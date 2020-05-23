# $NetBSD: Makefile,v 1.28 2020/05/22 10:56:19 adam Exp $
#

DISTNAME=		mailfront-2.22
PKGREVISION=		4
CATEGORIES=		mail
MASTER_SITES=		${HOMEPAGE}archive/

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://untroubled.org/mailfront/?a=b&c=d
COMMENT=		Mail server network protocol front-ends
LICENSE=		gnu-gpl-v2

DEPENDS+=		daemontools-[0-9]*:../../sysutils/daemontools
DEPENDS+=		qmail>=1.03nb8:../../mail/qmail

DJB_RESTRICTED=		NO
DJB_ERRNO_HACK=		no
DJB_MAKE_TARGETS=	NO
BUILD_TARGET=		all
DJB_CONFIG_CMDS+=	${ECHO} ${PREFIX}/include > conf-include;	\
			${ECHO} ${PREFIX}/lib/${PKGBASE} > conf-modules;

FILES_SUBST+=		QMAIL_DAEMON_USER=${QMAIL_DAEMON_USER:Q}
FILES_SUBST+=		QMAIL_LOG_USER=${QMAIL_LOG_USER:Q}
RCD_SCRIPTS=		smtpfront
INSTALLATION_DIRS=	share/doc/mailfront
INSTALL_ENV+=		install_prefix=${DESTDIR:Q}

BUILD_DEFS+=		QMAIL_DAEMON_USER QMAIL_LOG_USER

USE_LIBTOOL=		yes

MAKE_JOBS_SAFE=		no # due to hacky libtoolization

PKG_SYSCONFSUBDIR=	qmail

post-install:
	cd ${WRKSRC};							\
	for f in ANNOUNCEMENT NEWS README *.html; do			\
		${INSTALL_DATA} $${f} 					\
			${DESTDIR}${PREFIX}/share/doc/mailfront;	\
	done

BUILDLINK_API_DEPENDS.bglibs+=	bglibs>=2.01
.include "../../devel/bglibs/buildlink3.mk"
BUILDLINK_API_DEPENDS.cvm+=	cvm>=0.97
.include "../../security/cvm/buildlink3.mk"
.include "../../mk/djbware.mk"
.include "../../mk/bsd.pkg.mk"

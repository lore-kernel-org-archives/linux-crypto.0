From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 0/2] crypto: caam - performance fixes/improvements
Date: Tue, 12 Jan 2016 17:14:08 +0200
Message-ID: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alex Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:14559
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965021AbcALP2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2016 10:28:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following patches increase/fix CAAM performance by modifying
the configuration of MCFGR (Master Configuration Register):
-1st patch fixes a ~ 5% performance drop on PPC platforms
-2nd patch improves performance in some use cases, since CAAM DMA
transfers are optimized


Note: AWCACHE[0] (AXI3 "bufferable") and AWCACHE[1] (AXI3 "cacheable")
are set irrespective of platform, since:
-for ARM-based SoCs: the interconnect IP ignores AWCACHE[0]
-for PPC-based SoCs: PAMU handles coherency control, not AWCACHE[1]

Horia Geant=C4=83 (2):
  crypto: caam - make write transactions bufferable on PPC platforms
  crypto: caam - enable LARGE_BURST for enhancing DMA transactions size

 drivers/crypto/caam/ctrl.c | 4 ++--
 drivers/crypto/caam/regs.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--=20
2.4.4

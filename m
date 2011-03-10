From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 0/3] crypto: add support for the Freescale SEC4/CAAM
Date: Wed, 9 Mar 2011 18:54:31 -0600
Message-ID: <20110309185431.e73a3c2c.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steve Cornelius <sec@pobox.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<devicetree-discuss@lists.ozlabs.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:51995
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab1CJAym (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Mar 2011 19:54:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

splitting and resending due to apparent 100KB message limit imposed by
linux-crypto and devicetree-discuss mailing lists.

No content has been changed from the original post that made it through
linuxppc-dev's 400KB limit, available here:

http://patchwork.ozlabs.org/patch/86051/

 .../devicetree/bindings/crypto/fsl-sec4.txt        |  409 +++++
 arch/powerpc/boot/dts/p4080ds.dts                  |   95 ++-
 drivers/crypto/Kconfig                             |    2 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/caam/Kconfig                        |   72 +
 drivers/crypto/caam/Makefile                       |    8 +
 drivers/crypto/caam/caamalg.c                      | 1163 ++++++++++++++
 drivers/crypto/caam/compat.h                       |   35 +
 drivers/crypto/caam/ctrl.c                         |  270 ++++
 drivers/crypto/caam/desc.h                         | 1605 ++++++++++++++++++++
 drivers/crypto/caam/desc_constr.h                  |  204 +++
 drivers/crypto/caam/error.c                        |  248 +++
 drivers/crypto/caam/error.h                        |   10 +
 drivers/crypto/caam/intern.h                       |  113 ++
 drivers/crypto/caam/jr.c                           |  523 +++++++
 drivers/crypto/caam/jr.h                           |   21 +
 drivers/crypto/caam/regs.h                         |  663 ++++++++
 17 files changed, 5441 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/fsl-sec4.txt
 create mode 100644 drivers/crypto/caam/Kconfig
 create mode 100644 drivers/crypto/caam/Makefile
 create mode 100644 drivers/crypto/caam/caamalg.c
 create mode 100644 drivers/crypto/caam/compat.h
 create mode 100644 drivers/crypto/caam/ctrl.c
 create mode 100644 drivers/crypto/caam/desc.h
 create mode 100644 drivers/crypto/caam/desc_constr.h
 create mode 100644 drivers/crypto/caam/error.c
 create mode 100644 drivers/crypto/caam/error.h
 create mode 100644 drivers/crypto/caam/intern.h
 create mode 100644 drivers/crypto/caam/jr.c
 create mode 100644 drivers/crypto/caam/jr.h
 create mode 100644 drivers/crypto/caam/regs.h

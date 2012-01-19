From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix gcc 4.6 warning
Date: Wed, 18 Jan 2012 18:34:34 -0600
Message-ID: <20120118183434.16fc1a747ab6c79ee68076a2@freescale.com>
References: <20120109102740.82e4ac0f8425930b6a34ac1c@freescale.com>
	<20120113053918.GG13918@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:46437
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766Ab2ASAgT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 19:36:19 -0500
In-Reply-To: <20120113053918.GG13918@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 13 Jan 2012 16:39:18 +1100
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Jan 09, 2012 at 10:27:40AM -0600, Kim Phillips wrote:
> > drivers/crypto/caam/ctrl.c: In function 'caam_probe':
> > drivers/crypto/caam/ctrl.c:49:6: warning: unused variable 'd' [-Wunused-variable]
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> 
> Both patches applied.

Hi Herbert, I see you've applied:

e863f9c crypto: caam - add sha224 and sha384 variants to existing AEAD algorithm
0113529 crypto: caam - be less noisy on startup

to the cryptodev tree, but not the one at the start of this thread,
which needs to go into your crypto tree (it's a fix for v3.3).  I'm
resending it below in case it was lost.

Thanks,

Kim

>From 3b85bc6b93ff561d9d9f85b455734eb26487e875 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Tue, 20 Dec 2011 18:24:30 -0600
Subject: [PATCH] crypto: caam - fix gcc 4.6 warning

drivers/crypto/caam/ctrl.c: In function 'caam_probe':
drivers/crypto/caam/ctrl.c:49:6: warning: unused variable 'd' [-Wunused-variable]

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8ae3ba2..c5f61c5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -46,7 +46,7 @@ static int caam_remove(struct platform_device *pdev)
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int d, ring, rspec;
+	int ring, rspec;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
-- 
1.7.8.3

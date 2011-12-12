From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag.
Date: Mon, 12 Dec 2011 14:43:09 -0600
Message-ID: <20111212144309.5c1db15ae58ad5167cddb6ec@freescale.com>
References: <4EE4A172.9010308@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:17557
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab1LLUo3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 15:44:29 -0500
In-Reply-To: <4EE4A172.9010308@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 11 Dec 2011 13:26:26 +0100
Nikos Mavrogiannopoulos <nmav@gnutls.org> wrote:

> The added CRYPTO_ALG_KERN_DRIVER_ONLY flag indicates whether a cipher
> is only available via a kernel driver. If the cipher implementation
> might be available by using an instruction set or by porting the
> kernel code, then it must not be set.
> 
> Signed-off-by: Nikos Mavrogiannopoulos <nmav@gnutls.org>
> ---
>  drivers/crypto/geode-aes.c        |    8 ++++--
>  drivers/crypto/hifn_795x.c        |    3 +-
>  drivers/crypto/ixp4xx_crypto.c    |    2 +
>  drivers/crypto/mv_cesa.c          |   12 ++++++---
>  drivers/crypto/n2_core.c          |    7 ++++-
>  drivers/crypto/omap-aes.c         |    8 ++++-
>  drivers/crypto/omap-sham.c        |    4 +++
>  drivers/crypto/picoxcell_crypto.c |   46 +++++++++++++++++++++++++++--------
>  drivers/crypto/s5p-sss.c          |    6 +++-
>  drivers/crypto/talitos.c          |   48 ++++++++++++++++++++++++++----------
>  include/linux/crypto.h            |    5 ++++
>  11 files changed, 110 insertions(+), 39 deletions(-)

This appears to be based on an older version of the current master
of Herbert's cryptodev tree on github [1] - it's missing the hmac
algorithms introduced in commit 79b3a41 "crypto: talitos - add hmac
algorithms", and a caam entry is missing (it's an offload engine,
just like talitos). Something like:

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index e73cf2e..e9acadb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2205,7 +2205,8 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 	alg->cra_blocksize = template->blocksize;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct caam_ctx);
-	alg->cra_flags = CRYPTO_ALG_ASYNC | template->type;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+			 template->type;
 	switch (template->type) {
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg->cra_type = &crypto_ablkcipher_type;
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 2d8c789..dc641c7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2648,6 +2648,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	alg->cra_priority = TALITOS_CRA_PRIORITY;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
+	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	t_alg->dev = dev;
 
should be fine for both talitos and caam drivers.

Thanks,

Kim

[1] git://github.com/herbertx/cryptodev.git

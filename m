From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 08/10] crypto: omap-aes: gmc: Add algo info
Date: Thu, 02 Jul 2015 10:00:52 +0200
Message-ID: <1996807.vhgJsDVnGm@tauon.atsec.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-9-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435814320-30347-9-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 2. Juli 2015, 10:48:38 schrieb Lokesh Vutla:

Hi Lokesh,

>Now the driver supports gcm mode, add omap-aes-gcm
>algo info to omap-aes driver.
>
>Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>---
> drivers/crypto/omap-aes.c |   22 ++++++++++++++++++++++
> 1 file changed, 22 insertions(+)
>
>diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>index e5e9a19..11f3850 100644
>--- a/drivers/crypto/omap-aes.c
>+++ b/drivers/crypto/omap-aes.c
>@@ -789,6 +789,28 @@ static struct crypto_alg algs_ctr[] = {
> 		.decrypt	= omap_aes_ctr_decrypt,
> 	}
> },
>+{
>+	.cra_name		= "gcm(aes)",
>+	.cra_driver_name	= "gcm-aes-omap",
>+	.cra_priority		= 100,

Why did you choose the priority 100? The software implementations commonly use 
100. crypto/gcm.c uses the prio of the underlying cipher. In case of ARM, 
there seem to be assembler implementations of AES which have the prio of 200 
or 300. So, such software implementation of gcm(aes) would have a higher 
precedence than your hw implementation.

So, if a user would use gcm(aes), isn't it more likely that he gets the 
software implementation?

>+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC |
>+				  CRYPTO_ALG_KERN_DRIVER_ONLY,
>+	.cra_blocksize		= AES_BLOCK_SIZE,
>+	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
>+	.cra_alignmask		= 0xf,
>+	.cra_type		= &crypto_aead_type,
>+	.cra_module		= THIS_MODULE,
>+	.cra_init		= omap_aes_gcm_cra_init,
>+	.cra_exit		= omap_aes_cra_exit,
>+	.cra_u.aead = {
>+		.maxauthsize	= AES_BLOCK_SIZE,
>+		.geniv		= "eseqiv",
>+		.ivsize		= AES_BLOCK_SIZE,
>+		.setkey		= omap_aes_gcm_setkey,
>+		.encrypt	= omap_aes_gcm_encrypt,
>+		.decrypt	= omap_aes_gcm_decrypt,
>+	}
>+},
> };
>
> static struct omap_aes_algs_info omap_aes_algs_info_ecb_cbc[] = {


Ciao
Stephan

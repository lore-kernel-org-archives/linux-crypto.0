From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 01/10] crypto: testmgr - avoid DMA mapping from text,
 rodata, stack
Date: Tue, 22 Jul 2014 17:37:10 -0500
Message-ID: <20140722173710.d9956cf5b8a9757eab955b9e@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
	<1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:34275
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933141AbaGVWmU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jul 2014 18:42:20 -0400
In-Reply-To: <1405082095-30146-2-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 11 Jul 2014 15:34:46 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

> +++ b/crypto/testmgr.c
> @@ -198,13 +198,20 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
>  	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
>  	unsigned int i, j, k, temp;
>  	struct scatterlist sg[8];
> -	char result[64];
> +	char *result = NULL;
> +	char *key = NULL;

these needn't be initialized, here and elsewhere.

>  	struct ahash_request *req;
>  	struct tcrypt_result tresult;
>  	void *hash_buff;
>  	char *xbuf[XBUFSIZE];
>  	int ret = -ENOMEM;
>  
> +	result = kmalloc(64, GFP_KERNEL);

s/64/MAX_DIGEST_SIZE

> +++ b/crypto/testmgr.h
> @@ -32,7 +32,7 @@
>  #define MAX_DIGEST_SIZE		64
>  #define MAX_TAP			8
>  
> -#define MAX_KEYLEN		56
> +#define MAX_KEYLEN		160
>  #define MAX_IVLEN		32

this change could use a blurb in the commit message.

Other than that, this series gets my:

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks!

Kim

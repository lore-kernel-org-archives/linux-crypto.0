From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 21:21:37 +0800
Message-ID: <20150615132137.GA2367@gondor.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
 <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
 <557EC610.9070309@freescale.com>
 <20150615125951.GA1902@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54310 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbFONVl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 09:21:41 -0400
Content-Disposition: inline
In-Reply-To: <20150615125951.GA1902@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 08:59:51PM +0800, Herbert Xu wrote:
>
> > alg: aead: Test 2 failed on encryption for gcm-aes-caam
> > 00000000: ab 6e 47 d4 2c ec 13 bd f5 3a 67 b2 12 57 bd df
> > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> But this one seems obvious.  When assoclen is zero I failed to
> set VARSEQOUTLEN correctly for the cipher.

Please try this patch on top of it for the generic gcm failure.

Thanks!

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 95e8545..ca8948e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -777,7 +777,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
 	/* if assoclen + cryptlen is ZERO, skip to ICV write */
-	append_math_sub(desc, NONE, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
 						 JUMP_COND_MATH_Z);
 

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

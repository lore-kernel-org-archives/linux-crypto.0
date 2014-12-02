From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 01/17] crypto: ansi_cprng - Rename rand_data_valid more sensibly
Date: Tue, 02 Dec 2014 09:41:16 +0100
Message-ID: <1707797.LWZf6k9llc@tauon>
References: <20141202083441.17772.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, nhorman@tuxdriver.com,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54860 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaLBIl1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:41:27 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SA2F6> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 2 Dec 2014 09:41:17 +0100
In-Reply-To: <20141202083441.17772.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 2. Dezember 2014, 03:34:41 schrieb George Spelvin:

Hi George,

>It's more like rand_data_invalid (data which has already been output),
>so it's a pretty bad misnomer.  But rand_data_pos is even better.
>
>Signed-off-by: George Spelvin <linux@horizon.com>
>---
> crypto/ansi_cprng.c | 25 +++++++++++--------------
> 1 file changed, 11 insertions(+), 14 deletions(-)
>
>diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
>index 97fe3110..c9e1684b 100644
>--- a/crypto/ansi_cprng.c
>+++ b/crypto/ansi_cprng.c
>@@ -50,7 +50,7 @@ struct prng_context {
> 	unsigned char DT[DEFAULT_BLK_SZ];
> 	unsigned char I[DEFAULT_BLK_SZ];
> 	unsigned char V[DEFAULT_BLK_SZ];
>-	u32 rand_data_valid;
>+	u32 rand_read_pos;	/* Offset into rand_data[] */
> 	struct crypto_cipher *tfm;
> 	u32 flags;
> };
>@@ -174,7 +174,7 @@ static int _get_more_prng_bytes(struct prng_context
>*ctx, int cont_test) }
>
> 	dbgprint("Returning new block for context %p\n", ctx);
>-	ctx->rand_data_valid = 0;
>+	ctx->rand_read_pos = 0;
>
> 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
> 	hexdump("Output I: ", ctx->I, DEFAULT_BLK_SZ);
>@@ -217,7 +217,7 @@ static int get_prng_bytes(char *buf, size_t nbytes,
>struct prng_context *ctx,
>
>
> remainder:
>-	if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
>+	if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
> 		if (_get_more_prng_bytes(ctx, do_cont_test) < 0) {
> 			memset(buf, 0, nbytes);
> 			err = -EINVAL;
>@@ -230,12 +230,9 @@ remainder:
> 	 */
> 	if (byte_count < DEFAULT_BLK_SZ) {
> empty_rbuf:
>-		while (ctx->rand_data_valid < DEFAULT_BLK_SZ) {
>-			*ptr = ctx->rand_data[ctx->rand_data_valid];
>-			ptr++;
>-			byte_count--;
>-			ctx->rand_data_valid++;
>-			if (byte_count == 0)
>+		while (ctx->rand_read_pos < DEFAULT_BLK_SZ) {
>+			*ptr++ = ctx->rand_data[ctx->rand_read_pos++];
>+			if (--byte_count == 0)
> 				goto done;

I am against such collapsing of constructs into one-liners. It is not 
obvious at first sight, which value gets incremented in what order. Such 
collapsing was the cause for CVE-2013-4345 as it caused an off-by one.

> 		}
> 	}
>@@ -244,17 +241,17 @@ empty_rbuf:
> 	 * Now copy whole blocks
> 	 */
> 	for (; byte_count >= DEFAULT_BLK_SZ; byte_count -= 
DEFAULT_BLK_SZ) {
>-		if (ctx->rand_data_valid == DEFAULT_BLK_SZ) {
>+		if (ctx->rand_read_pos == DEFAULT_BLK_SZ) {
> 			if (_get_more_prng_bytes(ctx, do_cont_test) < 0) 
{
> 				memset(buf, 0, nbytes);
> 				err = -EINVAL;
> 				goto done;
> 			}
> 		}
>-		if (ctx->rand_data_valid > 0)
>+		if (ctx->rand_read_pos > 0)
> 			goto empty_rbuf;
> 		memcpy(ptr, ctx->rand_data, DEFAULT_BLK_SZ);
>-		ctx->rand_data_valid += DEFAULT_BLK_SZ;
>+		ctx->rand_read_pos += DEFAULT_BLK_SZ;
> 		ptr += DEFAULT_BLK_SZ;
> 	}
>
>@@ -304,7 +301,7 @@ static int reset_prng_context(struct prng_context
>*ctx, memset(ctx->rand_data, 0, DEFAULT_BLK_SZ);
> 	memset(ctx->last_rand_data, 0, DEFAULT_BLK_SZ);
>
>-	ctx->rand_data_valid = DEFAULT_BLK_SZ;
>+	ctx->rand_read_pos = DEFAULT_BLK_SZ;	/* Force immediate 
refill */
>
> 	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
> 	if (ret) {
>@@ -413,7 +410,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm,
>u8 *seed, unsigned int slen)
>
> 	/* this primes our continuity test */
> 	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
>-	prng->rand_data_valid = DEFAULT_BLK_SZ;
>+	prng->rand_read_pos = DEFAULT_BLK_SZ;
>
> out:
> 	return rc;


Ciao
Stephan

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4D8C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 19:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbiDRT2A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243986AbiDRT17 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 15:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A4313F78
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 12:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0715B81087
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 19:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3A8C385A7;
        Mon, 18 Apr 2022 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650309915;
        bh=o6iVkFHcSfJOiTVdyReysKo15hofwoteSZoJNDuK3ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K2GnLYyyWnPh5ZQmFUavbjRjNhqSRDEtuIyk7UJ0a/mkqEgzjIXv7p+5IRwryzefH
         D2w0dd+yjod2znUKU7SO3ysB0j5+wLH7dIUUsP+aKU20e8CRTbZW4f2dUSFaRhwKw5
         K3LybEf7hivxkA0gslolkzwEohc66hqXccZR6FhE6SmhTN3+i45aubVMhGzb0Mq/ts
         DV4d6tGBVH8ccZUAwJKAiIvk7jLAw7yqQPQE4CrZscy/7pndM4IJWzJ/1ITlfRzgdg
         fLLdIDHq08Q6pBLMxh6DcYD421qqO4HFL9gsahH87hjhWWFTFtZO/Pukb1Zp0TJrRL
         jjx7z22ukQQbg==
Date:   Mon, 18 Apr 2022 12:25:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 2/8] crypto: polyval - Add POLYVAL support
Message-ID: <Yl27GSvaCP6CDUmy@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-3-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A couple more nits:

On Tue, Apr 12, 2022 at 05:28:10PM +0000, Nathan Huckleberry wrote:

> +static int polyval_init(struct shash_desc *desc)
[...]
> +static int polyval_setkey(struct crypto_shash *tfm,

As I mentioned on the x86 patch, setkey() is the first step, before init().
People sometimes mix this up, e.g. see https://git.kernel.org/linus/f3aefb6a7066e24b.
Putting the definitions in their natural order might be helpful:

	1. polyval_setkey()
	2. polyval_init()
	3. polyval_update()
	4. polyval_final()

> +static void reverse_block(u8 block[POLYVAL_BLOCK_SIZE])
> +{
> +	u64 *p1 = (u64 *)block;
> +	u64 *p2 = (u64 *)&block[8];
> +	u64 a = get_unaligned(p1);
> +	u64 b = get_unaligned(p2);
> +
> +	put_unaligned(swab64(a), p2);
> +	put_unaligned(swab64(b), p1);
> +}

This is always paired with a memcpy() of the block, so consider making this
helper function handle the copy too.  E.g.

diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
index 1399af125b937..b50db5dd51fd1 100644
--- a/crypto/polyval-generic.c
+++ b/crypto/polyval-generic.c
@@ -75,15 +75,14 @@ static int polyval_init(struct shash_desc *desc)
 	return 0;
 }
 
-static void reverse_block(u8 block[POLYVAL_BLOCK_SIZE])
+static void copy_and_reverse(u8 dst[POLYVAL_BLOCK_SIZE],
+			     const u8 src[POLYVAL_BLOCK_SIZE])
 {
-	u64 *p1 = (u64 *)block;
-	u64 *p2 = (u64 *)&block[8];
-	u64 a = get_unaligned(p1);
-	u64 b = get_unaligned(p2);
+	u64 a = get_unaligned((const u64 *)&src[0]);
+	u64 b = get_unaligned((const u64 *)&src[8]);
 
-	put_unaligned(swab64(a), p2);
-	put_unaligned(swab64(b), p1);
+	put_unaligned(swab64(a), (u64 *)&dst[8]);
+	put_unaligned(swab64(b), (u64 *)&dst[0]);
 }
 
 static int polyval_setkey(struct crypto_shash *tfm,
@@ -98,10 +97,7 @@ static int polyval_setkey(struct crypto_shash *tfm,
 	gf128mul_free_4k(ctx->gf128);
 
 	BUILD_BUG_ON(sizeof(k) != POLYVAL_BLOCK_SIZE);
-	// avoid violating alignment rules
-	memcpy(&k, key, POLYVAL_BLOCK_SIZE);
-
-	reverse_block((u8 *)&k);
+	copy_and_reverse((u8 *)&k, key);
 	gf128mul_x_lle(&k, &k);
 
 	ctx->gf128 = gf128mul_init_4k_lle(&k);
@@ -137,8 +133,7 @@ static int polyval_update(struct shash_desc *desc,
 	}
 
 	while (srclen >= POLYVAL_BLOCK_SIZE) {
-		memcpy(tmp, src, POLYVAL_BLOCK_SIZE);
-		reverse_block(tmp);
+		copy_and_reverse(tmp, src);
 		crypto_xor(dctx->buffer, tmp, POLYVAL_BLOCK_SIZE);
 		gf128mul_4k_lle(&dctx->buffer128, ctx->gf128);
 		src += POLYVAL_BLOCK_SIZE;
@@ -162,11 +157,7 @@ static int polyval_final(struct shash_desc *desc, u8 *dst)
 
 	if (dctx->bytes)
 		gf128mul_4k_lle(&dctx->buffer128, ctx->gf128);
-	dctx->bytes = 0;
-
-	reverse_block(dctx->buffer);
-	memcpy(dst, dctx->buffer, POLYVAL_BLOCK_SIZE);
-
+	copy_and_reverse(dst, dctx->buffer);
 	return 0;
 }

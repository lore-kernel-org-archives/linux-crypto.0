Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA87C31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 17:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED35208CB
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560792018;
	bh=6deeDpyaXOI01fNb+oVFs6vLcv98dqXp2Sct02Xm+C4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mfQip/Kn498uUueh+F3AUdc3o21d8mA2CFYrOkMxgsX0NJfh7jU6AlOX14wLxHW8L
	 zCwYB7bBHDzx9WLpAFyRvIXUZcOvT7i0QRq2ihL5YiizK1ioJTxVtMQtyx7vDAOwHg
	 uHfbzCzo5MrDyKcnNQQR+g7qMe7+Eh9sVU2Zqoxg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFQRUQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQRUQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 13:20:16 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B0AD208C0;
        Mon, 17 Jun 2019 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560792015;
        bh=6deeDpyaXOI01fNb+oVFs6vLcv98dqXp2Sct02Xm+C4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHlc/STIdf7nFcb1HMpHP6yU7WDmKK3QoYe2s8H1IbeGwKB0rJ1WjbYJRT48QXB24
         pB3Aq1RvY7/eNbBLnGArcxtzyGGya+1H/1ZlJe5XE7WsCOhzQmjpEq8cx6uLYe8on5
         0cI0lsVeVjI3R4GDBBa7QoEmAQvYpCWOOdmt0+vY=
Date:   Mon, 17 Jun 2019 10:20:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
Message-ID: <20190617172008.GA92263@gmail.com>
References: <20190617132343.2678836-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617132343.2678836-1-arnd@arndb.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 03:23:02PM +0200, Arnd Bergmann wrote:
> On arm32, we get warnings about high stack usage in some of the functions:
> 
> crypto/testmgr.c:2269:12: error: stack frame size of 1032 bytes in function 'alg_test_aead' [-Werror,-Wframe-larger-than=]
> static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
>            ^
> crypto/testmgr.c:1693:12: error: stack frame size of 1312 bytes in function '__alg_test_hash' [-Werror,-Wframe-larger-than=]
> static int __alg_test_hash(const struct hash_testvec *vecs,
>            ^
> 
> On of the larger objects on the stack here is struct testvec_config, so
> change that to dynamic allocation.
> 
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I only compile-tested this, and it's not completely trivial, so please
> review carefully.
> ---
>  crypto/testmgr.c | 61 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 45 insertions(+), 16 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 6c28055d41ca..7928296cdcb3 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1503,13 +1503,15 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
>   * Generate a hash test vector from the given implementation.
>   * Assumes the buffers in 'vec' were already allocated.
>   */
> -static void generate_random_hash_testvec(struct crypto_shash *tfm,
> +static int generate_random_hash_testvec(struct crypto_shash *tfm,
>  					 struct hash_testvec *vec,
>  					 unsigned int maxkeysize,
>  					 unsigned int maxdatasize,
>  					 char *name, size_t max_namelen)
>  {
> -	SHASH_DESC_ON_STACK(desc, tfm);
> +	struct shash_desc *desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
> +	if (!desc)
> +		return -ENOMEM;
>  
>  	/* Data */
>  	vec->psize = generate_random_length(maxdatasize);
> @@ -1541,6 +1543,10 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
>  done:
>  	snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
>  		 vec->psize, vec->ksize);
> +
> +	kfree(desc);
> +
> +	return 0;
>  }

Instead of allocating the shash_desc here, can you allocate it in
test_hash_vs_generic_impl() and call it 'generic_desc'?  Then it would match
test_skcipher_vs_generic_impl() and test_aead_vs_generic_impl() which already
dynamically allocate their skcipher_request and aead_request, respectively.

>  
>  /*
> @@ -1565,7 +1571,7 @@ static int test_hash_vs_generic_impl(const char *driver,
>  	unsigned int i;
>  	struct hash_testvec vec = { 0 };
>  	char vec_name[64];
> -	struct testvec_config cfg;
> +	struct testvec_config *cfg;
>  	char cfgname[TESTVEC_CONFIG_NAMELEN];
>  	int err;
>  

Otherwise I guess this patch is fine for now, though there's still a lot of
stuff with nontrivial size on the stack (cfgname, vec_name, _generic_driver,
hash_testvec, plus the stuff in test_hash_vec_cfg).  There's also still a
testvec_config on the stack in test_{hash,skcipher,aead}_vec(); I assume you
didn't see a warning there only because it wasn't in combination with as much
other stuff on the stack.

I should probably have a go at refactoring this code to pack up most of this
stuff in *_params structures, which would then be dynamically allocated much
more easily.

- Eric

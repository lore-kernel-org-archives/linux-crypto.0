Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D45CA9EA0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E492214B2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571799927;
	bh=kkPkkVa8tSmBZrfUNuUqMVi0gdFyhC6khfCoDcn6A64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=M/PE/a4lwbOOZcL1cjV1i1Xm0DdtXttjKAlfCywNIGWibqSYrmeVnHaF9h1rdFbAE
	 dcqhjVh0Y1eii/1rdXEcQ66Xyk38fNx6nig0TnHcjJ8k4uN4KZeyHKVd7ICl7MmMfc
	 lBRFTf7ZADNk1ER5U/e6XS00t4wBESqx5jiwFsQk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfJWDF0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbfJWDF0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 23:05:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31BAF207FC;
        Wed, 23 Oct 2019 03:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571799925;
        bh=kkPkkVa8tSmBZrfUNuUqMVi0gdFyhC6khfCoDcn6A64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NGN+gKXch8HLob+NK8jg6R8JAt33cFKmddi/0mtNi5vBTxtl133qBxUaoHtztsaSi
         OOqvD/5K3Z/PSyYH7ac0y7ka20btM2nmV1IywyNBrWt8+rXJ+jpRW/p8vBlhMUjggW
         e76WrsCTM8xSyDlFlMTjq7PgW72v5YWTR8LBs+ek=
Date:   Tue, 22 Oct 2019 20:05:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 02/35] crypto: chacha - move existing library code
 into lib/crypto
Message-ID: <20191023030523.GB4278@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:08:59PM +0200, Ard Biesheuvel wrote:
> +static inline void chacha_crypt(u32 *state, u8 *dst, const u8 *src,
> +				unsigned int bytes, int nrounds)
> +{
> +	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
> +		chacha_crypt_arch(state, dst, src, bytes, nrounds);
> +	else
> +		chacha_crypt_generic(state, dst, src, bytes, nrounds);
> +}

How about also providing chacha20_crypt() which calls chacha_crypt(..., 20)?
The 'nrounds' parameter is really for implementations, rather than users of the
library API.  Users don't really have any business specifying the number of
rounds as an int.

> +static inline int chacha_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +				unsigned int keysize, int nrounds)
> +{
> +	struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	int i;
> +
> +	if (keysize != CHACHA_KEY_SIZE)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
> +		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
> +
> +	ctx->nrounds = nrounds;
> +	return 0;
> +}

At the end of this patch series there are 5 drivers which wrap chacha_setkey()
with chacha20_setkey() and chacha12_setkey() -- all 5 pairs identical.  How
about providing those as inline functions here?

> +config CRYPTO_LIB_CHACHA
> +	tristate "ChaCha library interface"
> +	depends on CRYPTO_ARCH_HAVE_LIB_CHACHA || !CRYPTO_ARCH_HAVE_LIB_CHACHA
> +	select CRYPTO_LIB_CHACHA_GENERIC if CRYPTO_ARCH_HAVE_LIB_CHACHA=n
> +	help
> +	  Enable the ChaCha library interface. This interface may be fulfilled
> +	  by either the generic implementation or an arch-specific one, if one
> +	  is available and enabled.

Since this is a library for use within the kernel, and not a user-visible
feature, I don't think it should be explicitly selectable.  I.e. it should just
be "tristate", without the prompt string.

- Eric

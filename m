Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87226C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 21:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbiAKVoF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbiAKVoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 16:44:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDC8C06173F
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 13:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A564617AF
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 21:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EFDC36AE3;
        Tue, 11 Jan 2022 21:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937440;
        bh=T4c2OoSAdRrkTt8fLZY/k1miG6vyy4R0XrZSy0eZWl0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXrU0w6eJTyVmXl817zj6o2nqMvH35CAdF71P/3jKtHlZkpn9NhEXigzoc8j8WUCK
         EnpMD9q94/pAdVKcpWUE+DfK/u+v5wFCYZlY+NhKvaFJTOLBuxQeDLNeCes74axH+a
         qORV8dubtByJyp1vtXo89mCr5GgjyWACXemDf9Y5XGmj/j1nLWNm51XJ2/j0VX7lMY
         HaW8juRiNCTos6hiB3DnUzVVCmu/CRJrxoBsGNuZDBnchMCajdqk7z7FqEaqvlGTJf
         MxmVZ7408oQl4X9+EeallPVG4qzcp+enL5YIp17wck4jQuhMsjtPcueL3Xqj8Ke21T
         3/gI/nwdXnf4w==
Date:   Tue, 11 Jan 2022 13:43:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: testmgr - Move crypto_simd_disabled_for_test out
Message-ID: <Yd36HsgI+ya6P7RF@gmail.com>
References: <Yd0jA4VOjysrdOu7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd0jA4VOjysrdOu7@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 05:26:11PM +1100, Herbert Xu wrote:
> As testmgr is part of cryptomgr which was designed to be unloadable
> as a module, it shouldn't export any symbols for other crypto
> modules to use as that would prevent it from being unloaded.  All
> its functionality is meant to be accessed through notifiers.
> 
> The symbol crypto_simd_disabled_for_test was added to testmgr
> which caused it to be pinned as a module if its users were also
> loaded.  This patch moves it out of testmgr and into crypto/simd.c
> so cryptomgr can again be unloaded and replaced on demand.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/simd.c b/crypto/simd.c
> index edaa479a1ec5..2027d747b746 100644
> --- a/crypto/simd.c
> +++ b/crypto/simd.c
> @@ -47,6 +47,11 @@ struct simd_skcipher_ctx {
>  	struct cryptd_skcipher *cryptd_tfm;
>  };
>  
> +#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
> +DEFINE_PER_CPU(bool, crypto_simd_disabled_for_test);
> +EXPORT_PER_CPU_SYMBOL_GPL(crypto_simd_disabled_for_test);
> +#endif
> +
>  static int simd_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>  				unsigned int key_len)
>  {

It doesn't look like all the users of crypto_simd_usable() select CRYPTO_SIMD.
So this will cause a build break in some configurations.

Maybe CRYPTO_MANAGER_EXTRA_TESTS should select CRYPTO_SIMD?

- Eric

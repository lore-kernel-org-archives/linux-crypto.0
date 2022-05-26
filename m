Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3F0C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 26 May 2022 08:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343722AbiEZI1T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 May 2022 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiEZI1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 May 2022 04:27:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC151E44;
        Thu, 26 May 2022 01:27:17 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nu8pG-0008xV-OZ; Thu, 26 May 2022 18:26:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 May 2022 16:26:35 +0800
Date:   Thu, 26 May 2022 16:26:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     gaochao <gaochao49@huawei.com>, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH -next] crypto: Fix build error when CRYPTO_BLAKE2S_X86=m
 && CRYPTO_ALGAPI2=m && CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
Message-ID: <Yo85u63lYHQJCIh6@gondor.apana.org.au>
References: <20220517033630.1182-1-gaochao49@huawei.com>
 <Yo8rUkE1/hxum6gt@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo8rUkE1/hxum6gt@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 26, 2022 at 12:25:06AM -0700, Eric Biggers wrote:
>
> How about just making CRYPTO_MANAGER_EXTRA_TESTS depend on CRYPTO_ALGAPI=y?

That breaks my setups with ALGAPI=m.

> Or alternatively, move the crypto_simd_disabled_for_test variable into a file in
> lib/crypto/.  But the other suggestion would be a bit simpler for now.

Yes please do that instead.  If we ever get some arch-independent
file for SIMD then we could move it over there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

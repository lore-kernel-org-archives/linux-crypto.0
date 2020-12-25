Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F9CC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Dec 2020 19:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00B922252
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Dec 2020 19:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgLYTUu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Dec 2020 14:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbgLYTUt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Dec 2020 14:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739D3221F2;
        Fri, 25 Dec 2020 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608924008;
        bh=x7HugvciPp6eNPDIlyvx1Z198aXmn2J5ADS+CB13jLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f1kENboFp3i2V3/OeXkz0GZRZ0y7cwv4wx4bGxPVF/3iBbJFD9wJrr50YWV1Q16xa
         +/j87ql6oWFOREhUjXIWxCQhriUIdUyU3uW1+pAc90zoWtFpYXuJubcBe1TOqF3JzS
         gt95t2fTBBQ+GcqB8JV3+g1kOe+coho0Io3Az0NAFKcE2z8dK2j/lc9M9Xg3RYLlpo
         CF4//1y9vOrrOwJ27cJ2DdjLxtJf1n3qmldNhWrxHtvKZhGHuliJlNTsNP/D4tFlmp
         Krhr+EuPSphE/Bhqf5l/gkis0xIsJIKPBtyk42wrhTJ1YY4SCDCSQXaInoYc+EqQ/n
         WnC+mfkYyzFZg==
Date:   Fri, 25 Dec 2020 11:20:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR glue helper
 code
Message-ID: <X+Y7Zg8vMZbxMJgK@sol.localdomain>
References: <20201223223841.11311-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223223841.11311-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 23, 2020 at 11:38:31PM +0100, Ard Biesheuvel wrote:
> After applying my performance fixes for AES-NI in XTS mode, the only
> remaining users of the x86 glue helper module are the niche algorithms
> camellia, cast6, serpent and twofish.
> 
> It is not clear from the history why all these different versions of these
> algorithms in XTS and CTR modes were added in the first place: the only
> in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> CTR modes don't seem to be widely used either.
> 
> Since the glue helper code relies heavily on indirect calls for small chunks
> of in/output, it needs some work to recover from the performance hit caused
> by the retpoline changes. However, it makes sense to only expend the effort
> for algorithms that are being used in the first place, and this does not
> seem to be the case for XTS and CTR.
> 
> CTR mode can simply be removed: it is not used in the kernel, and it is
> highly unlikely that it is being relied upon via algif_skcipher. And even
> if it was, the generic CTR mode driver can still provide the CTR transforms
> if necessary.
> 
> XTS mode may actually be in use by dm-crypt users, so we cannot simply drop
> this code entirely. However, as it turns out, the XTS template wrapped
> around the ECB mode skciphers perform roughly on par *, and so there is no
> need to retain all the complicated XTS helper logic. In the unlikely case
> that dm-crypt users are relying on xts(camellia) or xts(serpent) in the
> field, they should not be impacted by these changes at all.
> 
> As a follow-up, it makes sense to rework the ECB and CBC mode implementations
> to get rid of the indirect calls. Or perhaps we could drop [some of] these
> algorithms entirely ...
> 
> * tcrypt results for various XTS implementations below, captured on a
>   Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz
> 
> Cc: Megha Dey <megha.dey@intel.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Milan Broz <gmazyland@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> 
> Ard Biesheuvel (10):
>   crypto: x86/camellia - switch to XTS template
>   crypto: x86/cast6 - switch to XTS template
>   crypto: x86/serpent- switch to XTS template
>   crypto: x86/twofish - switch to XTS template
>   crypto: x86/glue-helper - drop XTS helper routines
>   crypto: x86/camellia - drop CTR mode implementation
>   crypto: x86/cast6 - drop CTR mode implementation
>   crypto: x86/serpent - drop CTR mode implementation
>   crypto: x86/twofish - drop CTR mode implementation
>   crypto: x86/glue-helper - drop CTR helper routines

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric

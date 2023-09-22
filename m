Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F204AE7D0C2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 03:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjIVDKj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 23:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDKj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 23:10:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D3C102
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 20:10:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B7CC433C8;
        Fri, 22 Sep 2023 03:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695352232;
        bh=PIaW8pwRk5aS2qNBtO7eK5Mrj5VdfA8PDu73RiKF6wA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jI7/qcOl4n/ZGN2TMG9hoA2TY40d1N4fqRAWpgHRiL1r51eaFDxIi/4LEwtv0ELr9
         H+24XPwdHhbKWGD3xGL3N1vNT91tWhkbHANLH/HB8Cjsy+vHM2wjuY2qJFdvrf/+mh
         mXXilD0ORqq9ENEXpwK2fV+1+5tCQ7j46wUODrTfk0bHfTNlpJ24Ec3g2v5JbOd895
         U/mUfmhkcCvP2UzDMBLsj614rlS4125ZzujmDqu2iLzvsbgaet4d2m+ypf7HhaPHFq
         MaSz2wQpGnLiVlykmxbHOMJt+prTswUs9TDVeu42WuBOX2rm4uK29g9QCaeR6DjR2L
         7iLUHklEHqNwA==
Date:   Thu, 21 Sep 2023 20:10:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <20230922031030.GB935@sol.localdomain>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 21, 2023 at 12:32:17PM +0800, Herbert Xu wrote:
> On Tue, Sep 19, 2023 at 11:25:51PM -0700, Eric Biggers wrote:
> >
> > Is lskcipher only for algorithms that can be computed incrementally?  That would
> > exclude the wide-block modes, and maybe others too.  And if so, what is the
> 
> You mean things like adiantum? 

Yes, wide-block modes such as Adiantum and HCTR2 require multiple passes over
the data.  As do SIV modes such as AES-GCM-SIV (though AES-GCM-SIV isn't yet
supported by the kernel, and it would be an "aead", not an "skcipher").

> We could add a flag for that so
> the skcipher wrapper linearises the input before calling lskcipher.

That makes sense, but I suppose this would mean adding code that allocates huge
scratch buffers, like what the infamous crypto/scompress.c does?  I hope that we
can ensure that these buffers are only allocated when they are actually needed.

> 
> > model for incremental computation?  Based on crypto_lskcipher_crypt_sg(), all
> > the state is assumed to be carried forward in the "IV".  Does that work for all
> > algorithms?  Note that shash has an arbitrary state struct (shash_desc) instead.
> 
> Is there any practical difference? You could always represent
> one as the other, no?
> 
> The only case where it would matter is if an algorithm had both
> an IV as well as additional state that should not be passed along
> as part of the IV, do you have anything in mind?

Well, IV is *initialization vector*: a value that the algorithm uses as input.
It shouldn't be overloaded to represent some internal intermediate state.  We
already made this mistake with the iv vs. iv_out thing, which only ever got
implemented by CBC and CTR, and people repeatedly get confused by.  So we know
it technically works for those two algorithms, but not anything else.

With ChaCha, for example, it makes more sense to use 16-word state matrix as the
intermediate state instead of the 4-word "IV".  (See chacha_crypt().)
Especially for XChaCha, so that the HChaCha step doesn't need to be repeated.

- Eric

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC67C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 18:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F63613C0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 18:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhEGS5O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 14:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhEGS5N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 14:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA3C613C0;
        Fri,  7 May 2021 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620413773;
        bh=l86gpragp24H58Ehi4smcNiwWwod2AAFVjXdHM3A3zU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FcTMEemz2dnHM+DuCJvV0g74Vli18ERy0GpOYgiSC6bEKQpUtJ0/NMpTMRu9PYRAZ
         3KJMiX0iHqDRk2pVXl1NvYQFuvVNDmCUy0DiRrvDuBFK+yQkucC1mZnBQSxVgLdYv0
         1BUMYti2NoF0NUELkO2AVRB939Sgq/IjJBYrKe6KkvDqm28er2CVOcfDydRpMAux0R
         PdX/a1IoFyF2mITqXmVY7+E6G2FINKcatm8m+NREA+AWtaYomBl0Y4OHmVsBOh2KaI
         L8IQlcijVIXQUK/yTVBeeu8CxpyOrxbEQgeUt7TKCcdb81SNplUGEO6+4Q162PMeMI
         hZecyHC6s0uZg==
Date:   Fri, 7 May 2021 11:56:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kestrel seventyfour <kestrelseventyfour@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: Fwd: xts.c and block size inkonsistency? cannot pass generic
 driver comparision tests
Message-ID: <YJWNSwrT4OP+tLXw@gmail.com>
References: <CAE9cyGRzwN8AMzdf=E+rBgrhkDxyV52h8t_cBWgiXscvX_2UtQ@mail.gmail.com>
 <YJTkf0F5IZhqiXI5@sol.localdomain>
 <CAE9cyGTi9YpC9pcu5-MXtmXu_DM5FEVt9DYrM4AQWQMK7f0=zA@mail.gmail.com>
 <CAE9cyGRCDP5dv1AJ_5LL5e9vJasuc1_AZFLjZnT-hwYE-CUUFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9cyGRCDP5dv1AJ_5LL5e9vJasuc1_AZFLjZnT-hwYE-CUUFQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 07, 2021 at 03:02:11PM +0200, Kestrel seventyfour wrote:
> Hi Eric,
> 
> I agree, that it can't be built on top of the kernels CBC. But in the
> hardware CBC, e.g. for encryption I set the IV (encrypted tweak), set
> the hardwares aes mode to CBC and start the encrypt of a 16 byte
> block, then do an additional xor after that -> result of that full
> block is the same as XTS. Then I gfmul the tweak and repeat the
> previous starting with setting the tweak as iv.
> Doing that is much faster and much more efficient than using the
> kernels xts on top of ecb(aes). But it introduces the problem that I
> have somehow to handle the CTS after my walk loop that just processes
> full blocks or multiples of that. And I am trying to figure out, what
> the best way is to do that with the least amount of code in my driver.
> I cannot set blocksize to 1, because then the block size comparison to
> generic xts fails and If I set the walksize to 1, I get the alignment
> and split errors and would have to handle the splits and
> missalignments manually.
> So actually I need a combination of what the walk does (handle
> alignment and splits) plus getting the last complete and incomplete
> block after walk_skcipher_done returns -EINVAL. At least thats my
> current idea. I could just copy most of the code from xts, but there
> is a lot of stuff, that is not needed, if I combine the hardware CBC
> and xor to be XEX (XTS without the cipher text stealing).
> 

Wouldn't it be easier to just implement ecb(aes) in your driver (using your
workaround to do it 1 block at a time using the hardware CBC engine)?  If you
implement ecb(aes), then the xts template can use it, so you wouldn't need to
implement xts(aes) directly.  And this would still avoid all the individual
calls to crypto_cipher_{encrypt,decrypt}, which I expect is the performance
bottleneck that you were seeing.

- Eric

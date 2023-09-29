Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4295E77347
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Sep 2023 22:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjI2Wnb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Sep 2023 18:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbjI2Wnb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2023 18:43:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5762D1A5
        for <linux-crypto@vger.kernel.org>; Fri, 29 Sep 2023 15:43:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C37C433C8;
        Fri, 29 Sep 2023 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696027408;
        bh=UYc7qcXwIPN8R+5u/B3YnekPh2cUVdEgNsXWyhg6OR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZrUibAlV4Q4kEEnJGVockzjSmIcXxeZnRM9kpZnb8BoZ65fYHiMcjlwm4IZ3XT2vQ
         NS8mwJIFDRyV2x2Ka8HjAgNuCnwkqqPnsScJpvG/sFTEmxrMe0IoYwSthX9WUqDTO3
         5rl1HC7ZLX9zttFLu7ZOtp2ETKHkO22Hk6hx6PjFDcT9GnY2A8l8yQnJw1DJy1PrDf
         t37Pu+oLy/urZEncbDdXysWWu/wrLDm9e5FhWLZAOF2Chz4Zbmxz+JTozbbkUQ0Apq
         /8bCzHnaHfzzueQm2UZCkejsfhGtoABQn/V8TO+0pS7Iloz51dOgRCoT4rw8lVmSRG
         n0EreCRz32Xkw==
Date:   Fri, 29 Sep 2023 22:43:27 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Yureka <yuka@yuka.dev>
Cc:     linux-crypto@vger.kernel.org, regressions@lists.linux.dev,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
Message-ID: <20230929224327.GA11839@google.com>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Yureka,

On Fri, Sep 29, 2023 at 11:08:55PM +0200, Yureka wrote:
> #regzbot introduced: 7bcb2c99f8ed
> 
> I am running the NixOS distribution cross-compiled from x86_64 to a Marvell
> Armada 388 armv7 SoC.
> 
> I am not getting expected speeds when reading/writing on my encrypted hard
> drive with 6.5.5, while it is fast on 5.4.257. Volume is formatted like this:
> `cryptsetup luksFormat -c aes-cbc-essiv:sha256 /dev/sda`.
> 
> Specifically, I tracked this down to the changes to crypto/essiv.c from
> 7bcb2c99f8ed mentioned above. Reverting those changes on top of a 6.5.5 kernel
> provides working (see applicable diff further below).
> 
> I'm *guessing* that this is related to the mv-aes-cbc crypto driver (from the
> marvell-cesa module) being registered as async (according to /proc/crypto),
> and I *suspect* that async drivers are not being used anymore by essiv or
> dm_crypt. Going by the commit description, which sounds more like a refactor,
> this does not seem intentional.

This is actually from commit b8aa7dc5c753 ("crypto: drivers - set the flag
CRYPTO_ALG_ALLOCATES_MEMORY"), which set CRYPTO_ALG_ALLOCATES_MEMORY in
marvell-cesa.  7bcb2c99f8ed is just one of the prerequisite commits.

I understand that the dm-crypt developers did this as an intentional bug fix in
order to prevent dm-crypt from using crypto drivers that are known to cause
deadlocks due to allocating memory during requests.

If you are interested in still being able to use marvell-cesa with dm-crypt, I
believe it would need to be fixed to meet the requirements for not needing
CRYPTO_ALG_ALLOCATES_MEMORY.  I've Cc'ed the maintainers of that driver.

#regzbot introduced: b8aa7dc5c753

- Eric

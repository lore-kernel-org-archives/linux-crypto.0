Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04C7C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 16:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BB4361177
	for <linux-crypto@archiver.kernel.org>; Tue,  4 May 2021 16:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhEDQxc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 May 2021 12:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhEDQxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 May 2021 12:53:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E04861139;
        Tue,  4 May 2021 16:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620147157;
        bh=/85iIZ3CVD30Lt/J6ODnC8CNiJB2kCPRILCSbK0AGcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cqY82zqwARokgfR4+6bspnGhFASk0hieJIlplVyNjPwuPieJx3vF65rQXfIgCyD0v
         KUy0slTiaOTswu1fLHelbivVstvLIvZ+BduqV+p0ukUR458r7Y8izanxNz3RB0QoMG
         20gP7AjakhQ7J1KT7eeqmRaoTFwJplocfDw0/+M6MApwfBoqBuhkiHIz0qt8+Sr2Do
         O/gBnKphi3tyMrpjCdERNhWYcgrHEDimO7YwyWGnPIXOGIEeL/1ptdT//zfFpGZbWp
         ROL6jrha958mYOtNSD1wZQLlQoNWXgNt5KEvpjJrq/yKdYct935Xutu9sb1ZPUGaH2
         RVCCcuBE/XRcg==
Date:   Tue, 4 May 2021 09:52:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kestrel seventyfour <kestrelseventyfour@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: cannot pass split cryptomgr tests for aes ctr
Message-ID: <YJF708LCG0l8WBaD@gmail.com>
References: <CAE9cyGSX4nwRrDbazih2FDp1_8e+wGTD17euyCJyitXWOignMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9cyGSX4nwRrDbazih2FDp1_8e+wGTD17euyCJyitXWOignMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 03, 2021 at 09:56:40AM +0200, Kestrel seventyfour wrote:
> Hi,
> 
> I am trying to update the old ifxdeu driver to pass the crypto mgr tests.
> However, I continously fail to pass the split tests and I wonder what to do.
> 
> For example, I successfully pass the test vector 0 here:
> https://elixir.bootlin.com/linux/latest/source/crypto/testmgr.h#L16654
> if there is no split.
> 
> But if the text "Single block msg" is split into two 8 byte blocks
> (single even aligned splits), which end up as separate skcipher walks
> in the driver, the second block is wrong and does not compare
> correctly, to what is hardcoded in testmgr.h. Same if I try it with
> online aes-ctr encoders in the web.
> I have tried doing the xor manually with the aes encoded iv, but I get
> the same result as the hardware and if I use the next last iv, I still
> do not get the second 8 bytes that are hardcoded in cryptomgr.h.
> 
> Can someone shed a light on it?
> Is it valid to compare a crypto result that was done on a single walk
> with 16byte with two separate walks on the 8 byte splits (of the
> original 16)? Is the cryptomgr test on the split tests expecting that
> I concat the two walks into a single one?
> If yes, how to do that on the uneven splits with separations like 15
> 16 5 byte sequences, etc., fill up the walk up to full block size and
> spill over into the next walk?
> 

The split test cases expect the same output (same sequence of bytes) as the
non-split test cases.  The only difference is how the data is split up into
scatterlist elements.  Yes, that means that a single 16-byte block of the
keystream may need to be XOR'ed with data from multiple scatterlist elements.
Take a look at how other drivers handle this.

- Eric

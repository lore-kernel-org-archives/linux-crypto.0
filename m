Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB73CC4363A
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 17:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C3720797
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603472407;
	bh=JbINGNb1wfDyaqjNDKC5RrjbUiFD1VruFriCCFRJSIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LW23iZybrL2Q6kIwBViJTz3fVeoDH6638QlylFeMn+2Fu1m3zAD4bsQE/H1q/Sd2R
	 4V1eHHz2cdafcSHPPwCPQej2y8UZejgo0T4xpqGZcU9jr8xbwauwD7Ht+PiNwLXstU
	 yjbofQaTK0InVfWKZSHXd6O8emu15H6zvgwxnMhM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750572AbgJWRAH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 13:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S465168AbgJWRAG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 13:00:06 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADEB9206BE;
        Fri, 23 Oct 2020 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603472406;
        bh=JbINGNb1wfDyaqjNDKC5RrjbUiFD1VruFriCCFRJSIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QfQdRr83Pwxc4s7oxCoXyNiSw+gc1EIlexY2GVX6Te+36OoIRWO2g1SqhbkmqLzWI
         2BOvtAKicV1yBmYKqjsav+bWQf94GI2EbZowoQRTCu0UZbVC3H/v/f5lxVYnUTZkAW
         gHhaMD4eyBx3v02/B84OCkMTSrDsPoAv7psWp64Y=
Date:   Fri, 23 Oct 2020 10:00:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Konrad Dybcio <konradybcio@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: Qualcomm Crypto Engine driver
Message-ID: <20201023170003.GC3908702@gmail.com>
References: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Konrad,

On Fri, Oct 23, 2020 at 01:55:13PM +0200, Konrad Dybcio wrote:
> Hi,
> 
> I was investigating Qualcomm Crypto Engine support on my sdm630
> smartphone and found out that the already-present driver is
> compatible. In meantime I found two issues:
> 
> 1. The driver doesn't seem to have a maintainer? drivers/crypto/qce
> doesn't seem to exist in the MAINTAINERS file..
> 
> 2. The person who first submitted it likely faced an issue with memory
> allocation. On downstream (taking sdm630 as example) Qualcomm decided
> to allocate 0x20000@1de0000 for the device and 0x24000@1dc4000 for
> BAM, which isn't something upstream driver agrees with (these memory
> regions overlap and the driver straight up doesn't probe..).
> I "fixed" it by giving (QCE register) - (DMA register) memory size to
> the DMA (which doesn't seem to cause any issues) and changing all the
> registers in the header file by 0x1A000 (just like it is downstream
> [1]), but the former person "fixed" it by offsetting the QCE node in
> qcom-ipq4019.dtsi by 0x1A000.
> 
> Which fix is more correct? I'd advocate for my one as the more
> accurate, but I can adapt to what's already been invented.. Test
> results ("cryptsetup benchmark")  don't differ between these two
> (though they are worse than without the QCE, which is most likely
> related to unimplemented bus bandwidth scaling).
> 
> 
> [1] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.7.1.r1/drivers/crypto/msm/qcryptohw_50.h
> 
> Konrad Dybcio

Out of curiosity, what use cases do you have in mind for drivers/crypto/qce/ on
SDM630?  I can't help you with that driver, but it may be worth mentioning that
that the SDM630 (and most other Snapdragon SoCs) also includes an Inline Crypto
Engine (ICE) as part of the eMMC host controller.  The "Inline Crypto Engine" is
very different from the regular "Crypto Engine" which drivers/crypto/qce/ is
for.  And in practice, ICE is what is used on Snapdragon-based Android devices
to accelerate the storage encryption; drivers/crypto/qce/ isn't used.

So if your goal is to run Android with an upstream kernel on SDM630, ICE support
would probably be more useful.  On the other hand, dm-crypt doesn't currently
support inline encryption, so if your goal is just to run other Linux distros,
ICE wouldn't be as useful (since outside Android, dm-crypt is more commonly used
than fscrypt, which is what Android uses).

FWIW, I'm interested in adding support for the eMMC interface to ICE, but I
haven't had hardware with upstream support to use.  (I was able to add upstream
support for the UFS interface to ICE, since there is a SDM845 development board
with upstream support, and upstream Linux now has a framework "blk-crypto" for
supporting inline encryption hardware.)  I see there's been recent upstreaming
work on SDM630 by yourself and others.  I haven't had much luck getting a Sony
Xperia 10 to boot with an upstream kernel, though -- and I've also tried some of
the branches at https://github.com/SoMainline/linux, including yours I think.
If you're able to give some tips to getting it working (probably off-list, since
it's a bit off-topic for linux-crypto) I'd appreciate it -- thanks!

- Eric

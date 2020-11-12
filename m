Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C3DC2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1F6216C4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfaaKBjf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgKLVUQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 16:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbgKLVUP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 16:20:15 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6FE207DE;
        Thu, 12 Nov 2020 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605216014;
        bh=ZrdSWeCv+VTEWbiteMfAvcDeEOsrjDrldbzblKITiec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qfaaKBjfc6ZRGN04CTNVHwbEGkw0Fa/DtCsJsKh8VVrEawy4LJrgE5c2GiCslkveb
         hc5wyC/xaNv1+sfkTh2aDKjDfN+PHwiU79Lo+03SLYRvQhT6pW+PCTJSo2Lq7/FVZZ
         vF67u09KktRBdPUX1Y7jthU2Apbtx43HqwwZ63+k=
Date:   Thu, 12 Nov 2020 13:20:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Konrad Dybcio <konradybcio@gmail.com>
Cc:     linux-crypto@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: Re: Qualcomm Crypto Engine driver
Message-ID: <X62nDWQNHy1pk+3t@sol.localdomain>
References: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
 <20201023170003.GC3908702@gmail.com>
 <CAMS8qEX766tggsR0DpJm8TVRwctwwvnRofiiDWhqsNDDK6exYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMS8qEX766tggsR0DpJm8TVRwctwwvnRofiiDWhqsNDDK6exYA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Konrad,

On Thu, Nov 12, 2020 at 09:26:30PM +0100, Konrad Dybcio wrote:
> Hi Eric,
> 
> First of all, I am EXTREMELY sorry for my long overdue response..
> 
> I just wanted to bring up that piece of HW so as to offload crypto
> tasks from the CPU, but it ended up being slower (which I suspect is
> due to bw scaling not being implemented, but I might be wrong, maybe
> A53+crypto is just superior..)

A while ago, I benchmarked the QCE on an older SoC, and it was much slower than
just using the ARMv8 crypto extensions.  So I'm not surprised.  I don't think
QCE is really used anymore.  But almost everyone uses ICE.

> The goal is to have the phone run Mainline Linux *at least* at
> functional parity with the BSP kernel. Both ICE and CE support are
> welcome.
> 
> Thanks for your interest and the patches you sent. There is more
> sdm630 (and not only, keep watching :D) work coming. I suppose you
> managed to boot your Xperia by now, but if you had issues, you should
> try out my v5.10-rc3 branch from the repo you linked with the supplied
> ninges_defconfig. Then you append the DTB to Image.gz and create an
> Android boot image (or put Image.gz+dtb into an existing one with
> abootimg -u boot.img -k Image.gz+dtb) and the phone should boot.
> 
> Thanks once again for your interest and apologies for the time it took..

I'm already using your v5.10-rc3 branch, but ninges_defconfig isn't working for
me.  (Though I couldn't find the firmware file "qcom/a530_zap.elf", so I had to
remove it from CONFIG_EXTRA_FIRMWARE.)  Instead I'm using a kconfig based on
https://github.com/SoMainline/linux/blob/marijn/android/arch/arm64/configs/defconfig
which is working for me.

I haven't been able to get a full Android userspace to work, and currently I'm
instead just replacing the kernel in a TWRP image and booting into recovery.
It's enough to get adb shell access and chroot into a Debian chroot on the
userdata partition, which is enough to run android-xfstests to test the ICE
support.  Earlier I tried AOSP using the instructions at
https://developer.sony.com/develop/open-devices/guides/aosp-build-instructions/build-aosp-android-android-11-0-0,
and also LineageOS using the instuctions at
https://wiki.lineageos.org/devices/kirin/build, but neither worked.  That was a
couple weeks ago though, so I haven't tried the very latest kernel with full
Android.  Let me know if you have any suggestions!

Thanks,

- Eric

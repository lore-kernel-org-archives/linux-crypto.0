Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 296B3C6379D
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Nov 2020 13:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE6522245
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Nov 2020 13:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+3lHgmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgKNNQv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Nov 2020 08:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgKNNQv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Nov 2020 08:16:51 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA694C0613D1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2020 05:16:50 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id i19so17817165ejx.9
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2020 05:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vqpvYxz/lOfiDszlZidDVdDIhjvBHcNz/0vAjd0jttM=;
        b=D+3lHgmC5dJXr3zvoXcTZVxjBJyngrR7+JhR6fj3dGv5eJdvagEEniy51TwEZVTFqk
         SjcUJKoC7KEN2smr+y1u5UFWKymOlAbzFKceGj6m9AXqnZqsZTxjbnoJABrqBF1K/tno
         qUUZdcpD5eiD2p0KZPWLKBSXN1vCfYx34ETGuE7DSY1gbToKcgHZuU7J6M+ICfEwonb6
         PAOZVaVJm8xOF1OW2K4jM1lRhm1fj1mWUE5BZ4icTedQ9oiwb/C61Fi9gTdDXVkAM4I3
         UpXYBaHd+5h639BTb4YZ9g0pK3FKd4PYTnxqYLBmNfvGJosbPJvIxaXgj3iuUCdd1iyU
         SVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vqpvYxz/lOfiDszlZidDVdDIhjvBHcNz/0vAjd0jttM=;
        b=lw6FzGT6cT41ELeW8ZDKoq+7ap9Aipdi1t26jGlyuSM6ZCuddM/Kg9lRSz6zygpzAD
         WsoCV+quIS5tGBNQSrbMioGjqsR4XbvxYjvW2RAKB6v4Qg6yt0beXexTooG9Oiv7IzMz
         gkHb5S6JsmlgglzAIGSLGU2T7lqYnhz2vwOU3i0t7qwJmsZ6b29w+bmvjt7UQ/IHg+FB
         B1ld3Mx8w+vbU/YdLborFnExDGP7JTAIdmFJaNgUQ3brtjoEFAZUsIID8Gpb4ihZJA7i
         OJ81xvk846ZMPwbkfTBUYp0THNGHYXgUHjtCTm2kmstGUhYOX6IrhjqnAuH3HrERRGdT
         sKVw==
X-Gm-Message-State: AOAM533v57ODd365pgJcWPMX8JMr3rz/Um5d4ghpFyHlzjhiKEqRCyLx
        LjnbyE6GM9st1iiZ1n+jpVnFS2BPKWQES+6yZ7c=
X-Google-Smtp-Source: ABdhPJxf4nwYVT9AYD2VkKw214xXMI3VaA1rjGyVcHUo5asKIFvefjamtWxlyqyDqyM81gtEMUgOgNlIuaB0Eya3WYc=
X-Received: by 2002:a17:906:2c19:: with SMTP id e25mr2663126ejh.66.1605359809423;
 Sat, 14 Nov 2020 05:16:49 -0800 (PST)
MIME-Version: 1.0
References: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
 <20201023170003.GC3908702@gmail.com> <CAMS8qEX766tggsR0DpJm8TVRwctwwvnRofiiDWhqsNDDK6exYA@mail.gmail.com>
 <X62nDWQNHy1pk+3t@sol.localdomain>
In-Reply-To: <X62nDWQNHy1pk+3t@sol.localdomain>
From:   Konrad Dybcio <konradybcio@gmail.com>
Date:   Sat, 14 Nov 2020 14:16:13 +0100
Message-ID: <CAMS8qEUg2cC5L9Y9kfZkinL5+YfT_i_BQgTkVSy5eQN0zcNRCg@mail.gmail.com>
Subject: Re: Qualcomm Crypto Engine driver
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> I'm already using your v5.10-rc3 branch, but ninges_defconfig isn't working for
> me.  (Though I couldn't find the firmware file "qcom/a530_zap.elf", so I had to
> remove it from CONFIG_EXTRA_FIRMWARE.)  Instead I'm using a kconfig based on
> https://github.com/SoMainline/linux/blob/marijn/android/arch/arm64/configs/defconfig
> which is working for me.

That's kind of expected, but Marijn's defconfig is fine. I just like
baking my firmware into the kernel for faster boot times.

> I haven't been able to get a full Android userspace to work, and currently I'm
> instead just replacing the kernel in a TWRP image and booting into recovery.
> It's enough to get adb shell access and chroot into a Debian chroot on the
> userdata partition, which is enough to run android-xfstests to test the ICE
> support.  Earlier I tried AOSP using the instructions at
> https://developer.sony.com/develop/open-devices/guides/aosp-build-instructions/build-aosp-android-android-11-0-0,

These instructions are meant for use with Sony Open Devices trees
available at github.com/sonyxperiadev, currently with CAF-based kernel
4.14.

> and also LineageOS using the instuctions at
> https://wiki.lineageos.org/devices/kirin/build

This one is for use with stock-based (BSP 4.4 kernel) trees.

> but neither worked.  That was a
> couple weeks ago though, so I haven't tried the very latest kernel with full
> Android.  Let me know if you have any suggestions!

First of all, you're going to need to retrieve gpu firmware (530
pfp/pm4 and 508 ZAP) like I do here (please flash the latest ODM image
from here to the oem partition [1] with fastboot) [2].

We are successfully booting Android but need multiple patches around,
in particular to enable A508 in Mesa (basically find "case 510:" and
add "case 508:" above it, like here [3]. For basic functionality,
we're working on proper 508/509/512 support) and the android device
trees aren't in the best state.. We're going to focus on these when
other components are ready.


Konrad

[1] https://developer.sony.com/file/download/software-binaries-for-aosp-android-11-0-kernel-4-14-ganges/

[2] https://gitlab.com/postmarketOS/pmaports/-/blob/b249d76d95107c7eeaf64ef6b58c1dc08cf3ca2b/device/testing/firmware-sony-ninges/enable_firmware.initd

[3] https://github.com/SoMainline/mesa/commit/13c197d956a7bf1761242a7d29e1a43904ecc9b3

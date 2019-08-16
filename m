Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC15FC3A59C
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 09:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F5A6206C2
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 09:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dXyyN4s/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfHPJwq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 05:52:46 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:34590 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfHPJwq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 05:52:46 -0400
Received: by mail-wr1-f51.google.com with SMTP id s18so985579wrn.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2019 02:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2tDToevl+x1e9wrylqW8zcsKvYm2YI9PHth3bU3yapA=;
        b=dXyyN4s/Br6b7c4Xt1Jers3sO/C7gEax7xqQT6R4M48ArWjiedoE1j1acwPlQLubds
         xOZSMogrZ/TK1j28ISMbBY9SOg9TDv03ZxTTCbHczUF6xW3A/CUi2liEB+9uKuoBb4Fw
         KE7TLErEyiKJVCvL9dM4tvYpHufLOmlbsMdwxaZQ1RsZHNsWMtvmxarIhDRPTGJ3Uu7s
         GlwDp+Fqb9sLpR8HA/BvBG8CjRlQbzuh/vC3sIjEbTGiX5IeVg68kHc8bAxDT7yY2RSU
         msxYkru4x0z/+5EWM3Ddb4dIH5DdXQunDeXQO5dtjsI5pJm42+rjjm38c8LdiUo5THUB
         M7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2tDToevl+x1e9wrylqW8zcsKvYm2YI9PHth3bU3yapA=;
        b=mJENtCX5Lm0qJqPtJR/Pe/cBS3bH+OzHZtOMKSQNVHYy4hU+ypiN5loH0vgW68JYgE
         x+ZTo+meV5ePLmwgYuW86JIOJpn5Shb2iLFw1B0d2w3v299pxKns7o+MNsGJu8Cmdp0m
         N3vS0saaYK3eO+r75Q5PstaMCADw+Pyr8EbOHZmDHoEPzeMZw+mXO1nqY72DMTE3TyU9
         I0I5Vhtnn6iXysbtnqaIigeAKdJQFJMUICNW/SYnKk6E+kV8NBBkOHFc3ceo61cn/7wj
         Qi1+f+I1ZSzXI20RX519uDK+6EzdPxjZHh+apOm915BibhXziuY70NA/SEq1lfFf9QEW
         IedA==
X-Gm-Message-State: APjAAAX5KGmb/oVHOkgJH/uTqGHg6QemjNVe4wwW+xbZ0Bzr48KFFHAL
        6nYrJfQA5ffNsjrbmPDGwTPEPHSAlPvWeMx26312FSPsVGXhfX5R
X-Google-Smtp-Source: APXvYqxKgjEtRN2NI3u61pI7yAdgAs2SuAvQ12Oev7KbCttsF64YEX6ZL2doNq6bnGOEsoKRajwd/IBhhEOTxEl9nOU=
X-Received: by 2002:adf:e8c2:: with SMTP id k2mr9592306wrn.198.1565949164469;
 Fri, 16 Aug 2019 02:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <1989109.29ScpdGMdu@positron.chronox.de>
In-Reply-To: <1989109.29ScpdGMdu@positron.chronox.de>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Aug 2019 12:52:33 +0300
Message-ID: <CAKv+Gu8ipTEJBB_sXmOcajp1NSkCJfOSi=kuqZhLekxJ1sn_Ug@mail.gmail.com>
Subject: Re: XTS self test fail
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 16 Aug 2019 at 12:50, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>
> Hi,
>
> with the current cryptodev-2.6 code, I get the following with fips=3D1:
>
> [   22.301826] alg: skcipher: xts-aes-aesni encryption failed on test vec=
tor
> "random: len=3D28 klen=3D64"; expected_error=3D0, actual_error=3D-22, cfg=
=3D"random:
> inplace may_sleep use_final src_divs=3D[<reimport>100.0%@+20] iv_offset=
=3D57"

This is currently being discussed: we are adding support for
ciphertext stealing (which is part of the XTS spec but currently
unimplemented)

Do you have CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy enabled?

> [   22.304800] Kernel panic - not syncing: alg: self-tests for xts-aes-ae=
sni
> (xts(aes)) failed in fips mode!
> [   22.305709] CPU: 0 PID: 259 Comm: cryptomgr_test Not tainted 5.3.0-rc1=
+ #9
> [   22.305709] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S
> 1.12.0-2.fc30 04/01/2014
> [   22.305709] Call Trace:
> [   22.305709]  dump_stack+0x7c/0xc0
> [   22.305709]  panic+0x240/0x453
> [   22.305709]  ? add_taint.cold+0x11/0x11
> [   22.305709]  ? __atomic_notifier_call_chain+0x5/0x130
> [   22.305709]  ? notifier_call_chain+0x27/0xb0
> [   22.305709]  alg_test+0x789/0x8d0
> [   22.305709]  ? valid_testvec_config+0x1d0/0x1d0
> [   22.305709]  ? lock_downgrade+0x380/0x380
> [   22.305709]  ? lock_acquire+0xff/0x220
> [   22.305709]  ? __kthread_parkme+0x45/0xd0
> [   22.305709]  ? mark_held_locks+0x24/0x90
> [   22.305709]  ? _raw_spin_unlock_irqrestore+0x43/0x50
> [   22.305709]  ? lockdep_hardirqs_on+0x1a8/0x290
> [   22.305709]  cryptomgr_test+0x36/0x60
> [   22.305709]  kthread+0x1a8/0x200
> [   22.305709]  ? crypto_acomp_scomp_free_ctx+0x70/0x70
> [   22.305709]  ? kthread_create_on_node+0xd0/0xd0
> [   22.305709]  ret_from_fork+0x3a/0x50
> [   22.305709] Kernel Offset: 0x35000000 from 0xffffffff81000000 (relocat=
ion
> range: 0xffffffff80000000-0xffffffffbfffffff)
> [   22.305709] ---[ end Kernel panic - not syncing: alg: self-tests for x=
ts-
> aes-aesni (xts(aes)) failed in fips mode! ]---
>
> Ciao
> Stephan
>
>

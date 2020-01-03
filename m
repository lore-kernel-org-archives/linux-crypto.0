Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A782C2D0C2
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 14:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C5E215A4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 14:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zAwEgWPw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgACOds (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jan 2020 09:33:48 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34655 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbgACOds (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jan 2020 09:33:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id c127so7076068wme.1
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jan 2020 06:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifraCwegUS/YivrX8FO5mIlbsVExhwEeZ5ejvcnHh4s=;
        b=zAwEgWPw4pO0DCHgDxwW1alXNOnJdhvkMmGWwa4F2qVRueh+4ee3ZVMcsPLX0aTmQO
         Uj7cc057zj1I3A6YNXgdGAguam4Mw5u5aRjun4z9EvhDvX84EO4uqsgpz/YDvRIIwgfh
         QIl4O+rcCf69b12V++lHu85ivalDffEqxOseu5ng+n4U+DbsGkGGrv7QKqeagR8BTma1
         p03NAL/DTcGNJ/0F43Z6iVzsGy2BkJHEhPvlERGOHkhKUyHdQTt8F0hkvoCejLXzboyn
         yWMviFSgaE8Kyy+RvRkzEP0M20lKX4i4e/OemeUK594XJNQT+jxZJFL1etBxmEvF8rUH
         P2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifraCwegUS/YivrX8FO5mIlbsVExhwEeZ5ejvcnHh4s=;
        b=albKHbBve9PUwuN1EBGXyPsrYSSbEDXie04zUcYOaylE7PdsgIQG6+T9i5uJMupFmM
         B5HBtABia+MVKljHo7uSvipNkUocfYIsc68zzr3AIZulU7LcdPcDPeJiwueCJm1hjU2h
         fiMcl+EFN2C1Bj9A94aVMfgAWv+Bg/rZYYMCENiCS8wtj/Cms/OGm+k9uSpYBPI7swwK
         At+MifUWbm3eXC1XhDn55vsVG4O0/zoT3jv7doy++gnTpbS0enTlfxmyxPTvAHQUFIUG
         2Z8RN/Be6j/cB85kb+swXz4O3EVu+ps1PQU4WyJPWaY1ESJTJQmGvtknh3+avWtGWJkO
         QAjg==
X-Gm-Message-State: APjAAAVXc9wuSEVU4PWQ72/sc3kBxIWc6iPyAjVxugro47rqeqxmVxp2
        Kc6yPS0fIPK6NzZpMMg+4yWcqcJzPt95aNaijCtVAEErvbpZ3w==
X-Google-Smtp-Source: APXvYqzUP2mvsDuZqtvCmzry9jciG3/MabElqkQDGDpMlZNWMOTqRuQ2gxDBzYDdmzdji1vYCPRa+ZAVYWEJD502I1A=
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr19338410wma.95.1578062026229;
 Fri, 03 Jan 2020 06:33:46 -0800 (PST)
MIME-Version: 1.0
References: <20191220190218.28884-1-cotequeiroz@gmail.com> <CAKv+Gu9ZXCK41xOavw+2KEhhsZq9BFH6mxXKPNomzB6q+DP_FQ@mail.gmail.com>
 <CAPxccB2LGANG8DcmF4nwUDOzDzf2RHX4S-4w9z6TcO9csu4xSw@mail.gmail.com>
In-Reply-To: <CAPxccB2LGANG8DcmF4nwUDOzDzf2RHX4S-4w9z6TcO9csu4xSw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 3 Jan 2020 15:33:35 +0100
Message-ID: <CAKv+Gu9fUs_xOZgUw5smrJf7+jrovkPL+1fF4fRcNhRieYSwhA@mail.gmail.com>
Subject: Re: QCE hw-crypto DMA issues
To:     Eneas Queiroz <cotequeiroz@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Jan 2020 at 22:09, Eneas Queiroz <cotequeiroz@gmail.com> wrote:
>
> I'm changing the subject title, as the original series has been merged.
>
> On Mon, Dec 23, 2019 at 6:46 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> On Fri, 20 Dec 2019 at 20:02, Eneas U de Queiroz <cotequeiroz@gmail.com> wrote:
>> >
>> > I've been trying to make the Qualcomm Crypto Engine work with GCM-mode
>> > AES.  I fixed some bugs, and added an option to build only hashes or
>> > skciphers, as the VPN performance increases if you leave some of that to
>> > the CPU.
>> >
>> > A discussion about this can be found here:
>> > https://github.com/openwrt/openwrt/pull/2518
>> >
>> > I'm using openwrt to test this, and there's no support for kernel 5.x
>> > yet.  So I have backported the recent skcipher updates, and tested this
>> > with 4.19. I don't have the hardware with me, but I have run-tested
>> > everything, working remotely.
>> >
>> > All of the skciphers directly implemented by the driver work.  They pass
>> > the tcrypt tests, and also some tests from userspace using AF_ALG:
>> > https://github.com/cotequeiroz/afalg_tests
>> >
>> > However, I can't get gcm(aes) to work.  When setting the gcm-mode key,
>> > it sets the ctr(aes) key, then encrypt a block of zeroes, and uses that
>> > as the ghash key.  The driver fails to perform that encryption.  I've
>> > dumped the input and output data, and they apparently are not touched by
>> > the QCE.  The IV, which written to a buffer appended to the results sg
>> > list gets updated, but the results themselves are not.  I'm not sure
>> > what goes wrong, if it is a DMA/cache problem, memory alignment, or
>> > whatever.
>> >
>>
>> This does sound like a DMA problem. I assume the accelerator is not
>> cache coherent?
>>
>> In any case, it is dubious whether the round trip to the accelerator
>> is worth it when encrypting the GHASH key. Just call aes_encrypt()
>> instead, and do it in software.
>
>
> ipsec still fails, even if I use software for every single-block operation. I can perhaps leave that as an optimization, but it won't fix the main issue.
>
>> > If I take 'be128 hash' out of the 'data' struct, and kzalloc them
>> > separately in crypto_gcm_setkey (crypto/gcm.c), it encrypts the data
>> > just fine--perhaps the payload and the request struct can't be in the
>> > same page?
>> >
>>
>> Non-cache coherent DMA involves cache invalidation on inbound data. So
>> if both the device and the CPU write to the same cacheline while the
>> buffer is mapped for DMA from device to memory, one of the updates
>> gets lost.
>
>
>  Can you give me any pointers/examples of how I can make this work?
>

You could have a look at commit ed527b13d800dd515a9e6c582f0a73eca65b2e1b

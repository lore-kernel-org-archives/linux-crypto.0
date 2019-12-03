Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0CEC43215
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 04:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5B742073B
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 04:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/H1/eK+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLCEQj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 23:16:39 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33630 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLCEQj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 23:16:39 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so1054891pgk.0;
        Mon, 02 Dec 2019 20:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fCbtMYLx1KYdikRtxKgukEL6DtHlmvKxFnXs8JP3/i0=;
        b=i/H1/eK+i6gKjCg2kehVmkTBMYbr1gZxc3C3cuZ4M+VFpoDZ4y0hnSUUWuC1ZhOQpp
         11JcZ/qwVm3nhnyaWccHx+qieAvuwpgMawlnN6vzvpFcmU2MYgzDdOYguN/ZDX429PzU
         9QM3tfyoWN/baDl8RjAThE7ER9paI3kFzYgL2TGO4fYNXvyqiOeGFLCn/y87/1tOPkxJ
         9nQTv8GL0ulovTb+lWaiAcvXpSTkIJ0V8lJY0dZ6EDf62Gbkjdcn9mdC1dt53Ig/0qW/
         GshV1O+HHGyuX0e4T3SC740qLF0FZHDL8ZPuvINW5v9GTFNbgDqrOwag2WQgu5geScQP
         1kKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fCbtMYLx1KYdikRtxKgukEL6DtHlmvKxFnXs8JP3/i0=;
        b=O1SOwK7sHcT88LXORPZV4/4cZlUUKnFWRtP1me80kbXIT+Q7Y/ar2ETqdwKjgHJsab
         3NxJ7aXGfJtxYkOxBErgerxyn8bWpAXU9W6DalP/sh+EvC4Eh8nEC1nubD0wuRekD1+f
         Y5Q/yfRVl/fQ11Ls1Axu0ZCMqRuZdkJEmTJrrD2+KI4Prv57At9kQOk6hmPFvpG8p8pB
         8p/MpzRQZkBtUdD15U272uyMlKQfZvdYle1Nmga3OB1HYLs2/+hBys64LCKfPleOvosW
         kyS88cA+JjAHZrspeR1KMud/d7fpzocy0xNLes0QalTJivUeNPoslVaCIHtx1EiaQDi+
         UoSA==
X-Gm-Message-State: APjAAAUEDTV9nyJfRiZt9jqbwotL6TEFf5/6zkXiDoD8IAfmY2YN20uB
        hAJelXauZ4vk6mFEt/5A3fg=
X-Google-Smtp-Source: APXvYqxLdZYWn6OJqGKjg2TESmazJ38Ycli+maIFavCbUEaRofyqYccYuh9qVb+CWwjVmMApZ559Qw==
X-Received: by 2002:a63:5a64:: with SMTP id k36mr3258280pgm.323.1575346598514;
        Mon, 02 Dec 2019 20:16:38 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i14sm1159641pfd.4.2019.12.02.20.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 20:16:37 -0800 (PST)
Subject: Re: [PATCH v5 3/3] hwrng: add mtk-sec-rng driver
To:     Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, pawel.moll@arm.com
Cc:     Mark Rutland <mark.rutland@arm.com>,
        DTML <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sean Wang <sean.wang@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neal Liu <neal.liu@mediatek.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?B?Q3J5c3RhbCBHdW8gKOmDreaZtik=?= <Crystal.Guo@mediatek.com>,
        Will Deacon <will@kernel.org>, Lars Persson <lists@bofh.nu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <1574864578-467-1-git-send-email-neal.liu@mediatek.com>
 <1574864578-467-4-git-send-email-neal.liu@mediatek.com>
 <CADnJP=uhD=J2NrpSwiX8oCTd-u_q05=HhsAV-ErCsXNDwVS0rA@mail.gmail.com>
 <1575027046.24848.4.camel@mtkswgap22>
 <CAKv+Gu_um7eRYXbieW7ogDX5mmZaxP7JQBJM9CajK+6CsO5RgQ@mail.gmail.com>
 <20191202191146.79e6368c@why>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <299029b0-0689-c2c4-4656-36ced31ed513@gmail.com>
Date:   Mon, 2 Dec 2019 20:16:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191202191146.79e6368c@why>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 12/2/2019 11:11 AM, Marc Zyngier wrote:
> On Mon, 2 Dec 2019 16:12:09 +0000
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
>> (adding some more arm64 folks)
>>
>> On Fri, 29 Nov 2019 at 11:30, Neal Liu <neal.liu@mediatek.com> wrote:
>>>
>>> On Fri, 2019-11-29 at 18:02 +0800, Lars Persson wrote:  
>>>> Hi Neal,
>>>>
>>>> On Wed, Nov 27, 2019 at 3:23 PM Neal Liu <neal.liu@mediatek.com> wrote:  
>>>>>
>>>>> For MediaTek SoCs on ARMv8 with TrustZone enabled, peripherals like
>>>>> entropy sources is not accessible from normal world (linux) and
>>>>> rather accessible from secure world (ATF/TEE) only. This driver aims
>>>>> to provide a generic interface to ATF rng service.
>>>>>  
>>>>
>>>> I am working on several SoCs that also will need this kind of driver
>>>> to get entropy from Arm trusted firmware.
>>>> If you intend to make this a generic interface, please clean up the
>>>> references to MediaTek and give it a more generic name. For example
>>>> "Arm Trusted Firmware random number driver".
>>>>
>>>> It will also be helpful if the SMC call number is configurable.
>>>>
>>>> - Lars  
>>>
>>> Yes, I'm trying to make this to a generic interface. I'll try to make
>>> HW/platform related dependency to be configurable and let it more
>>> generic.
>>> Thanks for your suggestion.
>>>  
>>
>> I don't think it makes sense for each arm64 platform to expose an
>> entropy source via SMC calls in a slightly different way, and model it
>> as a h/w driver. Instead, we should try to standardize this, and
>> perhaps expose it via the architectural helpers that already exist
>> (get_random_seed_long() and friends), so they get plugged into the
>> kernel random pool driver directly.
> 
> Absolutely. I'd love to see a standard, ARM-specified, virtualizable
> RNG that is abstracted from the HW.

Do you think we could use virtio-rng on top of a modified virtio-mmio
which instead of being backed by a hardware mailbox, could use hvc/smc
calls to signal writes to shared memory and get notifications via an
interrupt? This would also open up the doors to other virtio uses cases
beyond just RNG (e.g.: console, block devices?). If this is completely
stupid, then please disregard this comment.
-- 
Florian

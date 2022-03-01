Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D99C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Mar 2022 10:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbiCAKci (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiCAKch (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 05:32:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5349654A1
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 02:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646130714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XvmhzYzIN6YyKOjgRyfse+7E0We+oPI7HyRw5pHUOdE=;
        b=U9O3l9Hj5BkeF4qr11uBzORUyZZ6rsnL4EGQIsbhVdhSWoQStEC9ZnuPFuzFYEDl+tKWrH
        izCqxLPEXsO3qjf8k9JBz4vUFIgFudE08/N5tdwNqtdIPxGonLsZC41vfqHWIEZrp+F0Wg
        52F0xT9NthT21RK9CmbqDb/JfMdAlWg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-Ph_4Kc5dP_qL3o3FrB8xbQ-1; Tue, 01 Mar 2022 05:31:53 -0500
X-MC-Unique: Ph_4Kc5dP_qL3o3FrB8xbQ-1
Received: by mail-ej1-f70.google.com with SMTP id sa22-20020a1709076d1600b006ce78cacb85so6639262ejc.2
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 02:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XvmhzYzIN6YyKOjgRyfse+7E0We+oPI7HyRw5pHUOdE=;
        b=JyooVIj0a3RfOFqTEQ5uT5VVtJF5W7ImcLeQa7ieMMl0Lh5tiznM82eldQhV0QHDZp
         4rCCf/fFvzuwVTNKXTLsLQDsrkfqx8bvRieVSSKHiPaawszV4kpv0oM1fmiX4x1Eah9r
         0oa7pU+FSxwAxJnnNbI/ugVwhf9WtQK+KKQO+EcISj0cA6qoMrM+88uMVH3ZFd938nD2
         XRfzFIEoBL2sk2m1iD0y3qevYjHGGUOkyk9L1Oof7XW80oO8WBTio9LQLGp6NNelnk5x
         cMtottFUs+ag1kvfiux4IYvpjAUWhJxW1abb84sEKnKTOvxVgobVriKLlDTDtpiwy9Uy
         XgoA==
X-Gm-Message-State: AOAM532kTGKjpnHsHrJ+CBQmvJ0EXoAgTt5yla2AfuzpOxb25zlKSKkU
        aWp4d5lVLvAUH0vjeyFVYy2YIXm5Rga3tIjTvhHrb4CIN19+sm6QIty83Fy5QTZM7TfulH80Odi
        Gv1liUqBedvqeQ3U+gmjFxb2o
X-Received: by 2002:a50:ee90:0:b0:40f:349f:7368 with SMTP id f16-20020a50ee90000000b0040f349f7368mr23358809edr.236.1646130712553;
        Tue, 01 Mar 2022 02:31:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6xIoJMlO1A7ETr4+7k5TUVrUrwV9lNvsl4ikoWZTb0pGV5rskpq4uwCuMs4LHvn+CPJfl5A==
X-Received: by 2002:a50:ee90:0:b0:40f:349f:7368 with SMTP id f16-20020a50ee90000000b0040f349f7368mr23358795edr.236.1646130712357;
        Tue, 01 Mar 2022 02:31:52 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906195000b006cf3810dc99sm5147018eje.208.2022.03.01.02.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 02:31:51 -0800 (PST)
Message-ID: <7769e728-5864-115d-c3b8-8f52faa40f1a@redhat.com>
Date:   Tue, 1 Mar 2022 11:31:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v5 2/3] ACPI: allow longer device IDs
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Alexander Graf <graf@amazon.com>, Len Brown <lenb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <20220226220639.1173594-1-Jason@zx2c4.com>
 <20220226220639.1173594-3-Jason@zx2c4.com>
 <0c73d29e-e558-efb9-d0d7-c612b2bb7e90@amazon.com>
 <YhtyBHUyFysmZ9bC@zx2c4.com>
 <CAHmME9pocD1CoZbnF7p4k0ws7-R0Vc9H4i5TRJ_MCX-d3AZhFw@mail.gmail.com>
 <CAJZ5v0h_Z9XS9ZgSF4CWrZ4RU7=Oa02MY3_g0Y_rcgRNzsizfQ@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <CAJZ5v0h_Z9XS9ZgSF4CWrZ4RU7=Oa02MY3_g0Y_rcgRNzsizfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 2/28/22 19:19, Rafael J. Wysocki wrote:
> +Mika, Andy and Hans in case they have something to add

Thanks, I don't really have anything to add to the discussion
on v6 of this patch.

Regards,

Hans



> 
> On Mon, Feb 28, 2022 at 12:27 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>
>> Hey again,
>>
>> On Sun, Feb 27, 2022 at 1:43 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>>>
>>> Hi Alex,
>>>
>>> On Sun, Feb 27, 2022 at 12:42:03PM +0100, Alexander Graf wrote:
>>>>> To allow device drivers to match identifiers that exceed the 9 byte
>>>>> limit, this simply ups the length to 16, just like it was before the
>>>>> aforementioned commit. Empirical testing indicates that this
>>>>
>>>>
>>>> This is only true for 64bit systems where padding automatically bloated
>>>> to 9 byte array to 16. I still believe the patch is fine as it is, but
>>>> there will be minor .rodata overhead on 32bit targets which you may want
>>>> to quantify in the patch description.
>>>
>>> Good point. So I just tried this out with a 32-bit i686 kernel and the
>>> results are the same again for the size of vmlinux. I then ran `objdump
>>> --headers` and looked at the size of the .rodata section, where it's
>>> also the same. I'm not quite sure what to make of this, as it's not what
>>> I was expecting, but I think I tested it right. So maybe we're lucky
>>> here?
>>
>> I tried a little harder to get _some_ difference on 32-bit, and
>> managed to get one by doing i386_defconfig and then switching off
>> modules to make all M into Y, and then compared sizes:
>>
>> vmlinux: 25590780 -> 25598972, so a 0.032% increase.
>> bzImage: 8698944 -> 8699424, so a 0.0055% increase.
>>
>> So it does increase, ever so slightly, but a) on 32-bit, and b) a
>> super, super tiny amount.
>>
>> In other words, I still think this patch is very much a-okay. But very
>> eager to hear from Rafael on the approach.
> 
> Increasing the ACPI_ID_LEN value is fine with me, but the patch
> changelog is not entirely accurate.
> 
> The ACPI subsystem uses struct acpi_device_id mostly (if not only) for
> device ID matching and it is generally used for creating lists of ACPI
> device IDs in drivers (and allow/deny lists etc).  The device IDs
> extracted from the ACPI tables can be longer than ACPI_ID_LEN.
> 
> This means that drivers cannot match device IDs longer than 8
> characters (excluding the terminating 0), because the IDs in the lists
> used by them for ID matching cannot be longer than this and not
> because the ACPI subsystem is limited by that value.
> 


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DFA4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Mar 2022 10:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbiCAKgA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Mar 2022 05:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiCAKf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Mar 2022 05:35:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2705356C13
        for <linux-crypto@vger.kernel.org>; Tue,  1 Mar 2022 02:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646130916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5+CqQycvyRYkX2L7ftAW8XFXfOSyd5vBfPXO20RDoY=;
        b=JzvNfasuQnudUHUQUBul74oDM64iASFuCQQAdxn1RCkBfLLZFX9Z64sWuvQtmk+WtJYGH8
        E0oNeMU8ePSy+FW7WSjNEjuZ8djBCsU1K1iQW0qHvK7SxB2GsSQhuKcSlRy5WUxlg9JVor
        IcIANTPTWk7hyL8Wx4iJbU5aOLyMGl0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-LjEey3bUMye5fOtj9FVinw-1; Tue, 01 Mar 2022 05:35:14 -0500
X-MC-Unique: LjEey3bUMye5fOtj9FVinw-1
Received: by mail-ej1-f69.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so6639998eje.6
        for <linux-crypto@vger.kernel.org>; Tue, 01 Mar 2022 02:35:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t5+CqQycvyRYkX2L7ftAW8XFXfOSyd5vBfPXO20RDoY=;
        b=25lDZOoTcaDbuk7j7Suc6bNz+e342kduOfSbr3j13I+GoMavYlSvf2fodHh7MAHtLK
         rjiPYeOeuRp6JULOz774o3Iylt29ppECeHSbsJ9/SRVFFZUfoUFix1Zi7o6VqiM5mWOB
         0bvkJdTVuYumHqut6mej3sGs3fr4ySD/f+kn+XhS/QCQ1pzt6bd0q4S+abcU6KaGLt/8
         48JpobsWcpcPEDt37SgMnJBjbSucuioj6rQEy45y0zuWCJN/D+8UPwsTbR1lXS8YCS0q
         OSdpqWu8qGXr7qMsQwoC/x9MgA8rPsgoIyBVg8W7JsqrViiMeElovoMIP5vEUP8wnuwH
         olnA==
X-Gm-Message-State: AOAM5305vKizzbP7TKT7efN4Q42OWOHWrlm9gKA0CG2w5lFp7gbn30qA
        qggjmmTXlgTFRFwwiMUVIuey58VHaizEMZBtoP/fJSsyGucWw9KOotiiM21YHp4XIknZWgoSDil
        8co788t48vbry7EwXfEPy1T+6
X-Received: by 2002:a17:906:ae0c:b0:6a6:a09f:f8d5 with SMTP id le12-20020a170906ae0c00b006a6a09ff8d5mr18681302ejb.627.1646130913703;
        Tue, 01 Mar 2022 02:35:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAdPmzF4amKRWFY4CqbK9+TaLQceHPa3pbwSa4/lapqks5H4m/k0c1vhA7PaCgkd0Nsmupyg==
X-Received: by 2002:a17:906:ae0c:b0:6a6:a09f:f8d5 with SMTP id le12-20020a170906ae0c00b006a6a09ff8d5mr18681286ejb.627.1646130913507;
        Tue, 01 Mar 2022 02:35:13 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id da23-20020a056402177700b0041394d8173csm4911547edb.31.2022.03.01.02.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 02:35:13 -0800 (PST)
Message-ID: <e9bfc654-5504-29ff-5a5a-b73f24691600@redhat.com>
Date:   Tue, 1 Mar 2022 11:35:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/3 v6] ACPI: allow longer device IDs
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, rafael@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-acpi@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>
References: <CAHmME9qHnvwrxEue4Pdm_E1qZQGXFuR9orJSKCWj8fH5TSh6fA@mail.gmail.com>
 <20220228183355.9090-1-Jason@zx2c4.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220228183355.9090-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 2/28/22 19:33, Jason A. Donenfeld wrote:
> From: Alexander Graf <graf@amazon.com>
> 
> We create a list of ACPI "PNP" IDs which contains _HID, _CID, and CLS
> entries of the respective devices. However, when making structs for
> matching, we squeeze those IDs into acpi_device_id, which only has 9
> bytes space to store the identifier. The subsystem actually captures the
> full length of the IDs, and the modalias has the full length, but this
> struct we use for matching is limited. It originally had 16 bytes, but
> was changed to only have 9 in 6543becf26ff ("mod/file2alias: make
> modalias generation safe for cross compiling"), presumably on the theory
> that it would match the ACPI spec so it didn't matter.
> 
> Unfortunately, while most people adhere to the ACPI specs, Microsoft
> decided that its VM Generation Counter device [1] should only be
> identifiable by _CID with a value of "VM_Gen_Counter", which is longer
> than 9 characters.
> 
> To allow device drivers to match identifiers that exceed the 9 byte
> limit, this simply ups the length to 16, just like it was before the
> aforementioned commit. Empirical testing indicates that this
> doesn't actually increase vmlinux size on 64-bit, because the ulong in
> the same struct caused there to be 7 bytes of padding anyway, and when
> doing a s/M/Y/g i386_defconfig build, the bzImage only increased by
> 0.0055%, so negligible.
> 
> This patch is a prerequisite to add support for VMGenID in Linux, the
> subsequent patch in this series. It has been confirmed to also work on
> the udev/modalias side in userspace.
> 
> [1] https://download.microsoft.com/download/3/1/C/31CFC307-98CA-4CA5-914C-D9772691E214/VirtualMachineGenerationID.docx
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Co-authored-by: Jason A. Donenfeld <Jason@zx2c4.com>
> [Jason: reworked commit message a bit, went with len=16 approach.]
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

The need for this is a bit meh, but I have no objections against
solving it this way:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
> Hi Rafael,
> 
> This patch is directed toward you specifically. The first and last patch
> of the series this is part of have been through the ringer of review a
> bit already and do not specifically require your attention, but we wound
> up getting hung up on an ACPI ID matching API limitation. This patch
> fixes that limitation with this patch that you see here, with a trivial
> one line fix, which does require your attention.
> 
> The other patches will go through my random.git tree naturally, but
> because those patches depend on this one here, in order to compile
> without warnings (and be functional at all), it would be nice if you
> would provide an "Acked-by" on it and permit me to /also/ take it
> through my random.git tree (if it looks like a correct patch to you, of
> course). This would make the merge logistics a lot easier. Plus it's a
> small +1/-1 line change.
> 
> This v6 updates the commit message.
> 
> Please have a look and let me know what you think.
> 
> Thanks,
> Jason
> 
>  include/linux/mod_devicetable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 4bb71979a8fd..5da5d990ff58 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -211,7 +211,7 @@ struct css_device_id {
>  	kernel_ulong_t driver_data;
>  };
>  
> -#define ACPI_ID_LEN	9
> +#define ACPI_ID_LEN	16
>  
>  struct acpi_device_id {
>  	__u8 id[ACPI_ID_LEN];


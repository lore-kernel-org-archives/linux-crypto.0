Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73BEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 10:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B324561213
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 10:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhKDKDB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 06:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbhKDKDA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 06:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636020022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2PSO6mK/V2WEufqaXqvpZBXj1vpIF9VMwrHvOPSnJQY=;
        b=GrJRYk4kIlY8gVD5i6qbjc2Ramb4DlKUN9jT3nr8tt4mY2O/XMaA2fXkOast1e/mXDx4+4
        MDTXSkiwvg/K47H9R0IwLq023mrbyeWVHeX/ggn6qaLied1z05/gPCHB7Q7F5icbj/yfCa
        Y8w0qxecuUjefSpVhS0oOaRDTiholsI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-7mjyKL4qOfmRkKEkFbfAAA-1; Thu, 04 Nov 2021 06:00:21 -0400
X-MC-Unique: 7mjyKL4qOfmRkKEkFbfAAA-1
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50cd4b000000b003da63711a8aso5161696edj.20
        for <linux-crypto@vger.kernel.org>; Thu, 04 Nov 2021 03:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2PSO6mK/V2WEufqaXqvpZBXj1vpIF9VMwrHvOPSnJQY=;
        b=v3VESWMSPXPYR3VZcRRkgMMxwd92LgxT1FuB81uguBWcxn5LFBLTqVRglf21WtbMlL
         O10BQ24sM0inekw+Cr5m//NmGYNsZq5QW+/NlytG7du1isVMUsXBP8H3vMkXIeURQOjw
         M463YgwTrqgPsQoPY8IJjpJp/AshIF880Gt/qiqFhSD7E8u7oT99ydkEm9lVtzsqettq
         vqEQB156iV1MYsKrR2ZQusDL4Yn1g8f7SUyTDefDry2MCUldnSFe24Ps0VHunth5C1JQ
         duwKVm2wLji3KGT7mdIm3tC/bjWs9NVW7LH93bkduwk5CVfMrk9M+22LbP07JDX3x3Oj
         EVWQ==
X-Gm-Message-State: AOAM532Ar0ltJTszEw0S/BGKcpFDUQ9q3IACSTwjiP0DGwvQywyTfZVa
        hVVqSnVscUo3/0s5NIk8gcsLRt2hQYpxuhq8wT3QwpAKS4osT22zVgteimk2D1mTudyCXb0ofx7
        r0NQb34iW40THEZKZulhI0qW6
X-Received: by 2002:a05:6402:1289:: with SMTP id w9mr63952916edv.268.1636020020331;
        Thu, 04 Nov 2021 03:00:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmIBFjo3k5XIFHxIkRTFl5iANUtBeF5xy6uOrsg5CSSV9ha75F6OFM6T0qXUKd52hRQGg2rQ==
X-Received: by 2002:a05:6402:1289:: with SMTP id w9mr63952894edv.268.1636020020144;
        Thu, 04 Nov 2021 03:00:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id gb2sm2413667ejc.52.2021.11.04.03.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 03:00:18 -0700 (PDT)
Message-ID: <3f4bf34f-fdc2-37f7-c789-249f19b0653f@redhat.com>
Date:   Thu, 4 Nov 2021 11:00:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] crypto: x86/aes-ni: fix AVX detection
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
References: <20211103124614.499580-1-mlevitsk@redhat.com>
 <622444d6-f98b-dae4-381e-192e5cb02621@intel.com>
 <20211103145231.GA4485@gondor.apana.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211103145231.GA4485@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/3/21 15:52, Herbert Xu wrote:
> On Wed, Nov 03, 2021 at 07:43:43AM -0700, Dave Hansen wrote:
>> The kernel shouldn't crash in this case.  We've got a software
>> dependency which should disable AVX2 if AVX is off:
> It's qemu, I thought it was a qemu bug but Paulo disagrees.

I don't disagree that QEMU could do better in preventing nonsensical 
combinations; however, independent of that you shouldn't use AVX2 
without factoring XCR0 in the decision.  This is true no matter if 
userspace/kernel or even bare metal/virt.

That does not have to be done directly with cpu_has_xfeatures as in 
Maxim's patch: if boot_cpu_has(AVX) returns false after 
xsave_cpuid_features has filtered it out, or if boot_cpu_has(AVX2) 
returns false after cpuid_deps has filtered it out, that's fine.  I 
guess Maxim can look at the pointers that Dave provided and check if 
there's another bug somewhere in arch/x86/kernel.

Paolo


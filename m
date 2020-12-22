Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D39EC433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 04:55:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6215820E65
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 04:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgLVEzu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Dec 2020 23:55:50 -0500
Received: from terminus.zytor.com ([198.137.202.136]:36123 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgLVEzu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Dec 2020 23:55:50 -0500
Received: from [IPv6:2601:646:8680:a581:e440:f7b7:1011:93f7] ([IPv6:2601:646:8680:a581:e440:f7b7:1011:93f7])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 0BM4seMn4117225
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 21 Dec 2020 20:54:42 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 0BM4seMn4117225
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020112401; t=1608612884;
        bh=UtrX0dieD57hlki8ozSWTqtt8ZSNQ/eNxz7Q4ockwm0=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=YJTsTkm6EFKhX8FI/wzkUIqyDYumRJkQnyIQhjsB0ZPb1qTtNSdM79cPFv54GhlOT
         wcPsmniaYAIFhKf7OkIkp9j0G/iR9P6P5xvJ229kFV6yvfUr+9KIjbtOBs/NqHTD/t
         SNFbwGHutEKLdsNLihK3Y+ZjBjYr7uHUYDNjcXp5KSFOvJi8lABjAjebFZ03BtG0yO
         LjC5ckgBPUw4lpElXXFh4wWqU+wMK37oDSXfJNeA2QwpoW5AZd8/BbNObv0Z1IzaNc
         xypUiZhO68bxTeWrW3hfbOZrsABJyTusB5vSb5WzPTfQknzCX1ETOSAWPQtbAwziTy
         iF4uGsH2gPAKw==
Date:   Mon, 21 Dec 2020 20:54:31 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <4CDBFCA0-56B9-495B-9660-3BE9018BC8AE@zhaoxin.com>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com> <X9Ov3RWDpUik7gXo@sol.localdomain> <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com> <X9fN7mOMdn1Dxn63@sol.localdomain> <a95984ea-7451-78fe-88c5-b81f633fecdf@zhaoxin.com> <X9j43b+JPbUUvCrH@sol.localdomain> <345BC725-406B-40C6-88E9-747DBEBE0493@zhaoxin.com> <AB43DE6C-BF23-4B72-B0C8-09FE0071B2C7@zytor.com> <4CDBFCA0-56B9-495B-9660-3BE9018BC8AE@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     tonywwang-oc@zhaoxin.com, Eric Biggers <ebiggers@kernel.org>
CC:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
From:   hpa@zytor.com
Message-ID: <5804E9D1-15D2-41A9-A483-16985C9810FE@zytor.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On December 21, 2020 7:01:39 PM PST, tonywwang-oc@zhaoxin=2Ecom wrote:
>On December 22, 2020 3:27:33 AM GMT+08:00, hpa@zytor=2Ecom wrote:
>>On December 20, 2020 6:46:25 PM PST, tonywwang-oc@zhaoxin=2Ecom wrote:
>>>On December 16, 2020 1:56:45 AM GMT+08:00, Eric Biggers
>>><ebiggers@kernel=2Eorg> wrote:
>>>>On Tue, Dec 15, 2020 at 10:15:29AM +0800, Tony W Wang-oc wrote:
>>>>>=20
>>>>> On 15/12/2020 04:41, Eric Biggers wrote:
>>>>> > On Mon, Dec 14, 2020 at 10:28:19AM +0800, Tony W Wang-oc wrote:
>>>>> >> On 12/12/2020 01:43, Eric Biggers wrote:
>>>>> >>> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc
>wrote:
>>>>> >>>> The driver crc32c-intel match CPUs supporting
>>>>X86_FEATURE_XMM4_2=2E
>>>>> >>>> On platforms with Zhaoxin CPUs supporting this X86 feature,
>>>When
>>>>> >>>> crc32c-intel and crc32c-generic are both registered, system
>>>will
>>>>> >>>> use crc32c-intel because its =2Ecra_priority is greater than
>>>>> >>>> crc32c-generic=2E This case expect to use crc32c-generic driver
>>>>for
>>>>> >>>> some Zhaoxin CPUs to get performance gain, So remove these
>>>>Zhaoxin
>>>>> >>>> CPUs support from crc32c-intel=2E
>>>>> >>>>
>>>>> >>>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin=2Ecom>
>>>>> >>>
>>>>> >>> Does this mean that the performance of the crc32c instruction
>>on
>>>>those CPUs is
>>>>> >>> actually slower than a regular C implementation?  That's very
>>>>weird=2E
>>>>> >>>
>>>>> >>
>>>>> >> From the lmbench3 Create and Delete file test on those chips, I
>>>>think yes=2E
>>>>> >>
>>>>> >=20
>>>>> > Did you try measuring the performance of the hashing itself, and
>>>>not some
>>>>> > higher-level filesystem operations?
>>>>> >=20
>>>>>=20
>>>>> Yes=2E Was testing on these Zhaoxin CPUs, the result is that with
>the
>>>>same
>>>>> input value the generic C implementation takes fewer time than the
>>>>> crc32c instruction implementation=2E
>>>>>=20
>>>>
>>>>And that is really "working as intended"?
>>>
>>>These CPU's crc32c instruction is not working as intended=2E
>>>
>>>  Why do these CPUs even
>>>>declare that
>>>>they support the crc32c instruction, when it is so slow?
>>>>
>>>
>>>The presence of crc32c and some other instructions supports are
>>>enumerated by CPUID=2E01:ECX[SSE4=2E2] =3D 1,  other instructions are o=
k
>>>except the crc32c instruction=2E
>>>
>>>>Are there any other instruction sets (AES-NI, PCLMUL, SSE, SSE2,
>AVX,
>>>>etc=2E) that
>>>>these CPUs similarly declare support for but they are uselessly
>slow?
>>>
>>>No=2E
>>>
>>>Sincerely
>>>Tonyw
>>>
>>>>
>>>>- Eric
>>
>>Then the right thing to do is to disable the CPUID bit in the
>>vendor-specific startup code=2E
>
>This way makes these CPUs do not support all instruction sets
>enumerated
>by CPUID=2E01:ECX[SSE4=2E2]=2E
>While only crc32c instruction is slow, just expect the crc32c-intel
>driver do not
>match these CPUs=2E
>
>Sincerely
>Tonyw

Then create a BUG flag for it, or factor out CRC32C into a synthetic flag=
=2E We *do not* bury this information in drivers; it becomes a recipe for t=
he same problems over and over=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

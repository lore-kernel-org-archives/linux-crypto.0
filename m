Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399AEC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 20:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2EA622AAA
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 20:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLUUAS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Dec 2020 15:00:18 -0500
Received: from terminus.zytor.com ([198.137.202.136]:46061 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUUAS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Dec 2020 15:00:18 -0500
X-Greylist: delayed 1880 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 15:00:16 EST
Received: from [IPv6:2601:646:8680:a581:e440:f7b7:1011:93f7] ([IPv6:2601:646:8680:a581:e440:f7b7:1011:93f7])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 0BLJRg103956887
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 21 Dec 2020 11:27:45 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 0BLJRg103956887
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020112401; t=1608578866;
        bh=UGFdDjO1ECr35fGqPt/QpGBpk76YJYwXYZHdW1oqTfI=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=c18Ac7stpi+aErtiz+rL4d7zg4tXPw8clABl0FJCmxq4MeNp4Y3KoyRuP7YDaqhoR
         2H9gsC6zCzcQ3LDC5LdzQcCFozf6dSNYAmge4QWajnjgLYypP6a2nXdf2FqPtG+EbB
         Hp8ViX7Kk649fd+An5jQUchRq6/Bg38QOoTi1H5dyTeNAQ07IXGM+ttknJasOpANkf
         TSij0PgxI+xKbujCsKs3sBvAh2/lbDkymNiOgvUL20SCIPI3+ACFm0O3ah96Tn7DNG
         bGTLWm8hEelGSrqTIGdFJEFKJ2NXfYp0WKw+ep7xvSV9paHM5AuCF12df9vX3UoxEd
         YmX3o1xCQo7gw==
Date:   Mon, 21 Dec 2020 11:27:33 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <345BC725-406B-40C6-88E9-747DBEBE0493@zhaoxin.com>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com> <X9Ov3RWDpUik7gXo@sol.localdomain> <1f8d17bf-c1d9-6496-d2f8-5773633011fb@zhaoxin.com> <X9fN7mOMdn1Dxn63@sol.localdomain> <a95984ea-7451-78fe-88c5-b81f633fecdf@zhaoxin.com> <X9j43b+JPbUUvCrH@sol.localdomain> <345BC725-406B-40C6-88E9-747DBEBE0493@zhaoxin.com>
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
Message-ID: <AB43DE6C-BF23-4B72-B0C8-09FE0071B2C7@zytor.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On December 20, 2020 6:46:25 PM PST, tonywwang-oc@zhaoxin=2Ecom wrote:
>On December 16, 2020 1:56:45 AM GMT+08:00, Eric Biggers
><ebiggers@kernel=2Eorg> wrote:
>>On Tue, Dec 15, 2020 at 10:15:29AM +0800, Tony W Wang-oc wrote:
>>>=20
>>> On 15/12/2020 04:41, Eric Biggers wrote:
>>> > On Mon, Dec 14, 2020 at 10:28:19AM +0800, Tony W Wang-oc wrote:
>>> >> On 12/12/2020 01:43, Eric Biggers wrote:
>>> >>> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
>>> >>>> The driver crc32c-intel match CPUs supporting
>>X86_FEATURE_XMM4_2=2E
>>> >>>> On platforms with Zhaoxin CPUs supporting this X86 feature,
>When
>>> >>>> crc32c-intel and crc32c-generic are both registered, system
>will
>>> >>>> use crc32c-intel because its =2Ecra_priority is greater than
>>> >>>> crc32c-generic=2E This case expect to use crc32c-generic driver
>>for
>>> >>>> some Zhaoxin CPUs to get performance gain, So remove these
>>Zhaoxin
>>> >>>> CPUs support from crc32c-intel=2E
>>> >>>>
>>> >>>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin=2Ecom>
>>> >>>
>>> >>> Does this mean that the performance of the crc32c instruction on
>>those CPUs is
>>> >>> actually slower than a regular C implementation?  That's very
>>weird=2E
>>> >>>
>>> >>
>>> >> From the lmbench3 Create and Delete file test on those chips, I
>>think yes=2E
>>> >>
>>> >=20
>>> > Did you try measuring the performance of the hashing itself, and
>>not some
>>> > higher-level filesystem operations?
>>> >=20
>>>=20
>>> Yes=2E Was testing on these Zhaoxin CPUs, the result is that with the
>>same
>>> input value the generic C implementation takes fewer time than the
>>> crc32c instruction implementation=2E
>>>=20
>>
>>And that is really "working as intended"?
>
>These CPU's crc32c instruction is not working as intended=2E
>
>  Why do these CPUs even
>>declare that
>>they support the crc32c instruction, when it is so slow?
>>
>
>The presence of crc32c and some other instructions supports are
>enumerated by CPUID=2E01:ECX[SSE4=2E2] =3D 1,  other instructions are ok
>except the crc32c instruction=2E
>
>>Are there any other instruction sets (AES-NI, PCLMUL, SSE, SSE2, AVX,
>>etc=2E) that
>>these CPUs similarly declare support for but they are uselessly slow?
>
>No=2E
>
>Sincerely
>Tonyw
>
>>
>>- Eric

Then the right thing to do is to disable the CPUID bit in the vendor-speci=
fic startup code=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

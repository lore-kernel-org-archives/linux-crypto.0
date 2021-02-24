Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F225BC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 01:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A545164E4D
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 01:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhBXBUM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:20:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:36027 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233855AbhBXAzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 19:55:16 -0500
IronPort-SDR: ESR6VY9aawAZNg4Rcii4yAIgoAIudOqEqozCl2o9TWq8p8uQlNP/BzLZgK3lq+lWI8Q4Cylqgi
 EboSKthiGTGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="185055576"
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="185055576"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 16:54:39 -0800
IronPort-SDR: YCu6Y4GV//GLZPXt6iFPHIg4O+XVjjQOgR4ESuY6aBK0isXLej+G34VoWvhTGWUFlj/BxmcGeH
 chujS+CRxwNA==
X-IronPort-AV: E=Sophos;i="5.81,201,1610438400"; 
   d="scan'208";a="433011917"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.20.123]) ([10.212.20.123])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 16:54:37 -0800
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
To:     Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, greg.b.tucker@intel.com,
        "Kasten, Robert A" <robert.a.kasten@intel.com>,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        Kyung Min Park <kyung.min.park@intel.com>,
        Weiny Ira <ira.weiny@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, X86 ML <x86@kernel.org>
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
 <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
Date:   Tue, 23 Feb 2021 16:54:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andy,

On 1/24/2021 8:23 AM, Andy Lutomirski wrote:
> On Fri, Jan 22, 2021 at 11:29 PM Megha Dey <megha.dey@intel.com> wrote:
>> Optimize crypto algorithms using AVX512 instructions - VAES and VPCLMULQDQ
>> (first implemented on Intel's Icelake client and Xeon CPUs).
>>
>> These algorithms take advantage of the AVX512 registers to keep the CPU
>> busy and increase memory bandwidth utilization. They provide substantial
>> (2-10x) improvements over existing crypto algorithms when update data size
>> is greater than 128 bytes and do not have any significant impact when used
>> on small amounts of data.
>>
>> However, these algorithms may also incur a frequency penalty and cause
>> collateral damage to other workloads running on the same core(co-scheduled
>> threads). These frequency drops are also known as bin drops where 1 bin
>> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
>> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
>> are observed on the Icelake server.
>>
>> The AVX512 optimization are disabled by default to avoid impact on other
>> workloads. In order to use these optimized algorithms:
>> 1. At compile time:
>>     a. User must enable CONFIG_CRYPTO_AVX512 option
>>     b. Toolchain(assembler) must support VPCLMULQDQ and VAES instructions
>> 2. At run time:
>>     a. User must set module parameter use_avx512 at boot time
>>     b. Platform must support VPCLMULQDQ and VAES features
>>
>> N.B. It is unclear whether these coarse grain controls(global module
>> parameter) would meet all user needs. Perhaps some per-thread control might
>> be useful? Looking for guidance here.
>
> I've just been looking at some performance issues with in-kernel AVX,
> and I have a whole pile of questions that I think should be answered
> first:
>
> What is the impact of using an AVX-512 instruction on the logical
> thread, its siblings, and other cores on the package?
>
> Does the impact depend on whether it’s a 512-bit insn or a shorter EVEX insn?
>
> What is the impact on subsequent shorter EVEX, VEX, and legacy
> SSE(2,3, etc) insns?
>
> How does VZEROUPPER figure in?  I can find an enormous amount of
> misinformation online, but nothing authoritative.
>
> What is the effect of the AVX-512 states (5-7) being “in use”?  As far
> as I can tell, the only operations that clear XINUSE[5-7] are XRSTOR
> and its variants.  Is this correct?
>
> On AVX-512 capable CPUs, do we ever get a penalty for executing a
> non-VEX insn followed by a large-width EVEX insn without an
> intervening VZEROUPPER?  The docs suggest no, since Broadwell and
> before don’t support EVEX, but I’d like to know for sure.
>
>
> My current opinion is that we should not enable AVX-512 in-kernel
> except on CPUs that we determine have good AVX-512 support.  Based on
> some reading, that seems to mean Ice Lake Client and not anything
> before it.  I also think a bunch of the above questions should be
> answered before we do any of this.  Right now we have a regression of
> unknown impact in regular AVX support in-kernel, we will have
> performance issues in-kernel depending on what user code has done
> recently, and I'm still trying to figure out what to do about it.
> Throwing AVX-512 into the mix without real information is not going to
> improve the situation.

We are currently working on providing you with answers on the questions 
you have raised regarding AVX.

Thanks,

Megha


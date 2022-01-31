Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4167C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 18:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351085AbiAaSnV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:43:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:33563 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344176AbiAaSnU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 13:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643654600; x=1675190600;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vn+hK2iPQV+5GoZdmPFY/HBfv44aTXTVyClVfPBx8Sg=;
  b=RxCWGwz7OFmkTnDIKfb39I2mr7IfVRVlhl1fLWXoSM4T7AHZIUg6vcPw
   GML45Bw7MlD0hFFW9krC13ssM8r9p10Iu2TgUaGvetM1LG4cWbqQqMqbh
   88WScDdXJHj3qonXBGoGELd0y0JMM4ZWBt71UQOzozjK/yQQwAAvlG8k+
   UkWR4aX2ijNCHPPdcKJEOY4XrYh0I0jqMl1Wr7ISyHzZlH6Z7+D8xiV9J
   MJ7xQlK6rK1evsZ50UvZmAaQivhteWNhjUqi/y1i/xBROrn8rxSvKYKRP
   oK4mVb1phK+TVf0LqzlztwVeQpoQJgvdcnzF4xVXaZbzDaHHG2U4daUW5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247478717"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247478717"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:43:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="698097518"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.213.165.173]) ([10.213.165.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:43:19 -0800
Message-ID: <e8ce1146-3952-6977-1d0e-a22758e58914@intel.com>
Date:   Mon, 31 Jan 2022 10:43:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
Content-Language: en-US
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
 <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
 <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
In-Reply-To: <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

On 2/24/2021 9:42 AM, Andy Lutomirski wrote:
> On Tue, Feb 23, 2021 at 4:54 PM Dey, Megha <megha.dey@intel.com> wrote:
>> Hi Andy,
>>
>> On 1/24/2021 8:23 AM, Andy Lutomirski wrote:
>>> On Fri, Jan 22, 2021 at 11:29 PM Megha Dey <megha.dey@intel.com> wrote:
>>>> Optimize crypto algorithms using AVX512 instructions - VAES and VPCLMULQDQ
>>>> (first implemented on Intel's Icelake client and Xeon CPUs).
>>>>
>>>> These algorithms take advantage of the AVX512 registers to keep the CPU
>>>> busy and increase memory bandwidth utilization. They provide substantial
>>>> (2-10x) improvements over existing crypto algorithms when update data size
>>>> is greater than 128 bytes and do not have any significant impact when used
>>>> on small amounts of data.
>>>>
>>>> However, these algorithms may also incur a frequency penalty and cause
>>>> collateral damage to other workloads running on the same core(co-scheduled
>>>> threads). These frequency drops are also known as bin drops where 1 bin
>>>> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
>>>> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
>>>> are observed on the Icelake server.
>>>>
>>>> The AVX512 optimization are disabled by default to avoid impact on other
>>>> workloads. In order to use these optimized algorithms:
>>>> 1. At compile time:
>>>>      a. User must enable CONFIG_CRYPTO_AVX512 option
>>>>      b. Toolchain(assembler) must support VPCLMULQDQ and VAES instructions
>>>> 2. At run time:
>>>>      a. User must set module parameter use_avx512 at boot time
>>>>      b. Platform must support VPCLMULQDQ and VAES features
>>>>
>>>> N.B. It is unclear whether these coarse grain controls(global module
>>>> parameter) would meet all user needs. Perhaps some per-thread control might
>>>> be useful? Looking for guidance here.
>>> I've just been looking at some performance issues with in-kernel AVX,
>>> and I have a whole pile of questions that I think should be answered
>>> first:
>>>
>>> What is the impact of using an AVX-512 instruction on the logical
>>> thread, its siblings, and other cores on the package?
>>>
>>> Does the impact depend on whether it’s a 512-bit insn or a shorter EVEX insn?
>>>
>>> What is the impact on subsequent shorter EVEX, VEX, and legacy
>>> SSE(2,3, etc) insns?
>>>
>>> How does VZEROUPPER figure in?  I can find an enormous amount of
>>> misinformation online, but nothing authoritative.
>>>
>>> What is the effect of the AVX-512 states (5-7) being “in use”?  As far
>>> as I can tell, the only operations that clear XINUSE[5-7] are XRSTOR
>>> and its variants.  Is this correct?
>>>
>>> On AVX-512 capable CPUs, do we ever get a penalty for executing a
>>> non-VEX insn followed by a large-width EVEX insn without an
>>> intervening VZEROUPPER?  The docs suggest no, since Broadwell and
>>> before don’t support EVEX, but I’d like to know for sure.
>>>
>>>
>>> My current opinion is that we should not enable AVX-512 in-kernel
>>> except on CPUs that we determine have good AVX-512 support.  Based on
>>> some reading, that seems to mean Ice Lake Client and not anything
>>> before it.  I also think a bunch of the above questions should be
>>> answered before we do any of this.  Right now we have a regression of
>>> unknown impact in regular AVX support in-kernel, we will have
>>> performance issues in-kernel depending on what user code has done
>>> recently, and I'm still trying to figure out what to do about it.
>>> Throwing AVX-512 into the mix without real information is not going to
>>> improve the situation.
>> We are currently working on providing you with answers on the questions
>> you have raised regarding AVX.
> Thanks!

We had submitted this patch series last year which uses AVX512F, VAES, 
VPCLMULQDQ instructions and ZMM(512 bit) registers to optimize certain 
crypto algorithms. As concluded, this approach could introduce a 
frequency drop of 1-2 bins for sibling threads running on the same core 
(512L instructions). The behavior is explained in article [1]. [2] 
covers similar topic as [1] but it focuses on client processors.

Since then, we have worked on new AES-GCM implementation using AVX512VL, 
VAES, VCLMUQLDQ instructions using only 256-bit YMM registers. With this 
implementation, we see a 1.5X improvement on ICX/ICL for 16KB buffers 
compared to the existing kernel AES-GCM implementation that works on 
128-bit XMM registers. Instructions used in the new GCM implementation 
classify as 256L ones. 256L class maps onto Core License 2 resulting in 
no frequency reduction (Figure 6 in [1]) and execute at the same 
frequency as an SSE code.

Before we start work on any upstream worthy patch, we would want to 
solicit any feedback to see if this implementation approach receives 
interest from the community.

Please note that AES-GCM is the predominant cipher suite for TLS and 
IPSEC. Having its efficient/performant implementation in the kernel will 
help customers and applications that rely on KTLS (like CDN/TLS proxy) 
or kernel IPSEC tunneling services.

[1] 
https://www.intel.com/content/www/us/en/architecture-and-technology/crypto-acceleration-in-xeon-scalable-processors-wp.html 


[2] https://travisdowns.github.io/blog/2020/08/19/icl-avx512-freq.html

Thanks,

Megha


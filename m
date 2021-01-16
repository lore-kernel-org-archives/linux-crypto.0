Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A96C433DB
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8559823A01
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 00:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbhAPAP0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 19:15:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:8985 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbhAPAP0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 19:15:26 -0500
IronPort-SDR: e+1kz1knSqm7q3/TI2R4rZDRyb3uqfqsZWZQcIKmHgHOIRAiLfnieRS/2GpWOwYKwQ/miazAaS
 culiNnAD0sBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9865"; a="263422576"
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="263422576"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 16:14:44 -0800
IronPort-SDR: t09QPpFEG1iLf7taOkfKoFA8biUcl4HaAflWlH6kKL3MCzhHQ2IPXbLKc6ONBRU1S+6SNnCMJj
 Ux4X8DtqKrZA==
X-IronPort-AV: E=Sophos;i="5.79,350,1602572400"; 
   d="scan'208";a="425493706"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.254.14.175]) ([10.254.14.175])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 16:14:42 -0800
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-4-git-send-email-megha.dey@intel.com>
 <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com>
Date:   Fri, 15 Jan 2021 16:14:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 12/19/2020 9:03 AM, Ard Biesheuvel wrote:
> On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>> From: Kyung Min Park <kyung.min.park@intel.com>
>>
>> Optimize GHASH computations with the 512 bit wide VPCLMULQDQ instructions.
>> The new instruction allows to work on 4 x 16 byte blocks at the time.
>> For best parallelism and deeper out of order execution, the main loop of
>> the code works on 16 x 16 byte blocks at the time and performs reduction
>> every 48 x 16 byte blocks. Such approach needs 48 precomputed GHASH subkeys
>> and the precompute operation has been optimized as well to leverage 512 bit
>> registers, parallel carry less multiply and reduction.
>>
>> VPCLMULQDQ instruction is used to accelerate the most time-consuming
>> part of GHASH, carry-less multiplication. VPCLMULQDQ instruction
>> with AVX-512F adds EVEX encoded 512 bit version of PCLMULQDQ instruction.
>>
>> The glue code in ghash_clmulni_intel module overrides existing PCLMULQDQ
>> version with the VPCLMULQDQ version when the following criteria are met:
>> At compile time:
>> 1. CONFIG_CRYPTO_AVX512 is enabled
>> 2. toolchain(assembler) supports VPCLMULQDQ instructions
>> At runtime:
>> 1. VPCLMULQDQ and AVX512VL features are supported on a platform (currently
>>     only Icelake)
>> 2. If compiled as built-in module, ghash_clmulni_intel.use_avx512 is set at
>>     boot time or /sys/module/ghash_clmulni_intel/parameters/use_avx512 is set
>>     to 1 after boot.
>>     If compiled as loadable module, use_avx512 module parameter must be set:
>>     modprobe ghash_clmulni_intel use_avx512=1
>>
>> With new implementation, tcrypt ghash speed test shows about 4x to 10x
>> speedup improvement for GHASH calculation compared to the original
>> implementation with PCLMULQDQ when the bytes per update size is 256 Bytes
>> or above. Detailed results for a variety of block sizes and update
>> sizes are in the table below. The test was performed on Icelake based
>> platform with constant frequency set for CPU.
>>
>> The average performance improvement of the AVX512 version over the current
>> implementation is as follows:
>> For bytes per update >= 1KB, we see the average improvement of 882%(~8.8x).
>> For bytes per update < 1KB, we see the average improvement of 370%(~3.7x).
>>
>> A typical run of tcrypt with GHASH calculation with PCLMULQDQ instruction
>> and VPCLMULQDQ instruction shows the following results.
>>
>> ---------------------------------------------------------------------------
>> |            |            |         cycles/operation         |            |
>> |            |            |       (the lower the better)     |            |
>> |    byte    |   bytes    |----------------------------------| percentage |
>> |   blocks   | per update |   GHASH test   |   GHASH test    | loss/gain  |
>> |            |            | with PCLMULQDQ | with VPCLMULQDQ |            |
>> |------------|------------|----------------|-----------------|------------|
>> |      16    |     16     |       144      |        233      |   -38.0    |
>> |      64    |     16     |       535      |        709      |   -24.5    |
>> |      64    |     64     |       210      |        146      |    43.8    |
>> |     256    |     16     |      1808      |       1911      |    -5.4    |
>> |     256    |     64     |       865      |        581      |    48.9    |
>> |     256    |    256     |       682      |        170      |   301.0    |
>> |    1024    |     16     |      6746      |       6935      |    -2.7    |
>> |    1024    |    256     |      2829      |        714      |   296.0    |
>> |    1024    |   1024     |      2543      |        341      |   645.0    |
>> |    2048    |     16     |     13219      |      13403      |    -1.3    |
>> |    2048    |    256     |      5435      |       1408      |   286.0    |
>> |    2048    |   1024     |      5218      |        685      |   661.0    |
>> |    2048    |   2048     |      5061      |        565      |   796.0    |
>> |    4096    |     16     |     40793      |      27615      |    47.8    |
>> |    4096    |    256     |     10662      |       2689      |   297.0    |
>> |    4096    |   1024     |     10196      |       1333      |   665.0    |
>> |    4096    |   4096     |     10049      |       1011      |   894.0    |
>> |    8192    |     16     |     51672      |      54599      |    -5.3    |
>> |    8192    |    256     |     21228      |       5284      |   301.0    |
>> |    8192    |   1024     |     20306      |       2556      |   694.0    |
>> |    8192    |   4096     |     20076      |       2044      |   882.0    |
>> |    8192    |   8192     |     20071      |       2017      |   895.0    |
>> ---------------------------------------------------------------------------
>>
>> This work was inspired by the AES GCM mode optimization published
>> in Intel Optimized IPSEC Cryptographic library.
>> https://github.com/intel/intel-ipsec-mb/lib/avx512/gcm_vaes_avx512.asm
>>
>> Co-developed-by: Greg Tucker <greg.b.tucker@intel.com>
>> Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
>> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
>> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
>> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
>> Co-developed-by: Megha Dey <megha.dey@intel.com>
>> Signed-off-by: Megha Dey <megha.dey@intel.com>
> Hello Megha,
>
> What is the purpose of this separate GHASH module? GHASH is only used
> in combination with AES-CTR to produce GCM, and this series already
> contains a GCM driver.
>
> Do cores exist that implement PCLMULQDQ but not AES-NI?
>
> If not, I think we should be able to drop this patch (and remove the
> existing PCLMULQDQ GHASH driver as well)

AFAIK, dm-verity (authenticated but not encrypted file system) is one 
use case for authentication only.

Although I am not sure if GHASH is specifically used for this or SHA?

Also, I do not know of any cores that implement PCLMULQDQ and not AES-NI.

Megha


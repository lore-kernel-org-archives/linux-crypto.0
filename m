Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10569C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 06:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78092395A
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 06:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbhATXnu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 18:43:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:63848 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390953AbhATXQ4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 18:16:56 -0500
IronPort-SDR: rKkLTyjplmBFVaHt6do2dNFAezJins6Pmd0cIfgve6P0/BV2R9o2rCwShhSJ20IL3I1DrqUNmo
 StFIQWplSecQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="166283778"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="166283778"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 14:38:46 -0800
IronPort-SDR: zolBOEUHtbelebkdFAiHWg8eHG7cz9/esoy2XeQanwIXe7LH/OUMUIcrkBNsp6QNgdRqw6V8pk
 JwEsAQ41Iz5Q==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="366538808"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.255.228.129]) ([10.255.228.129])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 14:38:44 -0800
Subject: Re: [RFC V1 1/7] x86: Probe assembler capabilities for VAES and
 VPLCMULQDQ support
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, Dave Hansen <dave.hansen@intel.com>,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com,
        X86 ML <x86@kernel.org>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-2-git-send-email-megha.dey@intel.com>
 <CAMj1kXGJD1FdixURybqZEOJV+h1-QESp=WCJVPo-Bvd7Zh9j1Q@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <ea72956e-aa3c-4ce6-436d-34e5e701c242@intel.com>
Date:   Wed, 20 Jan 2021 14:38:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGJD1FdixURybqZEOJV+h1-QESp=WCJVPo-Bvd7Zh9j1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 1/16/2021 8:54 AM, Ard Biesheuvel wrote:
> On Fri, 18 Dec 2020 at 22:07, Megha Dey <megha.dey@intel.com> wrote:
>> This is a preparatory patch to introduce the optimized crypto algorithms
>> using AVX512 instructions which would require VAES and VPLCMULQDQ support.
>>
>> Check for VAES and VPCLMULQDQ assembler support using AVX512 registers.
>>
>> Cc: x86@kernel.org
>> Signed-off-by: Megha Dey <megha.dey@intel.com>
>> ---
>>   arch/x86/Kconfig.assembler | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
>> index 26b8c08..9ea0bc8 100644
>> --- a/arch/x86/Kconfig.assembler
>> +++ b/arch/x86/Kconfig.assembler
>> @@ -1,6 +1,16 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>>
>> +config AS_VAES_AVX512
>> +       def_bool $(as-instr,vaesenc %zmm0$(comma)%zmm1$(comma)%zmm1) && 64BIT
> Is the '&& 64BIT' necessary here, but not below?
>
> In any case, better to use a separate 'depends on' line, for legibility

yeah , I think the '&& 64 BIT' is not required. I will remove it in the 
next version.

-Megha

>
>> +       help
>> +         Supported by binutils >= 2.30 and LLVM integrated assembler
>> +
>> +config AS_VPCLMULQDQ
>> +       def_bool $(as-instr,vpclmulqdq \$0$(comma)%zmm2$(comma)%zmm6$(comma)%zmm4)
>> +       help
>> +         Supported by binutils >= 2.30 and LLVM integrated assembler
>> +
>>   config AS_AVX512
>>          def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
>>          help
>> --
>> 2.7.4
>>

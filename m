Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6402CC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBB422510
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 10:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbhAKKw5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:52:57 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:31062 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbhAKKw5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 05:52:57 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 11 Jan
 2021 18:52:10 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 11 Jan
 2021 18:52:07 +0800
Subject: Re: [PATCH v1 1/3] x86/cpufeatures: Add low performance CRC32C
 instruction CPU feature
To:     Borislav Petkov <bp@alien8.de>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <tony.luck@intel.com>, <dave.hansen@intel.com>,
        <seanjc@google.com>, <fenghua.yu@intel.com>,
        <thomas.lendacky@amd.com>, <kyung.min.park@intel.com>,
        <kim.phillips@amd.com>, <mgross@linux.intel.com>,
        <peterz@infradead.org>, <krish.sadhukhan@oracle.com>,
        <liam.merwick@oracle.com>, <mlevitsk@redhat.com>,
        <reinette.chatre@intel.com>, <babu.moger@amd.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <1610000348-17316-2-git-send-email-TonyWWang-oc@zhaoxin.com>
 <20210107063750.GA14697@zn.tnic>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <871e93d3-701e-86cd-6454-19fbb083d0c5@zhaoxin.com>
Date:   Mon, 11 Jan 2021 18:51:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210107063750.GA14697@zn.tnic>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 07/01/2021 14:37, Borislav Petkov wrote:
> On Thu, Jan 07, 2021 at 02:19:06PM +0800, Tony W Wang-oc wrote:
>> SSE4.2 on Zhaoxin CPUs are compatible with Intel. The presence of
>> CRC32C instruction is enumerated by CPUID.01H:ECX.SSE4_2[bit 20] = 1.
>> Some Zhaoxin CPUs declare support SSE4.2 instruction sets but their
>> CRC32C instruction are working with low performance.
>>
>> Add a synthetic CPU flag to indicates that the CRC32C instruction is
>> not working as intended. This low performance CRC32C instruction flag
>> is depend on X86_FEATURE_XMM4_2.
>>
>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 84b8878..9e8151b 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -292,6 +292,7 @@
>>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
>> +#define X86_FEATURE_CRC32C		(11*32+ 8) /* "" Low performance CRC32C instruction */
> 
> Didn't hpa say to create a BUG flag for it - X86_BUG...? Low performance
> insn sounds like a bug and not a feature to me.
> 
> And call it X86_BUG_CRC32C_SLOW or ..._UNUSABLE to denote what it means.
> 

This issue will be enhanced by hardware and patch submit will be pending.

Sincerely
Tonyw


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6313C433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DEBB22A83
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 15:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732700AbhAKPWL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 10:22:11 -0500
Received: from terminus.zytor.com ([198.137.202.136]:42433 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbhAKPWK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 10:22:10 -0500
Received: from [IPv6:2601:646:8680:a581:a9e0:c11f:a526:e0f6] ([IPv6:2601:646:8680:a581:a9e0:c11f:a526:e0f6])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 10BFKY171008008
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Mon, 11 Jan 2021 07:20:35 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 10BFKY171008008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2020122501; t=1610378438;
        bh=vwych3g6kd2B7PEaiLOn+znZEnaaw/IxZDstfNfdYSU=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=snforGX2nUUPKlsgUV+7isdPOXU4cyemVT7F0d2NtEC+dlTBF83ch5CV3Bg1uceBG
         IkhM4AWNxhm2yh69Fx+7EuT8L9TFRLh8T2ZApgqesjYTIm/VlGhQmSGiqampxhyGwP
         VXAK7vV7E+i1olI7u+LhOGXS6y8vmTl1mvCzZqyLRpjB5LmusdDuhqQo23M5i9cir2
         BaOUOxvIreCjS7MVR37Ri/8Ego7uxTFwxBfpnwb8fjuncxCCNsmNg1Vp0JjEzv0m44
         6DQprld21LgfFjlwnALdCGLopK70gCAryVriE6W9CJKATPMYf0mEvO4KW6mOSC77XL
         vwqg6jblrlhsQ==
Date:   Mon, 11 Jan 2021 07:20:25 -0800
User-Agent: K-9 Mail for Android
In-Reply-To: <20210107063750.GA14697@zn.tnic>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com> <1610000348-17316-2-git-send-email-TonyWWang-oc@zhaoxin.com> <20210107063750.GA14697@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 1/3] x86/cpufeatures: Add low performance CRC32C instruction CPU feature
To:     Borislav Petkov <bp@alien8.de>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
CC:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        tony.luck@intel.com, dave.hansen@intel.com, seanjc@google.com,
        fenghua.yu@intel.com, thomas.lendacky@amd.com,
        kyung.min.park@intel.com, kim.phillips@amd.com,
        mgross@linux.intel.com, peterz@infradead.org,
        krish.sadhukhan@oracle.com, liam.merwick@oracle.com,
        mlevitsk@redhat.com, reinette.chatre@intel.com, babu.moger@amd.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
From:   hpa@zytor.com
Message-ID: <A96ECD10-F51F-408C-80DF-5937DF43D314@zytor.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On January 6, 2021 10:37:50 PM PST, Borislav Petkov <bp@alien8=2Ede> wrote:
>On Thu, Jan 07, 2021 at 02:19:06PM +0800, Tony W Wang-oc wrote:
>> SSE4=2E2 on Zhaoxin CPUs are compatible with Intel=2E The presence of
>> CRC32C instruction is enumerated by CPUID=2E01H:ECX=2ESSE4_2[bit 20] =
=3D 1=2E
>> Some Zhaoxin CPUs declare support SSE4=2E2 instruction sets but their
>> CRC32C instruction are working with low performance=2E
>>=20
>> Add a synthetic CPU flag to indicates that the CRC32C instruction is
>> not working as intended=2E This low performance CRC32C instruction flag
>> is depend on X86_FEATURE_XMM4_2=2E
>>=20
>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin=2Ecom>
>> ---
>>  arch/x86/include/asm/cpufeatures=2Eh | 1 +
>>  arch/x86/kernel/cpu/cpuid-deps=2Ec   | 1 +
>>  2 files changed, 2 insertions(+)
>>=20
>> diff --git a/arch/x86/include/asm/cpufeatures=2Eh
>b/arch/x86/include/asm/cpufeatures=2Eh
>> index 84b8878=2E=2E9e8151b 100644
>> --- a/arch/x86/include/asm/cpufeatures=2Eh
>> +++ b/arch/x86/include/asm/cpufeatures=2Eh
>> @@ -292,6 +292,7 @@
>>  #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in
>kernel entry SWAPGS path */
>>  #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split
>lock */
>>  #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread
>Memory Bandwidth Allocation */
>> +#define X86_FEATURE_CRC32C		(11*32+ 8) /* "" Low performance CRC32C
>instruction */
>
>Didn't hpa say to create a BUG flag for it - X86_BUG=2E=2E=2E? Low
>performance
>insn sounds like a bug and not a feature to me=2E
>
>And call it X86_BUG_CRC32C_SLOW or =2E=2E=2E_UNUSABLE to denote what it
>means=2E
>
>Thx=2E

Yes, it should be a BUG due to the inclusion properties of BUG v FEATURE=
=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

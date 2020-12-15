Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD13C4361B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 10:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B30CB221FF
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Dec 2020 10:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgLOKDd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:03:33 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:35729 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgLOKDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 05:03:32 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 15 Dec
 2020 18:02:44 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 15 Dec
 2020 18:02:43 +0800
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Peter Zijlstra <peterz@infradead.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <TimGuo-oc@zhaoxin.com>,
        <CooperYan@zhaoxin.com>, <QiyuanWang@zhaoxin.com>,
        <HerryYang@zhaoxin.com>, <CobeChen@zhaoxin.com>,
        <SilviaZhao@zhaoxin.com>
References: <1607918392-19171-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <20201215085819.GE3040@hirez.programming.kicks-ass.net>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <07c55c37-1ae6-f2c1-e85c-53bb61c77c43@zhaoxin.com>
Date:   Tue, 15 Dec 2020 18:02:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201215085819.GE3040@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 15/12/2020 16:58, Peter Zijlstra wrote:
> On Mon, Dec 14, 2020 at 11:59:52AM +0800, Tony W Wang-oc wrote:
> 
> Didn't I mention something about a comment?
> 
Really sorry for this.

>>  static const struct x86_cpu_id crc32c_cpu_id[] = {
>> +	X86_MATCH_VENDOR_FAM_FEATURE(ZHAOXIN, 0x6, X86_FEATURE_XMM4_2, 1),
>> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x1b, X86_FEATURE_XMM4_2, 1),
>> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x3b, X86_FEATURE_XMM4_2, 1),
>> +	X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 0x6, X86_FEATURE_XMM4_2, 1),
>> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x1b, X86_FEATURE_XMM4_2, 1),
>> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x3b, X86_FEATURE_XMM4_2, 1),
>>  	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, NULL),
>>  	{}
> 
> Also, the above is weird in that is has the negative entries marked
> positive, and 1/NULL are inconsistent.
> 
> Something like so then?
> That's better!

> ---
> 
> diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
> index feccb5254c7e..f6e6669a5102 100644
> --- a/arch/x86/crypto/crc32c-intel_glue.c
> +++ b/arch/x86/crypto/crc32c-intel_glue.c
> @@ -215,14 +215,31 @@ static struct shash_alg alg = {
>  };
>  
>  static const struct x86_cpu_id crc32c_cpu_id[] = {
> -	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, NULL),
> +	/*
> +	 * Negative entries; exclude these chips from using this driver.
> +	 * They match the positive rule below, but their CRC32 instruction
> +	 * implementation is so slow, it doesn't merrit use.
Will fix the typo merrit -> merit and resend the patch.

Sincerely
Tony

> +	 */
> +	X86_MATCH_VENDOR_FAM_FEATURE(ZHAOXIN, 0x6, X86_FEATURE_XMM4_2, false),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x1b, X86_FEATURE_XMM4_2, false),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x3b, X86_FEATURE_XMM4_2, false),
> +	X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 0x6, X86_FEATURE_XMM4_2, false),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x1b, X86_FEATURE_XMM4_2, false),
> +	X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x3b, X86_FEATURE_XMM4_2, false),
> +	/*
> +	 * Positive entry; SSE-4.2 instructions include special purpose CRC32
> +	 * instructions.
> +	 */
> +	X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, true),
>  	{}
>  };
>  MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
>  
>  static int __init crc32c_intel_mod_init(void)
>  {
> -	if (!x86_match_cpu(crc32c_cpu_id))
> +	const struct x86_cpu_id *m = x86_match_cpu(crc32c_cpu_id);
> +
> +	if (!m || !m->driver_data)
>  		return -ENODEV;
>  #ifdef CONFIG_X86_64
>  	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
> .
> 

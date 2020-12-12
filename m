Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5BEC433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 04:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8674723406
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 04:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405429AbgLLEdp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 23:33:45 -0500
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:14120 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389029AbgLLEdS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 23:33:18 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 12 Dec
 2020 12:32:32 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 12 Dec
 2020 12:32:31 +0800
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Peter Zijlstra <peterz@infradead.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <TimGuo-oc@zhaoxin.com>,
        <CooperYan@zhaoxin.com>, <QiyuanWang@zhaoxin.com>,
        <HerryYang@zhaoxin.com>, <CobeChen@zhaoxin.com>,
        <SilviaZhao@zhaoxin.com>, <thomas.lendacky@amd.com>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <20201211130058.GZ2414@hirez.programming.kicks-ass.net>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <757bfaea-04ce-fa92-f990-bcda3d7580d7@zhaoxin.com>
Date:   Sat, 12 Dec 2020 12:32:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201211130058.GZ2414@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/12/2020 21:00, Peter Zijlstra wrote:
> On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
>> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
>> On platforms with Zhaoxin CPUs supporting this X86 feature, When
>> crc32c-intel and crc32c-generic are both registered, system will
>> use crc32c-intel because its .cra_priority is greater than
>> crc32c-generic. This case expect to use crc32c-generic driver for
>> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
>> CPUs support from crc32c-intel.
>>
>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
>> ---
>>  arch/x86/crypto/crc32c-intel_glue.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
>> index feccb52..6dafdae 100644
>> --- a/arch/x86/crypto/crc32c-intel_glue.c
>> +++ b/arch/x86/crypto/crc32c-intel_glue.c
>> @@ -222,8 +222,16 @@ MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
>>  
>>  static int __init crc32c_intel_mod_init(void)
>>  {
>> +	struct cpuinfo_x86 *c = &boot_cpu_data;
>> +
>>  	if (!x86_match_cpu(crc32c_cpu_id))
>>  		return -ENODEV;
>> +
>> +	if (c->x86_vendor == X86_VENDOR_ZHAOXIN || c->x86_vendor == X86_VENDOR_CENTAUR) {
>> +		if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
>> +			return -ENODEV;
>> +	}
> 
> Egads, why can't you use that x86_match_cpu() above, and also this
> really wants a comment on why you're excluding these chips. 

When doing lmbench3 Create and Delete file test on partitions with ext4
enabling metadata checksum, found using crc32c-generic driver could get
about 20% performance gain than using the driver crc32c-intel on these
chips.

Also, since
> (IIRC) ZHAOXIN is basically AND, shouldn't they also be listed?
> 
> That is; write it like:
> 
> 	m = x86_match_cpu(crc32_cpu_id);
> 	if (!m || !m->data)
> 		return -ENODEV;
> 
> That way you can have positive and negative matches in the array
> (obviously the existing FEATURE test would need data=1 and be last).
> .
> 

Lot thanks for you suggestion, will list these chips in crc32c_cpu_id
and use x86_match_cpu:

 static const struct x86_cpu_id crc32c_cpu_id[] = {
+       X86_MATCH_VENDOR_FAM_FEATURE(ZHAOXIN, 0x6, X86_FEATURE_XMM4_2, 1),
+       X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x1b,
X86_FEATURE_XMM4_2, 1),
+       X86_MATCH_VENDOR_FAM_MODEL_FEATURE(ZHAOXIN, 0x7, 0x3b,
X86_FEATURE_XMM4_2, 1),
+       X86_MATCH_VENDOR_FAM_FEATURE(CENTAUR, 0x6, X86_FEATURE_XMM4_2, 1),
+       X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x1b,
X86_FEATURE_XMM4_2, 1),
+       X86_MATCH_VENDOR_FAM_MODEL_FEATURE(CENTAUR, 0x7, 0x3b,
X86_FEATURE_XMM4_2, 1),
        X86_MATCH_FEATURE(X86_FEATURE_XMM4_2, NULL),
        {}
 };
@@ -228,8 +234,10 @@ MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);

 static int __init crc32c_intel_mod_init(void)
 {
-       if (!x86_match_cpu(crc32c_cpu_id))
+       const struct x86_cpu_id *m = x86_match_cpu(crc32c_cpu_id);
+       if (!m || m->driver_data)
                return -ENODEV;


sincerely
TonyWWangoc

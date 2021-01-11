Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924B7C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 10:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 514D72222D
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 10:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbhAKKzA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:55:00 -0500
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:24162 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbhAKKzA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 05:55:00 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 11 Jan
 2021 18:54:16 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 11 Jan
 2021 18:54:13 +0800
Subject: Re: [PATCH v1 2/3] x86/cpu: Set low performance CRC32C flag on some
 Zhaoxin CPUs
To:     Dave Hansen <dave.hansen@intel.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <seanjc@google.com>, <fenghua.yu@intel.com>,
        <thomas.lendacky@amd.com>, <kyung.min.park@intel.com>,
        <kim.phillips@amd.com>, <mgross@linux.intel.com>,
        <peterz@infradead.org>, <krish.sadhukhan@oracle.com>,
        <liam.merwick@oracle.com>, <mlevitsk@redhat.com>,
        <reinette.chatre@intel.com>, <babu.moger@amd.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <1610000348-17316-3-git-send-email-TonyWWang-oc@zhaoxin.com>
 <607494aa-674a-fe93-50f6-2c45f385f7e9@intel.com>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <6d2f1d21-635d-d359-ee2c-ce0665f519d7@zhaoxin.com>
Date:   Mon, 11 Jan 2021 18:54:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <607494aa-674a-fe93-50f6-2c45f385f7e9@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/01/2021 23:52, Dave Hansen wrote:
> On 1/6/21 10:19 PM, Tony W Wang-oc wrote:
>> +	/*
>> +	 * These CPUs declare support SSE4.2 instruction sets but
>> +	 * having low performance CRC32C instruction implementation.
>> +	 */
>> +	if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
>> +		set_cpu_cap(c, X86_FEATURE_CRC32C);
>>  }
> 
> On the Intel side, we've tried to move away from open-coded model
> numbers.  Say another CPU is released that has a microarchitecture close
> to 0x3b, but has a model of 0x3c.  It's a *LOT* easier to grep for
> INTEL_FAM6_NEHALEM (or whatever) than 0x3c.  See:
> 
> 	arch/x86/include/asm/intel-family.h
> 
> for examples.
> .
> 

Got it, thanks for your suggestion.

Sincerely
Tonyw

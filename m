Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40D2C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CC722CF8
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbhAGG1t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:27:49 -0500
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:46886 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbhAGG1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 01:27:48 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:27:06 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:27:04 +0800
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
References: <1608028091-29439-1-git-send-email-TonyWWang-oc@zhaoxin.com>
 <20210102211200.GA1750@gondor.apana.org.au>
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Message-ID: <464482ed-bce6-7e55-bd34-b3be736a6e8b@zhaoxin.com>
Date:   Thu, 7 Jan 2021 14:27:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210102211200.GA1750@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 03/01/2021 05:12, Herbert Xu wrote:
> On Tue, Dec 15, 2020 at 06:28:11PM +0800, Tony W Wang-oc wrote:
>> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
>> On platforms with Zhaoxin CPUs supporting this X86 feature, when
>> crc32c-intel and crc32c-generic are both registered, system will
>> use crc32c-intel because its .cra_priority is greater than
>> crc32c-generic.
>>
>> When doing lmbench3 Create and Delete file test on partitions with
>> ext4 enabling metadata checksum, found using crc32c-generic driver
>> could get about 20% performance gain than using the driver crc32c-intel
>> on some Zhaoxin CPUs.
>>
>> This case expect to use crc32c-generic driver for these Zhaoxin CPUs
>> to get performance gain, so remove these Zhaoxin CPUs support from
>> crc32c-intel.
>>
>> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
>> ---
>>  arch/x86/crypto/crc32c-intel_glue.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> This does not seem to address the latest comment from hpa.
> 

Yes, please ignore this patch. Have send new patch set per Hpa's suggestion.

Sincerely
Tonyw

> Thanks,
> 

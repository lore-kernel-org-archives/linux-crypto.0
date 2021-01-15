Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE36C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 01:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA88F23A5A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 01:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbhAOBoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 20:44:19 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:10351 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731508AbhAOBoS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 20:44:18 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 15 Jan
 2021 09:43:31 +0800
Received: from [10.32.56.37] (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 15 Jan
 2021 09:43:29 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
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
 <871e93d3-701e-86cd-6454-19fbb083d0c5@zhaoxin.com>
 <20210111110351.GC25645@zn.tnic>
Message-ID: <de54159e-0d0e-5e9e-db6c-5e908c86389f@zhaoxin.com>
Date:   Fri, 15 Jan 2021 09:43:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210111110351.GC25645@zn.tnic>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/01/2021 19:03, Borislav Petkov wrote:
> On Mon, Jan 11, 2021 at 06:51:59PM +0800, Tony W Wang-oc wrote:
>> This issue will be enhanced by hardware and patch submit will be pending.
> 
> I have no clue what that has to do with your current patch... you might
> need to explain more verbosely.
> 

After internal research, decided to fix the low performance crc32c
instruction issue on these Zhaoxin CPUs by microcode. So, do not need
this patch anymore.

Sincerely
Tonyw

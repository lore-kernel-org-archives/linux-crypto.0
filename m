Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39201C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Dec 2020 19:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D9922AEC
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Dec 2020 19:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgL1TLi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Dec 2020 14:11:38 -0500
Received: from mga04.intel.com ([192.55.52.120]:60363 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgL1TLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Dec 2020 14:11:38 -0500
IronPort-SDR: MOwJ5NXs4364hVctFDN4u4bRcNcs/s+u8WP2j0W//eTgDKZzUlO2UXcQrS0nxcCTQf35Bhf388
 0OMoMxnuq5PQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9848"; a="173838833"
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="173838833"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 11:10:57 -0800
IronPort-SDR: euDiD1wjstydV5fvx+0fQkOb0OymbIAmPQAga4osDp76DaJmTV2Ekwp2CM+S3HJvNDjPZiImBc
 5ziaX6/BE1kg==
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400"; 
   d="scan'208";a="459854520"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.254.12.31]) ([10.254.12.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 11:10:56 -0800
Subject: Re: [RFC V1 0/7] Introduce AVX512 optimized crypto algorithms
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        tony.luck@intel.com, ira.weiny@intel.com, x86@kernel.org
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <X+Et0ubPcBVZOURL@sol.localdomain>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <caa90522-14ac-c674-b6f5-22a7d8359a3c@intel.com>
Date:   Mon, 28 Dec 2020 11:10:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X+Et0ubPcBVZOURL@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 12/21/2020 3:20 PM, Eric Biggers wrote:
> On Fri, Dec 18, 2020 at 01:10:57PM -0800, Megha Dey wrote:
>> Optimize crypto algorithms using VPCLMULQDQ and VAES AVX512 instructions
>> (first implemented on Intel's Icelake client and Xeon CPUs).
>>
>> These algorithms take advantage of the AVX512 registers to keep the CPU
>> busy and increase memory bandwidth utilization. They provide substantial
>> (2-10x) improvements over existing crypto algorithms when update data size
>> is greater than 128 bytes and do not have any significant impact when used
>> on small amounts of data.
>>
>> However, these algorithms may also incur a frequency penalty and cause
>> collateral damage to other workloads running on the same core(co-scheduled
>> threads). These frequency drops are also known as bin drops where 1 bin
>> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
>> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
>> are observed on the Icelake server.
>>
> Do these new algorithms all pass the self-tests, including the fuzz tests that
> are enabled when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

I had tested these algorithms with CRYPTO_MANAGER_DISABLE_TESTS=n and 
tcrypt, not with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y (I wasn't aware this existed, my bad).
I see a couple of errors after enabling it and am working on fixing those.

Megha

>
> - Eric

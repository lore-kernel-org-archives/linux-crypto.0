Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC84CC433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 18:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A6B2227C3
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 18:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbhAPSf6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 13:35:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:34785 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727663AbhAPSf6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 13:35:58 -0500
IronPort-SDR: OpYSYeQ+XoZ9OvXwmdjpRydNX3fNgSQrklvanCvXqMswQKN7zwQJzwHCwzP9Z7wzCuEcDfk/6K
 qrTuoQhao6LQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9866"; a="175176646"
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="scan'208";a="175176646"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2021 10:35:17 -0800
IronPort-SDR: GnY77fKiXYavFnIKZdk81hwMunvmCoQzDAPM0H4i+usCOE8dWoBfuJ9SwOnsWI/r4cv9nRxIAE
 /nYvNVQ1YSNg==
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="scan'208";a="401634468"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.212.36.189]) ([10.212.36.189])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2021 10:35:16 -0800
Subject: Re: [RFC V1 0/7] Introduce AVX512 optimized crypto algorithms
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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
 <X+Et0ubPcBVZOURL@sol.localdomain>
 <caa90522-14ac-c674-b6f5-22a7d8359a3c@intel.com>
 <CAMj1kXGFsQMpWCYCB8Vqeq2Kj+WBiXkVv=dom13PJhbR3EZKFQ@mail.gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <07b2cb98-1a3d-0bce-98ff-e0250220e9fd@intel.com>
Date:   Sat, 16 Jan 2021 10:35:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGFsQMpWCYCB8Vqeq2Kj+WBiXkVv=dom13PJhbR3EZKFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On 1/16/2021 8:52 AM, Ard Biesheuvel wrote:
> On Mon, 28 Dec 2020 at 20:11, Dey, Megha <megha.dey@intel.com> wrote:
>> Hi Eric,
>>
>> On 12/21/2020 3:20 PM, Eric Biggers wrote:
>>> On Fri, Dec 18, 2020 at 01:10:57PM -0800, Megha Dey wrote:
>>>> Optimize crypto algorithms using VPCLMULQDQ and VAES AVX512 instructions
>>>> (first implemented on Intel's Icelake client and Xeon CPUs).
>>>>
>>>> These algorithms take advantage of the AVX512 registers to keep the CPU
>>>> busy and increase memory bandwidth utilization. They provide substantial
>>>> (2-10x) improvements over existing crypto algorithms when update data size
>>>> is greater than 128 bytes and do not have any significant impact when used
>>>> on small amounts of data.
>>>>
>>>> However, these algorithms may also incur a frequency penalty and cause
>>>> collateral damage to other workloads running on the same core(co-scheduled
>>>> threads). These frequency drops are also known as bin drops where 1 bin
>>>> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
>>>> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
>>>> are observed on the Icelake server.
>>>>
>>> Do these new algorithms all pass the self-tests, including the fuzz tests that
>>> are enabled when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>> I had tested these algorithms with CRYPTO_MANAGER_DISABLE_TESTS=n and
>> tcrypt, not with
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y (I wasn't aware this existed, my bad).
>> I see a couple of errors after enabling it and am working on fixing those.
>>
> Hello Megha,
>
> I think the GHASH changes can be dropped (as discussed in the other
> thread), given the lack of a use case. The existing GHASH driver could
> also be removed in the future, but I don't think it needs to be part
> of this series.
Ok, I will remove the GHASH patch from the next series.
>
> Could you please rebase this onto the latest AES-NI changes that are
> in Herbert's tree? (as well as the ones I sent out today) They address
> some issues with indirect calls and excessive disabling of preemption,
> and your GCM and CTR changes are definitely going to be affected by
> this as well.
Yeah sure, will do, thanks for the headsup!

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA96C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 05:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED9623A50
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 05:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbhAPFIj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 00:08:39 -0500
Received: from mga07.intel.com ([134.134.136.100]:8963 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbhAPFIj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 00:08:39 -0500
IronPort-SDR: WAYycEPBLpMpDfvR7PYwSmeH0US7LKOBIh+3RzlzlKETV7lkt/IK/ftBhI/nqr2JlVC9qzn59F
 kj+N8d5sYuHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9865"; a="242714444"
X-IronPort-AV: E=Sophos;i="5.79,351,1602572400"; 
   d="scan'208";a="242714444"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 21:07:54 -0800
IronPort-SDR: u3td4UgxEexaKLnafZbBqA/S73h9dHPvHTMC7JKYrOF0EIbV5IUvaTzpzx4fVlfOk/XJkYTSTa
 OApCJGrWG7SA==
X-IronPort-AV: E=Sophos;i="5.79,351,1602572400"; 
   d="scan'208";a="425552013"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.254.14.175]) ([10.254.14.175])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 21:07:52 -0800
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-4-git-send-email-megha.dey@intel.com>
 <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
 <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com> <YAJEu1esw0zPA7Qh@gmail.com>
From:   "Dey, Megha" <megha.dey@intel.com>
Message-ID: <79ecc4a3-3bbb-77b2-4f2c-32ff17719086@intel.com>
Date:   Fri, 15 Jan 2021 21:07:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAJEu1esw0zPA7Qh@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 1/15/2021 5:43 PM, Eric Biggers wrote:
> On Fri, Jan 15, 2021 at 04:14:40PM -0800, Dey, Megha wrote:
>>> Hello Megha,
>>>
>>> What is the purpose of this separate GHASH module? GHASH is only used
>>> in combination with AES-CTR to produce GCM, and this series already
>>> contains a GCM driver.
>>>
>>> Do cores exist that implement PCLMULQDQ but not AES-NI?
>>>
>>> If not, I think we should be able to drop this patch (and remove the
>>> existing PCLMULQDQ GHASH driver as well)
>> AFAIK, dm-verity (authenticated but not encrypted file system) is one use
>> case for authentication only.
>>
>> Although I am not sure if GHASH is specifically used for this or SHA?
>>
>> Also, I do not know of any cores that implement PCLMULQDQ and not AES-NI.
>>
> dm-verity only uses unkeyed hash algorithms.  So no, it doesn't use GHASH.

Hmm, I see. If that is the case, I am not aware of any other use case 
apart from GCM.

I see that the existing GHASH module in the kernel from 2009. I am not 
sure if there was a use case then, which now is no longer valid.

There many be out-of-tree kernel modules which may be using it but again 
its only speculation.

So, in the next version should I remove the existing GHASH module? (And 
of course remove this patch as well?)

-Megha

>
> - Eric

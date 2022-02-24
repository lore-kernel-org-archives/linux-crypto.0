Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FEBC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Feb 2022 19:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiBXTcM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbiBXTcM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Feb 2022 14:32:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047CA39B8B
        for <linux-crypto@vger.kernel.org>; Thu, 24 Feb 2022 11:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645731101; x=1677267101;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+dzLCsJDIFx2Vrlp8MijvZxC3WfWXaviKMozqy7XiIE=;
  b=mVQwVn8QrTPGVNGc6+QNiZVa5scbm3rNcEAdB6Aiwb5n2lwC6cKvX2T3
   whedYXY3dcH0wdMdbnK698fyGVUzrN8OuwaLPGYbME1Jx0Ke9YgHpq0gR
   89CCwFwQWk7ANSHV/kM+FNOUG0s8yq//LaYcnSbo0gkStkeap28ZHQfsW
   J4Jxembg3+lDQY46BC4J0qpgWNAW3ElPJIK9Wwg9Ip9J+AZFyqSD9ZFcT
   6zF+mfLb12eDR7JkLTpFsXMzzmPrh1Ksi1U2yfBeKq/J7rnRv/YcYeXrY
   y8gl8ov1kwFjVQaQkj6GfyN89aXlTiqQaq+lx1D7w+cY4TGC0LBBLxQLN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="315550851"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="315550851"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 11:31:33 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="777169770"
Received: from meghadey-mobl1.amr.corp.intel.com (HELO [10.213.47.95]) ([10.213.47.95])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 11:31:22 -0800
Message-ID: <0a21fe4d-b135-3696-71f0-aa14ca715d51@intel.com>
Date:   Thu, 24 Feb 2022 11:31:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, greg.b.tucker@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, Weiny Ira <ira.weiny@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, X86 ML <x86@kernel.org>,
        anirudh.venkataramanan@intel.com
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
 <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
 <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
 <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
 <e8ce1146-3952-6977-1d0e-a22758e58914@intel.com>
 <0a10e16b-df77-9a7f-6964-8dc3e114b30b@intel.com>
From:   "Dey, Megha" <megha.dey@intel.com>
In-Reply-To: <0a10e16b-df77-9a7f-6964-8dc3e114b30b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

On 1/31/2022 11:18 AM, Dave Hansen wrote:
> On 1/31/22 10:43, Dey, Megha wrote:
>> With this implementation, we see a 1.5X improvement on ICX/ICL for 16KB
>> buffers compared to the existing kernel AES-GCM implementation that
>> works on 128-bit XMM registers.
> What is your best guess about how future-proof this implementation is?
>
> Will this be an ICL/ICX one-off?  Or, will implementations using 256-bit
> YMM registers continue to enjoy a frequency advantage over the 512-bit
> implementations for a long time?

Dave,

This would not be an ICL/ICX one off. For the foreseeable future, 
AVX512VL YMM implementations will enjoy a frequency advantage over 
AVX512L ZMM implementations.

Although, over time, ZMM and YMM will converge when it comes to performance.

Herbert/Andy,

Could you please let us know if this approach is a viable one and would 
be acceptable by the community?

Optimizing crypto algorithms using AVX512VL instructions gives a 1.5X 
performance improvement over existing AES-GCM algorithm in the 
kernel(using XMM registers) with no frequency drop.

Thanks,

Megha


Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEEAC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 16:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiBAQmc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 11:42:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:45775 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241161AbiBAQmb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 11:42:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643733751; x=1675269751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Betlh+msQmMcjNP0dLelGhVQE76lOFcTrYR3ayu3hAk=;
  b=Lf0NzKZ+xCtdC3hVsxtsEPIiZ2a7nV1PbdcyDoYyAh8uKsIHLedbnBB5
   poiB/GphxUES9bKngEMt/YdfR7bXzlRn5bM6tLGptrXKCn33wPjDBQ01k
   6I6Urhxs3oPcPHwzkAE8IPViqFWwLC4WpndMn93baRvBpASOCuvJb78bi
   WD13vPDtb21j4qTft8/94zmd/G0NfYjlY4MFfxoPxACrNXuHbkhINdCPZ
   K4IwfyCs4f6dx+HZFgw0E21E92EyTGC+Z6sX7EIq8S65dWtKF4dZuJz3M
   d65xu1gL+I05+y/5eV5c2ROyhpPBQ2c45DfC6tf2tTJmdoHYuyV3acx2E
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="231302401"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="231302401"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 08:42:11 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="565645614"
Received: from sebough-mobl.amr.corp.intel.com (HELO [10.212.35.72]) ([10.212.35.72])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 08:42:10 -0800
Message-ID: <f932019c-f83c-3847-b70b-fa7eb57662de@intel.com>
Date:   Tue, 1 Feb 2022 08:42:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, greg.b.tucker@intel.com,
        "Kasten, Robert A" <robert.a.kasten@intel.com>,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        Kyung Min Park <kyung.min.park@intel.com>,
        Weiny Ira <ira.weiny@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, X86 ML <x86@kernel.org>
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

Hi Dave,

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
This is not planned as ICL/ICX one-off.AVX512VL code using YMM registers 
is expected to have the same power license properties as AVX2 code which 
implies it would have a frequency advantage over the current AVX512 
implementation until we have new implementations of AVX512 instructions 
which do not have the frequency drop issue.

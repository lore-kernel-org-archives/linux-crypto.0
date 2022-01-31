Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A646C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 19:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiAaTSy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:18:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:50518 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244151AbiAaTSy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 14:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643656734; x=1675192734;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=4cWRWKgSilAN/g7tM1/aIXkv1ERGqhDlMGjd2wXvSPk=;
  b=au20vETgXs8+C1CjEgr+yqUt7UMn3G4gq7qt6loV8i7AvA9M0kWc62NV
   qerLJuM5ttAgDQJon9H/LgAbi/hHA0k+In0Mf9aZ0nRUWFncH7k2IdA7Q
   oMrKFrkvdIpgKNnjv0uRF+ecex6kWp5Kt91S9sX6ROv41ZW55uSBWoPPC
   9fa3wvB0oZvV6rMcl405wb3epcWOCCJs+lNNVtd3YpN1vKp6QXkQho+l0
   pESlI5I2B59OByUuVVgnmcnruITEELD3FYtojKlwm9agAxXuvwsiY1dmY
   Ux17NfwOHgWkUCFkm9TL6zS7NL+aqvpdVqzfY7DBUxOPSawnottp579rm
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234925688"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="234925688"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:18:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="630127991"
Received: from kcoopwoo-mobl1.amr.corp.intel.com (HELO [10.252.132.7]) ([10.252.132.7])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:18:53 -0800
Message-ID: <0a10e16b-df77-9a7f-6964-8dc3e114b30b@intel.com>
Date:   Mon, 31 Jan 2022 11:18:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.2
Content-Language: en-US
To:     "Dey, Megha" <megha.dey@intel.com>,
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
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
In-Reply-To: <e8ce1146-3952-6977-1d0e-a22758e58914@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/22 10:43, Dey, Megha wrote:
> With this implementation, we see a 1.5X improvement on ICX/ICL for 16KB
> buffers compared to the existing kernel AES-GCM implementation that
> works on 128-bit XMM registers.

What is your best guess about how future-proof this implementation is?

Will this be an ICL/ICX one-off?  Or, will implementations using 256-bit
YMM registers continue to enjoy a frequency advantage over the 512-bit
implementations for a long time?

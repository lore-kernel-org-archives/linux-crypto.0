Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D354C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 17:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKERbl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 13:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKERbk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 13:31:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A821E140E8
        for <linux-crypto@vger.kernel.org>; Sat,  5 Nov 2022 10:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667669499; x=1699205499;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=MmeMSDfkrXBfCIwHDssJuZYjNJh55XLRtuGA0r9cT1c=;
  b=aKF6sVCTSOfXSrpPX48aNPQYdeopmAP4ULgKHli45H2JOVTVihhxNmDi
   f1uQ1qj1kXWncmb7/GBdL81IZWU4+1Przx5nHqnmXAVTUc0zdL7lv+Kj6
   uTDjYNgkMAzc3a2c5ZsxW2DTv9hBpFDdi+ymNBnO4Y3vpwrWNPuvd9A+w
   2NvcOrCyTp5iAc3QS6UIH7xx9MLvhVtIzaZl/pA5EmGzYgiK7uGGCwtXi
   RjXxd5pa05+Mif+EISQM/scryYLhq1x8hc1hkpQr9xnjwXB7Zl1QLlX62
   ac6SFIe97xZ7HXffKJ7NmgjWTtagHZmYSzbfw3X/n41Eq24KLjjB+GfO0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10522"; a="293530364"
X-IronPort-AV: E=Sophos;i="5.96,140,1665471600"; 
   d="scan'208";a="293530364"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2022 10:31:39 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10522"; a="668703156"
X-IronPort-AV: E=Sophos;i="5.96,140,1665471600"; 
   d="scan'208";a="668703156"
Received: from hanhn2-mobl1.amr.corp.intel.com (HELO [10.212.197.172]) ([10.212.197.172])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2022 10:31:38 -0700
Message-ID: <d438e0d8-7469-7584-405b-76006372c2d4@intel.com>
Date:   Sat, 5 Nov 2022 10:31:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 3/3] crypto: aria: implement aria-avx512
Content-Language: en-US
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
References: <20221105082021.17997-1-ap420073@gmail.com>
 <20221105082021.17997-4-ap420073@gmail.com>
 <MW5PR84MB1842E11FD1CF7B44703A42B0AB3A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <MW5PR84MB1842E11FD1CF7B44703A42B0AB3A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/5/22 09:20, Elliott, Robert (Servers) wrote:
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -288,6 +288,10 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
>         struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
>         int err;
> 
> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_enc) != 0);
> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_dec) != 240);
> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_length) != 480);

We have a nice fancy way of doing these.  See things like
CPU_ENTRY_AREA_entry_stack or TSS_sp0.  It's all put together from
arch/x86/kernel/asm-offsets.c and gets plopped in
include/generated/asm-offsets.h.

This is vastly preferred to hard-coded magic number offsets, even if
they do have a BUILD_BUG_ON() somewhere.

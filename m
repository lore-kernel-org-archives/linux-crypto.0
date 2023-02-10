Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E9CC05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 19:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbjBJTT6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjBJTT5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 14:19:57 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0E17D88E
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 11:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676056797; x=1707592797;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i7BcD5d7W/SqR71NcspbqtDXJmD/toZTCx4+Rh6DgiM=;
  b=m6NbrFyhMqBtAWlpnhYJVAEToF9VpTD0B0uoSNXv2mWRe17F7FDx6cJt
   n86KahOKJX4ErUSY+0KK/eLv13QGjNcaULi4iHibv26I8ZI6+73nHWtF6
   OVjjGTrXCLXUjMW2iGSdzdRO5BVA+UvZdP5rr9EpbyJfWEysUG0pJsoFW
   hnRNebI3+aL/2zHWl0h2BhiAHgQp6A3gMKK8dq4EgFNhCnBjixiHazSRP
   u7iJGGYMV8kuz/dowO0CzOkBOz2pgzpwcqfalwmajJy44Fjd0hDwrX8lI
   bKxw830492mCHKK9lMfuqd0F671WRW+CuIJ6yHaPcsDuQ8nCritC5dc6h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="310868092"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="310868092"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:19:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="670099891"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="670099891"
Received: from hyekyung-mobl1.amr.corp.intel.com (HELO [10.209.82.221]) ([10.209.82.221])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:19:56 -0800
Message-ID: <d31209ec-ba33-3326-be58-d227c2be8c6d@intel.com>
Date:   Fri, 10 Feb 2023 11:19:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, x86@kernel.org
Cc:     erhard_f@mailbox.org
References: <20230210181541.2895144-1-ap420073@gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230210181541.2895144-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/10/23 10:15, Taehee Yoo wrote:
> vpbroadcastb and vpbroadcastd are not AVX instructions.
> But the aria-avx assembly code contains these instructions.
> So, kernel panic will occur if the aria-avx works on AVX2 unsupported
> CPU.
...
> My CPU supports AVX2.
> So, I disabled AVX2 with QEMU.
> In the VM, lscpu doesn't show AVX2, but kernel panic didn't occur.
> Therefore, I couldn't reproduce kernel panic.
> I will really appreciate it if someone test this patch.

So, someone reported this issue and you _think_ you know what went
wrong.  But, you can't reproduce the issue so it sounds like you're not
confident if this is the right fix or if you are fixing the right
problem in the first place.

We can certainly apply obvious fixes, but it would be *really* nice if
you could try a bit harder to reproduce this.

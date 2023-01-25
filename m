Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE15C54E94
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Jan 2023 16:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbjAYQPV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Jan 2023 11:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYQPU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2023 11:15:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584FC30EB;
        Wed, 25 Jan 2023 08:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674663319; x=1706199319;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T/lcPQT2YnqHNhI7wuxUl84yk2/vgVT1L52WHsP5bXk=;
  b=BivQQkuEFQNnFJvmcM8pAeykDpnk2clZZORzV17UaY8EOQwGTYiTnUWD
   n6OrDjb8+FDv/CMmFTUR1ryX9zDGO25qlgnWSdu1wgqc9Lx8bRNSKcgNX
   5vtUiPh+ZClbzh3YReFrVNOh5w3ZGUXJ3oUKvClOS8ZXhYRMxPZs+G8Wc
   1uS5fRpaTZ+ZK/oFQpnLkPPSFm3c8cye75JHeBQ//FsIM2HGSO04td5+I
   lXX1h2I3GNN2fDqe553ReKoT5Ws9JN0bwJ0/M8xr0u4Uyam47xC7ri1CR
   R/am1Zkx9xmbHT//K3O+xuLlsY4h6BE7ZPirCO8dwGNiS/MyK3y6edYbs
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="327849368"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="327849368"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 08:15:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="751256459"
X-IronPort-AV: E=Sophos;i="5.97,245,1669104000"; 
   d="scan'208";a="751256459"
Received: from zguo4-mobl1.amr.corp.intel.com (HELO [10.209.50.216]) ([10.209.50.216])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 08:15:17 -0800
Message-ID: <ba4420b1-ea8c-d75d-2c4a-f0e7a6d01c6b@intel.com>
Date:   Wed, 25 Jan 2023 08:15:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] x86: enable Data Operand Independent Timing Mode
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Roxana Bradescu <roxabee@chromium.org>,
        Adam Langley <agl@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20230125012801.362496-1-ebiggers@kernel.org>
 <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/25/23 07:29, Dave Hansen wrote:
> There's another part here which I think was recently added to the
> documentation:
> 
> 	Intel expects the performance impact of this mode may be
> 	significantly higher on future processors. 
> 
> That's _meant_ to be really scary and keep folks from turning this on by
> default, aka. what this patch does.  Your new CPU will be really slow if
> you turn this on!  Boo!

*If* we go forward with this patch's approach in the kernel, I think we
should at least consider what the kernel will do in a future where there
are two classes of systems:

	1. Ice Lake era ones where DOITM=1 is cheap enough that it can
	   on by default.
	2. "Future processors" where DOITM=1 by default is too costly.

Maybe for #2 we set DOITM=0 in the kernel.  Maybe we add per-task
controls.

But, there *is* DOITM cost where the large fleets are going to be
tempted to turn it off somehow, somewhere.  The kernel will be better
off if we can design that in now.

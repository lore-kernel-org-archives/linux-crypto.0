Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4BFC38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 18:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjBASJU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBASJT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 13:09:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73287B78E;
        Wed,  1 Feb 2023 10:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675274958; x=1706810958;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DzB41kqRjG9qUWIA0y3gZ/k7RV+zOm/shnhJdtIANr0=;
  b=GSPagN+Zy2w1l80TvnlovsGmqGorCtM7YlIatGsyMtTP6Vc9nczzAhHd
   s+zjHR8JXodQCxpD2xbnFdAOC6TKurvn51cWF80ce4TMd27L+S4Awbj3k
   WLRsoyQakCHYD9NIX9R+46s5hhcDt4NzUfLX/xRTDeKEHpymCnozv0tLk
   8wvtwUOP+KfcrHeGEevD6uxKL8oyz+Yeg1hYBRK29/5APVIZOKVUEK3kY
   uvDjZbhaODUdun5mVHw1wwVBeaigbNalYNVMlmfy20LN2KvI20vCl4fGO
   asIHo37/E/98hsbDnyIMHYZ6fBP+3hw1TGFsUzShSyAAXaueIka+6Efli
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="414431226"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="414431226"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:09:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993782516"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="993782516"
Received: from sgkhacha-mobl1.amr.corp.intel.com (HELO [10.212.227.86]) ([10.212.227.86])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:09:17 -0800
Message-ID: <c5809098-9066-d90d-1bcc-108a11525cac@intel.com>
Date:   Wed, 1 Feb 2023 10:09:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] x86: enable Data Operand Independent Timing Mode
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Roxana Bradescu <roxabee@chromium.org>,
        Adam Langley <agl@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20230125012801.362496-1-ebiggers@kernel.org>
 <14506678-918f-81e1-2c26-2b347ff50701@intel.com>
 <CAG48ez1NaWarARJj5SBdKKTYFO2MbX7xO75Rk0Q2iK8LX4BwFA@mail.gmail.com>
 <394c92e2-a9aa-37e1-7a34-d7569ac844fd@intel.com>
 <CAG48ez0ZK3pMqkto4DTZPNyddYcv8jPHQDNhYoFEPvSRLf80fQ@mail.gmail.com>
 <e37a17c4-8611-6d1d-85ad-fcd04ff285e1@intel.com> <Y9MAvhQYlOe4l2BM@gmail.com>
 <8b2771ce-9cfa-54cc-de6b-e80ce7af0a93@intel.com>
 <16e3217b-1561-51ea-7514-014e27240402@intel.com>
 <Y9oMmYWzy7mlk3D9@sol.localdomain>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y9oMmYWzy7mlk3D9@sol.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/23 22:54, Eric Biggers wrote:
> On Tue, Jan 31, 2023 at 02:48:05PM -0800, Dave Hansen wrote:
>> We've been talking about this inside Intel.  Suffice to say that DOITM
>> was not designed to be turned on all the time.  If software turns it on
>> all the time, it won't accomplish what it was designed to do.
> 
> Why wouldn't it accomplish what it is designed to do?  Does it not actually
> work?

It was designed with the idea that timing-sensitive and *ONLY*
timing-sensitive code would be wrapped with DOITM.  Wrapping that code
would allow the rest of the system to safely operate with fancy new
optimizations that exhibit data dependent timing.

But, first of all, that code isn't wrapped with DOITM-prodding APIs
today.  That model falls apart with current software on current DOITM
implementations.

Second, we consider the kernel in general to be timing-sensitive enough
that we want DOITM=1 behavior in the kernel.

Those lead software folks to set DOITM=1 on all the time.  The fallout
from that is that nobody will ever use those fancy new optimizations.
If nobody can take advantage of them, silicon shouldn't be wasted on
them in the first place.

Basically, DOITM was meant to open the door for adding fancy new
optimizations.  It's a failure if it doesn't do that.

>> The _most_ likely thing that's going to happen is that DOITM gets
>> redefined to be much more limited in scope.  The current DOITM
>> architecture is very broad, but the implementations have much more
>> limited effects.  This means that the architecture can probably be
>> constrained and still match the hardware that's out there today.  That's
>> pure speculation (ha!) on my part.
>>
>> I think we should hold off on merging any DOITM patches until the dust
>> settles.  As far as I know, there is no pressing practical reason to
>> apply something urgently.
>>
>> Any objections?
> 
> Does this mean that Intel will be restoring the data operand independent timing
> guarantee of some instructions that have had it removed?  If so, which
> instructions will still be left?

Speaking for myself and *not* the official Intel plan here.  Yes, I
think the pre-DOITM behavior can and will be restored for basically the
entire list[1] (ignoring MCDT of course).

> Also, given that the DOITM flag can only be set and cleared by the
> kernel, and assuming that Linux won't support DOITM in any way yet
> (as you're recommending), what should the developers of userspace
> cryptographic libraries do? Does Intel have a list of which
> instructions *already* have started having data operand dependent
> timing on released CPUs, so that the existing security impact can be
> assessed and so that developers can avoid using those instructions?
Good questions.  I want to make sure what I'm saying here is accurate,
and I don't have good answers to those right now.  We're working on it,
and should have something useful to say in the next couple of days.

1.
https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/resources/data-operand-independent-timing-instructions.html

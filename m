Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516C0C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 00:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E52E611C2
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 00:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhETACT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 20:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETACT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 20:02:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6759C061574
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 17:00:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t11so8184780pjm.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 17:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kgwtEqurIJrKPh91Jj/algbxm5mofV9YTCkAkHjCGqE=;
        b=J5Frg9kEezALhQ/GbgzaNDHyRSU0SZG20oinNFfEt6LKFQCgNDjuux82ukX5t3ijjF
         oJ6sI0jvHxesJsLhk3kb0vLuStFee1mmFGnLvir9hTBu02jCYSLJ++U9cpRaBWq39EXk
         4QwoIelshDMwfnd05t3D1Jw+xD0qNcBRKOvy5W9zNdwumFkF+nDq836XXCAs+m0h7H2D
         HSAp69WrcDODW+RL8WgbjjND43/lmwwrVs4IdH47UxmCQmE/Rso29kvQx7nktwSqDIXK
         UEeDLku6B0IhHL+GgB1hOaUTHqQ8u+sXaE+9KwX6WgtrUdI1StIu3yN087rE7tf5XXit
         vIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kgwtEqurIJrKPh91Jj/algbxm5mofV9YTCkAkHjCGqE=;
        b=dvRcZOCK9nIP7jF3mCp4Ud+d56zOgXVsRIfgPEj5qr7GAkr7EkpRF5xV240KIPM1fd
         bgLtJ4ZeHpCqSh0luWbo4IolcjQqs0lTv31RHGnkaNx6i9+YY3/QxkaYA+q3z/XhGEzJ
         AP73y4Cwq0o9R711HEEQFoY0kyMxv231qX+7liDR7ZVR9eNxSJTZPBD18oW/T2H8Eq6T
         BalpDjyJ1jwbm6eF8uHtX8m+2GPP6wYOe4mRVo0PWWUe4Ey21XMIckrjG0T20b1RzyD8
         pPyfswpXxlhWQjJG8Rx/tG+MRjPeTF6r8ldeAPx+o9yjiIcg1nuowCg8K8GySoRYTS8k
         LzMw==
X-Gm-Message-State: AOAM530xiLB2YNWKkSUg7j0lkPT0B+ZlnwsfYQd2DOjMefL52EThEwvk
        00BWgHfl2gqzUggqTd1VgCIDyA==
X-Google-Smtp-Source: ABdhPJy/bG+X0C8kgVw5LLEdzhY2HDlA4y0sO/gIN3awyWQU2xPnAZgM7oox5eHIfM8WnpvODrQ8Ug==
X-Received: by 2002:a17:90a:6402:: with SMTP id g2mr1677564pjj.82.1621468858172;
        Wed, 19 May 2021 17:00:58 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ie5sm5123616pjb.14.2021.05.19.17.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 17:00:57 -0700 (PDT)
Date:   Thu, 20 May 2021 00:00:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Message-ID: <YKWmtUFHK1uZt4TL@google.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
 <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
 <247d9a25-f32f-d01b-61ff-b1966e382907@kernel.org>
 <YKP+1cjRWN/IOEpd@google.com>
 <112f7ceb-d699-fc1e-ea5f-89d505e0d6d8@kernel.org>
 <YKWgnb/OO5TWmer5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKWgnb/OO5TWmer5@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 19, 2021, Sean Christopherson wrote:
> On Wed, May 19, 2021, Andy Lutomirski wrote:
> > On 5/18/21 10:52 AM, Sean Christopherson wrote:
> > > On Tue, May 18, 2021, Andy Lutomirski wrote:
> > >> On 5/17/21 11:21 AM, Bae, Chang Seok wrote:
> > >>> First of all, there is an RFC series for KVM [2].
> > >>>
> > >>> Each CPU has one internal key state so it needs to reload it between guest and
> > >>> host if both are enabled. The proposed approach enables it exclusively; expose
> > >>> it to guests only when disabled in a host. Then, I guess a guest may enable it.
> > >>
> > >> I read that series.  This is not a good solution.
> > >>
> > >> I can think of at least a few reasonable ways that a host and a guest
> > >> can cooperate to, potentially, make KL useful.
> > >>
> > >> a) Host knows that the guest will never migrate, and guest delegates
> > >> IWKEY management to the host.  The host generates a random key and does
> > >> not permit the guest to use LOADIWKEY.  The guest shares the random key
> > >> with the host.  Of course, this means that a host key handle that leaks
> > >> to a guest can be used within the guest.
> > > 
> > > If the guest and host share a random key, then they also share the key handle.
> > > And that handle+key would also need to be shared across all guests.  I doubt this
> > > option is acceptable on the security front.
> > > 
> > 
> > Indeed.  Oddly, SGX has the exact same problem for any scenario in which
> > SGX is used for HSM-like functionality, and people still use SGX.
> 
> The entire PRM/EPC shares a single key, but SGX doesn't rely on encryption to
> isolate enclaves from other software, including other enclaves.  E.g. Intel could
> ship a CPU with the EPC backed entirely by on-die cache and avoid hardware
> encryption entirely.

Ha!  I belatedly see your point: in the end, virtualized KL would also rely on a
trusted entity to isolate its sensitive data via paging-like mechanisms.

The difference in my mind is that encryption is a means to an end for SGX,
whereas hiding the key is the entire point of KL.  E.g. the guest is already
relying on the VMM to isolate its code and data, adding KL doesn't change that.
Sharing an IWKEY across multiple guests would add intra-VM protection, at the
cost of making cross-VM attacks easier to some degree.

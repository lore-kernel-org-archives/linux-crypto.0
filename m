Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A8CC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 17:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 170A7611EE
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 17:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347220AbhERRxp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 13:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbhERRxo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 13:53:44 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A757BC061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 10:52:26 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso1972239pjp.5
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 10:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K62kztyMhw34FyLwToWQH1oT4oDG0ZJWnnyd/ejNoWI=;
        b=rXmUHMrFlrSp49qALZP0A+U8za1ztjEeMOxcIKugRBGV0iC+Il1IQp8Hj5bgSnEUe4
         27n/1fMn8RJTKiIrjY6IlJ5yWKJv41j+qrq2qYkJeSUkG/2RAafZ7nLOrPd2r3N6f0rb
         0Jv+X4OPKrT+92wbsotYtiZXMli1Q4rTaW7XIdmDtB21h8VkZEC9z6qy3pd2BSOfs5UH
         2/ucea481C6kzbVdUbxeI9jFZnzh+vQ0aTf4K/MXjzhqzld7rw052AFnYU+h10Uf2WQh
         bRDbKWqEAkfcU9iyDSMfKzDnkTervRWCCJLG+QQ/Gqm2NscfYnnqWRNNxyizfKXOylLw
         e77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K62kztyMhw34FyLwToWQH1oT4oDG0ZJWnnyd/ejNoWI=;
        b=heWPhdSOoayBo+ikXOXOWv3qOWTutHxhEVJvPvBmRcSVdKNclpfkRK9Jfi1jF7bqaZ
         v2uQqjy+n85QCtpMALHPnzXmjFomioNe/V8N08h//IQMNmjI64866DuZeajSG6rcCL0x
         Oq3VoctDF9+ucnEvreoC6IIfCreHZF+8I06pgNng9jgoPoPoIfz5ceNUudeNAVPVoMFr
         +7sFUOiKmRdpWk+uVLEYY3riOl8FAmsXhUBT6E746bG4uqI7lzCZ5A9X8Y7cjwHACzti
         yPdb9NEwVrG8r2s8PF2vLY24itnXU+UThO3EwkLeXHxNG97AAyZLE+RV/dvVXT+FwGjR
         oKyQ==
X-Gm-Message-State: AOAM531zuORRTSvSA7RUPueki3rt++WaNozbCddl5OsRVvbNmR9NbBir
        wDAPKSI06a/Emepdndt2a2OgPaFXe/FHnA==
X-Google-Smtp-Source: ABdhPJw4cqEvKK5G8ZZU+F1uSUhUcfgJBTp7DP7LJq7r9ikG+bFj8SPjrYyAQ3SswwF56Hr6Dp6HiQ==
X-Received: by 2002:a17:902:c789:b029:f4:33e3:dad9 with SMTP id w9-20020a170902c789b02900f433e3dad9mr159614pla.84.1621360346074;
        Tue, 18 May 2021 10:52:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d129sm12446943pfa.6.2021.05.18.10.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:52:25 -0700 (PDT)
Date:   Tue, 18 May 2021 17:52:21 +0000
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
Message-ID: <YKP+1cjRWN/IOEpd@google.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
 <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
 <247d9a25-f32f-d01b-61ff-b1966e382907@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <247d9a25-f32f-d01b-61ff-b1966e382907@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021, Andy Lutomirski wrote:
> On 5/17/21 11:21 AM, Bae, Chang Seok wrote:
> > First of all, there is an RFC series for KVM [2].
> > 
> > Each CPU has one internal key state so it needs to reload it between guest and
> > host if both are enabled. The proposed approach enables it exclusively; expose
> > it to guests only when disabled in a host. Then, I guess a guest may enable it.
> 
> I read that series.  This is not a good solution.
> 
> I can think of at least a few reasonable ways that a host and a guest
> can cooperate to, potentially, make KL useful.
> 
> a) Host knows that the guest will never migrate, and guest delegates
> IWKEY management to the host.  The host generates a random key and does
> not permit the guest to use LOADIWKEY.  The guest shares the random key
> with the host.  Of course, this means that a host key handle that leaks
> to a guest can be used within the guest.

If the guest and host share a random key, then they also share the key handle.
And that handle+key would also need to be shared across all guests.  I doubt this
option is acceptable on the security front.

Using multiple random keys is a non-starter because they can't be restored via
LOADIWKEY.

Using multiple software-defined keys will have moderate overhead because of the
possibility of using KL from soft IRQ context, i.e. KVM would have to do
LOADIWKEY on every VM-Enter _and_ VM-Exit.  It sounds like LOADIWKEY has latency
similar to WRMSR, so it's not a deal-breaker, but the added latency on top of the
restrictions on how the host can use KL certainly lessen the appeal.

> b) Host may migrate the guest.  Guest delegates IWKEY management to the
> host, and the host generates and remembers a key for the guest.  On
> migration, the host forwards the key to the new host.  The host can
> still internally any type of key, but context switches may be quite slow.

Migrating is sketchy because the IWKEY has to be exposed to host userspace.
But, I think the migration aspect is a secondary discussion.

> c) Guest wants to manage its own non-random key.  Host lets it and
> context switches it.

This is essentially a variant of (b).  In both cases, the host has full control
over the guest's key.

> d) Guest does not need KL and leaves CR4.KL clear.  Host does whatever
> it wants with no overhead.
> 
> All of these have tradeoffs.
> 
> My current thought is that, if Linux is going to support Key Locker,
> then this all needs to be explicitly controlled.  On initial boot, Linux
> should not initialize Key Locker.  Upon explicit administrator request
> (via sysfs?), Linux will initialize Key Locker in the mode requested by
> the administrator.

Deferring KL usage to post-boot can work, but KVM shouldn't be allowed to expose
KL to a guest until KL has been explicitly configured in the host.  If KVM can
spawn KL guests before the host is configured, the sysfs knob would have to deal
with the case where the desired configuration is incompatible with exposing KL
to a guest.

> Modes could include:
> 
> native_random_key: Use a random key per the ISA.
> 
> native_kernel_key_remember: Use a random key but load it as a non-random
> key.  Remember the key in kernel memory and use it for S3 resume, etc.

What would be the motivation for this mode?  It largely defeats the value
proposition of KL, no?

> native_kernel_key_backup: Use a random key, put it in the backup
> storage, and forget it.  Use the backup for resume, etc.
> 
> native_kernel_key_norestore: Use a random key.  The key is lost on any
> power transition that forgets the key.  Backup is not used.
> 
> paravirt_any: Ask the hypervisor to handle keying.  Any mechanism is
> acceptable.
> 
> paravirt_random: Ask the hypervisor for a random key.  Only succeeds if
> we get an actual random key.

AFAIK, there's no way for the guest to verify that it got a truly random key.
Hell, the guest can't even easily verify that KL is even supported.  The host
can lie about CPUID and CR4.KL, and intercept all KL instructions via #UD by
running the guest with CR4.KL=0.

I also don't see any reason to define a paravirt interface for a truly random
key.  Using a random key all but requires a single guest to have exclusive access
to KL, and in that case the host can simply expose KL to only that guest.

> Does this make sense?

I really want to use see concrete guest use cases before we start adding paravirt
interfaces.

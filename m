Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629C3C3F2D1
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35DF220870
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WqGcGMvM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbgCCVT1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 16:19:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55703 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732176AbgCCVT0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 16:19:26 -0500
Received: by mail-pj1-f68.google.com with SMTP id a18so1912074pjs.5
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2020 13:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2qU0zyTDNzYtyDUGa9/iXos9xa7ov/2wTakWPxGP1ks=;
        b=WqGcGMvMn5GluxOGODQRPNpbzgvWO+OkNu8cZEiK4m3NjrW/mP/9I8Ma2MOO/Ww+Rh
         AXpTLggSqb4nT/DNHZ4zPLZBLfPgo7r9MZEl//d92/3cJAZoUlA/0t9tIJIOzPiz4Vo8
         qCIuwYIq9DuCng1+aDxogCJeRnZ7hUGxeizAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2qU0zyTDNzYtyDUGa9/iXos9xa7ov/2wTakWPxGP1ks=;
        b=mJVRO14MvwBkIEseNnthhGSPs0O18+Eg1N+VUaYH0tkSIncsdoAXCx9PBKSPoJHC43
         mSv+LZECiQs1Hu8evHebaXHuVrOmk7tRQWCgAAv72kUEjN3eFXopo/guQiEDgyL50BHE
         bMNd/gNJPbqhQolCfEO4dsm8IXuIr+EYiYHUWHviOoFG7cecPApS/wotE+dua22iKYPI
         1rx08yXiXi/bCcrRM6lwTec+CUiEh3vqugx6zZw8YD/IgYANIVidm5rLnHYCZCcPibT9
         57ff1qVW+b3SFKvQn8npOBriYPHOBhJmllEc76/7FB/9nrWfTu+3QnsJMnEQpcePd8oI
         d2/w==
X-Gm-Message-State: ANhLgQ2N6BsMxky8PfItpvm2tP7zs0Zb0GgDmX/Q1nVo+tHJY6NWCDwA
        VPzrtTfLqQ1dVhwh+UesS2s8PA==
X-Google-Smtp-Source: ADFU+vsH9zwFogphrokiom6kP9jpc0/EfWWpx0kYNByJFBy78L6FRZ6b+5u0kGb51gx765tnnhfbdw==
X-Received: by 2002:a17:902:8d8a:: with SMTP id v10mr5883926plo.90.1583270363955;
        Tue, 03 Mar 2020 13:19:23 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k20sm3338375pfk.123.2020.03.03.13.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 13:19:23 -0800 (PST)
Date:   Tue, 3 Mar 2020 13:19:22 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     Thomas Garnier <thgarnie@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>,
        Allison Randal <allison@lohutok.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <202003031314.1AFFC0E@keescook>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook>
 <20200303095514.GA2596@hirez.programming.kicks-ass.net>
 <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
 <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 01:01:26PM -0800, Kristen Carlson Accardi wrote:
> On Tue, 2020-03-03 at 07:43 -0800, Thomas Garnier wrote:
> > On Tue, Mar 3, 2020 at 1:55 AM Peter Zijlstra <peterz@infradead.org>
> > wrote:
> > > On Mon, Mar 02, 2020 at 09:02:15PM -0800, Kees Cook wrote:
> > > > On Thu, Feb 27, 2020 at 04:00:45PM -0800, Thomas Garnier wrote:
> > > > > Minor changes based on feedback and rebase from v10.
> > > > > 
> > > > > Splitting the previous serie in two. This part contains
> > > > > assembly code
> > > > > changes required for PIE but without any direct dependencies
> > > > > with the
> > > > > rest of the patchset.
> > > > > 
> > > > > Note: Using objtool to detect non-compliant PIE relocations is
> > > > > not yet
> > > > > possible as this patchset only includes the simplest PIE
> > > > > changes.
> > > > > Additional changes are needed in kvm, xen and percpu code.
> > > > > 
> > > > > Changes:
> > > > >  - patch v11 (assembly);
> > > > >    - Fix comments on x86/entry/64.
> > > > >    - Remove KASLR PIE explanation on all commits.
> > > > >    - Add note on objtool not being possible at this stage of
> > > > > the patchset.
> > > > 
> > > > This moves us closer to PIE in a clean first step. I think these
> > > > patches
> > > > look good to go, and unblock the work in kvm, xen, and percpu
> > > > code. Can
> > > > one of the x86 maintainers pick this series up?
> > > 
> > > But,... do we still need this in the light of that fine-grained
> > > kaslr
> > > stuff?
> > > 
> > > What is the actual value of this PIE crud in the face of that?
> > 
> > If I remember well, it makes it easier/better but I haven't seen a
> > recent update on that. Is that accurate Kees?
> 
> I believe this patchset is valuable if people are trying to brute force
> guess the kernel location, but not so awesome in the event of
> infoleaks. In the case of the current fgkaslr implementation, we only
> randomize within the existing text segment memory area - so with PIE
> the text segment base can move around more, but within that it wouldn't
> strengthen anything. So, if you have an infoleak, you learn the base
> instantly, and are just left with the same extra protection you get
> without PIE.

Right -- PIE improves both non- and fg- KASLR similarly, in the sense
that the possible entropy for base offset is expanded. It also opens the
door to doing even more crazy things. (e.g. why keep the kernel text all
in one contiguous chunk?)

And generally speaking, it seems a nice improvement to me, as it gives
the kernel greater addressing flexibility.

-- 
Kees Cook

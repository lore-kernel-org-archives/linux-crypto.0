Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70732C3F2D1
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD3F20842
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 21:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732055AbgCCVB2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 16:01:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:43885 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732026AbgCCVB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 16:01:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 13:01:27 -0800
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="412891493"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.24.8.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 13:01:27 -0800
Message-ID: <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Thomas Garnier <thgarnie@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
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
Date:   Tue, 03 Mar 2020 13:01:26 -0800
In-Reply-To: <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
References: <20200228000105.165012-1-thgarnie@chromium.org>
         <202003022100.54CEEE60F@keescook>
         <20200303095514.GA2596@hirez.programming.kicks-ass.net>
         <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2020-03-03 at 07:43 -0800, Thomas Garnier wrote:
> On Tue, Mar 3, 2020 at 1:55 AM Peter Zijlstra <peterz@infradead.org>
> wrote:
> > On Mon, Mar 02, 2020 at 09:02:15PM -0800, Kees Cook wrote:
> > > On Thu, Feb 27, 2020 at 04:00:45PM -0800, Thomas Garnier wrote:
> > > > Minor changes based on feedback and rebase from v10.
> > > > 
> > > > Splitting the previous serie in two. This part contains
> > > > assembly code
> > > > changes required for PIE but without any direct dependencies
> > > > with the
> > > > rest of the patchset.
> > > > 
> > > > Note: Using objtool to detect non-compliant PIE relocations is
> > > > not yet
> > > > possible as this patchset only includes the simplest PIE
> > > > changes.
> > > > Additional changes are needed in kvm, xen and percpu code.
> > > > 
> > > > Changes:
> > > >  - patch v11 (assembly);
> > > >    - Fix comments on x86/entry/64.
> > > >    - Remove KASLR PIE explanation on all commits.
> > > >    - Add note on objtool not being possible at this stage of
> > > > the patchset.
> > > 
> > > This moves us closer to PIE in a clean first step. I think these
> > > patches
> > > look good to go, and unblock the work in kvm, xen, and percpu
> > > code. Can
> > > one of the x86 maintainers pick this series up?
> > 
> > But,... do we still need this in the light of that fine-grained
> > kaslr
> > stuff?
> > 
> > What is the actual value of this PIE crud in the face of that?
> 
> If I remember well, it makes it easier/better but I haven't seen a
> recent update on that. Is that accurate Kees?

I believe this patchset is valuable if people are trying to brute force
guess the kernel location, but not so awesome in the event of
infoleaks. In the case of the current fgkaslr implementation, we only
randomize within the existing text segment memory area - so with PIE
the text segment base can move around more, but within that it wouldn't
strengthen anything. So, if you have an infoleak, you learn the base
instantly, and are just left with the same extra protection you get
without PIE.




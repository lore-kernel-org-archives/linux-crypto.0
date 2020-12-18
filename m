Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EB7C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 14:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA1B23AC1
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 14:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgLROeb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 09:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbgLROeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 09:34:31 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2258CC0617B0;
        Fri, 18 Dec 2020 06:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=t2dndBPQ/dB6MBazQBkYq7w5jQZcjWAgNQl2baLPfTk=; b=Z64T0rZjYr1bLMiImNudlom4jI
        cmmcGJt1fp+iSLy80d6lAlZMxqOWwIwelpjDcz3hd/H0Jfqb/BSoEH6L+1YBBGZbR1s+/jmF2/dCS
        BX8S4k2mDC3YkQrfpUfA7r/D/kGXyIImspqvVnXwRznfeQAT8QCS/ewX7BxmvrRS2SL7iKKRXVV3C
        p/ZdxZDi+84JtbQpEVV6amfyKdXv4i1bqXDG5YwsjMJmR+6k1YGYK91lzsWQ+nA2TmXB3Uu/N54vE
        24D2ml8gHMI254glpGAoZpGHA468Bs/lVFo/97hvr2ipza1h+23G+BLSenMc/dJ/EMaPl6pbgGjOf
        B6D0bA1A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kqGp9-0003pR-Nm; Fri, 18 Dec 2020 14:33:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 176DB30018A;
        Fri, 18 Dec 2020 15:33:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 63AD0200926C1; Fri, 18 Dec 2020 15:33:34 +0100 (CET)
Date:   Fri, 18 Dec 2020 15:33:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Message-ID: <20201218143334.GG3021@hirez.programming.kicks-ass.net>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
 <20201218101148.GF3021@hirez.programming.kicks-ass.net>
 <61FFFEA5-3DD2-4625-9F3A-B7A589B92D95@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61FFFEA5-3DD2-4625-9F3A-B7A589B92D95@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 10:34:28AM +0000, Bae, Chang Seok wrote:
> 
> > On Dec 18, 2020, at 19:11, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > *groan*, so what actual version of binutils is needed and why is this
> > driver important enough to build on ancient crud to warrant all this
> > gunk?
> 
> The new Key Locker instructions look to be added a few month ago [1].
> But the latest binutils release (2.35.1) does not include them yet.
> 
> I’m open to drop the macros if there is any better way to define them
> without binutils support.

It's just a driver, make it depend on binutils having the instructions.

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD67C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Feb 2021 10:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BA264DC3
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Feb 2021 10:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhBPKLj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Feb 2021 05:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhBPKLj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Feb 2021 05:11:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE8C061574;
        Tue, 16 Feb 2021 02:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M3sGSrTBwz4qNYhjumdWtmzUj5dwr3S+HhZN9jBgyco=; b=d2WIA82ke4d6idbElbNfc4JiTt
        2CelTzoLni619XeJSNwMEn6uf8A5GxrMeYXv54drG9i38ULUj2AKPEPNty6Yskh6Ss5RPmhM0q0tF
        M/x8hbX7kygeHNqSb1IDfON8Y8i8Nldb81lTChkCH/Zvcf8WHOZShqpWpRk8uEJpoWOOXjrppfPnJ
        X8t7q/x5jqG2NrxnIquyNGWHb8q/VTI6A9L8wAFG9cf5Ecq1cl/ZtIyG07cHQllkaAYHCOgoHRV3d
        bDq5qwzkzpygGX2Dj+fwYWa4vlSBYkzDS4bdfzuQ5iZL8lOm34Gxk29cH3mb+8U0zuvLXslIE2XfL
        SNJvnonQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lBxI3-00GjSg-DG; Tue, 16 Feb 2021 10:09:25 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B468A3011E6;
        Tue, 16 Feb 2021 11:09:05 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 91A502B7E1C46; Tue, 16 Feb 2021 11:09:05 +0100 (CET)
Date:   Tue, 16 Feb 2021 11:09:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH 0/5] running kernel mode SIMD with softirqs disabled
Message-ID: <YCuZwWWGtqf8PaAf@hirez.programming.kicks-ass.net>
References: <20201218170106.23280-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218170106.23280-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 06:01:01PM +0100, Ard Biesheuvel wrote:
> [ TL;DR for the non-ARM folks on CC: disabling softirq processing when using
>   SIMD in kernel mode could reduce complexity and improve performance, but we
>   need to decide whether we can do this, and how much softirq processing
>   latency we can tolerate. If we can find a satisfactory solution for this,
>   we might do the same for x86 and 32-bit ARM as well. ]

> - could we do the same on x86, now that kernel_fpu_begin/end is no longer
>   expensive?

Can't we simply save/restore the relevant register set?

So something like (note amluto was wanting to add a regset argument):

	<task>
	kernel_fpu_begin(MMX)
		<SIRQ>
		kernel_fpu_begin(SSE)
		kernel_fpu_end();
		</SIRQ>
	...
	kernel_fpu_end()

Would have to save the MMX regs on first SIRQ invocation of
kernel_fpu_begin(), and then have softirq context termination </SIRQ>
above, restore it.

I mean, we already do much the same for the first kernel_fpu_begin(),
that has to save the user registers, which will be restore when we go
back to userspace.

So why not do exactly the same for softirq context?

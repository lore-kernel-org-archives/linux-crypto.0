From: Sebastian Andrzej Siewior <arm-kernel@ml.breakpoint.cc>
Subject: Re: [PATCH] arm/orion5x: add sram support for crypto
Date: Sat, 1 Aug 2009 11:38:03 +0200
Message-ID: <20090801093803.GA2362@Chamillionaire.breakpoint.cc>
References: <1244728999-8103-1-git-send-email-arm-kernel@ml.breakpoint.cc> <1244728999-8103-2-git-send-email-arm-kernel@ml.breakpoint.cc> <alpine.LFD.2.00.0906111513420.31536@xanadu.home> <20090611201530.GA11486@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111625280.31536@xanadu.home> <20090611210734.GA11920@Chamillionaire.breakpoint.cc> <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Nicolas Pitre <nico@cam.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60474 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbZHAJiS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Aug 2009 05:38:18 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906111712060.31536@xanadu.home>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Nicolas Pitre | 2009-06-11 17:19:22 [-0400]:

>I have no problem with you submitting it now.  It is not complete yet 
>but what is there is plenty functional.  However I'd prefer if you used 
>the API based on sg_copy_buffer() which includes a call to 
>flush_kernel_dcache_page() already for mainline inclusion, so to have 
>good style up front. ( a patch to fix flush_kernel_dcache_page() on ARM 
>is already queued).
I just wanted to let you know, that since -rc5 I have the needful change
in sg code [0]. On the other hand I have the IDMA somehow working so I
probably should sit my ass down and make it work with cesa...

[0] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6de7e356faf54aa75de5b624bbce28a5b776dfa8

>Nicolas

Sebastian

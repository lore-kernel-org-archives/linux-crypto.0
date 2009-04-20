From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: enable padlock on x86_64
Date: Mon, 20 Apr 2009 18:09:31 -0400
Message-ID: <20090420180931.7bd7ff02@dhcp-100-2-144.bos.redhat.com>
References: <49B83002.9040705@tobiasvolk.de>
	<1237029843-28076-1-git-send-email-sebastian@breakpoint.cc>
	<20090314114732.GB3805@elte.hu>
	<20090314115307.GA28235@Chamillionaire.breakpoint.cc>
	<20090314132420.GB6080@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Ingo Molnar <mingo@elte.hu>, linux-crypto@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, mail@tobiasvolk.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZDTWL0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 18:11:26 -0400
In-Reply-To: <20090314132420.GB6080@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 14 Mar 2009 21:24:20 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Sat, Mar 14, 2009 at 12:53:07PM +0100, Sebastian Andrzej Siewior wrote:
> > 
> > Yep, it is fine.
> > #1 in, #2 not will not result in any difference to what we have now.
> > #2 in, #1 not will result in "padlock not detected" while loading the
> > module and -ENODEV.
> 
> Let's merge #1 right now and I'll pick up #2 once #1 shows up
> in linux-net.
> 

#1 is in 2.6.30-rc now but I don't see #2 pending anywhere.

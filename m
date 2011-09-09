From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Fri, 9 Sep 2011 12:25:24 -0400
Message-ID: <20110909162524.GA3818@thunk.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <201109080911.12921.sgrubb@redhat.com>
 <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
 <201109090904.18321.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Neil Horman <nhorman@redhat.com>,
	Tomas Mraz <tmraz@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45735 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab1IIQZc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Sep 2011 12:25:32 -0400
Content-Disposition: inline
In-Reply-To: <201109090904.18321.sgrubb@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 09, 2011 at 09:04:17AM -0400, Steve Grubb wrote: But what
> I was trying to say is that we can't depend on these supplemental
> hardware devices like TPM because we don't have access to the
> proprietary technical details that would be necessary to supplement
> the analysis. And when it comes to TPM chips, I bet each chip has
> different details and entropy sources and entropy estimations and
> rates. Those details we can't get at, so we can't solve the problem
> by including that hardware. That is the point I was trying to
> make. :)

Let's be clear that _we_ which Steve is referring to is Red Hat's
attempt to get a BSI certification so they can make $$$.  It has
nothing to do with security, except indirectly, and in my opinion,
breaking application by causing network daemons to suddenly lock up
randomly just so that Red Hat can make more $$$ is not a good reason
to push a incompatible behavioural change into /dev/random.

   	  	       		   	       - Ted

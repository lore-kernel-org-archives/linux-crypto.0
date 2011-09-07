From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 7 Sep 2011 15:27:37 -0400
Message-ID: <20110907192737.GD20571@thunk.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <1315417137-12093-1-git-send-email-jarod@redhat.com>
 <1315419179.3576.6.camel@lappy>
 <4E67B75B.8010500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54597 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1IGT1n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 15:27:43 -0400
Content-Disposition: inline
In-Reply-To: <4E67B75B.8010500@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> We're looking for a generic solution here that doesn't require
> re-educating every single piece of userspace. And anything done in
> userspace is going to be full of possible holes -- there needs to be
> something in place that actually *enforces* the policy, and
> centralized accounting/tracking, lest you wind up with multiple
> processes racing to grab the entropy.

Yeah, but there are userspace programs that depend on urandom not
blocking... so your proposed change would break them.

	       	    	     	    	  	- Ted

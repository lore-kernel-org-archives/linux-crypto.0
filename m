From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic,
 don't buffer old output
Date: Mon, 8 Dec 2014 13:07:55 -0500
Message-ID: <20141208180755.GA4238@hmsreliant.think-freely.org>
References: <20141208142239.GA3237@localhost.localdomain>
 <20141208164313.10839.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 4381@horizon.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, smueller@chronox.de
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35765 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaLHSIu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 13:08:50 -0500
Content-Disposition: inline
In-Reply-To: <20141208164313.10839.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2014 at 11:43:13AM -0500, George Spelvin wrote:
> > Wait, I'm confused. You mention in this note that this is an RFC patch, but not
> > anywhere else in the series.  Are you proposing this for inclusion or not?
> 
> Er, in the 0/25, I mentioned that I put the least certain stuff last,
> and in particular I wasn't sure if the the last three patches were wanted
> or not:
> 
> >> Pending issues:
> >> * Is non-deterministic mode (last three patches) wanted?
> 
> I certainly wouldn't be unhappy if they went in, but with the comment
> clarification just before, I wouldn't be unhappy if they didn't, either.
> 
> They're "If we wanted to do this, this is how it could be done.  Is this
> something we want to do?"
> 
> Sorry if my motivations are confusing.  I did indeed start with wanting
Not your motivations, just the posting mechanics.  If you just want to discuss a
patch, and aren't yet proposing it for inclusion, you should put RFC in the
prefix of every patch header.

> to add the seeding because I misunderstood the comments: I thought
> this was claiming to be X9.31 *and* I haven't seen the later versions
> of the standaed (which you have) that back off on the requirements for
> the DT[] vector.
> 
> Since you've patiently explained both of those to me, I'm more interested
> in the other, more generic code cleanups.
> 
> You also sent me two detailed explanations of the consequences of making
> the generator non-determinsitic in a way that gave me a general impression
> of disliking of the idea.  So I've been weaning myself off the idea.
> 
Not particularly opposed to the idea, I just know that several use cases rely on
deterministic behavior for those entities that share the secret information, so
I need to be sure that the deterministic behavior remains and is the default.

> I put those patches at the end so they can easily be dropped from the series.
> 
> Or, as I also mentioned, simply postponed until there's been more discussion.  
> Since that's an actual semantic change, collecting a few other opinions
> would be valuable.
I'll look at this series in detail shortly.
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

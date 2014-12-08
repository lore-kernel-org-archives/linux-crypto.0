From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH v2 25/25] crypto: ansi_cprng - If non-deterministic, don't buffer old output
Date: 8 Dec 2014 11:43:13 -0500
Message-ID: <20141208164313.10839.qmail@ns.horizon.com>
References: <20141208142239.GA3237@localhost.localdomain>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: 4381@horizon.com, linux@horizon.com, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:23768 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751482AbaLHQnO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 11:43:14 -0500
In-Reply-To: <20141208142239.GA3237@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Wait, I'm confused. You mention in this note that this is an RFC patch, but not
> anywhere else in the series.  Are you proposing this for inclusion or not?

Er, in the 0/25, I mentioned that I put the least certain stuff last,
and in particular I wasn't sure if the the last three patches were wanted
or not:

>> Pending issues:
>> * Is non-deterministic mode (last three patches) wanted?

I certainly wouldn't be unhappy if they went in, but with the comment
clarification just before, I wouldn't be unhappy if they didn't, either.

They're "If we wanted to do this, this is how it could be done.  Is this
something we want to do?"

Sorry if my motivations are confusing.  I did indeed start with wanting
to add the seeding because I misunderstood the comments: I thought
this was claiming to be X9.31 *and* I haven't seen the later versions
of the standaed (which you have) that back off on the requirements for
the DT[] vector.

Since you've patiently explained both of those to me, I'm more interested
in the other, more generic code cleanups.

You also sent me two detailed explanations of the consequences of making
the generator non-determinsitic in a way that gave me a general impression
of disliking of the idea.  So I've been weaning myself off the idea.

I put those patches at the end so they can easily be dropped from the series.

Or, as I also mentioned, simply postponed until there's been more discussion.  
Since that's an actual semantic change, collecting a few other opinions
would be valuable.

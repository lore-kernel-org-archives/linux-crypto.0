From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Wed, 20 May 2015 18:18:01 +0200
Message-ID: <9811880.Zfx1jXMqj8@tauon>
References: <477328243.LmeEDk1ili@tauon> <3005024.K2tYVGR0qE@tauon> <20150520150642.GJ2871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57992 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbbETQSE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 12:18:04 -0400
In-Reply-To: <20150520150642.GJ2871@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Mai 2015, 11:06:42 schrieb Theodore Ts'o:

Hi Theodore,

As a side note to this discussion, may I ask why entropy_total is used for 
checking against the threshold value and not entropy_count?

The reason for my question is the following: until a DRNG (in the worst case, 
nonblocking_pool is a DRNG) is fully seeded, partial seeds may be "eaten" up 
by the caller.

For the discussion, let us assume the worst case that there is coming in one 
bit of entropy at a time. In between the addition of each bit of entropy, an 
attacker can access the DRNG (i.e. the SHA1 output of the nonblocking_pool). 
When only one bit of entropy is added to the nonblocking_pool, the attack 
complexity would be 1 bit. When an attacker would access the nonblocking_pool 
after each received bit, in the worst case, the attack complexity is not 
2**128 but rather 256 (i.e. 1 bit for each individual attack between the 
addition of one new bit of entropy).

So, the total attack complexity is the sum of the individual attack 
complexities (i.e. the complexity added after the previous attack is 
performed).

When using the entropy_count variable which is affected by account() (i.e. it 
is decreased when a reader obtains data), the threshold is only reached when 
truly 128 unobserved bits are collected.

Ciao
Stephan

From: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 07 Sep 2011 15:36:13 -0400
Message-ID: <4E67C7AD.9050903@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315417137-12093-1-git-send-email-jarod@redhat.com> <1315419179.3576.6.camel@lappy> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564Ab1IGTgS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Sep 2011 15:36:18 -0400
In-Reply-To: <20110907192737.GD20571@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ted Ts'o wrote:
> On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
>> We're looking for a generic solution here that doesn't require
>> re-educating every single piece of userspace. And anything done in
>> userspace is going to be full of possible holes -- there needs to be
>> something in place that actually *enforces* the policy, and
>> centralized accounting/tracking, lest you wind up with multiple
>> processes racing to grab the entropy.
>
> Yeah, but there are userspace programs that depend on urandom not
> blocking... so your proposed change would break them.

But only if you've set the sysctl to a non-zero value, and even then, 
only if someone is actively draining entropy from /dev/random. 
Otherwise, in practice, it behaves the same as always. Granted, I 
haven't tested with all possible userspace to see how it might fall 
down, but suggestions for progs to try would be welcomed.

But again, I want to stress that out of the box, there's absolutely no 
change to the way urandom behaves, no blocking, this *only* kicks in if 
you twiddle the sysctl because you have some sort of security 
requirement that mandates it.


-- 
Jarod Wilson
jarod@redhat.com

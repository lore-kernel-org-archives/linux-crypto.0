From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Wed, 6 Nov 2013 14:24:59 +0100
Message-ID: <20131106132457.GA13852@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <4306229.ErfOL470s2@tauon>
 <20131106124354.GJ14235@thunk.org>
 <9172761.DO0L6FkY0c@tauon>
 <20131106130432.GK14235@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Nicholas Mc Guire <der.herr@hofr.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131106130432.GK14235@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> Of course, some of the state in the CPU may not be unknown to the
> attacker, if it is derived by external events that are not visible to
> the attacker, such as a network interrupt.  But if that's the case,
> why not measure network interrupts directly?  We're much less likely
> to overestimate the amount of entropy we can extract the system in
> that case.

Actually, I believe Stephan is up to something here.

We _can't_ measure network interrupts directly, because we do not have
TSC. (And TSC-less machines are the ones that are problematic, right?)

Extracting entropy from the CPU will allow us to pick up entropy from
network packets (and timer interrupt jitter) even on machines that
lack TSC. And that counts like very cool feature.

(And yes, we could just increment variable to get tsc emulation in
idle loop, and then extract entropy from that. But we would not be
able to enter low power states at that point, and it would not work
when cpu is busy computing.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

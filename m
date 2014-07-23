From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Wed, 23 Jul 2014 11:47:15 +0200
Message-ID: <1406108835.2603.144733749.2407B407@webmail.messagingengine.com>
References: <20140721112102.19300.qmail@ns.horizon.com>
 <1405956426.2319.37.camel@localhost>
 <1405990940.28229.4.camel@localhost> <20140722044409.GE24960@thunk.org>
 <1406022592.2407.9.camel@localhost> <20140722225950.GU25291@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140722225950.GU25291@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Wed, Jul 23, 2014, at 00:59, Theodore Ts'o wrote:
> But why would you need to use GRND_RANDOM in your scenario, and accept
> your application potentially getting stalled and stuck in amber for
> perhaps hours?  If you are going to accept your application stalling
> like that, you can do the pointer arithmatic.  It's really not hard,
> and someone who can't do that, again, shouldn't be allowd anywhere
> near crypto code in the first place (and if they are, they'll probably
> be making lots of other, equally fatal if not more so, newbie
> mistakes).

I favored the idea of having a non-failing non-partial-read getrandom
syscall. But I am with you if it often causes long stalls that we should
stick to the old semantics.

Thanks,
Hannes

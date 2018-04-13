From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/5] random: fix crng_ready() test
Date: Fri, 13 Apr 2018 15:05:01 +0200
Message-ID: <4393662.RPWnPK42dp@tauon.chronox.de>
References: <20180413013046.404-1-tytso@mit.edu> <1699469.KmO53oa8XU@tauon.chronox.de> <20180413125313.GA2633@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413125313.GA2633@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 13. April 2018, 14:53:13 CEST schrieb Theodore Y. Ts'o:

Hi Theodore,
> 
> This was always the original design intent, but I screwed up and no
> one noticed until Jann reached out to be and said, "Hey.... this
> doesn't seem to make much sense".

I disagree, but I guess you would have expected that. But this is not the 
issue.

What I would like to point out that more and more folks change to 
getrandom(2). As this call will now unblock much later in the boot cycle, 
these systems see a significant departure from the current system behavior.

E.g. an sshd using getrandom(2) would be ready shortly after the boot finishes 
as of now. Now it can be a matter minutes before it responds. Thus, is such 
change in the kernel behavior something for stable?

Ciao
Stephan

From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [RFC][PATCH] Entropy generator with 100 kB/s throughput
Date: Thu, 21 Feb 2013 12:46:45 -0500
Message-ID: <CACXcFmnBNHab57dzx+QdqS=BTbUPCJo4zkztCw7W2Yfab+m5ow@mail.gmail.com>
References: <20130221140712.GA11550@fatphil.org>
	<51262C62.4040707@chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Phil Carmody <pc+lkml@asdf.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51262C62.4040707@chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 21, 2013 at 9:17 AM, Stephan Mueller <smueller@chronox.de> wrote:

> There is no state between calls. Of course, you need a scratchpad to do
> calculations.

But in general you need a buffer. It is quite easy to construct scenarios where
several K bits of entropy are needed very -- for example, reboot an IPsec
gateway the supports a few dozen tunnels and needs a few hundred bits
to rekey each. Without state, it is quite difficult to demonstrate that you can
meet such requirements. Given a reasonable size of buffer, some saved
random data and the assumption that the enemy does not already have
root on your server, it is trivial.

> ... I am working on showing that the jitter has entropy. I
> will come back.

I think that has already been shown. See the McGuire et al. paper
I cited earlier in the thread and the HAVEGE papers. Of course it
needs more analysis to be sure we have really good estimates of
that entropy, but it seems clear there is some at any rate.

>> Entropy harvesting is quite hard - entropy estimation is unimaginably harder.

Yes.

> This is a statement that does not make sense. You CANNOT per definition
> calculate entropy!

The question is not /calculating/ it, but /estimating/ it. That is a perfectly
reasonable thing to do, and it is done in most generators. It is a hard
problem, though, and requires care in both design and implementation.

Also, in some designs it is possible to get very close to calculating
entropy. The Turbid generator, for example, uses physical measurements
of sound card properties plus arguments from standard circuit physics to
prove a lower bound on the Johnson noise that must exist in the circuit.
>From that plus some quite moderate assumptions about properties of
the hash, you get a provable lower bound on output entropy.

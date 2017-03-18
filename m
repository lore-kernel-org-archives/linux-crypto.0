From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [ANNOUNCE] /dev/random - a new approach (code for 4.11-rc1)
Date: Sat, 18 Mar 2017 06:11:57 -0400
Message-ID: <CAH8yC8=+K76rwRfYk=92sBE0v9fPEWB=2bUQqF=tyY5C1nrvKQ@mail.gmail.com>
References: <2785457.pDyvZpZC2q@positron.chronox.de>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2785457.pDyvZpZC2q@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> The design and implementation is driven by a set of goals described in [2]
> that the LRNG completely implements. Furthermore, [2] includes a
> comparison with RNG design suggestions such as SP800-90B, SP800-90C, and
> AIS20/31.

A quick comment about SP800 and the hardware instructions... RDSEED is
2 to 5 times slower than RDRAND on Intel hardware, depending on the
architecture and microarchitecture. AMD's implementation of RDRAND is
orders of magnitude slower than Intel's. Testing on an Athlon 845 X4
(Bulldozer v4) @ 3.5 GHz shows it runs between 4100 and 4500 cycles
per byte. It works out to be about 1 MiB/s.

While the LRNG may reach a cryptographically acceptable seed level
much earlier then the existing /dev/random, it may not be early
enough. Some components, like systemd, will ask for random numbers and
truck-on even if they are not available. Systemd does not block or
wait if get_random_bytes fails to produce. In the bigger picture,
don't expect that software layered above will do the expected thing in
all cases.

Jeff

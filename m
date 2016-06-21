From: Tomas Mraz <tmraz@redhat.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 15:19:56 +0200
Message-ID: <1466515196.17017.8.camel@redhat.com>
References: <1466007463.20087.11.camel@redhat.com>
	 <3381856.qSaz1KcX2Z@positron.chronox.de>
	 <f22f4cd6-8198-71a0-9b79-9f10070758f3@gmail.com>
	 <8999970.pstTbGZv5G@positron.chronox.de>
	 <6b8c8f6a-862a-3e7c-e950-75cd93cdc1f7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	David =?UTF-8?Q?Ja=C5=A1a?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6b8c8f6a-862a-3e7c-e950-75cd93cdc1f7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On =C3=9At, 2016-06-21 at 09:05 -0400, Austin S. Hemmelgarn wrote:
> On 2016-06-20 14:32, Stephan Mueller wrote:
> >=C2=A0
> > [1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf
> Specific things I notice about this:
> 1. QEMU systems are reporting higher values than almost anything
> else=C2=A0
> with the same ISA.=C2=A0=C2=A0This makes sense, but you don't appear =
to have=C2=A0
> accounted for the fact that you can't trust almost any of the entropy
> in=C2=A0
> a VM unless you have absolute trust in the host system, because the
> host=C2=A0
> system can do whatever the hell it wants to you, including
> manipulating=C2=A0
> timings directly (with a little patience and some time spent working
> on=C2=A0
> it, you could probably get those number to show whatever you want
> just=C2=A0
> by manipulating scheduling parameters on the host OS for the VM
> software).

You have to trust the host for anything, not just for the entropy in
timings. This is completely invalid argument unless you can present a
method that one guest can manipulate timings in other guest in such a
way that _removes_ the inherent entropy from the host.

--=C2=A0
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb
(You'll never know whether the road is wrong though.)

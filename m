From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 20:05:01 +0200
Message-ID: <6920965.KzCBF1o6NP@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <6038462.HIH9pGNYO7@positron.chronox.de> <9a0a80fb-779e-b708-990e-1627ec03b1b7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tomas Mraz <tmraz@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9a0a80fb-779e-b708-990e-1627ec03b1b7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 21. Juni 2016, 13:54:13 schrieb Austin S. Hemmelgarn:

Hi Austin,

> On 2016-06-21 13:23, Stephan Mueller wrote:
> > Am Dienstag, 21. Juni 2016, 13:18:33 schrieb Austin S. Hemmelgarn:
> > 
> > Hi Austin,
> > 
> >>> You have to trust the host for anything, not just for the entropy in
> >>> timings. This is completely invalid argument unless you can present a
> >>> method that one guest can manipulate timings in other guest in such a
> >>> way that _removes_ the inherent entropy from the host.
> >> 
> >> When dealing with almost any type 2 hypervisor, it is fully possible for
> >> a user other than the one running the hypervisor to manipulate
> >> scheduling such that entropy is reduced.  This does not imply that the
> > 
> > Please re-read the document: Jitter RNG does not rest on scheduling.
> 
> If you are running inside a VM, your interrupt timings depend on the

The RNG does not rest on interrupts either.

> hpyervisor's scheduling, period.  You may not directly rely on
> scheduling from the OS you are running on, but if you are doing anything
> timing related in a VM, you are at the mercy of the scheduling used by
> the hypervisor and whatever host OS that may be running on.
> 
> In the attack I"m describing, the malicious user is not manipulating the
> guest OS's scheduling, they are manipulating the host system's scheduling.


Ciao
Stephan

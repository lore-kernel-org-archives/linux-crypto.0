From: Andi Kleen <andi@firstfloor.org>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 10:38:25 -0700
Message-ID: <20160425173825.GB13997@two.firstfloor.org>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
 <87twipn05w.fsf@tassilo.jf.intel.com>
 <31776489.IE3eGLxohC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31776489.IE3eGLxohC@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 25, 2016 at 07:25:55PM +0200, Stephan Mueller wrote:
> Am Montag, 25. April 2016, 09:06:03 schrieb Andi Kleen:
> 
> Hi Andi,
> 
> > Sandy Harris <sandyinchina@gmail.com> writes:
> > 
> > There is also the third problem of horrible scalability of /dev/random
> > output on larger systems, for which patches are getting ignored.
> > 
> > https://lkml.org/lkml/2016/2/10/716
> > 
> > Ignoring problems does not make them go away.
> 
> I have seen your patches, but I am not fully sure I understand the root cause. 
> is the noise source handling the issue or the random number generation the 
> issue?

Noise source handling is fine, the problem is the global locking on the
entropy pools when generating random numbers.

> If it is the latter, can you explain where the scalability issue comes in?

A single pool which is locked/written to does not scale. Larger systems
need multiple pools

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

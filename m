From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Tue, 13 Sep 2011 12:58:29 +0200
Message-ID: <1315911509.5977.1.camel@twins>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <201109080911.12921.sgrubb@redhat.com>
	 <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
	 <201109090904.18321.sgrubb@redhat.com>
	 <alpine.LFD.2.02.1109092241390.2723@ionos> <4E6E0F90.4090905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Steve Grubb <sgrubb@redhat.com>,
	Sandy Harris <sandyinchina@gmail.com>,
	Neil Horman <nhorman@redhat.com>,
	Tomas Mraz <tmraz@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Ted Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E6E0F90.4090905@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, 2011-09-12 at 09:56 -0400, Jarod Wilson wrote:
> Thomas Gleixner wrote:

> > Well, there is enough prove out there that the hardware you're using
> > is a perfect random number generator by itself.
> >
> > So stop complaining about not having access to TPM chips if you can
> > create an entropy source just by (ab)using the inherent randomness of
> > modern CPU architectures to refill your entropy pool on the fly when
> > the need arises w/o imposing completely unintuitive thresholds and
> > user visible API changes.
> 
> We started out going down that path:
> 
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05778.html
> 
> We hit a bit of a roadblock with it though.

Have you guys seen this work:

  http://lwn.net/images/conf/rtlws11/random-hardware.pdf

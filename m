From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Fri, 9 Sep 2011 23:27:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.02.1109092241390.2723@ionos>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com> <201109090904.18321.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Neil Horman <nhorman@redhat.com>,
	Tomas Mraz <tmraz@redhat.com>,
	Sasha Levin <levinsasha928@gmail.com>,
	Ted Ts'o <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
	linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	lkml <linux-kernel@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201109090904.18321.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 9 Sep 2011, Steve Grubb wrote:
> But what I was trying to say is that we can't depend on these supplemental hardware 
> devices like TPM because we don't have access to the proprietary technical details 
> that would be necessary to supplement the analysis. And when it comes to TPM chips, I 
> bet each chip has different details and entropy sources and entropy estimations and 
> rates. Those details we can't get at, so we can't solve the problem by including that 
> hardware. That is the point I was trying to make. :)

Well, there is enough prove out there that the hardware you're using
is a perfect random number generator by itself.

So stop complaining about not having access to TPM chips if you can
create an entropy source just by (ab)using the inherent randomness of
modern CPU architectures to refill your entropy pool on the fly when
the need arises w/o imposing completely unintuitive thresholds and
user visible API changes.

Thanks,

	tglx

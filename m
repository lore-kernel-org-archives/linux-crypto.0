From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Wed, 10 Aug 2016 19:44:25 -0400
Message-ID: <20160810234425.GG10523@thunk.org>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
 <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
 <20160809115622.GG9515@thunk.org>
 <20160809140444.GB2013@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160809140444.GB2013@io.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 09, 2016 at 02:04:44PM +0000, Jason Cooper wrote:
> 
> iiuc, Ted, you're saying using the hw_random framework would be
> disasterous because despite most drivers having a default quality of 0,
> rngd assumes 1 bit of entropy for every bit read?

Sorry, what I was trying to say (but failed) was that bypassing the
hwrng framework and injecting entropy directly the entropy pool was
disatrous.

> Thankfully, most hw_random drivers don't set the quality.  So unless the
> user sets the default_quality param, it's zero.

The fact that this is "most" and not "all" does scare me a little.

As far as I'm concerned *all* hw_random drivers should set quality to
zero, since it should be up to the system administrator.  Perhaps the
one exception is virtio_rng, since if you don't trust the hypvervisor,
the security of the VM is hopeless.  That being said, I have seen
configurations of KVM which use:

	-object rng-random,filename=/dev/urandom,id=rng0 \
	-device virtio-rng-pci,rng=rng0

Which is somewhat non-ideal.  (Try running od -x /dev/random on such a
guest system....)

					- Ted

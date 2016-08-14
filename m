From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Sun, 14 Aug 2016 18:11:14 +0000
Message-ID: <20160814181114.GM2013@io.lakedaemon.net>
References: <34197429.2CvoIfft9B@positron.chronox.de>
 <1654172.XfclnXhRmn@positron.chronox.de>
 <657897b90b8344eeab10d7a0f604988d@aptaiexm02f.ap.qualcomm.com>
 <1830987.VF9l4XmGxv@tauon.atsec.com>
 <20160808172930.GD4511@io.lakedaemon.net>
 <99963d34acea47bbacb3ca73b18fed9f@aptaiexm02f.ap.qualcomm.com>
 <20160809115622.GG9515@thunk.org>
 <20160809140444.GB2013@io.lakedaemon.net>
 <20160810234425.GG10523@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160810234425.GG10523@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Ted,

On Wed, Aug 10, 2016 at 07:44:25PM -0400, Theodore Ts'o wrote:
> On Tue, Aug 09, 2016 at 02:04:44PM +0000, Jason Cooper wrote:
> > iiuc, Ted, you're saying using the hw_random framework would be
> > disasterous because despite most drivers having a default quality of 0,
> > rngd assumes 1 bit of entropy for every bit read?
> 
> Sorry, what I was trying to say (but failed) was that bypassing the
> hwrng framework and injecting entropy directly the entropy pool was
> disatrous.

Ok, whew. :)

> > Thankfully, most hw_random drivers don't set the quality.  So unless the
> > user sets the default_quality param, it's zero.
> 
> The fact that this is "most" and not "all" does scare me a little.

My recent grep showed that only virtio-rng set it to a non-zero value.

> As far as I'm concerned *all* hw_random drivers should set quality to
> zero, since it should be up to the system administrator.

Agreed.

Gathering conversation about this from a few related threads, I have one
concern.  Apparently there is some confusion in userspace consumers of
/dev/hwrng data as to the quality of it.  Specifically, rngd (spotted by
Stephan Mueller) appears to assume 1bit of entropy per 1 bit read. :-/

So, while moving ath9k-rng to the hwrng framework makes complete sense
internally, it's not so good for existing userspace assumptions.  I'd
think that timeriomem-rng falls in this same category.

In light of this, do you think it's worth the effort (I'm volunteering)
to create a subcategory of hwrng drivers that are 'environemntal' rngs?
They can contribute to the kernel entropy pools, but not to /dev/hwrng.

thx,

Jason.

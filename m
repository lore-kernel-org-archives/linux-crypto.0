From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto: Add support for 192 & 256 bit keys to AESNI RFC4106 -
 resubmission
Date: Wed, 14 Jan 2015 22:00:58 +1100
Message-ID: <20150114110058.GC18099@gondor.apana.org.au>
References: <Pine.WNT.4.64.1501112342160.7768@Fly3>
 <20150113181641.GA54532@redhat.com>
 <4feca6bd058743cfa500f16394f50ff7@US-EXCH13-4.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarod Wilson <jarod@redhat.com>,
	Timothy McCaffrey <timcaffrey420@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56577 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbANLBF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jan 2015 06:01:05 -0500
Content-Disposition: inline
In-Reply-To: <4feca6bd058743cfa500f16394f50ff7@US-EXCH13-4.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 13, 2015 at 06:19:35PM +0000, McCaffrey, Timothy M wrote:
> > -----Original Message-----
> > From: Jarod Wilson [mailto:jarod@redhat.com]
> > Sent: Tuesday, January 13, 2015 1:17 PM
> > 
> > On Sun, Jan 11, 2015 at 11:48:08PM -0500, Timothy McCaffrey wrote:
> > > These patches fix the RFC4106 implementation in the aesni-intel module so
> > it
> > > supports 192 & 256 bit keys.
> > >
> > > Since the AVX support that was added to this module also only supports
> > 128 bit keys,
> > > and this patch only affects the SSE implementation, changes were also
> > made to
> > > use the SSE version if key sizes other than 128 are specified.
> > >
> > > RFC4106 specifies that 192 & 256 bit keys must be supported (section 8.4).
> > >
> > > Also, this should fix Strongswan issue 341 where the aesni module needs to
> > be
> > > unloaded if 256 bit keys are used:
> > >
> > > http://wiki.strongswan.org/issues/341
> > >
> > > This patch has been tested with Sandy Bridge and Haswell processors.  With
> > 128
> > > bit keys and input buffers > 512 bytes a slight performance degradation
> > was
> > > noticed (~1%).  For input buffers of less than 512 bytes there was no
> > > performance impact.  Compared to 128 bit keys, 256 bit key size
> > performance
> > > is approx. .5 cycles per byte slower on Sandy Bridge, and .37 cycles per
> > > byte slower on Haswell (vs. SSE code).
> > >
> > > This patch has also been tested with StrongSwan IPSec connections where
> > it
> > > worked correctly.
> > >
> > > I created this diff from a git clone of crypto-2.6.git.
> > >
> > > Any questions, please feel free to contact me.
> > >
> > > Signed off by: timothy.mccaffrey@unisys.com
> > 
> > Here's an unborked version that applies cleanly to linus' master right
> > now. Somehow, tons of extra spaces made their way into the original
> > (re-)submission, I just stripped them out (and fixed up a few extra
> > trailing spaces and spaces before tabs).
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

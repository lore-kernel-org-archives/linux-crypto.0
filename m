From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: gcm.c:undefined reference to `crypto_aead_setauthsize'
Date: Tue, 5 Apr 2016 15:19:30 +0800
Message-ID: <20160405071930.GA10527@gondor.apana.org.au>
References: <201604012329.Nnqft6lQ%fengguang.wu@intel.com>
 <20160404140004.GA4006@gondor.apana.org.au>
 <831EE4E5E37DCC428EB295A351E662491431DEF5@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Li, Philip" <philip.li@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51089 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277AbcDEHTs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 03:19:48 -0400
Content-Disposition: inline
In-Reply-To: <831EE4E5E37DCC428EB295A351E662491431DEF5@shsmsx102.ccr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 05, 2016 at 07:15:21AM +0000, Li, Philip wrote:
> 
> 
> > -----Original Message-----
> > From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> > Sent: Monday, April 4, 2016 10:00 PM
> > To: Wu, Fengguang <fengguang.wu@intel.com>
> > Cc: Sabrina Dubroca <sd@queasysnail.net>; kbuild-all@01.org;
> > linux-kernel@vger.kernel.org; Hannes Frederic Sowa
> > <hannes@stressinduktion.org>; Linux Crypto Mailing List
> > <linux-crypto@vger.kernel.org>
> > Subject: Re: gcm.c:undefined reference to `crypto_aead_setauthsize'
> > 
> > On Fri, Apr 01, 2016 at 03:02:30PM +0000, kbuild test robot wrote:
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > master
> > > head:   6ddf37da05cd71bf9e43349d607e810b43c9008a
> > > commit: c09440f7dcb304002dfced8c0fea289eb25f2da0 macsec: introduce
> > IEEE 802.1AE driver
> > > date:   3 weeks ago
> > > config: x86_64-randconfig-s3-04012139 (attached as .config)
> > > reproduce:
> > >         git checkout c09440f7dcb304002dfced8c0fea289eb25f2da0
> > >         # save the attached .config to linux build tree
> > >         make ARCH=x86_64
> > >
> > > All errors (new ones prefixed by >>):
> > >
> > >    crypto/built-in.o: In function `gcm_enc_copy_hash':
> > > >> gcm.c:(.text+0x278): undefined reference to `crypto_xor'
> > 
> > GCM is y but AEAD is only m, yet GCM selects AEAD.  Perhaps a kbuild bug?
> Thanks Herbert, currently we use make randconfig to generate this kconfig file, is it possible this is still a valid settings?

Sorry I didn't mean kbuild as in your build system, but kbuild as in
the kernel kbuild subsystem.

AFAICS, the Kconfig rules should forbid the situation in your
config file where GCM=y but AEAD=m because GCM selects AEAD.  So
the fact that it happened either means that there is something
that I am missing or that the kbuild subsystem is buggy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

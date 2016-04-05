From: "Li, Philip" <philip.li@intel.com>
Subject: RE: gcm.c:undefined reference to `crypto_aead_setauthsize'
Date: Tue, 5 Apr 2016 07:15:21 +0000
Message-ID: <831EE4E5E37DCC428EB295A351E662491431DEF5@shsmsx102.ccr.corp.intel.com>
References: <201604012329.Nnqft6lQ%fengguang.wu@intel.com>
 <20160404140004.GA4006@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Sabrina Dubroca <sd@queasysnail.net>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"Wu, Fengguang" <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160404140004.GA4006@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Monday, April 4, 2016 10:00 PM
> To: Wu, Fengguang <fengguang.wu@intel.com>
> Cc: Sabrina Dubroca <sd@queasysnail.net>; kbuild-all@01.org;
> linux-kernel@vger.kernel.org; Hannes Frederic Sowa
> <hannes@stressinduktion.org>; Linux Crypto Mailing List
> <linux-crypto@vger.kernel.org>
> Subject: Re: gcm.c:undefined reference to `crypto_aead_setauthsize'
> 
> On Fri, Apr 01, 2016 at 03:02:30PM +0000, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> master
> > head:   6ddf37da05cd71bf9e43349d607e810b43c9008a
> > commit: c09440f7dcb304002dfced8c0fea289eb25f2da0 macsec: introduce
> IEEE 802.1AE driver
> > date:   3 weeks ago
> > config: x86_64-randconfig-s3-04012139 (attached as .config)
> > reproduce:
> >         git checkout c09440f7dcb304002dfced8c0fea289eb25f2da0
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64
> >
> > All errors (new ones prefixed by >>):
> >
> >    crypto/built-in.o: In function `gcm_enc_copy_hash':
> > >> gcm.c:(.text+0x278): undefined reference to `crypto_xor'
> 
> GCM is y but AEAD is only m, yet GCM selects AEAD.  Perhaps a kbuild bug?
Thanks Herbert, currently we use make randconfig to generate this kconfig file, is it possible this is still a valid settings?

> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

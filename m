From: Petr Vorel <pvorel@suse.cz>
Subject: Re: Backport e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
Date: Fri, 24 Aug 2018 09:51:41 +0200
Message-ID: <20180824075141.GB1489@dell5510>
References: <20180823153101.GA27143@dell5510>
 <20180824020616.xfmfudk5aaejwm4j@gondor.apana.org.au>
Reply-To: Petr Vorel <pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180824020616.xfmfudk5aaejwm4j@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

> On Thu, Aug 23, 2018 at 05:31:01PM +0200, Petr Vorel wrote:
> > Hi,

> > I wonder, it it makes sense to backport commit
> > e666d4e9ceec crypto: vmx - Use skcipher for ctr fallback
> > to v 4.14 stable kernel.
> > I'm using it in 4.12+.

> > These commits (somehow similar) has been backported to 4.10.2:
> > 5839f555fa57 crypto: vmx - Use skcipher for xts fallback
> > c96d0a1c47ab crypto: vmx - Use skcipher for cbc fallback

> I think so.  Here is the patch which should be applied for all
> kernels since 4.10 up to and including 4.14:

Thanks a lot for confirmation and preparing the patch!


Kind regards,
Petr

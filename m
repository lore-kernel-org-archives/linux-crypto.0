From: Salvatore Benedetto <salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 07:36:44 +0100
Message-ID: <20160624063644.GA21443@localhost>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
 <20160624062316.GA16985@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
	linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160624062316.GA16985-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 24, 2016 at 07:23:16AM +0100, Herbert Xu wrote:
> On Fri, Jun 24, 2016 at 02:10:12PM +0800, Herbert Xu wrote:
> > On Fri, Jun 24, 2016 at 07:06:49AM +0100, Salvatore Benedetto wrote:
> > >
> > > can you squash the following patch?
> > 
> > No, please prune anything that we don't use from ecc.c.
> 
> I take that back.  I see it's actually coming from bluetooth.
> 
> How about moving ecc.c to lib so that it's shared between the
> two?

The patch was based on the current tree. I just pulled.
There is not point in moving to lib because bluetooth is
about to be converted to kpp. 
That patch I believe will go up the bluetooth tree, so
my suggestion is to simply accept that I fail to properly
name that symbol.

Renaming the symbol in net/bluetooth/ecc which I think will conflict
with the patch where I remove it completely which, again, I believe
will go up the BT tree.

Thanks,
Salvatore

> Thanks,
> -- 
> Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

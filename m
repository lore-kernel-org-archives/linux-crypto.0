From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Sun, 8 Nov 2015 09:50:03 -0800
Message-ID: <20151108175003.GT6114@lukather>
References: <1446709737-11316-1-git-send-email-clabbe.montjoie@gmail.com>
 <20151105160719.GG6114@lukather>
 <20151106045639.GA14722@gondor.apana.org.au>
Reply-To: maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwSwrS9OkH+FvIfA"
Cc: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	wens-jdAy2FN1RRM@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBT4W72YQKGQERONQN5A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151106045639.GA14722-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

--rwSwrS9OkH+FvIfA
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

On Fri, Nov 06, 2015 at 12:56:39PM +0800, Herbert Xu wrote:
> On Thu, Nov 05, 2015 at 08:07:19AM -0800, Maxime Ripard wrote:
> > 
> > On Thu, Nov 05, 2015 at 08:48:57AM +0100, LABBE Corentin wrote:
> > > sun4i-ss implementaton of md5/sha1 is via ahash algorithms.
> > > A recent change make impossible to load them without giving statesize.
> > 
> > Which one?
> 
> We recently disabled ahash drivers that do not declare statesize
> because it can lead to a crash when the driver is used through
> algif.

"Recently" is relative and really doesn't help.

Having the commit ID that made this change is an absolute reference,
and really helps to identify when that behaviour changed.

> Not declaring statesize is a bug anyway but the fact that it
> is exported through algif makes it much worse.
> 
> > > This patch specifiy statesize for sha1 and md5.
> > > 
> > > Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > 
> > Please also add a Fixes tag (and the stable version it applies to).
> 
> I don't see the point for a fixes tag as it would simply refer
> to the original patch-set that added the driver.

What's the problem with that?

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
--rwSwrS9OkH+FvIfA--

From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] crypto: sun4i-ss: add missing statesize
Date: Wed, 11 Nov 2015 14:22:10 -0800
Message-ID: <20151111222210.GI6114@lukather>
References: <1447006457@msgid.manchmal.in-ulm.de>
 <20151109035848.GA2163@gondor.apana.org.au>
Reply-To: maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LFN/h9p3ZzIorjyq"
Cc: Christoph Biedl <linux-kernel.bfrz-o6iJJGtClBpGEOBiBlW9YYQuADTiUCJX@public.gmane.org>,
	clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, wens-jdAy2FN1RRM@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-sunxi+bncBD2ZNBF5VYJRBFP7R2ZAKGQEBQ26CTA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109035848.GA2163-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

--LFN/h9p3ZzIorjyq
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

On Mon, Nov 09, 2015 at 11:58:48AM +0800, Herbert Xu wrote:
> Christoph Biedl <linux-kernel.bfrz-o6iJJGtClBpGEOBiBlW9YYQuADTiUCJX@public.gmane.org> wrote:
> >
> > Fixes: should rather point to the commit that caused the breakage in my
> > opinion. Which did this by intention:
> 
> Absolutely not.  That patch is correct and if you revert that
> you will simply end up registering a broken driver into the system
> that may then lead to crashes that can be triggered from user-space.

Yeah my point was that the commit log should be something like

"""
sun4i-ss implementaton of md5/sha1 is via ahash algorithms.

Commit 8996eafdcbad ('crypto: ahash - ensure statesize is non-zero')
made impossible to load them without giving statesize. This patch
specifiy statesize for sha1 and md5.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
"""

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
--LFN/h9p3ZzIorjyq--

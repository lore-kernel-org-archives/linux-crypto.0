From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: Convert arc4 from a cipher into a block cipher
Date: Tue, 6 Apr 2010 08:39:39 +0800
Message-ID: <20100406003939.GA21130@gondor.apana.org.au>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc> <1270499625.28743.37.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Roskin <proski-mXXj517/zsQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270499625.28743.37.camel@mj>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 05, 2010 at 04:33:45PM -0400, Pavel Roskin wrote:
>
> Are you trying to speed up arc4?  Or you want to simplify the code?  Or
> maybe you are trying to make arc4 unsuitable for anything other than WEP
> and TKIP?  The later should be fine, actually, considering the known
> security issues.

No the point is to make arc4 compliant with the crypto API by
being reentrant.

Functionality-wise there is no difference.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

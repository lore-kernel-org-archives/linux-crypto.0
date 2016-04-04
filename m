From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2] sunrpc: Fix skcipher/shash conversion
Date: Mon, 4 Apr 2016 09:22:02 +0800
Message-ID: <20160404012202.GA31970@gondor.apana.org.au>
References: <20160403001319.GB12588@fieldses.org>
 <20160403010952.GA25687@gondor.apana.org.au>
 <20160403035900.GB14318@fieldses.org>
 <20160403043715.GA26722@gondor.apana.org.au>
 <20160403221543.GB19744@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160403221543.GB19744-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 03, 2016 at 06:15:43PM -0400, J. Bruce Fields wrote:
>
> OK, I did get a chance to run this, and so far it looks good--it got
> faszter than the last time, anyway.  Thanks!

Thanks!

> For some reason, the original didn't appear to get cc'd to the linux-nfs
> list.  Or did it, and I missed it?  I do get lazy sometimes, but in
> general something like this I'd at least grab and run some tests on.
> Especially if there's a git tree I can grab, then it just takes me a
> minute to kick off.

I'm pretty sure it did get to linux-nfs, or at least the archive :)

https://www.spinics.net/lists/linux-nfs/msg56240.html

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

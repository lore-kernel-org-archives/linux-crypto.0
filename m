From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH 0/2] hwrng: chaoskey - Add support for Araneus Alea I USB
 RNG
Date: Wed, 8 Jun 2016 08:49:55 +0800
Message-ID: <20160608004954.GA11545@gondor.apana.org.au>
References: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
 <20160607105345.GE520@gondor.apana.org.au>
 <20160607220311.GB4744@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Keith Packard <keithp-aN4HjG94KOLQT0dZR+AlfA@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160607220311.GB4744-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 07, 2016 at 03:03:11PM -0700, Greg KH wrote:
>
> Ok, but usually drivers/usb/misc/ patches go through my tree :)

Sorry.  But I do wonder whether this driver should be moved as
it is just an hwrng device like every other driver under hw_random,
except for the fact that it happens to be a USB physical device.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

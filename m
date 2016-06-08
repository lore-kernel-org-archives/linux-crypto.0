From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 0/2] hwrng: chaoskey - Add support for Araneus Alea I USB
 RNG
Date: Tue, 7 Jun 2016 18:34:10 -0700
Message-ID: <20160608013410.GA22850@kroah.com>
References: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
 <20160607105345.GE520@gondor.apana.org.au>
 <20160607220311.GB4744@kroah.com>
 <20160608004954.GA11545@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Keith Packard <keithp-aN4HjG94KOLQT0dZR+AlfA@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160608004954.GA11545-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 08, 2016 at 08:49:55AM +0800, Herbert Xu wrote:
> On Tue, Jun 07, 2016 at 03:03:11PM -0700, Greg KH wrote:
> >
> > Ok, but usually drivers/usb/misc/ patches go through my tree :)
> 
> Sorry.  But I do wonder whether this driver should be moved as
> it is just an hwrng device like every other driver under hw_random,
> except for the fact that it happens to be a USB physical device.

That's fine with me, but it uses the usb misc device major number,
unlike other hw_random drivers, so that might get messy.

It's your call...

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH] hwrng: alea - Add support for Araneus Alea I USB RNG
Date: Thu, 2 Jun 2016 12:43:16 +0200
Message-ID: <c68e0fd6-f12f-f127-1cc9-896ab7a3d079@ladisch.de>
References: <1464853939-7027-1-git-send-email-bob.ham@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Keith Packard <keithp-aN4HjG94KOLQT0dZR+AlfA@public.gmane.org>
To: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464853939-7027-1-git-send-email-bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Bob Ham wrote:
> Adds support for the Araneus Alea I USB hardware Random Number
> Generator.  This RNG creates entropy at a high rate, about 100kb/s.
>
> Signed-off-by: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
> ---
>
> +++ b/drivers/char/hw_random/alea.c

Why didn't you just add the device ID to chaoskey.c?
(Because that one is hidden in drivers/usb/misc? ;-)


Regards,
Clemens
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH 0/2] hwrng: chaoskey - Add support for Araneus Alea I USB RNG
Date: Fri,  3 Jun 2016 12:13:06 +0100
Message-ID: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Keith Packard <keithp-aN4HjG94KOLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Two patches to add support for the Araneus Alea I USB RNG to the
chaoskey driver.  The first simply includes the Alea I as a device,
the second fixes an issue with the timeout on the first read.

Bob Ham (2):
  hwrng: chaoskey - Add support for Araneus Alea I USB RNG
  hwrng: chaoskey - Fix URB warning due to timeout on Alea

 drivers/usb/misc/Kconfig    | 11 ++++++-----
 drivers/usb/misc/chaoskey.c | 21 +++++++++++++++++++--
 2 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Kalle Valo <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
Subject: Re: [v2] RANDOM: ATH9K RNG delivers zero bits of entropy
Date: Tue, 27 Sep 2016 16:44:16 +0200
Message-ID: <2ba03f89daee4f09a88a1238943eb49d@euamsexm01a.eu.qualcomm.com>
References: <1654172.XfclnXhRmn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>, <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <ath9k-devel-xDcbHBWguxHbcTqmT+pZeQ@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        "Jason Cooper" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1654172.XfclnXhRmn-jJGQKZiSfeo1haGO/jJMPxvVK+yQ3ZXh@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org> wrote:
> The ATH9K driver implements an RNG which is completely bypassing the
> standard Linux HW generator logic.
> 
> The RNG may or may not deliver entropy. Considering the conservative
> approach in treating entropy with respect to non-auditable sources, this
> patch changes the delivered entropy value to zero. The RNG still feeds
> data into the input_pool but it is assumed to have no entropy.
> 
> When the ATH9K RNG changes to use the HW RNG framework, it may re-enable
> the entropy estimation considering that a user can change that value at
> boot and runtime.
> 
> Reviewed-by: Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>
> Signed-off-by: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>

Based on the discussion I'm dropping this patch. But the discussion was
hard to follow so please let me know if I misunderstood.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/9266265/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

From: Kalle Valo <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>
Subject: Re: [1/2] ath9k: change entropy formula for easier understanding
Date: Tue, 27 Sep 2016 16:53:23 +0200
Message-ID: <e8039ab4dcaa4f31841456ac2d196c92@euamsexm01a.eu.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>,
        <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>,
        Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
To: miaoqing pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470726147-30095-1-git-send-email-miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

miaoqing pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> From: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> The quality of ADC entropy is 10 bits of min-entropy for
> a 32-bit value, change '(((x) * 8 * 320) >> 10)' to
> '(((x) * 8 * 10) >> 5)' for easier understanding.
> 
> Signed-off-by: Miaoqing Pan <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

I need some help here, it this patch ok to take or should I drop it? The
discussion is available from the patchwork link below if someone needs to
refresh the memory.

-- 
https://patchwork.kernel.org/patch/9270463/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

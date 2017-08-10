From: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Subject: Re: [PATCH v4 2/4] crypto: add crypto_(un)register_ahashes()
Date: Thu, 10 Aug 2017 16:54:16 +0200
Message-ID: <6d27d00b-cac9-d613-90ec-782815266b87@axis.com>
References: <cover.1502368677.git.larper@axis.com>
 <01cfbf11707a9907d87c59fb47385c4178a08688.1502368677.git.larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
To: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01cfbf11707a9907d87c59fb47385c4178a08688.1502368677.git.larper-VrBV9hrLPhE@public.gmane.org>
Content-Language: sv
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 08/10/2017 02:53 PM, Lars Persson wrote:
> From: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
> 
> There are already helpers to (un)register multiple normal
> and AEAD algos.  Add one for ahashes too.
> 
> Signed-off-by: Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
> Signed-off-by: Rabin Vincent <rabinv-VrBV9hrLPhE@public.gmane.org>
> ---
> v4: crypto_register_skciphers was used where crypto_unregister_skciphers
>      was intended.
>

The v4 change comment above in fact belongs to patch 3/4 of this series. 
Sorry for the confusion.

BR,
  Lars
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

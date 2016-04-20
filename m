From: Vladimir Zapolskiy <vz-ChpfBGZJDbMAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] crypto: s5p-sss - Remove useless hash interrupt
 handler
Date: Wed, 20 Apr 2016 13:04:02 +0300
Message-ID: <57175412.4070501@mleia.com>
References: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
 <1461073452-10426-2-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461073452-10426-2-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 19.04.2016 16:44, Krzysztof Kozlowski wrote:
> Beside regular feed control interrupt, the driver requires also hash
> interrupt for older SoCs (samsung,s5pv210-secss). However after
> requesting it, the interrupt handler isn't doing anything with it, not
> even clearing the hash interrupt bit.
> 
> Driver does not provide hash functions so it is safe to remove the hash
> interrupt related code and to not require the interrupt in Device Tree.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

Thank you for the change.

Acked-by: Vladimir Zapolskiy <vz-ChpfBGZJDbMAvxtiuMwx3w@public.gmane.org>

> ---
>  .../devicetree/bindings/crypto/samsung-sss.txt     |  6 ++--
>  drivers/crypto/s5p-sss.c                           | 34 ++++------------------
>  2 files changed, 8 insertions(+), 32 deletions(-)
> 

---
With best wishes,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Wed, 16 Nov 2011 12:44:50 +0530
Message-ID: <4EC362EA.3020204@nvidia.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com> <20111105181025.69918e625a169ccb30d9b7c8@freescale.com> <4EBE48E8.60205@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com> <4EC1E642.2090309@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF1740805D40@HQMAIL01.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>,
	"herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805D40-C7FfzLzN0UxDw2glCA4ptUEOCMrvLtNR@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


> That doesn't make the duplicate memset/copy cease to be redundant.
>
> Why not copy the key to where it goes, then memset the rest of the data;
> wouldn't that be as simple as:
>
> memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> memset(dd->ivkey_base + ctx->keylen, 0, AES_HW_KEY_TABLE_LENGTH_BYTES - ctx->keylen);

Seems like the same thing to me. Kim is inclined towards removing the
memset completely, which I think should not be done. We need the memset
to clear the entire key table.

> Related to this, I wonder why:
>
> /*
>  * The key table length is 64 bytes
>  * (This includes first upto 32 bytes key + 16 bytes original initial vector
>  * and 16 bytes updated initial vector)
>  */ 
> #define AES_HW_KEY_TABLE_LENGTH_BYTES 64
>
> Yet:
>
> dd->ivkey_base = dma_alloc_coherent(dev, SZ_512, &dd->ivkey_phys_base, ...
>
> Why is SZ_512 used to during alloc instead of AES_HW_KEY_TABLE_LENGTH_BYTES?

Correct. Will fix this.

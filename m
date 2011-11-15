From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v1] crypto: driver for tegra AES hardware
Date: Tue, 15 Nov 2011 08:10:09 -0800
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805D40@HQMAIL01.nvidia.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
 <20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
 <4EBE48E8.60205@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
 <4EC1E642.2090309@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>,
	"herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC1E642.2090309-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Varun Wadekar wrote at Monday, November 14, 2011 9:11 PM:
> >> Why?
> > To avoid redundant work; there's little point memset()ing a region that's
> > going to be copied over the top of immediately afterwards.
> >
> 
> The length used for memset is different from the length being copied
> over. I am initially memsetting the entire key struct (which contains
> the key + original IV + updated IV) and then copying only the key. Down
> the line we copy the original IV and/or the updated IV in this memory space.

That doesn't make the duplicate memset/copy cease to be redundant.

Why not copy the key to where it goes, then memset the rest of the data;
wouldn't that be as simple as:

memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
memset(dd->ivkey_base + ctx->keylen, 0, AES_HW_KEY_TABLE_LENGTH_BYTES - ctx->keylen);

Related to this, I wonder why:

/*
 * The key table length is 64 bytes
 * (This includes first upto 32 bytes key + 16 bytes original initial vector
 * and 16 bytes updated initial vector)
 */ 
#define AES_HW_KEY_TABLE_LENGTH_BYTES 64

Yet:

dd->ivkey_base = dma_alloc_coherent(dev, SZ_512, &dd->ivkey_phys_base, ...

Why is SZ_512 used to during alloc instead of AES_HW_KEY_TABLE_LENGTH_BYTES?

--
nvpublic

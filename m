From: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v1] crypto: driver for tegra AES hardware
Date: Mon, 14 Nov 2011 09:26:16 -0800
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
 <20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
 <4EBE48E8.60205@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EBE48E8.60205-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Varun Wadekar wrote at Saturday, November 12, 2011 3:23 AM:
> >> +	/* assign new context to device */
> >> +	ctx->dd = dd;
> >> +	dd->ctx = ctx;
> >> +
> >> +	if (ctx->flags & FLAGS_NEW_KEY) {
> >> +		/* copy the key */
> >> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> >> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> > these really should be writes to mutually exclusive addresses.
> 
> Why?

To avoid redundant work; there's little point memset()ing a region that's
going to be copied over the top of immediately afterwards.

-- 
nvpublic

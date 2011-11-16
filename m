From: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Wed, 16 Nov 2011 02:57:20 -0600
Message-ID: <20111116025720.27e6b710e8b333612862bb2e@freescale.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
	<20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
	<4EBE48E8.60205@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
	<4EC1E642.2090309@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805D40@HQMAIL01.nvidia.com>
	<4EC362EA.3020204@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Stephen Warren <swarren-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>,
	"herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org" <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC362EA.3020204-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 16 Nov 2011 12:44:50 +0530
Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> > That doesn't make the duplicate memset/copy cease to be redundant.
> >
> > Why not copy the key to where it goes, then memset the rest of the data;
> > wouldn't that be as simple as:
> >
> > memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> > memset(dd->ivkey_base + ctx->keylen, 0, AES_HW_KEY_TABLE_LENGTH_BYTES - ctx->keylen);
> 
> Seems like the same thing to me.

it's not - it saves writes.

> Kim is inclined towards removing the
> memset completely, which I think should not be done. We need the memset
> to clear the entire key table.

why do you need to clear the entire key table if it will be
overwritten anyway?

Kim

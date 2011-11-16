From: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Wed, 16 Nov 2011 03:17:03 -0600
Message-ID: <20111116031703.e006c81ebf5368365e7a22fb@freescale.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
	<20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
	<4EBE48E8.60205@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
	<4EC1E642.2090309@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805D40@HQMAIL01.nvidia.com>
	<4EC362EA.3020204@nvidia.com>
	<20111116025720.27e6b710e8b333612862bb2e@freescale.com>
	<4EC37CBC.4060806@nvidia.com>
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
In-Reply-To: <4EC37CBC.4060806-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 16 Nov 2011 14:35:00 +0530
Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> 
> > it's not - it saves writes.
> 
> Are you ok with this solution? Either way I wan to start with a clear
> key table before programming the hardware.

the hardware doesn't care.

> > why do you need to clear the entire key table if it will be
> > overwritten anyway?
> 
> If you set a > 128-bit key and then set a 128-bit key, the remaining
> bits still remain in the key table. Similarly, if we use updated IV in
> one operation and want to use the initial IV for the next, the updated
> IV will still remain in the key table. The entire key table is copied to
> the AES engine. Even though, we program the engine with the exact number
> of bits to use for the key and whether to use the updated/initial IV, I
> feel its better if the unused bits are zero instead of having garbage.

you're losing free performance.

Kim

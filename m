From: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] Add Hisilicon Random Number Generator(RNG) support
Date: Thu, 7 Apr 2016 16:23:15 +0800
Message-ID: <1460017397-30996-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	<guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	"Rob Herring" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patchset add the Hisilicon Random Number Generator(RNG) support.

Changes since v1:
- Rename compatible name from "hisilicon,hisi-rng" to "hisilicon,rng"

Kefeng Wang (2):
  dt/bindings: Add bindings for hisilicon random number generator
  hwrng: hisi: Add support for Hisilicon SoC RNG

 Documentation/devicetree/bindings/rng/hisi-rng.txt |  12 ++
 drivers/char/hw_random/Kconfig                     |  13 +++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/hisi-rng.c                  | 121 +++++++++++++++++++++
 4 files changed, 147 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
 create mode 100644 drivers/char/hw_random/hisi-rng.c

-- 
2.6.0.GIT

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

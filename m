From: <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/2] hwrng: mtk: add support for hardware random generator on MT7623 SoC
Date: Thu, 13 Apr 2017 15:05:06 +0800
Message-ID: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <keyhaede-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
To: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <romain.perier-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, <shannon.nelson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>

This patchset introduces support for Mediatek hardware random generator (RNG)
Currently, the driver is already tested successfully with rng-tools on MT7623
SoC. And it should also be workable on other similar Mediatek SoCs.

SoC that also works on other similar SoCs. 
Sean Wang (2):
  dt-bindings: hwrng: Add Mediatek hardware random generator bindings
  hwrng: mtk: Add driver for hardware random generator on MT7623 SoC

 Documentation/devicetree/bindings/rng/mtk-rng.txt |  18 +++
 drivers/char/hw_random/Kconfig                    |  16 +-
 drivers/char/hw_random/Makefile                   |   2 +-
 drivers/char/hw_random/mtk-rng.c                  | 174 ++++++++++++++++++++++
 4 files changed, 208 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/mtk-rng.txt
 create mode 100644 drivers/char/hw_random/mtk-rng.c

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

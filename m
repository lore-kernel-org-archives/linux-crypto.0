From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 0/2] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Fri,  1 Mar 2013 12:37:51 +0100
Message-ID: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, kernel@pengutronix.de,
	gcembed@gmail.com, shawn.guo@linaro.org, arnd@arndb.de,
	swarren@nvidia.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
the following changes since v2:
- Merge device tree binding with the driver code in the same patch.
- Specify that currently, only i.MX27 is supported in device tree binding.
- Replace MACH_MX27 by ARCH_MXC in Kconfig.
- Remove __devexit_p from sahara_remove().

I haven't finally included support for i.MX51 submitted by Arnaud.
I'd rather it to be included in a separate patch later if you
don't mind.

[PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
[PATCH v3 2/2] crypto: sahara: Add driver for SAHARA2 accelerator.

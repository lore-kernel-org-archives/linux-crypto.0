From: Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Wed, 27 Feb 2013 11:41:48 +0100
Message-ID: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
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
this v2 of the series solves several issues pointed out by Arnd Bergmann
and Arnaud Patard.

Moreover, it drops platform support and relies only on device tree (compile
tested only).

[PATCH v2 1/3] i.MX27: Add clock support for SAHARA2.
[PATCH v2 2/3] crypto: sahara: Add driver for SAHARA2 accelerator.
[PATCH v2 3/3] crypto: sahara: Add device tree binding for SAHARA2.

From: Scott Branden <sbranden@broadcom.com>
Subject: [PATCH v3 0/2] Add support for Broadcom RNG200
Date: Wed, 4 Mar 2015 12:42:12 -0800
Message-ID: <1425501734-14025-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ray Jui <rjui@broadcom.com>,
	Jonathan Richardson <jonathar@broadcom.com>,
	Dmitry Torokhov <dtor@google.com>,
	Anatol Pomazao <anatol@google.com>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	Scott Branden <sbranden@broadcom.com>
To: <bcm-kernel-feedback-list@broadcom.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Ian Campbell" <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Grant Likely <grant.likely@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Scott Branden <sbranden@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This series of patchsets contains the Broadcom Random Number Generator
driver and device tree binding documentation.

Changes from v2:
 added usleep_range instead of cpu_relax
 add init and cleanup functions following new hwrng model
 
Changes from v1:
 added \n to 2 dev_err messages

Scott Branden (2):
  hwrng: iproc-rng200 - Add device tree bindings
  hwrng: iproc-rng200 - Add Broadcom IPROC RNG driver

 .../bindings/hwrng/brcm,iproc-rng200.txt           |  12 +
 drivers/char/hw_random/Kconfig                     |  13 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/iproc-rng200.c              | 254 +++++++++++++++++++++
 4 files changed, 280 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwrng/brcm,iproc-rng200.txt
 create mode 100644 drivers/char/hw_random/iproc-rng200.c

-- 
2.3.0

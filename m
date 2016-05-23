From: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: [PATCH 0/4] hw rng support for NSP SoC
Date: Mon, 23 May 2016 12:20:47 -0400
Message-ID: <1464020451-16520-1-git-send-email-yendapally.reddy@broadcom.com>
Cc: devicetree@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	bcm-kernel-feedback-list@broadcom.com,
	linux-crypto@vger.kernel.org,
	Yendapally Reddy Dhananjaya Reddy
	<yendapally.reddy@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Lee Jones <lee@kernel.org>, Eric Anholt <eric@anholt.net>,
	Russell King <linux@arm.linux.org.uk>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Jon Mason <jonmason@broadcom.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Kieran Bingham <kieranbingham@gmail.com>,
	Pankaj Dev <pankaj.dev@st.com>,
	Richard Weinberger <richard@nod.at>, noltari@gmail.com,
	Joshua Henderson <joshua.henderson@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset contains the hw random number generator support for the
Broadcom's NSP SoC. The block is similar to the block available in
bcm2835 with different default interrupt mask value. Due to lack of
documentation, I cannot confirm the interrupt mask register details
in bcm2835. In an effort to not break the existing functionality of
bcm2835, I used a different compatible string to mask the interrupt
for NSP SoC. Please let me know. Also supported providing requested
number of random numbers instead of static size of four bytes.

The first patch contains the documentation changes and the second patch
contains the support for rng available in NSP SoC. The third patch
contains the device tree changes for NSP SoC. The fourth patch contains
the support for reading requested number of random numbers.

This patch set has been tested on NSP bcm958625HR board.
This patch set is based on v4.6.0-rc1 and is available from github
repo: https://github.com/Broadcom/cygnus-linux.git
branch: nsp-rng-v1

Yendapally Reddy Dhananjaya Reddy (4):
  dt-bindings: rng: Northstar Plus SoC rng bindings
  hwrng: bcm2835: Support Broadcom NSP SoC rng
  ARM: dts: nsp: Add rng device tree entry
  hwrng: bcm2835: Read as much data as available

 .../devicetree/bindings/rng/brcm,bcm2835.txt       |  7 +++-
 arch/arm/boot/dts/bcm-nsp.dtsi                     |  5 +++
 drivers/char/hw_random/Kconfig                     |  2 +-
 drivers/char/hw_random/bcm2835-rng.c               | 46 +++++++++++++++++++---
 4 files changed, 52 insertions(+), 8 deletions(-)

-- 
2.1.0

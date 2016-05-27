From: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Subject: [PATCH v2 4/4] hwrng: bcm2835: Read as much data as available
Date: Fri, 27 May 2016 06:10:41 -0400
Message-ID: <1464343841-29504-5-git-send-email-yendapally.reddy@broadcom.com>
References: <1464343841-29504-1-git-send-email-yendapally.reddy@broadcom.com>
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
In-Reply-To: <1464343841-29504-1-git-send-email-yendapally.reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Read the requested number of data from the fifo

Signed-off-by: Yendapally Reddy Dhananjaya Reddy <yendapally.reddy@broadcom.com>
Reviewed-by: Eric Anholt <eric@anholt.net>
---
 drivers/char/hw_random/bcm2835-rng.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index b1e8b78..75ca820 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -43,6 +43,8 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 			       bool wait)
 {
 	void __iomem *rng_base = (void __iomem *)rng->priv;
+	u32 max_words = max / sizeof(u32);
+	u32 num_words, count;
 
 	while ((__raw_readl(rng_base + RNG_STATUS) >> 24) == 0) {
 		if (!wait)
@@ -50,8 +52,14 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 		cpu_relax();
 	}
 
-	*(u32 *)buf = __raw_readl(rng_base + RNG_DATA);
-	return sizeof(u32);
+	num_words = readl(rng_base + RNG_STATUS) >> 24;
+	if (num_words > max_words)
+		num_words = max_words;
+
+	for (count = 0; count < num_words; count++)
+		((u32 *)buf)[count] = readl(rng_base + RNG_DATA);
+
+	return num_words * sizeof(u32);
 }
 
 static struct hwrng bcm2835_rng_ops = {
-- 
2.1.0

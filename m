From: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 3/3] hwrng: st: Improve FIFO size/depth description
Date: Wed,  7 Oct 2015 13:23:29 +0100
Message-ID: <1444220609-31251-4-git-send-email-lee.jones@linaro.org>
References: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, pankaj.dev@st.com,
	daniel.thompson@linaro.org, linux@arm.linux.org.uk,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The original representation of FIFO size in the driver coupled with the
ambiguity in the documentation meant that it was easy to confuse readers.
This lead to a false positive BUG-find and subsequently time wastage
debugging this phantom issue.

Hopefully this patch can prevent future readers from falling into the
same trap.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/char/hw_random/st-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 17f0a09..1d35363 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -29,8 +29,9 @@
 #define ST_RNG_STATUS_BAD_ALTERNANCE	BIT(1)
 #define ST_RNG_STATUS_FIFO_FULL		BIT(5)
 
-#define ST_RNG_FIFO_SIZE		8
 #define ST_RNG_SAMPLE_SIZE		2 /* 2 Byte (16bit) samples */
+#define ST_RNG_FIFO_DEPTH		4
+#define ST_RNG_FIFO_SIZE		(ST_RNG_FIFO_DEPTH * ST_RNG_SAMPLE_SIZE)
 
 /*
  * Samples are documented to be available every 0.667us, so in theory
-- 
1.9.1

From: Lee Jones <lee.jones@linaro.org>
Subject: [RESEND 2/3] hwrng: st: Use real-world device timings for timeout
Date: Tue,  6 Oct 2015 17:12:50 +0100
Message-ID: <1444147971-25778-2-git-send-email-lee.jones@linaro.org>
References: <1444147971-25778-1-git-send-email-lee.jones@linaro.org>
Cc: kernel@stlinux.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, pankaj.dev@st.com, daniel.thompson@linaro.org,
	Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444147971-25778-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Samples are documented to be available every 0.667us, so in theory
the 8 sample deep FIFO should take 5.336us to fill.  However, during
thorough testing, it became apparent that filling the FIFO actually
takes closer to 12us.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/char/hw_random/st-rng.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 8c8a435..a1ff080 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -32,8 +32,13 @@
 #define ST_RNG_FIFO_SIZE		8
 #define ST_RNG_SAMPLE_SIZE		2 /* 2 Byte (16bit) samples */
 
-/* Samples are available every 0.667us, which we round to 1us */
-#define ST_RNG_FILL_FIFO_TIMEOUT   (1 * (ST_RNG_FIFO_SIZE / ST_RNG_SAMPLE_SIZE))
+/*
+ * Samples are documented to be available every 0.667us, so in theory
+ * the 8 sample deep FIFO should take 5.336us to fill.  However, during
+ * thorough testing, it became apparent that filling the FIFO actually
+ * takes closer to 12us.
+ */
+#define ST_RNG_FILL_FIFO_TIMEOUT	12
 
 struct st_rng_data {
 	void __iomem	*base;
-- 
1.9.1

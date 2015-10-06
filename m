From: Lee Jones <lee.jones@linaro.org>
Subject: [RESEND 3/3] hwrng: st: Report correct FIFO size
Date: Tue,  6 Oct 2015 17:12:51 +0100
Message-ID: <1444147971-25778-3-git-send-email-lee.jones@linaro.org>
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

The values supplied to the 'read random data from FIFO' arithmetic
are not correct.  The value fed in to initialise the iterator
describes the FIFO depth, but then the iterator is treated in
Bytes and subsequently increased by 2 in value for every read
word.  This means only 4 of the 8 available values are being read
during each invocation of .read().

This change increased the device bandwidth by a factor of 2.

Reported-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/char/hw_random/st-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index a1ff080..3b1432c 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -29,8 +29,9 @@
 #define ST_RNG_STATUS_BAD_ALTERNANCE	BIT(1)
 #define ST_RNG_STATUS_FIFO_FULL		BIT(5)
 
-#define ST_RNG_FIFO_SIZE		8
 #define ST_RNG_SAMPLE_SIZE		2 /* 2 Byte (16bit) samples */
+#define ST_RNG_FIFO_DEPTH		8
+#define ST_RNG_FIFO_SIZE		(ST_RNG_FIFO_DEPTH * ST_RNG_SAMPLE_SIZE)
 
 /*
  * Samples are documented to be available every 0.667us, so in theory
-- 
1.9.1

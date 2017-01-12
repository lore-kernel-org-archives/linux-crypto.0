From: Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH 3/4] n2rng: support new hardware register layout
Date: Thu, 12 Jan 2017 10:52:48 -0800
Message-ID: <1484247169-245086-4-git-send-email-shannon.nelson@oracle.com>
References: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484247169-245086-1-git-send-email-shannon.nelson@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the new register layout constants and the requisite logic
for using them.

Signed-off-by: Shannon Nelson <shannon.nelson@oracle.com>
---
 drivers/char/hw_random/n2-drv.c |  144 +++++++++++++++++++++++++++++----------
 drivers/char/hw_random/n2rng.h  |   36 +++++++---
 2 files changed, 134 insertions(+), 46 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 74c26c7..f0bd5ee 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -302,26 +302,57 @@ static int n2rng_try_read_ctl(struct n2rng *np)
 	return n2rng_hv_err_trans(hv_err);
 }
 
-#define CONTROL_DEFAULT_BASE		\
-	((2 << RNG_CTL_ASEL_SHIFT) |	\
-	 (N2RNG_ACCUM_CYCLES_DEFAULT << RNG_CTL_WAIT_SHIFT) |	\
-	 RNG_CTL_LFSR)
-
-#define CONTROL_DEFAULT_0		\
-	(CONTROL_DEFAULT_BASE |		\
-	 (1 << RNG_CTL_VCO_SHIFT) |	\
-	 RNG_CTL_ES1)
-#define CONTROL_DEFAULT_1		\
-	(CONTROL_DEFAULT_BASE |		\
-	 (2 << RNG_CTL_VCO_SHIFT) |	\
-	 RNG_CTL_ES2)
-#define CONTROL_DEFAULT_2		\
-	(CONTROL_DEFAULT_BASE |		\
-	 (3 << RNG_CTL_VCO_SHIFT) |	\
-	 RNG_CTL_ES3)
-#define CONTROL_DEFAULT_3		\
-	(CONTROL_DEFAULT_BASE |		\
-	 RNG_CTL_ES1 | RNG_CTL_ES2 | RNG_CTL_ES3)
+static u64 n2rng_control_default(struct n2rng *np, int ctl)
+{
+	u64 val = 0;
+
+	if (np->data->chip_version == 1) {
+		val = ((2 << RNG_v1_CTL_ASEL_SHIFT) |
+			(N2RNG_ACCUM_CYCLES_DEFAULT << RNG_v1_CTL_WAIT_SHIFT) |
+			 RNG_CTL_LFSR);
+
+		switch (ctl) {
+		case 0:
+			val |= (1 << RNG_v1_CTL_VCO_SHIFT) | RNG_CTL_ES1;
+			break;
+		case 1:
+			val |= (2 << RNG_v1_CTL_VCO_SHIFT) | RNG_CTL_ES2;
+			break;
+		case 2:
+			val |= (3 << RNG_v1_CTL_VCO_SHIFT) | RNG_CTL_ES3;
+			break;
+		case 3:
+			val |= RNG_CTL_ES1 | RNG_CTL_ES2 | RNG_CTL_ES3;
+			break;
+		default:
+			break;
+		}
+
+	} else {
+		val = ((2 << RNG_v2_CTL_ASEL_SHIFT) |
+			(N2RNG_ACCUM_CYCLES_DEFAULT << RNG_v2_CTL_WAIT_SHIFT) |
+			 RNG_CTL_LFSR);
+
+		switch (ctl) {
+		case 0:
+			val |= (1 << RNG_v2_CTL_VCO_SHIFT) | RNG_CTL_ES1;
+			break;
+		case 1:
+			val |= (2 << RNG_v2_CTL_VCO_SHIFT) | RNG_CTL_ES2;
+			break;
+		case 2:
+			val |= (3 << RNG_v2_CTL_VCO_SHIFT) | RNG_CTL_ES3;
+			break;
+		case 3:
+			val |= RNG_CTL_ES1 | RNG_CTL_ES2 | RNG_CTL_ES3;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return val;
+}
 
 static void n2rng_control_swstate_init(struct n2rng *np)
 {
@@ -336,10 +367,10 @@ static void n2rng_control_swstate_init(struct n2rng *np)
 	for (i = 0; i < np->num_units; i++) {
 		struct n2rng_unit *up = &np->units[i];
 
-		up->control[0] = CONTROL_DEFAULT_0;
-		up->control[1] = CONTROL_DEFAULT_1;
-		up->control[2] = CONTROL_DEFAULT_2;
-		up->control[3] = CONTROL_DEFAULT_3;
+		up->control[0] = n2rng_control_default(np, 0);
+		up->control[1] = n2rng_control_default(np, 1);
+		up->control[2] = n2rng_control_default(np, 2);
+		up->control[3] = n2rng_control_default(np, 3);
 	}
 
 	np->hv_state = HV_RNG_STATE_UNCONFIGURED;
@@ -399,6 +430,7 @@ static int n2rng_data_read(struct hwrng *rng, u32 *data)
 	} else {
 		int err = n2rng_generic_read_data(ra);
 		if (!err) {
+			np->flags |= N2RNG_FLAG_BUFFER_VALID;
 			np->buffer = np->test_data >> 32;
 			*data = np->test_data & 0xffffffff;
 			len = 4;
@@ -487,9 +519,21 @@ static void n2rng_dump_test_buffer(struct n2rng *np)
 
 static int n2rng_check_selftest_buffer(struct n2rng *np, unsigned long unit)
 {
-	u64 val = SELFTEST_VAL;
+	u64 val;
 	int err, matches, limit;
 
+	switch (np->data->id) {
+	case N2_n2_rng:
+	case N2_vf_rng:
+	case N2_kt_rng:
+	case N2_m4_rng:  /* yes, m4 uses the old value */
+		val = RNG_v1_SELFTEST_VAL;
+		break;
+	default:
+		val = RNG_v2_SELFTEST_VAL;
+		break;
+	}
+
 	matches = 0;
 	for (limit = 0; limit < SELFTEST_LOOPS_MAX; limit++) {
 		matches += n2rng_test_buffer_find(np, val);
@@ -512,14 +556,32 @@ static int n2rng_check_selftest_buffer(struct n2rng *np, unsigned long unit)
 static int n2rng_control_selftest(struct n2rng *np, unsigned long unit)
 {
 	int err;
+	u64 base, base3;
+
+	switch (np->data->id) {
+	case N2_n2_rng:
+	case N2_vf_rng:
+	case N2_kt_rng:
+		base = RNG_v1_CTL_ASEL_NOOUT << RNG_v1_CTL_ASEL_SHIFT;
+		base3 = base | RNG_CTL_LFSR |
+			((RNG_v1_SELFTEST_TICKS - 2) << RNG_v1_CTL_WAIT_SHIFT);
+		break;
+	case N2_m4_rng:
+		base = RNG_v2_CTL_ASEL_NOOUT << RNG_v2_CTL_ASEL_SHIFT;
+		base3 = base | RNG_CTL_LFSR |
+			((RNG_v1_SELFTEST_TICKS - 2) << RNG_v2_CTL_WAIT_SHIFT);
+		break;
+	default:
+		base = RNG_v2_CTL_ASEL_NOOUT << RNG_v2_CTL_ASEL_SHIFT;
+		base3 = base | RNG_CTL_LFSR |
+			(RNG_v2_SELFTEST_TICKS << RNG_v2_CTL_WAIT_SHIFT);
+		break;
+	}
 
-	np->test_control[0] = (0x2 << RNG_CTL_ASEL_SHIFT);
-	np->test_control[1] = (0x2 << RNG_CTL_ASEL_SHIFT);
-	np->test_control[2] = (0x2 << RNG_CTL_ASEL_SHIFT);
-	np->test_control[3] = ((0x2 << RNG_CTL_ASEL_SHIFT) |
-			       RNG_CTL_LFSR |
-			       ((SELFTEST_TICKS - 2) << RNG_CTL_WAIT_SHIFT));
-
+	np->test_control[0] = base;
+	np->test_control[1] = base;
+	np->test_control[2] = base;
+	np->test_control[3] = base3;
 
 	err = n2rng_entropy_diag_read(np, unit, np->test_control,
 				      HV_RNG_STATE_HEALTHCHECK,
@@ -557,11 +619,19 @@ static int n2rng_control_configure_units(struct n2rng *np)
 		struct n2rng_unit *up = &np->units[unit];
 		unsigned long ctl_ra = __pa(&up->control[0]);
 		int esrc;
-		u64 base;
+		u64 base, shift;
 
-		base = ((np->accum_cycles << RNG_CTL_WAIT_SHIFT) |
-			(2 << RNG_CTL_ASEL_SHIFT) |
-			RNG_CTL_LFSR);
+		if (np->data->chip_version == 1) {
+			base = ((np->accum_cycles << RNG_v1_CTL_WAIT_SHIFT) |
+			      (RNG_v1_CTL_ASEL_NOOUT << RNG_v1_CTL_ASEL_SHIFT) |
+			      RNG_CTL_LFSR);
+			shift = RNG_v1_CTL_VCO_SHIFT;
+		} else {
+			base = ((np->accum_cycles << RNG_v2_CTL_WAIT_SHIFT) |
+			      (RNG_v2_CTL_ASEL_NOOUT << RNG_v2_CTL_ASEL_SHIFT) |
+			      RNG_CTL_LFSR);
+			shift = RNG_v2_CTL_VCO_SHIFT;
+		}
 
 		/* XXX This isn't the best.  We should fetch a bunch
 		 * XXX of words using each entropy source combined XXX
@@ -570,7 +640,7 @@ static int n2rng_control_configure_units(struct n2rng *np)
 		 */
 		for (esrc = 0; esrc < 3; esrc++)
 			up->control[esrc] = base |
-				(esrc << RNG_CTL_VCO_SHIFT) |
+				(esrc << shift) |
 				(RNG_CTL_ES1 << esrc);
 
 		up->control[3] = base |
diff --git a/drivers/char/hw_random/n2rng.h b/drivers/char/hw_random/n2rng.h
index e41e55a..6bad6cc 100644
--- a/drivers/char/hw_random/n2rng.h
+++ b/drivers/char/hw_random/n2rng.h
@@ -6,18 +6,34 @@
 #ifndef _N2RNG_H
 #define _N2RNG_H
 
-#define RNG_CTL_WAIT       0x0000000001fffe00ULL /* Minimum wait time       */
-#define RNG_CTL_WAIT_SHIFT 9
-#define RNG_CTL_BYPASS     0x0000000000000100ULL /* VCO voltage source      */
-#define RNG_CTL_VCO        0x00000000000000c0ULL /* VCO rate control        */
-#define RNG_CTL_VCO_SHIFT  6
-#define RNG_CTL_ASEL       0x0000000000000030ULL /* Analog MUX select       */
-#define RNG_CTL_ASEL_SHIFT 4
+/* ver1 devices - n2-rng, vf-rng, kt-rng */
+#define RNG_v1_CTL_WAIT       0x0000000001fffe00ULL /* Minimum wait time    */
+#define RNG_v1_CTL_WAIT_SHIFT 9
+#define RNG_v1_CTL_BYPASS     0x0000000000000100ULL /* VCO voltage source   */
+#define RNG_v1_CTL_VCO        0x00000000000000c0ULL /* VCO rate control     */
+#define RNG_v1_CTL_VCO_SHIFT  6
+#define RNG_v1_CTL_ASEL       0x0000000000000030ULL /* Analog MUX select    */
+#define RNG_v1_CTL_ASEL_SHIFT 4
+#define RNG_v1_CTL_ASEL_NOOUT 2
+
+/* these are the same in v2 as in v1 */
 #define RNG_CTL_LFSR       0x0000000000000008ULL /* Use LFSR or plain shift */
 #define RNG_CTL_ES3        0x0000000000000004ULL /* Enable entropy source 3 */
 #define RNG_CTL_ES2        0x0000000000000002ULL /* Enable entropy source 2 */
 #define RNG_CTL_ES1        0x0000000000000001ULL /* Enable entropy source 1 */
 
+/* ver2 devices - m4-rng, m7-rng */
+#define RNG_v2_CTL_WAIT       0x0000000007fff800ULL /* Minimum wait time    */
+#define RNG_v2_CTL_WAIT_SHIFT 12
+#define RNG_v2_CTL_BYPASS     0x0000000000000400ULL /* VCO voltage source   */
+#define RNG_v2_CTL_VCO        0x0000000000000300ULL /* VCO rate control     */
+#define RNG_v2_CTL_VCO_SHIFT  9
+#define RNG_v2_CTL_PERF       0x0000000000000180ULL /* Perf */
+#define RNG_v2_CTL_ASEL       0x0000000000000070ULL /* Analog MUX select    */
+#define RNG_v2_CTL_ASEL_SHIFT 4
+#define RNG_v2_CTL_ASEL_NOOUT 7
+
+
 #define HV_FAST_RNG_GET_DIAG_CTL	0x130
 #define HV_FAST_RNG_CTL_READ		0x131
 #define HV_FAST_RNG_CTL_WRITE		0x132
@@ -112,8 +128,10 @@ struct n2rng {
 
 	u64			scratch_control[HV_RNG_NUM_CONTROL];
 
-#define SELFTEST_TICKS		38859
-#define SELFTEST_VAL		((u64)0xB8820C7BD387E32C)
+#define RNG_v1_SELFTEST_TICKS	38859
+#define RNG_v1_SELFTEST_VAL	((u64)0xB8820C7BD387E32C)
+#define RNG_v2_SELFTEST_TICKS	64
+#define RNG_v2_SELFTEST_VAL	((u64)0xffffffffffffffff)
 #define SELFTEST_POLY		((u64)0x231DCEE91262B8A3)
 #define SELFTEST_MATCH_GOAL	6
 #define SELFTEST_LOOPS_MAX	40000
-- 
1.7.1

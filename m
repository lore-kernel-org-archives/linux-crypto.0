Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792721593;
	b=C+hcvvwPKdsApXysHR/f1YTiGvk065xXP5/shMYg+P80Nb0onpstaA3FXa6lUdtHEO6U
	 7Te+X2w/h/rKcMpSDhqOPU2YxMuHuzbjNStdA15C9wIst2B0JvR1FvWgwdv20m+JCKIxs
	 e2JeDx8Mrg1jnGLl8K7xQPUxJMhm4eVRzTZPkS4JE1omXNtQjM+rmAfsHwacQCh+nuzG8
	 7GjN5BP0AvFuLtLTws2KBX0L6BuiZtbGb60VykLn7LBz8bPcfLT9ZJtKjVq2Hfacuuned
	 /1MoV9ui7icKiUsJAnRkP4fTxprbIgbu9bltpK4AfSf9Yl61BLEepEkmf51EROkh02g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792721593;
	h=DMARC-Filter:Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=4bFziF6nLkI2GZRk/+rbovA7ifZ++Lk3ZwEJ/bNkxYw=;
	b=Lg5od1h1HOUncXkdHO56zrtQuXgBpIADNtaFwcm/GveWo1aO20FoTv16lYAAMgzFi6D+
	 skScKPCBJKj+tkpJ2TtHZZpBkpGYe0NVgYK5KcvHA9tDA0jj5cU69n6W/zQeT0qatb0H3
	 63Q9y7+Lj8+TICXqlS+728RIseIkelzdT0Ec3LP+dQfMn9RHucp1W3ukT8mN6kzA/KK3X
	 h0rIv/YkZhZ5yYLWQS75fibHqPg18grf6sH2uNBr4zHuB0AK9j9Rj3DuT2SjYjQ2r+6iG
	 4RVXGulwsIXqba1wG86arEavGS70qcwUScMS2+wto2ICuiafe6OuneyOdY8vHSHtXyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=starfivetech.com;
	spf=pass smtp.mailfrom=starfivetech.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=139.219.17.128
Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2128.outbound.protection.partner.outlook.cn [139.219.17.128])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E837C606A326;
	Fri, 23 Oct 2026 02:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E837C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bP8gTzxAiwTw+tHorRDa2nsnZ5y9VwDYwolsKuIqv8icn4sEJZrdWj7sSv+NOG4Xsvxroz1MAp/9C4PPXh4Y/cOkoWAzqWppdUmNgeAqXCHnrdOJpOY507qzJguMOR5UEnvGWQi52Iabvpn2GT1NTgPjgy6QtvrqjxeHG/0UFfSN5rUwx7IY3XCsi8vsAegw/H/lK/cOQppmpTeva9sQUuc5q/GMfPsPB7UPjdGXEjnB49Jg5Ggf/HPmiT25wgG0nLd4Q+Tuuq8wZb6T7OxAr5gVbqfN6a3aD7X4/o1SL13yG2R0/ehwAyQJZWbwr5LokgRkf6hVo8SwxehzgMN1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bFziF6nLkI2GZRk/+rbovA7ifZ++Lk3ZwEJ/bNkxYw=;
 b=VKQmCJpb8YzAaaXWgpzEHJOfdsp3PcLyLGi3gQuxjPnjrGdeap1SuMk+a5b1ydZJEbfQS8790zQH2ZfspoOz+9vabuIVu8+JG6MndPerRa6IYSW/rOsv/Mm/cYVTyzfKjiSH3fgtS9iJ5xA0qigc70VeIOmE936Sj2m//5sDVeK6lADsRUevWXuYYM8WU6jBJEx/6F2gYKGtsiSRqzxhFhLtcLrsZDt6JEf2kP+vZ4CkBGfgShU0kFPbWm797zT+cEAcJaYLUMGJG1uR3QKqPGghXi+2JTrmT3HEcJd8CpHgwop9fo2Cy2nQ5bmswLadjUBxuSLIVXowOEaJezRDRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:18::6) by ZQ0PR01MB1303.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:1c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.16; Fri, 23 Oct
 2026 02:12:59 +0000
Received: from ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570]) by ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
 ([fe80::973:272c:ab11:7570%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 02:12:58 +0000
From: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
Subject: [PATCH v10 3/6] hwrng: starfive - move the SEU reseed out of the interrupt handler
Date: Fri, 23 Oct 2026 10:12:45 +0800
Message-Id: <20261023021248.3763-4-lianfeng.ouyang@starfivetech.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
References: <20261023021248.3763-1-lianfeng.ouyang@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SH0PR01CA0008.CHNPR01.prod.partner.outlook.cn
 (10.43.109.84) To ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn (10.2.3.134)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZQ0PR01MB1269:EE_|ZQ0PR01MB1303:EE_
X-MS-Office365-Filtering-Correlation-Id: f42fdf13-1bcb-4d68-82c4-08df30ab2814
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|23010399003|261022105027099003|261022075727099003|38350700014|56012099006|5023799004|261021130227099003|261021121427099003|261009221227099003|261021123027099003|261021135927099003|261021133027099003|261009223027099003|10067099003|18002099003|22082099003|261022115727099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	FbYIZA14Dj0YDAc5dy5+Y80SvRh7m65Mu+oJrascJnepCxPNmrFCfgpcFcdh37ocYJS16vpC7/Wgh8u1iYXtcI7M4lqfIjGjcxll3k8rZpuroiiSqJUdyOdakExISdmVFBeEA+d7RXK2VSL2Gc4/vICZ3DlJmSvfgvCYGLC72r4G/9QZP1LiWPXBGFdUAjeMp41Rdmm4g0gfS5p7ej0Kq4yrzQ+Cwns8ugqjCvY1D0Mj2wQj5Z8L+3igqPWJCBufoOEnHIgO+eh4Q3ml3+J5zw9ROXyXqb1RjnNrnlNRugnuDKdA9nKkAFBLHMxMLHdtRnwkqFPwQNNh1T8rKSSnTvKkz9s1S4DAUnmxm2AVOtaqDJY/f9B84cijMOxuR7mBf8eQqV56pIvjz0s/AnqtdBsVXAeBmygBUNqvWhVTtT2I4NDVfdBQm5WNEIDTCYNVU5pK/HJQaNYohQ7OIzotJGLo8RWT4vEYNZuszbUI59lM0oVTV5XsHsQTL7tAJeh5VRjRdMAjg1iwXMvftGHFt4u9aYdloaxIZEZPTrKVmJr4x7Efjvwmq8YCuaTyXVf3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(23010399003)(261022105027099003)(261022075727099003)(38350700014)(56012099006)(5023799004)(261021130227099003)(261021121427099003)(261009221227099003)(261021123027099003)(261021135927099003)(261021133027099003)(261009223027099003)(10067099003)(18002099003)(22082099003)(261022115727099003)(261022113327099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l02erQtHweGzUk55vjt/bVLuT1tIlHHH1ILAxQ3LSrHGUhMxlncGEa1ZNUaU?=
 =?us-ascii?Q?Rr+8AeOR/VBDSspE1DL9UjDfgO8H2YwGqfWzEnOEUpfPTgtpZ7XM6h+SXS63?=
 =?us-ascii?Q?BFjs7pfFxpS9ro31b8nA8Pj7pqmHI0Sgw6eyPi9DkJT5TVTFqqx4yjdMZ9VC?=
 =?us-ascii?Q?nMZn3vVxfbF2194YzVex622Fn1cwm4+gr8VnF+aRXgw6rSSJj9cu/gkxtcjQ?=
 =?us-ascii?Q?Xtyga+3dqWY8NclVLmHNtG5cLZb+bnj2VyjEJJAoFnZDYT5nDz3JNGVv1LtY?=
 =?us-ascii?Q?/sfzJBM1me9O7RpTlE9l+MObJlnvNyFPjI8wcG37lJT/XcHDXCWz/EuO/3Df?=
 =?us-ascii?Q?27c/b/oRpmKKSdHJ1fUiEtWZZaFUn8hW+KFwaQ21mYNCoAm22Wh40Iy/Z37O?=
 =?us-ascii?Q?tPzhUozVxg9LZkGx1FLyJ9EFmodLxCD/aGLivgwGjnJ0P3bT/bfguZ9EthDY?=
 =?us-ascii?Q?GyjquKUu1tyjZgHwQw8FqSXZAMXsa9pWP/KCIhmH6z6YZsfLIWvoqQRgirFk?=
 =?us-ascii?Q?EemnhPIFjzKCJJPcCR13EZJQ9SJVT1SLIrgyJmL8VkjbEG6twQHeVRDanbI0?=
 =?us-ascii?Q?WAAlIc1SkT16bHL4ptwTBcP7ch5S1hoeAbB9AkY0f+q/TjxrBbf9Rh4uEBGW?=
 =?us-ascii?Q?pIv795Iqe7o5N0siL9lGijzjK6PnHQbWgGOWMMKW8z7hia9GgLop7TKiQ2AK?=
 =?us-ascii?Q?4lq14roDUI5waM1gXgbgEMydGUxUoOuRFskruhgISCvAb2MPIWzbS/l6sR+k?=
 =?us-ascii?Q?9D5FbiIlLLcSmCsMAThxv3UKbRl/YcWqEguNo9r9KzhUc7W7vYrTMIpEDPcb?=
 =?us-ascii?Q?UvvdduficoaPs1K/bqrX3Hlm6Hp5Am/x2M4YOlyb9/3dpIdwDrPjwirLZDvp?=
 =?us-ascii?Q?zJgNDDKrfr/H2Po7nwWEb3F9BgtWQolNkt0qFcCuCuGVRcAqr7vR2vEy9LQB?=
 =?us-ascii?Q?rbjblldR/Q5I64OcB2QFB5oRS1tIgKjFcIoYouweG88vN3lhHZVAV1XuYat4?=
 =?us-ascii?Q?K3EDN8Le8M4CjzbUxjCAIptj4LBiqlwzvkvCjbxuTwr+iikCJA9N9D8zhN8L?=
 =?us-ascii?Q?eoSLdhqindYuOywFPn+L2qHDdSwpKyfUaz1O2KawjPRzF2hgYQHL81Ho7HPr?=
 =?us-ascii?Q?ZvubcTJiWpfC6GQvD7aQ91UsY4+QlHwbr+UzqV658ICutVyjppi0O2djkSPx?=
 =?us-ascii?Q?9zepEYqSSQQGf5pSrVL+IAidDBSiulaeRqRRlLZ6e7u+ktrz36wYwIU5obap?=
 =?us-ascii?Q?YForxB1pi/vNseW/KY3V6Qvna2IzDzjabHTWMs/IqI9VW3ynlrYc9I2DxkbJ?=
 =?us-ascii?Q?mZBv0g5VEnLpckyKu5JZXZyGLTjJ9xNCRvPQpM3LxNiXQGWG9IO5oX04Um6G?=
 =?us-ascii?Q?9P6PtSXauP7SFdLKhonGoenvxHrTJALQXq3aXXbg2PmJTW0RCXob4HMfrTZ8?=
 =?us-ascii?Q?3ZYqQGl/Bb/i/1FO9uE/yiFo5MwoWVnanjCAAjqlqFSM0Dn2VdXf/NRWpbbx?=
 =?us-ascii?Q?iIG1k5egREf0znNfa5CmOcRHcAqayvZrNf/vTlnoXMchjPCwsikFcHcDMJhU?=
 =?us-ascii?Q?EOpAvYUl83Mh3zfag2RVWnJpp5sDWkRULGgPg+vfGxXVMqnGjTtX6fXnZ8d2?=
 =?us-ascii?Q?+5qvKNt6OUfKaYdxHPQ8cNxXSuK8rTycfaeoWoEsU+sSl6VRCipDabI1o2hh?=
 =?us-ascii?Q?IpsCViORlyDYvXGPcggQJyB3xaV/znXF2+jUY/WZL/WTBlrNEBaxlzr2cWwq?=
 =?us-ascii?Q?qtU8FF3IEL8jRgg0WeW0sEiRg3YhXVliOzI+rax7bEeT9oJe7VYt?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42fdf13-1bcb-4d68-82c4-08df30ab2814
X-MS-Exchange-CrossTenant-AuthSource: ZQ0PR01MB1269.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 02:12:58.1177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBfOoZZAFBAEprwLfskkqdpZXrhEAlEcR/CfKYBdfmMi05Ynr0rFIuOUrE03dC6+WHAn07ANudE925oIHpMylE3PXg/WII4ByTUs4Xh+iN+61F0YI4YWF305Ql8q7g6Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZQ0PR01MB1303

From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>

When the hardware reports an LFSR lockup (a single event upset), the
interrupt handler writes the reseed command straight into the CTRL
register. The spinlock only serialises that register write: nothing
stops it from racing with a command ->read() has just issued, nothing
waits for the reseed to complete before the next command is issued, and
a sample taken from a locked up generator is handed out as random data.
The 40us timeout used for wait == 0 also rounds up to a jiffy and so is
not what it claims to be.

Rework the command handling around a mutex that serialises complete
command sequences instead:

 - starfive_trng_cmd() checks that the hardware is idle before issuing
   a command, takes an explicit timeout, and resynchronises with the
   interrupt handler before declaring a timeout so that a late
   completion is not left behind for the next command.

 - The interrupt handler only records a lockup in trng->need_reseed and
   queues a work item which performs the reseed under the mutex.
   starfive_trng_irq_clear() records a lockup it clears for the same
   reason, so that one observed across suspend/resume is not lost.

 - ->read() reseeds before sampling when a lockup is pending, and
   retries once when the lockup is reported together with RAND_RDY.
   Non-blocking readers return no data instead and make sure the work
   is queued, so they cannot stall when the lockup was observed outside
   the interrupt handler or a previous reseed attempt failed.

 - The interrupt is requested with IRQF_NO_AUTOEN and is only enabled
   between ->init() and ->cleanup(). trng->initialized tracks that
   state: the hwrng core may call ->init() again without an intervening
   ->cleanup() when the device is deselected and quickly reselected,
   and it calls ->cleanup() after a failed ->init(), so neither may
   enable or disable the line a second time.

 - The suspend callback masks the interrupts, and asserts the reset
   while the device is not initialised; resume re-enables the
   interrupts when it is.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
---
 drivers/char/hw_random/jh7110-trng.c | 352 ++++++++++++++++++++-------
 1 file changed, 261 insertions(+), 91 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 17932cc6d7aa..8e0e7865453b 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -8,18 +8,22 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/devm-helpers.h>
 #include <linux/err.h>
 #include <linux/hw_random.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/lockdep.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/random.h>
 #include <linux/reset.h>
+#include <linux/workqueue.h>
 
 /* trng register offset */
 #define STARFIVE_CTRL			0x00
@@ -78,7 +82,14 @@
 #define STARFIVE_ISTAT_SEED_DONE	BIT(1)
 #define STARFIVE_ISTAT_LFSR_LOCKUP	BIT(4)
 
+#define STARFIVE_ISTAT_ALL		(STARFIVE_ISTAT_RAND_RDY | \
+					 STARFIVE_ISTAT_SEED_DONE | \
+					 STARFIVE_ISTAT_LFSR_LOCKUP)
+
 #define STARFIVE_RAND_LEN		sizeof(u32)
+#define STARFIVE_RANDRESEED_TIMEOUT_MS	50
+#define STARFIVE_RANDGEN_TIMEOUT_MS	20
+#define STARFIVE_RANDGEN_NOWAIT_TIMEOUT	1
 
 #define to_trng(p)			container_of(p, struct starfive_trng, rng)
 
@@ -95,21 +106,29 @@ enum mode {
 struct starfive_trng {
 	struct device		*dev;
 	void __iomem		*base;
+	int			irq;
 	struct clk		*hclk;
 	struct clk		*ahb;
 	struct reset_control	*rst;
 	struct hwrng		rng;
 	struct completion	random_done;
 	struct completion	reseed_done;
+	struct work_struct	work;
 	u32			mode;
 	u32			mission;
 	u32			reseed;
+	bool			need_reseed;
+	bool			initialized;
 	bool			clk_on;
 	bool			rst_deassert;
-	/* protects against concurrent write to ctrl register */
-	spinlock_t		write_lock;
+	struct mutex		lock; /* protect trng cmd seq */
 };
 
+static inline struct starfive_trng *work_to_trng(struct work_struct *work)
+{
+	return container_of(work, struct starfive_trng, work);
+}
+
 static u16 autoreq;
 module_param(autoreq, ushort, 0);
 MODULE_PARM_DESC(autoreq, "Auto-reseeding after random number requests by host reaches specified counter:\n"
@@ -122,22 +141,38 @@ MODULE_PARM_DESC(autoage, "Auto-reseeding after specified timer countdowns to 0:
 				" 0 - disable timer\n"
 				" other - reload value for internal timer");
 
-static inline int starfive_trng_wait_idle(struct starfive_trng *trng)
+static bool starfive_trng_idle(struct starfive_trng *trng, bool wait)
 {
-	u32 stat;
+	u32 stat, busy = STARFIVE_STAT_RAND_GENERATING | STARFIVE_STAT_RAND_SEEDING;
 
-	return readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
-					  !(stat & (STARFIVE_STAT_RAND_GENERATING |
-						    STARFIVE_STAT_RAND_SEEDING)),
-					  10, 100000);
+	if (!wait)
+		return !(readl_relaxed(trng->base + STARFIVE_STAT) & busy);
+
+	return !readl_relaxed_poll_timeout(trng->base + STARFIVE_STAT, stat,
+					   !(stat & busy),
+					   10, 100000);
 }
 
-static inline void starfive_trng_irq_mask_clear(struct starfive_trng *trng)
+/*
+ * Record a pending LFSR lockup and make sure it gets serviced. queue_work()
+ * is a no-op while the work is already pending, so this is safe to call
+ * from any context that notices the lockup.
+ */
+static void starfive_trng_request_reseed(struct starfive_trng *trng)
 {
-	/* clear register: ISTAT */
-	u32 data = readl(trng->base + STARFIVE_ISTAT);
+	WRITE_ONCE(trng->need_reseed, true);
+	queue_work(system_freezable_wq, &trng->work);
+}
+
+static void starfive_trng_irq_clear(struct starfive_trng *trng)
+{
+	u32 istat = readl(trng->base + STARFIVE_ISTAT);
+
+	/* Do not lose an LFSR lockup that has not been serviced yet. */
+	if (istat & STARFIVE_ISTAT_LFSR_LOCKUP)
+		starfive_trng_request_reseed(trng);
 
-	writel(data, trng->base + STARFIVE_ISTAT);
+	writel(istat, trng->base + STARFIVE_ISTAT);
 }
 
 static int starfive_trng_power_on(struct starfive_trng *trng)
@@ -194,42 +229,71 @@ static void starfive_trng_power_off_action(void *data)
 	starfive_trng_power_off(data, true);
 }
 
-static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, bool wait)
+static int starfive_trng_cmd(struct starfive_trng *trng, u32 cmd, unsigned long timeout, bool wait)
 {
-	int wait_time = 1000;
+	struct completion *done;
 
-	/* allow up to 40 us for wait == 0 */
-	if (!wait)
-		wait_time = 40;
+	lockdep_assert_held(&trng->lock);
+
+	if (!starfive_trng_idle(trng, wait))
+		return wait ? -ETIMEDOUT : -EBUSY;
 
 	switch (cmd) {
 	case STARFIVE_CTRL_GENE_RANDNUM:
-		reinit_completion(&trng->random_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->random_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->random_done;
 		break;
 	case STARFIVE_CTRL_EXEC_RANDRESEED:
-		reinit_completion(&trng->reseed_done);
-		spin_lock_irq(&trng->write_lock);
-		writel(cmd, trng->base + STARFIVE_CTRL);
-		spin_unlock_irq(&trng->write_lock);
-		if (!wait_for_completion_timeout(&trng->reseed_done, usecs_to_jiffies(wait_time)))
-			return -ETIMEDOUT;
+		done = &trng->reseed_done;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	reinit_completion(done);
+	writel(cmd, trng->base + STARFIVE_CTRL);
+	if (!wait_for_completion_timeout(done, timeout)) {
+		synchronize_irq(trng->irq);
+		if (!try_wait_for_completion(done))
+			return -ETIMEDOUT;
+	}
+
 	return 0;
 }
 
+static int starfive_trng_reseed(struct starfive_trng *trng)
+{
+	int ret;
+
+	lockdep_assert_held(&trng->lock);
+
+	WRITE_ONCE(trng->need_reseed, false);
+	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED,
+				msecs_to_jiffies(STARFIVE_RANDRESEED_TIMEOUT_MS), true);
+	if (ret)
+		WRITE_ONCE(trng->need_reseed, true);
+
+	return ret;
+}
+
+static void starfive_trng_hw_setup(struct starfive_trng *trng)
+{
+	u32 mode;
+
+	/* setup Auto Request/Age register */
+	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
+	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
+
+	mode = readl(trng->base + STARFIVE_MODE);
+	if (trng->mode == PRNG_128BIT)
+		mode &= ~STARFIVE_MODE_R256;
+	else
+		mode |= STARFIVE_MODE_R256;
+	writel(mode, trng->base + STARFIVE_MODE);
+}
+
 static int starfive_trng_init(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
-	u32 mode, intr = 0;
 	int ret;
 
 	ret = pm_runtime_resume_and_get(trng->dev);
@@ -238,37 +302,62 @@ static int starfive_trng_init(struct hwrng *rng)
 		return ret;
 	}
 
-	/* setup Auto Request/Age register */
-	writel(autoage, trng->base + STARFIVE_AUTO_AGE);
-	writel(autoreq, trng->base + STARFIVE_AUTO_RQSTS);
+	mutex_lock(&trng->lock);
+
+	/*
+	 * The hwrng core can call init again without an intervening
+	 * cleanup: deselecting and quickly reselecting the device makes
+	 * cleanup_rng_work() skip ->cleanup() once the refcount is back up.
+	 * Only bring up the interrupt line once in that case.
+	 */
+	if (!trng->initialized) {
+		starfive_trng_irq_clear(trng);
+		starfive_trng_hw_setup(trng);
+
+		enable_irq(trng->irq);
+		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+		trng->initialized = true;
+	}
+
+	ret = starfive_trng_reseed(trng);
+	if (ret) {
+		trng->initialized = false;
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
+		disable_irq(trng->irq);
+	}
 
-	/* clear register: ISTAT */
-	starfive_trng_irq_mask_clear(trng);
+	mutex_unlock(&trng->lock);
 
-	intr |= STARFIVE_IE_ALL;
-	writel(intr, trng->base + STARFIVE_IE);
+	pm_runtime_put_autosuspend(trng->dev);
 
-	mode  = readl(trng->base + STARFIVE_MODE);
+	return ret;
+}
 
-	switch (trng->mode) {
-	case PRNG_128BIT:
-		mode &= ~STARFIVE_MODE_R256;
-		break;
-	case PRNG_256BIT:
-		mode |= STARFIVE_MODE_R256;
-		break;
-	default:
-		mode |= STARFIVE_MODE_R256;
-		break;
+static void starfive_trng_reseed_work(struct work_struct *work)
+{
+	struct starfive_trng *trng = work_to_trng(work);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(trng->dev);
+	if (ret < 0) {
+		dev_err(trng->dev, "Failed to wake device for reseed: %d\n", ret);
+		return;
 	}
 
-	writel(mode, trng->base + STARFIVE_MODE);
+	mutex_lock(&trng->lock);
 
-	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_EXEC_RANDRESEED, 1);
+	if (!READ_ONCE(trng->need_reseed) || !trng->initialized)
+		goto unlock;
 
-	pm_runtime_put_autosuspend(trng->dev);
+	ret = starfive_trng_reseed(trng);
+	if (ret)
+		dev_err(trng->dev, "Reseed after LFSR lockup failed: %d\n", ret);
 
-	return ret;
+unlock:
+	mutex_unlock(&trng->lock);
+
+	pm_runtime_put_autosuspend(trng->dev);
 }
 
 static irqreturn_t starfive_trng_irq(int irq, void *priv)
@@ -276,24 +365,21 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 	u32 status;
 	struct starfive_trng *trng = (struct starfive_trng *)priv;
 
-	status = readl(trng->base + STARFIVE_ISTAT);
-	if (status & STARFIVE_ISTAT_RAND_RDY) {
-		writel(STARFIVE_ISTAT_RAND_RDY, trng->base + STARFIVE_ISTAT);
+	status = readl(trng->base + STARFIVE_ISTAT) & STARFIVE_ISTAT_ALL;
+	if (!status)
+		return IRQ_NONE;
+
+	writel(status, trng->base + STARFIVE_ISTAT);
+
+	/* SEU occurred, reseeding required */
+	if (status & STARFIVE_ISTAT_LFSR_LOCKUP)
+		starfive_trng_request_reseed(trng);
+
+	if (status & STARFIVE_ISTAT_RAND_RDY)
 		complete(&trng->random_done);
-	}
 
-	if (status & STARFIVE_ISTAT_SEED_DONE) {
-		writel(STARFIVE_ISTAT_SEED_DONE, trng->base + STARFIVE_ISTAT);
+	if (status & STARFIVE_ISTAT_SEED_DONE)
 		complete(&trng->reseed_done);
-	}
-
-	if (status & STARFIVE_ISTAT_LFSR_LOCKUP) {
-		writel(STARFIVE_ISTAT_LFSR_LOCKUP, trng->base + STARFIVE_ISTAT);
-		/* SEU occurred, reseeding required*/
-		spin_lock(&trng->write_lock);
-		writel(STARFIVE_CTRL_EXEC_RANDRESEED, trng->base + STARFIVE_CTRL);
-		spin_unlock(&trng->write_lock);
-	}
 
 	return IRQ_HANDLED;
 }
@@ -301,15 +387,36 @@ static irqreturn_t starfive_trng_irq(int irq, void *priv)
 static void starfive_trng_cleanup(struct hwrng *rng)
 {
 	struct starfive_trng *trng = to_trng(rng);
+	bool initialized;
 	int ret;
 
 	ret = pm_runtime_resume_and_get(trng->dev);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(trng->dev, "Failed to wake device for cleanup: %d\n", ret);
-		return;
+
+	mutex_lock(&trng->lock);
+	initialized = trng->initialized;
+	trng->initialized = false;
+	if (ret >= 0 && initialized) {
+		writel(0, trng->base + STARFIVE_IE);
+		starfive_trng_irq_clear(trng);
 	}
+	mutex_unlock(&trng->lock);
+
+	/*
+	 * cleanup also runs after a failed init, which has already undone
+	 * its enable_irq(). Only disable the line if init left it enabled.
+	 */
+	if (initialized)
+		disable_irq(trng->irq);
+	cancel_work_sync(&trng->work);
 
+	if (ret < 0)
+		return;
+
+	mutex_lock(&trng->lock);
 	writel(STARFIVE_CTRL_EXEC_NOP, trng->base + STARFIVE_CTRL);
+	mutex_unlock(&trng->lock);
 
 	pm_runtime_put_sync_suspend(trng->dev);
 }
@@ -317,7 +424,8 @@ static void starfive_trng_cleanup(struct hwrng *rng)
 static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct starfive_trng *trng = to_trng(rng);
-	int ret;
+	unsigned long timeout;
+	int ret, retry = 1;
 
 	ret = pm_runtime_resume_and_get(trng->dev);
 	if (ret < 0) {
@@ -325,35 +433,75 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
 		return ret;
 	}
 
-	if (trng->mode == PRNG_256BIT)
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
-	else
-		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
-
 	if (wait) {
-		ret = starfive_trng_wait_idle(trng);
-		if (ret) {
-			ret = -ETIMEDOUT;
+		mutex_lock(&trng->lock);
+		timeout = msecs_to_jiffies(STARFIVE_RANDGEN_TIMEOUT_MS);
+	} else {
+		/* allow up to 1 jiffy for wait == 0 */
+		if (!mutex_trylock(&trng->lock)) {
+			ret = 0;
 			goto out_put;
 		}
+		timeout = STARFIVE_RANDGEN_NOWAIT_TIMEOUT;
 	}
 
-	ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, wait);
-	if (ret)
-		goto out_put;
+	for (;;) {
+		/*
+		 * A pending LFSR lockup taints the next sample. Blocking
+		 * callers reseed here; non-blocking callers return no data
+		 * and leave it to the reseed work. Re-queue it explicitly:
+		 * the lockup may have been seen by starfive_trng_irq_clear()
+		 * or a previous reseed attempt may have failed.
+		 */
+		if (READ_ONCE(trng->need_reseed)) {
+			if (!wait) {
+				starfive_trng_request_reseed(trng);
+				ret = 0;
+				goto out_unlock;
+			}
+			ret = starfive_trng_reseed(trng);
+			if (ret)
+				goto out_unlock;
+		}
+
+		ret = starfive_trng_cmd(trng, STARFIVE_CTRL_GENE_RANDNUM, timeout, wait);
+		if (ret) {
+			if (!wait && (ret == -EBUSY || ret == -ETIMEDOUT))
+				ret = 0;
+			goto out_unlock;
+		}
+
+		/* Lockup reported together with RAND_RDY: reseed and retry once */
+		if (!READ_ONCE(trng->need_reseed))
+			break;
+
+		if (!wait || !retry--) {
+			ret = 0;
+			goto out_unlock;
+		}
+	}
+
+	if (trng->mode == PRNG_256BIT)
+		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 8));
+	else
+		max = min_t(size_t, max, (STARFIVE_RAND_LEN * 4));
 
 	memcpy_fromio(buf, trng->base + STARFIVE_RAND0, max);
+
 	ret = max;
 
+out_unlock:
+	mutex_unlock(&trng->lock);
+
 out_put:
 	pm_runtime_put_autosuspend(trng->dev);
+
 	return ret;
 }
 
 static int starfive_trng_probe(struct platform_device *pdev)
 {
 	int ret;
-	int irq;
 	struct starfive_trng *trng;
 
 	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
@@ -368,16 +516,14 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->base),
 				     "Error remapping memory for platform device.\n");
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	trng->irq = platform_get_irq(pdev, 0);
+	if (trng->irq < 0)
+		return trng->irq;
 
 	init_completion(&trng->random_done);
 	init_completion(&trng->reseed_done);
-	spin_lock_init(&trng->write_lock);
 
-	ret = devm_request_irq(&pdev->dev, irq, starfive_trng_irq, 0, pdev->name,
-			       (void *)trng);
+	ret = devm_mutex_init(&pdev->dev, &trng->lock);
 	if (ret)
 		return ret;
 
@@ -420,6 +566,15 @@ static int starfive_trng_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to enable runtime PM\n");
 
+	ret = devm_work_autocancel(&pdev->dev, &trng->work, starfive_trng_reseed_work);
+	if (ret)
+		return ret;
+
+	ret = devm_request_irq(&pdev->dev, trng->irq, starfive_trng_irq, IRQF_NO_AUTOEN,
+			       pdev->name, (void *)trng);
+	if (ret)
+		return ret;
+
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
@@ -432,8 +587,16 @@ static int starfive_trng_probe(struct platform_device *pdev)
 static int starfive_trng_suspend(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	bool assert_rst;
+
+	mutex_lock(&trng->lock);
+	assert_rst = !trng->initialized;
+	writel(0, trng->base + STARFIVE_IE);
+	starfive_trng_irq_clear(trng);
+	mutex_unlock(&trng->lock);
 
-	starfive_trng_power_off(trng, false);
+	synchronize_irq(trng->irq);
+	starfive_trng_power_off(trng, assert_rst);
 
 	return 0;
 }
@@ -444,10 +607,17 @@ static int starfive_trng_resume(struct device *dev)
 	int ret;
 
 	ret = starfive_trng_power_on(trng);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "Failed to power on: %d\n", ret);
+		return ret;
+	}
 
-	return ret;
+	if (trng->initialized) {
+		starfive_trng_irq_clear(trng);
+		writel(STARFIVE_IE_ALL, trng->base + STARFIVE_IE);
+	}
+
+	return 0;
 }
 
 static const struct of_device_id trng_dt_ids[] __maybe_unused = {
-- 
2.43.0


Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D078539D
	for <linux-crypto@vger.kernel.org>; Sun, 24 Dec 2023 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="luVbGy/H"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BO8LBZS021945;
	Sun, 24 Dec 2023 00:21:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=dzqEg4d4RUGBJljTi10lxR9MfKEKd5PH94kTwLCppEw=; b=
	luVbGy/HBlZ+SGfDEz2fvAzq4oezB564O4QLggYYYo55HQyvhcXi2+u/M1XMH6qT
	88kUpDacTmxtQKpgcBqPFnhRF9PXjLuAqNM7kXhIfXqjHBbDeNU5SQ/1Yhlwc94W
	Xzf/fNIlBspJcQOZyDDHOV2bLxhn4UtRZhc5iV+4TzjcLokQ44Zy0ya/thOuOuoW
	7wxxjthT52byCBrSK3prgzGjHlCm7q3iVWqMzqMC+sd8RWCLzSEfFH3JsPU/D3Hi
	/K7ZEoLcGmsL92xBcObsSXNggQEOt2YuV6HvTuwo+HzFnjkwnMM3vEEkghmGR4on
	4xRZNV43TcF3h5d5BRduWQ==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5uq4gk8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 24 Dec 2023 00:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLRU5mIEzJinf+e3UU5c+DDZfEJ6ZsNkbvPXxFX4aVYJMKPNGtm/NcbNG6GhI3RSwW/1Ev4SeoftJDnf95lk0i3CdsQ4m0bVVu9tL8uE9/3862G9B+ZcFdZXEeeoza2dqRdu8Ci+IsehysLTukvCpELtTpVzhapQVZBOsBIe+HMSUuI+haumCC0O3BYOlxBiaP4UK3d3QZ/E+zszjpCb3F9s7Kt9JIBvPJWBlP+d+myF6VMPXqdFJEum/U8PJQ4bQhZ2ZqC73BSrXbxw1BvjM7hhAmvVqLjCj9en7V+RDpUqi7uHJMgE8bxZ1/A/pk+hpa63nxwqhNK33CwleHSnNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzqEg4d4RUGBJljTi10lxR9MfKEKd5PH94kTwLCppEw=;
 b=JAoa4h9mFarJ/y/Pxp7drm7SoIJ72jUu6o6oAnP+z58qR1Guvu6LaQvrCVOefPwmshEjNA001J5jJDnvk+6z9M+mDr2olqtxfaXyrc5NDaz9gdLR42RW2SH75h6o78UdT4VrDTrDa1VeVs3sUlq5c14wy9iAYpBOFsycNVWwKKPBk7ZQMWxxUOqek4U04JIIJ5aFFK7ZNWybLtcZr1TvlygQi666ti3PrIptcdMgtBFWXHC/QDSH41m2e4BDHaFQunKWm1qD3PhHC8j4nZCbMqcap6pRZl/YuwTSAb5VH7dBwCxv/kk0Kt4ae+NIAIdF2U+dpawx4Zl87F3eiBRfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sun, 24 Dec
 2023 08:21:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sun, 24 Dec 2023
 08:21:20 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH v2 14/14] crypto: sahara - add support for crypto_engine
Date: Sun, 24 Dec 2023 10:21:44 +0200
Message-Id: <20231224082144.3894863-15-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
References: <20231224082144.3894863-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0094.eurprd09.prod.outlook.com
 (2603:10a6:803:78::17) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ed145b-80b7-4150-9cec-08dc04594ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dKBLuRNPSYZklTXAU4X9NQHJmPqAvXSmFDCUy6iHiRPolKIvAnh3oBI7NmIBDvqOKmZ1siZ5dMuBs6alF3/NKV4giJCJ28D2shpvl4inJGWquv+NJ3JFeuWYAPrmKNM5NYroeOaTzKUwpwrB/edVOkzsrAjM3JKC1jKkwLyiHUXNjy5q3kAD9FcnsrCZh0CcccdKl2WqQEI8bzNkbTeW0JsmQXG2RbnLAPAEpU6kPeVuyPIn3tPndLO4nkZlQNvCgyEEcm0DWCC73C2FZqDSdTxYu+cLYKdUpZOnRuagJGZd9v5vZSb9MCzqBHnidifuBYNanlPdpi6LM1gUSxcd3hE/PdLL5KVOOnXTrHBoiN9CDZrbEWtvMx5Nn6hbNdRCHKhr1a4hTvTxB3a6M+jSxrd4nQMAT4k1xpAoxkvSgXAvKX8T0JycX7eLKdUOhdAJHeOEuVwXE1nutLxhE6MVdDZ6zec7sWqv0dKxJpEMces1D8m4OTdtkmqhsqZF3XiUG6JOtD0mV99UVtiosNJE4EGiwc4n1yUM6QfinbLrorTndbCPkIWnQD5NLBC6mPHfDl4z/utNgduxng7xEU4Y58STKTNLJxOUkhfvSImEvTcrFpDLezYEdV9J21CZKrZH
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39850400004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6486002)(478600001)(2906002)(8936002)(5660300002)(36756003)(30864003)(52116002)(6916009)(66946007)(66476007)(66556008)(8676002)(38350700005)(9686003)(4326008)(6506007)(6512007)(316002)(83380400001)(86362001)(1076003)(26005)(2616005)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?87BOPHm0pXqGF9TXeb5rUPDiso5fXWvnBCn21elCYBG+Wa1i1I9V4uF/g6Pl?=
 =?us-ascii?Q?RtWuKw/gZrekuJudLXl52/MmmlxBqjCGA2fZdd9cg3fOAhMHuyarqTyWhJ2O?=
 =?us-ascii?Q?eIlN3YZ2IkDf5ZhJsU0E5c4g77L60Vty/tQBxXhm3Pzjmbr/cEB1tvQ7c3yX?=
 =?us-ascii?Q?656N4TFEemzzAMjQze7maAuv7gFzzklAT71QzhhLnwrX18v1inGBC7XuuBQ5?=
 =?us-ascii?Q?bSilt3mHms51Lg003xXc/33vCA4XWAABvmetmp+QECMYODmKysY29xFksBek?=
 =?us-ascii?Q?Ae7cNwK9kOM3DN5hoHRMykBuSem3Cz8jOAwWtB7r7injL9YwNRVT1s+Ve+Mn?=
 =?us-ascii?Q?dMjJeh7QbP5X8V9M1Kt/bEx2BzDaY+gO7KP19LFZQTSKMvTFhpXurnPDj94Q?=
 =?us-ascii?Q?EjVuRNJRHz4Vl/ofwdYhEdJ3AfgvR5QmzJn4I5J0qRiYZv9vozZo1yMq19FB?=
 =?us-ascii?Q?vcRJRqFqaFG3QpWGO3FtNkC9DIODFvGE4lAk0STOj52mqoCVcZWLkBqosHF4?=
 =?us-ascii?Q?8s0rc176OgI/sAHtV3XauRIuD+5nJyjfuO6Yppza0NW4jSiMmL7vPDjNsKUE?=
 =?us-ascii?Q?EyKNgWHpYvcN1HxUqK4nfy3Ji4fRdTfuGdK5FKyC9Q57TGEXVCZgg2QGVEGH?=
 =?us-ascii?Q?zvVZAl0uIoua3O/TTBg0ZzGZHYwQIrfb4Twsel/wV0rUwE5UaCSQS+uiN55B?=
 =?us-ascii?Q?OJKSjo/WmswybGIYCplAXMFjMoxGKPYY+3ZS2+hhgfT3xsV08VMClNqNWSPg?=
 =?us-ascii?Q?vXyoQlbwOn8Zfd+v+DrDw11tC3T6vTonSQtn4HarCXadJ1U0mgG0dXR99O90?=
 =?us-ascii?Q?cOigJxjhICZgbBpUM60buVHcUEtBxvdcvvi/k3cnMg1FozUtUhfIaS98H/2U?=
 =?us-ascii?Q?vyXzV2QpFJgDxdGwR2F8v8DWI9zTITFFI8PbvAPcgSvGrmS3XYR2AAZ2JYKs?=
 =?us-ascii?Q?4jpFiXlSRvt7/YVYSs5Hbq+AImuyeAi4aJRF943093IVBsf79L2h6evg9IuO?=
 =?us-ascii?Q?G3VIqmgpSbtrj/+vFtCiYzk+zuig3Hf5QOrk4vxMVuXzx6MZPTPiGIOThL2g?=
 =?us-ascii?Q?7p5MGEq79xRuZaObe5U79fMDlHhAxpfRi906DXw9IoYZkgZduEGwpMdNCumf?=
 =?us-ascii?Q?6ix0kdKukZijMPnbXVZl3clxcARxO7a9cwfe3NsDyCkzojzzg5Thm1wdBZr1?=
 =?us-ascii?Q?AQURdn7ZPWvtMUwVzruVNCUXworbKOPpg8TxdUw4TpjBZOfiuqtJPp8LJYdq?=
 =?us-ascii?Q?SbArvn/vud2UIwKIvwi6kZSh9h/o24wg3z5VxZXcWJTX2EooCTzIfR7A6/3g?=
 =?us-ascii?Q?pXGmMpW2INX4Zw6cUbUZYFUVyXZ5Fn+V7WeHPHoZtv1y/oCviybaOr8eEx3R?=
 =?us-ascii?Q?nEYzQho154jmzgiwsNvo25h1vPR0lKdhTRE+/LCfyWxIVaEDecl7C+OO2bAz?=
 =?us-ascii?Q?xXVIqMgHBIBOE/nl/bzsis0zgKRbMNuK8nMFFc9/ZbIlbua+bOOZi/R2aYU4?=
 =?us-ascii?Q?ppd0gO2l4qQGY6/TSjUytrswGfjuQ2b+TzGKTjyOktO6W+xSaao5lfLFq5A/?=
 =?us-ascii?Q?oZUM/GOJi0Mg+WBoOm+TN3hYY564F1zeiFDOFZ4ZnDv3qsSr5EP5gKwy3B4W?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ed145b-80b7-4150-9cec-08dc04594ee2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2023 08:21:20.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8QVCfYgJalDhxesnyuR+pwadnJi5RENv4fobZbSdP9+qFaAcgo1hQg8CjzeG6hs1JOnAWEHV7Ig5hrTBo0nCLmeluy/ITVUE+fLvW+hcHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-Proofpoint-GUID: Vslx56E2HxXPfkbEDemiE5Yt7u-Jm1g6
X-Proofpoint-ORIG-GUID: Vslx56E2HxXPfkbEDemiE5Yt7u-Jm1g6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=963 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312240066

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Convert sahara driver to use crypto_engine, rather than doing manual queue
management.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/Kconfig  |   1 +
 drivers/crypto/sahara.c | 325 ++++++++++++++++++----------------------
 2 files changed, 148 insertions(+), 178 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 79c3bb9c99c3..0991f026cb07 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -306,6 +306,7 @@ config CRYPTO_DEV_SAHARA
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
+	select CRYPTO_ENGINE
 	help
 	  This option enables support for the SAHARA HW crypto accelerator
 	  found in some Freescale i.MX chips.
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 886395603a3a..3423b5cde1c7 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -15,6 +15,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/engine.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 
@@ -24,7 +25,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
-#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -73,9 +73,6 @@
 #define SAHARA_HDR_MDHA_MAC_FULL		BIT(9)
 #define SAHARA_HDR_MDHA_SSL			BIT(10)
 
-/* SAHARA can only process one request at a time */
-#define SAHARA_QUEUE_LENGTH			1
-
 #define SAHARA_REG_VERSION			0x00
 #define SAHARA_REG_DAR				0x04
 #define SAHARA_REG_CONTROL			0x08
@@ -191,12 +188,9 @@ struct sahara_dev {
 	void __iomem		*regs_base;
 	struct clk		*clk_ipg;
 	struct clk		*clk_ahb;
-	spinlock_t		queue_spinlock;
-	struct task_struct	*kthread;
 	struct completion	dma_completion;
 
 	struct sahara_ctx	*ctx;
-	struct crypto_queue	queue;
 	unsigned long		flags;
 
 	struct sahara_hw_desc	*hw_desc[SAHARA_MAX_HW_DESC];
@@ -219,6 +213,8 @@ struct sahara_dev {
 	int		nb_in_sg;
 	struct scatterlist	*out_sg;
 	int		nb_out_sg;
+
+	struct crypto_engine *engine;
 };
 
 static struct sahara_dev *dev_ptr;
@@ -671,7 +667,6 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_ctx *ctx = crypto_skcipher_ctx(
 		crypto_skcipher_reqtfm(req));
 	struct sahara_dev *dev = dev_ptr;
-	int err = 0;
 
 	if (!req->cryptlen)
 		return 0;
@@ -687,13 +682,7 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	spin_lock_bh(&dev->queue_spinlock);
-	err = crypto_enqueue_request(&dev->queue, &req->base);
-	spin_unlock_bh(&dev->queue_spinlock);
-
-	wake_up_process(dev->kthread);
-
-	return err;
+	return crypto_transfer_skcipher_request_to_engine(dev->engine, req);
 }
 
 static int sahara_aes_ecb_encrypt(struct skcipher_request *req)
@@ -994,45 +983,26 @@ static int sahara_sha_process(struct ahash_request *req)
 	return 0;
 }
 
-static int sahara_queue_manage(void *data)
+static int sahara_do_one_request(struct crypto_engine *engine, void *areq)
 {
-	struct sahara_dev *dev = data;
-	struct crypto_async_request *async_req;
-	struct crypto_async_request *backlog;
-	int ret = 0;
-
-	do {
-		__set_current_state(TASK_INTERRUPTIBLE);
-
-		spin_lock_bh(&dev->queue_spinlock);
-		backlog = crypto_get_backlog(&dev->queue);
-		async_req = crypto_dequeue_request(&dev->queue);
-		spin_unlock_bh(&dev->queue_spinlock);
-
-		if (backlog)
-			crypto_request_complete(backlog, -EINPROGRESS);
-
-		if (async_req) {
-			if (crypto_tfm_alg_type(async_req->tfm) ==
-			    CRYPTO_ALG_TYPE_AHASH) {
-				struct ahash_request *req =
-					ahash_request_cast(async_req);
-
-				ret = sahara_sha_process(req);
-			} else {
-				struct skcipher_request *req =
-					skcipher_request_cast(async_req);
-
-				ret = sahara_aes_process(req);
-			}
+	struct crypto_async_request *async_req = areq;
+	int err;
 
-			crypto_request_complete(async_req, ret);
+	if (crypto_tfm_alg_type(async_req->tfm) == CRYPTO_ALG_TYPE_AHASH) {
+		struct ahash_request *req = ahash_request_cast(async_req);
 
-			continue;
-		}
+		err = sahara_sha_process(req);
+		local_bh_disable();
+		crypto_finalize_hash_request(engine, req, err);
+		local_bh_enable();
+	} else {
+		struct skcipher_request *req = skcipher_request_cast(async_req);
 
-		schedule();
-	} while (!kthread_should_stop());
+		err = sahara_aes_process(skcipher_request_cast(async_req));
+		local_bh_disable();
+		crypto_finalize_skcipher_request(engine, req, err);
+		local_bh_enable();
+	}
 
 	return 0;
 }
@@ -1041,20 +1011,13 @@ static int sahara_sha_enqueue(struct ahash_request *req, int last)
 {
 	struct sahara_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct sahara_dev *dev = dev_ptr;
-	int ret;
 
 	if (!req->nbytes && !last)
 		return 0;
 
 	rctx->last = last;
 
-	spin_lock_bh(&dev->queue_spinlock);
-	ret = crypto_enqueue_request(&dev->queue, &req->base);
-	spin_unlock_bh(&dev->queue_spinlock);
-
-	wake_up_process(dev->kthread);
-
-	return ret;
+	return crypto_transfer_hash_request_to_engine(dev->engine, req);
 }
 
 static int sahara_sha_init(struct ahash_request *req)
@@ -1132,94 +1095,114 @@ static int sahara_sha_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static struct skcipher_alg aes_algs[] = {
+static struct skcipher_engine_alg aes_algs[] = {
 {
-	.base.cra_name		= "ecb(aes)",
-	.base.cra_driver_name	= "sahara-ecb-aes",
-	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
-	.base.cra_alignmask	= 0x0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= sahara_aes_init_tfm,
-	.exit			= sahara_aes_exit_tfm,
-	.min_keysize		= AES_MIN_KEY_SIZE ,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.setkey			= sahara_aes_setkey,
-	.encrypt		= sahara_aes_ecb_encrypt,
-	.decrypt		= sahara_aes_ecb_decrypt,
+	.base = {
+		.base.cra_name		= "ecb(aes)",
+		.base.cra_driver_name	= "sahara-ecb-aes",
+		.base.cra_priority	= 300,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct sahara_ctx),
+		.base.cra_alignmask	= 0x0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= sahara_aes_init_tfm,
+		.exit			= sahara_aes_exit_tfm,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.setkey			= sahara_aes_setkey,
+		.encrypt		= sahara_aes_ecb_encrypt,
+		.decrypt		= sahara_aes_ecb_decrypt,
+	},
+	.op = {
+		.do_one_request = sahara_do_one_request,
+	},
 }, {
-	.base.cra_name		= "cbc(aes)",
-	.base.cra_driver_name	= "sahara-cbc-aes",
-	.base.cra_priority	= 300,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct sahara_ctx),
-	.base.cra_alignmask	= 0x0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= sahara_aes_init_tfm,
-	.exit			= sahara_aes_exit_tfm,
-	.min_keysize		= AES_MIN_KEY_SIZE ,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= sahara_aes_setkey,
-	.encrypt		= sahara_aes_cbc_encrypt,
-	.decrypt		= sahara_aes_cbc_decrypt,
+	.base = {
+		.base.cra_name		= "cbc(aes)",
+		.base.cra_driver_name	= "sahara-cbc-aes",
+		.base.cra_priority	= 300,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct sahara_ctx),
+		.base.cra_alignmask	= 0x0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= sahara_aes_init_tfm,
+		.exit			= sahara_aes_exit_tfm,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= sahara_aes_setkey,
+		.encrypt		= sahara_aes_cbc_encrypt,
+		.decrypt		= sahara_aes_cbc_decrypt,
+	},
+	.op = {
+		.do_one_request = sahara_do_one_request,
+	},
 }
 };
 
-static struct ahash_alg sha_v3_algs[] = {
+static struct ahash_engine_alg sha_v3_algs[] = {
 {
-	.init		= sahara_sha_init,
-	.update		= sahara_sha_update,
-	.final		= sahara_sha_final,
-	.finup		= sahara_sha_finup,
-	.digest		= sahara_sha_digest,
-	.export		= sahara_sha_export,
-	.import		= sahara_sha_import,
-	.halg.digestsize	= SHA1_DIGEST_SIZE,
-	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
-	.halg.base	= {
-		.cra_name		= "sha1",
-		.cra_driver_name	= "sahara-sha1",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
-		.cra_blocksize		= SHA1_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct sahara_ctx),
-		.cra_alignmask		= 0,
-		.cra_module		= THIS_MODULE,
-		.cra_init		= sahara_sha_cra_init,
-	}
+	.base = {
+		.init		= sahara_sha_init,
+		.update		= sahara_sha_update,
+		.final		= sahara_sha_final,
+		.finup		= sahara_sha_finup,
+		.digest		= sahara_sha_digest,
+		.export		= sahara_sha_export,
+		.import		= sahara_sha_import,
+		.halg.digestsize	= SHA1_DIGEST_SIZE,
+		.halg.statesize         = sizeof(struct sahara_sha_reqctx),
+		.halg.base	= {
+			.cra_name		= "sha1",
+			.cra_driver_name	= "sahara-sha1",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+							CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= SHA1_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct sahara_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= sahara_sha_cra_init,
+		}
+	},
+	.op = {
+		.do_one_request = sahara_do_one_request,
+	},
 },
 };
 
-static struct ahash_alg sha_v4_algs[] = {
+static struct ahash_engine_alg sha_v4_algs[] = {
 {
-	.init		= sahara_sha_init,
-	.update		= sahara_sha_update,
-	.final		= sahara_sha_final,
-	.finup		= sahara_sha_finup,
-	.digest		= sahara_sha_digest,
-	.export		= sahara_sha_export,
-	.import		= sahara_sha_import,
-	.halg.digestsize	= SHA256_DIGEST_SIZE,
-	.halg.statesize         = sizeof(struct sahara_sha_reqctx),
-	.halg.base	= {
-		.cra_name		= "sha256",
-		.cra_driver_name	= "sahara-sha256",
-		.cra_priority		= 300,
-		.cra_flags		= CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK,
-		.cra_blocksize		= SHA256_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct sahara_ctx),
-		.cra_alignmask		= 0,
-		.cra_module		= THIS_MODULE,
-		.cra_init		= sahara_sha_cra_init,
-	}
+	.base = {
+		.init		= sahara_sha_init,
+		.update		= sahara_sha_update,
+		.final		= sahara_sha_final,
+		.finup		= sahara_sha_finup,
+		.digest		= sahara_sha_digest,
+		.export		= sahara_sha_export,
+		.import		= sahara_sha_import,
+		.halg.digestsize	= SHA256_DIGEST_SIZE,
+		.halg.statesize         = sizeof(struct sahara_sha_reqctx),
+		.halg.base	= {
+			.cra_name		= "sha256",
+			.cra_driver_name	= "sahara-sha256",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_ASYNC |
+							CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= SHA256_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct sahara_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= sahara_sha_cra_init,
+		}
+	},
+	.op = {
+		.do_one_request = sahara_do_one_request,
+	},
 },
 };
 
@@ -1249,57 +1232,42 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
 static int sahara_register_algs(struct sahara_dev *dev)
 {
 	int err;
-	unsigned int i, j, k, l;
 
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
-		err = crypto_register_skcipher(&aes_algs[i]);
-		if (err)
-			goto err_aes_algs;
-	}
+	err = crypto_engine_register_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
+	if (err)
+		return err;
 
-	for (k = 0; k < ARRAY_SIZE(sha_v3_algs); k++) {
-		err = crypto_register_ahash(&sha_v3_algs[k]);
+	err = crypto_engine_register_ahashes(sha_v3_algs,
+					     ARRAY_SIZE(sha_v3_algs));
+	if (err)
+		goto err_aes_algs;
+
+	if (dev->version > SAHARA_VERSION_3) {
+		err = crypto_engine_register_ahashes(sha_v4_algs,
+						     ARRAY_SIZE(sha_v4_algs));
 		if (err)
 			goto err_sha_v3_algs;
 	}
 
-	if (dev->version > SAHARA_VERSION_3)
-		for (l = 0; l < ARRAY_SIZE(sha_v4_algs); l++) {
-			err = crypto_register_ahash(&sha_v4_algs[l]);
-			if (err)
-				goto err_sha_v4_algs;
-		}
-
 	return 0;
 
-err_sha_v4_algs:
-	for (j = 0; j < l; j++)
-		crypto_unregister_ahash(&sha_v4_algs[j]);
-
 err_sha_v3_algs:
-	for (j = 0; j < k; j++)
-		crypto_unregister_ahash(&sha_v3_algs[j]);
+	crypto_engine_unregister_ahashes(sha_v3_algs, ARRAY_SIZE(sha_v3_algs));
 
 err_aes_algs:
-	for (j = 0; j < i; j++)
-		crypto_unregister_skcipher(&aes_algs[j]);
+	crypto_engine_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
 
 	return err;
 }
 
 static void sahara_unregister_algs(struct sahara_dev *dev)
 {
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
-		crypto_unregister_skcipher(&aes_algs[i]);
-
-	for (i = 0; i < ARRAY_SIZE(sha_v3_algs); i++)
-		crypto_unregister_ahash(&sha_v3_algs[i]);
+	crypto_engine_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
+	crypto_engine_unregister_ahashes(sha_v3_algs, ARRAY_SIZE(sha_v3_algs));
 
 	if (dev->version > SAHARA_VERSION_3)
-		for (i = 0; i < ARRAY_SIZE(sha_v4_algs); i++)
-			crypto_unregister_ahash(&sha_v4_algs[i]);
+		crypto_engine_unregister_ahashes(sha_v4_algs,
+						 ARRAY_SIZE(sha_v4_algs));
 }
 
 static const struct of_device_id sahara_dt_ids[] = {
@@ -1388,15 +1356,17 @@ static int sahara_probe(struct platform_device *pdev)
 		dev->hw_link[i] = dev->hw_link[i - 1] + 1;
 	}
 
-	crypto_init_queue(&dev->queue, SAHARA_QUEUE_LENGTH);
-
-	spin_lock_init(&dev->queue_spinlock);
-
 	dev_ptr = dev;
 
-	dev->kthread = kthread_run(sahara_queue_manage, dev, "sahara_crypto");
-	if (IS_ERR(dev->kthread)) {
-		return PTR_ERR(dev->kthread);
+	dev->engine = crypto_engine_alloc_init(&pdev->dev, true);
+	if (!dev->engine)
+		return -ENOMEM;
+
+	err = crypto_engine_start(dev->engine);
+	if (err) {
+		crypto_engine_exit(dev->engine);
+		return dev_err_probe(&pdev->dev, err,
+				     "Could not start crypto engine\n");
 	}
 
 	init_completion(&dev->dma_completion);
@@ -1436,7 +1406,7 @@ static int sahara_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	kthread_stop(dev->kthread);
+	crypto_engine_exit(dev->engine);
 
 	return err;
 }
@@ -1445,8 +1415,7 @@ static void sahara_remove(struct platform_device *pdev)
 {
 	struct sahara_dev *dev = platform_get_drvdata(pdev);
 
-	kthread_stop(dev->kthread);
-
+	crypto_engine_exit(dev->engine);
 	sahara_unregister_algs(dev);
 }
 
-- 
2.34.1


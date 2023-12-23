Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A1F168AC
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="JPgMSOLC"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BNHs82f010253;
	Sat, 23 Dec 2023 18:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=23fKkQHwcl9dzJfjJFSygtcqI3Zf7jtkTwMWWogJAXY=; b=
	JPgMSOLCA2NMunc9eeEZAIMdObQ1o3yrSxtdX2Mk7jD4mq8BqG02vPPX5xZ4aQD+
	lxF3UkpZbZPjcPLDOY9UZrhZuRn9jxjHK9NyXwaF0K/F4G2M2m6FsVe03JuSzaUj
	JbgZlHcpnozKbhTRM2aCfsNKlpU3AoQCKRyZCa1vY7W5WrM9DyBH0PxSmTD69M+h
	OLsY/JXIMlozGnIhiSdp5ZWoH8gUMVYRdDZaZeMO8hy3vJ2yYLn6K1VWiJ2ewF5D
	d2MunYM2p7y+ZxR7f/U4UHcN24azwEyt2QqTPJoNgMi3burtS5V7OSvc84ZVff42
	7lBoJtZ8TVb1GjsyyxB9lg==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v5ph60dqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 23 Dec 2023 18:10:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NNfPQVHRAdHzT2p71aBrv+QMTC4a9YCJEZDwZw3slwYlA5IJR00DLNP64CQkOuEVuI/hgy7ALNFRX6WW4Dd5VGjSf0U5krwgBL/vBzuIYtPJQTU1ao3BHLAgoj5sNyYsaF8VTI68G2uMr9Xz84eu9rqRh04/W3AYkfoMq8pXJEkXMjsgj3UBe0cxOIw8VSy+9smzZ0uvB89vSUYYSAdule4/V45NCZO8UudoT0o2pwtkXcJuFNy8dWJuko8gf0qXXwt3ltTgpS/TuqVvyCM3++ahTuihpIJ90EnPaCsFapXW2M93PlN8r6ptlnQii4LLi51hPuqXWc+LUi81U6spdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23fKkQHwcl9dzJfjJFSygtcqI3Zf7jtkTwMWWogJAXY=;
 b=ZY02Ekf66hT7x5S0XMW7vD5FW84eumdmFPlkN2gX62WUI8cvVvXFlOeaVsvYaExO6Bi4NMmKLFKjWC5xYfgUJp6R8yBMqel52wmntKoiYySfjrmaQQpQWYzb6xySHXHrc5C03/tqpBULAm79bLn6gJAZELps4IBkOgFVB9sFPmK2WL+6pfireIlCZUAIVhOOYxuIVhc3fD4/U+39Aae6gGJKk6N3eSz+B7TThE48PNCN/Qrb+NZQ3oK2S4wFJZx6mAQk7etzRFHz/dCPqRqv7iykOybtWGitFwuSDmYQDImM8VOu38bvR0o5wFIseIcu1uv1ztRSnvHhVeopFDxrlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.24; Sat, 23 Dec
 2023 18:10:54 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7113.023; Sat, 23 Dec 2023
 18:10:54 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, festevam@gmail.com
Subject: [PATCH 14/14] crypto: sahara - add support for crypto_engine
Date: Sat, 23 Dec 2023 20:11:08 +0200
Message-Id: <20231223181108.3819741-14-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
References: <20231223181108.3819741-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0053.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: 85148d74-771b-4d9d-2ba2-08dc03e2811f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	aUo/1hNHar/hVrJ1byW2ilPz8t1Ni5JV3J1xCIxzUXTSQVxQAJKuOebkAaQdA1tGZrnZuJNBfEKfOYwKQSBSpGwcek4c4vjHSAb2nqfSkdPkz0GiEGZn+i0QfztRIkh0DE6IT8H4P72IaHAxNjSc9FcUc1DN3kQGBHwZe/ClT34fGJKZG5o2kEDnvzo3/35oKQ6bfLtacGoEzoq9FlcrCppJOuEaYIi+xIzTRqm+opsMvmkv2mvrHXC8Jr82G4UILWn7nKYyOupc+jcVUzaKqq9nRrFTl/pFSdebQd+qzD7ZV5VUIW5wlXpVGR53BhqSsppPISc5/npC9z2ox3w4QZLX+qmx6CHXxltfUg/REEPgpdqVhqDipFW3W5pjtff/0Z8uRx5k6aOts27AFB67wPWo84WWrxkNq1I/lOZmSrN9/EF/NUcpq9NxkhhE41BCUfx6oVRDOcTny4Yh3GSPUkSLOXAwbGIp5ywGogR1xdGEcmvHrOaon0fo1MR8eIIluqvCmTkSXbIbU0qicH2EqVu/SoaMZ9EdD5YNkQFU4kE0wEoVn8bZ5Yzp5A/9bdAcBHsMGe9XMKhWCuoLN+znFZIZ0Jh2W+V42N4uvKqXF3BXJz6bTiabtsfxzRj2NoxF
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(136003)(376002)(396003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(38100700002)(2616005)(1076003)(26005)(83380400001)(36756003)(86362001)(38350700005)(6512007)(6506007)(52116002)(6916009)(316002)(6486002)(478600001)(6666004)(9686003)(66556008)(66476007)(66946007)(2906002)(30864003)(4326008)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5Xcr9c9m6LtJIySb8tWxID4x4xFCnSXMzhbgksr9YcczO3dBgDtUsC2GX+2L?=
 =?us-ascii?Q?AYTXidV+b7H0xkTzfwVb3QfPXB+a3aJ6+LA/QT9SXbWBAQ934A8D1UVV7lZw?=
 =?us-ascii?Q?6hneWmkSeIvtVuvKMpY4RM6Rkjev0+XdQum2pmVWiCCj6O2jeOYATEbOjyOZ?=
 =?us-ascii?Q?QUsVhOE0iaDS6cagEZ60GYKkZ03ElXIFx4CJqx3JRt4KfercIkyQNX1qHfry?=
 =?us-ascii?Q?Syz5eCLLF2cQnmyOlr4Da2nR3FI5WT2KgnVOXZW8VeFu2cNIo4ncO/fvSRkw?=
 =?us-ascii?Q?1+nertgt1o6gbyOVrBKeuFsJfQ6D7C9wg4dCi7cxESbYSONFi3yYi+336OpV?=
 =?us-ascii?Q?D4HTMY/eLPU8B0VUa6g10iGWOvAEnMb+4MuqRdEkTXQt8NDjkx76+XsTOBZm?=
 =?us-ascii?Q?GFVvqsAkfTP77PZef0GYFmwwfO5FwBwJMuuYUMYUTcqTvaHiCWpLnahEmDod?=
 =?us-ascii?Q?SupZulW822HqFlv73DlD3Koh3vD8xoWIx1cKY/sYw4QHpORp1Ivm9lYhkaZQ?=
 =?us-ascii?Q?MEGP0W0SQrGEVzbRQPZFK3NlEPzP1KJdV4hAdRmh1mTGHLxDqTxLvvHrApcB?=
 =?us-ascii?Q?rRjdJ+7h1+COSmclreJrszDvXxKIrELCf60zd27FDLY4uDHzUSvEu1ZAHdI7?=
 =?us-ascii?Q?EHZGJ/KDWA4FFl9u59qcJdt74SCo/fnYLWHT2FLzFmGNDqc5rvMs4kFDjzDG?=
 =?us-ascii?Q?g0sSVMN/yUy4+cCpc9oR0dBkiEeYSvdBjwzljbr2uIv0BM2kVxG3zUlj/bRN?=
 =?us-ascii?Q?abNamqMu14wj9PRCo9FnThz76tFvdjFbU44iUeH49EbizOr/WrMrh/AQW3Tb?=
 =?us-ascii?Q?hLjwTIuURviBTegvi5Ut8JNRRTm0eyXuKvQ5a3XbG/ZpbD32FUxEIQAMDH0D?=
 =?us-ascii?Q?ntIHtIUH+7gT9E3QYOoFzsrRdxQP1CoCEQwTXIKZLmn6b4UQpYBqYIGlxu5/?=
 =?us-ascii?Q?0M+t3A7mOgfxXGKZ84Y+UTVhjL3fAWw9zFfj3O3W5WbB6qRplkDcRFqRi3Xx?=
 =?us-ascii?Q?rkSJIP+cJd/Objfc1qlCNU7QYyTH1VVKHCvOJh2U5kodPA5KnirO/849wMnj?=
 =?us-ascii?Q?8sV5WR79vrB57+JcTx3fdH0BrwmRzCyIul7i+koP/SKiGtrUDjSUuI/6ILXW?=
 =?us-ascii?Q?sKyzOX5EnHENk9tLcBUNIYjyen5hroUTdcI/vbmWg7pdtCzD9uxYxCKQfI7T?=
 =?us-ascii?Q?jD7Ly71XbZVaHpdFRxSR5Sa/rTlZ84MWydUUzmOpqcIcctAmuw26nJtw9PMf?=
 =?us-ascii?Q?NE/VxmS2QZDoGrQcJr2HCWcwi1zj08/9wi5tIaLvj2eaoJ8FUJaWrECP1Jic?=
 =?us-ascii?Q?pfiZcj4E/slD7d2E98EOenXLH9wQ76ctF2wHuU5POOO19Dlueo7D08VJBZXa?=
 =?us-ascii?Q?Ym/i6CQJUEBLINjQgPviZDl+j+wdFRAmvR/rJ293ptEe4CIbpworvU4K9BJZ?=
 =?us-ascii?Q?/ibDcmLAi60ibbxLhBLG4Pl5emWzICtdnHBvwqsyiai8zCf63GY0Qe6d2D6l?=
 =?us-ascii?Q?wgZhvKVJe/e3OxDSGWBxB8vQ/YwgpvIVoz4YmgMw9Ai67N9sfNDqNQ1E9mN4?=
 =?us-ascii?Q?4T7STNlAV7P00v97mp0kGgF5+wHaF5mk01Ri3zs9f6tgYZy1zsDNgHE2tSYY?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85148d74-771b-4d9d-2ba2-08dc03e2811f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 18:10:54.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpA0knPJnKIZVpmnH4a2YMGMomfehMTrveS2bWPdiTp0/a83LrHLqY2CGkzE5o0yq794PvLE5Gqxhj2fUyzhHF6kD48rY5lp0jQS5RFJB60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-Proofpoint-ORIG-GUID: SvOKhKPpVIUTleEdTQtVaB4oo0KsnT1U
X-Proofpoint-GUID: SvOKhKPpVIUTleEdTQtVaB4oo0KsnT1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=962 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312230144

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Convert sahara driver to use crypto_engine, rather than doing manual queue
management.

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/Kconfig  |   1 +
 drivers/crypto/sahara.c | 326 ++++++++++++++++++----------------------
 2 files changed, 147 insertions(+), 180 deletions(-)

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
index 886395603a3a..6f3935f450ac 100644
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
 
@@ -1249,57 +1232,39 @@ static irqreturn_t sahara_irq_handler(int irq, void *data)
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
-
-	if (dev->version > SAHARA_VERSION_3)
-		for (i = 0; i < ARRAY_SIZE(sha_v4_algs); i++)
-			crypto_unregister_ahash(&sha_v4_algs[i]);
+	crypto_engine_unregister_skciphers(aes_algs, ARRAY_SIZE(aes_algs));
+	crypto_engine_unregister_ahashes(sha_v3_algs, ARRAY_SIZE(sha_v3_algs));
+	crypto_engine_unregister_ahashes(sha_v4_algs, ARRAY_SIZE(sha_v4_algs));
 }
 
 static const struct of_device_id sahara_dt_ids[] = {
@@ -1388,15 +1353,17 @@ static int sahara_probe(struct platform_device *pdev)
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
@@ -1436,7 +1403,7 @@ static int sahara_probe(struct platform_device *pdev)
 	return 0;
 
 err_algs:
-	kthread_stop(dev->kthread);
+	crypto_engine_exit(dev->engine);
 
 	return err;
 }
@@ -1445,8 +1412,7 @@ static void sahara_remove(struct platform_device *pdev)
 {
 	struct sahara_dev *dev = platform_get_drvdata(pdev);
 
-	kthread_stop(dev->kthread);
-
+	crypto_engine_exit(dev->engine);
 	sahara_unregister_algs(dev);
 }
 
-- 
2.34.1


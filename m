Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="U9Rg1HM7"
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104589A
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 09:05:39 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3B1BxksJ031433;
	Fri, 1 Dec 2023 09:05:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	PPS06212021; bh=UnsECkqUT+/3DWRvcVeGt3HH/CvWuLerCSRGP34RJJo=; b=
	U9Rg1HM7q3/X8oF3+WKcUfK2J4nBqtN2h4rHTraZOLTt5fOja0q+7awc8JYL4AU2
	WU4Hme9aE3yEkayE2QOZHL/0ei55ibpLUgrtry9qYiEYterb8iIeHvv/1wMkKaR7
	tNZu69ljHfJipTyMuK5vGw70BWyYAOvzhG445GgiIilGdOet5xE2nKwrFvjE4BIp
	3n5qSSvj6ZVlDCkl/v2tL7uzTnMWyXP8Ho+Rk3Erx99UOEQZJ5cDq0qGmMOaFa+J
	aiHU7g+vNK3pQDF+ymOIVPWKghTCk2DR/ADo8jwmg3K3joGdzupMTBawUrdqF0Ta
	vPyrmV1nBqXtGbPhVUBTpg==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3uph6dhynw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 09:05:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDGI2JC7vjqbeLrxO2OT7jD5OKFS5rn1JhzJNuPCs1yad6bmO50ggfisQTYV+YD4QhDiBQE1HZdhOmyWR+rusQrVNCcpz2VkwlZaoI1oU6rfMelOXJwLJHAhoPN7GhV8UU+iPGOB5iGloePH1i38e0pW0AsrJX/TS3jz4Q4gwMlJKtyu84QVhcPoleFq+GxsIlLqLBDXA7VFRvR92x5YBsISGL9ffMPMerO8Qc4imq4t+407pCVpeg0ZXKZEZrZDbBbNsLYnvXt+e2SWzrcNkpVtnyaqF/rxuIcdK80mmOqTpKjXbEHWI9OX2af11XViiT+mfL+4WjzpWHj9/Ntf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UnsECkqUT+/3DWRvcVeGt3HH/CvWuLerCSRGP34RJJo=;
 b=Mqbo9fYAOgQ8ilgdNN04pWhhnbRQSrAXVKHNT/qjYqr+G0fGDQid5H/NJacsybGYlm9dozD4FlNISMqQxQCR7qBSuwJLJbuhwSjbbxYlCBm0LiIIL7AwGJzdrUzAPq9cDLXy8nlOxUCzNslMs5R7Y+oJSW4j8DUEww7fSEbFdHntseDBtepc661RjIrztZYOISrZUHFOzkYXEqZSVxqwbkEE4/e6V+WmKoI8Anc3wbrU6MvcbQbuSEjQqc2CZRcE6djRUSfUA1U3FATQJTEiNuY5pA+Uov/RwIF8XUzcY0P5PxRQF9QRIUR+kG53IWDPEUXiJ7JK5jpvEK4Fd73/6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 17:05:34 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7c2e:5b95:fdc2:30e%3]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 17:05:34 +0000
From: ovidiu.panait@windriver.com
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, festevam@gmail.com
Subject: [PATCH 7/7] crypto: sahara - avoid skcipher fallback code duplication
Date: Fri,  1 Dec 2023 19:06:25 +0200
Message-Id: <20231201170625.713368-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231201170625.713368-1-ovidiu.panait@windriver.com>
References: <20231201170625.713368-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0244.eurprd07.prod.outlook.com
 (2603:10a6:802:58::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|CY5PR11MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ce4f1eb-0cec-4d26-0fc6-08dbf28fbb6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5Kc+3cvJZ34V+kZ152vXqVCtXGf3E6xnEQQumXd+KaL/wkhy4WNR9OJ94f7Cz6KF2RoEdJVhMWHCCMW73QLPXojVTUAUyICC/6XI4Kj0aj0H1IM4WcM3Lp7KmmGR1D53+pE8NVMDH2cn++6hutCVI6Py4xzkB1iZUQEi+mLAbfmX6l6XQkuxL+72GR3D5jFNqJVt5R9HGGl7mrVXsWlaxod0ZZgdA/YI3AT8VFrWmUf1HJWZYJws9EFIrof9TGKcyfezJUP+l8ax5Bhpxyz8B7PONTRAe8pKf3eKN6ewI1I8/cTxXqSQUsHbi5QRUEPa8ojqWwwN9f8XN6h4/w1c2A/8BDMMPHvgZypnUBRlQpO9fKo88KzzisVlHtVDlj9Etd/ZHHRcadaO1YgFzptG+YXnZyn85kHKJW7bQ+qPtxMobzskeh96Q/SPE0AtKnFyrrug/P8mVzoZVNCQ1i/QtChcIoguYaxOIJhrQoOryQlqK6sqMLNnnuMnOB1ufCMgDTZtqJKIQucs0pFPPi4Q4MZ/jLPV8i2n4AIGFARnioH7An5oTkJNERdx5yfENpxnsmL1IEx2MGTEfdLSjqnk4ZlrXEYl5IaEMZ29QrVupX52HVHgVMleqth7vehvwqBu
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(346002)(366004)(376002)(136003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(83380400001)(86362001)(6506007)(26005)(9686003)(1076003)(6666004)(52116002)(6512007)(2616005)(41300700001)(8936002)(8676002)(6486002)(478600001)(5660300002)(2906002)(4326008)(316002)(66556008)(66476007)(6916009)(36756003)(38100700002)(66946007)(38350700005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ECKJzvkeiDiwXUyPSbs61reYL7PgH2tzW0fQJPWNk5IhWls5XHlbXjla6nnw?=
 =?us-ascii?Q?0wolTx19E2OVPO/AZ5uGB2sfbo5d1j8xctGEsPfqhJom3w4vL2VT3vSQ6jvk?=
 =?us-ascii?Q?uiv9A8jRZYZxGj27MYfR5lAMI7JiluGSZmFzpQxfJbr3dGJMfizfJP/qcZNy?=
 =?us-ascii?Q?ZSEbzzXsQuUCea+K6u6ViT8xBGcYqs0cip35j1FcOeN34PZ4nwvLsA9FAeYO?=
 =?us-ascii?Q?AN/1NlriOOx2ioPxi+C7F7Ro/Z0xNH7HusI2g+26LOsCIr+DpNLqo2ofLydO?=
 =?us-ascii?Q?l8j9UtCguXNr7S7XS9rcX5Ib2wmFr30aVcx5f1QkLEmyozcW45d3hJbW/+5V?=
 =?us-ascii?Q?bVY2KcnlPmfL70M7oGQrB3bKA0Fhr5Ce2IUtGobz2q+cmuGCF4utlxqZmV3k?=
 =?us-ascii?Q?ieM4NgMrLXo/gzbkgusXw8VoHKgxsQYxPH6rbkQiGXw9DFzyKKzaIT3BAdVZ?=
 =?us-ascii?Q?WRHYFX+Xw2GnKRaeyZ2FMDcajym/UOJZ8md4rEAxn7xm81VTgvkng0lu00T8?=
 =?us-ascii?Q?K8x23gj4MZMbuHIlthD8WBwaWm/q1OMyjl6v/kqBp0CzRDc6oTf0kZFTbt6j?=
 =?us-ascii?Q?U2ZaZMmVs9AUDDFFiTBs/COL9vkFIdPKswze+dDO37zhUwCJSKFhL8ofAMAZ?=
 =?us-ascii?Q?kicsZ5bn2dhU415HLmy1SBPJRQPGJHhhXZGqZz5FhKou1v3udSgnvagyqw+T?=
 =?us-ascii?Q?/UrI7u32GSAfIDqoagFKF0kGgVUBZuW0d5RI7sOLnhP8n5CpuB6gK8a1S39B?=
 =?us-ascii?Q?1fyYNkvkf/hmSAofi3g0CYWUvgjgk+jb6+skGeT2sLVm2h3xeHjYV0zUmT9r?=
 =?us-ascii?Q?NcrLr44oLixildE683ypk+r3sokotplMzDTWSBXmvgvE6FPaQBOx4YS4qd6e?=
 =?us-ascii?Q?eE+r/8J89JN4pDBavWC+kBCAvVJeRsixH+JtHffiIG0xMjN1zKNJdgeyeCp8?=
 =?us-ascii?Q?PCnQ+KaZS8vCZKveOGHiWQYOTUGC5G/47PpCYwXhpHxcbpAWTEAS55Q28iAh?=
 =?us-ascii?Q?m3Mw5lYHFuMn7LZWXcScECXHqU/e7Zs7yXt20sYWbd+Q+S76LWuwFhT+YrMA?=
 =?us-ascii?Q?DYA8x0rcnWN5ls8fG1VRJEiyfhP5Y+siTDMG9ho5j7KkeXWJMcgEDE2/TZQ6?=
 =?us-ascii?Q?daxdEme8rwbHJJ6SbPBdG7UyrC5LOgQpkz+v0AJbEXG008dvHfv/Zs+kbAL/?=
 =?us-ascii?Q?RpaZK5F5qtzp3MRnm+LOYX794AVqBa72UFABU5Cyb5nEqdgWzXln5AU/7ATw?=
 =?us-ascii?Q?3g9Mx4nJ8CN5YtY8SljcUBSk3iUpONnyEJ5aDX1mTGFwYCdzvUvkXOIH6ry5?=
 =?us-ascii?Q?+pzl4QgLii3F8skM8zdKlX6BJslJPDuQdnEzvOHrRBrZFqa+GaeNBBd98UrA?=
 =?us-ascii?Q?0JNkLL/2VfmMQK7e1IXnPTIm8DELiQB8Hz+1USVe6hmbk72eIiYCAtXc/oQc?=
 =?us-ascii?Q?GXE4Qg3zNBvjvWlO0R6tCTqZtYNsj/6rzhLGcQhvb79PGtGy5yNeoO5HFJHp?=
 =?us-ascii?Q?dHCjhZBG+TnQ3UyoTG1zAmyKR16yx1vtgQsvwOTgHBmwJ9ZGGPM9Cq+CJvh+?=
 =?us-ascii?Q?oh4zJe/P0utqI1zwCHhrjU5B6+pb690vYtcZPGjxABCmigS2kjLILns93xJM?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce4f1eb-0cec-4d26-0fc6-08dbf28fbb6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 17:05:34.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYXDwXvNEQo/5+QRn9v8oUPgYxeqZZvqckbblSdx+LvivfFh3HJev5TZtsjS/pIaLGKhutyjD8pCzP+C5ueCIQidi6qs3QKtI6vzybyNjgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-Proofpoint-GUID: UIkYWkjx2WiwRuWztWoj90IeGFsB02-8
X-Proofpoint-ORIG-GUID: UIkYWkjx2WiwRuWztWoj90IeGFsB02-8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=679 adultscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311060001 definitions=main-2312010115

From: Ovidiu Panait <ovidiu.panait@windriver.com>

Factor out duplicated skcipher fallback handling code to a helper function
sahara_aes_fallback(). Also, keep a single check if fallback is required in
sahara_aes_crypt().

Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 drivers/crypto/sahara.c | 85 ++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 2f09c098742d..27ed66cb761f 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -646,12 +646,37 @@ static int sahara_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return crypto_skcipher_setkey(ctx->fallback, key, keylen);
 }
 
+static int sahara_aes_fallback(struct skcipher_request *req, unsigned long mode)
+{
+	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
+
+	skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+	skcipher_request_set_callback(&rctx->fallback_req,
+				      req->base.flags,
+				      req->base.complete,
+				      req->base.data);
+	skcipher_request_set_crypt(&rctx->fallback_req, req->src,
+				   req->dst, req->cryptlen, req->iv);
+
+	if (mode & FLAGS_ENCRYPT)
+		return crypto_skcipher_encrypt(&rctx->fallback_req);
+
+	return crypto_skcipher_decrypt(&rctx->fallback_req);
+}
+
 static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 {
 	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
+	struct sahara_ctx *ctx = crypto_skcipher_ctx(
+		crypto_skcipher_reqtfm(req));
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
+		return sahara_aes_fallback(req, mode);
+
 	dev_dbg(dev->device, "nbytes: %d, enc: %d, cbc: %d\n",
 		req->cryptlen, !!(mode & FLAGS_ENCRYPT), !!(mode & FLAGS_CBC));
 
@@ -674,81 +699,21 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 
 static int sahara_aes_ecb_encrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_encrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT);
 }
 
 static int sahara_aes_ecb_decrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_decrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, 0);
 }
 
 static int sahara_aes_cbc_encrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_encrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_ENCRYPT | FLAGS_CBC);
 }
 
 static int sahara_aes_cbc_decrypt(struct skcipher_request *req)
 {
-	struct sahara_aes_reqctx *rctx = skcipher_request_ctx(req);
-	struct sahara_ctx *ctx = crypto_skcipher_ctx(
-		crypto_skcipher_reqtfm(req));
-
-	if (unlikely(ctx->keylen != AES_KEYSIZE_128)) {
-		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
-		skcipher_request_set_callback(&rctx->fallback_req,
-					      req->base.flags,
-					      req->base.complete,
-					      req->base.data);
-		skcipher_request_set_crypt(&rctx->fallback_req, req->src,
-					   req->dst, req->cryptlen, req->iv);
-		return crypto_skcipher_decrypt(&rctx->fallback_req);
-	}
-
 	return sahara_aes_crypt(req, FLAGS_CBC);
 }
 
-- 
2.34.1


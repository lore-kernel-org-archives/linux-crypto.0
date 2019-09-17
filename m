Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886ABC4CECD
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 06:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E01621848
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 06:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UOo2/B6c";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="uB9T+4r8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfIQGhE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 02:37:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20600 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729094AbfIQGhD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 02:37:03 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8H6UbVT000750;
        Mon, 16 Sep 2019 23:36:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=3rI20w9GpToQ35JUgppavu70EPzlDBP9uuInWyrZ0CY=;
 b=UOo2/B6cEjrOJ1sFgLDb53RyJewWV51pC1q78hkbR+DdlNRf7GqUKujfF0pqaxZWCX5n
 vWA2+UomF1x8vXm+nomtkKk24CPVokHQmfDKkh06ka48VH61eCdwoPYk49Jk6g+9rDRU
 vZJR6A+UID57X2uEuGa4w/gM2HTDz5eNJ35R56QPSQrwSmpOHdOX5DqKFJvDlbK2QD0Q
 666kqjjzDTjXKkezBhSiEg+bi1eJHsTX/6oidNNRSgN0jaJI1Yz3Z+hiSq907oOKchuy
 u7eKILLvEDLdTs4yjidvzHDWPWLv7RUUr2Nw958mPADzx3icBujJABmOMeHmw5X/Tp9J 2Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v0yqksq8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Sep 2019 23:36:54 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 16 Sep
 2019 23:36:52 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 23:36:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j74MP6bjEv/AS8Iher6CpuJonMAH2+tZYS9TjvaX3EOD4+rivWUXmkizWELeZotktk6B3vGMBg+IAlEGeqMjXbgUN6y/uoL3yOaRPOmef4tmaV2IamnB38R4ABFofCWjJuU78l9g+bZ1Py2C0nUBS+13QsJsBONBwoYFyfjGLp8OwL2e8MpzUpbseGaEapdTC+Xmbflh3NYzMy0jHqTouo9jdIkqPYhjFQNNZfFpaLVdIgFg1EP5bWBXE8uw9LVlj6LcQstKqb8pN57dzJmyJmgRXGbTUM+GZOl4fpp4l6FJXcKn6cpe0rD8JpFGPFi5/YebijopEBQTKGk1oknOWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rI20w9GpToQ35JUgppavu70EPzlDBP9uuInWyrZ0CY=;
 b=G7iBAFoW0ZCql/W8ByIBgXGyaXXgTOQpctzVUhDJjeW3Glhl/cTjovYVvQeXKWbwmtde4MGaRyPm10ESklLpdiX7uUGeCkThOKmNAnc6vkDNexaCmbO/59SGSdgfIUFspwz5bdtL3kH0AVx2yfCojllW/hhEivPR/gHvcVIbBS429NU8h79nnsSu/ZZGlMYj2AqhnjKX8G0sI47iqpX7aJE9+YDvWDXqoAAIi/CgonytcR4KxWG1uN3yNH4G4M/HCAs9CW6Y9raiA/OLNrFX4jMgOJkAZT4P0GQd+6lFE3gvKsxSEecI2ip2HDVdc8CPAA0n9sGktGVGfqmdOoFg8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rI20w9GpToQ35JUgppavu70EPzlDBP9uuInWyrZ0CY=;
 b=uB9T+4r8EvG++LLrMz3rCMDK+6/+VrVZOukv2LkzkQuCNOEaT8e+cSQGeXEvgCDN+A9idCtOTconAyRsLXV4aGzd2TJNDHz80LtXRsIqLBBtXvbIraj2YPXgjVI3k7uGAz1kGrXjOdW7EPDL9yiL5pkJ2TDTGCZyNrs2+N4E6H8=
Received: from MN2PR18MB2797.namprd18.prod.outlook.com (20.179.22.16) by
 MN2PR18MB2798.namprd18.prod.outlook.com (20.179.20.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Tue, 17 Sep 2019 06:36:51 +0000
Received: from MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9]) by MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9%7]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 06:36:51 +0000
From:   Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Srikanth Jampala <jsrikanth@marvell.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Fix cbc ciphers self test failures
Thread-Topic: [PATCH] crypto: cavium/nitrox - Fix cbc ciphers self test
 failures
Thread-Index: AQHVbSJJ+lsKwuXHH0qw9SdXQiyxiA==
Date:   Tue, 17 Sep 2019 06:36:50 +0000
Message-ID: <20190917063627.27472-1-rnagadheeraj@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0113.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::29)
 To MN2PR18MB2797.namprd18.prod.outlook.com (2603:10b6:208:a0::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6d20565-64f7-4143-d2ec-08d73b396c03
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2798;
x-ms-traffictypediagnostic: MN2PR18MB2798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB279883ACB3E6F9F52E6F6771D68F0@MN2PR18MB2798.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(64756008)(107886003)(50226002)(66066001)(25786009)(2906002)(14444005)(6486002)(316002)(256004)(54906003)(3846002)(6116002)(2616005)(476003)(6436002)(1076003)(4326008)(6512007)(305945005)(71190400001)(7736002)(71200400001)(14454004)(486006)(26005)(186003)(81166006)(36756003)(478600001)(110136005)(52116002)(99286004)(66446008)(81156014)(102836004)(8676002)(66556008)(86362001)(5660300002)(2501003)(386003)(66476007)(8936002)(55236004)(66946007)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2798;H:MN2PR18MB2797.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wSVB6jK0rlfqyDbC8Jth1lCPUy8vreUeDMtMDnQNqo0PQfZuXhGw4tskg6f8KSeMu1e0u6EPI/TWdR3VwmusVb+d7NDaN1To8dpUv/9MocpPCAuJNnZkTNWXZ6wEh8ICzwxenNWLOHkyLUd8yn5LX+rtY7jSQCuUZ6RR7rVakMS+iADly/faskt8OfUFdmj5R8ytUd6aVJj3/WeTTW0P/WeoJbyxWZE+m/2wc+HvLKS3jiSoe/qGiF7IoznzcPF6bmMZQDLpC103YhaZ3LFb4KWNQJvog72+n2L7tpbrlF+fd9O3XeH1mV/RwQZtAF+xYiaZCYeNJmKpiixJXU/6hcHsFPcV4CHMGTJISBiCJWLddTz4O5sVz4QXPUaJ6WxFoUz995Nkz+RZiUB2q73dphYYJSp163BcXWJ1pj0iqgw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d20565-64f7-4143-d2ec-08d73b396c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 06:36:50.9537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYzUgpAqHiL960dk/HsYEaVbNSW3/kNL1iVGJQSV0blQc5tF41lBNvTegopPaxz4+FrTCZGf7ev7bitWeZjZrOXPIhru6EkCXlGNjCNwDxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2798
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-17_03:2019-09-11,2019-09-17 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Self test failures are due to wrong output IV. This patch fixes this
issue by copying back output IV into skcipher request.

Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_req.h      |   4 +
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c | 133 ++++++++++++++++++---=
----
 2 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cav=
ium/nitrox/nitrox_req.h
index f69ba02c4d25..12282c1b14f5 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -10,6 +10,8 @@
 #define PENDING_SIG	0xFFFFFFFFFFFFFFFFUL
 #define PRIO 4001
=20
+typedef void (*sereq_completion_t)(void *req, int err);
+
 /**
  * struct gphdr - General purpose Header
  * @param0: first parameter.
@@ -203,12 +205,14 @@ struct nitrox_crypto_ctx {
 		struct flexi_crypto_context *fctx;
 	} u;
 	struct crypto_ctx_hdr *chdr;
+	sereq_completion_t callback;
 };
=20
 struct nitrox_kcrypt_request {
 	struct se_crypto_request creq;
 	u8 *src;
 	u8 *dst;
+	u8 *iv_out;
 };
=20
 /**
diff --git a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c b/drivers/crypt=
o/cavium/nitrox/nitrox_skcipher.c
index 3cdce1f0f257..ec3aaadc6fd7 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_skcipher.c
@@ -6,6 +6,7 @@
=20
 #include <crypto/aes.h>
 #include <crypto/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/des.h>
 #include <crypto/xts.h>
@@ -47,6 +48,63 @@ static enum flexi_cipher flexi_cipher_type(const char *n=
ame)
 	return cipher->value;
 }
=20
+static void free_src_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->src);
+}
+
+static void free_dst_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->dst);
+}
+
+static void nitrox_skcipher_callback(void *arg, int err)
+{
+	struct skcipher_request *skreq =3D arg;
+
+	free_src_sglist(skreq);
+	free_dst_sglist(skreq);
+	if (err) {
+		pr_err_ratelimited("request failed status 0x%0x\n", err);
+		err =3D -EINVAL;
+	}
+
+	skcipher_request_complete(skreq, err);
+}
+
+static void nitrox_cbc_cipher_callback(void *arg, int err)
+{
+	struct skcipher_request *skreq =3D arg;
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(skreq);
+	int ivsize =3D crypto_skcipher_ivsize(cipher);
+	unsigned int start =3D skreq->cryptlen - ivsize;
+
+	if (err) {
+		nitrox_skcipher_callback(arg, err);
+		return;
+	}
+
+	if (nkreq->creq.ctrl.s.arg =3D=3D ENCRYPT) {
+		scatterwalk_map_and_copy(skreq->iv, skreq->dst, start, ivsize,
+					 0);
+	} else {
+		if (skreq->src !=3D skreq->dst) {
+			scatterwalk_map_and_copy(skreq->iv, skreq->src, start,
+						 ivsize, 0);
+		} else {
+			memcpy(skreq->iv, nkreq->iv_out, ivsize);
+			kfree(nkreq->iv_out);
+		}
+	}
+
+	nitrox_skcipher_callback(arg, err);
+}
+
 static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
@@ -63,6 +121,8 @@ static int nitrox_skcipher_init(struct crypto_skcipher *=
tfm)
 		nitrox_put_device(nctx->ndev);
 		return -ENOMEM;
 	}
+
+	nctx->callback =3D nitrox_skcipher_callback;
 	nctx->chdr =3D chdr;
 	nctx->u.ctx_handle =3D (uintptr_t)((u8 *)chdr->vaddr +
 					 sizeof(struct ctx_hdr));
@@ -71,6 +131,19 @@ static int nitrox_skcipher_init(struct crypto_skcipher =
*tfm)
 	return 0;
 }
=20
+static int nitrox_cbc_init(struct crypto_skcipher *tfm)
+{
+	int err;
+	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
+
+	err =3D nitrox_skcipher_init(tfm);
+	if (err)
+		return err;
+
+	nctx->callback =3D nitrox_cbc_cipher_callback;
+	return 0;
+}
+
 static void nitrox_skcipher_exit(struct crypto_skcipher *tfm)
 {
 	struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
@@ -173,34 +246,6 @@ static int alloc_dst_sglist(struct skcipher_request *s=
kreq, int ivsize)
 	return 0;
 }
=20
-static void free_src_sglist(struct skcipher_request *skreq)
-{
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-
-	kfree(nkreq->src);
-}
-
-static void free_dst_sglist(struct skcipher_request *skreq)
-{
-	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
-
-	kfree(nkreq->dst);
-}
-
-static void nitrox_skcipher_callback(void *arg, int err)
-{
-	struct skcipher_request *skreq =3D arg;
-
-	free_src_sglist(skreq);
-	free_dst_sglist(skreq);
-	if (err) {
-		pr_err_ratelimited("request failed status 0x%0x\n", err);
-		err =3D -EINVAL;
-	}
-
-	skcipher_request_complete(skreq, err);
-}
-
 static int nitrox_skcipher_crypt(struct skcipher_request *skreq, bool enc)
 {
 	struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(skreq);
@@ -240,8 +285,28 @@ static int nitrox_skcipher_crypt(struct skcipher_reque=
st *skreq, bool enc)
 	}
=20
 	/* send the crypto request */
-	return nitrox_process_se_request(nctx->ndev, creq,
-					 nitrox_skcipher_callback, skreq);
+	return nitrox_process_se_request(nctx->ndev, creq, nctx->callback,
+					 skreq);
+}
+
+static int nitrox_cbc_decrypt(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(skreq);
+	int ivsize =3D crypto_skcipher_ivsize(cipher);
+	gfp_t flags =3D (skreq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+	unsigned int start =3D skreq->cryptlen - ivsize;
+
+	if (skreq->src !=3D skreq->dst)
+		return nitrox_skcipher_crypt(skreq, false);
+
+	nkreq->iv_out =3D kmalloc(ivsize, flags);
+	if (!nkreq->iv_out)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(nkreq->iv_out, skreq->src, start, ivsize, 0);
+	return nitrox_skcipher_crypt(skreq, false);
 }
=20
 static int nitrox_aes_encrypt(struct skcipher_request *skreq)
@@ -340,8 +405,8 @@ static struct skcipher_alg nitrox_skciphers[] =3D { {
 	.ivsize =3D AES_BLOCK_SIZE,
 	.setkey =3D nitrox_aes_setkey,
 	.encrypt =3D nitrox_aes_encrypt,
-	.decrypt =3D nitrox_aes_decrypt,
-	.init =3D nitrox_skcipher_init,
+	.decrypt =3D nitrox_cbc_decrypt,
+	.init =3D nitrox_cbc_init,
 	.exit =3D nitrox_skcipher_exit,
 }, {
 	.base =3D {
@@ -455,8 +520,8 @@ static struct skcipher_alg nitrox_skciphers[] =3D { {
 	.ivsize =3D DES3_EDE_BLOCK_SIZE,
 	.setkey =3D nitrox_3des_setkey,
 	.encrypt =3D nitrox_3des_encrypt,
-	.decrypt =3D nitrox_3des_decrypt,
-	.init =3D nitrox_skcipher_init,
+	.decrypt =3D nitrox_cbc_decrypt,
+	.init =3D nitrox_cbc_init,
 	.exit =3D nitrox_skcipher_exit,
 }, {
 	.base =3D {
--=20
2.13.6


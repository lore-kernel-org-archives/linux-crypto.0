Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDC7C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 13:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E8152173C
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 13:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="A0Pzzm+W";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="CIOu1Mm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbfC1NQR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:16:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbfC1NQR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 09:16:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x2SD71k7031944;
        Thu, 28 Mar 2019 06:15:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=oiUYLkPUV36tz6kGw9kyFNxD7UtYrZIVdDZIWEJhPnw=;
 b=A0Pzzm+WuJpkvyeyGC61Itvd1offSdx/WfbIdodP73a8uvdJae1mnymoMehHKISU9kxJ
 hOsaes8VuY/SDIl0pLadjCa259+dMHOdOA4bJXSH5HLBOhtiZwHZ0Z9cGJ9r1T2v2xPa
 k0hvkw6vkdKePYlyJDhcUw/bmMCTKelXJfydOSM5MYxY+muTfLlqMr/cWbzvW2b2jfN2
 yfXVkrv21DJY2vImI6Xg2rDEOQHH+JUoTyVLFELjRmZGWXX0GtbQV+jgB6kcXzjBkx6O
 WH/nRYxAYyloW7+YZ7Vs2YqTSgrFhQjyoW4g+6zUdw7fKOwMFb4WTdLZ2psGSEgbaLti 4w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2rgr9fs9pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Mar 2019 06:15:59 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 28 Mar
 2019 06:15:51 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.52) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 28 Mar 2019 06:15:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiUYLkPUV36tz6kGw9kyFNxD7UtYrZIVdDZIWEJhPnw=;
 b=CIOu1Mm3wXPxIWX1OAwP7371/NPbe1nNc1r4j91tLCqdNq6kRMlx2zm+SRt5+09in2tEgMgseyGfd58Z5NUsknuf4O9iRKf//9DfP1bNCEF7RxsbLrpIvzMyoevR5SY74oenRzAt9buqi1ibRFMu+pusD4gtVWoYj78w9PBZQJc=
Received: from MN2PR18MB2797.namprd18.prod.outlook.com (20.179.22.16) by
 MN2PR18MB2704.namprd18.prod.outlook.com (20.178.255.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.17; Thu, 28 Mar 2019 13:15:49 +0000
Received: from MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::8a3:8874:ca6f:43c7]) by MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::8a3:8874:ca6f:43c7%2]) with mapi id 15.20.1750.017; Thu, 28 Mar 2019
 13:15:49 +0000
From:   Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nagadheeraj Rottela" <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - Added rfc4106(gcm(aes)) cipher
 support
Thread-Topic: [PATCH] crypto: cavium/nitrox - Added rfc4106(gcm(aes)) cipher
 support
Thread-Index: AQHU5WhcKhi9HXmMV0qpMZYuYF+tLg==
Date:   Thu, 28 Mar 2019 13:15:49 +0000
Message-ID: <20190328131529.11896-1-rnagadheeraj@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BM1PR01CA0151.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::21) To MN2PR18MB2797.namprd18.prod.outlook.com
 (2603:10b6:208:a0::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d99cf33-c12c-494f-5cf9-08d6b37f7f0b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:MN2PR18MB2704;
x-ms-traffictypediagnostic: MN2PR18MB2704:
x-microsoft-antispam-prvs: <MN2PR18MB2704B4C5201364EC92504A31D6590@MN2PR18MB2704.namprd18.prod.outlook.com>
x-forefront-prvs: 0990C54589
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(366004)(346002)(396003)(199004)(189003)(6436002)(6506007)(386003)(50226002)(86362001)(6512007)(53946003)(71190400001)(71200400001)(53936002)(14454004)(30864003)(68736007)(305945005)(6116002)(3846002)(55236004)(478600001)(7736002)(8936002)(26005)(186003)(8676002)(14444005)(256004)(2616005)(476003)(102836004)(107886003)(486006)(2906002)(99286004)(52116002)(1076003)(81166006)(81156014)(6486002)(105586002)(97736004)(5660300002)(106356001)(4326008)(25786009)(66066001)(2501003)(316002)(54906003)(110136005)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2704;H:MN2PR18MB2797.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mQOXc4yoLagQeydjzMelx2bAVrJfY+S7jKx3GlqHaX8n/rPOKICl0+O1d31jZt4KVJcu9wU7VJEW1Vtk7HgaHDNRkGU5Gc+7KsGHUrtHAm5DNQ2k+OpJeCiJ9Vjynzm7GcmXMNXzI8hwsmKNzHGc7qFKJ+j9RiVT8QYdhc0LZJEQ3j1nLCuf7vrj327eiAd7TxzG/GAIAnY7hk+mylOLtzha4LPPEATCoYCJDrDrpLT+rm1yWzPrWGIhtl0UYoss0YSwDxDWjtK5zf36iyxWsJpnYUr6iOTGBRf0B/vPm9raJgcYdh9D9RZu7vdYDHEVP1nDtw323leDLWLMDtoVBqft3GNsnMPPlT8gph8cxbkZhrUP3yIsIVGwsyBBw5Ck7Nj9kMzeaaA3WbvQg1dqaOi5cqwyGfXkWBA3QnDH2qg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d99cf33-c12c-494f-5cf9-08d6b37f7f0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2019 13:15:49.6695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2704
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-03-28_07:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added rfc4106(gcm(aes)) cipher.

Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_aead.c | 337 ++++++++++++++++++++++---=
----
 drivers/crypto/cavium/nitrox/nitrox_req.h  |  46 +++-
 2 files changed, 300 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/ca=
vium/nitrox/nitrox_aead.c
index 4f43eacd2557..e4841eb2a09f 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -18,26 +18,6 @@
=20
 #define GCM_AES_SALT_SIZE	4
=20
-/**
- * struct nitrox_crypt_params - Params to set nitrox crypto request.
- * @cryptlen: Encryption/Decryption data length
- * @authlen: Assoc data length + Cryptlen
- * @srclen: Input buffer length
- * @dstlen: Output buffer length
- * @iv: IV data
- * @ivsize: IV data length
- * @ctrl_arg: Identifies the request type (ENCRYPT/DECRYPT)
- */
-struct nitrox_crypt_params {
-	unsigned int cryptlen;
-	unsigned int authlen;
-	unsigned int srclen;
-	unsigned int dstlen;
-	u8 *iv;
-	int ivsize;
-	u8 ctrl_arg;
-};
-
 union gph_p3 {
 	struct {
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -94,36 +74,40 @@ static int nitrox_aead_setauthsize(struct crypto_aead *=
aead,
 	return 0;
 }
=20
-static int alloc_src_sglist(struct aead_request *areq, char *iv, int ivsiz=
e,
+static int alloc_src_sglist(struct nitrox_kcrypt_request *nkreq,
+			    struct scatterlist *src, char *iv, int ivsize,
 			    int buflen)
 {
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-	int nents =3D sg_nents_for_len(areq->src, buflen) + 1;
+	int nents =3D sg_nents_for_len(src, buflen);
 	int ret;
=20
 	if (nents < 0)
 		return nents;
=20
+	/* IV entry */
+	nents +=3D 1;
 	/* Allocate buffer to hold IV and input scatterlist array */
 	ret =3D alloc_src_req_buf(nkreq, nents, ivsize);
 	if (ret)
 		return ret;
=20
 	nitrox_creq_copy_iv(nkreq->src, iv, ivsize);
-	nitrox_creq_set_src_sg(nkreq, nents, ivsize, areq->src, buflen);
+	nitrox_creq_set_src_sg(nkreq, nents, ivsize, src, buflen);
=20
 	return 0;
 }
=20
-static int alloc_dst_sglist(struct aead_request *areq, int ivsize, int buf=
len)
+static int alloc_dst_sglist(struct nitrox_kcrypt_request *nkreq,
+			    struct scatterlist *dst, int ivsize, int buflen)
 {
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-	int nents =3D sg_nents_for_len(areq->dst, buflen) + 3;
+	int nents =3D sg_nents_for_len(dst, buflen);
 	int ret;
=20
 	if (nents < 0)
 		return nents;
=20
+	/* IV, ORH, COMPLETION entries */
+	nents +=3D 3;
 	/* Allocate buffer to hold ORH, COMPLETION and output scatterlist
 	 * array
 	 */
@@ -133,61 +117,54 @@ static int alloc_dst_sglist(struct aead_request *areq=
, int ivsize, int buflen)
=20
 	nitrox_creq_set_orh(nkreq);
 	nitrox_creq_set_comp(nkreq);
-	nitrox_creq_set_dst_sg(nkreq, nents, ivsize, areq->dst, buflen);
+	nitrox_creq_set_dst_sg(nkreq, nents, ivsize, dst, buflen);
=20
 	return 0;
 }
=20
-static void free_src_sglist(struct aead_request *areq)
+static void free_src_sglist(struct nitrox_kcrypt_request *nkreq)
 {
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-
 	kfree(nkreq->src);
 }
=20
-static void free_dst_sglist(struct aead_request *areq)
+static void free_dst_sglist(struct nitrox_kcrypt_request *nkreq)
 {
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-
 	kfree(nkreq->dst);
 }
=20
-static int nitrox_set_creq(struct aead_request *areq,
-			   struct nitrox_crypt_params *params)
+static int nitrox_set_creq(struct nitrox_aead_rctx *rctx)
 {
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-	struct se_crypto_request *creq =3D &nkreq->creq;
-	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	struct se_crypto_request *creq =3D &rctx->nkreq.creq;
 	union gph_p3 param3;
-	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
 	int ret;
=20
-	creq->flags =3D areq->base.flags;
-	creq->gfp =3D (areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		GFP_KERNEL : GFP_ATOMIC;
+	creq->flags =3D rctx->flags;
+	creq->gfp =3D (rctx->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL :
+							       GFP_ATOMIC;
=20
 	creq->ctrl.value =3D 0;
 	creq->opcode =3D FLEXI_CRYPTO_ENCRYPT_HMAC;
-	creq->ctrl.s.arg =3D params->ctrl_arg;
+	creq->ctrl.s.arg =3D rctx->ctrl_arg;
=20
-	creq->gph.param0 =3D cpu_to_be16(params->cryptlen);
-	creq->gph.param1 =3D cpu_to_be16(params->authlen);
-	creq->gph.param2 =3D cpu_to_be16(params->ivsize + areq->assoclen);
+	creq->gph.param0 =3D cpu_to_be16(rctx->cryptlen);
+	creq->gph.param1 =3D cpu_to_be16(rctx->cryptlen + rctx->assoclen);
+	creq->gph.param2 =3D cpu_to_be16(rctx->ivsize + rctx->assoclen);
 	param3.iv_offset =3D 0;
-	param3.auth_offset =3D params->ivsize;
+	param3.auth_offset =3D rctx->ivsize;
 	creq->gph.param3 =3D cpu_to_be16(param3.param);
=20
-	creq->ctx_handle =3D nctx->u.ctx_handle;
+	creq->ctx_handle =3D rctx->ctx_handle;
 	creq->ctrl.s.ctxl =3D sizeof(struct flexi_crypto_context);
=20
-	ret =3D alloc_src_sglist(areq, params->iv, params->ivsize,
-			       params->srclen);
+	ret =3D alloc_src_sglist(&rctx->nkreq, rctx->src, rctx->iv, rctx->ivsize,
+			       rctx->srclen);
 	if (ret)
 		return ret;
=20
-	ret =3D alloc_dst_sglist(areq, params->ivsize, params->dstlen);
+	ret =3D alloc_dst_sglist(&rctx->nkreq, rctx->dst, rctx->ivsize,
+			       rctx->dstlen);
 	if (ret) {
-		free_src_sglist(areq);
+		free_src_sglist(&rctx->nkreq);
 		return ret;
 	}
=20
@@ -197,9 +174,10 @@ static int nitrox_set_creq(struct aead_request *areq,
 static void nitrox_aead_callback(void *arg, int err)
 {
 	struct aead_request *areq =3D arg;
+	struct nitrox_aead_rctx *rctx =3D aead_request_ctx(areq);
=20
-	free_src_sglist(areq);
-	free_dst_sglist(areq);
+	free_src_sglist(&rctx->nkreq);
+	free_dst_sglist(&rctx->nkreq);
 	if (err) {
 		pr_err_ratelimited("request failed status 0x%0x\n", err);
 		err =3D -EINVAL;
@@ -212,23 +190,25 @@ static int nitrox_aes_gcm_enc(struct aead_request *ar=
eq)
 {
 	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
 	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct nitrox_aead_rctx *rctx =3D aead_request_ctx(areq);
+	struct se_crypto_request *creq =3D &rctx->nkreq.creq;
 	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
-	struct nitrox_crypt_params params;
 	int ret;
=20
 	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
=20
-	memset(&params, 0, sizeof(params));
-	params.cryptlen =3D areq->cryptlen;
-	params.authlen =3D areq->assoclen + params.cryptlen;
-	params.srclen =3D params.authlen;
-	params.dstlen =3D params.srclen + aead->authsize;
-	params.iv =3D &areq->iv[GCM_AES_SALT_SIZE];
-	params.ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
-	params.ctrl_arg =3D ENCRYPT;
-	ret =3D nitrox_set_creq(areq, &params);
+	rctx->cryptlen =3D areq->cryptlen;
+	rctx->assoclen =3D areq->assoclen;
+	rctx->srclen =3D areq->assoclen + areq->cryptlen;
+	rctx->dstlen =3D rctx->srclen + aead->authsize;
+	rctx->iv =3D &areq->iv[GCM_AES_SALT_SIZE];
+	rctx->ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
+	rctx->flags =3D areq->base.flags;
+	rctx->ctx_handle =3D nctx->u.ctx_handle;
+	rctx->src =3D areq->src;
+	rctx->dst =3D areq->dst;
+	rctx->ctrl_arg =3D ENCRYPT;
+	ret =3D nitrox_set_creq(rctx);
 	if (ret)
 		return ret;
=20
@@ -241,23 +221,25 @@ static int nitrox_aes_gcm_dec(struct aead_request *ar=
eq)
 {
 	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
 	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
-	struct nitrox_kcrypt_request *nkreq =3D aead_request_ctx(areq);
-	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct nitrox_aead_rctx *rctx =3D aead_request_ctx(areq);
+	struct se_crypto_request *creq =3D &rctx->nkreq.creq;
 	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
-	struct nitrox_crypt_params params;
 	int ret;
=20
 	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
=20
-	memset(&params, 0, sizeof(params));
-	params.cryptlen =3D areq->cryptlen - aead->authsize;
-	params.authlen =3D areq->assoclen + params.cryptlen;
-	params.srclen =3D areq->cryptlen + areq->assoclen;
-	params.dstlen =3D params.srclen - aead->authsize;
-	params.iv =3D &areq->iv[GCM_AES_SALT_SIZE];
-	params.ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
-	params.ctrl_arg =3D DECRYPT;
-	ret =3D nitrox_set_creq(areq, &params);
+	rctx->cryptlen =3D areq->cryptlen - aead->authsize;
+	rctx->assoclen =3D areq->assoclen;
+	rctx->srclen =3D areq->cryptlen + areq->assoclen;
+	rctx->dstlen =3D rctx->srclen - aead->authsize;
+	rctx->iv =3D &areq->iv[GCM_AES_SALT_SIZE];
+	rctx->ivsize =3D GCM_AES_IV_SIZE - GCM_AES_SALT_SIZE;
+	rctx->flags =3D areq->base.flags;
+	rctx->ctx_handle =3D nctx->u.ctx_handle;
+	rctx->src =3D areq->src;
+	rctx->dst =3D areq->dst;
+	rctx->ctrl_arg =3D DECRYPT;
+	ret =3D nitrox_set_creq(rctx);
 	if (ret)
 		return ret;
=20
@@ -290,7 +272,7 @@ static int nitrox_aead_init(struct crypto_aead *aead)
 	return 0;
 }
=20
-static int nitrox_aes_gcm_init(struct crypto_aead *aead)
+static int nitrox_gcm_common_init(struct crypto_aead *aead)
 {
 	int ret;
 	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
@@ -308,8 +290,20 @@ static int nitrox_aes_gcm_init(struct crypto_aead *aea=
d)
 	flags->w0.auth_input_type =3D 1;
 	flags->f =3D be64_to_cpu(flags->f);
=20
-	crypto_aead_set_reqsize(aead, sizeof(struct aead_request) +
-				sizeof(struct nitrox_kcrypt_request));
+	return 0;
+}
+
+static int nitrox_aes_gcm_init(struct crypto_aead *aead)
+{
+	int ret;
+
+	ret =3D nitrox_gcm_common_init(aead);
+	if (ret)
+		return ret;
+
+	crypto_aead_set_reqsize(aead,
+				sizeof(struct aead_request) +
+					sizeof(struct nitrox_aead_rctx));
=20
 	return 0;
 }
@@ -332,6 +326,166 @@ static void nitrox_aead_exit(struct crypto_aead *aead=
)
 	nctx->ndev =3D NULL;
 }
=20
+static int nitrox_rfc4106_setkey(struct crypto_aead *aead, const u8 *key,
+				 unsigned int keylen)
+{
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
+	int ret;
+
+	if (keylen < GCM_AES_SALT_SIZE)
+		return -EINVAL;
+
+	keylen -=3D GCM_AES_SALT_SIZE;
+	ret =3D nitrox_aes_gcm_setkey(aead, key, keylen);
+	if (ret)
+		return ret;
+
+	memcpy(fctx->crypto.iv, key + keylen, GCM_AES_SALT_SIZE);
+	return 0;
+}
+
+static int nitrox_rfc4106_setauthsize(struct crypto_aead *aead,
+				      unsigned int authsize)
+{
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return nitrox_aead_setauthsize(aead, authsize);
+}
+
+static int nitrox_rfc4106_set_aead_rctx_sglist(struct aead_request *areq)
+{
+	struct nitrox_rfc4106_rctx *rctx =3D aead_request_ctx(areq);
+	struct nitrox_aead_rctx *aead_rctx =3D &rctx->base;
+	unsigned int assoclen =3D areq->assoclen - GCM_RFC4106_IV_SIZE;
+	struct scatterlist *sg;
+
+	if (areq->assoclen !=3D 16 && areq->assoclen !=3D 20)
+		return -EINVAL;
+
+	scatterwalk_map_and_copy(rctx->assoc, areq->src, 0, assoclen, 0);
+	sg_init_table(rctx->src, 3);
+	sg_set_buf(rctx->src, rctx->assoc, assoclen);
+	sg =3D scatterwalk_ffwd(rctx->src + 1, areq->src, areq->assoclen);
+	if (sg !=3D rctx->src + 1)
+		sg_chain(rctx->src, 2, sg);
+
+	if (areq->src !=3D areq->dst) {
+		sg_init_table(rctx->dst, 3);
+		sg_set_buf(rctx->dst, rctx->assoc, assoclen);
+		sg =3D scatterwalk_ffwd(rctx->dst + 1, areq->dst, areq->assoclen);
+		if (sg !=3D rctx->dst + 1)
+			sg_chain(rctx->dst, 2, sg);
+	}
+
+	aead_rctx->src =3D rctx->src;
+	aead_rctx->dst =3D (areq->src =3D=3D areq->dst) ? rctx->src : rctx->dst;
+
+	return 0;
+}
+
+static void nitrox_rfc4106_callback(void *arg, int err)
+{
+	struct aead_request *areq =3D arg;
+	struct nitrox_rfc4106_rctx *rctx =3D aead_request_ctx(areq);
+	struct nitrox_kcrypt_request *nkreq =3D &rctx->base.nkreq;
+
+	free_src_sglist(nkreq);
+	free_dst_sglist(nkreq);
+	if (err) {
+		pr_err_ratelimited("request failed status 0x%0x\n", err);
+		err =3D -EINVAL;
+	}
+
+	areq->base.complete(&areq->base, err);
+}
+
+static int nitrox_rfc4106_enc(struct aead_request *areq)
+{
+	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct nitrox_rfc4106_rctx *rctx =3D aead_request_ctx(areq);
+	struct nitrox_aead_rctx *aead_rctx =3D &rctx->base;
+	struct se_crypto_request *creq =3D &aead_rctx->nkreq.creq;
+	int ret;
+
+	aead_rctx->cryptlen =3D areq->cryptlen;
+	aead_rctx->assoclen =3D areq->assoclen - GCM_RFC4106_IV_SIZE;
+	aead_rctx->srclen =3D aead_rctx->assoclen + aead_rctx->cryptlen;
+	aead_rctx->dstlen =3D aead_rctx->srclen + aead->authsize;
+	aead_rctx->iv =3D areq->iv;
+	aead_rctx->ivsize =3D GCM_RFC4106_IV_SIZE;
+	aead_rctx->flags =3D areq->base.flags;
+	aead_rctx->ctx_handle =3D nctx->u.ctx_handle;
+	aead_rctx->ctrl_arg =3D ENCRYPT;
+
+	ret =3D nitrox_rfc4106_set_aead_rctx_sglist(areq);
+	if (ret)
+		return ret;
+
+	ret =3D nitrox_set_creq(aead_rctx);
+	if (ret)
+		return ret;
+
+	/* send the crypto request */
+	return nitrox_process_se_request(nctx->ndev, creq,
+					 nitrox_rfc4106_callback, areq);
+}
+
+static int nitrox_rfc4106_dec(struct aead_request *areq)
+{
+	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
+	struct nitrox_crypto_ctx *nctx =3D crypto_aead_ctx(aead);
+	struct nitrox_rfc4106_rctx *rctx =3D aead_request_ctx(areq);
+	struct nitrox_aead_rctx *aead_rctx =3D &rctx->base;
+	struct se_crypto_request *creq =3D &aead_rctx->nkreq.creq;
+	int ret;
+
+	aead_rctx->cryptlen =3D areq->cryptlen - aead->authsize;
+	aead_rctx->assoclen =3D areq->assoclen - GCM_RFC4106_IV_SIZE;
+	aead_rctx->srclen =3D
+		areq->cryptlen - GCM_RFC4106_IV_SIZE + areq->assoclen;
+	aead_rctx->dstlen =3D aead_rctx->srclen - aead->authsize;
+	aead_rctx->iv =3D areq->iv;
+	aead_rctx->ivsize =3D GCM_RFC4106_IV_SIZE;
+	aead_rctx->flags =3D areq->base.flags;
+	aead_rctx->ctx_handle =3D nctx->u.ctx_handle;
+	aead_rctx->ctrl_arg =3D DECRYPT;
+
+	ret =3D nitrox_rfc4106_set_aead_rctx_sglist(areq);
+	if (ret)
+		return ret;
+
+	ret =3D nitrox_set_creq(aead_rctx);
+	if (ret)
+		return ret;
+
+	/* send the crypto request */
+	return nitrox_process_se_request(nctx->ndev, creq,
+					 nitrox_rfc4106_callback, areq);
+}
+
+static int nitrox_rfc4106_init(struct crypto_aead *aead)
+{
+	int ret;
+
+	ret =3D nitrox_gcm_common_init(aead);
+	if (ret)
+		return ret;
+
+	crypto_aead_set_reqsize(aead, sizeof(struct aead_request) +
+				sizeof(struct nitrox_rfc4106_rctx));
+
+	return 0;
+}
+
 static struct aead_alg nitrox_aeads[] =3D { {
 	.base =3D {
 		.cra_name =3D "gcm(aes)",
@@ -351,6 +505,25 @@ static struct aead_alg nitrox_aeads[] =3D { {
 	.exit =3D nitrox_aead_exit,
 	.ivsize =3D GCM_AES_IV_SIZE,
 	.maxauthsize =3D AES_BLOCK_SIZE,
+}, {
+	.base =3D {
+		.cra_name =3D "rfc4106(gcm(aes))",
+		.cra_driver_name =3D "n5_rfc4106",
+		.cra_priority =3D PRIO,
+		.cra_flags =3D CRYPTO_ALG_ASYNC,
+		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
+		.cra_alignmask =3D 0,
+		.cra_module =3D THIS_MODULE,
+	},
+	.setkey =3D nitrox_rfc4106_setkey,
+	.setauthsize =3D nitrox_rfc4106_setauthsize,
+	.encrypt =3D nitrox_rfc4106_enc,
+	.decrypt =3D nitrox_rfc4106_dec,
+	.init =3D nitrox_rfc4106_init,
+	.exit =3D nitrox_aead_exit,
+	.ivsize =3D GCM_RFC4106_IV_SIZE,
+	.maxauthsize =3D AES_BLOCK_SIZE,
 } };
=20
 int nitrox_register_aeads(void)
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cav=
ium/nitrox/nitrox_req.h
index 76c0f0be7233..efdbd0fc3e3b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -212,6 +212,50 @@ struct nitrox_kcrypt_request {
 };
=20
 /**
+ * struct nitrox_aead_rctx - AEAD request context
+ * @nkreq: Base request context
+ * @cryptlen: Encryption/Decryption data length
+ * @assoclen: AAD length
+ * @srclen: Input buffer length
+ * @dstlen: Output buffer length
+ * @iv: IV data
+ * @ivsize: IV data length
+ * @flags: AEAD req flags
+ * @ctx_handle: Device context handle
+ * @src: Source sglist
+ * @dst: Destination sglist
+ * @ctrl_arg: Identifies the request type (ENCRYPT/DECRYPT)
+ */
+struct nitrox_aead_rctx {
+	struct nitrox_kcrypt_request nkreq;
+	unsigned int cryptlen;
+	unsigned int assoclen;
+	unsigned int srclen;
+	unsigned int dstlen;
+	u8 *iv;
+	int ivsize;
+	u32 flags;
+	u64 ctx_handle;
+	struct scatterlist *src;
+	struct scatterlist *dst;
+	u8 ctrl_arg;
+};
+
+/**
+ * struct nitrox_rfc4106_rctx - rfc4106 cipher request context
+ * @base: AEAD request context
+ * @src: Source sglist
+ * @dst: Destination sglist
+ * @assoc: AAD
+ */
+struct nitrox_rfc4106_rctx {
+	struct nitrox_aead_rctx base;
+	struct scatterlist src[3];
+	struct scatterlist dst[3];
+	u8 assoc[20];
+};
+
+/**
  * struct pkt_instr_hdr - Packet Instruction Header
  * @g: Gather used
  *   When [G] is set and [GSZ] !=3D 0, the instruction is
@@ -512,7 +556,7 @@ static inline struct scatterlist *create_multi_sg(struc=
t scatterlist *to_sg,
 	struct scatterlist *sg =3D to_sg;
 	unsigned int sglen;
=20
-	for (; buflen; buflen -=3D sglen) {
+	for (; buflen && from_sg; buflen -=3D sglen) {
 		sglen =3D from_sg->length;
 		if (sglen > buflen)
 			sglen =3D buflen;
--=20
2.13.6


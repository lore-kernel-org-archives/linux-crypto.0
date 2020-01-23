Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0D8C2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252C024125
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 11:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="Px1i0B0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAWLW3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 06:22:29 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:29664
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726026AbgAWLW3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 06:22:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2eUr+FqdwiFvhjZA5xpyADOhhNHY3E949wIY3wBYR+/shNl9EaukkqBkonwBzV+erjpa4gxmd2V8ewWyHssKEDD5QcqpWtbrroGK1RENPZgB6nYgecjYbg94EpCOVchX+9ya4lncW05+mxJwRMWKjAeKF81/n7/8YGpv/R/3mCTGlW1u2S1lpeA3uODaY5BFMNBDbguLIu9bbtO2+luBQ0jWA4GtFrzzWq1rzvf1nGLJb6J7nBb0WR+9LLFYmxO/1tW3iGFLN6rExck/s9N8lo3LYrHbA1lHzvWIKRQ6YIQhmz7XNrdHohcmr5ruYV/zqvPo9peI36mYDeRjuYc/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkTJsLT1WYmw3N18ti4UtKrohtvlb6CiMMWAANflwWc=;
 b=EOZ7uVh+4QYOXxuMtKS3XhbE91WCC7Vga+0vofKFXsKDkhb4/DyD3UAg52bRLIzEmjPoZEwnZCOIYeZWIzlEl72YltdoFbERlPnWSeN2Vt/vD0qFPpqumef1OvOad26c7OrtYuWLemAtLh1sXbpcD/uh4fmoSO1TwMJ1LxaqAwEXZ+46PkcZZ8Q9zFLotPsOVUD/ZkXeuHu7eJW/GBBbmAZJHVRsAPM+62NafVt5uXc37iD8ziev3FS4G0Bue61HDYzA/Dmuq6kVtM12tpPHBDApXXOdpdCXli4Nfq+E5GaCzCTpaIQZdO4gI006tcu8OxlzSq4K53V7iQKEKu9IiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkTJsLT1WYmw3N18ti4UtKrohtvlb6CiMMWAANflwWc=;
 b=Px1i0B0BBimtpT1VrIkM5AOrXt7uBkWyUMap3L9YgPxYZRV+I9EtuFzZ7ddWeqqlSCP41JkFwMKFbt+DRKm/lXlXvjfS9L77c4ECZ7HxEbMXMJ7WaRP/JfAd/d58PPHJHFXzRA+T/X2BrJW9TfnydfM9sl4fM3qKNfKT2P+DrBo=
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com (52.134.89.85) by
 AM0PR04MB5730.eurprd04.prod.outlook.com (20.178.119.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 23 Jan 2020 11:22:18 +0000
Received: from AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::6105:a475:df04:bfb1]) by AM0PR04MB5089.eurprd04.prod.outlook.com
 ([fe80::6105:a475:df04:bfb1%7]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 11:22:18 +0000
Received: from pankaj-S2600CP.ap.freescale.net (92.120.1.69) by TYAPR01CA0032.jpnprd01.prod.outlook.com (2603:1096:404:28::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Thu, 23 Jan 2020 11:22:14 +0000
From:   Pankaj Gupta <pankaj.gupta@nxp.com>
To:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        Arun Pathak <arun.pathak@nxp.com>
Subject: [PATCH] add support for TLS1.2 algorithms offload
Thread-Topic: [PATCH] add support for TLS1.2 algorithms offload
Thread-Index: AQHV0d9fpUp9vdyUr0ua541zV8eJNw==
Date:   Thu, 23 Jan 2020 11:22:17 +0000
Message-ID: <20200123110413.23064-1-pankaj.gupta@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-originating-ip: [92.120.1.69]
x-clientproxiedby: TYAPR01CA0032.jpnprd01.prod.outlook.com
 (2603:1096:404:28::20) To AM0PR04MB5089.eurprd04.prod.outlook.com
 (2603:10a6:208:c6::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.gupta@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 920a481b-10c9-4599-1735-08d79ff68152
x-ms-traffictypediagnostic: AM0PR04MB5730:|AM0PR04MB5730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB573018F86CB4D577703B4471950F0@AM0PR04MB5730.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(316002)(186003)(16526019)(956004)(2616005)(26005)(110136005)(54906003)(71200400001)(6486002)(52116002)(6506007)(478600001)(86362001)(6512007)(1076003)(2906002)(36756003)(8676002)(81166006)(66946007)(66446008)(66476007)(8936002)(4326008)(44832011)(81156014)(64756008)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5730;H:AM0PR04MB5089.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvHcozoRd6rQ+SGjSOh0V72NPFP/Wy7k6riFyU1iphuXF2mCyxMjmwPyd8mFaE2FwVLca8f2ec6GF32YFvuj0LEKmcVLuuRMkLzkJa+ZcyMW//bxdZOJfYVI3wUL5hW1rXOdLF6feSx8QPY3srm1yfOKHXs53Bw0kgBkCGWndQm43osu7lDo2TzeYzvOt2V8p0NOfVtlBuKtyh7fUMTrnxwOhxcR342HDiNQfbPB5CdREbTRe5Uq8dNVdFFqEoOQhSjgRgXD6iiuH+5qqxmXGt0AVj9d89tzmimvmlcuUWdB93j7SNDdyCVLleQzOMPiY7otReI22ttJvjw1WQRICHgJzz5O6FqBxIzRoJ3ezEXmk/QhLTt0X5ljfAa6WG/YFW1f9EJfWHLgy/m6PreswPFkwl1NAqIoY273AjpjaemY7cI/ZtmqH0HUQ7+16i+m
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920a481b-10c9-4599-1735-08d79ff68152
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 11:22:17.9874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hIjt/FeZcyZ4on/RLlUtCNDWdVvQYAII/tNW77fABRBZoKjy+RYdMarZtKTxNVvqvUihAU46UOdUULJPzhPotA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

        - aes-128-cbc-hmac-sha256
        - aes-256-cbc-hmac-sha256

Enabled the support of TLS1.1 algorithms offload

        - aes-128-cbc-hmac-sha1
        - aes-256-cbc-hmac-sha1

Signed-off-by: Arun Pathak <arun.pathak@nxp.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 47 ++++++++++++++++++++++++++++--
 drivers/crypto/caam/caamalg_desc.h |  5 ++++
 drivers/crypto/caam/caamalg_qi.c   | 33 +++++++++++++++++++--
 drivers/crypto/caam/caamalg_qi2.c  | 34 +++++++++++++++++++--
 4 files changed, 112 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caama=
lg_desc.c
index 0fea15eabf6e..ee9ed9d90530 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -643,6 +643,9 @@ void cnstr_shdsc_tls_encap(u32 * const desc, struct alg=
info *cdata,
 			   unsigned int blocksize, int era)
 {
 	u32 *key_jump_cmd, *zero_payload_jump_cmd;
+#if TLS1_1_SUPPORT
+	u32 *tls10_jump_cmd, *xplicit_iv_jump_cmd;
+#endif
 	u32 genpad, idx_ld_datasz, idx_ld_pad, stidx;
=20
 	/*
@@ -697,15 +700,42 @@ void cnstr_shdsc_tls_encap(u32 * const desc, struct a=
lginfo *cdata,
 	append_operation(desc, cdata->algtype | OP_ALG_AS_INITFINAL |
 			 OP_ALG_ENCRYPT);
=20
+#ifdef TLS1_1_SUPPORT
+	/* skip data to the TLS version field in the Assoclen
+	 * IV + 9 bytes of assoclen =3D 25
+	 */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_SKIP | 25);
+
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_CLASS_DECO |
+		   LDST_SRCDST_WORD_DECO_MATH3 | (6 << LDST_OFFSET_SHIFT) | 2);
+	append_jump(desc, JUMP_TEST_ALL | JUMP_COND_CALM | 1);
+
+	/* rewind input sequence */
+	append_seq_in_ptr(desc, 0, 27, SQIN_RTO);
+#endif
+
+#ifdef TLS1_1_SUPPORT
+	append_math_and_imm_u64(desc, REG1, REG3, IMM, 0xFCFE);
+	xplicit_iv_jump_cmd =3D append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+	append_math_add_imm_u32(desc, REG2, ZERO, IMM, ivsize);
+	set_jump_tgt_here(desc, xplicit_iv_jump_cmd);
+#endif
+
 	/* payloadlen =3D input data length - (assoclen + ivlen) */
 	append_math_sub_imm_u32(desc, REG0, SEQINLEN, IMM, assoclen + ivsize);
-
+#ifdef TLS1_1_SUPPORT
+	append_math_sub(desc, REG0, REG0, REG2, 4);
+#endif
 	/* math1 =3D payloadlen + icvlen */
 	append_math_add_imm_u32(desc, REG1, REG0, IMM, authsize);
+#ifdef TLS1_1_SUPPORT
+	append_math_add(desc, REG1, REG1, REG2, 4);
+#endif
=20
 	/* padlen =3D block_size - math1 % block_size */
-	append_math_and_imm_u32(desc, REG3, REG1, IMM, blocksize - 1);
-	append_math_sub_imm_u32(desc, REG2, IMM, REG3, blocksize);
+	append_math_and_imm_u32(desc, REG2, REG1, IMM, blocksize - 1);
+	append_math_sub_imm_u32(desc, REG2, IMM, REG2, blocksize);
=20
 	/* cryptlen =3D payloadlen + icvlen + padlen */
 	append_math_add(desc, VARSEQOUTLEN, REG1, REG2, 4);
@@ -740,6 +770,17 @@ void cnstr_shdsc_tls_encap(u32 * const desc, struct al=
ginfo *cdata,
 	/* read assoc for authentication */
 	append_seq_fifo_load(desc, assoclen, FIFOLD_CLASS_CLASS2 |
 			     FIFOLD_TYPE_MSG);
+#ifdef TLS1_1_SUPPORT
+	append_math_and_imm_u64(desc, REG2, REG3, IMM, 0xFCFE);
+	tls10_jump_cmd =3D append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+
+	/* read xplicit iv in case of >TL10 */
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
+				     FIFOLD_TYPE_MSG);
+
+	set_jump_tgt_here(desc, tls10_jump_cmd);
+#endif
 	/* insnoop payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | FIFOLD_TYPE_MSG |
 			     FIFOLD_TYPE_LAST2 | FIFOLDST_VLF);
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caama=
lg_desc.h
index 99f0d1471d9c..7b4bfd2d7b96 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -16,9 +16,14 @@
 #define DESC_QI_AEAD_ENC_LEN		(DESC_AEAD_ENC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_DEC_LEN		(DESC_AEAD_DEC_LEN + 3 * CAAM_CMD_SZ)
 #define DESC_QI_AEAD_GIVENC_LEN		(DESC_AEAD_GIVENC_LEN + 3 * CAAM_CMD_SZ)
+#define TLS1_1_SUPPORT			1
=20
 #define DESC_TLS_BASE			(4 * CAAM_CMD_SZ)
+#ifdef TLS1_1_SUPPORT
+#define DESC_TLS10_ENC_LEN		(DESC_TLS_BASE + 45  * CAAM_CMD_SZ)
+#else
 #define DESC_TLS10_ENC_LEN		(DESC_TLS_BASE + 29 * CAAM_CMD_SZ)
+#endif
=20
 /* Note: Nonce is counted in cdata.keylen */
 #define DESC_AEAD_CTR_RFC3686_LEN	(4 * CAAM_CMD_SZ)
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg=
_qi.c
index fceeef155863..29a354ee960e 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -296,8 +296,10 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
 	unsigned int ivsize =3D crypto_aead_ivsize(tls);
 	unsigned int blocksize =3D crypto_aead_blocksize(tls);
 	unsigned int assoclen =3D 13; /* always 13 bytes for TLS */
+#ifndef TLS1_1_SUPPORT
 	unsigned int data_len[2];
 	u32 inl_mask;
+#endif
 	struct caam_drv_private *ctrlpriv =3D dev_get_drvdata(ctx->jrdev->parent)=
;
=20
 	if (!ctx->cdata.keylen || !ctx->authsize)
@@ -308,6 +310,7 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
 	 * Job Descriptor and Shared Descriptor
 	 * must fit into the 64-word Descriptor h/w Buffer
 	 */
+#ifndef TLS1_1_SUPPORT
 	data_len[0] =3D ctx->adata.keylen_pad;
 	data_len[1] =3D ctx->cdata.keylen;
=20
@@ -327,6 +330,12 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
=20
 	ctx->adata.key_inline =3D !!(inl_mask & 1);
 	ctx->cdata.key_inline =3D !!(inl_mask & 2);
+#else
+	ctx->adata.key_dma =3D ctx->key_dma;
+	ctx->cdata.key_dma =3D ctx->key_dma + ctx->adata.keylen_pad;
+	ctx->adata.key_inline =3D false;
+	ctx->cdata.key_inline =3D false;
+#endif
=20
 	cnstr_shdsc_tls_encap(ctx->sh_desc_enc, &ctx->cdata, &ctx->adata,
 			      assoclen, ivsize, ctx->authsize, blocksize,
@@ -2847,8 +2856,8 @@ static struct caam_aead_alg driver_aeads[] =3D {
 	{
 		.aead =3D {
 			.base =3D {
-				.cra_name =3D "tls10(hmac(sha1),cbc(aes))",
-				.cra_driver_name =3D "tls10-hmac-sha1-cbc-aes-caam-qi",
+				.cra_name =3D "tls11(hmac(sha1),cbc(aes))",
+				.cra_driver_name =3D "tls11-hmac-sha1-cbc-aes-caam-qi",
 				.cra_blocksize =3D AES_BLOCK_SIZE,
 			},
 			.setkey =3D tls_setkey,
@@ -2862,6 +2871,26 @@ static struct caam_aead_alg driver_aeads[] =3D {
 			.class1_alg_type =3D OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
 			.class2_alg_type =3D OP_ALG_ALGSEL_SHA1 |
 					   OP_ALG_AAI_HMAC_PRECOMP,
+		},
+	},
+	{
+		.aead =3D {
+			.base =3D {
+				.cra_name =3D "tls12(hmac(sha256),cbc(aes))",
+				.cra_driver_name =3D "tls12-hmac-sha256-cbc-aes-caam-qi",
+				.cra_blocksize =3D AES_BLOCK_SIZE,
+			},
+			.setkey =3D tls_setkey,
+			.setauthsize =3D tls_setauthsize,
+			.encrypt =3D tls_encrypt,
+			.decrypt =3D tls_decrypt,
+			.ivsize =3D AES_BLOCK_SIZE,
+			.maxauthsize =3D SHA256_DIGEST_SIZE,
+		},
+		.caam =3D {
+			.class1_alg_type =3D OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type =3D OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
 		}
 	}
 };
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamal=
g_qi2.c
index 5fd86bac5cf6..46e1bbe14ecf 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -773,8 +773,10 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
 	struct caam_flc *flc;
 	u32 *desc;
 	unsigned int assoclen =3D 13; /* always 13 bytes for TLS */
+#ifndef TLS1_1_SUPPORT
 	unsigned int data_len[2];
 	u32 inl_mask;
+#endif
=20
 	if (!ctx->cdata.keylen || !ctx->authsize)
 		return 0;
@@ -784,6 +786,7 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
 	 * Job Descriptor and Shared Descriptor
 	 * must fit into the 64-word Descriptor h/w Buffer
 	 */
+#ifndef TLS1_1_SUPPORT
 	data_len[0] =3D ctx->adata.keylen_pad;
 	data_len[1] =3D ctx->cdata.keylen;
=20
@@ -803,6 +806,13 @@ static int tls_set_sh_desc(struct crypto_aead *tls)
=20
 	ctx->adata.key_inline =3D !!(inl_mask & 1);
 	ctx->cdata.key_inline =3D !!(inl_mask & 2);
+#else
+	ctx->adata.key_dma =3D ctx->key_dma;
+	ctx->cdata.key_dma =3D ctx->key_dma + ctx->adata.keylen_pad;
+	ctx->adata.key_inline =3D false;
+	ctx->cdata.key_inline =3D false;
+#endif
+
=20
 	flc =3D &ctx->flc[ENCRYPT];
 	desc =3D flc->sh_desc;
@@ -3362,8 +3372,8 @@ static struct caam_aead_alg driver_aeads[] =3D {
 	{
 		.aead =3D {
 			.base =3D {
-				.cra_name =3D "tls10(hmac(sha1),cbc(aes))",
-				.cra_driver_name =3D "tls10-hmac-sha1-cbc-aes-caam-qi2",
+				.cra_name =3D "tls11(hmac(sha1),cbc(aes))",
+				.cra_driver_name =3D "tls11-hmac-sha1-cbc-aes-caam-qi2",
 				.cra_blocksize =3D AES_BLOCK_SIZE,
 			},
 			.setkey =3D tls_setkey,
@@ -3379,6 +3389,26 @@ static struct caam_aead_alg driver_aeads[] =3D {
 					   OP_ALG_AAI_HMAC_PRECOMP,
 		},
 	},
+	{
+		.aead =3D {
+			.base =3D {
+				.cra_name =3D "tls12(hmac(sha256),cbc(aes))",
+				.cra_driver_name =3D "tls12-hmac-sha256-cbc-aes-caam-qi2",
+				.cra_blocksize =3D AES_BLOCK_SIZE,
+			},
+			.setkey =3D tls_setkey,
+			.setauthsize =3D tls_setauthsize,
+			.encrypt =3D tls_encrypt,
+			.decrypt =3D tls_decrypt,
+			.ivsize =3D AES_BLOCK_SIZE,
+			.maxauthsize =3D SHA256_DIGEST_SIZE,
+		},
+		.caam =3D {
+			.class1_alg_type =3D OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type =3D OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+		},
+	},
 };
=20
 static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
--=20
2.17.1


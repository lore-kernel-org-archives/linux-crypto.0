Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5953C41517
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 833AA206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="NkiCsyxM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfG3QF2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:05:28 -0400
Received: from mail-eopbgr720073.outbound.protection.outlook.com ([40.107.72.73]:26016
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbfG3QF1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:05:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jup43totAxDZPK3lm6G1DrL5kwS2h4M3z7v5uvAqyq0UdJ3zRxY7dzUC2qSJJB9VwYeOlWb6s+pTaTSNvdlMnv1tWgTf0AWywazFcS03+qfyKD2547GBBsCcYPSbWLYpXZ90f7kcFUBXdSbFlsnq3BKFJanqkhlDUU9Y82krcJy1dsdltoe7K+kCrXGYQlFUdfBoO7xFFgEqxM8kvb2+qqN6M1yJCnX6sCAzINz3y/5n93i7DNA92h4GaytbCQ9sLymofuLBmkpwevSbt/XHi8nUP18zz3NqU8EDnEoU6npytX4jgf/zeQVQMKjCYtzf96zpEzSpeiErBYC0JqJ2Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XegdmQfaulYTsIvWuPKQFw4Tvb/5MsEtOcOymYukjfo=;
 b=BtS8847cP9yCfjw/L4UX0SvKG94GvTbjf14AtcHse+jXUtMQAZiDrqrzhtiAgq+VxfWtYDLsHYqenrUEQ7o/2E7zvN2kFr2WzKkywOvtUdsAhd4D7YmExwC0vpHs/GLPjHzgvt2unRlboGjwAbdbCyxgAaWRiJD+d7Xw4xNirzzMdSi8lZh9n6OzA3Wc0/lzHGgTPvC+finyuofGZr7+8m2y0KiMLws7NHvqataqXUmiIAP79Hm9IsC9t5N+K0DG/knKVCOPYQAFBi/FhoAUGiBuzNSEXgZoENFF2Ow4ohKx+ApmlU1cscoQiQ/GP+FuYDAgD0dmnjzt1wab17amSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XegdmQfaulYTsIvWuPKQFw4Tvb/5MsEtOcOymYukjfo=;
 b=NkiCsyxMThwboGWXuk4BwmQapszNXOGQkq8sPDQz8PIS66J85kvTbrpKJ8HhKw2dCIrL4NpjOxrz0eB/2mGu9yvlJTEiAEp0G89Hn0FhgHl5MW/bcS2whbCSEk0dcNMUxOmR90ZJ+FmU0TrP6Enr71s0BX/r2HjmOgwmyplW0do=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1292.namprd12.prod.outlook.com (10.168.236.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 16:05:24 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:05:24 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 2/3] crypto: ccp - Add support for valid authsize values less
 than 16
Thread-Topic: [PATCH 2/3] crypto: ccp - Add support for valid authsize values
 less than 16
Thread-Index: AQHVRvCYzhdDTqQjgUaoCcQeHw3uLg==
Date:   Tue, 30 Jul 2019 16:05:24 +0000
Message-ID: <20190730160454.7617-3-gary.hook@amd.com>
References: <20190730160454.7617-1-gary.hook@amd.com>
In-Reply-To: <20190730160454.7617-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:802:20::40) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cc06fca-b96f-403e-1411-08d71507bb25
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1292;
x-ms-traffictypediagnostic: DM5PR12MB1292:
x-microsoft-antispam-prvs: <DM5PR12MB1292EDE74D02E72FC482906AFDDC0@DM5PR12MB1292.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(199004)(189003)(2501003)(14444005)(76176011)(26005)(386003)(8936002)(50226002)(1076003)(2906002)(478600001)(66066001)(6506007)(71200400001)(256004)(486006)(3846002)(186003)(6916009)(81156014)(81166006)(68736007)(71190400001)(476003)(102836004)(11346002)(14454004)(8676002)(52116002)(86362001)(99286004)(2616005)(6116002)(7736002)(6512007)(53936002)(54906003)(66556008)(66476007)(64756008)(66446008)(2351001)(66946007)(36756003)(6436002)(5640700003)(6486002)(446003)(5660300002)(316002)(4326008)(25786009)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1292;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vab46gDNv9QO33qtDpaDAnO+FCW2uAZXKfVVCpzJcrKQQe3dZUUZEfqC98mqN6yDw60fKAfk4S+jUmMVtPcm/Fr3Uq/mFW/VxmBbBc2qo06Md/pPZkpkHdgGT3Z1Sf9noxhad1odtjQjNaUVcYkck2kO1HNu/okf5Qck1euNjEGlI1FC/LIl8F5ph046g9bfGl//yTrhgV0uV/d90N66dBlfqR115GBj7Cl4AVHQSse84WxMflsZ5zvrEpCDc2raPCy25w4EsLV324O+//Y4/zMb7FrKSOPuysckyhgoKm/XRMGHeWZpAVVgzNSX2xc1/8aL+DlP+ienEsDRuel0TT9uXTmLsI69zKs3EyvGwGxBbiBwXkoMYTIoaKGwCmrpiGMPd03PYJti5EWTbNb8HcLMGeW0lixDWUftqLUQ5BA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <1948E2C1C48B9E4793A32EF0D3079884@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc06fca-b96f-403e-1411-08d71507bb25
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:05:24.7670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1292
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

AES GCM encryption allows for authsize values of 4, 8, and 12-16 bytes.
Validate the requested authsize, and retain it to save in the request
context.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs"=
)

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c | 14 ++++++++++++
 drivers/crypto/ccp/ccp-ops.c               | 26 +++++++++++++++++-----
 include/linux/ccp.h                        |  2 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/cc=
p/ccp-crypto-aes-galois.c
index f9fec2ddf56a..94c1ad7eeddf 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -58,6 +58,19 @@ static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, c=
onst u8 *key,
 static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 				   unsigned int authsize)
 {
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
=20
@@ -104,6 +117,7 @@ static int ccp_aes_gcm_crypt(struct aead_request *req, =
bool encrypt)
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
 	INIT_LIST_HEAD(&rctx->cmd.entry);
 	rctx->cmd.engine =3D CCP_ENGINE_AES;
+	rctx->cmd.u.aes.authsize =3D crypto_aead_authsize(tfm);
 	rctx->cmd.u.aes.type =3D ctx->u.aes.type;
 	rctx->cmd.u.aes.mode =3D ctx->u.aes.mode;
 	rctx->cmd.u.aes.action =3D encrypt;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 35b6b3397d49..553d8aa4f18d 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -621,6 +621,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct=
 ccp_cmd *cmd)
=20
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int authsize;
 	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place =3D true; /* Default value */
@@ -642,6 +643,21 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struc=
t ccp_cmd *cmd)
 	if (!aes->key) /* Gotta have a key SGL */
 		return -EINVAL;
=20
+	/* Zero defaults to 16 bytes, the maximum size */
+	authsize =3D aes->authsize ? aes->authsize : AES_BLOCK_SIZE;
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* First, decompose the source buffer into AAD & PT,
 	 * and the destination buffer into AAD, CT & tag, or
 	 * the input into CT & tag.
@@ -656,7 +672,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct=
 ccp_cmd *cmd)
 		p_tag =3D scatterwalk_ffwd(sg_tag, p_outp, ilen);
 	} else {
 		/* Input length for decryption includes tag */
-		ilen =3D aes->src_len - AES_BLOCK_SIZE;
+		ilen =3D aes->src_len - authsize;
 		p_tag =3D scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
=20
@@ -838,19 +854,19 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, stru=
ct ccp_cmd *cmd)
=20
 	if (aes->action =3D=3D CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
-		ccp_get_dm_area(&final_wa, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ccp_get_dm_area(&final_wa, 0, p_tag, 0, authsize);
 	} else {
 		/* Does this ciphered tag match the input? */
-		ret =3D ccp_init_dm_workarea(&tag, cmd_q, AES_BLOCK_SIZE,
+		ret =3D ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_tag;
-		ret =3D ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ret =3D ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
 		if (ret)
 			goto e_tag;
=20
 		ret =3D crypto_memneq(tag.address, final_wa.address,
-				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
+				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
=20
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 55cb455cfcb0..a5dfbaf2470d 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -170,6 +170,8 @@ struct ccp_aes_engine {
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
=20
+	u32 authsize;
+
 	struct scatterlist *key;
 	u32 key_len;		/* In bytes */
=20
--=20
2.17.1


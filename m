Return-Path: <SRS0=68iz=XL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC83C49ED7
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 06:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AEB20830
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Sep 2019 06:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SVJPC0TU";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="is7tAoCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbfIPGmS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Sep 2019 02:42:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33872 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727834AbfIPGmS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Sep 2019 02:42:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8G6e35J004542;
        Sun, 15 Sep 2019 23:42:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=MablhYp5PuH6rCC5l2bRz8jFMCBYQlhUyRfKU99DKSA=;
 b=SVJPC0TUKvzrIYQgi4zU5D+mzgGzPR0AvVhkQtZCnutT1ZIAq0/khdtOLsxBC5kKeWt1
 PL8Nx2YDSkEPkYJPuPBMzLBYDnJkjviwUuuX3k0TVGqGndMimUhC4UcYjD8YpKWsJlqE
 yZb008S+MqYq9faCa6a0gPTCXG1XkvQyG150C34V34pJoz2bVhzNqNPbflcAI2iY5KVz
 BU4Qe/C1ooNk+jfGhnKuI8Ng4okvN53QMdhAlxmAYA+O2ncl5T1r0UDhBBMHgsMkqNin
 ADpeInE11siJT3nik2Ad5XbocaMAWpUFZLApb6q0OIA0O/YYejO6hBDk/hwfH6U2/RAc Lw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2v0wjpdxtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Sep 2019 23:42:09 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 15 Sep
 2019 23:42:08 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 15 Sep 2019 23:42:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gk/ridjdKXuQx76anwJW6RkpPJuW8qo6L5O97+hBibX7UWMyOpJ+qHja8fUmaK8LWpK/letpTLN7Im6hjYQ5X5XqTOA3nLAH5bWQ8CpO1z/ddNRNWxSD8RKaog4iYR6JMU7UHJI2gVH0r/upz2wDdhvNKttkBCZOnlMGkVTrhetH+ypm5Yg6sP1zScNwo4llqJKrNbQTpTOOAmO0ER0MnJeS293oAb/Mwyl6GblOxGt29Kjnf/ZtVAPumCiLIrHAE186FJlvjUCysMIJmZ8O+mQVU7OgjZHi+DuCc7vWwQabvY4lUIHZyux0Lwc8jL+SEmZkGmyQqDCies6qPAtMLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MablhYp5PuH6rCC5l2bRz8jFMCBYQlhUyRfKU99DKSA=;
 b=FUUKmWjfcaWrO2xOfJ6ijidcF8ZcsKxogh17arv+CfvhfrFO3SyLx7bm+C8jVILbxkCKzy2mfiNeYlQJ92zSf+8kqNU18QWs4rRy/B9TbY4g6AHGh9x0HTQ5DqUWkg4V9TLyPJ6z7HNLuzPxBoaAEaK6SAlhm+fStFAi/X+dYA5ik6gma0vKqe3HuPJ5DiZMyY+mjaOaRnBB3q166eHCV8W7UXWCkFy2aIdnMheMkUPTIHvKkDK4Q8jQZ97z88QISiEwrH7i9OaRLzpSTwnpqRO7VXPEc+rkf7YWE62eOoWF8ULD1HRexyzHIA9dML8DbAkW3Xa27rAFIl0+DTr3Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MablhYp5PuH6rCC5l2bRz8jFMCBYQlhUyRfKU99DKSA=;
 b=is7tAoCN3uNVtCdbGeowLgv1EpRwZbAZCFkLIIhOBGQhBKaeNuZ0JfL3hlQiWyiLmDpESJvm0lHVVAweSWmYyMxQ+DEBfhoWW6phDLhw+k7pLldDAEOHmjKS+fXVbCXOUtRzlQM2ABFZjKcZn+3MIhc6WgZYxZDfY2SlEYC8erM=
Received: from MN2PR18MB2797.namprd18.prod.outlook.com (20.179.22.16) by
 MN2PR18MB2463.namprd18.prod.outlook.com (20.179.82.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Mon, 16 Sep 2019 06:42:06 +0000
Received: from MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9]) by MN2PR18MB2797.namprd18.prod.outlook.com
 ([fe80::2010:7134:bdcf:8ad9%7]) with mapi id 15.20.2263.023; Mon, 16 Sep 2019
 06:42:06 +0000
From:   Nagadheeraj Rottela <rnagadheeraj@marvell.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Srikanth Jampala <jsrikanth@marvell.com>,
        "mallesham.jatharakonda@oneconvergence.com" 
        <mallesham.jatharakonda@oneconvergence.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Subject: [PATCH] crypto: cavium/nitrox - check assoclen and authsize for
 gcm(aes) cipher
Thread-Topic: [PATCH] crypto: cavium/nitrox - check assoclen and authsize for
 gcm(aes) cipher
Thread-Index: AQHVbFnb5xrH1mh3qkyAKa/fZPRbHg==
Date:   Mon, 16 Sep 2019 06:42:06 +0000
Message-ID: <20190916064140.24387-1-rnagadheeraj@marvell.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0083.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:1::23) To MN2PR18MB2797.namprd18.prod.outlook.com
 (2603:10b6:208:a0::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.13.6
x-originating-ip: [115.113.156.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16ae3615-9d5e-4991-32b1-08d73a70fdca
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR18MB2463;
x-ms-traffictypediagnostic: MN2PR18MB2463:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB24630D7FC72C6C44380DE38DD68C0@MN2PR18MB2463.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:191;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(366004)(376002)(346002)(136003)(396003)(189003)(199004)(478600001)(50226002)(6436002)(14454004)(25786009)(2501003)(99286004)(4326008)(5660300002)(71200400001)(71190400001)(64756008)(66556008)(7736002)(66476007)(66946007)(305945005)(36756003)(2906002)(256004)(14444005)(53936002)(6512007)(6116002)(3846002)(66446008)(26005)(102836004)(476003)(110136005)(486006)(54906003)(86362001)(386003)(6506007)(6486002)(2616005)(8936002)(186003)(107886003)(52116002)(316002)(55236004)(81166006)(81156014)(8676002)(66066001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2463;H:MN2PR18MB2797.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sMnf+6xVvTMSfOUduH3g9y8JL98VA5r1PVUoJw3cmXonUZJlU3zA8yWb9FRbAiS/1DN8B2y8lm5nTQJ0YZSzp4lUgV2Pe8TPK+zbpytKyVrX65Hfswk/DPL1alMP4tye5aSggGtVRJrPHUzZkL2y59n9OpNJhcYya+tx8oQKMj33Tjg51X9Q3SzIMe9QFmlLvWvBOEloWiPmBPqhdoYjcpZsdH3M8UivK1I56ap/FWEFwMEzlofcHRJxurgyRys7oJWY6Pn2fjTf5NbPjJlKsUAWhT5xilbjzF7iKJSN7oFCO9IZjLxo7bSOdWaZEvDPsjF5LXrddj7SIij5PEhNaaFBKXmoJ5+MkrlshJ8bUO0xIghgS5PXnGihSaGo2h3DtX33INrqhfP8LRrkW5EHQy05Y+Q4j2/kkhRgVPZxsFg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ae3615-9d5e-4991-32b1-08d73a70fdca
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 06:42:06.6218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sv96li4joIcD8n/CIo7JSY8aIWAEBL3yRKGQCNWbkq9712l3fTJlTivwCNduJNh8/w1dU4eHravWSDjmYd04jLnDOwhd+KWB6YSoi2VoL1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2463
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-16_03:2019-09-11,2019-09-16 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check if device supports assoclen to solve hung task timeout error when
extra tests are enabled. Return -EINVAL if assoclen is not supported.
Check authsize to return -EINVAL if authentication tag size is invalid.
Change blocksize to 1 to match with generic implementation.

Signed-off-by: Nagadheeraj Rottela <rnagadheeraj@marvell.com>
Reported-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence.=
com>
Suggested-by: Mallesham Jatharakonda <mallesham.jatharakonda@oneconvergence=
.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
---
 drivers/crypto/cavium/nitrox/nitrox_aead.c | 39 ++++++++++++++++++++++++++=
+---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_aead.c b/drivers/crypto/ca=
vium/nitrox/nitrox_aead.c
index e4841eb2a09f..6f80cc3b5c84 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_aead.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_aead.c
@@ -74,6 +74,25 @@ static int nitrox_aead_setauthsize(struct crypto_aead *a=
ead,
 	return 0;
 }
=20
+static int nitrox_aes_gcm_setauthsize(struct crypto_aead *aead,
+				      unsigned int authsize)
+{
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return nitrox_aead_setauthsize(aead, authsize);
+}
+
 static int alloc_src_sglist(struct nitrox_kcrypt_request *nkreq,
 			    struct scatterlist *src, char *iv, int ivsize,
 			    int buflen)
@@ -186,6 +205,14 @@ static void nitrox_aead_callback(void *arg, int err)
 	areq->base.complete(&areq->base, err);
 }
=20
+static inline bool nitrox_aes_gcm_assoclen_supported(unsigned int assoclen=
)
+{
+	if (assoclen <=3D 512)
+		return true;
+
+	return false;
+}
+
 static int nitrox_aes_gcm_enc(struct aead_request *areq)
 {
 	struct crypto_aead *aead =3D crypto_aead_reqtfm(areq);
@@ -195,6 +222,9 @@ static int nitrox_aes_gcm_enc(struct aead_request *areq=
)
 	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
 	int ret;
=20
+	if (!nitrox_aes_gcm_assoclen_supported(areq->assoclen))
+		return -EINVAL;
+
 	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
=20
 	rctx->cryptlen =3D areq->cryptlen;
@@ -226,6 +256,9 @@ static int nitrox_aes_gcm_dec(struct aead_request *areq=
)
 	struct flexi_crypto_context *fctx =3D nctx->u.fctx;
 	int ret;
=20
+	if (!nitrox_aes_gcm_assoclen_supported(areq->assoclen))
+		return -EINVAL;
+
 	memcpy(fctx->crypto.iv, areq->iv, GCM_AES_SALT_SIZE);
=20
 	rctx->cryptlen =3D areq->cryptlen - aead->authsize;
@@ -492,13 +525,13 @@ static struct aead_alg nitrox_aeads[] =3D { {
 		.cra_driver_name =3D "n5_aes_gcm",
 		.cra_priority =3D PRIO,
 		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_blocksize =3D 1,
 		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask =3D 0,
 		.cra_module =3D THIS_MODULE,
 	},
 	.setkey =3D nitrox_aes_gcm_setkey,
-	.setauthsize =3D nitrox_aead_setauthsize,
+	.setauthsize =3D nitrox_aes_gcm_setauthsize,
 	.encrypt =3D nitrox_aes_gcm_enc,
 	.decrypt =3D nitrox_aes_gcm_dec,
 	.init =3D nitrox_aes_gcm_init,
@@ -511,7 +544,7 @@ static struct aead_alg nitrox_aeads[] =3D { {
 		.cra_driver_name =3D "n5_rfc4106",
 		.cra_priority =3D PRIO,
 		.cra_flags =3D CRYPTO_ALG_ASYNC,
-		.cra_blocksize =3D AES_BLOCK_SIZE,
+		.cra_blocksize =3D 1,
 		.cra_ctxsize =3D sizeof(struct nitrox_crypto_ctx),
 		.cra_alignmask =3D 0,
 		.cra_module =3D THIS_MODULE,
--=20
2.13.6


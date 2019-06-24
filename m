Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3E6C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB0420645
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="CgPqvZB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfFXTHo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:07:44 -0400
Received: from mail-eopbgr690081.outbound.protection.outlook.com ([40.107.69.81]:24681
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfFXTHo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJyxUKkzrAIJ4gEGZ3SSbpbp416kpHzkjoVRdvVp2ME=;
 b=CgPqvZB+7Tk9vWErPSnzCSf2fOOAPbMhyYKGIL9vfdowPExj0RZycidFTyF+xMfksvkGXIS+di6BCyEg5Ybdk+xo+mdnna14yK1s0uWc4Z5GzS/5XiOvZ2KKgjItgMV/Viwkj9oBzFHgMcquGuIcXY1t3kkw4oXvmnW+7SGLYCg=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2584.namprd12.prod.outlook.com (52.132.141.167) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 19:07:42 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.014; Mon, 24 Jun
 2019 19:07:42 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 1/3] crypto: doc - Add parameter documentation
Thread-Topic: [PATCH 1/3] crypto: doc - Add parameter documentation
Thread-Index: AQHVKsAZ2iu41GA1mUC92fRE2Scqqw==
Date:   Mon, 24 Jun 2019 19:07:42 +0000
Message-ID: <156140326035.29777.7460831085991852791.stgit@taos>
References: <156140322426.29777.8610751479936722967.stgit@taos>
In-Reply-To: <156140322426.29777.8610751479936722967.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0051.namprd05.prod.outlook.com
 (2603:10b6:803:41::28) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87702f17-bbc5-43e2-863d-08d6f8d73b76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB2584;
x-ms-traffictypediagnostic: DM5PR12MB2584:
x-microsoft-antispam-prvs: <DM5PR12MB258431C121CE6ED64C6EB789FDE00@DM5PR12MB2584.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(136003)(366004)(39860400002)(396003)(346002)(199004)(189003)(99286004)(6436002)(25786009)(76176011)(52116002)(72206003)(33716001)(9686003)(6512007)(14444005)(256004)(68736007)(110136005)(6116002)(3846002)(446003)(476003)(11346002)(316002)(2906002)(26005)(186003)(102836004)(6486002)(386003)(14454004)(5660300002)(486006)(81156014)(86362001)(103116003)(305945005)(81166006)(478600001)(8676002)(66946007)(73956011)(8936002)(66066001)(66446008)(64756008)(66556008)(66476007)(2501003)(71190400001)(71200400001)(6506007)(53936002)(7736002)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2584;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IJfZ3Gv8tbFmiw08mirh2Uukbyl5CK76BsD9lrzEno8dysZEhe6mutHm+ZtpCeJJOEaChHDuBkCKT0OjKTTIlJv0FS1VTTfb4SiVE0G2hiXoMSBsY7iQTc+/jvNOOCfZmBwAJrtN72qMRk63iXjhZYxp/z/oAqqB6oAshhf0ylx3iMp9Lv38/+3v3lypjrarl7UjTWBYPIKzRJD4hDC4YViiG+8n5WCZCI7wMGMJJ6q8/haD0x9plLS/PezcgFUUeeivqBFCkgC6ahjh1oIQCVSC2hiFzVp6EJIRcKomK0tWQU+xl8+KLy/HrfTTIO9POp3QzChCBzOlDMQoLYDj5kCsk1G+XJu+IT/ohWcM+9VbAguWuK1X4lJ7cSnjXySNjg54dcZ0XUnFw6kf4z5/qP4t+9hfDWhVqDhD6+KVqxs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A77FBD29D268F94BA9C39A58A20F79B3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87702f17-bbc5-43e2-863d-08d6f8d73b76
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 19:07:42.1696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2584
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fill in missing parameter descriptions for the ompression algorithm,
then pick them up to document for the compression_alg structure.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 Documentation/crypto/api-skcipher.rst |    2 +-
 include/linux/crypto.h                |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/a=
pi-skcipher.rst
index 4eec4a93f7e3..20ba08dddf2e 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -5,7 +5,7 @@ Block Cipher Algorithm Definitions
    :doc: Block Cipher Algorithm Definitions
=20
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_alg ablkcipher_alg blkcipher_alg cipher_alg
+   :functions: crypto_alg ablkcipher_alg blkcipher_alg cipher_alg compress=
_alg
=20
 Symmetric Key Cipher API
 ------------------------
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 311237b1dab0..4b4e2ffbee74 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -327,6 +327,17 @@ struct cipher_alg {
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
=20
+/**
+ * struct compress_alg - compression/decompression algorithm
+ * @coa_compress: Compress a buffer of specified length, storing the resul=
ting
+ *		  data in the specified buffer. Return the length of the
+ *		  compressed data in dlen.
+ * @coa_decompress: Decompress the source buffer, storing the uncompressed
+ *		    data in the specified buffer. The length of the data is
+ *		    returned in dlen.
+ *
+ * All fields are mandatory.
+ */
 struct compress_alg {
 	int (*coa_compress)(struct crypto_tfm *tfm, const u8 *src,
 			    unsigned int slen, u8 *dst, unsigned int *dlen);


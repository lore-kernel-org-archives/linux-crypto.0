Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D095C48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504232086D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="aPE/iVXd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFYXnw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 19:43:52 -0400
Received: from mail-eopbgr740051.outbound.protection.outlook.com ([40.107.74.51]:63229
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFYXnw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 19:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1bfo1tuysgyO1BWqK21xLEqYauPT0CVzqbJBaSJuwA=;
 b=aPE/iVXdF+PEr87lPwybmb65b1RF8P53wpnlmQaVPED11l+VZudjBkKFRJ+agb28hr8PerKQQw+tRhd0JXhD/B6n9O5TKVPr+wGw+mIKPuXXzUeKckRaa63S42lcFJENJPxBLUFnknXBUEBd/pix5K1mKuoGYrGlQ6CzZ7orOHI=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1818.namprd12.prod.outlook.com (10.175.92.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 23:43:43 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 23:43:43 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 1/2] crypto: doc - Add parameter documentation
Thread-Topic: [PATCH v2 1/2] crypto: doc - Add parameter documentation
Thread-Index: AQHVK6/TtBc78DoRxkWkPP9GS6ugrw==
Date:   Tue, 25 Jun 2019 23:43:43 +0000
Message-ID: <156150622212.22527.13529785176241852561.stgit@taos>
References: <156150616764.22527.16524544899486041609.stgit@taos>
In-Reply-To: <156150616764.22527.16524544899486041609.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:805:a2::42) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a39d06f-eaa1-48d2-590c-08d6f9c6f550
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1818;
x-ms-traffictypediagnostic: DM5PR12MB1818:
x-microsoft-antispam-prvs: <DM5PR12MB181862EDD3E68E79D9624C07FDE30@DM5PR12MB1818.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(136003)(39860400002)(366004)(396003)(346002)(199004)(189003)(25786009)(99286004)(33716001)(81166006)(2201001)(81156014)(5660300002)(8936002)(53936002)(7736002)(66066001)(9686003)(6116002)(6512007)(3846002)(6486002)(305945005)(8676002)(6436002)(2501003)(66946007)(256004)(73956011)(478600001)(14454004)(68736007)(2906002)(316002)(64756008)(102836004)(386003)(6506007)(72206003)(66476007)(186003)(76176011)(71200400001)(52116002)(103116003)(476003)(11346002)(71190400001)(446003)(110136005)(14444005)(486006)(66556008)(66446008)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1818;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q863JaevK7qCRAQqqMIevsU4GFl9/m9U1DM84sCVVZyR3jcorLLMrqcg9DaX3gOIh6OB/fSjPcFedOMFHq4qYFacqQbE8NARwYX7CrpTWyWwJT0KhBV/kVqQHjc82nTfg3qrleHRpd3yHnyp8ij183ggHIYxYO1n4hw1+XAFh9tMeem7GSzOzbu2arF1H04Ngbnh3geWcZfdRF5O7z6IPAxHV2IfTS9BGDJiQ2CvlKQtK6GCapLQm55Tcm+1lzQNJQfGAD1MO0jg11JwOXF1MTfBG/HJiEZat2A8daccCxWser0beHsuRbkjBw2679tSbagzlNRlWiwSH00HiWdhgUZpHA8/lbcWDFsnCDpyZwF1xvlUlgqXIMdNeBCITXKkEDYJsBMny4NMEAwR4RLMVdzIxt+aXCuHozYO3fMvtN4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8B1B1F8CD343D4A8AF5D10449412300@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a39d06f-eaa1-48d2-590c-08d6f9c6f550
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 23:43:43.6900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1818
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fill in missing parameter descriptions for the compression algorithm,
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


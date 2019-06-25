Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3481BC48BD6
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC58B2086D
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 23:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="08Pac+YN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfFYXn7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 19:43:59 -0400
Received: from mail-eopbgr740049.outbound.protection.outlook.com ([40.107.74.49]:62880
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFYXn6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 19:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8Sxf+kFNcnxLM0pVY3/p0ey4q9dRRgmdKvZXWVcfuU=;
 b=08Pac+YNf0Wngrt9IRU3q1Eey51OMRuFAy3kxyhvUAw3JzOxqeb5jR9EAu4nmIAAGkVih11lt8eQE368qmGSn/W7aDWDL4DhoZSH1l5qPu8Q+JmUNs3uuzZpNZvhXGqBgizXYx5kTGBxH4rtFmUsS+RTYUtmp1pb4+0GHPEf90w=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1818.namprd12.prod.outlook.com (10.175.92.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 23:43:50 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.017; Tue, 25 Jun
 2019 23:43:50 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 2/2] crypto: doc - Fix formatting of new crypto engine
 content
Thread-Topic: [PATCH v2 2/2] crypto: doc - Fix formatting of new crypto engine
 content
Thread-Index: AQHVK6/XqR/ma8kUnUmph7llIf8q0w==
Date:   Tue, 25 Jun 2019 23:43:50 +0000
Message-ID: <156150622886.22527.934327975584441429.stgit@taos>
References: <156150616764.22527.16524544899486041609.stgit@taos>
In-Reply-To: <156150616764.22527.16524544899486041609.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:805:a2::22) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19fa43bf-4574-4bd2-3374-08d6f9c6f967
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1818;
x-ms-traffictypediagnostic: DM5PR12MB1818:
x-microsoft-antispam-prvs: <DM5PR12MB1818578977793058139AA1B5FDE30@DM5PR12MB1818.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(376002)(136003)(39860400002)(366004)(396003)(346002)(199004)(189003)(25786009)(99286004)(33716001)(81166006)(2201001)(81156014)(5660300002)(8936002)(53936002)(7736002)(66066001)(9686003)(6116002)(6512007)(3846002)(6486002)(305945005)(8676002)(6436002)(2501003)(66946007)(256004)(73956011)(478600001)(14454004)(68736007)(2906002)(316002)(64756008)(102836004)(386003)(6506007)(72206003)(66476007)(186003)(76176011)(71200400001)(52116002)(103116003)(476003)(11346002)(71190400001)(446003)(110136005)(14444005)(486006)(66556008)(66446008)(26005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1818;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8p0zxaYpcwm/14Ld5ZXD6IHhuBGh85QEUBZIk0RDnpP+Sz3SNQbdrRdN6uUyQdbMxjxmIIMY+0dejuSSHtXeTqlnqTJTT73CvhPEZzf2GTXvG1Cfx+FbPo130L0pot2268koWPcTYb7lqGPItGryZty6v6xj24iF35tamChS+aboHfE/tUydVjeeQxSyYqBmYtuQ51nC8fNDYx/N6011bIlotk4fV0KF7Bwz0zz0V2noH568LQZ1dRyjI0ZDbl75kOh6ebQ3QF1C9mkbpsADDoOaIjmuLgmiJfN2Jhwk3i4p+kkf9ObbcbL5mSWig9EgI1ZpCIQqifogashj4IWP80nH93bM7maXtNGcKbfc84YyvS2GeskSCRBGa9sCpf779cCzyLD2hIbdh/j1z51OuV17xv5pCd/VEIL9ljanNPc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27FEE38C9D454746B445E0556EBF0334@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fa43bf-4574-4bd2-3374-08d6f9c6f967
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 23:43:50.5327
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

Tidy up the formatting/grammar in crypto_engine.rst. Use bulleted lists
where appropriate.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 Documentation/crypto/crypto_engine.rst |  111 +++++++++++++++++++++-------=
----
 1 file changed, 73 insertions(+), 38 deletions(-)

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/=
crypto_engine.rst
index 1d56221dfe35..236c674d6897 100644
--- a/Documentation/crypto/crypto_engine.rst
+++ b/Documentation/crypto/crypto_engine.rst
@@ -1,50 +1,85 @@
-=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
-CRYPTO ENGINE
+.. SPDX-License-Identifier: GPL-2.0
+Crypto Engine
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 Overview
 --------
-The crypto engine API (CE), is a crypto queue manager.
+The crypto engine (CE) API is a crypto queue manager.
=20
 Requirement
 -----------
-You have to put at start of your tfm_ctx the struct crypto_engine_ctx::
+You must put, at the start of your transform context your_tfm_ctx, the str=
ucture
+crypto_engine:
+
+::
=20
-  struct your_tfm_ctx {
-        struct crypto_engine_ctx enginectx;
-        ...
-  };
+	struct your_tfm_ctx {
+		struct crypto_engine engine;
+		...
+	};
=20
-Why: Since CE manage only crypto_async_request, it cannot know the underly=
ing
-request_type and so have access only on the TFM.
-So using container_of for accessing __ctx is impossible.
-Furthermore, the crypto engine cannot know the "struct your_tfm_ctx",
-so it must assume that crypto_engine_ctx is at start of it.
+The crypto engine only manages asynchronous requests in the form of
+crypto_async_request. It cannot know the underlying request type and thus =
only
+has access to the transform structure. It is not possible to access the co=
ntext
+using container_of. In addition, the engine knows nothing about your
+structure "``struct your_tfm_ctx``". The engine assumes (requires) the pla=
cement
+of the known member ``struct crypto_engine`` at the beginning.
=20
 Order of operations
 -------------------
-You have to obtain a struct crypto_engine via crypto_engine_alloc_init().
-And start it via crypto_engine_start().
-
-Before transferring any request, you have to fill the enginectx.
-- prepare_request: (taking a function pointer) If you need to do some proc=
essing before doing the request
-- unprepare_request: (taking a function pointer) Undoing what's done in pr=
epare_request
-- do_one_request: (taking a function pointer) Do encryption for current re=
quest
-
-Note: that those three functions get the crypto_async_request associated w=
ith the received request.
-So your need to get the original request via container_of(areq, struct you=
rrequesttype_request, base);
-
-When your driver receive a crypto_request, you have to transfer it to
-the cryptoengine via one of:
-- crypto_transfer_ablkcipher_request_to_engine()
-- crypto_transfer_aead_request_to_engine()
-- crypto_transfer_akcipher_request_to_engine()
-- crypto_transfer_hash_request_to_engine()
-- crypto_transfer_skcipher_request_to_engine()
-
-At the end of the request process, a call to one of the following function=
 is needed:
-- crypto_finalize_ablkcipher_request
-- crypto_finalize_aead_request
-- crypto_finalize_akcipher_request
-- crypto_finalize_hash_request
-- crypto_finalize_skcipher_request
+You are required to obtain a struct crypto_engine via ``crypto_engine_allo=
c_init()``.
+Start it via ``crypto_engine_start()``. When finished with your work, shut=
 down the
+engine using ``crypto_engine_stop()`` and destroy the engine with
+``crypto_engine_exit()``.
+
+Before transferring any request, you have to fill the context enginectx by
+providing functions for the following:
+
+* ``prepare_crypt_hardware``: Called once before any prepare functions are
+  called.
+
+* ``unprepare_crypt_hardware``: Called once after all unprepare functions =
have
+  been called.
+
+* ``prepare_cipher_request``/``prepare_hash_request``: Called before each
+  corresponding request is performed. If some processing or other preparat=
ory
+  work is required, do it here.
+
+* ``unprepare_cipher_request``/``unprepare_hash_request``: Called after ea=
ch
+  request is handled. Clean up / undo what was done in the prepare functio=
n.
+
+* ``cipher_one_request``/``hash_one_request``: Handle the current request =
by
+  performing the operation.
+
+Note that these functions access the crypto_async_request structure
+associated with the received request. You are able to retrieve the origina=
l
+request by using:
+
+::
+
+	container_of(areq, struct yourrequesttype_request, base);
+
+When your driver receives a crypto_request, you must to transfer it to
+the crypto engine via one of:
+
+* crypto_transfer_ablkcipher_request_to_engine()
+
+* crypto_transfer_aead_request_to_engine()
+
+* crypto_transfer_akcipher_request_to_engine()
+
+* crypto_transfer_hash_request_to_engine()
+
+* crypto_transfer_skcipher_request_to_engine()
+
+At the end of the request process, a call to one of the following function=
s is needed:
+
+* crypto_finalize_ablkcipher_request()
+
+* crypto_finalize_aead_request()
+
+* crypto_finalize_akcipher_request()
+
+* crypto_finalize_hash_request()
+
+* crypto_finalize_skcipher_request()


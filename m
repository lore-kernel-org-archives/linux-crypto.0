Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DCAC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64BD320659
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 16:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="N0jATTMi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0QQ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:16:27 -0400
Received: from mail-eopbgr780041.outbound.protection.outlook.com ([40.107.78.41]:47123
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726440AbfF0QQ0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 12:16:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=jEMqwD/8+zjcIvZEfu13udOjnYXfGYWERz1fS0hCZGrTR/E+SpKg8/wH0Cr5OOZY40SDcLAZjS0KWY6PCYEBW494WEZZKHyKtuWEGvImUWwRC6Ee26sUD4ni6fX/iv+pIGC7hOvxNvRQvW8TSCJycjRLtWjShB66hmhArGU7jnQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd1f7veJABXvb4vB/eqWZrmGt0xB+yuwtr+cEL3V5L0=;
 b=Ss/FOjqpFUPkWgkQEiIR/s5oGzroDo7REmTlyhjXILP6021MG6/2BKRUL458eOEhvOd+yLWs0JeaLKpdhvqaB18eKp6wecaGxwIyQVIdQbhJ8cl7KfdrHpHLz6reA2pGAbRHTkc36is0nWbQ9ow2w8eswyPRYh/fA7x+nxkG0vM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd1f7veJABXvb4vB/eqWZrmGt0xB+yuwtr+cEL3V5L0=;
 b=N0jATTMiqXc3GRwnkqwqHN94AJzuZC3skod3EAxe2VWqM84egMkVjzCgAp3HzqRYPfd8P7f3oNSGbX4nAp+jtQGUbtS7h9PE/Fpblquo0+bA1cTTs3LMcAgcYvuRBDJgUaOq0pmUF7NAxLHdn0ixrSFBvREejdezmp1u/WUTq7U=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1579.namprd12.prod.outlook.com (10.172.38.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 16:16:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::180c:ff0c:37e6:a482%10]) with mapi id 15.20.2008.018; Thu, 27 Jun
 2019 16:16:23 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2] crypto: ccp - Validate the the error value used to index
 error messages
Thread-Topic: [PATCH v2] crypto: ccp - Validate the the error value used to
 index error messages
Thread-Index: AQHVLQOpSS4EJmTHHUCFR7szkyjnzA==
Date:   Thu, 27 Jun 2019 16:16:23 +0000
Message-ID: <156165202737.28135.12079221811780949916.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0501CA0073.namprd05.prod.outlook.com
 (2603:10b6:803:22::11) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91081ea6-2f83-4188-c84a-08d6fb1acc13
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1579;
x-ms-traffictypediagnostic: DM5PR12MB1579:
x-microsoft-antispam-prvs: <DM5PR12MB1579E7498771D77B904EB77DFDFD0@DM5PR12MB1579.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39860400002)(396003)(346002)(136003)(376002)(366004)(199004)(189003)(8676002)(66066001)(6506007)(386003)(6116002)(478600001)(2501003)(7736002)(5660300002)(6436002)(26005)(6916009)(102836004)(71200400001)(3846002)(71190400001)(6486002)(81166006)(8936002)(305945005)(68736007)(5640700003)(81156014)(316002)(15650500001)(53936002)(66446008)(103116003)(14454004)(73956011)(2906002)(66946007)(64756008)(66556008)(66476007)(486006)(33716001)(186003)(6512007)(52116002)(9686003)(86362001)(4326008)(476003)(14444005)(256004)(72206003)(99286004)(2351001)(25786009)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1579;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p/RFUAyL03J4nwfRmeF64Rj7qDgVOcS/OId1ZNnotU+rNzGuSpRFsrfWwnXqnWvs4KvoT4bNEU9eBycE2mgGVHUBGtaMK+TqH4mvA8wRR87KGLvtffKJf5RrvrT0vpKUtRw+sGU5NZnz1g50TwxZt1oru3SuOHEBe7EeGcP4QqDc+tivDboYFSepyob4IJfpOczN4VAj4DVbcMw4ic0NyebMFN8k8dd+ouvIYbeqo3DkD5fyrqDvl8rEr7H/tOLzMyWAgg3imDrrcJxAHE6Xi1y0VXLs0i+iTL9N1x+VM5aG9XMK3Ondf8dgncVNZCfiU7Ml21//x5INO1Z7FDlJavrHxz6LtjKOWe8FBWAxe3bBo9ewyyix4HkOy9YQWqErOj/4s8/sIiWtt+Ish4RLJjZbs5ljB6Bu10m3xfRhJBM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A561843AE09D5D47A622387F4E446207@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91081ea6-2f83-4188-c84a-08d6fb1acc13
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 16:16:23.5417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1579
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The error code read from the queue status register is only 6 bits wide,
but we need to verify its value is within range before indexing the error
messages.

Fixes: 81422badb3907 ("crypto: ccp - Make syslog errors human-readable")

Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
---

Changes since v1:
 - change parameter type to unsigned int and remove a check

 drivers/crypto/ccp/ccp-dev.c |   96 ++++++++++++++++++++++----------------=
----
 drivers/crypto/ccp/ccp-dev.h |    2 -
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 1b5035d56288..9b6d8972a565 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -35,56 +35,62 @@ struct ccp_tasklet_data {
 };
=20
 /* Human-readable error strings */
+#define CCP_MAX_ERROR_CODE	64
 static char *ccp_error_codes[] =3D {
 	"",
-	"ERR 01: ILLEGAL_ENGINE",
-	"ERR 02: ILLEGAL_KEY_ID",
-	"ERR 03: ILLEGAL_FUNCTION_TYPE",
-	"ERR 04: ILLEGAL_FUNCTION_MODE",
-	"ERR 05: ILLEGAL_FUNCTION_ENCRYPT",
-	"ERR 06: ILLEGAL_FUNCTION_SIZE",
-	"ERR 07: Zlib_MISSING_INIT_EOM",
-	"ERR 08: ILLEGAL_FUNCTION_RSVD",
-	"ERR 09: ILLEGAL_BUFFER_LENGTH",
-	"ERR 10: VLSB_FAULT",
-	"ERR 11: ILLEGAL_MEM_ADDR",
-	"ERR 12: ILLEGAL_MEM_SEL",
-	"ERR 13: ILLEGAL_CONTEXT_ID",
-	"ERR 14: ILLEGAL_KEY_ADDR",
-	"ERR 15: 0xF Reserved",
-	"ERR 16: Zlib_ILLEGAL_MULTI_QUEUE",
-	"ERR 17: Zlib_ILLEGAL_JOBID_CHANGE",
-	"ERR 18: CMD_TIMEOUT",
-	"ERR 19: IDMA0_AXI_SLVERR",
-	"ERR 20: IDMA0_AXI_DECERR",
-	"ERR 21: 0x15 Reserved",
-	"ERR 22: IDMA1_AXI_SLAVE_FAULT",
-	"ERR 23: IDMA1_AIXI_DECERR",
-	"ERR 24: 0x18 Reserved",
-	"ERR 25: ZLIBVHB_AXI_SLVERR",
-	"ERR 26: ZLIBVHB_AXI_DECERR",
-	"ERR 27: 0x1B Reserved",
-	"ERR 27: ZLIB_UNEXPECTED_EOM",
-	"ERR 27: ZLIB_EXTRA_DATA",
-	"ERR 30: ZLIB_BTYPE",
-	"ERR 31: ZLIB_UNDEFINED_SYMBOL",
-	"ERR 32: ZLIB_UNDEFINED_DISTANCE_S",
-	"ERR 33: ZLIB_CODE_LENGTH_SYMBOL",
-	"ERR 34: ZLIB _VHB_ILLEGAL_FETCH",
-	"ERR 35: ZLIB_UNCOMPRESSED_LEN",
-	"ERR 36: ZLIB_LIMIT_REACHED",
-	"ERR 37: ZLIB_CHECKSUM_MISMATCH0",
-	"ERR 38: ODMA0_AXI_SLVERR",
-	"ERR 39: ODMA0_AXI_DECERR",
-	"ERR 40: 0x28 Reserved",
-	"ERR 41: ODMA1_AXI_SLVERR",
-	"ERR 42: ODMA1_AXI_DECERR",
-	"ERR 43: LSB_PARITY_ERR",
+	"ILLEGAL_ENGINE",
+	"ILLEGAL_KEY_ID",
+	"ILLEGAL_FUNCTION_TYPE",
+	"ILLEGAL_FUNCTION_MODE",
+	"ILLEGAL_FUNCTION_ENCRYPT",
+	"ILLEGAL_FUNCTION_SIZE",
+	"Zlib_MISSING_INIT_EOM",
+	"ILLEGAL_FUNCTION_RSVD",
+	"ILLEGAL_BUFFER_LENGTH",
+	"VLSB_FAULT",
+	"ILLEGAL_MEM_ADDR",
+	"ILLEGAL_MEM_SEL",
+	"ILLEGAL_CONTEXT_ID",
+	"ILLEGAL_KEY_ADDR",
+	"0xF Reserved",
+	"Zlib_ILLEGAL_MULTI_QUEUE",
+	"Zlib_ILLEGAL_JOBID_CHANGE",
+	"CMD_TIMEOUT",
+	"IDMA0_AXI_SLVERR",
+	"IDMA0_AXI_DECERR",
+	"0x15 Reserved",
+	"IDMA1_AXI_SLAVE_FAULT",
+	"IDMA1_AIXI_DECERR",
+	"0x18 Reserved",
+	"ZLIBVHB_AXI_SLVERR",
+	"ZLIBVHB_AXI_DECERR",
+	"0x1B Reserved",
+	"ZLIB_UNEXPECTED_EOM",
+	"ZLIB_EXTRA_DATA",
+	"ZLIB_BTYPE",
+	"ZLIB_UNDEFINED_SYMBOL",
+	"ZLIB_UNDEFINED_DISTANCE_S",
+	"ZLIB_CODE_LENGTH_SYMBOL",
+	"ZLIB _VHB_ILLEGAL_FETCH",
+	"ZLIB_UNCOMPRESSED_LEN",
+	"ZLIB_LIMIT_REACHED",
+	"ZLIB_CHECKSUM_MISMATCH0",
+	"ODMA0_AXI_SLVERR",
+	"ODMA0_AXI_DECERR",
+	"0x28 Reserved",
+	"ODMA1_AXI_SLVERR",
+	"ODMA1_AXI_DECERR",
 };
=20
-void ccp_log_error(struct ccp_device *d, int e)
+void ccp_log_error(struct ccp_device *d, unsigned int e)
 {
-	dev_err(d->dev, "CCP error: %s (0x%x)\n", ccp_error_codes[e], e);
+	if (WARN_ON(e >=3D CCP_MAX_ERROR_CODE))
+		return;
+
+	if (e < ARRAY_SIZE(ccp_error_codes))
+		dev_err(d->dev, "CCP error %d: %s\n", e, ccp_error_codes[e]);
+	else
+		dev_err(d->dev, "CCP error %d: Unknown Error\n", e);
 }
=20
 /* List of CCPs, CCP count, read-write access lock, and access functions
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 6810b65c1939..7442b0422f8a 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -632,7 +632,7 @@ struct ccp5_desc {
 void ccp_add_device(struct ccp_device *ccp);
 void ccp_del_device(struct ccp_device *ccp);
=20
-extern void ccp_log_error(struct ccp_device *, int);
+extern void ccp_log_error(struct ccp_device *, unsigned int);
=20
 struct ccp_device *ccp_alloc_struct(struct sp_device *sp);
 bool ccp_queues_suspended(struct ccp_device *ccp);


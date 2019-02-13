Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E4CC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 19:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2DE20835
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 19:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="hWN6uqa+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfBMTXy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 14:23:54 -0500
Received: from mail-eopbgr780058.outbound.protection.outlook.com ([40.107.78.58]:54868
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729533AbfBMTXx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 14:23:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVuIpIA641YdfIyHKaK4IPoYyno4b1rce4HCEPJY1vo=;
 b=hWN6uqa+9SsmZlmw9DoTyJMxsy6Ub/D5lSKS/Ro5PoyTB58XelJ6ZzqSskH7qD8+rOwv39JbRvLolhyvPzf0vgZW9kIdZWlptf5tLDcA4UqXces+tV9CSsE7mj5mOIM41vJ9a/MS4i7ZC6raSdG9IzgB7h/Y7sA5Zy93saDf5xI=
Received: from BN7PR12MB2673.namprd12.prod.outlook.com (20.176.176.91) by
 BN7PR12MB2836.namprd12.prod.outlook.com (20.176.178.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Wed, 13 Feb 2019 19:23:44 +0000
Received: from BN7PR12MB2673.namprd12.prod.outlook.com
 ([fe80::82a:5427:9aeb:49a5]) by BN7PR12MB2673.namprd12.prod.outlook.com
 ([fe80::82a:5427:9aeb:49a5%3]) with mapi id 15.20.1601.023; Wed, 13 Feb 2019
 19:23:44 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Topic: [PATCH] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Index: AQHUw9Gi5mJPt5RuVE6hmwMqm1xhOQ==
Date:   Wed, 13 Feb 2019 19:23:43 +0000
Message-ID: <20190213192329.680-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0017.namprd15.prod.outlook.com
 (2603:10b6:805:16::30) To BN7PR12MB2673.namprd12.prod.outlook.com
 (2603:10b6:408:29::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ede939f7-5426-42a3-36ef-08d691e8c4a3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:BN7PR12MB2836;
x-ms-traffictypediagnostic: BN7PR12MB2836:
x-ms-exchange-purlcount: 2
x-microsoft-exchange-diagnostics: 1;BN7PR12MB2836;20:wNc9z6N7BZ/y/p/sR/HqIXorqTzL0rV+em9xxEIdQUGDYromGWCiDBoSOPrAJB63YRpcje4whdD5fy67Gu8oOD1PQAisUKPisQ+lFjnlLywLjMqBrAFcQH6RSskyvEw/XgYoeVEzZ2a/BE9Hu9mmcoobX/F9LuZ3DmzaNb/sZa2cCRr/PJ/t4zdVgCOzYJiUgJQ3d+31IyLX+DuggBWNQpJnV/EFIr8tdQ8KNTRM99jSEJhSWg3cOs2e3cw6ADv4
x-microsoft-antispam-prvs: <BN7PR12MB28364CE71E3FD724929E43F8E5660@BN7PR12MB2836.namprd12.prod.outlook.com>
x-forefront-prvs: 094700CA91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(376002)(346002)(39860400002)(189003)(199004)(53936002)(305945005)(6486002)(7736002)(8676002)(81156014)(71190400001)(316002)(66066001)(81166006)(478600001)(386003)(14444005)(8936002)(256004)(52116002)(966005)(14454004)(97736004)(86362001)(71200400001)(54906003)(102836004)(1076003)(3846002)(25786009)(6116002)(105586002)(2906002)(26005)(99286004)(106356001)(486006)(6506007)(36756003)(6306002)(2616005)(5640700003)(476003)(4326008)(6512007)(6436002)(50226002)(2351001)(186003)(2501003)(68736007)(6916009)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR12MB2836;H:BN7PR12MB2673.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IOUrw/liKdnL0Z6BiQxdtvt/vDsQGcliWMAMxZgSgTyH2fIQKx1tfLnOB2wW1nlMZmZ0RJu5+ICVWGEBR0tke5f3FnIOl3eGy0dXUKqhgbMEIiTjmfmRLlEdqzNEQ34nZN0pJKFLoJ3+JrwK2PxZ/58y4CnvxKiUVUqm7MXNrD1oT+ppiE6CtWCCPlMG30pYaYUqbFZERyVCUPNtUd3Z6IvmMIVqMmFZetoZmUpcRrRi9nBkEUHauom17CKF+QT39Jh1e90a2YlvknfRLKXer2dbaObAv1M4XJ39+/z5b4to5nPhTnvyeVce9BXmcjyb8PNSyAPoZfX3kn+70qq7Mz+Q+67vGmP+xjvbbxjacIWr87LQCVXAes/zvQR8nK3AL4+EcG46UiwUef1CFn/EZh6SFYvamC0ul67+0Tgc2DQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ede939f7-5426-42a3-36ef-08d691e8c4a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2019 19:23:42.5486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2836
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current definition and implementation of the SEV_GET_ID command
does not provide the length of the unique ID returned by the firmware.
As per the firmware specification, the firmware may return an ID
length that is not restricted to 64 bytes as assumed by the SEV_GET_ID
command.

Introduce the SEV_GET_ID2 command to allow for querying and returing
the length of the ID. Deprecate the SEV_GET_ID in the favor of
SEV_GET_ID2.

Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 65 +++++++++++++++++++++++++-----------
 include/uapi/linux/psp-sev.h | 18 +++++++---
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b16be8a11d92..b510900a9a83 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -584,40 +584,63 @@ static int sev_ioctl_do_pek_import(struct sev_issue_c=
md *argp)
=20
 static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 {
+	struct sev_user_data_get_id2 input;
 	struct sev_data_get_id *data;
-	u64 data_size, user_size;
-	void *id_blob, *mem;
+	void *id_blob =3D NULL;
 	int ret;
=20
-	/* SEV GET_ID available from SEV API v0.16 and up */
+	/* SEV GET_ID is available from SEV API v0.16 and up */
 	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
 		return -ENOTSUPP;
=20
-	/* SEV FW expects the buffer it fills with the ID to be
-	 * 8-byte aligned. Memory allocated should be enough to
-	 * hold data structure + alignment padding + memory
-	 * where SEV FW writes the ID.
-	 */
-	data_size =3D ALIGN(sizeof(struct sev_data_get_id), 8);
-	user_size =3D sizeof(struct sev_user_data_get_id);
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
=20
-	mem =3D kzalloc(data_size + user_size, GFP_KERNEL);
-	if (!mem)
+	/* Check if we have write access to the userspace buffer */
+	if (input.address &&
+	    input.length &&
+	    !access_ok(input.address, input.length))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
 		return -ENOMEM;
=20
-	data =3D mem;
-	id_blob =3D mem + data_size;
+	if (input.address && input.length) {
+		id_blob =3D kmalloc(input.length, GFP_KERNEL);
+		if (!id_blob) {
+			kfree(data);
+			return -ENOMEM;
+		}
=20
-	data->address =3D __psp_pa(id_blob);
-	data->len =3D user_size;
+		data->address =3D __psp_pa(id_blob);
+		data->len =3D input.length;
+	}
=20
 	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
-	if (!ret) {
-		if (copy_to_user((void __user *)argp->data, id_blob, data->len))
+
+	/*
+	 * Firmware will return the length of the ID value (either the minimum
+	 * required length or the actual length written), return it to the user.
+	 */
+	input.length =3D data->len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret =3D -EFAULT;
+		goto e_free;
+	}
+
+	if (id_blob) {
+		if (copy_to_user((void __user *)input.address,
+				 id_blob, data->len)) {
 			ret =3D -EFAULT;
+			goto e_free;
+		}
 	}
=20
-	kfree(mem);
+e_free:
+	kfree(id_blob);
+	kfree(data);
=20
 	return ret;
 }
@@ -760,6 +783,10 @@ static long sev_ioctl(struct file *file, unsigned int =
ioctl, unsigned long arg)
 		ret =3D sev_ioctl_do_pdh_export(&input);
 		break;
 	case SEV_GET_ID:
+		/* SEV_GET_ID is deprecated */
+		ret =3D -ENOTSUPP;
+		break;
+	case SEV_GET_ID2:
 		ret =3D sev_ioctl_do_get_id(&input);
 		break;
 	default:
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index ac8c60bcc83b..43521d500c2b 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -6,8 +6,7 @@
  *
  * Author: Brijesh Singh <brijesh.singh@amd.com>
  *
- * SEV spec 0.14 is available at:
- * http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
+ * SEV API specification is available at: https://developer.amd.com/sev/
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -30,7 +29,8 @@ enum {
 	SEV_PDH_GEN,
 	SEV_PDH_CERT_EXPORT,
 	SEV_PEK_CERT_IMPORT,
-	SEV_GET_ID,
+	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
+	SEV_GET_ID2,
=20
 	SEV_MAX,
 };
@@ -125,7 +125,7 @@ struct sev_user_data_pdh_cert_export {
 } __packed;
=20
 /**
- * struct sev_user_data_get_id - GET_ID command parameters
+ * struct sev_user_data_get_id - GET_ID command parameters (deprecated)
  *
  * @socket1: Buffer to pass unique ID of first socket
  * @socket2: Buffer to pass unique ID of second socket
@@ -135,6 +135,16 @@ struct sev_user_data_get_id {
 	__u8 socket2[64];			/* Out */
 } __packed;
=20
+/**
+ * struct sev_user_data_get_id2 - GET_ID command parameters
+ * @address: Buffer to store unique ID
+ * @length: length of the unique ID
+ */
+struct sev_user_data_get_id2 {
+	__u64 address;				/* In */
+	__u32 length;				/* In/Out */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
--=20
2.17.1


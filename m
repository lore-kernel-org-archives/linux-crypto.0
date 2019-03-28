Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE730C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 21:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D8D2075E
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 21:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="1Qdrx5Nr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfC1V6z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:58:55 -0400
Received: from mail-eopbgr730080.outbound.protection.outlook.com ([40.107.73.80]:50688
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbfC1V6z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 17:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLQRvjim5e5wEb8aFcSNfQ56YrWj+heqx7pDw2lyPmE=;
 b=1Qdrx5NrgVna8sK71m9YL220LT4hzPSPQxl/VUbOoappioshMhM3G6Zc8RNjKgAhI2igyJaVF66UTXwo+oQY8B2h+zz7NTMGjPOU97x93KPeH68vSJGSUZClt8OAiKs4pnVsFq1Pozgpr6OxRbW8dbvEmBjs4nVs67RKpkgzbRM=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB2987.namprd12.prod.outlook.com (20.178.29.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1750.15; Thu, 28 Mar 2019 21:58:52 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::4dd7:e79:1607:b755]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::4dd7:e79:1607:b755%5]) with mapi id 15.20.1730.019; Thu, 28 Mar 2019
 21:58:52 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Subject: [PATCH v2] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Topic: [PATCH v2] crypto: ccp: introduce SEV_GET_ID2 command
Thread-Index: AQHU5bFu8u3oefqwgkSU/l/q4ry6LA==
Date:   Thu, 28 Mar 2019 21:58:52 +0000
Message-ID: <20190328215838.23082-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0060.namprd12.prod.outlook.com
 (2603:10b6:802:20::31) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39284d7f-00a6-4664-4d81-08d6b3c890b5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR12MB2987;
x-ms-traffictypediagnostic: DM6PR12MB2987:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <DM6PR12MB29870047586D5C391AECC73FE5590@DM6PR12MB2987.namprd12.prod.outlook.com>
x-forefront-prvs: 0990C54589
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(346002)(39860400002)(189003)(199004)(25786009)(71190400001)(71200400001)(478600001)(54906003)(6506007)(4326008)(966005)(14454004)(316002)(36756003)(386003)(97736004)(2616005)(486006)(26005)(186003)(66066001)(102836004)(476003)(305945005)(6306002)(53936002)(2501003)(99286004)(14444005)(2906002)(5640700003)(52116002)(6116002)(3846002)(6512007)(1076003)(50226002)(6436002)(86362001)(256004)(5660300002)(81156014)(81166006)(6486002)(8936002)(2351001)(105586002)(8676002)(6916009)(68736007)(106356001)(7736002)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2987;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s6lnRm8b1bJsnBXp+LeMpfG7FblGooDbAOtmNa+JsIAuWH9+r2sLgCFEDBPAGouU+JrFeo23znOPG7fYpvPy/0rYtqfoHeNYDJI0wBPzwxpRyF3+s/igvuAt/DOVktKt6trLpaWwLWCUs8hqFR+HeZGCFptWgviXGDo1pzZbHlPABMBTGUnt1mukUoUNBhfhvQVQUZvo4ariPe6sIb5Wpe6Wg7XioLeLVrRnOk17rTmGWjuN6WCD4q7E1Bpj+h9jhkMJ8Hq486rRiT+zZutejgGsZ/NGZ7SvxfD/QT1Qca4k/Nl0Ef6rcRELQLb5F7VktGDygIgEpgMeRsCkmGp7epAP22itfixRNYGnKwdC18sWatOli4ltYzhUrS0uwH6LC9zvNaIz3S+KZhMuBMnaKhoQBEWN66koQVqCGPTT6kQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39284d7f-00a6-4664-4d81-08d6b3c890b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2019 21:58:52.5628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2987
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current definition and implementation of the SEV_GET_ID command
does not provide the length of the unique ID returned by the firmware.
As per the firmware specification, the firmware may return an ID
length that is not restricted to 64 bytes as assumed by the SEV_GET_ID
command.

Introduce the SEV_GET_ID2 command to overcome with the SEV_GET_ID
limitations. Deprecate the SEV_GET_ID in the favor of SEV_GET_ID2.

At the same time update SEV API web link.

Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Nathaniel McCallum <npmccallum@redhat.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
Change since v1:
  - Keep the SEV_GET_ID implement and log the deprecated message

 drivers/crypto/ccp/psp-dev.c | 67 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      |  3 +-
 include/uapi/linux/psp-sev.h | 18 +++++++---
 3 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index fadf859a14b8..80a59be9c80d 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -583,6 +583,69 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cm=
d *argp)
 	return ret;
 }
=20
+static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_get_id2 input;
+	struct sev_data_get_id *data;
+	void *id_blob =3D NULL;
+	int ret;
+
+	/* SEV GET_ID is available from SEV API v0.16 and up */
+	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
+		return -ENOTSUPP;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	/* Check if we have write access to the userspace buffer */
+	if (input.address &&
+	    input.length &&
+	    !access_ok(input.address, input.length))
+		return -EFAULT;
+
+	data =3D kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (input.address && input.length) {
+		id_blob =3D kmalloc(input.length, GFP_KERNEL);
+		if (!id_blob) {
+			kfree(data);
+			return -ENOMEM;
+		}
+
+		data->address =3D __psp_pa(id_blob);
+		data->len =3D input.length;
+	}
+
+	ret =3D __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
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
+			ret =3D -EFAULT;
+			goto e_free;
+		}
+	}
+
+e_free:
+	kfree(id_blob);
+	kfree(data);
+
+	return ret;
+}
+
 static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 {
 	struct sev_data_get_id *data;
@@ -761,8 +824,12 @@ static long sev_ioctl(struct file *file, unsigned int =
ioctl, unsigned long arg)
 		ret =3D sev_ioctl_do_pdh_export(&input);
 		break;
 	case SEV_GET_ID:
+		pr_warn_once("SEV_GET_ID command is deprecated, use SEV_GET_ID2\n");
 		ret =3D sev_ioctl_do_get_id(&input);
 		break;
+	case SEV_GET_ID2:
+		ret =3D sev_ioctl_do_get_id2(&input);
+		break;
 	default:
 		ret =3D -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 827c601841c4..6f89fc8d4b8e 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -5,8 +5,7 @@
  *
  * Author: Brijesh Singh <brijesh.singh@amd.com>
  *
- * SEV spec 0.14 is available at:
- * http://support.amd.com/TechDocs/55766_SEV-KM API_Specification.pdf
+ * SEV API spec is available at https://developer.amd.com/sev
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
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


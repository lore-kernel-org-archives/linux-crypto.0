Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D9DCA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1339F20679
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="LpFCX84p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfJUNor (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:44:47 -0400
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:3335
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728479AbfJUNor (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 09:44:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+zvmVxvMtOZ8dEb7keyAYCd0b++qqKhDZlWOD2r3844Q4i5CxEonaUM01+kXcIhb1LJfSzPiNZmf+HsJAOx1+L/urYRXXclXhCFbD0Z6IC3yUWKg1wRH3lTGKpUF5lXRyElrhG6qTMfPo9lQGDkeQFutJ1j7/jI/1FrMzlaThY7y1qVnc3LqpCoUJbU3mBQ7cani3QZC8AKEL526qb6eGBF9Y8WSxnZwvK/my/GB/g4/l2/cdohTKL4IVKlDN/0FhTdRiVnmTMfy31CwtJuKkS2zqlE9ONt1xZ3KUkWpD0uZ6i1Jn23ltTuO8RJPrmtsyyEdrvoPA6QbST+BwQNMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7ePt78Z4VNBfYKz09VfzDFlTnLgArXgedF4QF4uOE0=;
 b=WlBV+G8/ICHJ5Fy8ZEx/RtY36MXfF3059SrKgSUvKekqGOOpYNssgk0iwu+IdvaqjQ3UWwJU6X3FwiS6BEM05iTqY/CTPlEvwadV29cTN79y1oqCQLSxQEhuDoUIZUWpuElRb2JvZ6Xf0YZjso+sYAECxqBZeuiDarBhpFHJKk5iWF634Zosf8lmVQFVAQSXNKLSFP/o5Hrgk82DKH3n7Em+aB1/3xVTi938p4xp3rATZ5nwDcPp12eKOaqQHxMIIuIs8SCpNww9ZDEQzzfzJh9/eX53YrY61eV77vMBBLdpPogMsUUmaKfJ3H5Mr3bRg1CrKyTB6jz+YJAX60ghtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7ePt78Z4VNBfYKz09VfzDFlTnLgArXgedF4QF4uOE0=;
 b=LpFCX84pNw1/nC5ImfcPrkR8LiDIrB5wAmOWqY1HRyRurQihoNRon293WbwbEbBcOjrIR6+gLe5sVL6/S9k8MgyAyeOWRZ/CwMAntcJ3PGUMMad8vq5fH5AVpEFJZtJ4oGlnc9Yd+b7CgwcJ+oVH4EmeryRN4N+HgHmwBdVwj1w=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2582.namprd12.prod.outlook.com (52.132.141.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 13:44:44 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 13:44:44 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 2/2] crypto: ccp - Verify access to device registers before
 initializing
Thread-Topic: [PATCH v2 2/2] crypto: ccp - Verify access to device registers
 before initializing
Thread-Index: AQHViBWyjw89L6UQN0yW6OCjMk2zKA==
Date:   Mon, 21 Oct 2019 13:44:44 +0000
Message-ID: <157166548259.28287.18118802909801681546.stgit@taos>
References: <157166543871.28287.16899240336796713483.stgit@taos>
In-Reply-To: <157166543871.28287.16899240336796713483.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0015.namprd04.prod.outlook.com
 (2603:10b6:803:21::25) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 697f50c2-787a-4c46-b6e2-08d7562cd497
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB2582:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB258284A5980A4B613826D765FD690@DM5PR12MB2582.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(189003)(199004)(15404003)(25786009)(54906003)(6436002)(15650500001)(71200400001)(5660300002)(66946007)(64756008)(66446008)(66476007)(6916009)(86362001)(66556008)(71190400001)(52116002)(446003)(99286004)(76176011)(186003)(2351001)(2501003)(103116003)(486006)(66066001)(386003)(6506007)(26005)(4326008)(8936002)(256004)(9686003)(14444005)(6512007)(8676002)(305945005)(14454004)(316002)(478600001)(7736002)(2906002)(81156014)(81166006)(102836004)(3846002)(476003)(11346002)(6116002)(33716001)(6486002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2582;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: duyusjXAQDMKH6R0qco9RvbOwTt2daV2+CWnsKsAoOd7fc+bLg/MRURcnBQDgYrFp6yEPlR624yAIEXJUf5skd4gOX8IMbgnTR8hh032a2l4GTpbXCMpqhOKBM7Oncy197pWia+/qIY5xjiYPf7hrXX7AkC7UuurnxVIXlfDuMBmgJ8Oe8/KV6LGnop9Yq3mrtIHzUtRmPxzEIzxMolvKzb99kkMxcQRJ2SregS02cts7nQvi/izoHm3U/Gz1o/FfR41ldhP5qnt2l9D4AFC0U//P7VukPV/DVtz9nDohc0fcEEi37Wz4UkDhibktg88niLt9M4G/zyuQJbQxFu+t0Y+rFAtvfkqwdvfvJVwC2WzMixLHMHm2NCT6HoLxQ8XlE9hz7f8jesaBa0E54TR03xwB8jz0d43k6ICuyPoI+4n0OTP3wpQmlfh0W2HOvnf
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3822A3066D0B2F4B98CF12D334A83128@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697f50c2-787a-4c46-b6e2-08d7562cd497
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 13:44:44.4375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yJPbphlYP3fMoN68fI/DaOjR2DzKiwU7ka5x/pT5ho1mwyDPvOW6QvLGJt+PbfMw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check early whether device registers can be accessed. Some BIOSes have
a broken security policy that prevents access to the device registers,
and return values from ioread() can be misinterpreted. If a read of
a feature register returns a -1, we may not be able to access
any device register, so report the problem and suggestion, and return.

For the PSP, the feature register is checked. For the CCP, the queue
register is checked.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev-v5.c |   12 ++++++++++++
 drivers/crypto/ccp/psp-dev.c    |   18 ++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v=
5.c
index 2937ba3afb7b..82ac4c14c04c 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -789,6 +789,18 @@ static int ccp5_init(struct ccp_device *ccp)
=20
 	/* Find available queues */
 	qmr =3D ioread32(ccp->io_regs + Q_MASK_REG);
+	/*
+	 * Check for a access to the registers.  If this read returns
+	 * 0xffffffff, it's likely that the system is running a broken
+	 * BIOS which disallows access to the device. Stop here and fail
+	 * the initialization (but not the load, as the PSP could get
+	 * properly initialized).
+	 */
+	if (qmr =3D=3D 0xffffffff) {
+		dev_notice(dev, "ccp: unable to access the device: you might be running =
a broken BIOS.\n");
+		return 1;
+	}
+
 	for (i =3D 0; (i < MAX_HW_QUEUES) && (ccp->cmd_q_count < ccp->max_q_count=
); i++) {
 		if (!(qmr & (1 << i)))
 			continue;
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 6b17d179ef8a..1524e44b0736 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -929,8 +929,22 @@ static int sev_misc_init(struct psp_device *psp)
=20
 static int psp_check_sev_support(struct psp_device *psp)
 {
-	/* Check if device supports SEV feature */
-	if (!(ioread32(psp->io_regs + psp->vdata->feature_reg) & 1)) {
+	unsigned int val =3D ioread32(psp->io_regs + psp->vdata->feature_reg);
+
+	/*
+	 * Check for a access to the registers.  If this read returns
+	 * 0xffffffff, it's likely that the system is running a broken
+	 * BIOS which disallows access to the device. Stop here and
+	 * fail the PSP initialization (but not the load, as the CCP
+	 * could get properly initialized).
+	 */
+	if (val =3D=3D 0xffffffff) {
+		dev_notice(psp->dev, "psp: unable to access the device: you might be run=
ning a broken BIOS.\n");
+		return -ENODEV;
+	}
+
+	if (!(val & 1)) {
+		/* Device does not support the SEV feature */
 		dev_dbg(psp->dev, "psp does not support SEV\n");
 		return -ENODEV;
 	}


Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D246CCA9EA9
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A043C222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Wit3goNg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634530AbfJRTkR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 15:40:17 -0400
Received: from mail-eopbgr750079.outbound.protection.outlook.com ([40.107.75.79]:33668
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2634569AbfJRTkQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 15:40:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH/D0+Mk0tKFMjnsWKiGI6hfNtP1TwSKNcS3CHi418qfKgzQ3Nosz0Z2M+uPgJ1Tl/DRasbgw8/jVWUYM6QEkLGyfEqt31CaeNHSkLhqcIuv+IaZEDNwZzKDcuXWrZRW1za9hbykpj1aKjCyhG/rZjYkZsiCANbjaQ9k2HYFinwo7k3yXaWGj7W64MhB01IQLxlqe7IuUgFpBJinttBUDcBxMPUB2SUO4DMkoTF7YTZXZChZ14ipzL9xGXux9P8pXuO2iq9cb31llpmwSeeORMY+rm9DfCOiB/f3fzFH0C2Mpkwp/omP3kRhU8d2VS417V5rcGkh6w263LA4QsSNQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSF5ui91GdDhN3I7b3jLzT/MotFxAXI0PSVfs7uO/is=;
 b=jfi7CFW6Alx7jS3TM9oNtD2fTQFzH6f8EWOi4JA4i0mHEWQVTeQWK3hxBFTBSguOyLHYWquU7lOaZMrRaI6m8QSdrspuDHXvwWpGjdgQPi+4mXgj5rBEYQe2seUxXZMwfyJbJxA934XfNnlFGYUgDFkq36aL+GsZtEGxryEi01d/PBSIL+q0mrsEftb285CsFM141LBvUXzsZBXhwAsq8HjamhQS8YGlVP78NarsOS6UnvbBqgWdPsbFwQ8HnInXNAb+2QAaJTpNj11CjwVhuZn3df1LrsLHG/76k92L+tGxGgxBti0voLEJMjgHxAnGt0l+ON0Y1DSOXQCwoDAPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSF5ui91GdDhN3I7b3jLzT/MotFxAXI0PSVfs7uO/is=;
 b=Wit3goNgtqLn7NOVMalYyU0X/4kpBVDi5M/uQ2hPXzTR4/8cvHwg+syZO5/j/DgjSo/43uajzB9UZPFkkha7O1yhsQjoz/E1me+3PuEgoP+0lNR4N9z8oHw2Q1rcE/5LsR7I4cE7pZ9Hxyb2lTqyoPgn56zfldu5MiJw3QFuIlE=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1593.namprd12.prod.outlook.com (10.172.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 18 Oct 2019 19:40:14 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:40:13 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 2/2] crypto: ccp - Verify access to device registers before
 initializing
Thread-Topic: [PATCH 2/2] crypto: ccp - Verify access to device registers
 before initializing
Thread-Index: AQHVhevb6uCemt+Q2UGIzgECLxtkeA==
Date:   Fri, 18 Oct 2019 19:40:13 +0000
Message-ID: <157142761182.6869.14495874318327779624.stgit@taos>
References: <157142758885.6869.11882127817423670946.stgit@taos>
In-Reply-To: <157142758885.6869.11882127817423670946.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0075.namprd12.prod.outlook.com
 (2603:10b6:802:20::46) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b405c351-382c-4cbf-de71-08d75402fe50
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1593:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1593A2F44C0C357FF9073E55FD6C0@DM5PR12MB1593.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(15404003)(189003)(199004)(14454004)(25786009)(26005)(86362001)(66446008)(186003)(8936002)(8676002)(81156014)(81166006)(71190400001)(71200400001)(478600001)(386003)(76176011)(102836004)(52116002)(316002)(2501003)(99286004)(6506007)(54906003)(103116003)(66066001)(5660300002)(305945005)(3846002)(486006)(14444005)(256004)(2906002)(6486002)(15650500001)(11346002)(446003)(476003)(6116002)(6916009)(4326008)(6512007)(9686003)(2351001)(64756008)(66556008)(66476007)(66946007)(33716001)(7736002)(6436002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1593;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wgIMICwvE8AyJg5MTlM3wnj0T/tnSW4GiLnc78V4USLUluIEr5B0qMWXxk0Gy+OVKiNB9/CENvODCtVt8GpUgfaUGY27sJB2nQAUjFAkzeJv7eyuZHpfJ+IjQ+O4YIoOzPCOzWdh1EKp1SgljOmmgyEajyJwI6OLCNPtUhjRyjJ4mlQ9pvV6UsQM/iPXDWuSRVJLGGLX5vLFbxxTf8FCBArPlQx2pOWN+GihrJvmwihVi+OM/W6TwXS7VqnGBhgxcB7MCrlx1IxV3Iad9XD/H1UuPZRe84vgYIGPtxcDzJLZhdEQWs7DZebPVbTsrJSlhRHQLY9qepgyYo4osm50DlU5g26U+U00LL8VxGw17JiDoGWYe9am3vcmJ/fQIv/qoyQ/7rcK+x0Pt+dWZScG6NvonEdwpS3FbH2+kJtPtZ4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E524D2A87B56A4F8F7043EACAE7695F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b405c351-382c-4cbf-de71-08d75402fe50
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:40:13.1814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LfE3C05vYnf14Cxddb4T8AXwCorR9r3mRfNsvhg8tMn8MKzwfl8Zel8e1l+Z/uC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1593
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
index 2937ba3afb7b..72ea805cadaa 100644
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
+	if (qmr =3D=3D 0Xffffffff) {
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


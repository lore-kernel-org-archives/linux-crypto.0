Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2996EC282D8
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 20:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C46E12184D
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 20:58:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="ZHRLmJfG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbfA3U5z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 15:57:55 -0500
Received: from mail-eopbgr720050.outbound.protection.outlook.com ([40.107.72.50]:22556
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387888AbfA3U5y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 15:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amd-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lz88SedlVWSQREzbW/rZQqXC6gX6MN15EERRQFg15L8=;
 b=ZHRLmJfGxShB/1qGyya0t6rju4mZFb85TPl81on0A7pEZdoFA6oQuoZEgh9a+Xrf+wJIb9BPvAaue2+NgUVtms+8b+1BvBNXtqCMbqP4bCDbSS7Dli7ceSL9fbsLgWpKCnk8BKWprS7MWi90qCBUtIuI9qk9UAoVUR+litDxjIA=
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.116.31) by
 DM6PR12MB3612.namprd12.prod.outlook.com (20.178.199.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.19; Wed, 30 Jan 2019 20:57:52 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::10bf:617c:4515:4ad2]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::10bf:617c:4515:4ad2%2]) with mapi id 15.20.1558.023; Wed, 30 Jan 2019
 20:57:52 +0000
From:   "Singh, Brijesh" <brijesh.singh@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Topic: [PATCH] crypto: ccp: fix the SEV probe in kexec boot path
Thread-Index: AQHUuN53GxbsT9pk+UaDAUjTznR12w==
Date:   Wed, 30 Jan 2019 20:57:52 +0000
Message-ID: <20190130205710.14268-1-brijesh.singh@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0048.namprd12.prod.outlook.com
 (2603:10b6:802:20::19) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:4a::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM6PR12MB3612;20:ldmQhVVEUQLy1JfWGzaCE/WGOw4SideGUsZ9CTBJqjCX4p3NNtejXmjEdWs9XfCCM9NraUbzBj5/lZbyL3T16HnNc4XoCW4RxvedWzND6cIzDb+5wf6rU8HrlNeaSb4f80m6+EP/j3Xkth1hNeP8QR77USi0CGQ+Dev8p6LCh+1SbumAZwcQszjKUnPw3eNpg+ECnCr3CRBhIOj5sZvM/R5rX+cY5zM8p6AQjzvQ55UdO/KDMj031xgcz9GB2iIC
x-ms-office365-filtering-correlation-id: d1989338-9373-4245-6e2c-08d686f59972
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4618075)(2017052603328)(7153060)(7193020);SRVR:DM6PR12MB3612;
x-ms-traffictypediagnostic: DM6PR12MB3612:
x-microsoft-antispam-prvs: <DM6PR12MB36122CD34595DDBF6613F40AE5900@DM6PR12MB3612.namprd12.prod.outlook.com>
x-forefront-prvs: 0933E9FD8D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(376002)(136003)(346002)(366004)(189003)(199004)(6436002)(2501003)(3846002)(6116002)(86362001)(476003)(71200400001)(6512007)(66066001)(71190400001)(256004)(1076003)(6506007)(386003)(5640700003)(6916009)(102836004)(2616005)(14444005)(6486002)(99286004)(25786009)(26005)(316002)(54906003)(81156014)(81166006)(186003)(14454004)(8676002)(50226002)(53936002)(52116002)(36756003)(450100002)(305945005)(4326008)(486006)(68736007)(97736004)(8936002)(7736002)(478600001)(106356001)(105586002)(2351001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3612;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t8Z1j5P2+2ife45w2CdNSnpPPrClI1eS1Q4RrPStETS7IVFV5v6N8DpplyC3mVy4icDUGidqdNQDH5osPIbZPK0PluY1du/OczDII0AQPZ5xEga9NJoP4ojKicFiYohxqJMqHyh7f/MbBBM0twiXjOD14fuUdg/jMwFSiTOaqC0LQ8VDTRg8KPthWlLI0poGGmi7qCxL0zpRhcjRg5K4ul/z6c9aAzZlzdMQ3yiesN2HuWAoYPf8aE+3oA9MKDTE3CmgqXxA1sCY2AJN79MZfTLkLergwfRpc1Ft4CkcdqZlnbm67kz7xA6HRSQqwpoLwHNdghnU3+WvNQ6LIcfFuqCjh6RQJBRpk5xU4mA3N8HWo+TU6GUAGhFq01KNMecZbjfz+rQHN48K7UBT3SrIYtdXPFa2uf9TMlMPfPzrDck=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1989338-9373-4245-6e2c-08d686f59972
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2019 20:57:51.1341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3612
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A kexec reboot may leave the firmware in INIT or WORKING state.
Currently, we issue PLATFORM_INIT command during the probe without
checking the current state. The PLATFORM_INIT command fails if the
FW is already in INIT state. Lets check the current state, if FW
is not in UNINIT state then transition it to UNINIT before
initializing or upgrading the FW.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b16be8a11d92..966ca6f9cf79 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -437,6 +437,7 @@ static int sev_get_api_version(void)
 	psp_master->api_major =3D status->api_major;
 	psp_master->api_minor =3D status->api_minor;
 	psp_master->build =3D status->build;
+	psp_master->sev_state =3D status->state;
=20
 	return 0;
 }
@@ -964,6 +965,21 @@ void psp_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
=20
+	/*
+	 * If platform is not in UNINIT state then firmware upgrade and/or
+	 * platform INIT command will fail. These command require UNINIT state.
+	 *
+	 * In a normal boot we should never run into case where the firmware
+	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
+	 * may not go through a typical shutdown sequence and may leave the
+	 * firmware in INIT or WORKING state.
+	 */
+
+	if (psp_master->sev_state !=3D SEV_STATE_UNINIT) {
+		sev_platform_shutdown(NULL);
+		psp_master->sev_state =3D SEV_STATE_UNINIT;
+	}
+
 	if (SEV_VERSION_GREATER_OR_EQUAL(0, 15) &&
 	    sev_update_firmware(psp_master->dev) =3D=3D 0)
 		sev_get_api_version();
--=20
2.17.1


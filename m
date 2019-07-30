Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C3C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C94AC20693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="RCAQLFCO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfG3QFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:05:25 -0400
Received: from mail-eopbgr720075.outbound.protection.outlook.com ([40.107.72.75]:11388
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725908AbfG3QFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:05:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSE60BmgZu5y93oZmaUWDRLbHfYXhycneHhHadlYhPb3U9Xa9OxnPOTR7HgMSqEwKkaOQby8A+cw6AmnYVurlIlZCKg333txbDGy/qGFzeKXJKbabdc1isAs4fxe1OjgRjptFSBd3QlyM7bv9u8XEvvGPcQUsHwDTjSsDu8yXNr+NLmRKD2wiiDHV3F3+QdmWQjS0aZ1r51WOZqwHUGL6AIPNVnOBRUvvVsCBIFE/rdlWsRm/hzUhA1IU3GiBNgdvtY0MoTbK4v1ut2uBvIQKBa22opxfTzGBE8KxF0pyxCcTdZ+L/ddS4YXTad6pb5324kKdB2ygrAGr0xxBhKjhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCGHLfQSL/gxb8lv2qsYR9uj9C/D/ilkVzqu8giCK28=;
 b=UUM4hGGUtqDaWOhQnORUFLfQy9tTiXyKBYD8hvFsLSXw+R4AY/uWP89U6HCCCyXM4iCp+npAdOc6uEvcPfq1UxjkUuPFd8InSK0fhRl2otPvqj9YZ7/K42pHm6dyyyhJrPBDyv6DdEJvPazAlg0gGYRtWuJtJYFaPuM1Y/VyDovICc4+/+GWHStgqpeHZ0lzEcjTm4iACqCfzbeFrsH3ege6u60Zo7A5EZ1VYGMyJOV9EArIDWUVCDdAODvQWfis3sAdD1+39iUfh3mM3Ef8GImXvzDwJfAx+DtTQPHsRafgnTErnv9Hl0AIaEpOSbcot+RURlenrx6OHwKG+tRUWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCGHLfQSL/gxb8lv2qsYR9uj9C/D/ilkVzqu8giCK28=;
 b=RCAQLFCOUnUAlFRENvQ8uzbRs/nnYJRaNF4ydRHt+mqmhWqpk1l9p2L9a7h4x9MSefKOJ1IVU5MfikEVzu64/+yyNCKRkgcT8n9rW6Wk0NiKq3PuLVXYCWFdKXJOGXzSpm1LTeU+a8Vha3fX1ypsKGEisAhXrasoESrQJgm4P1U=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1292.namprd12.prod.outlook.com (10.168.236.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 16:05:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:05:23 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 1/3] crypto: ccp - Fix oops by properly managing allocated
 structures
Thread-Topic: [PATCH 1/3] crypto: ccp - Fix oops by properly managing
 allocated structures
Thread-Index: AQHVRvCXN8VceWiIaEmJZ2zQZx0/bw==
Date:   Tue, 30 Jul 2019 16:05:22 +0000
Message-ID: <20190730160454.7617-2-gary.hook@amd.com>
References: <20190730160454.7617-1-gary.hook@amd.com>
In-Reply-To: <20190730160454.7617-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0069.namprd12.prod.outlook.com
 (2603:10b6:802:20::40) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1228ddc-90ed-4675-c803-08d71507b9f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1292;
x-ms-traffictypediagnostic: DM5PR12MB1292:
x-microsoft-antispam-prvs: <DM5PR12MB1292AB18311F14E43F82A86EFDDC0@DM5PR12MB1292.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(199004)(189003)(2501003)(76176011)(26005)(386003)(8936002)(50226002)(1076003)(2906002)(478600001)(66066001)(6506007)(71200400001)(256004)(486006)(3846002)(186003)(6916009)(81156014)(81166006)(4744005)(68736007)(71190400001)(476003)(102836004)(11346002)(14454004)(8676002)(52116002)(86362001)(99286004)(2616005)(6116002)(7736002)(6512007)(53936002)(54906003)(66556008)(66476007)(64756008)(66446008)(2351001)(66946007)(36756003)(6436002)(5640700003)(6486002)(446003)(5660300002)(316002)(4326008)(25786009)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1292;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U2PHsIKUIxF4mDySaQ+lZXIXSWR7TW/Bbq2LdcusFfOtUCSFCo2H9MnYo53Ue4fpShpEAmNRrX9KWKVR3RxT7ezHk4I/DJdBcGp2IH0zL4kW+kJQci7YWMtPD/Kn0g1YpDfluzQshfrDAcFPjlU0Zjoxh+U8ipUkPzALE9iqeD70cUpMuHQ37BcJm5bQPFYAoLtaXleaCJNdmBRc9G2I4DRBFi7QOL3ua5Rp0kKemcniIYcdGfjhaoH8tPI16dKHCJ8ss28zVuOLRkVCMm/qkcUKN1SUOW21Tz+3+Xn6LfvFQVmpi1mK8AP6KGPgc6aQd6A/MHfc1CW+LcW+XeGpSsa9I7EDGlIAzP25tT44SRfEOwtUxn2mOLgUu09ZVuFj6mEWiiA4R6gzLDXOsaqN9crjeBMCYopCUZk4V0ETZ5k=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <1558122ECB466C4CB631AF3F231695B3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1228ddc-90ed-4675-c803-08d71507b9f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:05:22.9094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghook@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1292
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

A plaintext or ciphertext length of 0 is allowed in AES, in which case
no encryption occurs. Ensure that we don't clean up data structures
that were never allocated.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs"=
)

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 42d167574131..35b6b3397d49 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -858,11 +858,11 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, stru=
ct ccp_cmd *cmd)
 	ccp_dm_free(&final_wa);
=20
 e_dst:
-	if (aes->src_len && !in_place)
+	if (ilen > 0 && !in_place)
 		ccp_free_data(&dst, cmd_q);
=20
 e_src:
-	if (aes->src_len)
+	if (ilen > 0)
 		ccp_free_data(&src, cmd_q);
=20
 e_aad:
--=20
2.17.1


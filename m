Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBA0C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8731520693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 16:05:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="XlHNQPaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfG3QFa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 12:05:30 -0400
Received: from mail-eopbgr720073.outbound.protection.outlook.com ([40.107.72.73]:26016
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbfG3QF3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 12:05:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=np725IyYDS5aAsgXwv9v5AmWdZMMGH8GrqbrY7joR+U6dLWAH7c/G56dqZRoZPBU0ZVAabzd1xGJCMAhSUT4Yv2amKGT1aJMymUhKSMfAvC922Qu9tNrhfFC8P6tXAK+78NSmTs/vZqYWh+W2yZ0N7nNoMsFvyQbdn/TmQpDYY94xlmyaI64NPVG2jYiqIp5AqwInRDVW8pbNu6rOkGmlHrRKMfm7TpISStDx7Rq/FCFYgmyvNW1poXiArxN6iZB/ChZ73TgiIgzzHPRzuS77/P30ndSfT2mxRnSv3zcktff9lEoaXssFw07McHMjRNatLEJc9VTw/l/J1L3DLzpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0eSzewmzjKr1qeZRqfo4tjBp5slwdoaXdoapkP4fD0=;
 b=VJbLMSvg/GbpkEHkBj2cydRsZQX5r8IXKMxaa0rP7MZRobBON7UDwkFhbUR+0pn/YilOuOAGUPlN5ttYYNMCc9eyCejEpPG8HVQw0aj55ZXED+EsNwv/7SIwql8SS1GaS2jb/V/YAzcswhNfqzWIszUlbbo9G9hIaRaO7uYX/PM8zK5imF1cNTVLxwKNuXJO6p3OIYe4Z2P2LjruZ/YFk7caD9n60bbJIcEjZRyQuR8x63E/R+66pkFDYgrR6gKqOhznfwaVleyCJWtp2mdVUeflRzpaWDozTuKOOcDR2BXCmz9pVBsO2bIcu/EasU0Nxs5TUtfb0Pa/NxmXQe/QJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=amd.com;dmarc=pass action=none header.from=amd.com;dkim=pass
 header.d=amd.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0eSzewmzjKr1qeZRqfo4tjBp5slwdoaXdoapkP4fD0=;
 b=XlHNQPaX0oCHVAG3cD+c2rqYcXLX41WAzcwrtWSd1a9SiCaveo0Wh7IhhY2fKBHFkVWqmINxD6HuBLlQtGa019g8TscwqOpF6ZvxJ2Q+xl4GApcdOuBZDb7A62PBevNjEvNqKYCBS831DIuYqxn/1zCEL2yhHwvpPniXTCXS2+Y=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1292.namprd12.prod.outlook.com (10.168.236.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 16:05:26 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::58b8:4b33:20a5:5e3a%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 16:05:26 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH 3/3] crypto: ccp - Ignore tag length when decrypting GCM
 ciphertext
Thread-Topic: [PATCH 3/3] crypto: ccp - Ignore tag length when decrypting GCM
 ciphertext
Thread-Index: AQHVRvCZVm1XeXkuPEWaqrJ47t44ow==
Date:   Tue, 30 Jul 2019 16:05:26 +0000
Message-ID: <20190730160454.7617-4-gary.hook@amd.com>
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
x-ms-office365-filtering-correlation-id: 99fc27c7-e96e-4be3-a11d-08d71507bc27
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1292;
x-ms-traffictypediagnostic: DM5PR12MB1292:
x-microsoft-antispam-prvs: <DM5PR12MB129295232DD5A7DA04105378FDDC0@DM5PR12MB1292.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(199004)(189003)(2501003)(76176011)(26005)(386003)(8936002)(50226002)(1076003)(2906002)(478600001)(66066001)(6506007)(71200400001)(256004)(486006)(3846002)(186003)(6916009)(81156014)(81166006)(4744005)(68736007)(71190400001)(476003)(102836004)(11346002)(14454004)(8676002)(52116002)(86362001)(99286004)(2616005)(6116002)(7736002)(6512007)(53936002)(54906003)(66556008)(66476007)(64756008)(66446008)(2351001)(66946007)(36756003)(6436002)(5640700003)(6486002)(446003)(5660300002)(316002)(4326008)(25786009)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1292;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: E2Wb60VAb8IhsB2MivvPssZjx38pmve97rGn9sI7HXpFu7IEjn5TcGnjy/WLNTkDa2fXUP0sSnSQHhLasg2WcDUCDO6psIJPFutuWnTkBCxIiGUtnjLjpeQXGen5qxqIV9MdMHQThugfgCoTMcizQ9m9O0q0tIWmTHp6+w8Tbp6Ph0iyZpKW/jEJZgTngS845wrzT+ez7owuye/NBvwkxj3+npVzWbeTFXv8+f4+iBhBbFSLERAbuhPx07Qj/FYlGmBqT40MazzDZ1MDYVHaDOHV+8oSp/Z2DUtAm4Lfh6lQBTt08rqAYze4ZSePxH/Z5c6CxcTwY0xl+ZvAO0B4S6mlkuXH2xeS52MUWtNfomdFRTUaiJ2Xyx38w76YZzvTlbUk6tYN8lD4qUkBJBXddIQrx7pz2i5WudsOxAIyjPs=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0D4865651BBE5F45B25E7CA1E761A850@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99fc27c7-e96e-4be3-a11d-08d71507bc27
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 16:05:26.5815
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

AES GCM input buffers for decryption contain AAD+CTEXT+TAG. Only
decrypt the ciphertext, and use the tag for comparison.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs"=
)

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 553d8aa4f18d..4c1b1445af79 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -781,8 +781,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct=
 ccp_cmd *cmd)
 		while (src.sg_wa.bytes_left) {
 			ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
 			if (!src.sg_wa.bytes_left) {
-				unsigned int nbytes =3D aes->src_len
-						      % AES_BLOCK_SIZE;
+				unsigned int nbytes =3D ilen % AES_BLOCK_SIZE;
=20
 				if (nbytes) {
 					op.eom =3D 1;
--=20
2.17.1


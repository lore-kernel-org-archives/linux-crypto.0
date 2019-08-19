Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABCDC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 22:23:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912C822CE8
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 22:23:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="thDUZNR8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfHSWXb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 18:23:31 -0400
Received: from mail-eopbgr750052.outbound.protection.outlook.com ([40.107.75.52]:63812
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728435AbfHSWXb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 18:23:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od7M7rG8AG2iY6+HiZnyAGqxOKXhSAXc5Cw8E2ZA88n465Mi8gUMZiTialzad1vppsSIzebmPg3frDBnJWSTQFkiXEz95k7VRgF0iBKqYB/Oo2rAygrcSBsoIVDhUXY4mUjd2rD7FvbsnfOmzbpN1imC5JU+eeaou42c/EECthmnE1RiW3Kd9P652QLNwyZ/CEh/ekj3qzyu/3lGvPIDv77Yrtnn/KPlpyt00YHDuK6OPtzmyKctwWJEEJjMsaME/9yttBgkihpEvFR9BEd2S4SCSBRGIE7bD8GcBn/5MZNk29K3wAkcya/ELomxFyyIv2Aq6dXhZs4BjEnGLKkLSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWZxoGJSzpOzkDHJLMitZh1tncbhh/jw+5gDoDUETdg=;
 b=Z0ubR/JMuU+7BFbTY8i3PsjVlHih0dCeQ6ltMS3clf7JnEfBqXG10a+IJDJnqvjDtspqalhORMsFg84xQxMLEjl6TpkIT8f5L6+W/3ANrHYE3q22oBhwDXQ6YSAYv0H5kI0bq5ph6yHZj19lXo4/9IJErk7E9BQIg6Rt1CAfBq/0JjG2+aJAQzHEdBhxOjw+csgxeoOp0u3eIFIrqtCDJXhctfn6nMMWn+9JSztV5ySWFzmnD899FHMtn8sAX0SxS/1/A1ObHuvrmJ+hrFxk9TXoVcq1mO5p3HoQLAqNrsJJwVsp+kq2Yaa0sW2qRLRTY0DafsdS+FC1lVeuC+nP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWZxoGJSzpOzkDHJLMitZh1tncbhh/jw+5gDoDUETdg=;
 b=thDUZNR8A0O4TQNn/6ov1KohN8XiR6HECQN8irisXuo8u+3s7wZ8f9PqxICQTTnwAqi8cdwbjYQlHurAO+OxiJYi/phmORWZOtBCJCukVU226suSKzBUz64ChX+LiosgBWilTe7uos87gJJsgMwKjF9mwJVmDWGiWBRt0bxlC0A=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1212.namprd12.prod.outlook.com (10.168.237.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 22:23:28 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::f9ec:92b6:9a0f:30ca%6]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 22:23:28 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: [PATCH] crypto: ccp - Ignore unconfigured CCP device on
 suspend/resume
Thread-Topic: [PATCH] crypto: ccp - Ignore unconfigured CCP device on
 suspend/resume
Thread-Index: AQHVVty5K91so1H2VUSnun/kr5vqgA==
Date:   Mon, 19 Aug 2019 22:23:27 +0000
Message-ID: <20190819222315.61244-1-gary.hook@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:805:66::27) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [165.204.78.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21550aca-a9aa-4e10-9ed9-08d724f3db8a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM5PR12MB1212;
x-ms-traffictypediagnostic: DM5PR12MB1212:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB121218055FB7D11BFA97395FFDA80@DM5PR12MB1212.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(189003)(199004)(486006)(2616005)(26005)(186003)(81156014)(6506007)(102836004)(386003)(86362001)(50226002)(305945005)(476003)(2501003)(66066001)(8936002)(6512007)(99286004)(2351001)(5660300002)(3846002)(81166006)(5640700003)(7736002)(6436002)(53936002)(15650500001)(6916009)(1076003)(14454004)(478600001)(4326008)(52116002)(64756008)(66476007)(36756003)(256004)(14444005)(71200400001)(316002)(71190400001)(25786009)(54906003)(66446008)(66556008)(8676002)(66946007)(2906002)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1212;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3vw0GBPazmWKmU/OymgWMjU2NIjJXfjWGDDJZ0SzSJMTSFGVEnTYUAki6pZUHrxNdPfz1lxEgD0Vsv3vOGKFtRcrLLn0k+yUhqlpAEnZDYPzVCwxnAU1cFA8DiA8vFO2OP2LPfCi+/Pj9T8qwspXX1mkw9JsnOGDl9j9wbhvPuHc2fI8USJECiqjBDJCIT1hMAOr8BBzJ2YRfecRDlMnxXgHBtezg7bshesaQbyQn88Ip0GLCIQcDWZ8ZUkzpZDato3x8z0iWkTKPFuOmZ0YbwLYPj5dbVF9uZLsdomhA0datnAmvwjYx4tRupRrfEz7KZx7zHfxlVCJ4gIGvHWLGZdYB2CiyB3g39kv6/etZHrTpwrF5K49U/+uAgvxDnHDy32Nr1X/KUZ59kmbCfFmois2PSTH9G6pP1VvN+3b49g=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0A8A58F745AD144E99ECD406F80009E1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21550aca-a9aa-4e10-9ed9-08d724f3db8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 22:23:27.9620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZmzkqdTi4rSSD+wcCtAGJyKZVLT4UTnm5P2jOOLrDtCvsydb62kMCINyWKe+A/SZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1212
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gary R Hook <gary.hook@amd.com>

If a CCP is unconfigured (e.g. there are no available queues) then
there will be no data structures allocated for the device. Thus, we
must check for validity of a pointer before trying to access structure
members.

Fixes: 720419f01832f ("crypto: ccp - Introduce the AMD Secure Processor dev=
ice")

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index e58d69d4dd43..73acf0fdb793 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -555,6 +555,10 @@ int ccp_dev_suspend(struct sp_device *sp, pm_message_t=
 state)
 	unsigned long flags;
 	unsigned int i;
=20
+	/* If there's no device there's nothing to do */
+	if (!ccp)
+		return 0;
+
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
=20
 	ccp->suspending =3D 1;
@@ -579,6 +583,10 @@ int ccp_dev_resume(struct sp_device *sp)
 	unsigned long flags;
 	unsigned int i;
=20
+	/* If there's no device there's nothing to do */
+	if (!ccp)
+		return 0;
+
 	spin_lock_irqsave(&ccp->cmd_lock, flags);
=20
 	ccp->suspending =3D 0;
--=20
2.17.1


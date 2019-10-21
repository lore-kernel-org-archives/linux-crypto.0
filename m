Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305D0CA9EAF
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C89214AE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 13:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="RkHzTz5I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbfJUNod (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 09:44:33 -0400
Received: from mail-eopbgr790054.outbound.protection.outlook.com ([40.107.79.54]:25248
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728479AbfJUNod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 09:44:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEPZLggS84ZeSAm7Lc28QOYY0jly0iR40+U2mZs2Y4qXRvnAmxCUNCgaKetiqVA5V+qxzhzRSdLpFh2YYgV1YNIVvBvf5SzqJKCn9an2CncnyG4BQ9NmN7gNvzB7iLFneWQSSm7ISejSrKF4mG+xf8bgm/Duh+sKqN0nDwb5T3L0vihrMpUEEx2GpJtZPN/wuOySfMX0C3u236kFxFIy3/AjDD8linY9NUkaOMmUtZ5bU2uQYP1vT1QQ7zb9MKYH4Y3zZhT+TFBiMtxnTtGZxmlHR5bHPY0AkTf2PByM/CtH7S4Dyw4KSe9GXQJe7mOhDFQwIMNHQKrlinZuxlEJ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apjZ2nAz6pU1SLya1E1RJBCHL5pryXplLcNLpoYNiqc=;
 b=SsfUPln4BN0Yg3CgmV14NJDLD6A/hEMbTtAjRKkd1u248yYGRHZni+3bN0OkYBbJl1gUizzeWZgRFVfPzfoLEqdU8SbZ56GsxDn6YXmZ7cJjdvHwzUJAGea8Kzn2+bp8ER0VgOOMj7ed9tVLnWu5UzDF9QtAL+hBJWloZws2S/6kPSypyFs1kE8u85d1Nf0Zooi3h+pXUNHkiDEfvjia9L6tkOEufa+FP1eyn7Tla6my0bU+VCTynw18Bv7hDwziGa6N/RTjN9YCBa0dbMchW65tBoygeWS/ru8et1jVKlC6VU0nZAkGpBD05ffqdjTU3cvBdiKQZdwTrq1y8jTEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apjZ2nAz6pU1SLya1E1RJBCHL5pryXplLcNLpoYNiqc=;
 b=RkHzTz5ItN0DfOWovBT3LHyjTqbMd00FqYM8wgJa/nvJ++BqSxIHtQ0UpbWBbJcHVmIWrclOO42zJu5ZyLiLsyi4UXjo3pyfJK7A+9zfRAwyDC/O2rQsKaoxTPt0pBvniG1s97fuuSI9fqi1jIJBTDPYYuPKj+sOSd9XuXm2qOI=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2582.namprd12.prod.outlook.com (52.132.141.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 13:44:30 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 13:44:30 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2 0/2] Improve CCP error handling messages
Thread-Topic: [PATCH v2 0/2] Improve CCP error handling messages
Thread-Index: AQHViBWqq9mvMBhS/Eacs79HREKsVQ==
Date:   Mon, 21 Oct 2019 13:44:30 +0000
Message-ID: <157166543871.28287.16899240336796713483.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0023.namprd04.prod.outlook.com
 (2603:10b6:803:21::33) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56516d6f-6a17-4c7f-9e47-08d7562ccc75
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB2582:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB258264A688B675E4A7ACD506FD690@DM5PR12MB2582.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(189003)(199004)(4744005)(25786009)(54906003)(6436002)(15650500001)(71200400001)(5660300002)(66946007)(64756008)(66446008)(66476007)(6916009)(86362001)(66556008)(71190400001)(52116002)(99286004)(186003)(2351001)(2501003)(103116003)(486006)(66066001)(386003)(6506007)(26005)(4326008)(8936002)(256004)(9686003)(14444005)(6512007)(8676002)(305945005)(14454004)(316002)(478600001)(7736002)(2906002)(81156014)(81166006)(102836004)(3846002)(476003)(6116002)(33716001)(6486002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2582;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O1/n5s31itDopLi8+zKZ6jGdM7hdOKNKTS+ialUg7sTNm4+QJ9bx89sEovuFubJq7XOHnySJtddAxFLi69oYwjcp4R9PANjX8PlXbniq63UuFkuR4puNKl3mXqpnjo5W+60wgxuOG3pilWNqy/U2BsVmcDJeyqikA4qfWD97/rQntLqg4TSpm/a3jm+Ijb2SRXe2k/QP2RBlRLzN9nGtVo4W2GLPDky4DbT2W3jhF5anOAdXSn2+uXfG13zWuROqN6Iuip6/lmMOz/2eL44j3baMlYkdgfb6MOhFhb7OwTbuD2lXu0ZaflIX+sge7f45oEJ9/1ugMAVB2UKu2Mwux/GDHm2/a5pyFo4D/JhPRX7Hq7gf84bl30qc+hTnKE0ClTLCb31YRFxw3HbJQC2uQ+a88ay9L5I5p0nKENwqfWj/fahGYUIo9D37AoQva9XP
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E421F129B795144A67B3630C1AA455C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56516d6f-6a17-4c7f-9e47-08d7562ccc75
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 13:44:30.6294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FpfIyq35vV/V3qWDAijvWFqs1+1wZ2k62ZAZ3M2P/jaiQRb455Bqkyt8eI31BVeF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2582
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This pair of patches is intended to clarify the messaging produced by
the CCP driver when known, but non-critical, problems arise. The
precipitating conditions can be determined based on simple, unalarming
messages in the system log.


Changes since V1:
 - Change hex designation '0X' to '0x' in ccp-dev-v5.c

---

Gary R Hook (2):
      crypto: ccp - Change a message to reflect status instead of failure
      crypto: ccp - Verify access to device registers before initializing


 drivers/crypto/ccp/ccp-dev-v5.c |   14 +++++++++++++-
 drivers/crypto/ccp/ccp-dev.c    |   15 ++++++++++++---
 drivers/crypto/ccp/psp-dev.c    |   18 ++++++++++++++++--
 3 files changed, 41 insertions(+), 6 deletions(-)

--

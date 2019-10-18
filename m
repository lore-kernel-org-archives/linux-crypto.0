Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAC2CA9EA9
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A1B222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 19:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="bKNl7Jrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506017AbfJRTkC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 15:40:02 -0400
Received: from mail-eopbgr750072.outbound.protection.outlook.com ([40.107.75.72]:53021
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2505992AbfJRTkC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 15:40:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFl2j3DZtI6uj0A6gmt1gwT/3WZtA2bDAeJ+iuKrYRMCtuj7QdNqHLwAV7KLLU1QvjpTG69+/enlIu6qTPVhphm6vQn4lQapONxvWbSoWI1DBeyZhIJg5KKWuxgdntNmJmBomo5EQXDE5DR6pNwr7pKdbULVf3LykAKUZSFVsAomK/d0tdewB2zXQ8LG+nqGhGkpiEaiRqbltoUHgSW5n62WLQ8WZwPPmn5gtaxtsu+BPzI6aUUKEqsFsTAFxuAXVoHRFh/4B4v64hRxCh1vwWGdS+gwy7OnkL0U/fknddy1zl1lpqnedENIHxJcn46+KfO++w+ESvDBi3HUPttwrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swc6+sSuuZf8ip/ufC4tIbs/EWcoLLQJ6K3Mm9fQB50=;
 b=KwHNj/0i9Rh4WkMSR7mM9SX1sBHySon4/LlkimLYqL6wlRCRpOzFMc91ibEmRBomSuQsasHvMJxn01n75yl5Ncz9FLTg7pwcF9FwKyznyju7TDhk4riQJG7X6VLEBqC6MAllUIHwGZcumqpKXyLzvKv0SwohSp7r6PLuyIs9T3V6I9r4U8gmpCZrIiX+BhvrJAUTPQRiSVnViyXw2J4JpRsiSBtMjPAAHnGh49sthW6gvaa6lFSD5ewvj3ovP1hvk9WeVEuQpvad+1G/CxI/ddFwnK2Z0liF8dNTPQ/iKgYu8XjbZFppWXYCf2jmb5EpDey6pRglQE6GGjjzLWEMAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swc6+sSuuZf8ip/ufC4tIbs/EWcoLLQJ6K3Mm9fQB50=;
 b=bKNl7Jrxo0d0xH9w0DDKVlcTQEHLGNtbM0msU8B+nQ8Cb0Zd7P1Ed73B4TcbtmtxV86/sqF55kOvS1NglXxDM3z1ttmVzY5ZTqRhwuLT2eC4ZbMM3+137HGOWApAJ9R8GXpsFDn7Y/fRP5F2scMSt1G9pTnYUBNZColc9BGIpTA=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1593.namprd12.prod.outlook.com (10.172.40.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Fri, 18 Oct 2019 19:40:00 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:40:00 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH 3 0/2] Improve CCP error handling messages
Thread-Topic: [PATCH 3 0/2] Improve CCP error handling messages
Thread-Index: AQHVhevU/n4meMvGi0SNv60HvFtyVg==
Date:   Fri, 18 Oct 2019 19:39:59 +0000
Message-ID: <157142758885.6869.11882127817423670946.stgit@taos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0071.namprd12.prod.outlook.com
 (2603:10b6:802:20::42) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.78.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e71a6cc-1d88-4a6e-6399-08d75402f670
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR12MB1593:
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1593056B7933C53B493FFD6AFD6C0@DM5PR12MB1593.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(189003)(199004)(14454004)(25786009)(4744005)(26005)(86362001)(66446008)(186003)(8936002)(8676002)(81156014)(81166006)(71190400001)(71200400001)(478600001)(386003)(102836004)(52116002)(316002)(2501003)(99286004)(6506007)(54906003)(103116003)(66066001)(5660300002)(305945005)(3846002)(486006)(14444005)(256004)(2906002)(6486002)(15650500001)(476003)(6116002)(6916009)(4326008)(6512007)(9686003)(2351001)(64756008)(66556008)(66476007)(66946007)(33716001)(7736002)(6436002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1593;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 00Uw0RM0nU4LAxnb41mBwGev/FTu5q+up1IVGcLZc2Mrwp6h0JId687SF5L+ll3xzCkfVvLR/NLzAZ13LlEYnv6wygF5QlKw5hXYVP10f5DuQyBLE/M4lEAZxH+F3hvzxWFIc92jNuPOC6ki3/aydsrwFQfL+Cp5i4odUPQc+eeOzXf82SEHg7b9PBW3os80j3HYqq3j0TdGzdthIvrn2SY9CXp1o71ZaYoZAZA1LtH/fwL3qTxoH8JmRiozK3dLGGUl/ehNbuKghELZ+9PUvDAphQSAkSnNW+1HaQ+Omg7G0EN3wShdbR8Fl8fh+kqBLa9TCLQKbclDWBBnWz+yBPzGpQz2ge11rVQIoGW4bTzi/ZskbfmV1Wp1Hb02eJ7RefNgCubUid7HYwqQO2F6gDo9Cv+9YpKovA1CKBmzzrU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A66B36506312E04E8CB3B63FACB750AA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e71a6cc-1d88-4a6e-6399-08d75402f670
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:39:59.9292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kK0kxrb0KpZEBLIs7PMEmGxxaIhrYEYpR49AnrrNJG6aanHwMVqGoQdxNu94EWiM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1593
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This pair of patches is intended to clarify the messaging produced
by the CCP driver when known, but non-critical, problems arise. The
precipitating conditions can be determined based on simple, unalarming
messages in the system log.

---

Gary R Hook (2):
      crypto: ccp - Change a message to reflect status instead of failure
      crypto: ccp - Verify access to device registers before initializing


 drivers/crypto/ccp/ccp-dev-v5.c |   14 +++++++++++++-
 drivers/crypto/ccp/ccp-dev.c    |   15 ++++++++++++---
 drivers/crypto/ccp/psp-dev.c    |   18 ++++++++++++++++--
 3 files changed, 41 insertions(+), 6 deletions(-)

--

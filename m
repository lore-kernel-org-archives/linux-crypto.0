Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D321CA9EAF
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 23:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8FC21A4C
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 23:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="RPNYCooc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJXXL1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 19:11:27 -0400
Received: from mail-eopbgr790073.outbound.protection.outlook.com ([40.107.79.73]:47008
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbfJXXL1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 19:11:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chtC2yBTUDLmKc6T3raW1sqpBqM+bxMwt3ldv+1zUVT1deS3tdrBMrQxTxxU2AZ2U2D8bllLsGqQhu/+/swHRrNu9R+afc1WO6u/vWK89t2H64WVPsryhiPA+jjaG0AuQrXycx2v2pMbryK5UJ9WAtfW3naBqIjEvH9h67w/EtpPS4rERglINABuh+VulkOfVjowdDYSfJ9hnXxmewGMBqyxIFc1ESxwe5uUknrsy9r6VCJUULtXUmy44XzS1+vzs9yj9zP+siIDflIzwOb7KhDpB+qk0M6JRtUvBaShWo8emRW/61q39X+CbShfqTu9NZOgMgr9u5KmBnZBwuPM+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBDQ/Z9KQlgH8kjDB+GKAD429GQuIKdutd/216j3Zm8=;
 b=KWYX35R3z2CZe1o2hzuCSYxjPtzyZTmE0gnW1zefqkohXFKC2SzzSza0KbJbLWZ1B0Ovy30wS+HsP5dUFdv8FeYy2ZbC3yaY1wh3Yr9zoICBIzMPPNz+Ukvxh+XxhJgQcbRCHtAHQ9P2njwsE4kgCK47kTeor/BtauQUSkMwMIuobJdEEIymvAGkK78XN1S2+2o0Z9JPXcSrrwlBgGB70eYhslllHZ9fK+Fufp1r7GMt5ofSuCvaZiDRN7mc1B/nbopkdQcFShcyKNYzU7GDrAdQm7CvAxdtiIAbWEHC2NqazfFTmO6HJWyOn0T0lFPyGPYmteIt1mGp0i+RiUd7hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBDQ/Z9KQlgH8kjDB+GKAD429GQuIKdutd/216j3Zm8=;
 b=RPNYCoocWpCLWuo+5GBW35qVYvD6KE774zfoJPt5roygjRZ4Kj3MansK1EdhUfpGsghjYLsbYhf/GJp35eyPcgJnRl1cNvffXKBXQ856/oRfIOwS69jUPkycl07TfRqItoYPBkCV3BuBirCClo/HnfvJniXu63/pNOdXtmKwbT4=
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1468.namprd12.prod.outlook.com (10.172.40.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 24 Oct 2019 23:11:25 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::e0d2:a3e2:bf3d:a28f%6]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 23:11:25 +0000
From:   "Hook, Gary" <Gary.Hook@amd.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Crypto Larval
Thread-Topic: Crypto Larval
Thread-Index: AQHVisBbaC5rt3mfd068w747Np73Ig==
Date:   Thu, 24 Oct 2019 23:11:25 +0000
Message-ID: <474e3968-19d9-6fc2-5314-7fd7ca8d6491@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN6PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:805:16::48) To DM5PR12MB1449.namprd12.prod.outlook.com
 (2603:10b6:4:10::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98b2d453-6fac-4534-6920-08d758d77dd2
x-ms-traffictypediagnostic: DM5PR12MB1468:
x-microsoft-antispam-prvs: <DM5PR12MB14684FDCCD4690FE97E8E468FD6A0@DM5PR12MB1468.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(6916009)(99286004)(2501003)(6116002)(3846002)(14444005)(256004)(221733001)(66066001)(8936002)(81166006)(81156014)(316002)(7736002)(186003)(102836004)(26005)(31696002)(7116003)(386003)(6506007)(8676002)(52116002)(6512007)(5640700003)(71190400001)(2616005)(305945005)(486006)(66476007)(476003)(4744005)(66446008)(64756008)(86362001)(66556008)(71200400001)(6486002)(36756003)(31686004)(25786009)(478600001)(6436002)(2906002)(2351001)(5660300002)(3480700005)(14454004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1468;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0pNuaIBSyqjHq84r0U5MrzGRL1NtyfAgCixTyJEtsfgeX1O2mjCBYXDUiPQ41zwPbAnvhKFA7/XY/AJOG1vrAgiOnz8fV0WlJOQ8oWP5sKaYDNvYaoCMRdaxb7WtUAqQLU4xIwbP7doD0zTtsf9Q+284rvJBdcognIih6pd6O1gYtdvn+HaXzUWiGSOTExz5YgcWQriDSE+LVkUcbXGHhowNs3iZA5YSWmUSzbD3q928BOJ6J9y0y4lp9piBnod8R1+8xcfgdhiQ6sbJ7br5E8b/B98C10u98tA80saWZrlyAqStC3tOXqk3K5IxDguj3m3S90otCTh78V5ZXU5NtVPlV3IhtbDMWQIw0wY5EpbQ3/lh843Ck3MCS4HioROfvorNQAVdRJMEz/snK42x6LUmSEqMS08Qh3KM4OtN+mvt6ke5IIXVG2sqaCuRxgEn
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8B386328B7B764EA18A5D7FA51FB2C5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b2d453-6fac-4534-6920-08d758d77dd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 23:11:25.0677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A5osFBSZ4PfyX5JQsTCFaTA4hTuieFP/82m8XH6eVqT+YthHO+YJwj7Mjksl8TAr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1468
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SSdtIHRyeWluZyB0byB0cmFjayBkb3duIGFuIG9kZCBwcm9ibGVtIHdpdGggdmVyaWZpY2F0aW9u
IG9mIHRoZSBidWlsdGluIA0KY2VydHMuDQoNCkkgYmVsaWV2ZSB0aGF0IEkgbmVlZCB0byB1bmRl
cnN0YW5kIGhvdyB0aGUgY3J5cHRvIGxhcnZhbCBjb2RlIHdvcmtzIGluIA0KY3J5cHRvL2FwaS5j
LiBJcyB0aGVyZSBhbnkgcmVmZXJlbmNlIG1hdGVyaWFsIHRvIHNhaWQgZnVuY3Rpb24sIHRoYXQg
DQp3aWxsIGhlbHAgbWUgdW5kZXJzdGFuZCBob3cgaXQncyBpbnRlbmRlZCB0byB3b3JrLCBhbmQg
d2hhdCBvbmUgY2FuIGV4cGVjdD8NCg0KVGhlIHRvcC1sZXZlbCByb3V0aW5lIG9mIGludGVyZXN0
IGlzIGNyeXB0b19hbGdfbG9va3VwKCksIGFuZCB3aGF0IA0KaGFwcGVucyB1bmRlciB0aGF0Lg0K
DQpQb2ludGVycy9leHBsYW5hdGlvbnMgZ3JlYXRseSBhcHByZWNpYXRlZC4NCg0KZ3JoDQo=

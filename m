Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08523C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 12:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C66EC208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 12:50:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="xYgeZdru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfIJMuJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:50:09 -0400
Received: from mail-eopbgr800073.outbound.protection.outlook.com ([40.107.80.73]:11344
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729140AbfIJMuJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 08:50:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mA1G3QQ/xa8ylk75pMD1Z0eikBvnakXUOUwAL4DLe8S7CGrar2S9/+it8aOTpy/CzBp1mVVHRReUNf2bSiD710h1vTYkH48SgRjM/uBKkedVXarTomm9dSsIqImub/19ZByS3++mjuU2F7sU1/iXBhyNJQz6p+4YJSBoSU8cQxO1TS/aWzH4Ev3aoUzhY/pMIjsHsChF2/C2HF6WlirzopykH6wuMT1Khwa7bDAHNfHPQqN/TAi8tpN049SvkrKzzkPHxWOUisHfTBbw8xHhwmQ99XN1bDsnYXT8DPbaj+CTnIPqZDEenOnI43Scahonk9xcQ0FtP6UHTBhbkpRXjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LI0nbS7ux38BGubUFAH2NskX+LB4HEIAuxcKXY13Yfc=;
 b=SMlwDtV5CM0tnbxmXkrBGA/9ozAA+EkZcbZE9o5BV0+7Hgdkc3UiXnU1SrjdJWsp9iMydeCBQML5obNy5Ejgdj+qEM09UjKbKYRWb1HVAy8NkFHQrCWMUWiEQ0ibxe+Nesi+v7F6J8JhR1AhFRVuAIeYoamjLZE8vN3PAHU2FE8dQEugcK246RBMdDwqhfC8rYeFBh8xxq+CX6crqQIzXpKzBbGkPYVsF2BJ7e7o1Tg/EVwHfqtBe3IWgof9XD8BNdCBZEXfEq0plYjhhqV0/B3Eg/A/IasKCo3suGjQ8cmnjbeIZHpHMOz8GIBRJcp+nCCXLt4lf8cVSUtd6ZF7hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LI0nbS7ux38BGubUFAH2NskX+LB4HEIAuxcKXY13Yfc=;
 b=xYgeZdrubBcqoPlmAdJPgAQKiqbqvasWfaHUB+g9Uza4o5JtBKelf2kZeA8grd8YBB5BRia6fknNH2M5qFfdlsquhCW1XKoFWR+FB+8p3Ksy9PWOSLDG0mFv+MasuXrrmBJlrzCfoAW8TViAxx44s7TrMK8OTALAAjLJ28n+Mrs=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2320.namprd20.prod.outlook.com (20.179.145.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 12:50:05 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 12:50:04 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Interesting crypto manager behavior
Thread-Topic: Interesting crypto manager behavior
Thread-Index: AdVn1TV8jLDS1UVrTPOD3i+tUTHmBQ==
Date:   Tue, 10 Sep 2019 12:50:04 +0000
Message-ID: <MN2PR20MB2973C378D06E1694AE061983CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6896ca5c-cac3-4dce-9a75-08d735ed671b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2320;
x-ms-traffictypediagnostic: MN2PR20MB2320:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB23208529EAD61A0A89AFDFD2CAB60@MN2PR20MB2320.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(86362001)(81166006)(25786009)(476003)(2906002)(53936002)(5660300002)(186003)(15974865002)(71190400001)(76116006)(26005)(7696005)(66476007)(64756008)(66446008)(71200400001)(66946007)(66556008)(99286004)(102836004)(7736002)(54906003)(256004)(3480700005)(55016002)(2351001)(9686003)(74316002)(6916009)(14454004)(6116002)(305945005)(5640700003)(3846002)(6506007)(66066001)(498600001)(2501003)(6436002)(8676002)(52536014)(33656002)(4326008)(81156014)(8936002)(486006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2320;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2v75hIrhzSmctZAU8l/GC2jxBMzKJewXTdEOzo3QpnYQL7TYhh1PZPYVPMXmv0aaSxpSoB4agssf6yXL49KO2r0HDI9L+HuRai4nkH04hrAX06gZ6roZxpAPauRWhZ9yrtJvu4swGGUhkEMaEiDmWnyIueZNPpMqfTZZe3b/t4J/wYD/+ZfaYRhy65ccnYm9h4Vf5AcfWRzuP+uTtSd/zg8hCnRMSU52I+SWtJmY6tlzJUUBwF68ROj45VyAFvIfq/kKwkipcmRvjQb8J+o66ZNFrdOJQReE816DwgLOorvE4AemHzLYP18AY9+VZ4EKn4ADcNUnzHkGPNx5o+rDpNuY6SN6GlWf5XfpT9ZM0ExCrSjt9TIAWFHujqCQFudXveaxMwBUTBk1gPsllfnmJcbeM1aD4vjeUal4Sz3Nvdc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6896ca5c-cac3-4dce-9a75-08d735ed671b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 12:50:04.7279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J32zElyN6yb4J+VU2JlM68rAcuq1He31y6awbx6QwbnkmCQPPPrIhdoubcUxaXot4yZAhkE+eLJZchSH2L+X4xHKcI/8lIbXXgNxxbEnoLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2320
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert, Eric,

I noticed some interesting behavior from the crypto manager when=20
dealing with a fallback cipher situation.

I'm allocating a fallback (AEAD) cipher to handle some corner cases
my HW cannot handle, but I noticed that the fallback itself is being
tested when I allocate it (or so it seems) and if the fallback itself
fails on some testvector, it is not replaced by an alternative while
such an alternative should be available. So I have to fail my entire
init because the fallback could not be allocated.

i.e. while requesting a fallback for rfc7539(chacha20, poly1305), it
attempts rfc7539(safexcel-chacha20,poly1305-simd), which fails, but
it could still fall back to e.g. rfc7539(chacha20-simd, poly1305-simd),
which should work.

Actually, I really do not want the fallback to hit another algorithm
of my own driver. Is there some way to prevent that from happening?
(without actually referencing hard cra_driver_name's ...)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com


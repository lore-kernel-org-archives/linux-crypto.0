Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB2FC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4585D20657
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="dGu+fp3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfHBIzV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 04:55:21 -0400
Received: from mail-eopbgr740040.outbound.protection.outlook.com ([40.107.74.40]:9280
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728157AbfHBIzV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 04:55:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FF+vpLWVfzxQC+3AXpPVkW2UIei7JjoROhwvvGpBAvOVx2dyqYPSw5gV/CPoD4ie0HFNc5p66hcsMGV6dEJdDG8S1i1iHIsPgnytw3IitVWU7tfjjJch6vkEGZejJQPudNn72Yx3pxWnmfxd8vRjvrScBuaCB5KRMb6XLvfjKYO4SH1mNaprI+Y0ic2PkccI7oMHl7BrnRF8y4N7MrpoSvznP05VqsnPlOBzaw7dESL5FMn7g2Lg8C6KVmwC/nb6RhCXk0oabA4D9rtUUxsLgC/0+pXFRuO3gvpceZXQvaNaf3MojmKwBM/ZdK/xwjKV6xHPvhXi6yEG+ZNeacRh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRMxMFUDJGTxgdyUh0/BWHCW93fA/iogOnMoatrsHc4=;
 b=jkeHNCEI9nlFoiIt8moVLtWFtfofbwDLXVkF3I45JmHRjcGXksrQpFsm6nQxuqhPP1hcEvZo3HLlvG2qYK094QEj/6SxRdhlafBaRcG0mjPCjdTY5oOjQr0ahNvyafzZCnnzPrPBbb9nG/EUexSZDkYGQeSMwE+fmz5t/czu/Jv9YBblWtKGC81k1JYohVzg5h8opwl2gpS6QDbZFX+FvkuFdJNgfpxr9zrId9/aWG3qExpJ7xt3aUQ4qz88LvclQi0A6cot6phPtqBQf8NjiiA31GKvid01kI2NhF6f6058fLZxMprK1bNQDC39y31vKWcZUDntgiI7t43sC2q0dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nRMxMFUDJGTxgdyUh0/BWHCW93fA/iogOnMoatrsHc4=;
 b=dGu+fp3Fg1mAjzYPvTbz+KbbKOXF8UF9zeO6hWmelAohdAkqzK1Tbe9DNHS2fTgQc+BfMsidkkn2IDxZEAFCXbMGmyaQz8mFi08khBg6oDGfUT+EEqwj94uRsn/fsZovj35qzK5LmG3gBjGtBp+CfQ03kHNLdwe2f+K6sjBbg2w=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2334.namprd20.prod.outlook.com (20.179.145.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 08:55:17 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 08:55:17 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Need help with failling gcm_base(ctr,ghash-generic) selftest
Thread-Topic: Need help with failling gcm_base(ctr,ghash-generic) selftest
Thread-Index: AQHVSKFY6oVMoifWy0S5Dl262GlQMabm/nnwgABTtQCAABqIkA==
Date:   Fri, 2 Aug 2019 08:55:16 +0000
Message-ID: <MN2PR20MB2973F923FECCE73A0F74DBA1CAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190801194249.GA18705@Red>
 <MN2PR20MB297372F8FB158C59BF4F6F2FCAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190802051830.GA13677@Red>
In-Reply-To: <20190802051830.GA13677@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a87956e-ab0b-4216-c261-08d717272404
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2334;
x-ms-traffictypediagnostic: MN2PR20MB2334:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2334E62C44A6EA6735C2223FCAD90@MN2PR20MB2334.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(39840400004)(136003)(366004)(199004)(189003)(13464003)(7736002)(74316002)(305945005)(54906003)(229853002)(8676002)(316002)(6436002)(81156014)(14454004)(71190400001)(52536014)(6916009)(3846002)(256004)(68736007)(2906002)(71200400001)(33656002)(76176011)(66066001)(25786009)(8936002)(64756008)(5660300002)(66446008)(66946007)(6116002)(76116006)(53546011)(102836004)(6506007)(9686003)(66476007)(6246003)(66556008)(55016002)(81166006)(15974865002)(53936002)(486006)(446003)(7696005)(476003)(186003)(99286004)(11346002)(4326008)(26005)(478600001)(86362001)(41533002)(142933001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2334;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R++L5GitIqYnihUmhb9vYHvVdBMmFsjokI+pvADQKN+HH2XD4xVGilBN7iOIEB1dZZxTbwLnwcfECEec4Gh/RsPenvlX9TSI6j5iPunbXvmp+5YZNEwStc9mcrX/2o1WOeEr5ulP83MwIqOBEQvw4a7/mDc30mYdK9qlKPalvK/RiUQ4NDyKgLvFzpeeYYfEfvLOOIVJJgeUydNF1+y/V4fmrj/IY2Pqph37wjctKhOGY5nCaDHuhE/wa0vBgKX3S2m1MlQZt3DGTpp3gbhx0xx0xuVpaef1PR4/IxqRhJ4fQajuuTun8sNuQ+IRoGqTtfMCVyHvi4IAD+lUrQQo9GDMgtjShXMeZRVmK4bJq5FSokmGLlGmRhJW/zm8N8i4j9x/O2S3lTTZryKXeEn6Hiqi8VbSDhuECpLYTmG6I6A=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a87956e-ab0b-4216-c261-08d717272404
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 08:55:16.8271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2334
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> Sent: Friday, August 2, 2019 7:19 AM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: Need help with failling gcm_base(ctr,ghash-generic) selftest
>=20
> On Fri, Aug 02, 2019 at 12:24:04AM +0000, Pascal Van Leeuwen wrote:
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.ker=
nel.org> On
> Behalf Of
> > > Corentin Labbe
> > > Sent: Thursday, August 1, 2019 9:43 PM
> > > To: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Subject: Need help with failling gcm_base(ctr,ghash-generic) selftest
> > >
> > > Hello
> > >
> > > I am writing the Allwinner sun8i-ce driver and when running tcrypt I =
got
> > > [   30.201739] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) de=
cryption failed
> on test
> > > vector 3; expected_error=3D0, actual_error=3D-74, cfg=3D\"random: may=
_sleep use_digest
> > > src_divs=3D[100.0%@+2614] dst_divs=3D[5.90%@alignmask+3015, 60.56%@+3=
996, 17.92%@+865,
> > > 15.62%@+10]\"
> > > or
> > >
> > The decryption reports only an -EBADMSG here, which means the decryptio=
n itself went
> > fine, but the authentication tag mismatched.
> >
> >
> > > [  148.613537] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) en=
cryption test
> failed
> > > (wrong result) on test vector 2, cfg=3D\"random: may_sleep use_final
> src_divs=3D[100.0%@+0]
> > > iv_offset=3D20\"
> > >
> > Can't say for sure, but considering the decrypt error, this is most lik=
ely just a
> > mismatch on the appended authentication tag.
> >
> > > Since ctr-aes-sun8i-ce is passing the ctr(aes) selftest, I dont under=
stand what could
> be
> > > wrong.
> > >
> > That is possible, as this appears to be a problem with the authenticati=
on part,
> > not the encryption part. So possibly a problem with the way you setup t=
he
> > authentication key (which is actually derived from the encryption key, =
but I don't
> > know if your hardware does this autonomously, mine doesn't) and/or oper=
ation?
> >
>=20
> But since my driver is just a skcipher, I dont understand why I should ca=
re about any aead
> part, right ?
>
Ah, my bad ... your aes-ctr skcipher is being wrapped by the generic gcm_ba=
se
template here, I missed that detail ... wish I could help you further, but
I can't think of anything obvious that could cause this (decrypt fails on a=
uth
as I remarked earlier but only with a specific scatter buffer layout??).

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14245C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 00:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE36E2084C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 00:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="qwk2KhKz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731327AbfHBAYI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 20:24:08 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:9699
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729359AbfHBAYH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 20:24:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofqiR0aH5P7bQwt+EWwqX35PQiOQnr/q0MpNdzBCOo8V944/C3WjzFXAbWiorKxIKCV8FzKVt1uvpfiHilyHyC1p7/X+WWStsqGTY/q6iZR0UpmYMAoKeEfVYCVZs29I8Di0peMiqoUpKWzoWeOezJcQEISrd1QWT1wDXlQaZaUaf4AWZCFIUFtMwgafdxD78vwbq2bzIHAPuq5gZTSQAsLWtiUFF2xaPUCsVdswDVVxL/H4otDiWZlvD69rL575ir/4CH5o1tRQqXC0Uc+kMODbaviK9BBGEJtz6Tykxa9IONEhxwkZtSFGSxtkhohYmvMw3AX8vJauNPWWy/wSKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nwFhwPpZm/41poRA13bAhifEH9AncNH3+pNYzi3ED8=;
 b=PCRtWXiTdLWpViPslv+scHwx4XCzTlcJ7GTLNQFdgZw4+KtUoXnlHWRu9Yc+C56B31042M5kddGY5scqgJx1/WYwFN41yGrcx/umnz++sB+kByroH9Ktf1yopFmorQ1/8McwXsQYAsbU0MjtQpQ2ib4+kgU1Lf6xRBk3Xm5uBDOPesCGQePonNZleut5h9yZnY8b22kGWE3iucYEMzuXQ2hNl7pEQL0Qn4RU/5/uP2LVFoqrUZw+eCmcos4edn/spki2UsMZJFeqpTWqiCp4VnGvKMwYbs6f46VKbDlSrfk/XbCmS0jREmN45uRDI2DE1PNy+7xgLznBqZxiRv1Taw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nwFhwPpZm/41poRA13bAhifEH9AncNH3+pNYzi3ED8=;
 b=qwk2KhKzw573/Sgh2iMZy3c8BAnqgssbDKcyd0p2tvn86ZHkbiXXSvwdnLqBnpZR+mok/rhBYlRMfWLxvC3rm9eYDN656fpxO+n/sOmABenOPlF2xM0lLiOyNFHQBKWFjC8/QTwrjRbfv0dwgHN5vkeUbBIHmKaxqnNwrRn0tf4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3120.namprd20.prod.outlook.com (52.132.174.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Fri, 2 Aug 2019 00:24:04 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 00:24:04 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Need help with failling gcm_base(ctr,ghash-generic) selftest
Thread-Topic: Need help with failling gcm_base(ctr,ghash-generic) selftest
Thread-Index: AQHVSKFY6oVMoifWy0S5Dl262GlQMabm/nnw
Date:   Fri, 2 Aug 2019 00:24:04 +0000
Message-ID: <MN2PR20MB297372F8FB158C59BF4F6F2FCAD90@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <20190801194249.GA18705@Red>
In-Reply-To: <20190801194249.GA18705@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4384dd67-989a-4ef9-dca2-08d716dfb981
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3120;
x-ms-traffictypediagnostic: MN2PR20MB3120:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB3120F5BDFA1C78B40D3C9925CAD90@MN2PR20MB3120.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(366004)(136003)(376002)(13464003)(199004)(189003)(33656002)(68736007)(6436002)(476003)(2501003)(11346002)(446003)(9686003)(14454004)(486006)(55016002)(229853002)(478600001)(66066001)(2201001)(6116002)(71200400001)(71190400001)(2906002)(25786009)(3846002)(256004)(8676002)(7696005)(4326008)(86362001)(52536014)(15974865002)(316002)(66476007)(66946007)(66446008)(102836004)(5660300002)(6246003)(64756008)(186003)(81156014)(26005)(305945005)(66556008)(53936002)(7736002)(110136005)(81166006)(6506007)(99286004)(74316002)(53546011)(8936002)(76176011)(76116006)(41533002)(142933001)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3120;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IB7EpWyN2rgLSCNMR3gFfaSCK/OfpXQ9JBK1YimKioHbIQga+8o+joZGQ0o78/Ts7vdt7uO6RNG7HBnCQlt65UQxrPtMlyF95qw1gzknMx3whDZmTdhn+Y5tAq5rut39wI0jj+xYoWEOm6vEC9ExsuMKreZX2blr/Q/3+01Sh/lguRdNEstsvQM1IvCQn+/4vy1I6zKPs/UQ903a/HhZbrBGyAYzbh7VVaXW/8ykOPalVape9SrJpD06vLjkAyiHNh9Aec20q2aUdR6PQ6qJkCEO6jSu41T1KcAzePKgKt8ZVHyGAn/vgZhp1LMCBsKJvEGYihE+oNtkLDR5v1hehhv3Si9vv82kNGRgUQ7KSwwnk0NK408wYxdUYwMDqK/SXzy0zekOe2LF4IB/tzACIsLhUrw0e9T8vJSarDSx2IA=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4384dd67-989a-4ef9-dca2-08d716dfb981
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 00:24:04.0908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3120
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Corentin Labbe
> Sent: Thursday, August 1, 2019 9:43 PM
> To: herbert@gondor.apana.org.au; linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: Need help with failling gcm_base(ctr,ghash-generic) selftest
>=20
> Hello
>=20
> I am writing the Allwinner sun8i-ce driver and when running tcrypt I got
> [   30.201739] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) decryp=
tion failed on test
> vector 3; expected_error=3D0, actual_error=3D-74, cfg=3D\"random: may_sle=
ep use_digest
> src_divs=3D[100.0%@+2614] dst_divs=3D[5.90%@alignmask+3015, 60.56%@+3996,=
 17.92%@+865,
> 15.62%@+10]\"
> or
>
The decryption reports only an -EBADMSG here, which means the decryption it=
self went
fine, but the authentication tag mismatched.


> [  148.613537] alg: aead: gcm_base(ctr-aes-sun8i-ce,ghash-generic) encryp=
tion test failed
> (wrong result) on test vector 2, cfg=3D\"random: may_sleep use_final src_=
divs=3D[100.0%@+0]
> iv_offset=3D20\"
>=20
Can't say for sure, but considering the decrypt error, this is most likely =
just a
mismatch on the appended authentication tag.

> Since ctr-aes-sun8i-ce is passing the ctr(aes) selftest, I dont understan=
d what could be
> wrong.
>=20
That is possible, as this appears to be a problem with the authentication p=
art,
not the encryption part. So possibly a problem with the way you setup the=20
authentication key (which is actually derived from the encryption key, but =
I don't
know if your hardware does this autonomously, mine doesn't) and/or operatio=
n?

> Thanks
> Regards


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

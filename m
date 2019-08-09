Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7D4C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 09:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70DA52171F
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 09:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="JuyFVA31"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405567AbfHIJVj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 05:21:39 -0400
Received: from mail-eopbgr750045.outbound.protection.outlook.com ([40.107.75.45]:64516
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbfHIJVi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 05:21:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIQnruhs23Wyi2j+PRAFuvewp1svP4rBeHiKmMEDbYqqZzrvclx1OQmvfor2oW00fdND0pnkV4ay3KvTvi15lsFC3aKhU48AFiLE67mEvxOkd+hVrGMQRymzjhXtXa8uE+anWQnIW8JbdzHZTI3mflAAFfqJfS6Ggik89dCX7R/2TCUWUVqSjppevWo0VBSgctJW+VnAZ1RE1A/VdY3G7ivzGRikECsALJNhqVPjzhwkKDRm8O2ywnEoNZai7JEai1Y041zmHSDuXhc03urDmayzWYXecJGoXnxAVP1ibL3JN4vItbv3tGT9u+IPHMuMdTYKLWwZGDq5jGvXsWbTRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhC7Rgu+TJ3bzuYKy7vYSoSEMko7iUEnhLbAF+p5Y1I=;
 b=P2RwtcJ8553vk7guph7AMgA2oIy9Bkcive9dDtTUeiYvgSrvy048KiAFCottcME31V2YzuZSvePoubtHrR3cVW5MbZgtaEsr/hFycgxLP7Q38xgPo604AI+XiojACFKQmrEbaqgQVUo1vZb2JeI0W+ekaHVfO/uMhDvlJxET01HUlFech+uZNiQ2CJva10R40Y2JkH4dsKO5LjSNw3TNHS+35jL6uI+s381GfWFbz8BznKNvFobOO61WM9gbCyHupOWh8zYGRTI2QcG8gtMIXNadVk75gitnCyoOs029GYXysvyIGIR8VBpkaVE9MyQY+roAgX/NAYLv8LWfYdc+Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhC7Rgu+TJ3bzuYKy7vYSoSEMko7iUEnhLbAF+p5Y1I=;
 b=JuyFVA3163w1HQZFomEfk17q/qEBk4s0xnGXhWd4L7ciM4J83vOQddDHF7VR/sQhzZuQlpli1JrgksrFBgmCHOH2W5rJkRMH6+QcE2XaV/4IKOg2ReosTxMTLy+mCWoWRJYjpDUwUYUxumuaqSvjkq0AcYMyVecI6BJisLDh/Uo=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2269.namprd20.prod.outlook.com (20.179.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Fri, 9 Aug 2019 09:21:28 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 09:21:28 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH 2/2] crypto: inside-secure: This fixes a mistake in a
 comment for XTS
Thread-Topic: [PATCH 2/2] crypto: inside-secure: This fixes a mistake in a
 comment for XTS
Thread-Index: AQHVRuM6skknoBaEd0qfw7IJY2m3O6byU9MAgABFhYA=
Date:   Fri, 9 Aug 2019 09:21:28 +0000
Message-ID: <MN2PR20MB29732BBE23E130E3AEAB15F4CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564493232-30733-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190809051046.GA8571@gondor.apana.org.au>
In-Reply-To: <20190809051046.GA8571@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bc98acc-f0d3-4097-60d4-08d71caaf5b6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2269;
x-ms-traffictypediagnostic: MN2PR20MB2269:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB2269CC008FFE5E581A930870CAD60@MN2PR20MB2269.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(366004)(396003)(39850400004)(13464003)(189003)(199004)(55016002)(8676002)(6306002)(53936002)(316002)(66066001)(26005)(15974865002)(7736002)(14454004)(6116002)(3846002)(110136005)(6436002)(229853002)(9686003)(54906003)(102836004)(7696005)(66946007)(74316002)(5660300002)(76116006)(66476007)(66556008)(66446008)(64756008)(52536014)(53546011)(6506007)(478600001)(99286004)(186003)(76176011)(86362001)(966005)(305945005)(8936002)(2906002)(81156014)(81166006)(25786009)(33656002)(6246003)(4326008)(71200400001)(71190400001)(256004)(14444005)(486006)(476003)(446003)(11346002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2269;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PNjSkf6kh+pK2p0piTjlL/yNhviTRockC/USQW2oXohHla5XTOxeJPg7cefKnPhhB9/iZSWnnVm/o9cfiLgHHVtohzHDXyQ3lgqv4fVR+pf3Ufz4Qysn0QnzGBY8MaT2KHQig0f1oDKmVnREGYzIsbQiD1IGwbfQ5pBoY/Nf6Kny8cQEpxTr3PlKnVLJPv6m3zqBF0zTEvjLNwyJr3TFtu7OxJe+0Ar8Y1FAahbnIIWnW3UQts3yzZnn7co0nMf2EO7NLy1CNbKCfjSUhqqKRz4AYjNo1HqvG1tIUOm4SfVAKX1CQqhdZ58HmvkQHPN2hvyjtsNjcrwfbRMQ/qo7RMsVhcWCqL/uJM1hMUL6xDDw/9MSOh1jXb5xiaXVE0Y5eik7Zzyllo+kHMoZh2941cS07VXIkZAnWMh57GomJJo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc98acc-f0d3-4097-60d4-08d71caaf5b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 09:21:28.7343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HXMFBZfFfQX86D5eHwb7wsksjCkoU13hNfiN+9WdvfHXV0Ic1S7TV/WKxXv9qRvX9U/uJMzOENnulcHpOht6a7qelOO8ANmL9uWksJvkszo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2269
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Herbert Xu
> Sent: Friday, August 9, 2019 7:11 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; davem@davem=
loft.net; Pascal
> Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCH 2/2] crypto: inside-secure: This fixes a mistake in a=
 comment for XTS
>=20
> On Tue, Jul 30, 2019 at 03:27:12PM +0200, Pascal van Leeuwen wrote:
> > This fixes a copy-paste (and forgot to edit) mistake in a comment
> > for XTS regarding the key length specification.
> >
> > Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> > ---
> >  drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> This patch does not apply against cryptodev.  Please fold this
> into your XTS patch instead.
>=20
I already saw this coming ;-) And yes, I will fold it into the XTS patch.
But I'm waiting for some earlier patches to be applied so the patch will=20
actually apply without conflicts.

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt


Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com


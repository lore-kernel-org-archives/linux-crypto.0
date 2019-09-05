Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F67DC43331
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 14:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70159206A5
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 14:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="vlK+4Xx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfIEOHh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 10:07:37 -0400
Received: from mail-eopbgr790041.outbound.protection.outlook.com ([40.107.79.41]:31552
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbfIEOHh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 10:07:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbJu7+s8Wo5t2HxzI6A0NhE3nXExh8h8XtIx+dNHAlEgopR0QuEWWNRNXUJ6JAovKUfkon30rODsWj79FakSRiZNKo0uWhWYoStI+Z5kIVjw5M1hb9f2aLqljS/lZ7C72oX0CswfZE2S0YE2PMBwe5T8MOD/OD3YLp4Os9r8HCWX4Ogj8EBlXEJ8kN88JgjTVemDrbkX3ePybfeMlD841u3/1YheV0zbkLUacCxg//P7ljhkj6hdnI0chmus+p9FCADo3jQ3TpvPjo+hCPIbxcEU7Kx4kV4nlfe+I4OzMWRiXpxIIiR9N4I7bZGJpu5KJaO6xFdcR3Q8KkI0SmSa5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBvZlrVF4sVNMuD5185aYrIQzg5EfeSUk40zO/R3edE=;
 b=TkYUlPGHQJSJcB0zRGDcSbOaNYf01XVKvLKlYWz0nwdV7oqj45stFLsngsP0sTJASYKLH3/qa3x6oIb5uXU7EK7abPGvx5krXopZaoOZivMnndZM1pXJe8Tvu3XU7j/xB2CxEXeJ1MQPck3auHiKMiljlmNEFIwfE9YH/1k9d/eAYOP9A4+YIpyBPv92yx7qebUihGg6yhagJuul9x6Mjo7kd64hx0fqvvwrBYvtgQsTJrdiqLwCXqN8ubisGk+xvbx+E5luro6GX/it318Xvf+m+buYw6heLmsdYznOUV/oVf/Z3zGfyoxSykQGLFxfFaQuyWIArczQlmV1PfVPuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verimatrix.com; dmarc=pass action=none
 header.from=verimatrix.com; dkim=pass header.d=verimatrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBvZlrVF4sVNMuD5185aYrIQzg5EfeSUk40zO/R3edE=;
 b=vlK+4Xx+Y/4U7SoHe72HK0Oe5PDYGz+2sWMrCcxwjN4+qoTaeumED/7XyPoWNXxRzV4POdnLiQLb18E8FAE19iTVA+meYuo5Debk6VlZzK1uIeLXPQwsOyMzlCL4Dk3kw5FCBvKffxWBMS7gfTtDhYBk+y3qnuQDrKVK9YvW//o=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2638.namprd20.prod.outlook.com (20.178.251.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 14:07:33 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::6d07:5f09:97bf:c717%7]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 14:07:33 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - Fix unused variable warning when
 CONFIG_PCI=n
Thread-Topic: [PATCH] crypto: inside-secure - Fix unused variable warning when
 CONFIG_PCI=n
Thread-Index: AQHVY7gb6ppjCLb4NEeGzjBZPyb4pqcdDTiAgAAODOCAAAFwAIAAAizw
Date:   Thu, 5 Sep 2019 14:07:33 +0000
Message-ID: <MN2PR20MB2973814CBB4246226EC171F5CABB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1567663273-6652-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190905130337.GA31119@gondor.apana.org.au>
 <MN2PR20MB2973E751CAEA963B3C43110ECABB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190905135902.GA2312@gondor.apana.org.au>
In-Reply-To: <20190905135902.GA2312@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52e33259-71f1-4811-0a1d-08d7320a658e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR20MB2638;
x-ms-traffictypediagnostic: MN2PR20MB2638:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB26384DE07E7CC6D4DC0F9A15CABB0@MN2PR20MB2638.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(43544003)(52314003)(199004)(189003)(13464003)(102836004)(66556008)(66946007)(66476007)(64756008)(26005)(33656002)(14454004)(76116006)(53936002)(2906002)(66446008)(6916009)(9686003)(7696005)(3846002)(966005)(6116002)(6306002)(53546011)(6506007)(478600001)(66066001)(76176011)(8676002)(486006)(7736002)(54906003)(15974865002)(186003)(5660300002)(86362001)(476003)(8936002)(81156014)(305945005)(11346002)(52536014)(74316002)(446003)(55016002)(229853002)(14444005)(99286004)(256004)(25786009)(4326008)(71200400001)(71190400001)(81166006)(316002)(6436002)(6246003)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2638;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4ib1hoQClyc+YC2Gf7UD/0IkqS94TDa4uI/zqiagcNbVV5Hc2z+4y5fE/PHkPInclK0kGR7MjbIS7X1+Y8+PihY/IofmDFqUQ5MZdlYCBmauVuDCkCo53COdUF6jwvMqsuE7vUNDsgPhNfMZiJBJN48ROaZhCpLx/r5XQ5rPAnDazSqYywhmSAakZ4dUlFz5yYTQd/ghSsbrYnG3iLtH5oGrceIVMPeBeOIjbMz0l+P79nZbkyVf2B2FI2FxTYIbRODeLBCtJaIRTOC5+5weBpytd8N8f325TSyzD6sjBbd/sH/8S6pW90XnW7x5O01qh6ETq2inSK5VL9ysM223F/wRaPF25wSKY8kTPxCYocadJdN3O5mkdRzilhIi8IqQWMzne8G9XV4Txl7jcUq8fg6nkrEep+zeev30hmBMf6s=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e33259-71f1-4811-0a1d-08d7320a658e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 14:07:33.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrXsmzyvBGEmgFJhf/OsN6TdU1QwvMSEo8wqYmkwiChftZYSnHPfq9G3rMw8u/wXfHfvmxCTaZRgUpIrO53kR3OiiZyN5q4jd6l5yOzOud0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2638
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Thursday, September 5, 2019 3:59 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Pascal van Leeuwen <pascalvanl@gmail.com>; linux-crypto@vger.kernel.o=
rg;
> antoine.tenart@bootlin.com; davem@davemloft.net
> Subject: Re: [PATCH] crypto: inside-secure - Fix unused variable warning =
when
> CONFIG_PCI=3Dn
>=20
> On Thu, Sep 05, 2019 at 01:55:54PM +0000, Pascal Van Leeuwen wrote:
> >
> > > > index e12a2a3..0f1a9dc 100644
> > > > --- a/drivers/crypto/inside-secure/safexcel.c
> > > > +++ b/drivers/crypto/inside-secure/safexcel.c
> > > > @@ -1503,7 +1503,9 @@ void safexcel_pci_remove(struct pci_dev *pdev=
)
> > > >
> > > >  static int __init safexcel_init(void)
> > > >  {
> > > > +#if IS_ENABLED(CONFIG_PCI)
> > > >  	int rc;
> > > > +#endif
> > > >
> > > >  #if IS_ENABLED(CONFIG_OF)
> > > >  		/* Register platform driver */
> > >
> > > Shouldn't you check for errors for CONFIG_OF too?
> >
> > You are correct, the platform_driver_register can also return an error
> > code. So just fixing the compile warning was a bit short-sighted on my
> > behalf.
> >
> > I'll redo that patch.
>=20
> While you're at it, please fix the strange indentation in that
> function too.
>=20
Deja vu. I already did a while ago. Git rebase throwing in curve balls?
Anyway, I'll take care of it ...

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

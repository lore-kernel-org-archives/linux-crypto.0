Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238F3C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57452186A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 16:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="XuKgs7rW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfGSQC3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:02:29 -0400
Received: from mail-eopbgr740043.outbound.protection.outlook.com ([40.107.74.43]:9620
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727927AbfGSQC3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 12:02:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYgkNv/mJ/WNl2lwG6/VrpjQz9PrhEmiZuZur62Xw4OMOTdZU/yQlr4wYaZc9/tuqvJS2jmrmiiaP9rioO+wGjX6FpJeRHQhzFMUmj1btGKjmNx+rGyCsu3fwHqzKSxJgF6SSfRdAkLtzp6P4qO4W5+uRnHZsS+i7RPnae1af19UVf7VkUWZqrwOGPPt8al2FKPJg6lRptDQBDK3/owqGI/0/D0NMWQDZv86tP46/VUsYlF1zbQlIyT8+XgYEtyKpxjZE1ic7j1Pj7ioD3O5Pjk/TKr5y2P5zHPEMmcZT7/4RzuX2DKy5pMj/o/mrKo94RMS4Zt3O4vABfNw4BXpVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gk2tbZhirQO0a6rxz4TE9Tg0/RrfVLIjukkt1flYpXU=;
 b=Y7rdeWQ5pY77GNHvRlJ6211y084zmCGnyZ5onYBMDhZrH/aSOwi+duKAGj++G5wgnXjP+BDp5fCWAnpigqsGK2q1W+AiT/LZ90gQrWJflX86G34Nz7Cl0VzvJOdVGeWNnQNq165Td81zV10dzf6sCd05xaDK7JlD5tQKWyV+myqNzk+MS/fEPGEOa1XW2JE1FKfLpYa7ndA887NPEV89HlRr66z4UdOlpIi6uaPeSGw11Ds6ayKK9VpNd9y5GzC+t83MlayOjFK5zh1X63EhqQ9iYT4h2k4rJHpQtH0nxRGB0N5/Xmp92NHR+LgcOLAQwgyxjPNULcckHw8VEjipFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gk2tbZhirQO0a6rxz4TE9Tg0/RrfVLIjukkt1flYpXU=;
 b=XuKgs7rW8t3zrO/iu7aDUspADwPlVlGKwZ2D+JwbX0Lgd9Z8q1Kk6n9HcWkLNufdXp76ZfdDoGvPrflhd1AUsxi/get7kqwdvm3uS6viqKMcFm36/QwJc6akQBIA8VR6Aa3mhV8/TlcGdmIXEuBT/ruF1OzON2zoNhselOnCPMw=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB3102.namprd20.prod.outlook.com (52.132.174.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Fri, 19 Jul 2019 16:02:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2094.013; Fri, 19 Jul 2019
 16:02:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: generic ahash question
Thread-Topic: generic ahash question
Thread-Index: AdU+Pz/3ICV8h5GxTo+QH6d8mlFU5QAAxyoAAAIdQDA=
Date:   Fri, 19 Jul 2019 16:02:26 +0000
Message-ID: <MN2PR20MB2973C7FF454BB906A8181DA4CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <MN2PR20MB297347B80C7E3DCD19127B05CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719145802.lo7te2shj76trin6@gondor.apana.org.au>
In-Reply-To: <20190719145802.lo7te2shj76trin6@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79e90f33-cde4-4e17-7205-08d70c627eba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB3102;
x-ms-traffictypediagnostic: MN2PR20MB3102:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <MN2PR20MB3102FD4259530CB3C4ABF1EBCACB0@MN2PR20MB3102.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(39850400004)(346002)(199004)(189003)(13464003)(256004)(14454004)(102836004)(76176011)(53546011)(6506007)(71190400001)(68736007)(71200400001)(305945005)(25786009)(14444005)(7736002)(74316002)(6436002)(66946007)(64756008)(76116006)(66446008)(7116003)(3480700005)(66476007)(476003)(8936002)(66556008)(2906002)(6916009)(11346002)(446003)(86362001)(229853002)(26005)(7696005)(15974865002)(8676002)(186003)(81156014)(81166006)(3846002)(5660300002)(6116002)(33656002)(6246003)(54906003)(9686003)(55016002)(4326008)(478600001)(99286004)(316002)(6306002)(66066001)(966005)(486006)(52536014)(53936002)(41533002)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB3102;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2BfXf4OIJtv/gQv8sca7QRPwbA9Fv3N0lrau9QRpfcjM1m6vvRvGovv/0wA/C5lzeC3C5wYF+S4X0XItwpISNnAIXB0ErUHBUiU0RqdZGYtj0JMyf1YouDTlxI4i7m87fBcdzPPQBS8BFJGWiahRn1WWS1bwxfsnTBOVG09mdtsmY+/LcurdLIzBrvZ44p6+Sxd4xymamiFGMXnkM2Q6zUp6rsnl8/EP89aPkmuDYeiFunJOVfPvgJrePOcoeQ697kaylasa8KF5zYdRn5ddbT7Ci1S7023dgv9IDrbUJCKN/ARoEBC7diy9GJ5fSKK0ODz64mSajYtBLvYzi5wazN16APTRDJtc3pLpr8rrSGF/jNIc3b98lZn/NLlbYt+dlXOtCBFgrSngdKvXUZXQ0y6/AP8GvSz7iwgZe7ACFLQ=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e90f33-cde4-4e17-7205-08d70c627eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 16:02:26.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3102
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of Herbert Xu
> Sent: Friday, July 19, 2019 4:58 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: linux-crypto@vger.kernel.org; David S. Miller <davem@davemloft.net>
> Subject: Re: generic ahash question
>=20
> On Fri, Jul 19, 2019 at 02:41:03PM +0000, Pascal Van Leeuwen wrote:
> >
> > So I'm guessing there must be some flags that I can set to indicate I'm=
 not supporting seperate
> > init/update/final calls so that testmgr skips those specific tests? Whi=
ch flag(s) do I need to set?
>=20
> All implementations must support all of these calls.  If your
> hardware cannot produce non-finalised output, then what you need
> to do is use a fallback for init/update and then implement final,
> finup and digest.  If your hardware can't even accept non-finalised
> input, then you will need to use a fallback for everything but
> digest.
>=20
Thanks, that was sort of the answer I was fearing :-)
So I guess I'll opt for door number 3 for now: don't advertise the algorith=
m unless
someone comes with a very solid use case for accelerating it ...

> Since IPsec uses the digest call it would still be able to benefit.
>=20
For IPsec I don't need the standalone MACs anyway since I also advertise th=
e
combined AEAD constructs which are far more efficient to use on our HW.

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

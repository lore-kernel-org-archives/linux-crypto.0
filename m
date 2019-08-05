Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB162C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99ABF2086D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 09:48:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="nngg+PT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfHEJsQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:48:16 -0400
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:60338
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbfHEJsQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 05:48:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrRXi3OWLk1QvKYOgoGZELnI3xyG5FLbHFE029HXvwbZiWG2jLCxvKqcxPXrV9JSGQVcrpv+rNtvemzblXfS3R519ug42iYNOaTK5IUdukfAT6JcDly2jjh2KinrrGQ157cNzpuJySKY/UEKpiQK9Kj/ysyY8Vt067RwugroTK5gt/rUpuiOA2JiJlzN1P2FWy1W8rqCpS/j64+qDDyJrwXNrSI1JQjTQ7PNsMtlK3mT3ahq6xNhCS8XamP8HadIvEiTrLSXHB1SqFK8i8hncP/K8nIxafLTiRCXNpJJUV3+5wsnFzNGMqHksalEh12LBS01EgiRwUSzdgGJUc6BIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRDSnXIosacBpxj9sPxGVkGctcrMh/Q48eYQ8aDEtR8=;
 b=jyfXAVOIe2sAl/GjPNp0w1Sp1Q0Ell1GE8hpEns66Sq9MyYmnIBj2jYlFvpwP/xGi2o5PA0EH9CQebqLbBftiXNpGfTn2qZFHVh2/OTPnfri/U71+EJrJTE/6HK5cv43Kme04tOSXfk5SquMwob1HHCPasO9dkjFwNkU4/DukfjT298aQn3rinmOCzoIzpv7JmzntOLGwzPtSHZVcptcvx1JMnBoiJ3ugTKFfJzdaetxdg0lIguBWJEqG7Sj7mjFtaHfgm7cchA4omwhuGIrbnrd0ZW6QOHOx7RZ0QmDaI3bX2UN80NwIRqpfFzX6jH0vZnX0i8dO0gWtAYjgboMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=verimatrix.com;dmarc=pass action=none
 header.from=verimatrix.com;dkim=pass header.d=verimatrix.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRDSnXIosacBpxj9sPxGVkGctcrMh/Q48eYQ8aDEtR8=;
 b=nngg+PT4i4/rspjbBtJnbUZpO+0X4oLCGiZJcB+ih9G2g24oybW1HjO2dAyUyim90MKeAD/Cd6x+aFdLtxN5hPMCntZwVy22m5C99RK4dpJ9G+AQUs6FKwJjWU77VKqIk+COM71uVRKLFnmmZMmSJAvuVqMphuPuUU1QJetkvs4=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2368.namprd20.prod.outlook.com (20.179.144.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.13; Mon, 5 Aug 2019 09:48:13 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::d96f:39b2:19f4:c7c1%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 09:48:13 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Topic: [PATCHv3 4/4] crypto: inside-secure - add support for using the
 EIP197 without vendor firmware
Thread-Index: AQHVR7116MJ9FzpBkkuhb1mvd6XCi6bsSuqAgAADriA=
Date:   Mon, 5 Aug 2019 09:48:13 +0000
Message-ID: <MN2PR20MB29730648846013A67753624ECADA0@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190805090725.GH14470@kwain>
In-Reply-To: <20190805090725.GH14470@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bca94b5e-eef1-4ee8-6197-08d7198a0878
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2368;
x-ms-traffictypediagnostic: MN2PR20MB2368:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <MN2PR20MB23683112815CA9105D4A5737CADA0@MN2PR20MB2368.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39840400004)(346002)(396003)(136003)(376002)(189003)(199004)(13464003)(14454004)(316002)(110136005)(476003)(3846002)(2906002)(186003)(8936002)(6116002)(66574012)(11346002)(74316002)(99286004)(68736007)(446003)(6436002)(54906003)(478600001)(53936002)(6506007)(4326008)(26005)(229853002)(305945005)(102836004)(66066001)(486006)(966005)(66556008)(6246003)(64756008)(25786009)(14444005)(5660300002)(76116006)(53546011)(9686003)(6306002)(71200400001)(71190400001)(7736002)(86362001)(52536014)(33656002)(7696005)(15974865002)(81156014)(66476007)(55016002)(256004)(8676002)(76176011)(66446008)(66946007)(81166006)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2368;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8EJFxtq2yiWShFOFkFHn19KjScDxB/HdTzjVzpllNcUQlQx/vQDPh8I6YPfzl93t6/zr973heqbh0j+Gb4XBelATOk9JzbVgz3O1ybAQBiY6f8a4xM1JHRhBPjbJF6LrvLuJUclnSxN5MLa+YB2bNd76WnAS8VQ5JyrQqJ1TBrC8Arrpwf7ANsBvM/d08+PfhkUApkW62eLWv6scORe+u8KpbjoZAlchJag2RdU7K/302JgYKRW5UwIy4TP4HdWHm5Nx8YxNl17ujsAv/7sDG6MRyWfRkEmY5pCmZUyyBv6uDXYFDknb9kvPmOv6JGsp2NHUvY53vxeqRiD2gc7fVwO0AzL6QJNO77gEYNhy57fgUMoNCANG0l+9Pn7GmavsegjZMYLUUqkYn0OBiUfxKial9/mET0y/OXPzjRKMYK8=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca94b5e-eef1-4ee8-6197-08d7198a0878
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 09:48:13.3233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2368
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.=
org> On Behalf Of
> Antoine Tenart
> Sent: Monday, August 5, 2019 11:07 AM
> To: Pascal van Leeuwen <pascalvanl@gmail.com>
> Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gon=
dor.apana.org.au;
> davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Subject: Re: [PATCHv3 4/4] crypto: inside-secure - add support for using =
the EIP197
> without vendor firmware
>=20
> Hi Pascal,
>=20
> Just a small comment below,
>=20
> On Wed, Jul 31, 2019 at 05:29:19PM +0200, Pascal van Leeuwen wrote:
> >
> > -	/* Release engine from reset */
> > -	val =3D readl(EIP197_PE(priv) + ctrl);
> > -	val &=3D ~EIP197_PE_ICE_x_CTRL_SW_RESET;
> > -	writel(val, EIP197_PE(priv) + ctrl);
> > +	for (pe =3D 0; pe < priv->config.pes; pe++) {
> > +		base =3D EIP197_PE_ICE_SCRATCH_RAM(pe);
> > +		pollcnt =3D EIP197_FW_START_POLLCNT;
> > +		while (pollcnt &&
> > +		       (readl_relaxed(EIP197_PE(priv) + base +
> > +			      pollofs) !=3D 1)) {
> > +			pollcnt--;
>=20
> You might want to use readl_relaxed_poll_timeout() here, instead of a
> busy polling.
>
Didn't know such a thing existed, but I also wonder how appropriate it
is in this case, condering it measures in whole microseconds, while the=20
response time I'm expecting here is in the order of a few dozen nano-
seconds internally ... i.e. 1 microsecond is already a *huge* overkill.

The current implementation runs that loop for only 16 iterations which
should be both more than sufficient (it probably could be reduced=20
further, I picked 16 rather arbitrarily) and at the same time take so
few cycles on the CPU that I doubt it is worthwhile to reschedule/
preempt/whatever?

>=20
> Thanks,
> Antoine
>=20
> --
> Antoine T=E9nart, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com

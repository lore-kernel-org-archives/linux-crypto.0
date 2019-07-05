Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68F3C4649B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7904821738
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 14:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=verimatrix.com header.i=@verimatrix.com header.b="g9G1StCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfGEOy3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:54:29 -0400
Received: from mail-eopbgr810047.outbound.protection.outlook.com ([40.107.81.47]:64240
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbfGEOy3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 10:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verimatrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCHun4pX5QqkIcp+zjGc0IkrNeGvxPZrGVOUn3e4Gp0=;
 b=g9G1StCUCa5FhDf9zNykXxx9a7x6g+gR3XbG7viWKK3PxHLMPgKLrdba+rCMC0+7Iym7DJXq3bs7BpRE9C78TRtlD6W8CgAB6NJ3OWGOWxE9eyLnjwEjmfsP3javbu8PALrMObbKtV+zwiNXd9YLtT0X890nC1YvHD0eX1u571w=
Received: from MN2PR20MB2973.namprd20.prod.outlook.com (52.132.172.146) by
 MN2PR20MB2351.namprd20.prod.outlook.com (20.179.145.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Fri, 5 Jul 2019 14:54:26 +0000
Received: from MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69]) by MN2PR20MB2973.namprd20.prod.outlook.com
 ([fe80::68d7:2bbb:af61:2e69%6]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 14:54:26 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH] crypto: inside-secure - remove unused struct entry
Thread-Topic: [PATCH] crypto: inside-secure - remove unused struct entry
Thread-Index: AQHVMxLQ7vPFXQM6xUS4XzVd0Ihqpqa8EsAAgAADdmCAAAKYAIAAAUlg
Date:   Fri, 5 Jul 2019 14:54:25 +0000
Message-ID: <MN2PR20MB2973273C7446FC1CF6CA9903CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
References: <1562314645-22949-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190705141800.GE3926@kwain>
 <MN2PR20MB297394029C591248FA258760CAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190705143940.GG3926@kwain>
In-Reply-To: <20190705143940.GG3926@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@verimatrix.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd37c16d-f29c-45e9-a488-08d70158aca8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR20MB2351;
x-ms-traffictypediagnostic: MN2PR20MB2351:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MN2PR20MB2351EDF139F979AF128E9CA7CAF50@MN2PR20MB2351.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39850400004)(346002)(376002)(13464003)(199004)(189003)(54906003)(316002)(33656002)(71200400001)(53936002)(305945005)(6246003)(74316002)(66066001)(2906002)(229853002)(6436002)(71190400001)(55016002)(11346002)(446003)(7736002)(9686003)(4326008)(8676002)(15974865002)(476003)(486006)(66946007)(3846002)(6116002)(76116006)(99286004)(6916009)(64756008)(14444005)(66446008)(26005)(478600001)(76176011)(68736007)(73956011)(53546011)(6506007)(256004)(66556008)(7696005)(102836004)(81166006)(81156014)(14454004)(86362001)(5660300002)(8936002)(66476007)(25786009)(186003)(52536014)(18886075002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR20MB2351;H:MN2PR20MB2973.namprd20.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: verimatrix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nPP4pbKuTBcVJW0Dg158AB5EDRdI22uYkslSxfA7iGXVGPVFAPab1v5aG1QSPn9YZTr/C2t+RNs+c8c1r0BcTHxz9SxktKdUsnh6mAagv81jvr9/maJmAhG5prOukJcA+b2bBeRRbZ+FruigoIK+3nj2TAdverz8UZv4dhLQ8u+hPZSYDHEiJXdtzP99R22gcR9T9YCndm03/mpVrGbxVu+ASRJX/0JZwEdvd1CTo2tbdOGNNL86SjQP4GWozJL81xk32DbajJY66JHKkrM9zzZ1BK50jbNwY6eop68YvPTDWD1uNlEEouI6zIcPAU1Prp70U5p1vOiSElBgX4Fmrwvmj0oiUmUXz2syEZhmZ60jLAyseOp2O7z0sDKY/WN9nzBV1dMmUft5IHiz6UgHVonze9HkyXkHlCf+UAe+RJM=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: verimatrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd37c16d-f29c-45e9-a488-08d70158aca8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 14:54:26.0068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dcb260f9-022d-4495-8602-eae51035a0d0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@verimatrix.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2351
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org




> -----Original Message-----
> From: Antoine Tenart <antoine.tenart@bootlin.com>
> Sent: Friday, July 5, 2019 4:40 PM
> To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pasc=
alvanl@gmail.com>; linux-crypto@vger.kernel.org;
> herbert@gondor.apana.org.au; davem@davemloft.net
> Subject: Re: [PATCH] crypto: inside-secure - remove unused struct entry
>=20
> On Fri, Jul 05, 2019 at 02:32:46PM +0000, Pascal Van Leeuwen wrote:
> > > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > >
> > > You should wait for either those patches to be merged (or directly
> > > integrate this change in a newer version of those patches), or send t=
his
> > > patch in the same series. Otherwise it's problematic as you do not kn=
ow
> > > which patches will be applied first.
> >
> > This patch indeed depends on earlier patches. I was just assuming
> > people to be smart enough to apply the patches in the correct order :-)
>=20
> It's actually very difficult for a maintainer to remember this,
> especially when he has to deal with plenty of patches from many
> contributors. And some series can take time to be merged while others
> can be accepted easily, so it's hard to keep track of dependencies :)
>=20
That's an interesting point though, as dependencies between more=20
complex/larger patches are rather unavoidable ...

So how should you handle that? Do you need to wait for the previous
patches to be accepted before submitting the next ones? Thats seems
rather inefficient as I could already be getting some (low-hanging fruit)
feedback on the next patchset that I can already work on while waiting=20
for the previous patchset(s) to go through the process.

I'm a hardware guy. We pipeline stuff by default :-)

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
www.insidesecure.com


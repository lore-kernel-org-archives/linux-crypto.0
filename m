Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B89EC46470
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E5E20868
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 06:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="WLR6SJnQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388985AbfEXGua (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 02:50:30 -0400
Received: from mail-eopbgr690065.outbound.protection.outlook.com ([40.107.69.65]:5550
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388897AbfEXGua (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 02:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SPJBlQgqp9ZQIH4CMnVK6tleeQfxUvzNPpuE6U7Ib0=;
 b=WLR6SJnQ7rCCfnpEo3mGB3U9KnGB63pEQeBMHwe6w7oGkYPrQqvDYKlBz7MpA/FIL6Q+AWQ6uu90gBtNMICiS9yKWd/Y5yl4REzjgzshTF67L7nEqrkdKu+uayPiUFtGxJu6elJnzlYtx5jDdns100LqmGTPYrnT2wYSFI1SdpU=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.26.153) by
 BN7PR02MB5300.namprd02.prod.outlook.com (20.176.176.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 06:50:25 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::4155:72d9:c5a:70ef]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::4155:72d9:c5a:70ef%7]) with mapi id 15.20.1922.018; Fri, 24 May 2019
 06:50:25 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Stephan Mueller <smueller@chronox.de>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sarat Chand Savitala <saratcha@xilinx.com>
Subject: RE: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Topic: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Index: AQHUrjLRC0KQY4vUUEiutylzuXEA7qWzVM+AgJUjQyCAA8MlgIAVaNiQgBj4rpA=
Date:   Fri, 24 May 2019 06:50:25 +0000
Message-ID: <BN7PR02MB5124B0CB55A5B86D35752240AF020@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
 <4735882.YQOrfzxm5S@tauon.chronox.de>
 <BN7PR02MB5124AC0C75B15E5FB66DF2B6AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
 <18759853.IUaQuE38eh@tauon.chronox.de>
 <SN6PR02MB5135CE53C3E3FB34CA5E6BA8AF320@SN6PR02MB5135.namprd02.prod.outlook.com>
In-Reply-To: <SN6PR02MB5135CE53C3E3FB34CA5E6BA8AF320@SN6PR02MB5135.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 328d49e7-7a1e-4876-baea-08d6e01419d6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN7PR02MB5300;
x-ms-traffictypediagnostic: BN7PR02MB5300:
x-microsoft-antispam-prvs: <BN7PR02MB53003B022799292E1636A1C2AF020@BN7PR02MB5300.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(366004)(346002)(136003)(396003)(13464003)(199004)(189003)(478600001)(186003)(9686003)(256004)(76176011)(11346002)(476003)(486006)(52536014)(446003)(7696005)(102836004)(26005)(74316002)(55016002)(14454004)(14444005)(110136005)(4326008)(107886003)(71190400001)(71200400001)(53936002)(66446008)(229853002)(76116006)(33656002)(66946007)(66476007)(6436002)(6246003)(73956011)(66556008)(64756008)(6506007)(25786009)(2201001)(53546011)(86362001)(66066001)(8936002)(8676002)(2501003)(2906002)(81156014)(81166006)(316002)(7736002)(305945005)(5660300002)(6116002)(3846002)(68736007)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5300;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MaixsdFDt9lz1vFBVWgEnGF2BXdTRvm9HkDoaOa8K3iT20PmH1pJKikYI934sn1Z1ujDPqUCnyiBk/xFExAm4oATjw5BQF2bDLxmFIkEh0hvhhRQHBBgXggSeTmrRBFk04Ri6g5D3XFLppHFMFa0/h3o+hnr3pahk2FxDQQG0qhuyjSCfCyIC1mpMKZrcdahhFCYWSxzZQS/5j+WUdSFX9cAUMxDGUtKOubPZ7+5IFEsEHnd/WBPrs6Er2ZJLoR3/X/2xHiKA3SI6yxMGgR3p5In3DdvsD90d6ZIMgm1RHt9EAJmcQ6EvoyGkhF/Me9r8jvlQ+sjNZuB/EH7CQRlBeNRVQ78nwTGuWtENoCHA2R0dMYdBFxgJu83HmMmO377+HBzjF6wD2Di0Y/niUmgreUc9feVCcjDX544M3lkWTA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328d49e7-7a1e-4876-baea-08d6e01419d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 06:50:25.4955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kalyania@xilinx.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5300
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ping!!

> -----Original Message-----
> From: Kalyani Akula
> Sent: Wednesday, May 8, 2019 3:01 PM
> To: Stephan Mueller <smueller@chronox.de>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Sarat Chand Savital=
a
> <saratcha@xilinx.com>
> Subject: RE: [RFC PATCH 4/5] crypto: Adds user space interface for
> ALG_SET_KEY_TYPE
>=20
> Hi Stephan,
>=20
> Keyrings is in-kernel key-management and retention facility. User can use=
 it to
> manage keys used for applications.
>=20
> Xilinx cryptographic hardware has a mechanism to store keys in its intern=
al
> hardware and do not have mechanism to read it back due to security reason=
s.
> It stores key internally in different forms like simple key, key encrypte=
d with
> unique hardware DNA, key encrypted with hardware family key, key stored i=
n
> eFUSEs/BBRAM etc.
> Based on security level expected, user can select one of the key for AES
> operation. Since AES hardware internally has access to these keys, user d=
o not
> require to provide key to hardware, but need to tell which internal hardw=
are key
> user application like to use for AES operation.
>=20
> Basic need is to pass information to AES hardware about which internal
> hardware key to be used for AES operation.
>=20
> I agree that from general use case perspective we are not selecting key t=
ype but
> selecting internal hardware keys provided by user.
> How about providing option to select custom hardware keys provided by
> hardware (AES_SEL_HW_KEY)?
>=20
> Thanks
> kalyani
>=20
> > -----Original Message-----
> > From: Stephan Mueller <smueller@chronox.de>
> > Sent: Thursday, April 25, 2019 12:01 AM
> > To: Kalyani Akula <kalyania@xilinx.com>
> > Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> > crypto@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [RFC PATCH 4/5] crypto: Adds user space interface for
> > ALG_SET_KEY_TYPE
> >
> > Am Montag, 22. April 2019, 11:17:55 CEST schrieb Kalyani Akula:
> >
> > Hi Kalyani,
> >
> > > > Besides, seem to be more a key handling issue. Wouldn't it make
> > > > sense to rather have such issue solved with key rings than in the
> > > > kernel crypto API?
> > >
> > > [kalyani] Can you please elaborate on this further ?
> >
> > The kernel has a keyring support in security/keys which has a user
> > space interface with keyutils. That interface is commonly used for any
> > sort of key manipulation.
> >
> > Ciao
> > Stephan
> >


Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FD0C282E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 09:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC6B20674
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 09:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="ZSdJHnz/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbfDVJSC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 05:18:02 -0400
Received: from mail-eopbgr700065.outbound.protection.outlook.com ([40.107.70.65]:60195
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726724AbfDVJSC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 05:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0da4zLEbnUEpwPyC3syt7+VkVPZBGg4DglIAousTk0=;
 b=ZSdJHnz/u7zyuY5N/UpbDebIi+gR6Y4Kt49ag9ip/10qKyHSBphF4WYg0ZjFYxLCOhbUgNwjgSGI0J1Z5j4+UTH1jt7UjrupgM1hFvVw5nuj167ZB/TCXElz+h8jlbE5qxFIKM3h7m2i+FA8gZRB1P5EyUVdO5j5K9gkyiamT+0=
Received: from BN7PR02MB5124.namprd02.prod.outlook.com (20.176.26.153) by
 BN7PR02MB5250.namprd02.prod.outlook.com (20.176.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.14; Mon, 22 Apr 2019 09:17:55 +0000
Received: from BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::fc20:6339:ab53:378e]) by BN7PR02MB5124.namprd02.prod.outlook.com
 ([fe80::fc20:6339:ab53:378e%2]) with mapi id 15.20.1813.017; Mon, 22 Apr 2019
 09:17:55 +0000
From:   Kalyani Akula <kalyania@xilinx.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Topic: [RFC PATCH 4/5] crypto: Adds user space interface for
 ALG_SET_KEY_TYPE
Thread-Index: AQHUrjLRC0KQY4vUUEiutylzuXEA7qWzVM+AgJUjQyA=
Date:   Mon, 22 Apr 2019 09:17:55 +0000
Message-ID: <BN7PR02MB5124AC0C75B15E5FB66DF2B6AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
 <1547708541-23730-5-git-send-email-kalyani.akula@xilinx.com>
 <4735882.YQOrfzxm5S@tauon.chronox.de>
In-Reply-To: <4735882.YQOrfzxm5S@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kalyania@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b62a2f20-8cb3-4f95-3865-08d6c7036796
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:BN7PR02MB5250;
x-ms-traffictypediagnostic: BN7PR02MB5250:
x-microsoft-antispam-prvs: <BN7PR02MB52504DDC11E340152FC9D543AF220@BN7PR02MB5250.namprd02.prod.outlook.com>
x-forefront-prvs: 00159D1518
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(39860400002)(346002)(376002)(189003)(199004)(13464003)(33656002)(66066001)(6916009)(7696005)(229853002)(6436002)(6116002)(3846002)(97736004)(2906002)(478600001)(14454004)(305945005)(14444005)(66446008)(74316002)(66476007)(71200400001)(71190400001)(9686003)(256004)(26005)(6506007)(186003)(53546011)(8936002)(81156014)(8676002)(81166006)(102836004)(68736007)(64756008)(66946007)(476003)(66556008)(53936002)(86362001)(76176011)(25786009)(316002)(4326008)(54906003)(5660300002)(99286004)(6246003)(52536014)(486006)(73956011)(11346002)(446003)(55016002)(76116006)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5250;H:BN7PR02MB5124.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uzTaSN8PIYBhCp1dwQk4+fYOMI+VVvrjqs6ouyVKykNNUCCQByJYgd9QMv/JexJg9u5vWh67YIHqojB1w8g8DKOUa93AmucPjq5QD5vcxMeaCp7SAZXvo4Mw7WSDG4uK5UMXTJ+uYla5mZicIoY+dUEWly8cMynXejRNbgdueopZelQHOrN0c8G9gTuVvK3fMdFNb/DBGSMMDN4m129Oo2k68lTvl95iQIY8YIf5PKh83WuN8fbEj79ZNT8++p2HHLctqxy0+NtDFeUIAqHHiF9H+tUkkZKoMK8CtDBcyzQEtMpwjstIU7kGqXxtAPrvE6yBUCOBjUnNMoVsO7W9BcXry8GPuKGj126FykHhi2sfZ++m7NsXhooXo8SxY+9YeCEtJnduJeGtGkR/EMPhDctFNCPt0+qk87NtYKoJrtc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62a2f20-8cb3-4f95-3865-08d6c7036796
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2019 09:17:55.4289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5250
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Sorry for the delayed response.

Please find my response/doubts inline.

> -----Original Message-----
> From: Stephan Mueller <smueller@chronox.de>
> Sent: Thursday, January 17, 2019 5:04 PM
> To: Kalyani Akula <kalyania@xilinx.com>
> Cc: herbert@gondor.apana.org.au; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Kalyani Akula
> <kalyania@xilinx.com>; Sarat Chand Savitala <saratcha@xilinx.com>
> Subject: Re: [RFC PATCH 4/5] crypto: Adds user space interface for
> ALG_SET_KEY_TYPE
>=20
> Am Donnerstag, 17. Januar 2019, 08:02:20 CET schrieb Kalyani Akula:
>=20
> Hi Kalyani,
>=20
> > ALG_SET_KEY_TYPE requires caller to pass the key_type to be used for
> > AES encryption/decryption.
> >
> > Sometimes the cipher key will be stored in the device's hardware. So,
> > there is a need to specify the information about the key to use for
> > AES operations.
> >
> > In Xilinx ZynqMP SoC, below key types are available
> >
> > 1. Device key, which is flashed in the HW.
> >
> > 2. PUF KEK, which can be regenerated using the
> >    helper data programmed in the HW.
> >
> > 3. User supplied key.
> >
> > So to choose the AES key to be used, this patch adds key-type attribute=
.
>=20
> You expose your particular driver interface to user space. So, user space
> would need the details of you driver to know what to set. If another driv=
er
> has such key type support, user space would need to know about that, too.=
 I
> do not think this is a wise idea.
>=20
> If we are going to have such a keytype selection, there must be a common
> user space interface for all drivers. I.e. define common key types the dr=
ivers
> then can map to their particular key type interface.
[kalyani] Agree, now we have 3 basic key types and we can define them as be=
low
eFuse key
PUF KEK
User supplied key
But for our upcoming platform there are multiple flavors of above keys,=20
those may not be common for other drivers.=20
I will check on this further and update.
>=20
> Besides, seem to be more a key handling issue. Wouldn't it make sense to
> rather have such issue solved with key rings than in the kernel crypto AP=
I?
[kalyani] Can you please elaborate on this further ?
>=20
> Ciao
> Stephan
>=20


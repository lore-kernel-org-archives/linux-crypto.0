Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A3BC74A35
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A824420644
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 15:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=hp.com header.i=@hp.com header.b="Obfz3qJw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfGKPWE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 11:22:04 -0400
Received: from us-smtp-delivery-162.mimecast.com ([216.205.24.162]:59330 "EHLO
        us-smtp-delivery-162.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbfGKPWE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 11:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hp.com; s=mimecast20180716;
        t=1562858523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZYQfksre6ErtpOPnbg36I7bdTyGBffji0jMc7fEtNw=;
        b=Obfz3qJwt4foraiQIlTLrU1TIfEzvlTEwXnHDF23wfobw58iu/sZDaVuotmW1p4OrU6HUV
        t2LA/u0rAnrU1R6z5EGhVmY+Vv6b4XckASKHoY8AF4qVqHHWPGpXSTTP+gYBPptiLR9pJi
        MTasT+vCPhmk1y4XDuUzElRIvOEf+HA=
Received: from NAM04-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam04lp2051.outbound.protection.outlook.com [104.47.44.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-FkR16nKtOaWLM88BpKMpJA-1; Thu, 11 Jul 2019 11:22:02 -0400
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM (10.169.43.141) by
 TU4PR8401MB0703.NAMPRD84.PROD.OUTLOOK.COM (10.169.45.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 15:22:00 +0000
Received: from TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41]) by TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::84f0:ed8d:a382:7d41%8]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 15:22:00 +0000
From:   "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: CAVS test harness
Thread-Topic: CAVS test harness
Thread-Index: AdU2IaQXtQPkG6HVRT2zauBDH3qftABvXlyAAABAX4AABvU+0A==
Date:   Thu, 11 Jul 2019 15:22:00 +0000
Message-ID: <TU4PR8401MB05445179722F462CD8C05AB0F6F30@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <3201120.NINpRaGeap@tauon.chronox.de> <1782078.ZURsmYODYl@tauon.chronox.de>
In-Reply-To: <1782078.ZURsmYODYl@tauon.chronox.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.51.110.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74ef4cd2-c76f-4e49-3b83-08d706138558
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:TU4PR8401MB0703;
x-ms-traffictypediagnostic: TU4PR8401MB0703:
x-microsoft-antispam-prvs: <TU4PR8401MB0703376F6BF1B6D35D18CC11F6F30@TU4PR8401MB0703.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(53754006)(13464003)(199004)(189003)(51874003)(6602003)(9686003)(52536014)(6246003)(5660300002)(81166006)(8676002)(305945005)(81156014)(74316002)(9456002)(486006)(476003)(446003)(316002)(102836004)(4326008)(86362001)(11346002)(7736002)(68736007)(8936002)(186003)(478600001)(256004)(6916009)(76176011)(53546011)(6506007)(55236004)(26005)(76116006)(66946007)(66476007)(64756008)(33656002)(14454004)(66556008)(6436002)(66066001)(78486014)(71200400001)(66446008)(71190400001)(55016002)(7696005)(7116003)(99286004)(25786009)(6116002)(3846002)(53936002)(3480700005)(2906002)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:TU4PR8401MB0703;H:TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XIvRPmGW0XWk5nDwiAAOv/zG8+eueI8XThRfl9pIndPRGSCBzyYXPeA/VErV5/e8V3AnfQfZTi8MPLTwBjIQ1LtDOEC8LNx8kt65C0xOITl5xbdQqsQOlvz3R4gv0mgY81B6Yq+ePbbUR6xljoDffxESg0pgl3Wg0LYu5hf9GgsPpqeuK63mT4E4788gjsh1b234XFc4pGm7VPwKXl3UOwA22vQ+dXwxA5Ue0SpSvS3m9kfp1mji6EitIzoSK0xzVEdKPa2YFhdnzOnt6uzxxcdB56GxvjiCzcRbElY1v8Nusg5c1wBOVOgHFgwDHZ13FRaMDL+Q1yDl+3+j+4YHk2HMXlGPZa4qC13ArRkSs+RkHaUEJJZSJicJdLoadYF/RBeoqKoPb3yXdeE0S8EeLJOfqEiDjrPRjC2rjiHkJVg=
MIME-Version: 1.0
X-OriginatorOrg: hp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ef4cd2-c76f-4e49-3b83-08d706138558
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 15:22:00.6280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ca7981a2-785a-463d-b82a-3db87dfc3ce6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jayalakshmi.bhat@hp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TU4PR8401MB0703
X-MC-Unique: FkR16nKtOaWLM88BpKMpJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

Thank you very much for the reply. Yes we would need to write the test for =
AEC (ECB,CBC,CTR) 128 and 256 bits, SHA-1, SHA-2 (256,384 and 512), HMAC, D=
RBG and also for key derivation functions.
We are planning to write netlink based kernel module to receive the data (t=
est vector input) from the user space and process the data and generate the=
 result, pass it on to user space.

I wanted to know if this sounds a reasonable approach?

Thanks in advance,
Jayalakshmi



-----Original Message-----
From: Stephan Mueller <smueller@chronox.de>=20
Sent: Thursday, July 11, 2019 5:30 PM
To: Bhat, Jayalakshmi Manjunath <jayalakshmi.bhat@hp.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: CAVS test harness

Am Donnerstag, 11. Juli 2019, 13:52:29 CEST schrieb Stephan Mueller:

Hi,

> Am Dienstag, 9. Juli 2019, 08:43:51 CEST schrieb Bhat, Jayalakshmi
> Manjunath:
>=20
> Hi Jayalakshmi,
>=20
> > Hi All,
> >=20
> > We are working on a product that requires NIAP certification and use=20
> > IPSec environment for certification. IPSec functionality is achieved=20
> > by third party IPsec library and native XFRM. Third  party IPsec=20
> > library is used for ISAKMP and XFRM for IPsec.
> >=20
> > CAVS test cases are required for NIAP certification.  Thus we need=20
> > to implement CAVS test harness for Third party library and Linux=20
> > crypto algorithms. I found the documentation on kernel crypto API usage=
.
> >=20
> > Please can you indication what is the right method to implement the=20
> > test harness for Linux crypto algorithms.
> > 1.=09Should I implement CAVS test
> > harness for Linux kernel crypto algorithms as a user space=20
> > application that exercise the kernel crypto API?
> > 2.=09Should I implement  CAVS test harness as
> > module in Linux kernel?
>=20
> As I have implemented the full CAVS test framework I can tell you that=20
> the AF_ALG interface will not allow you to perform all tests required by =
CAVS.
>=20
> Thus you need to implement your own kernel module with its own interface.

As a side note: if you only want to test the symmetric ciphers and the hash=
es/ HMACs, you can implement that with libkcapi easily.

However, if you are interested in testing the DRBG due to its relevance for=
 the GCM IV, you certainly need a kernel module.
>=20
> > Any information on this will help me very much on implementation.
> >=20
> > Regards,
> > Jayalakshmi
>=20
> Ciao
> Stephan



Ciao
Stephan



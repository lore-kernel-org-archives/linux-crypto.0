Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB2CC282E1
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 19:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C429206BA
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 19:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="rZps2xKf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391738AbfEWTcO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 15:32:14 -0400
Received: from mail-eopbgr70109.outbound.protection.outlook.com ([40.107.7.109]:45320
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387758AbfEWTcN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 15:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpsC9d+x1j9EnE9XEQMgLZeUykOCsv0Hpt+6OD/xZA4=;
 b=rZps2xKfqgbJ5Xhk+aaRoaQgDzGudGSf1WI062/GULE55TY/4SgirE02N1xcEsnYGyVKDrkLzW559WoWYBsqfMjTa/dnBMnh1eWyWTuqCoRpiqDkjNzKgOh0oR68BjZN3OL0Xe0+ZJP/G6x2JSqvUBdhxtWrhgN57K7A7mI9PJU=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB2261.eurprd09.prod.outlook.com (20.177.113.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 19:32:07 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 19:32:07 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjg
Date:   Thu, 23 May 2019 19:32:07 +0000
Message-ID: <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
In-Reply-To: <20190523185833.GA243994@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d14ccd3a-0488-4b92-8a55-08d6dfb557fe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:AM6PR09MB2261;
x-ms-traffictypediagnostic: AM6PR09MB2261:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB2261C54861BBB16965C6EA5DD2010@AM6PR09MB2261.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(136003)(366004)(39850400004)(396003)(189003)(199004)(13464003)(76176011)(6916009)(305945005)(11346002)(476003)(14454004)(486006)(66066001)(186003)(7736002)(8676002)(81166006)(316002)(81156014)(446003)(229853002)(7696005)(71200400001)(71190400001)(74316002)(26005)(256004)(14444005)(99286004)(8936002)(3480700005)(9686003)(55016002)(2351001)(53936002)(6116002)(52536014)(3846002)(2906002)(5660300002)(33656002)(5640700003)(6436002)(6246003)(66946007)(66476007)(66446008)(66556008)(64756008)(86362001)(25786009)(73956011)(53546011)(6506007)(7116003)(76116006)(68736007)(2501003)(15974865002)(478600001)(102836004)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB2261;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f8xnCswkTCezZIhGtl3brekj1+z4KdCWSDGwrXhxJ5FM9HEeIJefpz2ask9wB7EbhqTkyuEYZdUctvviysXXDRTupaFj8RjLR4GUcn4qUknlV6sm9v3ekzsufSAlmqPQq9Ana7EiEabmMfslq05H0LuzIE9lEhMnAFbnz9a4lMPFzM0b3N3+wMyynOCSnEL9qYA7nrp0H1CEgeo4657DNtrEj5mAeJk5QvwyrLTfpDAk3MMX14pUM6grRJf3J2ISjtuuf46ZZxQ+6RWDLJCPuxMNEroPxnwWqrBoOiRCdCQgimQIbb+vJ1EBW5mrwA4eZqLUi6hpipcSO2CBZkFAjmeo4WrlnKkH/39IWhsQ+IbqtAQKZkZ/ApUuppbuMsLWloWgiWd6NlZRTIC7FiFkFlGSdu2/T6Ac/hGLof4znQk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14ccd3a-0488-4b92-8a55-08d6dfb557fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 19:32:07.6968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB2261
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers [mailto:ebiggers@google.com]
> Sent: Thursday, May 23, 2019 8:59 PM
> To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> Cc: linux-crypto-owner@vger.kernel.org
> Subject: Re: another testmgr question
>
> On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> > Eric,
> >
> > I'm running into some trouble with some random vectors that do *zero*
> > length operations. Now you can go all formal about how the API does
> > not explictly disallow this, but how much sense does it really make
> > to essentially encrypt, hash or authenticate absolutely *nothing*?
> >
> > It makes so little sense that we never bothered to support it in any
> > of our hardware developed over the past two decades ... and no
> > customer has ever complained about this, to the best of my knowledge.
> >
> > Can't you just remove those zero length tests?
> >
> > Regards,
> >
> > Pascal van Leeuwen
> > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > www.insidesecure.com
>
> Please send this to linux-crypto (not linux-crypto-owner) so this can be
> discussed on the list.
>

Oops ... looks like I've been copy-pasting the wrong e-mail list address.
Mea culpa. Now forwarded to the correct list.

Regards,

Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com



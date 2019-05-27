Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6485C07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 901F721734
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 09:55:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=insidesecure.onmicrosoft.com header.i=@insidesecure.onmicrosoft.com header.b="sEfvkV/F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfE0JzY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 05:55:24 -0400
Received: from mail-eopbgr10100.outbound.protection.outlook.com ([40.107.1.100]:53120
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfE0JzY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 05:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=insidesecure.onmicrosoft.com; s=selector1-insidesecure-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj7cmaZNHhkcn4yjeyV2gr+3XV2/PxXEDRrZK8XURag=;
 b=sEfvkV/FsPbbQJ3vh+vRupB1KkkCwz9A9UpSi2nNuzT0aNWYsOpa2VohU0DFC1dRx+xw7i/JJuqP+diGARGJU2UOr1NXMl4qnqhewoIKtunBlTJPNhC0sBOlDMSvGKKEYQee5+7EpqRIqybqz21p5ls5/XIDr79ftwRxWPJgWao=
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com (10.255.99.206) by
 AM6PR09MB3269.eurprd09.prod.outlook.com (20.179.244.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Mon, 27 May 2019 09:55:19 +0000
Received: from AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9]) by AM6PR09MB3523.eurprd09.prod.outlook.com
 ([fe80::8c11:e692:3a44:a3a9%6]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 09:55:19 +0000
From:   Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: RE: another testmgr question
Thread-Topic: another testmgr question
Thread-Index: AQHVEZmK2bzdbrfsm0iVWRutGLPeSaZ5GFjggAAKVYCAAAs7wIAAMw6AgACM6vCAAAlSgIAAAtPQgAAIJACAAQtqgIADsvCQ
Date:   Mon, 27 May 2019 09:55:19 +0000
Message-ID: <AM6PR09MB35231EEBF931A043AEAC04F2D21D0@AM6PR09MB3523.eurprd09.prod.outlook.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <20190525012258.GC713@sol.localdomain>
In-Reply-To: <20190525012258.GC713@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pvanleeuwen@insidesecure.com; 
x-originating-ip: [188.204.2.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be792e4-7030-48b4-068a-08d6e2896dbb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR09MB3269;
x-ms-traffictypediagnostic: AM6PR09MB3269:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR09MB3269A32710BABB302DC12E31D21D0@AM6PR09MB3269.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(366004)(396003)(376002)(39840400004)(13464003)(189003)(199004)(5660300002)(52536014)(478600001)(66476007)(66556008)(64756008)(102836004)(53936002)(68736007)(7116003)(3480700005)(74316002)(53546011)(81156014)(66446008)(86362001)(186003)(14454004)(8936002)(15974865002)(26005)(229853002)(81166006)(66946007)(73956011)(76116006)(6246003)(8676002)(6506007)(71190400001)(71200400001)(4326008)(2906002)(99286004)(7696005)(14444005)(256004)(486006)(6436002)(7736002)(305945005)(110136005)(446003)(25786009)(54906003)(66066001)(55016002)(9686003)(316002)(33656002)(3846002)(6116002)(476003)(11346002)(76176011)(18886075002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR09MB3269;H:AM6PR09MB3523.eurprd09.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: insidesecure.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4zJradnwiMjJ7hAp1xYrIlovBu9mwalF4NCGUQ0US8bYkverU8kOI9hIBT+MdxrnZzGAZLQmUdMTU7p2TYV3dY+nFlryFgD8dscfMGvAlrMkHo3A4dCy+d21fcYjWJxiAAZuXdcPWnOzjO4E7gs/ex9T9QCW6wT3oI6hRDLjnF+L8qo2iYsrTG6bDm0bPDEz3a9pk3FqK3qToH5op71tUQ7cIfpOwVXuQKIgzGGm21aiqFSAqU8/zvC9e7QhT9fp+C4I67lEF+I8ZvLPVXI14XW3aYr3XV47cyBkP0PdxAM+PY2gIlildWb8HiV1Y3AmWSSZ/2xY3QIfvXvaWpWR1JiwIU6pU0DF00cPGMPVkZmKsY5jtdbuIlYtHPSKSh0AIl+PPd9dCX1GJdky6HC3ObUpXBkf169npM2J1JdYekE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: insidesecure.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be792e4-7030-48b4-068a-08d6e2896dbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 09:55:19.7754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3c07df58-7760-4e85-afd5-84803eac70ce
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvanleeuwen@insidesecure.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR09MB3269
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -----Original Message-----
> From: Eric Biggers [mailto:ebiggers@kernel.org]
> Sent: Saturday, May 25, 2019 3:23 AM
> To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>; Christophe Leroy
> <christophe.leroy@c-s.fr>; linux-crypto@vger.kernel.org
> Subject: Re: another testmgr question
>
> On Fri, May 24, 2019 at 11:25:52AM +0200, Ard Biesheuvel wrote:
> >
> > All userland clients of the in-kernel crypto use it specifically to
> > access h/w accelerators, given that software crypto doesn't require
> > the higher privilege level (no point in issuing those AES CPU
> > instructions from the kernel if you can issue them in your program
> > directly)
>
> Unfortunately people also use AF_ALG because they're too lazy to use a
> userspace
> crypto library, e.g. systemd uses it for HMAC-SHA256, and iproute2 uses i=
t
> for
> SHA-1.
>
> - Eric
>

Are they really too lazy or just under the impression they will benefit fro=
m
that somehow? Maybe someone education is in order ...

Regards,
Pascal van Leeuwen
Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
www.insidesecure.com


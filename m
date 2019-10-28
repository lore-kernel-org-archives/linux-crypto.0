Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F45DCA9EC2
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 16:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15C97208C0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 16:12:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nxp.com header.i=@nxp.com header.b="IYxc6vDn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390828AbfJ1QM2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 12:12:28 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:34376
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730436AbfJ1QM2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 12:12:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIW79OdfuTX9ALg94yJu/DZVETTWegmNcUNK4ekTvaFOexd/mWeE1ZwssJ+I/qEgZuCWO5Wgg70pW2deJoCch4OHGzAlSwS+MWs73xldd/R438jHQZZpspxuewv6N8quQWLNw0VQeRojxkaHAvsjxHjkR0xPQI7cC7UbOByguyLKwAeMhiRE/wUpuw1deIoLFYTMowRyobnkZ7HoX8zSHMPh8tcwWx1Rjl9YdoWE+0iXlinAtU1SSFNOEzwyix48NRt6r3gQvrgY5UM52/3RFh8PRkqs85Q1t+Nbxh881Si6A5iAcW8Y952Pd9E6dLI4wWDFVVQJD8FwkbVdwFeLoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8vrfTIRk6dAqS1BW4/9Tu7QxSZhmjogwOuBi93PQFc=;
 b=nCBtN3mJAX/b3amRRFH0dusEk9FJPhqHPvSFJ/uNE/qsYWYJTj/DeP58I0eGeLlzSLSc/2Vcl2pdVu+QQ8Lyo8Jv7oN9zc0doENEofKYiyrmPL4hgUnQMpICDe3virZ1cb5If5JF/JfRZ7bzrRnNzC2dHufzKhTcKxMW5KgEwU9Akhqj7yjvAmspeQYSBioI/bgJv826jRZa8UbrOiSPrazQnQ45zlrmqb8NnuKqoePJKdkfbs7HFHNgGJLzexGC22aiA6QEdE/puNCDY1xeNQTMWYeV4ZaVt4GkuQRcoKqwPhO4Rw7JzptwDPXhyNkqpS1zyFnb09giT1uGZMxKEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8vrfTIRk6dAqS1BW4/9Tu7QxSZhmjogwOuBi93PQFc=;
 b=IYxc6vDn0vEpd1L1E+CsYsAOXxMyBj6yiudm1IRsLdZ3sVfWcFRWSZgvRUTPX9UdPpCxp3GBtjWEHd2LYV/961C4T5A12LWS9S84ACIU/N8EGONXJTmlMemN2rNOR9hQWp1Bg53KpKdco7MEANhNv6ZT5FdkhfmVSwENM4egz1I=
Received: from AM6PR04MB4439.eurprd04.prod.outlook.com (20.177.38.26) by
 AM6PR04MB5846.eurprd04.prod.outlook.com (20.179.3.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Mon, 28 Oct 2019 16:12:25 +0000
Received: from AM6PR04MB4439.eurprd04.prod.outlook.com
 ([fe80::d477:7579:4aed:91f5]) by AM6PR04MB4439.eurprd04.prod.outlook.com
 ([fe80::d477:7579:4aed:91f5%3]) with mapi id 15.20.2347.030; Mon, 28 Oct 2019
 16:12:25 +0000
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     =?iso-8859-1?Q?Stefan_M=FCller-Klieser?= 
        <s.mueller-klieser@phytec.de>
CC:     Franck Lenormand <franck.lenormand@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: CAAM hw key support status
Thread-Topic: CAAM hw key support status
Thread-Index: AQHViB3k4MywAkC5jk+3TDNh1rDtSg==
Date:   Mon, 28 Oct 2019 16:12:25 +0000
Message-ID: <AM6PR04MB443966860B2443CE06DD29818C660@AM6PR04MB4439.eurprd04.prod.outlook.com>
References: <2171b6f9-8e80-8f79-fffb-5a5b641ad196@phytec.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=iuliana.prodan@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f2474ab1-2a2b-47ac-f5d2-08d75bc19f23
x-ms-traffictypediagnostic: AM6PR04MB5846:|AM6PR04MB5846:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5846189A26E4066E24AEAF298C660@AM6PR04MB5846.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(189003)(199004)(256004)(14444005)(186003)(86362001)(4326008)(9686003)(6116002)(476003)(6916009)(6306002)(76176011)(55016002)(446003)(74316002)(8676002)(14454004)(3846002)(6436002)(229853002)(7736002)(305945005)(486006)(66066001)(6246003)(44832011)(81166006)(8936002)(102836004)(81156014)(966005)(316002)(25786009)(52536014)(54906003)(26005)(7696005)(66476007)(64756008)(66556008)(66446008)(66946007)(5660300002)(6506007)(66574012)(53546011)(4744005)(71190400001)(71200400001)(76116006)(2906002)(478600001)(45080400002)(99286004)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB5846;H:AM6PR04MB4439.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: okcQvi8jYog+doYcuZXGFPdqUDg1D3ACO0iSxPIJgPYPe6k4174DGFMO3u0HLH/AsjhXmTaMPC5bZiBYMjNCdF6I4ZZfOU6VwxlOXDteiV2flR9xPkV0v1iOXA+9xz/IqgvQ8faIQFir7xNE9pJqaWPkv6kyAlM3Gd5g/+lBdHv4t7HtiIFCUAIzb5513mRPeHItQMcN36DvPVXiW8rFiFMy5iWz3eZNQ4m6pSLzGhwdUCikrJA+yBbqc0eUtUhn9m1W3xPO201xBv4SwpoPiN+WAgJinOqxd4KkkepC7w7ksC9K0TPwl0Xl1Ki70Va2VIirYOlFEhVpm5hItt6v97ncokzsLpUCObgoRGRAlnmHPRqgZGk/w9PlcdQDcBVuKU2s3yw4Ung8DUzZcKbLSw4pn/VVQb3JiqgGyfbTtDvIcY/JEXmfmTieLDInQn2N3Tz57K/7CBCBMy3IK63kmv1hySyh5Ox0wQNOUT6X5g8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2474ab1-2a2b-47ac-f5d2-08d75bc19f23
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 16:12:25.1605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dfoWSYW1SOPf1smI2C8aKbvK1uOLv9lHW0EpeIMtal/Ap3AoCFzhc877nDKQ/jYxNzyyJVQZ+5QiF2pkAtHHzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5846
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stefan,=0A=
=0A=
On 10/21/2019 5:43 PM, Stefan M=FCller-Klieser wrote:=0A=
> Hi Franck,=0A=
> =0A=
> you sent an RFC to the linux-security-module list:=0A=
> =0A=
> March 1, 2019, 4:09 p.m. UTC=0A=
> [RFC,0/2] Create CAAM HW key in linux keyring and use in dmcrypt=0A=
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch=
work.kernel.org%2Fcover%2F10835635%2F&amp;data=3D02%7C01%7Ciuliana.prodan%4=
0nxp.com%7Cd2a2160934414cb916e008d756350679%7C686ea1d3bc2b4c6fa92cd99c5c301=
635%7C0%7C1%7C637072658050831257&amp;sdata=3D3ztN37KIopwP9X3tkHH96H4JFwsL2v=
PG0p%2BRqtlG7mM%3D&amp;reserved=3D0=0A=
> =0A=
> Is there any update on this work? How do you want to move forward?=0A=
=0A=
We just resumed this work. We want to see if we can use an already =0A=
defined key type rather than implement a new one.=0A=
=0A=
Regards,=0A=
Iulia=0A=
=0A=
=0A=

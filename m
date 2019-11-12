Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E1DC17440
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 12:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C690020818
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 12:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="u8NwhSUk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLMQK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:16:10 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52275 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfKLMQJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 07:16:09 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VhDmuIIeOZDSm8BevpO98nniAdBCUZEVXSwnM2yABge+RS0UT+I9UQ4jLAfXzprCs/zpQw9BjP
 Sp2K+modU6CgZCys5XajYm+ojEW+4piHYYcNRyanxXhb1sxBw2qV+3BQRUEgq7lcBrkurKdmzc
 cidWvy7SKZ02qudDE23elm/o+Z0GX5zaVA3KaCvsEXB6+3/iSUCkLfgydVs4zEk0MCEV4kdlya
 ZIHqub8YfvXWivCqU0qUL1oXGs0gyiIgTVW3lp0tB7L/T7YEKB+nLwSAN100FFSWmgw44TZVRa
 pNA=
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="56661930"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 05:16:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 05:16:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 05:16:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EX+uSaGr0vcbPG+7k0VCm20+pDbtV1YWOVQ3ApTYwJ8mWFqdwvJLyI4pzTdkCt9dwaIm2fXMGTs8IFga2JXNh6qwX66k40YRqhPdY5QSSk7Bp4op5lBH2BsIAAGxLDTKRi1R/WC/WnB9Xy71gRujr2zaJGtf0ufgjsUlbX7yY7ho4TiapBX0r6lJ0dVqSCT/HE5uVZcUlLNzFnkrfRlxDRTU1wXkfjjvBvjIOka+Xy1tOd/Rw+xRCYq6cyxEuuQZ6DsGgkAU4jOLTfygpIIVqf20jq4Cc6riI2QhogJJVgatZiL7rOVDMoESSJwOxG7qeCBC5voQirzC3m68cHWMvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bynUQryyE9kRcvPVfcCs9g4F1t3iUgJM1gds8bGEv0=;
 b=KVWlyMdF/RRWkZOvVEakm4Zw8B/aqCq7vg/3egImgm8TdMie7DvtvfMDAgypOD7yBNq91q/ICzaVD6wkpClea00gkefACRr1ybUng2rYQYo5EPVB8UOwyehmiq5mRh93mDgeQie1w1Hpscr/CPd9qYjeMLmUmpPyo8D7HK6lUm2h0ugyORx+AfYl2rq5V9E/hKjivA6TOys/Ui7uWBtvr+xW7EFHm+PW32xawqweyhLFLXftYRuP5SbMDhsmOZ62jbyaksOSZV/DkO+A+x3qDLtcH5fk75lGXy7pJeBtx0xYNLrhFiDWhOloURmXl3Rb/of7qpsDUZ9bqQGk20+Mhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bynUQryyE9kRcvPVfcCs9g4F1t3iUgJM1gds8bGEv0=;
 b=u8NwhSUkk4iwVHnVAqMlp/AZnyOsEmdDHD340g8hyucDKwO6CHheVg3iL4+iFM2rGqOb269ZLU1exAojrFE0OMzkvD0eNQvSUeBCOboVuWi3ii7hZrzKCnGL7lj71nQCkby3BNlcoj4pD1hhSyJUb0s7/wEAiMUYLhYUEhYtQUM=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB3695.namprd11.prod.outlook.com (20.178.252.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 12:16:06 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 12:16:06 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <yuehaibing@huawei.com>
CC:     <davem@davemloft.net>, <cyrille.pitchen@atmel.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: atmel - Fix randbuild error
Thread-Topic: [PATCH -next] crypto: atmel - Fix randbuild error
Thread-Index: AQHVmJWIP0EGiUeHhUKrP5SYoH74XqeGzHoAgAAAW4CAAKJjgIAABX4A
Date:   Tue, 12 Nov 2019 12:16:06 +0000
Message-ID: <bfe0db64-209e-603d-759b-70ac2f691007@microchip.com>
References: <20191111133901.19164-1-yuehaibing@huawei.com>
 <20191112021350.qu44becwmwom7ywu@gondor.apana.org.au>
 <20191112021507.y52sqecdaotqptcf@gondor.apana.org.au>
 <7988a8aa-e0e7-b031-7e79-fb9c5bd4e81a@microchip.com>
In-Reply-To: <7988a8aa-e0e7-b031-7e79-fb9c5bd4e81a@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::29) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb9d7558-7be2-4eab-9976-08d7676a1828
x-ms-traffictypediagnostic: MN2PR11MB3695:
x-microsoft-antispam-prvs: <MN2PR11MB3695DB4404B93097C891F824F0770@MN2PR11MB3695.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(3846002)(478600001)(6116002)(229853002)(99286004)(2906002)(25786009)(2501003)(2616005)(305945005)(7736002)(66066001)(186003)(31686004)(446003)(11346002)(6486002)(26005)(76176011)(52116002)(476003)(6436002)(53546011)(6506007)(386003)(102836004)(486006)(256004)(71200400001)(71190400001)(8936002)(14444005)(14454004)(36756003)(4744005)(8676002)(81156014)(81166006)(110136005)(6246003)(54906003)(5660300002)(86362001)(66556008)(66476007)(31696002)(66946007)(316002)(64756008)(6512007)(66446008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3695;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FgOIjR+9GUtKw3JH27gygBZPQXGFcgWnUqXE623RxrH1BoWlI5pIblid5uwl6s7mrzAxPyh7hqxSBN7hnSX8J8houiDfaxqYs1j+FGrPbUIMJDXfonrg34I0ufRz2D48ZNPi1kNQZC3QQsQe+b4FtgXKqpu776jh29HbBvf0Upsg0roiVEUT9zIy+d3edKtcf+HDnOlG4qslfX+rRvgsWUFe6lMevePhjYSL2RzoBR9p7odY0J0BFcGZ5MjPc4561AjKmsGzmpMgloXyV0sZLUfRU9a53fm3kZM39QGp6t6XKLgTCxgeKL7nwktVo/q87fScxduLUpC7e+A4KhS86cjtjiAePos3p5pbrLk9zVr+wY5uZPpGPspqR4Pv95Blu3Mv3GolgcYvmG6MaxtgS4zzotYYnQWVOf/Jhc6e60KggYDtZsu/b3u+mn4fbZUe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C438E02F457D444EA3A810AF280E13FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9d7558-7be2-4eab-9976-08d7676a1828
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 12:16:06.7591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t0TL7xUhk7HGADESimOfVVbZn4v6oYLspXpHNUepVyHlRncmzoLArQpRa53wAh/GT8ZhgSTY4q3LslxP74lT4fcZMIjha/+8W7Lz0jD/0xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3695
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzEyLzIwMTkgMDE6NTYgUE0sIFR1ZG9yLkFtYmFydXNAbWljcm9jaGlwLmNvbSB3
cm90ZToNCj4gDQo+IA0KPiBPbiAxMS8xMi8yMDE5IDA0OjE1IEFNLCBIZXJiZXJ0IFh1IHdyb3Rl
Og0KPj4gRXh0ZXJuYWwgRS1NYWlsDQo+Pg0KPj4NCj4+IE9uIFR1ZSwgTm92IDEyLCAyMDE5IGF0
IDEwOjEzOjUwQU0gKzA4MDAsIEhlcmJlcnQgWHUgd3JvdGU6DQo+Pj4NCj4+PiBXaGF0IHdlIHNo
b3VsZCBkbyBpbnN0ZWFkIGlzIHR1cm4gREVWX0FUTUVMX0FVVEhFTkMgaW50byBhIGJvb2wsDQo+
Pg0KPj4gT2ggYW5kIERFVl9BVE1FTF9BVVRIRU5DIHNob3VsZCBhbHNvIGRlcGVuZCBvbiBDUllQ
VE9fREVWX0FUTUVMX0FFUw0KPj4gYW5kIGxvc2UgYWxsIGl0cyBzZWxlY3RzLg0KPj4NCj4gDQo+
IEhvdyBhYm91dCBnZXR0aW5nIHJpZCBvZiBDT05GSUdfQ1JZUFRPX0RFVl9BVE1FTF9BVVRIRU5D
IGVudGlyZWx5Pw0KPiANCg0KbW0sIHdlIGNhbid0IGRvIHRoaXMgYmVjYXVzZSBhdG1lbC1hZXMg
YW5kIGF0bWVsLXNoYSBhcmUgdHJlYXRlZCBhcyB0d28NCnNlcGFyYXRlZCBlbnRpdGllcy4NCg==

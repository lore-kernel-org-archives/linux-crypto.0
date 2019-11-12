Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AA9C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 11:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491BA2084E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 11:56:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="N0a2Ow7f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfKLL4b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 06:56:31 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:30491 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfKLL4b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 06:56:31 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Tudor.Ambarus@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="Tudor.Ambarus@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Tudor.Ambarus@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Tudor.Ambarus@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: QeClRmGD5+8YL1H7TUg12xXhu1R+E6lFbL96JnsW9k221s64zYuth2+lPf54ZnULlMDFFmyYvU
 mKeUPqZA7dxFVfgIdFyDBIxkkK0fVEzDHMDHR5bQww3AMwilWrWMAY8xExLbPM+iTcaoVV01EH
 2GAAteIICrIRto5ftP2S2ub860H/gVBy30WzZ9DOMDRYgy1dHAf61qA/+5pgL9CZW805iZx3B5
 ps/Qu+KZTbTHVugkGB+8V+muloSdvIxhP435FePfNBhN8Phg+6E5QGz+siBcgvhfKHmTyxHC/U
 1fo=
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="56219158"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 04:56:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 04:56:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Nov 2019 04:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5/pczxxRSUOEJq/irjZR5N5MbrfXW9pgY9iHv7LfI9JnAjS4Gn7OnE4j+9u3E4rJ0M9RF/uXuv2baDTowy40/nZ2kX9yxx3qXVQuo8kG55tyMHQCvQ23QmsK/BxQOA8Et6vOMOnDAC5G8rBaX3QvwQKh82VUw3N3fpfrFHK+fXssXcm59C/22zFy+eKSHy4KC2BQ50mSzOavZ94jKUsFFaO8ugbKkx2Siiyp9AkNf1hP9SFTe9Lu5wT5p2UrYsRz77gihplMGb3Sw2POZ4buiOfQGThJPiCT5Hct7bMJhG6kFMOZsoq0WSVgVx/JYwCceb9Rv3lUmG/UtBneVAm0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Lm+dK2lxVlKV43wUzFlYiDgPzzomL1NK6bQawmSpRg=;
 b=A2WebAFhahwKnk9nuVJHPeD9IFIptD/6qB5bM7L3GDYdx897pjxnJDsbPWRiKaVQdo7AGMy/vYntjV7bdnI0x03UYmGkwoERacui7ug1s8+k/qg1QgN4lBMG7KBPcWhaK4wZXU+OLn21sZHUi0XISfxJrO+teaweLncyBJwrFeNlp9HoEKsmH6xNTJVs+8rWN75/RNgkHvsajEQCldF5ZbNv4NOVyHL/P0tZdRnvHr1NgNc1BnCRqdxSU9QPpdc5CW9H9Qmp8HCB5pvBE0zASUvjgaEW7cgCjgTpCS5HMeJsaAD+nHvyI/wq3jqbzliAxU5ZpSFY4E0tHWQZAWnOAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Lm+dK2lxVlKV43wUzFlYiDgPzzomL1NK6bQawmSpRg=;
 b=N0a2Ow7fiNjyCL5QRlkFwrgfzzmM/8IDHwHNsTzLtB8mt+55MCxaOgHeDcmOHpupzgBQtlHe3/zNwC/p0UOAvApcyN3wyfKOzyzIVn7DcfFxWtwMUndYzKHBSCX70Ofa0R6F8SztRKT73+0+tzzKS0XBzbwwiF0bYE4zua4iypE=
Received: from MN2PR11MB4448.namprd11.prod.outlook.com (52.135.39.157) by
 MN2PR11MB4015.namprd11.prod.outlook.com (10.255.181.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 11:56:27 +0000
Received: from MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457]) by MN2PR11MB4448.namprd11.prod.outlook.com
 ([fe80::c09c:36c8:3301:4457%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 11:56:27 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>, <yuehaibing@huawei.com>
CC:     <davem@davemloft.net>, <cyrille.pitchen@atmel.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: atmel - Fix randbuild error
Thread-Topic: [PATCH -next] crypto: atmel - Fix randbuild error
Thread-Index: AQHVmJWIP0EGiUeHhUKrP5SYoH74XqeGzHoAgAAAW4CAAKJjgA==
Date:   Tue, 12 Nov 2019 11:56:27 +0000
Message-ID: <7988a8aa-e0e7-b031-7e79-fb9c5bd4e81a@microchip.com>
References: <20191111133901.19164-1-yuehaibing@huawei.com>
 <20191112021350.qu44becwmwom7ywu@gondor.apana.org.au>
 <20191112021507.y52sqecdaotqptcf@gondor.apana.org.au>
In-Reply-To: <20191112021507.y52sqecdaotqptcf@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0079.eurprd02.prod.outlook.com
 (2603:10a6:208:154::20) To MN2PR11MB4448.namprd11.prod.outlook.com
 (2603:10b6:208:193::29)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b61de5da-aef5-4bcb-1d3e-08d767675919
x-ms-traffictypediagnostic: MN2PR11MB4015:
x-microsoft-antispam-prvs: <MN2PR11MB4015358B08A99611750C0F62F0770@MN2PR11MB4015.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(39860400002)(346002)(396003)(199004)(189003)(6486002)(6512007)(36756003)(186003)(53546011)(6506007)(6436002)(6246003)(4326008)(478600001)(102836004)(25786009)(99286004)(54906003)(386003)(11346002)(446003)(7736002)(229853002)(26005)(476003)(486006)(305945005)(316002)(76176011)(31696002)(86362001)(2616005)(110136005)(14454004)(256004)(52116002)(4744005)(3846002)(8936002)(2906002)(6116002)(64756008)(5660300002)(66556008)(14444005)(31686004)(66066001)(71190400001)(71200400001)(8676002)(81156014)(66446008)(81166006)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4015;H:MN2PR11MB4448.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: inNtBtxhMCqwaQwMmQGmuz9YTmrSKh2nMzoQouKhLZ0hB6Ax/ZI0PuKQ6D2+qaqJ7pf8mt2JWhssaTeJdbBPQ8CBnaPDwOv7kXo0meTNpOEFIYK6jYA/dxQ0oIfnUOf50RCh9VJfHznCj+rNyHW+TInGkaZkpiga8rbprQWx34NwGF/rCvYx/CVHwMgPmMi8e3hWTGu5VBX6SqOksJpm2AEf9l2cZiw6kAhTKoEv0Y4Yf9VKT9cRbLhjh4RPsthp1wQdEgRXHHEsELPYYjdVGcaLc5Iz+vKL24Z/e+KchPgnyw0ymjjqEEOzovYg1v2b9hXRLRfdx3WRPJhDMOra734cBna5QizmsJspYEE6JTpc2CPo+K54JIx4bKvtJx3tLEdAVAnABmhjrV2VKihQbA/yNvMSa9uNC+Wz1tPNOZ0d8tCgkjmZGKut74Bpapxz
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA58448150E7D14D83F2B3642E32869B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b61de5da-aef5-4bcb-1d3e-08d767675919
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 11:56:27.2743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IloxEY/EI5S6g7Ag1jxOQwEHVyE4tl8LyaXIyf1HzxWUi0qhAQwI2fSE+nxyfd+bxV8Wx3Jqb0l2lkQendBoyFwSLubBxkcIr/p4Ry3guU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4015
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQoNCk9uIDExLzEyLzIwMTkgMDQ6MTUgQU0sIEhlcmJlcnQgWHUgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IE9uIFR1ZSwgTm92IDEyLCAyMDE5IGF0IDEwOjEzOjUwQU0gKzA4
MDAsIEhlcmJlcnQgWHUgd3JvdGU6DQo+Pg0KPj4gV2hhdCB3ZSBzaG91bGQgZG8gaW5zdGVhZCBp
cyB0dXJuIERFVl9BVE1FTF9BVVRIRU5DIGludG8gYSBib29sLA0KPiANCj4gT2ggYW5kIERFVl9B
VE1FTF9BVVRIRU5DIHNob3VsZCBhbHNvIGRlcGVuZCBvbiBDUllQVE9fREVWX0FUTUVMX0FFUw0K
PiBhbmQgbG9zZSBhbGwgaXRzIHNlbGVjdHMuDQo+IA0KDQpIb3cgYWJvdXQgZ2V0dGluZyByaWQg
b2YgQ09ORklHX0NSWVBUT19ERVZfQVRNRUxfQVVUSEVOQyBlbnRpcmVseT8NCg0KdGENCg==

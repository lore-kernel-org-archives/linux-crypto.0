Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC46C4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 04:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EADDA60E8E
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Jul 2021 04:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhGWDoZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jul 2021 23:44:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6854 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhGWDoZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jul 2021 23:44:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627014299; x=1658550299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1e8FFQztQLc7eo+LCLZ56EdgLfKkOUALe59ZDfMnFH8=;
  b=mcJYhAGnOQ6EHomUWPEP/p/PiAFPW0P8ZYO7UIeblRolcHo2E5Ue1N2Z
   cOYXtL18oR8LzwzpUVm//S6qP8BdFeoZMUtAQHPs2eWjQQN5QPAyy/YxU
   KNi8+p5Hmo9VMffApdGmHZZxzhhOLFioz7n05NryjK6KpuAdS9CxlyPFu
   OoWbXff3haAsBvP7ROpyvmtl4TIl8u2AXGu0aAhCP2Plcnjb0DDPIG/s5
   ZkEaUqnMEcIn18/J92T36nkbtDEMNuKyeNH/Y42U26lJbInIFqia87RYe
   35GC3iVbuADZwJq96toA6vkIBY2A+tOgak0zpg/YMIHCz7HvIQK1/rezv
   w==;
IronPort-SDR: ldVjc7gwpa4k+amPvk9RjR76OEsjQzNOb4rKG7bMHWqEIrfjPH9pEFiHZO12UFBpTvPMujL4EJ
 DQbHWrvm3IllpHOs+O+vsOMrXtFU467PY/R9t+70m3koJnyIvGqXBp9kJ+IzfW7rRgN8orwpa1
 ECap86oNwYOHIUCG74xlssLsSfUS1B1SYXfTfjMbRS1G/rbPLZkzwOlZ1YqlZr3kCPBKMIGHmh
 H2Q0isI48tm/Rxj76cJU6GtsMjvnpJ9dcvC9cevT1k3eo+GhVIfXrrxygEbxnDek22odqg7/mV
 rGeqhhrRlA8oyKYL7GZRGhbY
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="137205099"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2021 21:24:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 21:24:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 22 Jul 2021 21:24:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q50UjDnqe5/tD3yR0i+eaxmFcBwYp4ewLGgPlROte63Tm0AXGhrDiQSHExIyOr/Dciikaw+EKDtPgNjvXE7UgGmBz7pVtO93MDH6XCBrxOV79LAtRGLtskdhVdogFmzRRB+ZJZo1y280JgsOqbZqA6PFgiFwlR0NbYsLmd7IhG9BtvAf5BKpc6MlZ7ObOkr1Evxa38Xyef8WZ7+FDuYQxdfej//CrakiDSLIVdyoNs+z+ebHDovdDOb8X5rP6a0PpHhu37fiUAAAEV6LqTijW/fPIP0wE0254xKJsO3Xl3byJvLR4H/6wiS1Fqm707c0jxlInW0LeGQvp5ivW+7wvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e8FFQztQLc7eo+LCLZ56EdgLfKkOUALe59ZDfMnFH8=;
 b=BiINqm7oATihbQQgK1pDV/SAVjhiOS23Y+rwjCDlTqRU1UtEeVrvjwP8dYcaf5XCJKZbrr+S4OKcZTOdfjxRjj/9Daq0+28jOMZ6X3cpLxrqMzx84HDccYWeYYrrAc3rGVxjaKW8GCy3JQuj777owHGE7hAqw2K6xDWUYaqnNa6/jHPz8lO2ng6POEJpmfUy+18DA6qY9lv2f9BHl2So+l3of6/TIH6O6HH0vy3QN6Cg85G49UBuizL7CUUal+NBhIL7Iyrtl7FaJt6q5BDzWoBCBl47K76QW+0m433rU3s/SmjIHQURpGMQIduf94yPPDGb9l1kTVLB+1BRZ+Cvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1e8FFQztQLc7eo+LCLZ56EdgLfKkOUALe59ZDfMnFH8=;
 b=kJSjItvZMKQ74S678ay8hreio6puJRJ2F6YsrSNb0KMKGakjXKlM7yN5PLBmmVkorLXRuGUUsBxwHF5YroG+h1P/SAuu6DrptisFDXnVpZYpz6EbfyQ5yu9vxJJIBN3giMMht16hEMrNBT88sgnG3lvlmTldPP5dgQ+Z4098N4Q=
Received: from CO1PR11MB4865.namprd11.prod.outlook.com (2603:10b6:303:9c::9)
 by MWHPR1101MB2336.namprd11.prod.outlook.com (2603:10b6:300:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.24; Fri, 23 Jul
 2021 04:24:56 +0000
Received: from CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::58e9:43d8:74e1:f266]) by CO1PR11MB4865.namprd11.prod.outlook.com
 ([fe80::58e9:43d8:74e1:f266%7]) with mapi id 15.20.4352.026; Fri, 23 Jul 2021
 04:24:56 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <salah.triki@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] crypto: atmel-aes: use swap()
Thread-Topic: [RESEND] crypto: atmel-aes: use swap()
Thread-Index: AQHXf3qwVAlERiynyEmqNOW7p1HJmg==
Date:   Fri, 23 Jul 2021 04:24:56 +0000
Message-ID: <e0c89ce0-4f69-0a2d-0e1c-a730864b38cb@microchip.com>
References: <20210722170827.GA4362@pc>
In-Reply-To: <20210722170827.GA4362@pc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e9aadeb-b362-4342-4101-08d94d91d387
x-ms-traffictypediagnostic: MWHPR1101MB2336:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2336C1F5396B6C9FFB02A168F0E59@MWHPR1101MB2336.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fWeldh+xE3vod/Qk4egHh4eNHKuf3GlEZDkbLHCGwh68WDcCpr86z1GljZ85/pGdOhZBqfmeWRaFLT01/PJ7vRaqJhye+h4a0zF8XyvKusZDDVjOlDKQ8+sdGYzhTzklXkD+z2KdSUoTv6rzQIuqeX4m6kRCgU/XbseCtQwmcDfiHvrx9Bl2b9F3VJovNwo6tyFuUesA4XvtukaU+/FMgUIxkFmZM5mzBikFO+/bZDOC6uuQumCHS8Cj9N7RDjiPiNuEwB1JykVAsRKnWAVJqqBVVJGYhEkn4l5mRBhRJ2UsG1trXpqgTmRvMVgtiaDAxn4eHHH324y0HFUuBiU+mt83OFlVnsSiHU3mMGx6m8HQIA2p1aGQiIkWHqC0Yek+dgIXZcqtRrYDyIq6k8XpjK3frNfA1TFVREs+iZUvADt1ZbDzrDqDfDEV7a6Yw4lTY8lmqJ4Sj25Nil4bV33lnXtsZnahLcvDvYug2Ylb0cs40hwK9adylMnwJTYOfSv4aTsGgwgXB77f67czI9x8MXt1datNdJmhdSJ72aHDFs3ho0jqHaxJaDerIV8p52b/fXGj86ptnzZataK33A2NhnQu+kYEWuKf5G7YkOkbMz6Ldtj5Iiom9GBSq6TG8UCuA0amr7FwGfAXtypdIm6T1OT+0nHH3PZLkfaYlIbQDvt9eHullEAgw3HsLXxfCxt3/BHdvDbyYaET+JFoYQJwaAEvHNyKTklNJbcatJjQvCXbpRiDfLdTlh8XWLconclOP9uzRUguVDlFYApqv0UUUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4865.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(8676002)(122000001)(110136005)(2616005)(71200400001)(31696002)(66946007)(38100700002)(478600001)(66556008)(6506007)(6512007)(83380400001)(31686004)(186003)(5660300002)(8936002)(36756003)(4326008)(53546011)(316002)(64756008)(6486002)(54906003)(66446008)(26005)(76116006)(66476007)(2906002)(91956017)(86362001)(45980500001)(38070700004)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmh6SUVzRlVwRmw4YTVTRldNd0svNlZocTdmWTVnU0RBMHF3Q2g3TkF6Umdh?=
 =?utf-8?B?bWFpMWdnNWNjbTJPOFJyU29tUFFVc2Y0TW5iYzZocXNzOGV3dHp1TEpVeUFF?=
 =?utf-8?B?S3NxZlNwYWVaOFd5bzl3MW1Ob3dpNmcxTjA2czFHMm9vdUdoRnJrcmRVRHJ0?=
 =?utf-8?B?TlR4ajdhQTVEbmlQN0l3elg2RGtBOFp2V3p2OTdJSkFETGRkQmRqMGVwM2VQ?=
 =?utf-8?B?anVCMVFCSkRLYzFnZXBIVEVyelk1ZXgvNnRWU3R1eFU1Mk5SbktQMUtYQ2U5?=
 =?utf-8?B?bDJOT0I2bGx1R1JFTTQxbnQxY0h0SWhJWk8yQW1DMjJNeTZkOWtHeWlCanpl?=
 =?utf-8?B?MThqTnduV3VVb21jTitzYnFpdFR0QURTN21UeldKa09aR3dXdUNmRDd2VEhE?=
 =?utf-8?B?N0dZQU1PZ3ptVW1pQzFtSGhyWk45d0hmUDNsVktkVzhEeU9YZlhleTd2dDNy?=
 =?utf-8?B?dlliWlJKeUlOdFpMblRhYXNSV3ZVbUxHdTArMWE5VVFyT1ZGNkZ3WFo3M0J6?=
 =?utf-8?B?bHhhLzAvb0psc0ZJazY0SUNyQ3loc0lkc1FRL05uTTlJVmZxZG9zdTJJRkxY?=
 =?utf-8?B?L0I2eEp5aDJIeHFWc3JiVEdUdjJGTGFzdDFDcmVuVldsRnJ0VHdpdjRTOHJI?=
 =?utf-8?B?Y0Zmd0c4UGhMemZhWG9iZ1h3UkNZTWxMQk1ERm9FUjZQRTV6eUMrdWcxZUhI?=
 =?utf-8?B?T3huNWlnb2kzSEQ3ZmpGTW5VcXVRRVhweEZoUGtuSDNzM1gxVVVMUEFWZlN0?=
 =?utf-8?B?OWVubk9jaktkVlRmRDl2Q2V4ZjczVHhRSGpubXUwVWp6Wk4wVTN0UW9TdEVV?=
 =?utf-8?B?b0UrdGVsa055a3dubU8xU1FER1plWnVTVGZhZ0RHT1hDVXZ1bWIzWVRralZk?=
 =?utf-8?B?NERLWnEzL2NFQWsyNXc0dDgyaWh5K3BRaFhoMFFXdzhZaXROMjdJTXZ1UkRq?=
 =?utf-8?B?R0NralNBNWZKVjVFaE52TVphMU5VWFFCRFd5enZpZmx4TGwwVVZmTzFzNWZO?=
 =?utf-8?B?bG5QdXVVaDV5WXFCY0ExWEFEczVmM2xOMktPRkhFQno4Rk9lVHBFa0lNeXdn?=
 =?utf-8?B?emtFRSs3dXVVeVVteitMVnZNOUlMTEQrMlRrWUNXUnNvNk8xc280WncwcW5u?=
 =?utf-8?B?Q1RpNnFxcEpSOGlmeEgwUnZhbTRRQnYrcEZFamZaQStESW5ObXV4NHFPazZp?=
 =?utf-8?B?a1Q0VlI4MENpWFNsQkU2cGE3VU1RVVJ1cnAwZFZtUFR0Z0xncW9GV1JjT1Bj?=
 =?utf-8?B?VmlUMmhyckNyQnM0bzNrNi9oQldzWGxMRkZwTEVyTThmdVFJOTRTN1JBU0hi?=
 =?utf-8?B?VTFXc2phUlQyZk9HNEg3VDEvNnJ0SmM0ZU5uWlBtcFpIZFQydDdXOGdUWTZX?=
 =?utf-8?B?UFVmbzFMbnE2bVpqMGhWQjVocVR6dGRIL0xWOGErT2xyVURDcmYrL01pbzk4?=
 =?utf-8?B?VXpORXRtbWo0OWU1MkVMWURiMmFYQzIvbS9EbUIyLzJpU3laNWwrQloyZGlK?=
 =?utf-8?B?MzUxUDNtZHRCNXo1UVRnT1g3NSt5ZlRybGVzS2VlYWlDN0VGbjIzT0hZbFFP?=
 =?utf-8?B?aDluMy9TcTdVakgrNzJseTlXWTRSakltT1d0TkIwOWsyRWttQlNGVU9hNW1q?=
 =?utf-8?B?ZDJxTGJmaUR5OWdwVFVKaG5GdlNIaGc2anRLVldIUDFwakJFMS9iNW56Y2FY?=
 =?utf-8?B?YXJOeXVPNzNRVlZFRmRPVkRwM2tpS1BOcHR5Y1V5clVIN2JONXRHNFJoWmZt?=
 =?utf-8?Q?rYuvdunCwvYplGFA5Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA9969C444A16C4B82D8792FCD6BBE91@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4865.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9aadeb-b362-4342-4101-08d94d91d387
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2021 04:24:56.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWqC7P+QKGBcMR0YZbovs+itv+EYCpWZhkzSLQ4y38yALxh98xlSBH1Dk4QF9NaPCnLt+9v9o5eQpPo7M8MGQ6nN7A7rggUnXJznjrS652I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2336
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gNy8yMi8yMSA4OjA4IFBNLCBTYWxhaCBUcmlraSB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBVc2Ugc3dhcCgpIGluc3RlYWQgb2YgaW1wbGVtZW50
aW5nIGl0IGluIG9yZGVyIHRvIG1ha2UgY29kZSBtb3JlIGNsZWFuLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogU2FsYWggVHJpa2kgPHNhbGFoLnRyaWtpQGdtYWlsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWljcm9jaGlwLmNvbT4NCg0KPiAtLS0NCj4g
IGRyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jIHwgOCArKy0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2NyeXB0by9hdG1lbC1hZXMuYyBiL2RyaXZlcnMvY3J5cHRvL2F0bWVsLWFlcy5jDQo+
IGluZGV4IGIxZDI4NjAwNDI5NS4uNjAwNDEwMjJjNGY1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L2NyeXB0by9hdG1lbC1hZXMuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC1hZXMuYw0K
PiBAQCAtMTgxOSwxMiArMTgxOSw4IEBAIHN0YXRpYyBpbnQgYXRtZWxfYWVzX3h0c19wcm9jZXNz
X2RhdGEoc3RydWN0IGF0bWVsX2Flc19kZXYgKmRkKQ0KPiAgICAgICAgICAqIHRoZSBvcmRlciBv
ZiB0aGUgY2lwaGVyZWQgdHdlYWsgYnl0ZXMgbmVlZCB0byBiZSByZXZlcnNlZCBiZWZvcmUNCj4g
ICAgICAgICAgKiB3cml0aW5nIHRoZW0gaW50byB0aGUgT0RBVEFSeCByZWdpc3RlcnMuDQo+ICAg
ICAgICAgICovDQo+IC0gICAgICAgZm9yIChpID0gMDsgaSA8IEFFU19CTE9DS19TSVpFLzI7ICsr
aSkgew0KPiAtICAgICAgICAgICAgICAgdTggdG1wID0gdHdlYWtfYnl0ZXNbQUVTX0JMT0NLX1NJ
WkUgLSAxIC0gaV07DQo+IC0NCj4gLSAgICAgICAgICAgICAgIHR3ZWFrX2J5dGVzW0FFU19CTE9D
S19TSVpFIC0gMSAtIGldID0gdHdlYWtfYnl0ZXNbaV07DQo+IC0gICAgICAgICAgICAgICB0d2Vh
a19ieXRlc1tpXSA9IHRtcDsNCj4gLSAgICAgICB9DQo+ICsgICAgICAgZm9yIChpID0gMDsgaSA8
IEFFU19CTE9DS19TSVpFLzI7ICsraSkNCj4gKyAgICAgICAgICAgICAgIHN3YXAodHdlYWtfYnl0
ZXNbaV0sIHR3ZWFrX2J5dGVzW0FFU19CTE9DS19TSVpFIC0gMSAtIGldKTsNCj4gDQo+ICAgICAg
ICAgLyogUHJvY2VzcyB0aGUgZGF0YS4gKi8NCj4gICAgICAgICBhdG1lbF9hZXNfd3JpdGVfY3Ry
bChkZCwgdXNlX2RtYSwgTlVMTCk7DQo+IC0tDQo+IDIuMjUuMQ0KPiANCg0K

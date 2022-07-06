Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDADC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 08:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiGFI7D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 04:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiGFI7C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 04:59:02 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2684397
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 01:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657097942; x=1688633942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XAo4iCqpWuiqLkjDealKAj2pFJB/8wcMEZLtckjnIv8=;
  b=hD5qG4AMnD3Jk24wCRMlI1Z2ic7Oeym2q7KeRFb0Ao6OBi8lYKRsXgYC
   8XrkhiYfijowYHVfQIEyLNbJWir5MY+hqsQuY0/NLzqIYmgBvH47upY3s
   p+K/NF5/ce/IzT+4254twJcjIHjeSD3i4NTtJ0sWW2kE1v1LKSOMKhfuB
   PMPJAbwb9A5dcPxbL961swPVW/60aFyf6JE3ofrFuKhL0D9QY3RAVj6n9
   Y+nXfi9kbmpkWw6Egetsq6NDRoxBQPColEcmyrsLu8Ocob3hzueAslw+D
   ZnKVDgRo3NKOtpZBbn1pj8V1g7VLuW4c7zl7BcLg5OgUclXERgL6ahpvv
   w==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="163530139"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 01:58:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 01:58:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 01:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmBCaTG4X/HUmAFOQscpBemlICIAmEtceOKKI17mCaM8J+CEFaZ+BnnLitbi0WUT/SwUf1bRd7+Li3o9EU5BmWLbnr1TXBAyGz8JX0V9K72oNW7oFCN6fXxeiVxAd1UUhGfO1YKmo18PVK5ye+9CHXp0mPsO7gMPrU4/AImlUBWFN/JITRTo/Ny5v9WevBLLKV7FkpD1HbrZ1/zwaArX3+yqDQFWASkkszkE190mAI2w6uR1bLwF39aPxPXg54LbqWVvZ6ohkArUSdRl5q6jN5/SXY2Rx4kPyU4jlz3qt4H60KnhklnDdRu1YAOK7WlE+I5xCt96isFCCPMFGmGZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAo4iCqpWuiqLkjDealKAj2pFJB/8wcMEZLtckjnIv8=;
 b=cVgN5AIu+S3DipQiDI1az9Dg/OcWjx0H2v053VtrxgfYzKSJrGxe6cN9e3X8IL0ybFt40VlOi8SGUrvJ3+k8HuhPIDZfME2X07ii82f1Z/X5f8wobb+7q8u2wfvQW1XDEg8Yee8sCNM31AlbexkHzITTSwqyVfMSUorShp+71XHP0kB2Y42B1inxZQeHLGsUgcyiyIcTX9YnRTQvJJJ09863duHXhsRyKHWX7PBBqIJ8BN5joZaJVGB/IsGAKoJVNmWXzKNrMCw9irv2T8iM/Vg7GWeziBlmvX0r+9VP3Z9Yj5tJ7OiGwJDbY5HI5CxFJjtvfvWIDFCZoJMKrKa08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAo4iCqpWuiqLkjDealKAj2pFJB/8wcMEZLtckjnIv8=;
 b=sONEf1Kd69qL7fmqg2SfRQbZvAzF7HizjlHR1U7CW3ePmIYwca1N6C0rOOODppAyZYwC+AzYj/Fp7O/417VNbOejwdupWWafQxLVm7FBSTQHD3FhkFIompZqUyYkHWCNudtSM2JiUt9hg3ZHLJFiTgl6o8sWAIQ8VaV/4kEvDWk=
Received: from CY4PR11MB1960.namprd11.prod.outlook.com (2603:10b6:903:11d::21)
 by DM4PR11MB6068.namprd11.prod.outlook.com (2603:10b6:8:64::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.20; Wed, 6 Jul 2022 08:58:42 +0000
Received: from CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::80c4:1a95:649d:2ee0]) by CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::80c4:1a95:649d:2ee0%10]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 08:58:42 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH 3/7] crypto: atmel-tdes: Drop if with an always false
 condition
Thread-Topic: [PATCH 3/7] crypto: atmel-tdes: Drop if with an always false
 condition
Thread-Index: AQHYkRaXFODg+gB2Gka6Zc3d210KJg==
Date:   Wed, 6 Jul 2022 08:58:42 +0000
Message-ID: <3d3651b5-a6b2-8a2e-92ef-a2bb94b23a41@microchip.com>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
 <20220705205144.131702-3-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220705205144.131702-3-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71276ab6-65ad-454a-d252-08da5f2db9e4
x-ms-traffictypediagnostic: DM4PR11MB6068:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6+ixZxaQI0mh6D5nWX2+KJV6K/f52UnBReLfZn6uwsmNML2R7bY4UDbIEVJf3t8zTFsyMdQTrg2bjWkZP+8g7RrS7SetXjCWOCKuTHz9sQmjHgEzcrCtCx3w7D4NdotaY1U92zKeE5FJphud++NDgAr1QSpEsYDpQQLwTUB2sh6yh9z40mYxvfmRLF1VrfEA/oNnMW4LKUEZTrHGgMHSlqjqAgB1JtaMLBckJpYXSkszaFEgKN3E6xIvxp4NRPl/3iX6B/jpWayRaGjem5YjsLQqu0e//CHo6vujYO9ZQAmKrWGeLcYtq4fIsqnHWSOeslGFViED2iZ9F6Wb9UKd+FbhsF17ceXSnpzm2vGTZNnOvRai5ziH4oriYSJ//SejrWV9WlIBkeD/ltqA9rlri2TSsE/7lFH54k2jQL7FXdpNQSmBcVkswGNxGBTKhFpnAR3DzWL2m2JGSs2u3GEJ6mKeGRyzAQfsKsr5xzYYS2e+veqobrwIESmiII+nojmiqTlbWS1MP35PmBMPyLkURwPAjIOZOG71hp6Z3CVZWJgD8ZyKfSlJ2Eqwt/QT3Y7Uy1GzFMCJhMDXR5vWr5QH48F5dEfke3vuBa6+O1za6cxHfLySGJ07He3Y1NAq84ylWOHMfesZySLpcjJF5DndvV897Lcyqdiy8CGNepmc1bzL2RG6hNKHPL/5AQIR1nPju1bygrPwDeMkpe7zZf/Y5pYjl2jrxGTVqWrLC8USjfIcRAilHKcM2kpg4gFKaf0s4fjiGRkn4C2BwhrqSJd9N5iiTQT5bTMLo8IwAg8OYzQ9OAu7A/rNxedE84a2elmAqh6aShHNjY5YJqADDkGAbSy0Zc9bbhtC7WOdvYI7eVvkRVyGZIwWFownolBI71IA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1960.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(136003)(39860400002)(346002)(366004)(6506007)(83380400001)(36756003)(66574015)(8936002)(41300700001)(31686004)(31696002)(186003)(86362001)(5660300002)(2906002)(316002)(6486002)(76116006)(122000001)(8676002)(478600001)(38070700005)(2616005)(38100700002)(66446008)(4326008)(64756008)(66476007)(91956017)(66946007)(53546011)(26005)(6512007)(66556008)(110136005)(71200400001)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGxSMS9ETkVPUlE1TTdaMHBuOXZUenBscHdodG5pclJXQWd3T1c2Q1ZkcnBj?=
 =?utf-8?B?TzRXM3NIZFJ2ekZYME5DbGtvUDhOVTFlcmwxOVg5alBhZkxaakQrSzRKSzE3?=
 =?utf-8?B?TWRXYjlPTXBzUVhIejdERVFZTkFWajlrbUVxYURjUmQrb3BmczAwM3J2bUli?=
 =?utf-8?B?RGVRQWJ1ZmdjdVAzSTZUYjZQYmJRK0dlNW0wdDhjZzJHMW0ySlJkUC9vT2l6?=
 =?utf-8?B?S0taZ01nTXdJUjk1Zi9mSUtRUy9CWnhDVVhuSzc1RW9LOE5xTTcxRGtLNFBK?=
 =?utf-8?B?U0RaZE9vSGZDRzF3MFlVWnpDaDNzblBXQkRhd2tCbk90elZoYitZaTZQS0dY?=
 =?utf-8?B?cDVzUUhtaU1BejdDblRvK2hHWFp0dFZJZlh5RnFMaGVYdG0xSFFXUGo0UmJh?=
 =?utf-8?B?UTUxekJnekVRMDd2bGNEbXFycG9OSVAxV3ZBK0FENEFVSnZzTGp6UENHcmVl?=
 =?utf-8?B?YmRtWFBmR3hrTTUyVWxmazhvdGlCcmhadTFVQUxzRGkwbGVTNmZTWVB6S21N?=
 =?utf-8?B?MkxSQkNBeFo0a3ZWTDU2ZlNrclhJY1lKYWNWdW5oblRHTEtmalVjbWdsVXJO?=
 =?utf-8?B?RFZXQkRIdFAxZVFPaFU2RVlLWlIrdDlxbVB4SzVjMVlEb0NuOXpTMW5mNDlV?=
 =?utf-8?B?YWNWWUZKdjRDZjBhQkMvNmJKMHAxQ2k1Ri9NRU5kUWpwdll6em5aeEk2TExh?=
 =?utf-8?B?dlRxT29jQzRza2dBT2lvOTRDWWpRbWJkei9kbUFlaWRlYVZRQUZjYXpGN0l1?=
 =?utf-8?B?NWJXVm9lZ0IwTFA2LzE4c2cvcFI3QmZBb0dQSWNRUHN6MzgzY3BRWWs3M1F3?=
 =?utf-8?B?dmJ0dFpHRVFydWVxZHpxYkpKZkdtRVZZc2NRZnBPK21BUzJiRGxkcUZNeWNl?=
 =?utf-8?B?WTdMOGQ5bzUxZmJQdGZabGRQUGhRQnh6aFhaK0h5TnBMTXF2bGE5d0VZdFVo?=
 =?utf-8?B?d3FGOHFxemNCNHZuQkNmKzk5aDNlYlJueElVVEtVUVI1VmJxVVNlc0t0V25J?=
 =?utf-8?B?WnBDdEdDc1pDcW1Dbm9HSm9VU3lKdHpERGdTSGQ4MFd1TlhycHRoR21yNDJB?=
 =?utf-8?B?SWNDOHBWb0RrWExZMTUvVGFBSWQ3Vm93Q2xuN2cvRUwrWEkxYlcycW1sTEkv?=
 =?utf-8?B?di9kazVDdU9LTHJJN0RCU3pjTHlDdXlrZVBmRVBMeVBHcVgrQmRONHh1Qkp0?=
 =?utf-8?B?QzVnSFExL003L0pwWHBSbmpnUlFZcDlVS1FqQzg0cGJvaEZTb1Y2UnNmMTF1?=
 =?utf-8?B?RE1uSlh2MTBwZ0g5UmpJZEprN2prZnoxR3JnMWxkVFovQWNFajNiUG5EMkdT?=
 =?utf-8?B?bG13OFpKMXg1OTc5b2pIcElHUGlpcis5d0RrUENmYXRheWhIK1pybmFQR3pF?=
 =?utf-8?B?YnlxRklZemYrUzR5R2I2VXBGUEcwTXNqWW81cFFURkh0bHJKRjl4QVJ0Tm1Z?=
 =?utf-8?B?aCtabHhuZnlxVWpPYXhlSllSV3hsOGlUSUNudExEQkRFM1h5L1pvVm5yRGxk?=
 =?utf-8?B?YStsMGlRU0FBcnZZakROeDZJMERCeG43RndVYWM4blA4OHBNb1hoMUw1akll?=
 =?utf-8?B?WVdhQXZROVdSWExMM0ZTb3NvcHJpT1Y4SDhSeS9mVllSbDd2WGIySEhkWEFD?=
 =?utf-8?B?a0hwaTliMDRhbUVTZnZGM2htWWw0aCtlbEsrQTJyV0NHL0FodjNhcnlERjh5?=
 =?utf-8?B?cURkNmFDNDhhYURseVd3VVZJWmR1a3JsZWtTV3BJU21Da2k5WCtTUStnZFg3?=
 =?utf-8?B?b3loakM3SUdSV3hUOHhpcktWaXRGRlNUQlhoZ2J0OWg5UDRMMVpZMFZOWTR1?=
 =?utf-8?B?d0diWFA1aFovV3R0TlFuRW5MK0tjeE0xR0ttZmpaTnZpV2V3eDZmUFB5bGVi?=
 =?utf-8?B?SWF3N3FQMUFZVXpndHR0c1IvZlJKVjVEc2U0bmd0VWU1UXpqSVppT3hVNFVo?=
 =?utf-8?B?VEtVTWhsUmIrdVZ4bDdFNGNodzhBanV1ZnBqaFRWY2ttUGZRcDRONWx1M2Rl?=
 =?utf-8?B?SmZ0L2srbzFUcmR4dGkxbGMzRVVUUUtvN3BGSGZObVdVUVVUWHlZWmZ4djFE?=
 =?utf-8?B?SGZaYTNmNXNYdGNSSVNvSlowcnVzTWZ6RDdlOTlmOGdMR3I4L3N4NythY2k0?=
 =?utf-8?B?UWlSdzBTUmdRWWJUVHBYWXRpN3E0S0hSTkRrVWFDemFBR1p3ZHUzYU5tS2x2?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92C806B540C85B42AC01C02237F05EAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1960.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71276ab6-65ad-454a-d252-08da5f2db9e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 08:58:42.3249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YSzQnfZ1r7xmvZE/x/saAiCQbyaUIPToROAx8Qmr9g4q22mIwcX9PSfZFFOUDxyFLv0HW8oMmYXOxyRxz8wLp3Sb2A1nuB1Tbrk7A9j/VfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6068
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMDUuMDcuMjAyMiAyMzo1MSwgVXdlIEtsZWluZS1Lw7ZuaWcgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIHJlbW92ZSBjYWxsYmFjayBpcyBv
bmx5IGNhbGxlZCBhZnRlciBwcm9iZSBjb21wbGV0ZWQgc3VjY2Vzc2Z1bGx5Lg0KPiBJbiB0aGlz
IGNhc2UgcGxhdGZvcm1fc2V0X2RydmRhdGEoKSB3YXMgY2FsbGVkIHdpdGggYSBub24tTlVMTCBh
cmd1bWVudA0KPiBhbmQgc28gdGRlc19kZCBpcyBuZXZlciBOVUxMLg0KPiANCj4gVGhpcyBpcyBh
IHByZXBhcmF0aW9uIGZvciBtYWtpbmcgcGxhdGZvcm0gcmVtb3ZlIGNhbGxiYWNrcyByZXR1cm4g
dm9pZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFV3ZSBLbGVpbmUtS8O2bmlnIDx1LmtsZWluZS1r
b2VuaWdAcGVuZ3V0cm9uaXguZGU+DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xh
dWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8v
YXRtZWwtdGRlcy5jIHwgMyArLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9hdG1lbC10
ZGVzLmMgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC10ZGVzLmMNCj4gaW5kZXggOWZkN2I4ZTQzOWQy
Li5hNWU3OGFhMDhiZjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2F0bWVsLXRkZXMu
Yw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC10ZGVzLmMNCj4gQEAgLTEyNjYsOCArMTI2
Niw3IEBAIHN0YXRpYyBpbnQgYXRtZWxfdGRlc19yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldikNCj4gICAgICAgICBzdHJ1Y3QgYXRtZWxfdGRlc19kZXYgKnRkZXNfZGQ7DQo+IA0K
PiAgICAgICAgIHRkZXNfZGQgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4gLSAgICAg
ICBpZiAoIXRkZXNfZGQpDQo+IC0gICAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gKw0K
PiAgICAgICAgIHNwaW5fbG9jaygmYXRtZWxfdGRlcy5sb2NrKTsNCj4gICAgICAgICBsaXN0X2Rl
bCgmdGRlc19kZC0+bGlzdCk7DQo+ICAgICAgICAgc3Bpbl91bmxvY2soJmF0bWVsX3RkZXMubG9j
ayk7DQo+IC0tDQo+IDIuMzYuMQ0KPiANCg0K

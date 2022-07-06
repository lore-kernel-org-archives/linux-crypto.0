Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 864DEC43334
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 08:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiGFIro (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 04:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiGFIr1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 04:47:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A926315A1C
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 01:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657097245; x=1688633245;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mdFitPYMrx77EgayDpGs3N9yiV/vpGA9aPoJNL83nJ4=;
  b=VtlBtYUSeUu0A5iR57ne/UD9221FZJAmy5/yrG9vIPZpWCmR5sAkY4rE
   m5m8+lN1gw228XViXZfSTc5Zv7c8gDRUDnDZt6F+7rgZ89x7dTyM7l4/+
   v4guals8lrETNC38YWDgbuZyE33l2cJHYn7fchiUx/1bQce35MA2qba/4
   YInoyE59udYDCLvgJay6Yl0nLpjfAhZrWliQOReJQUd2evDQUlGGZdOeG
   +xBF4wn0ctESXphNuWbSRFCtIUuA591vIcEYhHfKY8AwIs8JrBQJrHYzH
   z/kFpP1GYv8s80OhSJH22tG3PwFXEFdU3GmItw4xHrSck5Ls6suEfIiow
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="166585562"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 01:47:24 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 01:47:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 01:47:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvsHVqMi85Vxnsq0JsrC7T9K1XLbdYfrkxpOol7DY4Zr8V5/LSGcukFRFqfn1OCrEzmM/oiLZMIS1+G9RIrmND8K38a/gmv6jcoj2axwTm+p8WhxdTeneJXoqJvCBTSAHBiq/bndsyNEoKRQIG4KjMXW6G78yc3W01xeU+2QQFeO2tubhl6hotDL4GobP2mSpyCrvNe3Q9ArQtigWwGDxPD51rtbGZk7FRIqPrSz0b35y2Hirt5zn6g5vEMzJvLpGCqGkE7kG+Ag89a877VBR3li0h+gqJffan+oL4uFaSTXM4+lantczk/J+wWfKhBuZfZUfoZhwF23R5m0yeztaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdFitPYMrx77EgayDpGs3N9yiV/vpGA9aPoJNL83nJ4=;
 b=Ch6XCWwA8yF5ijBdef88f2HHnvISU9rV2/9FQr7HhpqWPY2FYeK+i54uW32SX9j14XXJ48k0w2r4pjipCvvPSihdXP1ozPxj4mTJnHjqms43wXealK8P0ow+WKvH3DbOu3L9gGpLIEYqNVYn8xbusLhpuOMTzurMBEU4YH1iKkiOeW1D+bMNf9+a3qomuYPHEIg6ioN0800x5dmRvmrO0HPyywqmiZ8k0woqpHE6nLVtAO3CotqIvK3p7QGrBhmx5yAWsS6ukBormz/vYFWL5EmypKjrMfbizpt5LU0NkTN7gOG4g+GyE7iQa1VvR4DnzegWOBm7e2Voc2tT0FUUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdFitPYMrx77EgayDpGs3N9yiV/vpGA9aPoJNL83nJ4=;
 b=UA/dCaTi074qEk+1jUh5MCXuJDqN1Kb2JSxbdoyEqytQDtbgW1O4rxNKSutf31ozFmkvwwfKXTLGn6G5Md0DuiJmXNbVTaPpSskYFO+HDXsQIx9tAGhTaex3tsyi53bmz7GUDlXd2+Qnf7xzywpEunrxghSO43eeJ4EucLqfYq0=
Received: from CY4PR11MB1960.namprd11.prod.outlook.com (2603:10b6:903:11d::21)
 by CY4PR1101MB2199.namprd11.prod.outlook.com (2603:10b6:910:1a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Wed, 6 Jul
 2022 08:47:22 +0000
Received: from CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::80c4:1a95:649d:2ee0]) by CY4PR11MB1960.namprd11.prod.outlook.com
 ([fe80::80c4:1a95:649d:2ee0%10]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 08:47:22 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <u.kleine-koenig@pengutronix.de>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH 2/7] crypto: atmel-sha: Drop if with an always false
 condition
Thread-Topic: [PATCH 2/7] crypto: atmel-sha: Drop if with an always false
 condition
Thread-Index: AQHYkRUBMCW5/RhHxUSb75dIXrPgAQ==
Date:   Wed, 6 Jul 2022 08:47:21 +0000
Message-ID: <5a29e68f-691c-267a-f270-b5955ff73e08@microchip.com>
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
 <20220705205144.131702-2-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20220705205144.131702-2-u.kleine-koenig@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 464b982a-d511-46d1-4466-08da5f2c246e
x-ms-traffictypediagnostic: CY4PR1101MB2199:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XPMbak3jhnNFj+QR+yC4ZTL/ZxtE3sTmFJhlYAqjnkDdfbqyxhrkTD30jmN+n1CeoCuR+DaovzR3FIDv1Ttj4vUqgPhgyqpFVyjsd/VY5uZQ3I4R7TrDHRf8xaTgr1Ce4V29KQyueSeG+HbePTTq9ukQFulmA9hq+Q168KfLqYsOZup/hDuTyj1RS4MksMKvMhNwrFosABcneylv/INbFUCS8fTdeZlP6Zk1fiz3gy+NMt52WlUleyitV9xRwPb6bMgA2D6LSpjcG9fFF00Hi/a5bDrY37ww7wbn85LAEA8GQziYEAUv1yxOhUo6x3WgY8HGDpXpd73GjTW2b/PYnkyVVV3JfwXvMaX+Pz/M39Z3mgzYypguaSH3/16f632MMd4L0pJhgWjbI+bCES8Dcr5apZli1FQGAcJs7o3vLVTf7vtg9SSz23Mj050JhD0W4ZOtWVFHvqc/qJy4zWCcmxv6h0Pn8YoNyOO6xayRFoucKcZfpwFEb+qDWeahqxlVKexHlW8WnIC7jUlHJPExl1mj7VylGs+hjGn/tevEKkgRGmdF5/bVVFZSAL7xXow64wybW14ck/ugM3BKwRKHGfe3z8NCi06Dwo87seezpjZxEhKReSL50PKIKQyTjIMly5uLDUGzdmQEa4Gk6AdEcY6m2ivkuUtWL1by7QH/dllCrwRkxLKtar89r7jWdDIgegRtl3lHEvAEg8qEUylgS8XUjKabjuttBC1RVHGS1ye6RJwUmhFAlsagksw6Z9nw6b9Q8XptYqoGKL2jOOUC/CyLdYY+/XlfpYK9AK4kd5aKM1BFyH1HrnBsJO2JGZx6MuB/GSDS97IS4Djdh9S3qhpumSTCrKEwl+gKgdqEEdQF7rllS4Ka3EY7Jd4k0hW/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1960.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(366004)(396003)(346002)(2906002)(6486002)(478600001)(38070700005)(122000001)(54906003)(110136005)(316002)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(91956017)(8676002)(71200400001)(38100700002)(4326008)(31696002)(86362001)(31686004)(53546011)(5660300002)(186003)(6512007)(6506007)(26005)(8936002)(2616005)(41300700001)(66574015)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU5uYkxhZU5jQTVRZ01QclZDRFNCYnoxNkRwUXRSRlE0Q094RUhlVENwNDl4?=
 =?utf-8?B?T2hGcXk2WnRVTEZzMDdCdVNPcFlvTmo2UXNiMnhKdkZMMlFrRHNUVnZRQWMx?=
 =?utf-8?B?Mk5VakpOVytPMktncm1QNmRkS2dZMGlKaytIbjVNc2sxSVliNUIwK1BiOVo0?=
 =?utf-8?B?WGZVL29ZWGd3R1RNbDZhcFV3M212Tk5mQUlldndKQnBjV29wUGVCUHpqbzJl?=
 =?utf-8?B?MUszN0xyMXFDeGZIQVBzL0JuWURsa1BuQzBQQWtOUElHUGhBdFpXTlYzSVc4?=
 =?utf-8?B?TlRIb3hKaDVpVGRqS3J5aktURDB5OFJTNXVKVVhLM204TEM4S3FEMllPcWpn?=
 =?utf-8?B?RVpKN3lyMzByVENtVEdOdnl2ZURUYzQxT1hpclBDY1ZkNE5nSngzNWJaVXBT?=
 =?utf-8?B?eWVqalNjRVlEQTJabTVydDhJTUNobktOKzBnQXY1M1NvTnMvdU04ZW80UmxQ?=
 =?utf-8?B?cThSK01GcGluVHM5MncvVUZ1SmFXWjE2TDlTYXB3L2hPQzY1YjhnTW05REcw?=
 =?utf-8?B?SUV2ZVB2UGdSS0pnRklpTzQrYXBBZTQ1dDJMVmRqUmp2Y3p5VEcxS1Z4Q3c5?=
 =?utf-8?B?R1FUdFdGS3BncUVzWmoxKzljWko1ZWJUZGRSVGluOGJEQ0puWFNncm1FUElE?=
 =?utf-8?B?Z2dnQkwrbWhaM2VLY1M0RXFPSXNpZ0thYjNLVTFxb2E1TjZNRXJwa0Nzc3hX?=
 =?utf-8?B?OHNQbzEzdDNJRTkxdTRiR3oxYjBxZnlHZzJRRnBvY29FTTRMQkpROUlaMmpl?=
 =?utf-8?B?LzJkVUQzMlZ3ekxBdm5VbDV3Y284MzBmRGp0cndMTGRJVnpUK0kzSEd2QU1r?=
 =?utf-8?B?WHdVRktEc2QwbW9ZQ1JZeUcxeHRIclgyMU1lMmYyaWhwSERlSXdSS3hVR1RU?=
 =?utf-8?B?dTcyQk1KRy80RWk2bTJCclNOKytDNk1QcTBXUUFBRTNJeDJwTzNOVnB4cDdC?=
 =?utf-8?B?R3N4RWVHWExKQkFsN2xvVW1xeElqaTA4UXp3c2tuS1BwbVcvQUp0TEg3MkFL?=
 =?utf-8?B?WGhkUklXRkhxcnVkVER3eW54S3ZGbUhmd0ZUQ1E3T2ZtYURaaytnL0pZTCtr?=
 =?utf-8?B?c3FKR1NFSWlKS0JUb2dTZjFUNnNtN2lYUU9CblJpZDh3SXJGVzk3Ky9ZOUZh?=
 =?utf-8?B?b1hKYzV6cVZLd1NZbExrd0d0di9QOFNRV0I1aVdlR1p4M3hMNXlNSyt3Qnkv?=
 =?utf-8?B?N0pVU1lOd20zRFNoaFRzRUZVSysvRHJvTWVqajZmYzNsdkRzY2hQY2VDd3Ji?=
 =?utf-8?B?aGNWQVhHN05PSmdDdkIrZlJVbWJXRUVRTCtUWWQ4ZVdHRXc3bEFFb0Jzb3A2?=
 =?utf-8?B?N05XcUUxSFh3WU43TzJBREpIUXRoTlJuZUNFN2NKUlFXa245QThmYTEySjMx?=
 =?utf-8?B?MnVYMlIzcENkSHRNWEhnYkVrUlBqSEs0ZXAvWkgrRHV3V3pQalNrSk91RVlv?=
 =?utf-8?B?V1hVOFpXQzU4OGtWcDhhWXFlbUtiY2pXUmh6KzA2c3pCL2VIZmFUL21UZlVM?=
 =?utf-8?B?V2M4RVR0YUtvSDVkUVprU1o0b010RDdSRDJ3THIyNGRrV0pOWlVvZXBkYUp3?=
 =?utf-8?B?U1NnWWl5WXZ3dG9vYVYyOVJjemxCaHJmcDc5WnBQR01ZL1ZUNVY5c0k5QnJW?=
 =?utf-8?B?OGZMdUhEcWlNN1JVQ1A4ZW9OU0FLbFV3ZlBkeng1UFlZM1pJekxtMTM1UC9o?=
 =?utf-8?B?K2srNGtLVGdodGVkTEVnR3lqNTljVE56Y2t5SjdGV3BBelVRcEIxUUZTTXVY?=
 =?utf-8?B?aFBmcTFGN28rTyt4UlAvOGhXWlJRVjJiVG1FK2RkaG5GYlo4bVVYSTVBU1RY?=
 =?utf-8?B?Wld1R2Y0YkNpQW05TzB3bnFVelhoenpFMDA0Znh1b0JLUjNDNlNJdnVnTmFs?=
 =?utf-8?B?bzdNQzZFQUxzaDFhNDBZS2JNTmlIMzZsQk5rRTl6bFNmYzZ6ZDI2M082Rndn?=
 =?utf-8?B?dUgyMXlyQUtCRW55S01Kb2IxUWYzVEFMS2o2bDNpeWN0SlZpRkJEZW1adkZh?=
 =?utf-8?B?TmNLcWFFOGora0RVVHNFNHpMb291dlVtRzhLbngweHVaMnpHMjBKMDBycy9z?=
 =?utf-8?B?WU5NT2pJQ2o5N1M1L1ZrelhnUmtDdUlqVU14eTlxTzhYV0ppdzUydzBrSjZS?=
 =?utf-8?B?UTFESGtqOHpTcWVZSHNhSklWSk5UbzNtcDJ1SUR5clRTQjZIc0Nxam5LbWg4?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C6E018802EE364797DCCB8A2A13A56E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1960.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 464b982a-d511-46d1-4466-08da5f2c246e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 08:47:21.9598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHPPCO4tVD1tqzoUTkgBperSDyAnHvXD/v+VuUA5Wc9pr1gyiAoIhuYSSfdsHap+JNIaXf1g7rFwPyBNvIWednIUZP7BtKUL/uoHWlP5RzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2199
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMDUuMDcuMjAyMiAyMzo1MSwgVXdlIEtsZWluZS1Lw7ZuaWcgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gVGhlIHJlbW92ZSBjYWxsYmFjayBpcyBv
bmx5IGNhbGxlZCBhZnRlciBwcm9iZSBjb21wbGV0ZWQgc3VjY2Vzc2Z1bGx5Lg0KPiBJbiB0aGlz
IGNhc2UgcGxhdGZvcm1fc2V0X2RydmRhdGEoKSB3YXMgY2FsbGVkIHdpdGggYSBub24tTlVMTCBh
cmd1bWVudA0KPiBhbmQgc28gc2hhX2RkIGlzIG5ldmVyIE5VTEwuDQo+IA0KPiBUaGlzIGlzIGEg
cHJlcGFyYXRpb24gZm9yIG1ha2luZyBwbGF0Zm9ybSByZW1vdmUgY2FsbGJhY2tzIHJldHVybiB2
b2lkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xlaW5lLWtv
ZW5pZ0BwZW5ndXRyb25peC5kZT4NCg0KUmV2aWV3ZWQtYnk6IENsYXVkaXUgQmV6bmVhIDxjbGF1
ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9h
dG1lbC1zaGEuYyB8IDMgKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtc2hh
LmMgYi9kcml2ZXJzL2NyeXB0by9hdG1lbC1zaGEuYw0KPiBpbmRleCBkMTYyODExMmRhY2MuLmUw
NTRlMGFjNmZjMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jcnlwdG8vYXRtZWwtc2hhLmMNCj4g
KysrIGIvZHJpdmVycy9jcnlwdG8vYXRtZWwtc2hhLmMNCj4gQEAgLTI2NjksOCArMjY2OSw3IEBA
IHN0YXRpYyBpbnQgYXRtZWxfc2hhX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KPiAgICAgICAgIHN0cnVjdCBhdG1lbF9zaGFfZGV2ICpzaGFfZGQ7DQo+IA0KPiAgICAgICAg
IHNoYV9kZCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOw0KPiAtICAgICAgIGlmICghc2hh
X2RkKQ0KPiAtICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ICsNCj4gICAgICAgICBz
cGluX2xvY2soJmF0bWVsX3NoYS5sb2NrKTsNCj4gICAgICAgICBsaXN0X2RlbCgmc2hhX2RkLT5s
aXN0KTsNCj4gICAgICAgICBzcGluX3VubG9jaygmYXRtZWxfc2hhLmxvY2spOw0KPiAtLQ0KPiAy
LjM2LjENCj4gDQoNCg==

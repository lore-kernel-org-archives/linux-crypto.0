Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04C4C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 12:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9D321D93
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 12:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbhADMAD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:00:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:7584 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADMAC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 07:00:02 -0500
IronPort-SDR: 69EuQhnoR4TRh6shb1MQo2ZVtUBoDqNy1pXUg1MQdY4rpJqBo6HygPFS7UiIBo5T3oaXhLsq12
 hqrsMnaq4+Zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="238493480"
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="238493480"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 03:59:21 -0800
IronPort-SDR: 4wMSa0V6dPTdjkHPY0AiTBEQ4UHwF5KmK6FBjVSOWdU2K4xt3j9e2gvzFKlFBsTOmaKUYmae/2
 AyCdpj4iKmHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="421346551"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2021 03:59:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 03:59:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 4 Jan 2021 03:59:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 4 Jan 2021 03:59:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFCoHfnm5MSO5v3YAR7Rx5SkohIBKBDEcLkXlfDnn8duXHokHTVHlY8SAnTpbwVaFiKvQvKf8no0tTsvZKo3eR9o8xEJDEviWoB2iXjhToQFUEH32QpXJnmIXi82D89P1qs7crA1yibIFznCuVFiuYgJbdgRYYj1leg6N4S4isZgExep2YRvqxu7/lw/BAbpqgoilglfdOQWSFDGFTBnapJco0PUvjjIvb24XBLfi9Khkwr5mNIf6UCTA4D8ki2uWFlUaNBYyEbqWHYhc9UYPmPjioiuAolJsa2EUp6ZdP/Rrs2x0L0/Q7d/FIhlBiIChsVwzoNtCyKp6s9YYNtO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJC3JjUNutXCmeZ3SzFBtkOxBGyADT3DF+NU9g/y47I=;
 b=Yzj0Mp1I/0MAW5wR6X2kKV5xXY2upmgUuF+va58buu1DtOfTfa+T8zeD6jI4cjjDS7HUWOulZRkCIlS6kUpfDdRDKaDJMFmT2Lvr8IixUDsviX8XLPqRITEywqH2/aqDiosXO+O2trT+9Ddb4pv1JcXrYzqe4GRP9KxCzSNBaTavYmATFDNLYNnAbFAE1DfnGpUyd2Cn/nFK3GA7k1lPEdC2QNalMcUH72XTqUvZmKdmCAJ/ffKLwiAWrPQdU7EfSeW1bSfailPtTxWpDtfqtr8czHeWJtkZSO7YTudQQL6MwEddbGYHMuIdR8p319NyeviTTXjEEMs0blWveltUXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJC3JjUNutXCmeZ3SzFBtkOxBGyADT3DF+NU9g/y47I=;
 b=WYOGA5vV3aPr+Oe5orGgEMFnH3AEivVMso/258q8gE/7Txs6nBng6mNUoaKzLQpYg0MDvJiohIZ3bXwcGdnmY/LfiIV4d+JogdfBmXESMB7x03RwHeePLlYn4Nb6rCHzzS1ZBiIZatZKQiZWkW/kjbOrI7Djskb0aROcS1KYRhg=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA2PR11MB5177.namprd11.prod.outlook.com (2603:10b6:806:11c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Mon, 4 Jan
 2021 11:59:19 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb%3]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 11:59:19 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Murphy, Declan" <declan.murphy@intel.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v4 0/5] crypto: Add Keem Bay OCS HCU driver
Thread-Topic: [PATCH v4 0/5] crypto: Add Keem Bay OCS HCU driver
Thread-Index: AQHW06Exh5lRwa6VTk2fZEmWlB0cV6oVACgAgAJ6o4A=
Date:   Mon, 4 Jan 2021 11:59:18 +0000
Message-ID: <ae9a431c1a9ca3b4597d2789714c7c35b9cbdbf8.camel@intel.com>
References: <20201216114639.3451399-1-daniele.alessandrelli@linux.intel.com>
         <20210102220750.GL12767@gondor.apana.org.au>
In-Reply-To: <20210102220750.GL12767@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c05d338c-d068-4c75-f3bf-08d8b0a82ac6
x-ms-traffictypediagnostic: SA2PR11MB5177:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB51772093109DF973AA146530F2D20@SA2PR11MB5177.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: attlch7g6EvfQ/iIOEnyG14bi+j2brgDk76CIe5uUFvMaZFm4t+z7U7ZnAg6NHTJ6LLvMUOSYBL8lxUMvz7zGz5wYh5A/ilj7KVMDLxXX0KdsEIyjVDbAJS7U3TR+ao7i4asVWLCb07qCXCSSSm7YBtmCg0xc4no2c429hOu/GVSlZqFtAPFxAbKMXeShRiOegfZrEUYAMos0dnlSj5ZxnZfVON4DioiPq5VV52DB/pivMJS0P87xFyNQNQDzbbktV2UpaUCQPY8EcltfDASeWrsoy86H4CWEOlVYzpyIgjx9XrnxObXynvkhzsh2gb/qi3Bz3fw4pBP+8PH2vMVq3ict9aSyEcG6wNX1U9jKD/Br/4WZs27UuNi+2bPyzPMFUExgQYTs8cdynckp0605RNyuIJuRH5bluOYaybHB258jqrKj7KYlT5g+qMxSeWUI/FZQDWlzgnYZdY6jTljjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(6512007)(86362001)(6916009)(2616005)(76116006)(54906003)(4326008)(186003)(71200400001)(6486002)(83380400001)(478600001)(966005)(66556008)(26005)(2906002)(66476007)(8676002)(6506007)(5660300002)(36756003)(8936002)(66446008)(64756008)(66946007)(316002)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MHZoMFY4Z0hqckh0eVRScUpodVY1VGNXRzdMQ1JKK09nOHp2N1VHMVE1QTRT?=
 =?utf-8?B?eGxsU0JRK21sQVZoVytUeFozdHJkaThqQktDb2ZSYno2MUZleVo2TmhTUkQ2?=
 =?utf-8?B?MDMxbHErVXhES3BJVXVQVjNJYy9QL3FzQiswbmVGR3ZnZzk4bExySUgzR1ZL?=
 =?utf-8?B?bjNKZkZEeW8vTVpJOFErWjZhVXc5SWdZb1J6OFRORW9rTFB0Y3Y2YXphWHhC?=
 =?utf-8?B?bUxSeUVXVUxlalA2cksrMWFmdjJKQUpQaGlZRzR3RUFWRUR6V1hlbHVLMTZW?=
 =?utf-8?B?T3NwVUk0c09BSGtVQkI3UDYxaWJ4Vjl6MDhCS3NqMWV4SXJxVTVLd0RpT2c0?=
 =?utf-8?B?cVFCcVRHem13TEVzLzNMd1dPK3c2TTByTXlPRTVHY1k1ME1BZ0ZVZmtOTE1F?=
 =?utf-8?B?QXB1a2YzNXg0R2JZMy9VMk1jUGpzMUJoZzZRRlUyZmhMR1A0RTNCaUMwZmlI?=
 =?utf-8?B?T0NpNGtLMmEvUUh0Zmt6dDZPRVcvaUF5SHd6VXBWR3RmaUN3RE1oaUgwenBm?=
 =?utf-8?B?YS91T05ROEl5Sm96R1RkVTNjZXJzbEdMTThsWkVieVhURUFPTHk5WmNMNDUx?=
 =?utf-8?B?NHdHL25YZ0ZIMmxPMGxMMURYM2tvYkczb0NlTEdTZDd1YWZxTnVJUk1raFhm?=
 =?utf-8?B?N09wM0tyNVBtZURORGQ3eUR3QlVIOUVvZXVJWEdqUGdudzZaYWN5cVJ0QXFQ?=
 =?utf-8?B?UW94NENkOVV5aEpSUzV3ejJLVzFhdkhzVXRKbFhjeVQvU0tHVDI5N2RGdlRr?=
 =?utf-8?B?dVJXQXRwbFUyNllSY1FDYnA1d2dSMTdFSnYxNm1wR1FhcXAwMm1FR3ZwN0JW?=
 =?utf-8?B?V1E2dTA1V2EreUdHT25pNjJMTFA3Q2ZjWXZaUThQRXBObWtzR3doRENienU0?=
 =?utf-8?B?VW9UZmhDUmNVek5HQnFCcmRZWGRReFZKb3BxeW1pLzMyeWh3S0RLTDNZcnlh?=
 =?utf-8?B?RFBpb242OHh6bkU5UTQ4cUhTZXZkZ1A5aTRSbFE2NWhxZ3U5b0tIajBDTU8w?=
 =?utf-8?B?eGMvOWZRcnR3enZZOUpPWVNxRjJYQ0hnQ2FIOHFScHNGa2dwN09xTWN6Yisr?=
 =?utf-8?B?dW93Y2htT1RXdm1xRS9KSFZ1c1hOdEJFQjJmWmRUZDRvYllmUmI5TkxUMWtK?=
 =?utf-8?B?M2R4OFpuUS9pVnMybVVWZGtVaFB4OFJ3SEdZZzRhYnJhWUs5bFY4R0JHZWJQ?=
 =?utf-8?B?aGZJKzBXVXBxbmZpZlVDR2xMYTlWaVFXQmQwVW0va3F0aUxpQmZNd1ZtNnJq?=
 =?utf-8?B?T0JWOVozbXNVcHBKKzc5MkN4K3FHKzlURXpwbGhaYlpZYU1ZMGlkWkhtUVYy?=
 =?utf-8?Q?Xav9eDqKGs/ValJz4UMjeGFy1fVN/E2qMx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7E1AEEC17EE594EADB3A3DFC468BF42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c05d338c-d068-4c75-f3bf-08d8b0a82ac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 11:59:19.0031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xfo8FGnNhBDToMWXdRZl+Tjf2651uyf7ivfpIBNFS4a+NtChXVFP0TxngaKULJw6TjIuAz5NF0qyyHseQrkyJv1VECedsFHc4eaH5sZY2XU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5177
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gU3VuLCAyMDIxLTAxLTAzIGF0IDA5OjA3ICsxMTAwLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBP
biBXZWQsIERlYyAxNiwgMjAyMCBhdCAxMTo0NjozNEFNICswMDAwLCBEYW5pZWxlIEFsZXNzYW5k
cmVsbGkNCj4gd3JvdGU6DQo+ID4gVGhlIEludGVsIEtlZW0gQmF5IFNvQyBoYXMgYW4gT2ZmbG9h
ZCBDcnlwdG8gU3Vic3lzdGVtIChPQ1MpDQo+ID4gZmVhdHVyaW5nIGENCj4gPiBIYXNoaW5nIENv
bnRyb2wgVW5pdCAoSENVKSBmb3IgYWNjZWxlcmF0aW5nIGhhc2hpbmcgb3BlcmF0aW9ucy4NCj4g
PiANCj4gPiBUaGlzIGRyaXZlciBhZGRzIHN1cHBvcnQgZm9yIHN1Y2ggaGFyZHdhcmUgdGh1cyBl
bmFibGluZyBoYXJkd2FyZS0NCj4gPiBhY2NlbGVyYXRlZA0KPiA+IGhhc2hpbmcgb24gdGhlIEtl
ZW0gQmF5IFNvQyBmb3IgdGhlIGZvbGxvd2luZyBhbGdvcml0aG1zOg0KPiA+IC0gc2hhMjI0IGFu
ZCBobWFjKHNoYTIyNCkNCj4gPiAtIHNoYTI1NiBhbmQgaG1hYyhzaGEyNTYpDQo+ID4gLSBzaGEz
ODQgYW5kIGhtYWMoc2hhMzg0KQ0KPiA+IC0gc2hhNTEyIGFuZCBobWFjKHNoYTUxMikNCj4gPiAt
IHNtMyAgICBhbmQgaG1hYyhzbTMpDQo+ID4gDQo+ID4gVGhlIGRyaXZlciBpcyBwYXNzaW5nIGNy
eXB0byBtYW5hZ2VyIHNlbGYtdGVzdHMsIGluY2x1ZGluZyB0aGUNCj4gPiBleHRyYSB0ZXN0cw0K
PiA+IChDUllQVE9fTUFOQUdFUl9FWFRSQV9URVNUUz15KS4NCj4gPiANCj4gPiB2MyAtPiB2NDoN
Cj4gPiAtIEFkZHJlc3NlZCBjb21tZW50cyBmcm9tIE1hcmsgR3Jvc3MuDQo+ID4gLSBBZGRlZCBS
ZXZpZXdlZC1ieS10YWcgZnJvbSBSb2IgSGVycmluZyB0byBEVCBiaW5kaW5nIHBhdGNoLg0KPiA+
IC0gRHJpdmVyIHJld29ya2VkIHRvIGJldHRlciBzZXBhcmF0ZSB0aGUgY29kZSBpbnRlcmFjdGlu
ZyB3aXRoIHRoZQ0KPiA+IGhhcmR3YXJlDQo+ID4gICBmcm9tIHRoZSBjb2RlIGltcGxlbWVudGlu
ZyB0aGUgY3J5cHRvIGFoYXNoIEFQSS4NCj4gPiAtIE1haW4gcGF0Y2ggc3BsaXQgaW50byAzIGRp
ZmZlcmVudCBwYXRjaGVzIHRvIHNpbXBsaWZ5IHJldmlldw0KPiA+IChwYXRjaCBzZXJpZXMgaXMN
Cj4gPiAgIG5vdyBjb21wb3NlZCBvZiA1IHBhdGNoZXMpDQo+ID4gDQo+ID4gdjIgLT4gdjM6DQo+
ID4gLSBGaXhlZCBtb3JlIGlzc3VlcyB3aXRoIGR0LWJpbmRpbmdzIChyZW1vdmVkIHVzZWxlc3Mg
ZGVzY3JpcHRpb25zDQo+ID4gZm9yIHJlZywNCj4gPiAgIGludGVycnVwdHMsIGFuZCBjbG9ja3Mp
DQo+ID4gDQo+ID4gdjEgLT4gdjI6DQo+ID4gLSBGaXhlZCBpc3N1ZXMgd2l0aCBkdC1iaW5kaW5n
cw0KPiA+IA0KPiA+IERhbmllbGUgQWxlc3NhbmRyZWxsaSAoMyk6DQo+ID4gICBjcnlwdG86IGtl
ZW1iYXktb2NzLWhjdSAtIEFkZCBITUFDIHN1cHBvcnQNCj4gPiAgIGNyeXB0bzoga2VlbWJheS1v
Y3MtaGN1IC0gQWRkIG9wdGlvbmFsIHN1cHBvcnQgZm9yIHNoYTIyNA0KPiA+ICAgTUFJTlRBSU5F
UlM6IEFkZCBtYWludGFpbmVycyBmb3IgS2VlbSBCYXkgT0NTIEhDVSBkcml2ZXINCj4gPiANCj4g
PiBEZWNsYW4gTXVycGh5ICgyKToNCj4gPiAgIGR0LWJpbmRpbmdzOiBjcnlwdG86IEFkZCBLZWVt
IEJheSBPQ1MgSENVIGJpbmRpbmdzDQo+ID4gICBjcnlwdG86IGtlZW1iYXkgLSBBZGQgS2VlbSBC
YXkgT0NTIEhDVSBkcml2ZXINCj4gPiANCj4gPiAgLi4uL2NyeXB0by9pbnRlbCxrZWVtYmF5LW9j
cy1oY3UueWFtbCAgICAgICAgIHwgICA0NiArDQo+ID4gIE1BSU5UQUlORVJTICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTEgKw0KPiA+ICBkcml2ZXJzL2NyeXB0by9rZWVt
YmF5L0tjb25maWcgICAgICAgICAgICAgICAgfCAgIDI5ICsNCj4gPiAgZHJpdmVycy9jcnlwdG8v
a2VlbWJheS9NYWtlZmlsZSAgICAgICAgICAgICAgIHwgICAgMyArDQo+ID4gIGRyaXZlcnMvY3J5
cHRvL2tlZW1iYXkva2VlbWJheS1vY3MtaGN1LWNvcmUuYyB8IDEyNjQNCj4gPiArKysrKysrKysr
KysrKysrKw0KPiA+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYyAgICAgICAgICAg
ICAgfCAgODQwICsrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhj
dS5oICAgICAgICAgICAgICB8ICAxMDYgKysNCj4gPiAgNyBmaWxlcyBjaGFuZ2VkLCAyMjk5IGlu
c2VydGlvbnMoKykNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+ID4gRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL2NyeXB0by9pbnRlbCxrZWVtYmF5LW9jcy1oY3UueWFtbA0KPiA+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1o
Y3UtY29yZS5jDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2NyeXB0by9rZWVtYmF5
L29jcy1oY3UuYw0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jcnlwdG8va2VlbWJh
eS9vY3MtaGN1LmgNCj4gDQo+IEFsbCBhcHBsaWVkLiAgVGhhbmtzLg0KDQpUaGFua3MgSGVyYmVy
dC4NCg0KSnVzdCBhIG5vdGUsIHRoaXMgcGF0Y2ggc2VyaWVzIHdhcyBzZW50IGJlZm9yZSB0aGUg
Zm9sbG93aW5nIHR3byBpc3N1ZXMNCmFib3V0IHRoZSBLZWVtIEJheSBBRVMgZHJpdmVyIHdlcmUg
cmVwb3J0ZWQ6DQoxLiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyMDEy
MTYxMzE0NTkuMTMyMDM5Ni0xLWdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlLw0KMi4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMTIxNzEzMzMuZ2w2dmNnUnAtbGtwQGludGVsLmNvbS8N
Cg0KSSB0aGluayB0aGF0IHRoaXMgcGF0Y2ggc2V0IGhhcyB0aGUgc2FtZSBpc3N1ZXMsIGJ1dCwg
ZHVlIHRvIHRoZQ0KQ2hyaXN0bWFzIC8gTmV3IFllYXIgaG9saWRheXMsIEkgd2Fzbid0IGFibGUg
dG8gZG91YmxlIGNoZWNrIHRoYXQgYW5kDQpzZW5kIGFuIHVwZGF0ZWQgc2VyaWVzLiANCg0KSSB3
aWxsIG5vdyBsb29rIGludG8gaXQgYW5kIHNlbmQgYSBuZXcgcGF0Y2ggdG8gZml4IHRoZSBpc3N1
ZXMgc29vbiAoaWYNCmNvbmZpcm1lZCkuDQoNClJlZ2FyZHMsDQpEYW5pZWxlDQo=

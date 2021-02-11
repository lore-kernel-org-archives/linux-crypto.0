Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B03C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 15:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7596364EF7
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 15:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhBKPRM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:17:12 -0500
Received: from mga17.intel.com ([192.55.52.151]:3181 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBKPOO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 10:14:14 -0500
IronPort-SDR: umW55vKPcKKmzNsvGT3l+KRx73JEJXzkLro/oRz0DaNJXqAE2qd7gTGdBfPdi5+fHWI6EN/5iZ
 9Q2rOoaQZO6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="162004609"
X-IronPort-AV: E=Sophos;i="5.81,170,1610438400"; 
   d="scan'208";a="162004609"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 07:13:05 -0800
IronPort-SDR: Ebv04BVbsj+S3G974SXXUO1VSr1Zjy6Hi0w5oSbp6CGH1Ce0QdW8/DfUVRnBCHaWkSGTCyB2C7
 lZmECSnoSBYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,170,1610438400"; 
   d="scan'208";a="422130951"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Feb 2021 07:13:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Feb 2021 07:13:05 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Feb 2021 07:13:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 11 Feb 2021 07:13:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 11 Feb 2021 07:13:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNkFfAqJtTISF4wAP0sKs32/eetcRU89B/ZAK5iGxlchaD8KkutmUVXwH0nmayjsa+XdwcHmyAsR54zkSrQLgd4jO9+n2QkzjUP58Mk1W+akkB21Q3m0lygdWUSyNLmZ3ck5PqsnrLoEOy0JqTpLP8t3eyEJAkckE022XYpNBjpHl8fxYqEacZrDa/H3fTMDTl2XteYVvYpVx02hubKJjnusL+AwgTvUyR0HqadDIM5j48xvAsHKsKolktGkQFKmmOZraUCJS7pc4v5tXr3N0oY4pR2MtH01enTYY5AETtAZnGnQJsTLXmhshiBItIr9DA5QBRbZOeDZ9h6/iIMs2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZpkFSrdt12TVAzg2AVT1MjogwM7/sBWEBxthNc1qDU=;
 b=B+GqxaZfbjEvAWpYijWXPqzZOd5qzA/Sw0+FYd0zGbgwfxGF2UumRx2JXUcHEvAL2lg+2SVUVSUxEl88mR5ecQAZZX9AvqXWR3NR6oQBFOT2KqGn6eARry12daudO/gYn31PIvdrlPAnR71b2UKn/JUUPtH30dog7hHv9h9cIj9e6dQzGjm5rkXOIdBsScW8h4PD55KBEfYT0sUGlfa4M844mgzqo7UUWziZ5O9D2f4TUMW6qXXeFIZe7I3SurpXMfeek4kghqWcjtwJ7SLg6s05yarrrXnoLET8RfRL1p15aOhWoHELiPWHrNV417hy52/l6yK49aX4FXYFtrwdww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZpkFSrdt12TVAzg2AVT1MjogwM7/sBWEBxthNc1qDU=;
 b=p0IPcpddY+YxhOCCKAVIyECKiO3HjEWwiGWwxFY9uJ57R1/TZar4VgLB+hpxiipM65xUb2cU7sakSn3A+zJ25TSDOdwAhOXk/tBrUZjP5fhDKGnLOejuAbfdhPqtWpzyHERHSSYkprDCsUah7cHCycv+/dsEua+O+Q+ajA/J308=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA0PR11MB4701.namprd11.prod.outlook.com (2603:10b6:806:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 15:13:03 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3846.030; Thu, 11 Feb 2021
 15:13:03 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: keembay-ocs-aes - Fix error return code in
 kmb_ocs_aes_probe()
Thread-Topic: [PATCH -next] crypto: keembay-ocs-aes - Fix error return code in
 kmb_ocs_aes_probe()
Thread-Index: AQHW/3+nY++Wy/eM80G1lHo9B26G46pTEceA
Date:   Thu, 11 Feb 2021 15:13:03 +0000
Message-ID: <416604524a9086e6707e86537cc27d95a7e65073.camel@intel.com>
References: <20210210074527.867400-1-weiyongjun1@huawei.com>
In-Reply-To: <20210210074527.867400-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.191.232.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1a614b9-f97d-480f-5733-08d8ce9f8719
x-ms-traffictypediagnostic: SA0PR11MB4701:
x-microsoft-antispam-prvs: <SA0PR11MB4701B1F40C851A3613176F80F28C9@SA0PR11MB4701.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Gnn2yilHE384g7/yXLB/vWWx8u3c6vk0kaMsXsHk2kA8s/qFyDV/mi2nq9c/PoQ4IaL/jlptVZqDZ0dUStEnyfoh4bjxOpX/YfMkNjtro2+9k14zXr37ljfWy+n19gAh7qhGHzqrytLTTZwXa9owI0KH/mwQlmC0s+NrVsMYbc9qnWXWkiZUsBOS0EM42Bzw6cJy6HfL5TOMb3vi96pXKt5wvV6Vqgtas4AWwYr3arpmAkQa6EyR13xIW2BVJpkyHGXdwZes24vRo1TdN+Jcv2jR6TW7WwHkhL+9kErKRcKz17Ykqvkfx6GymbRliJzPTWWD2UZUDi6k3Gp797GRuxh7TdV1ZIiiORJCUmv+hL/x4/hEbEJghGWPkMTscjKoJAdTeUruePojcdma6YzNi4LIhw18CvqWX8HFrAKKdzegnzu2Rov/8Hiqb9TDEc0BYQZJkGu3uQAYZh3yCkkvvsiPJv2RmrRvMMSLbra6nqffZOgfbiu9Gld+9MKj2Jx1O2PwgGGkxQ3WW5qxgbwSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(39860400002)(366004)(376002)(83380400001)(186003)(2616005)(86362001)(26005)(66446008)(66946007)(71200400001)(64756008)(8936002)(76116006)(91956017)(66556008)(6506007)(478600001)(6486002)(4326008)(8676002)(6512007)(110136005)(316002)(2906002)(66476007)(5660300002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TWhEZ3EycThKNjZXS3M3d1FlNjEvaFBiQ3B4NTMxNTE5ZXNFVmNBZVRTL1RN?=
 =?utf-8?B?elp3Szk3ZHIyS3ZrbURUZXJrUFZsQXRxaWg2b0lGRDYvRDJkSTZoSytlVlJo?=
 =?utf-8?B?Z3RlTlc1dXNpcThvaW5DMmJJSURvVmg3MU5XN1I3QWl2dlBPa1JSeHRWa3FX?=
 =?utf-8?B?NnRHNnhuZzEvTWRnd3pCQkJzOFpuTVdxOGFycGx6amVKU2IxNGd6TWJBek82?=
 =?utf-8?B?eEdsUEQzWnpWTEFwZjhENGFpVHJYL1MxWUY3ZDRjL0xMbno0UENadEZEZGVW?=
 =?utf-8?B?R2FZeStyWmk0ak1rdTl5YWZENWYzTDFwY01vV2tadFp6aWN3L3RlL2tEVHFQ?=
 =?utf-8?B?L0hnRkV2UmJaZlVBU1RTMzV3YUlneENKQ0lJSFdPZVE0S3R5UHRMTzc4YUNN?=
 =?utf-8?B?RGdHWVpMUFAyTnBwT2dWd2VaZUlRcDJFWXBkRk50YmtuZVZENTZKQS8wUG85?=
 =?utf-8?B?M0tIc1FnUVVqd0hyZnFXbE5CUk80MWllQndvTjNyM2ZObVdOSlEwRW1Cc1R5?=
 =?utf-8?B?YURLeGRQNzNybHh0Mm5Sa0lFU0wvOWo3Tm0zbFlaQU9LL3FXV1lQWk91dVdv?=
 =?utf-8?B?NWh6dHlEUngzUWhwMUZlZ0N3TWMvNVBvMFlFSjBxN3ppeitRY01DbjVNRUVB?=
 =?utf-8?B?anZPUncrTCt1aEdzUHFQQldPSjJjcU8wR29QVS9WQU1WMUhIZnhRRndLdWJM?=
 =?utf-8?B?SlFmVU1GdTllN3ZxRUZZb29xVldGWXJkd2U5d3pGLzkwNjd0by9IejNvRG5m?=
 =?utf-8?B?aVQ3RFQzZllUYnNvTEpIcUs1ZFU4SG1PN0FsTlhPZHVpTktGQVZxM2c5QXBM?=
 =?utf-8?B?cDhWVHhUTnBqVFVFdzYvRGZTdi92WmxaQndLWmh4S21uTkNkNzhEdDB5UFM1?=
 =?utf-8?B?dlU1ZGxmOE43S3NJY3JPV3MzZ2I4QW5lZGZESUlaalNxS1JKSkUwanJkVUtz?=
 =?utf-8?B?dmxzdFNKb1l1d2c4eTNOMEM5UlBhdm5JMzZLVERYYTg2Sk5XOG92dllJYTZN?=
 =?utf-8?B?L0JJam1DRkx2WjE2NXdpQ3BnK0c4TWZWU2pjZ2VsWUVqUUxrZlhUNG1EY054?=
 =?utf-8?B?MFdaamlGOGorV0ZNK0RCdFc5Q3ZoZ2dpOVhlYWczR2l2d0V5NmZoZ0tWZ2Uz?=
 =?utf-8?B?RW91RU0xbmsyRyt0cURxcTVhS2Z2MVpHYS9QdENkY1JqV29xMTZpZUYwaWYr?=
 =?utf-8?B?UndOVnpoNEU0cUlZbW5DRWp1cXYyc2hKeEFGYzNNUVFWeE53STZCTWYyN0Fn?=
 =?utf-8?B?b0FSbzAyWFpycUpnajFjbmRiUC9TdlpEUFlNMUlKL00wMERvbDVMUGFhYjcy?=
 =?utf-8?B?cXFOWjNmUTdhQjlodFU2b2ZUdEJXaUY2dGNVa0JjN3lBSlVhUk9hOW5McEN4?=
 =?utf-8?B?L1A5M3VpU2FiSGk5YkJraGZWekFOTXpZeVdPT0FmRUVOMy9kaFgxcUlrS2x3?=
 =?utf-8?B?RnpLVlJHL1ZMM0hsSVJNTWROTEoyNnQ5L002VkxSK1NTazVJMEdhbEdPY3RY?=
 =?utf-8?B?QkE1bDdNRU5qY0NVNGpPMk0wNWRhYnV5b1hDTThxLzFnZW5nS0ZZVWhJejJT?=
 =?utf-8?B?UTJ1bmczTWFHaHBPNWhKVllFeHdIM1pIdlRVdHBOUXBQR0EyK2l6U1FRS29s?=
 =?utf-8?B?YkpQOC9Td1lUNGxyVzNYSG04Qmo3SzNQMVNWMHhwZ1h3YWU0Ky9kUXVVVktP?=
 =?utf-8?B?Umsxd1JhUFhIVVVucmdSTmdXZkVMdkVuSmRJT2F3QXFHSTlrMFVwdGpGVFkz?=
 =?utf-8?B?WHMxWnVSWjhaYVpHMEZxSFhjaFRtRlpyU0ZSQlBudWRscGtTUzc1ajh6eW9N?=
 =?utf-8?B?a3l2QUFQUWJSMUNZbFlIdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <957CA3E0724DDD4EA043BB11AC5F1E1A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a614b9-f97d-480f-5733-08d8ce9f8719
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 15:13:03.4012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8zUimtQgKo4k+jo/WkodUGNB3a/RKewNX/JNaRgZV3SSyd5f7aX5Ean+y6wogIps/+VIW7ezRR1uxpCV8OPshe3GYul1MDxSipRvClDOX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4701
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgV2VpLA0KDQpUaGFua3MgZm9yIHRoaXMgZml4IGFzIHdlbGwgOikNCg0KT24gV2VkLCAyMDIx
LTAyLTEwIGF0IDA3OjQ1ICswMDAwLCBXZWkgWW9uZ2p1biB3cm90ZToNCj4gRml4IHRvIHJldHVy
biBuZWdhdGl2ZSBlcnJvciBjb2RlIC1FTk9NRU0gZnJvbSB0aGUgZXJyb3IgaGFuZGxpbmcNCj4g
Y2FzZSBpbnN0ZWFkIG9mIDAsIGFzIGRvbmUgZWxzZXdoZXJlIGluIHRoaXMgZnVuY3Rpb24uDQo+
IA0KPiBGaXhlczogODg1NzQzMzI0NTEzICgiY3J5cHRvOiBrZWVtYmF5IC0gQWRkIHN1cHBvcnQg
Zm9yIEtlZW0gQmF5IE9DUw0KPiBBRVMvU000IikNCj4gUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3Qg
PGh1bGtjaUBodWF3ZWkuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBXZWkgWW9uZ2p1biA8d2VpeW9u
Z2p1bjFAaHVhd2VpLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L2tlZW1i
YXktb2NzLWFlcy1jb3JlLmMgfCA0ICsrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9r
ZWVtYmF5L2tlZW1iYXktb2NzLWFlcy1jb3JlLmMNCj4gYi9kcml2ZXJzL2NyeXB0by9rZWVtYmF5
L2tlZW1iYXktb2NzLWFlcy1jb3JlLmMNCj4gaW5kZXggYjZiMjVkOTk0YWYzLi4yZWYzMTI4NjYz
MzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkva2VlbWJheS1vY3MtYWVz
LWNvcmUuYw0KPiArKysgYi9kcml2ZXJzL2NyeXB0by9rZWVtYmF5L2tlZW1iYXktb2NzLWFlcy1j
b3JlLmMNCj4gQEAgLTE2NDksOCArMTY0OSwxMCBAQCBzdGF0aWMgaW50IGttYl9vY3NfYWVzX3By
b2JlKHN0cnVjdA0KPiBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICANCj4gIAkvKiBJbml0aWFs
aXplIGNyeXB0byBlbmdpbmUgKi8NCj4gIAlhZXNfZGV2LT5lbmdpbmUgPSBjcnlwdG9fZW5naW5l
X2FsbG9jX2luaXQoZGV2LCB0cnVlKTsNCj4gLQlpZiAoIWFlc19kZXYtPmVuZ2luZSkNCj4gKwlp
ZiAoIWFlc19kZXYtPmVuZ2luZSkgew0KPiArCQlyYyA9IC1FTk9NRU07DQo+ICAJCWdvdG8gbGlz
dF9kZWw7DQo+ICsJfQ0KPiAgDQo+ICAJcmMgPSBjcnlwdG9fZW5naW5lX3N0YXJ0KGFlc19kZXYt
PmVuZ2luZSk7DQo+ICAJaWYgKHJjKSB7DQo+IA0KDQpSZXZpZXdlZC1ieTogRGFuaWVsZSBBbGVz
c2FuZHJlbGxpIDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29tPg0K

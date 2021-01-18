Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B04C433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 12:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0DC0205F4
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 12:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbhARMMT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 07:12:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:15755 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391224AbhARLzw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 06:55:52 -0500
IronPort-SDR: grjVIBgDjOBKkcP8ig1MvfI/+OI6PZhrIYRmhMqeXRWWf3q7hp1kmJf4ShJfVj63tWP3yirVeX
 MlCQ/tnaWbpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="175289506"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="175289506"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 03:55:11 -0800
IronPort-SDR: 56RcOf0LRK0s7AOSSTxKdd2/n9Oy7HX5ZAAbO5egus3uUQEJSpG9DnsAUs8MJwhqOTGKlHbH4P
 /YCHMtmLWvvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="390788090"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2021 03:55:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 Jan 2021 03:55:10 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 Jan 2021 03:55:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 18 Jan 2021 03:55:09 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 18 Jan 2021 03:55:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKld6um+e5j79LPTtOIzVeWv43UDa6NU/J+onYW59RYf4HCXuIJvRbaDG3kbnfZ6EKOoDpZfYaLaRyCpK6DnLRr+ZLboMs5bUw5pH8sDjok/JCf/5LUm3qTsQKHdqer9rmfnQ1JUjT0fHrqQ4s0TSGNMtt/VuuvOMa1JhFhoiO/yF3SBpOzkHpA3TojcGjVgjEr8Y5iSreNu8BGe4WqSHdA3AboBcOcliFXLp1AVZfd3c+OaOL+S16p5A3Sk4yoe4qLwQv60DUJd643r0xpa0R/bsvLzVaLnTFP5J3YGtNJTifh6bL8WPUzSILaTwjnI9yzgORMlGnn05dX+7cybOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+qz14Auq5yNTbm0sBN4U+y1xEXEjc+LTss+42tinMM=;
 b=dbVnifQLt5ixQMb+mqCD+D7f7nD2lzRx1Su6nuaeHEGGCKYxFrsE9mvDtIEmJxXsGYoRQ5BjZVlqviQSIQ6LWSWYcdb0Qg0uuxXk4P1M+RWtI8J2OXRNrKjnw/vOdPpnT884y1kVmq/j5Xprqap4nnpe62ae3dlTG94+1ItZvF5gEs/L7I25QZR0OGRDoZJvN5Arr6PYej8QKGc/Mpwt/+8Gm8M/x+sVku2X6FBYwKlK4Oj1wWYjrAIs4ZxABwzFTigpx/cmJp03MXaRTluZA5xsGJqAfWXZFnode1eYM6Kxu7ir91hSU5b+XGG1ZSQE3bm9oJjQj9s05nG5UD3q9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+qz14Auq5yNTbm0sBN4U+y1xEXEjc+LTss+42tinMM=;
 b=IpegDZ32IS17gg2OvM7QLUU3QdvSqcaL8TShyLaTb4jqqDFOywqkNTS4sddGbHUd2jdqInqkRd9hgAgKu6auJ6QKKbsuf1MuQA072SMKr7wuonfz3lfz50fDdii6C11pQBHQmKCrg7z8ubXherjr0niMQtqrvntfQbX6tiQji2A=
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 (2603:10b6:903:b3::23) by CY4PR1101MB2167.namprd11.prod.outlook.com
 (2603:10b6:910:1b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 18 Jan
 2021 11:55:08 +0000
Received: from CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::98c3:2fe8:7b0c:f845]) by CY4PR1101MB2326.namprd11.prod.outlook.com
 ([fe80::98c3:2fe8:7b0c:f845%3]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 11:55:08 +0000
From:   "Reshetova, Elena" <elena.reshetova@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>
Subject: RE: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZ8lMRowq1QUyYZqNdBK9VvaoXNMxwgAA8YgCAADFl8IAPZGXAgACVhQCABdATEA==
Date:   Mon, 18 Jan 2021 11:55:08 +0000
Message-ID: <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au>
 <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
In-Reply-To: <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [178.55.192.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54c9231f-3ed7-4ed6-369e-08d8bba7e73a
x-ms-traffictypediagnostic: CY4PR1101MB2167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2167AA70BF895912AD8B68D8E7A40@CY4PR1101MB2167.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6P5jpQEUzRsDPTtGETeRnbXqisoylWcP1vaiJKRYrnYU1Yeq97Y+xXI9GFwMW1cfIMFGRGIK9AQUbvzkTYTs0R9kOtHr4tVEBqatZqPYXZMm5AetBJpnPiiUK2nAL5+3Taxc/iX824LxQyrNKx+u7Z8hx+l2b9m9CT3iwmvpRTTO5H74VuMujv/wNWB5dTvQ5fc+e4rcCFK2K/InHRNPpE7C22fr3me/fcPe7P2yz1r1q1LcmFnzW059/gTOUfkkmwuIP53IgMY9v5Kv0tPrBA6zbR5y/N78YfhQoMecAXwiNGAfNkcMZaz1MG7c6lY0lDnhFYWHbFoA3PPZFSBWkZXznRQo5dXh5kCA8Ecz1CPu0oIo5eZgQD0+8nYCk7jwykrKBzDOumGGOOPefDoZaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(33656002)(71200400001)(7696005)(4326008)(8936002)(478600001)(6506007)(6916009)(9686003)(66556008)(76116006)(55016002)(26005)(186003)(52536014)(5660300002)(66476007)(66946007)(66446008)(64756008)(83380400001)(316002)(54906003)(86362001)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WTQ0TFZIRUxzRmZROWxNNWFyS3dObWg4KzV5Q2VseUh3bVl2Z2ZmNk5ZWUVn?=
 =?utf-8?B?OEZRdkRHK0lFNkxCOWdmcmRvOU5mb0prNGpySytJTGdNTnIxNG9rbEpBSVZL?=
 =?utf-8?B?R05OdXc1ckdXMHhxRmNqU2o1YS9ETkxIdXNtL2pjU1pNQjBjdENJdDZwQUhw?=
 =?utf-8?B?QWRtSWpvSThZNVp2RlludHlSWkdIZnBQRnhKZXJnUEQyaURaMjVBN1ZuZVdp?=
 =?utf-8?B?Q3NzR0VORHJxM2xNVm9oV1pMdzVJcjY2N1RzUmQzdFU3TUc5QkJxdDB6Q2o4?=
 =?utf-8?B?V1BlRVkxYXJ1RXJwK3pmUmMvSGkyVjQ4UmJITVhvMS9VaHJWR3dPQnNVS2JX?=
 =?utf-8?B?NjZ3UWM4SXJUVDh3SW1FTW5oME5VekZKdTJVdksrN3M3QjROQkxQcFZYVTA5?=
 =?utf-8?B?N21vUFRHOTgyT0Vhd2pRYVphNE5xTG5jajVjWGNWQyt2TlBZd01hNHdaODQ0?=
 =?utf-8?B?RXpXNFR3V2labVlJMmpYMU1kTkxwWTMwcXVLVWpzTXlNTnY4ZGZ6WERlbDFs?=
 =?utf-8?B?a25wMHlvR3F5eFZWa1hSWnh3STdjMmMvaEpHSjA2dFhGT0ovR1gyWjRMcC9p?=
 =?utf-8?B?YkFlRXQvY000ME5OaWxHN21RaFJoeGFtV1RqVzF5ZmwyNU1iUjVxajRSeGdl?=
 =?utf-8?B?ZVJpczYyM1QvRzRVcHFVMk5aaWpjRjZZMUNndmlFZ3g3aGlGM0tpYkxyWFpq?=
 =?utf-8?B?RXo3UFlhR3k5WFZHRFI5WW9BektQdlFnUUszUldUU09XdWpMWUIyd2FDUHhJ?=
 =?utf-8?B?clY2Um1wcTRMdkJoRUk0TllWQUlCZmtYS2VSNXZocDFaaWQxQUcreUlFVU41?=
 =?utf-8?B?dzdlTUE5SXpZdVVxbjRwSjVyQzVUKzFFd3J2N0lGWllvWUtxV2o2WHE5OGdI?=
 =?utf-8?B?eGFJVkI2bGRmTTdsQVhMOTFsYnQrUmxQSVNjYUJ4M1VITFI4ZU1jai9neC84?=
 =?utf-8?B?WGJHRk1vNmd3YjJqaVhaVGMydnVNdmhnR3RsT0x0WjdnUVl5T0czZlorcjhF?=
 =?utf-8?B?NmpMTmJaOGRPZjlCSWV3dWhOWEdNK2orYWZsYy9RcjAwaXdJejVpd2pQeVp5?=
 =?utf-8?B?NEw1VS9XR2dNRjRiSmJVQmczWGpTaitDM0YxNjJIblQ1UllIdGFtVldmM1Vp?=
 =?utf-8?B?ai9PaE1GN1ZSRkx0aU5sbStVNXhURjB1QWdSSlNsNzJhYWRoU0wzZ1pydE5q?=
 =?utf-8?B?Y3dlcEJsbmJ0YjF5YVNNT1dLbzhpMjVqdmJvWHNyVnVUcXM3T0lWZHVEUEFL?=
 =?utf-8?B?dzIyaVZDUnEzSHB4OWJ3T2ZzNVFWVkx3MWlBamZhSnlWTmhpekoxOHJKVmtC?=
 =?utf-8?Q?I3Obcihm4Dbt4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c9231f-3ed7-4ed6-369e-08d8bba7e73a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 11:55:08.4360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7SDNBjbloWnCJNOz7lgHKZD4kI79vj2S3jlWRb/LcizhQhw6a8HUHSOYGaoa7NdIiM1NeViovXwyUBvy1KIZTF5tQRyVVrpO9E4vBEMah4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2167
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBUaHUsIDE0IEphbiAyMDIxIGF0IDExOjI1LCBSZXNoZXRvdmEsIEVsZW5hDQo+IDxlbGVu
YS5yZXNoZXRvdmFAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+ID4gPiBPbiBNb24sIEphbiAw
NCwgMjAyMSBhdCAwODowNDoxNUFNICswMDAwLCBSZXNoZXRvdmEsIEVsZW5hIHdyb3RlOg0KPiA+
ID4gPiA+ID4gMi4gVGhlIE9DUyBFQ0MgSFcgZG9lcyBub3Qgc3VwcG9ydCB0aGUgTklTVCBQLTE5
MiBjdXJ2ZS4gV2Ugd2VyZQ0KPiBwbGFubmluZw0KPiA+ID4gdG8NCj4gPiA+ID4gPiA+ICAgIGFk
ZCBTVyBmYWxsYmFjayBmb3IgUC0xOTIgaW4gdGhlIGRyaXZlciwgYnV0IHRoZSBJbnRlbCBDcnlw
dG8gdGVhbQ0KPiA+ID4gPiA+ID4gICAgKHdoaWNoLCBpbnRlcm5hbGx5LCBoYXMgdG8gYXBwcm92
ZSBhbnkgY29kZSBpbnZvbHZpbmcgY3J5cHRvZ3JhcGh5KQ0KPiA+ID4gPiA+ID4gICAgYWR2aXNl
ZCBhZ2FpbnN0IGl0LCBiZWNhdXNlIHRoZXkgY29uc2lkZXIgUC0xOTIgd2Vhay4gQXMgYSByZXN1
bHQsIHRoZQ0KPiA+ID4gPiA+ID4gICAgZHJpdmVyIGlzIG5vdCBwYXNzaW5nIGNyeXB0byBzZWxm
LXRlc3RzLiBJcyB0aGVyZSBhbnkgcG9zc2libGUgc29sdXRpb24NCj4gPiA+ID4gPiA+ICAgIHRv
IHRoaXM/IElzIGl0IHJlYXNvbmFibGUgdG8gY2hhbmdlIHRoZSBzZWxmLXRlc3RzIHRvIG9ubHkg
dGVzdCB0aGUNCj4gPiA+ID4gPiA+ICAgIGN1cnZlcyBhY3R1YWxseSBzdXBwb3J0ZWQgYnkgdGhl
IHRlc3RlZCBkcml2ZXI/IChub3QgZnVsbHkgc3VyZSBob3cgdG8gZG8NCj4gPiA+ID4gPiA+ICAg
IHRoYXQpLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQW4gYWRkaXRpb25hbCByZWFzb24gYWdhaW5z
dCB0aGUgUC0xOTIgU1cgZmFsbGJhY2sgaXMgdGhlIGZhY3QgdGhhdCBpdCBjYW4NCj4gPiA+ID4g
PiBwb3RlbnRpYWxseSB0cmlnZ2VyIHVuc2FmZSBiZWhhdmlvciB3aGljaCBpcyBub3QgZXZlbiAi
dmlzaWJsZSIgdG8gdGhlIGVuZCB1c2VyDQo+ID4gPiA+ID4gb2YgdGhlIEVDQyBmdW5jdGlvbmFs
aXR5LiBJZiBJIHJlcXVlc3QgKGJ5IG15IGRldmVsb3BlciBtaXN0YWtlKSBhIFAtMTkyDQo+ID4g
PiA+ID4gd2Vha2VyIGN1cnZlIGZyb20gRUNDIEtlZW0gQmF5IEhXIGRyaXZlciwgaXQgaXMgbXVj
aCBzYWZlciB0byByZXR1cm4gYQ0KPiA+ID4gPiA+ICJub3Qgc3VwcG9ydGVkIiBlcnJvciB0aGF0
IHByb2NlZWQgYmVoaW5kIG15IGJhY2sgd2l0aCBhIFNXIGNvZGUNCj4gPiA+ID4gPiBpbXBsZW1l
bnRhdGlvbiBtYWtpbmcgbWUgYmVsaWV2ZSB0aGF0IEkgYW0gYWN0dWFsbHkgZ2V0dGluZyBhIEhX
LWJhY2tlZCB1cA0KPiA+ID4gPiA+IGZ1bmN0aW9uYWxpdHkgKHNpbmNlIEkgZG9uJ3QgdGhpbmsg
dGhlcmUgaXMgYSB3YXkgZm9yIG1lIHRvIGNoZWNrIHRoYXQgSSBhbSB1c2luZw0KPiA+ID4gPiA+
IFNXIGZhbGxiYWNrKS4NCj4gPiA+ID4NCj4gPiA+ID4gU29ycnksIGJ1dCBpZiB5b3UgYnJlYWsg
dGhlIENyeXB0byBBUEkgcmVxdWlyZW1lbnQgdGhlbiB5b3VyIGRyaXZlcg0KPiA+ID4gPiBpc24n
dCBnZXR0aW5nIG1lcmdlZC4NCj4gPiA+DQo+ID4gPiBCdXQgc2hvdWxkIG5vdCB3ZSB0aGluayB3
aGF0IGJlaGF2aW9yIHdvdWxkIG1ha2Ugc2Vuc2UgZm9yIGdvb2QgY3J5cHRvIGRyaXZlcnMNCj4g
aW4NCj4gPiA+IGZ1dHVyZT8NCj4gPiA+IEFzIGNyeXB0b2dyYXBoeSBtb3ZlcyBmb3J3YXJkIChl
c3BlY2lhbGx5IGZvciB0aGUgcG9zdCBxdWFudHVtIGVyYSksIHdlIHdpbGwNCj4gaGF2ZQ0KPiA+
ID4gbGVuZ3RocyBmb3IgYWxsIGV4aXN0aW5nIGFsZ29yaXRobXMgaW5jcmVhc2VkIChpbiBhZGRp
dGlvbiB0byBoYXZpbmcgYSBidW5jaCBvZiBuZXcNCj4gPiA+IG9uZXMpLA0KPiA+ID4gYW5kIHdl
IHN1cmVseSBzaG91bGQgbm90IGV4cGVjdCB0aGUgbmV3IGdlbmVyYXRpb24gb2YgSFcgZHJpdmVy
cyB0byBpbXBsZW1lbnQNCj4gPiA+IHRoZSBvbGQvd2Vha2VyIGxlbmd0aHMsIHNvIHdoeSB0aGVy
ZSB0aGUgcmVxdWlyZW1lbnQgdG8gc3VwcG9ydCB0aGVtPyBJdCBpcyBub3QNCj4gYQ0KPiA+ID4g
cGFydCBvZiBjcnlwdG8gQVBJIGRlZmluaXRpb24gb24gd2hhdCBiaXQgbGVuZ3RocyBzaG91bGQg
YmUgc3VwcG9ydGVkLCBiZWNhdXNlIGl0DQo+ID4gPiBjYW5ub3QgYmUgcGFydCBvZiBBUEkgdG8g
YmVnaW4gd2l0aCBzaW5jZSBpdCBpcyBhbHdheXMgY2hhbmdpbmcgcGFyYW1ldGVyDQo+IChhbGdv
cml0aG1zDQo+ID4gPiBhbmQgYXR0YWNrcw0KPiA+ID4gZGV2ZWxvcCBhbGwgdGhlIHRpbWUpLg0K
PiA+DQo+ID4gSSB3b3VsZCByZWFsbHkgYXBwcmVjaWF0ZSwgaWYgc29tZW9uZSBoZWxwcyB1cyB0
byB1bmRlcnN0YW5kIGhlcmUuIE1heWJlIHRoZXJlIGlzIGENCj4gPiBjb3JyZWN0IHdheSB0byBh
ZGRyZXNzIHRoaXMsIGJ1dCB3ZSBqdXN0IGRvbid0IHNlZSBpdC4gVGhlIHF1ZXN0aW9uIGlzIG5v
dCBldmVuIGFib3V0DQo+ID4gdGhpcyBwYXJ0aWN1bGFyIGNyeXB0byBkcml2ZXIgYW5kIHRoZSBm
YWN0IHdoZW5ldmVyIGl0IGdlc3RzIG1lcmdlZCBvciBub3QsIGJ1dCB0aGUNCj4gPiBsb2dpYyBv
ZiB0aGUgY3J5cHRvIEFQSSBzdWJzeXN0ZW0uDQo+ID4NCj4gPiBBcyBmYXIgYXMgSSB1bmRlcnN0
YW5kIHRoZSBpbXBsZW1lbnRhdGlvbnMgdGhhdCBhcmUgcHJvdmlkZWQgYnkgdGhlIHNwZWNpYWxp
emVkDQo+IGRyaXZlcnMNCj4gPiAobGlrZSBvdXIgS2VlbSBCYXkgT0NTIEVDQyBkcml2ZXIgZXhh
bXBsZSBoZXJlKSBoYXZlIGEgaGlnaGVyIHByaW9yaXR5IHZzLiBnZW5lcmljDQo+ID4gSW1wbGVt
ZW50YXRpb25zIHRoYXQgZXhpc3RzIGluIGtlcm5lbCwgd2hpY2ggbWFrZXMgc2Vuc2UgYmVjYXVz
ZSB3ZSBleHBlY3QgdGhlc2UNCj4gZHJpdmVycw0KPiA+IChhbmQgdGhlIHNlY3VyaXR5IEhXIHRo
ZXkgdGFsayB0bykgdG8gcHJvdmlkZSBib3RoIG1vcmUgZWZmaWNpZW50IGFuZCBtb3JlIHNlY3Vy
ZQ0KPiA+IGltcGxlbWVudGF0aW9ucyB0aGFuIGEgcHVyZSBTVyBpbXBsZW1lbnRhdGlvbiBpbiBr
ZXJuZWwgY2FuIGRvIChldmVuIGlmIGl0IHV0aWxpemVzDQo+IHNwZWNpYWwNCj4gPiBpbnN0cnVj
dGlvbnMsIGxpa2UgU0lNRCwgQUVTTkksIGV0Yy4pLiBIb3dldmVyLCBuYXR1cmFsbHkgdGhlc2Ug
ZHJpdmVycyBhcmUgYm91bmQgYnkNCj4gPiB3aGF0IHNlY3VyaXR5IEhXIGNhbiBkbywgYW5kIGlm
IGl0IGRvZXMgbm90IHN1cHBvcnQgYSBjZXJ0YWluIHNpemUvcGFyYW0gb2YgdGhlDQo+IGFsZ29y
aXRobQ0KPiA+IChQLTE5MiBjdXJ2ZSBpbiBvdXIgY2FzZSksIGl0IGlzIHBvaW50bGVzcyBhbmQg
d3JvbmcgZm9yIHRoZW0gdG8gcmVpbXBsZW1lbnQgd2hhdA0KPiBTVyBpcw0KPiA+IGFscmVhZHkg
ZG9pbmcgaW4ga2VybmVsLCBzbyB0aGV5IHNob3VsZCBub3QgZG8gc28gYW5kIGN1cnJlbnRseSB0
aGV5IHJlLWRpcmVjdCB0bw0KPiBjb3JlIGtlcm5lbA0KPiA+IGltcGxlbWVudGF0aW9uLiBTbyBm
YXIgZ29vZC4NCj4gPg0KPiA+IEJ1dCBub3cgY29tZXMgbXkgYmlnZ2VzdCB3b3JyeSBpcyB0aGF0
IHRoaXMgcmVkaXJlY3Rpb24gYXMgZmFyDQo+ID4gYXMgSSBjYW4gc2VlIGlzICppbnRlcm5hbCB0
byBkcml2ZXIgaXRzZWxmKiwgaS5lLiBpdCBkb2VzIGEgY2FsbGJhY2sgdG8gdGhlc2UgY29yZQ0K
PiBmdW5jdGlvbnMgZnJvbSB0aGUgZHJpdmVyDQo+ID4gY29kZSwgd2hpY2ggYWdhaW4sIHVubGVz
cyBJIG1pc3VuZGVyc3RhbmQgc210aCwgbGVhZHMgdG8gdGhlIGZhY3QgdGhhdCB0aGUgZW5kIHVz
ZXINCj4gZ2V0cw0KPiA+IFAtMTkyIGN1cnZlIEVDQyBpbXBsZW1lbnRhdGlvbiBmcm9tIHRoZSBj
b3JlIGtlcm5lbCB0aGF0IGhhcyBiZWVuICJwcm9tb3RlZCINCj4gdG8gYSBoaWdoZXN0DQo+ID4g
cHJpb3JpdHkgKGdpdmVuIHRoYXQgRUNDIEtlZW1CYXkgZHJpdmVyIGZvciBleGFtcGxlIGdvdCBw
cmlvcml0eSAzMDAgdG8gYmVnaW4gd2l0aCkuDQo+IFNvLCBpZg0KPiA+IHdlIHNheSB3ZSBoYXZl
IGFub3RoZXIgSFcgRHJpdmVyICdGb28nLCB3aGljaCBoYXBwZW5zIHRvIGltcGxlbWVudCBQLTE5
Mg0KPiBjdXJ2ZXMgbW9yZSBzZWN1cmVseSwNCj4gPiBidXQgaGFwcGVucyB0byBoYXZlIGEgbG93
ZXIgcHJpb3JpdHkgdGhhbiBFQ0MgS2VlbUJheSBkcml2ZXIsIGl0cyBpbXBsZW1lbnRhdGlvbg0K
PiB3b3VsZCBuZXZlcg0KPiA+IGJlIGNob3NlbiwgYnV0IGNvcmUga2VybmVsIGltcGxlbWVudGF0
aW9uIHdpbGwgYmUgdXNlZCAodmlhIFNXIGZhbGxiYWNrIGludGVybmFsIHRvDQo+IEVDQyBLZWVt
DQo+ID4gQmF5IGRyaXZlcikuDQo+ID4NCj4gDQo+IE5vLCB0aGlzIGlzIGluY29ycmVjdC4gSWYg
eW91IGFsbG9jYXRlIGEgZmFsbGJhY2sgYWxnb3JpdGhtIGluIHRoZQ0KPiBjb3JyZWN0IHdheSwg
dGhlIGNyeXB0byBBUEkgd2lsbCByZXNvbHZlIHRoZSBhbGxvY2F0aW9uIGluIHRoZSB1c3VhbA0K
PiBtYW5uZXIsIGFuZCBzZWxlY3Qgd2hpY2hldmVyIG9mIHRoZSByZW1haW5pbmcgaW1wbGVtZW50
YXRpb25zIGhhcyB0aGUNCj4gaGlnaGVzdCBwcmlvcml0eSAocHJvdmlkZWQgdGhhdCBpdCBkb2Vz
IG5vdCByZXF1aXJlIGEgZmFsbGJhY2sNCj4gaXRzZWxmKS4NCg0KVGhhbmsgeW91IHZlcnkgbXVj
aCBBcmQgZm9yIHRoZSBpbXBvcnRhbnQgY29ycmVjdGlvbiBoZXJlIQ0KU2VlIGJlbG93IGlmIEkg
Z290IGl0IG5vdyBjb3JyZWN0bHkgdG8gdGhlIGVuZCBmb3IgdGhlIHVzZSBjYXNlIGluIHF1ZXN0
aW9uLiANCg0KPiANCj4gPiBBbm90aGVyIHByb2JsZW0gaXMgdGhhdCBmb3IgYSB1c2VyIG9mIGNy
eXB0byBBUEkgSSBkb24ndCBzZWUgYSB3YXkgKGFuZCBwZXJoYXBzIEkNCj4gYW0gd3JvbmcgaGVy
ZSkNCj4gPiB0byBndWFyYW50ZWUgdGhhdCBhbGwgbXkgY2FsbHMgdG8gcGVyZm9ybSBjcnlwdG8g
b3BlcmF0aW9ucyB3aWxsIGVuZCB1cCBiZWluZw0KPiBwZXJmb3JtZWQgb24gYQ0KPiA+IHNlY3Vy
aXR5IEhXIEkgd2FudCAobWF5YmUgYmVjYXVzZSB0aGlzIGlzIHRoZSBvbmx5IHRoaW5nIEkgdHJ1
c3QpLiBJdCBzZWVtcyB0byBiZQ0KPiBwb3NzaWJsZSBpbiB0aGVvcnksDQo+ID4gYnV0IGluIHBy
YWN0aWNlIHdvdWxkIHJlcXVpcmUgY2FyZWZ1bCBldmFsdWF0aW9uIG9mIGEga2VybmVsIHNldHVw
IGFuZCBhIHN5bmMNCj4gYmV0d2VlbiB3aGF0DQo+ID4gZW5kIHVzZXIgcmVxdWVzdHMgYW5kIHdo
YXQgZHJpdmVyIGNhbiBwcm92aWRlLiBMZXQgbWUgdHJ5IHRvIGV4cGxhaW4gYSBwb3RlbnRpYWwN
Cj4gc2NlbmFyaW8uDQo+ID4gTGV0cyBzYXkgd2UgaGFkIGFuIGVuZCB1c2VyIHRoYXQgdXNlZCB0
byBhc2sgZm9yIGJvdGggUC0xOTIgYW5kIFAtMzg0IGN1cnZlLWJhc2VkDQo+IEVDQyBvcGVyYXRp
b25zDQo+ID4gYW5kIGxldCdzIHNheSB3ZSBoYWQgYSBkcml2ZXIgYW5kIHNlY3VyaXR5IEhXIHRo
YXQgaW1wbGVtZW50ZWQgaXQuIFRoZSBlbmQgdXNlcg0KPiBtYWRlIHN1cmUgdGhhdA0KPiA+IHRo
aXMgZHJpdmVyIGltcGxlbWVudGF0aW9uIGlzIGFsd2F5cyBwcmVmZXJyZWQgdnMuIG90aGVyIGV4
aXN0aW5nIGltcGxlbWVudGF0aW9ucy4NCj4gTm93LCB0aW1lIG1vdmVzLCBhIG5ldw0KPiA+IHNl
Y3VyaXR5IEhXIGNvbWVzIGluc3RlYWQgdGhhdCBvbmx5IHN1cHBvcnRzIFAtMzg0LCBhbmQgdGhl
IGRyaXZlciBub3cgaGFzIGJlZW4NCj4gdXBkYXRlZCB0bw0KPiA+IHN1cHBvcnQgUC0xOTIgdmlh
IHRoZSBTVyBmYWxsYmFjayAobGlrZSB3ZSBhcmUgYXNrZWQgbm93KS4NCj4gPiBOb3csIGhvdyBk
b2VzIGFuIGVuZCB1c2VyIG5vdGljZSB0aGF0IHdoZW4gaXQgYXNrcyBmb3IgYSBQLTE5MiBiYXNl
ZCBvcGVyYXRpb25zLA0KPiBoaXMgb3BlcmF0aW9ucw0KPiA+IGFyZSBub3QgZG9uZSBpbiBzZWN1
cml0eSBIVyBhbnltb3JlPyBUaGUgb25seSB3YXkgc2VlbXMgdG8gYmUNCj4gPiBpcyB0byBrbm93
IHRoYXQgZHJpdmVyIGFuZCBzZWN1cml0eSBIVyBoYXMgYmVlbiB1cGRhdGVkLCBhbGdvcml0aG1z
IGFuZCBzaXplcw0KPiBjaGFuZ2VkLCBldGMuDQo+ID4gSXQgbWlnaHQgdGFrZSBhIHdoaWxlIGJl
Zm9yZSB0aGUgZW5kIHVzZXIgcmVhbGl6ZXMgdGhpcyBhbmQgZm9yIGV4YW1wbGUgc3RvcHMgdXNp
bmcNCj4gUC0xOTIgYWx0b2dldGhlciwNCj4gPiBidXQgd2hhdCBpZiB0aGlzIHNpbGVudCByZWRp
cmVjdCBieSB0aGUgZHJpdmVyIGFjdHVhbGx5IGJyZWFrcyBzb21lIHNlY3VyaXR5DQo+IGFzc3Vt
cHRpb25zIChzaWRlLWNoYW5uZWwNCj4gPiByZXNpc3RhbmNlIGJlaW5nIG9uZSBwb3RlbnRpYWwg
ZXhhbXBsZSkgbWFkZSBieSB0aGlzIGVuZCB1c2VyPyBUaGUgY29uc2VxdWVuY2VzDQo+IGNhbiBi
ZSB2ZXJ5IGJhZC4NCj4gPiBZb3UgbWlnaHQgc2F5OiAidGhpcyBpcyB0aGUgZW5kIHVzZXIgcHJv
YmxlbSB0byB2ZXJpZnkgdGhpcyIsIGJ1dCBzaG91bGRuJ3Qgd2UgZG8NCj4gc210aCB0byBwcmV2
ZW50IG9yDQo+ID4gYXQgbGVhc3QgaW5kaWNhdGUgc3VjaCBwb3RlbnRpYWwgaXNzdWVzIHRvIHRo
ZW0/DQo+ID4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQgaXMgcG9zc2libGUgYXQgdGhlIEFQSSBs
ZXZlbCB0byBkZWZpbmUgcnVsZXMgdGhhdA0KPiB3aWxsIGFsd2F5cyBwcm9kdWNlIHRoZSBtb3N0
IHNlY3VyZSBjb21iaW5hdGlvbiBvZiBkcml2ZXJzLiBUaGUNCj4gcHJpb3JpdHkgZmllbGRzIGFy
ZSBvbmx5IHVzZWQgdG8gY29udmV5IHJlbGF0aXZlIHBlcmZvcm1hbmNlICh3aGljaCBpcw0KPiBh
bHJlYWR5IHNlbWFudGljYWxseSBtdXJreSwgZ2l2ZW4gdGhlIGxhY2sgb2YgZGlzdGluY3Rpb24g
YmV0d2Vlbg0KPiBoYXJkd2FyZSB3aXRoIGEgc2luZ2xlIHF1ZXVlIHZzIHNvZnR3YXJlIGFsZ29y
aXRobXMgdGhhdCBjYW4gYmUNCj4gZXhlY3V0ZWQgYnkgYWxsIENQVXMgaW4gcGFyYWxsZWwpLg0K
PiANCj4gV2hlbiBpdCBjb21lcyB0byBjb21wYXJhdGl2ZSBzZWN1cml0eSwgdHJ1c3R3b3J0aGlu
ZXNzIG9yIHJvYnVzdG5lc3MNCj4gb2YgaW1wbGVtZW50YXRpb25zLCBpdCBpcyBzaW1wbHkgbGVm
dCB1cCB0byB0aGUgdXNlciB0byBibGFja2xpc3QNCj4gbW9kdWxlcyB0aGF0IHRoZXkgcHJlZmVy
IG5vdCB0byB1c2UuIFdoZW4gZmFsbGJhY2sgYWxsb2NhdGlvbnMgYXJlDQo+IG1hZGUgaW4gdGhl
IGNvcnJlY3Qgd2F5LCB0aGUgcmVtYWluaW5nIGF2YWlsYWJsZSBpbXBsZW1lbnRhdGlvbnMgd2ls
bA0KPiBiZSB1c2VkIGluIHByaW9yaXR5IG9yZGVyLg0KDQpTbywgbGV0IG1lIHNlZSBpZiBJIHVu
ZGVyc3RhbmQgdGhlIGZ1bGwgcGljdHVyZSBjb3JyZWN0bHkgbm93IGFuZCBob3cgdG8gdXRpbGl6
ZSANCnRoZSBibGFja2xpc3Rpbmcgb2YgbW9kdWxlcyBhcyBhIHVzZXIuIFN1cHBvc2UgSSB3YW50
IHRvIGJsYWNrbGlzdCBldmVyeXRoaW5nIGJ1dA0KbXkgT1NDIGRyaXZlciBtb2R1bGUuIFNvLCBp
ZiBJIGFtIGFzIGEgdXNlciByZWZlciB0byBhIHNwZWNpZmljIGRyaXZlciBpbXBsZW1lbnRhdGlv
bg0KdXNpbmcgYSB1bmlxdWUgZHJpdmVyIG5hbWUgKGVjZGgta2VlbWJheS1vY3MgaW4gb3VyIGNh
c2UpLCB0aGVuIHJlZ2FyZGxlc3Mgb2YgdGhlDQpmYWN0IHRoYXQgYSBkcml2ZXIgaW1wbGVtZW50
cyB0aGlzIFNXIGZhbGxiYWNrIGZvciBQLTE5MiBjdXJ2ZSwgaWYgSSBhbSBhcyBhIHVzZXIgdG8N
CmFzayBmb3IgUC0xOTIgY3VydmUgKG9yIGFueSBvdGhlciBwYXJhbSB0aGF0IHJlc3VsdHMgaW4g
U1cgZmFsbGJhY2spLCBJIHdpbGwgYmUgbm90aWZpZWQNCnRoYXQgdGhpcyByZXF1ZXN0ZWQgaW1w
bGVtZW50YXRpb24gZG9lcyBub3QgcHJvdmlkZSBpdD8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5h
Lg0K

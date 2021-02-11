Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EC0C4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 15:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6008164F35
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 15:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBKPS7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:18:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:31783 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhBKPNT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
IronPort-SDR: PnaNP+k7o7J3EMZB9rhk4hbd1C+vtWqHc8spZnatpyGtvwoVW9EOYB7zZZyXFPn4el73qjVIHx
 XWKnbELDSEXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="246321265"
X-IronPort-AV: E=Sophos;i="5.81,170,1610438400"; 
   d="scan'208";a="246321265"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 07:11:57 -0800
IronPort-SDR: 73Ce9HmY1zS/EPb8A5qx3UayAdrgvp3WmqglpnqjG9KSSIYHIRopYph1oLL4HqSgps1MekQf17
 LOoEWbI/Ncgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,170,1610438400"; 
   d="scan'208";a="490396038"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 11 Feb 2021 07:11:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Feb 2021 07:11:56 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Feb 2021 07:11:55 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 11 Feb 2021 07:11:55 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 11 Feb 2021 07:11:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HojqAgN1ZMWHD8tL0036vH5u6jQy/HrDNWVZu3HfT3dvSc3j2bbx8ChWNCQbTGgRBzua7lPuXzy3NsaQ+zlGwyVUzlXf4orMTKQ9EBleeDy2vr1NYM7H9UD5MOb9Q0TGIJdKUT+FdPYk6ub1R8/B6XWgCx3WRkfI7+TW+Dy18z++itRGSiTJID1eNXa0i6SoJmI8oKYvjhhUhUxjCWkE+y4oNInbjfmKReRPdf6AW810nQ0GEL1Do7H6XIpGxq0WCZwEg5tSaEKN9UAMzJZ9PCFNWUb0xzYz0rFxtldtmYcNJQc1TvEJDgebY4GE1lTpZYTvBc4d9RO8VbwSGyIAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeyZVWSg3N14PXb4zgujKVyAa69eZf+/YCUT0CVtVL4=;
 b=HyjBwoP+zH9u58VOIddaktA+kXHhrOQ9KMnnKkxav97yF/RfX0MTzw7mu5pdJz1ibummw1u9/aqA71cfIc2YWHpn40fAtv4VOd8YpCC5h5PirttpdAMGIZC7YE7JwW808xlQiw669kjaI8rGi/N4SI2pUIT0LAN4D3jEqxzE1oOEMHjamv2cgVN/pMm3j0sw3teS6wK6hjjJ7rFfVltc34Xjqh8lWdMZD8RxhNI/kv562SBpGhQk9oFuadROC68Zb3c8fMxveAZpdglFn6awq+kOV6TJCuf6ieDw8jRxMe5fQPOY5rFtvgvDTePzu8PqNuvoq2aPVlJ3hmIPGSQ2Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeyZVWSg3N14PXb4zgujKVyAa69eZf+/YCUT0CVtVL4=;
 b=N8nXj+kpGEvTKyixT6RWnYpsR9IBYQVQeIDhrSnk49s+CWJLt9lx4P4tc6TkZW0pvdVfobtPIDRoobvTsuZzi6jX5V7n8LtfIqq1SRSYyGhwRhy2swZ8o0gMf1eJ9of+xjL5aprl++48OtB5FiQcI9FqPvVCaTemjcgzAmh6EKs=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB3053.namprd11.prod.outlook.com (2603:10b6:805:d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Thu, 11 Feb
 2021 15:11:55 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3846.030; Thu, 11 Feb 2021
 15:11:55 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "hulkci@huawei.com" <hulkci@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Murphy, Declan" <declan.murphy@intel.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: keembay-ocs-hcu - Fix error return code in
 kmb_ocs_hcu_probe()
Thread-Topic: [PATCH -next] crypto: keembay-ocs-hcu - Fix error return code in
 kmb_ocs_hcu_probe()
Thread-Index: AQHW/39a4ojg9CJ/y0eRVK6+4XLGTapTEXSA
Date:   Thu, 11 Feb 2021 15:11:55 +0000
Message-ID: <2105a6297394b9a76cf193bd16b9afc5c2d0f3d7.camel@intel.com>
References: <20210210074350.867341-1-weiyongjun1@huawei.com>
In-Reply-To: <20210210074350.867341-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.191.232.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9960644a-37ea-4f43-0eb8-08d8ce9f5e6b
x-ms-traffictypediagnostic: SN6PR11MB3053:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3053A410CB1DDFCBEFAD28B6F28C9@SN6PR11MB3053.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QhLOO5wrGZXe95fWc+VsxpKSeM9pSee8bvteyV891xOCIg3GpRssAwprLSJNf4tG8dgl+jMGveNjXoNvQMcA3vvXLlX5HEQ3pMNIa3ffYG9QNGnjAx6+qnt7lw76QfOw9Vs+srojcztnLFyb/RjTycOjsq+H1jSnkMSiXtqOUy4809ixVQqWOII3YCp9U4WvD4u2gdb/Nn/2gDL7y3GRECpxPxs9SHWDTVbi5fLcp0ehYsPTZoFaLKj7aYjgtTCAghQwHjvnYDQqwJwBGRZsjCBKI7Xp6GEgXF5lHWWsoYdmgZRJXx5ha33UTHcrzLv1k4b4yCI80vw3lb4FLZvSUy3LytziOstZDW5yz2+JVUAsXyuLZgDrRoLxW2hxnt0ITysgGXej5Ge7s+iHrAtgHyVLJr9nX9qZanh4VPFpva4jZNCIuIzQstT03etpZgLbYR3QNxVzOIoOmMTIvPLwM7RnaXt3QgBQ6kwOsh9+/hYUgjwBH3I5YMnaWoOsLMiX55+n8Ylz15kBdEVOXeYOLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(39860400002)(396003)(186003)(71200400001)(6506007)(6486002)(83380400001)(2906002)(2616005)(5660300002)(6512007)(66446008)(66476007)(110136005)(66946007)(86362001)(36756003)(66556008)(64756008)(91956017)(316002)(26005)(4326008)(8676002)(6636002)(8936002)(478600001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SWhmY2VSM2ZhNTBPV1cydE5pdG1INjgySGlsOElTWU5jRzRrYVNaUUlTWEFP?=
 =?utf-8?B?SmxuZjdXbk5KeThDSlFaT3o0a0w0cDBjSFU4dVBzN1dmZmZ5ZjlQcHRGR2Mw?=
 =?utf-8?B?T2x3Rmc2c3p0RThuMDZYNk1zRmwvMU8xdHczMTBHRG5mdlVvbHlrZW5Dem56?=
 =?utf-8?B?NnBrM1BzOGhmMlNaM1FjYk5ZcWRod0NqRi8rSmhSV3VoZmpOTHlxQ3huc0Vs?=
 =?utf-8?B?VXlxSC9oT2M4R3crRlpZU3BiYUhvNytOQ1B1MTZ1QVo2WkdmREpnU1pWaFhW?=
 =?utf-8?B?eGRsazE2YjVOMENMQXlRL3pNbks3akdGeGdpZ01vQm9jR2ZVc0NzZHVPWnhY?=
 =?utf-8?B?anRhTXlNa1d5VitYQVdYK2RFcUVBaGJXaWxqUmh3QVZzYUdoMnNFZFVhNjdE?=
 =?utf-8?B?WVFwdXhkT0plMVFxOENwVUV0K1Q1QzJhTzVTKzhsWi9ZbldMWnU5THdkUzQ0?=
 =?utf-8?B?OFE3MjJFY2xuNUNyRDhkVHVDQTBPTXJPaFdlNUgxa1E3RVBxU1pMK2VxMWNU?=
 =?utf-8?B?anp2bEt1NGQ0eUdlemxseTVUWFhqM0FicFR3YXlocjl5NVlnSVRJdGxLTVQ0?=
 =?utf-8?B?TndqK2VmUng0WkVWUmp5SXNNV0FmWUFFdWZzQWs5QktZQjVMbm9vbkhnbGZE?=
 =?utf-8?B?SXFZd3YyNUMrN3Rua2JRMHFOY0d6MWgxNFdPZ1NDeFVucWR4WDlqUWpXMUUx?=
 =?utf-8?B?MGVXRmVDcUlrTWtDK1NieGQ4aVoyUElLUlVlUEZ0dW5uOWlSZm56dmdBa1E3?=
 =?utf-8?B?NTJNZjhwRk9mNW1aendLY2JOR0oxVVBKRThGbXBvM0ljUFd6VGM4R1Z3TGV5?=
 =?utf-8?B?c2NzdjJpM3A3L3NpVmN5amcwemo0eFdzNDVSMlh1WWtyWGRqS1FIYklOZE5M?=
 =?utf-8?B?S0FQQU1Ea2NFNnUzR05DVm9IUEFUYm1jQTZDbTFpMHFWWmlwWFRKOXNkNWJN?=
 =?utf-8?B?WE1ZZTZvOEVtREdFUExNNy92ZWl3U05kV1ZQaTNML3ZJV1lwUTBqdU40MUV1?=
 =?utf-8?B?dW1xYS9RbXM1ODFwWFhQQ1ZaZlUyZmk4b0R5VEVOM1dBdzFaS1ZsR3Y4aCts?=
 =?utf-8?B?NnVKNWFWeXNCajdoNm0ydlNJYnJxaysyakFwbURRQXdJQjhEakhtWmpWeUI1?=
 =?utf-8?B?Rm5QSzYvM21rMnhsTCtKdVU5QVFNVTZ0YzBoTXhWaWMxeWRsQWpMR2hJb3Jv?=
 =?utf-8?B?aVRlSnU0elUvUEhnZ0NWbVNLWTV5dTEveUpaTVNBMUJDaWFXdXo2K1lkSlZs?=
 =?utf-8?B?S2JyeitvbmVMUUhYMHRjWnl6dlJpWnEyQ2JqL3daby90SnVuNkRaMGxrMjhx?=
 =?utf-8?B?Y1RqanhQV1lUcXQxdkZBb1JWNVBGYlZGSjRYK1drd1N3WWpweXlRZFNIaXFO?=
 =?utf-8?B?UVZlREJiTkNzUk45YVdsSlRySW1ZTWRRS3ExSXlZTmRmeXkwUi9IUjlWcFlP?=
 =?utf-8?B?VEVlbDdlb280ZFI4RFFCdHFhbGF0dS81WVgxcHRrYlI1U0I5SkljRnh2SFFp?=
 =?utf-8?B?N0dqYWI4THpDWW1mNWROaDJYRFU2aHZ3b1BIMVZJZXpMWGlMbkhXeUFabi9Q?=
 =?utf-8?B?MDV5U1JpdElEZTEyT3VjYUkyalN1TlRHa1ZJSzlMYkt0RDdjeWdkV29iT2I3?=
 =?utf-8?B?c3ZjVWVSSzNQeXlSUkRzd0VWSHVrV1cydUJSUjJna0tNVE84ZnlCOGF6ZW1x?=
 =?utf-8?B?WWxWczlmSWpQbUlMNGlIeWg4L1RkTHg4OVUycnJNODRLSkdQMWw0aURtUmFj?=
 =?utf-8?B?VTJBRUMwbmtnWWw5a2RDcWROTVJTRGhGWEJIbzFVSVBCZUo4MnMxdU5wcGVv?=
 =?utf-8?B?SzZwVFBpYUJQYzdmOC9Pdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D84655B294DDB84DAF6831C6D0B097D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9960644a-37ea-4f43-0eb8-08d8ce9f5e6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 15:11:55.1591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JHF1zfex7mWHuf3EoNgLHYBZmjmJ0f9WH2JndLB+NSGTgf1+WPR3Jx8YL9UjhUkfzeCwbuGTdUlzs1h4qKtxYvUwlgY+0N8eVdqZ5SaoXHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3053
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgV2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmaXguDQoNCk9uIFdlZCwgMjAyMS0wMi0xMCBhdCAw
Nzo0MyArMDAwMCwgV2VpIFlvbmdqdW4gd3JvdGU6DQo+IEZpeCB0byByZXR1cm4gbmVnYXRpdmUg
ZXJyb3IgY29kZSAtRU5PTUVNIGZyb20gdGhlIGVycm9yIGhhbmRsaW5nDQo+IGNhc2UgaW5zdGVh
ZCBvZiAwLCBhcyBkb25lIGVsc2V3aGVyZSBpbiB0aGlzIGZ1bmN0aW9uLg0KPiANCj4gRml4ZXM6
IDQ3MmIwNDQ0NGNkMyAoImNyeXB0bzoga2VlbWJheSAtIEFkZCBLZWVtIEJheSBPQ1MgSENVIGRy
aXZlciIpDQo+IFJlcG9ydGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4g
U2lnbmVkLW9mZi1ieTogV2VpIFlvbmdqdW4gPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+DQo+IC0t
LQ0KPiAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1oY3UtY29yZS5jIHwgNCAr
KystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1oY3Ut
Y29yZS5jDQo+IGIvZHJpdmVycy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1oY3UtY29yZS5j
DQo+IGluZGV4IGM0Yjk3YjQxNjBlOS4uMzIyYzUxYTY5MzZmIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL2NyeXB0by9rZWVtYmF5L2tlZW1iYXktb2NzLWhjdS1jb3JlLmMNCj4gKysrIGIvZHJpdmVy
cy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1oY3UtY29yZS5jDQo+IEBAIC0xMjIwLDggKzEy
MjAsMTAgQEAgc3RhdGljIGludCBrbWJfb2NzX2hjdV9wcm9iZShzdHJ1Y3QNCj4gcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQ0KPiAgDQo+ICAJLyogSW5pdGlhbGl6ZSBjcnlwdG8gZW5naW5lICovDQo+
ICAJaGN1X2Rldi0+ZW5naW5lID0gY3J5cHRvX2VuZ2luZV9hbGxvY19pbml0KGRldiwgMSk7DQo+
IC0JaWYgKCFoY3VfZGV2LT5lbmdpbmUpDQo+ICsJaWYgKCFoY3VfZGV2LT5lbmdpbmUpIHsNCj4g
KwkJcmMgPSAtRU5PTUVNOw0KPiAgCQlnb3RvIGxpc3RfZGVsOw0KPiArCX0NCj4gIA0KPiAgCXJj
ID0gY3J5cHRvX2VuZ2luZV9zdGFydChoY3VfZGV2LT5lbmdpbmUpOw0KPiAgCWlmIChyYykgew0K
PiANCg0KUmV2aWV3ZWQtYnk6IERhbmllbGUgQWxlc3NhbmRyZWxsaSA8ZGFuaWVsZS5hbGVzc2Fu
ZHJlbGxpQGludGVsLmNvbT4NCg0K

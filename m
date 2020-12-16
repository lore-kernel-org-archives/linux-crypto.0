Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2D9C2BBCF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 16:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 947F122EBF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 16:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgLPQ6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 11:58:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:40099 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbgLPQ6w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 11:58:52 -0500
IronPort-SDR: isQyFiBi99kaSIUnPoAIwqlHELRsxZUD/+FN4Q3otSiVR2QmupXGrQUoBilzKUTfYgKu2Xnk8l
 iuzw6rws1hrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="239190532"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="239190532"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 08:58:11 -0800
IronPort-SDR: ENJHQ1NIs5UB2jGljfJqKgy3CmVQCwxgS6CUSEYY1zBYFHA9MDcFXN3VDw/W4AQ72kkE5x0gKF
 OQ5iSRm6hOjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="333398684"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 16 Dec 2020 08:58:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Dec 2020 08:58:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 16 Dec 2020 08:58:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 16 Dec 2020 08:58:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flKwPvw/7z7HNRvXPtSdBSqZyBE9BuN7zfh1Ezh//XmvUPm8FyezYlFlSdSW1HGz916Qb0Zy+kHcH1TkUkML/HnbEMm6Mcj6u4Z5CA9s7sSBAJm596MgWzmdJeb6TME1cGvq5/IxzESVXN7VpLhFoF2vojFU62KAl9LhJ+yl/vFy1UeLRV9TKm8p3SIpuswHIn3hf2/6IcYKmYd0xZLRgIzjX3nnleD+ta7hUrxIJgV5NUTH3hFe3qspbBEG80enfFZB5Hwp7WrJ/OCgpQWXE48Y03tQP7nOYSHbkbF0wL64X8BfxMIEw9/i/tcu1+6fDPgVzmN/XK98wJzOAEuKDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDq0IgyInC/7D/rlbVfkdWz+YzGZKfW2aelals9UzNg=;
 b=bgC/1n06uhJMzAGvX/mG1xo3itD1jnWh9Iu/HQX4OA8ax1nvHz64151mUuuEjTL7819y/EPiMjiI4CNuMT2lA1O/O0lQAZc+eaJG7Snj1iEfohpe9SOnX/6o9mkYvBQwb2EKGrbMnJhTlkgXGh8dbET2pSHAnLDF7CkzQyNbdHAHxu+APvXgtmXVj3FmJ0GFb4IjT/yOX6FB4OhmS74pJqmVXcvfzEonUh9H5hgQU4dJNzWIoSV6kpKrTzUeHkRWnyUsWRCK+v16KOezt8SWuCGzfz5FZ7Ai3X3VOc+cLZEm/ibiOnCiVsP7WZHE44yttgZLYuUEQPF9J4s5w5n8XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDq0IgyInC/7D/rlbVfkdWz+YzGZKfW2aelals9UzNg=;
 b=penD2p7kRaJagQl/o9PmdEhryhn75lRhAIh4g7qfOCMuh3+fRKLzAonVGUEfwHh4ta68urRs3IEutt0iKNeN7Hdqei3kjUNbM2qEO6KKdJWMbR8Rx6EWY8Hto7qjfGofPptkDo8NsVYE/Xz0tTA6yJPufL9UqJTxzKMDB9NLbL8=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB3056.namprd11.prod.outlook.com (2603:10b6:805:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14; Wed, 16 Dec
 2020 16:58:06 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb%3]) with mapi id 15.20.3654.024; Wed, 16 Dec 2020
 16:58:05 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "Healy, MikeX" <mikex.healy@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: CRYPTO_DEV_KEEMBAY_OCS_AES_SM4 should depend on
 ARCH_KEEMBAY
Thread-Topic: [PATCH] crypto: CRYPTO_DEV_KEEMBAY_OCS_AES_SM4 should depend on
 ARCH_KEEMBAY
Thread-Index: AQHW062YNDKSBnqWtEOrhZVLutsumKn58dmA
Date:   Wed, 16 Dec 2020 16:58:05 +0000
Message-ID: <82c601a9e6c4adac815b2e3c091a2c1ed4daca38.camel@intel.com>
References: <20201216131459.1320396-1-geert+renesas@glider.be>
In-Reply-To: <20201216131459.1320396-1-geert+renesas@glider.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-1.fc32) 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8ad5751-7738-4d59-0018-08d8a1e3c1ec
x-ms-traffictypediagnostic: SN6PR11MB3056:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3056A092315091FA41BADB36F2C50@SN6PR11MB3056.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oFNEYljtGmxVgUabN+FGXyvPWDnkL0tAD/P2UrELt9dOAqKBAhlqV/48ghzXnmXhuYytaXtbpPhKZU/7m1V1H6358hSi+2RGhML1IYzdb4BDU3UA4o+rGC8VYgO/oqdOPYy36Ad077VbCf68rPkBmqL2UrbrwqvygWTtgFxaE8MbOO+dNO5oVKiyEGaFqKGFaoLArm7fW9Chsgk1Dz3lnANAAmJJrZET02N9npDIp6yvR72of8+HcHveZbyFYDzVeKtTeUnxThIxOlAOtzZqat6VhccIHAFujp3wXps+US34HlTDiD8BLzFMOLFhx7hR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(71200400001)(5660300002)(186003)(316002)(64756008)(4326008)(478600001)(6506007)(2616005)(6486002)(66556008)(36756003)(66446008)(8936002)(83380400001)(86362001)(26005)(6512007)(91956017)(66476007)(66946007)(110136005)(76116006)(2906002)(4001150100001)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TmhMWnRObXRrUDlIRGoyTzFNTTN3cmhia1BYaSt4OTcxY2JqaEdVRVZGcVVp?=
 =?utf-8?B?QVpxWW94NEMxQlVZbjB2Yzd6bC85U08vZUVsMFI0T2FRV3Q4SUc1N2J0ZWdC?=
 =?utf-8?B?TVlHUHE5R2FWZHhSblBEU2U4d0FxRDNiazBOenEwcUtJMGZkOE1iQnpjQkRq?=
 =?utf-8?B?ZHFhU29oSUFSaGRGUGNvbzNxZU04TUJqODNmWmxDMlp0eGpPQU5WR2JOTDhU?=
 =?utf-8?B?WXY2eWpMS0xrNENRWVYwYUZSUm53cStCZ0xWSndCYkEzZnV6TkxOMG5YR0dP?=
 =?utf-8?B?R0pLbWRJbkNhMTNpaVR4Z2Y2RkxCaUpuSXpUNFJickhnOVFnTUVGSmRWSnpM?=
 =?utf-8?B?ek1vK3ROZk85eW9HZU5wQlcxQWpYanZIR0tMSEFFRXNTN1BWQktROXEvRzl0?=
 =?utf-8?B?bUJXQVhWQW51K28wUXJ5NitiQlp0akgrRFdrL25BKzFMa244Q1RjeDVzUzJU?=
 =?utf-8?B?OUpVR1JtbXNxSWhIQWNvaXZzMWsvU2t1TjZsTzZ3K0lFZVNNNFRaNjJkSlRJ?=
 =?utf-8?B?OWFKeHhicXR4UmxyWFJVOEJnQnF4b3ZTT01SbWVFV2pZYVVRY0M1elE3RndL?=
 =?utf-8?B?WTBRMWRHaHZBempRUTNlS3ZsWHZCZDljQzVscVh0MUZXZVQwSFgxYytwT2tq?=
 =?utf-8?B?Ylpjcno1Nk1nU1RIaUI2akxQd2RPUXZPUlN1a2Z3bXV4emR1aDBheHArbVQx?=
 =?utf-8?B?N3lUS29lWVRIRncwMU5UNkN3Vkt0TGlrS0tnSjVQK1ZwWENWbytsc2l5QXcr?=
 =?utf-8?B?L1hqZVltb1FhWHYwWHAyWWRSbTE5QU9KV01SQXAwY01rcmd0YWI5R3JvdHRr?=
 =?utf-8?B?L0tNR0tYeGJDZ3BPa1pzWGRiZWJ1ckVPSnRXYU5JdHNVbzZla2IwR1QvdVU4?=
 =?utf-8?B?OTdnZHpQT2RqdTA0TXVuL2FFYVhiNU9FVTNHUHp3bzRSNGc3ODlwd1d2RFB5?=
 =?utf-8?B?N2ZicktsZzAxWWVXT1U0YW5YbFJXU3ozM2tZcUNRMXk4K1ZzNXMybm1GSUZV?=
 =?utf-8?B?SFlyaXUzdVZrUldNK080N2pjSnJJVkZuSVVJRHlpcEx5SlBlSW8xN1dyZkRa?=
 =?utf-8?B?NDRLOS9rdFZMcnlZUTFWRHhLSUd5bjZucEUvV3pWTzgxK1FGcXhGRXduSm85?=
 =?utf-8?B?RFl1d1pndGRrcXBXeDhyM25jeURmYVJ3ZHIzZ3dYbGNGbmhrRTFsMUZIYThV?=
 =?utf-8?B?UnZsb1ZKK2xZMmIvenVJdlJXaWNoVXBnd3pUVWFwY1B3Y3RMTG9kZkRONlZQ?=
 =?utf-8?B?UWpkTEFPMHBQQXRqbmVvNmhDN2JKYU5iWjUyZWkvQStTWkFVeFloYzdqSzBH?=
 =?utf-8?Q?Lax7eSCY6Cw6fYNborAmoy8iSYi5aoJmkR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA7ED6ADB28E37468D3A1AA3CAC1B615@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ad5751-7738-4d59-0018-08d8a1e3c1ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 16:58:05.5222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CjWBQIVrTZT3WuZ5Ry/8HMScdd1KalSU0CnfsvnSBizDPwxuLQblLlsBRSOf8loIXiRr/HBmV5OOAOmST3+hBOdwVC/sIMEWqzUY+fJROEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3056
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

VGhhbmtzIGZvciB0aGUgcGF0Y2guDQoNCk9uIFdlZCwgMjAyMC0xMi0xNiBhdCAxNDoxNCArMDEw
MCwgR2VlcnQgVXl0dGVyaG9ldmVuIHdyb3RlOg0KPiBUaGUgSW50ZWwgS2VlbSBCYXkgT2ZmbG9h
ZCBhbmQgQ3J5cHRvIFN1YnN5c3RlbSAoT0NTKSBpcyBvbmx5IHByZXNlbnQNCj4gb24NCj4gSW50
ZWwgS2VlbSBCYXkgU29Dcy4gIEhlbmNlIGFkZCBhIGRlcGVuZGVuY3kgb24gQVJDSF9LRUVNQkFZ
LCB0bw0KPiBwcmV2ZW50DQo+IGFza2luZyB0aGUgdXNlciBhYm91dCB0aGlzIGRyaXZlciB3aGVu
IGNvbmZpZ3VyaW5nIGEga2VybmVsIHdpdGhvdXQNCj4gSW50ZWwgS2VlbSBCYXkgcGxhdGZvcm0g
c3VwcG9ydC4NCj4gDQo+IFdoaWxlIGF0IGl0LCBmaXggYSBtaXNzcGVsbGluZyBvZiAiY2lwaGVy
Ii4NCj4gDQo+IEZpeGVzOiA4ODU3NDMzMjQ1MTM4MGY0ICgiY3J5cHRvOiBrZWVtYmF5IC0gQWRk
IHN1cHBvcnQgZm9yIEtlZW0gQmF5DQo+IE9DUyBBRVMvU000IikNCj4gU2lnbmVkLW9mZi1ieTog
R2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT4NCg0KQWNrZWQtYnk6
IERhbmllbGUgQWxlc3NhbmRyZWxsaSA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4N
Cg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9LY29uZmlnIHwgNCArKy0tDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkvS2NvbmZpZw0KPiBiL2RyaXZlcnMv
Y3J5cHRvL2tlZW1iYXkvS2NvbmZpZw0KPiBpbmRleCAzYzE2Nzk3YjI1Yjk0OTdkLi42ZjYyYzgz
OGEzZmEwYjJlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9rZWVtYmF5L0tjb25maWcN
Cj4gKysrIGIvZHJpdmVycy9jcnlwdG8va2VlbWJheS9LY29uZmlnDQo+IEBAIC0xLDEyICsxLDEy
IEBADQo+ICBjb25maWcgQ1JZUFRPX0RFVl9LRUVNQkFZX09DU19BRVNfU000DQo+ICAJdHJpc3Rh
dGUgIlN1cHBvcnQgZm9yIEludGVsIEtlZW0gQmF5IE9DUyBBRVMvU000IEhXDQo+IGFjY2VsZXJh
dGlvbiINCj4gLQlkZXBlbmRzIG9uIE9GIHx8IENPTVBJTEVfVEVTVA0KPiArCWRlcGVuZHMgb24g
QVJDSF9LRUVNQkFZIHx8IENPTVBJTEVfVEVTVA0KPiAgCXNlbGVjdCBDUllQVE9fU0tDSVBIRVIN
Cj4gIAlzZWxlY3QgQ1JZUFRPX0FFQUQNCj4gIAlzZWxlY3QgQ1JZUFRPX0VOR0lORQ0KPiAgCWhl
bHANCj4gIAkgIFN1cHBvcnQgZm9yIEludGVsIEtlZW0gQmF5IE9mZmxvYWQgYW5kIENyeXB0byBT
dWJzeXN0ZW0gKE9DUykNCj4gQUVTIGFuZA0KPiAtCSAgU000IGNpaHBlciBoYXJkd2FyZSBhY2Nl
bGVyYXRpb24gZm9yIHVzZSB3aXRoIENyeXB0byBBUEkuDQo+ICsJICBTTTQgY2lwaGVyIGhhcmR3
YXJlIGFjY2VsZXJhdGlvbiBmb3IgdXNlIHdpdGggQ3J5cHRvIEFQSS4NCj4gIA0KPiAgCSAgUHJv
dmlkZXMgSFcgYWNjZWxlcmF0aW9uIGZvciB0aGUgZm9sbG93aW5nIHRyYW5zZm9ybWF0aW9uczoN
Cj4gIAkgIGNiYyhhZXMpLCBjdHIoYWVzKSwgY2NtKGFlcyksIGdjbShhZXMpLCBjYmMoc200KSwg
Y3RyKHNtNCksDQo+IGNjbShzbTQpDQo=

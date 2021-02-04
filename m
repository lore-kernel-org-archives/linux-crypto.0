Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26394C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 17:55:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF9B564E0D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 17:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhBDRyg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 12:54:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:15375 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237459AbhBDRy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 12:54:27 -0500
IronPort-SDR: VCLPopg0grRIcBwmeDG3HnBf22sI96i1FIjRLqSlnyIwurYDLQrJfZSKt0VRJV7q/gq/BOkbt7
 zJ6MWI2Nsc3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="160455698"
X-IronPort-AV: E=Sophos;i="5.81,152,1610438400"; 
   d="scan'208";a="160455698"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 09:53:40 -0800
IronPort-SDR: mhz4FE4EQ4mCJnQFjUzQIQr/bwGMsQ0+q/LphQGNY3VHZYChFpb7qOCygygF7LTY7gsd9w233/
 HNFbM2e3LE4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,152,1610438400"; 
   d="scan'208";a="483648454"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2021 09:53:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Feb 2021 09:53:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 4 Feb 2021 09:53:40 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.58) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 4 Feb 2021 09:53:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/lbb0pbpLT1r3D5Or5ezinESQC06d1gAFCVflcymeQRNejVLShZyn8GndHoXi92veiYkUi2Cp+WhswBJpQfZ998/+U2jHndhlz7hYISM9vewQ2FV9TKBpVdU++vrGj+5ylYwqIOVl5AIVWKMjIqTuqGqfziQfWvLcJ39cSfLmAW84VADEqg1Jt2tYCROGctYPH+ydTM6V0T+odIknnGUMbEEeuu/13Uz1pgdRJ+NiFULljmvNCjRLwhsfH4Ql0V4FjqqqKSrySbZA0e/j6uAiXD8FHOwsjIqSoT4NlHKKBDJQZDxEcG5aPk/LIX9qZl4iRvNxLycx1f3jKyewZYDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjAa224OKrhnv2iEGugqyVbTZsYGBEgtt8O801lmor0=;
 b=ZybVKA+bLmKNtuQMabwjuwqdi56YxgxeLuNumwL75A/dS+KJIMvKjuSLwY3AbjTnxyKR1N9lF4OvWYUACS2iI1dWt/TQRGtlNsB87W1loId2Scwovm8XnYAmiYxroj0k7F/vORpwBI7HhJgXM05rmh7RA4huGHa4AMKEpDUstN873bwMFOYrCxrq/jvnKT5JoyKQv4EzeU6Skzzyjdf25uKzvRvuPW5ak4ENhnITN5pw8bsF8giNXYr2pY/9bukM6rOe67sDlbhZ0ZhgrMGXgR11J/2mLZpi9SujeCrchSYfpKrX1O87UMlU56RqqtZYcdnijsJ6o3IqVSOPWUqdmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjAa224OKrhnv2iEGugqyVbTZsYGBEgtt8O801lmor0=;
 b=oIcv/FyVmncctFh06oisVLMEllKgCEsFO987Cc6m4jCwfHFoWZtWE8SjVRIIgdRE1AoK/LBcWph8X4GMWC8rJyhJMdTk1zTfU0jajz55n9HdAZLgqy1QMSlQKCkYCT9vbF/U8+vtClAYmM/Yqp9Pglb5u4Gozxt31U3Be/+YIqc=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Thu, 4 Feb
 2021 17:53:39 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3825.020; Thu, 4 Feb 2021
 17:53:39 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "lee.jones@linaro.org" <lee.jones@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Murphy, Declan" <declan.murphy@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 06/20] crypto: keembay: ocs-hcu: Fix incorrectly named
 functions/structs
Thread-Topic: [PATCH 06/20] crypto: keembay: ocs-hcu: Fix incorrectly named
 functions/structs
Thread-Index: AQHW+uZZ/ghhe+tLN0qICeiOprWDg6pIR4aA
Date:   Thu, 4 Feb 2021 17:53:38 +0000
Message-ID: <b8425f8b292e0ca268a2f575e9053ed408bc4c6e.camel@intel.com>
References: <20210204111000.2800436-1-lee.jones@linaro.org>
         <20210204111000.2800436-7-lee.jones@linaro.org>
In-Reply-To: <20210204111000.2800436-7-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 878ccfcb-5d96-42d3-996b-08d8c935cd84
x-ms-traffictypediagnostic: SN6PR11MB2575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB25757B4037D389FF1B845C78F2B39@SN6PR11MB2575.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xkb0B0bAoAiZZqIFcdPJGzvB4KL5PJ9AZT4rtsTv/NXCRNwDRzdZvnLYTil/eb3GqrdrI6Ijw9WUMJX7d6WqaRJoIRf/AD6/zXODB6u6mc/WoRQKX8JRVXFbLjKrRI52X9tV3Jg9CF4U/TT6GfJogxSCPRMUMqOEbCURcpvS9rxW9McXVmZu+4FEQYRffnFpQlrG96QMbcLFiHV6iGlLcepZN/Fxh0FtsL0qdml6QgVRztp5Hef7YU04EQHr41/69PwGoovJGmez/swcJKbgZjhU1oAw7d6iSKhUHRCJw/2079IUUQ9D/EyTXAMUnRUUN2WWcsXqXLUbPlJAqrdSOxZ8O4RvBjsCd1/DrBWQEu/rWQ0AKwJhywxvCFAjOq6eAg+tMycbGr/VpaZ5DYgMBxpw3QDnAWw77isULvUe337Tj4mYwImUPNRssHMsKLFx9V1hfCvyCU2y+5lddjqngMFmPMvnWXjDPDPvrkV3AnmJ7SzLkYcvr0G3aayGOXa/OD1FXiYJeNJ/tTOEADIb1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(396003)(376002)(136003)(76116006)(186003)(8936002)(66946007)(91956017)(66446008)(86362001)(5660300002)(478600001)(36756003)(54906003)(6916009)(26005)(316002)(66556008)(6512007)(71200400001)(6506007)(6486002)(8676002)(64756008)(66476007)(4326008)(2906002)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VEp6N0JGVUZUVGEraVlsZEl5ZitteTBtSXhXVEc3dnFJMHF0ZGJSTjR4azJo?=
 =?utf-8?B?ZVY2akw3b3VmUCtxem11c0JBckRmVy9nOW41TlpxRWdlcDFLUVl5bnRhVEp4?=
 =?utf-8?B?THFERjhKbVcyN3l3a1ZKMzhtMjFXZjZjUlduSDFjb2x2RDZtOHhvOHlneTJ1?=
 =?utf-8?B?ZDFUTlkxS2JCeFNGeVZIb3dQd25lLzlYWXl0c2VpYWt3YXVGczlQSXpTSkNG?=
 =?utf-8?B?a1djK096cXRvZGFGYXpNeUdVc2VhY2M2T0pHaHh2VXNYZWl2dXJodUNaL05N?=
 =?utf-8?B?dUJzUS9SUTN1bCtldlFjQ1JTWkZkbGdSb0dFa3ZFbG95aS8vSVd2ZUdqQjg5?=
 =?utf-8?B?aFp5TURGTzJ4cm5haDlDdzRLY3VMZncwTGpwREpiYUwyYVh2aU5ncGRDRlpx?=
 =?utf-8?B?NUJoZWVDQXNvb1Y3Z0g1OTlVd0tJQkNKTGUzaEVoclNWdng3Y3pPRTlQTTJz?=
 =?utf-8?B?RHNTNEcvKzc0T2t6SXF6c2w2aENXMFR1ZmMySmRDNUJLdjFXdXZQVnQ4ajhD?=
 =?utf-8?B?N3BscmRhUHhxVzB6Unc3L1NUalhkZklZb1B1a3hhTTAwYitOc2RDWUI0T2lT?=
 =?utf-8?B?WmxMS1ZGSGlDUk1KU21RTmdiN0dabjJsYnFqYmdJYWJVdk1QQTlBSDJ4MTBh?=
 =?utf-8?B?SEJSWHFTWVAyaWUxa25zSUhkQkZtTHdJK2czVEhwam51VEFTZWNYTGJ0ZVRW?=
 =?utf-8?B?bnQ0RDZXNjJrSnlkTFVLeEtoM1JncnMzUkNwSjNCVEd6QWtmT0ZvKzg3eVlL?=
 =?utf-8?B?V2oyaDVEZ0tOYWJuSnBpakZMeGpBajdRcHhrS3VKS0ZLRklwUStVUzVJTU01?=
 =?utf-8?B?ckNCMk1ibEVTcHM1T1FNYTRRVjhSQ1UvNjN5Y3pvS1dpWDM3Rjc3THc5RFVK?=
 =?utf-8?B?MEhhVmw5TzBtS2FKWWNrZW9rZEpWQzd2TWdpWmZqNmlnN0lpaGlXcGhVbU1N?=
 =?utf-8?B?Mld5SE1hYVRNc2NQZzdRNkFNUkdubk4vVDFpSnBRVVhFb1JRU1lDK3NyNHJ6?=
 =?utf-8?B?RGtzKzFDOVNUcDFQY3lMZHZqendhNkM4STRYMUJuYTM4Ni9QVHNXK05LMGV4?=
 =?utf-8?B?cXpwcUFQNVVKek1wWnZTSFFFTEpsZnZzRm5taHd2SnpjS3FwbE85ZWlROXpC?=
 =?utf-8?B?ajZiNWNSR29heGFEVG5hTUlhbWVZMVNWV3V1NWdMZ2luMTR5RU02bytMSVJl?=
 =?utf-8?B?d0dIU2FHRkRGbXhRM0xtWjFzNE1sWDF5bTZmSkE5My9vaEM5THBzdVZobkI4?=
 =?utf-8?B?dEFhYjhHMmhHSGRLeFFhRkx6dUxhSlVIVHAyYThUMTI4V0pDYzBmb1VXdEVt?=
 =?utf-8?B?dm9oRVBBeHNDNFd6YzZFemRWWDMxWGxZRzRhc0Rvb0Z2VEFjeHZmb1NIRm0x?=
 =?utf-8?B?cmJCWEoxQ0l2L0grbnNrQ3BKMkEzb3VTeEVYaVR0ZVJIU0txQ3Q4d1FZNFlR?=
 =?utf-8?B?ckYxYU5SRDkwL0pKbmIxdG5LcHdZN1V1VDUzMWp3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9498B8D24AAE974298EB344EAD004471@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878ccfcb-5d96-42d3-996b-08d8c935cd84
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 17:53:39.0174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vst+kUmXUWRGbC2ZKjTaEFhtcC3Zt9MpPzGdRMdAPFOkkLJj0dqEJSHVVx0pmcO/HFMAZ9zWhVjzrvQAnoClIaBLdKGqHCFnP0Xw7aU+mCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2575
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVGh1LCAyMDIxLTAyLTA0IGF0IDExOjA5ICswMDAwLCBMZWUgSm9uZXMgd3JvdGU6DQo+IEZp
eGVzIHRoZSBmb2xsb3dpbmcgVz0xIGtlcm5lbCBidWlsZCB3YXJuaW5nKHMpOg0KPiANCj4gIGRy
aXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jOjEwNzogd2FybmluZzogZXhwZWN0aW5nIHBy
b3RvdHlwZSBmb3Igc3RydWN0IG9jc19oY3VfZG1hX2xpc3QuIFByb3RvdHlwZSB3YXMgZm9yIHN0
cnVjdCBvY3NfaGN1X2RtYV9lbnRyeSBpbnN0ZWFkDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5
L29jcy1oY3UuYzoxMjc6IHdhcm5pbmc6IGV4cGVjdGluZyBwcm90b3R5cGUgZm9yIHN0cnVjdCBv
Y3NfZG1hX2xpc3QuIFByb3RvdHlwZSB3YXMgZm9yIHN0cnVjdCBvY3NfaGN1X2RtYV9saXN0IGlu
c3RlYWQNCj4gIGRyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jOjYxMDogd2FybmluZzog
ZXhwZWN0aW5nIHByb3RvdHlwZSBmb3Igb2NzX2hjdV9kaWdlc3QoKS4gUHJvdG90eXBlIHdhcyBm
b3Igb2NzX2hjdV9oYXNoX3VwZGF0ZSgpIGluc3RlYWQNCj4gIGRyaXZlcnMvY3J5cHRvL2tlZW1i
YXkvb2NzLWhjdS5jOjY0ODogd2FybmluZzogZXhwZWN0aW5nIHByb3RvdHlwZSBmb3Igb2NzX2hj
dV9oYXNoX2ZpbmFsKCkuIFByb3RvdHlwZSB3YXMgZm9yIG9jc19oY3VfaGFzaF9maW51cCgpIGlu
c3RlYWQNCj4gDQo+IENjOiBEYW5pZWxlIEFsZXNzYW5kcmVsbGkgPGRhbmllbGUuYWxlc3NhbmRy
ZWxsaUBpbnRlbC5jb20+DQo+IENjOiBEZWNsYW4gTXVycGh5IDxkZWNsYW4ubXVycGh5QGludGVs
LmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4g
Q2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBMZWUgSm9uZXMgPGxlZS5q
b25lc0BsaW5hcm8ub3JnPg0KPiAtLS0NCg0KQWNrZWQtYnk6IERhbmllbGUgQWxlc3NhbmRyZWxs
aSA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4NCg0KDQpUaGFua3MgZm9yIGZpeGlu
ZyB0aGVzZS4NCg0KRm9yIHNvbWUgcmVhc29uLCBpZiB0aGUgaXNzdWVzIGFyZSB0aGVyZSwgSSBk
b24ndCBnZXQgdGhvc2Ugd2FybmluZ3MNCndoZW4gY29tcGlsaW5nIHdpdGggVz0xOyB0aGUgY29t
bWFuZCBJIHJ1biBpczoNCg0KICAgbWFrZSBDUk9TU19DT01QSUxFPTxhcm0tY29tcGlsZXI+IEFS
Q0g9YXJtNjQgLWo1IFc9NCBNPWRyaXZlcnMvY3J5cHRvL2tlZW1iYXkNCg0KV2hpY2ggY29tbWFu
ZCBhcmUgeW91IHJ1bm5pbmcgZXhhY3RseT8gSSdsbCB1c2UgaXQgZm9yIG15IG5leHQNCnN1Ym1p
c3Npb25zLg0KDQo=

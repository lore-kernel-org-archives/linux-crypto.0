Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EEFC433DB
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 17:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D82C22C9C
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 17:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393546AbhARRJl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 12:09:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:32942 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406928AbhARRIw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 12:08:52 -0500
IronPort-SDR: JEuex1xOqOoNUZnHZkQPbSi5wri5CDj2yAK28oDJFa5MEI+A27mQW+3Hpq+d8ykZUuOUyU3W8W
 +yVNz8Zmu8bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="175324587"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="175324587"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 09:08:10 -0800
IronPort-SDR: Id/8Qo1/k8pn1ziGuubygTiEQ+kdZDoo+c7X5TjdQ8ec5anv8M+3kGypXVuo1a44AQ3YRwkraC
 t96xrqY+Dv8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="365391458"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 18 Jan 2021 09:08:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 Jan 2021 09:08:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 18 Jan 2021 09:08:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 18 Jan 2021 09:08:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMLErdtdhXzM4etqe4eEp21uOIm9NBVWE5xXgsVYklNiIhkLiyrc8cZMmH/vgOLwnrNZDWWsotAu7mN7CbYiP3TGsbArj56IHZy5LGO1vxJmxPU1wFTDpOyz6HQxmrzssFGUpfHf1Nl17FNew7rzgDuHvheb8d9/ji8R6KPFyKuhhMfHg8XrQgG/8JF9SXsDI6s8mOrRJ2CShxOvXm6d+5U9vnjku3OorIrB3WXRo4vgJTuMIH9upLfRQ8+rpS6N5UlWaeoiZX6AOc6996EIBHTAyMc7GEv+hQlLWmGUAYPAaJIbgRC8OixwAvOvyzkuQuUQsgfawnV7aDoJVJsdiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMdTwi9YfLMxqlQdcXFPRHRgxbOqBznMQc7BOZkAa4Y=;
 b=ietZQrY1NWwzKRE2B/kkl0yfsfaf67w6/PrDbMv9pufQ0f1v6G14LZ5HUxh/7Vbgr42/oS55emNXnM7YVQvVJcrHBAdJN5Mj2/fIpQ5FdDXbAqLlJ0uq1qVdnzG+EGfhmB4E86kx4LHKaolCmhktAPp1H8DHsu/s+yIJ4QH9bbxKQBlVDA/I13rFAkZPYgM1xMc2j/YmGcirKdh++ZbESPGhIT+fsyIbQkQGXDF0AgpCtuNpLJliZ9Oi3YADztUptyfxv2JV4f47bkg+iNTIygfRrwgk3sBVYTnynV9cDwHq2Pzqsgge0BLZKsZT5g3mxXJyA34aER3Eu/XBmZu5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMdTwi9YfLMxqlQdcXFPRHRgxbOqBznMQc7BOZkAa4Y=;
 b=c42OntcGJ+TtZ6IZQD3joSt2tVtj97FolYKJ/1kPGQYdfbJPLD3G99Uln0NLIEdgMzOipO50cxe4ttfbj8vL5o0AV667QwbZ4gQqjHxBSDL19ZTSMka650H4yGv9aGEK+HTzpEvMcK4IMda6rCrd2ErE/jX1njzNo0xIBJcxfGc=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB2943.namprd11.prod.outlook.com (2603:10b6:805:d3::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 17:08:06 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:08:06 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "ovidiu.panait@windriver.com" <ovidiu.panait@windriver.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: keembay: ocs-aes: use 64-bit arithmetic for
 computing bit_len
Thread-Topic: [PATCH] crypto: keembay: ocs-aes: use 64-bit arithmetic for
 computing bit_len
Thread-Index: AQHW63+6NeOB492f4UO80BWDrld0FqotofgA
Date:   Mon, 18 Jan 2021 17:08:06 +0000
Message-ID: <6531633c91803cd9677c777da330b913e16f4d45.camel@intel.com>
References: <20210115204605.36834-1-ovidiu.panait@windriver.com>
In-Reply-To: <20210115204605.36834-1-ovidiu.panait@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c68035ff-a07e-46f2-859a-08d8bbd39ff6
x-ms-traffictypediagnostic: SN6PR11MB2943:
x-microsoft-antispam-prvs: <SN6PR11MB29437F2D8F1ACC9771D95C4CF2A40@SN6PR11MB2943.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hoGtKWW+yf4uilWr7Cz3BXmHGwWgLENcBi6Dwgy9nDrBpiR2WfP1Kql8y4FjgB4aWJb48F4VD1kY6wENIssWAlUjsWpnEfIeo6qwdqvU1N1auaSF6PsXQ0/sL/os+flnTjempTsQ6KKxRDH935FHPF240jJK44fSiC+xKH1Rutva1H6lkkcfDzKmWdISVxygOWBuLH70FIgKPDrVumlw2DUM6WdmBvKD3mVtIwkObPzGzKh5g9m09iCeFVMRsI8Yypgz5BBHVljOfrWCUhJ37h2L6PVValc44FWenFcFifAGdwEBfFUxPd88ghcm45mstvb2z6fm8y7/U1WvnYia7ChDHWrzomTUItKxDGdKOfUKkW0UAvJRwBR6WwA3OAGENXC9+bKMw/hzbHbtfcGsUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(366004)(136003)(6512007)(5660300002)(76116006)(91956017)(6506007)(8936002)(316002)(8676002)(110136005)(2616005)(71200400001)(6486002)(36756003)(64756008)(86362001)(83380400001)(26005)(186003)(66446008)(478600001)(2906002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VEF0WmFYWWdvL1BXVVFydkRCSWgwcGNnQllCMkNRN2c2YkVsbkZXSVJBdlR0?=
 =?utf-8?B?dmhPdHBwRU16K3draG9LRWsvWmpPd0pBRzN3R0w0VExWT1I3Q2I1NERmeHU4?=
 =?utf-8?B?S2pnMVRJREJuL2NVWjh0V2ZQZlB2RzBFc2xpUVhJZGxYT1Q1dWdVd09lY3RH?=
 =?utf-8?B?NzhvQmQ3OU5Da2c5SzZFekE0VW54ZENNMHhwK2FnTC9IOWdpYWpoNXVhZVFZ?=
 =?utf-8?B?K0hjMTVNOHpoVnpRcFIvbE1LK01XYUFGWkIzd0F5eVhhNHBXdWVOOTRveVNn?=
 =?utf-8?B?ejVVWFFpT0pjczM0eG11YXJIeEl4UTFhdTVZYVVlQjFGUFpRWW1mVENQaDAw?=
 =?utf-8?B?ekNzd0VucnVIOXZ2bUVMbFBFQlJvSUV1amxxNUlSME5GOFNXRXFBeFE0ME0x?=
 =?utf-8?B?VmdXbVVqQWhpRVIvSkxyQlBDMnBYeFQ4WVVuMGllRGYzdHRMa1owdUtPZTlO?=
 =?utf-8?B?MzFuZXZSZFR3YnNVd3FyWllXYytpdkFCOEkvQ3NUeUFSM09nSTVScGFmeTVL?=
 =?utf-8?B?S0E5dXBCbVFNOHova1pkN3VMcW5YSEpIcUduc09oSklKenBRMVp3ZXZTbEFx?=
 =?utf-8?B?YVQ3eWxsRjFPeDRlZ0FnUmRwWnl5b1lnRndjcWoxdHNyYTFzVTFXZDV5NE5Q?=
 =?utf-8?B?QXRDK1RYZGNwcGpWZldjSFpCOHRjUThCOFQxckFvMGhCTkZ0NEp0OEQ3L2h1?=
 =?utf-8?B?cDgrTmIwR1NjYjhMSFUvdWZYUFh2WWN3ZXQ2TG41aFVRZXJIK0FnTmtFWG0v?=
 =?utf-8?B?bldRekRoeEFZSFNZOHZ1dytpYVduclhlT0N4WEFHbE1aN0N6NW5wem5zSnlB?=
 =?utf-8?B?enBqYVkwOGNxY2dDWXg3OW5sbGkwaTQ1cmZNRENhYWtwckljKzVJbGIxT2Np?=
 =?utf-8?B?a2hVZDg2OE00Z1l5UTdiclR1K1NBeExLT2s3MTEyT0t6WHJPL1lobjJOUjFB?=
 =?utf-8?B?b3RIc2pNOXdXTjhwVGpvaGJINlRwY2FWVm1RRUt3aWpuUkJPN2lGSVdraFNl?=
 =?utf-8?B?UXkyNE9sT1lnMnBxRnE0SzVuMjZIUHNUaUY2RTVidDdLaERvcHVERVIzNEZQ?=
 =?utf-8?B?NWZHSU9wYW1YanlPQ3gxY24zUGUwRE1sYnZvb0hmT0xvOGlaWEdiRy9NU1lY?=
 =?utf-8?B?eXp1a0RHa1BWSGhTMkpqek1SQ2orNXl6TjUrbk8xUXB1bVA4UEdmdnAxOUxV?=
 =?utf-8?B?SHV6WWhjQXZ3aU9zTUVQVXcvZ3BOaS80NzY4REZSNGMvejZ3VHd3TDNOeTRr?=
 =?utf-8?B?RXd0cmU5bFNMc3l3b2x6ajdxczBuSHBzekVLaFBudzJUR3pRdXYrcDI4d21q?=
 =?utf-8?Q?sfaAR+Bt72I0Ktm8WWXzUAi8DMA8vxMBLG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCE1DC67ADE3464498FD9453DE3B1732@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68035ff-a07e-46f2-859a-08d8bbd39ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 17:08:06.8472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JWNW6iR8wPcXLZAmkzhQaSWLUp3YAYLHFq9T34QQo5tOsj2mpsMIcU10avW4TZnbx2/pkdj1I5K73/FOZVeHmgZNyqMHYezsHq+NfrZUuEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2943
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgT3ZpZGl1LA0KDQpUaGFua3MgZm9yIHNwb3R0aW5nIGFuZCBmaXhpbmcgdGhpcy4NCg0KT24g
RnJpLCAyMDIxLTAxLTE1IGF0IDIyOjQ2ICswMjAwLCBPdmlkaXUgUGFuYWl0IHdyb3RlOg0KPiBz
cmNfc2l6ZSBhbmQgYWFkX3NpemUgYXJlIGRlZmluZWQgYXMgdTMyLCBzbyB0aGUgZm9sbG93aW5n
DQo+IGV4cHJlc3Npb25zIGFyZQ0KPiBjdXJyZW50bHkgYmVpbmcgZXZhbHVhdGVkIHVzaW5nIDMy
LWJpdCBhcml0aG1ldGljOg0KPiANCj4gYml0X2xlbiA9IHNyY19zaXplICogODsNCj4gLi4uDQo+
IGJpdF9sZW4gPSBhYWRfc2l6ZSAqIDg7DQo+IA0KPiBIb3dldmVyLCBiaXRfbGVuIGlzIHVzZWQg
YWZ0ZXJ3YXJkcyBpbiBhIGNvbnRleHQgdGhhdCBleHBlY3RzIGEgdmFsaWQNCj4gNjQtYml0IHZh
bHVlICh0aGUgbG93ZXIgYW5kIHVwcGVyIDMyLWJpdCB3b3JkcyBvZiBiaXRfbGVuIGFyZQ0KPiBl
eHRyYWN0ZWQNCj4gYW5kIHdyaXR0ZW4gdG8gaHcpLg0KPiANCj4gSW4gb3JkZXIgdG8gbWFrZSBz
dXJlIHRoZSBjb3JyZWN0IGJpdCBsZW5ndGggaXMgZ2VuZXJhdGVkIGFuZCB0aGUgMzItDQo+IGJp
dA0KPiBtdWx0aXBsaWNhdGlvbiBkb2VzIG5vdCB3cmFwIGFyb3VuZCwgY2FzdCBzcmNfc2l6ZSBh
bmQgYWFkX3NpemUgdG8NCj4gdTY0Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogT3ZpZGl1IFBhbmFp
dCA8b3ZpZGl1LnBhbmFpdEB3aW5kcml2ZXIuY29tPg0KDQpBY2tlZC1ieTogRGFuaWVsZSBBbGVz
c2FuZHJlbGxpIDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAg
ZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtYWVzLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtYWVzLmMNCj4gYi9kcml2ZXJzL2NyeXB0by9rZWVt
YmF5L29jcy1hZXMuYw0KPiBpbmRleCBjYzI4NmFkYjFjNGEuLmI4NWM4OTQ3N2FmYSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtYWVzLmMNCj4gKysrIGIvZHJpdmVy
cy9jcnlwdG8va2VlbWJheS9vY3MtYWVzLmMNCj4gQEAgLTk1OCwxNCArOTU4LDE0IEBAIGludCBv
Y3NfYWVzX2djbV9vcChzdHJ1Y3Qgb2NzX2Flc19kZXYgKmFlc19kZXYsDQo+ICAJb2NzX2Flc193
cml0ZV9sYXN0X2RhdGFfYmxrX2xlbihhZXNfZGV2LCBzcmNfc2l6ZSk7DQo+ICANCj4gIAkvKiBX
cml0ZSBjaXBoZXJ0ZXh0IGJpdCBsZW5ndGggKi8NCj4gLQliaXRfbGVuID0gc3JjX3NpemUgKiA4
Ow0KPiArCWJpdF9sZW4gPSAodTY0KXNyY19zaXplICogODsNCj4gIAl2YWwgPSBiaXRfbGVuICYg
MHhGRkZGRkZGRjsNCj4gIAlpb3dyaXRlMzIodmFsLCBhZXNfZGV2LT5iYXNlX3JlZyArIEFFU19N
VUxUSVBVUlBPU0UyXzBfT0ZGU0VUKTsNCj4gIAl2YWwgPSBiaXRfbGVuID4+IDMyOw0KPiAgCWlv
d3JpdGUzMih2YWwsIGFlc19kZXYtPmJhc2VfcmVnICsgQUVTX01VTFRJUFVSUE9TRTJfMV9PRkZT
RVQpOw0KPiAgDQo+ICAJLyogV3JpdGUgYWFkIGJpdCBsZW5ndGggKi8NCj4gLQliaXRfbGVuID0g
YWFkX3NpemUgKiA4Ow0KPiArCWJpdF9sZW4gPSAodTY0KWFhZF9zaXplICogODsNCj4gIAl2YWwg
PSBiaXRfbGVuICYgMHhGRkZGRkZGRjsNCj4gIAlpb3dyaXRlMzIodmFsLCBhZXNfZGV2LT5iYXNl
X3JlZyArIEFFU19NVUxUSVBVUlBPU0UyXzJfT0ZGU0VUKTsNCj4gIAl2YWwgPSBiaXRfbGVuID4+
IDMyOw0K

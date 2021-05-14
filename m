Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32CAC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18D96127A
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhENUhX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:37:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:18793 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229932AbhENUhW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:37:22 -0400
IronPort-SDR: NQBSKIppLO6WjH3o3URY2kzw93a2Fw2AaPLVxaSmoreYs7BCCX4VXuSi+XxcgMPFzxopVpgj5+
 XVuDlVSKuSjw==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="200282951"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="200282951"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:36:10 -0700
IronPort-SDR: iobjiLG7L2rp2USbPJrw3Tl0KsB1uWPYNgyOFEqNlpPCPWw4/XHyC3KIa5iEb2MI32FBkGKFqG
 +gj3pBdDcXGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="410093842"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 14 May 2021 13:36:08 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 14 May 2021 13:36:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 14 May 2021 13:36:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 14 May 2021 13:36:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgB72Z+k2S+sN6g/zDTkvMMd0w/HkwRj9jEKEPSTTntNZNNPWKLSatBWLue+0FGSbCGKMLKGptYT9T0Z3ZYMZDcvfaznnuPlYnaIFeG8Iqa4+blIYslQAdbqVppPl/i4uu5/ppBaPbg65jA60jj8/gaBo+EPRI5lWSFOs9entTF/LeM4slfxBf3zMDykwWHiMKQRxCQ0QCinPpbmSEG/k7HGjfOWkr9pII88MH87lsCXj1e/vnPyoQREYZ67zArkBTXNvPbUz1OI6mHQL3j42gJDlMq9GXNa/QxAZEI+IIxz7XmDBP1XwJhWmxqq0YrgY44IvaGejyURn18IT5ynrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlkXJqHRkQ0nV0IF5AEKXB0Utn1py+QY1usB/xIXvP0=;
 b=QnhdifPR18uWJRirKSIZaY97R84tg2Htc5DmBgKj03AOK4yUCj/QH271vDZblJy2xLtCkPTuez2vei22ofKsiMqOkABdOlBUc3nKsl+XuNTKVH+Imcl1GpKf4RwzeWYtL9UJ8wL+lFpe2zqWTpT0YfRsl0RPPuCOfen9nY/UZ76rzK7mrmlSTz+SAH6qcbweY7Ai3d/MIbPAPbNnPiT+uAUwLs8blfx3KEIofBz7TawD83Rd6CkoPXfNfHWIhFKk9sh8VBzMLKGTQiUeejnRWjBphEu2Nf6pLKgpA8fmG53NT1TXEs8JHSnjMKHfd8fUJWYArAXX4P+VfpiNYU5hOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlkXJqHRkQ0nV0IF5AEKXB0Utn1py+QY1usB/xIXvP0=;
 b=MwbPuDaf55f82pz+rTQpEckeY2OTBIQ2pWGFPh2cW4MxlsvrvBFdohwmxY91vt+G8AE01hh7Mr3tjXWYGISr8wVkkedLsFdBhfjuutsZDam+bFcKdvGTgbJMoPJQOW52jqtaL/T2LLPiI+r5jGUXnQ6F//xqIeKDOgsJ7bPZhFg=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB5205.namprd11.prod.outlook.com (2603:10b6:510:3d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 20:36:06 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 20:36:06 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Topic: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Index: AQHW09NkgKbOTl1SG0GiKIj8N4sTZA==
Date:   Fri, 14 May 2021 20:36:06 +0000
Message-ID: <89A68071-B57B-49E4-B034-514CA43BC46C@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
 <CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com>
In-Reply-To: <CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89e45c4e-eddc-42af-7b59-08d91717e65d
x-ms-traffictypediagnostic: PH0PR11MB5205:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB520590399AC1CE004EC62A23D8509@PH0PR11MB5205.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: klQgMFK7URUZBRDcmem2bLnXa87avPsH0adecli4MRISMWETqJBNCrZ8dvtjOMpvoyA8/ZPCYn2zEy63HovffGDaE+VhOgfU462FBDu1lj2GHfo7YMs2FqWCb7oY8nXScnzuzyqtw4Ki37FXYyyRRXfgLezBOr3tTsc6vg29QxTrosryTy+RIldrp39LKmKqTODICbiesLD8ZV1FxTtSRcY35Ev8VVizX+PxfUJFDMGSUQ5VDLHEfiyXsDwyKYieXMiulww8tDSbvSWuOaxJCZjrLu+fMhCy4OfQKnhFDgNkOcMmZmRKY5mQLHfPudzBVtrPhQAgqJO1rKygtnqwzkAY7f6NZ3tHGFwbaHZTimdosst26xXHKWAGwqnxFhlurg9DSJUQW89BLpI+ow3YEZfCJDu6uEU5656sjLR3sFeqnz3+/Ds11+qIddVkBc1DETfhKOpTufGJWQcCPWxmFJYE9qumaXfh/mcL/OX5bm5hss0I9xcp7OQNgr2Wlh3FcnYgNWwRPKKpmxCAnQO8Dny+z+641sKwPRlp/eR3NBoeBUIywaVNac5nHzHqF7EwCvPRZ3WkNKrK7oRFw9fsKp+G5a2Lf2tAabH0hIQegfPorr42g+BvHtEKWkZSgb4d5kKSSlWYr+SwFUkX16VhtZHaFpsM72/rtcVgJN6HnwE8bG0avzN240EO3LVyXevBvUD1TukSXLzeCKiVMKQsWqNnoOIqh3boUi+iSQ6N8lq7FPD41oNpVdLje+qa0884n7Yklp1i+aW6NWZQSXHnSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(366004)(136003)(376002)(54906003)(2906002)(76116006)(83380400001)(66556008)(7416002)(66946007)(2616005)(8936002)(71200400001)(966005)(86362001)(8676002)(36756003)(6916009)(6506007)(478600001)(26005)(6486002)(316002)(33656002)(5660300002)(64756008)(66446008)(66476007)(186003)(53546011)(4326008)(38100700002)(122000001)(6512007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YVFrTTVMSU1UMlptQTVLNUZDN0E4c0E0T2pQc2gxeTdTRjRHMnBWTG41ME9J?=
 =?utf-8?B?a0JTKzlOcmtac0QzN1p5dlp5MjFJbEZrS2g4Z3Q0WjhjR3J6RHYwZXRzMUEy?=
 =?utf-8?B?Vy9kZFM2TWNOS1hVbjhjOWREKzZxdFBneXc0dTBvK1YzSlVubTZFSGd5Wkx3?=
 =?utf-8?B?d2N1SE5nWDQ1dmNnUDNIc2lkdEIvR3plN2xTZ3I2K1BZQlMvYWJ5dU1vK21k?=
 =?utf-8?B?RlE1TUJtT1RaTVArSzZ4bDlTekVWSHhKTXNVVmFndzFBYXFndU14SW1JcTA2?=
 =?utf-8?B?VGRTT1F0Wk9DOWtHamd4L21jQi9QSXg1bGJzYW1xOVhrWTRRRnB6Yy9FZlgv?=
 =?utf-8?B?M09HT0l1ZjNsWnM0Y3h5aXc4TWtraENnb0VEZ1FOU0pneDJyVmNNejdtdVFw?=
 =?utf-8?B?RG9YV21wcExObGhSNTdwWTZ2WWhybXZvaURvdWdzUXU0N0tXd2laWElldkVI?=
 =?utf-8?B?WWdwbUNTYlJTbkNQWU91bStIVHhnUW5jM09DdnU0dHUwR2VncnVWanRWbVB2?=
 =?utf-8?B?KzJEbTNENEJwZnkyRTMramFjVmVFSTFqY1czSUdWQTR0R3F6ckF3UHU5QmFX?=
 =?utf-8?B?OFhpbTM0bWl3Q0ZnQkpsd0J6WVRtbko5L3V1NElGayt6MGo2c0g1ZkU0M1dz?=
 =?utf-8?B?OWo2SWR3OWViRlBBSTcyVWZwZjJWSGZEYzVkTGxITXR2UDBXcWUvVGF3d2ND?=
 =?utf-8?B?YVJJdVNoSVNsWWowVGtoNFJMcmV5ZElmdmdSaS9xS2Nlc0JxLytKYjBrYkIz?=
 =?utf-8?B?eG9Za2hQSlozUlg3WHB2dzgxa05VYVdBRXBIWEttOVB4d1BCdUxDci8wMXNI?=
 =?utf-8?B?cWI4R2YvbjVTdGVYOXF5ZHF3ZzVQZlgwc0pSem9wT2tnTjA4Q1o3TytCS2w3?=
 =?utf-8?B?SyszcEtJcG5tM3k0YUt6dGJDazlBMit4NmtzV1MrMm80UDl0R3dwTzUyL0Nk?=
 =?utf-8?B?WkdNS295bUpkajd0bTVKbWxocVdhSzNmTEJPSXdOWXAyR3JodEYvaE5ndTVv?=
 =?utf-8?B?R1FmVGRJSElTMXU0bk5NbGxXNFFNb0JJSHFMTzFUY3pIejdNMUUxM2VvcUFw?=
 =?utf-8?B?eGc2QlZMWnVHMk9lOC9TSXYvUnlCT25xNDFYNS9qTUxTZEhITUZGRFJUcS9a?=
 =?utf-8?B?bDFHR05aTnV2SWVBc3dkYTJQZHp5WWMwcjRvWVAzWWxwai9Xay9pUlJvSWZq?=
 =?utf-8?B?M3g1Y3FBUXNTVHc3d2hhcjB4VEdSSWxzZ2I3endPVXJRck9KaWdCZG1uTmtr?=
 =?utf-8?B?NXBkNmxTSGxXNHBrRC9rc1VKUHNJUEJ4ZFlHUnpkejEwYVByMmRQem5XdkRW?=
 =?utf-8?B?Z002aURrbUJJbjRQU0I0VUI3OGJZZnVBNjdOZ016MytHd0s2Vjl5cGdibGtO?=
 =?utf-8?B?TTdIbkV1NFRPM2s1aGs0ZzJmckNsaXpvcG1ZT2FWQ0tLRGpJN09FWm9FLys0?=
 =?utf-8?B?T1dwU2dHSkdMa0ZJRk5tZlNnaUxsSlRjeHFqdmZQZkdUVUpnOTNNbUtqTkVX?=
 =?utf-8?B?bHMzc09NUmR1eWpwRWh6dTR2RHNsYnhFZEFxQnViWld2VGhmYnAyUjlFbDJT?=
 =?utf-8?B?NXdDcUJRZzhKNTVaaisrdGhJaUdEOGFwTkdIS2QvS2dOUDVWMFBFcjRLcWxv?=
 =?utf-8?B?dmFmcTI2MDBOTXBWV1BZVUJoOXJmOGdtaE5tMTlYRkE2bVlGY1hpL0l3UnEw?=
 =?utf-8?B?dDZYSXlkTjNoWENieFQ0VEFlQU9rcHRVb3dBZFFVVU5GSGNaV1BlYWwrQlow?=
 =?utf-8?Q?lbi8Dz2LwyZx7rDkDJUiTUk9Osi9uKQO4tqC+Xp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91D22C2053E4BD4DB7AF98FBDDC70D70@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e45c4e-eddc-42af-7b59-08d91717e65d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 20:36:06.4794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7OmABgx5t3952HI+Hc+MOOluamaRbsr53IbPEoxFrpZWLAwa9Nye6moRPNgZDgCIvK+QRfTYsX9IL7/CDh+pfTkjRwc5V9MevbQe91UkEgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5205
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gRGVjIDE3LCAyMDIwLCBhdCAwMjoxNiwgQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9y
Zz4gd3JvdGU6DQo+IA0KPiBXZSB3aWxsIG5lZWQgdG8gcmVmYWN0b3IgdGhpcyAtIGNsb25pbmcg
dGhlIGVudGlyZSBkcml2ZXIgYW5kIGp1c3QNCj4gcmVwbGFjaW5nIGFlcy1uaSB3aXRoIGFlcy1r
bCBpcyBhIG1haW50ZW5hbmNlIG5pZ2h0bWFyZS4NCj4gDQo+IFBsZWFzZSByZWZlciB0byB0aGUg
YXJtNjQgdHJlZSBmb3IgYW4gZXhhbXBsZSBob3cgdG8gY29tYmluZSBjaGFpbmluZw0KPiBtb2Rl
IHJvdXRpbmVzIGltcGxlbWVudGVkIGluIGFzc2VtYmxlciB3aXRoIGRpZmZlcmVudCBpbXBsZW1l
bnRhdGlvbnMNCj4gb2YgdGhlIGNvcmUgQUVTIHRyYW5zZm9ybXMgKGFlcy1tb2Rlcy5TIGlzIGNv
bWJpbmVkIHdpdGggZWl0aGVyDQo+IGFlcy1jZS5TIG9yIGFlcy1uZW9uLlMgdG8gcHJvZHVjZSB0
d28gZGlmZmVyZW50IGRyaXZlcnMpDQoNCkkganVzdCBwb3N0IHYyIFsxXS4gUEFUQ0g5IFsyXSBy
ZWZhY3RvcnMgc29tZSBnbHVlIGNvZGUgb3V0IG9mIEFFUy1OSSB0bw0KcHJlcGFyZSBBRVMtS0wu
DQoNClsgUGFzdCBhIGZldyBtb250aHMgd2VyZSBub3QgZnVsbHkgc3BlbnQgb24gdGhpcyBidXQg
aXQgdG9vayBhIHdoaWxlIHRvDQogIGFkZHJlc3MgY29tbWVudHMgYW5kIHRvIGRlYnVnIHRlc3Qg
Y2FzZXMuIF0NCg0KPiAuLi4NCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9jcnlwdG8vYWVza2wt
aW50ZWxfZ2x1ZS5jIGIvYXJjaC94ODYvY3J5cHRvL2Flc2tsLWludGVsX2dsdWUuYw0KPj4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwMDAwMC4uOWUzZjkwMGFkNGFmDQo+
PiAtLS0gL2Rldi9udWxsDQo+PiArKysgYi9hcmNoL3g4Ni9jcnlwdG8vYWVza2wtaW50ZWxfZ2x1
ZS5jDQo+PiBAQCAtMCwwICsxLDY5NyBAQA0KPiAuLi4NCj4+ICtzdGF0aWMgdm9pZCBhZXNrbF9l
bmNyeXB0KHN0cnVjdCBjcnlwdG9fdGZtICp0Zm0sIHU4ICpkc3QsIGNvbnN0IHU4ICpzcmMpDQo+
PiArew0KPj4gKyAgICAgICBzdHJ1Y3QgY3J5cHRvX2Flc19jdHggKmN0eCA9IGFlc19jdHgoY3J5
cHRvX3RmbV9jdHgodGZtKSk7DQo+PiArICAgICAgIGludCBlcnIgPSAwOw0KPj4gKw0KPj4gKyAg
ICAgICBpZiAoIWNyeXB0b19zaW1kX3VzYWJsZSgpKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVy
bjsNCj4+ICsNCj4gDQo+IEl0IGlzIGNsZWFyIHRoYXQgQUVTLUtMIGNhbm5vdCBiZSBoYW5kbGVk
IGJ5IGEgZmFsbGJhY2sgYWxnb3JpdGhtLA0KPiBnaXZlbiB0aGF0IHRoZSBrZXkgaXMgbm8gbG9u
Z2VyIGF2YWlsYWJsZS4gQnV0IHRoYXQgZG9lc24ndCBtZWFuIHRoYXQNCj4geW91IGNhbiBqdXN0
IGdpdmUgdXAgbGlrZSB0aGlzLg0KPiANCj4gVGhpcyBiYXNpY2FsbHkgaW1wbGllcyB0aGF0IHdl
IGNhbm5vdCBleHBvc2UgdGhlIGNpcGhlciBpbnRlcmZhY2UgYXQNCj4gYWxsLCBhbmQgc28gQUVT
LUtMIGNhbiBvbmx5IGJlIHVzZWQgYnkgY2FsbGVycyB0aGF0IHVzZSB0aGUNCj4gYXN5bmNocm9u
b3VzIGludGVyZmFjZSwgd2hpY2ggcnVsZXMgb3V0IDgwMi4xMSwgcy93IGtUTFMsIG1hY3NlYyBh
bmQNCj4ga2VyYmVyb3MuDQoNCkkgbWFkZSBub3QgdG8gZXhwb3NlIHRoZSBzeW5jaHJvbm91cyBp
bnRlcmZhY2UsIGluIHYyLg0KDQo+IFRoaXMgdGllcyBpbiB0byBhIHJlbGF0ZWQgZGlzY3Vzc2lv
biB0aGF0IGlzIGdvaW5nIG9uIGFib3V0IHdoZW4gdG8NCj4gYWxsb3cga2VybmVsIG1vZGUgU0lN
RC4gSSBhbSBjdXJyZW50bHkgaW52ZXN0aWdhdGluZyB3aGV0aGVyIHdlIGNhbg0KPiBjaGFuZ2Ug
dGhlIHJ1bGVzIGEgYml0IHNvIHRoYXQgY3J5cHRvX3NpbWRfdXNhYmxlKCkgaXMgZ3VhcmFudGVl
ZCB0bw0KPiBiZSB0cnVlLg0KDQpJIHNhdyB5b3VyIHNlcmllcyBbM10uIFllcywgSeKAmW0gdmVy
eSBpbnRlcmVzdGVkIGluIGl0Lg0KDQo+PiArc3RhdGljIGludCBlY2JfZW5jcnlwdChzdHJ1Y3Qg
c2tjaXBoZXJfcmVxdWVzdCAqcmVxKQ0KPj4gK3sNCj4+ICsgICAgICAgc3RydWN0IGNyeXB0b19z
a2NpcGhlciAqdGZtOw0KPj4gKyAgICAgICBzdHJ1Y3QgY3J5cHRvX2Flc19jdHggKmN0eDsNCj4+
ICsgICAgICAgc3RydWN0IHNrY2lwaGVyX3dhbGsgd2FsazsNCj4+ICsgICAgICAgdW5zaWduZWQg
aW50IG5ieXRlczsNCj4+ICsgICAgICAgaW50IGVycjsNCj4+ICsNCj4+ICsgICAgICAgdGZtID0g
Y3J5cHRvX3NrY2lwaGVyX3JlcXRmbShyZXEpOw0KPj4gKyAgICAgICBjdHggPSBhZXNfY3R4KGNy
eXB0b19za2NpcGhlcl9jdHgodGZtKSk7DQo+PiArDQo+PiArICAgICAgIGVyciA9IHNrY2lwaGVy
X3dhbGtfdmlydCgmd2FsaywgcmVxLCB0cnVlKTsNCj4+ICsgICAgICAgaWYgKGVycikNCj4+ICsg
ICAgICAgICAgICAgICByZXR1cm4gZXJyOw0KPj4gKw0KPj4gKyAgICAgICB3aGlsZSAoKG5ieXRl
cyA9IHdhbGsubmJ5dGVzKSkgew0KPj4gKyAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBsZW4g
PSBuYnl0ZXMgJiBBRVNfQkxPQ0tfTUFTSzsNCj4+ICsgICAgICAgICAgICAgICBjb25zdCB1OCAq
c3JjID0gd2Fsay5zcmMudmlydC5hZGRyOw0KPj4gKyAgICAgICAgICAgICAgIHU4ICpkc3QgPSB3
YWxrLmRzdC52aXJ0LmFkZHI7DQo+PiArDQo+PiArICAgICAgICAgICAgICAga2VybmVsX2ZwdV9i
ZWdpbigpOw0KPj4gKyAgICAgICAgICAgICAgIGlmICh1bmxpa2VseShjdHgtPmtleV9sZW5ndGgg
PT0gQUVTX0tFWVNJWkVfMTkyKSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGFlc25pX2Vj
Yl9lbmMoY3R4LCBkc3QsIHNyYywgbGVuKTsNCj4gDQo+IENvdWxkIHdlIHBsZWFzZSB1c2UgYSBw
cm9wZXIgZmFsbGJhY2sgaGVyZSwgYW5kIHJlbGF5IHRoZSBlbnRpcmUgcmVxdWVzdD8NCg0KSSBt
YWRlIGEgY2hhbmdlIGxpa2UgdGhpcyBpbiB2MjoNCg0KK3N0YXRpYyBpbnQgZWNiX2VuY3J5cHQo
c3RydWN0IHNrY2lwaGVyX3JlcXVlc3QgKnJlcSkNCit7DQorCXN0cnVjdCBjcnlwdG9fc2tjaXBo
ZXIgKnRmbSA9IGNyeXB0b19za2NpcGhlcl9yZXF0Zm0ocmVxKTsNCisNCisJaWYgKGxpa2VseShr
ZXlsZW5ndGgoY3J5cHRvX3NrY2lwaGVyX2N0eCh0Zm0pKSAhPSBBRVNfS0VZU0laRV8xOTIpKQ0K
KwkJcmV0dXJuIGVjYl9jcnlwdF9jb21tb24ocmVxLCBhZXNrbF9lY2JfZW5jKTsNCisJZWxzZQ0K
KwkJcmV0dXJuIGVjYl9jcnlwdF9jb21tb24ocmVxLCBhZXNuaV9lY2JfZW5jKTsNCit9DQoNCj4+
ICsgICAgICAgICAgICAgICBlbHNlDQo+PiArICAgICAgICAgICAgICAgICAgICAgICBlcnIgPSBf
X2Flc2tsX2VjYl9lbmMoY3R4LCBkc3QsIHNyYywgbGVuKTsNCj4+ICsgICAgICAgICAgICAgICBr
ZXJuZWxfZnB1X2VuZCgpOw0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgIGlmIChlcnIpIHsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgIHNrY2lwaGVyX3dhbGtfZG9uZSgmd2FsaywgbmJ5dGVz
ICYgKEFFU19CTE9DS19TSVpFIC0gMSkpOw0KPiANCj4gVGhpcyBkb2Vzbid0IGxvb2sgcmlnaHQu
IFRoZSBza2NpcGhlciBzY2F0dGVybGlzdCB3YWxrZXIgbWF5IGhhdmUgYQ0KPiBsaXZlIGttYXAo
KSBoZXJlIHNvIHlvdSBjYW4ndCBqdXN0IHJldHVybi4NCg0KSeKAmXZlIGFkZGVkIGEgcHJlcGFy
YXRvcnkgcGF0Y2ggWzRdIHRvIGRlYWwgd2l0aCBjYXNlcyBsaWtlIHRoaXMuDQoNClRoYW5rcywN
CkNoYW5nDQoNClsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjEwNTE0MjAxNTA4
LjI3OTY3LTEtY2hhbmcuc2Vvay5iYWVAaW50ZWwuY29tLw0KWzJdIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xrbWwvMjAyMTA1MTQyMDE1MDguMjc5NjctMTAtY2hhbmcuc2Vvay5iYWVAaW50ZWwu
Y29tLw0KWzNdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDEyMTgxNzAxMDYuMjMy
ODAtMS1hcmRiQGtlcm5lbC5vcmcvDQpbNF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8y
MDIxMDUxNDIwMTUwOC4yNzk2Ny05LWNoYW5nLnNlb2suYmFlQGludGVsLmNvbS8=

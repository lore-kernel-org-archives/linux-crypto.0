Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CC3C433E6
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 19:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 053AC23139
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Dec 2020 19:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLVTEO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Dec 2020 14:04:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:64950 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLVTEO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Dec 2020 14:04:14 -0500
IronPort-SDR: IKbzMqLQYF9zKos+CdsDrDR4m0en9B0KRQo0Rt5KmbMfQ1lcqzgvmthRvQUHUD9dDXmAmPTcy+
 4yuAWe8raicA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="162967046"
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="162967046"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 11:03:21 -0800
IronPort-SDR: V2XJcDi3YlopeEOgr99VPi9iTFewKHSKxMJTXgpX5Ud5gCJxa/9S2H4flegvepCv6f+jWMYd/D
 2CVEjt/cHUSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="344430856"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 22 Dec 2020 11:03:20 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Dec 2020 11:03:20 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Dec 2020 11:03:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Dec 2020 11:03:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 22 Dec 2020 11:03:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfWpB4DNZBNQOPUWrK+0zpp1C161ySzqGBbNjo9Bmjl82x1uedg12lS/9PkWqcbDNhQkECSvzy/rZBK1ScywhQtJWnpwSecuBHcn/XrEQSIZhaNzreqwgcHoxZeA54BoyTqMS5a3sWrKZXhijQX6vWFrzTYTIaM+zdMP2XTXAnrHUnmyqPhMsx6owalsVqfA43DmqlUF9U6PnAH0pnIxVzSxOzktVZrDdGQc0Ni5PC8XdE2fmCpVMYjd6vVzEBynbc91DV5a7MHQ+60FM7F9++q8yBpy1TDw+2hulwzPLfmmcWPrm6DCMWjB1bO251mbRKHtVmg0xtXjH9ZblWxByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrdoCIn++af+88/NkNFDBlHE4N9wH6VCYrWivBVumIw=;
 b=DQGWoB9aTjCquBOPLmuFZBcVJGU3+/BuCe77/vamnoic19AUFzrngJeVkPqMqWWNjMjHriWsTo9ObURedXs55rAV7NgSD6p1aXgHkLBSQX29lXCLy/kZmo0KmCW6Hpj45jmD+7KVNtVO57Koi8HAW6z5PUX0zmBjTdtwcCSY5zV8QXJaE1BZLSxDNNpGIbdU8nc2Z0eGVB9Orxn4CIy9FlEeyO5Xgw/Jxf8p2y3hwsoEnR58Ffro3ICLgIKY9hswhRnw+bBi35TVQGFxayonqG0S3OWb7AUbwkW8QaDrHBpFrXXT1m1SHhlWrdY8tJfC0dQXUkBLRxrV0hpKAOCnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrdoCIn++af+88/NkNFDBlHE4N9wH6VCYrWivBVumIw=;
 b=Y5EGMOMQ9ZNtUIQFVurJDgtoV5Z/9Vacz/RNPQAqQC12ZgYgB8GmSsI0UwYpY+9UN/RAtYprw6LSzpPSg4v6mp8NdBCPZq9bqANmfnT8g0qrHZ52HwKp0HJCFISAq2s9+K7vayOlqHzJXvB9//DSsLFoXpHUSa6jp+j827XTj6Q=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 22 Dec
 2020 19:03:15 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::819:e14a:af80:d33]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::819:e14a:af80:d33%6]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 19:03:15 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/8] x86: Support Intel Key Locker
Thread-Topic: [RFC PATCH 0/8] x86: Support Intel Key Locker
Thread-Index: AQHW09NdTvKYqu53kUecoNyqJY7uyqn+ymaAgAS4IwA=
Date:   Tue, 22 Dec 2020 19:03:14 +0000
Message-ID: <FED814E6-425E-405D-9907-609C4B51D739@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <CALCETrW+3xW8TfLp84VHFB4K7c3m+jLu+fmku6EOSe+QGJAJxQ@mail.gmail.com>
In-Reply-To: <CALCETrW+3xW8TfLp84VHFB4K7c3m+jLu+fmku6EOSe+QGJAJxQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [112.148.21.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 505b0450-065d-4a5c-53ec-08d8a6ac3c5f
x-ms-traffictypediagnostic: PH0PR11MB4821:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4821C4D1CB31C0270B13903ED8DF0@PH0PR11MB4821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RwFy8zxITGc6m7lwERNSSfz5EHSEAOG5jjDQn6eRG97//6IHJZgPbPsMSf1iaKAdAyUMNgjODmZ+Ub5I1urPrcEhmzOZpqOBvYyOpQyjjfZ6V1vhfrlR49v/gvUFv1CG/SrmTUpIps6SAqc2RnneTZMGxwT743D6d1BUPYA6MRTvzfi12Ba0hzQS3oakbsLHLJSuIxoeGensDSEmohmJ3JFYStMck4HBFx5MZpstzVGMrgo49BnLBY6/pmiVgNNDMcx8xevliy6dMeZZ/3R5EURkI+P80XEtjA+HsQpjvLM/XHgcqVw9mtH8NHHC//jvCjwBO4vh/+f0oKip9cAfEOX0YSV9zV/ERiFWKFbDBPfaF3cFu/sJTX/2ZvXUCDcb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(71200400001)(6486002)(53546011)(6512007)(6506007)(186003)(7416002)(76116006)(33656002)(5660300002)(4326008)(86362001)(66556008)(26005)(66476007)(316002)(64756008)(66946007)(66446008)(2906002)(83380400001)(54906003)(2616005)(478600001)(8676002)(8936002)(36756003)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dDIrNUx3bDhlTGludmRuT29FdTR3N3lQS3VpZnVsV1NmZ0dSWWxXdUtEc3lv?=
 =?utf-8?B?SHhNNFpnc091akxUVndhRlNvdExNS20ydDZvOE1qMDhMaW40QTlvamxkZlFv?=
 =?utf-8?B?aW4xc0MxQU5xSjJQMTNRem1IMEJCZEozS2EwWkFRbmNNNGdBb2Q4eG1iR0FR?=
 =?utf-8?B?TEJITEJLd0RDNUtsSlpDTEwrMXltRnBaOWY1dDlYT3ZxNkE1U3d2aUVuVUJ2?=
 =?utf-8?B?UVFFWUJFdlJORHlQUEIzdmwzeC9ZK3lxeVFlT0t3RVY3V3hIOFB2T0ZqUTM2?=
 =?utf-8?B?WTRZVVRlVEtpK1drRTlUQ0VZTlZ3Y0Zld085ci9uUmFsRzJwMDlrUElJTHU3?=
 =?utf-8?B?azJPcjJpZDZKTFh6dUNucTI1ZUx4M01ReXBITmNmSWs1QTBTU0VjaGdyY2Vw?=
 =?utf-8?B?TlZ6bGkyQXJVOVpaMlh0WDlYMUwydlQ0clJMUVA2US9idGx5dDBLQmFRZTll?=
 =?utf-8?B?TnVJaE1CV2RQcU5LVG8zLys2YVZ5TytuQ1lYQ25vLzdFdnQ0ZHVDU3N6ZmFG?=
 =?utf-8?B?MGlBeSs0MzhJZ2czalVsQVcxSHE1N1J6TmRwY0h0K1dSM3JRR09UWXpEL09v?=
 =?utf-8?B?RGtPTjNnYnhpUC9UcjJ4TFBwU25nbEYra2E3N3Y1aUhyZ0JtOVY2RjhzTDRT?=
 =?utf-8?B?R3lkcjg4eG1CaG80Rkk1RjJlZUVNbkJ3bFg1WS9HbmU5enFZSDgyTUhYalVW?=
 =?utf-8?B?U1lDSEsxMXFQendIeVVpSmUxR2x5bU9qVFNscEM0VnNNaXlnSXlKZDlQblpK?=
 =?utf-8?B?TEc5cHZ5NS9LOHpUaGN0OE5xN21KK3c2dkhNWXF3T2tTL0NVYnk1eGw1QzBJ?=
 =?utf-8?B?ODdSYzYyT3BEdkJWTmtzUUNhaWZSUlNOY1NMd0h3d09CV05wMitUUE5MVzJs?=
 =?utf-8?B?ZDFVWlZXWWpyMDFvR1YxaEt6TnlqZ3R1bWJaSnZjMkJOM2VDbnZWMEpZWEJV?=
 =?utf-8?B?MGVGVXZCQjkwRXllY0tZUWtuckdVbEtyUUJhRTNzTnorWDA5YzYvaEVmQ2l4?=
 =?utf-8?B?YjlERGFYUm9XbGhIYmRkT3AzZ1czdDlTL09NeUJXWnF0M3Yxc1lacmlEMGRG?=
 =?utf-8?B?VVUzaEEvZENjSllsRFFUeFVjOWhvNXJPeUxxR2h2Qk9QL3g5VjExOERRektO?=
 =?utf-8?B?ZVgwMERDQU4vb0hWZkovVFVmSnRodmU1QXAyUjJLMmtxZEZOanpMWnJsckVk?=
 =?utf-8?B?WGRiODVsTWc1VElTVWRvdWZHMTBOdXJEVWZ5NDNDTkM0aGRoT0pDOFRIV21x?=
 =?utf-8?B?Qnd0RkZzVUVBOFBsVndXVkhJTHV0ajNjZEIvZFl4NGpPOEJ5cXJRUmdXWTdm?=
 =?utf-8?Q?CkKANJX6X20zs3zLF8q8QsU1Sqg6x0n/6k?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C4876055A6F55488E0EAA4A82676BEE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505b0450-065d-4a5c-53ec-08d8a6ac3c5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2020 19:03:14.8280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7OXDdvQRNaHQ3Ft5Jnibiauha3DSkzmQPC07IouuGzej1doy6n+exyrR4KF3b/rr40iEV202T0PXu6RDDDJLcnQSgcH18DGRWjYa0Hvd3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4821
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IE9uIERlYyAyMCwgMjAyMCwgYXQgMDM6NTksIEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJu
ZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIFdlZCwgRGVjIDE2LCAyMDIwIGF0IDk6NDYgQU0gQ2hh
bmcgUy4gQmFlIDxjaGFuZy5zZW9rLmJhZUBpbnRlbC5jb20+IHdyb3RlOg0KPj4gDQo+PiBLZXkg
TG9ja2VyIFsxXVsyXSBpcyBhIG5ldyBzZWN1cml0eSBmZWF0dXJlIGF2YWlsYWJsZSBpbiBuZXcg
SW50ZWwgQ1BVcyB0bw0KPj4gcHJvdGVjdCBkYXRhIGVuY3J5cHRpb24ga2V5cyBmb3IgdGhlIEFk
dmFuY2VkIEVuY3J5cHRpb24gU3RhbmRhcmQNCj4+IGFsZ29yaXRobS4gVGhlIHByb3RlY3Rpb24g
bGltaXRzIHRoZSBhbW91bnQgb2YgdGltZSBhbiBBRVMga2V5IGlzIGV4cG9zZWQNCj4+IGluIG1l
bW9yeSBieSBzZWFsaW5nIGEga2V5IGFuZCByZWZlcmVuY2luZyBpdCB3aXRoIG5ldyBBRVMgaW5z
dHJ1Y3Rpb25zLg0KPiANCj4gSSB0aGluayBzb21lIGZ1bmRhbWVudGFsIGlzc3VlcyBuZWVkIHRv
IGJlIHdvcmtlZCBvdXQgYmVmb3JlIHdlIGNhbg0KPiBlbmFibGUga2V5IGxvY2tlciB1cHN0cmVh
bSBhdCBhbGwuDQo+IA0KPiBGaXJzdCwgaG93IGZhc3QgaXMgTE9BRElXS0VZPyAgRG9lcyBpdCBk
ZXBlbmQgb24gdGhlIG1vZGU/ICBJcyBpdA0KPiBjcmVkaWJsZSB0byBjb250ZXh0IHN3aXRjaCB0
aGUgd3JhcHBpbmcga2V5Pw0KDQpJIHNhdyBpdCB0b29rIDExMC0xMzAgY3ljbGVzIHdpdGhvdXQg
dGhlIGhhcmR3YXJlIHJhbmQuIEJ1dCBhYm91dCAyNUsNCmN5Y2xlcyB3aXRoIGl0Lg0KDQpJdCBp
cyBub3QgZXhlY3V0YWJsZSBpbiB1c2Vyc3BhY2UuDQoNCj4gRmlyc3QsIG9uIGJhcmUgbWV0YWws
IHdlIG5lZWQgdG8gZGVjaWRlIHdoZXRoZXIgdG8gdXNlIGEgd3JhcHBpbmcga2V5DQo+IG9yIGEg
c29mdHdhcmUtcHJvdmlkZWQgd3JhcHBpbmcga2V5LiAgQm90aCBjaG9pY2VzIGhhdmUgcHJvcyBh
bmQgY29ucywNCj4gYW5kIGl0J3Mgbm90IGNsZWFyIHRvIG1lIHdoZXRoZXIgTGludXggc2hvdWxk
IGhhdmUgYSBib290LXRpbWUNCj4gcGFyYW1ldGVyLCBhIHJ1bnRpbWUgY29udHJvbCwgYSBmaXhl
ZCB2YWx1ZSwgb3Igc29tZXRoaW5nIGVsc2UuICANCg0KSXQgaXMgYXNzdW1lZCB0aGF0IGFsbCB0
aGUgQ1BVcyBuZWVkIHRvIGhhdmUgdGhlIHNhbWUga2V5IGxvYWRlZCAoYXQNCmJvb3QtdGltZSku
DQoNCkkgdGhvdWdodCB0aGUgc29mdHdhcmUgd3JhcHBpbmcga2V5IGlzIHNpbXBsZSB0byBiZSBs
b2FkZWQuIA0KDQpXaXRoIGhhcmR3YXJlIHJhbmQsIHRoZSBrZXkgdmFsdWUgaXMgdW5rbm93biB0
byBzb2Z0d2FyZS4gVGhlIGtleSANCm5lZWRzIHRoZSBiYWNrdXAgbWVjaGFuaXNtIHRvIGNvcHkg
aXQgdG8gZXZlcnkgQ1BVLg0KDQo+IElmIHdlIHVzZSBhIHJhbmRvbSBrZXksIHdlIG5lZWQgdG8g
ZmlndXJlIG91dCB3aGF0IHRvIGRvIGFib3V0IFM1IGFuZA0KPiBoaWJlcm5hdGlvbi4gIA0KDQpJ
dCB3YXMgY29uc2lkZXJlZCB0byByZXN0b3JlIHRoZSBrZXkgZnJvbSB0aGUgYmFja3VwIGJlZm9y
ZSANCnJlc3VtaW5nIGFueSBzdXNwZW5kZWQgdGhyZWFkLiBUaGF04oCZcyB0aGUgY2FzZSBmb3Ig
UzMgYW5kIFM0DQooaGliZXJuYXRpb24pIHNsZWVwIHN0YXRlcy4gVGhlIHN5c3RlbSByZXN0YXJ0
cyB3aXRoIFM1Lg0KDQo+IE5vIG1hdHRlciB3aGF0IHdlIGRvLCB3ZSdyZSBnb2luZyB0byBoYXZl
IHNvbWUgaXNzdWVzIHdpdGggQ1JJVS4NCg0KSXQgbG9va3MgbGlrZSB0aGUgY2FzZSBhcyBsb25n
IGFzIHRoZSB3cmFwcGluZyBrZXkgaXMgbm90IGZ1bGx5IA0KcmVzdG9yZWQgYnkgaXQuDQoNCj4g
V2UgYWxzbyBuZWVkIHRvIHVuZGVyc3RhbmQgdGhlIHZpcnR1YWxpemF0aW9uIHNpdHVhdGlvbi4g
IFdoYXQgZG8gd2UNCj4gZXhwZWN0IGh5cGVydmlzb3JzIHRvIGRvIHdpdGggS2V5IExvY2tlcj8g
IFRoZSBvbmx5IG9idmlvdXNseQ0KPiBwZXJmb3JtYW50IHdheSBJIGNhbiBzZWUgZm9yIFZNTXMg
dG8gc3VwcG9ydCBtaWdyYXRpb24gaXMgdG8gdXNlIHRoZQ0KPiBzYW1lIHdyYXBwaW5nIGtleSBm
bGVldHdpZGUuICAoVGhpcyBpcyBhbHNvIHRoZSBvbmx5IHdheSBJIGNhbiBzZWUgZm9yDQo+IFZN
TXMgdG8gbWFuYWdlIHRoZSB3cmFwcGluZyBrZXkgaW4gYSB3YXkgdGhhdCBhIHNpZGUgY2hhbm5l
bCBjYW4ndA0KPiBleHRyYWN0IGl0IGZyb20gaHlwZXJ2aXNvciBtZW1vcnkuKSAgQnV0IFZNTXMg
Y2FuJ3QgZG8gdGhpcyB3aXRob3V0DQo+IHNvbWUgZGVncmVlIG9mIGNvb3BlcmF0aW9uIGZyb20g
dGhlIGd1ZXN0LiAgUGVyaGFwcyB3ZSBzaG91bGQgZGlzYWJsZQ0KPiBLTCBpZiBDUFVJRC5IWVBF
UlZJU09SIGlzIHNldCBmb3Igbm93Pw0KDQpUaGlzIGlzIG9uZSBvZiB0aGUgb3B0aW9ucyB3ZSBj
b25zaWRlcmVkIHRvby4NCg0KPiBJdCdzIGEgc2hhbWUgdGhhdCB0aGUgc3BlYyBzZWVtcyB0byBo
YXZlIHNvbWUgaG9sZXMgaW4gdGhlIGtleQ0KPiBtYW5hZ2VtZW50IG1lY2hhbmlzbXMuICBJdCB3
b3VsZCBiZSB2ZXJ5IG5pY2UgaWYgdGhlcmUgd2FzIGEgd2F5IHRvDQo+IGxvYWQgSVdLZXkgZnJv
bSBhbiBTR1ggZW5jbGF2ZSwgYW5kIGl0IHdvdWxkIGFsc28gYmUgbmljZSBpZiB0aGVyZSB3YXMN
Cj4gYSB3YXkgdG8gbG9hZCBhbiBJV0tleSB0aGF0IGlzIHdyYXBwZWQgYnkgYSBkaWZmZXJlbnQg
a2V5LiAgQWxzbywgZm9yDQo+IG5vbi1yYW5kb20gSVdLZXkgdmFsdWVzLCB0aGVyZSBkb2Vzbid0
IHNlZW0gdG8gYmUgYSB3YXkgZm9yIHNvZnR3YXJlDQo+IChpbiBhbiBlbmNsYXZlIG9yIG90aGVy
d2lzZSkgdG8gY29uZmlybSB0aGF0IGl0J3Mgd3JhcHBpbmcgYW4gQUVTIGtleQ0KPiBhZ2FpbnN0
IGEgcGFydGljdWxhciB3cmFwcGluZyBrZXksIHdoaWNoIHNlZW1zIHRvIHNldmVyZWx5IGxpbWl0
IHRoZQ0KPiBhYmlsaXR5IHRvIHNhZmVseSBwcm92aXNpb24gYSBuZXcgd3JhcHBlZCBrZXkgYXQg
cnVudGltZS4NCg0KVGhlIGN1cnJlbnQgdXNlIG9mIHRoZSB3cmFwcGluZyBrZXkgaXMgb25seSBm
b3IgYW4gQUVTIGtleS4gTWF5YmUgdGhlIA0KZmVhdHVyZSB3aWxsIGJlIGV4dGVuZGVkIGluIHRo
ZSBmdXR1cmUuDQoNClRoYW5rcywNCkNoYW5n

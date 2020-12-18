Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F84C2BBCF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96D5D23A9C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 10:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbgLRKfQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 05:35:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:35862 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgLRKfQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 05:35:16 -0500
IronPort-SDR: snXJVbd2yLZaTuTMY8/9tmJHGB5S11mfhR00bgbnfbIq0fUHxvHyTn5mV0XxxriiCFKIPnvOaY
 5lNCKH+gWgSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9838"; a="172849482"
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="172849482"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 02:34:34 -0800
IronPort-SDR: FJUTLM5Tpuhg/YN2W7d/EJW0WbjU/JpfCgiNLc95icWE/I9HH0TnD53wwdHS6UBSEMu458fc8+
 55JuHgeM15Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,430,1599548400"; 
   d="scan'208";a="453814575"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2020 02:34:34 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Dec 2020 02:34:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Dec 2020 02:34:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 18 Dec 2020 02:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grou7YPHXmq2gtkzL2wzSdSo++4un6yZEeexaMKjZRh96sPY3ltIzjF9hlLnoPTox0qERCzJYa1NmvGZsU1R9G4qdjPGHX8VfXV+7vCB4wb26xOkPaEJCODvfzchX/jkP6tmpDlZ9nP3nco10IOwGMUoPgGI57LgENZa/yNnc07oCuf5n8M16ndZIu9TqcbUzx4kIIYcOksXKw4/F/WZAKHwxLkq8UfBTBROguPjEmdM2sDlsh7gtIMLnM9KwjihanlmkJZEkIwEH8CH1zFnlZciln3VuDuUVDqrKY0khaNhzLEsD9WV7kFLWVsWnZB+6cK7slc1Rg2t8HQlcyIz9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+xV+efbtE6ZNMPf59WBg/apeiFCAuNU9VaYovMzCUQ=;
 b=RTSfBdOY5MxanT2Y11/oQGhfuC1DaOG1sB6qSWPhFyAGKIRDCehou8mtKUphQ4q2Donu41RCz4/XRV/jziEjkpZgFCqtN6CpqPHaZoRZ7fgfUCVhEOylMFZSKez8toP5gdKJcZypGP6HQe3Ba0bs2DT4el1u+6wCS4szNwpu8IbE/gT4baNa/9RW8u1dE63B4mx/ksA/aRxLI8wyMap2eyLF/7MSBMKSvAehfCELDR7ss0AWcleVcBe2JTfwNgq9oUqTuwjZDLCk/VjTBohzgPOg84fT26vtsAmnqXG1swZRxs/Wi3mNKfLBHv+L0iCyYk8WtuhbjMXHMRLvACD1LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+xV+efbtE6ZNMPf59WBg/apeiFCAuNU9VaYovMzCUQ=;
 b=xedOfLG+GCPGKTqE77xJwh4udwweIx8MZ9rcIpHez7bOkYkorPZ7e8mxaxlxEVBP9FK+MZYGygkdOfdOCehyVLpvOQACxrVyr2TdK7k2L7wob3Diar4/0X8JgF2pbKYxROEp3JjLKH8bz/lQ/ueHI0iF/cps3+upZuDoWH3LLjk=
Received: from BY5PR11MB4056.namprd11.prod.outlook.com (2603:10b6:a03:18c::17)
 by BYAPR11MB3702.namprd11.prod.outlook.com (2603:10b6:a03:f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Fri, 18 Dec
 2020 10:34:29 +0000
Received: from BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a]) by BY5PR11MB4056.namprd11.prod.outlook.com
 ([fe80::a556:7843:c77:936a%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 10:34:28 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Sun, Ning" <ning.sun@intel.com>,
        "Dwarakanath, Kumar N" <kumar.n.dwarakanath@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Topic: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
Thread-Index: AQHW09NkgKbOTl1SG0GiKIj8N4sTZKn8pL0AgAAGUwA=
Date:   Fri, 18 Dec 2020 10:34:28 +0000
Message-ID: <61FFFEA5-3DD2-4625-9F3A-B7A589B92D95@intel.com>
References: <20201216174146.10446-1-chang.seok.bae@intel.com>
 <20201216174146.10446-8-chang.seok.bae@intel.com>
 <20201218101148.GF3021@hirez.programming.kicks-ass.net>
In-Reply-To: <20201218101148.GF3021@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [112.148.21.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6f0d020-3841-4019-bb34-08d8a3407fc3
x-ms-traffictypediagnostic: BYAPR11MB3702:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3702A1018EDA7A96103C49D9D8C30@BYAPR11MB3702.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h5VDYNZQyKU/Jo67ivhZrIULXyWlgUFhHx+iSlUCXxafwcn8q481rjvSO5101bfZqX2AeUd+RSRLYpS7KCdj78eOhh5AWmgS+Y8r1lvZW9TIrzWHnoBVkS4IrB6uTIJkHa0KlcA+R2g9euy5qZoIuIUw0KTR9Xatm/e9qztxNQyGuAV2R1NW/ds2qQ5FFCOfOCrFgEF4RU7MfVYmxsRM2n5GZdSnlEekBQg+ChqYoDt3KANTPo9tZxZWFC/XnhEVd+HWPURgn7F5n6wNH2oB9sNMsbKW2Aw/0z2RG7JjAyU/QuY4PDNUe/+1YM0tQGyeh1xiS6M+jiLda0R1wV+6QCYGVI/Cm6vAF2bIustPyRurTARFTt0JXAf86fNrqVkB3P1J088OLfLbkS2bMAHk4wi1NFe2XSFS7KD5yBpiQqroeMAGa8ig7rOk8l6N+QnPUmvEsj8hyAfxFw0OA6WOfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4056.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(7416002)(66446008)(5660300002)(316002)(966005)(53546011)(4744005)(66556008)(6506007)(36756003)(64756008)(478600001)(6512007)(2906002)(26005)(76116006)(71200400001)(186003)(86362001)(4326008)(6486002)(2616005)(54906003)(66946007)(8936002)(66476007)(83380400001)(33656002)(8676002)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WmZBQ29CZ3I1SUt2ZU5qNU8xK2VkaVRrOVFIL3k5M0N0Z3BMb0xIMmdIakg1?=
 =?utf-8?B?Qzl5VHFKK01Md3VwME9abEh5Ui9jNzZwU2d4dEc4WmNuTEFjb3dtOFMrVEEy?=
 =?utf-8?B?OXdkVGxxRXNFamN2ZFUwRitJS2lkcytGNjZhVjVxakZjNE8rcDdRWnFZMm5z?=
 =?utf-8?B?L3FsVnpMRm5xY04yNnRWUWdFTkZNYkNpS2FNK0VJSGR3SXFRZFlvTWN2clBp?=
 =?utf-8?B?N2M4bW1pcTNCU005eDA3QkxMMkdIbVlNYkJFRm5EQXNEYlpFM3R2VUdUaDcv?=
 =?utf-8?B?VlBMSUxyWmZjMk43T0ZYNkl1OGRxVEFpMlF2bmpvcmJjRzVTbEtYRzZ2bXVX?=
 =?utf-8?B?dnNUa0hxaXF5NTJHUXlVWFc0TENTK25pMDMzSDg5U2NYakhwRHlDcklXbDNY?=
 =?utf-8?B?S3ZyOE5YTktGd2dhWE11LytPNkFXZi9YVllSd2Vub29JVUowcUluWTQ3UkIz?=
 =?utf-8?B?L2I1a0ZROUxPMWxOdkhWRVRUSCtkcFR4MmtrNXVza3NJdnR5TW0vTEhHdnFD?=
 =?utf-8?B?WVJ3Z2ludXB5Y3lycS9aZU1jQ05Qd1BVbXBCcEtrWVUzaXE4K3kzbTNpMDNt?=
 =?utf-8?B?YVhDN1ppeWdKSTF2b0ZTTnB6TjhkR2ZZeHlEbTNVQVkvcEtkcmhsSGQzYVVq?=
 =?utf-8?B?ZXRIbEMwYkY0SHpKS05oNkxuSDNzQlViaUR1M05uMm41eC8ydXdxaXJrUmll?=
 =?utf-8?B?NWNMQ09GR3FVZ29WVUNTVDhoL0pmTFRXck01MnA0OUxJWmFYRWRJNDJQak1x?=
 =?utf-8?B?NkZ0S2xVWGh6b05ZdTJ0M0I1SU1hK1VhUHNKTE52QkpZMDEvdkJFOGpEWUpq?=
 =?utf-8?B?OFlwbTZHcEdDLzg3RmFHSjlNRDhjSTZHd0wyTW5acDBjYTlDWW40WlRrRldl?=
 =?utf-8?B?TEd5MzJ0WjFrZWdoblNLUjdkRFZrR2d6VlNteWhsYmh4azlPYzUrdSs1SWZp?=
 =?utf-8?B?djhiSktYNjFrY2tuTTRPQXF2cFh4NThRSDE5Wk9Fa21peGs5c2dZblJGMjdB?=
 =?utf-8?B?dXpJVEJPUDdhcWphU2dhTG5MNFEzT2REdzZBbVRuVmI5bXA3MVRtOXdUTElB?=
 =?utf-8?B?d0NuZjU5MXJFbkFUaFN4d3B2dmx1WXYvWW5zMWdrN0JwZ0FKMW9mVlQ0MUxh?=
 =?utf-8?B?cTB4a25zNUsyeXc2R2IxOTVmL1lib3BsYWNoWDE2cHlxTGxGWm8xYmJRSi82?=
 =?utf-8?B?dkJOcTlkTVhEVUZ6YWtMZmNlK3dXZVJMdGY1RHZnOWtYMXB2bVkySWF1VEhP?=
 =?utf-8?B?ZzVLV3dKSXJaSE9HRlNyNFNxNndNc2tQcnp2US9yM1JrRjNDbUpjVTUrL1BF?=
 =?utf-8?Q?D0zRr0F0xMjFLFGZ5zHYahBXPp1lHbCUTa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6ADF1B81B955FE42B28476F95DEFC848@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4056.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f0d020-3841-4019-bb34-08d8a3407fc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 10:34:28.7664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CjXY0pPSR5l3fuQfVFyshEfUcFjk4gwu4sRU7LuSmxTT9o6uwxElQyqAQuZSPZVZw2y5gXBNpJZyCeVCBwpTOjmZOz8DcoRq3+2PpsMxs1s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3702
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

DQo+IE9uIERlYyAxOCwgMjAyMCwgYXQgMTk6MTEsIFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5m
cmFkZWFkLm9yZz4gd3JvdGU6DQo+IA0KPiAqZ3JvYW4qLCBzbyB3aGF0IGFjdHVhbCB2ZXJzaW9u
IG9mIGJpbnV0aWxzIGlzIG5lZWRlZCBhbmQgd2h5IGlzIHRoaXMNCj4gZHJpdmVyIGltcG9ydGFu
dCBlbm91Z2ggdG8gYnVpbGQgb24gYW5jaWVudCBjcnVkIHRvIHdhcnJhbnQgYWxsIHRoaXMNCj4g
Z3Vuaz8NCg0KVGhlIG5ldyBLZXkgTG9ja2VyIGluc3RydWN0aW9ucyBsb29rIHRvIGJlIGFkZGVk
IGEgZmV3IG1vbnRoIGFnbyBbMV0uDQpCdXQgdGhlIGxhdGVzdCBiaW51dGlscyByZWxlYXNlICgy
LjM1LjEpIGRvZXMgbm90IGluY2x1ZGUgdGhlbSB5ZXQuDQoNCknigJltIG9wZW4gdG8gZHJvcCB0
aGUgbWFjcm9zIGlmIHRoZXJlIGlzIGFueSBiZXR0ZXIgd2F5IHRvIGRlZmluZSB0aGVtDQp3aXRo
b3V0IGJpbnV0aWxzIHN1cHBvcnQuDQoNClRoYW5rcywNCkNoYW5nDQoNClsxXSBodHRwczovL3Nv
dXJjZXdhcmUub3JnL2dpdC8/cD1iaW51dGlscy1nZGIuZ2l0O2E9Y29tbWl0O2g9YzQ2OTRmMTcy
YjUxYTIxNjhiOGNjMTUxMDlhYjFiOTdmYzBiY2I5Yw==

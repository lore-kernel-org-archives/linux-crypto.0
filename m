Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21EEC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 886C1611BF
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240502AbhEQWVz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 18:21:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:18266 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238122AbhEQWVz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 18:21:55 -0400
IronPort-SDR: 04HXcTVbRTKJr1GssGSW+FXcVdztzQq6qiCKEvAy2g5tVSt/v7JZ4AIM0UoV+SLJoVGYByXDhO
 I3aTOpIVaXAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="286109312"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="286109312"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 15:20:38 -0700
IronPort-SDR: X+dsawR6JMV9YeN67HDwUaO6w+myDuKzmgAuaMZskkmDABvwVcUXrVkA2DZScvEjVhdRkPOIeq
 dpxmvNbYbNEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="460495904"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 17 May 2021 15:20:38 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 17 May 2021 15:20:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 17 May 2021 15:20:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 17 May 2021 15:20:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq1YOTC7ytbc7KJgnn9VuuuZUcyA29ryNncqJu2pZqqSa/hFBSHWigWpV995Tamow7gDwsok8omnOIuwIOmhXioRjP3JFzGpQJEP7AvxO/zNlGwyMtxNps6htOE8b4QmXz4CLTKjXjEvWQml/UGghOZQpi4RxL54MnVElQI7PZ2gV3TOPbIFS7WASCcryEYJTcNEbF82DQf4+8a1a70ao7K8ghuc5iJ3IWKQroKp96UutkUzvNRp5jGu6k4HC8Xr1N5ONbMIw/Bll4tV5Lllg/DB2ZsYZ6dFp1/ryOlE+WZPYUWVVvLujddPg5ArRXqxPPaJPOSw1MvqpUDn1yPvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ7FCtwDJFEX6FvBgyM0K+6pKHcUABMAcOypmet6Rms=;
 b=EhK1mNhWNFr2AIPO/SjLh3JUIYnIO0Ucf67h56kxp/eRMfVv771QkPhZ/Eevlgl898VxqLp3TtcfT0JWAEg0xyJLhvO63OpntoCcOQFH2EP8PvK2D1C+SygvfX/W0oVoMjfueaqrQh6Hvm0zNRNfcyxd8PYsd4YABZEJjkbSUz7jllE3S4eE4JVVVe4tYyzQ3GjwQlfJXKpFtG+hR7eRgN7Kq/amcCQFP2x6H87IXhsllGXfc6lgjP3eSsvzk5yeYt0dQT2GqOH5t/73d+IDMKQqhpaebF/1seon7xVO1zgLpaPKkU2SPfH4yQfxbn4+NJvyLXPlo42kKT5pyH8gUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZ7FCtwDJFEX6FvBgyM0K+6pKHcUABMAcOypmet6Rms=;
 b=MJ+znqM2vcqOZLjKqTdPshCQqkLEJnOt1Srh6ro8avRJJDOOj3A/Bzlni8pgG/rIqxZblYhuwof/f9+YZdbSatCaq0TbHLi+/gAktuxWjWV0U7qhzccA5BlRgueyxxy/CwlV7zdgfVQqyP3z/uZs+0Fdhd7EOL0Yl+Lx83iVOkY=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 22:20:35 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 22:20:35 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Thread-Topic: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Thread-Index: AQHXSP6hgf4aXmFhiUuqBU4d/omVPark1qMAgAMqZgCAAAZ6gIAAPC+A
Date:   Mon, 17 May 2021 22:20:35 +0000
Message-ID: <A6C89752-29F5-4B9E-901B-250B60A7A24E@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <9f556d3b-49d3-5b0b-0d92-126294ea082d@kernel.org>
 <C08CCADB-864B-48E0-89E0-4BF6841771E8@intel.com>
 <CAPcyv4hkHoj5Jb6SdXyADuaFnPpW+zen-hZeJw+qisa64srOFQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hkHoj5Jb6SdXyADuaFnPpW+zen-hZeJw+qisa64srOFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e431641-a37b-4e46-a9bd-08d91981fe50
x-ms-traffictypediagnostic: PH0PR11MB4902:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB49020F02BAAD7DAEA7460534D82D9@PH0PR11MB4902.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 19QFZVC7cyosK/wxuDvnEtgfpowKhFbZQHPmGSnk6TQpy2PA3M5kLLYGNZ8JEokFwJRvTIT+Hp4hUkAB7bC60xnxJxPmNJ6HMqt9WF0QStw+2Wa6Bb16tGDADH30OWFm6g/osXhLnJ8uGkIYWnfOOUnAfQn1xRUwaF8RcgfehY/37fJdxPASOkV3X9B5GJQCpE4tODfBjf06h+kOc/W2YXB8RERgQLqv8Es8c9iBZ98vNtPpgFY6Zi8kxSebXLB3aYU/vCkM1Fm36BGCscaNU+FRfX8bm/D1Ojs6WFSp7M0nNNvmO82kpTHVmd0Qn63+z2GRxK64QPeR0CECdtdTwkyeCoDzFF/KGmiyrCK9wylhn0uHekcatAjcjT9XBmr0yfL1W6V3enUunxO/JyQkuL/IEFFtrqe+kOBEiUh+MM4XydTVXh+NKt10cPk7eRHhbSsbGqnjJkPEexKIhyUfCektygIIKi0Ki5hB6OffmAXBYscFG7hH7eWqWT+8ttHlSuXwDjlh2U6KyxVFjHBvR5Lg6mFO52MzUXofuNJgvgud5Ad+Op8JMXkBIpqptybPBdrlNNLI3RyU37gU4EWQc66UCs5MZz9c/Xc6gzJ4roar3s9F6qgSSmF6NY4aawarJO6MQtCBZE961d+W0oq+0kNULDGkKvBxL3VfeeLz5RM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(66446008)(64756008)(37006003)(66946007)(66476007)(4326008)(6636002)(71200400001)(66556008)(316002)(122000001)(6486002)(26005)(478600001)(8676002)(2616005)(6506007)(38100700002)(54906003)(6512007)(86362001)(2906002)(8936002)(186003)(33656002)(53546011)(76116006)(36756003)(5660300002)(6862004)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VlBja2I1NHlwOGFHcnM5Y2loR0VIdmdxcFlXVFhURTlFWGxXZnlJOE1nb25w?=
 =?utf-8?B?TzJPNFIyNkJKdlhaVHI0V3c1Tk56UnVKaXlaTGJadjZiNEpLbUxkRm95K1RB?=
 =?utf-8?B?cmlaNWk4NFZjN3dYYVFKQ2R1OTliMklWZjJsQzY2am0zTUJ6NVJrZHZnTDcr?=
 =?utf-8?B?dTJKVXZsY0oyelIwQkNHVFppdEpEeFZQVVVHbndFaEVaeXNVWFE4V1kwa09L?=
 =?utf-8?B?Mkw0Q2RKZ3EzQks2L2ZLYnNQem82b2pIeEVlTG9CSHlXakZnYkhPeUFDTlRT?=
 =?utf-8?B?V0JnbXlTWjdXWjJ1R2Faa1pOc0ljWFQxRTlIdmlCd2VMeEpTeHRaZzFSSXJj?=
 =?utf-8?B?bW1pZHg3OS9sTGJ0MzRxc2RJd0pBR0IxR2hlcTJWMzcrNk0vdnFJbjZpUkZH?=
 =?utf-8?B?THpZa0dGbk5HUE1CVVNCakU1OHZ3UlQ4L1RlWUVQdU1sb0t1bitGZTJZNFdD?=
 =?utf-8?B?aEhjMExqWDJ2WmRPUThSQzh0NFhNdEs2MytFcldLZXJwaUJLYmR1d2hxTmZT?=
 =?utf-8?B?amVvTWpEbURkT1NpaFFodFNUM0lQNnZ6TXVqbEY5OEYyUHFoSTk1MjVVK2U5?=
 =?utf-8?B?LzlvZVVFc3JuVElmNDBjYmtpTUw1RzNEQWJHbWtlYTJyRUNCK3B5U2w5b1A3?=
 =?utf-8?B?VUFWbTVXU1kyQ0dnVmlyNG4xT2IrcXM5WTNpQUF4OXRSeVF6WmZvVnhjT093?=
 =?utf-8?B?SVY0ckZUdm44TXcreGNVdERBYzZlZjdsUnA2RVovYTNmSER2b2ljaytDZUh5?=
 =?utf-8?B?bUV1TGdJS2JTUXVBNWlWNXNkL0QzMDl2aGxQNkxGZUF0WXZPSk5qVWFXdWV0?=
 =?utf-8?B?WTRaRG9zRjNDazYxbFVkdyt4MFJnZXlYRHJ2VWpzUE02Mm91ZXFLRnVlTHNC?=
 =?utf-8?B?M1lzVnZJYzBOcS9NWGRNMjE2MlI0cTVuUk9VMk5DRlNrS1JXSzl6QnB6NFRZ?=
 =?utf-8?B?RllsQ3RlQXBkZzA2VVM4ekxWZ3ozTUNlUmZXMmNYNnhVQlNOTjY1RFFlNE81?=
 =?utf-8?B?ZVhROTZFdysxdHErV05RL2dpN2dNQ3REckhEOStDdDNrV2ZXR0RUeDA4WXJ3?=
 =?utf-8?B?MWpDWHpiTkZQT0pzcmVIR3d1WW9pdXNFRkgvVjQvZ3dmdFE4SXJnVXFnUWpZ?=
 =?utf-8?B?d3ZQSjZSZEEwbTJET0FPcy9oTXZRbG9OaEZMS3dqREliaWQxY2R1dEMzWmNh?=
 =?utf-8?B?OVkyeFBRQy96RDFkdzUvUjhyK0RNY3lJWkxLVStRTjhCU1E3YUlGTnAxUm0y?=
 =?utf-8?B?SG9TTmErWDR0b01kOTFUR0crTXZlcWw4UHhlWmlTNDBXL2xrMUZXM3V4eEl4?=
 =?utf-8?B?SS9veDFicmJLb2p0Qk5pbnQ0QzN1VHpZb1JZMU9LR2hWYVN4d2tWUVpLU09W?=
 =?utf-8?B?UE5wTzl5SXVqbStRdCtCZFJ0SFgySEt0aHdYVHVPNVJqSTlXOUdRUkFaU3I2?=
 =?utf-8?B?WlE1TTFha1ZiQ2ZoZEZ5NUwrZG9QQWZVT3NVdmlqOE13SEo2U25kYk4yVk9n?=
 =?utf-8?B?SFB1YjJkUGJONDd5NStReGhQcFNHa2tRUHRWTkthSmdkcmEvUktQd3NMZ0tY?=
 =?utf-8?B?a1Fha2J3L3ZjZ2czZ2xWejlMUWZ3MXRob00xeTZnQy9xc0R4OWpxN0FiUndR?=
 =?utf-8?B?aWdYTlM4NnM5azRWUndRZ3Q2Q3ZWZDNEQ0VqU3JsY3ZzaXgvZDFpd25zWEM0?=
 =?utf-8?B?UHlWNlpiTjV2R0ZMQ2c2b1BoYTNDRXdxYkxIL3Q2S0VidzlGTlNMN1VkTHpP?=
 =?utf-8?Q?1SrpbgMNSj4n/7P5F8KFutfdk0HXT8liPBGqG9w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBB17F72F529714AA6CBB47185B96EBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e431641-a37b-4e46-a9bd-08d91981fe50
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 22:20:35.6177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +tRmfA1SDtwZVMjnvAKvTka+Hxem1+ueQEsBsetCXP4FovOlXgZrQEuvfOMjo4rkFcOiVmlIEf5fM6P0UB0yw+ENjBtLTu8aU2JDGp6mb4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gTWF5IDE3LCAyMDIxLCBhdCAxMTo0NSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+IHdyb3RlOg0KPiBPbiBNb24sIE1heSAxNywgMjAyMSBhdCAxMToyMSBBTSBCYWUs
IENoYW5nIFNlb2sNCj4gPGNoYW5nLnNlb2suYmFlQGludGVsLmNvbT4gd3JvdGU6DQo+PiANCj4+
IE9uIE1heSAxNSwgMjAyMSwgYXQgMTE6MDEsIEFuZHkgTHV0b21pcnNraSA8bHV0b0BrZXJuZWwu
b3JnPiB3cm90ZToNCj4+PiANCj4+PiANCj4+PiBJIGNlcnRhaW5seSB1bmRlcnN0YW5kIGhvdyBL
TCBpcyB2YWx1YWJsZSBpbiBhIGNvbnRleHQgd2hlcmUNCj4+PiBhIHZlcmlmaWVkIGJvb3QgcHJv
Y2VzcyBpbnN0YWxscyBzb21lIEtMIGtleXMgdGhhdCBhcmUgbm90IHN1YnNlcXVlbnRseQ0KPj4+
IGFjY2Vzc2libGUgb3V0c2lkZSB0aGUgS0wgSVNBLCBidXQgTGludXggZG9lcyBub3QgcmVhbGx5
IHdvcmsgbGlrZSB0aGlzLg0KPj4gDQo+PiBEbyB5b3UgbWluZCBlbGFib3JhdGluZyBvbiB0aGUg
Y29uY2Vybj8gIEkgdHJ5IHRvIHVuZGVyc3RhbmQgYW55IGlzc3VlIHdpdGgNCj4+IFBBVENIMyBb
MV0sIHNwZWNpZmljYWxseS4NCj4gDQo+IElmIEkgdW5kZXJzdGFuZCBBbmR5J3MgY29uY2VybiBp
dCBpcyB0aGUgb2JzZXJ2YXRpb24gdGhhdCB0aGUgd2Vha2VzdA0KPiBsaW5rIGluIHRoaXMgZmFj
aWxpdHkgaXMgdGhlIGluaXRpYWwga2V5IGxvYWQuIFllcywgS0wgcmVkdWNlcw0KPiBleHBvc3Vy
ZSBhZnRlciB0aGF0IGV2ZW50LCBidXQgdGhlIGtleSBsb2FkaW5nIHByb2Nlc3MgaXMgc3RpbGwN
Cj4gdnVsbmVyYWJsZS4gVGhpcyBxdWVzdGlvbiBpcyBzaW1pbGFyIHRvIHRoZSBjb25jZXJuIGJl
dHdlZW4gdGhlIExpbnV4DQo+ICJlbmNyeXB0ZWQta2V5cyIgYW5kICJ0cnVzdGVkLWtleXMiIGlu
dGVyZmFjZS4gVGhlIHRydXN0ZWQta2V5cw0KPiBpbnRlcmZhY2Ugc3RpbGwgaGFzIGFuIGF0dGFj
ayB3aW5kb3cgd2hlcmUgdGhlIGtleSBpcyB1bndyYXBwZWQgaW4NCj4ga2VybmVsIHNwYWNlIHRv
IGRlY3J5cHQgdGhlIHN1Yi1rZXlzLCBidXQgdGhhdCBleHBvc3VyZSBuZWVkIG5vdCBjcm9zcw0K
PiB0aGUgdXNlci1rZXJuZWwgYm91bmRhcnkgYW5kIGNhbiBiZSB0aW1lLWxpbWl0ZWQgdG8gYSBn
aXZlbiBQQ1Igc3RhdGUuDQo+IFRoZSBlbmNyeXB0ZWQta2V5cyBpbnRlcmZhY2UgbWFpbnRhaW5z
IHRoZSBwcml2YXRlLWtleSBtYXRlcmlhbA0KPiBvdXRzaWRlIHRoZSBrZXJuZWwgd2hlcmUgaXQg
aGFzIGluY3JlYXNlZCBleHBvc3VyZS4gS0wgaXMgZWZmZWN0aXZlbHkNCj4gImVuY3J5cHRlZC1r
ZXlzIiBhbmQgQW5keSBpcyBxdWVzdGlvbmluZyB3aGV0aGVyIHRoaXMgbWFrZXMgS0wgc2ltaWxh
cg0KPiB0byB0aGUgTUtUTUUgdnMgU0dYIC8gVERYIHNpdHVhdGlvbi4NCg0KSSBkb27igJl0IGZ1
bGx5IGdyYXNwIHRoZSBNS1RNRSB2cyBTR1gvVERYIGJhY2tncm91bmQsIGJ1dCBMT0FESVdLRVkg
cHJvdmlkZXMgYQ0KaGFyZHdhcmUgcmFuZG9taXphdGlvbiBvcHRpb24gZm9yIHRoZSBpbml0aWFs
IGxvYWQuICBUaGVuLCB0aGUgaW50ZXJuYWwga2V5IGlzDQp1bmtub3duLiAgTm9uZXRoZWxlc3Ms
IGlmIG9uZSBkb2VzIG5vdCB0cnVzdCB0aGlzIHJhbmRvbWl6YXRpb24gYW5kIGRlY2lkZXMNCm5v
dCB0byB1c2UgaXQsIHRoZW4gcGVyaGFwcyB1bmF2b2lkYWJsZSBpcyB0aGUga2V5IGluIG1lbW9y
eSBzb21ldGltZSBkdXJpbmcNCmJvb3QtdGltZS4NCg0KSSB0aGluayBEYW4ganVzdCBnYXZlIGFu
IGV4YW1wbGUgaGVyZSwgYnV0IEZXSVcsIHRoZXNlIOKAnGVuY3J5cHRlZC1rZXlz4oCdIGFuZA0K
4oCcdHJ1c3RlZC1rZXlz4oCdIGFyZSBmb3IgdGhlIGtlcm5lbCBrZXlyaW5nIHNlcnZpY2UuIEkg
d2lzaCB0byBjbGFyaWZ5IHRoZQ0Ka2V5cmluZyBzZXJ2aWNlIGl0c2VsZiBpcyBub3QgaW50ZW5k
ZWQgdXNhZ2UgaGVyZS4gSW5zdGVhZCwgdGhpcyBzZXJpZXMgaXMNCmludGVuZGVkIHRvIGZvY3Vz
IG9uIHRoZSBrZXJuZWwgQ3J5cHRvIEFQSSwgYXMgdGhpcyB0ZWNobm9sb2d5IHByb3RlY3RzIEFF
Uw0Ka2V5cyBkdXJpbmcgZGF0YSB0cmFuc2Zvcm1hdGlvbiB0aW1lLg0KDQo+Pj4gSSdtIHdvbmRl
cmluZyB3aGF0IHBlb3BsZSB3aWxsIHVzZSBpdCBmb3IuDQo+PiANCj4+IE1lbnRpb25lZCBhYm92
ZS4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhpcyBhbnN3ZXJzIEFuZHkncyBxdWVzdGlvbi4gVGhl
cmUgaXMgYSBkaXN0aW5jdGlvbg0KPiBiZXR3ZWVuIHdoYXQgaXQgY2FuIGJlIHVzZWQgZm9yIGFu
ZCB3aGF0IHBlb3BsZSB3aWxsIGRlcGxveSB3aXRoIGl0IGluDQo+IHByYWN0aWNlIGdpdmVuIHRo
ZSAiZW5jcnlwdGVkLWtleXMiLWxpa2UgZXhwb3N1cmUuIENsYXJpZnkgdGhlIGVuZA0KPiB1c2Vy
IGJlbmVmaXQgdGhhdCBtb3RpdmF0ZXMgdGhlIGtlcm5lbCB0byBjYXJyeSB0aGlzIHN1cHBvcnQu
DQoNClRoZSBlbmQtdXNlciBvZiB0aGlzIHNlcmllcyB3aWxsIGJlbmVmaXQgZnJvbSBrZXkgcHJv
dGVjdGlvbiBhdCBkYXRhDQp0cmFuc2Zvcm1hdGlvbiB0aW1lIGFuZCBhbHNvIGJlIHByb3ZpZGVk
IHdpdGggbWF0Y2hlZCBwZXJmb3JtYW5jZSBhcyBBRVMtTkkNCmRvZXMuDQoNClRoYW5rcywNCkNo
YW5n

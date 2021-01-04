Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DFCC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47B18221E5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 15:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbhADPSR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:18:17 -0500
Received: from mga12.intel.com ([192.55.52.136]:54599 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbhADPSP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 10:18:15 -0500
IronPort-SDR: 8/Hq+/YNIN39Q0vAsLg7heJ5axZwMVparwjExb9Nvw/Ia3URz4BoI+vVTGzLpRfg1DkpFe9Aoe
 krkuHbVwoSRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="156159742"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="156159742"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 07:17:58 -0800
IronPort-SDR: 6Y/f87QN5dIAnoze2VPjL7QXNWeyaVdrn4IBbl3ZROCH39cdJgjUD35Ume0zRduiTVEVwoPmpY
 ABToQNSOAXZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="569385291"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jan 2021 07:17:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 07:17:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 4 Jan 2021 07:17:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 4 Jan 2021 07:17:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8j6oLap9lDXqiZ2zI/pZY9wlT+vPX6CLP5Ma9kZ+vhNcCOnhO0IEbw2e4y/EgGOCJebpNuY+l6lNheay1HRgzMiFBF5wXk7Ugarc2dPcT3u0GGEDdz0RfEEfRhGGl4sybl9TpBC1MgOrrefYaF81Xip+Hu5Ir2F8W5m9sUCitIH+wYXPfvYSRYftArTVlA4tIRJM0NmjteCW16cAcIc74y256N23JJEhGDd8ig04ncMG04S6v/0K4m031S70zIb4Ply/xCCa+fN0MmDZPaE0YXmXu2kX/Xf6K9LJvCMv5ztmw3hSSHrK1KlXg4cUEcz58k6ZONyIw/UFyo2ikewpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q6CUeDpYzv4OkTM7QQYTZW9o9/DxRZUCpkGdOo8dII=;
 b=gwMEyIQVhxpTdZ8I9Nk6tUS4Ps/Ix6s6TNmRtViTQaZq0WGa0lBV8MY5bgKkbfKlaR/qSEOYjHsKDcPmVCMrY+CT2fTcwC0zF1ucAxW8l98vVeWyinyo4pUaeYGheS0gcOLjNzHgn6Y4a8ADQXjMuVZnrprZOXFycCHBuwVHBJtBfJtX/N4nigdMH6tH4CO8MYGObE7Uk+XjzE19VD66mBJmhhAv5DraszBgCU0bYxItKp1e7SNJTesXkvyw1vBd2gkQJWCmlkKoUyYXL4kSi2t1t/IBvh7XyDENK3nTJqkisB7hLi1mYJ8bkDFPuA57kboPToi34Z7Gf3pT6ki5kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q6CUeDpYzv4OkTM7QQYTZW9o9/DxRZUCpkGdOo8dII=;
 b=HhUnPtDu4/ULmdVqLPODcKRoq0giER7mCK4P9xOT2Ux/ZrM94ZtCLpqCzemsw/1+Ej/Xu40J02zrge8kyIWm0D7ndwzpj1koC48uGAtyVeCFNEnbpdK8FhivaLJzSadddB7/6x4Xx4IOVZJKB5kG6vmRl/FCBYBkWgI6+2/rLLc=
Received: from DM5PR11MB1707.namprd11.prod.outlook.com (2603:10b6:3:14::23) by
 DM6PR11MB4610.namprd11.prod.outlook.com (2603:10b6:5:2ab::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3700.27; Mon, 4 Jan 2021 15:17:56 +0000
Received: from DM5PR11MB1707.namprd11.prod.outlook.com
 ([fe80::516f:5c83:c08f:9074]) by DM5PR11MB1707.namprd11.prod.outlook.com
 ([fe80::516f:5c83:c08f:9074%12]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 15:17:56 +0000
From:   "Chiappero, Marco" <marco.chiappero@intel.com>
To:     Ard Biesheuvel <ardb@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: RE: [PATCH] crypto: qat - add CRYPTO_AES to Kconfig dependencies
Thread-Topic: [PATCH] crypto: qat - add CRYPTO_AES to Kconfig dependencies
Thread-Index: AQHW2F9tE8gHbgKLUEyOHxqkG9bmxaoFBToAgBKielA=
Date:   Mon, 4 Jan 2021 15:17:56 +0000
Message-ID: <DM5PR11MB1707CD79C464AA747F644994E8D20@DM5PR11MB1707.namprd11.prod.outlook.com>
References: <20201222130024.694558-1-marco.chiappero@intel.com>
 <CAMj1kXGUBQX2HrGSS8OAC2zDS0_WyaiRQzxyFatpUG+Px+WcKQ@mail.gmail.com>
In-Reply-To: <CAMj1kXGUBQX2HrGSS8OAC2zDS0_WyaiRQzxyFatpUG+Px+WcKQ@mail.gmail.com>
Accept-Language: en-IE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [37.228.229.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a45cc6d-3c86-46ba-16de-08d8b0c3ea30
x-ms-traffictypediagnostic: DM6PR11MB4610:
x-microsoft-antispam-prvs: <DM6PR11MB4610CBAA0C09A5EBEA033B44E8D20@DM6PR11MB4610.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrYoL9wbkxOgFLA78yU9qUBc9nHrjtuK6ee5IE/XWqVxov5FpqRHy9nMzE7swjSyWTQqbbq012XYb+uodHgCZx78bNHQ5KJRHy0TNy1g3gFOAKBf2DCwvuIXVuHX3FVeV0UVARBAedvF9M+JKx/5oWP3eOIIMqFwEF4tL76OTe3I0ciFt6iWn2RK+WcCzzkr/2Lf6R2GuFkQeyd0MOCvOM2WUoXn93+vO0kUasT7bjKFKfe5K0ByoMqUa3HkebvTOD6+XKqGMjFuCGL6kwdiUm7cKkAxMGRcha8w0NAWseUoVcd/Pce6May8vNzwjx5BjySa6JapmKA/JSICJFftqZyqZqPa9gn6CSHeDozLq0xPdlHECbqalrnfD+V9iqS5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1707.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(5660300002)(52536014)(9686003)(186003)(66946007)(76116006)(6506007)(66556008)(6916009)(64756008)(55016002)(4326008)(26005)(33656002)(86362001)(478600001)(4744005)(316002)(71200400001)(66446008)(8936002)(54906003)(7696005)(2906002)(8676002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akJ5Y0hnZFRZZHQ3WFJHTmZkUWFBWGZQME84ajF5dzY5cjRxamNFSG5vMWlw?=
 =?utf-8?B?Sm00dDQxRGVLNWdrN2I0ZVNmUnIxb3BaN3ArQ2dMVGtTck1lN2lTeFk3SHJs?=
 =?utf-8?B?VTRZL0V5WENQSEdKQ05xalNWK1NTYXhCd2UzNjR3czFHb291ZUxqZE8xMXA1?=
 =?utf-8?B?N2h5aTVJVHFJdGZrZklDQkxJT2MvaWw2Q3JQMlRiMDYxUXJjYmphK0dxT1lU?=
 =?utf-8?B?MDVvM2N4K0psSHBRMXR2Nmp4VnR2UllMSFBFcG5DeWlPcGczOGNrbnBnbmJt?=
 =?utf-8?B?U3hMVmVjaWxrc08xSnFMZHNDRXZ5a29PQTN2NGZvVWgrd0Y5aEt1MDVJWFZn?=
 =?utf-8?B?d2JzSTFpYXN2R1hoL3QzdTRBVnl4QjZtMzFTb2wwUzd4T0hGNUd1akdXaTlV?=
 =?utf-8?B?K0c5OUlqTGZmVU5UL2wrT0R4WFJxdTMxRnBTVENZSG1DdzRuQkpmUmFBdWlY?=
 =?utf-8?B?VTUwTUtFOUhWYUNjU2dlQkcxcmtCd1pnNHJTN3lZVU5qOXFRdnY4cmJlbVpD?=
 =?utf-8?B?UmNpY0RXUmxmQ3ZoSDY5SEd3OTVqUTRlWTljYjMvU0Z3UUszbENuUGEzd2N2?=
 =?utf-8?B?ZVlRWk51ZkRHNk5BR0l6bFJDdkVrZ3F4L1IxSlNucFJHK3lSZkp4RGxsZks1?=
 =?utf-8?B?V1Rsakt2TWswVjAxNnpUOHFWZ3VyMlZpME8wSjQ1UUd4RDNoNk5uaFBMejRD?=
 =?utf-8?B?SHlZT0VkTlIzbjFkTElhb1J5MlJCNVVuNkNWb0pqYlRZV3cwVm0rZ0JicEtr?=
 =?utf-8?B?L0s4V1BKdnMvdkFLdVgvNkFCTkN4N2RucURwMW1OZlZPZkFnMGp4UFBzU2py?=
 =?utf-8?B?RkVWOXFRNDNONjgwUks1Z3pwVDVMcWZKSEJCUjFnYXM0TVZUbzhjQ0hRT3p1?=
 =?utf-8?B?SmRUNmEvUWNuZ090NEtvYWR0OHBkY2R1UGdnZzZwNXVCVHdyYWFaNk5VYVU2?=
 =?utf-8?B?aWpROEhQU3dMVms4L3YyWlh0UFdxSldPYWgrYzhuRjliTWlCb2RYbDhHQURs?=
 =?utf-8?B?RFI1akx0TW9RWW1xU25hWWZ5cW56d2NkRDMwbVZaaTFaNXk2THV3OVVudFF6?=
 =?utf-8?B?cnNoL0hjTGtKZlhCREh5MlVKL2xyVG5Hc09JYktvWUxvY3RPeWZJNjJsdTE1?=
 =?utf-8?B?N1duYXEvOE5jOHpMczlqNlA2dkFNWTM5OG16bXlaSEhoa3Z6WHVPbXA4QUkv?=
 =?utf-8?B?VEpUVitYZ1hZMGdCaVREazBLem8wdTBRdWVWdnN5TlZhTU9zM3lKdmNEb1VY?=
 =?utf-8?B?MXFJV1Vkc2RkYjFhNlFCTkREN3ZSalFJa0FrSXYyTUN0OUNqbHdVeEtqZU84?=
 =?utf-8?Q?upiOL7vyijT5I=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1707.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a45cc6d-3c86-46ba-16de-08d8b0c3ea30
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 15:17:56.6476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5UIEAgwSntaUfCcOFf17y240iC5+EZ+dn4W/ZIBt+ysbCxDFSnhNH2mxLHjJ/3W5MCH+x/73a9J0yBpIWpAjmtkJ1nmbZbB1no0vvIAgujA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4610
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

PiBPbiBUdWUsIDIyIERlYyAyMDIwIGF0IDEzOjM5LCBNYXJjbyBDaGlhcHBlcm8gPG1hcmNvLmNo
aWFwcGVyb0BpbnRlbC5jb20+DQo+IHdyb3RlOg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9jcnlwdG8vcWF0L0tjb25maWcgYi9kcml2ZXJzL2NyeXB0by9xYXQvS2NvbmZpZw0KPiA+IGlu
ZGV4IGJlYjM3OWIyM2RjMy4uODQ2YTNkOTBiNDFhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y3J5cHRvL3FhdC9LY29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy9jcnlwdG8vcWF0L0tjb25maWcN
Cj4gPiBAQCAtMTEsNiArMTEsNyBAQCBjb25maWcgQ1JZUFRPX0RFVl9RQVQNCj4gPiAgICAgICAg
IHNlbGVjdCBDUllQVE9fU0hBMQ0KPiA+ICAgICAgICAgc2VsZWN0IENSWVBUT19TSEEyNTYNCj4g
PiAgICAgICAgIHNlbGVjdCBDUllQVE9fU0hBNTEyDQo+ID4gKyAgICAgICBzZWxlY3QgQ1JZUFRP
X0FFUw0KPiA+ICAgICAgICAgc2VsZWN0IEZXX0xPQURFUg0KPiA+DQo+ID4gIGNvbmZpZyBDUllQ
VE9fREVWX1FBVF9ESDg5NXhDQw0KPiA+IC0tDQo+ID4gMi4yNi4yDQo+ID4NCj4gDQo+IFRoaXMg
c2hvdWxkIGJlICdzZWxlY3QgQ1JZUFRPX0xJQl9BRVMnDQoNClRoYW5rIHlvdSBmb3IgYnJpbmdp
bmcgdGhpcyB1cC4NCg0KUmVnYXJkcywNCk1hcmNvDQo=

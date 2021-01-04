Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7660C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 11:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9695020771
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 11:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbhADLh6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 06:37:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:50852 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbhADLh5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 06:37:57 -0500
IronPort-SDR: LyX3m6uQ6u+ggMXvfdpfELu0zE0+S/FfRgFD1tB1JkDqwhcLiPj7stp2gpfevM3IhMyqVUal1/
 94ehg+lbH24w==
X-IronPort-AV: E=McAfee;i="6000,8403,9853"; a="177096379"
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="177096379"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 03:37:15 -0800
IronPort-SDR: NFuK2RJJdHB1ttApzp4j5hRLpfrg57aSFAB681Bea53XmER2SROJXCHWduU45J+GNOoMruw3es
 6ohaCHyJISpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="397378334"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jan 2021 03:37:15 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 03:37:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 4 Jan 2021 03:37:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 4 Jan 2021 03:37:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 4 Jan 2021 03:36:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnMvlzK6Etq6MhAw1VRcfy5mfJdHzpFITFq2niYlCMSPozHJ3krEfvayOEmIkuadjz9aEyowPGIgkVJhpndi4+Ou+Hxqh3ztn4ZK63KU90m7Flbnal2odU5tDczxkSIiPrSi8Poui53E45cHmvc8qG07FvMf/7TYoiypFCoh5S391WDgyq+87hto3Mq/+5VL6qwWEjrMzcktQpLhU9uLEvIFRIlbB5tVCbcwxRztIHC1ORnX7yF7Mje78skiNtL9vk5I0ofO/fpHamPHnLM3JovgrgDyQEzviSP+U7VuZGFkq21M6Lcj7LBEWrvuMWglNdj1OpeIMCQpYMOSOrJCLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uKMyx6gsvr32Aubk3eRN12Wv6c95HT0jY6pfyBJXF0=;
 b=XIal9ryggFEY7shIzSqOaQWNrV+I01XQZ4uqmU5+fCVMdop3DEXZewuLeyyblXPHELVyjKzCjqE2XJHnSu+1sI+ZIz5JccLZhEBAQwBTvbzkOkIjLaa9KgWCo7ibVU7UApE4+rLV3i5qrfTWcjcBavLkLpSrkmTJSoM0Y2eAEs+YRVTKwyOWM0/eWSwUnZKDdLUo7cnx2raDMbXzohGPhPCqVRGq4rzwvN86HPtH2/Ow6jJujWPU30IqOwAfX3p6hkAXKd4d5yf+m5HAMILT2WXH5o6geAXYm253rGIc2TgfdsHA/CKc/eCroF5Ek0FoH3qv4ceIfPEnSJoI1EWcrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uKMyx6gsvr32Aubk3eRN12Wv6c95HT0jY6pfyBJXF0=;
 b=Y0jCkX5i2v4ZaNaLnoVjt2XHZqtKTz6BLhnZqGwOfvMBdCAVCKs6zZnKL2Z8vARz8Mv1Ho8Sa6puc5AbFjFsCnRwMaLeNbAA7dd4uOGKuxoVFeTJObWcT9S6L5xTwgdFn32wNIGnfenDGJcJpvdc3yVFY7YbFUNdU27n2+lhCPw=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Mon, 4 Jan
 2021 11:36:57 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb%3]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 11:36:57 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "yumeng18@huawei.com" <yumeng18@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuzaibo@huawei.com" <xuzaibo@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] crypto: expose elliptic curve parameters as Crypto
 APIs
Thread-Topic: [PATCH v5 3/5] crypto: expose elliptic curve parameters as
 Crypto APIs
Thread-Index: AQHW4U5x033bdxCQ00ehanwAaKR82qoXN5CAgAAhoYA=
Date:   Mon, 4 Jan 2021 11:36:57 +0000
Message-ID: <1661cb6eaaa7ba456345851781b64dde5b91d22a.camel@intel.com>
References: <1608790107-32617-1-git-send-email-yumeng18@huawei.com>
         <1608790107-32617-4-git-send-email-yumeng18@huawei.com>
         <20210102212929.GA1996@gondor.apana.org.au>
         <a260ceec-e3ca-8fbd-e80e-f08ddc2029a4@huawei.com>
In-Reply-To: <a260ceec-e3ca-8fbd-e80e-f08ddc2029a4@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 780a82a6-9583-45b1-a2c8-08d8b0a50af0
x-ms-traffictypediagnostic: SA0PR11MB4717:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB47174BDAA263D4BD147ECD6BF2D20@SA0PR11MB4717.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T5K0fr7qcP1do0ypRO/yFePRIiLShRNOpm5fgDOqz1nYON0q2q+pFNyKe1sSlyc7jBhUsL7A2PxNl+XOCH1wltmARPwIAuDG8AxCyZzOLpc2rXaxs77D4od02mTqDedrDgjHuJRr+e4I0y3p2yFDwcYK0fKjdaOQNONrBWo6WJwQgb+GoxYpWGMd7WaNntBlE/YyOyjnubBju9Xi7SXRejPXE0vLfBUaZCANkg8ysqRha3PAdRofAK/zuB881v39zogGumjIYkUpe+GyoHsczt+pO8UnvDmF++ulBiimphMpCTRglKYlEJnI+PAJJtWx/pwmtY+f5VIZ3NWm2Md5XinL3B4RlPcuw9rdp1i46Yoe2bmyM9FVqYzzUrE84pw3zg46jiPtST/5NnhOdHbXOwBU+Is0EW3gAyWWe3bM993yYFrnuaz5RCFPJdKkk7EKLtQHKnGSf2PU+0jJ5+0PwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(5660300002)(6486002)(2906002)(6512007)(86362001)(26005)(83380400001)(4326008)(6506007)(110136005)(966005)(66946007)(186003)(54906003)(76116006)(91956017)(36756003)(478600001)(316002)(66476007)(2616005)(66556008)(66446008)(64756008)(8936002)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dG51QVlwRFBhK2FPS1hiVlNFdm55Q3YyWlR3N0tRRUJWVU9nM29Id1F4YzB6?=
 =?utf-8?B?d04vbHdMT0hIRUFNamo4L2FJMitBakIxVnE0dS9GM3FzaUpyTDhYTXJUbkZL?=
 =?utf-8?B?QWREV1ZNN2dkbTVTR2tjWVZMcnkybUdqQVNLOEJHZWwyb0U1MnhiZy9QK1RL?=
 =?utf-8?B?ZllPWXNoR1ZFcURmQTFDYVdQYWlweGhNOUNXS3RYZUN2bjBZNkRhZTd3aWhv?=
 =?utf-8?B?MWV6WHJjNVFuUGVvaThDZlBNaTdSQlhTZkNIalpBekplN1MvWjBrdTFZM3F0?=
 =?utf-8?B?cktiOHhFNU1CWG4wWnhieW11TDgxcTZWL0lEdnU2eGtKV0NUSXBBaVJDdUoy?=
 =?utf-8?B?cDlxT1BaSjROQ1NCbVJIQnVCUzdGalRTUTc4QXQybjBWRVRIU1d0ZXpQQ0hT?=
 =?utf-8?B?T1VBVzFaYmpRaW43MlpQMW5ydHM2bUJpL1NBL3RQTEZHYnVtNWJUTVdBTG1T?=
 =?utf-8?B?SEJnQnc2WTQrbmRSZ0w1aitDZFo0akxyaXByR2o4NUdnTWlraFRKc1lObjNN?=
 =?utf-8?B?Y0VzWGduK1ROOW5NM28rWUNDMTI0Wno2a0ZRUWorbnJvMklGUzZsODRYdGJj?=
 =?utf-8?B?R2xLbitiV2pjK1g0ZExRSlpxaWZyQkg3ci9aaUdkZ0RObm9OejIyZjdTVWRG?=
 =?utf-8?B?U0VXbkFxd0MxeEpBeS9SMmFhYXZPdE9pd1RKdytic3kvckh0UmxzQ1YxODll?=
 =?utf-8?B?V2k0RlM1djE5SU9NazgwMmcxaHJxbVBWQm5FMjBkcHNJWGk4Vy9VUE9tV0xH?=
 =?utf-8?B?Zy9WSUdCeXVZUEZvaURSRXVLZ1BnblV5QTVza3ZGTlFTeU5wZ1E1OEhHN3p3?=
 =?utf-8?B?WkFLSkpYMFlUVGt3L0RiRzlWQkduMEc5b1kxQll0dVd0VEpTR2wxc29qY2pm?=
 =?utf-8?B?QmdsaTBGR0RSUXg0MS9sZVhxSWZCdmpCOG5VbzBXdXJ1U1d5MmJERDVNWStZ?=
 =?utf-8?B?R052WXpXMUcxdEtZYTFkdDFRYXU4ZVExNUFrenQrUDlyV09LdWo1dkdSaVBh?=
 =?utf-8?B?Ry94d0tZblVJemVNMXhURXhOTE8ydUF1UEIrTFZLQzRlZFdiQ1lSNHp3M054?=
 =?utf-8?B?K3VCVGtIV0V2L29oMS92TitWSi9BTDJDeCt3WncrQy82VzRlUUNudHJ1VmxW?=
 =?utf-8?B?dzlLcFVzN0J0cE51dlR4ZGRBOVkrNnhJdnZMTlNuMDJnSVlCU0ZQR294Z3RM?=
 =?utf-8?B?UmtRdk16d0xKb0lrNjY3cVlUNEhPNE5UUSswanRYaDI2M3NwSlFYODczL205?=
 =?utf-8?B?RFhPZmROZlloeW5LQjVDWXlic0RCcU1YakpSbFl1bmZqK1diSUo3RTFnNDVH?=
 =?utf-8?Q?VZM+ohyUuGllLQwIv5c3IDQig/4/GW+uqx?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7ADA55FD4FC62243BB5FD850D5552A92@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 780a82a6-9583-45b1-a2c8-08d8b0a50af0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 11:36:57.0970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2FfzPcDrCjQarhvWfCKWfnoKpqT9KpQWOvMse4Y99TXYmzMQ1EdFxVZ5DcBVqXh1R6v9Hjb5RTyttjBXwvjeWTow/mORgNRG/NFly7ruTjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gTW9uLCAyMDIxLTAxLTA0IGF0IDE3OjM2ICswODAwLCB5dW1lbmcgd3JvdGU6DQo+IA0KPiDl
nKggMjAyMS8xLzMgNToyOSwgSGVyYmVydCBYdSDlhpnpgZM6DQo+ID4gT24gVGh1LCBEZWMgMjQs
IDIwMjAgYXQgMDI6MDg6MjVQTSArMDgwMCwgTWVuZyBZdSB3cm90ZToNCj4gPiA+IE1vdmUgZWxs
aXB0aWMgY3VydmVzIGRlZmluaXRpb24gdG8gJ2luY2x1ZGUvY3J5cHRvL2VjY19jdXJ2ZV9kZWZz
LmgnLA0KPiA+ID4gc28gYWxsIGNhbiB1c2UgaXQsDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IE1lbmcgWXUgPHl1bWVuZzE4QGh1YXdlaS5jb20+DQo+ID4gPiBSZXZpZXdlZC1ieTogWmFp
Ym8gWHUgPHh1emFpYm9AaHVhd2VpLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gICBjcnlwdG8vZWNj
LmMgICAgICAgICAgICAgICAgICAgIHwgIDEgLQ0KPiA+ID4gICBjcnlwdG8vZWNjLmggICAgICAg
ICAgICAgICAgICAgIHwgMzcgKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICAgY3J5cHRvL2VjY19j
dXJ2ZV9kZWZzLmggICAgICAgICB8IDU3IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+
ICAgY3J5cHRvL2VjcmRzYV9kZWZzLmggICAgICAgICAgICB8ICAyICstDQo+ID4gPiAgIGluY2x1
ZGUvY3J5cHRvL2VjY19jdXJ2ZV9kZWZzLmggfCA5MiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiA+ID4gICA1IGZpbGVzIGNoYW5nZWQsIDk1IGluc2VydGlvbnMo
KyksIDk0IGRlbGV0aW9ucygtKQ0KPiA+ID4gICBkZWxldGUgbW9kZSAxMDA2NDQgY3J5cHRvL2Vj
Y19jdXJ2ZV9kZWZzLmgNCj4gPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUvY3J5cHRv
L2VjY19jdXJ2ZV9kZWZzLmgNCj4gPiANCj4gPiBUaGlzIGNvbmZsaWN0cyB3aXRoDQo+ID4gDQo+
ID4gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LWNyeXB0by9wYXRj
aC8yMDIwMTIxNzE3MjEwMS4zODE3NzItMy1kYW5pZWxlLmFsZXNzYW5kcmVsbGlAbGludXguaW50
ZWwuY29tLw0KPiA+IA0KPiA+IFBsZWFzZSBkaXNjdXNzIHdpdGggZWFjaCBvdGhlciBvbiBob3cg
eW91IHdvdWxkIGxpa2UgdG8gcHJvY2VlZC4NCj4gPiANCj4gPiBUaGFua3MsDQo+ID4gDQo+IA0K
PiBoZWxsbywgRGFuaWVsZSwNCj4gDQo+IEluIG15IHBhdGNoLCBJIG1vdmUgZWxsaXB0aWMgY3Vy
dmVzIGRlZmluaXRpb24gdG8gDQo+ICdpbmNsdWRlL2NyeXB0by9lY2NfY3VydmVfZGVmcy5oJywN
Cj4gd2hpY2ggaW5jbHVkZSB0aGUgUC0zODQgY3VydmUgeW91IG5lZWQsIGFuZCB5b3UgY2FuIGVh
c2lseSBpbXBvcnQgaXQgdG8gDQo+IHlvdXIgZHJpdmVyLg0KPiANCj4gQW5kIGlmIHlvdSBpbmNs
dWRlICdjcnlwdG8vZWNjX2N1cnZlX2RlZnMuaCcsIA0KPiAnZHJpdmVycy9jcnlwdG8va2VlbWJh
eS9vY3MtZWNjLWN1cnZlLWRlZnMuaCcNCj4gaXMgbm90IG5lZWRlZC4NCj4gDQo+IENvdWxkIHlv
dSB0aGluayBhYm91dCBpdCwgdG8gcmVseSBvbiBteSBwYXRjaHNldD8NCg0KSGkgTWVuZywNCg0K
U3VyZSwgSSBjYW4gdXBkYXRlIG15IFJGQyBwYXRjaCBzZXJpZXMgdG8gcmVseSBvbiB5b3VyIHBh
dGNoc2V0LiBJdA0KbWFrZXMgc2Vuc2UgdG8gZG8gc28sIHNpbmNlLCBhcyB5b3Ugc2FpZCwgaXQg
d2lsbCBhbGxvdyBtZSB0byBnZXQgcmlkDQpvZiBteSBvY3MtZWNjLWN1cnZlLWRlZnMuaCAoYW5k
IGFsc28gYmVjYXVzZSB5b3VyIHBhdGNoc2V0IHdpbGwNCnByb2JhYmx5IGJlIG1lcmdlZCBiZWZv
cmUgbWluZSkuDQoNCkhlcmJlcnQsIHNob3VsZCBJIHNlbmQgYW4gdXBkYXRlZCBSRkMgbm93IG9y
IHNob3VsZCBJIHdhaXQgZm9yIHRoZQ0KZGlzY3Vzc2lvbiBvbiB0aGUgUkZDIG9wZW4gcG9pbnRz
IHRvIGJlIGNvbXBsZXRlZCBmaXJzdD8NCg0KVGhhbmtzLA0KRGFuaWVsZQ0KDQo=

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D33C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 16:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D65123A1E
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jan 2021 16:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbhAUQOl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jan 2021 11:14:41 -0500
Received: from mga05.intel.com ([192.55.52.43]:15213 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbhAUQOh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jan 2021 11:14:37 -0500
IronPort-SDR: D1uJb1UPshhCp3IBy8LKqdf3GN3oxdA5QGwb4O0lIixKkPCBYYUZ4j2MxkYFQ6TyXCWaKLp1tp
 lVpQEAdGcYvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="264109979"
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="264109979"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 08:13:54 -0800
IronPort-SDR: zfmab1V3XLH16FR3mt8E22cWC0D2fkndYu3oP1altw6D/eJM/99u0szvKbWb4MsaAMYpJHxVep
 iEpulw+jcVTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="392017501"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2021 08:13:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 21 Jan 2021 08:13:52 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Jan 2021 08:13:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 21 Jan 2021 08:13:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ1OE5cNE4131mbe9MbT2zK2nAaaoox/BsxNVZi9c8nIEFfrsU+KRBX0usVWPyeH0rgWS0byNVnolhZdB4I4oMUJfFc0SgABqx22bbZyW97On0VDU6D445Bhzd0In+UbI7QVCvVnfaNQCMQEP/8Mg3ZjlW5zPUZ9MABgrfETeP8QNdikKnznldhT5LachzGwWNlI7tlJc3bsDck5+bhoVsveIK0Q/ukrlaqzR+w2Kcc2iSNKwDs8+XxR1cz3rjBXj1fAiCQlkq2ZYNqrYDpfszm9OkqusRoeLv/TBZKrUgoxMlB1iD5hXjI0rW3dhtumw9D6EKohRvgfwNLu+EkVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkexnQWC9fetoZaegBX7MoTeigvsQNdaSaQE2Uxhl0Y=;
 b=f2aOIBniF+gIF30WisSBFQ5xevgWnOqotrOy0RWRH0Rt7ibbpLy+CQJ08NozwKKLw7ZMCkw17LdvoVOf+8dX05ZQxxarcIY2krj7QVrGi7nXK6Vh/356/WuecVD8/UemN/pLxKfuFPaeL95lJ/DhFnYjJUElMa1dJcHSegEIkZrdxOgsm93XfYpyVudCVHt63diFCdk1TUy7kE9l1CqnAPUV5UObJXyYy+4vwJP3ku6mPWSDtlr2BbMnovVDKLaIQR4dBA3VvRX9YYp4zTdtH101Q6PLoU6ZAh8dXW+z/BDaAdtXRgwP0nZbMHLUdDSmDKlsyFanJwbeTlW4LelABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkexnQWC9fetoZaegBX7MoTeigvsQNdaSaQE2Uxhl0Y=;
 b=l0+YC+j/ABndGySZt2U2BwaNm+eHXNblP4sYOREEYVWZUspOJdkqFGxH+5mNVV4518hNFsmKtpqdOVh08IQCKlG16bwImeQoY85qJgD+8onVTxvajV4nM8A3n49gmknG0UcA+oskYFI7XdscChDYBmDdKkWqH1PMjFctDdc87bI=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA2PR11MB4954.namprd11.prod.outlook.com (2603:10b6:806:11b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Thu, 21 Jan
 2021 16:13:51 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%6]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 16:13:51 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "ardb@kernel.org" <ardb@kernel.org>
CC:     "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZp0lFZ4RWHkSmMpliCOeP3aoXNzCAgAA5/gCAADTIgIAPb+8AgACGmACABdvZAIAABCMAgAOXb4CAAPk8AIAAangA
Date:   Thu, 21 Jan 2021 16:13:51 +0000
Message-ID: <711536383d5e829bd128a41e1a56ae50399b6c26.camel@intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
         <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <20210104113148.GA20575@gondor.apana.org.au>
         <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
         <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
         <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
         <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
In-Reply-To: <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8fce774-4b05-4c8f-5c35-08d8be278af6
x-ms-traffictypediagnostic: SA2PR11MB4954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB49542E8ECD1EF34FB4317503F2A10@SA2PR11MB4954.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O6fV3f0osx6qFvLoTw1nxq6JxF1HHrKjZhCLiyaLP8SPZXlNMPqPud861rFdjYok7dlH45+pNgY9YgaU9g7OVNgPDWMaAr15g9CO/bUhs2PMZCm/OIID6rID05B7hEk00lG+wLn0skov1HnFSgiA2rKgfJPEFTEkP1PhWxM/ZnhPhlTmg6Bq01SBm4Fiu95DABKamUVDf5avfOySXS5/YcDpZbTeh8woDT6LhgWHIICD3LSLIhQFSZaPpAPCfxep2omMTvlP7oUKv7NCQNE9ZHbkLDjn0y8uuVWCNca/sceU/IQiVgbFZdnXeE1VmRSGbdPUHW2k2fqW86ebfFOsNWUAmyKawlGnh0xlhWgpM0mpL3V7SSefmlfakT8XHogT9wrT6oVrFbqm9MAKIAIhwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(478600001)(66476007)(6486002)(36756003)(83380400001)(8936002)(76116006)(2906002)(66446008)(54906003)(26005)(66946007)(6512007)(2616005)(6916009)(64756008)(316002)(8676002)(4326008)(86362001)(186003)(91956017)(66556008)(6506007)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UzNJK0R3M1lxL3VPMmh5M3Q0L2I2czE0ODdEak83UmRGaVFVRm4yT1lpVWJZ?=
 =?utf-8?B?My9CQ2NIR2VLanJpaGJ4QnJKRmtpdndGVWc4ajcvSDhkTitqOXA5aXpETG5i?=
 =?utf-8?B?cHhRbFRnYjlRRjBBeXlwOWFwVFliQVo5S09TWURqTkRzQ3JOU200by9MMy9G?=
 =?utf-8?B?cGhRZklMTHUrWXdnbW1kcm9NeVliTEQrb21OVEFjbHNDUE1QY2Y2ejZKR2No?=
 =?utf-8?B?R3ozaTU0ZHBwVExJcy9WYWhuZWdJeTl2cVErRVdIcUZ0WmpPTTdzcEc1S0gw?=
 =?utf-8?B?Y2hsaEVNQSt2WFNWOCtzUlB3NkozVnI1aytyb2ZzRWM2QU1Ka1I1NlB5RHdE?=
 =?utf-8?B?LzczcUFQRmRWQ0JmUHN4ZjZyKzgxQ3dTQWEwRTRnRzkvaXo5cjNBYUpqTkll?=
 =?utf-8?B?eHhXWnJMbWFPTDhDb0w1MVc5bnBqT2RNRUlwbnIxS1JxeGppSjlmNTllV2dy?=
 =?utf-8?B?ZGNXbmVQcXRnZWdscDY3T3c1ZUJzWW5pYXl6dGQ2NElQZVBMUGNxTWZTdE1Y?=
 =?utf-8?B?VmxhOVMrcXB3dGp4MlZFa3RDZmROOUFaZjROazdPQjZ6T25MbUROSkpjZTgv?=
 =?utf-8?B?T0V3NUdBOG8xN1RFQzVnWVR6RE1FYmFlNUt0bDRKRm5vK081N0lnTTBKM0hX?=
 =?utf-8?B?WDZuQTJlVkw1WEVSNFdSY1UxMDc4UlpFakRWZUJIM1FnTmJPOEp3MTRqRzlo?=
 =?utf-8?B?bkU3RjFYZk9HTjVYVW5VZFNoL1lWelR5UTRkcTdXbVQzVHlTRDIyeTRPaGRo?=
 =?utf-8?B?Zm81YTU2bzBZbE1nNW85SThsY21aM2pIWExvYmpVVWRYRlBQREt2Q2E1UE1V?=
 =?utf-8?B?OFBUT0VldGhMd1grOUIrdVBaNnBOVmx0emJsd1BSdDJYWUZhVy8zV0UxMDlh?=
 =?utf-8?B?OWU1dkRIdHVVb24vOXMrdVNabFNPQ2F1cC9rU05reE5kSThocEhTSmpraGpP?=
 =?utf-8?B?VGo0RW5uMVRQa2xLZnNldk16dmxtL0tYbndxZjFZcCs5TW9SbmFoUE00TklX?=
 =?utf-8?B?YnZnZmloVm5GdDhCK0J5dGtTTzNCbTJxL0pJdXhBT2RpYmY4Vlc5Y1h2cFYw?=
 =?utf-8?B?TG5OSlRwVmRrWHl2MDJja2RzQ1JqUjA5MStCMUEvc0JOMHU3LzRRNVBwbEgz?=
 =?utf-8?B?MjBNYnZuMTFtL1hQd3dlSWRHMGFlMThDM09JaGVXNzVhWlZvOU5vQ09LY0Nj?=
 =?utf-8?B?dUY1eTdPcSs1L3lSbnRRaCtCUHJOckFLeWFGL1dNeHNYVXNtemtBaURrello?=
 =?utf-8?B?VGZuZVZJNTRySkZyOEdiUWU1bzg1SVpyUlE1OEI3ZUJBek05OHp2UzRzbkxm?=
 =?utf-8?Q?n+TefzwoPjPKJnzQEec3JNYadG2wAGkR6c?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1AFE6E8E5829ED4A892A11EBAD6D4248@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8fce774-4b05-4c8f-5c35-08d8be278af6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 16:13:51.5999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gej98YdJPMX69QKviPFpgigZJdua6jfSLJxb/MTUZOLrS8U2U6hpZ5V2D9qiMcZ2bhTdhdPsDMFS5+pUnuIlm1zwA3K5KioylizQJ2a/JJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4954
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVGh1LCAyMDIxLTAxLTIxIGF0IDEwOjUyICswMTAwLCBBcmQgQmllc2hldXZlbCB3cm90ZToN
Cj4gT24gV2VkLCAyMCBKYW4gMjAyMSBhdCAyMDowMCwgQWxlc3NhbmRyZWxsaSwgRGFuaWVsZQ0K
PiA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gSGkgQXJkLA0K
PiA+IA0KPiA+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgdmFsdWFibGUgZmVlZGJhY2su
DQo+ID4gDQo+ID4gT24gTW9uLCAyMDIxLTAxLTE4IGF0IDEzOjA5ICswMTAwLCBBcmQgQmllc2hl
dXZlbCB3cm90ZToNCj4gPiA+IFRoaXMgaXMgcmF0aGVyIHVudXN1YWwgY29tcGFyZWQgd2l0aCBo
b3cgdGhlIGNyeXB0byBBUEkgaXMNCj4gPiA+IHR5cGljYWxseQ0KPiA+ID4gdXNlZCwgYnV0IGlm
IHRoaXMgaXMgcmVhbGx5IHdoYXQgeW91IHdhbnQgdG8gaW1wbGVtZW50LCB5b3UgY2FuDQo+ID4g
PiBkbyBzbw0KPiA+ID4gYnk6DQo+ID4gPiAtIGhhdmluZyBhICJlY2RoIiBpbXBsZW1lbnRhdGlv
biB0aGF0IGltcGxlbWVudHMgdGhlIGVudGlyZQ0KPiA+ID4gcmFuZ2UsIGFuZA0KPiA+ID4gdXNl
cyBhIGZhbGxiYWNrIGZvciBjdXJ2ZXMgdGhhdCBpdCBkb2VzIG5vdCBpbXBsZW1lbnQNCj4gPiA+
IC0gZXhwb3J0IHRoZSBzYW1lIGltcGxlbWVudGF0aW9uIGFnYWluIGFzICJlY2RoIiBhbmQgd2l0
aCBhIGtub3duDQo+ID4gPiBkcml2ZXIgbmFtZSAiZWNkaC1rZWVtYmF5LW9jcyIsIGJ1dCB3aXRo
IGEgc2xpZ2h0bHkgbG93ZXINCj4gPiA+IHByaW9yaXR5LA0KPiA+ID4gYW5kIGluIHRoaXMgY2Fz
ZSwgcmV0dXJuIGFuIGVycm9yIHdoZW4gdGhlIHVuaW1wbGVtZW50ZWQgY3VydmUgaXMNCj4gPiA+
IHJlcXVlc3RlZC4NCj4gPiA+IA0KPiA+ID4gVGhhdCB3YXksIHlvdSBmdWxseSBhZGhlcmUgdG8g
dGhlIEFQSSwgYnkgcHJvdmlkaW5nDQo+ID4gPiBpbXBsZW1lbnRhdGlvbnMgb2YNCj4gPiA+IGFs
bCBjdXJ2ZXMgYnkgZGVmYXVsdC4gQW5kIGlmIGEgdXNlciByZXF1ZXN0cyAiZWNkaC1rZWVtYmF5
LW9jcyINCj4gPiA+IGV4cGxpY2l0bHksIGl0IHdpbGwgbm90IGJlIGFibGUgdG8gdXNlIHRoZSBQ
MTkyIGN1cnZlDQo+ID4gPiBpbmFkdmVydGVudGx5Lg0KPiA+IA0KPiA+IEkgdHJpZWQgdG8gaW1w
bGVtZW50IHRoaXMsIGJ1dCBpdCBsb29rcyBsaWtlIHRoZSBkcml2ZXIgbmFtZSBpcw0KPiA+IG1h
bmRhdG9yeSwgc28gSSBzcGVjaWZpZWQgb25lIGFsc28gZm9yIHRoZSBmaXJzdCBpbXBsZW1lbnRh
dGlvbi4NCj4gPiANCj4gPiBCYXNpY2FsbHkgSSBkZWZpbmVkIHR3byAnc3RydWN0IGtwcF9hbGcn
IHZhcmlhYmxlczsgYm90aCB3aXRoDQo+ID4gY3JhX25hbWUNCj4gPiA9ICJlY2RoIiwgYnV0IHdp
dGggZGlmZmVyZW50ICdjcmFfZHJpdmVyX25hbWUnIChvbmUgd2l0aA0KPiA+IGNyYV9kcml2ZXJf
bmFtZSA9ICJlY2RoLWtlZW1iYXktb2NzLWZhbGxiYWNrIiBhbmQgdGhlIG90aGVyIG9uZQ0KPiA+
IHdpdGgNCj4gPiBjcmFfZHJpdmVyX25hbWUgPSAiZWNkaC1rZWVtYmF5LW9jcyIpLg0KPiA+IA0K
PiA+IElzIHRoaXMgd2hhdCB5b3Ugd2VyZSBzdWdnZXN0aW5nPw0KPiA+IA0KPiA+IEFueXdheSwg
dGhhdCB3b3JrcyAoaS5lLiwgJ2VjZGgta2VlbWJheS1vY3MnIHJldHVybnMgYW4gZXJyb3Igd2hl
bg0KPiA+IHRoZQ0KPiA+IHVuaW1wbGVtZW50ZWQgY3VydmUgaXMgcmVxdWVzdGVkOyB3aGlsZSAn
ZWNkaC1rZWVtYmF5LW9jcycgYW5kDQo+ID4gJ2VjZGgnDQo+ID4gd29yayBmaW5lIHdpdGggYW55
IGN1cnZlKSwgYnV0IEkgaGF2ZSB0byBzZXQgdGhlIHByaW9yaXR5IG9mICdlY2RoLQ0KPiA+IGtl
ZW1iYXktb2NzJyB0byBzb21ldGhpbmcgbG93ZXIgdGhhbiB0aGUgJ2VjZGhfZ2VuZXJpYycgcHJp
b3JpdHkuDQo+ID4gT3RoZXJ3aXNlIHRoZSBpbXBsZW1lbnRhdGlvbiB3aXRoIGZhbGxiYWNrIGVu
ZHMgdXAgdXNpbmcgbXkgImVjZGgtDQo+ID4ga2VlbWJheS1vY3MiIGFzIGZhbGxiYWNrIChzbyBp
dCBlbmRzIHVwIHVzaW5nIGEgZmFsbGJhY2sgdGhhdCBzdGlsbA0KPiA+IGRvZXMgbm90IHN1cHBv
cnQgdGhlIFAtMTkyIGN1cnZlKS4NCj4gPiANCj4gPiBBbHNvLCB0aGUgaW1wbGVtZW50YXRpb24g
d2l0aG91dCBmYWxsYmFjayBpcyBzdGlsbCBmYWlsaW5nIGNyeXB0bw0KPiA+IHNlbGYtDQo+ID4g
dGVzdHMgKGFzIGV4cGVjdGVkIEkgZ3Vlc3MpLg0KPiA+IA0KPiA+IFRoZXJlZm9yZSwgSSB0cmll
ZCB3aXRoIGEgc2xpZ2h0bHkgZGlmZmVyZW50IHNvbHV0aW9uLiBTdGlsbCB0d28NCj4gPiBpbXBs
ZW1lbnRhdGlvbnMsIGJ1dCB3aXRoIGRpZmZlcmVudCBjcmFfbmFtZXMgKG9uZSB3aXRoIGNyYV9u
YW1lID0NCj4gPiAiZWNkaCIgYW5kIHRoZSBvdGhlciBvbmUgd2l0aCBjcmFfbmFtZSA9ICJlY2Ro
LWtlZW1iYXkiKS4gVGhpcw0KPiA+IHNvbHV0aW9uDQo+ID4gc2VlbXMgdG8gYmUgd29ya2luZywg
c2luY2UsIHRoZSAiZWNkaC1rZWVtYmF5IiBpcyBub3QgdGVzdGVkIGJ5IHRoZQ0KPiA+IHNlbGYg
dGVzdHMgYW5kIGlzIG5vdCBwaWNrZWQgdXAgYXMgZmFsbGJhY2sgZm9yICJlY2RoIiAoc2luY2Us
IGlmIEkNCj4gPiB1bmRlcnN0YW5kIGl0IGNvcnJlY3RseSwgaXQncyBsaWtlIGlmIEknbSBkZWZp
bmluZyBhIG5ldyBraW5kIG9mDQo+ID4ga3BwDQo+ID4gYWxnb3JpdGhtKSwgYnV0IGl0J3Mgc3Rp
bGwgcGlja2VkIHdoZW4gY2FsbGluZw0KPiA+IGNyeXB0b19hbGxvY19rcHAoImVjZGgtDQo+ID4g
a2VlbWJheSIpLg0KPiA+IA0KPiA+IERvZXMgdGhpcyBzZWNvbmQgc29sdXRpb24gbG9va3Mgb2th
eSB0byB5b3U/IE9yIGRvZXMgaXQgaGF2ZSBzb21lDQo+ID4gcGl0ZmFsbCB0aGF0IEknbSBtaXNz
aW5nPw0KPiA+IA0KPiANCj4gWW91IHNob3VsZCBzZXQgdGhlIENSWVBUT19BTEdfTkVFRF9GQUxM
QkFDSyBmbGFnIG9uIGJvdGgNCj4gaW1wbGVtZW50YXRpb25zLCB0byBlbnN1cmUgdGhhdCBuZWl0
aGVyIG9mIHRoZW0gYXJlIGNvbnNpZGVyZWQgYXMNCj4gZmFsbGJhY2tzIHRoZW1zZWx2ZXMuDQoN
ClRoYW5rcyBhZ2FpbiENCg0KSSB3YXMgc2V0dGluZyB0aGF0IGZsYWcgb25seSBmb3IgdGhlIGZp
cnN0IGltcGxlbWVudGF0aW9uICh0aGUgb25lIHdpdGgNCmZhbGxiYWNrKSwgYnV0IEkgc2VlIG5v
dyBob3cgaXQncyBuZWVkZWQgZm9yIHRoZSBzZWNvbmQgb25lIGFzIHdlbGwuDQoNCldpdGggdGhh
dCwgdGhlIHNlY29uZCBpbXBsZW1lbnRhdGlvbiAoaS5lLiwgdGhlIG9uZSB3aXRob3V0IGZhbGxi
YWNrKQ0KaXMgbm90IHVzZWQgYW55bW9yZSBhcyBhIGZhbGxiYWNrIGZvciB0aGUgZmlyc3Qgb25l
Lg0KDQpBcyBleHBlY3RlZCwgdGhlIHNlY29uZCBpbXBsZW1lbnRhdGlvbiBkb2VzIG5vdCBwYXNz
IHNlbGYtdGVzdHMgYW5kDQpjcnlwdG9fYWxsb2Nfa3BwKCkgcmV0dXJucyAtRUxJQkJBRCB3aGVu
IHRyeWluZyB0byBhbGxvY2F0ZSBpdCwgYnV0DQpJJ3ZlIHNlZW4gdGhhdCBJIGNhbiBhdm9pZCB0
aGUgZXJyb3IgKGFuZCBoYXZlIGl0IGFsbG9jYXRlZCBwcm9wZXJseSkNCmJ5IHBhc3NpbmcgdGhl
IENSWVBUT19BTEdfVEVTVEVEIGZsYWcgaW4gdGhlICd0eXBlJyBhcmd1bWVudCwgbGlrZQ0KYmVs
b3c6DQoNCiAgIGNyeXB0b19hbGxvY19rcHAoImVjZGgta2VlbWJheS1vY3MiLCBDUllQVE9fQUxH
X1RFU1RFRCwgMCk7DQoNCklzIHRoYXQgdGhlIHJpZ2h0IHdheSB0byB0ZWxsIGNyeXB0b19hbGxv
Y19rcHAoKSB0aGF0IHdlIGFyZSBmaW5lIHVzaW5nDQphbiBpbXBsZW1lbnRhdGlvbiB0aGF0IGZh
aWxzIHNlbGYtdGVzdHM/DQoNCg0KDQo=

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE20C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 808EF233F6
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388684AbhATTB1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:01:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:22025 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbhATTBY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 14:01:24 -0500
IronPort-SDR: F6Xm2wIIJ1UUj/SgMZ+OaL0p7tPDZ18a8F3XeYvMjPZ5G/WocuoXgub888HtpkT1YBbZ5zhhjG
 O4LBxiJuDQCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="240702065"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="240702065"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 11:00:47 -0800
IronPort-SDR: qOs1J5Hi255z34mHBgwQSrhjhUOoQ/WihQok8yIvKDQEe/ABESvcbMVdJk4tsk9hXZTebHagNO
 wNsDoMGzO+9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="354407668"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2021 11:00:47 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Jan 2021 11:00:46 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Jan 2021 11:00:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 20 Jan 2021 11:00:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 20 Jan 2021 11:00:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A64LLCHTWL2/byGpnf4dd1KnrO0FI7c0lnWoB2uJNVmsntBHUYQLaQZnnxVgscwWXt+dqIr4b2CdV28zGXim8jzUeupC4an4JEddcbAbGNhBJzmBwcny5fB7YWjPJBxsGga+TPY9g3JZMSc6TOBBYdKB1zu51VhIbo2WHlGN5EgfBV2NUd4RIa41IkiAR3OP4FT5Wd3qJHkBw5ZrwPLKSB+OoPFrbwmm10jhhhoE/TCmmx4QpcA8Grct/PNqCUEkYYju51ZUNkUXOhm96oAkBNKYEaTPtVOtOVdmvkRHWfggw+JMGGMzk7D7J0f3mDv6mCq6HIpbaCr+dj16f7j7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIb07aWhtHqmweTOA86YgRfJ3O7g4osBsWpBpEOYbv4=;
 b=hCBFVMTbpT9HHzq8WIXxwOI/jowxKTjVm/St6+OIfS2WguFjU0kkiwXvz5+ksPFmfbj6yEvpQqCVgxVj41u2ehOeY35OT4wSqqk/BpQJy2R4WcJ0xOL84YtlJN+LjbKst2ubx79Q0khjtqBb/AxJ8dAkpXdyfFwK3rCRNOoMFxbBjSORkx/0k0Mm7NYN0QefJj7fIgL7IRf9IUkiikb1d/wLXKuU5OPCyeHSr8ldfp853Mz1CiFf8HFmOWRBP1rfEtFKcrYdHbkjUuG7E4mPLm2ZHt/ff3YRxmW3R5m2zrCP11c06VL8MktAUwxm7vl1NHsvOVY4EYVrRq5sjFRDTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIb07aWhtHqmweTOA86YgRfJ3O7g4osBsWpBpEOYbv4=;
 b=NYlIC5Wj9NLwZKew9L3YU8hZv9aEI/qfzdjujEN9tnpiYST3x4ua7DFBhlc+5clID9XIYi+2i57myTdVKY+qmNMWjvycgYidzpfEjBVCBSI4PkOh7GzkuJy+JPic81qr6PpqtRAY6eeUaKrWodjoW8MxWqyPl+rBK4v/Yapcyng=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB2879.namprd11.prod.outlook.com (2603:10b6:805:5c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 20 Jan
 2021 19:00:45 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%6]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 19:00:45 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "Reshetova, Elena" <elena.reshetova@intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>
CC:     "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZp0lFZ4RWHkSmMpliCOeP3aoXNzCAgAA5/gCAADTIgIAPb+8AgACGmACABdvZAIAABCMAgAOXb4A=
Date:   Wed, 20 Jan 2021 19:00:45 +0000
Message-ID: <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
         <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <20210104113148.GA20575@gondor.apana.org.au>
         <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
         <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
In-Reply-To: <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99ba2cf5-0957-41f1-9213-08d8bd75b11b
x-ms-traffictypediagnostic: SN6PR11MB2879:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB28799C774A72B39682FD3C87F2A29@SN6PR11MB2879.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2g5RJtVyRxQsdDWhvGsE6bj0qsBaJVLUDry6ueRE5lhAskOpsa6U9+cHBjahw+ubUf6NrM+CKg5nvgajZ+Ljj7txeo/RKRJfhHLPKUVzA3H3r1pjtq6J88XZ9WI5i+UdkXnPVc1m/ZITvdL/OtQltO/wzosusjm/j0lcyr51MxhcVFchBPlxfM/qEoaDDO9+Wie4awlGuKlTfCE4f1e6emBQ8Qv+wlCVtFq8CitSUqBAQLaqNWXZR9GiaTtWbFpi4YiSL/h7quJpj5YDKRCSvxrzePP/wVbDGHTSc+bxKbH1jjBRs6mTfriDCrY3KLuCA/B++rDurA6OqohKEUHzaAnB/Wgm25HhtucWzYmJgbW0u472iNj/HY3P/5yZ+Bph7IeLPpPnWy+Bl10ejMwwVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(2906002)(5660300002)(54906003)(110136005)(316002)(83380400001)(8936002)(6512007)(71200400001)(4326008)(2616005)(26005)(478600001)(6486002)(8676002)(186003)(36756003)(76116006)(66476007)(66556008)(6506007)(66446008)(64756008)(91956017)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VmxGNlZUc1NaUTlDSjU1cldOY0VtM3F1N0NlWUdpQlhVRWNWZmtKbWdzYmxn?=
 =?utf-8?B?a0k1ZUJDU2liUEJheTNJTEg3a3dzMkRjQ0FuajRqckg5VENvMWcrKzNnYzNL?=
 =?utf-8?B?WEU3ZjNIRHErMEVpMExyai9BSjNYVnQrakcreVFjYnNkd1VUTG1vTkZJUDJy?=
 =?utf-8?B?UG1KTHZPWXl1N1oyTVA4YTZrZjR1Zmc3NldRS2RBWHRnMm1ualovaEZqWk42?=
 =?utf-8?B?OGVMenRmSmxFOGNSVjgvRlRNVkVHWVlMVUZjY3phSTM3Ky8wb1BCL3orODdo?=
 =?utf-8?B?WDJRL1dGQUd2cEdSNU05N2NYOXRab2pDWngxTGIyK1R2Uk9ocXpYSnFmZjQ0?=
 =?utf-8?B?VGU3Qk5Xc0F6bU5EYUxjV3FXa05iR0U3OWZMVldSUUdIbERnZGdkVThBN01r?=
 =?utf-8?B?eFpBdTFkenZZNm9hamlLYW42STB3b2k0Q1hhYzJXbC8vUGZ4RXFLRjR1R3M1?=
 =?utf-8?B?TWlMbGJPdGZyMkZNZGpodEhIWW1IcnJiTWJDRHpYNGpET2E4RDFpL0t1Szk4?=
 =?utf-8?B?NCtSRWF4SlB1RENzaTg3YnhUMXVMVnpRL3BZTDloSEgvbXdENGNndW4yb2F0?=
 =?utf-8?B?c25JTUpkRWp4Z3JzRkkrRFh5dlVOYXN6azE2ay8yVUFJdXpEMG0xN09SMVJx?=
 =?utf-8?B?dEdHeW0xUVI4WXF6cGFVTVpZT1oyVGdJdVZCTWgvcHhheHNzMEZnK0tMZjA0?=
 =?utf-8?B?cTVjbUMvMzIwZDE4QStlVUcrVHhLdEp0VXRiVVh0NWw2SUl2eW1tWVNHd0dZ?=
 =?utf-8?B?d3Vzb0NzTUprcmxnbWFXQUlMaVNYUlRISFVRV2FsYWlIc2twOERMRmpLdjZq?=
 =?utf-8?B?cDNLZ3plTkpRU1d3TFc2L2xqV1JPSG1OZHVlYkxjZFd0TThTakRTcW9YMHpT?=
 =?utf-8?B?SVhDK0xwaXd6am9QRGFpZ0NiK0NqMW1ONEZFUmZjQkg2bWM4bENjYTVHemkw?=
 =?utf-8?B?ajFHbFQ3bDF0TW1Odm93Nk9TdGJBY0pnSEtaS2VlY0FJNE1XQmlQV0hBWCtH?=
 =?utf-8?B?OFpqUEYybGZkVVNZMDdGK1VJQm1EVmw1L09oaGtCSkVrTzJpMDczd1JzVlE1?=
 =?utf-8?B?eUdWY3lNZzJONFoydWhWUTVBZFlVekgxSXR4bmlMdWRyQzRpVW41aEdEZnNW?=
 =?utf-8?B?MjdXSUo4bmRtS0xUUkRGUEtzNkhJVkNUckt3OVRVZWtWNjFpMk5idGw1a3Zj?=
 =?utf-8?B?T054amcycC91b2NRcUtHNTNDWFlXakE2eXZKR1dhdmIrenpVbzdzcmVKNVgr?=
 =?utf-8?B?RGJ3SnFxQVFmM0xVWHhib1lnYTY3ZEFiRnNSSkN6Sm1Nc3JMSk9RSVhBT2Nq?=
 =?utf-8?Q?98TzmieYjVG+DkoTNea4DP0iPr+6j2Ip8C?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42AC27819A85E44E8A4027BA9DC1F305@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ba2cf5-0957-41f1-9213-08d8bd75b11b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 19:00:45.1483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcD/z+1iyjo+yp+5n1AG/9eRo1XUGt2cK8rCDVJEQEu236C3t3VPmzY7TySYEj69ln1o2dvcl8enTyoaDhm+lrPZv7evygHEoiPgj8Brk98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2879
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgQXJkLA0KDQpUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB5b3VyIHZhbHVhYmxlIGZlZWRiYWNr
Lg0KDQpPbiBNb24sIDIwMjEtMDEtMTggYXQgMTM6MDkgKzAxMDAsIEFyZCBCaWVzaGV1dmVsIHdy
b3RlOg0KPiBUaGlzIGlzIHJhdGhlciB1bnVzdWFsIGNvbXBhcmVkIHdpdGggaG93IHRoZSBjcnlw
dG8gQVBJIGlzIHR5cGljYWxseQ0KPiB1c2VkLCBidXQgaWYgdGhpcyBpcyByZWFsbHkgd2hhdCB5
b3Ugd2FudCB0byBpbXBsZW1lbnQsIHlvdSBjYW4gZG8gc28NCj4gYnk6DQo+IC0gaGF2aW5nIGEg
ImVjZGgiIGltcGxlbWVudGF0aW9uIHRoYXQgaW1wbGVtZW50cyB0aGUgZW50aXJlIHJhbmdlLCBh
bmQNCj4gdXNlcyBhIGZhbGxiYWNrIGZvciBjdXJ2ZXMgdGhhdCBpdCBkb2VzIG5vdCBpbXBsZW1l
bnQNCj4gLSBleHBvcnQgdGhlIHNhbWUgaW1wbGVtZW50YXRpb24gYWdhaW4gYXMgImVjZGgiIGFu
ZCB3aXRoIGEga25vd24NCj4gZHJpdmVyIG5hbWUgImVjZGgta2VlbWJheS1vY3MiLCBidXQgd2l0
aCBhIHNsaWdodGx5IGxvd2VyIHByaW9yaXR5LA0KPiBhbmQgaW4gdGhpcyBjYXNlLCByZXR1cm4g
YW4gZXJyb3Igd2hlbiB0aGUgdW5pbXBsZW1lbnRlZCBjdXJ2ZSBpcw0KPiByZXF1ZXN0ZWQuDQo+
IA0KPiBUaGF0IHdheSwgeW91IGZ1bGx5IGFkaGVyZSB0byB0aGUgQVBJLCBieSBwcm92aWRpbmcg
aW1wbGVtZW50YXRpb25zIG9mDQo+IGFsbCBjdXJ2ZXMgYnkgZGVmYXVsdC4gQW5kIGlmIGEgdXNl
ciByZXF1ZXN0cyAiZWNkaC1rZWVtYmF5LW9jcyINCj4gZXhwbGljaXRseSwgaXQgd2lsbCBub3Qg
YmUgYWJsZSB0byB1c2UgdGhlIFAxOTIgY3VydmUgaW5hZHZlcnRlbnRseS4NCg0KSSB0cmllZCB0
byBpbXBsZW1lbnQgdGhpcywgYnV0IGl0IGxvb2tzIGxpa2UgdGhlIGRyaXZlciBuYW1lIGlzDQpt
YW5kYXRvcnksIHNvIEkgc3BlY2lmaWVkIG9uZSBhbHNvIGZvciB0aGUgZmlyc3QgaW1wbGVtZW50
YXRpb24uDQoNCkJhc2ljYWxseSBJIGRlZmluZWQgdHdvICdzdHJ1Y3Qga3BwX2FsZycgdmFyaWFi
bGVzOyBib3RoIHdpdGggY3JhX25hbWUNCj0gImVjZGgiLCBidXQgd2l0aCBkaWZmZXJlbnQgJ2Ny
YV9kcml2ZXJfbmFtZScgKG9uZSB3aXRoDQpjcmFfZHJpdmVyX25hbWUgPSAiZWNkaC1rZWVtYmF5
LW9jcy1mYWxsYmFjayIgYW5kIHRoZSBvdGhlciBvbmUgd2l0aA0KY3JhX2RyaXZlcl9uYW1lID0g
ImVjZGgta2VlbWJheS1vY3MiKS4NCg0KSXMgdGhpcyB3aGF0IHlvdSB3ZXJlIHN1Z2dlc3Rpbmc/
DQoNCkFueXdheSwgdGhhdCB3b3JrcyAoaS5lLiwgJ2VjZGgta2VlbWJheS1vY3MnIHJldHVybnMg
YW4gZXJyb3Igd2hlbiB0aGUNCnVuaW1wbGVtZW50ZWQgY3VydmUgaXMgcmVxdWVzdGVkOyB3aGls
ZSAnZWNkaC1rZWVtYmF5LW9jcycgYW5kICdlY2RoJw0Kd29yayBmaW5lIHdpdGggYW55IGN1cnZl
KSwgYnV0IEkgaGF2ZSB0byBzZXQgdGhlIHByaW9yaXR5IG9mICdlY2RoLQ0Ka2VlbWJheS1vY3Mn
IHRvIHNvbWV0aGluZyBsb3dlciB0aGFuIHRoZSAnZWNkaF9nZW5lcmljJyBwcmlvcml0eS4NCk90
aGVyd2lzZSB0aGUgaW1wbGVtZW50YXRpb24gd2l0aCBmYWxsYmFjayBlbmRzIHVwIHVzaW5nIG15
ICJlY2RoLQ0Ka2VlbWJheS1vY3MiIGFzIGZhbGxiYWNrIChzbyBpdCBlbmRzIHVwIHVzaW5nIGEg
ZmFsbGJhY2sgdGhhdCBzdGlsbA0KZG9lcyBub3Qgc3VwcG9ydCB0aGUgUC0xOTIgY3VydmUpLg0K
DQpBbHNvLCB0aGUgaW1wbGVtZW50YXRpb24gd2l0aG91dCBmYWxsYmFjayBpcyBzdGlsbCBmYWls
aW5nIGNyeXB0byBzZWxmLQ0KdGVzdHMgKGFzIGV4cGVjdGVkIEkgZ3Vlc3MpLg0KDQpUaGVyZWZv
cmUsIEkgdHJpZWQgd2l0aCBhIHNsaWdodGx5IGRpZmZlcmVudCBzb2x1dGlvbi4gU3RpbGwgdHdv
DQppbXBsZW1lbnRhdGlvbnMsIGJ1dCB3aXRoIGRpZmZlcmVudCBjcmFfbmFtZXMgKG9uZSB3aXRo
IGNyYV9uYW1lID0NCiJlY2RoIiBhbmQgdGhlIG90aGVyIG9uZSB3aXRoIGNyYV9uYW1lID0gImVj
ZGgta2VlbWJheSIpLiBUaGlzIHNvbHV0aW9uDQpzZWVtcyB0byBiZSB3b3JraW5nLCBzaW5jZSwg
dGhlICJlY2RoLWtlZW1iYXkiIGlzIG5vdCB0ZXN0ZWQgYnkgdGhlDQpzZWxmIHRlc3RzIGFuZCBp
cyBub3QgcGlja2VkIHVwIGFzIGZhbGxiYWNrIGZvciAiZWNkaCIgKHNpbmNlLCBpZiBJDQp1bmRl
cnN0YW5kIGl0IGNvcnJlY3RseSwgaXQncyBsaWtlIGlmIEknbSBkZWZpbmluZyBhIG5ldyBraW5k
IG9mIGtwcA0KYWxnb3JpdGhtKSwgYnV0IGl0J3Mgc3RpbGwgcGlja2VkIHdoZW4gY2FsbGluZyBj
cnlwdG9fYWxsb2Nfa3BwKCJlY2RoLQ0Ka2VlbWJheSIpLg0KDQpEb2VzIHRoaXMgc2Vjb25kIHNv
bHV0aW9uIGxvb2tzIG9rYXkgdG8geW91PyBPciBkb2VzIGl0IGhhdmUgc29tZQ0KcGl0ZmFsbCB0
aGF0IEknbSBtaXNzaW5nPw0KDQpSZWdhcmRzLA0KRGFuaWVsZQ0KDQoNCg==

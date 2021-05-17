Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DE2C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BBDF61285
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 22:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238122AbhEQWWH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 18:22:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:46585 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243165AbhEQWWG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 18:22:06 -0400
IronPort-SDR: 8t8isNY7xJJdgX+L890jTvXNbP72xQ4PcNXil1z5tHWW+r8+Fqg/5hSunW9GXekD/5uv77xPAP
 l+4/BfIuLJpw==
X-IronPort-AV: E=McAfee;i="6200,9189,9987"; a="200631529"
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="200631529"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 15:20:48 -0700
IronPort-SDR: pDjrXG92NRs1k0tRzwL/caPkAQyYY/kvfZ51SoBfikfUJ/NDmG0avOA0kVIpHdv2TdmXtgJ5Mf
 a/+XL6fRp32w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,307,1613462400"; 
   d="scan'208";a="438373477"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 May 2021 15:20:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 17 May 2021 15:20:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 17 May 2021 15:20:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 17 May 2021 15:20:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 17 May 2021 15:20:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUXu6ggoYO/s24fG+6Gs2UHdxPzP88ty7bRR1Kw99Ro7GXhfWRI89zXUGD7ROXVYVYVcAxdzw4IAkCGrFA782U/BcyQ/MKTuVAg/ojVbPf2DQjxngVI0EtbwLAyUC6+aY3j5tUKtMoospB5QZT40dC1tWTvTkjmsHAZE2QaBN6KasErrIqycU8G+eQKIng4VxBV2B2nwp/fzDVpmT6vo8hbGWHUWgE8VamC04ebBniDZXeoX80bVqUPXaoqHYAP8Q1WuPLqAJUWKhdlGLRWefv9YYdvyNaQD2gVFk8sk1BQzytYpGeSj0Bb/ZWmlMF33JRusCPjsormct3s2cttdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93iLbr7qgk+bT7oLIw0SGCerZToGxrKX6/hfqvCrJb4=;
 b=B8CvbjdtQedyri97aIlBh2qj+EtJ4hRJQy+JvfGqOaxwp+TLeCdZa0uoZ8JynOAubOn6Hux9RUme5Jz5R33cyrMisKEa2VYXTuS1zShWRN4ofHvxttToIUix+Pz9jpemW7UpevlOyaTxNmPGrFa/FTBoHEQtibCfZE52YKiYowyaB7kKIhuYJCFrzlHW2NFVspBBtqJYFZ1sAkPoSWMY3n2B2fyIzaAHui/Z2QppHudEgiETt0bNdWh5Loa1DJrwPsl815AXafWCQ37pUPvKp7wKrX3JtF7LA5FczWw7bJ9/MRjp1amWUT58k5rTIic9368YKUvkpDRrYA9UIWkTxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93iLbr7qgk+bT7oLIw0SGCerZToGxrKX6/hfqvCrJb4=;
 b=aQq74phxaCeQWfzoLsnxIpKGdXXt0n1dHuQch16+4HhcmetPEHAotk4oZLSzLBXo0Dtiy6BZZMthNmiCxzv4+uTYPg8gUuSjF6for6I3PrMVomWHPS4nqOYb91PxFDbCew23UtpgpAjiFNMEHU11xE5SBXmGcYM1ARlo9fpbrxU=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 22:20:44 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::8878:2a72:7987:673%5]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 22:20:44 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Thread-Topic: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Thread-Index: AQHXSP6j1UZkk9xSxUyblh3IA2amtKroNuiAgAAM1oA=
Date:   Mon, 17 May 2021 22:20:44 +0000
Message-ID: <ED9DFB96-B15E-493F-9089-4B69F5456532@intel.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <20210514201508.27967-11-chang.seok.bae@intel.com>
 <YKLhc6HX9+JunQ/X@gmail.com>
In-Reply-To: <YKLhc6HX9+JunQ/X@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.189.248.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a669604-c7fa-4ddd-ca29-08d9198203b3
x-ms-traffictypediagnostic: PH0PR11MB4902:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB4902007D36070C79092E8B4FD82D9@PH0PR11MB4902.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HoXobY7bhP+xK6e6wp8i4R5hJXqYmSQZsyZgOzqM5ZcyqpEFVDNoBRyjKxDtM4GB34sRKSO8+2PpQdlztpoka2sig31TCQ6sFrIqKmaX3hXsg/EQAaywGSl5xY8gxhzjaKTEfU5QjIak8mWKrZwviSFTOUyxVJgPJK1EYsdf9HICVeI2hCU2hN8KpaDPQYynNfuoYXs6t80+gppzAtiSE+xKacQRqRffalYu15fkg8jTrxjbFvD2O3HWWUaaNv9RQibobw32FbVgk8eOT++HUQt+AHbGPqXcgKmPlDTZG54J2fvoNzguKEkRp7faeHGcP06oJANGtyarv0VAAh32GbeD4tdpWFiPdYsmR6xEuVrQhao+4e01upeTowMnQqkvnn1hQ56gge7d1pLpXct95jBgxv8if7rA5YDZ8fT2oy2X0LfT7ToGOxxLFF9VDUdDb+OHXvB6n6Ca85/is/jLNdx037KifflnJOu5HHp8x+x5WD7pVSc1cCbcujlAqQpKh1Wu+MEkTlhwL7fKBtWORLy5hAdJ64ip5kcUmJIor0uJ4h6ueEG0GYfHvqEXAN0tKzssU8l4No++QOW/1B0yEd0QFMVv3yGBkJLMZ0sHL0xBiXGpkVD+kdYFK9/DbVGj24UEN1IkW/5SHqoR4VlCNj5nNzScgbbMo060Ye6FWCk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(66446008)(64756008)(66946007)(66476007)(4326008)(71200400001)(66556008)(316002)(122000001)(6486002)(26005)(478600001)(4744005)(7416002)(8676002)(2616005)(6506007)(38100700002)(54906003)(6916009)(6512007)(86362001)(2906002)(8936002)(186003)(33656002)(53546011)(76116006)(36756003)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S04xd2JGVUsyTk9OQ2xldFJTTENyK2hxSnFmWCtTMTNXK2QvWUpnbVJlNG9R?=
 =?utf-8?B?SDVJV01FYjhPZXlCVGkvTDZUa2tVcXNBOXJxWmNqU085WDlzZTR1ZTA0SXVF?=
 =?utf-8?B?THNISWNqek0rVEgzWUVpN2szcGN0UDA0QWxDK3FQYjNqWGNFbXIrczN0c0Jy?=
 =?utf-8?B?QjU5c0l3MS9LSzdEcEkyOXkvTWh6eUY5STc5RUg3ZWxSL1BMd1cxSzc5YTVY?=
 =?utf-8?B?dHNDbkt3ck5VWU5tbTU1Q0YwWXJoalVLWkp2TzdGMTA0S3g4ZHdqaHJEYWxk?=
 =?utf-8?B?cjJQc1FNWXo2R3lYejMwTW5SeTBERXpvdkZpZ0tzRlRUVnJlK09oSjF4NGdF?=
 =?utf-8?B?ZkxTTEtDQ0VnMGhGRE5YNzM5SlF4OGhJSzBwL2IxTGpRUS9iSzJrdWYwWVha?=
 =?utf-8?B?T3NUUWVNWUJYUmdLTlZXMTJhWmV6TVpsMnp3eU1sUmw4YnpEOWVkWXRZRGUv?=
 =?utf-8?B?bytVV0dFY0VUbkdXVi9BMlZ6cG03c3JsT0ZFN3dOenJZNDREUU5yM3I2c3k3?=
 =?utf-8?B?TTRseHA0ZU9RUG4rTnRuU3A2YWZtY1BMRitReWpEYTY3RkY4K1Nhd3k1MmFi?=
 =?utf-8?B?SFpYRkJrcDNNL3RYUGh1YVdPNEQrVTNDTXZhUTFoUEh4bS9Wd1pBWkZIRHpC?=
 =?utf-8?B?MXlBRlc4ZHczcW1QNXpSaUppSG9pYmJYa0U5aGNMbDY3K3NtSlY5WDJWN2c5?=
 =?utf-8?B?ZWFMaGp3SFVvWVhpMGpFbVVJc001d01vYzByc0VpSEN1bVFGZXdqNS9CUW5C?=
 =?utf-8?B?SU5wMnZzekFzNjFWRms5dEdkRkhmSmducmNBMG1zdWg4b3VuRlpvUTRVTzE3?=
 =?utf-8?B?Qy9hNmRkTDR4bk1xN2lYU2g2NWZvMXc5ZGN2Vm1aMGFwUCtlRzZRNkk3eElB?=
 =?utf-8?B?ZkMzazRnYmJoUVN2MnRDVnZ2bENVWEZGcyt0MlpvUENWWVZsVkVhS0lOME1s?=
 =?utf-8?B?dG5ldk9LbndrQ1JrMFkzaFF4blYzT0VsclAwdUxpRCt1RUlSU2dMNy9nMnp6?=
 =?utf-8?B?dHp3RkxORlpDWlBFNzVKWHBuWnM2OTF3VDE3dTRwRjJtcDB3cVdTVHBYemNT?=
 =?utf-8?B?VnJBbzBqVy9CSkZiSEZQeTllcG55YXMxdkovcWwwTTlOUHNqK0EwcTZuWGdw?=
 =?utf-8?B?RkRQZkVGMGNOSnB3bUtOSUh6OEllSmxyODRQeXdyMlFIMzZUNzBadzhBNDBu?=
 =?utf-8?B?aDJjN05ZUmtDcnRQRUpqZlBkL3FZYkpLWlUrbEMvQXE2TnBzNktiVnJVVFJV?=
 =?utf-8?B?ZFJwSjkrNFZOekdYQ3c5NlBjaE4vSDBIMXpMM2FYNHJSVlgvSXE2RE9JUGJF?=
 =?utf-8?B?ZmZ2YVd5bTBFazBrYWpJeUNVS3QyS21FbDJKZmZhTVp4M3dUUVVFby9ONEsy?=
 =?utf-8?B?NkUwRlg2TW85UHo0Q2NueVArR3hLOGR3S0FFMWF4L052VkhReFpoejhGKzRk?=
 =?utf-8?B?aDVjNFdMNEdncFpyYzl1R2lxTVFzdlRmeGNJbnVPUjhRSG5KWlVlclRZdHpN?=
 =?utf-8?B?SHQ3TThkS2JTRVEydEp0aDFzc1g2NStKWjlFSXRXVlErbTNOMkVYVnF1RnRN?=
 =?utf-8?B?UUpyNklyUDhGNFpOMVpYWWNVVzIxam1YWmJzK25WU0hmNFFFbGdwdWl5eTV3?=
 =?utf-8?B?Q0djOHg3dXJ6c2hRTmY5WUcxR25LRW1lVUswS2FEYy95MjdJdGlGNlRRTEFJ?=
 =?utf-8?B?aWF5NXNUcXJ3M2JlL2E4UUFpM3lOZEVWL2owNWdHS1B3RnIzZWcvcm9Rb3Vs?=
 =?utf-8?Q?ZDwjvn3oE9WcCP1QB233nKl0uAlVFuS/pXN96qc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82823B00F9E3ED4C92C7EAC80E68A56B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a669604-c7fa-4ddd-ca29-08d9198203b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 22:20:44.6709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wnzUf4RBctCYCWYzfkZX2yLpJ1DCKzb4UGhlwZNBcotScPXZxzdCMn96UazWkbl9L3j/fuMvYImgCq4n7tpQkTeI54lpRy5FNSY9qy++xgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gTWF5IDE3LCAyMDIxLCBhdCAxNDozNCwgRXJpYyBCaWdnZXJzIDxlYmlnZ2Vyc0BrZXJuZWwu
b3JnPiB3cm90ZToNCj4gT24gRnJpLCBNYXkgMTQsIDIwMjEgYXQgMDE6MTU6MDdQTSAtMDcwMCwg
Q2hhbmcgUy4gQmFlIHdyb3RlOg0KPj4gSW5jbHVkZWQgYXJlIG1ldGhvZHMgZm9yIEVDQiwgQ0JD
LCBDVFIsIGFuZCBYVFMgbW9kZXMuIFRoZXkgYXJlIG5vdA0KPj4gY29tcGF0aWJsZSB3aXRoIG90
aGVyIGltcGxlbWVudGF0aW9ucyBhcyByZWZlcmVuY2luZyBhbiBlbmNyeXB0ZWQgZm9ybQ0KPj4g
b25seS4NCj4gDQo+IFlvdXIgY29kZSB1c2VzIHRoZSBzdGFuZGFyZCBhbGdvcml0aG0gbmFtZXMg
bGlrZSBjYmMoYWVzKSwgd2hpY2ggaW1wbGllcyB0aGF0IGl0DQo+IGlzIGNvbXBhdGlibGUgd2l0
aCB0aGUgc3RhbmRhcmQgY2JjKGFlcykuICBTbyB3aGljaCBpcyBpdCAtLSBjb21wYXRpYmxlIG9y
IG5vdA0KPiBjb21wYXRpYmxlIC0tIGFuZCBpZiBpdCBpc24ndCBjb21wYXRpYmxlLCB3aGF0IGlz
IHRoZSBleHBlY3RlZCB1c2UgY2FzZT8NCg0KWWVzLCBpdCBwcm92aWRlcyBBRVMtQ0JDIGZ1bmN0
aW9uYWxpdHkuIFdlbGwsIGl0IHdhcyBpbnRlbmRlZCB0byBhdm9pZCBtaXhlZA0KdXNlIG9mIGZ1
bmN0aW9ucyAtLSBzZXRrZXkoKSwgZGVjcnlwdCgpLCBhbmQgZW5jcnlwdCgpIC0tIGZyb20gb3Ro
ZXJzLg0KUGVyaGFwcywgcmV3cml0ZSB0aGlzIGFzOg0KDQogIEVhY2ggbWV0aG9kIHNob3VsZCBu
b3QgYmUgdXNlZCBhbG9uZyB3aXRoIG90aGVyIGltcGxlbWVudGF0aW9ucycuIEUuZy4sIEtM4oCZ
cw0KICBzZXRrZXkoKSBvdXRwdXQgY2Fu4oCZdCBiZSB1c2VkIHRvIHRoZSBpbnB1dCB0byB0aGUg
ZW5jcnlwdCgpIG1ldGhvZCBvZiBBRVMtTkkgb3INCiAgZ2VuZXJpYyBpbXBsZW1lbnRhdGlvbi4N
Cg0KVGhhbmtzLA0KQ2hhbmc=

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F04C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 10:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 892A160EBD
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Nov 2021 10:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhKDKSS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 06:18:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:1143 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230101AbhKDKSS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 06:18:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="211730382"
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="211730382"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 03:15:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,208,1631602800"; 
   d="scan'208";a="729247915"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 04 Nov 2021 03:15:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 03:15:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 4 Nov 2021 03:15:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 4 Nov 2021 03:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcyu1MNwZJBPv2z0l2c5r7Oyr7Hqi4UTflp/HX/tnUFGWZ8nPPMvJ/WOqWCIq61zKqg/kwaHspmsODUfag9e7Zi/DWOIIQPgubISp0Cd0ss+AS8CyYIl2q+GI7RMptkbStpPtlTk7UzugyZYU8Eo5Uo0/Tn/3weZ90PSo3kLrUgFDwfdyjJYX7aFz8SpMKpyZXH1/4h3CM+qAfe0R1GMc/D/V9AHHU9y4FjnYhYjjAGq44EomU4ZaeBMP5bDAJPfOR2YZW/s4QN2H4U2McoWWam6Oue9YzoNNxSv62uJ94Zn/RvmNi3NcDxTGO/xVnDughti07lH8iwS5OYqUpH38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4l67ov3eqJbu1FehVIRkaV0PvDrCAM2+Pwf6cpvYKLI=;
 b=fUvvYtNHFBjN+nukE9Z4PlOtVrf5xUC9FQE4fNGPr8uadmOnnEHXvT/wd2G4KXZPzHckb/fDhulqM03tT2l9z4StQKkpHAgX1rcpSe+yXIy5zm9KIK90f6fGjc6/INpMRIkpqjodI8iI+3LMzRM38RsHH6bUppojVFy26LnTI/nDoFnq6RDAPh32k3fmQxBg0tFYKTxhiORiyCy4elps3JxbYN6/C0/6+ufHUjYnc0LO+d6fE+fW7K04/5zvDIO+4l8Ww4NeUjf0nYYsCusADrsNi6LXSIoVJqFAEloQfHyS/xDhGbHO8/d4WDfmiWekXyep2FtqCE5v6RwEEkTgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l67ov3eqJbu1FehVIRkaV0PvDrCAM2+Pwf6cpvYKLI=;
 b=Bk/hSxmCuJA7mv3zfbvLjtgiqpKHGwrmfiGKzSrPfpzGC02uLHtbuHWhtdqQpmneGqbtwTXSltOgr6xKfJ3+DEere2miFWC3P3YsmyOjAktE8zyR7u/oiwwlawy5s9vC2EFXdUKYUWy0EIfGrH+IYAhuOxIjcymiKTZf83PRiRY=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB2831.namprd11.prod.outlook.com (2603:10b6:805:56::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Thu, 4 Nov
 2021 10:15:38 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::a403:ed38:5a4d:c366]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::a403:ed38:5a4d:c366%7]) with mapi id 15.20.4649.021; Thu, 4 Nov 2021
 10:15:38 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Murphy, Declan" <declan.murphy@intel.com>,
        "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: rectify entry for INTEL KEEM BAY OCS ECC
 CRYPTO DRIVER
Thread-Topic: [PATCH] MAINTAINERS: rectify entry for INTEL KEEM BAY OCS ECC
 CRYPTO DRIVER
Thread-Index: AQHX0JfTPMdyxINzUEOfpaqMpgEmgavzKKEA
Date:   Thu, 4 Nov 2021 10:15:38 +0000
Message-ID: <fd122a44fd4b21785b853e4259d00584caa10f25.camel@intel.com>
References: <20211103094711.8844-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20211103094711.8844-1-lukas.bulwahn@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1da4b6f4-481f-48fe-a6f1-08d99f7c0ca2
x-ms-traffictypediagnostic: SN6PR11MB2831:
x-microsoft-antispam-prvs: <SN6PR11MB28319D95E13D2E2E1E78F378F28D9@SN6PR11MB2831.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w1AoHSxQyUsnwDMTz2rI93yUiGaLkgKq4rR2ZTUYP0hU7e2Xc7sj6+G+YBzca+lLTPUcG3ARxLyHgfgy+wf+2wOcszFFImMunr2/6R/Zxv1HqghyCsnUgZzJyAAAld1cvx87iUICCfU/GonHxsIlZ95Ss9H+yFByILvpsPN7KQ9nzSCtKoVOJs5AoMs5ki9h4xlTTLyX+GOLKZ3gFBxpqCDfxhLvinvzDc4TFT2vkqxdPPGlxOisYs6clZ57WFpoSc/jA+IjPk8K4X5XLGbajXqdWCrfsRu3zjyBZAuKo0vlfHVKSlKOQTwts/VEgtu2qlYaARZAdmoC9a9D08UGJM212ImNmodaRhiZsPLM0zhX9fuQ9AKLwbDE/5LOkgH7icWM3F3wMNsqS9qOqXY3JWbEs9Udj2BjidZpbM7TCUfvdYrMyiW4G/x3uJD9l1jBfnuUemql8wmJ8P89aKV9gCm6+jqNm4S4JfVMDcZWq80aISvpSKYF+ck7Gi++v8M67oJLVwDvIy+jcIXlJwtnkBxKHewwExgoBhaj4liyiFPp6hSCTkuQl+kVuQ+tXFvNu7qJzCe+vY4g0O3ipEVd0OnrSfgUQCIy+MUfUIrNmpJHlHnefvCi9GLMUt8JYEjHrYL+n8CpHjnTnns2phl2tHlj8iJDHLT5DcHVP4zmmN6tzaR/PmJmjSjPHd0BiKZ+w6V0D8tYGe2ueju/pZbJyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(110136005)(5660300002)(4326008)(86362001)(38070700005)(6486002)(36756003)(2616005)(54906003)(82960400001)(38100700002)(316002)(76116006)(91956017)(8676002)(2906002)(8936002)(122000001)(26005)(6512007)(508600001)(71200400001)(66946007)(66476007)(66556008)(64756008)(66446008)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0pRUzEzYmtEMC9nVE84T1E0ZFQwendOUGtXeTJFK3hUSm1ic3JzRmRyNUhU?=
 =?utf-8?B?T3FEWkxQVlhsMHNEdytaWGhkZDhlVHpjaFRBZjA4bnYzSlRyN0JuVEtHWFNh?=
 =?utf-8?B?VzFmOHNsa1JSQWVNZmNmTE4vYnVaWWtKSFVTWFhNSHZWMFM5ZTAxelFnNldp?=
 =?utf-8?B?NnR0dzA3Qis1ZDdmWjNKVTNsVHFBc1c2SFo0b29XSmZYT1RURGtJYWxsSGJ1?=
 =?utf-8?B?dVR6M09PQkdDa0VVRTlsWTVIRTllOHl3NjArU1VuTWhCM3ZmMWo5SHhPVHgw?=
 =?utf-8?B?cjNHdUxDVmNxdUc0RVo1SUZadWVpbGlVdGJlT0NSSjhsczl6V2c2ajdTMTB4?=
 =?utf-8?B?eHNwUWt0Tit4MEx3cHQzZ21NVmF0dTlNZTh6V3RnVE4yallKWERtb3htYU9a?=
 =?utf-8?B?M05wQi9WUEJmNEFhV1ZaanFLT1RONEtFR2dOaHh5K2VTL05pK0RwQUpibFkz?=
 =?utf-8?B?eTFiZHR6UWFtaHVPdDZkWU52TnBZZFRldnk0R0hwU2ljNStsRmVrWk01bUl6?=
 =?utf-8?B?RWdnaXVMc1VCa3JndXdFL3ptNE91YVEzSyt4bjFRWFAxanBjcGo1cjJKa2o5?=
 =?utf-8?B?d3BLb0hEUlVvMGZucWw0Z3ZNZVVTM2UzQXMrZEQxbGRYb203UUFoWVl5ck9D?=
 =?utf-8?B?L0RDTlhMUW44NnBSY2c2RjlPcXVIcVdtKzYrVTNqWUpsRFYrb0lUQjgxVHJP?=
 =?utf-8?B?a0VUbDJyMFc2ZUtNWkFRejBLaGNHZVJVSmVDa3JpUjVZM3VyK25OSzRNbGVK?=
 =?utf-8?B?d0U5OEFqR2Y0RUN1UFBsa1AxYURaWThsaDlyeTZNc0ppZ3JxNnVCNFlPQ3ha?=
 =?utf-8?B?MVhOUkFjSGdGR2xQV1VtVFBBcWVhc1EwNEMvdU1PSkwxWE9UUzU0TWNLUWZM?=
 =?utf-8?B?clAxMTVuRTdxV3ZVVWlWZmFuSDZsNnozbnRjQkl4MDdiK3lOZm55Z09sc2ly?=
 =?utf-8?B?b0ZVM3lMUEhiVVRQNy9lQ3QwSzhubC9CYzlWQlpQY2ZUMGljdVlHYzluMVpi?=
 =?utf-8?B?NXdER2orSTFIejJqMDU1eHdBV2ZOcUEyejhqWDZNSmt2WkQxQnBTYkY5bHM2?=
 =?utf-8?B?N09FWVVLS2RKOFpYTXl3MGx0VExOMFlmVE5qQUpqSUpDVmZHa2IyZ0JsNkVt?=
 =?utf-8?B?dWhoTWtBRWhHTVNRaGJYd1pRdGVKOGVjUDU5T01GU1FKL1JVRGUvZGZoV1J1?=
 =?utf-8?B?bllXUlNEc3RLbU1tYi9qdm5uaVdIRHN6eWZ4QUtzV0QrdVhKKzJmeVpIUnFx?=
 =?utf-8?B?SGxGd3ZPandpeEZSZzlRVU94VVp2aVZYTlZTVEpRbmozNHcxLzY0a09UenVz?=
 =?utf-8?B?VTNVamk0RDNFNU15aVBjVkYxYVhCZW5GRks4UVIzM2puZmZpdVdISmpveDlB?=
 =?utf-8?B?S3g5QWEvYmFRU3R4VzhMK2VVS1g3dU1LY1RzeTdzNk5MRGl0V0Ywb1pkeGg1?=
 =?utf-8?B?aG9tVTRjd1BmaDVMMjM4c0JjSWViUEM3Q2thR1d4cEsyMlhPU2NDVmpaWG9B?=
 =?utf-8?B?TFVJZk5CUGRCWTRjVUVRVWwrZ2hzMVVUL2lVRWNTc0V1VjFYM202dnZXVTIr?=
 =?utf-8?B?dFkzTW4wTUVZbno4M1hXRHJWNy9tUUQrbHRqSXZ1bnZqRUhVU1BCRW9rSHZs?=
 =?utf-8?B?L1ZrNUpxYWxta1dxeERUUWFOVi9KcVcrdGwzazR2c3FoRE5sczRPdXhocGRE?=
 =?utf-8?B?RE5mdXlCVnUrMzlSUnQyOW9kdWNhRTN5Q0VTQndnQVdEVnQyVjU2WjNLN2l1?=
 =?utf-8?B?TkY3ZkdjYXMvQXB1b0dKV25SS3lESXhOUjBNbSt6MXAyN3RYd3p6R2luTWNF?=
 =?utf-8?B?bGhpNUlDd01OczA0d0gzUndIWkkyVXpnZzNJalpJUHJDNW1BK0lnQXZSVnND?=
 =?utf-8?B?TUZ0T3czbnFUK0FnWUhlRE9LVHhyV1hSbHc5RGxRUkVuWm1RZE80Z0trV2JQ?=
 =?utf-8?B?WWp3M2w1ZFJFSjFzWFczQUltRXJlWTFqSjJ2VzMwWlcxblJhNzN5K1ZveGYy?=
 =?utf-8?B?NTNCUEtHc1BCQ25MZkluc1k3ZjVxZGhKby9tbE5WOUt1VmIxd3FZZUhyOTZm?=
 =?utf-8?B?WHQ4ZnYrdndsaWtiVjBkSlJUYjk2akpoSGFoM3VhTTZFdzE3TWI1aW83Qktm?=
 =?utf-8?B?cEJuWmcrOGY1ZzJRbTJEdGw5dDdadUhWTm5tcDQ2ejk0dE1mc09kY1diQ2Rs?=
 =?utf-8?B?Vk56QWtyYURjWHo2aVIzKzlvYmxwVVM3Q3MrM2g0dm1VTHpNeEtEcnNOelUx?=
 =?utf-8?Q?T/DqCKLBHjFvxtNOdw2Nt5TT1JD3uLuqT8SdLFq04o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17F7B07ACDB5BE40A8A6A7B4BA83C276@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da4b6f4-481f-48fe-a6f1-08d99f7c0ca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 10:15:38.5623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PT9dgVGIZHBglrGRe7OlqtWIY7Ak4lwPKDd7dGwmjHAEht8w2y9xjz/phO5abkoNXdvwCVBknAyfMBxfoUH4uCElQjnJZV8F2Z50Qzbxl24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2831
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgTHVrYXMsDQoNCk9uIFdlZCwgMjAyMS0xMS0wMyBhdCAxMDo0NyArMDEwMCwgTHVrYXMgQnVs
d2FobiB3cm90ZToNCj4gQ29tbWl0IGM5ZjYwOGMzODAwOSAoImNyeXB0bzoga2VlbWJheS1vY3Mt
ZWNjIC0gQWRkIEtlZW0gQmF5IE9DUyBFQ0MNCj4gRHJpdmVyIikgb25seSBhZGRzIGRyaXZlcnMv
Y3J5cHRvL2tlZW1iYXkva2VlbWJheS1vY3MtZWNjLmMsIGJ1dCBhZGRzIGENCj4gZmlsZSBlbnRy
eSBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1lY2MtY3VydmUtZGVmcy5oIGluIE1BSU5UQUlO
RVJTLg0KPiANCj4gSGVuY2UsIC4vc2NyaXB0cy9nZXRfbWFpbnRhaW5lci5wbCAtLXNlbGYtdGVz
dD1wYXR0ZXJucyB3YXJuczoNCj4gDQo+IMKgIHdhcm5pbmc6IG5vIGZpbGUgbWF0Y2hlc8KgIEY6
wqAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtZWNjLWN1cnZlLWRlZnMuaA0KPiANCj4gQXNz
dW1pbmcgdGhhdCB0aGlzIGhlYWRlciBpcyBvYnNvbGV0ZSBhbmQgd2lsbCBub3QgYmUgaW5jbHVk
ZWQgaW4gdGhlDQo+IHJlcG9zaXRvcnksIHJlbW92ZSB0aGUgdW5uZWVkZWQgZmlsZSBlbnRyeSBm
cm9tIE1BSU5UQUlORVJTLg0KDQpNeSBiYWQsIHRoYXQgaGVhZGVyIHdhcyBpbiBhIHByZXZpb3Vz
IHZlcnNpb24gb2YgdGhlIHBhdGNoc2V0IGJ1dCB3YXMNCmV2ZW50dWFsbHkgZHJvcHBlZCBhbmQg
SSBmb3Jnb3QgdG8gcmVtb3ZlIGl0IGZyb20gdGhlIE1BSU5UQUlORVJTIGZpbGUuDQoNClRoYW5r
cyBmb3IgcmVwb3J0aW5nIGFuZCBmaXhpbmcgdGhpcy4NCg0KUmV2aWV3ZWQtYnk6IERhbmllbGUg
QWxlc3NhbmRyZWxsaSA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4NCg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogTHVrYXMgQnVsd2FobiA8bHVrYXMuYnVsd2FobkBnbWFpbC5jb20+DQo+
IC0tLQ0KPiDCoE1BSU5UQUlORVJTIHwgMSAtDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRp
b24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQo+IGlu
ZGV4IGJhOWY2NTM3YWJjMy4uMWZiMjU0YWExMmQxIDEwMDY0NA0KPiAtLS0gYS9NQUlOVEFJTkVS
Uw0KPiArKysgYi9NQUlOVEFJTkVSUw0KPiBAQCAtOTY3MSw3ICs5NjcxLDYgQEAgRjrCoMKgwqDC
oMKgwqDCoMKgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2NyeXB0by9pbnRlbCxr
ZWVtYmF5LW9jcy1lY2MueWFtbA0KPiDCoEY6wqDCoMKgwqDCoGRyaXZlcnMvY3J5cHRvL2tlZW1i
YXkvS2NvbmZpZw0KPiDCoEY6wqDCoMKgwqDCoGRyaXZlcnMvY3J5cHRvL2tlZW1iYXkvTWFrZWZp
bGUNCj4gwqBGOsKgwqDCoMKgwqBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L2tlZW1iYXktb2NzLWVj
Yy5jDQo+IC1GOsKgwqDCoMKgwqBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1lY2MtY3VydmUt
ZGVmcy5oDQo+IMKgDQo+IMKgSU5URUwgS0VFTSBCQVkgT0NTIEhDVSBDUllQVE8gRFJJVkVSDQo+
IMKgTTrCoMKgwqDCoMKgRGFuaWVsZSBBbGVzc2FuZHJlbGxpIDxkYW5pZWxlLmFsZXNzYW5kcmVs
bGlAaW50ZWwuY29tPg0KDQo=

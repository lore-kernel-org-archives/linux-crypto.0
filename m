Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8F7C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 10:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B07960EBB
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 10:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhKBKR1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 06:17:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:35556 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhKBKR0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 06:17:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="218419421"
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="218419421"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 03:11:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="559949088"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2021 03:11:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 03:11:16 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 03:11:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 2 Nov 2021 03:11:16 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 2 Nov 2021 03:11:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwoXM/LmNqHtV6kcyE7XzPhb7Wbg0RxbIyAul1OG02d+XU5ER+7tqTxTngnBMtxg+Y5JO3e2ncoIXpKCN87I9dLJjTRGi88JF9ev1N96BBFJ5AIZKNfJ/fZSfv7PjGDRHOZ1wNXa/SfuN4/n6H6x9iQJoRZwp59gar8dtM6cSV7SymKoq5LufrDWfVAey1sLWDUICEveXRHmhvDoPmXK2jWSRus7IZKpEmb9P3rXWTxGUX0DYw4s/wTX4S/S8hORug8mIKWFBgumnQfBwVnR5FttFKuZVcuuKi+QNo+Ko5RFY7zCtgP+VpCemXWcLcwb7wVEQhQC2GYqN1g7e/ANew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CbW9vhZ6whI63lsednBwS/Rcz5d0Z4D5pBvIoFFoNuQ=;
 b=PiKwgIVeB5VKp0HL2LHX3QuyVdtzPSRiNktfM08M3nihBPnj8k1CnIf7Uvw0G5Nh1iReoPE1uG6p9fRibY7GWHOKQNOAqBpo/pqP1oUf49m9rS7eup1fniueX74eiuR0jNDY5ypYVcUT1mYBlDIVVB0faiEDBzRZdJO+OABtBtQ3wIBpihB70jCDk54eOg3avp07YiUNFdRxQ/GBiG4+mFCPvkvGmbP/Hk5TznQmdA/QS1yuuwgifMPCRIBdS+DxwgTiQz4gfm121dq3B4zs9sd1362gPW4paxN/9+/qyAfBrdgd43+xAQ3jfpzYO8ffmg/G1zwt6Aab/p8+aB+3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CbW9vhZ6whI63lsednBwS/Rcz5d0Z4D5pBvIoFFoNuQ=;
 b=W4qfag5Eh4BVkKzNnc/poKVXe+hvmpwj7iEnLkRu1OOrUcLX7FHpfAc9OTeaS0R3Us9ofn9Of2vi3aVYW8wiI2jzZ6vbpDD9jg0vphi+IYVeb6GseLC4uPn2AmejAfVtOhuq/NOdHO8nrULSaZFm1Lc1MTSulQq9TA92purgPcs=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 10:11:15 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::a403:ed38:5a4d:c366]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::a403:ed38:5a4d:c366%7]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 10:11:15 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "hulkci@huawei.com" <hulkci@huawei.com>
Subject: Re: [PATCH -next] crypto: keembay-ocs-ecc - Fix error return code in
 kmb_ocs_ecc_probe()
Thread-Topic: [PATCH -next] crypto: keembay-ocs-ecc - Fix error return code in
 kmb_ocs_ecc_probe()
Thread-Index: AQHXzydH/zukDrjlwEO1QAdgG4VUSKvwBZ+A
Date:   Tue, 2 Nov 2021 10:11:15 +0000
Message-ID: <399748982971320015c0af2ec69b6d7efd68727c.camel@intel.com>
References: <20211101140233.777222-1-weiyongjun1@huawei.com>
In-Reply-To: <20211101140233.777222-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e5cc36b-2887-4ea9-96d0-08d99de91b0b
x-ms-traffictypediagnostic: SA0PR11MB4717:
x-microsoft-antispam-prvs: <SA0PR11MB47172E4DC672B412F2B32C03F28B9@SA0PR11MB4717.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gsBlib6YC73BWYCCZQV3CNaIFbuCeo8yznLsRBfIp9+SqpL1BqFiSROldque3yZ1lsQJK2pUZkZaaTbm2kz7MVmS5l7SuF5De8KdZjR7DkpjmHsMJXJIxODeKJX2JQlRh3O5xVVAoQkaebvnXG1vihP/FuyI59zBIfMIB8JVZr1meRgvnuPsO+qmHzN2EEqJ0Gp8UGbQQmAy1hHvYBiF7Z2geWec9t8ScVONMA2odadmrpqNGc//e3zkkX+KUkl2lKhZ73FVrDpEHkk1zZHsHO7z7QxXIrWsyxV3rbASETyfG0dsBgMu3hNvUUN7kfzufmaJtEER0N2cBTiZTp7RUL2qKoKj1rxApXbr8YU8wHgbH9grLDAkF0xb3kUQenVt62pgraG0XxgEwNTEqSbRulqdZAqJSZd76fDskUWFVBen7s1Frys6sX7fxsuNlEhQ2mLB9uxr9zUqsTsRcq0sdipOziIOFEgcrG8SdkLAei6WqUVnyGh4EL/MhcIV+3/EzACme/r33kl0eBsUiIkpgy6AtTISfeQ7fpFCN9OQ0da/ClWlyYK1/EX+TgvoVw5fx4tgy676Bo729gR64kXRbuPnKmbnIjH0fwhFwIZWm3HDwMZX0TsGgwDrtUmKoAEhjb8aztzlt0AOx++/AcNHNhBHzJgXYWi4bvFS7wJLJ6mtjVPbG6MWOfOh66JQJUnK3MIC4iiwEZ6NpsOReeh4xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4744005)(66946007)(82960400001)(2906002)(91956017)(76116006)(508600001)(6486002)(8676002)(86362001)(36756003)(6512007)(316002)(2616005)(54906003)(186003)(5660300002)(71200400001)(6506007)(122000001)(38100700002)(66476007)(66556008)(66446008)(4326008)(64756008)(38070700005)(110136005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGxTZExCYU9JZkh1bkNLS0RXOG4za1NPVVdvdHA3UDVCUWlnUy9McVozV1Jo?=
 =?utf-8?B?SU5QNWVtMU1LOERZT1ZRaldWaWIvNkxBVzBjenUxNldJM0RiQWRSb3JQdkpJ?=
 =?utf-8?B?Q0Z2RHRpNGYxSkR6YitkaUFFVE5BZ25SUFI2eHlHSXpKR1VOd1A3MHBUelZp?=
 =?utf-8?B?cHdNcTBScENYZ0lWNzVDbzQyRkYxdnllRDQxUk9UT1d2a3paN1JmQ1FlUHkz?=
 =?utf-8?B?eDIzYWx2bHpEUHplM1lyTkg0RnliRE1VTzNKSzhmWFZEVmhRbU5WZ1lqUXcy?=
 =?utf-8?B?VFBwUzhLeFVsWjRjNDJnK0w3NUZHM1dJVDhjdk0yTEloNjJVWVg2MitMaFQv?=
 =?utf-8?B?eTJHSFdCVEFlR2o2bndTMUJjajJGQWZVVFVsL1hpU2c4MkJScm1ndjFqcTdO?=
 =?utf-8?B?SDRab0pzc2dIbWFMalF1Y3M4dnFPeC9ROVN0U3ZISFBFdXUxMmF0MDRSTDh1?=
 =?utf-8?B?eFpHYThzSzVVL0tYZktNaTl4VjY5UEdwZHYwQkpVTEZIQ1JHU0hpMU5OS2wx?=
 =?utf-8?B?MTF2UTJLRVhTS29SWCsrUnl5L3pvd2tNTUxaejd3bWg2UjBPakJBRi84eFp0?=
 =?utf-8?B?SmpMNmdrVXViNXQxdkRZRmxNS2xsUkYrNDJPWmtUYXhBT2NKaEcwTjJLYXl0?=
 =?utf-8?B?OTdlcjNudEFQVHNra0pDNUlFUWVhVGFabTVxS1plbUpEdUsyOUhEN1JPemU5?=
 =?utf-8?B?L3V0dkQzWVAyZEdHa3FoZ05PelJSbmhnR1BzWHZ1ZVVkdFBGRGtla3ptbFo1?=
 =?utf-8?B?WGxwNjcyWU52alFtWG96TytNT0Z0d3c3L3d2SkozcTk1d0Z4dy92eW1oUXRJ?=
 =?utf-8?B?bHQ2WnplcVV4TGZZTjFFU3hqNW5xejVDNDd4aTdrM1NScDdaNFd6MkFQMlhu?=
 =?utf-8?B?aThDdHpPSmpUT3JnbjRyV05mMWlTVTIxa0hNbUdvTDVKajhheEM0dGxNRjUz?=
 =?utf-8?B?QVNSRFFEcnJxV29RUkhObUVkbVZJdTlsUjVzeDNaRUJjbVlMVEp3MXcwSjJ3?=
 =?utf-8?B?Q1JCSEdjcGp6VkJYRFh1aUZ3SnJyWU1sU3c2YktMQVFJRWpKbWloc0R3MmxD?=
 =?utf-8?B?Q3ZSRFQ5ekQrdjZIU2NNd3B2S01jQnAzcFc5ajJTWjVTS2FsSmtjb1ZKMVQz?=
 =?utf-8?B?V2VtUWhXaTVWNmlnNjYxUlNjVGFZQ25GSVZFZFIvZlFLUDR3Q2gvZEg0Yi96?=
 =?utf-8?B?UVJJdnpGbWtpOXZGSit5M2ttc3RMelBwSEdLRjRRdVJEazFEZ1NJSFNKaFBi?=
 =?utf-8?B?aWZseWNaTWJaWXprS1dScmJzUzV3dlZYN2NvR1JMaVdRVFVLSllGNEorODRs?=
 =?utf-8?B?ZG5jMnRVSGlpT1dNRE10Uy9EOTZMK21ydXdXclZVcXp3NEMxK0NOU0FwM0xh?=
 =?utf-8?B?VmdmZEFGRXZxZVc3MHUwVjh2cWdaRXE5NmZDaUM1V1VkYjVMODFOQW8vSGFa?=
 =?utf-8?B?dFQ3aW1sbE5Lb3RPUWh3Z3licmkxaC9mblloc0FYZXBuZ2h1MFRZc1VGbzdx?=
 =?utf-8?B?YVZOYUJKVXhZelhFL0FmNWVFWGhjb1RLZUJiaXMxVUp1OWt6WDRBR0psS214?=
 =?utf-8?B?bzNhSVp2WUhVU3hHR1lHV0JaUm9qZXprQmVoTWVDQTMzZEpYY053eTF6dHpQ?=
 =?utf-8?B?TTJhWFJBWUV6TFhkazhSRkp0cXdWdXo0WHY4SWlrOHlDOVV4V2NMUVlaZjJy?=
 =?utf-8?B?VXlpcVRmOThiVFBZaUdKY3hmVGJqM1BkMkZWUnR4N0pudzVaWEtLb0UwWnll?=
 =?utf-8?B?SGFzY2pFbE50TUQrRXhncFo1T0QzbU41VGFEdXR4Z2JmRElld1ZwMGZFYUZn?=
 =?utf-8?B?emZwWHVJUzF3cjNWUGxqOXdvT3U1WncybVdjcHhWdVh6eGpNS2Q0OVFrajA4?=
 =?utf-8?B?ZUlMRGNMNGd2cnJiK3ZVVUlLa01EbzFib1RnazExcmJhYTMyRUtYdnVaWVE3?=
 =?utf-8?B?MVBpWUUvczJwSVk0OU1NQ0kvaFc3VFBCRUJlWERsVnRCaFpxakZLOXk1ellM?=
 =?utf-8?B?eXV5bGg2a0pPWGt4TjlOTnJRS2ZFUkVBUnF6UkdBWDBqaEY2aFdTUnRiVzNy?=
 =?utf-8?B?UFd4MWJQS3dzTTF1RmtVNFBUUkNxeVlaTStXTnJHY213OXVjOUVrN3FxNkd1?=
 =?utf-8?B?T0w2cnJJNmhxdVppK1Y0N09Yb0hFVEdUdW00SUV1V2hNNU1BSk5aM3NyaHor?=
 =?utf-8?B?Q0RoSC9jRzhielcwREI0clFyc0ZTeHdEdlRkaExiaWNhQzZWU215RVhNcDF5?=
 =?utf-8?Q?tUF44ZvmjOnM93Z3PKXeaeTJ9wxoWdQ7REdTOEde+w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B5BFFAE9F0CB754687A4C657E2111C2F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5cc36b-2887-4ea9-96d0-08d99de91b0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 10:11:15.2063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMTCLSIaOqCINX6MwnYMNGotD/XMXTuRQ1gE1L/uTcRRBnLYJc7nn2eIXTt0dS003J3ejACY8NpMq7ENI+HmJ565eYMsqXB2Hny6UL9Pkr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgV2VpLA0KDQpPbiBNb24sIDIwMjEtMTEtMDEgYXQgMTQ6MDIgKzAwMDAsIFdlaSBZb25nanVu
IHdyb3RlOg0KPiBGaXggdG8gcmV0dXJuIG5lZ2F0aXZlIGVycm9yIGNvZGUgLUVOT01FTSBmcm9t
IHRoZSBlcnJvciBoYW5kbGluZw0KPiBjYXNlIGluc3RlYWQgb2YgMCwgYXMgZG9uZSBlbHNld2hl
cmUgaW4gdGhpcyBmdW5jdGlvbi4NCj4gDQo+IEZpeGVzOiBjOWY2MDhjMzgwMDkgKCJjcnlwdG86
IGtlZW1iYXktb2NzLWVjYyAtIEFkZCBLZWVtIEJheSBPQ1MgRUNDIERyaXZlciIpDQo+IFJlcG9y
dGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
V2VpIFlvbmdqdW4gPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMv
Y3J5cHRvL2tlZW1iYXkva2VlbWJheS1vY3MtZWNjLmMgfCAxICsNCj4gwqAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKykNCg0KUmV2aWV3ZWQtYnk6IERhbmllbGUgQWxlc3NhbmRyZWxsaSA8
ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4NCg0KVGhhbmtzIGZvciB0aGUgZml4IQ0K
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8va2VlbWJheS9rZWVtYmF5LW9jcy1l
Y2MuYyBiL2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkva2VlbWJheS1vY3MtZWNjLmMNCj4gaW5kZXgg
Njc5ZTZhZTI5NWUwLi41ZDA3ODVkM2YxYjUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRv
L2tlZW1iYXkva2VlbWJheS1vY3MtZWNjLmMNCj4gKysrIGIvZHJpdmVycy9jcnlwdG8va2VlbWJh
eS9rZWVtYmF5LW9jcy1lY2MuYw0KPiBAQCAtOTMwLDYgKzkzMCw3IEBAIHN0YXRpYyBpbnQga21i
X29jc19lY2NfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gwqDCoMKgwqDC
oMKgwqDCoGVjY19kZXYtPmVuZ2luZSA9IGNyeXB0b19lbmdpbmVfYWxsb2NfaW5pdChkZXYsIDEp
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFlY2NfZGV2LT5lbmdpbmUpIHsNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBhbGxvY2F0ZSBj
cnlwdG8gZW5naW5lXG4iKTsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJjID0g
LUVOT01FTTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIGxpc3RfZGVs
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiDCoA0KPiANCg0K

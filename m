Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB3FC433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 12:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1200864F45
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 12:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhBBMf4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 07:35:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:56361 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231453AbhBBMfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 07:35:52 -0500
IronPort-SDR: zibmNy8N+mHCeFr4jf+DDuV17868QInOwNFBOEi17jDPtaA9PBeUnMYbrjNTjfiTDKVvL3lfQt
 ZUUoDBfir+QA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167951645"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="167951645"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 04:35:28 -0800
IronPort-SDR: mVaB5ErJeYwftsUDXmenLFJL1fUbBd0SS1BK5njXQjVe+VdvMoqrHYZsunP3hfyirxGJPln2o6
 sQAqNx3DrXFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="359030617"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 02 Feb 2021 04:35:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 04:35:27 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 04:35:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Feb 2021 04:35:27 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 2 Feb 2021 04:35:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOUdptgf3kL640TYmOliiGb8OKH04sFE+CizkY0rJy3kekmYW+XxQh0VnNsDSV2ch9Qiqjd6S5wrW22Bnb+MpC4ArHKW0u7zK6yPoP5gZj8ZhRHKU84Nderyt7yDF98iS1H8BhsWxzW1cs3h/7KKQPpQ53vFxQe+38Y7CMkdMzWpGvIGKQu3q7pXmc5FE7shJIdqMw6CTEIjAclSciyXnrnT4Bcnwia7aagKWi49DfVC18MMBBntDdg20dLN+WciOA9fwvt4Ab9wAe9uBy9oZAx5nsnrgDasuXkkqZ3/LA/bskvpebq+XyhbYvXJUf26vInnESMHpXgKR/R5Oy4HsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uAWAby64d+zqP3xvGuT25IkLT165wdIlRdbWeVci98=;
 b=Hi1ytGMrsJ/VQuYqqfX0OSzVwEg/F+HB3RuQul9GKp2x+zqMEgtPD9Ei/SXLPGH4r/t1BAPFoWVtON64iMAiHxi0Sz3iavejFw5uT7IFeQUyY0ylo2vvfT2USIQ5oUmtkM1MEjZmNGiTk7vyW8ZnBCNIkO78QYqwLLmTCAvf5bO9yzlHIdoq4CxpiKgnKhxjlhVSCs7n6JWxtXOrntD0g5zpyixqIq//Mhr8iKFL19twpKyjmwI7z5w/RPDadvufbmEOyDWR2R5nvDDHmlDF/h2aFSHAeBoQWiGvNq3g2YWzV1waMFNr8gJu3viAc7FNiRaZ1gi8TH87k4XQn0XMUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uAWAby64d+zqP3xvGuT25IkLT165wdIlRdbWeVci98=;
 b=iuuixphqImPSVrI3sbapX6p8osRziqCyFHwm58gIML7+N6e8tuOwkYZwNmzSgwvR1XoYdmR7hNAbzZg7bsrreF/Ys/18E9/K+fMWpZpR0QiMH3c7IeKubx51OZKg96NmrHWOWEQf4wm8QhTZJXDD3sEAtmeZgbkfKHBWnDPvw4g=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA0PR11MB4701.namprd11.prod.outlook.com (2603:10b6:806:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 12:35:26 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3805.024; Tue, 2 Feb 2021
 12:35:26 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>,
        "xuzaibo@huawei.com" <xuzaibo@huawei.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "yumeng18@huawei.com" <yumeng18@huawei.com>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
Thread-Topic: [PATCH v7 4/7] crypto: add ecc curve and expose them
Thread-Index: AQHW+L0cRVwV16205EitrxgPGecVIapEUuIAgABG5QCAAAQRgIAAMG8A
Date:   Tue, 2 Feb 2021 12:35:26 +0000
Message-ID: <172b57990e5c0cf9c9c3b638df37fe03efdc7ddb.camel@intel.com>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
         <1611299395-675-5-git-send-email-yumeng18@huawei.com>
         <20210128050354.GA30874@gondor.apana.org.au>
         <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
         <20210128103908.GA32495@gondor.apana.org.au>
         <c3c3d47edbfd61c338deea5a10a4fb39e2ace68a.camel@linux.intel.com>
         <20210202051346.GB27641@gondor.apana.org.au>
         <f239c77dd510c860254189b65fa297d039041490.camel@intel.com>
         <20210202094203.GA28856@gondor.apana.org.au>
In-Reply-To: <20210202094203.GA28856@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6b55f03-5bfa-4b1a-d4b9-08d8c7770461
x-ms-traffictypediagnostic: SA0PR11MB4701:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB470160B963B4AA18126BE717F2B59@SA0PR11MB4701.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FUnTRtPHC5+ar0Bx4oBiI08rpwuCHCUqRKg4M2trt71IEyy7ptGgKghcy7GkP/1eARMa09XJmV49LpJ1C3buCQvSrultmNkjthd9O9Vw8DND6fztmY1hgHKUc8HhoiTS2ujYiqaZy6JsTza8imx4nLhMfbwTPP8DP/NKrcrgBvU+j98gt3w3y1VLy9xRiWidj/ASbd94mgzCjybgcHXHQdH2Qa1KO/V6blxOGFa5IgLrrDERscdBOrOsxj3drICHPu+x6u4YdQrEiU0jOnEBLn/BHhwsZjAX0p5Fx7PZRLSClYCzwUzHH8zFrEchwcPm4ncBKgu9tQRaK/BYeU1YHz9cx4R59tv4OKShjLF9l3zy8dLfmNnfLon7o0960RlF5Q6AeEIsdLWbZmNyNFxPBBtXek2kVTLw7Jk1xTWQEplbWH3owGnidhkTy3xkIPUy6LdU3nA5+Vp+sxoCP/NENQjbLmXUhnXVMIiIfx5BFay9JtO+hBuUSq6NHfqgF6m1SH+EH1EJbS3d23T9JbqLATxBVd2yGCB38u8aTWipBra0OAipGrSfOKBUkh5FbX1eNwpaevXoqMW4doG+cDTaPw1IE924+BPxv3FndirFEyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(4744005)(2906002)(6916009)(966005)(86362001)(64756008)(6512007)(66446008)(8676002)(4326008)(66946007)(478600001)(8936002)(5660300002)(91956017)(26005)(76116006)(2616005)(6506007)(71200400001)(186003)(83380400001)(316002)(54906003)(66476007)(66556008)(6486002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?LzFmOVRxSDFMbk5ZRmhPaThFS2VZR0pzUlRGeTZldmlzVnZEaUlnQVNFL2Fl?=
 =?utf-8?B?MHpFbVFXWE5wWmtxL1YwRTVITSt3b0lNblFRUDVJUnZwVjFaUnJOMnBLRzRa?=
 =?utf-8?B?VVZ4aFBlNGhDTG50NzZyOXUyWmFoOGxWSWh2V1FYUFhDeFROSGZkaGlQdWN0?=
 =?utf-8?B?Tm9kNmZab2dMVU5DTm1mVkplT1MvQzJZeW55U1hWdnIxcFRNb0Q1Y2p0WVZK?=
 =?utf-8?B?NGVMdGtSYko5T0RjVm9nVDhHaHByNkk4SFJodjdIdlN4SVRQR0Z4WHd6cmgz?=
 =?utf-8?B?K0lXc2tTV244WEhLcTBPeHZkeE9oWGRPcEsxei9NWmR3MFhNZ0E0U1p5RXJH?=
 =?utf-8?B?clRUdUJGYmhNYm54TWNyU3Vla25vVEd2UG10cGVWdGlOVHhmSCtqbDQ0aFlh?=
 =?utf-8?B?YVlVVTd0ZlNTWHdNNGlJaFZac3lIaUViMkJkYVlQT1praC9lMVdDVjdaQTk4?=
 =?utf-8?B?NTZRRkVIdDZGbGtyOXVkSEI4VFVQY21wMHBwN3VsVkowUjNaTnpJd2dlNkgv?=
 =?utf-8?B?QXNVR2FUeSthaUZHblM5MXNjVWRGaHpnYmJTNHFoOXpWaEdOWnZ5YWFjbzY1?=
 =?utf-8?B?bVl1eTZsOE1PS1BwTktzTDJGT3dDUTAzdlVCMDVFT0Y0U2ltUG5PQ05GNHhY?=
 =?utf-8?B?TFBPdEF2VW1WN3MvN1VYeFRleExKNVZ1Z0Z5UUNKaHczbWQ1VWNsV1JaWGVu?=
 =?utf-8?B?ZnlJQUlqMmxGQklNaC9CcnBWc3E0eGhxanV3a2xMRUpiRStOVWZEUCt6WGdY?=
 =?utf-8?B?WVZMWndqa3FGQlFKY09nZkdqSGtzVmp5aWI1c0Vkc0lLZllTMzFQUkVtTmRO?=
 =?utf-8?B?Yk12OVZ3K1I0bUttbG43cUdhenpLbTBUOHY4Qlc0VEFtaTV0alI5c3ZuMWFP?=
 =?utf-8?B?UEo1Tm9Udi85Wjg3ZXBTcmdWeXJaYlUrSFZETEYxMVpuaUNsTG9QNzNiSVBW?=
 =?utf-8?B?WmlWelkvODNzcGRWR254ZGw5MlFtamVpbXJVdVlKYlhkMXRidWdzb29Ha2l3?=
 =?utf-8?B?VDRvaWJwZGg5ZzA2RjdCWHJEdUFOMzNQWFZ6VU01WWpqd09jaWJZWFAzcmg0?=
 =?utf-8?B?VlY2NGhTM0FLOXhNTlFFTnVFYlhPYTJGd3lheWNZU2p5WEVpeHBNaU9wL2FQ?=
 =?utf-8?B?Y1MvQW14WHN5MmJ4alpmcENoWjJ6VEczTWN4SCthRGV2VE5saXJwbGhWS2p0?=
 =?utf-8?B?VXY0ZExjMFRkMWNkQWpJNDlnRFNWMVF3cXdTeEUvaGdsR1ZSYitOUTJORmNo?=
 =?utf-8?B?T2RETG5vSWc5UmNadUF2eVNwZE5wajVhMG5JWUo1TzZIQUJiYURMMklBdGJ3?=
 =?utf-8?B?aDU5cno2Wm1YUWZsT1dEdUtVRWswYnQ3eFV0ZTlYOG5JMy90MVFBMk1nNHhz?=
 =?utf-8?B?UW9LQmpHZUxVc3gzVGFVazFUSXRsazM4Z2dhajhwNG43NzdDTXV6NVQvUjJB?=
 =?utf-8?B?YWRZRm0yRUVGTitxLzgzeDRqZGFKdGJqaWswUFhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E21917B30D3006419B603E3B504A5177@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b55f03-5bfa-4b1a-d4b9-08d8c7770461
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 12:35:26.0271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f7bQ0JpxhNmzj0OjhPTPOtg+4EJl+eXgagTTP1k+SwhTlgHSaT8T9XFlZP2zPmpbBDXqEYoc5l6KlXc7JWHaA0KE1vJ6Y2dE3itHWFBj8Ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4701
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVHVlLCAyMDIxLTAyLTAyIGF0IDIwOjQyICsxMTAwLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBP
biBUdWUsIEZlYiAwMiwgMjAyMSBhdCAwOToyNzozM0FNICswMDAwLCBBbGVzc2FuZHJlbGxpLCBE
YW5pZWxlDQo+IHdyb3RlOg0KPiA+IEkgc2VlLiBKdXN0IHRvIGNsYXJpZnk6IGRvZXMgdGhlIGlu
LWtlcm5lbCB1c2VyIHJlcXVpcmVtZW50IGFsc28NCj4gPiBhcHBseQ0KPiA+IHRvIHRoZSBjYXNl
IHdoZW4gdGhlIGF1dGhvciBvZiBhIGRldmljZSBkcml2ZXIgYWxzbyBwcm92aWRlcyB0aGUNCj4g
PiBzb2Z0d2FyZSBpbXBsZW1lbnRhdGlvbiBmb3IgdGhlIG5ldyBhbGdvcml0aG1zIHN1cHBvcnRl
ZCBieSBkZXZpY2UNCj4gPiBkcml2ZXIgLyBIVz8NCj4gDQo+IFllcyB3ZSBuZWVkIGFuIGFjdHVh
bCB1c2VyLiAgRm9yIGV4YW1wbGUsIGlmIHlvdXIgYWxnb3JpdGhtIGlzIHVzZWQNCj4gYnkgdGhl
IFNlY3VyaXR5IFN1YnN5c3RlbSAoSU1BKSB0aGF0IHdvdWxkIGJlIHN1ZmZpY2llbnQuDQoNClVu
ZGVyc3Rvb2QsIHRoYW5rcyENCg0KVW5yZWxhdGVkIHF1ZXN0aW9uOiBJIGhhdmUgbXkgS2VlbSBC
YXkgT0NTIEVDQyBwYXRjaHNldCBbMV0gYWxtb3N0DQpyZWFkeSBmb3IgcmUtc3VibWlzc2lvbi4g
U2hvdWxkIEkgZ28gYWhlYWQgb3Igc2hvdWxkIEkgd2FpdCBmb3IgdGhlDQpmaW5hbCBkZWNpc2lv
biBhYm91dCB1c2luZyAnZWNkaC1uaXN0LXBYWFgnIGluIHBsYWNlIG9mICdlY2RoJz8NCg0KQWxz
bywgSSBndWVzcyBJJ2xsIGhhdmUgdG8gZHJvcCBQLTM4NCBzdXBwb3J0IGZyb20gdGhlIGRyaXZl
ciwgc2luY2UNCnRoZSBhcmUgbm8gaW4ta2VybmVsIHVzZXIgQUZBSUsuDQoNClsxXSBodHRwczov
L2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyMDEyMTcxNzIxMDEuMzgxNzcyLTEtZGFu
aWVsZS5hbGVzc2FuZHJlbGxpQGxpbnV4LmludGVsLmNvbS8NCg0KPiANCj4gQ2hlZXJzLA0K

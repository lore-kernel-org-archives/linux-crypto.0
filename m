Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DFAC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 09:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B03A60C3E
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 09:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhBBJ2V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 04:28:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:4989 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232367AbhBBJ2T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 04:28:19 -0500
IronPort-SDR: u8nQYQugpfgo5F25WRyguyHRV/uAs9VVdaglsKp1V8bnAoDAJeMY7kcE7Oajh06+mDi/0gBTZ1
 6A0O7x97K+rA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180969448"
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="180969448"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 01:27:35 -0800
IronPort-SDR: HREuH0YOHC20O3nG5Q2qmcbb/0b0xIw0XQgpz+CT5GGa4S6Bl869I371D0Sh2nNYoC1Dx5hgtF
 F3Qeut7LqA7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,394,1602572400"; 
   d="scan'208";a="507241984"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 02 Feb 2021 01:27:35 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 01:27:34 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 01:27:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Feb 2021 01:27:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 2 Feb 2021 01:27:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWejZ3Dz7wpTV8XUZZLwjycMmRPYHEndFY8lMtSfuUw6HbHWBO38BA+BpAzPw3CZp9n2F/GK9XMN5hJ7xAcBI3rUCjcci5ZUIGO3TeuXc50FwffqZ997u/Mi2gfM4DUtoB4My5AZpTxApqifTFXS8AMlK1aYFwvqksjGEbsWbQwow6qirumkwyFNvXQYAwLQrvE78yJNBrTmfDzaEg9UXtuyNK8VcR4mVFZsARpDdcERfOqJNB+DMm0GDqO9Ffx7wkfDlIzqtUuXI68K+9S6B/QLAg6I1FwTS/J9eeLmwSp0uiCeSS5hl1Mdh4uJwJJ14cfUTUCiozU2qul8Vhtivg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpYtqVUOWfIfeaR8DOGRRIyLW3d6dE5GkaAIlVp8LjM=;
 b=PZCYdeJJz25wo0OR1zP223HbKGJCe4duVlympDqK2hTSGFZghciBsb6pX1MlVCxkCzHRQjwCePU45cgyfh09vB8oFlWnaC7KF6oIuBlzIJbw9x6Im59v9tBwfJWueaXnSd5xFhXnnCPl/cdzo8FSmG9IdT04/xYUMT9MXw717x4Qg6+vV38FR3hog8o770uRSWUYxuAyfR86gYfjhgk29/XbHEHwsgPJKeOAJQoZmRF7l1XHvSnQO7PZpDXw+fb7jOynkb01YzViYYWQew/MKxZhEgkduX6qd1JHo9M5vUjWFeyu8WfvDZUfY8RliE4M0NlDV1dZVwobNLvhJ49w1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpYtqVUOWfIfeaR8DOGRRIyLW3d6dE5GkaAIlVp8LjM=;
 b=XtzBbHwgcK8/Ls/zHKP8tYELJdqtiyz6Rzx7mLsBSIBFwWAh7rJ2qd+k4ZjjdHYesZIyH01IKK8miehBoMkBJHbugdCvccohdANpv2Ll2M0vtLqUwZi6d/EZ8H82RqaOpoH1CIwWBefWNoJZ5QiOAy9YXpNc6vc0IK2RKEwSTk0=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA0PR11MB4621.namprd11.prod.outlook.com (2603:10b6:806:72::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Tue, 2 Feb
 2021 09:27:33 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3805.024; Tue, 2 Feb 2021
 09:27:33 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "xuzaibo@huawei.com" <xuzaibo@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "yumeng18@huawei.com" <yumeng18@huawei.com>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
Thread-Topic: [PATCH v7 4/7] crypto: add ecc curve and expose them
Thread-Index: AQHW+L0cRVwV16205EitrxgPGecVIapEUuIAgABG5QA=
Date:   Tue, 2 Feb 2021 09:27:33 +0000
Message-ID: <f239c77dd510c860254189b65fa297d039041490.camel@intel.com>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
         <1611299395-675-5-git-send-email-yumeng18@huawei.com>
         <20210128050354.GA30874@gondor.apana.org.au>
         <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
         <20210128103908.GA32495@gondor.apana.org.au>
         <c3c3d47edbfd61c338deea5a10a4fb39e2ace68a.camel@linux.intel.com>
         <20210202051346.GB27641@gondor.apana.org.au>
In-Reply-To: <20210202051346.GB27641@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9962fc2-886d-4b97-09b3-08d8c75cc532
x-ms-traffictypediagnostic: SA0PR11MB4621:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4621B1121BAD8B955F5F8094F2B59@SA0PR11MB4621.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Tb2MOVCjs3L1UM2/nYfcwv7NYhXxtK64PFrLujLB/SjDWG5f2gXXN+XYNTpRZJ3OUppw0mACb/1rPm6f7Im6xm/D5y14OrQEN6xezWCQwLtFp31tg27jbcxfsb38Lx9Q6TOuM/egy/WAMgL4iTYgiidOIWO+BEHqh/n5Cc5f0uliHqhMWl4z81Cy9Qv2jjOEf3MV2NWgcmqGNGtMQ8SjUVL1toKNdBjqweRHU8ldfi0e62BJ+QYSfCmXMxJy5FHy/mj+6rQMIPKQCAVq/ZeU7NRB7C8yUZg+GbzYag5MLQVrchgb1ls6U9Qnw7HKKbPDUjdotKtReJXvD63VKlkaZegjEYt0lOHn0ezpVVfFSqCGIn1r5MKDarvY8KUiiDNWBNrsDIxZ9XyLmBbL9/1bO+DY/dqvHGyktYYt4vLDGkEKOso3vQACzFQqYRFRNDMb4frUVsdriEcANIWS2buDE+j8Lg85oD6Nn8+sE/iIGF4YAJpHxoiQ2SMHA/FQmu1nBpj/Q14NWt4Q7RLHTxTjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(54906003)(4326008)(6506007)(6486002)(4744005)(66556008)(91956017)(66446008)(71200400001)(8936002)(316002)(26005)(2616005)(186003)(2906002)(6916009)(6512007)(76116006)(86362001)(36756003)(64756008)(66476007)(66946007)(478600001)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NktiOWhPb2Fqd0dqVEF4S0xzdCs1R2pRUmxtQjJYQmhpUFhUQ1VBdGh0QTBV?=
 =?utf-8?B?bmlhWEJzU3EzQjk3WEZpaC9pVHZsWm9uM2lMK1lEb0JEOU1PMEhGWk9mejQ3?=
 =?utf-8?B?a3ViU3hHVFhuZ3ZxTmdpQkVSU293VU5GdHpVSmh4RFROTFliL0ZFcW1MQytE?=
 =?utf-8?B?UGZqQi9yMFExQnE4ZHNaQU9OZ2FlUmF2dzd2QnlhbEM2UDFHdXh6UVJFRStS?=
 =?utf-8?B?L1VXYXo4UXVhWHhZZG53WHJhSTRZQ3VaYnJJa2EzRzFQZjIvOXRRV0hCY2V2?=
 =?utf-8?B?dkpyUHBhNEZOMG9RZ3VPT1d3eW9EMUdOZEVONm5VYmVpc2c5SlNrN0xJY1pV?=
 =?utf-8?B?MlBObUxRblNBVW1pT0xoQ3BwS3VVVm9BTGFFQ2l3eUFzS0ZUMnVVNUhzWG9V?=
 =?utf-8?B?WDFxMHlNUlpTbFVIdWg4TWJPZzB2eWpVRW51ZnIvNDhrRkdBakwxVjdmZ0l1?=
 =?utf-8?B?b0szejdrcG12YURjL2gvRUJkY3FMNWlxZDMzaWV4dTVnU2VQMFArZ3U1Q0tU?=
 =?utf-8?B?QnJsZHpKYStmb2lqS1N5M3V4WFAvYjl0cmRIejhzQlFVOFRESTNIaktwR2Uy?=
 =?utf-8?B?bzFKaWtLVWNWNVYrWGZNNHhsR0pma0Z4ZGROSjA2Y3VId0JZUjNkd2gvUzBz?=
 =?utf-8?B?VFdFWnhYZ0d5R0tITDBTcmxrUFkzcWFXWEcyNWRCdUVEeTJncE8wZnJxbzF2?=
 =?utf-8?B?SnY2c2pvQVlKUlJrMUZiUTVuemIxUEJRb3BEZmdZYUF2YjFpVUFWNW5sdit6?=
 =?utf-8?B?dmRBaDRCcERLMzhxOGtsUXU1Q0dZYUNVa0ZZaDVqUGhqQ1pwcDVlbkxBWitu?=
 =?utf-8?B?U3MzT0psRVhLb015QWdTM3RQQU1VMUMrOThhZHVKZUNwNkJjbTN5U0U5c2VS?=
 =?utf-8?B?aWkxckRQejJpbFc1TFZKYkVKekV4QjlCSExQbm5kQVZ4S2QyU0IrVnQ0YmpH?=
 =?utf-8?B?MWI5NmF3QXA4dmp2ZjcxdXpnMjhCbXY1eTJRSURNd1pJNktCZG1SYitUa3ZF?=
 =?utf-8?B?dHRUdi9QdUZkQzYyVWpWc1h5UjU1SlpSZHZZZm83czVlNHVNdFVGVEFkVXE1?=
 =?utf-8?B?aEc4d3BHeEt2dVRSd3duWkVTb3h3ZWFsTDRuRXNCdWJBY3dydUl4UG9xVi9O?=
 =?utf-8?B?WHZlYnFocjJ2SCtFVkpkZFU4Vlo0SEo1akJwQ1N4cDdKL3JSaHdrSU15eVNU?=
 =?utf-8?B?T0NBS0poYkVVV3pSSGQ1RU5uQXZuS3BpOVdwMHltZ1JJaVV4U3Q0THQwV2tj?=
 =?utf-8?B?QTBpZzR3OFMxQ0NhcUEzeXZFR0doUnFJdm1Xd1YxL0JReTc1RTVJWDJHcVhR?=
 =?utf-8?B?bGFsVnQ5a2NQZlFxbmtwbDBmT290US9aVDVXekxyOEh4YlA3cUJJZUJnSGYx?=
 =?utf-8?B?azFYekUyRzBIRWU5eFpHZm4vZW9Oemx6TEI5Qk90SlMwZ2UvZVYxeW1mNEZ5?=
 =?utf-8?B?NXFxTWtKUVJCSmx4VmtvQkZ5WGZHOFlEV1hjMGhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2221EC7365688C448D1D580799C737B4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9962fc2-886d-4b97-09b3-08d8c75cc532
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 09:27:33.1055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3zYlwdnkIrqDm2tehx6YbUDHfMCGI3ZZXu+XYtoJlEpWrkjqhvYIbM1Lpr+PtbLVZpXARYUdciYI5YlLiH/i4c+uebDazT5GGouC5xg/K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4621
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVHVlLCAyMDIxLTAyLTAyIGF0IDE2OjEzICsxMTAwLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBU
aGUgaXNzdWUgaXMgdGhhdCB3ZSBhbHdheXMgcmVxdWlyZSBhIHNvZnR3YXJlIGltcGxlbWVudGF0
aW9uIGZvcg0KPiBhbnkgZ2l2ZW4gaGFyZHdhcmUgYWxnb3JpdGhtLiAgQXMgb3RoZXJ3aXNlIGtl
cm5lbCB1c2VycyBjYW5ub3QNCj4gcmVseSBvbiB0aGUgYWxnb3JpdGhtIHRvIHdvcmsuDQoNCkkg
dW5kZXJzdGFuZC4gVGhpcyBzb3VuZHMgdmVyeSByZWFzb25hYmxlIHRvIG1lLg0KDQo+IE9mIGNv
dXJzZSB3ZSBkb24ndCB3YW50IHRvIGFkZCBldmVyeSBzaW5nbGUgYWxnb3JpdGhtIG91dCB0aGVy
ZQ0KPiB0byB0aGUga2VybmVsIHNvIHRoYXQncyB3aHkgcmVxdWlyZSB0aGVyZSB0byBiZSBhbiBh
Y3R1YWwgaW4ta2VybmVsDQo+IHVzZXIgYmVmb3JlIGFkZGluZyBhIGdpdmVuIGFsZ29yaXRobS4N
Cg0KSSBzZWUuIEp1c3QgdG8gY2xhcmlmeTogZG9lcyB0aGUgaW4ta2VybmVsIHVzZXIgcmVxdWly
ZW1lbnQgYWxzbyBhcHBseQ0KdG8gdGhlIGNhc2Ugd2hlbiB0aGUgYXV0aG9yIG9mIGEgZGV2aWNl
IGRyaXZlciBhbHNvIHByb3ZpZGVzIHRoZQ0Kc29mdHdhcmUgaW1wbGVtZW50YXRpb24gZm9yIHRo
ZSBuZXcgYWxnb3JpdGhtcyBzdXBwb3J0ZWQgYnkgZGV2aWNlDQpkcml2ZXIgLyBIVz8NCg==

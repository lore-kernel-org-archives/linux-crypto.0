Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2BBC433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3F5464DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhCRQH7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:07:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:45900 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhCRQHe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 12:07:34 -0400
IronPort-SDR: zIVo9uV+Jo3PjRSHLIohh7Q6bozLEZoeUBdAjYATgNcH4L04SS55PvYfho4xsBtZ8/2RT0m00h
 OX6CUbtBa6uQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="274771927"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="274771927"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 09:06:25 -0700
IronPort-SDR: 2VmDvE0qsQCw6CfUKA7ssLivLgEPhm0EVJZ/xa8zNiv0ufjUpiXT4uB+gn2FTFudrrIOalQTAF
 3Tb3ezBHgiYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="523314797"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 18 Mar 2021 09:06:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 09:06:25 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 09:06:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Mar 2021 09:06:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Mar 2021 09:06:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsSKC8ZGUh1wY3qYUWGZ7SvDWlboB7edPLQ12fRp99EtqF9wHrx8WgiRMbS8htZ99CsTxAzoJ4qekmR8FSlrAZLuDfE5cKqzQxmGeDwMEIuOLPVgx2HhG2FSihhsaQBAOPUPGD7JF8etXlm033EN9IrR5jYSHfqo3Emwk2EMvUdh6jHXYv9rypsq3JTcdnj3OpD3bLrrgN+xSrh/+DSaVHzXf/bSJwyqy9XrGxHGZvemmJPelzQMvTHnAed6dzXz/kNdSLJhocfb6cpoFTvepZzqMpdFzhSQBIfiGwyzcoKoHVHWS2/IVy+NgF+czAlO+MEMsNV60imWOy1hr2a6jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SdUtwIjlxrM39dmxMvk/bR7M9jC2pa185lOJkIAa3g=;
 b=JdWfijkkn/Zktyg93p61P6urkPDkfh1kQr5k+ZDPLueumm2Imq2jL5LUt3Bt2/VGAPpbpq1x1sVN06Tly8Ns+zoDsvRBsqXsBa9YT+7S9hZO4QaQ6kQs7oy5robO4jfJY6bwj9YtfmzqLznAg6gcadW8J5ZuWiuDyH0OibyO5KnhP2M7ZjNHIqdz+xzR8l7XR7Ne9xiggsm8gvQ38yIV/2sx+7x3eLxtRnbMHTKB0OPiEnPcVXDKy56rgLpnt3p02ndEMzfua0LO2ti4qtXhg8uEutfAfHLyqf51j7mukfS9+oiZGs3nCgUK815V/Ch/STtsl2eVQyN8u5ojhj1lVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SdUtwIjlxrM39dmxMvk/bR7M9jC2pa185lOJkIAa3g=;
 b=Aeai/9Gn1yUs6S9u0Z7HinqgyK4x9tcinnCmWuruyQz+GBuIyDGOWOpd2ZghiMG+wS3QMhkZUjiGHYaX3KeO+5BgZ89kNHY0uARFcomGMvphks7EwM1H2EdjkK9N0/S8LDNeN1VUnvWLft4do3DAl+UAz4GuMiL9nohGvlv/bwM=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SA2PR11MB4907.namprd11.prod.outlook.com (2603:10b6:806:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 18 Mar
 2021 16:06:24 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::15d2:c175:b922:8d8c]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::15d2:c175:b922:8d8c%3]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 16:06:24 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "lee.jones@linaro.org" <lee.jones@linaro.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Murphy, Declan" <declan.murphy@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 05/10] crypto: keembay: ocs-hcu: Fix incorrectly named
 functions/structs
Thread-Topic: [PATCH 05/10] crypto: keembay: ocs-hcu: Fix incorrectly named
 functions/structs
Thread-Index: AQHXG/R78PYkJyHquk2FlKmJu5KuP6qJ6VyA
Date:   Thu, 18 Mar 2021 16:06:23 +0000
Message-ID: <8fca1b8440cdf9b93effb88649f0512d2d154ef1.camel@intel.com>
References: <20210318124422.3200180-1-lee.jones@linaro.org>
         <20210318124422.3200180-6-lee.jones@linaro.org>
In-Reply-To: <20210318124422.3200180-6-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebad75b3-8cca-4da7-0449-08d8ea27c745
x-ms-traffictypediagnostic: SA2PR11MB4907:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB490768A317CCD92376E9EE8EF2699@SA2PR11MB4907.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:225;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fjTsBf8zRqEVjE11d7ERKdgOrIeJURoAyZFQi1XW274GiJ7duBkQL8r5Aq42G6YEcFADc9CXIKnpjTn12iWocFjmIkcYLqC44qT74m3Rws79oHvy4T47999IoykdYulmiz5EcpQV+mj1P8aOCtWlZVu6oBI2gJ/Oe6IPr9PcssKi4mLBVQYDBTF/8RIsTrFTpmaubzvorCmcnhX2z8hZ10LZGggwLKS9BXDKbWZpGRsB+/7MsU51XR/WVCllNIPVQhTUQ3JNExHwq4LvA1WhunHxM+ZfV/p3jV9mLDHPImV0bCk9hHWCJVvz9EvEFvgkDlFX0RPhkFKk6Z7eaz3aDxMFEDcHK+dc6KqZa11kVGww4zlT5NdmvVQoRN6IPtt3KpE00EUhiL2UiE+1kxoSzIgMeMQLM6OLjLOPkSrsEwhoZUhXoh050DNSC0zVV3Q3G7mNk28OV5+PxMpEIeEMpSVW1fBtN0Mz4r66bUqP+DIZPlvzp5EvXjCQTpK2Tp9+JADvltY+GaYNnN5RG8SAQkr6vjMQCOmM5IYgsePueOGxdf9jXjCjWA3oANJMVA47rJ2YT03V5jFQZ9RVc87BHHrPVAf5O8Ne0qKzWy+tpFiSvvM12KkdXkAG25qDIbG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(478600001)(86362001)(2616005)(71200400001)(36756003)(316002)(5660300002)(66476007)(6506007)(64756008)(6916009)(186003)(2906002)(83380400001)(66556008)(38100700001)(8676002)(8936002)(91956017)(66446008)(6512007)(26005)(76116006)(6486002)(54906003)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aGFHbEh6YWRObHlLYU8rbndCdE1iSUdKYStUNlVnM0F3K0FCK3lrWmtSamtm?=
 =?utf-8?B?SzZVdkpLa0FhZDhsVXNOcGpTVnJFYkRCbFFOWVByR1cxZW15RFovQTJzKzh4?=
 =?utf-8?B?c2h6bkIxRk55c1lsemY0ajh5M0dKRkJvTjFaTlU1aE1oblRwT082QVB0emJP?=
 =?utf-8?B?N29rNG1lZ29JYXJGalRMR3I4aHU1NWpITkoxczI5R0g3Mm1DUElPMmgyekVi?=
 =?utf-8?B?dllENU9nSSsvV2RUcFk0K0dneHVsUWVVWkxyMzRMd1h6V3YxamtKd0hVOGdG?=
 =?utf-8?B?d3AvOGhUWjhvMlFZdEtJcUw2SVE2cDkzekFwTGlMaDZyblhiZllrUjlRWXhk?=
 =?utf-8?B?Y3lyekQ5Y3gwdWdwLzNHL0gzd0hYWVBDM3JOem1tSUdYVTNUT09PSGg1S3JG?=
 =?utf-8?B?U013djZtRUhMSEllMEhaOTdZb1ZiRmtkV3RZMmV1bGlTbzVEQ1RvVCtvUmJJ?=
 =?utf-8?B?WmQxc3JUdVk3THg0Qy93dDAvamdwNlM1U1RQK3BRZkFvK0VFSFZ2TE0vdkRF?=
 =?utf-8?B?b0szRU5aYzFtS0cxVHpkTm14NUVGVGFvN2pneUprTTlncUdMM2xTZUp6Vlh4?=
 =?utf-8?B?WWFRSTBaSU94MUU2aHRPdVU2c1hSNzc0RzRWM1k3NnFSMzJCK0todFo0bDQz?=
 =?utf-8?B?dFBUYWtuaUREU3A1UXkrMU5RckJCYkd2akd4SEtuTFI4RW9GZ0YwSGxQQVd2?=
 =?utf-8?B?S1lyeC9zWThzQUp6Tnl4b2U3NjhkVUQ2aXpTeEtmTXR4VWNkVS9nVUJlV0xp?=
 =?utf-8?B?VkRheVhDOEVnSThncEliUnAwd0xqbUN3STcrUnQ4SkF5WmVEbElYVzNIb3ox?=
 =?utf-8?B?SmFDUW1nMll2WnQrZUFvM0Ewb3BCSnBvblVMREc4TGxrb3ZPOHBQMXA2R1Iw?=
 =?utf-8?B?ZGNLN2lkMVIvZnE0R0dnWXgxK29vRm50NVNxdk5WODdDZVlnVHNFTVNKeFdj?=
 =?utf-8?B?UjBTbW04QWRXTU9xcnlkRGtRRzZGZHc3c1F6V3dXdjZnYkxJdk9iOWUydUxv?=
 =?utf-8?B?TlRDSmk3YXhkSkVsRHZ6TldGNU5qdGxvS3FzT3k1NmtTT2hrdlVuTFE1YlJL?=
 =?utf-8?B?emt5aTRiMWpEMER5V25NZmRtL3dJZG9OcEpSMjVINE8rVS91L2hkUUhsNC94?=
 =?utf-8?B?ZEt4OW9BSXIvcmMwdnd6QlNxYTJUcVFCdFNialVJMEU2UGVzN1prRnlFbW8w?=
 =?utf-8?B?Yk1mQzRwTndxcXFXT3lmTnlPcEZwS0RVYnE2cjhvY1NkYTJHNjFHR3ZLQ00v?=
 =?utf-8?B?U1FlVlAydWxCM2dROVJUZGxsOWxmb2k2bm9jUmx1ZVYvL3BiQTRXR094NjUw?=
 =?utf-8?B?M2NxZ1hkQmc3L0NSYWJJdTJtclhEZEZhOTB3YktxZ21CSXV6d2V4Zks3byt5?=
 =?utf-8?B?NnBMOVp4cjZ1a3YvWGdodHVxY2JUK0crN2grcklGZ0JEcWFKM2ljOUhnNTk5?=
 =?utf-8?B?TUllaVYzbk81UmIvOFJ3aVkrWTA2bnpZY01CYzRFazJqMFE2VDgxYm9yM0p5?=
 =?utf-8?B?L28vbWh1TlJLbTVtQXNKVUx5amFxckpzcS8zU1h2S3JrNnQrRFlXMFI4Qi9o?=
 =?utf-8?B?SldUQzZtd2ZVYWwxeXJhc0RNTFZSa1RFZms4VC82UVlBbzg2OG9tZm5DVzhK?=
 =?utf-8?B?YkRrVHZsd2xyLzdhSkxQYkJtYlV5emtoZTVBT1l0Q3hLWmZJK1orcVZiNlBq?=
 =?utf-8?B?OE55Sko2UU54ZitFZ2hiNmg4em1ySHJxSjFiNGUvNWlpWWRHZEJqZ3NVajNi?=
 =?utf-8?B?NVVKU1NkOWZrWktIUkZieVZ1VUpsQ0VQZE5mRnhtbGJxZlRVR29idk92aTdx?=
 =?utf-8?B?K1VVU1hvMEltMUZiVEZLZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9FD6D2D8FFB014ABFAD4FCA62DB0356@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebad75b3-8cca-4da7-0449-08d8ea27c745
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 16:06:23.9698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJVZ/Ix9ScPGNNNoK+ipNiP1mjtxIie1pnfIwMLQd2Pe3eVwpdsnUCUVpLnLJHYWeujgHZ5Oh5jak9tiLPDpfalJJov06YoRqiqB6b0imow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4907
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTE4IGF0IDEyOjQ0ICswMDAwLCBMZWUgSm9uZXMgd3JvdGU6DQo+IEZp
eGVzIHRoZSBmb2xsb3dpbmcgVz0xIGtlcm5lbCBidWlsZCB3YXJuaW5nKHMpOg0KPiANCj4gIGRy
aXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jOjEwNzogd2FybmluZzogZXhwZWN0aW5nIHBy
b3RvdHlwZSBmb3Igc3RydWN0IG9jc19oY3VfZG1hX2xpc3QuIFByb3RvdHlwZSB3YXMgZm9yIHN0
cnVjdCBvY3NfaGN1X2RtYV9lbnRyeSBpbnN0ZWFkDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5
L29jcy1oY3UuYzoxMjc6IHdhcm5pbmc6IGV4cGVjdGluZyBwcm90b3R5cGUgZm9yIHN0cnVjdCBv
Y3NfZG1hX2xpc3QuIFByb3RvdHlwZSB3YXMgZm9yIHN0cnVjdCBvY3NfaGN1X2RtYV9saXN0IGlu
c3RlYWQNCj4gIGRyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jOjYxMDogd2FybmluZzog
ZXhwZWN0aW5nIHByb3RvdHlwZSBmb3Igb2NzX2hjdV9kaWdlc3QoKS4gUHJvdG90eXBlIHdhcyBm
b3Igb2NzX2hjdV9oYXNoX3VwZGF0ZSgpIGluc3RlYWQNCj4gIGRyaXZlcnMvY3J5cHRvL2tlZW1i
YXkvb2NzLWhjdS5jOjY0ODogd2FybmluZzogZXhwZWN0aW5nIHByb3RvdHlwZSBmb3Igb2NzX2hj
dV9oYXNoX2ZpbmFsKCkuIFByb3RvdHlwZSB3YXMgZm9yIG9jc19oY3VfaGFzaF9maW51cCgpIGlu
c3RlYWQNCj4gDQo+IENjOiBEYW5pZWxlIEFsZXNzYW5kcmVsbGkgPGRhbmllbGUuYWxlc3NhbmRy
ZWxsaUBpbnRlbC5jb20+DQo+IENjOiBEZWNsYW4gTXVycGh5IDxkZWNsYW4ubXVycGh5QGludGVs
LmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4NCj4g
Q2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBDYzogbGludXgt
Y3J5cHRvQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBMZWUgSm9uZXMgPGxlZS5q
b25lc0BsaW5hcm8ub3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IERhbmllbGUgQWxlc3NhbmRy
ZWxsaSA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGludGVsLmNvbT4NCg0KVGhhbmtzIGZvciB0aGUg
Zml4IQ0KDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYyB8IDggKysrKy0tLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtaGN1LmMgYi9kcml2ZXJz
L2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYw0KPiBpbmRleCA4MWVlY2FjZjYwM2FkLi5kZWI5YmQ0
NjBlZTYyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYw0K
PiArKysgYi9kcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYw0KPiBAQCAtOTMsNyArOTMs
NyBAQA0KPiAgI2RlZmluZSBPQ1NfSENVX1dBSVRfQlVTWV9USU1FT1VUX1VTCQkxMDAwMDAwDQo+
ICANCj4gIC8qKg0KPiAtICogc3RydWN0IG9jc19oY3VfZG1hX2xpc3QgLSBBbiBlbnRyeSBpbiBh
biBPQ1MgRE1BIGxpbmtlZCBsaXN0Lg0KPiArICogc3RydWN0IG9jc19oY3VfZG1hX2VudHJ5IC0g
QW4gZW50cnkgaW4gYW4gT0NTIERNQSBsaW5rZWQgbGlzdC4NCj4gICAqIEBzcmNfYWRkcjogIFNv
dXJjZSBhZGRyZXNzIG9mIHRoZSBkYXRhLg0KPiAgICogQHNyY19sZW46ICAgTGVuZ3RoIG9mIGRh
dGEgdG8gYmUgZmV0Y2hlZC4NCj4gICAqIEBueHRfZGVzYzogIE5leHQgZGVzY3JpcHRvciB0byBm
ZXRjaC4NCj4gQEAgLTEwNyw3ICsxMDcsNyBAQCBzdHJ1Y3Qgb2NzX2hjdV9kbWFfZW50cnkgew0K
PiAgfTsNCj4gIA0KPiAgLyoqDQo+IC0gKiBzdHJ1Y3Qgb2NzX2RtYV9saXN0IC0gT0NTLXNwZWNp
ZmljIERNQSBsaW5rZWQgbGlzdC4NCj4gKyAqIHN0cnVjdCBvY3NfaGN1X2RtYV9saXN0IC0gT0NT
LXNwZWNpZmljIERNQSBsaW5rZWQgbGlzdC4NCj4gICAqIEBoZWFkOglUaGUgaGVhZCBvZiB0aGUg
bGlzdCAocG9pbnRzIHRvIHRoZSBhcnJheSBiYWNraW5nIHRoZSBsaXN0KS4NCj4gICAqIEB0YWls
OglUaGUgY3VycmVudCB0YWlsIG9mIHRoZSBsaXN0OyBOVUxMIGlmIHRoZSBsaXN0IGlzIGVtcHR5
Lg0KPiAgICogQGRtYV9hZGRyOglUaGUgRE1BIGFkZHJlc3Mgb2YgQGhlYWQgKGkuZS4sIHRoZSBE
TUEgYWRkcmVzcyBvZiB0aGUgYmFja2luZw0KPiBAQCAtNTk3LDcgKzU5Nyw3IEBAIGludCBvY3Nf
aGN1X2hhc2hfaW5pdChzdHJ1Y3Qgb2NzX2hjdV9oYXNoX2N0eCAqY3R4LCBlbnVtIG9jc19oY3Vf
YWxnbyBhbGdvKQ0KPiAgfQ0KPiAgDQo+ICAvKioNCj4gLSAqIG9jc19oY3VfZGlnZXN0KCkgLSBQ
ZXJmb3JtIGEgaGFzaGluZyBpdGVyYXRpb24uDQo+ICsgKiBvY3NfaGN1X2hhc2hfdXBkYXRlKCkg
LSBQZXJmb3JtIGEgaGFzaGluZyBpdGVyYXRpb24uDQo+ICAgKiBAaGN1X2RldjoJVGhlIE9DUyBI
Q1UgZGV2aWNlIHRvIHVzZS4NCj4gICAqIEBjdHg6CVRoZSBPQ1MgSENVIGhhc2hpbmcgY29udGV4
dC4NCj4gICAqIEBkbWFfbGlzdDoJVGhlIE9DUyBETUEgbGlzdCBtYXBwaW5nIHRoZSBpbnB1dCBk
YXRhIHRvIHByb2Nlc3MuDQo+IEBAIC02MzIsNyArNjMyLDcgQEAgaW50IG9jc19oY3VfaGFzaF91
cGRhdGUoc3RydWN0IG9jc19oY3VfZGV2ICpoY3VfZGV2LA0KPiAgfQ0KPiAgDQo+ICAvKioNCj4g
LSAqIG9jc19oY3VfaGFzaF9maW5hbCgpIC0gVXBkYXRlIGFuZCBmaW5hbGl6ZSBoYXNoIGNvbXB1
dGF0aW9uLg0KPiArICogb2NzX2hjdV9oYXNoX2ZpbnVwKCkgLSBVcGRhdGUgYW5kIGZpbmFsaXpl
IGhhc2ggY29tcHV0YXRpb24uDQo+ICAgKiBAaGN1X2RldjoJVGhlIE9DUyBIQ1UgZGV2aWNlIHRv
IHVzZS4NCj4gICAqIEBjdHg6CVRoZSBPQ1MgSENVIGhhc2hpbmcgY29udGV4dC4NCj4gICAqIEBk
bWFfbGlzdDoJVGhlIE9DUyBETUEgbGlzdCBtYXBwaW5nIHRoZSBpbnB1dCBkYXRhIHRvIHByb2Nl
c3MuDQo=

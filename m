Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F26C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 12:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 896CD2311B
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 12:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbhAFMKz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jan 2021 07:10:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:18230 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbhAFMKy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jan 2021 07:10:54 -0500
IronPort-SDR: kswwFistTsemil2XjrMOOJ4NVprKZrErcPFspqyrlRIWao/770Ktbo+RZx3rot6kzH6dJUvuLU
 7soSlSNPVpTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="176487059"
X-IronPort-AV: E=Sophos;i="5.78,480,1599548400"; 
   d="scan'208";a="176487059"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 04:10:14 -0800
IronPort-SDR: Buc7fevCdhi7XB1wKHOx2sTITvb2ELp08xGwXB67LMuhWGo2fWpJK9zWj44ofdLqiQfggwf9ps
 CQQ+tg4tYiWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,480,1599548400"; 
   d="scan'208";a="350823763"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2021 04:10:14 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 04:10:13 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Jan 2021 04:10:12 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Jan 2021 04:10:12 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.54) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 6 Jan 2021 04:10:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vm1aE14F1/f98GMwmVJXNLQFdHjGg9V20GpXYWTlGd34FdI7uU9/BiCDJxGwNpVuUruYPZ3hZNsGm73pqJBRNAyfGgJ1XscMSbjJlBHAGu5CmexUPmFiHETK75Cu6AUDl2gSHEZ79UWiCZbulq8NJ4kC5R0NQ94ua8FKVtV6F2NFRPy4UyOsnVFCk/xlW+MA1WUfcvbR7yGPS9sUAxsnP743VkgY+jctGxt2LwsiYxGKZDoXKMQ9nseb/V1DX688elFQRku0nQdpmevC97Vavlngxk6DAJZPOsnpOBtERr9aGRUF2gTEK+WDQ+1oKC+W5E8Vm1i4cMxsPT5CBkHrXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YJyYqIVl4Kg+2zCk6+KuemzJbx4A7ReiKgme7HpX0M=;
 b=T24hgzA/TNfHbbHtNVpzuY4Z4+ZFzkgy9y0ho8xR8GWZfZx+dATthRZFEbKcoH0M0RUum6qePcfZ2Gt7PFuSLykQWhr2OiqweV248RSXtZnOKC+otIS4Bqk5bdhQVzO9Zms3A8AjvraeNOaXazqiO4vS93vKUz7Ug06Td3LfgLerIK8ww2rNhP3sz5X2ooajLs2MTQ7LzbLBNaCPu62XPvKI9ct+1m3UvmwTqtU+4f3ZEunbTXpZTf3Q47afha/WUJANkaMAjWlMsI0NuYrJ4DLcbYb3y7pZ50VgqT//Ulj7wD8XoLWFtlFRCGzJjRbrqAbI3iFhFwKyRrtKGps/GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YJyYqIVl4Kg+2zCk6+KuemzJbx4A7ReiKgme7HpX0M=;
 b=VcJ/aKJLHmyoBw1agaujZiv4SjgktMEi1TXO9TbT2xh7YpbMBnvZQBON27V84s5GtGlCmlEpkvP1QOJB+FtVAsskTJbnfCDz8qR2C8oR48gl8nvu/c+cJ25ZznM5V8WoZNseUSvOKlGOrh5Pk0eYqcfOig8c1y7TFhGUeHp016o=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB3485.namprd11.prod.outlook.com (2603:10b6:805:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 12:10:11 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::6d5b:2bcf:f145:d0cb%3]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 12:10:11 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC:     "Murphy, Declan" <declan.murphy@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: keembay-ocs-hcu - Fix a WARN() message
Thread-Topic: [PATCH] crypto: keembay-ocs-hcu - Fix a WARN() message
Thread-Index: AQHW5A5USu4meHJ2xUWraoJJH4U/b6oagaMA
Date:   Wed, 6 Jan 2021 12:10:11 +0000
Message-ID: <c9fb1462004f6cdca99538889faa3f96436fca1c.camel@intel.com>
References: <X/WB9IlpyIi+5p5s@mwanda>
In-Reply-To: <X/WB9IlpyIi+5p5s@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ab3b82-484f-469b-a2b1-08d8b23c045f
x-ms-traffictypediagnostic: SN6PR11MB3485:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB34855D49FAEBE62652CE081CF2D00@SN6PR11MB3485.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eUXEqVMWgJwCUBeH81zqJDDWCekbZXOYn7IwoMrTSlO1KmEK4CsUy7XX59v+NWUIvFpgirRpzsq+Gjxw37qGcwe+9xoPMquK5lxnGmOcrhMx9x6Vu44CtTcnDcpWoMz3d/lSEETRljIbrni/sK7ePISiOV5XRbcTLeoT3BWrk9UkEHPLD7OME2F1QJxtiG7SRwKbG2GmiU31652/hOWozedJjV2AAgaHR8u+3Bdo4odFDvqJthe/J2IqZ8DpKkb8QRwi2J/6IQQVG3cF7TTiqLw2V6xOh+fKvMUTafvDU8tM4AcFLtnJrEAN+BxB/JWPUS754OGgcRndaHnPjgP/4GueUVabTC02cn9hVdX4OsRGaRZ7BxGtnEf7czUUpnL+T2iGKi2otsnTBP7wywYFCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(83380400001)(36756003)(6512007)(54906003)(316002)(6506007)(4326008)(4744005)(76116006)(66556008)(8936002)(66946007)(26005)(64756008)(91956017)(15650500001)(66446008)(2906002)(66476007)(186003)(2616005)(86362001)(478600001)(71200400001)(5660300002)(6916009)(8676002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UG1sM1hNWjRJbVZYRy90dFVHWU1lR3o1Skk2TkFwWXRROUNYNFFNVkRSc05Z?=
 =?utf-8?B?YVh6a2oySDBUbmwvRU8vNjFPeGdsdjE1RjhTa2t5Z3oxWnlLYTBmcDd2VDBF?=
 =?utf-8?B?T3B3ZlZrRUFRSU03cXFjYkRFWXZyQUc5clM3RGEwK3E2ZVQ1c1dtemN0VUZW?=
 =?utf-8?B?aFVoeUVseXRtNXJncFVuQUwzRVJsM0toUmNzSjdIQWs3SWZLTmNtTTZiWE53?=
 =?utf-8?B?MGx2RitrWFNic0VmMVA3ZDJDRDUySVRXVTZCKzVaUUF0VC9qNzFENnc0R3Bu?=
 =?utf-8?B?RWxxMjRqVVp1UEdZajBqYmtQeG9pQmV2a3l1eC9zTFpQazJUclQyM0pvQ3k2?=
 =?utf-8?B?bWpQdWgvV1NiaWhzdU9ENGZ5cTlxY2I5VDZTWElTSGpLOVFoVm5oM05aRXk5?=
 =?utf-8?B?RXhzb3ZTUWlzQTZVNFI2a3FLM2czd3NJeFpkTFkrcWtlRHpaTUFCcmE0Q2Zh?=
 =?utf-8?B?UGNOR3QxdDd2VkM0a0pHaDQwWnBNbHRBQ0krdlFUTldxR2p2bDNHWDJTdGJJ?=
 =?utf-8?B?cGY1TzFzTHdzTTY5MVYrNWU0QnpScmFMK1krVlM3SnkvdWtjN1FTUGowOWpq?=
 =?utf-8?B?d0tCdWI3RDNab3N3bW5mNHlXaTVDQUVNeHYwSWY4aXlXRjdROENMMTFqUmVV?=
 =?utf-8?B?dTdrVXJkcythT0hCcFA2cVNlNWlhMHVGMDF6aG9Ja3hET0tjNHhjbTlNQ0lr?=
 =?utf-8?B?S1h6Y2JaaFVSY0xkbjNvcjFCei94RldPZ1ZqMmY3ZEc2eUZsYWFqaG1TR1Jq?=
 =?utf-8?B?RkFRWXdLSFluSXkwVWdFT1huQ2tSY0pSZWIxZW0zM1VOK2JUYzNtVGprZ0Jh?=
 =?utf-8?B?YnI2M0JyNW5TUTNldkZUcGVsQ1VHY0JLRXN6SW9xazg1MkdzeDBZeUFRay9Z?=
 =?utf-8?B?VTV0K0dOUlh4M0I3a1NZRU42REkrZVd5S1dSWXNRV1dUYVhvUnpiSVd6Qmtt?=
 =?utf-8?B?N0ljTkI3SkNpZVI2TWROVGVOQ280eDZNTjhTK2ZNRFlLdTYycFlPUW5zUTh6?=
 =?utf-8?B?eUV1ZHE5UnVFY0NLb0duS0RhbU1sYUxPQ3hUcWI3RWpPa0s5c3hleVhObW00?=
 =?utf-8?B?a0U0QmhsVFpXckdtVHp2bSs1SWltdEVyWlJEa1RaWE5HMjdjZnpscVMwaUFx?=
 =?utf-8?B?RzVRR3NRRGxYWlJ5SXV2cTFFWDdldG5oYkJIaG40c1o1UFpsQXZIa25JU3RO?=
 =?utf-8?B?eDd2ci9aOG0vLzlFN0JMNUtDbStkMGFqSXBicGdPblZvaVFwSlBNY3hJUXFM?=
 =?utf-8?B?Q0tFaGpzcWNyUXBEbnNTa3ZCZnhJVFpkeTQyWmM1VWtxbEp4K0sraHVpTE1R?=
 =?utf-8?Q?lfCED6cqaHX92dykX+GpQVyDrhoPBzilTl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73F28795998CBC4AAA91A5459B2D68C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ab3b82-484f-469b-a2b1-08d8b23c045f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 12:10:11.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XtchrHZIsD8WEqk9DOssnWNFGR6eCS9PzzRdjGlycTji6cGnYVHl5PX5/cNG17asJZPHulqdm6TMEgXJ+Mkh4Dkam5hSt+mTAX8K3LnJm7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3485
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgRGFuLA0KDQpUaGFua3MgZm9yIGZpbmRpbmcgYW5kIGZpeGluZyB0aGlzLg0KDQpPbiBXZWQs
IDIwMjEtMDEtMDYgYXQgMTI6MjUgKzAzMDAsIERhbiBDYXJwZW50ZXIgd3JvdGU6DQo+IFRoZSBm
aXJzdCBhcmd1bWVudCB0byBXQVJOKCkgaXMgYSBjb25kaXRpb24gYW5kIHRoZSBtZXNzYWdlcyBp
cyB0aGUNCj4gc2Vjb25kIGFyZ3VtZW50IGlzIHRoZSBzdHJpbmcsIHNvIHRoaXMgV0FSTigpIHdp
bGwgb25seSBkaXNwbGF5IHRoZQ0KPiBfX2Z1bmNfXyBwYXJ0IG9mIHRoZSBtZXNzYWdlLg0KPiAN
Cj4gRml4ZXM6IGFlODMyZTMyOWE4ZCAoImNyeXB0bzoga2VlbWJheS1vY3MtaGN1IC0gQWRkIEhN
QUMgc3VwcG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50
ZXJAb3JhY2xlLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L2tlZW1iYXkt
b2NzLWhjdS1jb3JlLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gDQo+IA0KDQpBY2tlZC1ieTogRGFuaWVsZSBBbGVzc2FuZHJlbGxp
IDxkYW5pZWxlLmFsZXNzYW5kcmVsbGlAaW50ZWwuY29tPg0K

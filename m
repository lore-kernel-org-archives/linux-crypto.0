Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836D7C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526B964F27
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 12:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhCDMC5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:02:57 -0500
Received: from mga17.intel.com ([192.55.52.151]:21204 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239787AbhCDMCp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 07:02:45 -0500
IronPort-SDR: 2MckNTXxxnVyreoL6h602KiRuBVbrn6rv7uuKVGE2ziOS2dtyNQdm72xEQGSa35vYvthS+nPN3
 HyNaNBo06qRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="167299610"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="167299610"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:02:05 -0800
IronPort-SDR: K3E3aY249dAxLjn2rv31okbHHBe0YDViG8VmcaHG14FzIpJ/5E9uNWtu4NRqLsEGlOiaPTs6vz
 gRwebLZaBXjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="400578835"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2021 04:02:05 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 04:02:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 04:02:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 4 Mar 2021 04:02:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 4 Mar 2021 04:02:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3bWFJrRu/CFLmCSW8cdB7+n3j52meL34mcPXvNcr06nzXuInzRmxnwIWPLGFf7k/OQiY6Y/7PIMpuqJsi2GyCAlmElUwCeejh6IdFCpBMZtfL/eSP/3G8fMMNglwPaRYEYvh7n6ZWfAsA+cmaw8ykibFHFrnTHVPACdGk7TnCyLPUHGpBTzQu8vJcQub4Ag7+16NDbJUe6rNdoeYJLH8ZcI+fzzOwBhkveSa1bLDok/+GWyDHnIT4+r5gadDb4xM0KLgor9Kpt+TYF+gKMPJ3UVwqTikmZ4kUHE+9AvJvzH+iuq2e9Ruy/v1v2a7/KOrgciAYuqZQKsszeLMc4Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jbPvXqjJn7FgdU9LkvPJnUkiAFURs/Z8x+Gf82rRSw=;
 b=l52L6+ttYNxe9kjJTLlTe1bVlWb8wxlI2b8G7e+G7kTq0nIqsGvyz5cIoP963LVWnkEvR8pnNy8kyo35eXUOBgwwmhuMgajfBABvjKKR+szFXUwUipkCPTG2ZSl64zOZxFbR9SlIGitEhBAoWgIfutyONA6kyNB8uexVAFQWeb11hD7/yd2xeSxezZDfEl+yHmXsRbyt4426CCGLszrhvxklc5NdghldJ9oVxyTc1YGtgw4unP5+ImyJgRDi1EXVSKD1vFatGvSCzqC2OUyLvp0DhPx+1CwppzNDNFTJdveXkA8eTuXKckLPmgfDgMdmVz8lnBFV8dr5ujvTxuJJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jbPvXqjJn7FgdU9LkvPJnUkiAFURs/Z8x+Gf82rRSw=;
 b=ebZWm5Ak/eDvmXE/ZjLBHiES4s58AUTGmm/6A3v4hjGuYnWRRaFIarbTrmoVkSq9SXtK/g+aE6ibHHGJtkmVxekCVDpIY5Aty+PFw+EkNgX1VxZrEIn6tS2D94Uomfx91w1dR0j73uk4ZsUjYDxaAecXeucYDe0RztVHpMfTnm8=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 4 Mar
 2021 12:02:03 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%7]) with mapi id 15.20.3890.030; Thu, 4 Mar 2021
 12:02:02 +0000
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
Thread-Index: AQHXEDpuG9OtMND6ckyNWWTs05as56pzu+eA
Date:   Thu, 4 Mar 2021 12:02:02 +0000
Message-ID: <7d54b93328abe346c57f73886f8104630a5b82be.camel@intel.com>
References: <20210303143449.3170813-1-lee.jones@linaro.org>
         <20210303143449.3170813-6-lee.jones@linaro.org>
In-Reply-To: <20210303143449.3170813-6-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e58ec30a-3ea8-4db0-ac0c-08d8df0552be
x-ms-traffictypediagnostic: SN6PR11MB2575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2575F437564486E0C19DA173F2979@SN6PR11MB2575.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lzGce3jY4+/MJMXznWtmel9Th8Nsdi/lvgHojfKoINOcuycnNsvHlTuPECkKbL+nQbimkVVE1oh4PiVY4aXO8hO6E7m9dI19PN1kJ+5HuhRhn50vTfdKFFISa86k8+bq29Bg/iMH+9Kq2J9WoLhU/cLnuSff5FBsuszlwPvn1b5U+zfIOE/Smdy1RNYKZdNMFtC+GgS2iYHRTlB3BspQBMxL2mSC3a4fHLaZk+dCB8Mus6pI653ODoQkVELSEzzE5KcqdbhsalVnllH0KeBpcZvcyoyjQLDccEtUKsTEHKgLLIaAfTAv4aYiGl1NDyu1o4SAqDgDDcCEZSw1uAvQLyZxCUVi4VOW7I4pPkLTPAvAMOu+Li3jxnAeUvkdWp6f+WoegS/zNUu8Gl520R4tX5A3HEGa5e0F4wL0iSN8J3AzfWiuxNJ1otXjJFh6mr0ZIslF8Ov2nPlLjus9nkYrthDnfdkbRzAoLhd+07X/Vkv93mPnoKfT6iW0gR/y9Xl/85SbuPG/BrhpzWryGgvHDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(346002)(366004)(8676002)(26005)(86362001)(36756003)(5660300002)(8936002)(478600001)(2616005)(6916009)(6506007)(6512007)(91956017)(186003)(71200400001)(64756008)(66476007)(66946007)(6486002)(83380400001)(66556008)(4326008)(316002)(76116006)(54906003)(2906002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bGxPLzZtZWRXWUZHRmxIQnBQRCtQTXgzVDFJdG9nbm0rRlh0aDE1cUZlZUJX?=
 =?utf-8?B?aDZtUDA4alcvKzRNQjV4eW0xSmNhM1BmOGh2clhpUll4c3dFM2xHdW0zMXN4?=
 =?utf-8?B?RWVBQUZBMkQ2OFBtK1JVRXFhUFo2K3JhMkFXT0dySHlOTi9qaC9aM3dtbW9k?=
 =?utf-8?B?Q3ExSXJ0Zkk0OC9KVk16NlA5d3Fyald0YmpnWEU0bFRpb1ZUNW1lcTNOM2Jm?=
 =?utf-8?B?VGkxVEwzZmJkR3R2MExSTHViNG9YdHpCNEtheDBnODdraXh2b1pwS2Q1RDZC?=
 =?utf-8?B?c205UTVRRVZjdXV4WGRRdW4zdURaRENWWlJDbnVtZTdEUDZCd0J1cUtFMkhG?=
 =?utf-8?B?TVVXZFQwamhrdTZFUzN2YUsybUc5NGYrTXNPVWEvdk5kYy9zZ0hwcFNxQlRy?=
 =?utf-8?B?ME1wVGRqZGM3dmkwa0J4eHZ2K1o4cDJsMzJabXNtTjlvdGdZMU1lNjFZcnU1?=
 =?utf-8?B?QzNuKyt1UUhxeVE0eVFIck9hS2dkYVhva3VZVjI0dVl3cmJPeHZiRTVka3ZF?=
 =?utf-8?B?cXVEWFNoQXNrWE1IUVovVnVrcnJSYTQvZytGYkxlWHUrNTFibjBGc2ZDdERl?=
 =?utf-8?B?Qjh5cklNaitTMXFOai9FbE5PZ2t0WkRabEVrTTQvSkIwekFDcjR3ZjNSYUVG?=
 =?utf-8?B?UkVVVXMvQ2puNWRtdUExOExzclgxUzFkVTBmK2JhbUVaWmw5UEsxNTNJTkI4?=
 =?utf-8?B?Qjl3ZmR2N0FBc3Z5Z2VLWXZCaUZKRGRGcHowc1pqL1dYdFZ1YW94dEtJc0JU?=
 =?utf-8?B?d0JMRjQ4WG12SElxcVI2djc2b3BpR2EzcnpGZGRjTzQzbW5pcXRwWVRmN1Qx?=
 =?utf-8?B?WHRIaTZ3bHp2dEx3R2l4VFVhdVloZDc4VnFyMHRLcUpEbEwrelFVMWlmQ3Fs?=
 =?utf-8?B?bDBKQnU0MEZQSmFpQ0sxd3JpVzNETjM1WkJJNlB5STRzemJ2aklhL2ZmWGZ0?=
 =?utf-8?B?YnVFZ3Rob3U0MGhGRXRLRG45S1VTL1RRejB2T2t2S2lTdzFxbTY5QTh2VG9Q?=
 =?utf-8?B?Q2pxaFZjM0dNcFNJTkpiVmJ0RURUTmFvdElqQU93MU1KUWtsQ1VZOHRrWEly?=
 =?utf-8?B?dGkwT3lIUDdlQXpHVXI4MnVMeTIrdVFrQ3pKV2xuTnhXQkxwOG1maTc2TzUz?=
 =?utf-8?B?ZmF3K0xBUGYzVjIxWFNabVo5RFduS0pVTk5Fa0dQRXFnVTAyV1VyS2Zndlh6?=
 =?utf-8?B?bG5INkNMU05tODlJb1hwQ0NQMEdleFlXSnMvOS9pbFp1UDhrbkFlcThNbFdP?=
 =?utf-8?B?dGpWN0N5ZmYyQnplWXpOY29rNW04bXBTWFZrdk5OR2Q4Qm9vUHVNR2pOV3dX?=
 =?utf-8?B?T0NCZ0ZrK0hFa2U5TlVueWh4QUF0RTNLWVVFVlVhdHJtUGs1Q1pNZHl0bEh0?=
 =?utf-8?B?RVNNMWJBZjRkQUN6VmdZQzhwdEVNcDJtalVUcFk0QzZab1g1TWcraGtoa3BZ?=
 =?utf-8?B?Sm1XTmE1aWxNMVZueFdMVzNqZWtiU1hWRHFQdExrNndRalg5amlINExVa1hD?=
 =?utf-8?B?WmNJWmNacFltb1lEMCtmci9hRExuQUpZN1JidHBYZDd5MnFGYlA1dzQrU2hn?=
 =?utf-8?B?cEVmRkhsM0lrbFJrY3U3N3ZmdU95UWNOa0tkMlpERWxDOWxaVUM2eVdZRDJl?=
 =?utf-8?B?K2ptL29xOCttZkhtSDdFYkhabkUzYzMzSXNSU2VXWjc4aU55Q3lYVmkzdzkv?=
 =?utf-8?B?TURZS1M3TGV0a0xZZk9oL1QrQnBldGYxWUh5RTR0eGJnckZVQjRWQ1RkbjMr?=
 =?utf-8?B?RHl3c005K2E4Q0JKZ3VFWWFJdms1ZGx2TDBlbVBaWERFUWpiRjBVL3pReFBs?=
 =?utf-8?B?LzlheU1BTEJoWU55VW55Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA7719E63C9C544A9F1003C7B9378F48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58ec30a-3ea8-4db0-ac0c-08d8df0552be
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 12:02:02.7903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XotVM91tUn2dO54WS/2VCxprmnkUgPn1ck+l48y5lUrC0Q2IJ6XgWcMRvskwH1nVMrsrlx26w5PnwvX8YoEr2xCc5iVL55+sLBfRlkscE48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2575
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SGkgTGVlLA0KDQpUaGFua3MgZm9yIHRoZSBwYXRjaC4NCg0KT24gV2VkLCAyMDIxLTAzLTAzIGF0
IDE0OjM0ICswMDAwLCBMZWUgSm9uZXMgd3JvdGU6DQo+IEZpeGVzIHRoZSBmb2xsb3dpbmcgVz0x
IGtlcm5lbCBidWlsZCB3YXJuaW5nKHMpOg0KPiANCj4gIGRyaXZlcnMvY3J5cHRvL2tlZW1iYXkv
b2NzLWhjdS5jOjEwNzogd2FybmluZzogZXhwZWN0aW5nIHByb3RvdHlwZSBmb3Igc3RydWN0IG9j
c19oY3VfZG1hX2xpc3QuIFByb3RvdHlwZSB3YXMgZm9yIHN0cnVjdCBvY3NfaGN1X2RtYV9lbnRy
eSBpbnN0ZWFkDQo+ICBkcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYzoxMjc6IHdhcm5p
bmc6IGV4cGVjdGluZyBwcm90b3R5cGUgZm9yIHN0cnVjdCBvY3NfZG1hX2xpc3QuIFByb3RvdHlw
ZSB3YXMgZm9yIHN0cnVjdCBvY3NfaGN1X2RtYV9saXN0IGluc3RlYWQNCg0KSSBkb24ndCBzZWUg
dGhlIGZpeCBmb3IgdGhpcyBpbiB0aGUgZGlmZi4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0K
PiAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtaGN1LmM6NjEwOiB3YXJuaW5nOiBleHBlY3Rp
bmcgcHJvdG90eXBlIGZvciBvY3NfaGN1X2RpZ2VzdCgpLiBQcm90b3R5cGUgd2FzIGZvciBvY3Nf
aGN1X2hhc2hfdXBkYXRlKCkgaW5zdGVhZA0KPiAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3Mt
aGN1LmM6NjQ4OiB3YXJuaW5nOiBleHBlY3RpbmcgcHJvdG90eXBlIGZvciBvY3NfaGN1X2hhc2hf
ZmluYWwoKS4gUHJvdG90eXBlIHdhcyBmb3Igb2NzX2hjdV9oYXNoX2ZpbnVwKCkgaW5zdGVhZA0K
PiANCj4gQ2M6IERhbmllbGUgQWxlc3NhbmRyZWxsaSA8ZGFuaWVsZS5hbGVzc2FuZHJlbGxpQGlu
dGVsLmNvbT4NCj4gQ2M6IERlY2xhbiBNdXJwaHkgPGRlY2xhbi5tdXJwaHlAaW50ZWwuY29tPg0K
PiBDYzogSGVyYmVydCBYdSA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiBDYzogIkRh
dmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBsaW51eC1jcnlwdG9A
dmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IExlZSBKb25lcyA8bGVlLmpvbmVzQGxp
bmFyby5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9jcnlwdG8va2VlbWJheS9vY3MtaGN1LmMgfCA2
ICsrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2NyeXB0by9rZWVtYmF5L29jcy1oY3UuYyBi
L2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jDQo+IGluZGV4IDgxZWVjYWNmNjAzYWQu
LmQ1MjI3NTc4NTVmYjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2Nz
LWhjdS5jDQo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2tlZW1iYXkvb2NzLWhjdS5jDQo+IEBAIC05
Myw3ICs5Myw3IEBADQo+ICAjZGVmaW5lIE9DU19IQ1VfV0FJVF9CVVNZX1RJTUVPVVRfVVMJCTEw
MDAwMDANCj4gIA0KPiAgLyoqDQo+IC0gKiBzdHJ1Y3Qgb2NzX2hjdV9kbWFfbGlzdCAtIEFuIGVu
dHJ5IGluIGFuIE9DUyBETUEgbGlua2VkIGxpc3QuDQo+ICsgKiBzdHJ1Y3Qgb2NzX2hjdV9kbWFf
ZW50cnkgLSBBbiBlbnRyeSBpbiBhbiBPQ1MgRE1BIGxpbmtlZCBsaXN0Lg0KPiAgICogQHNyY19h
ZGRyOiAgU291cmNlIGFkZHJlc3Mgb2YgdGhlIGRhdGEuDQo+ICAgKiBAc3JjX2xlbjogICBMZW5n
dGggb2YgZGF0YSB0byBiZSBmZXRjaGVkLg0KPiAgICogQG54dF9kZXNjOiAgTmV4dCBkZXNjcmlw
dG9yIHRvIGZldGNoLg0KPiBAQCAtNTk3LDcgKzU5Nyw3IEBAIGludCBvY3NfaGN1X2hhc2hfaW5p
dChzdHJ1Y3Qgb2NzX2hjdV9oYXNoX2N0eCAqY3R4LCBlbnVtIG9jc19oY3VfYWxnbyBhbGdvKQ0K
PiAgfQ0KPiAgDQo+ICAvKioNCj4gLSAqIG9jc19oY3VfZGlnZXN0KCkgLSBQZXJmb3JtIGEgaGFz
aGluZyBpdGVyYXRpb24uDQo+ICsgKiBvY3NfaGN1X2hhc2hfdXBkYXRlKCkgLSBQZXJmb3JtIGEg
aGFzaGluZyBpdGVyYXRpb24uDQo+ICAgKiBAaGN1X2RldjoJVGhlIE9DUyBIQ1UgZGV2aWNlIHRv
IHVzZS4NCj4gICAqIEBjdHg6CVRoZSBPQ1MgSENVIGhhc2hpbmcgY29udGV4dC4NCj4gICAqIEBk
bWFfbGlzdDoJVGhlIE9DUyBETUEgbGlzdCBtYXBwaW5nIHRoZSBpbnB1dCBkYXRhIHRvIHByb2Nl
c3MuDQo+IEBAIC02MzIsNyArNjMyLDcgQEAgaW50IG9jc19oY3VfaGFzaF91cGRhdGUoc3RydWN0
IG9jc19oY3VfZGV2ICpoY3VfZGV2LA0KPiAgfQ0KPiAgDQo+ICAvKioNCj4gLSAqIG9jc19oY3Vf
aGFzaF9maW5hbCgpIC0gVXBkYXRlIGFuZCBmaW5hbGl6ZSBoYXNoIGNvbXB1dGF0aW9uLg0KPiAr
ICogb2NzX2hjdV9oYXNoX2ZpbnVwKCkgLSBVcGRhdGUgYW5kIGZpbmFsaXplIGhhc2ggY29tcHV0
YXRpb24uDQo+ICAgKiBAaGN1X2RldjoJVGhlIE9DUyBIQ1UgZGV2aWNlIHRvIHVzZS4NCj4gICAq
IEBjdHg6CVRoZSBPQ1MgSENVIGhhc2hpbmcgY29udGV4dC4NCj4gICAqIEBkbWFfbGlzdDoJVGhl
IE9DUyBETUEgbGlzdCBtYXBwaW5nIHRoZSBpbnB1dCBkYXRhIHRvIHByb2Nlc3MuDQo=

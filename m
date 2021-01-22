Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6777C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 12:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E27F23444
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 12:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbhAVMIa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 07:08:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:44427 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbhAVMIL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 07:08:11 -0500
IronPort-SDR: w/D1AzMC8C/Il9KUpND2zqkzPs5BCVnSlolpLfXiobEEFS+FGgvk7CEt1Kv11MZz9kXnMkmSgf
 h7tmTTfQmOXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="166537742"
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="166537742"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 04:07:29 -0800
IronPort-SDR: 6zImcqHfIoK5pxujFohX7OuXSu40YlUKQc9UaBreKy2LBNLpBdoBB+FA0W8ZVzZkEP91eLmXrw
 Az5/PjGeIbhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="351857176"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga003.jf.intel.com with ESMTP; 22 Jan 2021 04:07:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 04:07:28 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 04:07:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 22 Jan 2021 04:07:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 22 Jan 2021 04:07:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjwBRGixHN9EbIbirPBka+6kJlZWZ0yfvAabn6G+l+qPY9dJ8rUhZ5UCurMCJk0Pj8Ini17s+XABPJrvvwysXh/lt4o3KRI1J4xK93+aoYUgmv1BK+swlAk5SmyoaiIKCcvdW7Led/2V99MmBOLgRzABZ1mLr1syBUmAL3KFb4hW3S5Y51h+TsrtwoeKknghoDfcPSJz68T3+DKi1eyui3STzzN+d4EyEKpXOfdglIDLJjWjeCnLAGWwD+bw7nD9lK72jVv7ZJiQ9YeRSWZUnMxXSTyat2GKCaQMQyNvKE2qKXrjiUZRkialLDwmeov87fcQcgVX8smHh4a+vRBZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dCHRqG5kuxg2Z4LuKq4K73K7J9lMt1iZT8hD40wV1I=;
 b=F6NiXpci8HJhryMHQMuP9rq8u4NC6xZu3W/H/mstHb/EX8d0bPOSsGIRHbiwNqUUGkOJdo2cSd4iZ4ULGq/ZYO5z8Wz+FB1xZ/C39nJWRCk5TOY2sw22syoGdVNGu1fS60Qtip6j6FtjVlG8PH40H+Od0/COSJv4xNl1+kEldMWuUmvqq01OjBPgiQ8HBQB6QyR5gzNnnecwmwaTOJzjrw3DOeYAdadfR7za7iCh6tG1BLI9lU7tPdIPW6Y7ATr3vUOj8EFkJ25ZgTEMltVWyOD64IzgGqnq2qsZZRY93uKnQWJTF4qw41PYlezBLj7AyuwxU69g5NryEUqNejhFQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dCHRqG5kuxg2Z4LuKq4K73K7J9lMt1iZT8hD40wV1I=;
 b=rSyQb36I+JLOW37MWYUF9NdSoBkF73lrR5/tFx2XlkahCBXTDeafVk1AT9vsF5DHffilWGe7OGg7Vy/qNaNa58X2JuA0XOZf6EZMIQ7JdDjsMO1xsiPRJJT1cfW+kLGkkZFl8aXWWAXxUImmaZGuIErA/OHrs+D1uovqFCni+cg=
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by SN6PR11MB3054.namprd11.prod.outlook.com (2603:10b6:805:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 22 Jan
 2021 12:07:27 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::d4a0:9ff0:15b8:cd76%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 12:07:27 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
CC:     "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mgross@linux.intel.com" <mgross@linux.intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Topic: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
Thread-Index: AQHW1JkZp0lFZ4RWHkSmMpliCOeP3aoXNzCAgAA5/gCAADTIgIAPb+8AgACGmACABdvZAIAABCMAgAOXb4CAAPk8AIAAangAgABABICAAQ13AA==
Date:   Fri, 22 Jan 2021 12:07:27 +0000
Message-ID: <b8fdb83a067d603d1e5644721be035ebeeac6ea3.camel@intel.com>
References: <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <20210104113148.GA20575@gondor.apana.org.au>
         <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com>
         <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
         <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
         <7ae7890f52226e75bf9e368808d6377e8c5efc2d.camel@intel.com>
         <CAMj1kXE8TnHvZrp2NQv9SJ4CfUOxy1sVXVusjrSWaiXOjRTQ5g@mail.gmail.com>
         <711536383d5e829bd128a41e1a56ae50399b6c26.camel@intel.com>
         <20210121200257.GB27184@gondor.apana.org.au>
In-Reply-To: <20210121200257.GB27184@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gondor.apana.org.au; dkim=none (message not signed)
 header.d=none;gondor.apana.org.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.151.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b31613a8-9b2a-4358-50d7-08d8bece4940
x-ms-traffictypediagnostic: SN6PR11MB3054:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3054CF5F06DD7A4CBF9D143DF2A09@SN6PR11MB3054.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TtppQJDoCviRH8cOuSBoe7gIl1yu/KooCXki63JmRuvUr8lidNBchFgOCx9IjNA9We6qLRZHF2iMIIuMXzcxM48RmBjIKX0Ntaiz69inMUVHPXz9Lsx6FKjH/hzV67R8Y+47t9Kv3u9R03xFuwGODMEf2mkgaChOGwPn7n0wQm82f/bCLCOCKKAzKDme0QnXlYX37NefWISXWKYLQpQKbVnvKfpcxls98ofuN1hVAcHukEXheftK9Qr6mV7aR3kIUXJz9YkxWliPKIj8sTmYXtBnfaNjO9yRV8nFZ8q/N6XreoVkkOD5QcpRagCavaWaBT0QXqQVV+X9I/b9Ks5WqZChUrW3fpDt3GtfCwFhxCslxDqXCAAe+sBIm+0fACyiZK5hypSO0B4HHK1/A6KvoVhpgZFDVvEP5AL37YP5CXPDzbRyQfzanz3fChUiDN5wtvxQqdMLCR5D4oUuI1MDisMHFNCyyYgP9TkAzx61vJW4NEaxzYeKs/NV91QnTJcNY4v7osf1xqwqnfEEXRYesQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(26005)(316002)(6506007)(4744005)(4326008)(478600001)(8936002)(54906003)(6512007)(6916009)(71200400001)(186003)(6486002)(8676002)(86362001)(2906002)(64756008)(66556008)(36756003)(91956017)(66946007)(5660300002)(76116006)(66476007)(2616005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YStEcVZoeWJod0plUVNGTHpsbldnVGVMd0NvcWlFS2FzWEh2VG9QdnhsMFdt?=
 =?utf-8?B?V05HbS9kZ2ZmTEhyczl2U2Qrb1R4T2hqOXlKa1c2YXl1NkxYVGphVDBXVTlP?=
 =?utf-8?B?OTNkNmVERFp0UVY1N2RIUWZiMTJzbUdiZmtWU1ZkV0dEcE1GSWxkemt6RGF1?=
 =?utf-8?B?WE9WRkxSS1N5RW9tUFk4a2o2K2NNUTh3bm5jRUhSMUFFdDd0aG9Mb0pudUpC?=
 =?utf-8?B?WFJzMVk2RWIyQ3ZjV3NXVUkvRFpvN1psSC9BT2JXWXVibE9pZkZBUWh4Sk1C?=
 =?utf-8?B?cmRNM0wzc0E4NmtjVnowTVJlZUxnbmw1Z2tKcmRkUVdxUzZMZUY4SlpaazVl?=
 =?utf-8?B?MTQvVitTSW9LVmUzc0wvcWZTZDJnR3dvZkU3SGFuUzdrVFBLTk5zQVZ4K00x?=
 =?utf-8?B?SlZMbC9Fc1I3K1FPaVlyWThTUzE1SDJHZEVBTTVCOHFlQUJFYWJOSnd3N1dK?=
 =?utf-8?B?Y254NWEyYzhSdnZ4QWFIbnd1bkVaeXgzekF0NHJQY1poMEJqR1pPMG1JY2Fx?=
 =?utf-8?B?bG1sdW8rRU95M2VNbXlqd3ZBcGgvUTR5MFBITXl4Y1B2SHdhVHZoY21lSkli?=
 =?utf-8?B?L2NaTU1LRlpjOUR4eklmNmhaMVFvZDRxT3ZwVjZTeERRVEVnVVpXZjZ1L2Yx?=
 =?utf-8?B?bHJPN2FQOVJDOUxiemlJbDQ5NWg5TGJYaHBuNzFhUTNuaGNSWitTbFJtczhI?=
 =?utf-8?B?cHdmd0d1NnFEaXpvY2JZdGRCcG10S3pkNFpyZ1pMS0YySG5SQk9LS2JDa25H?=
 =?utf-8?B?VmdlUCtNVzhRRGh6MHkzRUJxYjJFdTRWTmp2K1NOZXZNVkMvVHF1T0R2Ylk1?=
 =?utf-8?B?OHBKRjNkVnRkTlU0VTFhcjNFak0zbDVNVDhzTzZYY2h2OW1JNm5uTVYzZnhT?=
 =?utf-8?B?YzZQTFhab2M5Y3Fja2hFSWRqUnF4NXE5Z2lwSktuS2NFNjdLeDFGL3hYeEsx?=
 =?utf-8?B?cXN5MUNSMVNBRTUzbGpQRTJjalRBYWVSVGI0VGFkTnh6OTRTMVZLQkV1R25R?=
 =?utf-8?B?YWxLTzlzRytqdVRVV2VPbDBZdG94LzdpNXlZTS9MK2dYZkNLWlJsRWgyY3I3?=
 =?utf-8?B?djZicUdlV0M2RTNIVnhzdG1qZTV5c2tjekFVZGNJMFUrQUpEUG9pbGR1VHJm?=
 =?utf-8?B?TDNUUkVEK3UrclhFUzNILzU2Z0JJR3VsZ3I0dGpuNWJPRDMzcnFjb1hjaGtV?=
 =?utf-8?B?dEY3V0orY3lCRzJPckVpU1dLeGJPNmlUN2g0aTBpOG5NdEY5d3haQlpnMGtP?=
 =?utf-8?B?QjlwT0tIc3FjSXBVSGNQeGtPSHc5WFZPQ2J2bkFlZkRXYVVSY0JJazVOSUlT?=
 =?utf-8?Q?PyYVZwkChb+shP4v9G2NRkGbT6JDuzaSNn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8AA94CAE7599774BBBCB447E80081565@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b31613a8-9b2a-4358-50d7-08d8bece4940
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 12:07:27.2898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HS+4LvWWuJ1tbZXI3XZOuV4GiqjIdWzODecQfek0MsIdxcfNVrV3Tlr8OP/ZyBvNYVRYgP2kWFdBU4FXn12VK9Eio0kABAW0g+cN1pSUF40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3054
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gRnJpLCAyMDIxLTAxLTIyIGF0IDA3OjAyICsxMTAwLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiBP
biBUaHUsIEphbiAyMSwgMjAyMSBhdCAwNDoxMzo1MVBNICswMDAwLCBBbGVzc2FuZHJlbGxpLCBE
YW5pZWxlDQo+IHdyb3RlOg0KPiA+IEFzIGV4cGVjdGVkLCB0aGUgc2Vjb25kIGltcGxlbWVudGF0
aW9uIGRvZXMgbm90IHBhc3Mgc2VsZi10ZXN0cyBhbmQNCj4gPiBjcnlwdG9fYWxsb2Nfa3BwKCkg
cmV0dXJucyAtRUxJQkJBRCB3aGVuIHRyeWluZyB0byBhbGxvY2F0ZSBpdCwgYnV0DQo+ID4gSSd2
ZSBzZWVuIHRoYXQgSSBjYW4gYXZvaWQgdGhlIGVycm9yIChhbmQgaGF2ZSBpdCBhbGxvY2F0ZWQN
Cj4gPiBwcm9wZXJseSkNCj4gPiBieSBwYXNzaW5nIHRoZSBDUllQVE9fQUxHX1RFU1RFRCBmbGFn
IGluIHRoZSAndHlwZScgYXJndW1lbnQsIGxpa2UNCj4gPiBiZWxvdzoNCj4gDQo+IERpZCB5b3Ug
c2V0IHlvdXIgYWxnb3JpdGhtJ3MgbmFtZSB0byBlY2RoPyBJIHRoaW5rIEFyZCB3YXMgc3VnZ2Vz
dGluZw0KPiB5b3UgdG8gbm90IGRvIHRoYXQuICBBcyBsb25nIGFzIHlvdSdyZSBub3QgdXNpbmcg
dGhlIHNhbWUgbmFtZSBhcyBhDQo+IHJlY29nbmlzZWQgYWxnb3JpdGhtLCB0aGVuIHlvdSB3b24n
dCBuZWVkIHRvIHBhc3MgYW55IHNlbGYtdGVzdHMgYXQNCj4gYWxsLg0KPiANCg0KT2gsIGxvb2tz
IGxpa2UgSSBtaXN1bmRlcnN0b29kIEFyZCBzdWdnZXN0aW9uLg0KDQpJIHdpbGwgY2hhbmdlIHRo
ZSBzZWNvbmQgaW1wbGVtZW50YXRpb24gdG8gdXNlIGEgZGlmZmVyZW50IGFsZ29yaXRobQ0KbmFt
ZSAoY3JhX25hbWUpLCBzb21ldGhpbmcgbGlrZSAnZWNkaC1rZWVtYmF5LW9jcycuDQoNClRoYW5r
cywNCkRhbmllbGUNCg==

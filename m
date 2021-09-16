Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E0FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D125D60E52
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhIPRIW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:08:22 -0400
Received: from mail-sn1anam02on2066.outbound.protection.outlook.com ([40.107.96.66]:11076
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245027AbhIPRGU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 13:06:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFAcfvyl1Td3Bl8ngHL1vyZHZ4S2GF515fV7z4sNGkXiuZXycHhM0mFcfnHeCuQr50Ywh2nCx7mBn03+Umy4ZeulerWUJTLvm5jw/fl4pDX+dGrKFZAxIQDIfioD0qmyUceAZCfKdUZ1HBIwPELLUIJFnEb9nkuop4ZqYoZQV2wpOKOetMbDM6emPZAijokgK5hjlsEpje8Y1CCe7iVWDCG6l3edUjA1aJWbUhwRz7c7a16kKzux/N3MSq+Nh18/zw4xXBilWtJw/S2AHJBmLJMscTFniDLdF8Gn9LrNM7QN6SCQgSxqczBBjA32WZO9c0mXOMXB6FItyNGSMBTofw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ISpikRviDqmBekZmBFlrM4/nQkc/CDUtoEjtA+BX9zc=;
 b=CUwg3gmTKJesLLKANXfyCoDxi+Jr0+/FKR23rUl+aHFn6ipXa/L40GTRHJ0ZAUc/bnQGjgEHf5WoIJVrFE9rZ9AcRjSGxXvPoD6WWrKFbb3hcMXIAZ9eYrVN7oZWCV5yZCaxe0XMCKMN9vozDOD++zjVXtHwTvSOM37kx6ByXZihWgBHiPhkkgpBVq5WGP9fAHoRqCjgijI+FkADWn0Rgo1airjC1FdN93QzXwNb2KO9xkasSx5Ix0jFlacIwicOGOvvIuAvhMpPYca/NWLNBb1O2FMo5prv1Bc1qQaD808xGR6vlf6XCgeOoG0DpHzNNNBS/4BsYDbYG+Vb+GZ6Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISpikRviDqmBekZmBFlrM4/nQkc/CDUtoEjtA+BX9zc=;
 b=fS2EgWCDD2p2BchdPh/8ufjrfrJRIYCZK2lS2KHLrvF9f024LWUIm+sIFr3Hhvyva9wl9AUSkDuE2stBfI0JJZvfQiM/B9kXmeAPuCd0rVIfN0upLF0Sp43w1e8pOwJAbOITzPjvZHK6clj9wZXfJ8UGhUP57qKZBmPH/TrUYkvcA0O+Ddy2TFy14COYW7Vc/EtKRWYiMVSC7PHH9bEG5xEkZD0bJ2CEixusWuXolNKoPVD/Ji967P9ZYRcmL4nOp5qWo+d+b7LnXECu6/i7HoiCmqlrqaRvoSggsvdb6fBBHCfN3Zcz6fJMOMHHyoINuB9xPqU6yxMOQN0Pk/jl4w==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR1201MB0271.namprd12.prod.outlook.com (2603:10b6:301:57::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 17:04:56 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 17:04:56 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 06/12] nvme-fabrics: decode 'authentication required'
 connect error
Thread-Topic: [PATCH 06/12] nvme-fabrics: decode 'authentication required'
 connect error
Thread-Index: AQHXpg+Us5utNpoC4UOqIT5Z8VROV6um7dMA
Date:   Thu, 16 Sep 2021 17:04:56 +0000
Message-ID: <debb3e34-4758-3c67-a974-7cc315a5a4c9@nvidia.com>
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-7-hare@suse.de>
In-Reply-To: <20210910064322.67705-7-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5d5bc1b-92e5-4235-40c5-08d979341bf9
x-ms-traffictypediagnostic: MWHPR1201MB0271:
x-microsoft-antispam-prvs: <MWHPR1201MB0271C507D654CEE015BC97F1A3DC9@MWHPR1201MB0271.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4jtvhi75iLix/1/2PrvCLXCOFxQawyi0oHP+ZEptV4Ettf8pyYQausVDXCV4rC3CralIhuGEoUDbJqZZAnWKvixvnagYoXQbSeB8pwkIKsq1egmDgmSsimflbky1x0ukqaAj1c0WgV206SdbL6rAflJ0tAkdevwl2GlTTsdfnNBQbALiz6io40JVdZHrGAeOZG+6cHLNMQJBYeeidgHHmOUs2FbiDUuyMVDY4cAYJweTlpu1kjWClIq3vQgd/o8Jw3vpV2AnHlspO3JEj6I0uYs36HTS/5J4DaHzQu8N3fKrNVlJ6K2G96RGPbUE8ONgFvyTrpBfFtoG6/jM6GRdC8ZnTjAle10Fe9+2AAWAFooX9Bm+ZWFWHbWcKjYoIpPKj3AugIUDKw2o3uDC0tdDBXEcjSjv7xFggTM20zpfg8QWdjlp1gxTnPjKyvB745KykKMhGleQ6DMDsJcnfv7dMCewi+iWtl6Wsm7jpvXHPVXJsOclcVkzn1+F7EwImlwASl2pR0NaptRxoX85j0CAk2UfCMIq53q9w1cvBrTjWoQUpkyOJpaKQ6HwlTx18CSbVSsjD+kgsDOr3CWJIPAuTFPi996G3psCOfyZUZ4ZoE47LcmxzOqZMT5tq17j0nK5k0QhwSvgkLEjbC7nvfKee6MGh2E39TCMEzfLfeMXsEHGW412Rc93iZQ0fL0/OI9/ClZARTYyOb8TMQIWESKSxdUUJerlUz+aAGyl7wE/RrzHlmAqiPCcVt/XvPZ/sbHu3Zz+PEx2zZPoX7qaq55iQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(53546011)(6506007)(8676002)(86362001)(558084003)(38070700005)(66946007)(8936002)(31686004)(186003)(2906002)(110136005)(54906003)(36756003)(316002)(71200400001)(66476007)(66446008)(64756008)(66556008)(5660300002)(31696002)(6512007)(6486002)(76116006)(478600001)(38100700002)(122000001)(2616005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlRoVGpCNklrNml3RzBGSVlDYUtiMWFQRmwzampEcHdpVnUvVlMyZFJsMTFE?=
 =?utf-8?B?M08vdlNEYXViWGIzaXcyY3dxOEFkak5oRXZCNFJ4KzBzREU4U3pnQjlYRXZh?=
 =?utf-8?B?YTRlV0l0YzY4S21EQVlkVHY4bFMyUXVUQzFsdWhHMk5TeGlVcDdxNTZpNnZB?=
 =?utf-8?B?cDMwQVZqM3VZNms2OFN1VXBPaFlqRXltYXN2elFKcU5YM0RjL1NaODA0M05H?=
 =?utf-8?B?RzBDVkxpSHFzMWVrRWVublpUSVpZQklMeXViTG1tWlIvRHNtNFFaamJ1UENp?=
 =?utf-8?B?allIK0V6c1NPUmZBMWFFbmovd2VoU2k5VnBYYk9ERy9tZklpNUg4UzFVaUJF?=
 =?utf-8?B?OEJiRkpQM0U0NkQyNFFZSWlKbFR0SHhMWFZhR0ZTNm5md3JUNlJXblBHYWpP?=
 =?utf-8?B?MXJseW5CL05wRkVJYloxdGxQWWx3TTE4cUdac1UycTNHNjhIT1cyQ1ZkRndW?=
 =?utf-8?B?ZmNYd0d1TGgrWnMzT2h6SnpQOFhjeURlTEF4TEx2dnFwMU5tYlQvdUFmMkc4?=
 =?utf-8?B?NlRDZjZHZklPU2E0NC9LcDZsRWdteXVWVzJJYWVFcFk1MURZamRjcFhManRV?=
 =?utf-8?B?LzZpREVjM2piR2NvbEI2bHhqdGUreDRyTWw1Ukh6SHhjdmtRMTlxVTgvc1dL?=
 =?utf-8?B?bmxqY1JKY1FzV0FBMUFLVWdkcVBlVWx0cUdxNUVZdkdnVUU2UmJPQzNkUGNt?=
 =?utf-8?B?SUZmNTNxcUxVTCtUTW5HMHlmVi84RkdlTVFvSUJyY2xtdkx4bkd5L2MzemZU?=
 =?utf-8?B?dHVMU0dCVjlsNnhJeDY5L1ErbXhNcFpYVDE5RjdvbDFvbGRwblBWQUxQMlVk?=
 =?utf-8?B?SUVzaUwxY0VRa2UyaXY0QVRHWDYyNWpxd1MrZ0hVMXFKMXE0V0g2RnBJUjBL?=
 =?utf-8?B?QXIyUEEzc2VyalhZQjVvZGpVU01jYXl4SU5tSGY1N3NNUlpkbEs0UHZiTzZG?=
 =?utf-8?B?MUtHVTNKSGtQajY0clhwbllUdEdTc0p2aFcyN1JnZnpLTWh4U3IwbEg4R3di?=
 =?utf-8?B?OGJwUEZUZ1R5bmsrOEloNWlRdVUxYVFoTlhsN0VRdzk4VmY4SVpoc3hqZkdX?=
 =?utf-8?B?bmtBeVJLVzRSeWp1TXVIRmpna0tYem5ESmFuaTh5VmRodkhVcGlRTkF0Mkxa?=
 =?utf-8?B?bmVVZkVxM2lUYnpHd0Fyd2NJNlVCSWdCeWpyd2VBZkluZUVoS2tqd0kwck5h?=
 =?utf-8?B?T2k0UDVYWGQvUXMxVkhZVSt5SDgvY0Zpekw4T2FEZ1d4VDl2Z1RWWndZbGRo?=
 =?utf-8?B?K1puMVh0aThsSnUxdW95eWN6OWpqVE9aM0xucXMrT1BiUy9DYW82Z1hvdFJK?=
 =?utf-8?B?YnNESHlsRVEzYko2S3JEN0F6U2M4WGNaNHZxT1VUNi9FbEh0a21NSWE2blRV?=
 =?utf-8?B?czJYZWlselZSQ01IQS9ybm5VM1Z5Q3JySE1yb3E1MDA2SE5jZ0FUSUxUZ0pO?=
 =?utf-8?B?TDh0ZUM0R3ZCZ3pUUE9LSDhwSTFGcEJSS0QxNWZQYUFqM0xHZUFYK1ZYTE5x?=
 =?utf-8?B?czBtR0J5Nlg3UTNJUXVtaEN1TVMxeDBiMml1STF4RkVoRldUcDlNSUlMRjZ6?=
 =?utf-8?B?ajN4UXE0ZEljRDI0REJHUXVrZjJhQW9zU3UzcTlMUlB1eDdZUXNacXlnVUFa?=
 =?utf-8?B?b050OU4vUWEvNVIrUU1EM050WHVmVnZpNXM2YlZDbHVDTXB3enhPc3lNVkhh?=
 =?utf-8?B?M3VoU1M2VkloVkFnVHBia0xzMlZQQWdxM1I1NklRZG14WTFxdkV1MmNzWUtE?=
 =?utf-8?B?ZmsvM1RFS3I1VGRPbG4vMnZWeDhOMHVaeXVXUmtCbkpCQm8yVGMyWlpUZ1hE?=
 =?utf-8?B?ZmJiakdSZ3BndUFYbGJXdG9GbjJ2NjVHaG1xS1hCS041S3ZrY2lFNDVBM0t3?=
 =?utf-8?Q?SCjtiNbFoQky9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4F79AA7D78FE4428FB3A0003A4C8595@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d5bc1b-92e5-4235-40c5-08d979341bf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 17:04:56.3116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: doAYyNSvNdSDSlSppIo/JkA/Ftna+0tkkM/OJx/gF1AXg8j2uq3Mt2xWkcdNoFPpSqBKfN0sCUBjcipAMumiJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0271
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOS85LzIxIDExOjQzIFBNLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6DQo+IFRoZSAnY29ubmVj
dCcgY29tbWFuZCBtaWdodCBmYWlsIHdpdGggTlZNRV9TQ19BVVRIX1JFUVVJUkVELCBzbyB3ZQ0K
PiBzaG91bGQgYmUgZGVjb2RpbmcgdGhpcyBlcnJvciwgdG9vLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+DQoNCkxvb2tzIGdvb2QuDQoNClJldmll
d2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg==

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3258C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 09:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKWJJp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 04:09:45 -0500
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:8289
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231623AbhKWJJo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 04:09:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msniWdHDu0PvplPkJTpiPkat8UZLQKgHIOduSON0caU9HtfMYMKHGe6rR9FWOW+F5A2HAIpo+r8ARluYWoPhUN1m7M6M3SbhC3FHS1L2ZJz8kRVxPfBQnlc3+zJGox9IdYfdMMcg+Q8NqWuCDfDGAYFnGOOeWDKCdHSvqmd1Zoyfv49cjz+kW+KzzScnxNlkt0zzkl97uDscj8iF+MPjT8rbwVUA/Ic82PcXZKZEQyFcMyAIkGktPre6lqR9EeucPBhHNc8zJz5M44fGrPt3N5IsXGlQTyzygDmbncDAkuzAVPVYoypyjLoJONTI3bBNDhFmGc3dnzn+2wqKyuHF5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPM+KcHQ6R4OxF60uL8gWP4wqeytkGJ5iejUyjhrz/A=;
 b=duRXNWu6el7hMCkhO90uvIyEmxD+jHHwz0ebnp0yzlGO0AI6P+qbV7msKci7DE/gclIZeQkuOiVoWJzaQ9SrpXT2PLlAw0kfIRk1NPsyHW1wclzXMoaFLeNNgTbKpTdGEu4xPFafA+2lhj0EH/xvKLDqcSu7cSoznW5XYCPF7wg6KYyBRZZhT4b96p2LgJfiIK6udFmSg0CiL+FyC/CcCzUaIJGT17AkN2PbIt8m5mU198+i2xdAX55hs+eGMnRsV74cehh4w5XZuHEZYBOkn0/MvXF59y9gStu0i/Qqeo1xxv0AumNCmp3B0U9laA736wp11fO6UbnZGiShVkFtow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPM+KcHQ6R4OxF60uL8gWP4wqeytkGJ5iejUyjhrz/A=;
 b=e8GzbGhA3HWUEvgFW9ajjZn8VMWU8HG+1Q2yK2AXNuEDKN5/GcPJuALQewbhTySBTK3+XPlk01/GD9ODFNnjLzgbKTZlOodCU2AR+Korxt3O5ubfvvOxmc6y0hL/i6rf61JQnpzoCTSmmrJpC1tZSVyv/AisuwptdEq2wnJ7orFTk/dUlonQCbIYT9dpOe54FhI6ea7NiSo+E/sRsvvt/dUSn2+9aAWoojEEW58c+gIuZukpPOxQZc2DDM3wSwdFlFmmeanHTz3i/y8Vf+LJ2r6syC8pykzPj7MhG+eUG64HGmxR/97EMVHSsRmpuEZJbOewOrR4olcoNqOZkhD28Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW2PR12MB2378.namprd12.prod.outlook.com (2603:10b6:907:f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 09:06:33 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c961:59f1:3120:1798]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::c961:59f1:3120:1798%4]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 09:06:33 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
CC:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Thread-Topic: [PATCH 09/12] nvmet: Parse fabrics commands on all queues
Thread-Index: AQHX33WMMkWuoAmcC0elgEzKN+gIQqwQ0+UA
Date:   Tue, 23 Nov 2021 09:06:32 +0000
Message-ID: <194c883c-4871-e2d5-e5f8-3fc43b975ad8@nvidia.com>
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-10-hare@suse.de>
In-Reply-To: <20211122074727.25988-10-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dad16a14-a096-4d1c-c7a7-08d9ae608b85
x-ms-traffictypediagnostic: MW2PR12MB2378:
x-microsoft-antispam-prvs: <MW2PR12MB2378E2DBD98AC1D0FE04BE59A3609@MW2PR12MB2378.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: friJQdfau9tTG4bzqnPMmU1oyJ9ns1anfBeZt9p+XNlAIPN7OKbrqUi1MjBFuhtc5pru7VNAsarkYjOGsQIctOk1FrMvvLZohxgv2knBGD4UzScceURe07tWj7z9fjduyK0Ch2PX5b5n0d7mGGCcwlDwYrh76mdxIjUANcvfXcBxWldYJlhVcbQPcGee7fdP5vXYMXLgtBPM0jlwcEtbKoAM+d18KdqVbSNSrz/P86/GEoXN3ZVDEYBcAXve0B5fQZxtzmY8qFqkJvt4zyF5DYUiTbZ6Y9tasiMW49h6Xp9TJ0F3YvW6RMTMnaaF6gabm4ytGopWmhEAB/3oiGiPEQHXc/4nU+PgZYU83g+kwgvo6YI8gMb0kugnHEHAWLRfoZY0CApvKIGnjMWyTZSLZ4ewIM1V4DEppMafxtXGqOpE2Fgs0EeMawJ4Q/R1htVrx/fhZdSOQRuDcsA823osG3qn4ay1HLY2yQohLasUNJsjHeSqO8w7uV3OtNqIH+6nvEcr9ZvD55BlU/yQyVV02vbUEC+maeK4rEDQ8jWVyaXsrAxfiS6ffm9Lxp5xwnZNriCFqlc1vOgkzXnwA0RoUGQVeotX8SbCMxXThX+dLSH8iL6NxxAckcFksZKUrU6aMskjmGTWGQ9kljBDBWf2W6Y1YAH7B5sEbrTm6Y+XCfmdWF77Ec7b8r607SViXU//Sckbn5pNw4XI6kzeA69/tM3E63w3nIxk3aKy2+YA/WUkIVUtAAuikcrqx7vtTSkv8cEtpjNEHLyOBDMnuFWtLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(31686004)(83380400001)(6506007)(53546011)(508600001)(186003)(316002)(71200400001)(8676002)(54906003)(110136005)(8936002)(38100700002)(5660300002)(66476007)(66556008)(64756008)(66446008)(66946007)(91956017)(2906002)(76116006)(31696002)(4326008)(6512007)(6486002)(86362001)(122000001)(2616005)(558084003)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1VDQmNTaGdOclIrRWJtSk9GakM3VEVubkFFOGhyM2dUZDRuS0lxcC9KQVVW?=
 =?utf-8?B?WWRiejB0S2s3Umo1anZvNEUzN0hXNEdLRVRRdkNYVGVZUHhrQ2hscHAwd2ND?=
 =?utf-8?B?dTdaZ3NJNnVHdVVWbzZOa3QyNHExZVRKV3dHVTFlcFUwUWVyL2NqbXE3bXV1?=
 =?utf-8?B?U2s4TXppRllkWGFoRWV0TDVBWnFuRXUvLzJtNkhWRFlzS2JCcWswUlZ1Tk9z?=
 =?utf-8?B?VFpjNFFHMitIT3l6SW1vQWFYVU4ya2JLeGZCY1ZuejBJbjFwei80U0JkTWpz?=
 =?utf-8?B?NU5kVEt0M3RtbFFQZ09ZSnU5OElGeEhSdXl0UHJCbGlENUxQc1BGc2ZZV1Y1?=
 =?utf-8?B?T29nT1ZDc1MyV094ZStKa05VSzJIZFdyWnR3L0hjR2lJV2Y1azhuZ2VISTNj?=
 =?utf-8?B?eVpFQnJEQmV5ZW1BWXlUNnNQbTZwZUhiOUpROGo2MDVobHh0aHlFaXpSS1NM?=
 =?utf-8?B?ZVFwcXRsQTZjWkZiSG0wQmdrU0NrRFgxbHVYaEEzVjZKa2E5dXZuTnViQURJ?=
 =?utf-8?B?aTR4alBldENpS2ZYem1Od3VaWlJ1YXZocld3ajY5UUdNWVUxclRNeWVwYzFx?=
 =?utf-8?B?ckV3VXI2OWhyTWxWZ2ZrOVVpYUJsRWVHOEtHRm5FWGQzMWw4OWZoNXZlaTFG?=
 =?utf-8?B?WE5yNEwwdDcvLzA2Y2ZCRG9yVmJ2VjhuQ3ZYbHVkbmVsUndVWEdoOG81RUN1?=
 =?utf-8?B?bkx3Um1NTlhMYzU2Tk9LS2dNVWI4R1NrSEdFVnBKdnVjTm5SZEV3b0Rtcjg1?=
 =?utf-8?B?M3g5dUJZRG1KZzRRSDF6OEtreDIvTVE4UCtQaEZOVWQyMGdQZWE2TWh2a3lp?=
 =?utf-8?B?K0U1YlBjTXVBcFdqbVVOWk5seFJNR3lYbnExOUt4S2svbHovWXhlUE1MVnVt?=
 =?utf-8?B?elBRR3dmMmxjTHlZOEFvL0hxdGtkRkpualpxb25hUkRZUFpjSjVIbU5TN3Uw?=
 =?utf-8?B?ZzEzQWxOU052NUE3RUYyc21vMlpUN2hKTlF5Wm9sY3M3b2hVSlNHdU14cU9Z?=
 =?utf-8?B?NVN2eEloUTRDQm9qN0xPeFB2VnVVQ0xpT0dHbkhQaWg5NzF2R2VUMnFsRXo3?=
 =?utf-8?B?eXVtc1hDVjNHZTExcUt6ZzgyS25PaHRBTlg3Q3hkd25zWSszVUwvQktZOFJQ?=
 =?utf-8?B?cWxoR0ZkV0pWclRRVGhvWitFV0YxeUhuSldOeUE2UkZqbnBLM3VydlFoYk5m?=
 =?utf-8?B?MEppMjFBdFJwdXhCYlR5ODRTY0JVdDY1aXFZNUlhWEdoOS9ON240em5wcDdx?=
 =?utf-8?B?ektyVWtMYzlPWlhyem1DNUQ2c0k3cGExQUhHNklvSG42SmJRYUxSMFRaSVZD?=
 =?utf-8?B?VDBZdU1LSW9wdlBCRXRkOHhvQzFIT2JuMVlnLzlFcE1lUVJvWlJ4S3loM09r?=
 =?utf-8?B?QTN4YThZSDdvQ0ZXZjdleW9hVXo4Sk14WmNwTVhqRTI3Ymk4TUZDVHdEY1NZ?=
 =?utf-8?B?Yk9FN3VUZ3NDSiszdDdtL2xYd1FwbFB2MXBNZmQ5T1p3ZW4wYlZlVVBMY3V0?=
 =?utf-8?B?dEppYkZoTmtYTjZsVmJ3OUo4ZjFDbkQrMGRNdTVvN3lvVFE1WFNFYnM1SDlY?=
 =?utf-8?B?MEgycWxlT0xTVXZGaEpTcndIelAwZnZLNXJvL0hxV0FhamxLS2xPanRCODRj?=
 =?utf-8?B?Vlg0YkpTN0J0elFXRS9JL0FZSUdHSk0zRkJaSWVxRzhOS05hb2Y1Nm9YTndh?=
 =?utf-8?B?Zm9neGdLMDRXT1V4OVVKemhOejg1VG1VOTJJUlZNcExzYU4vcWtLMEFLL1dl?=
 =?utf-8?B?Myt4S2FQMHRiUXNuQUVtdjV2Y3prazVpWXlJdm80ZnY4TFFjb3hDZE9aTTdC?=
 =?utf-8?B?QjVUZmt0Y3ZuQXRxRlJodmN2czk2Q3QwTFJYZXZNeEo0NzNhNmdsbFBBU09E?=
 =?utf-8?B?T2NUQ2ZydTlZbldad3FVOHQ3akJOQUVPM0dIeXhmZ2JtdncrUGJZSS9KYnI5?=
 =?utf-8?B?cERLaVQwODBSNVRoQ25lcW1kUEQ1QXJUSjZaanRpUzJWL3BSa09TZmhYM0ZL?=
 =?utf-8?B?UWM2WFM0NTI2WWVoai9ubm9PTFJIMXd2aXpTdHB2Y3hRdnR5S245TmU4Qmli?=
 =?utf-8?B?a3IrWUJxcm1XU0o5SkxNbjBUeFMvNDUrZzhzcFNaeUplMnUxRVV0amFGZkMz?=
 =?utf-8?B?ak1rTlhVbFhHNWg1R0hsNCtwSjhuUjBBK05PMVd2bjFZMVNpRVJmcm84Nklr?=
 =?utf-8?Q?cfn7iU2DnlMC92ndgM9gpgCD6wrNPFZ2ByckdAkJRQJZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F37702EF2FFC9B4FBCC45A9B865227BD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad16a14-a096-4d1c-c7a7-08d9ae608b85
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 09:06:32.8720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u3re43Y8aRbvlgid6qp+wmgJJwIfQwIn2sSMkNJsKZvfH8oYDGYArhCz/LMzs3Yjol6t8f7kpSGStnGT1fyNhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2378
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMTEvMjEvMjEgMjM6NDcsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gRmFicmljcyBjb21t
YW5kcyBtaWdodCBiZSBzZW50IHRvIGFsbCBxdWV1ZXMsIG5vdCBqdXN0IHRoZSBhZG1pbiBvbmUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4g
UmV2aWV3ZWQtYnk6IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo+IFJldmlld2Vk
LWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxoaW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQoNCkxv
b2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEu
Y29tPg0KDQoNCg==

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4154C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 08:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhKWIqK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 03:46:10 -0500
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:64896
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232024AbhKWIqJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 03:46:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYb8976jMxkCwIdIWlG89Ir3VzonJFrxgdkc/fjcRgoO9Bi//5aEyXSw5b3vUi+IE2tIvJT9s0Ys6D7PA8+zh5o3kFYvqMXqpbmV1XdWO9G+6xQN+dcwFmgoaVJ0pbiJg6a2bGz8rpzZFEpRr47Z6k4oE+4hwN/gmgnqzJKSIgLCe+caaFub6Rvp8XJCcYkGzm7rGdM1ekUorFF+Hx9EftaqLpNirLHp+78Ip6+xpxypYOtBNMGlOwUaehBM3/yIhVCxxPTWvVHtdjfy3uu/+Qq2XsFtUuG8p0jIlaAi0ycj/6v+zziJsOBa/M8uehnx84TZ4KMWa+4bKAzv4du4gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6wc9CntRJZfBjp406A7z7TeAYihaLntqQRVV+45l9o=;
 b=alkz3fv+lFaUqQhDTCS5NiBzKslOFldscpLT8Qyx8QiJyNIVPKCW6WpoX5yRUxJxuendSdW94jNJYjosu6vIlk8rHMfgJxUB2zkuJ7yHtQ+tICDZR3oG/DbFvm+odQ6XxSq2ox5HTF4QDLJKMyYlBYSEO0yNJIC681fhq0+J1D8rc3m+H82vjcUiZVFqBv8bbN7/1Lymbg7sms3mqZPhILuQnF49FI67025vvnrIfYy5RQ0/waVCcA7Kql66VBzTiQCBbxk7fGIc7A02C9IP/+P2QAjz1+L1beFmupw7+/1ktWfdaQjsG6RDjeuUXkidcWzmpgoOWEB0VZ522sI3wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6wc9CntRJZfBjp406A7z7TeAYihaLntqQRVV+45l9o=;
 b=kdxneT2oPSIPe8NmbASlu2bq1NWq7e81ifNvaiWcPekxuxR+qtoCBxFIXQ5X1y6DRQNyMQN48qf56JolQtfusxuM6b5CdKAK5X+MOZlFgeHkPUbt4xayj8vmNLWQ8dSt7g7JL0ePSYWKqbNwENM5cJNeXS8yvC1i3XU6yiwEX0vMb4ZM4yqPW8nMt/JgNBq8heMlcSaoblJb26ACTs0E7JZ0+O9JTtY7tk856xUMbnbuP9si7MmCeqndJtNxrNAtDE1u2iiCZoD+GqUDR3drnqgo5yxIpqGXgdjTIYBPD9DoktArYOrjF/MX72SOhXvKy90rONbSzzeIK6IDPr8OXw==
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 08:43:00 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::6dd2:d494:d47f:5221]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::6dd2:d494:d47f:5221%7]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 08:43:00 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>
CC:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Herbert Xu <herberg@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 05/12] nvme: add definitions for NVMe In-Band
 authentication
Thread-Topic: [PATCH 05/12] nvme: add definitions for NVMe In-Band
 authentication
Thread-Index: AQHX33WkM3KHonaLLE2E3M4EWdLnTKwQzVIA
Date:   Tue, 23 Nov 2021 08:43:00 +0000
Message-ID: <78717c09-ba94-788a-0851-3feacf2ac157@nvidia.com>
References: <20211122074727.25988-1-hare@suse.de>
 <20211122074727.25988-6-hare@suse.de>
In-Reply-To: <20211122074727.25988-6-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f64e6efc-26b9-4785-3f3e-08d9ae5d41ae
x-ms-traffictypediagnostic: MN2PR12MB4253:
x-microsoft-antispam-prvs: <MN2PR12MB4253326EB459F337096B4F9FA3609@MN2PR12MB4253.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zGHB6T6LgWthjxMwI2Hb31qBshwF4bV/9rFe1iqxFbXzrbNfMXh+uDFW6Bc+cWVUu+XgHn1tskm9JZI0nNX9oa03utL7Vp48oktr7ITpI0HqHJU2ytK5eaeZY8xUplmpry+jjFYxaQ/Fp+fOwoM5SRQo/sZ2GPIPDdh4l5pu5Kuf/ByRC17PT71MbBXtPuGpGHaGr0Z9lQabt0BX8lX4HLjauCC6SqnhDkoiBwIFDdgwz0/lHm78cw9MV8CoonBZjeybSjKlAcjh+LMNm+8nKTKLoRHY02ZcMZUWe2DZ73VZmXeIM+dsS3aoAtbNXiL7q/mNc4dcgMb8GErxhrwXGrFKDuRaySGUP86DCiRNQLov5y5TKo27DiwB7c5Cy0XOegt4F3qpRpTEpYVy2ACxsHTuaMr6oUu5R69PAc7lvRsQayGxc4Na7X8PHzsoTlktekSCrUY6cYGKQe9IR3XqFG7ESJ4fWL+w/1AC5h+9LKvQv9ypnBvwx/eOItZ/DqzS0yNvI81oI/vSNKpdngPva+kbuiQ08ZVRycHtrU7Dw6tgjY0FahHe2ybqzhyBEnmBWvd25Aorn8oTMhNYX0W/yBQMVXfYH3t6nYxCV9Q8p2plztK4EmkvdnIAjoXJii1dEwdf7Jmbn8jH9YW+JOkWcbE4+87hpBUdUieDM4Fm9MlaTzrOFoUaACGGi6VH2bmJGcMQTyfiNUI/LdjFBs9a9dVUbxaybf8pOQ9SbicHHgA7oZZVytzeh5tBuwf9M6xNqrFXld7b2mUGk/vMkZ08Yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(2616005)(508600001)(66476007)(71200400001)(86362001)(91956017)(6486002)(31696002)(66946007)(64756008)(53546011)(186003)(5660300002)(4326008)(316002)(76116006)(558084003)(122000001)(2906002)(6512007)(8936002)(110136005)(54906003)(66556008)(8676002)(38100700002)(36756003)(66446008)(31686004)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk5IdlF1dU9wWlFTKzVQMUpoYVk1a3R3cDZnS0RDQXhrQUUrcmRzcGFvSkQw?=
 =?utf-8?B?OGF5SWphbGxQRU8xZ3dHdXNraDNaTC92a1N2dkpiWEE3ZWRtd1BackE0YWdh?=
 =?utf-8?B?R1pBNGRTaTNTVFFWZUVsODVjbXUxenNpRnFBc3V1cFN3b1FpOUVoNGpqOHdy?=
 =?utf-8?B?b2U2dDZXVjdoZ2I4ZXJKWVdvNkZ5RjRVQXhXTkl2emN5OElJRFRLSG85VW95?=
 =?utf-8?B?Q2NzbUpGUkhGcjRzVTlvcExVSFVYTit0bVZCMGxrSmFqUUhZWk05YWZFZHNu?=
 =?utf-8?B?aHVDZU1uekdpT0hXUmJya0YvT1UxaXp6RzE0SDg2VGpaaG9nRlU5THViWnNz?=
 =?utf-8?B?VFBlVWltc205ZG5tTXJjOEZ2bU9ZRDFhQW4yRU85dmx4ZitHS3Y5QmRJS3Vx?=
 =?utf-8?B?dVJPemR3RzFuZ2NOS3lITmZadVkzOFZnVWE0UFd4azdUQ3BhNFExMWhNOUZk?=
 =?utf-8?B?SnJoRk1VbEQzQXBON1JhZVZ3QnBacGErY0w1b0ltcXQ4dC9pd1pzUndvbUQ4?=
 =?utf-8?B?RG5hd0d0a0lmSVVaK04rSVYwaXU2YmZKdXd2V3FQZFRCemw5TnpxMXp5NGUx?=
 =?utf-8?B?cVRBb0hDWkpmQXFxb1hTS29haTAzd0RJWTZJWUpFYmRUTU5laHg4NUtTWWx4?=
 =?utf-8?B?cmNqRFNEMnhnSVVlTVEwYjVQT09PajBGZ1BYOTRNeU5iUTk3M3hrMlZid0c1?=
 =?utf-8?B?VzdMbDBjREdqQmpQT0U2c2x5dEtXS1BvMHo3UERIMStEUmoyVVRhM3VnTjRE?=
 =?utf-8?B?OVYrKzRDNGw1c2tETHJHT3hNQlZqdmx3SDkxaExvVFdwdUxrQkZjUjdoajdr?=
 =?utf-8?B?Ym0rMnUyM1pkM3RxK25jMXVMNHlKN2hhWGRQM3YzUldSNWdvRVY5N2JoMEl2?=
 =?utf-8?B?ZS9ONE82MjgzbGg4Y0puRjlIS0x4b2twN3NoWFBBM1V2T3dHUTN1UnlHd1ZC?=
 =?utf-8?B?VjVMTnZDN2RYbjkwSHM3VldrTXZ6aHBDc21hT2xTcVVmR210NW9YQ2EvMTkr?=
 =?utf-8?B?bzNmdFlaT2wzamN2OUVPQ29OOGlCblIwbFJOdXpVWEFEZHhBMG1Gd0o0Rmls?=
 =?utf-8?B?NmhmSWFOcmx2ckNOWlJvV2NDNGZkZDIrVmg4Vk1xOU9QdlluN0NrcjV4eHZQ?=
 =?utf-8?B?SmwxY3VEOFNhUzlicUd0VEJkR3ZTVFFIYVR6VU1jWENhdmgrbytldkxNZ2xh?=
 =?utf-8?B?Q3VMY2p6dHcycGJvc0tIMmtMdk54WnNqYUx5MUthTHZMTE42T1RMMmNPS3RS?=
 =?utf-8?B?TkF2TGgzNEtKdGIwVFB0VUVPemdveHFodmhOeFB6MmgwTFFITnF5RkdrUkt0?=
 =?utf-8?B?bXRUck5EeUJpTCtFaGdsTUtTcERTUW1jOEtIMjQyaU01QkxnaWRZeWpoN3VF?=
 =?utf-8?B?YUpKSGFmMU1YM3I2eVI4akMveTdCWlhMd1lGRTYzMCswM1Q3blREeHozdnUv?=
 =?utf-8?B?QmVtZXBIcTFncUt3Y3RjeGs5V2EyckJyQkt3dk44NE1uRDI1MlJ3djNvd2hI?=
 =?utf-8?B?TnBiRkU3ZndmYU9EWEFVclZBdkhkOGgyeW9uVG1VN1dnblhxU0RkQkM5K0Iy?=
 =?utf-8?B?YWRiRmplL1VxWkhnSkJMaHpMbDBNYnVwSmlCMnl4WUhHRWdFMXpycWVLLzQ2?=
 =?utf-8?B?S0M5OC9SNVVCNjBDSE45ZXZnWHVHMWNXMSs2dzU5VER0cmc4d2ZER29xbXRi?=
 =?utf-8?B?UTA1c2FUQ3JFelkxQStuZkFJNjhRZ0hYS2hSOFl3eTNRbUwwTXQxVER3Vngv?=
 =?utf-8?B?VjdkQk1wOTBCZHFwRU1yTUhEZEZBZ2dTWFZqN0NNZlV4YW1VOUpudmUybjdS?=
 =?utf-8?B?bnE0Zzl4OFFZSXhOVXBpTXc1YzJyQ3g0QU1xeUNsTXdkcitGZEZQc3JmUmgy?=
 =?utf-8?B?OEoreGxJQzlYZm9BbVkrcG9GSUR1bHg2bkJHMVEwVmJJQ1ZndVhKc3UzY3NO?=
 =?utf-8?B?RzBrMHBQVnNCellyL1NhRG5pMWIxclpOTU5hUjEwMVl3VEdETGhxMFduczc2?=
 =?utf-8?B?NlVQZWFPRDNheGdkVVRXUzQ2bDAvZGpMYUlSd0NvSzFvK2l0Z3VrQmhOTXlL?=
 =?utf-8?B?UEdSSGJSdFJzSC94c1VaN2JmMHVYK1dFK29NWWdhWUVtZTRjMEYxVmRuWi9F?=
 =?utf-8?B?ZlV3dkI1QTBUZHBGbmMyc0FXOTVyQ3VtNTlDYnpkTEEwVGg1ZjRudGZvRVZr?=
 =?utf-8?Q?waRuEKM9d4N0X9uQCyile6FXYNVZRUj3m7fSvqm+LV2B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <010174DCCE6B7E488245AFBBE78393A1@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f64e6efc-26b9-4785-3f3e-08d9ae5d41ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 08:43:00.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3GIP2D/o5sZdqKtC7x6fba9lDw5qpElzllcKRZ5kDMWU17MRG+yua7gq6PmiII5R2V2ZktQhqshrQlPUwzmoRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gMTEvMjEvMjEgMjM6NDcsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gQWRkIG5ldyBkZWZp
bml0aW9ucyBmb3IgTlZNZSBJbi1iYW5kIGF1dGhlbnRpY2F0aW9uIGFzIGRlZmluZWQgaW4NCj4g
dGhlIE5WTWUgQmFzZSBTcGVjaWZpY2F0aW9uIHYyLjAuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBI
YW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4gUmV2aWV3ZWQtYnk6IFNhZ2kgR3JpbWJl
cmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo+IFJldmlld2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5pIDxo
aW1hbnNodS5tYWRoYW5pQG9yYWNsZS5jb20+DQo+IC0tLQ0KDQpMb29rcyBnb29kLg0KDQpSZXZp
ZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KDQo=

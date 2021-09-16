Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47069C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3135F60EE4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 17:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344619AbhIPRFJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:05:09 -0400
Received: from mail-co1nam11on2071.outbound.protection.outlook.com ([40.107.220.71]:24160
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348436AbhIPRCu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 13:02:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkPsj2ToQgEvDUfUHt4ZhYDVST5BpoMIA/z67YuDDe0vBcqK/SiCWnwoSk3nma3Rmxapp/UkHuDpV/qOHr8tv6mJkcM0ZjLAZskVcS5fBaFAZ57fyqU0gTQP0A3cCnBTfH61zV4hJ/1S6NdMOfgUaJpIoB4c+jIz8T76FK/Nbz0OOtuMAZhnVOBxbp0s1wBbOJvEzXtylRgGI0SYKvrxVYWMEqhfZLmWweq1D+r6DVEttVd2mWEKus/3NE+DysXFs9yTV1eoj9vNzcbxJAJp1REa20wjszPbtVZZB9ycVNQsPJT12Gb7DHfKIvNSIcO1rQZ2iVB6p+xW8pWx35D4rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3dQ0l7AY3WA6Bq0hgJhvbAsd7lBqebzN2YhEtJivjvg=;
 b=P/fxdcGhBXdd5tl6qf0saDuSrakcLl+8iasNIQSOmFJGSIqq6PYW0FkQTwBhbK5ZblmmurhkFeIqnY778SJvt4914Sh8CzoceLrrda+lI14fzcqTsGpe0EnVa0WNz6noOsEx6s0IQaZhs0atPTvZTGCAV98jkMQoPlnjwmVYf5Z6lvOHrKgGUcWYJa0c1ucfYHKxdl5OKhX3Ui00EylB7mTqvJ7qkfviheCkN9bjrWEht+SX/VjuI4YpkulOtMM5fEbGLPeGsdnZSjp3DyTlVeT7uF3+l0js/CZioaMbEKUlHQEeU9KUeBJ8EatzM86GtWcphjP2hPIvNPLIR58VeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dQ0l7AY3WA6Bq0hgJhvbAsd7lBqebzN2YhEtJivjvg=;
 b=e167CF8sxtJyqhyZqPDmR/w1XQ2+x/1N8tGIKLhxiuA8OIw/OXnQbPlfgof+jeJXyspKDzz9K9z82utG8ZLA/xAautNv3LfBLz81ylSIHIA+6BdfuY+Z8S9UoaoqVcg+jf2zVA78fmeG0tXGT2egGLG/PjZfDwJwW7TlyDZDaGtrRTTBBsLCMonQlCsNLjdzpYj28gYtryudfMWNuWrymmuBXFKDkD20oPPWb4H5Ml+Ne/VeSEABQnMOaQ+vtSkJYouAVZNCRM7veL/IVZMYrG3GZ0ieST1YvZ1egOios3RyMHPtpvZXH7e94rp/UWHT9zRq3fpe0tHE51ki+7yroQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4540.namprd12.prod.outlook.com (2603:10b6:303:52::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 16 Sep
 2021 17:01:29 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::498a:4620:df52:2e9f%5]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 17:01:29 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
CC:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/12] crypto: add crypto_has_shash()
Thread-Topic: [PATCH 01/12] crypto: add crypto_has_shash()
Thread-Index: AQHXpg+kD37W4Iztn0emBNqas/yC06um7NsA
Date:   Thu, 16 Sep 2021 17:01:28 +0000
Message-ID: <1553a7ea-72d8-fb17-78bc-f9b73ab2edb1@nvidia.com>
References: <20210910064322.67705-1-hare@suse.de>
 <20210910064322.67705-2-hare@suse.de>
In-Reply-To: <20210910064322.67705-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e91e7f8-95eb-4660-7906-08d97933a058
x-ms-traffictypediagnostic: MW3PR12MB4540:
x-microsoft-antispam-prvs: <MW3PR12MB45404632DA5261466B0166D9A3DC9@MW3PR12MB4540.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:431;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yyGGqMa5ONaGqmeU6KvddI9eSt472EgioqX4xLg17WVEuUFiYD34oYf2wCzLe3h9Dr5t7Nzqm763zNDPzHVvHMkAe9MS3X0oWRSBwXdWn/OhOFqWo3lPIes3OlJn5cVVy2EGbiBfUaD0ikquf60giyfseGpDLGU8w3ArepR1KiHQ4bkagLSXTup7NCDDqOagaQ1sfS9Gf5C1rDIf538Bzof00XBv3ruhLVZ1KJb1H2N4bPF10Jcameu19z9yKfovt73VZsQcdj0M2QxetunDhaIHssh/ZXhJyVkNR+qL8jY6S2boZXJYh4f5fcgkJ2BflkKMsV8tGqWFw++W7FGLCEmllZ5VM+rzJo1pIUaRkVpUSnalIkvkFI8qqVudlZcS0erZHhtM4Cd/yA5sDGWDmURrLWwzXl61ilVEvruTAP/CBCynlFl4b7Wl4rLj85naFXRZdJKAqmrVguX1CDmrjESOOtWaUaOol6xmAuBnMzvihZKiPImNgW46Jjw7VpkDmK8jvHv5iZ+hXPY9saWKI9QAhT/Ngnbnb+4TfAqXcfJsQslQv/qJDL2/fqyT4gvB6ZFcHLk9gT6SeF+hApG2jOLnktj/M3ihoO2ux9GNJnKZ8xkqmEOma4ZZB/KyEFg03yDwRMOBAICPUYHP87liWSzbEMJAvj+6y+O5PZT6OcjnZDbnziogA1jiMJPi9un2lczZatDnl4HQG6J5lROWzrpr2WMj57tjhU+M6AzbjwwgbQBbFv57MHBps9HFepjnnCxNQg/c3xqvSk2hbADX9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(38070700005)(558084003)(8936002)(53546011)(110136005)(6506007)(54906003)(5660300002)(76116006)(4326008)(8676002)(6512007)(66556008)(316002)(6486002)(66446008)(66946007)(66476007)(64756008)(2616005)(38100700002)(36756003)(2906002)(31686004)(86362001)(31696002)(71200400001)(122000001)(478600001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWtXYXFLQnRONU9WUVpTck1xZ3Iyd013dSthbUkwWWY4Q3BKbmFkMTZUcUo2?=
 =?utf-8?B?N25BMDllV1VOcmFBL3Fnb25EejhHUjBoZlVhYzBkTDAveHljelRUamVCZlJF?=
 =?utf-8?B?SW1yemV6OUZKN1RQSWI0bUdJaUVqaFpIR2FkajBqcUxmZy9vcXZSRGlPNDZR?=
 =?utf-8?B?S29Wbm1OODc3YmI2VWVYelJpbmJTZHRGaGhUMlQrVjNoTUZpWXhXcC9jSGNJ?=
 =?utf-8?B?MSt6bEhsSStzRERzbWFjdEpFL1ZCNkZ0UWg4RTZaaWZmM2NTVmVRZlBDM3pI?=
 =?utf-8?B?ODk2UTRicXZxTzNjZTNpNWtlNTdQQlpRRFc3dDNnT2ZUSUNnYjBWWldDdnI3?=
 =?utf-8?B?cTUxM2JVNjNsQW9SUHJWSWpKajVyR05ndjc2enpLU2FVQUJxTWZMbFZVZFBx?=
 =?utf-8?B?SlhEVWovdS9ZZWhMeTlDUHF3VTR1SStJL0N6QmJLS3JqR0wzVUNkRm5GbTZw?=
 =?utf-8?B?QzBtY1dXV09haW1PaVpsc3JzWWxtcU9FNitmSHNqQ0JPT20xN1FVMGloUUtC?=
 =?utf-8?B?bi9kZ3cvYks2VVFJTyt0Uk5VY2ZhbXNESisweVQ0bG9LZVY5TlRDc0p0ZHZq?=
 =?utf-8?B?cFJQdzVWaE5ZRlNnZHZYWDlSU3Z5OGdQRTR4ZC81emlVckUvSjQxSkRseVYz?=
 =?utf-8?B?S3lEZUZzaDBxNHZlVGRGTWpVd2pRNmdtVmsyZTNRQWpXVEhMUk1TYThjRk9I?=
 =?utf-8?B?blNUK3VGSFlpaVU2L1FhNGFiVW1NMCt2RCtrVmc4ejFBVW9IU0JXaWNacTh5?=
 =?utf-8?B?SmVkeTB3SEs0TkhGZ1VScnZWU21nanduNWpzS1ZKeTFsV1QyNXlDWlhFMXZ0?=
 =?utf-8?B?Y3NNa0xYdS80MG9TZnR6TWdxWFFuQmw3UVlWVFdqZjV5RWhNYmgyU2VjSXhq?=
 =?utf-8?B?SlVXYWJxOGp4UVBwTm52eENoSnVIa2RPRGlnYU40THJ5RmtreDdocDF5ZFJo?=
 =?utf-8?B?cFBFS0FMZWNjOXpnNEZ6dTVKVzNBdTBCR2V2aWhpbDU1Yzg1QlVMRG5nWU4w?=
 =?utf-8?B?N3h5QTRwUlpWbW1XK0NNVWFqZHVWS3RsZ1p0d0FtNFRvMnlnU1grK2pvVkVH?=
 =?utf-8?B?NDc1WGpVWjd5Rmo3Wncyd0xOMjY2MUpvUk40UHhFd1ljcnlIa2xzWUJSVm5L?=
 =?utf-8?B?WnNmRFh6M0U3VkxER050SDZHYTJHTEpTM01aVGI3VysxTzdxNVpBU3hkRllS?=
 =?utf-8?B?T2hMUXRlRU0wKzdOdDkvZ0Y2WkZDelR4aEF6UnVPeEhwdXVUc0hkYVNyejE5?=
 =?utf-8?B?bFJGaTlUOVdxVU1NU1l2a0VtVmxTRFBrTGgrUU1MNG9wMTk1TFM0RVA0YW41?=
 =?utf-8?B?NUFFWlVOOEJldnlEd0ZqUlhsK3lzSk53U2QvVTg3aWx2VWl0N3RtaDlwOFFt?=
 =?utf-8?B?MTh0MVM2a0V1QlRNbGVnVHF2RXlhbENMLzRrWHNtUWJHczhWT1NEZlNJYmNt?=
 =?utf-8?B?aHlkWDVUNkJXM1VIb0o4QXpLNmxwNWNRWTI3cWZEM0FiTXpRN1hyc05Tb0Fk?=
 =?utf-8?B?M0FBRmd3enFmdndRdXBLY25CNVVwMy9vVXluajN6Q0Z4UFJhMnpQYnEwT1Ra?=
 =?utf-8?B?VzdFTXhSc3dmdjVEdnVMR1JUU2kwbnp0b0R4VXBldTZSUXI5VlYrcGtzemJt?=
 =?utf-8?B?WUZTU1J4S1p6VzcxTXFBQXBjRzlOZHdrVVI2T1ZzWjJkNnVETEZOek96US8w?=
 =?utf-8?B?VVZQRWthcTF1MStXSnM0N3NYb2pVODNSRStwL1N3Ui9OZzRTMkk0MElCdmFB?=
 =?utf-8?B?L0o2Mi91Z0lGUDBhZDlZMHRhVGZvc1hMd1hlS1p4dDhFNEZ0aUthLysxMXBn?=
 =?utf-8?B?RHNnd05qV1IxVG9yenNpQ0ZoSlFreS9NelM2dXpwMUI0YTZvVXIrWFJLY2NO?=
 =?utf-8?Q?+cy8I3foUtnZB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <694B19512C895144928C279734986061@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e91e7f8-95eb-4660-7906-08d97933a058
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 17:01:28.9361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yqDhsZyZuws2m/x7qzef5EvvNqjKmQ8GZoNEE6KI5YAs3jdczXQ9hgVRQDyvFCl+sjMxSCeL/W4xEMq1IzIj3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4540
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

T24gOS85LzIxIDExOjQzIFBNLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6DQo+IEFkZCBoZWxwZXIg
ZnVuY3Rpb24gdG8gZGV0ZXJtaW5lIGlmIGEgZ2l2ZW4gc3luY2hyb25vdXMgaGFzaCBpcyBzdXBw
b3J0ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5k
ZT4NCj4NCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8
a2NoQG52aWRpYS5jb20+DQoNCg0K

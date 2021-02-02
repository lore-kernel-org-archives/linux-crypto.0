Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FFEC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 12:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBCE964F65
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Feb 2021 12:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhBBMIq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Feb 2021 07:08:46 -0500
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:16261
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231180AbhBBMId (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Feb 2021 07:08:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/ovGyWzlbHKs4XR3ummx1vt7LYydBBDUKqA5EnGU+FZYKMZp1+3S77f+1nxOilurMpH7RuMt4vJm6YH95+Wg2ZeDS6gHCHlZ8q1F6DAeP7mEG1JIVTd1HpXSmLKdUzjlZtir4bMzuse7l68OpUcib3GzqMi72MEqITAY8rXARtwKhpvVoDKwKBGdLFFjcQHs0HMbyQ+/6H5qdDIwETafV27eeIkgH5RbormID60pvlAKCpkG0NfGhaFtg0G4MBIsDWF+rw5mIvKJaUhcAzf48Utxs6tVj0FllA5lHPiLHI5nh5Q29a1Y3e5rpiEq8n/5YzFlCKgHt/LatVIaYr5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PZruhj2Bw7OFELX0FxO976iIxDJ+YR5payop6oZVus=;
 b=dA1Z/ZddoEIR9clFCQrig6+NRdMxq4t7V8buokTY5pawyBhD4zTge/xJzLc0T//diwYaGZHvxR2+d7jAoL7Mrqrd+FoCRXZoVIaDK3TmPfO0JYMD7zlugGvL/WF6Sxl66f1LHcy8CPfddzGW38NJ1X8sF0JW5zZupTk3g7GCNT3JX8psW/b8gTfUQJwcwD94W17F4Z8ykCsl1/8aUxJpsF1zy3XUU9rCb4Xww4Af6+KjKEWSwL3FRrafJBdnb0w6ji9vhfBU5TOpBzFCRlt3rcz8CDA70i6Pmamw5Jae1vXqWXhMVm4AogTfxtI4oaiww1vzFQXKgaEcar/hNf2IZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PZruhj2Bw7OFELX0FxO976iIxDJ+YR5payop6oZVus=;
 b=ep4g5DG7Hm0YxwmrRgVD7XWROkmqXI/EAlI2SIey4C3TUrUUTdwkKi1dm9e8M5ae/6tv8BwC8X+CP6bYegAMn1oKbAtG9D7l1J1ZkR+xHnACHqVHuN4Kqre7gDH8v3KZRYetbaux88JIH5VfT7WqxKIWlcteaxx43RREDRQPWDw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7117.eurprd04.prod.outlook.com (2603:10a6:800:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 12:07:45 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1%6]) with mapi id 15.20.3805.019; Tue, 2 Feb 2021
 12:07:45 +0000
Subject: Re: [PATCH v2] crypto: caam - Replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1612231575-15646-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <68e55dd2-68e5-78fd-f7ff-a4ca2c26369a@nxp.com>
Date:   Tue, 2 Feb 2021 14:07:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <1612231575-15646-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::30) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR10CA0050.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 12:07:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d902b75c-21f9-43cb-53cf-08d8c7732663
X-MS-TrafficTypeDiagnostic: VI1PR04MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB71170D8B5125642B7D895CC898B59@VI1PR04MB7117.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdnDTtUlmtj+Jl9YHHNuKZKNnyiJ082NkmJKPx4Q9FFYTkJ2T8ijCChLRjpO7Q5FkjdtrCWefc4WcifxTxpqTrS8dt19iap6j9rGsUq6MVKghi3wnHpTmrkJyh/GViLvbaNFZZATwhk5W6cRAPQ09BYqay0dU6/oe+LQXh7QKKClGDQJOhHglhqqwc5pPS5GePfu6X9t2xQDLbBnumP10QcL/w74Q2G/MOch7vVrdO3P4bkcM94ynqHYOl6TLQb5NxRe65725yF5HN4cjTm+4Y7v4MrUd5/3qkWWRDtZFwwnIOIvFlew1y47iEfwB172/LvAMaNzhlzM2IaDN3auDzZGsjP7DroU/nFwEiDqXdV/nq6jdhz8URyztwICESpXvGvDz1cLzKipULQPxJZUBo6yZDfG+shNvQUvT0BtKunQBMAdAPrQUVPoHgq7qFMj4P2fqa2DJ3SGU52S3b1Y7+sJCwJxlwiv6Sj8OshgQis/h4dp3ib49lUJ++ns9qz0PVGYSuWcyAD+wy+2/8UNMGUH1nip39KyeqYynx4Os6TisdlfmmcaQGYzJbGqRL8cVQtugAqhD1YO49M9F17mZpQQitRcLjH+AEvN6SPSNLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(26005)(2616005)(8936002)(31696002)(4326008)(53546011)(6486002)(52116002)(2906002)(36756003)(956004)(16526019)(54906003)(6916009)(31686004)(478600001)(5660300002)(16576012)(316002)(86362001)(186003)(66946007)(66556008)(66476007)(83380400001)(8676002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?blQ4aHBqYjROVnlYL2lCbTRVMW00L3RRV2N0cldhTnU1RGRod1NQL2NCZk1i?=
 =?utf-8?B?T3U2Zk9tOVIrUUFBSHZya3NyemVyS1ZQY20yTUZ3SndDNzJrZVpnSXpNUWpq?=
 =?utf-8?B?N3pyNS91YmEvTHpLbU1wK1JqekIzYTl5TkZNTlNBUVNVU0kyRGUySU9jYUFw?=
 =?utf-8?B?c2VMeFJPSWMzNFdIL3dZaVZTU0EzZVdJb29OTDFmcURCcERaWk5yMHJqTzMw?=
 =?utf-8?B?Q0ZRMDV1UHhQZWFtdzd4YzBrZ3dkcWVVVUNaa2RZclE3QXdkejhEbWJJNkdI?=
 =?utf-8?B?cnZHQm5QRkVUNFZ2OVZkNkNUUEVCS1VHdFdWWDVNVmdFa1V3L0QwdVdJTTY2?=
 =?utf-8?B?cm9pVnFFWWNUeWFlSGRtQmpHVU5yK2kwWWJzcy9WUklHYjM1WEVDeHpNbThv?=
 =?utf-8?B?bDFxdDZHeTk2UXh5WHFWTWE5ekdMZWxxTzBlN244THdlUG0vRW1ETFlzbFR1?=
 =?utf-8?B?dHZUNVYrV3pjanJYV1FHS2VKRTBPMFIvQVp3T0VYL2FsbTJ3Z1lvdFJZQnA4?=
 =?utf-8?B?WFR2emMvWFJYSWg3emVJR3FRRWRKYjNzTjczSDVZbC9YYWpzS3lQaGNhWDlY?=
 =?utf-8?B?SEdTNVdvRlAzVlpvWDUweTJ3LzI2RFNsNzZYWDFhbjVmbmRUdkV0ODlQdnJO?=
 =?utf-8?B?K1dkVG1WZUxhbWtScVBWeXFZbE1TeEtpQW9aTFNQVGdxTUhmclRCWDJhbzl4?=
 =?utf-8?B?N0k4MTZrdEZkQ0JxLzlrOS9MdFlKK0ZWZTVPOVZML3B6Z2htOGFuTkVJclps?=
 =?utf-8?B?Y3RWRW9GckxwWmRKWGh2LzBNN2lwdEFxZHpRTS9HN0w2UFRkQmdwRDJhenZJ?=
 =?utf-8?B?ZVFDYytsOFpialRTZXdXb2IrOUQzQm0xOFFXdXlxNjlBRUd4d1hqZWZJb3N2?=
 =?utf-8?B?UEVhQThIUkRSRms2bTRBc2FHdGVGelcyRGJuQjZFcGJ3eFRBYTJWdnlHU0ZU?=
 =?utf-8?B?WTZsY1JpaFozZ3lRaitsZGI3dlpQWGJVMU1SYzJJU2EvUjYveUR1M29DakY4?=
 =?utf-8?B?K04vbDhBODNRd3VoYU9zSUczTm9DcytSTzlNQ1k4dktZS25BYzBhb3JnUzF3?=
 =?utf-8?B?d20za1hRUzNWUUFZdG80U21pTTAxNWd6ZEFzZGdBVUc0WmI4eG91THpkaVA2?=
 =?utf-8?B?YWFkeFBjVmpyTnhPSnFncVZKN0U1TkhsR2VJQjVRSnlWMFJja1c4MVRPS3FK?=
 =?utf-8?B?bTV6UDFxdnVvbWw0ckh3SXVzemxIcnB2TTJnMGZibjNYekhLUFR1Vnl4UktJ?=
 =?utf-8?B?eDR2Zlo4Z3VSR0IxZWMzOHlzV05PMFNDcFpDSmF5Q0ZsVWo0Y1llOUk4eUQ4?=
 =?utf-8?B?V1JpazF4ei9DdXlPY3NIaTJjSnlidzNBZEtpS3BJZDVhNnUzbHZhQ0UvT3BT?=
 =?utf-8?B?bSt2VzluTFBPSnI4M1ZPTTFrSHdYdlVpbStRRzlVcThxTFIvRFQ4R1ZyUWJl?=
 =?utf-8?Q?Fos3ZNF4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d902b75c-21f9-43cb-53cf-08d8c7732663
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 12:07:45.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAdHbBSv4nOG8vrQfMdRIaEDykr85WmxdNEhmF3esiSikvbl3RBB60nmQHitEvo9SDqkksmbzqWOorYT3bcCKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7117
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/2/2021 4:06 AM, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./drivers/crypto/caam/debugfs.c:23:0-23: WARNING: caam_fops_u64_ro
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> ./drivers/crypto/caam/debugfs.c:22:0-23: WARNING: caam_fops_u32_ro
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia

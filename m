Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E09C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287AA64DA8
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBASsL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:48:11 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:15139
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229612AbhBASsK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:48:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNN1FXyxCZuL5He7DgQytxNMvtofcRipML+0q0jI49bJ5q9DK6NXlkTcswH7BwXzzyf7FrYUa+BP8rs449D2jOecZALeYypjijQ5wIFVjuLbnwJIEbaznzLaIRE088P3MWXRYk8zbpkC0X2Aqjq0K4UcoikNlMKYzHMkCVuwefo0Wz75wKqk7WRnRtsJCZBOK0T+H43IZmCFAiHFL0oICTTP2yMyoTMMCrt8jCbqeZ88b1X/TbIO3A3zMB8wC6gVlqkug3rAbSDPQQOauo3QhiVXEIMeZ4tTz4xJ6MTDbOdxE4OITOsuYXkAqma5ZxPYFzmMTgrBtrpfNC211xiJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C2AhSyJJBbnCtNcayIM6QdFhmXCsfTVVyAjVWdVue4=;
 b=ZmScggqAIOeEzOuSQU13w64Bc2IZMKipY9KcE/TuE6LkPXLAC2tO7PEQGDiF/j5P5trXaxjxU3jZoKHZXwa6wZWEwAPFoEKDbRKiSuE43u+uo51Hh86cX1H8yXhi81w+/InD3C5/2Yr5/0ELecsau1A3m0q2qdz3RyYoWJk9h2rugVmGJY9vaY5Je2s+qFEscXIPCcQ8H3tgNW1J8Dj8+D/v00CwaAsVVhS8iwVQYXQCsnl/ls3ya07MP9bpJHm0H1GBRYVcugvEMle7c7cdH05qkauAZKjJ59fyXP00Aj7qLQ+5weUelRTjzwwfgN9IcjtOnipwA1DiBWmY97vVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C2AhSyJJBbnCtNcayIM6QdFhmXCsfTVVyAjVWdVue4=;
 b=Rh/JaW441XvrvTOpVdqDGvhzd3U79K2PKFJaA2Y3vKzpDAopprcSaBJL/GF8X5S1ZMHIazHxQZ1hymwAjTRFAxzpudzf62NLvPW/xlgb1Skj5ue/ovXpBgyzeQLf8RXj5W/SYlyP3IIth89l5AMKmGFvsuNdm7OitQuFLGFLFlA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB7181.eurprd04.prod.outlook.com (2603:10a6:800:12a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 18:47:22 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::f02d:1e2b:185:c4e1%6]) with mapi id 15.20.3805.019; Mon, 1 Feb 2021
 18:47:22 +0000
Subject: Re: [PATCH] crypto: caam -Replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1612167611-15297-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Message-ID: <e14c3c3a-60df-eba6-cb2c-29d475a3c3eb@nxp.com>
Date:   Mon, 1 Feb 2021 20:47:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <1612167611-15297-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [78.97.206.147]
X-ClientProxiedBy: AM0PR04CA0077.eurprd04.prod.outlook.com
 (2603:10a6:208:be::18) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.129] (78.97.206.147) by AM0PR04CA0077.eurprd04.prod.outlook.com (2603:10a6:208:be::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 18:47:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a803b946-c9e7-4636-ceb9-08d8c6e1cf57
X-MS-TrafficTypeDiagnostic: VI1PR04MB7181:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7181BD12FBA8AFEA2D2E919098B69@VI1PR04MB7181.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7uyxxQvD+Ihwab0KvBhYq3OO4TsV8pYh8BbJE/Mg41Gun+ZtBEQoapDnUPtq04FuzS6/oXUtgLVxXvIYNohMGYXxylvOzeHPiYJsI1bF69iN0O2wdA6tPOEMHzKdBVGUtrW/ZwjaEsJsWWbxYLBTbcOChumC5YdDmwWTYjXPjd3m3npgUTcJWhNBO6GRvhEB3Mw4JbirAat4R2H88neyYSTapG2+u+vX9LVFe6dj6FOBI2LmMzE4JqwjKYf6zC7Au5itmybwhwl0QSjbFM9xcDK8HG3PfQ6crHB0UB6kYCwjZCnYcgWk4/nzy1b1WLiAkJqBaDin5eVrRG4b+Y5A/9GiGUBf2+uI0Z3I4YjyHi9HFBkZoyJuvAXrUv5axrpwPtJ/lXo3RKmYhLpZJslJTVgWCcnH7cNRLe4loSjKr6u0UYQHppSlKLiRUPB2TzYO9H9OU+nFgNfJpeKCwCtpkMTc711u56N7m4rEGFoJ6Y3Riwj7kPWb94XfnPg/z6sXq7G4B4WEqbV85Zuaa11iooI+qo//SQ7w1LiH4YubQwXEnOth1p0+I7BPktUmiDTzYFoqRl3e6txJ3RNUImC+0VWakV+0loeUc8T9fJV6wQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(66476007)(36756003)(4744005)(956004)(2616005)(6486002)(31686004)(4326008)(8936002)(66556008)(66946007)(26005)(186003)(53546011)(16526019)(83380400001)(52116002)(8676002)(6916009)(16576012)(54906003)(2906002)(31696002)(316002)(478600001)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZmYyd0pzaEdZV0U2TGRrZk9uVndBMmRMLy9OUEJzUXFIb1VTZXNSMXVSaVVC?=
 =?utf-8?B?bzBiaUYvZmU0bTU5T0FtRVpyT3cwSDRyZzNHVXBybld2K3l2aGlETFVydDlp?=
 =?utf-8?B?YmNYWDBRR2hXVzVYOTk4YnRaaVRaNzMycnVHalJBT0R4aVZQRWZmRGNyc3lN?=
 =?utf-8?B?ZGpSeElLNjh3ZTMwdjIvTGFwaGVFRnR4K0U5QUlBRVR5T05uMUZWbjlydnRs?=
 =?utf-8?B?WG1oNlRKRFV5MlEvcEJicnBWdHA5blV6cldPZGNiZktGMXlNUjcwSXVBRHV0?=
 =?utf-8?B?THZaa2JyYkswUkZLd2dUeDhEaU9DNlovVTRhR0x5UmJTRWwwSEJiNDNrUDFQ?=
 =?utf-8?B?RVIwdFVaU3l2eFFSdVFyZGFoalVBbVZIejJvSFBOT3Y1Z2VWK0V5RHcyWFBY?=
 =?utf-8?B?WUhacXgxN1A4ZjA0V29MWmlmMHl4aGxrQWhBa0h4NUE5ZVp2Sm9rQjNIVHZ3?=
 =?utf-8?B?VmdONVhQU0VGYzFvbzFBdnM0QW5HV3F1elJ3VVEzZW1ITW4rWHJ4aGt2SHpP?=
 =?utf-8?B?enh1Rmt4bThQcFYwem52K3NRZDdkZ1NpM0hVbEQyUUxVcFhkWWVBNW5nSzJG?=
 =?utf-8?B?QzFBTmIzaGtXemVObG1qcVVZWE1KWHFOa1B4SWZQSHRMTEd6ak4yTXdzRVEw?=
 =?utf-8?B?WkxqUjRyMlpZTklUajcxV09hR3U4Y01MYXB2UmJoWUtadXpxSmw3YnlqMUVj?=
 =?utf-8?B?Z0FPQjIrdVdVUEFmSklyd0RoOUJycFAyZzZuTldzQ1pXek0rQWQzakNwdmhD?=
 =?utf-8?B?ZndmYlRpeTdhenZrRm5heWVMU0I2MDNkdEcyS2RzTWxKeVJjbXBRdndwR1hp?=
 =?utf-8?B?OGRkNlZFOHg1MndOUGxIMTMxSWlTeEZDWUppMmR6bnZORkY4a1pkSUYyY3Rs?=
 =?utf-8?B?SDNva1laR1RNbThmbGNkbXVaNEthMWF6TjlTVFlZbmx3WUgzVXRhVlNVMjBu?=
 =?utf-8?B?TkZRanFwTEZVRU13eERXTURUcTZRamt6UXRnYmRqUE9uWmdIa1RiaXZtbGti?=
 =?utf-8?B?Rmk3VlhTY20ycUg0S1RFNzJGRTJ3Q1BkRldLU3ZZQmFsdU9YaWg4YWg1V0gz?=
 =?utf-8?B?NWI1VVlJMHhTTnl5SXMyUWlpSXlMOGgzY2xPREU3SW5McGd4bDhMSGZUQ3lS?=
 =?utf-8?B?VFRGQ1pvaFZncTdpR0J3U1h5T0tYQk1OR1Nsd25DRENXamx0cHpReGZIREty?=
 =?utf-8?B?MUpvc0VtR0kzTVRHNWkraXlzeXJIcDd5R0psZXNkZ2UzMGU3bU84eUozSWlw?=
 =?utf-8?B?WDMzc3E3OXovRU1wUldyRERPVXRxUy9OWHQrYkRoSDZ3ZFhBVitOVW9Hemsv?=
 =?utf-8?B?b2cwejVqMVlOd25KQ3RJbTJidytaUWVSNU5BWDlFcHM0dDVWMFNoa3pKZVdo?=
 =?utf-8?B?Q0RRZTlLNzJBRlJYZysxT0NuSS83OXdVWGZweHZBTGJXQTBDb1BYbkxybFI4?=
 =?utf-8?Q?lE0cY2z3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a803b946-c9e7-4636-ceb9-08d8c6e1cf57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 18:47:22.4832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmzZoyNUQeT+KvCavtT4vHQp6eauUNi7bCdxEYOXNEKdr5hRxn4Whm4l4pkrDFvoHtsYH73QnJASCrUFLyABJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7181
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/1/2021 10:20 AM, Jiapeng Chong wrote:
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

Patch title nitpick:
s/crypto: caam -Replace/crypto: caam - Replace

Thanks,
Horia

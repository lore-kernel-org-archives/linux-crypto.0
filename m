Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18979C4321E
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 14:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbiK2Oov (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 09:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiK2Oou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 09:44:50 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2028.outbound.protection.outlook.com [40.92.74.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E6D50D7C
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 06:44:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyIRnz3SWUsMmdm4cjnk6jpMw80L3xRoLW1W+jr6wNdPjJtvFTYwOXpy2hG/XS28caIPtJnKoyldJ3xmAD6youZ0BUWv+at1rat8UfKgHhDteinXj/KdE5EKuoW+YCNrHshuFROqzHaqj1CAOP/qKHRk9xtWhoBgikwYLVM7IaVxgFCUexPzgxgdW+9Prfxk0vxVi74iqZVkqzUQcZ7G0dFFg8rFXqLtZ80FBwLRbr4sMzVy/ZMv8ZAXrn4DicruBMnf3OHKBE5XTEL/RpZtLMJ3o2XcpQKr6hm0BJu0AmW+aPI34BJHltHSEzVj1d1dKnoC3XSZp1hMZqFw5b63JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/kCvToU8nsFM7Lr6623yTPnxd4u3RwRyznZzZFCZR4=;
 b=J5jy0wPyYTGDDpKx1HjOQ/Hg+HRqdABTHsieGnp1UWcrroXP2EcUZZMXeFIE8LQpZak0HzRm8jtu7pGV/1Cv1AnVZRceM1/ut7nVnVSl5jA3ixC+kPcxJ8jegt2N/H76NXMbGFal0zfCjd/8tbP/H7EjOHuX2BglW0Uukd/GMpo+yCcFYF7kRl2Mn/cOWkpw/zZp78BNw4/UcPKGewRYb0X9p/nJ1ZEkqNAbeMx570JRq1XnTJb0S5whbTcbRTAkfkGBWKH1r/2gGSgrhuRQRLYSZYn5vzjGiVP2K3WlmvC8UcLMmgMsfMtgeFxDF0tlGBJ8pQRFcFcaGqkw/EAvjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/kCvToU8nsFM7Lr6623yTPnxd4u3RwRyznZzZFCZR4=;
 b=sg/S57ZGjMM56m5f/Z9MZebJxXUQJfVxQGUsrjvfBEG3f/8ouaOTxcYlxjR2H7BcRgM1lILbUY0cTaqye8FAf0rRB6t/cbDYR3LlEwkixFgUMvrwlJObyQfy8kfMyvT3NEigHa88NxwBclVmdBucciake5fnbLDcK0/RtE41EGrPaX2izkywUrpmSEPTW0kAyBNqN8f/A4ebaJY2bJcHlIa1kX+g90vQ0imQslDASpJAASzNJ4IsaNc74/4DZFVRcbbk101FDgEcB+sC2DK/Qt3vKprEC2LT3BEe4W+OKNPYH3iVDy52qb/bCOn9zJmVLpcJjjP8UmYoMcEPAi8RSA==
Received: from DU2P193MB2114.EURP193.PROD.OUTLOOK.COM (2603:10a6:10:2ff::14)
 by VI1P193MB0637.EURP193.PROD.OUTLOOK.COM (2603:10a6:800:152::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 14:44:47 +0000
Received: from DU2P193MB2114.EURP193.PROD.OUTLOOK.COM
 ([fe80::a05e:c8c2:6878:88eb]) by DU2P193MB2114.EURP193.PROD.OUTLOOK.COM
 ([fe80::a05e:c8c2:6878:88eb%5]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:44:47 +0000
From:   Susan Lewis <susanlewis51@outlook.com>
To:     linux-crypto@vger.kernel.org
Subject: Re: Blockchain solutions
Message-ID: <DU2P193MB2114A538748766C1D9BB3C22C6129@DU2P193MB2114.EURP193.PROD.OUTLOOK.COM>
Date:   Tue, 29 Nov 2022 20:14:47 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-TMN:  [NM6+nPyWa3jzquE7pf/TKN5R/CiDItzK]
X-ClientProxiedBy: PN2PR01CA0227.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::14) To DU2P193MB2114.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:10:2ff::14)
X-Microsoft-Original-Message-ID: <22b05bc2-7e64-625b-0929-708bd0af5ea0@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2P193MB2114:EE_|VI1P193MB0637:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aba2000-2fa0-4171-2916-08dad218430a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1j/of35GHvBMliLzNg/PpBifMhTDhQv/nh+dtx7ftEUvwUIReqyWD5dHVqzuhwxeNC4fT77EcWeoUl003koXyJWfUH/bisHLuP8+rfwQVce8B5kNQf2J+Kwy7Vn8GrK7TI60tJSeCAro6Wti77MOvDzz6NhPufsXTrFqjUGlKNukzm+UCm+smrwcXMCwl/AW/4mLSevc9AlW93yyJSGhgg2p0Ghzh6SDeTVVIzGRfgvr/ywJ8l3kmT3UiexiUPz7rKZ88phsEmh4n1Czc/g/tU7G5Pp7iq+IG3+wBlS6XNbLd47yJCBNKt3x6aHbgdC2KkP4nwBQtDNiol3NfQDvM4B0SuzB90AIfqiVKU51gd1Vc7Oh3vyMZaDcHKnKz6yTjq9TR845kUZy/eXbN4L2PP6z3Iv/C1A72LAXFcTnmdxRpFZ7dDEfFF3l50tYmJfzNsy5I7ppwypQwF5u+ZIiYq+EmA/Zh2tc/BH7BrfeHmVGbosdElYP1applDfxPPACblkstSqp/gmTT4B/urzJDCEW2OT+FfiBwo5DU6aZ8L9+a97JgeFtt+1r83jdefp/FXta/RmQ+40Pek4Xqk6vyLLMmkWH6/GT8XeQLX4hg1GayYZmPviE2rogRNUHmTz4a4clplfzLoxW0J9aRR8OQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTQ5ZUdLbnVZRitqS0dWQW5tU29YVVk1ck1JTm51ZlRiL25ib0hrMWJVWTJR?=
 =?utf-8?B?b0hPZnlEQ3o0eGdQcm9iK1hHOGNGVlpEMWgzbExoTGgvME1iY1BKaW9VSzM2?=
 =?utf-8?B?K3hZTXVEN0lVeHpDR0F6WEQ4dTJUdnhHeFdpdlVVUFlXalRudTV6RlE4NlRR?=
 =?utf-8?B?Z1FBZlgvVWc4aWQ1bzN5V2R0WEwxQm1PaWRic2tIeG0rWTJ2SHhnR1o5d0NQ?=
 =?utf-8?B?Mk54QlNXVUpJbElZT1kyQmxWRUJEbk82ckJRQ2ZrellUUEFhVXhsQTlEMzRI?=
 =?utf-8?B?OEorU3pGOUJwSGJ5U3Y1UEJYZ014aDFkVG9nT1FFUUlZUFRuaFQvZlpCemJm?=
 =?utf-8?B?d1hvQ0c4RlNjMHdKUmhwM3B2MWJ2dW16blQ1QUYyY2JXeGd1STZhVzZaaVVs?=
 =?utf-8?B?amNOMjkxYkZSTzV5MzNscm9VemRiWG9zRDd4SEtrbWhxKzA1TzJqQ3JRRGJR?=
 =?utf-8?B?RTNPZXpvRVBFUjV4Z2VoZWxycmpxcDFmaUNnRUpUVndEZ3JwYmpqK0V2dTRn?=
 =?utf-8?B?UXcwY09yQmxZL3REbzNrZEQrWmgzZWxTbjBpM0dUdlN4aUlGTjNrUndQUXpH?=
 =?utf-8?B?eWIvWWMrSjU2cDlxSUtFQWxsYWY4U3M4QU5SSXlEOTBOUjZjVDB5WXdlRnQ5?=
 =?utf-8?B?ckx2VnpBaFZMVFhEeDlqdXNZL2xiZnQ4akFDbkFSQnlwQTkxamkxdHpsU1pk?=
 =?utf-8?B?Y09odWZvZ2RvUHhPaE1xVWthTEJxS01PbGoyRU5QNkFZZ0hqaVFhZjlpTC9m?=
 =?utf-8?B?RE1IVVlQOGV2ZVNlS3VoVDI2MmltZXJ3ZC9nUDBFTGQxaUlJVEZhS3ZwOUJO?=
 =?utf-8?B?Nk15Q0U2aXRJMEpCM3JDODh3RjhpSjJ5ME53MEdYTTVsZE9ZNDFnSC9BaFFp?=
 =?utf-8?B?bFBWcjRwMUJwVlNGUGNkdGx2eWZ1TlUrSWRqL2p1VUpsOG4xcTdqTUVvRmxB?=
 =?utf-8?B?NW1xUHQ0RnpENndUSTBTdTRHTEVBZnVqN0tJd0Faa0NhczU4dzRvVE9vMHpx?=
 =?utf-8?B?ckVRM1N4MDQybGsxMWhHbWk2blRxT0k0QlZiNzkxNnVWMGoxYm1hNnJOK3Vx?=
 =?utf-8?B?VVRGeWltSkVTUkVKNTRUWWJCcTB0a3U5ei9HYTlpWHhnOWxNNGtrNitTMkhK?=
 =?utf-8?B?S1BBY2pRYWZRbEw3TVErRWcwY0VzNmtCQzAvbG9sUkQ0QWZoMENnVFpwLzli?=
 =?utf-8?B?U1BPVWMxRE02RmRwVU5xcDR2NjVCMEVUTHdBT3d3SDlkcTZHTEM4OFpvMXhx?=
 =?utf-8?B?QnJFdHlyL0g5VktGbmFJTlkyd24xdW8vNWMyVDhnWnhoZEQ3Y25qaUtKekM3?=
 =?utf-8?B?MmE4VUV4UjBVRklycmowdU14UjBtdWdNVkdmajljRzRYT2Q3TFhLcWZxZStE?=
 =?utf-8?B?eDRFbjBDbjBGUFp2aDB3MWZ5NE0xeUQrQU5PZFYrVUo3NHh0T3hZck9uUnQv?=
 =?utf-8?B?cFlPU0luYlNPNkRZNjZzd0dGYm1kVXBpT0k1Y2xhVU1SQUY5aUhvQUNhSlEy?=
 =?utf-8?B?YTl1T0svdWtjdlF6S0cvd05EQ25ZZXFhTlVBL0xqTnhSVGMrR3QwUFhSa095?=
 =?utf-8?B?d09FM3Z2d1hKd0VkY09wOFJoemFYdG9YTGxNam9rdUgrUW92dS94bEFVU3dU?=
 =?utf-8?B?SlZpVWRGb0hoN1dTMnB1dnlJQTNUdTFmUHVUMTlGOG1QdWZZS29KVjdHa1Jt?=
 =?utf-8?B?YXlsTjhQdDJZRGsrcU5lcis1T0orV2FhMk4ycHNiamo0S2J3WWJXbW1nPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aba2000-2fa0-4171-2916-08dad218430a
X-MS-Exchange-CrossTenant-AuthSource: DU2P193MB2114.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:44:47.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P193MB0637
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Hello,

I am writing to follow up on my email.

Can we get on a call on Thursday (1st November) or Friday (2nd November) 
so we can discuss this further?

Please suggest a day and time to connect and also share the best number 
to reach you.

Thank you
Susan Lewis

On 8/8/2022 2:27 PM, Susan Lewis wrote:

Hello - Greetings,

We are a Software/IT development company. We build Digital Solutions 
using emerging technologies for Startups and Enterprises.

We can help you to become a game changer in your business segment, we 
deliver enterprise blockchain solutions that go beyond optimization of 
workflow and resources. Get a resilient ecosystem to privately 
communicate, accelerate critical processes, and continuously innovate.

What can you expect from blockchain?

     Automation
     Eliminates duplication of data
     Enhance data security
     Reduce risk

Solution we offer:

     Blockchain Smart contract development
     NFT Token and Marketplace development
     Crypto Wallet development
     Defi
     Crowdfunding
     File storage
     Protection of intellectual property
     Cryptocurrency Exchange Software and more

Can we have a free consultation call – we'll tell you how to revamp your 
existing system or hit the market with a new solution?

Please suggest a day/time and share the best number to reach you.

Thank you
Susan Lewis

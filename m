Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC503C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Dec 2021 07:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346912AbhLWHog (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Dec 2021 02:44:36 -0500
Received: from mail-vi1eur05on2089.outbound.protection.outlook.com ([40.107.21.89]:2293
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229557AbhLWHod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Dec 2021 02:44:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVComGbpDxegJkgNC1FUXCXIv5mDqu2vS5oVrvQ3cuZ+tT8b26E699zjlhRDVlk4d3jkIAqE4r9XiuFg0zBrtxY2SxBKRBa1nHrZ6+xpD3hI4dzVKQ5fPHLXKvvHlR+Pw4riTr7955nj8k7AxDerirFY6jjIHUX2/YcU8ng+Rar2c4pqi1WsmV9Xb3tSbfthMZzjcT7VD2jJg3m1LY3BJgS3jz1X1tomy88s2EaiS01wCHAKoTiP7PaMIMtHWbNdGHLthPCsmu4bs6EP47KTnHO/WoA5LRbUhJfmJyu0F6XwUilt7oTkyXS8/i6xcKB1Q01YxKowC/90JinX81CiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2H3QjlAigtyU4YhRIdpCch7G2vQ+TcAhnm930nagIo=;
 b=jwA6u+3TGD/WrNL4MiaJtfI+Huv9YheNqAFh+Z2maJ41GHQMfSp2Z/kkZGubyOOteMJ/1flQ6MsWkevIcLKT7NeZrSsTvILJlBj1Mfp9CJEOumGTCG3XA1SwpHbUGF2izdoi3gSZXdQZ4ybfO0nuomDaVWcmPXVHMnkpW5xMdrKt2ZSTi7264h0gezgIQMsvjYRiXnSrU8eqL5uGyX0JlPuk2XnA06sxPiXAZ5WR6ERGznvfT9u18cNf/nQhW7oKUT9qKBn0iDSjaquixUdy6/D7f+d3RnKH+0ybRXQQj3sFveZkwiQCtN8KsZPwAzkDF8qU8JOEX71TCiKU/gRrcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2H3QjlAigtyU4YhRIdpCch7G2vQ+TcAhnm930nagIo=;
 b=r6HCjuZSJCQBZs4PLCL57+2+ICIm8UjRUaCxTgL8JOC1HwuzvazCiApLgz7b1q/SiRV+rUZb+ZouxD8d13vIFTKZ6CFiyaTQhWWQqZqONyK28xFkLKcPdoUSyydm5+npaTtqLLRfEwwjT2xSuerMwUVgF2a881OSpDfGetgIiq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB4720.eurprd04.prod.outlook.com (2603:10a6:803:52::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Thu, 23 Dec
 2021 07:44:30 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4de2:963a:1528:b086]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::4de2:963a:1528:b086%4]) with mapi id 15.20.4801.021; Thu, 23 Dec 2021
 07:44:30 +0000
Message-ID: <f2e72422-b302-1006-f5fa-22e2a2c701dc@nxp.com>
Date:   Thu, 23 Dec 2021 09:44:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] MAINTAINERS: update caam crypto driver maintainers list
Content-Language: en-US
To:     Pankaj Gupta <pankaj.gupta@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20211217081233.2206-1-pankaj.gupta@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20211217081233.2206-1-pankaj.gupta@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0701CA0022.eurprd07.prod.outlook.com
 (2603:10a6:200:42::32) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e9c30f7-c90b-421b-1aa6-08d9c5e80d1d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4720:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4720DCA2898596EF34398006987E9@VI1PR04MB4720.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:299;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DANQyYqVBkSKYxMtDl7Rn8nL6UHtJL+II5rSIjzJn6SGX++1qCtUKkfJRT9xwbd3u+p2rVkepYFvc3tq7u5pChRIt4jiUv4Ch4naQGfnZ4zXDZAewQemAbB/fctVlf9C0fD3wRNAQ3IJ81FPEBLQHftY65y0VX85nJTOy4g7fefBVNDdwR+2LeXlkn9NcVmf6546Pq6G/2saU9EVkjZZeetftK2KJnnzOtqmMawrfQUUULrl1YZAMpZa8wZYOlXDbOTqb9NAcVvlusZiTTNA2V3J6UMamDKUg3xyYNg3VEPRSFqB1W4OepplaaTuqv/hNt1WEXYkoyPDa7jAuoi3seOzfPeh8pacp+I/7sFMQ4px//jNmTnLuSi+8NkzqqhzQ5NPz4+jVJOnkNC8IN4VE5mzsKUkN0EZBnOQQYvVg6MeKXwKgTF5MaCdYabI45UN1CCWyCD1ElvlGw7HXXOL+hy5/Yl24vp7rxZBbSrpCIYx0J6Q5GBieQXyqPWH8nBjqkTTrOWHSlKqtzyYpryKJ/wwJ4wSlR5iG6dFpLmcuzefcxwvQ3IGkcJDZIFIPokJbgqmRdPfiFL0CTJAxsh3QAho5hnPdGSqFaAfYxb6wE38WX5og9YXvkmKsawByykSwboGi+i2Rr6ILIhDYNJKUGgatpAQAKMcdWYKXaE0+kjoUXvn9thijleMOEzJHDxp8eQJBQUj1zr2CdrxuYGPxzZJ9ywTXFVhNOnlgqQ1xq69YfKymaqxLR1e+d2dxcCth7q6lpuXStvyAOinxEVuNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(558084003)(31696002)(508600001)(2616005)(86362001)(6666004)(8676002)(6512007)(8936002)(2906002)(110136005)(316002)(186003)(26005)(66556008)(66476007)(66946007)(52116002)(6506007)(53546011)(6486002)(6636002)(38350700002)(31686004)(38100700002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXk1a0NjdEE5Q1BrRForb052NVhWMkRMeDlsYTAxaFQwaWgyYUx1OGpvUXZk?=
 =?utf-8?B?Z3lvUjdsc0FZZ2ZPdzdKVzlTdGxRT1hYM3V0cDBjK0Z6cnNrT3hxMm4yVzZI?=
 =?utf-8?B?R3NxMll4YjlNMFd6bmNBNk9YRTJTNmFNR0IwNGk0UmZhaXRObERuQ0dPdys4?=
 =?utf-8?B?dWpDMWM5dXhVOFBvS2tVYnVkbnJMQlNTQTBVYUJyWjZ4WTVKc1RFNGtReVFM?=
 =?utf-8?B?alMwUlFaR3RGdHdPbjhQNGJLNklLNWRMdU5ZUWZMV0dxTHVENCt5anlhZVhU?=
 =?utf-8?B?dnkzVG8vL0FYN3AxQlpoMWZva3lQejNINnJJZlVTVTQvSlQ2MElBTGV1dE1u?=
 =?utf-8?B?M05qTG0vS1RRYVh5YUFrR2c1cmpieGFPMmJJK3hVSENoV2FrdW0veUZZQlpr?=
 =?utf-8?B?azdEK1Q4TGRUcTdwR3YvNTNrOWlEMjdVamRVSzI3RmhwZDlyVGc2N2QyMFY0?=
 =?utf-8?B?MDg3TkI2VkU2YThnZ2FzUUM1ZUtRZyszYUlnYkxMNzFOTUhyUTlpT2VQSXBP?=
 =?utf-8?B?UFJwS09vYU5RR1g2d2FLV3p1dmhUeHljaXM5bnRZdkRBTlZXT3QyZEZaaDRN?=
 =?utf-8?B?b2IzTitmL0lmc1dvSXgyckJ4aitScG1GMG5hdGhEdm5ld2Y1a3NPSXF0Wld0?=
 =?utf-8?B?aElLcnBVOW1LdDFPc01UZWpuYTdVck44NEgvbUFFZXhSblZnSlhLUFkyTFZ0?=
 =?utf-8?B?aFVUVVliQ0pUZmljK2RCZTdSU3BJQlRPWCtTbkk5REIrZ2RFeW5NT0E1aGZS?=
 =?utf-8?B?KzlYREZrb3E5d0pLTzFVa0dlVEFUWXd2SThZdmFVQjFFd1VNR0lDWWJDWUJn?=
 =?utf-8?B?QXp0RWdoMXpXRGMxOWVJZnhzMTI2MndvWkhQcXZkaU41bGw0bjdmbVNwT1d4?=
 =?utf-8?B?U1hlcWxhS1hiWC9DWVBTbTA0QmJJMnlDWTM3a2pYN3hxSmJCbmRCNGo3N0pK?=
 =?utf-8?B?SVBjNXFTNUY2VHA4WE9uVzhiN2l5NW41ODBZeDcvNzRHNSs1NnZVeDlmQ3hU?=
 =?utf-8?B?TXFWc2RIS2JydUMrc1dZSm51WVlPczNHQW5vdmpBcitNb25kenRaRE9tclhj?=
 =?utf-8?B?SStrUS9SQ1dYR25DYjltYTVZS0VyYnAwSURWdjZUVloxU2xPVEJUT1IrcE9x?=
 =?utf-8?B?cCt6RGdpb0U5YjhTMVd4aGxTZTlOa2NYSzQzaVp5QmNzMElsR01PNkJkVjcr?=
 =?utf-8?B?VDJacEh4YzladTZwOHdtWEJZNVhYQldFeGJxN09OdUFRYjEvYkJpdkNRdXBr?=
 =?utf-8?B?cTBIZGpXb0k5RitPT0dPdFVQV001czVGMjhlLzN3bXRvY3VYRTFoaks5bkor?=
 =?utf-8?B?dVA0T01aRW9oQTRzSEtmTjM4KzFKdEpEckx0VmZ0c0lNcFJhRUdseTdVeGdO?=
 =?utf-8?B?OUV1RnFsaWs1VXQvSEMyazNTQmRWVjl0NHNhSGQxNTkya285eTdkUTBwZTRZ?=
 =?utf-8?B?eXAxeFVWNGZLL0d1cHFlZVRUTFZvSFZuMUFaUDI0OEd2WmNLYUFCV2VITFBu?=
 =?utf-8?B?YW9SNjdJMGpCZnoyTlp5YmRaQTQySmQ5L0ljODVXMGlHQmhKc1pwc3NQOGRO?=
 =?utf-8?B?aEp5cXRiOVRaR3hCVWtEbXhYSWNGV0VjQ3p5VHhIT0J6MDlldFlkSXg5VENB?=
 =?utf-8?B?ZWlVVUxOUS9rL0YzZm5tS1hNczM0TzQycWoxNGluazZaSmtJQkF6WkZJN0dL?=
 =?utf-8?B?dWUxUVNLREgzK25TSkZocUVUZ2RoOGZ6a3luM1pWbXRGSlFqWUt0RTRMNGto?=
 =?utf-8?B?aEY3dmtWT3lBTjBWanNuNVdKeVA4Y2U5K1BCWUFMUWtGVklVVmZLYmhJb1E3?=
 =?utf-8?B?azVrWFg5YUxZSm9SRml6NUZvQmNneGxySGZ2eWNrK0N5NnFwc2oyeG1ITnFO?=
 =?utf-8?B?M2tlUVNUYzBTYTNRdEw3Wm54ek8vNVl2SEp0ZXhlS2twN2NYaTdvbG1vM3lk?=
 =?utf-8?B?MkQxQ0NyeUJubDlib1JaZzAwSFR4NFV6MjdiNGdyT1kvdDBaY3NxWHBtbDQz?=
 =?utf-8?B?OGtiNnVUMlphVmFPenF1REsxYmpQNGtHb0xKSytRdFdkR3ZvL1BFaU9YdWpm?=
 =?utf-8?B?NFZHNHJPbzhYYVVaVGFvMElSaXlPc1lOUk1HRE9KMW4rdlg2TVNTNmJtc2dE?=
 =?utf-8?B?c2hOdm1Odk96akswWHRWSWxRQU54Z1BXZSsxNHg2UDJyaUNVSUtaU2JmK1R4?=
 =?utf-8?Q?yyMa1l8UDUJ4YxehXcyTjOw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9c30f7-c90b-421b-1aa6-08d9c5e80d1d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:44:30.0230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0c+YPVylW9+bZoMsVCN9r7G3YaXH0r+XnW5qcu0npsxPZV/1YdcRAbbjiITrpvvr5Zz4KputqA5bnwfLRlCq9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4720
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/17/2021 9:17 AM, Pankaj Gupta wrote:
> Adding Gaurav as caam maintainer.
> 
> Signed-off-by: Pankaj Gupta <pankaj.gupta@nxp.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia

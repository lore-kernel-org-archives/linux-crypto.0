Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC756C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 07:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79BB61B1E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 07:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbhKRIAw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 03:00:52 -0500
Received: from mail-db8eur05on2048.outbound.protection.outlook.com ([40.107.20.48]:41225
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244066AbhKRIAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 03:00:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPKTOZAdzsQluARH+JoGRbjOTRXgSQn4La/yWDFdW9rSv4Lu6h+v//0kungqQWzQWpAHYwgNJQdcK+ZbI53OLarF4nQoWwMoBeb4lOxyH5dsBjRJ9QXXe3eQpKnpyMxqMz+vfs9TSnMhzlS3OVqJMx18SReLG3IGpSS9liFz0LcPNothSIBfYumOGZlNBAEB+SKe0NWZJKiGdG3eW2zIuutJ4z3l7srfLQjNjKHg0ESrYYgEIhAyOczdHNucYjFxmYIy98UUIKK0L3Imx0mzZZ4p/is90DFSIUt1iNXrwkanSZs3RXE4ZBUxt/vz5kmwdN/n/4bay4lpFRq6JtfvgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ow/bX/GRpHDQjchqUIQvMMHNU10bTV+Skfx5iNOCIU8=;
 b=CdiKwC5hF5IqivIILuml+MrwkfkQ1gtMRqG0ZLxhS/Xa16Uety86v3tx+Qrr7NXG32GV/P6PVz22pDMSSIvi28wuL1RzGuIM5ipMfRhVzhRrVRB4oEIE6I1LRgjEzoVfm+1SvYKGH2RoOH9QP+dkdMff0dkV8bCChJ7pdCfaOx2NzeejFWRdp+jjNq1kIYQ56idgjJMuc0d6JejEIaugA9pPMCuGqC3ylJ/iHcdU4i1mjGBz9EZt2ihi9O4q+0L2pw2M4MLhB0sUgHLvJyXhJnc26L1fdJkFPFio3ltgeFvlWN4pGBG9CW46ZjTbOKMk2thLAHODs85wSjlC2HHQSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ow/bX/GRpHDQjchqUIQvMMHNU10bTV+Skfx5iNOCIU8=;
 b=ij51mapAZc+SCnub0DIKAS9T88kJaUGRICj+gmCa2pSkahWLOUPa/pDQ9pKgJ8XriWB7ehq8YXrVnsg7apweAac+sWkmHRhyOuBIFknlETfrrw/RJwQ8EwCxFCUGmE+1HgyNjDREojSbKJwDkP5OrcvAJWci34HED+bnF1T+PCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB5039.eurprd04.prod.outlook.com (2603:10a6:803:59::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 07:57:50 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b%7]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 07:57:50 +0000
Message-ID: <78f35c6d-c7b5-f5c7-b658-00aac28674a5@nxp.com>
Date:   Thu, 18 Nov 2021 09:57:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] crypto: caam: fix descriptor error when create ext4 fs on
 the device-mapper device
Content-Language: en-US
To:     Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20211109095105.203960-1-gaurav.jain@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20211109095105.203960-1-gaurav.jain@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0175.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::12) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
Received: from [192.168.0.213] (89.136.162.44) by AM0PR02CA0175.eurprd02.prod.outlook.com (2603:10a6:20b:28e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27 via Frontend Transport; Thu, 18 Nov 2021 07:57:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5647ac7-f0aa-4d3a-9d76-08d9aa691dd8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5039:
X-Microsoft-Antispam-PRVS: <VI1PR04MB503984530AE7C4D1A28BF260989B9@VI1PR04MB5039.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2eSRguKfIFqAviHVNgXF5VWvcRbGFVXBpigKDxJN5sjUvig6NN2bCueWbHBsC8gXllQPBVxeSfINlHJhU+SoKfRhaSr85ptPIze9SGx3PFFEbe6WaxNp58cfVX+MBmETWZAI6+04BJFT6pHExI9cYsKCCbUiI7Mt8GOKs6vK10r2V/tl1OeYtAXs42QTVd4IVEvamWWBkyFJTCNzlPIdC4KfPhUR7W5T6/zkOWZdRN6fmpb+16bbKIUYcRIkpx0REAnBylZkarp3ljE4gs4lHCGt2r8hCUFd9rMTsnvQC/LBIJWU2yrIxrdtS6nZmpx7Ujb1J0g2Ia5xuCEUWp88FnoMRyovAgA+1OUpNAZLBU5YmWM2rxJ7+XKbPNS7cwX8PUB3ZRUTVMoe33FrTA5d8JKXILym+xk0lHhXK8xAqcBjOg4Ddao1+dUKF+bLH2zhwbvicv74f38+Eyo19FAt2JdCKlpnAiFUdDdEYewJBkSWWBiBOCkcGKtYM7sOqwNkkc21N6q1uaBJP8qyTI10eB9kon7i4GbEVDa2Z0j6oBtcnd3jIdAgOa/fa3zP3IWhPq51MoilPDJOMVAOsQfWckNWQiy5YBRyrPBISQ5ENMIOldY3KzNuIYq8ztpIuFIqqq7Iu0z4OGXK1Ws393BdeeCTAA9qwrYiuCpZRMiYSCDwCRhHFbYJ2BP/wHg2i7bwXo6ffaLKOTyDyzyGVkXTNr3jC2VLQhDLnzlH/8tuK3ikXX3DEfPMcCPAY6phH6eOHmRukleNVSwrRbo/hVe0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(31696002)(66556008)(6666004)(4326008)(6486002)(38100700002)(66476007)(31686004)(38350700002)(86362001)(83380400001)(2616005)(8936002)(6636002)(5660300002)(508600001)(26005)(53546011)(36756003)(2906002)(66946007)(956004)(316002)(8676002)(16576012)(110136005)(54906003)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFNocUlYaFI3dVpybHZFak8vVm1YelVzam45ZjAvRkEvdGZINGlicjB2YXlm?=
 =?utf-8?B?eUlUYXdVVFQ2ZC9Ba0pUU0lTcXBYMUlHbldBMm1UdTAzR2ZFWTFEb0RQckNR?=
 =?utf-8?B?Zlo0RUJmSXlJSWMwaXFESjhEbGE3RzJkR3JVODNmNHlRak55bHQ4Rk8wZWo2?=
 =?utf-8?B?UnBFaWphSUtaUTE1V3NtL1BmZFF5MlgrN01FVDk0YW9mMjRLUCszOHlyS1lE?=
 =?utf-8?B?TWgvTDZhN0F4UkRtaHBKRlNrWC9OMVg4eDdWclEvT3U2Z3FTaFlBQkFxZGNB?=
 =?utf-8?B?U3dLSU9FUkxLNjNRdTZrZHJMRWMwWjNrTkVvT1I5ZXU3cjNBSlFJOHdPZlFt?=
 =?utf-8?B?Tjl6SEkya0tlOGlIbXQ5WkxjcXI3T3FOcjFaWndhS0NHN1l0ZVovU2xuUzVY?=
 =?utf-8?B?VVVnNTlhOWtpZngvWDk5bEhYRS9taEZySjdTOUJNSnJndk5QL0svcE9kKzNM?=
 =?utf-8?B?K2FxNHJIa0VvRnh5QWZqWHh4TVpvTG5HTWRKaUlVUHE0NTZDK0VDdllQWG51?=
 =?utf-8?B?Y1AxUGNuV0FhSkxTd285aEx0Y3B2eG9FQjdKVlh1ZUNwa3l5NnJ1Z0kreTBW?=
 =?utf-8?B?WG5hZ2cvV0ErY1hGQnRCUFNVQmV3NU54QkdCWDhtNEhkdDN0bjFNYUtTZ0Jy?=
 =?utf-8?B?N1lFV0Z4T0lORytFOTliallQNjlnTDhwdzVvaTdPdmh1WXNTdEhqWUk3UGpR?=
 =?utf-8?B?cG15V2hUcmdvbndBOUE0SXVKZG1wQXJpbXRjRVJ5M2NQQnIwMlNIRDM1STJS?=
 =?utf-8?B?WEl6UE9qbUxMV05rWm5jZjI5MUpEbVpaRTgwZnJkYjZiSXNoT0pZTnl6dTNp?=
 =?utf-8?B?NmQ1eENZRWU3ZVhwdXh6ZWNoRTFoUzRzRE5qcXI4Z051Q2lVd3RTcWlYQWNr?=
 =?utf-8?B?UTg4U0JUZ1Q1SzFDK3k2bHBMbVY5MzU4czcwMzl3UE5wczlYL0ExMzFpN05Q?=
 =?utf-8?B?ZVRPR0RxSStrUzNqaE9maDFPNytaMHlQVXFUVmlWUTFtbUhyUDRDeWJEYXJW?=
 =?utf-8?B?WDU5S2dGMkMzM3RZUUpvZVFlR0tkT0lqdkdrdktmc3lWTXFBNGNaTlJkd2I3?=
 =?utf-8?B?bzBBZlBBRXR3SFNvek1WOXVtQUJ2cDdrU3ptUkdhRXFMNUJKZlcxcGk0cks3?=
 =?utf-8?B?bWV3R1Nob0lrd1I4N1BQeDdUdEs1Q2ZtN2hPYkdiV3psRmZqeEhicThDT3po?=
 =?utf-8?B?eUtjZjB4YkRuOFYwRGZ6c0JFbzlsczVPci8xaDFNZkVLNTdWcXhXQ3FFRWFU?=
 =?utf-8?B?YVkza3drdE9iVFFIQU9ETmVJcVVJTzFucGowWkdNYmtoZURKWVNoVHJtVVVv?=
 =?utf-8?B?RXVpdDNyN0s1ODAwZi83OHJhcitGdWVsQmF5MlgwZXpzYjE5TWNrYmFHWUZX?=
 =?utf-8?B?RjFHZkFXdjVsb0MyWlEvZEpXN0MwaEU3SHNidHB2MDQvdFYwL29XdDdqallP?=
 =?utf-8?B?RWlEeUFaYWxJUC91dzFkRDlveHgwYjg5amwzdE81cnZzSFo5a0NnbWR4Y3Mv?=
 =?utf-8?B?ZXI5ZFFRMXUrMHY5ZUtaR3R3em5EbU0xRTM1U2svRGR1VHVQSTdjdGhqdHBK?=
 =?utf-8?B?L3lQOEJHN2Z6OXVUSEdXeXVCcy9haGZrU2lyMTJweUN1bVdHeG12bGdYMFBa?=
 =?utf-8?B?QlVzeHZScXdMZndjUU1Cei8wK256M0RiT0tEWG1qMEF1cXV6WmlWWUJTQWpH?=
 =?utf-8?B?YVBGWGR0VXhqRFV2c0tqRG5rSVd3NUQrOXVsTWI4bllwbWEzeTRXWGlud0c5?=
 =?utf-8?B?RHdFb0NzcXdJTFg3bkhaWjJvWmtLdWlsaGFVNkpZcGxuZFlHVmFMVWdncno3?=
 =?utf-8?B?QjArMitrT3JLVHFMS0I3cHZBTmR3N0l0VTFrSkxYYmQwem9iQTFsQVQzTmtP?=
 =?utf-8?B?dWVsdXRwcWdHLzRBRTRDSTh1eTlxVXdwNmtSbGoreE1nWFN1ZWVvTEpyZnNB?=
 =?utf-8?B?ekZBR2xaeU1IeHlqbmVnYXE4NkNRVEdvTENBNGJOZm85UERGVm9XdTBrMDg5?=
 =?utf-8?B?aVFBMjM0SXZYRER1ZU1xSnh1Q3g2bjBleUh5dVc2S1p2UkQ5d2VQaTlRSldZ?=
 =?utf-8?B?WVYrOVBvYm8vU1ArbWhUSnFGWHhkUS93QTJvQS9rcTFTS1pZUGF6UjVSU2NP?=
 =?utf-8?B?YUVnc3Y0TGNpalZJQ3FEcS95SEI0d3NsKzZGbkQwckQ2NElhbTdIVjNIMHg5?=
 =?utf-8?Q?Q9gloy+z0KmoOeu+OZ9lwlw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5647ac7-f0aa-4d3a-9d76-08d9aa691dd8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 07:57:50.0008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +6P9B1rI3tLQT5YvPAvZsfNpDYNaVtnwLr3gyJVsoqgSSZPl/HAihIergZtFI8t/gqxLgSJqeCqevKKsQyVGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5039
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/9/2021 11:51 AM, Gaurav Jain wrote:
> Root cause:
> When caam queue is full (-ENOSPC), caam frees descriptor memory.
> crypto-engine checks if retry support is true and h/w queue
> is full(-ENOSPC), then requeue the crypto request.
> During processing the requested descriptor again, caam gives below error.
> (caam_jr 30902000.jr: 40000006: DECO: desc idx 0: Invalid KEY Command).
> 
> This patch adds a check to return when caam input ring is full
> and retry support is true. so descriptor memory is not freed
> and requeued request can be processed again.
> 
This approach is fine for a fix, to keep it small.

IMO it would be better to modify caam driver to use the crypto_engine callbacks
(prepare_request, unprepare_request).

> Fixes: 2d653936eb2cf ("crypto: caam - enable crypto-engine retry mechanism")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Initial upstream patch submission should not carry the R-b tags gathered
during internal reviews.

Patch looks good, thanks.
However the subject should change to something more generic,
given the root cause.

Horia

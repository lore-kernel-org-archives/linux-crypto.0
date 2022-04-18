Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67B0C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 12:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiDRMNT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 08:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiDRMNS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 08:13:18 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10070.outbound.protection.outlook.com [40.107.1.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A151E1A81A
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 05:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dnb7GJZ766uCsqW1Y5duuN0WmhqcTKlbwIh3qMQcMfpnfFNb60bdf9U0FGLyJeCeNTv6IofWQyKzF21AblxoAXZXVTxZv6JWeA1tYk7MaNs0zo1id00Z4JgqyKra/oBCM9xBkplnMEID+WBN6xdK+ctdF2d5WSSLxgUI7AhTaT2Ee5V9hrIwCUK+41IJUhAfkH86UhE+EwSc/rg7Fi6lZlvuHIVfpbIsSuOinRVx2f5EHLW1xP9+CVU9V0YvF7fMp3VzDKuBddEsS8OKROuV6Q/I/QYRylOaJq7KksUX4g1PoWgydDWuBX8ccd8qRo25u2t1TjZeykm0K5M/smq0vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ce9qwUaM0AT4WZybPOHPIjf4BiFSxWTncG0/MFTm6mg=;
 b=GQEHFkOHQieMKUdWFGgwiUNsxggXeD09iGOd5kU7uLYtpWvMMCsKrdIR7263/4Xh2198q8MHRlKEseRwoGLhAT++UlCb7M01s4Y2R5aYvkxEARJzzYPZrMUpQzE8yO9im6djWQMeV7BqcyfBudx1sf9J/6r0TOlpuXoMepIQBVYCkxiMlw/PVTpt/B8oO3CYh6vSIp0Co+ylprC6VRdGfkY0Ai+rTz/0RtBCj9tY0nQ1QUuGkGNVxw4x3+jmLdS/t53micFSzjp+dE8+xnXCbt4qTo1VXrw+cpd+Rqr7bCtm9XvKcw4w0uJW5+wMN56TDLQOgN7j5RqktOyXOqIyUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ce9qwUaM0AT4WZybPOHPIjf4BiFSxWTncG0/MFTm6mg=;
 b=Zpx7PBFOMjie2QD8oH24uqeQDCnZqH2k9cZbR4lKfCQGtViHu79xFjNy5k0g2jrOC59Vv/AqPZbhqEcZ3Z0iiH2HBWEl+y5ULDP+69kP+HMc6KwiWhoVoDGZDjn3EOU+ti3mWZnIC5W0GF7Qv7pWVjiqbim3NDqj43CMCE/MYuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com (2603:10a6:102:229::20)
 by AM6PR04MB6407.eurprd04.prod.outlook.com (2603:10a6:20b:d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 12:10:37 +0000
Received: from PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f]) by PAXPR04MB9517.eurprd04.prod.outlook.com
 ([fe80::ecbc:8286:8006:fb5f%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 12:10:37 +0000
Message-ID: <8f51bb57-8671-5eb0-694c-9134801ab09f@nxp.com>
Date:   Mon, 18 Apr 2022 15:10:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [EXT] [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>, Varun Sethi <V.Sethi@nxp.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Vabhav Sharma <vabhav.sharma@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>
References: <20220416135412.4109213-1-festevam@gmail.com>
 <AM9PR04MB82115516947967193216FE60E8F19@AM9PR04MB8211.eurprd04.prod.outlook.com>
 <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <CAOMZO5BX9JhqJapqfqup9DdzL=nUvO1qBjg_H9R8Ly+hs92ErQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::13) To PAXPR04MB9517.eurprd04.prod.outlook.com
 (2603:10a6:102:229::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6213231e-4cba-4fbd-1344-08da2134721a
X-MS-TrafficTypeDiagnostic: AM6PR04MB6407:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB64070DA36DAC06EB2250ADFA98F39@AM6PR04MB6407.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ssFw9DmBG2HAsY4zdUT/bjRWpEmGozPRqwsiss6dDcA5K4Ug9e5N3kKGdeUJvOrwHj/E6APWkubKFzi28MyjL2EQYf60nQSGt4/aSwOwt6GBYEiqMNCwQZiNIK3RDGO+2b+s7A24IjIDrhrm8LYyQ6f/YlCn7vRrCGsyRXcvEz9MaH2YH1lkTNOPGR2V3GHCneJqdakQD+Z+NAN5a+jxIbPh6xTNWrokup2wXVeGjBIqAmbk23MTA6WQZi2VPuNzTOw8SsTkaFFU9buVN/GHJ/O44aokJx3o1n9mZSZa1YYmHywCVmKYdcsDB8DtWP76iAuWYd9YN0FhIz0imp/MyS8tHMT15/qCScFv0JNvZ6RlJ2IS4eKtOxfvH3i1MJSk408jmmptHWcaW7c1yo/1p/FfXYBQPHeWM6b3+fUYZ5RVZyRMZcZeRp4xS47jict715hSXEdgZMiARxKRCy+YCAW5wbXSBDJz7p2pd1iU1En6UazE9s0t5wzbGruBvIgOVH8dCr+TPE4JVJ9oykB8PnhoMs3JArp1TCJ94NmJbeiinwau0fXVGD2v9KDYzGZM9nxWZV2851VJm2CUnUZpdLGCvz2XFk8pQrwvfy6S6NSlQG3tPI5+h8UhkHVP6eP9328mLTECxLVaxIUNHxQjXGjrtCdbMc4Y6MyaMRRLkiFhuynO6JYaJZzLx99g6kP1FZJNd3P+/vU6p/8i0u/39m8H/FmsNAtUKrVONociAzp2eyTxH6LHy+DjV3yGGxuUtOP1PkjaMDLXlJ2r1XRX4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6486002)(2906002)(186003)(38350700002)(38100700002)(66946007)(66476007)(316002)(66556008)(86362001)(110136005)(8676002)(4326008)(54906003)(6636002)(31686004)(26005)(31696002)(53546011)(6512007)(52116002)(2616005)(36756003)(8936002)(6666004)(508600001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGxRSmhMZGE4ZllOcHJSTGVCVUpkRVROaHdPWjEyTERhRGdmV3hwQjhkNFpR?=
 =?utf-8?B?aUNsNnhBRVl1a3hDcWZkcE1KRUx2UlpTbENKQ1k4ckVmVXBaUHpTMFFOdFMv?=
 =?utf-8?B?OTRBR1Z0ZnhVeGVMQWEwTkUyQXNOK0RSNWpuai9RUTgyR2pHT1V2TithWDF6?=
 =?utf-8?B?V253d0s4Wm9UVGlzQkN3YzAxQ0VBRElKdG91SXRaTmFBNU02ZkNtTVdVbzY1?=
 =?utf-8?B?U1NNN2JyakdjeHBKZCtaNFNmVy9jQlBDMjhtNzRwUEQ5eDdYb0xDeDZ4STE3?=
 =?utf-8?B?cWlXcE96aHowNlcvOGJoaUhodHpQS1hhcUhUNUpLVmNaaS9DRWJPUDdOMUE2?=
 =?utf-8?B?VlBWanlRcExuTHhUdmU5Ty8xS3V6a0FqWEZXSnp4cEptS0oxT1lFQkkwd2tm?=
 =?utf-8?B?ZXRxSml1REtLaDR5WVF2cGtmUU5XbWxSR3Z4TWI0Mkc5ZWNlUEVOYkNtY2NO?=
 =?utf-8?B?NG1uU2FJZUFZN3p4UTh1V0w1UGVaZUcrL1NtTVYyZVI5NVUwOTNzd0FkZzk1?=
 =?utf-8?B?d25ZalA3eWxHdTdtWUkyckFNRmRwTmNYTWZCUmFrUFV1bmlhWkM4QjlDbDdi?=
 =?utf-8?B?QStTWDJBUkt6THljM1Uydkh3VFN4c0MwSFBVQmFCM005TnRkV05oaFRsVWla?=
 =?utf-8?B?SXdwbTZxS1FCT2h4VVN4TVNNQ0ZaQzFMZmNDVlp4bkUwQzcrd0pVTGdKTS9v?=
 =?utf-8?B?a0x5Tkl5Q0pIaVJmVHZKaUd1N0NxaDVEQ0NkWFR0U0VnNnR6U3hpRTNQSHZ3?=
 =?utf-8?B?K0tWM2JvRzcvYzR4ZFlteTlaUW80Qng0Y09MdmptYWxYY1RtWkl6S0Y3RWdx?=
 =?utf-8?B?OUNIbU9zTnNIMWJlN3BoRUZHRzQ0dVdDRm9KN2ZmRDZxS0tnM1BIQ0VObDFB?=
 =?utf-8?B?SUZlaEJpMkxhRVBTemhMMERucFNYZUxlNmczV3dCdDdVZklBZHFCSTNva1Fs?=
 =?utf-8?B?Z2hNajRac0h4RTNydkdLTkExUzl5dmUxUG93UDd2SSs1SkN3UktsTVJtNFcx?=
 =?utf-8?B?Q25DTzI2aGx1SFJmd3d2RXp2bUR5VzRwMmVWcmJTLzMybnBWUFNnYWpSNjNG?=
 =?utf-8?B?VXlSVWxkK0U0eVNjbnBxTjdESXVhRXppTnc0UGp2SklBTlp1Tms0ZmM5WjE0?=
 =?utf-8?B?QUthUHNqT1BXUTVucHRibXYvZ2hpWHlRb1VQVzJjM3dXUTRwd3lzZFF1TVA2?=
 =?utf-8?B?eVYxY0MvN0pCNVQyRS9JNUQwTElYejJESEZKcWp5U2xrSW9YWm9CY3FoTHVL?=
 =?utf-8?B?RWhsZk42QVdCVm9xekJwQXZpZW05UG43SW03dEFTVVFvUnFrUjRrTVpMUDk5?=
 =?utf-8?B?ZU1jeWx0MWxBa0Q2TGFvbmVzQURJMnFzTllOc3RxcVhKQ0dPcWlqazE5NTZy?=
 =?utf-8?B?cDdlWm1SM0F3V3NiSU5KZVY4OWM4aUtQWnd3SlFHR0NLRlE4dFR3a2pjcXBi?=
 =?utf-8?B?ZVZwK0lxWlMvbFQ4dnZSVW5CaXJacjZoV0RDNzVPZVRQbUd3K2VoUkdhY012?=
 =?utf-8?B?azF5TUlxVzlqSXpBb0lEcEcyQ1E4dFpnWnhvWmZKeEJOOUdHVmtnZkZJeklU?=
 =?utf-8?B?U0N1OElROHJ6cHUyTi9GeXRWZVBZK3dERkJHK2xSL04zK2pqQXc5dnhUMy9V?=
 =?utf-8?B?aGpiMEUzSVppVDkyMllEYndGRTVkVlAvS2NLYVhMNy96Z3dYQmZhMXYzK2Rq?=
 =?utf-8?B?QWJmSHZWVURUT2JiRjBnRDUwMDJpanQxNy9zTTNNVkNBOEZMejJUSGxFTkw4?=
 =?utf-8?B?MDFYelh2V1J2L3R5ZFNoSlpsR2djTzVBSXFaZXlNdzh4N1doMW5hdENuaUZh?=
 =?utf-8?B?ZTlZQXRzOGl6WEpqL1U5c3ZsM09ISG9TaCtIcno4eTV1TVh6ay9MSVpXM2k3?=
 =?utf-8?B?a0VXK21UR0c0QkNscFAvc3FVaHkrNTBoMk9ObGVBdnFIby9ZeDhENGp1S0Yx?=
 =?utf-8?B?ajFubG0rUWd1Y2FiZWRlMzRTZjZmbVBvSTI1WjlLQmg1YWVFLzE5RXdZVUt3?=
 =?utf-8?B?NkI0ajc3ekh5L1g2cWJQQ0pTZEpKRGQycllqRzdPWnI3cDVkSWx5WXNSRnda?=
 =?utf-8?B?MS9SYnRFSVFITVVaKzZOdkZDNmdleEhUcXptWEtOb3FyMGpYNy9lMXBUdUVT?=
 =?utf-8?B?ZUl1THVxT0NDVzlBSndsQ1J0RlQxWFNZUGNDQUdGRldpR1JpVVFocnBuR3pT?=
 =?utf-8?B?MFBZRmw0OWhIK1dTdUNPRXBHSFZySjFiUGltdmpPcmVLYTVCT2l2YUJvdzNl?=
 =?utf-8?B?SkVuUFNoUmlBRVIxd3M0UWhxbGxtR0YwQXprL3BTdHVyQTJPWGxoVFlVWjk1?=
 =?utf-8?B?M3Z6b09ha3BqU3J6UUVLRnJjOFVJd0tXRUpxOEVRZDhhRWhSUGNHWFpGWkpK?=
 =?utf-8?Q?sU12iVCVmmFdb3Ec=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6213231e-4cba-4fbd-1344-08da2134721a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 12:10:36.7529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAjVnbTkrMxgsdX0/fWLwrWBW0bwhVhqZ798s2UezF1dq8xvBGsJDuMZgifzXgXe9woNuyF1Ul4JqxMoXCTivQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6407
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/16/2022 10:11 PM, Fabio Estevam wrote:
> Hi Varun,
> 
> On Sat, Apr 16, 2022 at 3:00 PM Varun Sethi <V.Sethi@nxp.com> wrote:
>>
>> Hi Fabio,
>> Vabhav is working on a fix for the Linux driver. He would be introducing a new property in the CAAM device tree node, which would be used for specifying the entropy delay value. This would make the solution generic. This property is optional.
> 
> Unfortunately, a devicetree property solution via optional property
> would not work.
> 
> Such a solution would not be backported to stable kernels and people running old
> devicetree with new kernels would still face the problem.
> 
Indeed.

> This problem is seen since kernel 5.10, so we need a kernel-only fix.
> 
I'd prefer to have this patch (or a kernel-only fix in general)
applied only on the stable kernels, and use the device tree approach
on current kernel.
However, I'm not sure this is acceptable from stable kernels rules' perspective.

The alternative is to merge this patch (btw, please add a Fixes tag)
and then the DT-based solution would also include its removal.

Horia

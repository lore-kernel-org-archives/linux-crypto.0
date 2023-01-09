Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B96C54EBD
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 10:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbjAIKKJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 05:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjAIKJi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 05:09:38 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2050.outbound.protection.outlook.com [40.107.249.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A749730A
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 02:09:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ixpr1CZqwJUUuFeFqXCX8aNVK82diqqM8RORVeejWzosMuy+3ViJQXz4bR/z8rzLFU3epFH7GG8hVEk3T7LnzKo7QV9Py9rGnItXyValFCJSPbW6tASYzpljUQLiQs6VjVcJsBf6RP0VbMOW1oK8pf7ReUrraB+ZVCLpgS9sqqRzCzvAQZHCmH2agaGY6xiOCJ79a/fGsp5VHvQgoiHrKZ0R2IKFfU1elbF3WHB1JRhCbuFC0TD0dW0MRH8Bs7CfkfhZMs3UYfWqTWyMsvFEerAlG7yDxBaNErsX3hqEjbfbfj2oboUboYolrA4z2JZdbjxdbaVdZMipQd8/B/7xkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IUkXR9/rBpY5d4zsinynvGGxzCB36aNRVdVDcKdUek=;
 b=O/08LtxnK+Sza5c4T7S05txMBM/QDyIBcCF8PEX37wbBlQagG4ecDmkLdvNtjgfig1GzlCj0+QPWRf8lM3UeIxw6So4N6xcrFd/Lmbq0jK3VOem60rkk5eQpYLqF434M8Trws2WeyU0+6vHVuu9udb5hzJTQebXqB0RxAgde2B0W8EpLX6VQ1hmhYWEO/pHzo7YruuNfWaVyq8jTZ1OysXbHO/HC9NPfo//2U2qT52QpR6ASz0tq4e+zMa4H0NerrlvxfCysqHme4Xmr5/MhM+3rog+2gTNQV7Ave84snjZ92P98ahsm9eJxU7lphLHqcPEUvGQBNGuJ7TO1umJ2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2IUkXR9/rBpY5d4zsinynvGGxzCB36aNRVdVDcKdUek=;
 b=XBIM8EOY5elBsDKA6Y8TVIgUYrCxITzi0FpRG9TsINnO9ThP8hl4g7Y7TOgpviBBbaVYyG/r7RhFClCfIOIAva9gdO2cI0F5lVMcUkpB4z4GdKuCgTsrsSLHYJV8Aeu4bGS3/P579Ejdyvt97Fklq1t5Da45BXPOR+5WrIiPWWKkgIok1e80+AofZTWcWkq+2+NwZFHZV9+h0xdGlxLFpy7Vx+Zct/1mK7L6QPL0IG/ziZW3PZEi7k3fk+J6EXwM4hXEs820WjhEOJsQp/kXksKxzSqm0rP+RwrH0sfpFdDdmQd+tqgcaWadrLMw8Pk36ivwe07S7YCWP8Qnps8w+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by DU0PR04MB9370.eurprd04.prod.outlook.com (2603:10a6:10:359::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 10:08:31 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2991:58a4:e308:4389]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2991:58a4:e308:4389%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:08:31 +0000
Message-ID: <5a07ddfd-eb8e-a9a1-6952-67fb45f2727e@suse.com>
Date:   Mon, 9 Jan 2023 11:08:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
From:   Jan Beulich <jbeulich@suse.com>
Subject: Re: crypto: aria-avx - add AES-NI/AVX/x86_64/GFNI assembler
 implementation of aria cipher
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::13) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|DU0PR04MB9370:EE_
X-MS-Office365-Filtering-Correlation-Id: 279459e6-7d7a-4cdc-ff51-08daf22975bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwSt5orWzuNxvFUu+SpeH2r0XnyCTFqKBjp1HrbbOtQSAaU4pJi722sCj56nz8iEX7Cx3ESNZ17GcySKaZ2TEdL0a1U00Qt4A73gR2YTd/JGEYuC6CJIGLDVovnhIgd0rg6m2+YimElcdZSexrwpSgUtmLf12Kd53MTU9PPGRi7WDdxN+egahGf3dl8tO1mA+cvjlFKXqYtLcyXG9reOkN+s3JWLeWnUxe2kcI96V5eGLEMOa2cace+iRyvFMhZ/AvCeypAXZ02zZnc2MR6WJ4f7Pezhai2gqkvmzv6VzkTZsluucBa47YZivrmErTcY3AzxeZscfCaHgvw2BnU4j62JK66KQHBXc44En0d8uCG6FHdi5/lKTB3MsVDzJLKrp2CPLRFTnd3JSV6xPl2ski7573PRlee7HVRD6xIX4VUht97dc+U2aFeWLnXF+hsz8mKixgpGj4Zeg9Qr+DR5Ggbso/UTgyFLgMaRLLHgqiirlCuQl99P0oIj5uGri/w6QhBdGliD3I1Njn1O0+krOKTroRl/53EjRu7pLVv36pkZ3B0Na3fY82H692tHNOQazyyGfytuHUwyZgEpQ730BgQ+kCAv3b83rfrRZEoiWzOUBITGKOtXmvABy5b6+XCBZY1vhZruQ3GyqE5d1W+Irh4P34WP5lDFR55QbchRtgz0z3SWKVmYD8WiVPIY9pvPhvrOl7239T4HqKtVLz5VQMawBqmwo6XrjWmSC7Ib3FY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(41300700001)(31686004)(8936002)(5660300002)(36756003)(2906002)(66946007)(8676002)(6916009)(66556008)(66476007)(6512007)(316002)(6486002)(558084003)(6506007)(478600001)(26005)(4326008)(186003)(2616005)(31696002)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEdxM1hkdnlWUGpnWVNYT3pHbzBmb0lxSjV5Z1BJSlJ5b3E0YWNydi9Bay9t?=
 =?utf-8?B?THZ0RWRTWFpwTVEyNlRseCtJTUtnMEpMVHpOM05pU29XbG5YSFRoQWZndkFZ?=
 =?utf-8?B?OTNHVWk2YnV0MllIWG9WdFlYdFhUbURtWVczOVZsdDg3bWRnMmdSU0lmbjNZ?=
 =?utf-8?B?MlVQRmRwWCtINjdVSWdSMVRMdk5oU2I0cEVHUUlHUjJkRlBXcXdYKzNEWSs1?=
 =?utf-8?B?Y2NUYUdpZnp0bHArWXpsYnd4ZUxpNlcwR2tsYVg5ak1sT0pwbDZyUGVNY3J3?=
 =?utf-8?B?M1V1YVNPOHI5ZGVYVkxyUTN3ZnJIR1FKamhpNGZZN0dmODNvOWcvTVBJNll3?=
 =?utf-8?B?OHdzWklSdDAvWXZKcXJZWFR0MzM3SmM1STR0bzV2bWhyR1BNTEptOUtvZDJS?=
 =?utf-8?B?NFowdm9DdFZlZHFzWW00RGR1VTh0R3pFUUFiTjlxaWN3aHN1V0JNRU5EYm5s?=
 =?utf-8?B?Nm9RQU1PeTJ3akh5WCs5bjBSWE45aS9zd2NrVE8wNG1FVXZ6bkNXVWpONlJF?=
 =?utf-8?B?endSN0RZSW5zcko2bDNoTlhiQ0pXS1lCVHhxQ2k4aGhmNkMzQkttYnBGdlE4?=
 =?utf-8?B?ekVKd0wvaVQrRnJrN0J6aWh4UUtaVTV5MitZVkF1bm1xYWZlSjVwY0ZDVnlZ?=
 =?utf-8?B?eUhqYTVZbjJ3Y3R5NUd6MXp2MWtrbkV3WjZwWkJRL0s4MUlIeXNNdkMxYitU?=
 =?utf-8?B?ejZUTjBpY3VmQUxqSGNUL3hmVzZOMy83RUcwS0lCWmM5eWhWZ3V4anJaKzZz?=
 =?utf-8?B?Tm5Ka3h6akMrblZWMEVPcUdGV04yVndvK29ZYmwwelFxeW1xM1RZcWN4ZWFw?=
 =?utf-8?B?VmwzSU55dGR2WFRyUVFVRkdGZG5OTStYTUREcUdJSG16RlRiWGFUNkV2MDFh?=
 =?utf-8?B?L1JRSUorWW1ObnBaVmQrTWFCWnk1YXpMS3p6OVZoVndPcGJtNHA2bzRxYzM3?=
 =?utf-8?B?T3JjSG5FRkJkQ05JYWMzZm11TWtJbTN2V0U2aVpYMWVkR3RMVCtwRDhjMzBB?=
 =?utf-8?B?b1B5YmRBOTVKUExpS3dneDdoa3pnMUlDMmNNWnJEbGRubUZmdmxpMDVJUUFz?=
 =?utf-8?B?cHRhdk9adGY3RGZGQW5FOWM3dXErbEhhRjVYbEFlWmFmdXVnVlRNYzJDKzZo?=
 =?utf-8?B?MEUzL2ZabENiZmY3dEx0VlRVUUdCUDJiTTBtbmJVNzl2ZUVUUFdkUkNvZ1Ny?=
 =?utf-8?B?U0ZOTmFDd3Z6UmIxUTRSa1lVS2NvTXNGekZHZFZyUTZUL3c4YU5XQVIwd3FI?=
 =?utf-8?B?RUZrMnQ0aVJhNzA2Umt0Q2NId3pQQ1RQYzR0UXFpT1lIWi9DWDNoNENZdHda?=
 =?utf-8?B?bERZRUxTNFhNYTAwYi9aaFgrNXhWNkN5bUZSNWpqUHA2QkU1SFBlQzZWd3dm?=
 =?utf-8?B?anNLcDVCa3N6VVNXaWZxV3hpVzdkbklFelFUb3FxR3VDMEo1MllINzdSM0Fm?=
 =?utf-8?B?U2dsTlFBVnUvbVBFQis3NUxYRHltKzE5UlVmazZtZUlxWXRCYXpFdEcybzJu?=
 =?utf-8?B?aUtGNjlibk5tZlVIc044SzJoOTNGVkNUYkVORDQyM2pWdllXYXZ4QTljSjZp?=
 =?utf-8?B?RUhsMWlaNGdvRXIrcElMTExUNTB1Z1Q4N1h4cXdXdS9OTURvWkpkY3J6dnhv?=
 =?utf-8?B?VDZkWTNlOGZ0Nmh5NkIyWVhGMkZyb2tOazM3UGVYZVIweGJxSWM3L0NiUUg3?=
 =?utf-8?B?RnlNaFdWVXEvZ043MUZRWGwzS2U2Mk5BUS9PMjlwbHphOVEzY3dNZjBCK1hZ?=
 =?utf-8?B?Ny8xOW96RzFOWm5GTDc4VVpyVGN1eXFUb1lkMTZQdVdCbjYzSGlOSGxkVXB1?=
 =?utf-8?B?c20rcmhIeE5GUEllZzJvMTFSRG9SaFpCdm5lekFYMUErWExxcHBNUThnTVBu?=
 =?utf-8?B?UDBBd3BZeENxTURwcWZWRVdCRzdTWlNGRHZZenZEcUJzRkpQVHdGMHhLeTkr?=
 =?utf-8?B?dlJwVTIyNHZrT0pLcTRFT3ZHbjhzQWJ1ZTZjWWYyeC9qWFd0R2FKSU9KcUdR?=
 =?utf-8?B?c2pqKytzRjJJTURuQ0RBQXJXZHhEajcvb1RDbzA1M1JBOXQrVE80dEVEbHRK?=
 =?utf-8?B?RWg2bU1McS9HNWlObkZZRldpeHc1YUFRZjRIMlZ1QU1qZy92YW5IdHhaeWhj?=
 =?utf-8?Q?+/ZgqAsz1r8JBmRZrrwK60kwR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279459e6-7d7a-4cdc-ff51-08daf22975bb
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 10:08:31.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YMhLQcqnD9hNIqw8INBdhZ3rH38nuBudsbaHgzX67hGMqn2iK6HbIKwOMjeVCq2V/dAum74FZUmoy1D4u5yR/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9370
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

sadly I don't have the original thread to hand to reply, so this standalone
mail will need to do.

The documented GNU binutils baseline for the kernel (6.1) is 2.23, yet this
new drivers uses GFNI unconditionally. This breaks with any pre-2.30 gas.

Regards, Jan

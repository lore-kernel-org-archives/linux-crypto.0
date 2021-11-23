Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908A2C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 17:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhKWRNx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 12:13:53 -0500
Received: from mail-vi1eur05on2046.outbound.protection.outlook.com ([40.107.21.46]:52129
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236928AbhKWRNv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 12:13:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOvUh2HZBaUZWB5tTEzsiyelvV2gfagZjqgXS8tH5ZDN1wqS8Z93uxOYmftRDyFeOpvdxUSVVFx2FnWeuB/5UQ+hAPLnWqRjSAWXnPiWCPPaF/8NtJUgykgvIvPETcmpH/vmjuzU+BMqHrXyOZSM/jyp+b45CriqeqWaFI5qYC3RvIM9KnJOWUl+hC3rnczpEeaKozdDJIt+z2xwbJk+Ula0sDqPmNBIcsBp41nhdTe4QVBc846GzeGepj8xdv+kq5d4HLwANZA6/rxHAgUpbouq+oW6RFZeXDpwBgFGM38GqmxIrZQC10bHQGn97YdlCKGjuxPnZjpUBp5d6aG3Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktaiWcvusuKWc5wpAuZcxMqaKoawzvu4LGD8zU+uCuc=;
 b=AmN4PwM4Fvx6gtQXHwyarQqAAyr10flJb0WPERYTNBm/SKXXDglUpxP4veqbMy7wpnPYM6lh4STCuloErrHbIpPc5T0b/Ofm/7FAyy5zP1vCq6eLwARhZPMrNVnFqv22wtoUcgJXgPJe4ltn0Hx+nuuNOyAs+2+BAh7X2oQNPgDtlufiJCkcE8G8aaKurNrmOhi9Add9iKOJoTPKnpIwk0yrsbRqSY18xpebvGFHuM9uDfdnoBVQbWO86K8LRDr0fNdGH9tEYbN/F19hQib0V6PRbTFNtcvriY+raUoT14yNFK5W56OJqSBeZukFk0eJKUI0EVEwb65/mxZgMoa4qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktaiWcvusuKWc5wpAuZcxMqaKoawzvu4LGD8zU+uCuc=;
 b=kilPkUIPRf7x1E3ey8qZZAx2QM/BQ2dEXGPibG23gL/xS8h/feuvDV2RjgdlIMA282qDr2LalSGRI6SWMDxRc9CvBVtB8MmO8eWNAL2CDKp84GhK0X5lBPT9TMV55ZKR8v7of1r5gTLRPkV0aPIHHy1S7Vff8n8KoUabcSnHctA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3136.eurprd04.prod.outlook.com (2603:10a6:802:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 17:10:40 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b%7]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 17:10:40 +0000
Message-ID: <6d129fc1-611b-2ebe-6ca6-5797aebb6a09@nxp.com>
Date:   Tue, 23 Nov 2021 19:10:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] crypto: caam: save caam memory to support crypto
 engine retry mechanism.
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
References: <20211122113234.851618-1-gaurav.jain@nxp.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20211122113234.851618-1-gaurav.jain@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0086.eurprd03.prod.outlook.com
 (2603:10a6:208:69::27) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
Received: from [192.168.0.213] (89.136.162.44) by AM0PR03CA0086.eurprd03.prod.outlook.com (2603:10a6:208:69::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Tue, 23 Nov 2021 17:10:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b894728d-5492-45da-48d1-08d9aea42cd1
X-MS-TrafficTypeDiagnostic: VI1PR04MB3136:
X-Microsoft-Antispam-PRVS: <VI1PR04MB31360160A9D15C7B014B613998609@VI1PR04MB3136.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMrQ0srP4BHGnYMhfNrDRGnoN69/350LI7jKuUY79quNQKm9K88qSpd9S0TGufmLM1q5z66hZagdteeFy9eXF2tjm6hamowg05PeJHDyUrbblH4R4Fcgp1quHM1X/xsEUmnX7r35VSlZMm9mShPOmDlt8sJhV2Ep5vkkA2ymreF8bQ6acs1+IANQw9qvGEBrwP09BAtX+QLwmGXNEy6PyTajKt9g3/PVd7/EnSNvkJ5ab6LJfGX2lcVwCVbXTRgRghjZaXaG8dWkOFS202Vwzwogn5LzWL3Vlz7cAwDM6iyvSMNExpkf91jap1wrZ0uYTyqjuf3sT57f1RIwbH49fWA70uSe3dVjWBb17XSiohoECTMlSBYIfIYYz1KlMmQU0To4xxynllh6mqtYRBHAyvBRZ4SR1t7wgzi4Vl2EtKD+kuiBo/Alb/5b8VvvX4FP5fDFQbeVMYFxyZXVEOoDY0n5NVoqR3AP2OpKPLedgt7M8httS7pYFSW+q5vShZ2V+SVfOgjFFqpQEW0w+QbuD78TGeRT5g4ybqIDW4kk5xxHEoa3ZDuK6/d5X5vDjzsq84ly8O2CXavZBiT6tsMzngiTUbz66ACiiQ4cQ2+ylXHQ5O8plYNDVupi3SlJggKY1gBdQYZSjxr4+0+b/iUGXhzdQmqT+82uVUAts7LrXisF41tbUj5mPtl+Q5x/hXCF1MkG4F1igcgO/KTZnZ+g0OxU7V+QKAvW/KrnvEQAy/gWmfbpEayPEOGraXgim3LgVqgNnkKYIN+wR5C++iSjEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(26005)(8936002)(6636002)(5660300002)(36756003)(53546011)(8676002)(31686004)(38100700002)(4326008)(66946007)(66476007)(956004)(2616005)(86362001)(66556008)(186003)(6486002)(38350700002)(16576012)(2906002)(83380400001)(52116002)(31696002)(316002)(4744005)(54906003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M21rWHlYdXVmMUxtZDBKQk1IZm9FYXdoNk5yeFI3a3VrVVQ1bHMrL2NNRUpn?=
 =?utf-8?B?ektMNGo1RUFDMnh2blFpUnk2TWZSYVgxTGNwWU4xTy9pblczeFVxTm5Pa2pX?=
 =?utf-8?B?TU5RYkZTNkxaRmFIbDdHam9hRUphUW43TDFDbkF0MXpIOU41cDQxWVJ5T1dx?=
 =?utf-8?B?YjIyZmdUem84S2hYa082QWZlWml5dER5STlBblZjTGdNZ2NyN3F4R216eEg3?=
 =?utf-8?B?eVBmZlVFcHRTVzJlY0Npem0rVW9OZFVGL3FYNDVCZXBTYUo1RU9Ga25ZV1Bk?=
 =?utf-8?B?am9HOWJiY2V2VlVPelJPaHZTMHFpNm5yZVo2QzlWNXBkalNleGd5SERMV2Rp?=
 =?utf-8?B?UEIwSFRpUUU2Z3pHc0lXeTVuZXRDcm5NS0FvZzRWWHFRM1dIdGRSK3VHaVNS?=
 =?utf-8?B?Q3UwQ3RyZDZOMXRxUlo2MkZUaVhqNWlSeVRWa2lPbXZVVjhmVVc0ZVlML2Fk?=
 =?utf-8?B?NXEzcEhBRVRydDFxS2lHS1FDaW8rR0FNVjB4RjU5OTNONUJBNC9WK3NZUHJP?=
 =?utf-8?B?bEV6a3Z5bklkSjlkVTI2TjhCVExNMHBRRnhOcVNQaEphTk9CSWhIcWErbFRG?=
 =?utf-8?B?UmZudExUQ2NBS2ltRW9EZ1dSRGIvaTVud0VKZUJDQ2ZIb1paV2N0aXJYRGFJ?=
 =?utf-8?B?N2E1ZjNNMHBDWkxFaWxvaEZZMjJiSjZPVGZ2ZWQxdlplbUJkZTBNM0U5cWtO?=
 =?utf-8?B?OVNzUkRsbGY4QzNOR2FQWjl2QlNYYWpjQ2RHTUc5ejFKY09INCtzK2tFOXZs?=
 =?utf-8?B?RWtIMExrOGd0eG1yb2R5S2VGYytXOVk1ZURBQ2NvVU00bTNXYVZLZWtmem9t?=
 =?utf-8?B?ajRYRkJlOUxIeklaM0lpR3cyTUk1R1FFTzZ0QUhmeUJVNzJOcWlkSXFheGgy?=
 =?utf-8?B?bUZSZ2VLVHJKUFJZQkV6VldjSnoyQk01UlZMa1M2cUtldzVjSEVRV3VNbGt6?=
 =?utf-8?B?S1ptSjBmMFovZTZjWGNNVFdHdWlDakVyTXMwUXgvTDdldDViOGowVFFUSzJN?=
 =?utf-8?B?YU53T0VGQkdRaTRqd1VqclBlcmFnL1FiQ1JOcUFIK0QvTkFCd3FFMFRrdmd4?=
 =?utf-8?B?c2tSSjBNK3lKaEQ1ZEtaWHhhY3FwQzdmaE44bUxGeW5KZ0FWckpJbWI2aDNR?=
 =?utf-8?B?c2h1R2piYWQ4Z3UyUUxROVdsdFh1T05BczhXa2I5clQ1cWdpc0U0Z050YU1W?=
 =?utf-8?B?b25pNmpQNVdkVVAyQlc5VDJhSWlaTTVlQmgwTVFBQTdqZGZKQ1RUSzlNQW9r?=
 =?utf-8?B?WGdramtTSVNqVTNXMVF5ZGJLaStvdit4cGJjU2MyWDIwS0hiTHFXK1Q0bmc4?=
 =?utf-8?B?OVdaRzI0T04vYUUyUGxzelhQQUtZZXhPSWRsZGxKL3M3LzNoTGYwMndTOVk0?=
 =?utf-8?B?NmxhUG85WlplUDlZOS83Um9ZZ3d6ZnhJbWlnRlFnYVV6RjZoR0ZkNVZZNjZ1?=
 =?utf-8?B?bTJnaGZ6YlRuRGxFMGxUOElQYU5jdEFLeFB2VDJ4dlB6dVplNVFHTkpSRVZG?=
 =?utf-8?B?TjY3dFJBdGNRbmFGUkxoUFNYaDVOc0ZEdkwxTDkwOGlRUm0zZDRSSDMrTGI1?=
 =?utf-8?B?dndiZk5DWDNoN3RSOEpObG9ZS1RjRVhJQS9BbzRyVUg1dXc1a2F2dnhXZjBU?=
 =?utf-8?B?YnE4R2pmRXNsdW9XZGROZzdZb0dDTDBJZzhLTDNGUStoMEc5ZUpydzFyckp0?=
 =?utf-8?B?cmtOQ3lzSWxheU13SVkveDBtNW03OUc2NGRxb1RHNVpGaVJ1N2phdVpOb1pL?=
 =?utf-8?B?c0lRbTAyUXNrUCtYNm8zWk9RYzlJT3BqdE5WQ3BDLzcrR3EzV0QvdjRzL3Bt?=
 =?utf-8?B?SjZmSktkcm1iQVhXbC8rOVRJNjR5aTFlSkxRcjV1VjZOV3lzTDFoQ2Y2QlRV?=
 =?utf-8?B?T2xYR0xzZCtNb1d1ekg4Q3JJb3Exa3lmajJ5aWd4eWtGcHVBNXNhQWRLRnlt?=
 =?utf-8?B?YnlHek5pZnpkUjNvc05ha2RianpqQTRJenphQSttc3IzOVRVMlpuaHBuWWRa?=
 =?utf-8?B?bHZDZVFlUzcvbitHTHhKOUlTUW1OVkF1TVRvaEIzWU5oeWQvQXdzTS9nQU1H?=
 =?utf-8?B?dmZlbkxuZlljUk9YNU9QOEc4cy9QcjNIekVvSEtmQkNObDdxa2FpUEVLKzdU?=
 =?utf-8?B?T0RXS3BXT01XRG9HclRkd0lOVE5sRXJubzNsSkdLVERJSDBJTmtRTEpnb214?=
 =?utf-8?Q?L65CTzRj6VeAj3IJPz7aLJg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b894728d-5492-45da-48d1-08d9aea42cd1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 17:10:40.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPGi/zi0v3ZG9mlTlE23yqRz0oaBm6PTBbSiY3CHbJ8nnkNmETqdL2iCnYIgB6ti7VB/wnDfZwQJtrA7af12Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3136
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/22/2021 1:33 PM, Gaurav Jain wrote:
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
> Fixes: 2d653936eb2cf ("crypto: caam - enable crypto-engine retry mechanism")
> Signed-off-by: Gaurav Jain <gaurav.jain@nxp.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Again, please don't copy R-b tags from internal reviews.

I am fine with the patch.

Thanks,
Horia

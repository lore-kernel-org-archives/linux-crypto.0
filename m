Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BBCC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 08:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 120D361B7D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 08:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhKRIY2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 03:24:28 -0500
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:38093
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244370AbhKRIY0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 03:24:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRIHTLWkQOf8CYYL/7lexc3RaQ7aBJdF9xSMYFuYGuHQgsXcpdJ1HkeilM+Mx8tm3cblRhbez0O+CPzeyYE5ladWW5JSvcf/4q2V9QQwCwruRXurBoV9K75rjDq05Bx0Fq4UdkC8W6UjrNt4KT4nD38scpLrhAWsvGVleZsPL+O/FOc5C6ScXhft80RL0ZZSPE5e2Kv4qF40CWfeRJ1nvGMI1yRUMaEiqLj9ICqy+nWYkxoeMaGaoJDVLm+2gzUnq0zEhxFrVpsEyXaiFMIQTSpfcfZWbHc63b8zaDpopANN4F0D4tn6NmIxhD6xJ8ogEvFAoPJVWzolgZvsEnlSSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbKvH+zj/abXsWV4DNkHriyHP42Q4fOqKZOCkWKpjjs=;
 b=KBYS7x4dTfTBz5jPN35Xmp1etSyIZZj93ugoEf3h3dhUshGST8+I4asFV9gZJkr1HwEjum4SNxBbDaVAVWT35eOhESKJC1idfZNJYqaufV+CUwHl1SKG52en6oiFqfdkdhYu5AftwTF9LC+alncEytsAtleMu3wQwodGTGDdZopD6LuUrDzTe8d4EiEyGhkz5//54prOoS/S+7V/AtljrN67JLiFvapJXStAYPm4CDpXBfKzfdAa/58ggPyn31fc5XjlV5CWt3gTwwicG8OlMcYN8oHKyQfOrhECmkrK3zT41SKesDFZQC5lITzo+gvP37+8Fehsw2suYur9IN8ipg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbKvH+zj/abXsWV4DNkHriyHP42Q4fOqKZOCkWKpjjs=;
 b=p4sFMJi+PhH2u2QTnebxOQk+fYdgNNGNGWVw/H1O2vJdxSDeKuwnZOzL/5yxz4umDUot/Msfuhj36qEmfhMF/NaxNgcFzu8Ni4ssNpF56+N4COfyM8gVZQboV35VWE2Jitvbn3CcrtNi9VJeHyef3Y0oK2Utgh7IsxLkUw7Wpqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com (2603:10a6:803:4d::29)
 by VI1PR04MB3983.eurprd04.prod.outlook.com (2603:10a6:803:4c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.18; Thu, 18 Nov
 2021 08:21:23 +0000
Received: from VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b]) by VI1PR04MB4046.eurprd04.prod.outlook.com
 ([fe80::50f1:1936:3037:778b%7]) with mapi id 15.20.4690.029; Thu, 18 Nov 2021
 08:21:23 +0000
Message-ID: <d45c25c1-1cb5-cde2-3152-3920200a8b3d@nxp.com>
Date:   Thu, 18 Nov 2021 10:21:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with
 raw_cpu_ptr
Content-Language: en-US
To:     Meng Li <Meng.Li@windriver.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211101031353.2119-1-Meng.Li@windriver.com>
From:   =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
In-Reply-To: <20211101031353.2119-1-Meng.Li@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR06CA0133.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::38) To VI1PR04MB4046.eurprd04.prod.outlook.com
 (2603:10a6:803:4d::29)
MIME-Version: 1.0
Received: from [192.168.0.213] (89.136.162.44) by AM0PR06CA0133.eurprd06.prod.outlook.com (2603:10a6:208:ab::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 08:21:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5eaaa38-b151-42ab-a03d-08d9aa6c67f7
X-MS-TrafficTypeDiagnostic: VI1PR04MB3983:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB3983A7F0D39962981FF7E9CD989B9@VI1PR04MB3983.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:568;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WNHWeVFnT9U8mRrhXHWi6idzml/N+kiT5MuIHT381cVcAdXHdfUcMKnsL08FmsdpL7TN9KxHSBbPx2/oy4XO7tE562iA3WStzJQDk12yVnBTwIsyYgd0pRTb5qn1yBmSX1Riel5BMFcRUx0792Wap4h8gIM9s1RVxhmS1j2gbz3r9YeZbITjbf+tQ05FlDNT6woU5eJXulqHDQ39HzKYJBwhbqYhcIrxaCjPM9GWxOFxrD03fmq/gWdAVhJ30A9JtPwo4DLqTncOs4Ryj7wqVo3jr9devEflYj7noViPmav1EgqG01/hIncX+bobqmkcmF1oD2rPtXY5KqH00fPSl1XnVals2aAdxdz1Ujl3q5nCcfShSSveQ8kwPiAtZdyrQYgMqdCTvUnbtn48QjhhnuhW4B8LhFsB8PAghn5nSyoqqWK4tX33pcFodHH781bXpdS290a4jSbP365B+YXwcDu03APaCcZDDMCcDroclb5u1n7kNnHX0kLrfFM/NRWsCAkJutumToWu6aelW30zVww4BrJ87368Gch11By97JSFRIhBCQMNLpAMt39ovMhPboS9pcsEKEi16Td7TxUnRAXCWSYKaN1o3q5WniPDYBLgr7O4vehld8il/WKtuF/+0XVq/ZZop7HrPUvmtyZK+euaJwGvE0BPqFK/05sc5lbLy3PnjJ+7KaEWvuYmjtCEU8LcmzqUSerMM5UYjSlX228SloY21M3dzO5Mho46t8f+t/IgV2vIGPbtKpnPXIUZirQWeMlTkZ0+EmX7/rkdmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(26005)(2906002)(31696002)(508600001)(36756003)(86362001)(52116002)(110136005)(4326008)(186003)(54906003)(8936002)(31686004)(38350700002)(53546011)(316002)(16576012)(2616005)(66946007)(66476007)(66556008)(956004)(38100700002)(8676002)(6486002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGo1Yy8vSTdqcW4zTWVvaWhzSU54dml1UFFUWEt6aVdqQW1XRitsQ01YTU1F?=
 =?utf-8?B?SGkvSENnQlVQZUVFVnpFYldXQjhyZld1T1U2aCthbGNPVmxvaldrUGl4WlhR?=
 =?utf-8?B?YTZnMzhZMDdKVEM3QmVEbkxVV0U2b1NTcUVRblkzZ1ZYYStreXIzWUNQK1Mr?=
 =?utf-8?B?ZTd1LzNjSHZJemcrLzdCbUkvM1RzKzBCWnpkdDh5TGdtdytQQnV2UzJ5enNh?=
 =?utf-8?B?NEFmY0tuN3pweDFzaWtVbjBTNmpUcnk5MC9HbkVJVVFCUFBORFIxTlJBa3FO?=
 =?utf-8?B?ZlJ1bng5dWxFRGFmeWNPQnprUjBYcEhXcUs3K29iS2RIQmZobXd3Sko3TTI0?=
 =?utf-8?B?cDdGWjhZTFRkRjNXSlU4aE9sNG5EWmhGN3FWTUYrVjFuWUhUaE5Ya2NvZk44?=
 =?utf-8?B?YzVHY1A5L2d2NTdYZThsQXNsTWZJNVMvQTZ4YjRNU0toRjMzSlBJVWhwMlox?=
 =?utf-8?B?MWh6V0lSUGpkKzVYVDhIaGxXZ1Jnd0h2eE5XR2ZHM3NDY3REd3l0UUlHV1pN?=
 =?utf-8?B?Y1hQQk05S1RGUjNUQjFra2h5QUVoR1U1ZVY2eWZhZVVZdUltUkhQc0hsNWhx?=
 =?utf-8?B?Z01ldkJlejY4ZXJkYnJCaXUyZHd1UUpWQVY0eDBJWkYvNUNjRGhuWXB2SDlz?=
 =?utf-8?B?YjJoR1FMcXlka3dVU01BdFgvd1YrWlViM1A4QUpBV1lTQi95NmpVSVpST2tM?=
 =?utf-8?B?RUhHV2IvODJMZVZMeFZua05iQnhac0J0RG1BV1NBMkVCOGxENHlIR25uL2xY?=
 =?utf-8?B?OGFwMitzRVRIVTJrSjBvN3lWU21hbHk1d0QwSzFGaFNseFBsd1llRWFhWFRu?=
 =?utf-8?B?RnMwSnFXdTlHVTZ0MTRIQnpwL3Y4c21xU3lCRis1b0dFcFNkN3JLSEM0Q1Ev?=
 =?utf-8?B?OXVUUnRzTmlIQncwSXl4cU1SeFpiWEk4c1dCKy8rS2o1K2ZYUFVnQnhWN0V6?=
 =?utf-8?B?M3dFTDlNaVhTRUFHTiszVTJBcGJyc0I0K3FGMGR2TDFleWhhSWU4REZVTDRV?=
 =?utf-8?B?ejVRN0h5Qm9hNFVabFVaVTBkRWZhTjR4Rm9tL0pWK2ZHM0ZTOTdUMmRWYWIw?=
 =?utf-8?B?MHZ0aVZ0UFFmT0Y5MXZoWjA3YTZvbUJPWTdYbDQzRWcxd083Z1J4UlhRZ2Rv?=
 =?utf-8?B?U0NjZWFzTDJBcHo2YllOa1NidUdxb0xZZjZvMUhMbUFqdWp5QkJlNFg3RzhU?=
 =?utf-8?B?R3JRb3VkQ0x5VFhmM0hFZkdSSHJpOVhFenlrY09ydCtRd0lSVDdWL1AvSzFw?=
 =?utf-8?B?UUVzcWp0WktBb1BlMmFCb3lhSVJSQnZBZXkyeUsrRGozcUhuMlNJSDBLRWc4?=
 =?utf-8?B?b3liTFdhTE15Y1REMm5IbktJMnV4TEVnOHZ0ZllTYVhtL1Bib0RxdHJ6L2hW?=
 =?utf-8?B?RjhNOWE0c0N5aXRGN3RkU2FMU1Y1VGZoNnY5dkh5bG1GZEt2K1BCaUtaODBv?=
 =?utf-8?B?ZVFYK1lBSkd1Vkt0WmJuR0lmYWZEdmpLOUZzdjlHN1NTK0thRE45S0ZrMnJR?=
 =?utf-8?B?TEhBTTFTRDRyaERqWnd3L05MbnNlMnZLdWJSSmwyOWpqM3VUNTB5MlF5VjJJ?=
 =?utf-8?B?cFlpRWVFMDNKRjFCckxGZWpXVjhzZjl0aDlsQ01kc1BmcmJkYjkzNmpvMStT?=
 =?utf-8?B?NjdkZ3ZQOGtMT2xFL2hUbndSdlBLK2dkVXZSUEJMMzE4UlMyUTNGSzBSWlJV?=
 =?utf-8?B?YjQ3WlFyM2tRS2NndW5USlBNVHROdnNORGE5K0ovTGtGOUdqV21FOWdTVlFn?=
 =?utf-8?B?cjZUdk1rT0dPMjJ6TW9yemtiUWZ2eS8wbEF2Ukh2a0RhdHVIYWdkVnVsTG92?=
 =?utf-8?B?MUtlR0YzdzYvVHVjK3lkcVlXYkhrbGNZRllTL2xUUVdQQnl1aXUyWENibVhK?=
 =?utf-8?B?UU5JNm9sckRTWmdsK3ZwUHh0ZTZ4WlhuUm5mNzlScG5ZU3NlNkpPSFlTaUo1?=
 =?utf-8?B?Ky9PcE4xQXE2TUcxNlUyZVhZbWxGcUNDQ0Nza3NySHJlMGUzL0V5SUhkV2p5?=
 =?utf-8?B?dVcvWkhmZ05YcjFEOVB4eEdtV1Vjd2ljUHNFeUdFUzJrMXdFRDUvcXVXWGRF?=
 =?utf-8?B?Njhjd0tSMTFYTlRqOHU0dGxQMDROTVFsODdMNWtvWVAzUmtUOEZ0ZzVFMVBu?=
 =?utf-8?B?aThPaWR3S3VJWWtzWE5oeHJhRlZySmQ2UkZxSVV2ajlMa2tsOGVIZXhVY0FO?=
 =?utf-8?Q?uKnLuOIEqdd/bwtstIywtsU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5eaaa38-b151-42ab-a03d-08d9aa6c67f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 08:21:22.8356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U0721R63uuNMWlD0Xpggm9fGHIK7IYe+73JVKgFxnvXmNsVJ23eNjJ8tTV1bhalYLT5oGQL7vM89W+1cPQ+XaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3983
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/1/2021 5:14 AM, Meng Li wrote:
> When enable the kernel debug config, there is below calltrace detected:
> BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/339
> caller is debug_smp_processor_id+0x20/0x30
> CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard #1
> Hardware name: NXP Layerscape LX2160ARDB (DT)
> Call trace:
>  dump_backtrace+0x0/0x1a0
>  show_stack+0x24/0x30
>  dump_stack+0xf0/0x13c
>  check_preemption_disabled+0x100/0x110
>  debug_smp_processor_id+0x20/0x30
>  dpaa2_caam_enqueue+0x10c/0x25c
>  ......
>  cryptomgr_test+0x38/0x60
>  kthread+0x158/0x164
>  ret_from_fork+0x10/0x38
> According to the comment in commit ac5d15b4519f("crypto: caam/qi2
>  - use affine DPIOs "), because preemption is no longer disabled
> while trying to enqueue an FQID, it might be possible to run the
> enqueue on a different CPU(due to migration, when in process context),
> however this wouldn't be a functionality issue. But there will be
> above calltrace when enable kernel debug config. So, replace this_cpu_ptr
> with raw_cpu_ptr to avoid above call trace.
> 
> Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Thanks,
Horia

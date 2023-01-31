Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA40C636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 15:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjAaPXU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 10:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbjAaPXC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 10:23:02 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ACF49953
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 07:21:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjugOij0m+sRea5jDx8WsOpaz6+W1sRB6b3SG2OW1MOD/h59mi4re3moDdNR6f6V8QLRCVo15chVCfzYbSvHLuDTPlDtTxSst1E87GhLyvc/a5fLaGtTl+lmURz+ArFqId0MeY8B6sAjhhmuNeuKHHF6VRRJD+/uYBVWQxgPwQduiorpC2v1nfKd0Yxr9ict2uh63yj0Rt4J7qyze0nxmmCaJmXyj8flR+Qs+ZRG6+dgvh4lkam2hr8rSypFU2O12M/x6Laz1ink0JwPTxTf6AukREY+E3ba+VVWOwPzoLlHkWV/U9vEM4GPeMjllbQ1oFBHEdcVXWFyqQxx+QKTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2ttiAMWGl8MvQ5BL/b6i+v8qy/dmcXy5OrQfo5agEg=;
 b=Ghqa+DRSxZTYnvI8gevPzcK/VgJ2Kfn43+A0UerDbxLf5MxHb02aKRGN7bE4At7dxF8qELOaU0DgyAy0xjolWJFHncUpoWx/Ll2lNIGqaIEH2hkhJpMruq3vrYRLp7BQYnlIGyvtAiCpYRbZ0092mOUUoZLQL/WL2yhUlt9dzUmX0q0lFg7ei9SeGlWR9R1Ky/c4A9i/L/nUE0L4HKZBL1ZggQtIHGXHVvlf4AerNd2d+hgxYI3t5jwUnKqiiFrwMhF4ODdAhR9ZQReyjjUw5WUsgoYnQTwLC2ptFHR5CtCOCUKKjWMGNEM4OmCePszVIzYZtHyybQjasiGvIM1lNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2ttiAMWGl8MvQ5BL/b6i+v8qy/dmcXy5OrQfo5agEg=;
 b=kVYy4Dkialko0j4MIAmlvTjCkZIwmVA+xLIM7YNOcCDmQh1W3Nz6Zvqxk3QzR8ViRildx56tCN79rznrrDb0Ow+LOw2PrreXuuE/hJ/6L3OA9Gxi4Y9M/PyVFga6RN0LVMkWcuM75jxQd4VxwXamz4KGSdD0pUr6gzBIL8iKrRw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB6006.namprd12.prod.outlook.com (2603:10b6:8:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 15:21:46 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 15:21:46 +0000
Message-ID: <7d6effd4-4109-184c-064e-e606b9dcd200@amd.com>
Date:   Tue, 31 Jan 2023 09:21:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 17/32] crypto: ccp - Use request_complete helpers
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        linux-arm-kernel@axis.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com, Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlat-005vmv-9T@formenos.hmeau.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <E1pMlat-005vmv-9T@formenos.hmeau.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a3ace3d-9db5-4ea0-6256-08db039edd94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VICoYlqMD8pWzdY4ycF49+M4yiv5HiU052qp9Xmrj/8jHFVW2dAyF9/rpWyOAr3xqHXydGJSgefayEmK3R0AYE3m03NWTxIAgO6sK1SlMHP7oUx/YGhXWh9m0JjflrDndRXnJ1kjvpAFJH+fTY2Vd6h57mZNS4AtPt8uMdvHzeiOz1X2s2kWuXw6RYdCRHbgFlLmTIHtdMLSfxtV4VP+AvGzoWnHCLsxeueVQ4GyEHcVIybXUkJoJDNOHWnI1W0jdAj8WJfnf2LmWnINmLYgXj/vuW/pjV7FM6UUJ5BhJH/N69/UFWxrpIy+kzEHstG8YiQ7xu2uFJ6IYzSIM8E0cCJD5p89SULLKwbNdBJzzJ0z1Qtyfv9FdWxJa0TwVMT8s12Gr6mvLnWtGUhkr2Tptvwmq9DDptiZx8uf/09a4miGWbZM35yvBliygrQIrFg2CayDnsMwU5nNu3Nhks8yLihJ5WuJ1iiXvp/9d6dMhWNjbCBVnPtDmunsTjgdrPIz9F4WAPs2/YTHbiU+rQEdf5xrAOPhmkuKQCnh44iHJKqWd+ghPVJyzmA5O1rbCMGJPpg9tnxuHGnjkbTTftTgGSjh5x4NqdA2XClPCG704LDL5cUEurkhLHTfB/e13KIubGm6ock80TPqlB0DD8nG8huU6C+wey8vJK1mR9/iyAtmnLmHiqSgt5STTXpoe0tTZvWKDDfWqsPmUAd2WekuEZgjF1wN8i2nnJHTiwF1gzzCJaXvluuByMLCZq8WDlgB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199018)(2906002)(316002)(26005)(6506007)(921005)(6512007)(186003)(53546011)(5660300002)(7416002)(36756003)(110136005)(2616005)(6666004)(38100700002)(6486002)(31696002)(31686004)(83380400001)(86362001)(478600001)(66476007)(66556008)(8676002)(8936002)(66946007)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SStLS2FYcm1wM1dvL2IyNjRIZE1ZNVhGUWpuOWFLSlJOMlluWC9iSkprLzZs?=
 =?utf-8?B?K1ppSVJiNE5kZG1CUUd3ZjZTdzkwSGVsY0xpN1V0dkd0N0c1a2NscWVWYXlB?=
 =?utf-8?B?ZldRS1FvMzJGVEVSa255TXBHdGRFaU1jSWNMOHBRN0pMODdieVZIb28vako0?=
 =?utf-8?B?eXRBbGVKOWlDZ2hMTDhEaXJUUHFYa1d3Q1JDc2V6T01SMWMxWkxDRWpvbjBq?=
 =?utf-8?B?SmJ2TVQwQmsrdkp3L1g3M2VHK1liUlVLMDM0ZGVGeTZhZTZPK25nNy9TSGti?=
 =?utf-8?B?UUxzVWRkWEMvN0ZXWnBVMXh5aG9tVGh6N2xvamQ4UW0zWWs2R0tvekN0N1l3?=
 =?utf-8?B?WmtGWHlaYzRNTU01cEtsWWhIK2NLRno3QWd3QmRoTzRJanBUU3pDQmF1QzMw?=
 =?utf-8?B?K2VwMWd3VGRSc3crbHJmelRRVCsyZ3ZrSk03ZlhYK1lpWFlOYWdZV0FjZGt5?=
 =?utf-8?B?bVpEVFZOczNQVy9ScWxLMWE5V2huaTZaWm5VMFo0U1R3UmFrVnVCRU1KUk4v?=
 =?utf-8?B?d0NTSDU5Zi9xaFkwRXhlOWN0Ynd4NzVHNmJDaTh6bXJOaVNxRCtyTUpsZmdj?=
 =?utf-8?B?aXppbG81NE1jN0xpTkJ4WjRzR20vdmtzYk9zc2JxankwRjBGNGFLMFVTN3h2?=
 =?utf-8?B?M2pUWXhYQmNlQkd6eWFVUVZ5SmxKc1YwZXUrVEdXMUJqeEpFWnV0RWZScjVK?=
 =?utf-8?B?YjUrNlRPS3FFZ25VVmgzcWRvQnpURG9UME53OWJpSnpRNm5qcSt0LzdMejMz?=
 =?utf-8?B?V3BTRVBZRHJjS0VIYVJFaVpnR0FUSFkrTmlRMWp0UzZGNGpTV2JtY3M5WU14?=
 =?utf-8?B?OVlCM3pCVTJPZ1A4RE50am1lTXNxOUNpaHFEclRUZ1haRDc4R1VXcXVXcW5P?=
 =?utf-8?B?NFVOcmtkNlFUUnFwaGFkcFdGMCsxSDI3NGNaVzJibzZBYllJWVJUUmNGdjVk?=
 =?utf-8?B?eTFsbFNqT09rWTRhSXhQdHVBUjJPZHl4eFh6OXFZVTFIMlRkZmtiUGVnRmdO?=
 =?utf-8?B?YkJKQUhCMVRSTVhWSnJXNzJFaFN0Q3l0OVFoVnFXVjAxQXF2cWxSR0lBMGRz?=
 =?utf-8?B?dDZIa202V2Z6anR5UWFHSGloNEp3UW0rT2I1VTZBN2ZOc3lRT0JEdllMRERo?=
 =?utf-8?B?RGtsOW5PSWZGK3lwVkRQR2dXMnVQenJVUHpjQWVBU24ydGhQNXFsRW80djdX?=
 =?utf-8?B?dkNScFNDVkR6WG4wS0lLc0ltdHZlWDAvQzFuT2czVVM4MTVJOHRWK3VjYXN2?=
 =?utf-8?B?QXB2TUJCRmVkQi9DYXoydXE0T3dCM2JKclVPSXJSMW1IcEprQWt5ZjdVSkxK?=
 =?utf-8?B?UTUrcmthK2hyZktlZlV2WnlyVmpMdUY5MTEvWkxzdU01K21lV1N2VkZFUGtz?=
 =?utf-8?B?dW9GVVMxQjd0NXdmUFcwM0kvZ3ZSbzZ6OGxaOExvaU0xSDhwYjhpVERKdHM0?=
 =?utf-8?B?MWRnWU8xTHNpMTRXalZFUEJKTzA5aFo3cEZGV2k3dUFKR2crOGlRb2VnLyty?=
 =?utf-8?B?eEVIRStmU1JGcDRpaEQvZE5uTkRrNDlrd041Z3U3SHlMNUFlOG1UZ1Q4cWpW?=
 =?utf-8?B?cDNRSXVIZllCK0hrZ3prZy9jaUUxQnlrQnNocEFnOThVenFzUjdpeXhmczBq?=
 =?utf-8?B?L1RUSnJmTkpuNllQUTJ5UUkrZGlUM3hpUy9td1UvRzY1dzhHYnNMeEw0REIr?=
 =?utf-8?B?TGhlc0xOQW5RNkRYMHZaZmgyWFduaGlUNndqQjBZUmpKSllkRzJaaHQ1TnlC?=
 =?utf-8?B?N1NNdFNtd0xmSmRRTlI5NDRnajV0dmNxb09iZ2NCMGM0L25SRGxlQ3VnRFI0?=
 =?utf-8?B?OXF1MWRyNk1pRzhXcXpSZnhMNmN5Q3JmMVFrRXVGNmVwQnhoYzJ1U0hEZTZq?=
 =?utf-8?B?Q09zZXBSaHh1QVR2L2gvZGo1UmI2TmloMURHOTFUVVRwK1FBN2huNUQvZ0dB?=
 =?utf-8?B?Tk9ndUlXdStJYVdvOS95VnR3NmtQOXhlOUJOY1ZXSHhjVjg3cnBBMUF1ZTI3?=
 =?utf-8?B?UVp3aDBtNXUwVTkvRU41QWE1MWRrNnp6bG52VVljaFlCRGZ0VUtwelArbFFh?=
 =?utf-8?B?c3dTM2ZjaURNSk05aFZacVZydnU1ajBpcVdQUVpnbXRneG0xVWIxWEVrOGZs?=
 =?utf-8?Q?R+KLOom27ik2/KomAjGidIjv9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3ace3d-9db5-4ea0-6256-08db039edd94
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 15:21:46.1960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJfznaO+OMa9GZ0XsHUoRhrop6uPlqYgMpYM/LSM1+aLFuvu+xQKWhEMuxYf8UJjvZBe/uqdvAD2QRIU0zA+bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6006
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/31/23 02:02, Herbert Xu wrote:
> Use the request_complete helpers instead of calling the completion
> function directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> 
>   drivers/crypto/ccp/ccp-crypto-main.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
> index 73442a382f68..ecd58b38c46e 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -146,7 +146,7 @@ static void ccp_crypto_complete(void *data, int err)
>   		/* Only propagate the -EINPROGRESS if necessary */
>   		if (crypto_cmd->ret == -EBUSY) {
>   			crypto_cmd->ret = -EINPROGRESS;
> -			req->complete(req, -EINPROGRESS);
> +			crypto_request_complete(req, -EINPROGRESS);
>   		}
>   
>   		return;
> @@ -159,18 +159,18 @@ static void ccp_crypto_complete(void *data, int err)
>   	held = ccp_crypto_cmd_complete(crypto_cmd, &backlog);
>   	if (backlog) {
>   		backlog->ret = -EINPROGRESS;
> -		backlog->req->complete(backlog->req, -EINPROGRESS);
> +		crypto_request_complete(backlog->req, -EINPROGRESS);
>   	}
>   
>   	/* Transition the state from -EBUSY to -EINPROGRESS first */
>   	if (crypto_cmd->ret == -EBUSY)
> -		req->complete(req, -EINPROGRESS);
> +		crypto_request_complete(req, -EINPROGRESS);
>   
>   	/* Completion callbacks */
>   	ret = err;
>   	if (ctx->complete)
>   		ret = ctx->complete(req, ret);
> -	req->complete(req, ret);
> +	crypto_request_complete(req, ret);
>   
>   	/* Submit the next cmd */
>   	while (held) {
> @@ -186,12 +186,12 @@ static void ccp_crypto_complete(void *data, int err)
>   		ctx = crypto_tfm_ctx_dma(held->req->tfm);
>   		if (ctx->complete)
>   			ret = ctx->complete(held->req, ret);
> -		held->req->complete(held->req, ret);
> +		crypto_request_complete(held->req, ret);
>   
>   		next = ccp_crypto_cmd_complete(held, &backlog);
>   		if (backlog) {
>   			backlog->ret = -EINPROGRESS;
> -			backlog->req->complete(backlog->req, -EINPROGRESS);
> +			crypto_request_complete(backlog->req, -EINPROGRESS);
>   		}
>   
>   		kfree(held);

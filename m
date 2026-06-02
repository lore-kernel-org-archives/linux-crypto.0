Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6372773F7;
	Tue,  2 Jun 2026 20:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780431859; cv=fail; b=FNK8w9Smxaqqmct3zfKFYiL4uvLexzNiB0jD3pt795QOqT0hxvjuMf2fCU+m9ySuF23Ixx+r7OptyQ5e2Iy/H+g/FoEFuHKUWSV5wrNb458UUBSow9jWVuR5EABurVHPUYyj6vX3Be/+Py5Jl8pWsunw4AHi34hIWj5LrQem4jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780431859; c=relaxed/simple;
	bh=+wjSIAGoT/tsIyIZBqFOuETxrtMd8wUVAS+Vsvv793I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZSFs9taezwE/zNMnJnkPs8EVX5o+eJ8cUef7oEc71/ZmRYO2O/esqamiK+wxLamFejEQpHwpxZouTds7WF5KufWYd1eyKk7tIE2nXOwmEzxyO/c5c/WRI+8hSA7WnWjMQ+l8gAu/0TzfIF45Ltn1Hpq7IDbyUBAU5trYbzT+YnA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Tt1+kQfs; arc=fail smtp.client-ip=52.101.53.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tt1+kQfs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JlD4RrtmNeoVi+sptb4/tGeBuZPZxQxaegIJIgl6J16RM3vyJeN4gaLxuo1I/XK9ud/z3yDtRny6xp8Ky6SKULwinWeBsBHINaUEfKqsqoIXaBeDdXNC0kcW//kPWuP5hwqHgjwDWO442rHJ+5B4QvY9f85hnijyRwa/BpvQE0eItoN3IxNlTE3L5Y0dbiiHZt8xFuMAYOg/gHyYeCwStgVkdy8vmMGiEjVDoePdvoCKwpDV63sbAND/8aLx5LgKg4CLPQXtO1aY8NytPe1zICCYJsgbDjX+q69JrjWhVE5JQ6T0viSF704mBweJtbZqutOvso3+Hvk17bgKnQj2kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LZj8MMpTgrJ1JOzId7TZWJQWl0iQ8tGrQU6FQ+mJfU=;
 b=IQbV5yGmAqsZd2kmG3Su2URiasVDv/pBXwmK7GewrVALYHyrQ0KtLvsoOe37OdtkahcYzTwmDCKN7AMl6RNqP4hYS6dSsFQq5/9vikEkWxRaE4JaFKEGe2XJ7U0s89V5/S1KmQVZ5bsuHv55P2F+xGAFNHMdTL3Jo11sITxy2Z4/ekD6tIACs9Zjx4k8oQazhJHW5i49Pg6+OuolU8ew+yuD1VOq0eQMj+3Raj4HWRxqiPNXLh7TFjQ554fT/fE/Hd9IdpIQNdduZ8SjxPslczKvOwDQFGqIXZYJqTf2Q+C977DAFGU1N5+Tc42VvBn+GxD/pfqwh4JWFp+MiPbmLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LZj8MMpTgrJ1JOzId7TZWJQWl0iQ8tGrQU6FQ+mJfU=;
 b=Tt1+kQfslBP5pCugmry1czgLiYH3JLrsH4tQjm88Wzezfl+UkIObo8bwHAJC7KfAMvku9vE89PsMcabxUigmT40dn2MlCui8mCV7QgMycUVZZ9LHOTypYqk/LT01q9aheRCN4wrypy4iWNf4rg9PqHZz6zml86YEq00S0QnzzqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7954.namprd12.prod.outlook.com (2603:10b6:806:344::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:24:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%6]) with mapi id 15.21.0092.006; Tue, 2 Jun 2026
 20:24:10 +0000
Message-ID: <e94278a8-52df-4758-98fc-e6d7e5b55491@amd.com>
Date: Tue, 2 Jun 2026 15:24:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: use two-argument strscpy where destination size
 is known
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, John Allen <john.allen@amd.com>,
 Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Srujana Challa <schalla@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 qat-linux@intel.com
References: <20260525103038.825690-4-thorsten.blum@linux.dev>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260525103038.825690-4-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7954:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8de190-7e3c-424e-09be-08dec0e4e673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7KYh3pU1U9uJgsGZ0YOp7f9NBkibUpq0VmbwmZGH61FB2441RX+vhYOqJEGji2qPnTGylj2t8ccO80nMyBY4Y47RKQUgEtsGTvJDTin+D/fF/q3mXNBW8+UXWy/XGJipe4FIT1lFnSb4RIWDiGxziEZkdK8nY5YLEPSrzvlx7ss/XFzsGiJryi1u7ebhTpUQCMMEzUiPYiSOu36b5Fo3q7qeX4qzx65fdcwQZXXJMxRc5WPWXoNyZ/OYS+bCRVOsGcZZxrH/AsyXgqLwFKOpDZKKSxCUcsCOxsDsVjFZ/EctDQ5cNq4Arqbxh9Th6M/8xqdkE0tVThF5+bD+8LusuihPJPEekar0JmcD0W6Gxe9JFzaDrr2BV7Rj/U2VqrFaXjwdEkMtF177QUduVtI7eLFz5GYkAZFA3DqStS1r5aZYvqYmhkfkwxJ3LqBIoh+WrwK5x5W+JAB2NSQNBgXa2SEF3kjIAmmtR19g28d7Wz4PMY7MqaaKKYOXAGzZdURG7NGjXcZqWrWEdO0CNBOGJummnAJT1ljZfLpbFzi8TyBJGG1uutPUXf5t8aaoqUZC2Q7LnoTt9prdK6T43u61x9KBj0usWJqBIzTo9gzOvznenUeXyXHhStaIE7aAzXThb6laytSSsYMlt7UuJ37THZ/BZ+4q+hEA2NamOFk0EbndIs8V4KYwVTt4GqJfCZKi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXhrMy9DMUxzekN4MzNMMnpUVldwRVJxSHZtWGVWR3FTa2RFaDBoZXAxN0o2?=
 =?utf-8?B?MFFIblFRejBRY3c4U2drMGtBbnBiRFpmOGd1NEVsQXBmRkhKR1UwaVpCNUZO?=
 =?utf-8?B?eEM3cHFnWVhURVE0VjhuQlA5bC9xV21tTGFBSjNBNENZeGZvamFFdjgzb3py?=
 =?utf-8?B?MEV4YTNBLytWYzI3R1BpK1Q4eDljL3lRbkZ2emo3emRmT1IrcHZjZ0M4SU0w?=
 =?utf-8?B?QStheXZleWpOQkhJWjFRSXVGTjVqdlZBbFNEcHc2Wm85c1k1UlA3N1UzV3Fm?=
 =?utf-8?B?ZXhmWTIvbml3cTNlRlN4VUhhVGpaMXd1RUp1d2ZsbWdBdWxQMkFtYldEZGdp?=
 =?utf-8?B?Q3J6Zm9tSitwdTZSUXZOTjU0N3BnbC9UbzkzaUtDek01WWhGZHVaK3ZoanU1?=
 =?utf-8?B?ZnoxVXlwSHVoZ2psT1Y4ckdwOE1kWStIVXZCYnlVRC9GeEdEQlJMOWE3Z1Ev?=
 =?utf-8?B?Wjc0bCtsOVZ2MVBqWnBrdkw1Ym9ZS25JTEtEeCsvanROSWJzS21VNWhOcXRT?=
 =?utf-8?B?WnRKaFQ2YloxaUdzcUxEaEJrRmlkYkNqNFM0YTFyV0lnOHpEU1l6Z1Riekxw?=
 =?utf-8?B?SzdUb3NwUmtyS3VBWjFQcFMzM2xtSXcxV0VRNk83TzExZ1RZN3JDdEUydHVG?=
 =?utf-8?B?UkYvUEpKeTB5S21SQ2k4cjltRjB2WmVvcDRHWnQ1azVKM1ZFUG5XZXZGT21Y?=
 =?utf-8?B?aXpEdjA2ZmN2WnpVNUxhRTVFWHlSL1pobG5Wbyt1RnBoWHhYWEY5M1pCdE0y?=
 =?utf-8?B?aFVwdkxaNTlFdDRWVFF6T2VCTUNJK3pwRUVCdnNXQ1B3Q1J4RElkVHNIbWpE?=
 =?utf-8?B?NXJpZzgzYXA5OTFzSUtuZnFtOEpQa3RqNDBwQ1FHa0pYUFRuZmN2bjhKKzli?=
 =?utf-8?B?aXlHRWl1Q29NWTQxRHVpYWRIdXVxM2l6ZzhFY05saFFSUmxqcW9JaHltR2xS?=
 =?utf-8?B?MG1sT0ZlYUFId2NmTktjOFhwNU4rU21VQTgrSk41WmVWNFc3S1dHQVQzaS9B?=
 =?utf-8?B?SzU4REg0QjZ0dXJuWm5BNHU0eW5YUGNqdnllYXp0R2JwS3QzQ293YmYwOS96?=
 =?utf-8?B?ZGxrallZUVpnejJ5d0t2anpTd1FZMkhXb3EyVlVRRWJSMHoyWlpIcGZXOFBj?=
 =?utf-8?B?N2xVUmpHazBILzJYV2pVVkN2KzYxVThVcjh3YWMyMkx6ZkVkMVhJTFNPU09G?=
 =?utf-8?B?T3REcExOMEE4RGErOWl1VHpndzFNRXFZV0YxdkNIdmFSQjZEaENxeFhRN0V1?=
 =?utf-8?B?U0RCdklLMU11NXZ3cHJhcEpMVXcwVE41VGpkbDBMVUxnaHVMTGs2c21aZzBu?=
 =?utf-8?B?Mi9RbmUzSnpwM1ZQNmlMUnZDMVdtMnJ4YW5TR081dzFlNDJQQzZhUjhHODQ4?=
 =?utf-8?B?Yzhmdm1LTXJyS3E3S1ZhbzJFamNlMzNPMlRwdWJINnNxRmpaSkE2QlB4bC9w?=
 =?utf-8?B?ZUhsY2pIN3orRm5WUncrOTVad2UyTnBjOXBkajluZmNrcERwUW1pdUxrT25V?=
 =?utf-8?B?S1FjSkFzRU56T0dGeEdPUTEzYStsMzcreDd2RUsyVStFZ2pNT25aUkZ6Z2Mx?=
 =?utf-8?B?dGM0WkpiN2hyZmRiY2I4YlYyUGJvdTJ6emR0dHNOVW85dm1aVWxmUXQzbWVq?=
 =?utf-8?B?azNNblI4NWkwUTc3UG9QODNJbGMyWW1OOTZUQitPM2x3SGRPOFFWb05Bdlgy?=
 =?utf-8?B?bjNJK1BOVFY2TFhXWXQ3U202a0k0MWNBbEdXcHB4NlRST3N1aVNFYVE0YXla?=
 =?utf-8?B?TFYxNi9KNG5uS3ppWWlCa05JWitZaTlJSUVHZDVQTnFSekZIQ1RQZHYwL29G?=
 =?utf-8?B?QW42LzNERGFmTDV4MHhVZ3dnREdLY0xNSHpXM2szdEhYaWQ5RjlZOGxxRjlm?=
 =?utf-8?B?cms5T3NyOU9XMlJGY0c3VEd4SWsybW9CdDcva0dnaFRmMDI0YkVDQ3dkVTJy?=
 =?utf-8?B?dlZyY1cxR3VFUkJSamltWTVqdVAwUTQzSEJvYTh6eTBZRU4wVC9yMFROT3Bn?=
 =?utf-8?B?a1RDWlRMZm43V3RXWlRsemx2bFExWW9JT1BQdUNNOUF5Q2ZkTDR6ZWVsT0V5?=
 =?utf-8?B?UnB6WUo3NjdxS29NWHhKVGMzR1NrL0xnZnNSSTRRL3NPbVJBREQ4Z2JlRDZI?=
 =?utf-8?B?NUc3VDV3L2NIeStDTjBKRU9NdkRpdjh0YjlBZDc5dWxETHhlak55Ny9UNlI5?=
 =?utf-8?B?Y2xjc3FNV3diR0dLMGZVbzh3cXhPT1ByekVEaCtiNjJJZEt0OXdpdk1sV1Q1?=
 =?utf-8?B?VEx1QitPeDBtNHFGVWZOT3U2bjhwaXBQQ1pESmoxdXIrWmU2czJSTzluVmFj?=
 =?utf-8?B?QW5iTWREM0J5SUFEeTc1SXZpTE10d2V4dG5ldUlvR05jR29Tek1qUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8de190-7e3c-424e-09be-08dec0e4e673
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:24:10.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9T6H3ShaCwWMfkwOlKyJDccyvlN6f/BHvtYrbK5JIYTLe+5Y5UQC5Bx45y+R5Ro0LEbYSkEZfAor7trPgc/Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7954

On 5/25/26 05:30, Thorsten Blum wrote:
> To simplify the code, drop explicit and hard-coded size arguments from
> strscpy() where the destination buffer has a fixed size and strscpy()
> can automatically determine it using sizeof().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

For the CCP driver changes:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

But I noticed that there are a few other places in the driver that I think
can be changed to use the two argument strscpy - essentially the strscpy's
that involve "cra_name" and "cra_driver_name" in
drivers/crypto/ccp/{ccp-crypto-aes-galois.c,ccp-crypto-aes-xts.c,ccp-crypto-aes.c,ccp-crypto-des3.c,ccp-crypto-rsa.c,ccp-crypto-sha.c}.

> ---
>  crypto/api.c                                             | 2 +-
>  crypto/crypto_user.c                                     | 9 ++++-----
>  crypto/hctr2.c                                           | 3 +--
>  crypto/lrw.c                                             | 2 +-
>  crypto/lskcipher.c                                       | 3 +--
>  crypto/xts.c                                             | 3 ++-
>  drivers/crypto/cavium/nitrox/nitrox_hal.c                | 3 ++-
>  drivers/crypto/ccp/ccp-crypto-sha.c                      | 2 +-
>  drivers/crypto/hisilicon/qm.c                            | 5 +----
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c            | 7 ++++---
>  drivers/crypto/intel/qat/qat_common/adf_cfg_services.c   | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c        | 3 ++-
>  drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c     | 3 ++-
>  .../crypto/intel/qat/qat_common/adf_transport_debug.c    | 3 ++-
>  drivers/crypto/intel/qat/qat_common/qat_compression.c    | 3 ++-
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c        | 6 +++---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c      | 4 ++--
>  17 files changed, 32 insertions(+), 31 deletions(-)
> 
> diff --git a/crypto/api.c b/crypto/api.c
> index 74e17d5049c9..040b7a965c2f 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -116,7 +116,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
>  	larval->alg.cra_priority = -1;
>  	larval->alg.cra_destroy = crypto_larval_destroy;
>  
> -	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
> +	strscpy(larval->alg.cra_name, name);
>  	init_completion(&larval->completion);
>  
>  	return larval;
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index e8b6ae75f31f..d3ccb507153b 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -11,6 +11,7 @@
>  #include <linux/cryptouser.h>
>  #include <linux/sched.h>
>  #include <linux/security.h>
> +#include <linux/string.h>
>  #include <net/netlink.h>
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
> @@ -87,11 +88,9 @@ static int crypto_report_one(struct crypto_alg *alg,
>  {
>  	memset(ualg, 0, sizeof(*ualg));
>  
> -	strscpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
> -	strscpy(ualg->cru_driver_name, alg->cra_driver_name,
> -		sizeof(ualg->cru_driver_name));
> -	strscpy(ualg->cru_module_name, module_name(alg->cra_module),
> -		sizeof(ualg->cru_module_name));
> +	strscpy(ualg->cru_name, alg->cra_name);
> +	strscpy(ualg->cru_driver_name, alg->cra_driver_name);
> +	strscpy(ualg->cru_module_name, module_name(alg->cra_module));
>  
>  	ualg->cru_type = 0;
>  	ualg->cru_mask = 0;
> diff --git a/crypto/hctr2.c b/crypto/hctr2.c
> index ad5edf9366ac..cfc2343bcc1c 100644
> --- a/crypto/hctr2.c
> +++ b/crypto/hctr2.c
> @@ -354,8 +354,7 @@ static int hctr2_create_common(struct crypto_template *tmpl, struct rtattr **tb,
>  	err = -EINVAL;
>  	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
>  		goto err_free_inst;
> -	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5,
> -		      sizeof(blockcipher_name));
> +	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5);
>  	if (len < 1)
>  		goto err_free_inst;
>  	if (blockcipher_name[len - 1] != ')')
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index aa31ab03a597..e306e85d7ced 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -359,7 +359,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	if (!memcmp(cipher_name, "ecb(", 4)) {
>  		int len;
>  
> -		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> +		len = strscpy(ecb_name, cipher_name + 4);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> index e4328df6e26c..d7ec215e2b3a 100644
> --- a/crypto/lskcipher.c
> +++ b/crypto/lskcipher.c
> @@ -528,8 +528,7 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
>  		int len;
>  
>  		err = -EINVAL;
> -		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4],
> -			      sizeof(ecb_name));
> +		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4]);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/crypto/xts.c b/crypto/xts.c
> index ad97c8091582..1dc948745444 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  
>  #include <crypto/xts.h>
>  #include <crypto/b128ops.h>
> @@ -400,7 +401,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	if (!memcmp(cipher_name, "ecb(", 4)) {
>  		int len;
>  
> -		len = strscpy(name, cipher_name + 4, sizeof(name));
> +		len = strscpy(name, cipher_name + 4);
>  		if (len < 2)
>  			goto err_free_inst;
>  
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
> index 1b5abdb6cc5e..e36c1741bb78 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/delay.h>
> +#include <linux/string.h>
>  
>  #include "nitrox_dev.h"
>  #include "nitrox_csr.h"
> @@ -647,7 +648,7 @@ void nitrox_get_hwinfo(struct nitrox_device *ndev)
>  		 ndev->hw.revision_id);
>  
>  	/* copy partname */
> -	strscpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
> +	strscpy(ndev->hw.partname, name);
>  }
>  
>  void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
> diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
> index 85058a89f35b..ff9bb253dbb2 100644
> --- a/drivers/crypto/ccp/ccp-crypto-sha.c
> +++ b/drivers/crypto/ccp/ccp-crypto-sha.c
> @@ -426,7 +426,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
>  	*ccp_alg = *base_alg;
>  	INIT_LIST_HEAD(&ccp_alg->entry);
>  
> -	strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
> +	strscpy(ccp_alg->child_alg, def->name);
>  
>  	alg = &ccp_alg->alg;
>  	alg->setkey = ccp_sha_setkey;
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 3ca47e2a9719..0c8cc0d7a82a 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -2870,11 +2870,8 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
>  		.flags = UACCE_DEV_SVA,
>  		.ops = &uacce_qm_ops,
>  	};
> -	int ret;
>  
> -	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
> -		      sizeof(interface.name));
> -	if (ret < 0)
> +	if (strscpy(interface.name, dev_driver_string(&pdev->dev)) < 0)
>  		return -ENAMETOOLONG;
>  
>  	uacce = uacce_alloc(&pdev->dev, &interface);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> index c202209f17d5..24c2618af68d 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2014 - 2020 Intel Corporation */
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/list.h>
>  #include <linux/seq_file.h>
>  #include "adf_accel_devices.h"
> @@ -294,13 +295,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
>  		return -ENOMEM;
>  
>  	INIT_LIST_HEAD(&key_val->list);
> -	strscpy(key_val->key, key, sizeof(key_val->key));
> +	strscpy(key_val->key, key);
>  
>  	if (type == ADF_DEC) {
>  		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
>  			 "%ld", (*((long *)val)));
>  	} else if (type == ADF_STR) {
> -		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
> +		strscpy(key_val->val, (char *)val);
>  	} else if (type == ADF_HEX) {
>  		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
>  			 "0x%lx", (unsigned long)val);
> @@ -360,7 +361,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
>  	if (!sec)
>  		return -ENOMEM;
>  
> -	strscpy(sec->name, name, sizeof(sec->name));
> +	strscpy(sec->name, name);
>  	INIT_LIST_HEAD(&sec->param_head);
>  	down_write(&cfg->lock);
>  	list_add_tail(&sec->list, &cfg->sec_list);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> index 7d00bcb41ce7..11cba347d12d 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
> @@ -60,7 +60,7 @@ static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const cha
>  	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
>  		return -EINVAL;
>  
> -	strscpy(services, buf, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
> +	strscpy(services, buf);
>  	substr = services;
>  
>  	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> index c2e6f0cb7480..ae10b91da5ba 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
> @@ -5,6 +5,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/fs.h>
>  #include <linux/bitops.h>
>  #include <linux/pci.h>
> @@ -350,7 +351,7 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
>  	dev_info.num_logical_accel = hw_data->num_logical_accel;
>  	dev_info.banks_per_accel = hw_data->num_banks
>  					/ hw_data->num_logical_accel;
> -	strscpy(dev_info.name, hw_data->dev_class->name, sizeof(dev_info.name));
> +	strscpy(dev_info.name, hw_data->dev_class->name);
>  	dev_info.instance_id = hw_data->instance_id;
>  	dev_info.type = hw_data->dev_class->type;
>  	dev_info.bus = accel_to_pci_dev(accel_dev)->bus->number;
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> index f9017e03ec0f..32aeb795cc03 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2024 Intel Corporation */
>  
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/types.h>
>  #include "adf_mstate_mgr.h"
>  
> @@ -158,7 +159,7 @@ static struct adf_mstate_sect_h *adf_mstate_sect_add_header(struct adf_mstate_mg
>  		return NULL;
>  	}
>  
> -	strscpy(sect->id, id, sizeof(sect->id));
> +	strscpy(sect->id, id);
>  	sect->size = 0;
>  	sect->sub_sects = 0;
>  	mgr->state += sizeof(*sect);
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> index a8f853516a3f..fc5d88a2bb17 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2014 - 2020 Intel Corporation */
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include <linux/seq_file.h>
>  #include "adf_accel_devices.h"
>  #include "adf_transport_internal.h"
> @@ -103,7 +104,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
>  	if (!ring_debug)
>  		return -ENOMEM;
>  
> -	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
> +	strscpy(ring_debug->ring_name, name);
>  	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
>  		 ring->ring_number);
>  
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
> index 1424d7a9bcd3..8129ad0c32d8 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 2022 Intel Corporation */
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/string.h>
>  #include "adf_accel_devices.h"
>  #include "adf_common_drv.h"
>  #include "adf_transport.h"
> @@ -144,7 +145,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
>  	int i;
>  
>  	INIT_LIST_HEAD(&accel_dev->compression_list);
> -	strscpy(key, ADF_NUM_DC, sizeof(key));
> +	strscpy(key, ADF_NUM_DC);
>  	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> index e0f38d32bc93..5c3636080757 100644
> --- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
> @@ -99,7 +99,7 @@ static int dev_supports_eng_type(struct otx_cpt_eng_grps *eng_grps,
>  static void set_ucode_filename(struct otx_cpt_ucode *ucode,
>  			       const char *filename)
>  {
> -	strscpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
> +	strscpy(ucode->filename, filename);
>  }
>  
>  static char *get_eng_type_str(int eng_type)
> @@ -140,7 +140,7 @@ static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
>  	u32 i, val = 0;
>  	u8 nn;
>  
> -	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
> +	strscpy(tmp_ver_str, ucode_hdr->ver_str);
>  	for (i = 0; i < strlen(tmp_ver_str); i++)
>  		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
>  
> @@ -1331,7 +1331,7 @@ static ssize_t ucode_load_store(struct device *dev,
>  
>  	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
>  	err_msg = "Invalid engine group format";
> -	strscpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
> +	strscpy(tmp_buf, buf);
>  	start = tmp_buf;
>  
>  	has_se = has_ie = has_ae = false;
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> index 9b0887d7e62c..465f00e74623 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
> @@ -74,7 +74,7 @@ static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
>  static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
>  			       const char *filename)
>  {
> -	strscpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
> +	strscpy(ucode->filename, filename);
>  }
>  
>  static char *get_eng_type_str(int eng_type)
> @@ -130,7 +130,7 @@ static int get_ucode_type(struct device *dev,
>  	int i, val = 0;
>  	u8 nn;
>  
> -	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
> +	strscpy(tmp_ver_str, ucode_hdr->ver_str);
>  	for (i = 0; i < strlen(tmp_ver_str); i++)
>  		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
>  


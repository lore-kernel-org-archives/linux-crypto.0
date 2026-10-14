Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011065.outbound.protection.outlook.com [52.101.52.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3C52E050
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985570; cv=fail; b=a1feAeRMDM6yz0q0Jmrz5YqsKwStD9UyqhwDV0eckIFE5TOVc2Z5OSmPlmUliTemapV0Go1DgBdzIEP2DYt0gDLJ9t/WbB6klkggw0bF5ry150Nr9oRQ3gULHDhgClCVmXv63o0QU6YDrPCkaDGvUvWgxJ4yZFlUQH99MUpmkhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985570; c=relaxed/simple;
	bh=oF0BABzL1dTUcZUS81q777JK8J8EYVmcgLfrNtCmTfA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gpivr90ra/VBXkog5zib2Vp3sWwFeXy2yJ1NjKGxtZmDOS4YzwEeXrG7KjcTF4BNqB6+SyyjCU5hFBY4aAry3ya9GHFw3WWNpjgDKB09Ui3NxdyVYIAbFKji4wfW5wkZHhK0Mz10d31syJCWxfEvWTVrcf3dDZd8Lae/y3MFnUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v85P9RX+; arc=fail smtp.client-ip=52.101.52.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v85P9RX+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PaIf8JBtwpYCeYaKmrVw/6k81mZS7ZptWahXfDhsrTA8Jvvs+vrdfC29VDUhNm/iptGHqr7TiD1WRRHjWGZ6pPrHzq5VhSfR7pI2QDOSnp+h6AaQ7bOPDXOrr7Sy8FVEsoOf5RV3UsLML4lVQT4bwAC0R/6c0Y9w4d89wGVVSL+tr+TLlfFs7LX1gddFpw25hxPnGJlwyesFWHJT+7Fdfoi+CBVB2IdHTuBxjxThS/fhdv4KgqOvpsy8rn5gV2DIXLmCw9pg9U3ajEoDEH0tnfBPfyU5WU8GiYhkrNsSTi1o1zfv4xOE4uM/ltcIQJYmb/hj+F8tpUI+J8BsyPNliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mrq20QUKt3CkhJrFFlZ1Z/lqNHAmt74gvDFaJj0ES4=;
 b=QQrY/4n3mQT64s5jDkFQsRCuosiuoGVvr9+u84Iw1w3Kj4B3YmIUwhcZW00obI9B2q8fRqkHnb/fUV9Beo6uctrw6LKRDhXiwKlVB7ZHVbNEO6eOLRsxL8/rjjmCayYr8oolQ/YGZfXZ/LJCS3nLwrin1ATKXMEOBhs6PTY2bDOYWhR6lZgB12iEVh8D5Ru9Y9a6WAHnokMAZTXdL+qc2bwG2uiFrIQAhongFz243x6tU9tb9Qh9C8NoyugU0p7GgcD/zzCuchnbwrGzM/C1rjuL6FTGiUM4u4SyPDF1d69KsF8cGWKmNLkzDfOWWNr8cy/rp4tPNTVnG0CClW76Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mrq20QUKt3CkhJrFFlZ1Z/lqNHAmt74gvDFaJj0ES4=;
 b=v85P9RX+ejTPye1QOtmxbfbWUxldcVAc+Gk/2W4fF2m8BGNaP7eFZBvobJQ0QjP5bUtKzwyeDuOMqwlooEEiF/ar8MdeLaOFkQf3LYt+M39uQGMDYNQTpnx/ZVGmP6y+juPxHSYKARkIxvwlyG1m8pqOesrLLSQ02geDzF7S+kY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by BL3PR12MB6425.namprd12.prod.outlook.com (2603:10b6:208:3b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 13:45:54 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 13:45:51 +0000
Message-ID: <e33122fd-4c55-412f-8780-9aea08ac641e@amd.com>
Date: Wed, 14 Oct 2026 08:45:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] crypto: ccp - Check SNP initialization state after
 copying user inputs
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261014132145.1726322-1-michael.roth@amd.com>
 <20261014132145.1726322-3-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261014132145.1726322-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0011.namprd14.prod.outlook.com
 (2603:10b6:610:60::21) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|BL3PR12MB6425:EE_
X-MS-Office365-Filtering-Correlation-Id: f8414295-8fa2-4fba-e979-08df29f975e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|18002099003|22082099003|10067099003|3023799007|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	dxJ6bYvBjrtjhUDZIRHZUPrQNUgjMh6oe18XHIeOvVor6jdcWHNjEWSJu/kg0YoZJPPVyLQ3ihQo5SwQjFf7D3XjcDs88KEkTqxePGMm6xt0vo2+etXhiAgsY0xB9ZVJpwoJMpHLCdEbqwrwogzNI+TkXgfNrlRmkgnHQGaug/zQkVhMEINTMTJND7W3wtxb01uoG+5kmmd62TGd8dMkVAYkbg06KRrVZ7re1qb1ojsH1MrOa8KOcvCIURD1+fYVbu8wnJV9U3Gwhys817oyxDCJCNWZMFsOXiFtVdkcySvLbj2X9LHdqYyLcpcXNOTACaRtj4Wzgxj42MXpmTBTT9+iEZvqOuHb1yN5Yvss1+OUyg3mNKBXPnmW9u8NDSME8DSTc6qFBKkkyHYSB6jeM/QE7YZ0+adfHD/VL0669fpyawN+T9I86F/byS8BJLjRhiENAAsChTnmppXa+m4O/PIRVVjVfM8W4cYWuYo+ssMsFKivlAJHdMlQWhOAh0Y51iHFuUi6RvRE0yJ/45fcg3k2hA1UpPFzXtfV051K8dM6H4Rc5nzihJ60tlXx5FVv2tFPPTcnrzHt25GO87DkctI8Nsv7a53L4ZK6WP4b7RaCDr2D3C8V3rrrvDFRh8CiVw/Wfjhe+6jEnSFHhOs2ZjljqOX0O9mQt1wYKhfz9pQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGwvR29Cd3RRZUlYMHZzUEdCMTZQMXBkSWlSMjJRWTNIYVJwNVFiMXBVMHNS?=
 =?utf-8?B?cExTVmIxMkpYeUJYanFYMVlnZzNPK3hSSWZFb2d5TE1mbVBMNXdoK2xNMW03?=
 =?utf-8?B?QWZSMXBBU2tlMUdiQnFqcHhUNldBVVRSeUR5cFRkdmxFNjEzMEhXb1dZSEp0?=
 =?utf-8?B?Wk92cFFTeVdzZjVKMThKdDhmQjhFdno4L2dCWGxZYmMxeHdlSHh4Qm1tTlhK?=
 =?utf-8?B?Sm5zS3pGM0VaL1FJTDlERURPYWRmMGxPZURXOXNWUEpnLzlKS3pyU1QyTGZ2?=
 =?utf-8?B?dkZ2RVZjMXBsYzUrRGNVOUlueUVucnVIT1hObEp0eTNxOTBCdWdZUmdvdGw5?=
 =?utf-8?B?ZGd0d2JrcnRuZTYrLy9EejRyMUk0ZDg4NzhKdWo0aUNEZ01OODNkNGtoUEx3?=
 =?utf-8?B?b2hobzNUamdzQnlnei9mRm1kODlCaG9IK3JHMVV0anZBVFZVMVZmQU9RT0t3?=
 =?utf-8?B?UnFXbUwzQUdXejBNK0drTWFDMTJQZEQzZkRDRU0yb2pTL20wc04rS1JGYTlM?=
 =?utf-8?B?MjVhRExYQUp2OUVhdXNBUUZXREFCQjRRSzhkMHo0OGk1M2pCTlhhaHVqdDd4?=
 =?utf-8?B?eWxCYlhZcVVrU2VyV01CSEdoZXNNb2p3Y25NTmhCNE5OdUdMSzhLQ2E5Qisr?=
 =?utf-8?B?a3BraGN2eGp4bFd2M0lEVkpvUDFTQ25Xa1Vsdnd5Uk9hYzBLclU5M2pYY1U3?=
 =?utf-8?B?a0hqczNoWHNVMmFUaGtaaFJWcXp5TEtRb3hyZ2VnNFNqTHhlSHFGeGpCcCtl?=
 =?utf-8?B?MEE0T3A3dE9uVEZHM24xaVBEZHA0end0VkxIbElzT3o1SVdEZE9pd3p0eGlm?=
 =?utf-8?B?SmIralo0MFVrUVZnQVROdHFOVmdsU2NJY0lLTXBTZU4wUXA5andrOU5jTkJy?=
 =?utf-8?B?ZzVpZ2UyT3NRK21Fd0llQ3lSRGlOcUp3RHlsMW95ZlZsZXN2bGVYYTN5NnRw?=
 =?utf-8?B?QUtTcGlQMTJFb3c5WmFrZnVCWVBKcm9PZnYxT2ZXUnZUbXJERnZaNXl4VG93?=
 =?utf-8?B?Z1pZR0J5OFJ2V2pYYmtqYmRxUHlqcCszeitrNitVMUhZN3FaUU5WQU04NFRx?=
 =?utf-8?B?UUJBM2FrN2UrYmJmcExmV0NRUmg0NzM5R0lWWStCcTlvaUs5bTBGK1hGOE8x?=
 =?utf-8?B?U1FTVTY1U0NGcEtQekxxU09wbXo4YWUxY3duMjFpT3d5djJnUXlnQnZiU2Q2?=
 =?utf-8?B?UFh4U1BpYUVmc0xldklxVG94aDRsU0ZxWWxmd1BiMzlzKzFtU2FOdW5TTXZa?=
 =?utf-8?B?UWdrd1VTbDkyMGxyWEtSbzhhZ0lqRkE2bTRhYzM5MDZ3Um03VHc4NEVuSTBs?=
 =?utf-8?B?WFZkeTZSdDRMTE1BNDZXNjg1Vk94Q1NjV3gwbGp2ZWJHTVNESXcxcnpmWUhF?=
 =?utf-8?B?L0NCOVo5NFN6bjlNcUFQSklYUERTTEhTNEgyVGE3a0lSa0ViNXpCeDQ1bFla?=
 =?utf-8?B?UDBiTEV6emppOTdnTmFPdDFidkt5MDVHWHRXamczVHhHeWNEOFdteEFjbHlL?=
 =?utf-8?B?TW5lZkxjTzVoNFZ3ZHpTR2daaS9xUkhjNjR6aU1xd2hib0VvYjZ4Q1Jad241?=
 =?utf-8?B?VnlkNWMrYlF0djBwOWFKTzVLWnlZRldibkRDRTN5KzJSM012QURmNXJoUGtr?=
 =?utf-8?B?Z044b2UydW1oTU15cWdsR0Q1cVlQb0VDWmttakhyaVNDOVBTV0RSSUIxdnR4?=
 =?utf-8?B?czJ1b0JHbWZsQmVta2Z5WjFMUjRBMjM4VFJoVnowclIyN1A3eFAwVmFWSUhG?=
 =?utf-8?B?VjN1blZ5dVV4dDd2c2hGWlllZ0dOMldoMkFDV0lscWswTk1MZnVIU0wxWXdz?=
 =?utf-8?B?Rkd3YW9OSEtvME41MDlSaDFaTmwzdS9zZGpzdlVwOVk4YnhsSXRrMXExN2Vz?=
 =?utf-8?B?cEFtMkF5OVgvUW5iZVFIVXpabmt3bXQ4OXg4Rnp3V01xc3I4VStBaHQwMEE0?=
 =?utf-8?B?dVhMM3d4emtaanJvL3NJY0xlMTIyT0h4NXZ4eUFwdFR5by9YNDhYbnVPZFF0?=
 =?utf-8?B?NnhqdUNxelg1WVlhYlBiSzdld2d0WFZhZmwwMGRzNUFBbW54V282QVBWWWh3?=
 =?utf-8?B?aXN1aFZRWVhQTGV5czlYVHlQbGFOcGZ2TWxnelpIM3MvcWhwVDVzTTNIUXJ1?=
 =?utf-8?B?b0FyczdCc25HVzNpRlFoeGFoS0RhVDBOamZZQlB0NUorK2J6aERsczJibXJR?=
 =?utf-8?B?dGFsQlBhZmk2bTc0RDRUcmNXbk43YzJJVDF4OGJ1ZjkyQ0ZLK29peFMrTHdh?=
 =?utf-8?B?MWdKbEsweU5VWlFudHM2NC83U3N6enBteS9UYndiZUZJODFZSW9sZHQ3VDNq?=
 =?utf-8?Q?xLX/cmWsQzHTMcFMV7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8414295-8fa2-4fba-e979-08df29f975e2
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:45:51.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3ocpepOkrpYR1gRssPD2BZkiRDovSmkx4CX6AddRljk/0K+tiiITsdMLqYJj2JRSCqCcQkIVgf3rGofM8TdWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6425

On 10/14/26 08:20, Michael Roth wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> When servicing SNP configuration and VLEK load ioctl commands, the
> driver checks whether SNP is initialized before copying command inputs
> from userspace.
> 
> The SNP initialization state is protected by the global SEV command
> mutex. To prepare for acquiring the global SEV command mutex only
> around firmware command execution rather than across userspace memory
> copies, move the SNP initialization check after the userspace copies
> and buffer allocations, right before issuing the firmware command.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Minor comment below only if you end up having to do a v2.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 7de3b6bf71e1..e42cf3aee50a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2639,12 +2639,12 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (!writable)
>  		return -EPERM;
>  
> -	if (!sev->snp_initialized)
> -		return -ENODEV;
> -
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> +	if (!sev->snp_initialized)
> +		return -ENODEV;
> +
>  	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>  }
>  
> @@ -2661,9 +2661,6 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  	if (!writable)
>  		return -EPERM;
>  
> -	if (!sev->snp_initialized)
> -		return -ENODEV;
> -
>  	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
>  		return -EFAULT;
>  
> @@ -2677,7 +2674,11 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> +	if (!sev->snp_initialized)
> +		ret = -ENODEV;
> +	else
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> +

I would prefer this to be

	ret = sev->snp_initialized ? __sev_do_cmd_locked(...
				   : -ENODEV;

or

	if (sev->snp_initialized)
		ret = __sev_do_cmd_locked(...
	else
		ret = -ENODEV;

Either of those reads a bit clearer to me than the negative check with
an else - just my opinion though.

Thanks,
Tom

>  	kfree(blob);
>  
>  	return ret;


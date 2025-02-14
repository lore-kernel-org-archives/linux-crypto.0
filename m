Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FE4264FB0;
	Fri, 14 Feb 2025 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739544791; cv=fail; b=WJuZ2KpQM6b/jsCebuexSiaAstSxuSaG1DikEQg2uo1NGPRXIzkW3WSe2+OFlNrLPVbpEY3EnwpKuWOnfJS5JN78ltWmTJ/2OLls3hRHcrbRjdDNhW6VgZe4pTwV1mXI1W8xxFGJgw7OZCaKUVvC95lkXtRiGyS1DyPkQapH8no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739544791; c=relaxed/simple;
	bh=DH991YFGcVx/mflYxGvDYs/lXw3Q/fkQ41wo1hngORY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jm8vTj6PgU+x5fAzHpCdmeZAdEwSFFLx/0oo1jifGG5hwg4z9ajCAlKhPjElEMs3aukhJh33etRX23/DNJDndPCncrme/KNQdSNELqamIyOXO/YGUqCzJulw7SunxYZywVZEfBFrHZ7XuJQVMnuZurhyWDxDxlWgXqPSH5CoU1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wd83DjEd; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wd83DjEd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEuKVRFcdlxNSRUVm+ls8CxTPBG5SyDn9XOYc0pcc3kKAZAEFwVFGtcnNbwp++zzKCizxKou/N3vYXlPhuYsS82BcP1EeewDXw7/H/b7TViVKKjhBabXBrTW16XbDQjl34rQv2nrbNw3wiBVlnWfQdrjuPzsgPea09Yra+jDMK+N1NSEhPehzL3AKP4PxxMtIve0PmcL58HJyVxNdacTqhy6nJOsbBiM4k6yOrmfkCGBvQEBefDTbYBb97Vr4pMHO1NiIQA5H2l3+lY4UOKCvOPSDJRUO6E8kLqjlPwP1AqVfPq1ggVL6LOaDASaRHxxgA1Vk6GBwaG8rTWXnaCsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fq7oRvN9aMxxIUsqvOugS9wwAi8nPz3c3hghwDvopaI=;
 b=DZaEnOhaDd+gdPXijYC/8YkwsuDnEkjJGYBO3j8kpu2AhD8U1bkGBgoUzAen4M9OsUpxTCD/F9zyYT9IJJrFF6zGkN6PP4QI21mCyuGi1GqYyBEdWDTCedxrNr2+fOut4mV0Bi1u7JdR4pLhLomquOYXg3GIdbg9NQa+AEwmioKnyVYqb+G+0Y+XuRNbHi2CG06dEGB4SILthu6NFbTSUvK8vjGZQc6tcDa7FXZl+7UzX8vLIWYlfau37Nnm5m+dBu6k88AMlPpBIzItSj16eXxxP1it+Op/DvtXHM1QDfTMgrby1oCHe7QvDOROk0ej7iBzkzlC2V8zgEnNCq++zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fq7oRvN9aMxxIUsqvOugS9wwAi8nPz3c3hghwDvopaI=;
 b=wd83DjEdcmpOPkh1Lwnhn/yPTxU4DB5quIWW2UF8PqPxyz6L/RhJLCk0QaeXgHV0L/qHbPf++Vnnw1soNsJgNUoM8qkbQc7heJ4ciPWCFPZj8SFRF+HGDgKcwMfiLGMarbRvZoSqMwcD5Y076PM44UeAKcJ5HduHmyRGpPbXczY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB9210.namprd12.prod.outlook.com (2603:10b6:a03:561::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Fri, 14 Feb
 2025 14:53:06 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8445.008; Fri, 14 Feb 2025
 14:53:06 +0000
Message-ID: <8050badb-8671-400f-8bb6-04255c761ba0@amd.com>
Date: Fri, 14 Feb 2025 08:53:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: snp_alloc_firmware_pages: memory leak
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>
References: <20250214035932.3414337-1-aik@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250214035932.3414337-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:806:130::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB9210:EE_
X-MS-Office365-Filtering-Correlation-Id: ae4f7b68-55a7-4704-6dcb-08dd4d074a42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEVNU253MzJxUDhMb1FON3dXQ044bU1jbm9PL2RKUTdVVlo4eVMzQlNoM0VR?=
 =?utf-8?B?WjNTcUVZYnVUWnRVRTNCblVHTnY0VFcwVEw3djlqRHhIditTV2F0aGR4TWFt?=
 =?utf-8?B?WWtDbkowUGNyOWpYWXF1YjVRT3RKazJzN2V4cnd1UWtOVitSWDVIOUsxUm9x?=
 =?utf-8?B?K2tyaHJZVWJhQy9ndW4vN2VDMnlvdTJ4TDF1MEtIS0M2RDNyYnlnMXBkeFNT?=
 =?utf-8?B?RGdURlh5RWk2d1o3SHJmWGJxS0VCSmtOS2tTU3IrSktnZGQxR3pOem1QWjBD?=
 =?utf-8?B?RmtwdkpIUElnaWRiWi9WNEtBQ3NBNzBhYkpLMGt5dk80ME1oRFZjUWZwdGRy?=
 =?utf-8?B?YU5ZVFdKRmJybmlXVU9lZ0hKMjVFUjRnYmg0c3pMS1Q2WXExSzFUY0tJb0Zn?=
 =?utf-8?B?ZnZRM1hHOUhMaDl2bmlyYnk4aHB3bHFmaXltSzlEdVV4L0Z5MDc1MVpYeDVX?=
 =?utf-8?B?cjlHVUJYaEN3T2pYVXlMalBjUFZwaHBZSTAyaEh3U1dFZElSd2M3QlczYklG?=
 =?utf-8?B?QmM0OEZsUVNpZjhGa3A4QmNkUnhKQWI2elREYkp0aDJXQ0xTMCt6bEhoRVZJ?=
 =?utf-8?B?cjhxcjdwTEVJdVlsOEdqUDlJeThIbGFLRGJ2WGF2VDcwZW55N1hHUUttMzBq?=
 =?utf-8?B?SlM5QlJlNWxVNldJN3BubHFpek9mc1dlU0JkbU0zbnR5d3BiN2JlS2lLNDV6?=
 =?utf-8?B?WktHK2JuWG9yemJiOHFFa3ZTYjhabldGdDlqdHhHTi9iTTZGMmY2U1hDb29t?=
 =?utf-8?B?b1FqbXdzWkNWeVY3ZEsxZ2c0TlM5M3Zna3NhbVFxaFVraXJLL3ZwOUN1U3R6?=
 =?utf-8?B?OGo1dE92YnFFdnprcjJSVW9kTTVrZW4wY1VHZWptUmgxeG1GbXFwYlRFcGtm?=
 =?utf-8?B?WThMWWZzWlkxS25Xbk10TkxQU1RsL0FpVklOSE1tQytNd1lXVVExVHgxdkk1?=
 =?utf-8?B?Mk5SbmpjZk85SDI2Mk1hYzlkckJoY0RBTlp1VDIycWMybHNxRU9ENXRNajNo?=
 =?utf-8?B?RzlKQXRhQms5NldpMnAwVFoyUFVsOGFiWGxXbTFVcEtDWVA1bWkwK0VSSHZH?=
 =?utf-8?B?ZDJYZU9UWXI3TkkzU0NGSDdneXRZY3FYUllUZGV1NC8wTXk3WFBJQlEzUlhS?=
 =?utf-8?B?S3ZmTE5KcTZHV1hVZmtSMVdCYmFyYU5zR3ZOYXFoWG1tRk85TVdwRFdaTXNU?=
 =?utf-8?B?OHIydnlQNFVZNjZWRk5WTUZMUE5BL3plclFMalUzYkI1VE41UDRZbXJjcG44?=
 =?utf-8?B?RE5IakJrd1FHcUkxUDdjR1AvZDVxR0prekZ6OXRWYlhlOENNUmY4TW9CcmZv?=
 =?utf-8?B?M1ZxK3JVLzdCRzRzTWgxSU5tdksyZkdPekcwTU9xZEV3TFVCc1BibFpwMWZQ?=
 =?utf-8?B?K3lNeGVGRkRXZjJUWVRocHpPM25hMjA3MGFXbENCMmdTcnVjMC9xOS9YZkZZ?=
 =?utf-8?B?M21iajloUURDYnVWbzRnK3B5dC9VOGU5MjdaWTR5aHRHekcybUJrK0J6V2JL?=
 =?utf-8?B?c2hDd3pibVh6bFhvamZ2YUFFcDUwTm9OSFNBMDF2dngwMU83KzE4N05DVHUx?=
 =?utf-8?B?ZUdMYWtQTS9peTY1ai90VFJqL2o2cDR5aFVYMjRWaFl2VlVHMG1WSlF2cEVX?=
 =?utf-8?B?aUtib2IzMTY2R09YcEJxTzN2dENGTWlkMmJhK3d0dEROQ2FvR0UyUFBrTy9s?=
 =?utf-8?B?dmdWNGpEdWdsNFFqazR1V0k5ZG5xcVBReWJkWmJuTVY2RlJsQnZLTXR1RWZt?=
 =?utf-8?B?QTZabzB6eUYrWFVBVE1ITWFpbHgwaTMwWmR4VnNIMGZLeTVXZ0lTNzd4cDdp?=
 =?utf-8?B?TzdsMnI2SXpWUVJpZlNHbW5nREZGQ2NUMFhTY05VWU95Lzc4Mmp2OWQ4WmhS?=
 =?utf-8?Q?w67EAqds2lO7+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0ZxR0t0UjVzYjVFck9tc1k0YmR0d3N1a2x4V1RxMEdCOWhXb0ZQQW9Ccnpw?=
 =?utf-8?B?YjFmQmRWM1dnYXlPUWk3dk5sZkU3dVpUb0dXM2ZKSEJwVjhNREVtUlkzc3hR?=
 =?utf-8?B?WWxEOU5kYklCS0EvRkZyVHhhcHVUMjd0ZkhvV1kvNHppUDRTc2xDdHN6Q3Fi?=
 =?utf-8?B?MjdtZVppbTVoRFVCNjRuQWY5YXgxQ2F5ZkYrYkQwU002cjhxajZhcnhvS1ZD?=
 =?utf-8?B?Z0NmbFhUV0ROcTBFY0RSaXZMbWRHYWNib0NVVkpQWFI3SHRqWHg3RlBMbVZN?=
 =?utf-8?B?a0pyOW1rRWV3WUdXOUxzbEczK0l2SEVmZGRqNVVxbUxIaWVMRUVvdzVDcTlL?=
 =?utf-8?B?Ti95TUdlYlB4L203c2RFZDh0WENxd2RyMnRnZlo4dzdSWmYrWm5TbG10NjFS?=
 =?utf-8?B?Z1MzOVBsZTdZODVJTGtaZnJEYUx6ZHhXNis5cW4zL3FISkp1aEQvZDd0WkpI?=
 =?utf-8?B?d0JMaHEreXVGZ0c3NVh4cHN6enl1bHh6M01qSWNVQ1FCWlZFQmJHSEZoWDJv?=
 =?utf-8?B?dHd3S00vc2tNVGpsYVMwOURJTzVCTkpJeWFiMG15cGZHM254Y0NlbWxENFJQ?=
 =?utf-8?B?akdhZWNNNWo4QlBydDNoVGErRUV0S1hjSXFBRzdMNHRuYmdaOG5wN1VJRDUy?=
 =?utf-8?B?NGV1MVNiRGExNThrYXRQM3NYamU4ZU8wTnB6T04zRDdaUVF0Nmh6NXBwYTVo?=
 =?utf-8?B?ZStrbEFuZGpmeFR4VjF4ZUZCQWVUVWFXakg0d2UxdTArUElVRjVCQ2szVDVG?=
 =?utf-8?B?R1NNcHoxNEZBd3libUk0VTRrZy82TFhPaWxVRFcyNzIyRmlqcFFoODhxbTg1?=
 =?utf-8?B?aVVBMnZrY1RRSTE3YlB1WXc4TW4wVHJTNDRFb3NJYWZHbis4emJYYnZ3SE5h?=
 =?utf-8?B?bytSUWpkVG1BMDBEVjVzSzREdDdZbVFJR1duVlRrMGNXQXE1UzNkVTRHVXVK?=
 =?utf-8?B?MWZ6UHM5OTZKTG02c2FJdWtiTlVSbzVoS0w3UWxuQlIydXF3N0RWcFJjVmpi?=
 =?utf-8?B?NEdLbnI1Mk83M1Brck5BVllqVmtqZjhjZHZ1QmduUnBwOWJNcnZyU1lXRmhp?=
 =?utf-8?B?Q1JmbS9SdnV2NEg5RG9Ib0RhbXhkRXlFc1F4dnE1NGRpaVE5MVBLU21IcGdT?=
 =?utf-8?B?SkhBT3UxbGRjZlZrUTZmVXFYcDNrZ3Y0OHFtMHR2UnpSWlBHaGhCYzZCc2c5?=
 =?utf-8?B?RnNJV3loT3NjV3R1WWtqRjRGUzZKSDZxVmF3b1djL054WHgxanpHdndPUmtR?=
 =?utf-8?B?aXZiZDk5RXVrbitRK2pQNW5uQUlqODBSWlhYTS9TRkZxT1lmc1hoT0hhWWdE?=
 =?utf-8?B?V2FGSXpRa1ROZlp3RFp2dXZvU0VDNFFIZzJzN08vZlpmTjdoUm5KQWFqeXcy?=
 =?utf-8?B?N2lKSk95OUpYM3c4OFFVRG53SHRzMGl6SW9oYUlTeWlZb1hucU4wOWJiM0M4?=
 =?utf-8?B?NFlnNWt4N1pHU3hhejBXeGRGbVRoUGRQeHMreVNiVzl6Nm1lb0EvVm1JRW53?=
 =?utf-8?B?cmF6RGJsK2xta3ZkT09nMFVBbVcybndiMlljTmRnQkUrenBOckhuQnpka3FB?=
 =?utf-8?B?eXFkbVUxMlg3S1dja3Ntdm82VXJ0L2tTeFZNdkh4bzdBMlZIa250L0FIdDFO?=
 =?utf-8?B?UWoyMDlDdjB2bTlDcmRCYlNEcjhxeWF1SzREVk5aajIrWVJ3a0lkc3pjTysx?=
 =?utf-8?B?VEh2OHZBcDFyYXpUNXFNcUkzbWFaMHhsbXZVWVBzWXJWRjc4SFJHdWV1dm1Q?=
 =?utf-8?B?VDNBRXNYOUVQUmlCbEVYTi93RTMvTWU2OXhydWNTRGxqbXdVMXU1dEZqc0Jw?=
 =?utf-8?B?bVdSVjlUUDBPQmpyTGxLbWNVdlRqb1Y0dldBKzJVZ2NCamhHWTUvQUZGZTRy?=
 =?utf-8?B?ejZ3REg0SjJjSmVmc3dmYThnbFR6bEVUd0QrTkowOXQraEdVZmpaRTVIZVg5?=
 =?utf-8?B?T0lhT2NoS1dYV3p6KzBMRHBDMVg0ZjFicXF3eWphZ0JKSm5hcndWNVl6cHFj?=
 =?utf-8?B?enNBaGdhRUZFcnI0eUxmdmxEdVBnSlR6TDRyMXMwZkg2eDJMQ2RUQlMzSXBB?=
 =?utf-8?B?NFBZQ1FtQXpOcXRoWXZ4ZkhSSUZRSWtDWlA1aGNzZDlzdmVXdi9aSmhqeU1H?=
 =?utf-8?Q?rK/yv0cP7VpkPluXsi+VJ/nE5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4f7b68-55a7-4704-6dcb-08dd4d074a42
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 14:53:06.3995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeuecHNXtJETgluGuEq5WxV5LFzWrOKhCko574WDn3suJpJyp4Cpsqi97dyMeUthqfANdTlrNdftST+luh9ddg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9210

On 2/13/25 21:59, Alexey Kardashevskiy wrote:
> Failure to rmpupdate leads to page(s) leak, fix that.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2e87ca0e292a..0b5f8ab657c5 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -443,8 +443,10 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>  		return page;
>  
>  	paddr = __pa((unsigned long)page_address(page));
> -	if (rmp_mark_pages_firmware(paddr, npages, false))
> +	if (rmp_mark_pages_firmware(paddr, npages, false)) {
> +		__free_pages(page, order);

I'm not sure we can do this. On error, rmp_mark_pages_firmware() attempts
to cleanup and restore any pages that were marked firmware. But
snp_reclaim_pages() will leak pages that it can't restore and we don't
pass back any info to the caller of rmp_mark_pages_firmware() to let it
know what pages are truly available to free.

Thanks,
Tom

>  		return NULL;
> +	}
>  
>  	return page;
>  }

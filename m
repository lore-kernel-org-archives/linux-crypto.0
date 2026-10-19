Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC84F390F
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417147; cv=fail; b=SVtpXDj3mqmsfcU0MHwQUyjRw/BuKyr9E7COTUdLQ2KAqT4ITkaGQNMBrtXDJJ1PSUCcruMySmyGcQoRTnNczUcKkRhpXKipyxSDBCghnSmfqDKi6sTkHXoFpp60nP+siMaVYPV4SHSDVHGUBT0shxOOdXcuRUlgay9pI5sadfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417147; c=relaxed/simple;
	bh=tLd/s5+pMDvM2T9h434a2t6hIPSzBNpGGxuCObc1wBs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lg8jALDUd4vdDLOHnvwyKESedJpZHYIVLmvQbASieWqUHBrXKfdkUp/gl6xaSA5dmfvhH22USUeZK00k49x7m6MZJo/usorKHbx8QubmExNHEiQSd2Zo6oBgCDaSCefxZy+B76LdVBX1ENvLhL/sjSJi8F31DG8kATGf7TS14zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VwEZeuVc; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VwEZeuVc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhBBRYipuRrRHbdyHEAlraNZfhsHOhPfxeIIGKtKk8gagxU+mwawOmk7e8dJXtz0NtLCYLM4A9UTt5dFTfm3KLLQTgcXpLv+EJ9o6mhPLICczbrFpzGUg5hL+7HfHOELVu8GxRCDXBxdIQ4A2T5g1pnMp+zxnk1o6dnmhI4TVloJGNJ4HFyexEpIr8gP5gvWDEyOQMxQ88DRMWqfRlee3vob54JrXY5afz62dbblYrFEEoCspH5k3Ty0nyDmFDQl6E/xZKuxaWRfCidfDlQFJZTQCq0TfC4bj26EyGZHLbhknGTP7/EKGnDHD4A6hxYd3gVG35svzCugSydXsJDfsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vAuHqYocm/cGfyYL/yunTXoZnA7jwFvaab8s7PzEAI=;
 b=kcLopaZE4Dpj5ZvGs24fZYtlcwtADGj6cgG8R3qSquAnpfu4oiHCf4Xrlh1f4yLO/svHiMc+S2SS1tUVbgPZV07jqaQnGsGe9YneKNLc3nJ1lNqjy3ZzgaJ1EifwT4xyt9CUQhfbQvjd2zFRLWJgDsxPTn/NQjkpNWQFW77q2EzcsdXCVCE3DtmPIbIFXWfkjVFGWlApPlQiwcZD9xkslO4vENkCmaZwfoEgiTDepQ0gNlB2YjcCKDV/kCpqCNN6L9dpIP1UfUR4nKDeqyx87mvcAzl4OTbXqOO7kUo270pfMCv9Km/axhBjAbg7/EyIiZqFT4CfQsgB4AYjeo8iQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vAuHqYocm/cGfyYL/yunTXoZnA7jwFvaab8s7PzEAI=;
 b=VwEZeuVcRtEUqL7A6rFAf9gmK/bBrCJiY92cZ8Oylwv5jM7Xar4TlueB05UvGV/WtfyLWt6KfPD+3ergVlbLarw+JawgHQI0A2spQXRp5RJdKNNphbAFer4+1aygXItltL9rXF0P0frVhKqK4T60pRGU9BQfevkWGsmPDyjlqS8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH0PR12MB5677.namprd12.prod.outlook.com (2603:10b6:510:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 13:39:00 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 13:38:59 +0000
Message-ID: <7ffc133c-c1b9-44bb-ab9c-60569eb749ff@amd.com>
Date: Mon, 19 Oct 2026 08:38:57 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] crypto: ccp - Use __free() handlers for
 sev_ioctl_do_pek_import() allocations
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-5-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-5-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::12) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH0PR12MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: a761c5a4-97ae-4365-cb10-08df2de6549b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|22082099003|18002099003|4143699003|11063799006|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	O4OsY4HjUf2pQnoac1BxgC57tON979HHS25zdwJ+Du7MTd1ocHsu3HAuGs2OuAXARtLBv488FYmZm58mjyAM83VaFBai3g2CsARAfW0e8W9NFhkRVwDpSKrWt6DLfUL43/VcS4jSJiuR5KM+JiWgFU0X4HCFoWictTHdzGc9KOcKMauB/CpmPHrY1DzIQ07iqt4dyRbXSouTNfqRr2n9cMn5EuPwh5EkbzacL8FeAJq2PaTy3Xp8Va/GcZbU0zxdT0xLcG+/YhS6W0OEWCfU4v2pASXUPJLZTkrqV/3O0bSrOzCC4HMCw6vfBN3sugZiGf7gc55Y5tjpDfX1bKZ1J5N/axxcbmHwLh0rq5YDFdOmhBwwHc9rbhUN4Y7gT3lq7yAjioCZA/jrQe49HSpmXq+E4IxQVCnx0GZNzTZsKlwXUxZiWysliEozoS0TeozUOR/E/AjtOGAqxeNky0hpQMxiKbHD8SKV0P6r+Iy5gSo9OFgH6iQ+rGqqVC0v05XvWIWLdnRwspT498DspGwjdDPQPF9r6F7xWzZ2sSkSPHjs6uBH6v74kxslJwokKo2CI/6sc3aNYZlLQ8l7u+Tx139rQs9f3rtMS4djZSArxqIWpyhPVRZHJmi1T5SvApDBVE7CHjGLa9JmiGxDnM3HrO1s1DBLQ0fQsiSVSi8gor4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUM4UEhuUEw2SEV0OGVEeUFic1pVaWJTeG15VWhZWEtzL1ZldmRyNlFyUmJG?=
 =?utf-8?B?L0RNM0VYeFRoNlNLY0ZLR1Bxb0xzL3BtU0d4ZWtBTEpMY29zVVRKWkNSM0xw?=
 =?utf-8?B?Skwya2JmdU9vTlRUNm5LcGJBMll0LzVSQ2l6Q0s3SEZRY21yVGlOVjhxL1l4?=
 =?utf-8?B?NGRlQlFrQVJQTTN4VEtRbm9FWnpMRjloRW1hWWVsem5FZ01iMnNYUEdWZDlt?=
 =?utf-8?B?c1FrK3JCL3E5YURyZnQvOGVodnpvM1lYbktsV1M1c2VuQnNROGlDajdSU0dj?=
 =?utf-8?B?dGo4VEFqcWZkdHd6c1hwNCtXa2NVU2MvUmErdWFtMnhtWWZGREFVblVHWUNC?=
 =?utf-8?B?cU5aaHZ4b3JxVDFLMklWckhIaUh6aEZhTktLNGE3VTJGb2c3dzY3MEJFQ2Vq?=
 =?utf-8?B?VmNpbEFrV09ta3VycDNiTWhDaVNZSUM0RE5wV3IwYm5ONXJHaU1pUVBEUHBY?=
 =?utf-8?B?M2x5VGtjZkNHQU8zZExGTlY5QXVKck1oWjdjYnU2R29NbkFrdTJlR2Y3RHA5?=
 =?utf-8?B?SDVnYk1qTnR6Z0VFRzNzc0o0T1BKd2dxQzIyWG5UREZQdVdiQVJYTjNFTnlk?=
 =?utf-8?B?MkJvNEErQVg0SFVxdVVlWk16emVPQ2FtYUFhSWpkSXhXS3I3T1JkNTl3ZmEw?=
 =?utf-8?B?MWM5MWs5bjJUeFJxOFF1Z3lwQ3JQTU4wNG51S1lNcHBPOUdmYk1ES1pZOVJ6?=
 =?utf-8?B?TjZJdkJjRDRVOHZOTGpmNWJRQWFJRFRacXZkY3ZlKy9EOGsyQkdaclNSdFdw?=
 =?utf-8?B?V1lhQ2xXSDRDL3pYekdoWWViYXY0Z0NwY1gzQ2Fka0w1eUh4N3JlYlpHWnBO?=
 =?utf-8?B?eFkwV253OHpZcXFiWjhGRXQ0bkRoUCtXc3ZUYkVMMHdTWGQ3Vkt5VnB1Rkx3?=
 =?utf-8?B?Z2hJTlJVTDYycndkZDQvdDJoWlZFK3lFR2pxT1I3L3dQYUFqZmxMcVRSbFpE?=
 =?utf-8?B?a3NnZ1NkVGlJNXovQk9yN1ZBL0RuVXFqSXV1L2dnMmJkZVVMWHIxa0t6M096?=
 =?utf-8?B?eElJWWJtdE9xVVhvaUFUbHdhK1UzK0FVZmFVaTJpNFN4TnZZR2E2Wkpwbyt6?=
 =?utf-8?B?Qml4T2Q3ZDNjZXk0WS9YbFBkbE5kV0xYVkNXeUtkUkdXNHJrV3pvMXQ5aUxZ?=
 =?utf-8?B?SEFFS0w3SFRscEUxMVNubFR5NWtzaUxSekwxNnpzTG9WbTF6UmlWbjlLZjV4?=
 =?utf-8?B?M3hXY1lKUXk5QWI3eGk5WUdPVW1jeVVWbVp5bi9UNDFhUjBvMjBVQS9OR3JW?=
 =?utf-8?B?ZXJuT296ZGlJR1BBTlJzbDNlZFNYK3F2MXZsU3RKcU9zcy9CV3k3Q3I3cXlS?=
 =?utf-8?B?aVROZFA2WGhHWTBmN3FYbzRnTXVGaDlaOHc5eEVxV0l1Sy9kdTdlc29aODJS?=
 =?utf-8?B?ZFVGM0NNKzZ3bmltL01ySzJSanZwRjdpQllGRk5ISmhZQmZaNnVTWVNrdklU?=
 =?utf-8?B?MkJ1OGd5QlV5Q0Z4b3VIZnRza1Q0YzY0VkFRaFltU240S0NOR2JsRUVhRlBM?=
 =?utf-8?B?aHVaMENuQXRWUk5Ua05hUlI2bTNsckMzSm9VNEs1cDhoSzY5aXJ1ZW1UVlcv?=
 =?utf-8?B?ckZPcmMvSHJodkV1YlhKd0xCYXRDQlE3aFdDc0Q0R2JTQWh4QXlrL0VLWFVT?=
 =?utf-8?B?bDFhY2pwQWhrMTZFTnhvd09OdHRSVWJiVzFzaytQRVVzdE5ZRWtZcEx4anQv?=
 =?utf-8?B?OTFjVng2QUxuREU5dXltREtKeEJqWjg2Z3N3VWhHN2tYNFJCQ1AxQ1pwYTFr?=
 =?utf-8?B?aDhYU0w0ZTNpRXdWVUh0UVcrUFNaSC9KMGU4ZGlOeTlqa0hSZXp4RXFzVzE2?=
 =?utf-8?B?d2c4ci9LakhnNnczS0RGZGdWMFNVaHJHcXc3N2d2ZU9PWWcxUVRLakJPdmNh?=
 =?utf-8?B?SVBvbW0rSnhWeVpIK0R0UDVtazYvVjZCWHhZZFV0M2IrSWF2M0VzMzUxSkF2?=
 =?utf-8?B?NnlZUjB4N2pIM08xQ095QXhIeGljWml6MmR0YTBEQTZRYzNWcnR0aFhERXNx?=
 =?utf-8?B?c2hlQXFDelBJNzhoUEM3NHhxMTBkL3N1d0FyNm5QSGl4RUpVdHl5clRVWHp6?=
 =?utf-8?B?T3BLRXpRek5OSElZc0xOQTI2S0VNeTREMktlZmdYeGdwRWNhZ1ZwOFlMWnlT?=
 =?utf-8?B?STBEaWFROFU3MnUvZElnSHlKUjVXVzdNdnZCUlZHNmllc2d0ZzgwKzNBamhk?=
 =?utf-8?B?YzhYTjJISm9Icjk2UVRhc01pbjc4V3ZkellkVjBSUkh3QWZxWmE5akdsVzQ4?=
 =?utf-8?B?THZ4OTgrZlJjU01nQ1FGZ2szY1RiejJMaXF4elhDdVV4d3NMUEhkOUVrYlJ3?=
 =?utf-8?Q?PBmwruvJRqPfn8qHY4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a761c5a4-97ae-4365-cb10-08df2de6549b
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 13:38:59.6479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZ/bVo4LGqsECtDJYawhemiBn536D6Wtr0Tr2BDsY1asgyfKBTAJGtC4IEcxU0llDqDAbpEOnaGJaWBI8ldfSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5677

On 10/15/26 23:09, Michael Roth wrote:
> Make use of __free() handlers so that the related goto statements can be
> dropped. This is in preparation for switching over to using mutex
> guard()'s.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Minor comment below only if you need a re-spin

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f6d06242184e..6b483bdf0f0f 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2284,8 +2284,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_cert_import input;
>  	struct sev_data_pek_cert_import data;
> +	void *pek_blob __free(kfree) = NULL;
> +	void *oca_blob __free(kfree) = NULL;
>  	bool shutdown_required = false;
> -	void *pek_blob, *oca_blob;
>  	int ret;
>  
>  	if (!writable)
> @@ -2305,30 +2306,24 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>  
>  	/* copy PEK certificate blobs from userspace */
>  	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
> -	if (IS_ERR(oca_blob)) {
> -		ret = PTR_ERR(oca_blob);
> -		goto e_free_pek;
> -	}
> +	if (IS_ERR(oca_blob))
> +		return PTR_ERR(oca_blob);
>  
>  	data.oca_cert_address = __psp_pa(oca_blob);
>  	data.oca_cert_len = input.oca_cert_len;
>  
>  	/* If platform is not in INIT state then transition it to INIT */
> -	if (sev->sev_plat_status.state != SEV_STATE_INIT) {
> +	if (sev->sev_plat_status.state != SEV_STATE_INIT)
>  		ret = sev_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto e_free_oca;
> -	}
> +	else
> +		ret = 0;
>  
> -	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
> +	if (!ret)

You can just return if ret is non-zero after sev_move_to_init_state()
and avoid the else path that sets ret = 0 and the if (!ret) check.

Thanks,
Tom

> +		ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>  
> -e_free_oca:
>  	if (shutdown_required)
>  		__sev_firmware_shutdown(sev, false);
>  
> -	kfree(oca_blob);
> -e_free_pek:
> -	kfree(pek_blob);
>  	return ret;
>  }
>  


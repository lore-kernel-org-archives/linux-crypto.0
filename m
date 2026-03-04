Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A242438422C;
	Wed,  4 Mar 2026 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772657425; cv=fail; b=YAQrE7maBQUb/P2Zt+KaI5R5crHko7UQDPQCiheApzVChBEquRBNwwkk7L5d1qF+645sr5zIk3UzEfHdVOAK5ZTPgnCmAAmRkFBlNAKltBYo+3hzKnJQI9icBRINDQ1KXNyi19Dhb1Bog2swAfEnz8ZCXRsdGBmXUjR1JEpCsIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772657425; c=relaxed/simple;
	bh=vP6TJ82rsuXrj12jU8ADnVIscWeYyw1UvogwWxuHIKc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=axPn+419hanUZz1plENVDI0oPH0DBO5lm6Pr29mbJ2EmwH2hwOM5LC6e1dTb8UKG6P1OV3vbFYq35kyukdkZyENR9PJB4q2+lhJo9Z7wnMdlG1/59BRkAm3xF44l1RTHGWpdntXCYZEC3qC5KFNC+8CG5BRNGLjrf+rOXviS9AE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j3rwy9Hv; arc=fail smtp.client-ip=52.101.57.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j3rwy9Hv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IGLHX+WbRc882DebHOp8N9xVPJFdyp7A+t5OOBi4OFmXqrecX+Tf+R694gey6E3z4G4LQxDIUBPW5p0Hqrf77IE1fZzPx2iy/1QAYTHYXtcPopc7sRXBsIvSJ4XLkuPucuLUf7BbjoEdhdnq2up/Jt06GbalyXulocTHnP+CwEK97R6w56TFiWxT6sjPpL9AqtjRql+ztwzmf4UTOdKtIxjHYl5yZ9NJIVg33ocgGK5uXogeX3E7cZ+497dwzVmjOJRW/cY+enCekH/xogo8wZlD0kisY+ugUVzacOxLRIFmH4dx0tJlfzuTHFWR2gqdVteOGFgxtjJzCNTzTAt8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oG4ckZO/Yni3fCbnUEXVULAOXhhQLt08Fa1r+nopjuE=;
 b=x4IfJALkNrkGYZyQpcS9xxns9Ka7YjzArJdFqL2t+M9bqUpGg6FK6SPLjMWxeE6KrovWR/FdvcGpjZhyp0IAs5DJMY/uT4HnugH1GFsb7DNUh/KJ4qORkW90zXsNRJJlOfoZlf6iTNBk4YKuy5KMxY6t36N5VVNIEWtevPSIgo8+o/EASbAyA2cihkTFAUa6xhYrDorOG3yZNC9liirRgkF8PODDQSSV2dXDz60DNQFKpWAM/Hw+XszuaHT5nwF5wia7OjSKKmyrMdSK8JsBIorQiMueEHEambF/QgBd30CQHRtykE0TJYWHDOB12MWG3tCQWYqpCXjXq/0nX7o4og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oG4ckZO/Yni3fCbnUEXVULAOXhhQLt08Fa1r+nopjuE=;
 b=j3rwy9Hvr6+lKjC1kzxprueKo9tz04FCx4+VPgh5NdeM81BEH8IPNXO6AqBzWgK+gTkJFITVXuIH6D47JX2sU6dUJnPbOCeRMYHDDhqHofSTrFlQcN9N2YGjK5zEE5J08CLiOIL1ewyc6zjS85k6J7XUZq3s/Ww4tF4wa7Xigp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Wed, 4 Mar
 2026 20:50:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9678.017; Wed, 4 Mar 2026
 20:50:16 +0000
Message-ID: <856a1607-1b21-4706-ad38-5cd4dd879761@amd.com>
Date: Wed, 4 Mar 2026 14:50:14 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Fix leaking the same page twice
To: Guenter Roeck <linux@roeck-us.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: John Allen <john.allen@amd.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tycho Andersen <tycho@kernel.org>
References: <20260304203934.3217058-1-linux@roeck-us.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260304203934.3217058-1-linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:806:f3::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f060b98-13de-4d11-a20d-08de7a2fa3ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	Im1j20MedoKQi9oa7oLgX/q99nWN+YQO6xQTpJi8p5vY6MavyL0sViDuR+H25e+njcQwyXClc5TnrP2JG/LlkjQ3e+zCN4oPrVobN8k2g7D83uCUEYh0tmIx2HsTdeSTw5aU19r+mqcex7UKvs4a+R820m3IRW7ouu/Pp4U0iyrKS2jabTCT471a6t0LoYvPPEkVX4RFr7ZnyJO89sAw9pwrq8atUj1KpZAcN71Ffb9c7qquOuaUTofwA7Vi9m51Cx3yaQNPIYVXOM/8yXcFs24mZXUeelHKzraR7qZlbQC1L4gqpiSzputpXmWMTWEON0koypNQ4FquWpmGNtSQee9Sw3jg8uQj4BpHozPNtfmKIcw0BC4V+RPOKRZTTLZ/eGfK3qNsBZZd5WtF7O/nB89TvyW6U4cOKAueamMRe/cmtGVx3IaplRv2ythCdgQfDD8pdrUb9aqCQeDX0dkd0MItEFt1QsWEnGzmR9LMwxhMxH9bP9X9Zm8LWH76giNZ2jgKE2g7/8+mt5Yl3TYhd1GTu4HUibZTmM/JqkTjEiLE0hSv0dHaJw2gC6WnO87RtKmJvgoXz44E/DSGgXTxr0L5q9J4Dz314Jja69/ZPJemPlOsOYpvOvBYYisWzQ3wkoIWtNLdtZSh/GMK6X8NqCIITXQEvm8Z8PhrLmOIiu6XsU4T2KIC7s/DP8VUtdpVqcnHO2A4KaS67yWrtZusaefrhfVWAsnYHYB+h8rBU/A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VktDL1p2SDgvcWkwa3VlMmN1NnNPZmpJTXJ1Y3ZDNXpacFRONHRRSmFJVkFy?=
 =?utf-8?B?UzloSHA4SE1sVVp2bWxVRVIzQm1GNXRtdm43NmhCUkJWL2xRdmRxTnFpVlU0?=
 =?utf-8?B?Y25ZVzBySVBCVzlweEluSW5TZDdocEo2akEzdDZ6azRMdG55bm1DMnkyczBs?=
 =?utf-8?B?S0tZR09EOHIrT0xJV2ovSU93N1I0TEZFWFZXR3hGOFJjMEowd1RESU9jbG9v?=
 =?utf-8?B?RUpDV1BkWEErUnlWMEpvRzdESW9JOWdsb2RpbGpVUDRiYjJWcUlMVHM1bFRF?=
 =?utf-8?B?dmRQczVWaHRabC84YnZBNDJvQ2oybTB0c1hrVCtIUDNhbU5kajlPeGhWMGxO?=
 =?utf-8?B?RGlPQ0VEcklxOHJzak5PT1hqTFBhUmhzMzJMeDVXSGNLUVIrR1g1L1pvbDN4?=
 =?utf-8?B?S3VsQUxtVkg4Rk1sNTdNQ0RBbFNaaHNSYTVlUkVyTlhJK0wvTzY2eXIyZEVU?=
 =?utf-8?B?QTJUdmJjczhjRXl0ZXk2Zi9PWnNpTWkxZ0YrbFZIZlZXcTlBMHlnWncyV3dn?=
 =?utf-8?B?Q0RFdm1JQ0JnK1pwVWd1V0NMTkZVMTVTSmFZVzVsejlDZm9hY2srYW9DeEhv?=
 =?utf-8?B?ZWgrd1lybUhmdXMyNVhuTmdJOE5WbVg4RTMwVWRaUHhCc0FocWZuSWxBM0NF?=
 =?utf-8?B?NndQRCsvRk1zSXZucGt2a0p4TE10ZzI2RS9wS3NZaExyM2dja252ZFlrRm5h?=
 =?utf-8?B?R2Z3Q3F2cWxxcjEvRklOQ2s4M0tndVU5bGpqRlhDbm0zMENDaWRqVlh6UCtW?=
 =?utf-8?B?ZzJSd0ZmZm51YXNkQUtkTFFKUDIwR1RHaDB1aUNHRjl5TXgwa3dIQkt6VW84?=
 =?utf-8?B?OXpvY0JiK0dtaWoreEZTREZlUkJjTnFwWXQrUkRHVUJ3SHdYbnIvVUFDL05w?=
 =?utf-8?B?Mlh2Tm56WW8rWVdHZjFuNW8vVHlwcGVhNDRBUm1CYW1XNENIRVVZUWVwVjNS?=
 =?utf-8?B?K2N1ZDErNnhRSG1mRVE0Q0dqcnRXci8ybW40Wjg5VmoxNlFLaTJzTzJsVEJr?=
 =?utf-8?B?eTdMT29ZVGxRWFlqS2h1ZGpXQzVJSDFXb3I0OUlkN0pxTFl6VnFZdmJCUG5N?=
 =?utf-8?B?SnZ0cDFORUg2Qk8yRURHVmQyVDlST2kyZ0k4N2x2dndDTnpQOVYrKzJKVFVq?=
 =?utf-8?B?cUVOUzl6V01LT1lEWnBBYmFnbHlOaGJJV3J2TzEyZU96elpBTlVab0NkS1Vx?=
 =?utf-8?B?c09FNnNZRHR5ekhMbzZkMEdURnRkcHZFbUUwZHQvNkUray9mV0trZkdPbFpD?=
 =?utf-8?B?QUNoa1ViOG4vSzRLOEtMd1VHTEgyVkxxbjRxNGt3YndnT0Z2S05RNHVXMDNo?=
 =?utf-8?B?b1Nrek9GaUFtWmdqL3JaQTdaV1VSV0pCeHkvUFpUZTlFWEhaUnJvVjFtSWdo?=
 =?utf-8?B?clZWYW9xVGt0eEhiQUhUbnZRQ3hKSnIreTZsbS9NTEdTaDVHMm90T0U5eW85?=
 =?utf-8?B?YjgyY09NaE5YT2FQYjVkM25rQ0ovc2FSVWVqcGlCSjVxOUdYa3RNVDBtdWJB?=
 =?utf-8?B?eEhVU0lDSFh4R3JneHJHc0lZWm9tdGRuMnVYcnJsQnFOa2hmLzNhWXgxNmVt?=
 =?utf-8?B?QTFCWTNuU2ZIYzF5dVBwdHhjUEVnbnpMSWttY0hCTlNCdGpRQ21pd1l3RUtX?=
 =?utf-8?B?aEdWa29Cb0UzbWdub2dRNTFUdlZUVlNyRy9BZmxINFpnVGVUbEJ1QnYrUVhl?=
 =?utf-8?B?Wjk1elVPWFVQaWc3SEh5MzF4dUdlemhTNHI3MGZ6SGlBbHpHTTQ4eXM2M2U0?=
 =?utf-8?B?TG9EVVBtdm5oWDNtTUJRN244VXRYdTZEa2FoN2ltWHgvbW4xWW9wRkUyakgv?=
 =?utf-8?B?SGhCTVgvaU04NmJLS0w4Q2F2TWhZbTM5ek9LZUVnUkdTbnZBcG14WE5jdTRK?=
 =?utf-8?B?dGtoVGxreDdlT2pvc2J4TFBTTFl3U3hLQ3pmb0h3eGFBdUJjYmd2V2dNaWYz?=
 =?utf-8?B?WFV1NXU2cGgrdkhlKzlYRFYzVVRUeDlWZ05ZNGltWi9PTEptZEp5YlJNbkZO?=
 =?utf-8?B?TWt6aytxbHhGcXZmM3BaaS9ieDRrUE81bkNnR0R2TFZTUGRBdzkxRzBSYmZw?=
 =?utf-8?B?dVdjZ1A2aWVXcVMvU0xYdkxDaG9Oei8vUk9WK2g5OHEvUFN0MVdkLzR3QlFu?=
 =?utf-8?B?QStKdUorZGE3MVJpc2hmSS92WGZBK2MwUzRJZVlCMjhZTmw5V2lkQkk1Rk1Q?=
 =?utf-8?B?V1RsR0pxODRDbWR4NVNYaldoWE9hNk5meUpOclRTZ0M0NUZQSEd4aDdzVnpY?=
 =?utf-8?B?T3krOUYyL3lqU2pkSGNrUXU0WEpaSlFTRmhFSGZaNHdwemlhdW1PNm02VkVH?=
 =?utf-8?Q?Vf47Pz0B1ft2x+0PYD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f060b98-13de-4d11-a20d-08de7a2fa3ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 20:50:16.3436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtxRI4ZYLpk8YSwkgce2+BWj8wgtJ3BgfqkNR4/hNrFdfPcvRT6DPTVz6YABhEgHIL6kLsUwIz0zYWA0XEOP7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383

On 3/4/26 14:39, Guenter Roeck wrote:
> Commit 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is
> missed") fixed a case where SNP is left in INIT state if page reclaim
> fails. It removes the transition to the INIT state for this command and
> adjusts the page state management.
> 
> While doing this, it added a call to snp_leak_pages() after a call to
> snp_reclaim_pages() failed. Since snp_reclaim_pages() already calls
> snp_leak_pages() internally on the pages it fails to reclaim, calling
> it again leaks the exact same page twice.
> 
> Fix by removing the extra call to snp_leak_pages().
> 
> The problem was found by an experimental code review agent based on
> gemini-3.1-pro while reviewing backports into v6.18.y.
> 
> Assisted-by: Gemini:gemini-3.1-pro
> Fixes: 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is missed")
> Cc: Tycho Andersen (AMD) <tycho@kernel.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..bd31ebfc85d5 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2410,10 +2410,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  		 * in Firmware state on failure. Use snp_reclaim_pages() to
>  		 * transition either case back to Hypervisor-owned state.
>  		 */
> -		if (snp_reclaim_pages(__pa(data), 1, true)) {
> -			snp_leak_pages(__page_to_pfn(status_page), 1);
> +		if (snp_reclaim_pages(__pa(data), 1, true))
>  			return -EFAULT;
> -		}
>  	}
>  
>  	if (ret)


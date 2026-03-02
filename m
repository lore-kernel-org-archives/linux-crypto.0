Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2332AD03;
	Mon,  2 Mar 2026 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464576; cv=fail; b=NmpU8BPBhItNPo7Qrn7tIoYs++0WbgVd+droxa0LPGeeNtiNGIisCUPdd/8wMR8tjKnqlWgU4YOsr9Hi87Je/DCPM0CoFj1fV4eysAoyi1iLXcjGxfpl91dIVnjiez1wTOWvtr3j+iXVP9DCGn1UFVbo39/MF1JzauOhlfZS/uU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464576; c=relaxed/simple;
	bh=IHpcyOyfqZHUDLxJfXEVpci4CHzYX89uQqXiqYMi/UM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rjy3cWCD5Ly5UMxvC6sHW9ZntLQg89A+gQd5kFqvSWsuzEs0UmS47mtfFtSCsT4hFY90sJAt/Bz/3uvRbsppiyoOdiPMC18Wvf0nYr2HEtNX13QM7eZY7WkFFfi2c5yOlbpb1E/1VCeHBtJmid2akSCDzfsFVLvLoqWVDuL7eiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gsIKik+q; arc=fail smtp.client-ip=40.107.208.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gsIKik+q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qIQEVTXz2WaHcaQrIKxHrGxpgCKc9LGP9KHtn9s1zYcdQ7RjHko9AaDLoiTpMJgJgtRdgHbzKNzFMrEw6X+fkmznxD+y0COjhCTHmS0NxpZkZzXHMMl5FDdu2AwRYD5RF7ZA8vHpvlP6PQM4Be2jA9OSIAB2Klm7oE3mVUqEwzHOAncERIj5JkO+EfwvKYHv8WZVKKFjixWnyZqoZhno7GfMcLBlnOLKdsJLPkGCat/ITdn08XVqEGm3Rl0DIeLhf2GKBHCO4iX1i8UGjrdVUL9nqu/MOmn3cU/U8Rd2mgbWMtJX7zIV10dCnPqEa7cQbHDmjxUbLXTjKViY55TfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkeXHdojGXfTvSUpxji4RlJQnJiGEaNp5cvz3HLGsVE=;
 b=we7M2uxVkJxmkTNaX4lzMepmt4+a2s0EfHatdb6yhj8MpUA0G2knyB5VH0GF2iVXGcnhuFl3aN4ZBxMXh9uxfUz/Y+VzLSbx/AKaJfSaaUn+v7fF3EfWMLPt4vgpBRzylneulCC/TA4rNAzlOUSnaxPPby1dr+VUrE/qDdk++5WwrBeBEG8S9u5ESBkR1JV7fut5w/slAkltoAgX/AS0Z9ozTP2NDxi+btcgq+lfx2z0xdCgEs/9cJRs3tpUIDm+6IRWyFcYZdygCKwu9mL64YfCH+who1b82hsW4OlMexdiW0noz6zm78zv8HDh2eicpyQbhoAdPYl5XR1678Nc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkeXHdojGXfTvSUpxji4RlJQnJiGEaNp5cvz3HLGsVE=;
 b=gsIKik+qV/R/gepqBFyYrARF5wTuBCCVzSs+MY7tc0KyXDHSBigycvhDGyHlXzwlsotdQae8EC6oOjd0jFkp86vaL0M7nLrFpMVG55uN9iXr7V4rDGpklyOYu+h6jDeRDFqTN5yurwurebXAVcjP3gW54inMrTeuN0Zojb2MEDQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6408.namprd12.prod.outlook.com (2603:10b6:930:3b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 15:16:12 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 15:16:12 +0000
Message-ID: <0b7e2fdf-a331-4bfd-a79e-6a85d5c858b5@amd.com>
Date: Mon, 2 Mar 2026 09:15:55 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: ccp - simplify sev_update_firmware()
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302150224.786118-1-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302150224.786118-1-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:806:d1::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b71366-5b32-4db0-e807-08de786ea3b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	JF9jFOYO0L/up7uXVEieSN5QTUXPjNTeJYdDmZqeuYoCHAtIIrWe9Cpm/CXDmcsc7sAJ3qk7xEySV5XYuEzGWXuScfv6+U4FuX4NJrcvkeBhHnUa35QudQ5cGMArd+ARNan9QWoOBN2VF1EL+LNilachRHEg2/EcDaNTkCOAT32X/HxZvU0BsbAGeGs0D8oA+aQXPA4/RJukfy2paaZF+M3j8gi1SoAz+cmvDiYBb6cEpUUBFavAePxaOtImZ0lgfZ9EHJfhEQSkkqvGmkTmEPXLJSu31BahVRnGoEKcx4rItIdaQqFWZ90y9rg1uPIxljCZyM2Nm81vR7YoZ1rjbzzg5N2EfKVulXTC3qITatS2JWRan62fovz2KQVi9DsU4T4g+mtXxM8zymVdIz1VMchCPSOSIkf20UNXgCxJ3TJNovDm+I3nPDmMa4XcYW+D8edlYewgmR3b/f7lEAs3vxmjv6cDNa+2RsYczwdRdfdt8+mIMTqFoVEvQUWTAL8AM6q1fV09DVQ/cWj6snvpbc1OQGCGra0+ApLUhg8FL8ARI2AJf/xtbG9KmRcVWrI8FYVQ6MV1XPbOSpvTJz2c/GCzeJbxL0S86XkURk7f/GOPpc4/HjHRVg9o2BaP9C9X1c1Rs4iBcM++aJwOr6Lca4VuSf+JFUGGMUpjn0nTQSmLUQ8Y7JwtVYElvuyZoxlrd18yIn6T/inFm/jTJMaDKDn/OXRAj0pm52iEAokbSJc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0hpOWxtVGtuY1dUYnY0ZDRqRDlFbVZtY3F4UC9icVQ5bFVXVnI2OUtTUFVK?=
 =?utf-8?B?RzhlUHlHVTJUd1lLYkJIWkJMdjRuYUUvaXZoalk0S1p6RFdLQjIyMWZwSzRp?=
 =?utf-8?B?L3MweDNPVTY2ZFh3Sk1nQzFzVXA4cm1SdmJFNTQwWkVMOXZwSms1TklEKzJ4?=
 =?utf-8?B?a3dlZkRTbnhuTmxhM2ZwUDB2dmwyd0VVV01xRWxoMEJjOU5uZUxFM2xjV1ps?=
 =?utf-8?B?TDNTSHIwWFlSQWFRV1kraUcvakFSdE9EQ2YvSkNNNVppTkZRMGFrVGJVdk9S?=
 =?utf-8?B?VjhmcXBsWUs3VW8zTXJMOWw5bFZDV0l1aHhwL0dzMHBqUHM5ZkdJWmprd3RQ?=
 =?utf-8?B?K29NKy9TaW82enpqR2ZxVVBQSWpMd2hTaGdyQ21kbjRoWVNPNERZN3J4TEl3?=
 =?utf-8?B?LzRzTUthUWswWmVUTjgxYXdNYWhXMmxDeGlRQUdyUERlMk8rR3RwdVM2YkVG?=
 =?utf-8?B?ZWoxKzVJV2VEYVhtVDlGWitIbVJRUWU4a21zS2c4bEpIdkdpSm9iN1BpeW1H?=
 =?utf-8?B?ODcyazA0Wmp0S1RwRm1nMFVjbmJFaGdUZjJUVXVQWVpQWU1wU1hYQTBFNGRU?=
 =?utf-8?B?dzRQeE5yWjlpNGl0ZlQrczl4NGQ5ZjV1T0lrSHBlelhkNkNnZ2dQOHBjZDFX?=
 =?utf-8?B?TXhwSW9GVmg2Wkt1TG9ZaTd6WHRiaHd2bkd5M1dEeEZ3Qm9rTWRMOTF4YjVR?=
 =?utf-8?B?eWN5a3QvcWJhOVgxeXRKUW1ESFhBV0NsSDFJTFFoMTYvN3VyUHNVWlZ0U0xp?=
 =?utf-8?B?dGsrS3kwZ3FnNG5McHh6VlBsczhlbUJQKzNBK0JLc05GKzAzUkVNWWx3WVJv?=
 =?utf-8?B?SStURExXdkZMMVdEQnRCZ050eFVyMitRZzUvUFJOSHgzZWo5L1NrYXdGWkNJ?=
 =?utf-8?B?RlYyYURtMHlDRGFvWnVGSGRNQkdTK3lZMDRiWitCYVZ2UzJxUlV2cllodWxD?=
 =?utf-8?B?QkRIMXRXbWNwSXhndDBjclU4RGxjVkJYSmc2cThBKzg1ZHNCK2F0allGYWY3?=
 =?utf-8?B?TVI5ZzBYTmhwL3hBVWV0ekw3TUpBTHRxNzRmTmlJRUtjbFlHUnBIbk1LbDBT?=
 =?utf-8?B?b2tGR3g1VTMwSURGaVh0cVFUSU9MMVVKU2VOeGpKQWFOYkhNcEJiZktnc3Fv?=
 =?utf-8?B?QWp5ZkhEMzRucmVVSDZjelRNekxPd2w3cTZ0K0dQVlBhc3dnUHlzNWlEM3Nv?=
 =?utf-8?B?dTJxTkROWUs2a2l0a0hQMGh2aUhzOU9CVWFVOTdBZGh4SVFxNTVBT0d1bHhZ?=
 =?utf-8?B?QUFncW8wT010SXJNcWkzOXk1OEtrK1VtOHgwMUZadlJFcnFHdlFKd0g5eDln?=
 =?utf-8?B?UG5JZkljaXN4cG10RTdnSjhzaC9DMFdZMXEwdXZZZWpzYWhoWUJuWTcwS0NI?=
 =?utf-8?B?bjVCdkxZekdxejBoUlZTOFdZZ1ZBYzZpMkRtSEdmYUpXZFhHS3B0WVFQODNt?=
 =?utf-8?B?M09FK0FKay9kMTlldnJPbTY3ZzYrQUk2dlMxanE4ZGE1MXl6bnFLUUFvRkdv?=
 =?utf-8?B?UlYrK1NwNjN0VmQyMDUxWWlhRTh3dXZPMFU3NWNWR3RoK284ZmJNUlhsNURH?=
 =?utf-8?B?TWNEYngraEdEcjVaNDdKeXJ3azF4OVhJSGRRU25YWG0xemlEM3E4bG4wbGJl?=
 =?utf-8?B?ZmlGL0V1a1pWakh5QzN5RVQ4OFdOYUtYdXduQ0I0UzVzUDRka2dSamZRSzRF?=
 =?utf-8?B?SFlOL3hkTDk3RkdGbGtDSlVzK012bnY5ZWNvV0ZGK2l1THJzck9xOGUwbk5p?=
 =?utf-8?B?TklDNCtoZ08rVUVYbWNaaFhCRGMxM1I3dm9GTFpBOXhndGlybVVEbGFKMDZt?=
 =?utf-8?B?S0xrZW1WTnEvUFNvS1FER2ZUNE9LRjNpNFVoWmhhYko4a0o4aEV0a0tHblJ6?=
 =?utf-8?B?T1djZlp4dVJhQ1h4OVJqVWNNMjNnNlBNaGpHTHFnWTl5VUtET0lrMnJTMTBR?=
 =?utf-8?B?TDA1V0Zzc2Q1WlJSa1BRV0Y0M3hPbEMxVklRVHoxeCt5NlcyTmVwWTZUaUVH?=
 =?utf-8?B?TlZUN1RZS0Mxa2VSSzVhT1plZE5aRTdiVDJZLzFjWFc5NDlUekh5elU0d0lZ?=
 =?utf-8?B?bzBRRGhnKzVJQmhDU1hiUVFoWldWMFFrRzNCcEkyTUwwTlQwdVdGSitXM3J1?=
 =?utf-8?B?RCtPVzlRVHhDOEgzbm5LRnpkVDVvUGhlakEvWHVoM3VISjdTT0YwRkJXUURR?=
 =?utf-8?B?U1ZUeXJUc3kyU3JBd295dGlZb2FlTHRLeFA2YWJwMUVyMUhLWXFOUmY1eSt1?=
 =?utf-8?B?bGNkYzJCUnI2Qjhsdzl6Z1QxcjBvTmc4MDVNN3R5aEN3SG1IK3RLbXNiM2R1?=
 =?utf-8?Q?bNy+H4iktX42bF9FyB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b71366-5b32-4db0-e807-08de786ea3b0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:16:12.2862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvsSbrMj8tL/nfThkrQrB7ESvhNFNroMxfIckQb6/EUk5wXORsBSptzF1QgsZOumS1ZqJAx0qglGSBZ3KoC0bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6408

On 3/2/26 09:02, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> sev_do_cmd() has its own command buffer (sev->cmd_buf) with the correct
> alignment, perms, etc. that it copies the command into, so prepending it to
> the firmware data is unnecessary.
> 
> Switch sev_update_firmware() to using a stack allocated command in light of
> this copy, and drop all of the resulting pointer math.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..c45c74190c75 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1967,11 +1967,11 @@ static int sev_get_firmware(struct device *dev,
>  /* Don't fail if SEV FW couldn't be updated. Continue with existing SEV FW */
>  static int sev_update_firmware(struct device *dev)
>  {
> -	struct sev_data_download_firmware *data;
> +	struct sev_data_download_firmware data;
>  	const struct firmware *firmware;
>  	int ret, error, order;
>  	struct page *p;
> -	u64 data_size;
> +	void *fw_blob;
>  
>  	if (!sev_version_greater_or_equal(0, 15)) {
>  		dev_dbg(dev, "DOWNLOAD_FIRMWARE not supported\n");
> @@ -1983,16 +1983,7 @@ static int sev_update_firmware(struct device *dev)
>  		return -1;
>  	}
>  
> -	/*
> -	 * SEV FW expects the physical address given to it to be 32
> -	 * byte aligned. Memory allocated has structure placed at the
> -	 * beginning followed by the firmware being passed to the SEV
> -	 * FW. Allocate enough memory for data structure + alignment
> -	 * padding + SEV FW.
> -	 */
> -	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
> -
> -	order = get_order(firmware->size + data_size);
> +	order = get_order(firmware->size);
>  	p = alloc_pages(GFP_KERNEL, order);
>  	if (!p) {
>  		ret = -1;
> @@ -2003,20 +1994,20 @@ static int sev_update_firmware(struct device *dev)
>  	 * Copy firmware data to a kernel allocated contiguous
>  	 * memory region.
>  	 */
> -	data = page_address(p);
> -	memcpy(page_address(p) + data_size, firmware->data, firmware->size);
> +	fw_blob = page_address(p);
> +	memcpy(fw_blob, firmware->data, firmware->size);
>  
> -	data->address = __psp_pa(page_address(p) + data_size);
> -	data->len = firmware->size;
> +	data.address = __psp_pa(fw_blob);
> +	data.len = firmware->size;
>  
> -	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
> +	ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, &data, &error);
>  
>  	/*
>  	 * A quirk for fixing the committed TCB version, when upgrading from
>  	 * earlier firmware version than 1.50.
>  	 */
>  	if (!ret && !sev_version_greater_or_equal(1, 50))
> -		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, data, &error);
> +		ret = sev_do_cmd(SEV_CMD_DOWNLOAD_FIRMWARE, &data, &error);
>  
>  	if (ret)
>  		dev_dbg(dev, "Failed to update SEV firmware: %#x\n", error);
> 
> base-commit: 11439c4635edd669ae435eec308f4ab8a0804808


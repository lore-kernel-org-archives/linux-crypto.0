Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90F62C0D8
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418716; cv=fail; b=JcRztxcxD0wPQ6wCYKJz1YkZrIfmzhzDcIXecQoVAo49+tfd8z2+H3wQdJOLYY8vl9tzA74a8k51U1fzDBVB8LGUp05UhvmUK739OfdhSq4fggzmc8x58OkkqcfSODXmFhlhTMxAK4Ul+/ssev9r60HE/2eiL5OI5DryanJiits=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418716; c=relaxed/simple;
	bh=uJr63rYaI7TVdLTqdh04dj8W93nYn21hrJNUpbZ50L0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K0BDZCVxNelk7Jg6K4FHWFwn/cDh05lhIv6zl6ZgBZG469HUYn85emu6i4Qm7sutjTJlg5aOPUwBGY+MtrRiB2DCmA5Q5ZjQRSLGhh8TjTmkCA4BuQPpUj+R97ZEyWbLSlHlZNmDUluAww2IwroZyNzp4WeiAgoIp1Utw0v0k00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C9/wgrR6; arc=fail smtp.client-ip=40.107.209.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C9/wgrR6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhxgFFn4L/2/maXfWxudEbUX7tT7oOFiwCYiFquoGOnMJnIbdwn5MJ2tr/G5DHav3XyrWJgxIiqgBcCP8eRqufw+OAIAaVqemdWuVETmzwvJ/YdDGTRrrkGmuR1Dko8oYsoFNOSjdG8AhSmCYg5MuVSMFiEc0pUc+8n+O5i0tflbrOlRqaV17b04LQ9G4wmKN7lHnYy5cflZ/rfNFbEg4aERgWt5SM+TD9UnjsXucMbAjPXiZ2waUAiUyIGLfA/hH4H0Cckn5ChQa6R4pHw+71nxZSw9ZfWTo4MLA7y6LFT+ad4dusukDXGL68kgmnHqXGQuItE/yRYPmOFANfmKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiAaNFrqWmGoB2+BA1HhNEOA/PQIvz4gK2OjHwuIJOs=;
 b=agjHQYvcfOUA3FGA0VMGCsFf2XCZFrpYc6e4XKzR2+B++wTZxhFrNMmFgUqqTTYBb4RlxHRJETkw+EpyIVKlY+otbN7ZsPZotZX4CZgrweb58s95F9wtp45j9lciNZTadTsNcDd3wCVyfvcv30LkFhq9lyAyky9hbW/fKi1ClgiUbDjbV5CuFLHHUNoB+33Qt7P/1FhzY1dFTeoshIzLfWRNU8m27iFbVb3XAPTmD6b8O7ah+zP0ghHtE3rf61Sz5FSdFgH5UBuEZMuobkawzCXS/0bsQftl7g2pcLJRqe3GBfSnIUoz1/1sp91acsJlYxIaUnAeTTiJA3tjnhNzEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiAaNFrqWmGoB2+BA1HhNEOA/PQIvz4gK2OjHwuIJOs=;
 b=C9/wgrR6uDTxnFAXSjqj4wUAAN+QQCt20A45kXa3gJzNTCiXs8YpFf4cKJHzPdEvui/HAvp4Mx2OY1aKomO8IWjf/6tcgutL+c+nCeDsB03R+0s6m8JdceAVo3suTcvwWx+/PXQjjYArCUcMk5G+zaMxHP/VtLkg4lQsqMqptqY=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH7PR12MB8594.namprd12.prod.outlook.com (2603:10b6:510:1b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 14:05:10 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 14:05:10 +0000
Message-ID: <afc2c5c2-5614-442f-84d6-ed4cb4cc3051@amd.com>
Date: Mon, 19 Oct 2026 09:05:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] crypto: ccp - Allocate status page outside
 sev_cmd_mutex in SNP_PLATFORM_STATUS
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-10-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-10-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:610:cd::24) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH7PR12MB8594:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b5bb5a4-fda9-43fa-6fcf-08df2de9fd13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|261009223027099003|10067099003|56012099006|6133799003|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ruosfvq3dWXrshfuI8Y5Vi3fKYsIaYBulx6Tbd4nyYrnzNYRggUPnNciyUTfz4sZ1Bl/VdnEO9mCDCH8JlIMBbGW9PYwqspx/BckjWnJ7lL7POmmeA2jB/J4fTqHO25GNP9KlQGiJgM9SU3AKgEZkshP9mnwaCI5r5tu0qM9O3XhaEh90/BVaYgPgmFnzOa++JW21yss1aIpDafd2HJNvXro47ZGjOazq7JAroU7R840USWJx2Re9SkVtQ2Hhh6YY5MdFmBssHXkgbZa7/rjeHQWAZOlC94CwU7/W/IrEh9r+Q18rmxMZHH2VMHNo93dKEjvzzRriL6Af5QyVYfXtXkek5Hn+npNP6IL/7NYz2vQV1D/bj0HrL/x8FticxwSujor/OB++xXkAG7zV8/iNrVv5mQB7lkajblZPUlqbEcB3uZhbFykCm2P68WfKSttl6rFyjtMEo9r7ZS1zavJfbXO1JEyNpbbG7bnNyMtTXRoPF1F9nT8vzS1eeB33/XhwIyOc8SwktgUbPNSU7nrLGmd7SZ6XGMn29n6aRScMY7EDNhBGMNFFpWAjNHG/T7wnmg+Z05z2ZDP5zP/dov0pBZ3Ny9/ovRlyf/RUI1cCB2rLWXqG20Stb4tGwsEtnYqP1lG1FZAqnkw36ZE8D1YSod8654+5OYa2x+j9BuyZ2w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ujk5aTFMTmNCS1c5Sm0wbzRXN2pJRUNkbGxZalduWEliUy9HdW5rNVdPNC9i?=
 =?utf-8?B?UWVzTmVvbXBOa1gvNnJkZFZ2M0c0SHpaTjU3b2N1YllqWU9LQkVxVndLQVE2?=
 =?utf-8?B?RVlubk5Kc2toWnFkREhZZ25ocS8rM0JHdWxNekFuSnFQMTBsZm45OUdyeEx0?=
 =?utf-8?B?N2QvMCtYNTNnRFdLanlUaktmdzd3eGY4WmdnNEQrUWQ4cGJZeVF3MDBnTGNH?=
 =?utf-8?B?TlFTcmZ4NHV6eGQzK2lHTjZUejBDVDJDVDlEbDExTVE3Ui9scHNRS2djb213?=
 =?utf-8?B?ODE1elk4VWxwTFdHRllMM0JuYzNCMURtTVQzUGRIWGlhMVg0d1B5Z3pTVDZP?=
 =?utf-8?B?MjEyMUx4RWdlTURVVTVadGQ5UVlYQ3F2TGVJejhndUhJY2orczR1dnkzY0Y3?=
 =?utf-8?B?SUhNbjZIY09QOFJEMUp5OVVqUitLeFg4MG83MDA0TW1xWFZhQytwQ3d4YnAy?=
 =?utf-8?B?QmNZMlErQmxxOFhjMnVZQm1zeXBUWjZUZmNPUElKSHZDbisrbWI5R3FmUFFl?=
 =?utf-8?B?S0xHTFptVHU0UVFHelgwQ2JGUGhwQ1NyRU92SDQ2MzNaTVhnV2pKaGpVUEsr?=
 =?utf-8?B?VEpKSllzSElzZnBFWUhxajZSRnc4L3g1QmxlYXlZaVQ2VUVlTWhIU3VLbFdy?=
 =?utf-8?B?Q3piUmJlMTluYzNwNlRJb1FrMC9lYUxxWHI0ZzF0RVhqeDBjQjJjMTZvNy9E?=
 =?utf-8?B?WnQ0UWE0YkJHQUZEaDZaNmxhYzBpUEFlNGFTR250YUs1dmQxMHpIUTVralNF?=
 =?utf-8?B?RXVOaU1rSjhqVzFweDdxRVpKamkwU0tVRlR1WnQvRm45NGd5U0Z6VzlVVHdn?=
 =?utf-8?B?SlBaL3dyUU9Sc2p0U3NJaGZNQXlxaWh5enltMXMwKzZNQzFXZVVYSk9HUXFh?=
 =?utf-8?B?a3RMWFZwcGtNNUdHK01kWGtNMDN4cWR5UnVFRVBFeUxMd2Z2RFhxLy9PY1dF?=
 =?utf-8?B?SWZPbUd5TjF6MGtkRXhPMnJReDRKVkdrNjhsMVFWNjBZVlQ2RWJOdktReGZP?=
 =?utf-8?B?Ui85VHA2Rkh4RDZrUEJyL3ZmQWx6T1R0MWpxc1ZKL1oxa3h5K21GVXlZK0dV?=
 =?utf-8?B?bjZZd0NLcmdJNVZhSEd1M3NzT0J4Vm9vaEtTNE52RERtZnljbUZaR254TmdO?=
 =?utf-8?B?TUk1WGVMNUVCVmlUd2NybjJCbEpiZG9ZR3NOWnRVZXVheFd1L1IvWDJ1NFll?=
 =?utf-8?B?STFvZCtSdi9yZVZJck9ZTlViUms4bnpyR01paUFydGh3d1VBYzJ3T1p4NFRp?=
 =?utf-8?B?cHlJUU1zNnpjVE9uNkttZlQwMFdmbXZacVlkY3RYbW1WSnMzVWlxejlncTIy?=
 =?utf-8?B?d3dvVmthNGpOUHNxVlNyQ2F1WEdLMUt2QWJjUm03ckVZaDYyMW9KNHNOb2ha?=
 =?utf-8?B?c0tJd1dwUCtLeDNDZmZDeEdxMVRIRUhmWmxldXJWR29wcldUM2hrUTJqWUJO?=
 =?utf-8?B?TU9MMDY1My95MXlXbVQrVUN0akthYjJwb0U5a0ZwVU9qTC9kazhWd1N6cXlZ?=
 =?utf-8?B?RWtiVkJLSlZ6STZrNmU0bllBZDhFWndzK0g5R2NCVUNQZHB6WkJybUdhbjdp?=
 =?utf-8?B?dnZDTjNHWjJaWHd4WGsvM1hsZTgvTHRNRWRxdlNIVGx5VW1lNmlpR1lPN1lO?=
 =?utf-8?B?SW5kTTJaaW94WStYdkJFK052Y2JUeWxNUFdlL1VzMm0zTGVlMXFDdlJ6d05a?=
 =?utf-8?B?WEhUUGNQczJiSDFsclk1R1I5OU9yVzI1clZudlE3aHh5NCttczZhaTM2a2tF?=
 =?utf-8?B?bk1Xc3MzUkZUV3pGZFBsa3hJUGRlQ3NjYXgyOFFqOVdWYWZJdlhhOVBhcjVY?=
 =?utf-8?B?dkUvWm0vQlp2dGVhTWdscDZyTGJyMFZhUGxLUzdpVXVHSGh3NkhzQW85RWFF?=
 =?utf-8?B?azVWNm5JdWkrT0Q1VmF6elRPK2RNQUhOcnA5VlgwMnFZb0dqTTFmN04zZ05F?=
 =?utf-8?B?MVFDNS9KYm1uV1BKcUlDR3ptVGZENTU4UjRBU0xydGhUV0J0TXJpTUFYUmFu?=
 =?utf-8?B?R0RtL2d6OHdiVjR6My9HKzJxV295cksrblZLQy9xdndKd1o3QnV1WFBxTW8x?=
 =?utf-8?B?dGo3aHQrcTNjZHNpYzlUcnFhcW5tcjlPYVF1K09Zanl2Q2dHaGRIcHRUVVll?=
 =?utf-8?B?SG9VcnFJNlV4c3M5N2RWempGbm1KaXN2VE93RWQvNW1kTko0NENwMXhTT0gv?=
 =?utf-8?B?OU1nTDlYeWxUS0E4ekJ4K21XMmhoNXVCSEM4YmxSWStSQ1JjWkk2dmlGVnkv?=
 =?utf-8?B?QkFlMDBBZXQ4QnhkWlNDMzF4c2JkZTYvTXErT21SeFdTbnFHVCtuZ3ArVDZZ?=
 =?utf-8?Q?bmrGGP8R1k1uZT82lB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5bb5a4-fda9-43fa-6fcf-08df2de9fd13
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 14:05:10.7886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkJNx0UbDJOFnABrx1l/oyIG5r+O7urKa5qUaSJEIFBMZQCvfcY/aQklE9LiXDPnCzEyWyCulB8wt3NiSFR6qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8594

On 10/15/26 23:09, Michael Roth wrote:
> Allocating memory while holding the global SEV command mutex
> (sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
> across the system if page allocation stalls. Handle allocation/freeing
> outside of the mutex instead.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 62 ++++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1e017783dd03..aa4f0fd731c0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2532,8 +2532,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> -static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> -					int *error)
> +static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> +				      int *error)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	void *data __free(free_page) = NULL;
> @@ -2544,31 +2544,36 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  	if (!data)
>  		return -ENOMEM;
>  
> -	/*
> -	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
> -	 * when SNP has been initialized, the status page must be firmware-owned.
> -	 */
> -	if (sev->snp_initialized) {
> +	scoped_guard(mutex, &sev_cmd_mutex) {
>  		/*
> -		 * Firmware expects the status page to be in Firmware state,
> -		 * otherwise it will report an error INVALID_PAGE_STATE.
> +		 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
> +		 * when SNP has been initialized, the status page must be firmware-owned.
>  		 */
> -		if (rmp_mark_pages_firmware(__pa(data), 1, true))
> -			return -EFAULT;
> -	}
> +		if (sev->snp_initialized) {
> +			/*
> +			 * Firmware expects the status page to be in Firmware state,
> +			 * otherwise it will report an error INVALID_PAGE_STATE.
> +			 */
> +			if (rmp_mark_pages_firmware(__pa(data), 1, true))
> +				return -EFAULT;
> +		}
>  
> -	buf.address = __psp_pa(data);
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +		buf.address = __psp_pa(data);
> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>  
> -	if (sev->snp_initialized) {
> -		/*
> -		 * The status page will be in Reclaim state on success, or left
> -		 * in Firmware state on failure. Use snp_reclaim_pages() to
> -		 * transition either case back to Hypervisor-owned state.
> -		 */
> -		if (snp_reclaim_pages(__pa(data), 1, true)) {
> -			data = NULL;
> -			return -EFAULT;
> +		if (sev->snp_initialized) {
> +			/*
> +			 * The status page will be in Reclaim state on success, or left
> +			 * in Firmware state on failure. Use snp_reclaim_pages() to
> +			 * transition either case back to Hypervisor-owned state. If
> +			 * for some reason that fails, it will have been added to the
> +			 * leaked pages list, so indicate to the caller to not free
> +			 * the page.
> +			 */
> +			if (snp_reclaim_pages(__pa(data), 1, true)) {
> +				data = NULL;
> +				return -EFAULT;
> +			}
>  		}
>  	}
>  
> @@ -2586,8 +2591,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	if (!argp->data)
>  		return -EINVAL;
>  
> -	scoped_guard(mutex, &sev_cmd_mutex)
> -		ret = __sev_do_snp_platform_status(&status, &argp->error);
> +	ret = sev_do_snp_platform_status(&status, &argp->error);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3086,9 +3090,7 @@ static int get_v1_svn(struct sev_device *sev)
>  	struct sev_user_data_snp_status status;
>  	int ret, error = 0;
>  
> -	mutex_lock(&sev_cmd_mutex);
> -	ret = __sev_do_snp_platform_status(&status, &error);
> -	mutex_unlock(&sev_cmd_mutex);
> +	ret = sev_do_snp_platform_status(&status, &error);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3103,9 +3105,7 @@ static int get_v2_svn(struct sev_device *sev)
>  	struct sev_snp_tcb_version_turin *tcb;
>  	int ret, error = 0;
>  
> -	mutex_lock(&sev_cmd_mutex);
> -	ret = __sev_do_snp_platform_status(&status, &error);
> -	mutex_unlock(&sev_cmd_mutex);
> +	ret = sev_do_snp_platform_status(&status, &error);
>  	if (ret < 0)
>  		return ret;
>  


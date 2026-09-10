Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0536496D20;
	Thu, 10 Sep 2026 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789070991; cv=fail; b=lVUjPfEboBAa/yXTwTNYK3WJpdVrDz4w7uP8lmor85GFLf8PpuW7EQ/HkKofKHFJa7rEPGkehbk49ZmSD0b24OIhr8YCtg+arGb65XII6Slsrr1+6xVxNmQ/Q3VqNslHfnZqRUh/z/kGhv8DTPaNj+NmNF5Y8GqVf7ko2OUGp1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789070991; c=relaxed/simple;
	bh=OrU3m8D3HCRndA+c4c2JwWGAh1ptnva0Cq2D/eGDG+0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qzZ4w09PgeCSSQOHbE6fUWZtxwiuPdq5MujVaWQKbJylDoyV7q/7l6GHUhQxXkvP5P2wa+Znq43duvs5Au1D2I6u3nfKRPVDLtSTvGyETe0lBNXe0fD3ccuwsT5+dqEGJCpc3ZyQH0Bldoz1XZN9vsERe12NX1B8xgUzjNYpdwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d8VRguB4; arc=fail smtp.client-ip=52.101.62.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d8VRguB4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKY9jpjdURr2UNLBUvQB9c0SduV30da4GbGGmD9a4JTQfLwPL9Y/g8InLP0wHNACcTnMCYITvGQMEg+jZ+yXyGChWDg6qpmeaziYYmtn6PWGeQcIi98IxnOXmpTfUhn4bTvWUyVdKIqo2C09D+AQC06yGRIovdzEpg4Al0VHb3ojm2ZQBzJfq5Edtjiah/WgkzEjVeW8kAqPTsX7Sbjy7wBFTuCeQsm8ygBQ4irRsBxjNaaUbNJUAMjftw9go0u7ypA4ae6K2wDsXZubVZKGejTOeSYqUwlYwtEVah7mxnVNaPNqtCN2njwvofCw7TvXBtrqleyO6X5gyvO+qQmYug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKMEv+pEdKXd196dN1+yKGXwAcUUOqIw/7y64K/hcxw=;
 b=ZlAYkvvFrASFiXg+eTL4u0tn5CfnR4/HoOOdwxyNqF714ZOFyYBok0qccwITfqoJ0eVOqWMTX+aS8IpCdnApS8LzHxbQ5NftTKzN8oRANZ2jLAGn6bU7GFZDwIdwzXrbynbbJFq1rAdB2TIImQog5lqXREkP50xz1+CPNSxFLJ8DyhuKm/JAT7UFveyyDpey+izslC2u8KkVwQGhpbDSV+qSmlECChD6N/ZbkRUnr7noTLEpNSZjrSF7IqkwfSfhLoCp2ZByJoS/yNehRnE6XUargFsZFQt+tFFW0Z/THULoacT3BBXh55qlEAWA5W2VMggfC7llT33ifrYEXb8wYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKMEv+pEdKXd196dN1+yKGXwAcUUOqIw/7y64K/hcxw=;
 b=d8VRguB4EINmMnEiwFaWNqML5qmCeGeAb8U2k1RrDjdX7FZBngtR50XIdQKBLNlDdtZv6YLsyL4yKj80MHj4SfMPruxta/V88mmoKkKaLTAVcjYPm8Rrc2ynYh7nUFQyKyrnGNR2wQixY6MDQFlaZt9T/AdeCapuLMO+xvvvotM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 20:09:40 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 20:09:40 +0000
Message-ID: <e3040c1e-1928-4552-a775-aa9d9925fa9e@amd.com>
Date: Thu, 10 Sep 2026 15:09:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] crypto: ccp - Allow SNP platform data to be queried
 after SNP INIT
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1789059391.git.prsampat@amd.com>
 <acb69b69796f5324c41dfd7a1f207044f1f18069.1789059392.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <acb69b69796f5324c41dfd7a1f207044f1f18069.1789059392.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:610:e5::7) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|MN0PR12MB6101:EE_
X-MS-Office365-Filtering-Correlation-Id: daece1be-40d9-4f53-af88-08df0f777237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|5023799004|11063799006|10067099003|56012099006|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KJeSzHUbES+0JA4NxXlEc151xsUBUjA5cH2NMTlenuaRxAj4gss+Tky2In/9UZbMYWsMesK+FRrrpiLhMQ5uT05ugWROXGMPHvpuXr1kD7ndykmrcN1cy/8arLVL3TQ9y7d7OFPydmKDA+R+iQGWitb5kizguzE/r/Np4gw9UVz7Lbv2sWdb867Sz/RgX6cl+Q7L2Z8eD6e2ZLp0R2BdyLwruFkeCGkXnNq6jpoaVjIen6ADpeT7vXnfXEi7fHJWgM1W7D3KZjKvdU9o+7p3tVW43EqnrIbM8fay82bt3fCWnrX6ptmzTjaF7fVgYw5gwrAh1Uy3LLhEDvx5paV3BvkEgxXWoYcdADFU6imqZ5xz7pBqp068Fubo4dDrhdmwLXsKekSWEDjXQFwWAYjMTqOtW/rPGof+2JBxuQ1CeUcEHCjFjrti5XL8FLorAfS1q/4a1ig7hGWTwnNylYdmp5yTuBSKgm5TxSh/y45/hXM9/zqvJLoQQfDH3uPMPRRJyXRyfClJFij3vLEi6XBTuFb68B2VxHlxgh5Nx12MxOogwMTs7cTqoxNWw1ZPAePIJownWutEMXLmb8+kk8Yjd6kJJU9Xz8sq731DLOXfe9v0/UHNkl+7lFMwsfTI9xcEiyVq8rgItaqUq5FhioCIUjqKK656syCbfJCsQetNuRo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(5023799004)(11063799006)(10067099003)(56012099006)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODNnVjlzVzlGdlFVR0lJV0ZYOFB1cU5WbS9xT2ZUd3NUUC9ERUJrWmI0MmN2?=
 =?utf-8?B?R3AvL1pGaW5helFGZHdBbUhsRU5nTEZEMkJQOUpOQ24xb3JpRk1qU28wTmlt?=
 =?utf-8?B?ckZEbFpMWUdLdUV5VTA2bFJqalQxSXFXeVFQYkY1ckx2bTBGYVgvU0U2RVh6?=
 =?utf-8?B?VDczRkxpcUNvSWMyNzRiZ3B4dmk3Yk1BeUt1Q0s2Zk5COXdQY3Bydzcrc1No?=
 =?utf-8?B?NkljWTBqQ05KNEhvY2JJdEs5U0cwTHgwU0JkQjN1QXEvNG1KM0tzem5lZ3NP?=
 =?utf-8?B?Z29XVGRISVQzUy9meWpVakVsZFhhdkpqTTl2MXRpMEFxQUZHdU1ENkkzeENt?=
 =?utf-8?B?bEdrRGI1NXJITjQ5OFJPMUtBRWNJdHFFdzNFL0ZYa1o1Z0ZXQm9TNExVaDli?=
 =?utf-8?B?UC9ua3pIWnl1YVJZWWxYY241dzRIZXNlc1M3bElIdnBKUFhJTDFtNEU4ZHR2?=
 =?utf-8?B?bWdIdW16eWNHQ2piMlFrV2NHR1B6QVJjc1JoeWtQYWJIN1hSdDhyMEcwaWR3?=
 =?utf-8?B?czFKMTdmUlBTVDgzY3VNcU44K0dHRTRXTDBaQUpXMkd1RTNnbWdISmQwWWIv?=
 =?utf-8?B?TnR5Y1ZkNUtOaS9VekdnN3VndEJ2NXl3aVh6bUM1QkZXd0pnb3ZOcHgyaTU3?=
 =?utf-8?B?N3pHSFJ5TGlIWlh3bHo2TDA4TWE4T3MrZjBtY3k5RXZFdXk2ZE53NzB3VUl1?=
 =?utf-8?B?alNIZ292ZUJSRWw5M0tma0E4aksyd28wUVUzZE1RQTljdjQzcDgyYlVISGlX?=
 =?utf-8?B?MXRURG43eEZTQzlXeUJXWEg5TFp4ZjVmaktzNWNTdDFqTHhhSzBpV0lhTUhv?=
 =?utf-8?B?VlNtRy8xSDI0bm0zWXFlYk5WdDd1VWM2RENLVjY4ZjNZZ2xMTmFkelgrbzNy?=
 =?utf-8?B?aHQ4UlFvUlhQdVlnemVRVXJNVzRnbWFJTzNrVjN1RllBQVkwWjY3TnlsSVF4?=
 =?utf-8?B?aHBhd1Q4czNpTisramlVMkJlUk9SZit4S3lhemFzODZya25qQVhqSWI4b3dF?=
 =?utf-8?B?UTNnbWxLRFFuWEw5alRFMHp2MXAzOTYxZUVod1lrNkR5U2l1NkN1TmhhdlFK?=
 =?utf-8?B?VU5sUDZ0cjVZNytOMU83ZmJUeXdFMkJtRkVvZHdHMVJqT1ZqT2xLQk1sNUoz?=
 =?utf-8?B?ejFzdk9hUjZvTlVFbC9zd2NYZThDcXdmbmNFTGc5ME5QaFZNL0hxdUczemJI?=
 =?utf-8?B?eUpQU2gyYkVvbXRGd2VLZWFJWWlzK2o2OWp4YVJNQnJXRGxpYlk5SDF5aU9h?=
 =?utf-8?B?S2tlVjRTdURoNklZL3U0UGw3VFgrdkpqTFhhZEpsUlplTDdmdDZKMWl1TEN1?=
 =?utf-8?B?YW5STkJLWDROeGcwaFRFV3BDV216alI1bTFzTUVHdWU0cHdvZzhoaEZmOHFr?=
 =?utf-8?B?dTlEYUd3VVNySHgwdUIyL2x2dnlaODJxbm4vaGRSSWdUckNoeGxhenF5VzFh?=
 =?utf-8?B?YzR0RFBKekxwSGdSL2p4S2hhb1hmSFRHdGxxQ3NTVEs3WWh4K29GRVVCT1o5?=
 =?utf-8?B?QjRFcXRLeWR4d0dmTk9ZK3BrbWVDWkdMQlVoMk40bjNYWEhyZ3pFQ1poa1FG?=
 =?utf-8?B?L0J2OVVhazJzY2IrODc1OHJZdjFTQWJETm14RU8yTXZCTXdmNlBxVjB5SEVl?=
 =?utf-8?B?KzNyOUtwNTNWYzlDa0o0c2xuRVBudnpoR0JlMjdTaTZ1NmpDMDRjaVRwVDBa?=
 =?utf-8?B?RlMxYys5TkVleW5tcXozWkVZMHNFNDNWUUMrVGdCRkNQcUZKZmhua1o5b1ZV?=
 =?utf-8?B?cUNkYkxGQnI0YUtqUHlCOEo3LzR2V1VDMDdWTGprUVg5V1duVloyWjIzcWRP?=
 =?utf-8?B?bWtUZFA4MUZpNVNSMnZzNENuaDFzYWRPQ09KRWdoYm1qZkw0SFVjVFFOdFd5?=
 =?utf-8?B?bVdTaitnand6c2pGMnJlSllzTnZ6SEVqNU9xRG8zRHNWQjVnb2kxVnFVSnpl?=
 =?utf-8?B?L0RiZy9sZWV0eUtXbGp1WFFKc2hjS2JxNi9ocXdjSUFldkw2ZU15c05WK0Qv?=
 =?utf-8?B?aUpOQ3lWaUZVbXFYZVdpVVhWckl4UHh3TTJqdjhlWE1nbnRGdzMwRnFTQXhx?=
 =?utf-8?B?NFBJcHdsUXFMU1N2SnBvWmlibm1kOEE5dVhtbG15NjZBeVZEUjFNY21vK0l5?=
 =?utf-8?B?ckVuTWM2eDB2bytSZDRmVFF3QTNRTVVWTy9VNWpOczU1S2dLUnMzWGpNRXln?=
 =?utf-8?B?aEZ4eUtXN1V6dFQ2YndUaTMzYnRzZGVGZDlsNlMyTkYyV0k1S1hCNmZFU2xM?=
 =?utf-8?B?TnhhcWczVXVPdlphMmlpZWJ5clBZSkJUazFvbVlxeE1OR0FYTFZHUzNPUExD?=
 =?utf-8?B?bjgrTkZxNkdkbzFiWjlLdHVjUXVQNENTRTk2bk01QTNuK1JKSXRxQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: daece1be-40d9-4f53-af88-08df0f777237
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 20:09:40.3873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYH3CAUR4swZUAtc1VJHtHWKCzacP9/IhEPORrI2yUfrEzR0/Rk4QNV0sMmFfOjOn4J9bONjE7O0/EMTDg/KhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6101

On 9/10/26 12:02, Pratik R. Sampat wrote:
> In preparation for refreshing the cached SNP platform status and feature
> information after a successful firmware live update from
> DOWNLOAD_FIRMWARE_EX, allow snp_get_platform_data() to be called while
> the SNP firmware is in the INIT state.
> 
> Once SNP is initialized the firmware requires the output page of both
> commands to be firmware-owned. sev->snp_plat_status cannot satisfy that
> as it is embedded in struct sev_device, so use
> __sev_do_snp_platform_status(), which stages the output through a
> dedicated page, and mark/reclaim the SNP_FEATURE_INFO page around the
> command.
> 
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++++++++--------
>  1 file changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1ed9e61a95cc..e891d6d1c6f0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -131,6 +131,8 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
>  				 unsigned long reason, void *arg);
> +static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> +					int *error);
>  
>  static struct notifier_block snp_panic_notifier = {
>  	.notifier_call = snp_shutdown_on_panic,
> @@ -1261,19 +1263,12 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  {
>  	struct sev_data_snp_feature_info snp_feat_info;
>  	struct snp_feature_info *feat_info;
> -	struct sev_data_snp_addr buf;
>  	struct page *page;
>  	int rc;
>  
> -	/*
> -	 * This function is expected to be called before SNP is
> -	 * initialized.
> -	 */
> -	if (sev->snp_initialized)
> -		return -EINVAL;
> -
> -	buf.address = __psp_pa(&sev->snp_plat_status);
> -	rc = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +	mutex_lock(&sev_cmd_mutex);
> +	rc = __sev_do_snp_platform_status(&sev->snp_plat_status, error);
> +	mutex_unlock(&sev_cmd_mutex);
>  	if (rc) {
>  		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>  			rc, *error);
> @@ -1302,17 +1297,46 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  		return -ENOMEM;
>  
>  	feat_info = page_address(page);
> +
> +	/* If SNP is initialized, transition to use a firmware-owned page */
> +	if (sev->snp_initialized) {
> +		if (rmp_mark_pages_firmware(__pa(feat_info), 1, false)) {
> +			*error = SEV_RET_NO_FW_CALL;
> +			rc = -EFAULT;
> +			goto free_page;
> +		}
> +	}
> +

You could change to use snp_alloc_firmware_page() which will allocate
the page and place it in the proper state for you.

>  	snp_feat_info.length = sizeof(snp_feat_info);
>  	snp_feat_info.ecx_in = 0;
>  	snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>  
>  	rc = sev_do_cmd(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +
> +	/*
> +	 * The feature_info page will be in reclaim state on success, or left
> +	 * in firmware state on failure. Transition the pages back to
> +	 * Hypervisor-owned state.
> +	 *
> +	 * snp_reclaim_pages() has already pinned the page via snp_leak_pages()
> +	 * if it could not do so, which keeps it away from the allocator. The
> +	 * reference taken here is dropped either way.
> +	 */
> +	if (sev->snp_initialized) {
> +		if (snp_reclaim_pages(__pa(feat_info), 1, false)) {
> +			*error = SEV_RET_NO_FW_CALL;
> +			rc = -EFAULT;
> +			goto free_page;
> +		}
> +	}

And then snp_free_firmware_page() here (after you copy the data -
similar to what you did in snp_verify_mitigation()).

(I think the same changes apply to __sev_do_snp_platform_status(), but
don't worry about it for this series)

Thanks,
Tom

> +
>  	if (!rc)
>  		sev->snp_feat_info_0 = *feat_info;
>  	else
>  		dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>  			rc, *error);
>  
> +free_page:
>  	__free_page(page);
>  
>  	return rc;


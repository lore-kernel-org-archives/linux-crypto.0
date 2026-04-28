Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944CB74C14;
	Tue, 28 Apr 2026 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777413786; cv=fail; b=IjfJDtw82Y2fhCy1m6rftgCl2Sck8Npr3obQaPIRkq8XjnTcd1hAErPsKskT+5Gl5ko0YHRsVBH2kCHE3zRjS95RnYhMEz9NE7p7MZazx7Hh84Ec3wWopNDxGcLRSQ5gXoYjaFSWPYG/ILLZ4Q19O5KXHG9M/Vn9UY1URgxG9cE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777413786; c=relaxed/simple;
	bh=wHbilqfl4e/Bft6UsKqSSeKkOMh5QCELh6k3VWCRdjk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R+A43ebX1PNvuFfy5y4din0U/Jq3h/Ma+Dq5Jp15W8kbdhBG4Tsb+PZO59pV/APyoRSZP9CYcpZZ5vuwoVVbY/gnSPtTtpqB7dibupKSuu0T7UrOfnQ/HXHvqoGIB45cWFFe8jUQcGZ5O0fzNbOfUg5LXu/P6XrdkJ829DoF79E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IUWxY3ra; arc=fail smtp.client-ip=52.101.52.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IUWxY3ra"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AfElCFLknsFt5EhoXccmLwLUv0nJItLvNUj08adF3vlT8fW5phoqIjLa8+cEp0jHpHlWdUfEA3nB++YoMvMmFUkQK0l/8c+dalzHcCpgIoFCK4m8qJJF4a1e8ySFEnmWKLtDfqLiYjnIVY5JAfNlY37NnpjR1aimMiKOlymYuCY91tfHaTbUHe7r9nZTZbIdIEiMjKkYUUWUw9k0B5pDgt4/pMYLDLud54kIy/LLs5yYgyd4QGLjeySZffHuizOCZ0wiqymKE39R+Aq/9sZqVRWwWezuuPSTOVPy5yniI16IFS9sKy+2qZwSvxD5SxBwu0l4himeE77WLS7N5rJi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLQax+UM0Atv+8t6XSrnxB11WWpeiYMphCKhnmlLfd4=;
 b=ebkShOLC3BlfOnmtO6oxBy2h7ono6HgMQ4YRrLVGDxAQX3e6P6Az93vbRdEAKoWnxO1UDyJ3qPHagf2LK/dUbewJ9W38hwRtO4MvhbdnVqfDrYNxAKqCBkzRjqY7V6q2fKLYOed3oEFeyQLABworR+p2S9SNVvu/PFx2flq+H57yScEI0zG86RpckxMZf8t9Jr77i2m5VGw2UPc4lx66FLET6Jp6As1hgbmW1bCz0HkvN10SBQx0F4iqb688I6DDQUCMv5sfNT/VIUSYBfySGs+b9grjO3ZYlRQrS7CzZr3jCDCVp7IZQukNPXMsLzELZw48zZElQVghKRKjrpbK2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLQax+UM0Atv+8t6XSrnxB11WWpeiYMphCKhnmlLfd4=;
 b=IUWxY3rajylIyVkD/G4U8t1kCgwxqaWJMr+PoJYkLZneGFbs67hPluRmiJRTEkZ1E1QK8buJWgkIEgWz70yqpscrvzFhYZ2mJujbpBH+WZIFxJxpqUDvan/SOdxD0MTjMJG8Qq5Q6EyZw4xNJfZccXPXCZ7+GzqFgtEicAOeqV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5966.namprd12.prod.outlook.com (2603:10b6:408:171::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 22:02:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 22:02:55 +0000
Message-ID: <6846489a-4553-47f8-ac32-97fd07736cb4@amd.com>
Date: Tue, 28 Apr 2026 17:02:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_VLEK_LOAD)
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-4-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260427161507.32686-4-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:1ca::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa2a692-25e9-4f2c-eb23-08dea571e671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5FWbWjQT/4Ul4bfdfmbUjqJSJNsJ1vczTdGKY0NTtwgZtolAQyZsD1wGZrqK6pf04XDHprjKKGBLUwUrBWq/g3cqwtGnOYOMuSNhxrUTI9tqib8mcIBGz7zlcC7RM7CmvQvT4wpUr8UnzxQAjZdYq3Z8aRJM7gef7uR31iKbyqkaDQM+0ZbIykhe8qTJn/XpG4S7xX8Y1h8UXnDDpzhCPDbDJ1fb24WH0Tna4hJUcMUoyF+XbCHO7Fmeq6NF0we/v3ceOfs5rTlJuCIt6+Yxjoij7COcI81srJ+il6uQtphpUvG+AJpoDcWhP4+BykaeEDDO3Ft84bMw0kzKg5FbyxITtSu480x7qqG3z0Cf3S8NiD0FERyzZv1WD6P3vAp1Hd/xHRZazVKw1l+OCHLcpLn/BlM6oZkCFvhZlc5nWhMQhGQd/I1NMFRRoNasRL6gwe486Ov2hy8SDLZ0HVino2cv558aRribecFk7zquVp1L3PuD+O/mG90xXN5+2wMrbwgC5lhrx1x//BMI7kJlPCmmk//b+zDiKj6ISsY7tvJ3y+sgBd6umFiBwdmGTJyToWv4oLTe7ZDLSg9jprFe2k69O075Ywz7gTjr+xglI3qe8FK/z6O4Bncs87UW5YqrYAaRcOV8exjindL0mX8YBw4iE0VqLuHZfGRhJRKuxkJTx46fOqme52q7q7Ms9Ysk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUl6MjFZcXBvT0hYKzNmcEpaazNkdUVGZHh2NE84VHR0d2kzK1k5S2RhenQ0?=
 =?utf-8?B?VXJya3M5aDNtMWY1bzZEWXh4ZXl0dTFDQTllcWRTM095bWg1eTMxWG0zaEsw?=
 =?utf-8?B?blByODZUNGJadkltQ3ZsUUx5NFQwaWVDSGhiYVloUGZtakZsNGpaUlVNRFhx?=
 =?utf-8?B?dUMydThYODRVem5sbFVGbk1YRWhBVGEzSmdBZXUveldaOXIwZlNPdHZZU2pN?=
 =?utf-8?B?MnVCZU56SzQ5RTB0alo0bmJ5NUFNMUhuZEFoRVN1Zi9aMzhCRHZoaGN2a3FS?=
 =?utf-8?B?M3dHNVh1RGpvRXNKOTFwcGVXUGtQOGR1TlBlYkZYdVd5dUcrQ3lyYjFMNHNn?=
 =?utf-8?B?cmFZRFVrZlQ2UkhKd3cwTmwydnp4SS9rZ1RLK0pvMUZHbnZldG5jV0xvVm0w?=
 =?utf-8?B?SlFZRUV1K0ZTS2dMclQvOC9SZHYvL2k5RFBUTEtibWo3cXViM0hGb3ZsODZ3?=
 =?utf-8?B?M3lWMWFMSGZzMXExcFMwSHIwUXk3aTZqcmtPUTNhcEpnM294cmZRam1wZTBV?=
 =?utf-8?B?alpkMzg3MW0wOGpFTTdJWDVObTN2QkN2Wi9NTzFtUWh0UFVNNlR0TmVlYVYy?=
 =?utf-8?B?RytHZFlpT3oxbXJ2ZUZQMm4va2o3UVI2NjFHcS9CcU1jZVlqaGp1R1ppck40?=
 =?utf-8?B?NThSK1hwS1d6N0x3YXhEZnBBaklSUFFRRGgxUUk1bjJqRjc0MjJ6UU4waWxX?=
 =?utf-8?B?YThIWkMxWitqN08xSEFYZVBzbFdzZm5WREZ5U3ZQa09aMlMrdXZ4eDlqem9E?=
 =?utf-8?B?Vm1haHY4RllqWVIwb1ROQlhoa2ZGb25ick1PNHVUcCt0blhJbGtkWDM5Z3ZF?=
 =?utf-8?B?c2hKZWRwWDZSc3BtVXdWQ0pDdmV2aWluNnRNQ2dBelF0VE5zekVtbSs2cThL?=
 =?utf-8?B?eHdDbVdqbVRkM3l4cjBUdFdNc2oxRFF0eU1maVk4YWxGYUdDbXZCNFZjV3Yw?=
 =?utf-8?B?bzNXeU1ra3ZsZnM3ODFIRU1pUHZTNmFDUS8vZ0cwQVM0YTBkbC8rODhrWUN2?=
 =?utf-8?B?by83NXlLQ3VjQnVGVUVRNkNzNnB4ZkVsRnZ4Um9zR2ZXRjJXRytoTWZMZU5j?=
 =?utf-8?B?ZGRPN2tYUEpPVkJTZTZXNnJacVNRZW42Mkh5Yll6a0NLTFBsck42dVE1NGFm?=
 =?utf-8?B?bVMwN2k1V3duQlBWNFEzQjFVZ0NGMXNmeFlVdHpteSs4d0NWbksvOVlMako3?=
 =?utf-8?B?Umd2eGxqYXdFakYyN2E2Rm9Cd1VDL0JsVXZkOHdpNVJ1eG92NXlOQnlhWFlG?=
 =?utf-8?B?Q3R3T1VYU2JTQTlMdjR5NzdlZ0Jsbk00OUJWQ0F0ai84ZTdwdUgyY3FSVWUy?=
 =?utf-8?B?ZGRvb09CV280cGR5RnNUa3psQXFYTmg5ZThDN0hFUFYxaDR6VWVRS1h1Nm9D?=
 =?utf-8?B?a1JxeFVjNzl3Wk5naGZSczZ1bXgraU9SSVVrL01MSkkzekphS1FtSE1xbVJP?=
 =?utf-8?B?UG5XL2dSUWZrS3BPWHRiVjNYMGlQVjFQWm1ud05mM1ZWZjB0UDREdVdnOTRy?=
 =?utf-8?B?OTFmbnRTZWVFWDh5b045YmpXY0dsMlhGa1c2eThaV2g2dlRkMDNuN21vS3Ex?=
 =?utf-8?B?Nm1CRlFWZG1IeWJvVGhWS0xRK0Ywb0ZMS3JSNDdxZGlDTkc0V3U5NllDRC80?=
 =?utf-8?B?VW5pTUxhbGw1bnRGVlU3L2ZPVjVxa1hKaWJ6MW44S2I5NGVoVXAvdlhyQVky?=
 =?utf-8?B?a1NGeVNla05lSDV0ck8xaDRLdnNETUllWmhMSVZLc252cDRqUjVWVkJ5STJv?=
 =?utf-8?B?UzdRUllzM1h2eGkyQnh2MzlOdHhZa0p4VlNRa0pqTU5uTXpIOG1XNU9sOS9I?=
 =?utf-8?B?MXA4Rmo3T3UzTEI1MzkvSGZ0U3FRN0FuQnJOSUxpQWF0cGFWZ1NZVkdmY3c2?=
 =?utf-8?B?MGVzcDM2SlVzaWJwTWVlS2xtc0Q4S3Ayak5weUtzK1ZTVG13WnU5RzBhVS83?=
 =?utf-8?B?d1cxMisyb2hlUHp6UlVxTFkzcVVadmswQTArM3laTjhlRE5vR0NycGNNc2Jv?=
 =?utf-8?B?eGlDMmlCR3ZLbFVVRHpNUWliRlp3WlhTS3lPTmRWUUR2aUlVU1hSd0hCbDc4?=
 =?utf-8?B?T2ZCUnkvZzZrYmpPSDN1WmtXeDlYb1lmV1Z2MndVUTlYR0lsZ2NVNWE0ZWtL?=
 =?utf-8?B?TnlZOFR3MkFFcXY0dnNaUkRSMzAwRS91QzkyYUZXYVJTaDAzZkRTeWIrU1Jv?=
 =?utf-8?B?SVp2T0RabmluaUJZeDJKajErTFZjbjBQU1Qxai9FdnF2ZFpTcjlldGx6NStu?=
 =?utf-8?B?Nk56QktEZUZPTVdVbXpDMlRVM1VaNm5NT0tlU3hCcldDVmJvUXdkUDduQTlE?=
 =?utf-8?B?Y3ZRWWdOWTl0QzdhNHF2dzlzNTdncTEzYjJYWWt2YzBVVGYwYVRGZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa2a692-25e9-4f2c-eb23-08dea571e671
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 22:02:55.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYZzzxDl/UY4ecSD9p55cPvnYL7ea4s1Vdj96uiZNcnYqb78M7LutDicoTGLvxZFBN19C9sHR+4wmuW5gpa8wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5966

On 4/27/26 11:15, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Sashiko notes:
> 
>> if SEV initialization fails and KVM is actively running normal VMs, could a
>> userspace process trigger this code path via /dev/sev ioctls (e.g.,
>> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
>> execution for an active VM trigger a general protection fault and crash the
>> host?
> 
> The SEV firmware docs for SNP_VLEK_LOAD note:
> 
>> On SNP_SHUTDOWN, the VLEK is deleted.
> 
> That is, the initialization/shutdown wrapper here is pointless, because the
> firmware immediately throws away the key anyway. Instead, refuse to do
> anything if SNP has not been previously initialized.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Stable?

Minor comments below.

> ---
>  drivers/crypto/ccp/sev-dev.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 572f06368d4b..e8c3ac6d989a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2481,9 +2481,8 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_vlek_load input;
> -	bool shutdown_required = false;
> -	int ret, error;
>  	void *blob;
> +	int ret;
>  
>  	if (!argp->data)
>  		return -EINVAL;
> @@ -2497,6 +2496,9 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  	if (input.len != sizeof(input) || input.vlek_wrapped_version != 0)
>  		return -EINVAL;
>  
> +	if (!sev->snp_initialized)
> +		return -EINVAL;
> +

Should this be moved up to avoid the copy_from_user()?

And should something other than -EINVAL be used, maybe -ENODEV, to help
distinguish the error a bit?

Thanks,
Tom

>  	blob = psp_copy_user_blob(input.vlek_wrapped_address,
>  				  sizeof(struct sev_user_data_snp_wrapped_vlek_hashstick));
>  	if (IS_ERR(blob))
> @@ -2504,18 +2506,7 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>  
>  	input.vlek_wrapped_address = __psp_pa(blob);
>  
> -	if (!sev->snp_initialized) {
> -		ret = snp_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			goto cleanup;
> -	}
> -
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
> -
> -	if (shutdown_required)
> -		__sev_snp_shutdown_locked(&error, false);
> -
> -cleanup:
>  	kfree(blob);
>  
>  	return ret;


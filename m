Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDB024A047;
	Tue, 28 Apr 2026 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777414042; cv=fail; b=ukKIlNGd2pHH8QGMlQ1V7GEYNbXg+WC/SdKS6TEHW+E95zmPRwghsxrFfF82+Rg6T0HtIPBZjCyoQu4h9yvr1whWWTJmUC9lNRhl8grvxD5ARD4/MRuYwpz+lXOPlbY6lH6eF5sHJnM31K5Amxk0R+XDZGJtemcoBQuF7CDZtXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777414042; c=relaxed/simple;
	bh=3bOq5ztve85f2hYlXN0jV25oAhW7PSXsKIjxaeSCwZA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i8NnHdqZ4HJPPZcwOylNudC/C3aQHayK3bfsVL+IOw/o4CdI+yqx2hCpo+kDSn9cZ7VWETJAgUBUzxocjrkeamsact68nfCcq6Fnd7g8kox65LNAN3Vnwk2/sZiGJ21huS28SOsugRs9qOaafS/JeVOlQ7UrwXyNCiWYr7foGto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SxHhjEiW; arc=fail smtp.client-ip=40.107.201.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SxHhjEiW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YLYRvOh6MHuRf4qZ4LJK8NuZaMimV5qnsoy9JuCH1AKpQet18f2ENL3G9atVF8mz9rUG3dmpRhTf/EEOQPjecDrQD+lkixIOtNtuNF+xqOPMjLqWEPbJfMTItnQZ7j82GFlDzFimBuA52vuG0QWJDzlK/OdYlIL3RWqrDnY0oT4GkFbPNKrJJQ9gYUFvK00av+x6y9gBkxD5o3j0xZeCynspljRF6AtyWcJY+75EDj79MaaZZgu70rpYB0aAeSrEBCzKW5aP7rYzqSxiqtcDDl95qMUDw1/DQRlhy2XGlI2Ka56YsFP4lcAjK8rzJP1WE00upaL6MbCvRnUglSh83A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/GHUBcB5iAbtJ3R/aQ6Fh3kdNfb3UZ3drdMnBjEdC8=;
 b=T3bfPYI4G2Fv29zTAvYSVOVWazdXZMrfTrSrpH0eb8GRfhrBJyEIjSc8MFYVTeBF5s0DOeRUWBP63NxKouZnSNCDkTpApmrNjbR/NooorAhEw6nNoI4NrD5pqAl+mbuGgtAH2KlVTBaPS2TsZ46eetf7ljS19UX0Mde6aBvBaKGNEA3CgMGzWRuxJotv0Tm5e0iN9qB4JHuaC0ujXddDnexWjW3XRAEnUD28StKsKEN0kwm4CWmZ8wZ7jsMuucp0VvHHJLoBmbETvF8Yxxb+qrnmbKkJTgteIFK/kXrZv2sc+u3IbeOM+RXQd0rB219tJCUPl4PHx7oxCeMwvvw7DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/GHUBcB5iAbtJ3R/aQ6Fh3kdNfb3UZ3drdMnBjEdC8=;
 b=SxHhjEiW8rNB9CdS6CWKSRLONWGBOpzus/mGsCTbxbRhzeROcchMD2ZMTi60L7edPadxvtNy1NHu/jPA29/e3ctAa6zBBbIFzgpLn2eaei9pZiuvnKggxJhTXLQxJ7i/1dcwAMfP/bDKVg45ywkDlACIwFGi5ecYnLdMyXIVHrU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5966.namprd12.prod.outlook.com (2603:10b6:408:171::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 22:07:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 22:07:16 +0000
Message-ID: <0eb93344-1923-4bc2-828b-9296856bbbb1@amd.com>
Date: Tue, 28 Apr 2026 17:07:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_CONFIG)
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-5-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260427161507.32686-5-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb6c77d-0b9d-4b11-14b3-08dea5728227
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vFzz2OKLWX8mVp6Df/CEIw40E7zSk1+os6D63pnNogMVkYKFLoYlr02CeLyh7A1ApR7idXAGIirRBfF8vqHCkSnBOdZZp5b7UzOFH1/s5BxkU8NP++tYRse9tbHPEblVkltZKXlPv3tvNV/axyvk7MSU1L3jKvh2PcH4lpVL+TPoVndkDyKym8eJH9EM1R6JwqEFQc/jDdlQAKufQi/GfZle/1ItzgMzkQaQQYySW5V0G33/P7dPQRkkbJYadie6JsRQO7CKy9aKxfrE5x5HdLwiOc2iNEPuH1f15ErnYrwJCMspcZyMalR8VvlqzZQ3sHhYDal76cB1Bhw5waY+s1mpCowJ1Yorv8JBPbt5f88i0bPZ2ENQrK7sISUsqzVebhex6+22FRR7+uM4qj0G9JDtShbTMz5OYCxQLYghKJyl4m02Xte9cRYWmQOAmz0sTzaVvAO/w4rPi08sOIoW6gkI5r9zjJN8RD7LgIOSSzVmhrSUZs48NDc/IyQoU3Y+GWtEbNEBa+4dMSsm7s77nHCZLuFcY/YKCIOo2pgyNjqVp3W9rOdBDVqdTWlrJ1jC0Q5pic2l4hinZgv+Wr/dyfAxo3VMwgGPH2yQXHMkxQM1dHB2wgwFESmyYhg9VxUMv0bJpaIe5xw2w8QbfUSjVxQlJ37reD/nqv3LDMNc8QduAFcV6ozz0aFdwP+uF2hj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjY2dFBaRUdnKzRNazErVHEvL0NQd3dKK21KNnNwK3hjZCtaQVFyTXltTklt?=
 =?utf-8?B?blZHMUx4VEppbkh2UmZTbHo0TWdvZTFXOFY5Q0tORmdpbnU1SkVaNElCbm5L?=
 =?utf-8?B?eFNZL2ZRaUFuRWw1NmdzQWNaY1VyV0xjUFZ2dldYQWpNdHJmUDJBRkdxR2t1?=
 =?utf-8?B?c3dJM1lmWXVGT0VBWVplUEExZkZTR1pPZVpIay9ud2tpL0tKa3BLZUgvUUtI?=
 =?utf-8?B?QkpSTTlxUW45YnRaSXEzcm1RTzc4d3hnRlIyRTBDZlBIaHpBVmFiZXBRbGZq?=
 =?utf-8?B?ZVpKNFlOMmEwT0ZkT1ZVVUhpZkN4aTBFRmNtSzRIVFdtWDl0d0ZpTVRIOEZ1?=
 =?utf-8?B?bDUvekxuT1plRlRBaDRKTWRvcUdoTG1zT2o0ai9aMHpLaXRTd3MvaE9xYUky?=
 =?utf-8?B?Zm5kLzZ6SDNrWnpMZnF3OGIrUndUWVptWFFRb0xheG5pTkgrZnU0OGlxZll3?=
 =?utf-8?B?REF0Vi93OHNIN3FoeVdUcTIxZFBPTkkzVUJySDdvWnBVSFZDVjFBd0ZEdVF0?=
 =?utf-8?B?OTlXcFcva3NLMnpqcWhJeVhjQlpDZ3kyelZxRXZoRkNTMDBXTVcrc01NY3Jj?=
 =?utf-8?B?dm9lODFEeWkrVE4rL1dnTEtNcUZidDBGSDh3a1c0OUhmdUE0MWluMzd2WCtl?=
 =?utf-8?B?d3F4T3EwTW40RG01TEYxWUtMU0NxdzcrRmd6amFxUmVNdnREWlZ2dG9NZ2x6?=
 =?utf-8?B?UmR1U0psMGFJTm5jcmp2VVhXTkg3Wm9paEdIM2dMbWRqb2c5SUQ0VHhwVThh?=
 =?utf-8?B?VVR1WXpHdGF0NTI1MEt1NkpYeW9SQnlXQmdtdWxZQWJ6dHFiNEwwWmdvc0Fa?=
 =?utf-8?B?d3dJQW5TTXI2RFFZQlNZOEh6c1hOWWNQSDcrMXdlZFl4K2lCdFNCWWRIT203?=
 =?utf-8?B?Qk9xL3M1eW9yekJsQTAwRkxMcGZMakxZUDZIa2RkOUNRVWNjYzNabXBrb2Fw?=
 =?utf-8?B?VVhzRk02aFRORVZ3eURRSDcwbmNVM2JPclY4TzRwcXdIa0t0VE1SOFhFREZ4?=
 =?utf-8?B?S0gxUzFvOWxQVTBscVRMb3lpa1ljcGVPR1poTU55anRxaUpYZC8vK2pYeVRp?=
 =?utf-8?B?WmtMakhxVk9XS3B1R3FEbmYxYUlOaHlYVUV0bTVMclljd2FjT1EwanRxS0xx?=
 =?utf-8?B?bllWeEphd0MralJEOEptU2lKZ25WbUF0OUNEb3F1ZlBXK3ZmUXBTSy9nT3Qx?=
 =?utf-8?B?VzJiYWpVbHJPdXVzR3NtZ3lNbDBESkpiMUtNclZPSFJnb2ZkYVo5OFZpVTZj?=
 =?utf-8?B?T1NWR2pXUmk3Rjg0U1NQTkdzL0hZZVBnMVZaWG44Vy9QS0tkTHpBZGMrNnp2?=
 =?utf-8?B?bE90YWlMZWZ3QUFvS0NUYVZrZkZ0SThVLzhkcGxsU2VBbXJyaEJQakhFSU8y?=
 =?utf-8?B?b2p6dHJyVElVeE5RNC9KcFh6blZJRldNMGFNcEpNZGJRTTZjR1NUOFNrZEs3?=
 =?utf-8?B?em1NaFNFWE5JT3JWWHRxY1p5bFNKWGhYa3JLbC9rQlllM1FrYjJjVStROGta?=
 =?utf-8?B?aS8zcTNJTHkwV3QzNWo4TFBzSDQrZzhXMVJyZWZkQXZyVHczMFdYM2R5Vnk3?=
 =?utf-8?B?Z2UwckU5WDZvQVIxTHErcUJwWi9BZjF5NUVSQml1SGJaTkZkZUlzODRZU3I2?=
 =?utf-8?B?V0pKd2dWa3pOLzNKTWNISmJBVC84MmNudHUwbERPU2VCamh5ZDJUa1pVN3Bh?=
 =?utf-8?B?UXErSWdVUVhuSTBWcG9VQjZNVlZZR1NQUVFZM1hOaEpkT0NFdGxwUDNPTDd1?=
 =?utf-8?B?SHNCQzVhS0RSZEx5c0JKUUp0Ti9ESThQNU56czdxUi8vbTUzaGVKaUdneUpm?=
 =?utf-8?B?aEd5L0xXeUtQQ09pbHVtdzZOcGRvUHlyamJObXlUdXNsQ3M5bVMyT05qL3dt?=
 =?utf-8?B?UkZ1emw3dkdxcVJ4Y3k1dDVhSUhqUDB0QzRjR2doK005SVJaaTE1eGNKbk4z?=
 =?utf-8?B?c1I0T1Z1NnAzN1dpSGFLLy8xMlZNUTIwcVp1dS9xWHJtTDVpQW9VOTNVd21E?=
 =?utf-8?B?WlZ0Q3NCQmlTOU5La3k3Vkt1b1hSd05FNUE2L3YzZTBMTm9OM2VROERycVJ4?=
 =?utf-8?B?Wld5L3JIWGdxVHlnM051S2pxMTJRcUsxVnIwa1NqSGpieVhkdnVyR2pjcldV?=
 =?utf-8?B?cy9rUG1yS3VWb1R3TGZBSVVaMFpsOVRRQjlxUGdPSSt0SUMyeWhjRWRhbEsz?=
 =?utf-8?B?U3B1NXNEQU1nK21VN0dOREV1TDUxWi9wUnlQOGo1YTRtQlh0OXB5VGgvSVY1?=
 =?utf-8?B?TldOUWo0Ym45MEl6a0c5dldCdFVHUkJ4TVZoR2xLeVVXZDN0bEwxRjNieE1X?=
 =?utf-8?B?N3RSVXQxdDVnbHJuM1B1U0pYbHFNa2p4U1ZMWnVSUDA4bVY3RWFHZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb6c77d-0b9d-4b11-14b3-08dea5728227
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 22:07:16.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWO0kIob2+XpuV98CNleClEPT8Za5bfZyjLVv5sbp2a3Q1FVYZyPTpCGQoM1Xb7n54vTNZP55OTlZhUWQ1lLLw==
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
> Refuse to re-try initialization if SNP is not already initialized for
> SNP_CONFIG.
> 
> This is technically an ABI break: before if SNP initialization failed it
> could be transparently retriggered by this ioctl, and if no VMs were
> running, everything worked fine. Hopefully this is enough of a corner case
> that nobody will notice, but someone does, there are a few options:

Isn't this the same with patch #3? Not sure why it is only called out for
this one.

> 
> * do something like symbol_get() for kvm and refuse to initialize if KVM is
>   loaded
> * check each cpu's HSAVE_PA for non-zero data before re-initializing
> * once initialization has failed, continue to refuse to initialize until
>   the ccp module is unloaded
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 33 ++++-----------------------------
>  1 file changed, 4 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e8c3ac6d989a..5b113908a4f9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1727,21 +1727,6 @@ static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  	return 0;
>  }
>  
> -static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
> -{
> -	int error, rc;
> -
> -	rc = __sev_snp_init_locked(&error, 0);
> -	if (rc) {
> -		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
> -		return rc;
> -	}
> -
> -	*shutdown_required = true;
> -
> -	return 0;
> -}
> -
>  static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
>  {
>  	int state, rc;
> @@ -2451,8 +2436,6 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_snp_config config;
> -	bool shutdown_required = false;
> -	int ret, error;
>  
>  	if (!argp->data)
>  		return -EINVAL;
> @@ -2460,21 +2443,13 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>  	if (!writable)
>  		return -EPERM;
>  
> +	if (!sev->snp_initialized)
> +		return -EINVAL;

Maybe -ENODEV to distinguish this situation?

Thanks,
Tom

> +
>  	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>  		return -EFAULT;
>  
> -	if (!sev->snp_initialized) {
> -		ret = snp_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> -
> -	if (shutdown_required)
> -		__sev_snp_shutdown_locked(&error, false);
> -
> -	return ret;
> +	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>  }
>  
>  static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)


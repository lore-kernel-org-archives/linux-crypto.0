Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013056.outbound.protection.outlook.com [40.107.201.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2974A07;
	Tue, 28 Apr 2026 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777413493; cv=fail; b=C/TocSEYOiqnE9rDb+BQE83OrqrqyNdxq14ltq8jOvkNnsCJHQ/SVhGummCcRzT38U/ejUfvss9ILc3IgGQi/GUEPq6d/wMT8O716JSgTv6/Pxltk8OrWsEF/DpGKAd5dXoHtghG8Ii4RcZjweJ8xDEcfneJWy8YxK+5Y2Efjas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777413493; c=relaxed/simple;
	bh=MH0tAMUHNnql+KClVeYCERVVysvVXzw7N34dt93wI9I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K6dvJF26OK8wxc8rgYAqykdZuBe0KVCrLd7VfoCZmgHJF16d3ogBwDNMSaIlU8+E+gK6rIGnJalVqVqt5eSweDFCmmIHF2j6P8AcYbRB0Cp6DaRSQi6wXFRw4IfpIEbqhSLmq71Z6ok5ayWWy9WBjTyfES0BmzkLbn6XKAzA+RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AhmOXErl; arc=fail smtp.client-ip=40.107.201.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AhmOXErl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfDX9HuwkbW6tbT/nh5xm3eRcoiF5jCfUySFf4nwpeRaZVlRSR0ZYSM4GvZaJ2Wy+ptu0dBnIlSyWstIftaX81qlqee20xtpgR9nyey7UjCKdkDGWHHHyhL7va23W413LiflWOGbodol8jxdCoB0+rni5PzOALE5D1CU0VR8LZOfPW1MCnZzobk3CzYn2n4rpjOA+gcdrj4axsLX6BmEAtJv2701jCPKOq7DMBT2DR+0Enl+m5BJ+6QM0xjet9R3qvtZkTlr/f+l6Evww8QJW2y2kSYJeZppGlYjDDb4jInEYtjGPooDSR+dTYta4LT+tOE9kw/otlIRQcRgdOZ9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZS4x2V+9VkZsyF/C+gd2qzDAKsaWWMiOBr/3KwqMBOc=;
 b=KCAHBHlmTzdz0GoRiVnEVLookzm9M7HgMqdv/bcM5j05IreENT680uMKOFUyKevVFLmNSsiYX435pM7wHdegICCjxDkFg28h8uUBduYGIV8Q/dPhUxIyHRK+oDGALsH9CSY6R2qkONrGyVT7d86qQZqfgPcakmrcRKdQ5olDZDpuvgcoW6ofP/+vpMkJ0nyDC9KQLdxgILUP7eo/XFgk8u1JFuT/w17XgjiYqxS1pFqYiDTGaeecv4I/kW5m/2rCzr8KrbQiAa1dejyqT7XPDBuTt4CBTruAH8W73Pl4VL6+KNcz5cDrFIN83qINc7sT8XWR+L3E+Ca91IwgMGWKOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS4x2V+9VkZsyF/C+gd2qzDAKsaWWMiOBr/3KwqMBOc=;
 b=AhmOXErlJWsHJPyaEFYZ/ojtd2dld2gUgNCUnOatDFaAqpXe/jrKPXbS4sJUQLo8QHPOJ3Ue1FKUc4+xQRvDUqUOKk089Eb+mFObhtSN3Bjq8R6u+uQ4fSQrv9uSqicx5gr/XK8P7l4R8IspvTbNmH9ylGpTbVjZ9Ps6uryRn2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB9178.namprd12.prod.outlook.com (2603:10b6:806:396::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 21:58:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 21:58:07 +0000
Message-ID: <76aa46d0-9676-495a-a689-e258e30d5cd3@amd.com>
Date: Tue, 28 Apr 2026 16:58:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] crypto/ccp: Do not initialize SNP for
 ioctl(SNP_COMMIT)
To: Tycho Andersen <tycho@kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-3-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260427161507.32686-3-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DSSP221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::9)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB9178:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c1389d-4b0f-4edb-9256-08dea5713b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9OOd3Ex7m3keHIAk64LaMqdHpoyC7k6fv4oo6MYLFhsNOAbo9UOSDz290sZu57uoe1vJBBxXE8AM5kPngelNOjbSYYkOLrC5Rfj1JHGRpNnbUrBwLV30guG8LV6pohcQSdkEDMUexPyp4LZZeX2DBQvnvw7CzdMNoSvymZhnSWC03SuHgLFl/8dT5pxz40N6nzvsvJQSx9P58YPlV4EJ4LtleM+IVTxgKGY6mMsUjG+6gyk5T2MpFLV9q7mcKkeyddlbxhMB4HHlyCvUWwuYxqVjsKlUSSZAok37mVZb/1IJG6U5d7Hw5/Z/BT/6azgDRWDEKIuHD8/bjU8Njb91YX2Pk0bJ6eeWR32SYgYZOdWKVN+2y7IiS071ynwgyJ8z58h+dd7ws8q+TVIuv7oo9TC364wCZGEBKf816LWxWlcjclXKklyM8WO6yy0t17bzHhu3bhyr2JNHITiQzR8ROzVX/a5Pbuo6Gi4j/dfOo6Ne4QshRjlBePJZBjfzTYaXhBc05rMXORCXt7Ghw8Atkd/yp2f9F5W4FvUp7eo8vtm/Y1gST25pPfwLPOXSnP10wAA2QkznLg8HHD0wTV7K+SHv8Iu8pGfBOs71jW08avuPOdEXqD8O/lCGqMeoWUtHdeqqCFQ7YIL4X6UYdy0IJcOcBcg7CBi5wVbwhs2bGRxePi65e+zKJztwpwcgqmNp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjZPMW1XUG11ZEdHcjhzTEpjNHBXVkhWT2ZERXhkR1Z6M1owRmNwNUFkRzNI?=
 =?utf-8?B?Lyt1UXRrYWJtaXVDRit1dnA1cWY0QkJTbWRMbjZNRnk4WHI2UzVkQnQwRGxq?=
 =?utf-8?B?NHhJa21iU3dJZEtyN2JBQjdJVW1qL2dVR2NHaitnRnd1ZTArTkVxbmpMVXlp?=
 =?utf-8?B?ZU8zUitCMnR4YW1hZ1pkOE81eVZWZjNQOXhFc1ZWd0V0VE0vS3pqZnRkYThy?=
 =?utf-8?B?elJjZGc1Ky8xS01USWZPbFNUaS9tUk9lWUhyVEppQmxOa2JwaUtDSFFtbWNh?=
 =?utf-8?B?cFZ2KzF6TXY1YU92d1phTUVaYjN0azBuRkRQUXBDR3BmSksrUVFMQ2wvWUtz?=
 =?utf-8?B?Nnh1UHcyVnFaNitlSnNaVS9ZTCsvVDdvcU9EZDlmT29FV0hkZENrYXh3NHpL?=
 =?utf-8?B?ZFpibnBMdmNtWFh2dldsSlp0cHBoZXVvTDN6L0d6K1RzR0JhVjJKZ0JFL1RN?=
 =?utf-8?B?TEFQdzZLUTVFSVdJcXZGSWlWLzMyUy94UVZGNm95S0dJNkFZRmhQQzZ2RFpM?=
 =?utf-8?B?THF5d2orRktCRUE3VGRTS0cycThwM0JhdGNqR0JkRnd6MFMrV1ZGVlF1NTdp?=
 =?utf-8?B?bmc1VUNEKzBPSzR3d1BQN0FKYytIVlF4bklVd2xrVFVnQnh6TndMTTdndWEy?=
 =?utf-8?B?aG41WXJhSlRwZG41bEEyVm9VbDdsTkZGVzJXcGkrMURucHhtZmdiWUYwQkVw?=
 =?utf-8?B?enh6Z3hpN0VCNFRucG0rQ3pLcUp4VG90OUNLNmlYRmlLejNSSTNKVmZmZHho?=
 =?utf-8?B?MFNrR2tsWDh3SUU3b1FkcEhkdTJxWjZOd3BQZ2l2Y2x6bXVXc2xLWEpPaXIx?=
 =?utf-8?B?QUZ1L05RM1kxYVBxQzZEN1pKT3RqcldaMy9uc2VYVGRxemxxcDVMWkhVOFBF?=
 =?utf-8?B?RUhRVTZNeDJpZVNZbGNVVHBiTVA5c3AyRDF5MHNENFNsZEU3TzRqSktzNjNU?=
 =?utf-8?B?NzlubTEvTnYrUEZVSjRVZUpjSU1BcHUzUUp2Qi9EdUdRTmdDUGdZTjZjL0kx?=
 =?utf-8?B?aExQY1YvdmsyZDlkVDRVQ2Zna3IxVmxxdnpLMDNmVSs2QWR2RlNpR0JpbEhY?=
 =?utf-8?B?MHY4ZDdqb2c4NDc4L0pveFVvWkF1MnZTRnJ0aWY2VE9CUCtuKzE1ZGNCS2Z2?=
 =?utf-8?B?bFR4N2w3UmsrekoxL3RHdkhDMVdVTi9iOXJjRHVIVzMwblJzTXBVZmVBQ0Ns?=
 =?utf-8?B?U29jR0Yra3NDVURBUXB1R2ZhZFgzdnAwOWtwZE9yLysvT3BKY1NMUnUzWm9w?=
 =?utf-8?B?T3QxZGZuS1FScjNNR3UxbjdKTlRQb1BlZWFkeERhcTdJZHFjb01wd1NDaTFB?=
 =?utf-8?B?Sis3K2FyWlNiS1lta0paczlhRTJ4cDlqSlNUaWM0bUFCeEgyN2tqN2EwOXpM?=
 =?utf-8?B?NFpBMjlHRWNKbllheXlwSTlQQjlmeEhneG9NTjQ0RDBKMEdFSU9RbnN2K0wy?=
 =?utf-8?B?WjJ2L2N3RHVjektFQWhnZ0NwbkN3NEVFeWRpbEtrQkx5L3M2cW1meXVZdU1s?=
 =?utf-8?B?Uis0dml6Si9LdFBuOWFVc1UzSVdycWJJNmg4OGZ2ZGkvNHNKMGd4eVQzaFE4?=
 =?utf-8?B?anh2Q2FPeVVqb0N6dndRSEIxN1JPTnMxNHYwUE4xR0dGRVNiWjJoNzBpRUtG?=
 =?utf-8?B?UlArRzFDNXlUeGR6RkM3bHNMVTRwci9IYnB1YmdJTmJPazhNK2NPWmRoeHZE?=
 =?utf-8?B?T0lkd2dnUWZQdHBGTEFSYWMxanorODJIbUxQMHF5aExUcUFwbkpEWENudTdi?=
 =?utf-8?B?VHJPa2dZeXVCeXJIa1Q5UWg1WWcrWHY5NVUwK0tFOFoybjRnWTk4dml2cWVh?=
 =?utf-8?B?RFArNUlMZlhFVXZDdk1CSngxN3N5WTIxcDh2bmtybGJ0b0R0MHMxYTI3VC9K?=
 =?utf-8?B?TjVNaEdPQnAvT2c2YXNZYVByall3MTIxL3dYRVhzN2JydmVNQ3Q3L3B5ZG9n?=
 =?utf-8?B?WHgzOTZJdlZGdklXVGJiVEhLajJ5ZVpIdU55N1JJYUgyb2RnQnowTDRuYXQ1?=
 =?utf-8?B?UEF6dU5hYkZRZXpZQ25UdFgzZGx5ejlNZ3d4bGZ1cnpxT0M1aUxWZi9ISllJ?=
 =?utf-8?B?bmt3d1ZabThWYXhpbkZyeXlKUXdCdkd2VUVqTWtwWmtqcXVwR0ZJRURRK0F0?=
 =?utf-8?B?NDZFS3JXU3NVVEg0U2RJRFg2a2lNME1NQVJ2MnBSQnRSOGdUR3gxNHFqeU03?=
 =?utf-8?B?RS9BZzJnUlBWWG92czVkOVMvN0dzaHlTdnBDYkthUERWYzhiNEc4Q3BjKzRJ?=
 =?utf-8?B?NWxNWGIzRkd1YzlXRXZ2cU5yMTNSd3JudjU0ZEVvWGhQbW0ySmZKb3Nsek9m?=
 =?utf-8?B?Z0NhYXNnTXRMK2dEd2Q3dUdhbjFvQkhpS2ZOT1I0ejgrK21kK3NXUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c1389d-4b0f-4edb-9256-08dea5713b21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 21:58:07.6605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVSpuBDWQqQHj9pjz2DKLKRpUuAlxZ9elKhENC7dMm4EQdDX5nipEF7yX+LNMJpi0wLa96I5VWjaA3aeuTxGTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9178

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
> The SNP_COMMIT command does not require the firmware to be in any
> particular state. Skip initializing it if it was previously uninitialized.
> 
> The SEV-SNP firmware specification doc 56860 does not mention SNP_COMMIT in
> Table 5 as a command that is allowed in the UNINIT state, but it is in fact
> allowed and a future documentation update will reflect that.
> 
> Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> Reported-by: Sashiko
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Stable?

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6891b90bbb88..572f06368d4b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2437,24 +2437,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  
>  static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>  {
> -	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_commit buf;
> -	bool shutdown_required = false;
> -	int ret, error;
> -
> -	if (!sev->snp_initialized) {
> -		ret = snp_move_to_init_state(argp, &shutdown_required);
> -		if (ret)
> -			return ret;
> -	}
> +	int ret;
>  
>  	buf.len = sizeof(buf);
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>  
> -	if (shutdown_required)
> -		__sev_snp_shutdown_locked(&error, false);
> -
>  	return ret;
>  }
>  


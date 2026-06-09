Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010047.outbound.protection.outlook.com [52.101.85.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751EC368D4D;
	Tue,  9 Jun 2026 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781021223; cv=fail; b=uWAT7EfnKhTS4zx27+5/FdKtCx8nJJiZF/JoR8/iBe6LaGqMnYIRHD4kzD5i8f+LZNYccjm3GrFSgW5mCZwLjnffDiPJHOxTebvZrCmM0asj0w+pk79qPiaodfZwrfytDt/A55QA0Tmp2ipy2WnZxoe7eCMW1dDuJ61zIacMBGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781021223; c=relaxed/simple;
	bh=m/44MROreUCB0tW+rvAG0Fye/oOvoIf1q0AqjHubqBY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E2XZn42rj3ZlJ/C9G3CQdhi2W+NnMUuebUhiBMpCEeak8pTtd83xuzV4ZcOL/6n6q5fIqDm/ufZkCQMbAhQ55YyZOVy4/vFxZiPGX4bEcONFabV8dUOEbYs4hXfGul35ieq6LefyzggpqhtCnItMD+aD9xXK6+2R2zE8eSlT2Ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vf/SAy1c; arc=fail smtp.client-ip=52.101.85.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vf/SAy1c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iE/nItoincL09zwCdAjqquR0JHy/NNCGF3Ttb9/T3mf6mpgdTThsk8xx7pelnb7T7a50UqcIyOR2kGPddutY+ltYMzNJbHvMsK/MIezo/cvH7Xl92dVyyJbKz8xLR9/cPQOl0OF9p/KgHI8CqbOyWoM7f9Ozhmbg/AqpWNoNk9kCPNW/Xg5i0PTRVHDMNjpURBpDYMfgqRRJhf4a5FQhyiXjiU+bBVCU5+443h31O/VryfeUhrpE/4zPeYdp1jGLdFY3+z+DK20X8LB4THemBaBiespjLglYixzZfPQByt1f90gNLv8v7TUa75aeBKDvUNnMd70FLQ5nzlOKUdGMWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axUGPIRsm9H7WC/2vbxrw3w7sAMOFj/yORm/K3cYO00=;
 b=pW7KT/0M9UUFeuxiQYy3o2YmCf64JAqHUeu+fLEr63k3xXwYpAhAqvHKn3bAPpw2lPqD0FDRz9XtjjbdkDxmbXFpTuA5uWL+ot+VOqVG0FO+UNX3Q2C6VlvooN43b/9nms+S9TsSUbgFWvag93v7O+TUv4Z5xZ23UZu3b6u2e2eYPrpJXPam2NXhQjTVThBX38xCe859hdxnOHtkpGrTjzLpCR/y5g5j2VZsTxeTwUsikaXwZStBjXhdfcAbRCLoxjROQ57gOFXCS7IizWbMNbgd25THWq4emkd04o+yR/82qjEUhnvVKWfyPl6hW22/QnIMHRg8ReCb+Yrh9j8cIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axUGPIRsm9H7WC/2vbxrw3w7sAMOFj/yORm/K3cYO00=;
 b=Vf/SAy1cgEhGIxrfxozGI/HW5HUpcgbWZvOJZZK+SsQaLxDndD2Ls9uzXTWkaGMM3PvDIGKEkV75QxHDjJ74szlEhsWYDIyE5MoQ/Z+Y5lX9wQD1fpcqyYMTHuZoiXpmwTuYwoSUI6gh4tTi99f6qTvI6jvt+dvmqIjz/2NgvXI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DS0PR12MB7947.namprd12.prod.outlook.com (2603:10b6:8:150::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 16:06:56 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 16:06:55 +0000
Message-ID: <c00d4186-2a89-4c24-be02-6b6a05450fe5@amd.com>
Date: Tue, 9 Jun 2026 11:06:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: "Pratik R. Sampat" <prsampat@amd.com>, ashish.kalra@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::22) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DS0PR12MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: cddce0b3-cbc6-4b96-6b29-08dec64120ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|6133799003|18002099003|22082099003|3023799007|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ro+NuDqCVoxagQELyCQ9EUh5o3HL4hCR0nQXbM59ucBmWkbfnyNzOz/WvQ1WJi40F6vo4D+gl2ugpQ+7GU6H5kxMZjK1V2hYWYu61xvodWqAasJ/0LyGOOYGrEX7xFkm3QsgN+7r7cHUwfLhpoxlAHpRbFxq0RB1i48ku6FWfR2mujBLTTY87fnXz01IUWDfTI5z4VmnGuHFoDhBquM5yKZp+m2LfhxAbmZa6eTrGJW0MJ/VIlUKaUgP0JUjV5WR1JJDCyI8C/UQu53uUHrfKZwWw6XBpVPq+OIIPFzJR+RAUO5Abqn00gRtiM9pjF9164PKD6KiVhcbWArvEZ/lUO2Sowsu5TWKiE4ld2plMUXkosarQyD5mJ8BhvXT1qvLAJfqkI9hgu61S57gWGtepWEl/8w98QjT2h9I7rOYIgVLfrvKgdXZKbYR22m7lCG9wFpqqPJM4us58NTLZunWB4bnr8gksdBXrnA601Q9SndcXzD2VwYQSy976MKNY/LOlKHhH2iaj7FzamqSYk4QlUI6e2a6SU9YsdjLgBi6UJA8puj15cJ6nJLKDPw8idIHA62lszsG//WhTM3jf/ezIFW4BNaNOFnXxaIfCro1YxemhfLbKBgo0wmm+RrnzbfCuQZUJWNY4N4KgR98HITOtmRGZvkswXIJifv9y85M9oiNdG8x+x7TPtR3oyodgw8I2HbLNGRsxR5ktDvCJxgr4w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(6133799003)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXlsaUhHTDdzOXhtLzVLNUUzN1Q0UlhUUkFIbmxkem9uTWRTMXlQS3l2eHFv?=
 =?utf-8?B?NjFDbTFGc1gvUFp1RHBUSVRzSzREQjZ3QTdsbzhCQ3R4SHJQOWt3T0RpYU00?=
 =?utf-8?B?QklTZ1Z5MTcrTHdpSkMzViszLzhHUytoek1wbFRuYzF1aERKVG80M2FpU1d5?=
 =?utf-8?B?bkZjalFXY3Rnb0FCMVFTaEVKdWtFZjhxWkNkNFFZM1l0YWR2ek1pcG01K3hx?=
 =?utf-8?B?dTZVakNyQlJDVEpzOHpXNHlyUDZiSWpBc2l5R1NlV04rUlF2a2V0TVBrdTZ5?=
 =?utf-8?B?VXE5VEo4TU1EcldQb3hiL1h1UFlWUFNaNnNSMjVEcnF3Wk1xR2V1NnBXZmVW?=
 =?utf-8?B?a3kzeTJ0MU1yN3c5NVlzUWtIZ1h3Q2czQ0Y2TUg2V2pYRW5mOW1sNlZGK29j?=
 =?utf-8?B?M1B1YUkyTmdkYUpUMytpY3NtaWtrOHo3MXVHbFVPNUFxSFpxVGxQRHJBV2Rj?=
 =?utf-8?B?Wld4Nmtma3lPZDBDeVJ5ajV6c0NiVS9tZzg0OEg1cUNHeFNlbVFDQW8vZGFn?=
 =?utf-8?B?dmgyb3QzOEJGN29tQ0Q5a1lBbzB5akVYKytKcG1rdmhmbS8vRFQwSkpaenNv?=
 =?utf-8?B?TkJ2Wnk3ZHZvVXY3L3F6eHlRNXFiNnhGNU9UNUVhblJJYXBWY0Jtbkh1N2gz?=
 =?utf-8?B?Z2lTSVV3RUNPSnFJZUxqd0UxSG5wQWdHdUVUbm1ydEFKNStjYU45OXNXM1Z5?=
 =?utf-8?B?akFtakd4azJ1YjlRT1RiM1BxUEhwV1NIN1RmV3lqcUd5UnVvZjNoY1dZRFAw?=
 =?utf-8?B?SzhDd1RlSm9FdDRZTHpQOElmVjBDc1YzdEZDZ3FuZmVyZWJ4RmVaUjdiK3BQ?=
 =?utf-8?B?V2JicE1GdWsxL29KcDJhK3ZmWm16dHU4bStSZG5mNEx2R25KTlZ4bkw3bnYx?=
 =?utf-8?B?ak9JWVVVYXA3bThFSGlLaFMrR2UrckNFSW9ieTVERlFZUXpmUjZwMWk5NG52?=
 =?utf-8?B?YTQ0YVZ2TmRrRGt6ZE9SYkN2MkxacjA1S25rbng0SmVRUUhYekM0N2J3MmlG?=
 =?utf-8?B?b2R3NGJndG83L2p3Nm05TWFWSHpCWHdYVlNraWU3Ly9HQ1RVcHZsMzF0Lzh3?=
 =?utf-8?B?cFk3TUsvNFJiQ0tQbzJaUmM1U2tnQnpaeUtaR2VtREpMVDJsc0cwTy9aem9S?=
 =?utf-8?B?NTZKdzdPUjZtTEtGSjVDZWRKL2VEWURTN0lFL3Z4R25RK2UxSTZadXFxSmEw?=
 =?utf-8?B?KzZSS3NnNmhsNWVFV0FYSkUreE5QRjFrL25kODJqdktnNkxEVUUrK09OVEtB?=
 =?utf-8?B?ZEt2VDZQamh5cm1ZeUZFeUh1aEQ4a3U3eUliSHRQVGtkTkR2bWl5OVVkRzFB?=
 =?utf-8?B?TjFnMTFJQ0NmSVJ2K2NKTnBaUmF5NHJoM0QyU3pYV3g3VHRZT3Y3Q3htVEwz?=
 =?utf-8?B?RDhFQzFEbnlCSkhGd0x5ZzFJaDZvWUZyN1NNcCt5NWFMalZBbWkyeThjYzIw?=
 =?utf-8?B?ejZCMjgrcC9PU1ZiVndpRktxT1cyUVBZUThBK0dDamNDUmRSNDdnZkJVSkhh?=
 =?utf-8?B?OEhMS1dHWVVyS3RnS3dBOHJmbGdpakN6U3Zld3poOW1VNENVYjFqZkFNbHdG?=
 =?utf-8?B?UUZHRkdwdzJMTThrOVhSNUtXa3BiMGZtOE9nbXltdVFQSSsvZndkMnRPbGpH?=
 =?utf-8?B?bERhU0poZENDNitkdU9wZ2VzcGRiRlhxc0w3c2RTMk5yUlM2TU8zd2UxNjg3?=
 =?utf-8?B?UnN6QXEvM1hWKzJ6dVRHSHgvdkFOQW9xVmF0dlNyK3FldmkraE5aQ3pNS1A4?=
 =?utf-8?B?bC96UEo3di94WFFjRlBCdWRGSzZ2dUtjTEtjM09JR05jTVBuUUxBenhCb1F0?=
 =?utf-8?B?M2M3QjJQckZHVU03cW5GRDZpU1A5dE11YTdJYy9uOXVBVktudnB0Mjlwbnp5?=
 =?utf-8?B?NXc1TnFnN1dVbjl6UVBaTzNNb2kwK25lbG95d1RJYXNVWHd5bHo1VXR1b1ND?=
 =?utf-8?B?VHFGK0JKbVkydTl0VWd0a0w2QURrUkE5bDZXOVRHNEp4bTA3RUdxZG9sL2Ux?=
 =?utf-8?B?NmtKbEF5OVN4TlRTcEtRY3B5a2p5UlcxUmtwckVkV3NFdWc2YVcxbTQ2QmdD?=
 =?utf-8?B?a0MzZTVWNVA3Qjg2SERXRyt6L0hrWTJOYUMrZExGVTdmVFptc0Y1dG5wOVVY?=
 =?utf-8?B?TG1GZlJJSmdCcEcrOXpSVXNEQUV2UW13WGRpalNhVWdTMm92MTQ0eUpmbGF4?=
 =?utf-8?B?Q3lNODF1VXNzRmZsTnZmMW9rNnZ5OVB4QXRNcFQzSE4wcnlWWVI4UmlVRlhx?=
 =?utf-8?B?TDV1TE9BOGlhUVhTUlhIT3REMjV2U001TkRiaXpweXNMK2RNdEdtMnpJUFZJ?=
 =?utf-8?B?Szd0VWZaOEF3cWhMQkwzeTdRWSt4WFZSZ0R4emRwRDZXbmo4ZER0UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddce0b3-cbc6-4b96-6b29-08dec64120ba
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 16:06:55.9044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngZouM/xNTtyAnlHesB5uUEOAtFRCvIByggyNFmA6cbo+piy7loKSXfZfzOknxtw6qPutiQpy73ob1eueqAfbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7947

On 6/8/26 15:58, Pratik R. Sampat wrote:
> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> can be used to query the status of currently supported vulnerability
> mitigations and to initiate mitigations within the firmware.
> 
> This command is an explicit mechanism to ascertain if a firmware
> mitigation is applied without needing a full RMP re-build, which is most
> useful in a live firmware update scenario.
> 
> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
> subcommand is used to query the supported and verified mitigation bits.
> The VERIFY subcommand initiates the mitigation process within the FW for
> the specified vulnerability. Expose a userspace interface under:
> /sys/firmware/sev/vulnerabilities/
>   - supported_mitigations (read-only): supported mitigation vector mask
>   - verified_mitigations (read/write): current verified mask; write a
>     vector to request VERIFY for that bit
> 
> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
> it are bug-specific. Information about supported mitigations and its
> corresponding vector is to be published as part of the AMD Security
> Bulletin.
> 
> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> more details.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

Just a few minor comments below, but in general...

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v4:
>  * Split interface definitions in documentation - Kernel Test Bot
>  * Wrap snp_verify_mitigation() under #ifdef CONFIG_SYSFS - Tom
>  * Remove check for snp initialized and feature info active for
>    registering mitigigation interface - Tom
>  * Since init vs init races should not be possible anymore[1], remove the
>    sysfs mutex guard as sysfs' own synchornization suffices - Tom, Tycho
>  * Dropping the reviewed-by since the patch has changed in a meaningful
>    way
> 
> v3: https://lore.kernel.org/linux-crypto/a043a82c-f3dd-4f29-86fb-60638eaddc9b@amd.com/
>   * Remove failed_status interface and report failure via dev_err - Tycho
>   * Make vulnerability interfaces root only accessible - Sashiko
>   * Move /sys/firmware/vulnerabilities/ to
>     /sys/firmware/sev/vulnerabilities/ to be platform specific - Sashiko
>   * Guard sysfs creation under a new mutex to avoid racing during
>     creation and using the sev_cmd_mutex which would race with
>     vulnerability operations - Sashiko
> 
> v2: https://lore.kernel.org/linux-crypto/20260501152051.17469-1-prsampat@amd.com/
>   * Intrdouce /sys/firmware/vulnerabilities sysfs interface instead of
>     an ioctl interface - Boris
>   * Reword commit message to focus on need for a userspace interface - Sean
>   * Since download_firmware_ex is the primary usecase of this feature,
>     posting this patch in parallel to those discussions[2].
> RFC: https://lore.kernel.org/linux-crypto/20250630202319.56331-1-prsampat@amd.com/
> 
> [1]: https://lore.kernel.org/all/20260504165147.1615643-5-tycho@kernel.org/
> [2]: https://lore.kernel.org/linux-crypto/20260430160716.1120553-1-tycho@kernel.org/
> 
> Patch based on cryptodev-2.6
> ---
>  .../sysfs-firmware-sev-vulnerabilities        |  19 ++
>  drivers/crypto/ccp/sev-dev.c                  | 171 ++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h                  |   3 +
>  include/linux/psp-sev.h                       |  51 ++++++
>  4 files changed, 244 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> new file mode 100644
> index 000000000000..964362558bb2
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
> @@ -0,0 +1,19 @@
> +What:		/sys/firmware/sev/vulnerabilities/supported_mitigations
> +Date:		June 2026
> +Contact:	linux-crypto@vger.kernel.org
> +Description:
> +		Read-only interface that reports the vector of SEV-SNP
> +		firmware vulnerability mitigations supported by the firmware.
> +
> +What:		/sys/firmware/sev/vulnerabilities/verified_mitigations
> +Date:		June 2026
> +Contact:	linux-crypto@vger.kernel.org
> +Description:
> +		Read/write interface that reports the vector of SEV-SNP
> +		firmware vulnerability mitigations already verified by the
> +		firmware. Writing a vector value requests the firmware to
> +		VERIFY the corresponding mitigation bit(s).
> +
> +		The list of supported mitigations and the meaning of each
> +		vector bit are both platform- and bug-specific and are
> +		published as part of the AMD Security Bulletin.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 068b901034cb..251cc7540f51 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -245,6 +245,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
>  	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
>  	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
> +	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
>  	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
> @@ -1352,6 +1353,156 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_SYSFS
> +static int snp_verify_mitigation(u16 command, u64 vector,
> +				 struct sev_data_snp_verify_mitigation_dst *dst)
> +{
> +	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
> +	struct sev_data_snp_verify_mitigation data = {0};
> +	struct sev_device *sev = psp_master->sev_data;
> +	int ret, error = 0;
> +
> +	mit_dst = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!mit_dst)
> +		return -ENOMEM;
> +
> +	data.length = sizeof(data);
> +	data.subcommand = command;
> +	data.vector = vector;
> +	data.dst_paddr = __psp_pa(mit_dst);
> +	data.dst_paddr_en = true;
> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
> +	if (!ret)
> +		memcpy(dst, mit_dst, sizeof(*mit_dst));
> +	else
> +		dev_err(sev->dev, "SNP_VERIFY_MITIGATION command failed, ret = %d, error = %#x\n",
> +			ret, error);
> +
> +	snp_free_firmware_page(mit_dst);
> +
> +	return ret;
> +}
> +
> +static ssize_t supported_mitigations_show(struct kobject *kobj,
> +					  struct kobj_attribute *attr, char *buf)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	int ret;
> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_supported_vector);
> +}
> +
> +static struct kobj_attribute supported_attr =
> +		__ATTR_RO_MODE(supported_mitigations, 0400);
> +
> +static ssize_t verified_mitigations_show(struct kobject *kobj,
> +					 struct kobj_attribute *attr, char *buf)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	int ret;
> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
> +	if (ret)
> +		return ret;
> +
> +	return sysfs_emit(buf, "0x%llx\n", dst.mit_verified_vector);
> +}
> +
> +static ssize_t verified_mitigations_store(struct kobject *kobj,
> +					  struct kobj_attribute *attr,
> +					  const char *buf, size_t count)
> +{
> +	struct sev_data_snp_verify_mitigation_dst dst;
> +	struct sev_device *sev = psp_master->sev_data;
> +	u64 vector;
> +	int ret;
> +
> +	ret = kstrtoull(buf, 0, &vector);
> +	if (ret)
> +		return ret;

Should we save some time and check for vector having multiple bits set
before sending it to the firmware?

> +
> +	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_VERIFY, vector, &dst);
> +	if (ret)
> +		return ret;
> +
> +	if (dst.mit_failure_status) {
> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
> +			dst.mit_failure_status);
> +		return -EIO;
> +	}
> +
> +	return count;
> +}
> +
> +static struct kobj_attribute verified_attr =
> +		__ATTR_RW_MODE(verified_mitigations, 0600);
> +
> +static struct attribute *mitigation_attrs[] = {
> +	&supported_attr.attr,
> +	&verified_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group mit_attr_group = {
> +	.attrs = mitigation_attrs,
> +};
> +
> +static void sev_snp_register_verify_mitigation(struct sev_device *sev)
> +{
> +	int rc;
> +
> +	if (!(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED) ||
> +	    sev->verify_mit)
> +		return;
> +
> +	if (!sev->sev_kobj) {
> +		sev->sev_kobj = kobject_create_and_add("sev", firmware_kobj);
> +		if (!sev->sev_kobj)
> +			return;
> +	}
> +
> +	sev->verify_mit = kobject_create_and_add("vulnerabilities", sev->sev_kobj);
> +	if (!sev->verify_mit)
> +		goto err_sev_kobj;
> +
> +	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
> +	if (rc)
> +		goto err_verify_mit;
> +
> +	return;
> +
> +err_verify_mit:
> +	kobject_put(sev->verify_mit);
> +	sev->verify_mit = NULL;
> +err_sev_kobj:
> +	kobject_put(sev->sev_kobj);
> +	sev->sev_kobj = NULL;
> +

Extra blank line.

> +}
> +
> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
> +{
> +	if (sev->verify_mit) {
> +		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
> +		kobject_put(sev->verify_mit);
> +		sev->verify_mit = NULL;
> +	}
> +
> +	if (sev->sev_kobj) {
> +		kobject_put(sev->sev_kobj);
> +		sev->sev_kobj = NULL;
> +	}
> +}
> +#else

Just add the CONFIG option to the else and endif, e.g.:

#else	// CONFIG_SYSFS

...

#endif	// CONFIG_SYSFS

> +static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
> +static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
> +#endif
> +
>  static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
>  	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
> @@ -1673,6 +1824,17 @@ int sev_platform_init(struct sev_platform_init_args *args)
>  	rc = _sev_platform_init_locked(args);
>  	mutex_unlock(&sev_cmd_mutex);
>  
> +	/*
> +	 * Register the sysfs interface outside the sev_cmd_mutex. The
> +	 * _show()/_store() handlers issue SEV commands that acquire the
> +	 * sev_cmd_mutex, so creating (and on the shutdown path, removing) the
> +	 * sysfs group must stay outside that lock. sysfs provides its own
> +	 * synchronization between group creation/removal and concurrent
> +	 * attribute access.
> +	 */
> +	if (!rc)
> +		sev_snp_register_verify_mitigation(psp_master->sev_data);
> +
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(sev_platform_init);
> @@ -2752,6 +2914,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>  	if (sev->tio_status)
>  		sev_tsm_uninit(sev);
>  
> +	/*
> +	 * Remove the sysfs interface before taking the sev_cmd_mutex.
> +	 * sysfs_remove_group() waits for in-flight _show()/_store() handlers
> +	 * to drain, and those handlers issue SNP_VERIFY_MITIGATION via
> +	 * sev_do_cmd() which acquires the sev_cmd_mutex. Removing the group
> +	 * while holding the mutex would therefore deadlock.

s/would/could/

Thanks,
Tom

> +	 */
> +	sev_snp_unregister_verify_mitigation(sev);
> +
>  	mutex_lock(&sev_cmd_mutex);
>  
>  	__sev_firmware_shutdown(sev, false);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index b1cd556bbbf6..d5e596606def 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -59,6 +59,9 @@ struct sev_device {
>  
>  	bool snp_initialized;
>  
> +	struct kobject *sev_kobj;
> +	struct kobject *verify_mit;
> +
>  	struct sev_user_data_status sev_plat_status;
>  
>  	struct sev_user_data_snp_status snp_plat_status;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index d5099a2baca5..98666c5a6f79 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -129,6 +129,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
>  	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
>  	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
> +	SEV_CMD_SNP_VERIFY_MITIGATION	= 0x0B2,
>  	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
>  	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
>  	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
> @@ -898,10 +899,60 @@ struct snp_feature_info {
>  #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
>  #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
>  #define SNP_CXL_ALLOW_POLICY_SUPPORTED		BIT(5)
> +#define SNP_VERIFY_MITIGATION_SUPPORTED	BIT(13)
>  
>  /* Feature bits in EBX */
>  #define SNP_SEV_TIO_SUPPORTED			BIT(1)
>  
> +#define SNP_MIT_SUBCMD_REQ_STATUS      0x0
> +#define SNP_MIT_SUBCMD_REQ_VERIFY      0x1
> +
> +/**
> + * struct sev_data_snp_verify_mitigation - SNP_VERIFY_MITIGATION command params
> + *
> + * @length: Length of the command buffer read by the PSP
> + * @subcommand: Mitigation sub-command for the firmware to execute.
> + *              REQ_STATUS: 0x0 - Request status about currently supported and
> + *                                verified mitigations
> + *              REQ_VERIFY: 0x1 - Request to initiate verification mitigation
> + *                                operation on a specific mitigation
> + * @rsvd: Reserved
> + * @vector: Bit specifying the vulnerability mitigation to process
> + * @dst_paddr_en: Destination paddr enabled
> + * @src_paddr_en: Source paddr enabled
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @src_paddr: Source address for optional input data
> + * @dst_paddr: Destination address to write the result
> + * @rsvd3: Reserved
> + */
> +struct sev_data_snp_verify_mitigation {
> +	u32 length;
> +	u16 subcommand;
> +	u16 rsvd;
> +	u64 vector;
> +	u32 dst_paddr_en : 1,
> +	    src_paddr_en : 1,
> +	    rsvd1 : 30;
> +	u8 rsvd2[4];
> +	u64 src_paddr;
> +	u64 dst_paddr;
> +	u8 rsvd3[24];
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_verify_mitigation_dst - mitigation result vectors
> + *
> + * @mit_verified_vector: Bit vector of vulnerability mitigations verified
> + * @mit_supported_vector: Bit vector of vulnerability mitigations supported
> + * @mit_failure_status: Status of the verification operation
> + */
> +struct sev_data_snp_verify_mitigation_dst {
> +	u64 mit_verified_vector;                /* OUT */
> +	u64 mit_supported_vector;               /* OUT */
> +	u32 mit_failure_status;                 /* OUT */
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**


Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773439B942;
	Fri, 17 Apr 2026 14:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776435181; cv=fail; b=ElRExV+4ZCkidttjm//LWI4i3UPl8yovT0yKr/CZEMz/SeXexyUhC2gEioi3q3VqiXAftVrW9+FtEPPHMJhhr0iPmUydBAm3xUlgHuOmMaeajgulNGj5cBFX7rCw+E2POwI5U29dnS9G8luGmtrb0Ng4c2ISSBYMRZ6S/ZgV4zc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776435181; c=relaxed/simple;
	bh=veoy5xh9M4HBGlVaJDqs8WB4pkvDm41ksTlKGyDu5hQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I5hF4W8qxarauJWLDGuRgx1X9vsn5i3B79A6D8ZcMGQ8aUvgdyvGYZ0VVtPv7S5uUy3steUA5CbvCzwGnBYPfHhpRBAAqn2k1MwC0+uPpSOiqWazBiseKNzGbxyw85lP5kuO2L+SHddXssqzY/BboTooznboyRUWlP6fA16hPwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XoITTTmx; arc=fail smtp.client-ip=40.93.195.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XoITTTmx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y27S9DCprLGCdJGZT90ShSY3zhLXyWouJdGZp3KFCRERoLFBjeEALFj76O32sCexE8jAXnhKiYecixaHT3HzQbFgljdPYh5Q3ZeC96/hj/nTfJHWXlzlTWHkXHs689XvDeCFvY50K4XmgaJWK1jpfkEyj+5r5uCfm/FOQEh7ANzGXnZndQyCVdvVXl/9eOP9KdQY1Z6g4RWu24Hns90L8gBPrOMqT8M6BHL7iWYhJtuWh8MekeJFHAFRNswk3b9UpRSGJ5dgTVni3qmXk/v7Ql9+TrGm6rrLTZXGrlmmQ+D4irLiuNsoxqMD/44MbAkv2wUT1G7tdSdJDkQq9mnXhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjGDgJxQUhIn2uN8iLeEZWOlu2TAHfaDRhp5yx3Z8/4=;
 b=ARK4JriQIPM/agbDqe8MhVqRJWupRCDQG4dx0HptIj5jFaWpwYmdHf9OyoCkGnNWfaPeuKyUwSp2PNSaTLaHST2ExWqyMR7imDGUGguA39sGlFfVyY9SnPHf+0n8yWgzvKZHl1ST1EGu1N/mv9gpgTF1dbZYU4CziIL5kBrKnZyCqWlLB6GAfbTNtifhauTpYTXgaFeMmSjW/Fnsw4piMk2xOrYdrRSa3y05v927SXAvooExckjj48SICOB8XYmNgEISWDH5h/XYczE53Jw6zr9GRf3WealiMpW+OWggTm9o7juUaE+M6a+eZ69rnqWauJM1jSfUikJUNoDg5/Cv2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjGDgJxQUhIn2uN8iLeEZWOlu2TAHfaDRhp5yx3Z8/4=;
 b=XoITTTmxiubbfrrkbYGQ9AnvzL/E+w6I3CnxkFGq8xJIxmIDSb9Y65Kyo0Dc2FKt20WCV0NNRf0JM1QmKaXWtbXcVS6sHfYtFRMhuUCd7jEmNcGGoK55EQTuc19luH3CQIzGHwIWfIotfwPtOMbGwXmZqCoC9KlNjk1bj5RQ2XI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY1PR12MB9650.namprd12.prod.outlook.com (2603:10b6:930:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Fri, 17 Apr
 2026 14:12:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:12:51 +0000
Message-ID: <0f4bb67e-ada5-42c5-8470-6447b5df0085@amd.com>
Date: Fri, 17 Apr 2026 09:12:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] crypto/ccp: export firmware supported vm types
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-3-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:805:de::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY1PR12MB9650:EE_
X-MS-Office365-Filtering-Correlation-Id: acf61c10-9cc8-467c-9584-08de9c8b68d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NlNeAaokJvyLhCaStFnhI20NMqy8JBjHNC52LpFylCFc13fNq0BDKaYWg1bXyOSDQ1nFjqOYTP4tvvMZ2NeZi2+Z+YnMckIWvwsk6ekKRUA6gxzHiXW41T1hPt0GeAKypRX8ltqhCznhJhg0t/fVK+VvAXZLkLY1Tm5rKjfBWKYf/AORl/SZhxG1Fm61smZRvddK0df+nuisg7Eg5hLFYLQe4E9yjpNA51u9XOLLPILaJOxs2tLq1khHkehf6Bg2IeTGxm1HKwe9G3T4V4LaXmFfanhdl1OEMtDqvPoh2kxqezq9Mx4Er9Q7xaH4MeNsOIJCaa5RZmyl+9ek24DSZDth0JAmA7CwocnYtvkq9TeMJG/mROC+4CuXgvlk8fGHD5US+mY14negiZHBIZW3tZUb35RHwydOVWRP4FkFt8GB4//RK4flWodCBNtMe7TxULdSYVCadpBNztMO3jwc7k/iC8BT2hJeze0kMLrPWMzWoAxjrWTDeMKZ3vPHr2oS82BIaMP+6qiXP7N3dN7Y3X0bjW7vBjqOKBSWn4XUc/9VZYEDXW+IVC433I7rX7bjvUZBsXNbTBJ5+7+rT6eZlaNG3UWMZulY6lC82DmDwZQjVR/O0NOMm+7ON0BaWlvD9uSA/gngB5dOJyDgT5nZKl8G2eMdD9ER43QXDfKmf5vjoojhu4rpH6mdUietI/vRYyja+eVEcpNpXJbd7H6ArmqWm20bubP5aaFtCnMyhwQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHZWbWlWeU1pV0pEQUZJWVRsYjAvQ0VFcEd4WndTQ0hOQ2o1eCtWUmxzWEtn?=
 =?utf-8?B?R2ZNR1FtNWd3MUg2cWtxWHBGQkttU2ZaaEZSeXZCa3hubkhrSlA1bDdmaVd3?=
 =?utf-8?B?Nk9GWm1XQ3QvRVBNYXByckwzVnI1eEtSVURwTlAxVDdQYWg4QlRyQ2o0Z01Y?=
 =?utf-8?B?T2c5cGx6NzVJUC9IdGVNZkZQWVN3V1RTWXFRT0E4NDhGcVBMbnh6eWRsR2M0?=
 =?utf-8?B?WklmS0ZWUG1XWUFWbUpBZzh3Qk9MWTdadE5lTWlzOGFRZ3dsNENxWnducW9n?=
 =?utf-8?B?empZUStRWUo2RnlKL3cwaWRHMFM1VG9FWVdDSE1MYm5mODE0SmVRK0xpcndr?=
 =?utf-8?B?MTdKb1BqcElNOHJrczNUc0ZaMUVOclNKdEp3RkMvb21ZKzZUYW9udzMxb3Z2?=
 =?utf-8?B?bHBvSU0xVzErUlVGeVNvekJWSVc4Nmd0R0VZdU5WV0toOGV5RnlSbjRYNUMy?=
 =?utf-8?B?NEVYR1dMQXNPM0ZvWVBFcGRMcE9mWkRPSEY3Szhoblc5d0hMR0pHZWRHOFd6?=
 =?utf-8?B?czR5cDhHOThHNzRRclQxVS8xRmgxUGZJNVB6YTlabHNMMk0xdk8xdHZOamdQ?=
 =?utf-8?B?VWZtcm5oRFJNYUFCdDF5M2pmRXNET2lYWVU5cHV1ZWh5R2UxdzI5SWpSZXZJ?=
 =?utf-8?B?TDJSa0Y1OEtXSWdnTjBRZXdZakg5em1DMGxTQVFDUi84cnRRRFZINFZVeWJ1?=
 =?utf-8?B?Y3pQUkptcWVQcUlEOTBSSUFQeElOMjNnVU5DRTlPTkdQUFJVa2twcDh0K2Ns?=
 =?utf-8?B?M1plQnFxS1kycldnZWdGeFJ4clZMdVB2dHI4TXp0SzRpeGVTTkxuL1V3WSth?=
 =?utf-8?B?aW4zN3dMMmIzQmp2SGdNVlUzdCtPeHdSaWVGTTVKUStEWXBFL1dRV21rZjZJ?=
 =?utf-8?B?NDhmMGY1YTZaYWxjVGlnZ2YwN1p4aTFWb3RNcHZtRzdRbVQxQ0Y0M1RkazhU?=
 =?utf-8?B?WDJqN1VyWXRPQnhKREluSHVmN2hmU2hMeFowZXB4MENYVkg0aHF4bThOMS9j?=
 =?utf-8?B?SkMzdUUrK05FekY0THMwSUVhSENXVXc4bGFlclNlaUpvSVRmNW5jcTdVRXBj?=
 =?utf-8?B?KzZRVHFhVmtRa1NWMGh5MGU3ODNYdW1YOE5SbDg5WGp4S1VIR1JTR21YakNU?=
 =?utf-8?B?MlYwL2M5MVdvSmRJR3ZvdU1nMkZva0d1dld6WjBxNE1YaG1qdE9mZmIrVFFC?=
 =?utf-8?B?T3Q3OVp5Tno3SFd6M01UbWgzejU0MG9uQTVPK3gySVFYMldWcXBPS0QvZnhV?=
 =?utf-8?B?UmtobHk5VE1DL3VUSGxLeGNyQlVaVHFqQ2l6cGtTaVo3ME1Qemx0QmpVeWhF?=
 =?utf-8?B?WWtMeTdjY09mNkJKYWtGeXpqSFBpUngxaUFackFKalZpUE9jdDJ4cTdlODVj?=
 =?utf-8?B?MzAvQUszVmR4a2k0US9CSjhEKy8xeWZ1dHhYc1ErTGY5QWtRVUdMSEp3TVZ2?=
 =?utf-8?B?cE96UFdoSG9KSDNyUk5WeHNtamIyMXVoazd1THN2ejF0OGlsQy9FOVIyZkl2?=
 =?utf-8?B?Q3ZLNzAvbDB0bzF1c3YzNG1CWFZPaHY1ZWVJbGRVNWpHWUpHSzRJWXB2LzVw?=
 =?utf-8?B?NG9vNGxzWnRsOGxmdDVDMmRnbjlPZmlOckVhZU1RaUYyVWVENmN3WGQyeHFv?=
 =?utf-8?B?cWxINWM5RkRsbDM2aDVEY1lvREdkZDFSdDRoV3ZsU1dUc2tjR0gzMEk4ZFNh?=
 =?utf-8?B?ajJrREM5VGhlNUFLblFVUEpITlJOck55YVM3VDhoekU3cEVqTFhrUFFkait2?=
 =?utf-8?B?aytYNzBRdVNEMllQOGwzTVRwcjZMdi92NTNTMURSUGpKRVZIak05R1RNQ1V6?=
 =?utf-8?B?WXUvZ3c2RzlBRjdpek1ieVE1VE5nQjcxckl5bkJpM0FONWVCdnkxMkYrTWJO?=
 =?utf-8?B?d2o1SERncmNmNjFpRlVVRVdqVnpLZzNYcC9sMlBNa2pQYWg3S3Rmek80bU5x?=
 =?utf-8?B?UWxFSmhta0M2OE9KUzdFd1dFNzhxVFdpK2h1REk4dWx5cXVGNjkra2dYemx3?=
 =?utf-8?B?Qm5ka21TQWxVeThSelI5MGtCQ0c0NUYvMStpYlJrSkN1RGlrSW1jVXZiL0Jq?=
 =?utf-8?B?N29oajZUcWFBUHpoSVU4SGcwZ1JUcERVRnl3SmhPVU51UkdHNm5CNCtSenZQ?=
 =?utf-8?B?QmlaUFY1dk90eG80dEZGc0VRdTgxZzFsczFTR3BUdklvelEyNkFvR2g3NWl4?=
 =?utf-8?B?bWVzVER4WGNkeWdQNHQ0TFhJa3hJejlKMUpROXp2aWhDcFJCVXcwbFI1eXFJ?=
 =?utf-8?B?OUF5dUJ4c1NxRTF0eVN3TXBnK0RhbFdSN2RJbGZXZHB0S1piWGNzTkZKcWJO?=
 =?utf-8?Q?R0G8FjpvsYZpHjGni/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf61c10-9cc8-467c-9584-08de9c8b68d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:12:51.6648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrj/ATHnM8VK37uUbnGD/5RTqeMgVlSJcRbcGi98Ziu57KoI6CXslhUXjlBD2qvuq9g5eHYmCbKv5CjiI8sBKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9650

On 4/16/26 18:23, Sean Christopherson wrote:
> From: Tycho Andersen <tycho@kernel.org>
> 
> In some configurations, the firmware does not support all VM types. The SEV
> firmware has an entry in the TCB_VERSION structure referred to as the
> Security Version Number in the SEV-SNP firmware specification and referred
> to as the "SPL" in SEV firmware release notes. The SEV firmware release
> notes say:
> 
>     On every SEV firmware release where a security mitigation has been
>     added, the SNP SPL gets increased by 1. This is to let users know that
>     it is important to update to this version.
> 
> The SEV firmware release that fixed CVE-2025-48514 by disabling SEV-ES
> support on vulnerable platforms has this SVN increased to reflect the fix.
> The SVN is platform-specific, as is the structure of TCB_VERSION.
> 
> Check CURRENT_TCB instead of REPORTED_TCB, since the firmware behaves with
> the CURRENT_TCB SVN level and will reject SEV-ES VMs accordingly.
> 
> Parse the SVN, and mask off the SEV_ES supported VM type from the list of
> supported types if it is above the per-platform threshold for the relevant
> platforms.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 70 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      | 37 +++++++++++++++++++
>  2 files changed, 107 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 64fc402f58df..1e3286c048fe 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2940,3 +2940,73 @@ void sev_pci_exit(void)
>  
>  	sev_firmware_shutdown(sev);
>  }
> +
> +static int get_v1_svn(struct sev_device *sev)
> +{
> +	struct sev_snp_tcb_version_genoa_milan *tcb;
> +	struct sev_user_data_snp_status status;
> +	int ret, error = 0;
> +
> +	mutex_lock(&sev_cmd_mutex);
> +	ret = __sev_do_snp_platform_status(&status, &error);
> +	mutex_unlock(&sev_cmd_mutex);
> +	if (ret < 0)
> +		return ret;
> +
> +	tcb = (struct sev_snp_tcb_version_genoa_milan *)&status
> +		      .current_tcb_version;
> +	return tcb->snp;
> +}
> +
> +static int get_v2_svn(struct sev_device *sev)
> +{
> +	struct sev_user_data_snp_status status;
> +	struct sev_snp_tcb_version_turin *tcb;
> +	int ret, error = 0;
> +
> +	mutex_lock(&sev_cmd_mutex);
> +	ret = __sev_do_snp_platform_status(&status, &error);
> +	mutex_unlock(&sev_cmd_mutex);
> +	if (ret < 0)
> +		return ret;
> +
> +	tcb = (struct sev_snp_tcb_version_turin *)&status
> +		      .current_tcb_version;
> +	return tcb->snp;
> +}
> +
> +static bool sev_firmware_allows_es(struct sev_device *sev)
> +{
> +	/* Documented in AMD-SB-3023 */
> +	if (boot_cpu_has(X86_FEATURE_ZEN4) || boot_cpu_has(X86_FEATURE_ZEN3))
> +		return get_v1_svn(sev) < 0x1b;
> +	else if (boot_cpu_has(X86_FEATURE_ZEN5))
> +		return get_v2_svn(sev) < 0x4;
> +	else
> +		return true;
> +}
> +
> +int sev_firmware_supported_vm_types(void)
> +{
> +	int supported_vm_types = 0;
> +	struct sev_device *sev;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return supported_vm_types;
> +	sev = psp_master->sev_data;
> +
> +	supported_vm_types |= BIT(KVM_X86_SEV_VM);
> +	supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> +
> +	if (!sev->snp_initialized)
> +		return supported_vm_types;
> +
> +	supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +
> +	if (!sev_firmware_allows_es(sev))
> +		supported_vm_types &= ~BIT(KVM_X86_SEV_ES_VM);
> +
> +	return supported_vm_types;
> +
> +}
> +EXPORT_SYMBOL_FOR_MODULES(sev_firmware_supported_vm_types, "kvm-amd");
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 69ffa4b4d1fa..383a682e94fd 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -899,6 +899,42 @@ struct snp_feature_info {
>  /* Feature bits in EBX */
>  #define SNP_SEV_TIO_SUPPORTED			BIT(1)
>  
> +/**
> + * struct sev_snp_tcb_version_genoa_milan
> + *
> + * @boot_loader: SVN of PSP bootloader
> + * @tee: SVN of PSP operating system
> + * @reserved: reserved
> + * @snp: SVN of SNP firmware
> + * @microcode: Lowest current patch level of all cores
> + */
> +struct sev_snp_tcb_version_genoa_milan {
> +	u8 boot_loader;
> +	u8 tee;
> +	u8 reserved[4];
> +	u8 snp;
> +	u8 microcode;
> +};
> +
> +/**
> + * struct sev_snp_tcb_version_turin
> + *
> + * @fmc: SVN of FMC firmware
> + * @boot_loader: SVN of PSP bootloader
> + * @tee: SVN of PSP operating system
> + * @snp: SVN of SNP firmware
> + * @reserved: reserved
> + * @microcode: Lowest current patch level of all cores
> + */
> +struct sev_snp_tcb_version_turin {
> +	u8 fmc;
> +	u8 boot_loader;
> +	u8 tee;
> +	u8 snp;
> +	u8 reserved[3];
> +	u8 microcode;
> +};
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> @@ -1045,6 +1081,7 @@ void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
>  bool sev_is_snp_ciphertext_hiding_supported(void);
>  u64 sev_get_snp_policy_bits(void);
> +int sev_firmware_supported_vm_types(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  


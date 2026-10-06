Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916913E40EF;
	Tue,  6 Oct 2026 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303043; cv=fail; b=UzbAb8v4R2JVu1Rc+sywDj6x3as2S+AHUq4fDweBgTM62/mWqYzZyTpdJhPJb4KaX+Ks+nQUHaZ8vuLeR9B0IpGUodBskFECNpu2z2oHKCQ+1/BM9+Xj9hDe0Huu/BeRM1BMirbcLuZctU0XbCb+YUDBsRoa3zRNHW8UTIiEeWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303043; c=relaxed/simple;
	bh=nAqauYmYT5jM4PQFnl6xHDYR4X2oO3VsoNJl3IEOdNs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q8QFzzTXX0akSXPc90lBbF+fxjSLNg+ObwiR/42BCSKxud97vQAuyo9m2MJ1oyAMGiUoliveP1V7XU2bntFEByreljibKVBWj4viQeilN1W29KglFOsifM1DFs7OBt8l3N4v7gUAKxH0h/km0NpPOHBpfukAtWiVX9vSpvvi5T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HfSWPQBk; arc=fail smtp.client-ip=52.101.201.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HfSWPQBk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mvFlFqj6QL7KGTdZJJ7CNwKABsmlrwbW1W2TxtrRvjnd61p6ypEUTRQ3KN81j1w0+jlK0iHD0TwefNXpJlGGLy7tTfxiRjh1z94mK37N0Cj07wGfZR4eptQ4Jy5jDnhOUl9uJuzal2M4s2MMxKySH7tEAUVtFPvcfsahjNINreTkTVW1dtpENTQV+wOR0bzcUiOFDzFrkrtETY0pBfN9DYgemP0lPwEenhRMdR26mMb1SdgDz1OJAKcs1nHgZEiAEu/BacHoYwarJ7RM6XSB4mrO3pQK0qsTrbmO6s11ikqGXcvmolf9XhXVO4T4KbBSYab7ts8cQqlnsKh6UQSkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gvfsv+RwvrnaGNa3S2wCCiEf1BGtgNm/l9LlImuMFMk=;
 b=Jj1Zr+yqIfqedvteILgYD/QH4g2NlLEI/3LveoMCj2V8KLXQGaTGUe0qiLlsc9NyNIY5PU5vft9slKPlLdWGoXOpmqTnc8ZrsWU3175U5Q8souRZpCg/ba92y+UtqmH4GwAGPWCb5J2hPCQ2OBxYW99xEJb+r6IiDsz6RcpaQfMaBBoJ4CXNbOEiCVbijIMWn0yl3n5WsW1/hyaZBP/170TklWlF0t+bLMUyku6NTxUxye/fDOpBsJ3tvzBmvAfQbCB6CFrvrgZxG1OoSY/XdMgI3wnsMgzGWofUm8MUEQIRnAva/vePlJnXPeCQy7eLOOgH7hstFZhyRDneuGa3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gvfsv+RwvrnaGNa3S2wCCiEf1BGtgNm/l9LlImuMFMk=;
 b=HfSWPQBkB1jgUqTHY5njdBnzFfl7b6x2exxihCB0SFWJCwHDbpWZ8N6A2qkkIPnVccnhSe7vz96shqU25n8I2LAG+tdENTASOwCH3PPPNIELJnLosXgajlETO49/QPOwdmHAaTnqPevb/0XAA2/yGccYRBeCgDSOEvY0uhZMwzk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DS4PR12MB9748.namprd12.prod.outlook.com (2603:10b6:8:29e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 16:10:34 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 16:10:34 +0000
Message-ID: <4639287b-0fe6-4aaa-9720-c7f264019d06@amd.com>
Date: Tue, 6 Oct 2026 11:10:30 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: "Pratik R. Sampat" <prsampat@amd.com>, mcgrof@kernel.org,
 russ.weight@linux.dev, dakr@kernel.org, ashish.kalra@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
 aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
 shansinha@google.com
References: <cover.1791212077.git.prsampat@amd.com>
 <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0252.namprd03.prod.outlook.com
 (2603:10b6:610:e5::17) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DS4PR12MB9748:EE_
X-MS-Office365-Filtering-Correlation-Id: ae6b3206-f4f6-45f3-13d5-08df23c45a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|5023799004|11063799006|4143699003|3023799007|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	SKxhD2Ng38EPnaDQkmAh+7OLp9ieIfTUD5Hz95ij7aCv+kJdYhuGW/FOQqtpgS0Rbw1wbrXgPkqtY70tIiQW6BJdi8XMAdIxhsRYMqJ6xp52U23IOQ73USvT25RRwHjqpNisOL4rPMADDedK2hSoGF0GsiX8A2Owqsft3C7AB5XZaZuhzBvD1ayS4vNraAl9cZdbNL/4QEx0/zJ2Y5RB6u7z5dsR6TgFdIbl10xpoGcWTAiyqTau3CoW26gRis6c+tO0dF2PeBF3U07ZYqXTPuvJml793GHL8mt4ndqgfSbma7ZDtyBGyfiPju9ExM91LznILxSvMf+OWLzGtB+mmFm9jB8KSpYnIe6JJ6gl+mOebwBSra9gtUchqKfLb25mU9MFqp8ZZrDIjOkxAPUTKNcchHcNbdkTCc2OQjB4laQ0FsAQDocjboVHFZWEInRW6AOmf1/aSS9xfMek2sbWNQZZb49Gz4Dbx6IXtdZ/MmFK+cYEsdeYFPKy8dD31vJUGKbixGsIkEqvLnAjleW8Ts300I87n1var3PrcoMsilBHq2utU0BFdEUUSjFAYwMa0+EC0Mjq5tOGExne4QZLlWzUioo7Ls9kuoYGudE9PDi8AJH/hBoIgpWRNwrvz0t4+W8xxN0OMuEIGhLg5PpRpKoA8DbAV4IRi/QlyrZs7qg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(5023799004)(11063799006)(4143699003)(3023799007)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUNjczJrSVVFZHBmQUZjV2YxbllvVXNjZFV4aGdDbzNsamF2RTBubzJSem0x?=
 =?utf-8?B?Q0tSWWdrZjNySFkrc3U5Rkw1ME5ISDFmdmMwQU1Wbk5iRnowSGJmYmIwNEVl?=
 =?utf-8?B?SGV2a29ndDNoQkp6NFpWMTBkRS93N2QrTGFDOEFZR20yQ2E4Rjl5OHV1Y2Jr?=
 =?utf-8?B?bE9WNEhxUmxFSWh4UTRJMkxjMW9MamVRRndxK2QwOSs1UGFqY1M2VEFONXU0?=
 =?utf-8?B?RG9oZkN0RmdjUVBqMWVBdXExdDlzRUpzM3dJdURZdVoyV0dwQkZVNEE5dnRU?=
 =?utf-8?B?Z2V0eTBZQkttQ0Z5ZGEyNmUvMmFrVmhNWnhuY3JGazhTS1NPaU9MQmRDNzBo?=
 =?utf-8?B?VUdQaDRFdThYU3laL3hCc3ZtK3h1ekpHUzg3bzZ3SXU5NVl1OElWYXpDUzhK?=
 =?utf-8?B?M0tLT094UFZrU3lZOVJaZlB4SDd2dzBEUFZ6VkpZUkFpblJxbFBXRFlNVGpq?=
 =?utf-8?B?a0s1SStSNGxvS2FieVBKN3RranVBTHkrUDBGU05IMSt0YU83Mm41eGMwdS9S?=
 =?utf-8?B?dUMvTjRaTGlJNE1IZ2svZDhJd3NDK0dKQWpPYk5nUmlSUkR2aExaMkorNzBY?=
 =?utf-8?B?SnpiRGpjaHlKS2NkUllUUXNpVVlWM1BOOGtjTE4xZzRXdWNpMnRYSzRmZzFi?=
 =?utf-8?B?RW42UXpFMmlyNVQrRWIvZzlyOUc2VTNSd0J1eE9LWXFWcjFYUWg0bU5KOVB3?=
 =?utf-8?B?UnpBV2FJZ002UXVXK25PbXlrcWdqbGhLa0NuRm43ME9BNnlJL3RSMjBKNFM5?=
 =?utf-8?B?M2JkQVR3bWc2QTVqd0F6UEcrNWYrVjA1WWUzbitpVy90blFOZCtBN2M0cWlD?=
 =?utf-8?B?MmtOZExGQXVvbDNybUtXSitlZkMrNTRpbnFXM09aOVBqbXQ3dExiUWU3SXo5?=
 =?utf-8?B?Rnp0TDJLMElDK2JOSXZzK0VtZFdycWhNbzBDUFlyVjVKamZRK2ZON1V4c3JE?=
 =?utf-8?B?UW1HYi9oRi9GOGFCVU1GSHQ4SThFcDFMOHpBbTBzbStCMjB2MnFweDBJM2RV?=
 =?utf-8?B?NXlnUmRIMnZ3UUtPekp1ampHTnR0R0VIMGg3QjI0ak9ZdG1oM0JTOStsMUZJ?=
 =?utf-8?B?Z2h4NjhtTExZRDZqd0JHSm9tZjNRTmFOeDF0N0RNRkl2NHZVaWF0NGpTWGN2?=
 =?utf-8?B?d010SldMK2JFTGVieXE1Qk1LVVI3SFhkZm5uL0FiUmpsQ3FBYWZoZkwvQkJu?=
 =?utf-8?B?YVlpckQ5YVRTNWJrUkZWZHNwTTZlZDhJS240MWtuNG1McVpoVy93V3JRTnl5?=
 =?utf-8?B?ejNpYjM1M1lLaVRtYVN0ZTVEQkFVN2s4V3NCbEd6R2pxUVV4TnNZWmxYbDA1?=
 =?utf-8?B?dmgrODlkNTY1cG1SZnV0dGo0THl2UmZXVDI5UnJKdEthVVJGNmxUeHhQdjFM?=
 =?utf-8?B?Ylh1blF4YWlpNTdjbEdWb05CZ3R6cnRzcytvRzhIOHVjZW93NHFxZC96aVB3?=
 =?utf-8?B?cWx0Q0ZIT015aWFXWDF0Uk5QK0tVNCtLOHZjT0VIVHhMUlM2SHg5bjJrdllZ?=
 =?utf-8?B?SnAyeGlGWkRoRXZjNXdTZ01FZVBJLzlGTEFJWEdLUGxkUFBjM29hUzZYRVM0?=
 =?utf-8?B?ZVdjMXV4dnlmRytycFREMmJNbmZDcGV0K0JFQ0sxME9jZFRkY0RRVE41NFNK?=
 =?utf-8?B?NGtMd2gyc1QxS2NjM2J2MXl5VUlqZnYrZlVIZW1BSUYvSnBsalVac1psQjN1?=
 =?utf-8?B?Mi9kSE5LZTBvdmw0ZmRTcmhGd2g5TnBIQ3NwdUtSekJLaWpUVlFRUG5TM2l5?=
 =?utf-8?B?UncyeDFVc3hxSGxHM1NPeEYyMzZUcTdFOHhkWXpnTUJ5SEErYkxjSVhSV0F4?=
 =?utf-8?B?a0J2V0FZckZPUXpwL3BhLzVJVnJ6U2JDWTZzNEhwdXJBNkgydWw5RXlVM2ht?=
 =?utf-8?B?SFVpb09iNkdVQlZBdUx6d0xxMkgzcFJ5d2RuSngvYkhvaDh6Tml0YnRYYmVY?=
 =?utf-8?B?b1d2S3g5V2czL0RyNW9BVkFmdjJPUlc4NDFFcVVzbWpDNjRENjNNazROSTV0?=
 =?utf-8?B?Ukk0dFNGU0w1eTc1SmFwVHhvTi9YRW5WV0M0QTJJQXhiVGdhT1VCVytxc1d5?=
 =?utf-8?B?Q2RaUnNOSDVWTEw3MnQ0ZGpuSE12L2pqQnkwMWNRVUNrL1VWOUVXRk1mWkNu?=
 =?utf-8?B?aFF3Q3N1K29iU3plN2wreEcvRGdvUUtNQy8zVTJRK3o0aXd4bm5GWnMrOG9M?=
 =?utf-8?B?azVLYkJvYUFHNE5Wd2R3azkrNGdpUkY0eVhQV0ZlREFKbnRpRVo0cU5USG5j?=
 =?utf-8?B?ODJWbklLSW5LajBIR3djRzRyck9BSmd4UVQ3a2xIRXMvbGVsVXd1UURlQUQx?=
 =?utf-8?Q?9c15EI8eFnOPVBIHve?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6b3206-f4f6-45f3-13d5-08df23c45a50
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 16:10:34.6714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VWLRH9PDRgogkk9Y2pIihezrWbVG61hH566pcBHB0FuSO44UJ8TYqfMdsxGUF40wvP2ef2rkAOTbmzCe4KjKVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9748

On 10/5/26 11:15, Pratik R. Sampat wrote:
> Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
> command.
> 
> DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
> it is WORKING then legacy guests are running and the update is refused
> as busy. If it is INIT, shut it down, release the buffers the firmware
> owns across that shutdown, run the update, and bring the platform back
> up afterwards. SNP is never taken down, so SNP guests are unaffected.
> 
> To test run the following with your sbin file in FW:
> 
> echo 1 > /sys/class/firmware/sev/loading
> cat <firmware.sbin> > /sys/class/firmware/sev/data
> echo 0 > /sys/class/firmware/sev/loading
> 
> The COMMIT bit is left clear, so the image is only loaded provisionally
> and the admin decides when to make it permanent with ioctl(/dev/sev,
> SNP_COMMIT). To roll back, do not commit and upload the previous image
> the same way.
> 
> Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 284 ++++++++++++++++++++++++++++++++++-
>  drivers/crypto/ccp/sev-dev.h |   2 +
>  include/linux/psp-sev.h      |  19 +++
>  3 files changed, 304 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 88cf60a9640e..e54f23ba1b9b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -29,6 +29,7 @@
>  #include <linux/psp.h>
>  #include <linux/amd-iommu.h>
>  #include <linux/crash_dump.h>
> +#include <linux/sizes.h>
>  
>  #include <asm/smp.h>
>  #include <asm/cacheflush.h>
> @@ -252,6 +253,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
> +	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> @@ -2213,17 +2215,297 @@ static int sev_update_firmware(struct device *dev)
>  }
>  
>  #ifdef CONFIG_FW_UPLOAD
> +/* Largest image the firmware accepts, anything above is rejected */

I may have missed it, but I don't see anything in the SNP ABI spec that
says the limit is 512K. If that doesn't have a limit how did we arrive
at 512K?

> +#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
> +
>  static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
>  						const u8 *data, u32 size)
>  {
> +	struct sev_device *sev = fw_upload->dd_handle;
> +
> +	if (size > SEV_FW_IMAGE_MAX_SIZE) {
> +		dev_err(sev->dev, "DLFW_EX: image of %u bytes exceeds the %u byte maximum\n",
> +			size, SEV_FW_IMAGE_MAX_SIZE);
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +	}
> +
>  	return FW_UPLOAD_ERR_NONE;
>  }
>  
> +static int sev_download_firmware_ex(const u8 *data, u32 size, int *psp_ret)
> +{
> +	struct sev_data_download_firmware_ex sev_data = {0};
> +	int ret, order;
> +	struct page *p;
> +	void *fw_blob;
> +
> +	order = get_order(size);
> +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	fw_blob = page_address(p);
> +	memcpy(fw_blob, data, size);
> +
> +	sev_data.len = sizeof(sev_data);
> +	sev_data.fw_paddr = __psp_pa(fw_blob);
> +	sev_data.fw_len = size;
> +	/*
> +	 * Don't commit to the new firmware immediately, perform an explicit
> +	 * SNP_COMMIT after

Don't commit the new firmware, an explict SNP_COMMIT is required after
update.

> +	 */
> +	sev_data.commit = 0;
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data,
> +				  psp_ret);
> +
> +	__free_pages(p, order);
> +
> +	return ret;
> +}
> +
> +static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
> +						   int rc, int psp_ret)

Name rc something more specific, like cmd_ret, to better distinguish
what you're checking.

> +{
> +	enum fw_upload_err ret = FW_UPLOAD_ERR_FW_INVALID;
> +	const char *msg;
> +
> +	if (!rc)
> +		return FW_UPLOAD_ERR_NONE;
> +
> +	/*
> +	 * The command timed out: psp_ret was cleared and the PSP was declared
> +	 * dead, so there is no firmware status to decode.
> +	 */

Move this comment into the if block as it is explaining what happened if
psp_dead is set and simplify it:

"The SEV command timed out and marked the ASP dead, there is no status
to decode."

> +	if (psp_dead) {
> +		dev_err(sev->dev, "DLFW_EX: PSP not responding (failed %d, error %#x)\n",
> +			rc, psp_ret);
> +		sev->fwl_rollback_required = false;
> +
> +		return FW_UPLOAD_ERR_TIMEOUT;
> +	}
> +
> +	switch (psp_ret) {
> +	case SEV_RET_INVALID_PARAM:
> +		msg = "Provided image is not well formed";
> +		break;
> +	case SEV_RET_INVALID_LEN:
> +		ret = FW_UPLOAD_ERR_INVALID_SIZE;
> +		msg = "Provided image has an unusable length";
> +		break;
> +	case SEV_RET_SHUTDOWN_REQUIRED:
> +		msg = "Provided image cannot be live-updated, shutdown required";
> +		break;
> +	case SEV_RET_BAD_VERSION:
> +		msg = "Provided image < committed version";
> +		break;
> +	case SEV_RET_INVALID_PLATFORM_STATE:
> +		msg = "Platform not in UNINIT state";
> +		break;
> +	case SEV_RET_INVALID_ADDRESS:
> +		msg = "Unaligned address provided";
> +		break;
> +	case SEV_RET_UNSUPPORTED:
> +		msg = "Feature not supported";
> +		break;
> +	case SEV_RET_INVALID_CONFIG:
> +		msg = "Image rejected, unsupported configuration";
> +		break;
> +	case SEV_RET_BAD_SVN:
> +		msg = "Image rejected, SVN < committed SVN";
> +		break;
> +	case SEV_RET_BAD_SIGNATURE:
> +		msg = "Bad firmware signature";
> +		break;
> +	case SEV_RET_UPDATE_FAILED:
> +		/* The previous firmware is still running, a retry is safe. */
> +		ret = FW_UPLOAD_ERR_BUSY;
> +		msg = "Upgrade failed, automatically reverted";
> +		break;
> +	case SEV_RET_RESTORE_REQUIRED:
> +		/*
> +		 * Firmware requested a roll-back. Declare the PSP dead so
> +		 * nothing else tries to use it, and let the next upload through
> +		 * so the admin can restore the previous image.
> +		 */
> +		sev->fwl_rollback_required = true;
> +		psp_dead = true;
> +		ret = FW_UPLOAD_ERR_RW_ERROR;
> +		msg = "Live upgrade failed, please roll back";
> +		break;
> +	case SEV_RET_HWSEV_RET_UNSAFE:
> +		/*
> +		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
> +		 * firmware is indeterminate and the recommendation is to reboot
> +		 * the platform. Declare the PSP dead so the driver stops
> +		 * issuing commands to it while the reboot is pending.
> +		 */
> +		sev->fwl_rollback_required = false;
> +		psp_dead = true;
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		msg = "SEV firmware no longer safe. Reboot recommended";
> +		break;
> +	case SEV_RET_NO_FW_CALL:
> +		/* The command never reached the firmware. */
> +		ret = FW_UPLOAD_ERR_BUSY;
> +		msg = "Driver error";
> +		break;
> +	default:
> +		ret = FW_UPLOAD_ERR_HW_ERROR;
> +		msg = "Unknown SEV firmware error";
> +		break;
> +	}
> +
> +	dev_err(sev->dev, "DLFW_EX: %s (failed %d, error %#x)\n", msg, rc, psp_ret);

This is coming from userspace interaction, so probably should use
ratelimited variant (here and any place you issue a message).

> +
> +	return ret;
> +}
> +
> +static int sev_fw_upload_shutdown_platform(struct sev_device *sev)
> +{
> +	int rc, error = SEV_RET_NO_FW_CALL, sev_plat_state;
> +
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	rc = sev_get_platform_state(&sev_plat_state, &error);
> +	if (rc) {
> +		dev_err(sev->dev, "SEV get platform state failed %d, error %#x\n",
> +			rc, error);
> +		return rc;
> +	}
> +
> +	switch (sev_plat_state) {
> +	case SEV_STATE_UNINIT:
> +		return 0;
> +	case SEV_STATE_WORKING:
> +		/* Legacy guests are running, the update cannot proceed. */
> +		return -EBUSY;
> +	case SEV_STATE_INIT:
> +		break;
> +	default:
> +		dev_err(sev->dev, "Unknown SEV firmware state %d\n", sev_plat_state);
> +		return -EINVAL;
> +	}
> +
> +	rc = __sev_platform_shutdown_locked(&error);
> +	if (rc) {
> +		dev_err(sev->dev, "SEV platform shutdown failed %d, error %#x\n",
> +			rc, error);
> +		return rc;
> +	}
> +
> +	__sev_release_firmware_buffers(false);

Do the buffers have to be released? If so, why? I think you can keep the
allocations. During platform initialization the buffers will be
detected. Is there a shutdown path where they might not get freed?

> +
> +	sev->fwl_reinit_required = true;
> +
> +	return 0;
> +}
> +
> +static void sev_fw_upload_reinit_platform(struct sev_device *sev)
> +{
> +	int rc, error = SEV_RET_NO_FW_CALL;
> +
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (!sev->fwl_reinit_required)
> +		return;
> +
> +	rc = __sev_platform_init_locked(&error);
> +	if (rc) {
> +		dev_err(sev->dev, "SEV platform re-init failed %d, error %#x\n",
> +			rc, error);

Single line.

> +		return;
> +	}
> +
> +	sev->fwl_reinit_required = false;
> +}
> +
> +static enum fw_upload_err sev_fw_upload_update(struct sev_device *sev,
> +					       const u8 *data, u32 size,
> +					       u32 *written)
> +{
> +	int rc, error = SEV_RET_NO_FW_CALL;
> +	enum fw_upload_err ret;
> +
> +	guard(mutex)(&sev_cmd_mutex);
> +
> +	/*
> +	 * A PSP declared dead only executes DOWNLOAD_FIRMWARE_EX if it was the
> +	 * firmware update that killed it and asked for a rollback. Declared
> +	 * dead for any other reason it will not answer until the platform is
> +	 * rebooted.
> +	 */

"SEV firmware will only successfully execute the DOWNLOAD_FIRMWARE_EX
command if a firmware rollback is required. Other commands may be
processed, but may not execute properly. Use the psp_dead boolean to
restrict execution to this path."

Say something similar where psp_dead is being set to true in
sev_fw_upload_handle_err().

> +	if (psp_dead && !sev->fwl_rollback_required) {
> +		dev_err(sev->dev, "DLFW_EX: PSP is not responding\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +
> +	/*
> +	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.

I see a mix of DOWNLOAD_FIRMWARE_EX and DLFW_EX, change these to all be
the same name of your choice.

> +	 * We being in this state means that the legacy firmware has previously

s/We being/Being/

> +	 * been shut down, so no need to do it again.
> +	 */
> +	if (sev->fwl_rollback_required) {
> +		psp_dead = false;
> +	} else {
> +		rc = sev_fw_upload_shutdown_platform(sev);
> +		if (rc) {
> +			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR
> +					: FW_UPLOAD_ERR_BUSY;
> +		}
> +	}
> +
> +	rc = sev_download_firmware_ex(data, size, &error);
> +	ret = sev_fw_upload_handle_err(sev, rc, error);

Maybe it's just me, but using generic rc and ret can make this possibly
confusing in the future. How about:

s/rc/cmd_ret/
s/ret/fwl_ret/
s/error/psp_ret/

> +	if (ret == FW_UPLOAD_ERR_NONE) {
> +		*written = size;
> +		sev->fwl_rollback_required = false;
> +	}
> +
> +	/* A rollback retry failed. PSP now stays dead */
> +	if (sev->fwl_rollback_required) {
> +		psp_dead = true;
> +		if (ret != FW_UPLOAD_ERR_HW_ERROR)
> +			ret = FW_UPLOAD_ERR_RW_ERROR;
> +	}
> +
> +	if (!sev->fwl_rollback_required && !psp_dead)
> +		sev_fw_upload_reinit_platform(sev);
> +
> +	return ret;
> +}
> +
>  static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
>  					      const u8 *data, u32 offset,
>  					      u32 size, u32 *written)
>  {
> -	return FW_UPLOAD_ERR_BUSY;
> +	struct sev_device *sev = fw_upload->dd_handle;
> +	u8 old_major, old_minor, old_build;
> +	enum fw_upload_err ret;
> +
> +	old_major = sev->api_major;
> +	old_minor = sev->api_minor;
> +	old_build = sev->build;
> +
> +	ret = sev_fw_upload_update(sev, data, size, written);
> +	if (ret != FW_UPLOAD_ERR_NONE)
> +		return ret;
> +
> +	if (sev_get_api_version()) {
> +		dev_err(sev->dev, "SNP platform data refresh after firmware update failed\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +
> +	if (sev->api_major != old_major || sev->api_minor != old_minor ||
> +	    sev->build != old_build) {

One line.

> +		dev_info(sev->dev, "SEV firmware updated to %d.%d build %d\n",

Should be the same as the sev_pci_init() issued message.

> +			 sev->api_major, sev->api_minor, sev->build);
> +	} else {
> +		dev_info(sev->dev, "SEV firmware version unchanged: %d.%d build %d\n",

s/ build /./

Thanks,
Tom
> +			 sev->api_major, sev->api_minor, sev->build);
> +	}
> +
> +	return ret;
>  }
>  
>  static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 7ec692e2147e..1e45a08c41da 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -71,6 +71,8 @@ struct sev_device {
>  	struct sev_tio_status *tio_status;
>  
>  	struct fw_upload *fwl;
> +	bool fwl_rollback_required;
> +	bool fwl_reinit_required;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index fab62228f981..b71154e9ae4b 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -890,6 +890,25 @@ struct sev_platform_init_args {
>  	unsigned int max_snp_asid;
>  };
>  
> +/**
> + * struct sev_data_download_firmware_ex - SNP_DOWNLOAD_FIRMWARE_EX structure
> + *
> + * @len: length of the command buffer read by the PSP
> + * @rsvd0: reserved
> + * @fw_paddr: system physical address of the start of the firmware blob
> + * @fw_len: length of the firmware blob
> + * @commit: whether to immediately commit the firmware update
> + * @rsvd1: reserved
> + */
> +struct sev_data_download_firmware_ex {
> +	u32 len;			/* In */
> +	u32 rsvd0;
> +	u64 fw_paddr;			/* In */
> +	u32 fw_len;			/* In */
> +	u32 commit:1;			/* In */
> +	u32 rsvd1:31;
> +} __packed;
> +
>  /**
>   * struct sev_data_snp_commit - SNP_COMMIT structure
>   *


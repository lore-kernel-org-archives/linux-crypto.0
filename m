Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FEB442373;
	Fri, 25 Sep 2026 21:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790370699; cv=fail; b=BAZMKg65Ybh42bgJ7qZOCDFRR9q2q96Sll3uxZZW+RBiKU0eFbmBZ8tp2oxZ5cFfMfXVAyTaPAi/jkfpvIvKcuKXc1wbfpmCHfO1XXSk8oq2bZtCJWSJ7arSLGvTAfph82XIobIKfuuXXv3h9onCGFYEcF0seeYJ9+YPyTawIuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790370699; c=relaxed/simple;
	bh=/n76NI6Zt76tNkx5UgNLpDpGkk4ictduMvAkqnvFdHQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kqv60GBbxnCygwl66YPN6YzZG9jZpfJBqqi3F160VViCdcEtIAnoq0lAS91zt6I/rhvuW9TGrmcLYVxErsUQOCugfXqAaJB0NPvAnCAev11WyAm1oSPV9k2J2/xKB4e8xOrsvv4mxVxtWaGeu+gLeJwHrYHg0Fh5PSp/ArgVXJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jTOMelZ+; arc=fail smtp.client-ip=40.107.209.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jTOMelZ+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aBrpA6f3DWIpq7GIyNz7Wp5OG0oullAa3yfMdPZtAiED5mtRHl7tbnnXUSKJGE8HW/W2CxpvDX4/KMR9ahE76xm5pph6bXHAq83rWKyIW20fhGaDinHLeYhu0lmTRG0Aid58EjzIhfxn4etdqAjc2mBeE+gjSCPSX4SuKmI06ac55b0ZgjQeiSK494z/INQRfu+PH5HWg1y6uLHwMS5Ct3LRjrARllH6Cze5drP4bTrzJ1AdeWgYC6u/RZnBRjRMjbaV2aVtc1hF4469+DmKpjGXTZX/1BV4Q1mkCwp/RexukrqJN4dWrDxCp1HTH3bEtMlSe2K4xKAUBnAzF3ZUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5u+zh3bwEFdcG7EuK77yuaD8ZR4LULd7MQAauMgx7s=;
 b=G8j8uiCyZL0O2WRUnPV9RttrsUqlcoGGuLk75+peqMYzGhp0FcIgqZpklsxpvXVwWWi15cSpBkv4HbwCRbKWUn//jO/cmXQTD1UEITlM3g5YVN5pWx0j/a0vzIfu28VyfZW2o1UibaeRkXVSVylMS9Dga75FrhwMgioA7A7a3mRcGpNzNVpUQRqgBlPEuDzIBu4kx1eA8yxxs8JVvaML1ckygEpQzvBqpQmTHhavUPoMFDhwQ/jE2XBq+2uP8N+2/L2YQXt5pRsUGN/CMgfD5TRPlPklr7lzcWaW9+TGVYx1Q8j5PxmacpWz3jNq7jHRV0OFRojVIfavat/fzzqmPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5u+zh3bwEFdcG7EuK77yuaD8ZR4LULd7MQAauMgx7s=;
 b=jTOMelZ+FhIr+UDvSNTSiWJV5agaOKy8YVXE+VQEUAp+Qzfx4zijlC5Ujxd6keCp11wIZeRYeKle1pAvDzAFmVEUylXupq3hV3ZFweShJRQOYkENxa9oa/EMvxjK6BB58oM9mTqhucNR9HXoQWbCp0sZwGZUCY7ntvijGHR/fG4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Fri, 25 Sep
 2026 21:11:35 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 21:11:34 +0000
Message-ID: <4cb82167-9459-4664-9129-cc9d0f44a0a1@amd.com>
Date: Fri, 25 Sep 2026 17:11:30 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 7/7] crypto/ccp: Implement SNP Download Firmware EX
To: Shantanu Sinha <shansinha@google.com>
Cc: aik@amd.com, ashish.kalra@amd.com, chao.gao@intel.com, dakr@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, mcgrof@kernel.org, michael.roth@amd.com,
 nikunj@amd.com, rafael@kernel.org, russ.weight@linux.dev,
 thomas.lendacky@amd.com, tycho@kernel.org
References: <cover.1789749016.git.prsampat@amd.com>
 <3463e8ce7b925d8cade35cf9d98b96bc3fc619b4.1789749016.git.prsampat@amd.com>
 <20260924213737.3833625-1-shansinha@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20260924213737.3833625-1-shansinha@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::27) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 1989dd38-a39a-4257-4280-08df1b499457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|4143699003|10067099003|5023799004|3023799007|11063799006|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	UuVyAYAdTXrqF2+hksebpnQ0woM+ZA3vZqgItQmN5J/qmOPKBtHeJD0eSq+Cj3s2eMuhhxSivsSPIU70/75rgeNp4hGBRMeyFYT5HvKRIDpz+hPOymnL7stxEXd/D7uj3D197KTexhNSjsbtoE/JWnVjzzboXCyveixX9lpzx/Cvo6sq1gqAXJCdIPMAU19GvRCYuzS0LMKc+PQ5Z9veVhrpM2WSqgrZIoqHhMaa1tfh1Gqpj94JBhB05c9M8PHEEkBV7WYFvLSgGcH++NMihL/Vduy3a3HicEOTc1oLigjaC4gkM7vw3BO+QdfCGKb7CfhvBQl1NVfHKSNu4R9SJPm59g+tka/hcz/q5FBj+HkkQzYYXvmbvwuN3hUFJkn5Vf/NT4QtrcWZypW8yhteU6dWh5Jyof0QiqEp0n93/ax2tgOblshDJyb0PWg+6rinHF4sM3n2GXtDVTC385X3Fnbvhm00uyuCgtLUQBoYRmJ74V8aSVR1Ks3mzAJtMDFJP9yX8wtN0M0nreS6JiJOfXtR/EsBAzrScWUYgAvqnUjfNHLupwUjERcS1QMSSXPCUNWWfdjxcwkVDA+zra/oDJhnOB2MFVMovQYFDPJdyFDswrREUqR4mdA/ORttad1ye96iFjolNxZ7sS32zBcxpFhcwnt5/vNCdw1WbJN7ZPs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(4143699003)(10067099003)(5023799004)(3023799007)(11063799006)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bER1VjM4VTlONDlkcnRuMGdzeFZXN0lmZHU4UkVoTCs5RXVhTXVoOFEyNURY?=
 =?utf-8?B?Ym1WQnFLNGhndGxOMXpMNm11MWk1MzZDU0gxeVRGUUdBcnNSalVDZmFjN0xU?=
 =?utf-8?B?cU1kWDEzdzRuRGVUT3EzenBJUk5Yek43R1JXUUNmaVZrZ2F4RU16NVowbWh0?=
 =?utf-8?B?TGxVQzdTaGppVFhWeGw2V0lvc1NMSFU5bUlUdjVFRG1ISHpJMzVaTUgwSkJG?=
 =?utf-8?B?QmliYTBPdWZyNGJIK01XYTEzQ0lLcWJaMGdWS0wrV1hKNVhLM1AxV3BqZzNz?=
 =?utf-8?B?RVpNRGhUM0lkNWJOak9CL3Y2b1pDNFZGb0JCU0RIUlhBL05pS1pGQnhBVndk?=
 =?utf-8?B?aGw4OXBZMzh1cWwwdUZXeW9lT1dxQmw4bUFVeS9sRG1BZ2Vnc09jSEtwRUsz?=
 =?utf-8?B?RWdrcmpDVnJaa21adzVGQk5RekV3Z2hCQkNONGdjbkV5SHdoMUtIazZxL05Y?=
 =?utf-8?B?LzAxQ01lU0JxOC9Odkc0MmFFWHRPaFBTOURQOWdnalROblNtRlphSVpHa1Jt?=
 =?utf-8?B?ZElDblNaOURSNmJac1FsbjRHNDZIeFZDcC95TG9LMWR6azlrZ08xOGQrdUhl?=
 =?utf-8?B?YVZmM25wOWhwdFUrQUIyT2sxZGpwOCtDY09raE5LaVJ2cWk3TkRhVC9NMVk4?=
 =?utf-8?B?NVdHUWtKbm10bS9BbFhISnQ2OVJKYWgzUXZzME9BVjZhblVJdncrOE4wU0to?=
 =?utf-8?B?NDI1Z0FiSVVnWGNzTE5Zbys1R3hQNDlUY1JETUlmOGNRWUZJdnR6OVdweTdN?=
 =?utf-8?B?WjhvVmNCdmExNDdlTlFONG8zMkM0LzlRT1IrTW9SWEI4S3BUaXFsaysrN0lr?=
 =?utf-8?B?Ujc3Zkp4dVVvT1pGT2Vhb29VN0JJUm9PcmRWdXNhUmc0UGJveExlQkZsaXlN?=
 =?utf-8?B?MzJxR0hUdVFFNDFKOU0xSHVBQU5RWTFiWm1uR1VvVDA5a0ZSbWl4UTFqRzF5?=
 =?utf-8?B?ekp3RHpscVgwQ1F3djZ3a09uWVJWejFNdjM5dzFaWjdhK2hyVHN4U0l3dVdL?=
 =?utf-8?B?QmJrVmU2bU1GU00yMFhHQVdRNEpXc01kbTFsaFFHZUxWTG0zUlo3SVpERTM0?=
 =?utf-8?B?UGFXbGJPcktzbHBVRjNIUkdpY2pRL25GT2tSTnNPVkhxcUltaUY0NGVQYldC?=
 =?utf-8?B?QmNSeFpXWDNSOS92WFhTWTZOMmduTmNnMEhRL0kyWXU0RVBKTVY0RHNDSFNO?=
 =?utf-8?B?RFp3TGhoT1pXVjUzSG1KbXQ5MHVMOTQxZEZjNXRFN2pTS3Z5alJ2Q2FXaU9F?=
 =?utf-8?B?eTM0SnB1bGlXcnh0b1NKYmxvZURPblFtcjFmSDM5a1JZUm9MUWx6YmVxaEpX?=
 =?utf-8?B?cDJZZWt3cEVjZC9kU0llckxWTXpjbnJrcUx5c3VLanNFek03dmc1aElwdjdK?=
 =?utf-8?B?eHNtZGVSa1VHTVJDdzdJZFRyQ2p5NGNzbmFaejh4VWx6QkF4QlFqZlFxeVdQ?=
 =?utf-8?B?WUlrUTY5SXFJbkRYRmxwNTQrY2hHeUZhSnBSOExPbHpuSXdpZUM1WHBEaTUr?=
 =?utf-8?B?THRQT1ZTbDFkVUFEWWJwUENkeitzbGdxTE1yanhhZ0lRR3AxMnZQSXhMVHZG?=
 =?utf-8?B?bkFHWm5hM1ZFRWk3U1lYdHN5K0x4YmRUaFlYd2I0bnJ4WExSZExBVlBMWmpo?=
 =?utf-8?B?NjBrMHZtMlhNRkNPQ1d2bXZBTmQyeFNEa0RaanZuWEJvbm5HM3pHN2hodWpw?=
 =?utf-8?B?S2dLWW5pZk81Z0ZqV1NzZ0pKdmxVTXlmT2xoR2JpRHJhV2pzS3grcitkNXVQ?=
 =?utf-8?B?Smx4V3NJUjJKTFdnNW0zbzFDeWdEaW5SampmWEttYkF1WEtHU0psUmNBcjdy?=
 =?utf-8?B?dmdpb3J2VkxWMjNhWUJrd1U2eVdIMjZzZ0Excm9lL2tNZlV4M21leHJnWjlS?=
 =?utf-8?B?MUMyNnh5dnU5bktzNGE3d1dPMW5DM1ptV1ZjTXZnT3RxL0F6NjZXMThsdFh2?=
 =?utf-8?B?enhwaklaQ2ZMYmtTNHd4Szl4U3JTdXVLSlpLMTU0ZElkcVp2V1Z0eFBDL2o4?=
 =?utf-8?B?c0o0NUJUcUczV1V3MER6TFpRQUxEKzdGcVJwaDY1Tld3UTlvbnROdVA1VTVN?=
 =?utf-8?B?VDJtT0M1cE5hVU81dm5jSVZLYUMvNW1vdEs3aUNIVnRMOFdYNHV5bTlJWDBR?=
 =?utf-8?B?NWtEa0NSK1dWeGZJTWhMWnhObXdUODN1dkQ5czZaaFJLQm1jSDFnNGtoWnMr?=
 =?utf-8?B?SUhSbDRPam1TQVdPTnZzdkt4Qm9lRTdKSlgzcWR4eXZ3Z1JyWk1RWVVyem5q?=
 =?utf-8?B?YklWT29zaWtrT3dzSisxVnBUUGlybTVjTmQwZjJ6b2FGdW9NN2h2UDNtcm52?=
 =?utf-8?Q?UO1pxXPYk+554OsvwL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1989dd38-a39a-4257-4280-08df1b499457
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 21:11:34.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MDQwOWObss+xdxvseZt6YRu9fzNkj3+TXoVvMr4Ag/+ie7q1mR3B9hIb0+5gjxsLRF7FkQPAQG4o3o5Aql/1BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431

Hi Shantanu,

On 9/24/26 5:37 PM, Shantanu Sinha wrote:
>> +static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
>> +						   int rc, int psp_ret)
>> +{
>> +	enum fw_upload_err ret = FW_UPLOAD_ERR_FW_INVALID;
>> +
>> +	if (!rc)
>> +		return FW_UPLOAD_ERR_NONE;
>> +
>> +	switch (psp_ret) {
> [...]
>> +	case SEV_RET_UPDATE_FAILED:
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		dev_err(sev->dev, "DLFW_EX: Upgrade failed, automatically reverted\n");
>> +		break;
>> +	case SEV_RET_RESTORE_REQUIRED:
>> +		dev_err(sev->dev, "DLFW_EX: live upgrade failed, please roll back\n");
>> +		/*
>> +		 * Firmware requested a roll-back. Declare the PSP dead so
>> +		 * nothing else tries to use it, and let the next upload through
>> +		 * so the admin can restore the previous image.
>> +		 */
>> +		sev->fwl_rollback_required = true;
>> +		psp_dead = true;
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		break;
>> +	case SEV_RET_HWSEV_RET_UNSAFE:
>> +		dev_err(sev->dev, "DLFW_EX: SEV firmware no longer safe. Reboot recommended\n");
>> +		/*
>> +		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
>> +		 * firmware is indeterminate and the recommendation is to reboot
>> +		 * the platform. Declare the PSP dead so the driver stops
>> +		 * issuing commands to it while the reboot is pending.
>> +		 */
>> +		psp_dead = true;
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		break;
>> +	case SEV_RET_NO_FW_CALL:
>> +		/* The command never reached the firmware. */
>> +		dev_err(sev->dev, "DLFW_EX: driver error %d\n", rc);
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		break;
>> +	default:
>> +		dev_err(sev->dev, "Unknown SEV firmware err 0x%x\n", psp_ret);
>> +		ret = FW_UPLOAD_ERR_HW_ERROR;
>> +		break;
>> +	}
>> +
>> +	return ret;
>> +}
> 
> I've been trying to work this patch into our current workflow and
> running into a slight issue. My goal is to cleanly distinguish 
> between the following failure outcomes and their associated actions:
> 
> 1. Rollback to the old (committed) firmware: SEV_RET_RESTORE_REQUIRED
>    (0x25), where the PSP did not auto-revert (psp_dead == true &&
>    fwl_rollback_required == true) and will only accept a
>    DOWNLOAD_FIRMWARE_EX upload of the CommittedVersion binary to recover
>    the host without a reboot.
> 2. Retry the update: device busy / legacy SEV guest active
>    (SEV_STATE_WORKING), driver-side -ENOMEM (SEV_RET_NO_FW_CALL), or
>    SEV_RET_UPDATE_FAILED (0x24), where the PSP either auto-reverted or
>    was never modified (psp_dead == false) and remains healthy on the
>    previous firmware.
> 3. Abandon the update due to a fundamental image or precondition error:
>    bad signature, malformed image, version/SVN check failure, or
>    SHUTDOWN_REQUIRED, where the PSP rejected the command up front and
>    neither retrying nor rebooting will help.
> 4. Reboot the host: SEV_RET_HWSEV_RET_UNSAFE (0x14) where the PSP is
>    permanently disabled until a system reset.
> 
> Right now, the same user-facing error in /sys/class/firmware/sev/error
> (FW_UPLOAD_ERR_HW_ERROR / "transferring:hw-error") is returned across
> states 1, 2, and 4 above (SEV_RET_RESTORE_REQUIRED,
> SEV_RET_UPDATE_FAILED, -ENOMEM, and SEV_RET_HWSEV_RET_UNSAFE). Because
> psp_ret is only logged via dev_dbg() in __sev_do_cmd_locked(), userspace
> tooling only sees "transferring:hw-error" in sysfs and has no clean way
> to tell whether to roll back to the committed image, retry, or reboot
> the machine without scraping English strings out of dmesg, which has
> been finicky.
> 
> Could we do a closer review of the error reporting here and potentially
> include (rc, psp_ret) (matching the "failed %d, error %#x" format
> already used in sev_fw_upload_shutdown_platform() and
> sev_fw_upload_reinit_platform() below) in every dev_err() output so the
> exact driver return code and PSP status code are always visible in
> dmesg?

Agreed. Having better error logging by adding rc and psp_ret should help.

> 
> Alternatively (or alongside that), we could also separate the enum
> fw_upload_err buckets so those four outcomes map to distinct sysfs
> errors:
> 
> - Keep FW_UPLOAD_ERR_HW_ERROR for fatal states where the PSP is dead
>   until a host reboot (SEV_RET_HWSEV_RET_UNSAFE, or when psp_dead is
>   already latched).
> - Use FW_UPLOAD_ERR_RW_ERROR for SEV_RET_RESTORE_REQUIRED (where writing
>   the committed firmware image recovers the PSP without a reboot).

This error return seems a bit of a loose fit to me. It isn't an error reading /
writing, rather it is the failure of the platform having partial success
applying this. IMO, it should be in the same bucket as FW_UPLOAD_ERR_HW_ERROR.

> - Use FW_UPLOAD_ERR_BUSY for retryable states where the PSP is still
>   running the previous firmware (SEV_RET_UPDATE_FAILED and -ENOMEM,
>   alongside SEV_STATE_WORKING).
> - Keep FW_UPLOAD_ERR_FW_INVALID (and FW_UPLOAD_ERR_INVALID_SIZE) for
>   permanent image/version rejections where the update should be
>   abandoned, and add case SEV_RET_BAD_SVN: alongside
>   SEV_RET_INVALID_CONFIG so an SVN check failure returns
>   FW_UPLOAD_ERR_FW_INVALID instead of falling into default
>   (FW_UPLOAD_ERR_HW_ERROR).

Agreed with the rest.

> 
> As a side note, I think -ETIMEDOUT is not handled properly. When a
> command times out in __sev_do_cmd_locked(), it zeroes *psp_ret = 0, sets
> psp_dead = true, and returns -ETIMEDOUT. Because
> sev_fw_upload_handle_err() only checks !rc before switch (psp_ret), a
> timeout falls into the default case, prints "Unknown SEV firmware err
> 0x0", and returns FW_UPLOAD_ERR_HW_ERROR instead of
> FW_UPLOAD_ERR_TIMEOUT.


Ack. Thanks for catching this.

I'll work in all these for the next iteration.

--Pratik

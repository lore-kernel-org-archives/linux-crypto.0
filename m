Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533A5373C17;
	Wed,  2 Sep 2026 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371052; cv=fail; b=t3Vx7h1W3gcfUsxHIG0nyI5Fvg1Pb+CoQqgYvXQPUZtrvQ32JM78urmaD3gBXj3lUlHxMMMbIDnf28Ej7ZQ2yuUmjjNGpqReT67Fceos0nnAzxxviNMUUXM0VKjOO/WYghXtp4YehBcfQkUl/62AG/rTB40ix6p54OTxyuFWufQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371052; c=relaxed/simple;
	bh=EZ9UCOR4jD6zPsYjiFp/1Y2wfcfS0y5XjOsteE/iVAQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VSd0gtWlImdcYdVv0LZ2seOHejSxpFsOeXsY8lG5MULAeUuQGlBnhfmMcc5n/XUNk2j3wfjv4ID9ybp8eiilXLshWkgZWFWyG1U+g1nC4/Aa7dzgjflWndELSvANyjWSzaXYQBGcRLKEx6bm4/n0JSHbSpssZaqWj6EK+0AsbxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yhrMC4Vd; arc=fail smtp.client-ip=40.93.194.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yhrMC4Vd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0vgS0dIyP5W7X/hqtwtspwqDm1rgYuO1QaiAm3tRDHs9OVCaL7b6SweIIDxydCOea7vpTedzaLIcuyZYt0hfXI+1AU0BOZQVbTceF0UaTEKwvuyY8SrQg+P0ACoNCladEAnxH5fOQqW501B7126fh/p/cSXqs6MwOUf0TbuvCypwSAzwq3pGS6rYqOTQF5NRaI8aB1bceJDLKQ73QH3BvXgq1ZQ1P98qRmRLL7ybmyXEBz4aPcTEdZaPn1nRAuEn/7UjAOQaTGFV11JobrV6wjpGYgt2i9rQKFzPYL+jcLwJ+0tQTDCNHXvs4sp1+Fex0HEYf+LCDk0CUgDJ6ji/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1LrR6A4EGpHyvgi42uig9x/OYlBXj3XpgOI5GUo4cE=;
 b=cJ6fr3ofhNKcKNlCtewUxGDfdiV37n/qC+IfoENQT+W30nHxeMilqDYE+bTgpi3cdNKcz74Gp5p1AqtKQyxC1cTUFrgUj8yNvomRjCrsTs+n3YrP0vzxYFclCJDS3LbqAOjXzuf4+jKRFRDYEA2P7zseuKiJNteeUhn5A+RZGUpSeEyFdpprJit2xr2JT57Dbrc/e2PSXXEg4xTMl9BHHoYzdtDo4S6FCWE7yPYgu7+rp7Pt68LE+eJiKfj+qFmJIg1KPwI62Vt4iGU8PW9Tcbwm5GssohvEhgwckZrVSfpaEtcr2jHwO54eJeReOxJK3K0Y/DyBz4TZGs7pMpU/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1LrR6A4EGpHyvgi42uig9x/OYlBXj3XpgOI5GUo4cE=;
 b=yhrMC4VdhjqVULnFNnmvkxjC8UAx/NOjH0bCeQErlPMPDGMNLgRFIC5Ik/JGXydPTscTpKgGIxGkw7z34knTSxm8ZT5vl1nWlOy0RVtDktErbWjFUaFcNCvAnKDQm7RFpkgk7iSjJXJHntiRFRS5w+V5YbfwPg+tmcuKm3AZT6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by SJ2PR12MB9162.namprd12.prod.outlook.com (2603:10b6:a03:555::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 17:44:05 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%5]) with mapi id 15.21.0382.007; Wed, 2 Sep 2026
 17:44:05 +0000
Message-ID: <cf23d9ee-2bae-4393-8435-c04a80778069@amd.com>
Date: Wed, 2 Sep 2026 13:44:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] crypto/ccp: Implement SNP firmware live update
To: Shantanu Sinha <shansinha@google.com>, tycho@kernel.org
Cc: jackyli@google.com, aik@amd.com, ashish.kalra@amd.com,
 davem@davemloft.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 kim.phillips@amd.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, michael.roth@amd.com, nikunj@amd.com,
 seanjc@google.com, thomas.lendacky@amd.com
References: <20260430160716.1120553-7-tycho@kernel.org>
 <20260831204757.436751-1-shansinha@google.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <20260831204757.436751-1-shansinha@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAP220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::25) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|SJ2PR12MB9162:EE_
X-MS-Office365-Filtering-Correlation-Id: b260ff8e-e283-4b27-b43c-08df0919c858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|22082099003|56012099006|10067099003|11063799006|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r2Et89PExkE7WJ635GVCXy/DtXXMhGDrT+8Tbi7XhlKiBpb40+HvnnseIMuzm+0QLFMduOZaiNKhOokPNJJytyXPsV5dbmq7GONS7lLh+GCb99F3rJ85aPmGoPGt5r0vws+b8WqvK7GwyjEAe+nR4ksTWjpObVnBTwNDnA5tX1YFLoOrdkxpXrnIjqnWUJnsRRR2x4VNZnJSJHJyRdwQ2jzyow5piaduQx3w4muTpm5wUeQoC1MD4+4M/Rluyy7PPI8Mh9/JPKdljlxl/kZCf3h/rqfgSYX5p1AgSRTBoYZxPVIOJBAHLLDh9nH2/1y3VlFTvgKRh8/71/8T8jp91nofWslvmkTry9ldKQmXnZ8O41iAcXtcY+XFPLIC1WKHBsvrpJGPgWwGASiQ43wHPmt8PzbLMMj571mNQJkN1ALfWWw6OJNmkWL3ThC5gmJuXUmimTS4kMmlGp0ePmCqD91gaayLpEEM46bP9LEmuYX0F4GNpdNhHV3xsjLSvpzMnvNcAID1EV9GdqT3W9QDu+xXQjaafgxW0DD8ZabgjtRNnYE6tRX3H8b8RuFTWE9ncdsafe7zu0YGQ+NlQS32r///Lw/qHxX/6sTLR64PlQ6VJBGM42Hi+wgaHEy9fa5gUp8FLkiax82rZcT6hlokveqqEz+50mai+cpKlkw4+KI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(22082099003)(56012099006)(10067099003)(11063799006)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnh4cTFISFcwZERGZlFRc3ppcGl6UTBhR0V3MHRpMVI4U0dnc2NMY3U5Qkdw?=
 =?utf-8?B?NU1mVHgyK0FiUlZMZXUzWEhRWUJCTmNGM0swSDZzc1NZS1QxTnZPQmplRk1H?=
 =?utf-8?B?cXdpT3VoTXV4bUkzdjVWSjE0RE1MNUo3eit3cFZSYjZlUWZSdFdjdmdEaEhm?=
 =?utf-8?B?WlFrK2p5M2lXU044eVZqMjVqcFd2ejNWc01LU1B0cWV3Q2NaQStUc0h4bGFh?=
 =?utf-8?B?OUxBRWdpNmVLRU1FcVkxNTVGQVhUS3J3dFRJQkU3SDRRQUpnc0o4Rkl5Um03?=
 =?utf-8?B?SmZIcitDMGVmL1cwczZaaU91Wlc4Vk95anFiaCtZTGlKQ0hHclp4ZWR0dDhw?=
 =?utf-8?B?SGxXcmNwRG5LTXROaURrYng4RHNSRm9CeUpWcXg1RG9MZjU5a1NmYzdyNlZ2?=
 =?utf-8?B?bmVXU2dlZ2V2TEJuK2NaZUhGeWIxQ2RDQVl4ek9rd0xwVmxLaUppY2hTaHZ3?=
 =?utf-8?B?ODloTWczbWJGZVNValphd0hTUW84RHVWYVlSYnNmaDlxOC9LNCs0cXpSZ0JO?=
 =?utf-8?B?d2cyZWE2cUhmNktNTGNobXI3MEcyRk5IUEYzVG0zWE9oVkwzcWlBQnJydDFH?=
 =?utf-8?B?YVY4eU1abEV0WjNHTC9NdUFhUnVleVhHOHJyV1dkQW9qSEdSQ0JFdG04d1lE?=
 =?utf-8?B?RWF0RkJDQ0M0Q0pONUZ0Y2N5Z2c0U0VBYjRPSFlXdmtZd0wvQU1IbWlKb2xt?=
 =?utf-8?B?ZU5vZzk4WGR1M3Z2YWZnZHhlOG9wbzFVeDBNKzVQMkhudTV1YWtxUEFaaGpw?=
 =?utf-8?B?b1lMTHZUMHNVMVZjbEVOZmp5cEVKM2tnVXdZV1g3VXhmRVI3ait6RGZNVVlR?=
 =?utf-8?B?SlNqaXFwSVJqUjU4TkFLZTFHdFFienFBcndTZjBqNXZKYU1SLzJ5a2IzU2Nk?=
 =?utf-8?B?ajdtUVdGcnhvMUhnY2ZhWm5zbUw3Mkd5SDBLTkZoQ0V4eERIc0xUT2gzUG5X?=
 =?utf-8?B?WHFpUU56QWI5NEduamNJbkFMM0N5VXl2TnB3SWp5R3pINk5YN0E2M2E1SmZN?=
 =?utf-8?B?NzArcm5DRmlYTmdzTU9QYjhWeTN5SFpVVURZbnRzVllac0lFaU42QldZRnJq?=
 =?utf-8?B?ZXJ4TU5Yb24zNFUxSWJQcDRGM3dmNHlMR0hVd0VRQkZZVlFvVmMwaWJhS0Iv?=
 =?utf-8?B?T3NVR1VNejkzZGUrUzd3dERsM2VQM3RHYzZON0lkUkRTRFpXM1BSdlZIY3JX?=
 =?utf-8?B?WS9qdkl5NDdZMU9vZ1dqVkN1UU12ZWJUZXNoL3c4UlZMSVRMT1doNUc5aXBo?=
 =?utf-8?B?Q1IyNUJSNG9yQmlQUzBqNjJMTTREUjlsaWJ0Q0tESk56Wk9lTFBHYmo5TVdF?=
 =?utf-8?B?cnR5M3lqV0I5VnVKQlQyaTlpSCs0c21tRDRaQXZBVWJadk5RakV4YWtBcERr?=
 =?utf-8?B?VVR0WDFIa0FqcEpxM0dWSUdkUHhZL0htSXhieDZVdHN5aVBNTGpFNzQralR4?=
 =?utf-8?B?Zzl0NE56eFJWUVl6NERMVi9kQ3RmRHF5M2szSVJVWFdUdGhmaDRpM21Mb2Vz?=
 =?utf-8?B?djJodGVIS01OVE16YWlSNGYyLytuMjVSRkttRThaNFJPZnVQQVI4RU1tUGZL?=
 =?utf-8?B?VytBenVFL1Z6RnJiaVh5Vk5Ndk9tdllxZExROXpDaE5Ca3k5b2NINFJVeXhv?=
 =?utf-8?B?M21BOHRCYkJpVUtsSThGcXlNRWNkeFhYWVlEOGVod3h4M2VJNnB6M005Nkxy?=
 =?utf-8?B?RHVxMjJIMUZyelFjb25JWlFnL0NHUTg2SUxVRlBwNWx5T0pJSEJ4ZmZCbitE?=
 =?utf-8?B?STZZbDJJNnQ4VnVRRWFqNVpKZHcrWFo3SkpHNmNkUjZTNFhhYUJUNGo5NnBa?=
 =?utf-8?B?Si9WblREclBoZVQyMEVmaWpIZXdRUThlcURiTTVWV0RrME5EMTAyZXdpZFVK?=
 =?utf-8?B?aTdwdWhqRXNyS2pnUXRVYlZKSjIzbEhHWldJMitQUkdXa3VNdkU2ekV2YlBJ?=
 =?utf-8?B?b0MyTHl4dkV4TzlTd3ZsdGxvVFJmK2hWTXRYa1YwYlc4aE1abkdGTHFmUzh2?=
 =?utf-8?B?YWhVb1c4RlNEdGxLUmIrd3NFY0svVVRzZGtqRUxTUzhoZ1JPVUNFRFhXVHNU?=
 =?utf-8?B?WDNDQ3N5UWFDam9FMXlEOHV6T0FwNzlTU1JuZ0ZFbExnY0h1ZktKS1QrZTRa?=
 =?utf-8?B?RndlTkVxV3k4bWhhbU44RWFEdW44L2taS25zOW8yL3hBc2gvMjRReURlT0Zx?=
 =?utf-8?B?R3ZKQWRScUpPZFpmeXNrY094Qk5sU210WVFlYkR0MGRHaTJVUWNVcUl4UUpB?=
 =?utf-8?B?TnNZL0gvMFZNaUc1Q2VZTnpCcHVkMzNDaFJ6L1A2R3ZsRmc1dlNLTitKSWdY?=
 =?utf-8?Q?8L5frpHSxEk1+baHUD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b260ff8e-e283-4b27-b43c-08df0919c858
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2026 17:44:05.2028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZG+1L62+QM99Ea2t+hI+/hSVChwLKkstz3FirtN3wLTt+HfLEG7UYr5Lvo2MAXRbf1l9YX/vp+ZDD78KYCMyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9162

Hi Shantanu,

Thanks for the review. Tycho is out for the next few weeks so picking on this
in the meantime.

On 8/31/26 4:47 PM, Shantanu Sinha wrote:
> [You don't often get email from shansinha@google.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Thu, Apr 30, 2026 at 10:07:16AM -0600, Tycho Andersen wrote:
>> +static int sev_firmware_shutdown_if_sev_initialized(struct sev_device *sev)
>> +{
>> +     int rc, error;
>> +     int sev_plat_state;
>> +
>> +     rc = sev_get_platform_state(&sev_plat_state, &error);
>> +     if (rc) {
>> +             if (error)
>> +                     rc = error;
>> +             dev_dbg(sev->dev, "SEV get platform state failed %d\n", rc);
>> +             return rc;
>> +     }
>> +
>> +     switch (sev_plat_state) {
>> +     case SEV_STATE_UNINIT:
>> +             return 0;
>> +     case SEV_STATE_INIT:
>> +             error = 0;
>> +             rc = __sev_platform_shutdown_locked(&error);
>> +             if (rc) {
>> +                     if (error)
>> +                             rc = error;
>> +                     dev_err(sev->dev, "SEV platform shutdown failed %d\n", rc);
>> +                     return rc;
>> +             }
>> +
>> +             sev_firmware_needs_reinit = true;
>> +             return 0;
> 
> Tested this on Milan and hit a failure during SEV re-init after firmware update.
> 
> __sev_platform_shutdown_locked() sets the FW platform state to UNINIT, but
> sev_es_tmr and sev_init_ex_buffer remain firmware-owned in the RMP. When the
> new firmware comes up, SEV_CMD_INIT_EX rejects the stale page state and fails
> with SEV_RET_INVALID_PAGE_STATE (0x1A).
> 
> Tearing down the buffers on shutdown fixes it for us:
> 
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1905,6 +1905,20 @@ static int sev_firmware_shutdown_if_sev_initialized(struct sev_device *sev)
>         }
> 
> +       if (sev_es_tmr) {
> +               wbinvd_on_all_cpus();
> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +                                         get_order(sev_es_tmr_size),
> +                                         true);
> +               sev_es_tmr = NULL;
> +       }
> +
> +       if (sev_init_ex_buffer) {
> +               __snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
> +                                         get_order(NV_LENGTH),
> +                                         true);
> +               sev_init_ex_buffer = NULL;
> +       }
> +
>         sev_firmware_needs_reinit = true;
>         return 0;
> 
> (Could also pull this and the cleanup in __sev_firmware_shutdown() into a shared
> helper. This logic is duplicated there.)

Releasing the TMR and sev_init_ex_buffer pages makes sense here.

> 
>>       if (ret == FW_UPLOAD_ERR_NONE) {
>>               error = 0;
>>
>>               rc = sev_get_api_version();
>>               if (rc) {
>>                       if (error)
>>                               rc = error;
>>                       dev_err(sev->dev, "SEV query api version failed %d\n", rc);
>>               }
>>       }
>>
>> +     if (!dlfwex_wants_rollback)
>> +             sev_firmware_reinit_if_shutdown(sev);
> 
> If rc == SEV_RET_HWSEV_RET_UNSAFE, psp_dead is true but dlfwex_wants_rollback
> is false, so it still falls through to re-init. Even though it is
> recommended that the host should be rebooted after HARDWARE_UNSAFE,
> reboot tooling can lag and we may want some buffer. Plus the kernel shouldn't
> be touching a dead PSP anyway. Checking !psp_dead is a simple safeguard against
> extra churn while awaiting restart:
> 
> +       if (!dlfwex_wants_rollback && !psp_dead)
>                 sev_firmware_reinit_if_shutdown(sev);

Agreed. Matters more with the teardown above. init re-marks the TMR
private before failing, stranding 2MB.

> 
> I also moved the call to sev_firmware_reinit_if_shutdown() ahead of
> sev_get_api_version() so sev->state is already restored to INIT before sev
> status is queried. This is just to avoid unnecessary transient states.
> Curious if that logic makes sense to you. Am I missing something that made
> the original ordering strictly necessary?
> 

Having an ordering isn't particularly necessary from what I can tell. It's
arguably better than what we had where early-returns on the cached state, so
re-initing first keys off the driver's own record of having shut down rather
than off whatever the new firmware reports.

The only issue I see is that it reports a stale API version. Refreshing the
platform status within __sev_platform_init_locked() should do the trick.

Thanks,
--Pratik

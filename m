Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011055.outbound.protection.outlook.com [40.107.208.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CB04DD3CD;
	Tue, 22 Sep 2026 10:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073212; cv=fail; b=eGop26VBkP0meksyoCpVbL10RhyYjF8XDRJc+HErSPLWhTwR3Io2lgO2dgXVke7by7N/WST2nD22lnzO0ulPuutpjriMGPwS5C5f8kYbQ/il8nkWv9RCXB/+rOuoQM3T111l/jRi83La3zYM/rg6QAqRRW4Hq5J8M0TkAGy76XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073212; c=relaxed/simple;
	bh=yGxotSxuadbC3Cl1CF/5r394msHRxdiZMGYBe4/9xu4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ca+KHZXtkTVreJ4i8rsznJAkGbzSwWGkmxhcXNr0E69j5c6TepGzsmjykUERKEAGivoKBrjGJdQUYwihiOhn/igISXjqgw5Uhg+thjE2KT+p7Jh9csXW2nn26rISerjPldQwGZciEamV9Q1Ie6Ubi8BvNkFUfkrdR8rpyxglULo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XbkucMbw; arc=fail smtp.client-ip=40.107.208.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XbkucMbw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHoCl9in2I6BKWVv0ZgiQDx/9swMpKykpAaK7bYrwiMLsuGQEKbq/daj3g5vgYdm9HvCH8IHNnMJbePAijejXAsv0FZLWvvrGDMJkT1ed52Pk78ziXhDVAvOL/lvsezq4ITxrk6eJpVxwLKxyhYff5aOxqEVuKfSRcQpwApDsmK9fNxWTgmNAXfvm+7y/+Y7pvI7nFDZxYbxb1uwJW8zUE4vRZ9z36rdE7J46rSTzbnz2m7hDfOz01vzy+Q/uzfadtPgkAcBmYqaddvqhskpAVCEoXLS2uyDmsSni5ru9WblfD1zR3hfho38XpDsT4TsNLhIjwsg4BHFdXAq/3iHTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNDru1fJKFb5yqxxz+57ZNDNqzNTVVKG00k/33SbtIM=;
 b=NrA6telCPg/cFwLLuD4h7emWZlVcDaBWptQYr7j1TSOQyMw0kDLKmHcUDf8Qph5IveIgGUUP0Ot1BfcCvTPlFjreLYqt8doQ8Qy5Z+1P+kHsXTUpnhAwBANjcPosX9Wp/7e4KzyDBreAMr2PwCPl76bJeZKBH+o0HWdPfeZ06b90yt64LUtj3LLhgZCWdrAnTMvS3ehrRuSAm+CO2oeYODVNWepAQyChzidn4wK+YarUU2rwcpKZ8iyN3MKXNU7wdWQ7cgT6FKsn+4exUUL6RztWbSJPUK94qYa699JYUpnSVRXoWBN5LZD4fJJ4giWqaLVck+4344kSmHa5Ru6SoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNDru1fJKFb5yqxxz+57ZNDNqzNTVVKG00k/33SbtIM=;
 b=XbkucMbwmvO28HSvgh0YFA4mSC6+1lfjNsyKtR42Ii1PZJSTN3eJNSC0pRWpVcB0A4zqCVJVWkjXN71/nAjRnWasWPGDqtfATQEYh+vvCXYgL04dZMtIBAd8tuxrOxNpDjBBOmCRQ+e+j838heZZh6UE0jZVXfyZ64NvORiNkpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21)
 by PH8PR12MB7183.namprd12.prod.outlook.com (2603:10b6:510:228::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 10:33:27 +0000
Received: from PH8PR12MB6914.namprd12.prod.outlook.com
 ([fe80::2893:177a:72b0:6000]) by PH8PR12MB6914.namprd12.prod.outlook.com
 ([fe80::2893:177a:72b0:6000%7]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 10:33:27 +0000
Message-ID: <99667c45-b44b-4378-9d92-7fd9eb64ff16@amd.com>
Date: Tue, 22 Sep 2026 05:33:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] crypto: ccp - two PSP init fixes, and the AMD BC-250
Content-Language: en-US
To: Mattia Tadini <info@mtsistemi.it>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
 <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
 <179007151736.36856.17325391038801459309@mtsistemi.it>
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <179007151736.36856.17325391038801459309@mtsistemi.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:408:ff::10) To PH8PR12MB6914.namprd12.prod.outlook.com
 (2603:10b6:510:1cb::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB6914:EE_|PH8PR12MB7183:EE_
X-MS-Office365-Filtering-Correlation-Id: faf56be9-cb0e-4a9e-a039-08df1894f029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|5023799004|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I+HFzq7JcCzQ/WL3Br/pwORvtQYErKyh8byDIv3ABAD8r8orybb555nPkjt+kVI6Jh5QkpPuwFnm2NWfjSO2e8CDURdWknpjF2lvI5+9YxRMfsOQBWnq5BzEPyYwboOIien2lPM4MMfbbYE4ybNhgDwoAQDIALHIoZzc6eIAY6Wk0hx6fN0HruINjizKRTzJTcbuNhfnowTo30NiJWIgiWueGdIvt+lF0KrItz1ClTZTUsYSWZQcmtaYTZ7J9yYNkkCQ9sj+LH0IomBTzh0V5bQ8H4jS5asHUfeTwZUty4Yfeiu8FJsk58z4tOz98YBXi/KXRxQ8BoOPHYuDQ6QCRziAM7a2ReHuEyIaB4VncLpCDjpNOdSpHfWHbhJTwNQ1P5pfnFr9cfFck8SjA8gmzTayYYWIlnBzHRpdeiiO/87HR3IgnB/P0dPVfXTj7v6DuKgMKgnZ4p13c+DmooYXHioVc0tA+vrzepD1PnHtvsw5gz5YWQJRjkcI1BA7rQ+7Kj/5USTc9agyuFMJbfkVk0lOZTV1Uwn8szY6fMuNapltIO/5UiyujJlCKj6PBBgSO8cm+4KgYC3ZlThHBxW0YTS93dKGf3hgtdsHbGySMp8MBWZgGT5pZr1FDH6f66MmrHxFFH1F183qRBII104c5xV9PU7v9a4syJXTpyP2eKQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB6914.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(5023799004)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3Qrb3VON3NXd0gyUkJ4ZWhxRit1aU1DaU5hM29DWTZVcXB0UnhESGFEa0E5?=
 =?utf-8?B?UnpJcWpvTC9BTmpTcG9aTEl5UVl4UnNVc0VMaFlFTW5zdWNBT3l1Sm42NDNw?=
 =?utf-8?B?U2dSRWszY1IvNjZ4ZS96SDVDL2VROTJwY25ndUI1VGpuUkNDOEFHR0d4ZlF1?=
 =?utf-8?B?c3o4c3JDUFFKNTIvekxiUGlyQVRtTzVZZGpjVU1PZ2Y5SFhiSU9BZ2FzWnBn?=
 =?utf-8?B?bDRjbXE3a1VJOWNJQVk3VW41cGl3UjA1TkNEaFFOcWgvNVMyLzhnZjJ5SnRS?=
 =?utf-8?B?MFJHOXVFcUI1dEkwQkE1UHlTTlpDU1RFb3RNWU9NNmFNU1lCbTVOejZmd1k0?=
 =?utf-8?B?c2pYek5scUJmdHl3SVJWanhiaTFEeC81d085R2h5Y0ZuT1hZMlFvL3htNEVi?=
 =?utf-8?B?NDdudHp0N2kwVWtwN3EwSHVKNStteGdWZGI5TXlHVzRsK2RsWGROKzRZUkJi?=
 =?utf-8?B?N25FL21oRkNlSUhEd1lIQTRHVnlldG5raHI0Y3d6NUE3MVRGeXFVYmVzeWE5?=
 =?utf-8?B?VDhtaVpxMmdFNFozd3MxdnJWL0NMck54U3lFSm9XOTVJekJZUVM3WmZudVNC?=
 =?utf-8?B?b09aZ3E4c1Vld0oyVi9YbHNxNWZxNHR2dFlENHBqK3g1MVF1bktJNG5CRkk2?=
 =?utf-8?B?MXNnZGRNajI0cVZ4WDg0T1RsUWVFb3Q5MzdDR25HdUlOZnZzdnpiZTZEejlz?=
 =?utf-8?B?TEgvYzVBL0VJMXJvM1E3Y3hsTnFGRDNtaFV6dEdCb0VrTXJRWTlaMHIrUDg5?=
 =?utf-8?B?QVlUM0t5b2I3RmZDcnIrOXg4MGVzei9heXRRS2FaajhxMnN3YmVsODR2N3JV?=
 =?utf-8?B?QVRnOHJ6bVVVeTNaazlocWxSTUJ2Tk1MTFhGVjhKK2lBYm1FWGh0Z210ZjlP?=
 =?utf-8?B?bTRQZjcrMXdBYkRFa3diWE9SUlc3alFFcG1MU2IzcVcraXl4V3I5Y1dNZHY4?=
 =?utf-8?B?YjdUbFI0RjVCdzBBSkZBVkJpSElLNmw5Z25pUVYvSXBoSFdLbzJpcS9RQTRM?=
 =?utf-8?B?eGJzbmRnak1KMkxnWmN6Y0tyN0lYKzJLbktudWl1RkFWVDhJaldmZ0Q2YU54?=
 =?utf-8?B?VTI5NFQzUTJ4VGVDdlNWMGxNOEIxSSsvS3NhUlQ0K01vaW9aVVEyMjVta0Rh?=
 =?utf-8?B?SWNickJDL25maXZQZG0rck00czVTZldmb3RoY3ZNTHF3UThSM01ZODNjQVRs?=
 =?utf-8?B?clZsSWNIQWlWVklYcGZoVFJqdkwzdGovb3RUdmg4WkoyRkZRYUJWK2ZkNGcv?=
 =?utf-8?B?ek92T081NksvenB5RnBKK0FORnBKbU4xVGp2WGlDSFgvek00dEtKRU84SXBG?=
 =?utf-8?B?anpGakR4QWplRHFDK2w5U2ovTGRScXNrMmZSV1VvcGN0d1hBckJCTWJKUHp4?=
 =?utf-8?B?UTFMK3ZaQkx0dTFyamRRQXNVRzZJenZ4TlVhd3NRaG1MeGo0REFHUFR6R1Q5?=
 =?utf-8?B?eWlvaVlDZWlDN2xsZ1FYN3gzVDQ5U2dmcUtKQ2Q2MTc0LzIwSTBJRUNrdCtW?=
 =?utf-8?B?YU53RWM4YllNUGFFaDYyN0FzL2tpdHhaendjSWQ1VGNUSXBHSVlKbjZDcSt5?=
 =?utf-8?B?bUhxcEp1Y2hHOHVkYUtxMVdMRnRNOE56bVdTc2xKZUM3S3dvdmhOMWhSb0hk?=
 =?utf-8?B?bnA0anYzTU1tRDNuTjk4VzlJR2Z0cnZqVy9BTnNqd2NRMkdWUW9RV214QVNq?=
 =?utf-8?B?SlIwYkIrRUlYdHc4T1dXdDlTTHhEWEdyZTVKNmxWcS9ua2lXQzFSRm01TWFk?=
 =?utf-8?B?Nyt3dTFyRDZtUVhMTndYQ1Q2dVdWTmlrdkk0SzlOY1dTSUNFSjFZSTA1UmdF?=
 =?utf-8?B?TWdwaUJyWXQwM1BWcGh6MllucEFxVmZBSzNzK0VYN3J3dEVpcDZPbC9GWGJ4?=
 =?utf-8?B?SjAvZExMaWlCZ3ZXRFROYXYzRTk3TlYxMGF5T3JiSzJKb09NdlREQ2UxRklX?=
 =?utf-8?B?SFB3NXFNNFhweW1TTEFIOTVtSDJOd3ZwNS9XYzlXNm1PY25kRkc1YUt1NmM3?=
 =?utf-8?B?NExsWlZTUkVaQkZpZ0lqVFM5ZUVBVVJSTmZremVBaGYwSjlHRnVoUTNkYzdH?=
 =?utf-8?B?VTFYVHM1RkIrYXl2SDVUOWJZdHliZWwwTVdTYWdNWjkvOElNYUw5ZkpHQUtN?=
 =?utf-8?B?Vko5K2dGUVJsTXEyaEFpS0dZUmsza0daeVVBRVJEdDNsb2Mwbmp5ZWlHSFo5?=
 =?utf-8?B?SGRxdXhOUjJWa21sNXFzZlc4NmZWMDgwcVNnclJqVXd5cmM0aHhOR091UVpj?=
 =?utf-8?B?WWdvVTBSQzc4ell4SkFXdnRPcllGUkFieDZQbVhQQWU0UUs5c1pzcVMrb3d1?=
 =?utf-8?B?M3dZTzJOSmxVT3FvVWxCOGQ5N2hCek05TEZ0MU9BcXFJdW41Y2tVQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faf56be9-cb0e-4a9e-a039-08df1894f029
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB6914.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 10:33:27.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMW9+NYdRKiXtYewgPt17VS+N+oHzXqxkmXxtTr/TDQ/RobcBkzoOh/fZnZJWc0c+HWLN/AZVHr6+6j4zlbdvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7183



On 9/22/26 05:05, Mattia Tadini wrote:
> On 9/21/26 10:10, Mario Limonciello wrote:
>> Sorry; but what's the point of adding support?  You can't access the
>> crypto engine, it doesn't run SEV or TEE, it doesn't support DBC, it
>> doesn't report HSTI.
> 
> Thanks for looking at it. One correction first, and the mistake is
> mine: the cover letter is wrong about HSTI. The security reporting bit
> is clear, but psp_populate_hsti() then asks through the platform access
> mailbox, and on this board PSP_CMD_HSTI_QUERY does answer. With the
> series applied on 7.2.6:
> 
>    fused_part=1               debug_lock_on=1
>    boot_integrity=0           tsme_status=0
>    anti_rollback_status=0     rom_armor_enforced=0
>    rpmc_production_enabled=0  rpmc_spirom_available=0
>    hsp_tpm_available=0
> 
>> It seems that the capability register isn't even populated on this
>> system.
> 
> It reads 0x00000002, the TEE bit and nothing else. That lone bit, with
> no TEE behind it, is what patches 1 and 2 are about.
> 
>> To me it appears the patch series is a lot of "fixes" to let you
>> read.... the bootloader version.  Am I missing something else?
> 
> Only the above. Once the device is bound, userspace gets the bootloader
> version (fwupd picks it up as "Secure Processor", bootloader
> 00.1c.01.02) and the HSTI attributes. Nothing more: no crypto engine,
> no SEV, no TEE, and the firmware rejects the DBC command.
> 
> If that is not enough to carry an ID, I understand, and patch 3 can go.
> Patches 1 and 2 then have no reason to go in either: with the current
> table I don't know of a shipped part that sets the TEE bit on a pspv1
> or pspv2 function, so they would only guard against a device that is
> not there.
> 
> So: would you take the series with the HSTI data as the justification
> for patch 3 (I would send a v2 with a corrected cover letter), or
> should I drop it?
> 
> Thanks,
> Mattia

It will be up to Tom here.

Given HSTI attributes do get exported from platform access mailbox that 
does change the shape.

But I do think that you should spin it to a v2 for the following reasons:

1) The cover letter is wrong (this discussion).

2) The first patch has a Fixes tag, but it's not really a bug until you 
add patch 3.  So it's in the right place in the series but I don't think 
it should have a Fixes tag.

3) I'm confused by your comments with TEE.

Why is the TEE capabilty set but TEE doesn't work?  Is there a problem 
with a guessed register layout or a real issue?

Rather than play whack a mole, wouldn't it be better to just clear 
psp->capability.tee when the ring init fails?  Then you can take pspv3 
layout.

4) If you DO end up sticking to a new register layout, you said up front 
in your cover letter DBC isn't supported.

Why do you set PLATFORM_FEATURE_DBC in your platform_features then in 
patch 3?  IMV this isn't going to be a relevant feature in the BC 250.

So I think that leaves two options for you to weigh out.

A) Either take the existing register pspv3 register layout and clear the 
TEE capability when the test fails
B) Take the new layout you proposed but don't advertise DBC feature.

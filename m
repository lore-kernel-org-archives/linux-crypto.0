Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9B542EFF;
	Tue, 22 Sep 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790088187; cv=fail; b=XWaAC6fGhlNQKr9Xkoic5gPtdDCDW5in1C43cc2Qyk82yCPUDMLQz2UO5jvm5PPbxFbc6bTezk3Vdm6T+L0Xj5+WGUlfx9mrK1P40OR8PqO0LLP1cuCjOYFmdEeqgM6OrzGtM314HYA0woZFQCNNnW5U4vwyDDZSIi3nGA5Pdts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790088187; c=relaxed/simple;
	bh=gzfGHdmITD/KAGskw6XSqbbbWt4E7ShSJGphTasWgeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A78tYdTLZp8wX4570UpShYngGux7mQiN5BOkl2IaFL7cgS4Y8wJ/azH6DbS5qLnWkL5mKg0WCRfB2iPuWFcBVhHQx6ArwJqY1kGjtyq9AhSj+8kiG3yPfahuVVcDXgmUZ1EzyS0ZTEcnoVT8qkAfuuAG/E80gxQ3poE9a7hKKKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jij/zrFR; arc=fail smtp.client-ip=40.107.208.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jij/zrFR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VoEaxj+xetsrpLMZTGCG98wxYLZG15IklEH8MPh/x2ptN4baNM3FIuHME7L36GeYeU7NmBWGacDnSPUPMOtq6bmREImkKiPtt3brgVwrRoL24bqGn33zXdaE+16DeE+2+80X8EvJqy8e2bG2T7rUCVRVgj8xF3jABAaHyTOmNTkTfx6EGefBYTTDwaLCzKyWK7qqLaeUIG0KK0vvsJ7GshQ5TvvZARBfZDUiyI9MbGXr3WkN/v2ROBYc0Q7w1qoC4WR9Vfyl6WMigfDk/eqe2VV/LXVuKl8lswPS4HwzUV1ZSQVlxy+2PBeo5icFZV9QR6ydypZk/Dx1YD1AAS0u6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFcsePkMUCCVyRdDSnIKwEDxteXXuS0lD5mDYSes8aE=;
 b=Igc6bvCadpfY/aOribjjA2Pgi6wiFaknFZlpbg4ifGTi4AEgseqgSLj/MpsuytHF3HRoigJYwll+WfE9W3Yxs+4BavqBSudRiWIXcLmGPiW0qqcQQ3M1Zmu5cc20PvvJ8V9Sud5J9dUE/wns0eDfwsDS+UbDw83PPmNkqO85mR3n0yz39oqutv3UEMfvAg9rilZSsmfDg3mNrTTKzQGVyjQLFHYzG+/JkeuuRUwdu5lrfNA2W210eXAAb/CHQiUNGY5E7ua/WxKJDoGziUdRZNA4MFLi4/Li0289RXli9kNPPJUxoywkcAcWloki5qsnUFHI/8w9vY+Agu47VatUxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFcsePkMUCCVyRdDSnIKwEDxteXXuS0lD5mDYSes8aE=;
 b=Jij/zrFR/sGJzwSbVCF4fkgoNH3X/o4nCmeTC+l/jp6opLy3CD1k/pC2pmEw97WN+Ca3vhvRpsmYrwDhaDjO8kVbXtxNjfjf/SpMmamNRT/yk5C3O5aXqUdNH5BeAUWjNIJvHfbE1GAXPQQFDNZzytBM/BwIhcvHDTwakwN4Kas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 14:42:43 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 14:42:42 +0000
Message-ID: <0902307a-52d2-41c9-9552-289d05c05153@amd.com>
Date: Tue, 22 Sep 2026 09:42:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] crypto: ccp - two PSP init fixes, and the AMD BC-250
To: Mario Limonciello <mario.limonciello@amd.com>,
 Mattia Tadini <info@mtsistemi.it>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <178984289056.12336.17662860552012704364@mtsistemi.it>
 <10469a97-1e55-438b-a9cc-7a7cf650c104@amd.com>
 <179007151736.36856.17325391038801459309@mtsistemi.it>
 <99667c45-b44b-4378-9d92-7fd9eb64ff16@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <99667c45-b44b-4378-9d92-7fd9eb64ff16@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR07CA0107.namprd07.prod.outlook.com
 (2603:10b6:5:330::21) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: edf18bde-eeff-48be-d1a6-08df18b7c1f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|10067099003|5023799004|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dp5WWIeppwrjJAmJe5Jw2PIYgSzstPZ/czHeeO/Oen4Dr3bwfxgNgRqPH54+b1r4fg2ygKAYJxOKhB1EjOVU+NK5EhEth0s0DRADGUMs1HvcWLTGtDQF2FL8q7Ma4rV/GYPPwUFcOMTxdVLJpGBiWQKbeV2NwJd2QT7+h4uJ/Rf9ucDLfBzE3zu4KAdBQqrhFmOa6Kl5s+gKp5mUU34CuXXX4V91MREZaxTIz3Yms4JDCeX0BfXlT5d8jHCLabKntGuAEIi8OaQmd3sc8LpjTXOyrLiOr9CBU2NX8Klhe1RvKDSa7V5gZL+9+TsWyVemred1AZ91eiXGVTI2K/se1xcO5/gzBPplALsal6X9JkGxUoOvgZkcLb8WMNlnS//ejmzUFAtC6S5xpXWDKXYRAxiPRFE2LpYMT2YdLSwENEcNz5Hec/IXB0MNsqQ9Ky3ouZTfLmR/zIsDuStClVYNE/x6ZYyDQ88t3y+AoEMLlzySqt36fM3r/YMlITeMrYJoJ91exYjSHfomdDsEqAjY0IE0lemCPnVy+6C7lTIERVnHq5SsurDMyhVE2+CHqYKplp4ukuQY4t1K4tlxZu0hzaSOF4Ri2FVTknVgW+kOkdjy2E3t3r8zo7nSF6yBcrrXeHYXKEuecW49FXWkWn/IaYYLhXqgGB1R9CzyQgZ/6uA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(10067099003)(5023799004)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFNZWmE2SnQxa05ZT01IZFpFUENCbmFqZmkzUVlvUzNWeFNPVnFEWWNNRVBk?=
 =?utf-8?B?MzFVWlY0QlNGVDR2NUxHVXY4WDFGNlVXZG1BTmFZUkJjZ0c3ZjNETlVYc081?=
 =?utf-8?B?UUF0RnlKU1Nod1FMVkFOa3BlVmZqSUVYRG9EVG9PQ0g0akRqSFBEL0VDL1cy?=
 =?utf-8?B?ZnpFOVBjUzd1TjNRMGE0aVVHeXBFcHBqVzZYdzVicmVPaVY0OExJN0U1L0hl?=
 =?utf-8?B?dWxwL2NydFc5WlRiR3FLQVpIdVppdXpkckpVNENFUkZqTy9mNkNDS2g4eGVY?=
 =?utf-8?B?ejBnd3Rja01qdGhXQmI4Qjhsd2dhWVpLZDNrWXJBTDVCaUxUNS80cVBRaEM4?=
 =?utf-8?B?SXpHNVRablIwdXExWmRHcTFPdHErZVFWdnErb1Q4UGlpZ2lUMEtET3BQZzJx?=
 =?utf-8?B?NlU1OHVOLzRjMmhkMFNubzVXZEU2Y0hUbFNQNko0cENLcnFOYzA5amdLRTZq?=
 =?utf-8?B?YlhJYm1ReFFOSzBNQ1E2OVdRQzdaMTJLWi9PUkptZTVmclVHd0FZRG04MHJN?=
 =?utf-8?B?U2w1cDMwK0RLbWpRSldUaFVBaGtpVFZpSG5jemJ2Z3FPYzZYQXlQWlF1MnFi?=
 =?utf-8?B?WW1kaVVpWDdZdzQ3VzZ4Z09oWlhiS1VYNjdNcUpmaEZ2S3lsV0JsRldCUllp?=
 =?utf-8?B?djZuRVk4eHpVYWo0ZGJnNERhWTNXbE9IUDM5MlRTZHBtS3BxMVpiOWwxWXFx?=
 =?utf-8?B?bVVQcHk2UWw5UWYzWlVIV2Z2U0lNSTUzZ21COVFxKzZ3R0o1ZGUyQ05YU3lN?=
 =?utf-8?B?MTlNamp1VFVRNFh6cFM0RDZmNXZOSDY4aExFRXZ0eVJ3VXJmOVlibVdBdnBi?=
 =?utf-8?B?UFRmOExHK1QwS01pRUtHc0lkZ0VPd045SmNFRk81WjIrYUx6UmtITmJLckRo?=
 =?utf-8?B?bUtyTndWZzltbXZkZDV3NXdMaUM4NWNqR2JGWXFQeTAvSmRiZGhMRWUvMFpt?=
 =?utf-8?B?ck5EU2ZBbFdtcHZabVZrcWoybFNRaVlkbmR1SG5PZUNKMU1RVC9PK2dpcXZE?=
 =?utf-8?B?alZQWk83eUJZRW5TYm1DYVUrNGxPU2M4ZkFnV3MzL2oyaVhwdnplK2dVaEh4?=
 =?utf-8?B?ZE5OWmhNRGptQnk3NTFJSHlSL2FFT01LT0xGMXQ4K0VhTXFianZOUmFHL1Vj?=
 =?utf-8?B?cDcvREVlTWhmWXRYRWFTbC9xNDdmRXB6Y0lsWWtUR3BKb1VoUTJaY0pzTWtp?=
 =?utf-8?B?aHJjZTlwL0hiakorSFRtU1p2R2d2MExLL1IvMDg0OWg5YjIvODJRUVdoVEN1?=
 =?utf-8?B?MGZOR3AxTFdrQmZvMm1TK0x4ZXdmYmhSUUR4TWh2RnFRYmpFWFFnSXFOR095?=
 =?utf-8?B?SExSTGI3QThYaFl2Y3lmS05pSlErN0p0WUU4bXhnUmdZK2dUZC8vRVZ1R0lr?=
 =?utf-8?B?cGtEYkJUQ0hMcFl4bXUxeXZXVjZtMDV0VXJjWlZYMTBKVllOWnFBUzRCZ295?=
 =?utf-8?B?ck94aWdpWDJrTWlzUWNSTjJLcjhsdUlqWmNNRmtZeXowd0c0VkxobU9BS1cx?=
 =?utf-8?B?Yk1GVXFyclZSMUNuaTZhYjQ4QVk3Y2VQRnlhK292ajVrUkxwb29KbHd5NjNz?=
 =?utf-8?B?Z0kybm5xZDFSb01rNDFpVXROM1o3WUJXQzd0WndTUzZTcHpOc2VTT1lUaTls?=
 =?utf-8?B?OTdFV2RBbE1xWm1scWJ6UUtDUzJ4OFBBK3Z4MVgxVk03QW9DRWluMGtnRjFl?=
 =?utf-8?B?N1ZuS1M2YXE3anpVem9VUzJvRVJwZGVPMnVaelBjczhtYjNyN2lBVjdYeS9K?=
 =?utf-8?B?UHBDU29oZ2lBV0JocHBYUDBuNDFUTjRSTlRqTWRlQ1c0N25Wd0VsdVUxbk0r?=
 =?utf-8?B?YS9aYzIyQzU3VWppYjFVbUNrUG9NcnRqcm96bW1oc202UVlSdFE2dzlHcUs0?=
 =?utf-8?B?SiszM3FjMytLQng0OTVOdGIrek5xSzBidTFldmFDeVdsc2hHcWxrSEh3dkRk?=
 =?utf-8?B?Zm5qT1dmb1Q1aUpXZlN4K3VJVWpLbTFyKzFJRzAwczVMRGlqSDJ5TCs1ZElv?=
 =?utf-8?B?TnBxY0pnN3ZUWnBmWUZlWHJPV1lwMFFVMXR3ek9DZ0hjenhZMHVXRC9veWR2?=
 =?utf-8?B?clcweEtqRDVUcmYzMlAxNkg1R29UMFBiM1QxK0NvVmNJekt4L25rQlhEZmh2?=
 =?utf-8?B?eXZEMFdIdEpiem93MlVjdy83NVQwU2FYTU53OTBzTTJQWkRUeXIveEVXNVk3?=
 =?utf-8?B?ZXBEK0wveHRrMW95Sy9DdldEMGhjWVorN21YYzVEZ29GaDhSeVpsSjhoaGU1?=
 =?utf-8?B?ZDdzSDRqb0FkQ0xqS1hZbitPdDBkZEcxWmFaTHFHZ1I2U053M2VZTDk3a1B4?=
 =?utf-8?Q?EG26cA9neYFW0qhMqG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf18bde-eeff-48be-d1a6-08df18b7c1f4
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 14:42:42.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qhh3hDsPDJ2IjfKXqGBHIfotdyZWWS5DxS26N5Zm65ECQABsyIIcU3PXKrUZPxMr4al7a8+IvCYqc+ju+tKpPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

On 9/22/26 05:33, Mario Limonciello wrote:
> 
> 
> On 9/22/26 05:05, Mattia Tadini wrote:
>> On 9/21/26 10:10, Mario Limonciello wrote:
>>> Sorry; but what's the point of adding support?  You can't access the
>>> crypto engine, it doesn't run SEV or TEE, it doesn't support DBC, it
>>> doesn't report HSTI.
>>
>> Thanks for looking at it. One correction first, and the mistake is
>> mine: the cover letter is wrong about HSTI. The security reporting bit
>> is clear, but psp_populate_hsti() then asks through the platform access
>> mailbox, and on this board PSP_CMD_HSTI_QUERY does answer. With the
>> series applied on 7.2.6:
>>
>>    fused_part=1               debug_lock_on=1
>>    boot_integrity=0           tsme_status=0
>>    anti_rollback_status=0     rom_armor_enforced=0
>>    rpmc_production_enabled=0  rpmc_spirom_available=0
>>    hsp_tpm_available=0
>>
>>> It seems that the capability register isn't even populated on this
>>> system.
>>
>> It reads 0x00000002, the TEE bit and nothing else. That lone bit, with
>> no TEE behind it, is what patches 1 and 2 are about.
>>
>>> To me it appears the patch series is a lot of "fixes" to let you
>>> read.... the bootloader version.  Am I missing something else?
>>
>> Only the above. Once the device is bound, userspace gets the bootloader
>> version (fwupd picks it up as "Secure Processor", bootloader
>> 00.1c.01.02) and the HSTI attributes. Nothing more: no crypto engine,
>> no SEV, no TEE, and the firmware rejects the DBC command.
>>
>> If that is not enough to carry an ID, I understand, and patch 3 can go.
>> Patches 1 and 2 then have no reason to go in either: with the current
>> table I don't know of a shipped part that sets the TEE bit on a pspv1
>> or pspv2 function, so they would only guard against a device that is
>> not there.
>>
>> So: would you take the series with the HSTI data as the justification
>> for patch 3 (I would send a v2 with a corrected cover letter), or
>> should I drop it?

My take is to just drop it.

Thanks,
Tom

>>
>> Thanks,
>> Mattia
> 
> It will be up to Tom here.
> 
> Given HSTI attributes do get exported from platform access mailbox that
> does change the shape.
> 
> But I do think that you should spin it to a v2 for the following reasons:
> 
> 1) The cover letter is wrong (this discussion).
> 
> 2) The first patch has a Fixes tag, but it's not really a bug until you
> add patch 3.  So it's in the right place in the series but I don't think
> it should have a Fixes tag.
> 
> 3) I'm confused by your comments with TEE.
> 
> Why is the TEE capabilty set but TEE doesn't work?  Is there a problem
> with a guessed register layout or a real issue?
> 
> Rather than play whack a mole, wouldn't it be better to just clear psp-
>>capability.tee when the ring init fails?  Then you can take pspv3 layout.
> 
> 4) If you DO end up sticking to a new register layout, you said up front
> in your cover letter DBC isn't supported.
> 
> Why do you set PLATFORM_FEATURE_DBC in your platform_features then in
> patch 3?  IMV this isn't going to be a relevant feature in the BC 250.
> 
> So I think that leaves two options for you to weigh out.
> 
> A) Either take the existing register pspv3 register layout and clear the
> TEE capability when the test fails
> B) Take the new layout you proposed but don't advertise DBC feature.


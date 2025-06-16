Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23DD1DF99C;
	Mon, 16 Jun 2025 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750106823; cv=fail; b=kqh+Bv0v6nI3oRJbrti95S+gsXm0K10ezZkbO5wQvF4hkJ8BGjVqbhr1o49pyjGqRGT3tpXvEgZAiYiWikKDoXcDCtkZp00bw3wfCloX4+AAM8Frobn6GnJvUXGkNBcOuRLUyuAeraEJShcqXdpdbifgHkdp6dj/u9AZrbYDUeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750106823; c=relaxed/simple;
	bh=gudQqbhVUhw26YKrk8Zz4Ynhi8Hreqg9g+o8KezNxO4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rUE4BgR02QzHO7qcFrv+fIPq1ugI3LabHn7mvdVW7kTtow112R9TJ8Xqw/V2u/enqtYznDplYPPeGGXyM0K0op6n3uX7sJqvdALunFlR1sHmwc2WS2P1XjQShh095qVxolkdaWh6/JvPB4xPb2eYclG4S3enx981oWi+EjWYC1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RMWZZDJM; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RMWZZDJM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mErmsFe2dZ+QgjcPwliiFYlPMoGqXN1dYHmR4P47w/AlWKO4RUqLn2BR1oVXqHgFqKlVUgBOwDJPKRafsZjlu1er6hbZ5b3Ez6HJOrRX34q0ofTL0CW3ws++p25nofa8B9ttYw/vSJJDEm2+hNc7okLBMJaA2R5NA315L8Y2kPMkAL7WEtYqY3PllNe9osfBkmsIY31ZnJVYQhLQq9CqtARvOOaEVyzQk1DJJWSw1jBUbAOyl6Wt9Qt6XFirKJRKOZoHP2QKf7/nQRC1u33A0+uTFfqUfg3Ba8nBQydEg0/hVODvb4qbswnO/C4H1cVucoU6mYbmjV2tc2b0QHj53A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THQMuW0XPzrVoyNPc6q5Uzxb/PXicz7vEAkZXHz0ia0=;
 b=JW2PEr7Hbi2Vqdbxl6tg1vELFsK2gF7GHozi+SWWJ0TG5F1cMEcAtmBDvkKiXyI2Chxi2CW0TYH1mThY2XoRQBfgrpjBdFy+jy1Q4Y+250whJSvD3X2lInFlJ73ZIooXvLF1JQxRA3AXKr0afpG8MkD1X+yLaJjDjp4daOJEf6t/T7rrm70eiTiD6UZQyccBaZhSJgGiWSGrpE1UHAeV+CPcVOldJDO2VNeYqw5Jy5kmf4DFwIYY12Oe5fpVWQBGYewTHG00BSCQZXGlBLci8PVK+AxX7AS3p05exyCJDjwC5r/t/uy1exg3fE071Jhl7ij9bx+8t+EEXdudACrevQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THQMuW0XPzrVoyNPc6q5Uzxb/PXicz7vEAkZXHz0ia0=;
 b=RMWZZDJMhFZnNPBRgM+utp8+u2XwEPmyzKh0pkoP2fTyDhCUVsQrUW1dFuhtIYp8lLqSp/aCWMVt9ZKnjWqSMT6/bV8THttBoDK3rT4XprQipKskLz5Vt8uPpjsGhLVFuL/ACQ7IEyTukMtvijnvsVcg1yV9EFOZFIqKzwvJHeM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA0PR12MB7461.namprd12.prod.outlook.com (2603:10b6:806:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 20:46:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 20:46:57 +0000
Message-ID: <9961dc02-3bab-3e68-47cd-93a5eb65e1ca@amd.com>
Date: Mon, 16 Jun 2025 15:46:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] crypto: ccp: Fix SNP panic notifier unregistration
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: aik@amd.com, dionnaglaze@google.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250605203803.4688-1-Ashish.Kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250605203803.4688-1-Ashish.Kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SCZP215CA0023.LAMP215.PROD.OUTLOOK.COM
 (2603:10d6:300:54::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA0PR12MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: fed4d74a-6dba-4c23-107d-08ddad16ef37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUh1WnY3TXJzaXBTb0lraUhCZzFhYUdSM21ZaXZFM0VDQVJYRGV1OXNGNmZP?=
 =?utf-8?B?OEtCQlAxaVIyQjljbEdPeFpITHVpS3VmY0xmQ3VBQm9nQUNZSzFRODVRMS9B?=
 =?utf-8?B?WmNBQjlRbENLMi93RnlKaFlyTjJleG1jd1pxQVhSMDZYN2lCZjBqOFhNQjZn?=
 =?utf-8?B?VXowUGNSWFlxZVpab05pcWQxaWdOR0NYT2tWdVVzRXArV0ZOOVhKRXNBcnpY?=
 =?utf-8?B?WnVQMkgxdzUrZTkrNTFWQ0hVUWEwU1hyTVdWVW56TS9SOHdBRFJiK3BIcEhu?=
 =?utf-8?B?Y2NNSEZxTXhYNHZSNmpCTVBjUytKR3VYOVhWMlROcWNvTk1GblBTRVB6VDZO?=
 =?utf-8?B?WTMzZnFYSUoxb0VhZWloMGJGTUh0OGVmbm9WQmN1ZG9aZDR2KzhOU3lmZ3RD?=
 =?utf-8?B?Qk5pOTBRVkNadGtkVHNmcGcvS041eFQzZ1NDb3dHdkhHejJ6RkpQcU9jeG9n?=
 =?utf-8?B?ME04UTR6cTd1NW9MYkU5RW1xUldWeDk3N3dmVnZxNjk5S25TblpyMGR5OTEx?=
 =?utf-8?B?c0RjRXB4RUFPc2FKSW4zaCtjSkc0akUxSFNQY25OTi9IY0xYVExrM0V4QlZM?=
 =?utf-8?B?SDV3TktsdS9NUUxUSHZQSlNPKzRQNjVyS01sS1BFamVJWGxhYkt1bnMzNlow?=
 =?utf-8?B?bzljK2Y2ZFdRVGRpeDY5Q3JqRnZaUDlNdnFRaUdyenNnai9HSWo5YWl1SVRC?=
 =?utf-8?B?YnNOS2hqendNRWR5NlArdUE0NllDMVVaVEZmMkgyeDVadVhNeisrRUQ5a2Q4?=
 =?utf-8?B?bC92ejRGUnIyUHpDcW4zYzcyeGJVUEEvbEEyTDZpdXZwVTVlZ200cXc1VWxU?=
 =?utf-8?B?VDJDTGNTR1Y4YVB4dWtEdXZoY2ZQclp6YVJXQmVCTkhWNnpoemdsRkVhN0s5?=
 =?utf-8?B?YndvTjlvdzQrL1pGU0tLOWFHWkRtei81SEs2UjJ1elAvaW0zTWNuMVpvSzBv?=
 =?utf-8?B?Vmh3NSt3VUFqOGpwUENVcXJlV1hZMzBXNVpTVHh3ZnBhN1BCeUNwT0h3aUJq?=
 =?utf-8?B?RnZVVXduaENIaDdjSHliVFNDZUJVbWVoUUVENEpaMlllSk14VENHL3AwMXhH?=
 =?utf-8?B?VjRlUGFnRlRKbWQ4RFBFbE9EbWhvOEh3OFVRTG5xbndick5CSjY2ME5DTDMr?=
 =?utf-8?B?KyttenoyeWsyNFY3Yy9UUkZpbXlXTGtWR0VRL3E5RzlrMWhCMEtseHNBWk42?=
 =?utf-8?B?Sy9lcEUxM2dOdHR0c3YvTXZSN0pWeXROYlQvYmhqNm1mcUZBQ0g1OGhTTWpH?=
 =?utf-8?B?dTI0cjNMbTNtSm5IeUlWb01Xa1hPVVNoLyt3WHd1SXZLcGIrekRQdFRTNG9B?=
 =?utf-8?B?KzloVEN2YlI0QjdiT3RXQTBQN1pUMHduNnROaGVOR3k4Y3JmL2JuaVNpakZ0?=
 =?utf-8?B?UC9yKzVubnBoMmF6OUhHSVVlZ0s0T1NqU2ZvM2l2emxJbUwweUxURjV4UWtU?=
 =?utf-8?B?WVJzOGlHVzFnMXFVUU5hOTUrclhPUTF6V0kvelVGYVdHUzUzT25ack5LVmpk?=
 =?utf-8?B?bDdvaGEzYTZZeCtRVCtRWlJIZUJiME9CZmI4SGRvdEF0ZTA4MmZicHlicXZr?=
 =?utf-8?B?d2VuMUtsSnkya1RtNGozTCtvMlhHWVB4eGVjTTNsejdjdTBFeXdsdnA2dVoz?=
 =?utf-8?B?VUZ6YzRnRVIwaFJKdkg3dzNlZ1U1T21FQU4rTFo1Vmt5NGJNYWlKdFJ5bVJV?=
 =?utf-8?B?eUU0eDhRa0YzNGpYaGprcnJOcU13N3A5RHVtcCt4L0phN1k0ckdScGRvODhi?=
 =?utf-8?B?b1RCSGwwOHFXYzNocjFpTlF3QWxlUXd4djJkRjg3UVIwTE9DUE9ia3c5YUJU?=
 =?utf-8?B?UGhiVk9SOVRhM1drZENHMjIxR1pvaTlPT2doWFJybEd0TThPR3M0a3pnaC9s?=
 =?utf-8?B?Lzg3YVNaRnVrVHpqK3hUWEpTWFZxdE5CeFNhQUJTbG1wVm8weTNTMEdxODlT?=
 =?utf-8?Q?anrBkf2AyWY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0lKOC9PZUxQV2llWW92NHhVQnhveFVYT0tqdkJjWGc1SFJFZlUvbEpRZGk0?=
 =?utf-8?B?M1VMaXhWOVBrOU9WeFhMcDkzbEFGTTBPSUU4ZmJSb3pEM3pqVFZ5REZmZUhr?=
 =?utf-8?B?dUV5OEdGci9DcUJBZHRKR04rcE8vNEtFRjFOdTM2V0lwM1REYWZnYlVFV0dm?=
 =?utf-8?B?b05pRWoxYWhZbUdLZTZURzYxK3NiLzhHR1o0NHpKTml5NncvS2g0dkl4UmE2?=
 =?utf-8?B?bzROOUFXZVd4by9lejU1MDZpRUNyeTVrNTQwZTVOK2VhREhNV1ZhZFRpQnFM?=
 =?utf-8?B?bmRFMFFKeFZHUWJ0TC9VaHd4dHp2LzdjaDhndFB1cWtodTVCOVU5TGpHaVE0?=
 =?utf-8?B?bkhsYmRGdEt3NlR2NVZQQkl3RW10Y2wvTTV5T1VNRSs5THNvWlFwUFZBN2pt?=
 =?utf-8?B?eVFEbVo1UEVjTHJEWVNWVzdnVlh3NVlZRzVFODg5UUFDcngwK2ZhSjVMcnNq?=
 =?utf-8?B?Zm1EbEtLYStKN0IwcEZESVBIOEhvWDdJYW93YVQ3bzlIeTNqajVkUno3OVhF?=
 =?utf-8?B?N01kNXk0TENzSjluMmJWeFNRd202S1YxTGd0aTZTbnpvTUFiODVLU2prM0ti?=
 =?utf-8?B?VEtIVGtVL2ZtbFFCWkwwR1lLWklkd25jeTZrbjNUVDRmNnpzc0Y3MStkNVZ5?=
 =?utf-8?B?WU8vZS84UC9OMURNcUNobWFDcmlIeFBNNHIxRkJoWktjVGlQMWpHdy9ZTGRJ?=
 =?utf-8?B?WEhvd2poeTBSMkduUUtXcXc2dmQ2VERSTXZ2TTl6VG5FaFFKNEJ5bHdPSGF0?=
 =?utf-8?B?K0hQRjdtemNSTlR5M0F5WU1pRlcxNGFuWm0wVjZ2LzkreEpOTmlDcUJiTHd0?=
 =?utf-8?B?cTg5cnMzdUlFcmdtY2pBZEtURnNKcmNWa01YQUsxbVpVMEQ3NVlBMGJQKy9U?=
 =?utf-8?B?VGFFeXFqNXRrbXNWWjBBWWYwdHZ0dm1vQkc5OXFiSXBwSE5xSHBrdWlaLzRR?=
 =?utf-8?B?c0RKQWd2c2w3TElnSjZPYXUwdkFua2tPdXp0WEszUnNRTmN2NG9zT2RzcEJa?=
 =?utf-8?B?YWJMblpldS9QYm5ZYVpmSjdHMU9QWDNMY1c3dHlkU2Y4SForRFl6VHhvMTE2?=
 =?utf-8?B?WXNVU1IzT3JKQk1rb25KUkIrSlVYZk1kU3UxaklmYUxsSi9Oa3BxUWdmczNX?=
 =?utf-8?B?VmQ3VWYzTlJZTmhkOUQzZE80V3l1NmVEa1UwVXIwSnpMaytSTHBIWWxxQVRG?=
 =?utf-8?B?eE5rY3JvWjZCcmF6VlU1MVBjZ3dJMGYxdUhwR29oMTYzb3dSMnFKeUlxQWN3?=
 =?utf-8?B?NlVxSHh3SHEzdFpyQXFJNzVDZGxZRFBuQXE3TjZMU3k0Z2luSDMwR2g0RFkv?=
 =?utf-8?B?Qit6eENYcnVYSVdnTGRKRUJxcHJPWXplcnhtNm1kTmEzTnMvci8yOE03ZVJu?=
 =?utf-8?B?ekpYSGZsTXVpUHFXSjloSWFiTjV4LzlwTWZjRkR3UnVEYWlIN3NtTmNwUmlG?=
 =?utf-8?B?ZU1lREdWcEpWZ2ZNekQ3MGRvVWhCakJWSGYyWXlya0lyRHlIakoxRk51WWcr?=
 =?utf-8?B?eWZiYWVnMzB6VEtGQ2o1YittUHk3ZXI2TC9STjVWQW53cnpsSkFacnVXU2VN?=
 =?utf-8?B?dUMxcnNoZGFoaWhJVDYyQkJmM3VQWjZEVW9HSGUwUnpiZjN1VnFvN3hySXRN?=
 =?utf-8?B?WEhpd05SY05VcXFaeTJxTzhCS3phcXJOMVc3cjIrNDl0UWxZYTROTCtRMzA5?=
 =?utf-8?B?RGlEUWt5S3AxcytiQ091UEhYZVlLbFlLMUoyT2EwMEdvb0FkTm9COC9VTkdt?=
 =?utf-8?B?aHU3bTRPazJ3NEdyb1pYQzNMNTZxaVQ2SGZ2U25SbmVlcGtVcVRRZDMyVC9B?=
 =?utf-8?B?ZzYvU2RTYWZPUldVb1UrQXcxQnFmQndlNHIxd2ZqcWp4ZFdHblNERStNblM5?=
 =?utf-8?B?dmIwWE45aUFOVXRMd01IN2pIeHdwWTZ2dEl0RTNxMEk4TkY3ZnFsOEk2alhB?=
 =?utf-8?B?Q2RQZnFvdXU1NER4cnhSR0JmMHVlUlRZZlRVaUtXMmdSRjRyWTRTZTNXNjQ4?=
 =?utf-8?B?VHFVbnU0bUo2a3JRWGsvaW9Na3MvamUyZS95M0pNY05pYUVrN2xEaGtqZmwy?=
 =?utf-8?B?ZzVQcktzMWNMNWhHaVZ3d0dCQjJ3Si80UlFGUU5sVjBZZkpsY0pPbFlwWGpj?=
 =?utf-8?Q?1D/m9xykkkSq1T5L+tyElobT8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed4d74a-6dba-4c23-107d-08ddad16ef37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 20:46:57.4286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yh6MC7AV5KSH/BBOFqvGVpfZz6eZb72ikCu4jBCpz4Tn2zKKHyLv+fYp26juWQzJLXiNhiYVPVl9AYM9Y46AdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7461

On 6/5/25 15:38, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Panic notifiers are invoked with RCU read lock held and when the
> SNP panic notifier tries to unregister itself from the panic
> notifier callback itself it causes a deadlock as notifier
> unregistration does RCU synchronization.
> 
> Code flow for SNP panic notifier:
> snp_shutdown_on_panic() ->
> __sev_firmware_shutdown() ->
> __sev_snp_shutdown_locked() ->
> atomic_notifier_chain_unregister(.., &snp_panic_notifier)
> 
> Fix SNP panic notifier to unregister itself during SNP shutdown
> only if panic is not in progress.
> 
> Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Looks good code-wise. A nice comment that explains the deadlock if
called during a panic would be good to add above the check for panic.

With that added:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8fb94c5f006a..0ba5fe3b7883 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1787,8 +1787,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
> +	if (!panic)
> +		atomic_notifier_chain_unregister(&panic_notifier_list,
> +						 &snp_panic_notifier);
>  
>  	/* Reset TMR size back to default */
>  	sev_es_tmr_size = SEV_TMR_SIZE;

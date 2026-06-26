Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1CE3B1009;
	Fri, 26 Jun 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782507584; cv=fail; b=mKk1oAdCtFCo6rqEaKnRamSGmPyUbDkNBS7SKRSZt0QH4ns1CQVUTDbTzhnkrP+PQsNENJ2Y20jJnUxkwj55Ak13619XZFYJHi5Q2nVGEo2VtpyRbDU5JZLpBQtdPaeREAsKWrNuNSHjme9eYQVWKhQxm0RbPPy9n6e8dDXF9e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782507584; c=relaxed/simple;
	bh=dn/02/qzQedP77YqnVif8PLnMowvs4gCoqXIadlvSI4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XAeP9MyNlfrsQuAmDy1AiAGHWCwe9aKyZUjo0XD7GP8HjNwpwWBLilIR+yTOSX2IlGr6QyWs6Z/MnQG2ctKdN6l70RDVzSqqodfIv0FefLUuLvgiZ5VlRkz2PLTv7ALIM4FCQ09RTna2Ak8/Fmgqj16bZRRSNVgUGQDRuJJqiTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=alpwe+xK; arc=fail smtp.client-ip=52.101.53.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="alpwe+xK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gPv6bRxTML/xTIkQfPz09zQlX3ho00VyLMAcxsZsPUcvMQQRxFf2b+ODuv1iY2/oWZHgdhVRK50UOOcsdXO7vmKPBCjs7Q2mKSkCvGu1SyE3a9eGAreGdpXGU9RBTZTjKQQXX4v9T13gtv9fOEnPdOlfYjXUi9ewgA/xI/i5GWiUumU99HpSx3CBOz22ZOh/as0iCnwB9EKsvQWX4vdkgv4l9tAsU14dL/vDgQa1nL72nfD2NC4vkNy5sU9nzo0loVhBO5zpXngSdVqsrrKa4H/aHGeteuxQzW/aUrju5f85RKyIsa3asCU6LL9vEJ+se1emr++WcWy5aOSmTOdQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehrDTic89w9+EUZUk+rI11c0TDpFBTg8GvvtKqjnJcw=;
 b=L+VKiUT9ylRSLtgbv9365cIgC5aAgqEPxHrtJvGoaGozzV/f3ZvkKo0gdwckWTYIatq0vzAXlYzQpjsHeEpOzO03xauggHNq4446ruPes4UX0CB1wXerwuRqQ6jacRebwSobnTBw5dWo5/K8ShfukVOjOW/L4cTFqWOU0D5RlvRMtqgRnChzTJRFTwbf1NtC0Ti4yAkMj9i4mi9Wqmr6U7Z7YsbUStzIBGzmppHS67tZCO08fIXNWTQQ8+tVw1IQhskPZiBHtLK5bKI1pe4scfVy6n3YbEaLUlHUd6AZ9LAW9uEn6ZkxX7fOcuOgdvKqo0Ld0thInmmuPeLBymYQKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehrDTic89w9+EUZUk+rI11c0TDpFBTg8GvvtKqjnJcw=;
 b=alpwe+xKYlGfgnPHjgkBs73bKM8w62791oLOaqBYJ2SEIEnURYVXqN8Ixir31WGIVrkXQ9fSrzJ48X9Tz9td17NolbAaP8bse5vxEuVzm/2sM8QCt7FA8HVnwbrxoACU/JQH6+ZfLff83sLvtdcEW54sBREXFue8NBuHW8aTahg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS4PR12MB9772.namprd12.prod.outlook.com (2603:10b6:8:2a6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 20:59:38 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Fri, 26 Jun 2026
 20:59:38 +0000
Message-ID: <9d019b55-739d-429c-bb34-ce792e8340b6@amd.com>
Date: Fri, 26 Jun 2026 15:59:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782336473.git.ashish.kalra@amd.com>
 <ba146ca15b7f76eee386c8c073fb3f1cc36e5781.1782336473.git.ashish.kalra@amd.com>
 <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
 <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
 <20260626164032.GDaj6rgHq4xPd-qjvG@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260626164032.GDaj6rgHq4xPd-qjvG@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::7) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS4PR12MB9772:EE_
X-MS-Office365-Filtering-Correlation-Id: f661a89a-78e9-49e0-94ff-08ded3c5d579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DENVAitFD8rrNWUDHxXmvcMjqnxey5WP84xvtayzNsIB9/bl4SoyNjyrQJWWbM7lJDFYCVARpSBWJVpjlG3yA816BE7fFZm829EIM+kOrPcsgDtyajYAfb2xUR8ohJHg4UyYuTHQjcrQJ2W4L1FpXxBpgvxqL4u9vH9pE8x6kfeaL7UmL4Q29Xkeo7yct69uf1rI2ev/0f0ypc4gdTtztUvyj7qTSCzC7dDPPKUxKN5dlpVqlJRNXJlDCLaskOTbUaHgAewiz0aZAzSGfFb2SJO+Fuo9LYCfsLBenupWL7yXSI+ChFXC32Wzt1HvftWEIXlptiXDejOEFTN9j1F93MAGKvFKjU9+4poBEzNMRpYgdpcMT8t9lkm5lcNTrBw9AvwST+QXKaNmYfFTL0SoPZz9o2JqWM1gMFkB/RnHcRkk68sIpz+bzyevqj5VFrDKm3eAnIwaRe4q1RMET+2k/3twMp5gqxa7G/VEHrFyWimttDHJpNXR2P6Zhx+d7fQYmNupOTeOaGh4wRXm4yAwMmHpuje2+jnv5jBtv0pLDeArhmj0iUSa94ZYkrlKuhSm87e2qAmV3gNgsv0H6O/JZgacT/cJpOzXIGepjJB8JOcYaOInCOAqKmdMdq3Vs5DlqiQX9A5S3V6OCPQic+TIWMx3SYvmgKAww30JG4Io/Jk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1dmeklTa2pRZS9Yd2NoT2RDU21IK1duNzNlUEtXSVJTYWwzOVR0NGRLeThT?=
 =?utf-8?B?akkyUlRQWW85REFhWU51UjRzbUIyNGNUYjZjaFFIOHZRdFFIMEo4YytXY2dR?=
 =?utf-8?B?TnRlVGFyMkdjYUZPZmQrM0pPQVRESkp6YTNJOEp4SkRPWFpNdW5KTGRGVVgx?=
 =?utf-8?B?Yi9LN0Urek5zOE9VMTlxS3dCbHNkOWZWWmg4QWg2RHltUjU2L1hSb205NWJD?=
 =?utf-8?B?STdLV3VPWlkzSGg4L1E4NzJtVkx4TGNmYlROSUk5MnVTckEraEhFNHc3L2o0?=
 =?utf-8?B?OGFKTENqc2lVQVhxcjVMRzhqTFdqeDh0MkxJZXNnKzZGSE5vTmFJVWZFWVlT?=
 =?utf-8?B?V1ZscEdxN2U0M3RKODlQaTF1OUdvTUZuMktqN0FFb3R3cWJUSlFsRHNxekNP?=
 =?utf-8?B?MjVVWGhXYkF3SE14Tm14RjQ3QS90YWd3Y1VOSk9FSW1KWWtCd0ZDN0JaNHZM?=
 =?utf-8?B?bEtnYTk5SDRnalNxQmxvM2k1cldVbXJ3d1J1Tm9ld0VreVhaYTlrNG1yUExL?=
 =?utf-8?B?UHhkL0ROZEtGYXVrekhvL0tJSFdrbEJjK2ZwZzdpWlRLYzZuM1cvM2l4SWtJ?=
 =?utf-8?B?UjlTYzNDMkw3djZjaXYzRk82ODVKTHZHclQxOE4zREdWeG96cytKVTNQa3RH?=
 =?utf-8?B?OWFSU2lmY29WRzZzWlJEeS85c3hsMmhYOFlJV3o2OERZMk83azFyWndjWWpk?=
 =?utf-8?B?eGswT2VabkhsYmdYRElQNUlWb1krWGFuWVZtWUdYRU94UlNHWERNU0RycHVD?=
 =?utf-8?B?UEo1eDNkd3E3YlcrdE1GZjFvZnB0OFNTRjZvZi84ano1MUpLSXRNZW8zN3pJ?=
 =?utf-8?B?R3RvZDBzcG40Zll3Y2U2UC9kUjNuMHcxdWR6aG9Cd1J4VjF0UWVXaVNyQXRa?=
 =?utf-8?B?V2FXSmt3dFJlQXcwcU9zV3JNQ2VXbEFSdHZ5NlRqR3ltMFJsODE2QzRRaGdm?=
 =?utf-8?B?bVBNbm1zZmEvMVZIMWtwTzVGZU5NSGhHR1ZIaklXbUl6S0tDMEs4WCtaNmFv?=
 =?utf-8?B?cHVSaW9WdzdZQWs0bmgwSWJJVUF3V1NITlJFMy8vd050Vnk4aXlDUWpsMTFR?=
 =?utf-8?B?Z1ExWnUwOUo4cGRndjhNNVlHMG9DOGI3Z3RRa2tpMTlLRVdDdDNNMXUyNlU3?=
 =?utf-8?B?Q0ZwcGgyTDdGZ3R5amFNNnJPVkRaTU1TWklheEUwRUM3UGFKQldqZ2FPaDBr?=
 =?utf-8?B?TndVa3ZVVHp3SWlLK3JiRlg2c0dYc2pKS2NucncxRXM4TW9PMFFuSmF5blo2?=
 =?utf-8?B?WDl3UEFqRXlCbTcyS2k3ZG1iOW9vTVc1THR5S2pkQmRhZWxiMUJwK0lDazR4?=
 =?utf-8?B?bHl6c2tockRmZWV2RUE2SnlFZEpNMmQrUWd6WnM0d1dxa3IwWGYrbTlSUTY2?=
 =?utf-8?B?OHM0SWpVTHpzRit2SGJKWGtBbmc3T0s3TVk3UGFhaVdSWVNUSUFlTmRhSisy?=
 =?utf-8?B?V0lzSXp1TmRKZjZmK0lCNlp5T0htTG9JakZ1TWRsd2pXUVovQW5meHpUZzJV?=
 =?utf-8?B?SDA0RjhLRUk4OGlzNjFqa25rVkZtZ0Y4aVpaejY3TlY0dzZmSEZGVDJoR1lN?=
 =?utf-8?B?ZnFReDlGOExNdHZiSWZrRmk3UGxLMXRaaXpmU2N1YjJvcmVwN2d2M1gxd0pz?=
 =?utf-8?B?RHZZaXhFeHJNNi9iZWZoZEJpWi9qanQ5QmVPeWFyWDRKYnFpdjJmR1p5Y1Fi?=
 =?utf-8?B?cG5yTzMvbGNmTVRqcEFlRGVzRVJlOS9ISW1BUGVkZmJQa0VXQXhwWVFYTC8w?=
 =?utf-8?B?V2wzQ2IwcWd5alRMR25rZDc4OWlJbERlTlFsTzhGSW9GbWdNZ21kTGhuazRa?=
 =?utf-8?B?L2N5LzUrZDdrMG9heXRHbjB3cUtHZkhqdkxKenRDei85Zk5LL3N0QnhNRFU0?=
 =?utf-8?B?ZS9CVSszMk52QWdCNVJHQktyRnY0V2VtVzZIaTFKQllnOUZ2bVpIeEF0d0Mx?=
 =?utf-8?B?eG9keWlFYldJYkU5ZHJaMXRtMEozUzFaUFVlZzBhV0tiQ3UycmttWFJGRld1?=
 =?utf-8?B?eGpFS2FQVk8vYzcrTEJXMkxFU3Z3VHVLenU4SDFranhJcXBvdUx2c0VLOEth?=
 =?utf-8?B?cWdVUnplMDRZeDFSU0taSnZMdlJNcmlHZ3RQdEZxY1FaZkg1Ukt5Yno1ekNh?=
 =?utf-8?B?aG0yTnF2a0xNQjRYLzN6VDczODBCSzN6V1puRmUwNWZXQ1FuT1FZRVYxclhO?=
 =?utf-8?B?c0ZDYWdKZ1BUT3ZFT0pic2hMQ2tUTldTRTJVamluNUdVWkI4eW9nWnZyZkQy?=
 =?utf-8?B?MzZ1MTd1dS90Tml1akxLTHRaL2Jvak5lZWpPOG4yVjZQcDNQOFFpR1BsTnJH?=
 =?utf-8?Q?se2YA8AaXmOgSSnO+K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f661a89a-78e9-49e0-94ff-08ded3c5d579
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 20:59:38.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9xkBcJBI5b9JnSBU1kBgzxjPxqh1toJgg1Hd9uoYSFP7l3+Lz2bhm0IEUnoW3Jx3/12194HVvH2Z0Tq22QIpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9772

Hello Boris,

On 6/26/2026 11:40 AM, Borislav Petkov wrote:
> On Thu, Jun 25, 2026 at 02:42:23PM -0500, Kalra, Ashish wrote:
>> Hello Boris,
> 
> Hello Ashish,
> 
> lemme try to make sense of your AI reply...
> 
>> cpu_hotplug_disable()/cpu_hotplug_enable() are refcounted (cpu_hotplug_disabled++/--,
>> with a WARN on underflow), so they have to be balanced. This flag collapses them to
>> exactly one outstanding disable per SNP-active window, because the disable and enable
>> sites are not reached a symmetric number of times:
> 
> Well, why aren't they?
> 
> Why isn't a simple design where on SNP init hotplug is disabled - *exactly*
> one call to cpu_hotplug_disable() and on SNP shutdown hotplug is reenabled
> again - also exactly one call.
> 
> I know why...
> 

It can be that simple, and flag-free, by following the SNP_EN state:

  - cpu_hotplug_disable() when SNP_EN is programmed: in snp_prepare(), before snp_enable().
  - cpu_hotplug_enable() when SNP_EN is cleared: in snp_shutdown(), after the firmware clears
  it on X86_SNP_SHUTDOWN.

SNP_EN is set only by snp_enable() in snp_prepare() (gated by online == present),
and only the firmware clears it. So:

  - snp_prepare() programs SNP_EN and disables hotplug on the same path; if it's
  called again while SNP_EN is already set (re-init), it bails before the
  disable.
  - snp_shutdown() runs only on the X86_SNP_SHUTDOWN path, after SNP_EN has been
  cleared, and enables hotplug. A legacy shutdown leaves SNP_EN set and does
  not call snp_shutdown(), so hotplug correctly stays disabled.

We also have to re-enable cpu hotplug on the init failure paths 
(snp_prepare()'s online != present check, and the SNP_INIT_EX / DF_FLUSH failures in 
__sev_snp_init_locked()), so a failed init leaves hotplug enabled, as it was before
this support.

The only extra case is a kexec target that boots with SNP_EN already set (legacy
firmware -- on X86_SNP_SHUTDOWN firmware the full shutdown required before kexec
clears SNP_EN, so the target re-inits normally). There snp_prepare() bails, so I
do the disable once at boot in snp_rmptable_init() when SNP_EN is already set.
That and the snp_prepare() disable can't both run -- SNP_EN is either already set
at boot, or it gets programmed by snp_prepare().

No (extra) flag needed.

Thanks,
Ashish

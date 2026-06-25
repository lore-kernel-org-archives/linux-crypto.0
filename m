Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011004.outbound.protection.outlook.com [40.93.194.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7B9260580;
	Thu, 25 Jun 2026 19:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416556; cv=fail; b=J/Uto2P+q2e0T+ew5oYAJgG9mBG/C0wzp9xfbEr1xFgQcEK2xub/qr8pqyIMNs3tbmWjT4QgET/jdP+x2b1Wp12ouH3c8dO5tiTvGJk67nFbeT7gLHSkPYxS2ckSkTuVz/HN0dWl11vNPpr1A3T+nJlN8MrIBpXSynwUrXmTnuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416556; c=relaxed/simple;
	bh=sEcRpkYENpq74t1RNn635oGUp8G3UL1+pVwC8OQxPSM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b6be1/n1SwJBLPcNL7/BzienRSaazBZNyPrSsZRC9uTyz48q8c/co0cVDzkOvcfGLRZymYhpu+cVBGS42lHJ7oi03L6ThD3LAU0Shtki9fs5dBSl52x52M0XM4clIhVzC/rAUFlnkoutZCg4ONoxsLdvNfPYBwzA7z5E1ATkSSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1KthDU5n; arc=fail smtp.client-ip=40.93.194.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1KthDU5n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4OsS6BSlS1kHuevDFrn75Np5MhzWxFRYkb99t4w2QckVo/QbDABvqqfWx9I8nOCadOX00N0XneE1h+fgjlD9dNCzmk5+jjr/RzwD4Ccqll8v3wxjABDT1PwbiYI9y3u9kwmTRWSKb+SfgX2BzOWciItUc2F051aoBmvs0kKlBfPh+enJdWz7qATqGV3Ql9sWoEEwfIdTc97agIeA+/jSpE0jK7ZzhmIugxPDMBFRAb3U7AmkiUfxCCVT0da1NaOdwG3kngb8SujtlKcSqAaKa08zHe2RlMw6dstre4RpPfGx33Kcil1UykDw8oi6zthPV9QEqgjO8OHzpFyNgYojg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xD6NC9xU3uuPY/oSbeL1nW5EuE1t+NlvGwjEKNxtoms=;
 b=Q7yl4jAHrZI3a0m6+zNdOw37J6tLOsAguM2XHb8Htm01gb5Weu09Ku3Sox4tp6N+GAi9D4iFao9tlTPjQ66FtDy3SNQC6NNNPDOeH2CtnLr2jtt6L35mRKjwEJ9AalfjzTQWIy2RXqwHfn8aIgn4lrW8mdnT792jTu/kGVcNo/j5DRg0F+uaaas/YVcRabbPjXMHfKjtQJlgFylnedDBKt3Wbnjo3Q5BybAN0eUvEglCqbiroyVxJMPiLLuKyLXOSpqe8k3lNxnGFjcAD7JnMbZLmWzDm9W1b6CsJ6ZN3ASk21VaHVZXrWYR7IrWYXkKizctyuyo+Km+JTee4FN1uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xD6NC9xU3uuPY/oSbeL1nW5EuE1t+NlvGwjEKNxtoms=;
 b=1KthDU5nKuLAz21ITFREYNRxgmTP3IfPbBdd40efFFNEfNl5FtCpDDqeXiY0meL31ERlUp3oj7v+02Z8Cwp0E/hfn1wNtTfPPwKOpTKQV1RHYmR9F94auM1uhrson32IRDNe9V1dkLW01OAkPk/bISHwRFJd1l4ktuOSVs5qsow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA1PR12MB999230.namprd12.prod.outlook.com (2603:10b6:806:4de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Thu, 25 Jun
 2026 19:42:32 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0159.012; Thu, 25 Jun 2026
 19:42:31 +0000
Message-ID: <7c64d96f-f932-4db9-8119-b9e40d5b7fd9@amd.com>
Date: Thu, 25 Jun 2026 14:42:23 -0500
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
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260625150253.GAaj1DHZC8ULg6PzbI@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:610:b2::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA1PR12MB999230:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e70caaf-7bfe-45ef-9bf4-08ded2f1e439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	7JquSdLFr1BmnuxngKjuTBCzRCUE+j1i4Kd5Xio9fTEspUemCUxTmOfwjKRg4H6xbMZa4RV7GXpy9MLNG/gFgahCSMm48GBiHMOid4XqUOJnE+5IRt1sDCmGsE0w3e+XUHxBG4Wwdlq98rE2x+EqqUhVtK+tE4MzF+31kViJ45lYFlEtuJKpfLl77gB2/0YX4WSYMQ+NhY0Tw6c0EIqGOJxUwOTfO65cjd5omVk1eJFSiIUomGvpxur8+lMAFlg4qWYBz6bBpUrjY1bTH3hNhP7IKu/ZhywNgSM8n5d9wxUq8+zjE2Ja1FKjR2uoCQfYvx8nzp9QpDhk4yLA8pcInj4nooiQR7jKw2Y+g4lWJ6PWx7a0qctEdCFb1LjY4SlEFWzjIhe0lC8RK12bo7HBGkzC+GIpSsbI+BUcBTUTF62Dh2KgoISpG/IoHCugq7VQMKwWi5e2yd7blT05oijVFJ3NAfPRD9bV+lHt60yUeyKa4gCnWk5VCYfjx0/mCz07OWfRVUt5pZ9kshJ3muQV64MZ+3BBK1RyKYeHIR+GCs4EgwtgzJFqXL5JGrCPNMiHL1My98TAw+ya1itO1hL76J3ChG5HhEmZdn/KCsANIgwJxxMyXApwwj2uL5Y4tnpBawxOCpcsEScUC17y8oe1d6A/dLARiPOzme4BCEu8unE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEExa0FwUkEzOVQ1THdpVTRQanJLQlpFNXdjYUpjaGR4ZE5BRmYreGM3VXR0?=
 =?utf-8?B?a3JyRHA4Wmx0Vkdwa0VDRi9sdC9pREU2bWxGR0xEcmp6Y1o0VGtnSGwzQVhr?=
 =?utf-8?B?U2J4aHpCNUtELzBOOFlEZGxHd09qWUVWS3lnTUhlb0hMSDFvSUw0enRWWkp6?=
 =?utf-8?B?eVg4TlM2eEM5OXhweVBaSGc5ZlJCbHI1Sy81bHZZQmk5UVFMYnBBelJ6ZFM1?=
 =?utf-8?B?QWh1T1dwZ0lsVWV4QW9qeDhUTEdYWnRBUXVDWUJUbmhuUm0zUUJwb3RnSGM2?=
 =?utf-8?B?NDJpZkx6NmhjK1VvSWh2dnBLd2dDUFJBWmZDaU12d3ViM0Q4VzJwR3B2WUor?=
 =?utf-8?B?eUNsaDFnSkF2NldpQ0pMVkF3M0MzTlo1KzNSZUpJbm1qWjZ5UGJSL3VKSkto?=
 =?utf-8?B?VWIrNWVlZGpiaU9hbHUycVVheEp6RDhaUktOYlZtTHVqendXRy9meEJvczJh?=
 =?utf-8?B?QkVtSGZmT2VIZnVDMTJ3d2NwbDZCTnlhTGE2bExHM0dIcHBvQ0xTMHdQdzdX?=
 =?utf-8?B?ekdMM2orUVNSM3RXS0dKWmxKbnh3dWlJZXpCYm55L3NwaGFiL3pCSjVkU2ts?=
 =?utf-8?B?REFoUWw5YjVYRVJnQlU2WndRUGw1T3VMay83TERNd3NsbzFjei82TStFbnFV?=
 =?utf-8?B?M0JZd1JpU20rN0RUTlNQNjVzSlgwM2dJNXdpbEZHYVU3WkgvZ1lnUnduNjQx?=
 =?utf-8?B?TW9CL25CZ0diNE80MlFhL1dhOFl4QWkwaE50OUVZR05EcDF0d3JRVENjQzh5?=
 =?utf-8?B?U0xIQmJ0eXFyRnpCVVZEWUVzUExVR0x2M0dFSG13bWlWK1pKOFQ5NW9NSEdJ?=
 =?utf-8?B?bjltRkc5T1V4cXZjbGhBSjYwK09vSXVJb05xNERDQ1ZLeFpNMW5NOFljTTBB?=
 =?utf-8?B?NWJacDRxdVJvcXpZR2ppanl1OW0zZ2tBZjRObUhjTzZlWUhVSnNabkpWSmx0?=
 =?utf-8?B?K3U2ZkxMQjJKUU1UWFZaOW1EZzRQa20yNlNydmhwbjlDNTlhcER2OFJEL1Zi?=
 =?utf-8?B?OVZLdklTOUhNS1RWeVZ5b0h0NGJQYW1Za1orcDdCbFVHSkxlSHhHUEJCdVZW?=
 =?utf-8?B?azVkdDVkZ0pEekxLRG1rdWlkSW5UbzRrZGc2MFhBZWk1bUQySzZtdzVrcDNK?=
 =?utf-8?B?bmhJcTRxelNOSnNRQ0doNWp1ZE5SanVqRFFhSGpYTWQ5cktIbXArMzZKTlBD?=
 =?utf-8?B?TGFTMEcxZlFMeWxKdGJSMXRNcEc1amRJY1o0cGdVeWRYN1g5QmdNeW1vRmNs?=
 =?utf-8?B?MUxyZVJtMjM5ZUR4SWNJMkNJODk4YlROUTM5ZnZjNUp1TVpGenExSm9jcUNO?=
 =?utf-8?B?TVA5c0VTdm9iRmhqRWhXc005T1hjUEdiS1ZyS3cvUXBiY2ozaGZTWWRxQm56?=
 =?utf-8?B?ZjZRaTBWTDViTWc3eUExZFVzenpJRzNFL2pHd1F6QUFpQnA4OFYzUUp1amV3?=
 =?utf-8?B?TCt4czNYT2ZMa0FZYXJoQWViQzZOVDhxUHhuSERxYXQwUDU1RElBV2lMaDEy?=
 =?utf-8?B?TWk4L3BxTGtpd3VLcUhleUxKdXk4dVhmSGg5UFczODBPOWpHeFgvOXRVVS9L?=
 =?utf-8?B?U3dlMCt3Tm5lZ3EvdzNaQ014SHA4SDk3bVpGbzc1NnUrRmRrN3pocnU4Q0Z0?=
 =?utf-8?B?akh6cHV1RmRmOWdlODJlVUcwSVlnUW9Nb3FxU3g1d1E5MUpqWnpzNWdkWmly?=
 =?utf-8?B?dVY4ZnI4SzNBSTh3b2RZeG5JRmt2RXNodXgydDVzL2tGbWt5UzMySjY3N2ZH?=
 =?utf-8?B?M3BSU1g4TkVNS1cvYVJ2Wkw0clk3bnpzbGQ1OUFrcHU2MHRvU1gvZU1BVW5W?=
 =?utf-8?B?bFpKRFpXTkZEZFFCVUJvd1dkSjM5d2h3MjlwSG1CZmhLR1pvVVBFUWF2WmJT?=
 =?utf-8?B?OWxMcmxweTg0TUVqWEdQbFNTRVl4OXdBaGJ2UUFtUzNmNW1za2NRcnlWSHRj?=
 =?utf-8?B?TlMzckNLTjhObTY5OGZrWXRhYnNUS1pKVi83UDB4WCtlcC9GVzhpZTZvT1ZC?=
 =?utf-8?B?R096Q0NsRnN5OXg1ZGV2eXZNd040OUhFMktYcHRGRW11YzNUako5RE5hNFcv?=
 =?utf-8?B?Y0VpcEx1eVVIbGcraDFldldpd0xhYlhXbERMZlZGR20weXJaZ0ZqWXVuM1lo?=
 =?utf-8?B?YXFvNFFKclBSSyt6TTMzUVJzTFNETSswejlNbmdKQUcwZnNQQTArakpMUy9o?=
 =?utf-8?B?MTdOUk8xcy9POUxPNXRXRVhtKzM4V3NjcmxZSGVSL1o4YWVCaXJOSk5YZEQr?=
 =?utf-8?B?NEJjZ1FRbWhac2xENDAxRWVDZ3FhNTZwREt3WHZwczM3dzQxeXhiRHJ6bTJi?=
 =?utf-8?Q?tSp3TV79e4MLtoZ4Wq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e70caaf-7bfe-45ef-9bf4-08ded2f1e439
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 19:42:30.2446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph0xOjqMs4RaobtDc8l0CRpSlbXfyCIFWIs1fJ9XYc7c+7XLKGpF8Q90nHUvdDnQ4ZE2/SJR05mLceZwFEJlcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999230

Hello Boris,

On 6/25/2026 10:02 AM, Borislav Petkov wrote:
> On Wed, Jun 24, 2026 at 09:56:49PM +0000, Ashish Kalra wrote:
>> +/* Set while SNP has CPU hotplug disabled (kernel-lifetime; survives ccp reload). */
>> +static bool snp_cpu_hotplug_disabled;
> 
> Do you really need this?
> 

Yes.

cpu_hotplug_disable()/cpu_hotplug_enable() are refcounted (cpu_hotplug_disabled++/--,
with a WARN on underflow), so they have to be balanced. This flag collapses them to
exactly one outstanding disable per SNP-active window, because the disable and enable
sites are not reached a symmetric number of times:

  - On firmware without SNP_X86_SHUTDOWN_SUPPORTED, __sev_snp_shutdown_locked() does not
  call snp_shutdown() (it's gated on data.x86_snp_shutdown), so SNP stays enabled in
  hardware — SNP_EN stays set and hotplug stays disabled — while sev->snp_initialized is
  cleared. Re-init after that is routine, the SNP ioctls self-bracket init and shutdown
  (e.g. SNP_COMMIT, SNP_SET_CONFIG, SNP_VLEK_LOAD):

  if (!sev->snp_initialized)
          snp_move_to_init_state(...);   /* -> __sev_snp_init_locked -> snp_prepare() */
  ... SNP_CMD ...
  if (shutdown_required)
          __sev_snp_shutdown_locked(...);
  - So whenever SNP isn't already initialized (psp_init_on_probe off, or after a prior
  legacy shutdown), every such ioctl does init -> command -> legacy shutdown. Each init
  reaches snp_prepare() with SNP_EN already set, and the disable now sits at the top of
  snp_prepare(), so it fires on every cycle. Without this flag that keeps bumping
  cpu_hotplug_disabled while the legacy shutdown never re-enables — hotplug ends up stuck
  disabled. This flag makes all but the first disable a no-op.
 
  - Also, importantly, kvm-amd module reload on legacy firmware is the same pattern: 
  unload leaves SNP_EN set, reload re-inits.)

  - On the enable side it avoids an unbalanced cpu_hotplug_enable() when the teardown/failure
  paths run without an outstanding disable (e.g. shutdown of a never-fully-initialized SNP).

So it's not redundant with cpu_hotplug_disabled — it tracks whether the outstanding disable
belongs to this SNP-active window in this kernel, which keeps the single disable/enable
balanced across the asymmetric legacy-vs-full SNP teardown paths and re-init.

Thanks,
Ashish

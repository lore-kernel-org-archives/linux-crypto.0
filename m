Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810DB2E7F0A;
	Tue, 31 Mar 2026 00:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774918513; cv=fail; b=NPDU2UmIfyVC7Bx2DR3KqwlV9N6mmS2521ESgsiq8D/+68X6ID5CsYK2oQ+0rtJJjOJu6EO14pM+CmPox2AbZAwsGQIB4j+iItrsIxlpl3cd9T0cg/m5C2IxcCCpyTjiL6RSokhjYnYjfs8v+0liDhhj4Ea0Ill6OkUxqt0lPEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774918513; c=relaxed/simple;
	bh=evrlFNoTWAUEyYXkfcIibXhBVsXy2U+wqUt79sCE2fI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eFnZa3mEenUiFabxsNlr88juAD+fdArEDGkbzEouctJ9Oif7zUawTwjobJ+/NAEx5RBDmOLkFyXJ3A9uyE6s9rZe23+pipxKlX2I0S3WhnqnDppvJTOm6kb/uxKsJb82QpwQ2sINSjQZSmZbrolrb4sCkyI8S89VhQTojwgk7gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W81BLsAK; arc=fail smtp.client-ip=52.101.53.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W81BLsAK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBqIYvKXnVG9AAmF0ecg79VtO58JEkmkyvAH7eV8mxllCzMfwcoXJ2ILhcRTClY/0WPQmO6Gtg9ZhtJZv7bNSH08fATOuoN7/VnCFXVIm99xcKjIbidIbcZrW0vKI3/RT/lbD7jZmgRBir/V0gVMaWrOKlmuPYv4cPCwMId9/oyDL/E4ZusO7XPaSRIj2OIZaJ5Iewy07Nldw53i6XX6cWEEoBZoMz8gRHJ19Fiwv5Mos3lOHQwF6XDLy62CX2sd9rxhYF5dYKXeEOB9IE1unRW9awL+J4VFsnbXYU5uc3An/Osp2JL2+JCei/NZXPrLhpZIjNBeu9DtpEcn5xFIaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgDdk/ahC+JKMKpsUvKYu5/qyp6yCiS/49rN1EPQXG8=;
 b=Ehky9TZnSH73VaXmRAhO0NboazirNVsROceZZY6vYLqV5GFW3dW8BklqeG9UNPWqPcnj2CGo8AtLKGBMJLmMTyujuWq6CSvo1y3INbsC/tZZTmj0sG1SATcB1UZ1UG7KJs2OXwMv25LDxK86+7yDOJhy5t89dj71IdMVDM07e/Np8/yL55HksQUvG40mmJuWKcuZWXAMBpRNtSSycAzGG/9a/6KSh7sxN513xq/ouqpxwFJCIWJHC5lI3rFRx8sAZ52eaB9T+MmeJeWwcNLzbqaE9WBk0gSDdpnVUAtVJLr9YGjyNs3ZRyEKZc50R3AeCD6k4Cevo0OoL+SNN1cckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgDdk/ahC+JKMKpsUvKYu5/qyp6yCiS/49rN1EPQXG8=;
 b=W81BLsAKVszwAj7OSGbJks9IB7kSh9sVk9NUCF/tqoRxZqniFn7rnjsrWEW/w+ZsYfdxdk7xCTCAhn2DHzZwd3x32nO331KyjgjpNCJ8tGZjqGq/3SxeE3Hhy3z1x+RitC/2IP2kxOkBDcvLph13TUjA4HxqUJJotuC0cqgfhWw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM4PR12MB5793.namprd12.prod.outlook.com (2603:10b6:8:60::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 00:55:04 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 00:55:04 +0000
Message-ID: <52e3f2cd-7d89-4181-b88c-67901cc92aa5@amd.com>
Date: Mon, 30 Mar 2026 19:54:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] x86/sev: Add interface to re-enable RMP
 optimizations.
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1774755884.git.ashish.kalra@amd.com>
 <a30809d43368d6ddeb82e6717be83327282ee52e.1774755884.git.ashish.kalra@amd.com>
 <23267200-9fed-43a9-a28b-a6daa701159b@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <23267200-9fed-43a9-a28b-a6daa701159b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0421.namprd03.prod.outlook.com
 (2603:10b6:610:10e::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM4PR12MB5793:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e29abf-eccd-48fc-05a8-08de8ec024e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	liBSRLbet1kNrEwv8fdCJsqEZvDjq0HNurFeSzYMhEYpHDwoyiqvtvBe8edP9U2BUt0X2YZAGHQANM0/GtJHUPsm4CmHYKsShU3J2Dd7zossbNNpD0KCwQakuEQD3S4XFDYkWJrO/AarOCnFhO30j38aP9GZEswBbYlVkX5VTESYFL803DdCV9im1XUpQwCao2uT1SFbbcb34TNRbdBM1Nr0wtZOkPlIIanXMuynNLJnj/ITPOvLKs/Ho/X83UpiSqSgtk9SNlvNVt04Vm93zy+DZWP6/xTQ9WT80MsMRgO7fEgO2V21IjO59g3CZvc2aJrKdSGdmfU1cyqOp5twuzT/6K7eR0C4FcsDqyW+KdMxWmaWCWUopfgfD43RT1EVomX7ofmLJW+3ajCvCEC3MMRaJq2VtwP88aJk4LsnuksxVhqp0MbjXYzdX7KWUQhEl025j2M/ju6jRg8yibslRdwgedXREDae8Cy9T2qOShnWJYoYmAm/6lCh24oZV81EHHZYh8uRdp/uTJEXK/n08JyL/6RLFdlHfQitWUsz2zR50HYTifyLCgLbCmUdojPGKnTvMk7Lc2BbMtu3E0gFo9S/ZGOuedZ5j4IjU4TIjNxToEEVc2/KROMMY6IpAR0ftAHJVdPEqPNalQS3B/8QE+szHbaznMHDfpl/6Thxqjutj6371ynIOTXjwqLYjSn+0SBiEptHQVv71xjQ06znywNG6L5MAEPclIj4maKZYwME2vISrCGhf+Xl3pIOKbE0TuCLLb6VwjNk3NuMllxulQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0F5QWo0TmRNcHRtRkRuaW4zSFhxTVpBSmdtcTZuRVp0aUlaVTdBZ2pkaDRn?=
 =?utf-8?B?dWhwdHZiWWVKUEQxWXZISUdVVUIwMi9CQ01PVkN4WXlEcWVIZHFmejhuOFA0?=
 =?utf-8?B?ZlZBa3dPcUxhR25tSGkveWNSUmdrN3duanplT3RlZ0czQ0RORXBWVTdIbkVK?=
 =?utf-8?B?QTlTMFVUZVpHOVVqeW1FWmc0S3FkdDRVWjZHb1pidTZPVDRtb3hlSlgydHNL?=
 =?utf-8?B?ZFRVckQ4V21oZzRvbjVyMVRza0U4UmNPeXQzaVFVRDZNcDhOWThpdGc2TW53?=
 =?utf-8?B?dEYzbTR1SGV1bnc1MHVxZG8vV0F4d1IrYlJKL1pXYVpabjZNcXFvQW9KT0gy?=
 =?utf-8?B?QUpIMHFXN1BRYjBubFdIYldtbnQyY0dlS1JCZFY4MGZ4Tm9WMWd5RGhGMXIw?=
 =?utf-8?B?UzIvQjRZamJvdzVnVlkvUGhGTzJQbUpXVE40dzlpd3FvUWl0aXU2bHZlcFJ1?=
 =?utf-8?B?MTkxdzk0K1hFR3VZd3JST2hhZWRpMFlScU5rZjREVG5WSU9CTDFKY3lvS2lI?=
 =?utf-8?B?b05iSXkyVis4RStMNU5NSHJDUWdBbm9wYnV0cndLR2RpWExubHJZeXJMY0hr?=
 =?utf-8?B?YWtDMnBOZFlHNnlidDFZWEFORmJXZGpwRHBENllFaDVab1I1cVRXSTQrU1Iw?=
 =?utf-8?B?VWJzMUs1MDc3UUxxSDNORGFVSzUraSswSmt5TUJ3c0FGTjFEYlM0NDBDMXBY?=
 =?utf-8?B?ck1IYzNhb3dlbEc5Uy9Sc2lnWGhMa2ZwWVNlWktBMmZ1bUF3a1VpYXJ3Q0ZV?=
 =?utf-8?B?WUZDVFV2MmhsbG5ISVNXS003QUozdzlIOWM2MWZRUVd2T3Z4dVNjeHdHeWk5?=
 =?utf-8?B?dFZ4ai81MEJoTUV6TG1Sdm5sdG5RMGVOK1hvUUhuRjlpTDQvNnRaWDNralFk?=
 =?utf-8?B?SXlLSldBNUZIclZXbjdEeWs5RGN2SzBMRVIvZWF1QXFESkMrekMyMlVmK1BM?=
 =?utf-8?B?VTdwWVpaYjZvQ1N4OFdQUWpWYUZFemMrQUxZOTRsK1ZFMmVTeXg4bThBbmJ2?=
 =?utf-8?B?ZlZ1ckF4N3BFYkxoV0RDR0FTMUxmZkhjNmZORExVSUVUUnBpbjRYOEV0eXBq?=
 =?utf-8?B?MEJCdWZFRHVVQjJkYTB4N3dFRk4yc3FjTjRCR2dKWmdIUFpjaTFoYmorTHUv?=
 =?utf-8?B?WkxtWHdGNUJOZHhlQ0JIWnBmbWtDczBLMjNoenBtL1RxOXZIZkxaVFBMVXhP?=
 =?utf-8?B?anExTWsyZzZRTFlQV0thbUZ1ZkRJRmFMNXdVWEZxUk5Dd25VcjVGalIzU0Za?=
 =?utf-8?B?Vk5veUUrNS9JcEozT1lDYkp5NmFhaFBkaW9rMEpIQVp4My9PSnRsaks2aGxL?=
 =?utf-8?B?aGtqYVRQNkNvc0dqSEkrU0RLSUFKOXdhYVBCZ1JiYjNacVM3bWVPdForVVR0?=
 =?utf-8?B?K1hmMUo1WFh0RGtRWDAwVVROVGNOWnB3Y3hNdXNjUkJzVzlpRUdwczdFOVBk?=
 =?utf-8?B?SWZqSlVmdEZmR09pcWV1SHgyQUdVUmZoa2lDWmtLak84L3RUUTg3TTB5WjFt?=
 =?utf-8?B?MGNObjAxSWFNTG05TVQwNGgvZG5MSlpuVDZLWHNidElLUDdoRm9OaXkya3V5?=
 =?utf-8?B?TERXOG9tM1NvMjVBaHZ1dllvMCtRdGd0S25halN2SFhaYzBXSlRuZW1hTkw3?=
 =?utf-8?B?NVJRTWs5QloxSDJzTExySklaSGI0aTZSQmFqYys2cEo4eUJybFdJaE1ONTNZ?=
 =?utf-8?B?Y1VPdW1vOVdoTHhjUXFrWGt3TThZMGI0KzNPWGJIZzZSMFhVL212eGlaVTQ0?=
 =?utf-8?B?V0lsYkNaOTZJU0Z6VkFTRDdTVmt3aVZqZGpiMFp6cXB5eGhuQ25nTjhHVFlq?=
 =?utf-8?B?bFhLUFA0eStiLzlMVTV1SmkyTGNCc2FZMXdDRWZmTHBJdmc0WVNmNmM3Z0RF?=
 =?utf-8?B?bDJjY0NaNDNwZWw2WkN4U01Uck5oYVIrUEVOUmlDSWVFLzZ2alI3SkVnb0c0?=
 =?utf-8?B?YnJuUDh2NkVHYVo2Sk1STWdWWGtUZGUxSnJoZ01qUDJpRFR3aTBKbEVDREpL?=
 =?utf-8?B?cmQwYkIyaG5ZUXdQckhMS3VmRHE5K0NsU2s3N0NFSGdRdWI4Rld2Nk9oek9q?=
 =?utf-8?B?U0dqOGUyQ3hRMURGbythQ0pDU1pmUXRleWJIa1UzbFlhbnhjVTk5czJ5bHcy?=
 =?utf-8?B?MDZwU1orNkFCYnh1cFBwMElDek1nQnJlL3JjV3RlQkc2YWUwbEtNZi9Wb2dp?=
 =?utf-8?B?T0U2Um9SZzUwUGFRbTBBUDhsUmNPTHd0RXJCa3FzakUzamo4YkxlQzdWRjFO?=
 =?utf-8?B?TkpTTWFqaGVjNGRodjBrVG5uV0wwcVpUZitPMjFTaC9BdTVEZHZJMmViZ2ht?=
 =?utf-8?B?RnZJdGZJVmJGRThod05iL1k3b3F2M0tLSEtjTlhuTWVjcmxycWY0Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e29abf-eccd-48fc-05a8-08de8ec024e3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 00:55:03.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a/sQpX/50KX4QdIodtVBOXSvTdZohx9dHJOj6i18I+CaGQ0TKtNAV0euvlDWKQnGcwclPtwaetQhSrLmfbmBzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5793


On 3/30/2026 6:33 PM, Dave Hansen wrote:
> The subject seems rather imprecise. This both adds a function to
> "re-enable RMP optimizations" *AND* calls it.
> 
>> RMPOPT table is a per-processor table which indicates if 1GB regions of
>> physical memory are entirely hypervisor-owned or not.
> 
> It's per-core, right? Why not just be precise about it?
>

Ok.
 
>> When performing host memory accesses in hypervisor mode as well as
>> non-SNP guest mode, the processor may consult the RMPOPT table to
>> potentially skip an RMP access and improve performance.
>>
>> Events such as RMPUPDATE or SNP_INIT can clear RMP optimizations. Add
>> an interface to re-enable those optimizations.
> 
> 
>> +int snp_perform_rmp_optimization(void)
>> +{
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>> +		return -EINVAL;
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +		return -EINVAL;
>> +
>> +	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED))
>> +		return -EINVAL;
> 
> This seems wrong. How about we just make 'X86_FEATURE_RMPOPT' the one
> true source of RMP support?
>

 
Ok, i will work on that.

> If you don't have CC_ATTR_HOST_SEV_SNP you:
> 
> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT)
> 
> Ditto for MSR_AMD64_SEG_RMP_ENABLED.
> 
> It could also potentially replace the 'rmpopt_wq' checks.
> 
>> +	rmpopt_all_physmem(FALSE);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(snp_perform_rmp_optimization);
>> +
>>  void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>>  {
>>  	struct page *page = pfn_to_page(pfn);
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index aebf4dad545e..0cbe828d204c 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1476,6 +1476,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>  	}
>>  
>>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>> +
>> +	/* SNP_INIT clears the RMPOPT table, re-enable RMP optimizations */
>> +	snp_perform_rmp_optimization();
> 
> Ahhh, so this isn't happening at boot, it happens when kvm_amd.ko gets
> loaded? That escaped me until now. It would be nice to mention
> somewhere, please.

Well, as of now, it is happening at both boot time and here after SNP_INIT_EX,
as SNP_INIT clears the RMPOPT table contents to 0, but eventually, when SNP enable
is moved completely out of snp_rmptable_init() and only done when kvm_amd.ko
gets loaded, then it will only happen here.

Eventually, call to "configure_and_enable_rmpopt()" (setup_rmpopt()) will move out
of snp_rmptable_init() and get called from here.

> 
> There is basically no naming difference between
> snp_perform_rmp_optimization() and rmpopt_all_physmem(). Can you just
> get this all down to a single function, please?
> 
> If you really have a reason to have a scan now and scan later mode, just
> do this:
> 
> 	rmpopt_all_physmem(RMPOPT_SCAN_NOW);
> 
> and:
> 
> 	rmpopt_all_physmem(RMPOPT_SCAN_LATER);
> 
> *That* function can do the X86_FEATURE_RMPOPT check.

The only thing is that this is an exported function out of the x86 platform
code, so will probably need to be renamed as snp_rmpopt_all_physmem().

Thanks,
Ashish

Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011045.outbound.protection.outlook.com [52.101.52.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749603B4E80;
	Tue, 19 May 2026 19:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220636; cv=fail; b=QXDAn78JIMxJVsiMmTmM62J7Sg+9lgFW1d+e4eOvbjwNK1T9sUn0GS+cPZuLCX0KWOi+5hE0pW4o59pREGdVodtJAAPaz4qrm9FTRaFv0AUMHgZWOBN9honwiefXhieGau44ZX0GCGShauo1jlnZNhPvhXFj5+HjhSBvGN16gJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220636; c=relaxed/simple;
	bh=YCwJaAGuLCphoWZTh8o8LuwELy2jjPgRHINkRkERiUs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TUNMCWBV0geQhjKIb5l2Y5UCuhg8Mbob57azd+atGp97XpDuf27mjS1Ntskdjrr0nldtt7t6LVI1YWmFTfCtUVH5RRgrgAkzBbDDTKdEqJrkhaLq8/qhafo7KvlbJSkRLgLKlYWjCxHtvXcM6eqLHjjJcf1gWMyfk0iCOn0mcfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R1WR17EQ; arc=fail smtp.client-ip=52.101.52.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R1WR17EQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqM2ElSHiNDCDpZt50M1yxSPaYHofO5d6njUpLG5sdUrQiF6tVZK7zpy5s8G2p8wrP+Z5PnOII8sDnz75sJBnv9zdouzDmHZkfaxrDofRDvtreu7Xwxj/0mm1btf058tj80/7LvX0iCQSBuKB8JRXMBhc29O1ElLLhndRMU9RcE1DtsSnSXgJa4mxHCiMiXbB9LODzDaGPnkUjMYPgUH3bn10AbWRWyHpzi4IuibGB+nSTp50/pbfwNOLWxmuuhWumrrXhUC53GnLBjCkR6O2y9d18tB1nH9k9wZ//4pbGOn2h2vTs4qEkWQWY8xVMccC8rbdJcfExcDmIAbaP12fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3O0PPTu6BKfdOmXBGtQHn1JASv6pEhkGm2eyC09cRY=;
 b=iRw+xcRgeqTT/vinsxYyt6pez8qfgOqOxOCfnjk999CNpVTGyEWalXvkrBpPRm7wSBVvblV32EVNcWdp53cemxEd0V3hv2XwbXiV14K9i/5IdZcVq6eC1iFMoNyYMCFph3ATesRWcq2BPKuOAemMqbVbh+zYclUUQwfgs8IUIa8xD+glRnlKC7dVekbrDMulDYVRQ7pq1RFNw01+S8Kil8TVupFoQEbE6V7O7jVK9QY/6ujQPyiK2qZLvREJCrOYFgPBaBvPJQ32T9hDDJb478ClsoyV54cnT0CLXDckKN52EIlupHnsu8W7cAlbaK5EDxwy9Uhctrfa5hViJfjxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3O0PPTu6BKfdOmXBGtQHn1JASv6pEhkGm2eyC09cRY=;
 b=R1WR17EQZs72lOZxnGyHvrN7IBlK+eFbpzSuUtzSbOcCy6cQe1BfZAaS9uvKWsDlXYNSHH7iD6SDsqTLPWWoVis6Qe+SvjQqioyauR6xiBK+LEz7+HAKkJW61dAr2pYha0wqvWGRqEm0x9HhaPhUroa+XDx0QdawVJGecmeLyC4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB8660.namprd12.prod.outlook.com (2603:10b6:610:177::5)
 by MN0PR12MB5809.namprd12.prod.outlook.com (2603:10b6:208:375::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Tue, 19 May
 2026 19:57:09 +0000
Received: from CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3]) by CH3PR12MB8660.namprd12.prod.outlook.com
 ([fe80::87aa:52e5:4b72:d5f3%6]) with mapi id 15.21.0025.023; Tue, 19 May 2026
 19:57:08 +0000
Message-ID: <a043a82c-f3dd-4f29-86fb-60638eaddc9b@amd.com>
Date: Tue, 19 May 2026 15:57:03 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
To: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, aik@amd.com,
 tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Content-Language: en-US
From: "Pratik R. Sampat" <prsampat@amd.com>
In-Reply-To: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0059.namprd14.prod.outlook.com
 (2603:10b6:610:56::39) To CH3PR12MB8660.namprd12.prod.outlook.com
 (2603:10b6:610:177::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8660:EE_|MN0PR12MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: ca8a4239-757e-4568-d04d-08deb5e0cf06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|11063799006|22082099003|56012099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	eI5vupzK1YZC+ThIwciYJb/t5pJeS+CYJGVAKe5pftgfFiPIAHz9iU0cVcTp5/hV1ye9n4lXv7YaBo6h8wtJb0urKLLA0b/hmh7mAf2e7KdARsL5MDgXfnHCy6vWe+bFbhxzK5tKMtHyXaW4Uu54fggvaf8DIBBD6c8bdsLNiR+aDF2VkDymd5sk53JieYCOWbRd/oPtNDsiwclrhYPTxk35z2rOJHgIGU9hD2kmJyiXXlYUUNx9UtloTKWgG1fBXIzlFKNf0Mhzam00oX0Q7ulb+Nqyzm0QTJcpJEIg4U4disf+qbeAYTiS2BSb6QjCl/GnNEkJl2uCsBxommzHXk2nb9FkavD6i72H+xTt5JetzxTlL9vN7EFvwN7UyGe1Woi5RLoQz4usoUR0j72HpA74pN5Pg6tmQArTuHifJoyDb7vrl9lggqCiheKbLwE6FnU4WysMa6C0nT4J+R56MPsLKBcRc6SNzMnwF94GdmJVnqH1iKibOTtqNS2863+LawfZEGr302JFbuNDWoEZZLsno87UEESP74GVWbH6ev36Te/q/RyNugIy4HM3XpRWYLKWPUn2n/Q5LnU94zsZRRf7E1gyANiY0EOH8KsmdNlHAYGuLQVdzmA+mRuJBUqpWCEO6U/+COqKI3rpdYsIZGdvRFuAbLF5jnmN0F/8HDcVz8vVTCW/G+Ek2a9k+He6Ljx55zCvP7TYUu5My30uZw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8660.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(11063799006)(22082099003)(56012099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vzd6M1h3YzVZdzJMbmF1YWVDWnRiTDYwZVRmUUNNdEN4YlBrdHRyc3h4WHUv?=
 =?utf-8?B?L2xPZ09QSWpDRGFzZVB1d2s0MnI5Y2FzZDNXU2h5SVJhTUpORTVWeWUvbFdG?=
 =?utf-8?B?TnRnSnNMQlp2YWpGM0VhbWZrTXlVWWhSWVZ4cFpPVnpzUkhUVGtKRHFrSGhN?=
 =?utf-8?B?dStSVnBYV293QTZRMDVMM29CQ3hVdU1hc05aZmt5ZmI3SFkwcEpnUkpPUFVk?=
 =?utf-8?B?YXgxUnlMYnhzaFhRa0RTeFNvNTlJMVV5cEdvejh2OGw0NkxTUmVNaFBudFV5?=
 =?utf-8?B?YjdOcGxNNWZJTGtreTJsN2t0Q0M3WkVUL3RpK0JoTytkN2ZGeDYyWXJMUTc1?=
 =?utf-8?B?WWFRelh0TVM1NUxDTEdiQmJaRHZUZnJYWlZTUlBlVmI2QXkrR1lkQzEzRjVy?=
 =?utf-8?B?K0VVNVJoTkl2dWdUL3F1SDMza2dYbDVEdnhPS2tuUUtJdzA5dHlMR0N1dFFM?=
 =?utf-8?B?aUJqakl3TThZbldVNXFRMTZYMHRKbkd6YUoxZ1JKQTRMaWxuaEVtYll0NkEw?=
 =?utf-8?B?TkNrNVg3dkhLRWNuMTNNUy8zbDljaE04TCt6S0owZEwzbzJVQ0RndFpEUHJT?=
 =?utf-8?B?TWdmWGNZWHkycFJ4OGVsYjhkY2FwWXRsalpmZ0pYS3luUXpsOEtmNzlBSEtv?=
 =?utf-8?B?czZBek5Ub1RZcVBKcVlQUm5VTE5GZm5xbjhjY0hWSzBWWFdaakM0VEJxVEtQ?=
 =?utf-8?B?TmFreFVhbDQ1a1FvTEpUYlROYjVTaXY0ck9HQ0J0b3VhdFZiY3lFd1ErVnZy?=
 =?utf-8?B?Vk05ODlia3Y3aGtvbzZObytGM3BWa2dXUlFvdlNSQUt4UTg5MnFLM3IwZVBI?=
 =?utf-8?B?dlBCdEJoazBRcXgwRXFFNTc0enNmMllNQzdxSlJXNWZ4WFNYMmkyMllZdk5k?=
 =?utf-8?B?SmVPNzZ6UWZ0b3dNd0ZSdjZITTl2R2NnbGVOL2hpZlZsRksyNjgvZlZVY1E1?=
 =?utf-8?B?NFUwT0tyS3hqL1k3dE12ZzMwSm13TDdZUTF1N09yclpsVS8rR1RjWHUxOEtF?=
 =?utf-8?B?dnZsR3hxMHpXUnYrU1d3VXFBcDcwQUpqYmI4ZXptSjgvcE5Ob2VIMTVtRGdo?=
 =?utf-8?B?bkt2elpKS2Nlcjk5RmFjS0Q1NFJuWnhPTWtITDV5aEJPZVhvQXhKSTZsR1lv?=
 =?utf-8?B?emNDSVQ4dEJRN3lVU0x0U0hGZ3ovYWhmai9hbjBpWFdJR1JzRzlIcW9lUnda?=
 =?utf-8?B?S3g4bFNUQUFoVlJyNHBYRmhLLzJpZ2lLUzU1bFNIUytxclZ2Zk8xY0MrcElQ?=
 =?utf-8?B?L3lmSlBnaCtlK3ZDSWdUNUVVT2UyY2VuQ25iMXovaFVPRktjQlVDa09oUURh?=
 =?utf-8?B?RkJuOHpEMVFScGlsTlJtQTcrMDZkaTlET3Z4dmxDL1dicHNiN29YdnI1THVq?=
 =?utf-8?B?amZKRkpVTXhFUkN4RkxWUWdPd1Fjc1kwYUNwUWpHSDRrNWdXaGJJYVJLT3Vt?=
 =?utf-8?B?YVVzQzdtUVZZNENuRFlRK051SnhVNFpGUVczWXpPZkJCUkdrYmRjQ255d0pF?=
 =?utf-8?B?S3pGbGhXNjNSNjdRMlozZEZKVEFWSy9HRlJWbnJPaHBVaERPT2lxQWFxR2Zi?=
 =?utf-8?B?bFVVZEZXdzdydXpsSlVOZmNhRVZSK1lHNGJUVDBVUGlIQlQ5OFJSWm44cFF1?=
 =?utf-8?B?Sk9WOGFxSkRKeElFWnk3Y0lxNnQrelJYaXpzSURGSWxPelhCOFQ4Rk44S0xG?=
 =?utf-8?B?ODJqeE41Q1VxNFh1Z1N5NU9DM0lEM1VaZUlGeXI5ZGZzWWRDT1pPM0ZaRFV6?=
 =?utf-8?B?RjRMU2o1bW5CSkRUWkNUZGM1T3VvUHVwbisyejVNcDRMbjN1eXdyQjNJbk1v?=
 =?utf-8?B?UlBybU5zQkljNVF5TlpOTEdEdUFTNzBtQUcwZURmVUJ6QlJ6a0YweHhVNHc3?=
 =?utf-8?B?YnJTL2J5b09WcXl3K2tuemJZb3dEejdpWW9ET0VWQUd2YjY3b29WUUR6NTNW?=
 =?utf-8?B?NEVhR01nWEU4TXRUSFhPVDRhQjBMVFNMYmpRdkFHU1IxUGlJeGpyV0Z1a3Iz?=
 =?utf-8?B?cTJaSjJVTzVyaDNFR3ZGY2VBVEtsNlptQThjcThxRVMyWStDSVIzYWJCOWN3?=
 =?utf-8?B?SS9odmdmYmJYVVlFb1pMOEFpVDYxUmhPWGlRM3lBUWxvMXYzMlRHMWQ4UFF3?=
 =?utf-8?B?eGF2dG5FUmtpSENzaHdBMTJBckR3WGpyclBaZXJnY3AxQnNNNlZ0UnlaR3Ru?=
 =?utf-8?B?NjErSm9qemdaZmluaElZdXpScncyaURYdmp4dVhMRmJEZTNaUFkyNW5MMVNY?=
 =?utf-8?B?eE1SNUhJZWtZVXBTSXdibC9EUHlUZVQwOS9zcWc4SFN0blc1dWNsUDY0cmFw?=
 =?utf-8?Q?2HFeSEqR5B5I+BTT0d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8a4239-757e-4568-d04d-08deb5e0cf06
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8660.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 19:57:08.6956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hp5VE/Tbl6XQ1tx7cuVuQfo7AE0QScQBrCz3IB6bo9Myn1HL7XjXkL8klxz4Zh6NR3YPrJH4NDKQis82/AO56Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5809



On 5/19/26 3:50 PM, Pratik R. Sampat wrote:
> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> can be used to query the status of currently supported vulnerability
> mitigations and to initiate mitigations within the firmware.
> 
> This command is an explicit mechanism to ascertain if a firmware
> mitigation is applied without needing a full RMP re-build, which is most
> useful in a live firmware update scenario.
> 
> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
> subcommand is used to query the supported and verified mitigation bits.
> The VERIFY subcommand initiates the mitigation process within the FW for
> the specified vulnerability. Expose a userspace interface under:
> /sys/firmware/sev/vulnerabilities/
>   - supported_mitigations (read-only): supported mitigation vector mask
>   - verified_mitigations (read/write): current verified mask; write a
>     vector to request VERIFY for that bit
> 
> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
> it are bug-specific. Information about supported mitigations and its
> corresponding vector is to be published as part of the AMD Security
> Bulletin.
> 
> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> more details.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---

Apologies, missed adding the changelog with the patch. For the record:

---
v3:
  * Remove failed_status interface and report failure via dev_err - Tycho
  * Make vulnerability interfaces root only accessible - Sashiko
  * Move /sys/firmware/vulnerabilities/ to
    /sys/firmware/sev/vulnerabilities/ to be platform specific - Sashiko
  * Guard sysfs creation under a new mutex to avoid racing during
    creation and using the sev_cmd_mutex which would race with
    vulnerability operations - Sashiko

v2: https://lore.kernel.org/linux-crypto/20260501152051.17469-1-prsampat@amd.com/
  * Intrdouce /sys/firmware/vulnerabilities sysfs interface instead of
    an ioctl interface - Boris
  * Reword commit message to focus on need for a userspace interface - Sean
  * Since download_firmware_ex is the primary usecase of this feature,
    posting this patch in parallel to those discussions[1].
  Link to RFC: https://lore.kernel.org/linux-crypto/20250630202319.56331-1-prsampat@amd.com/

[1]: https://lore.kernel.org/linux-crypto/20260430160716.1120553-1-tycho@kernel.org/
---

Pratik

Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012003.outbound.protection.outlook.com [52.101.53.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DA9347FE1;
	Fri, 19 Jun 2026 23:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781913075; cv=fail; b=bFhDNJxKbxCdo/rxkZxFKhQDypGf/YV7aUZ9UY7pk4El1eS0eYehSaVzyOLa0MjElkEPjXO5fgdLuPHWFggGFp3ytQLa8R4eoiY+fIlc9drMIsC3GlA/K+zecJCtfw6Zh+bIqzk3OGnVZCX16VRqY7RIqeyv/vFE5YklwEahsgc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781913075; c=relaxed/simple;
	bh=dxLEJkQ66hkE+87bVuL1ouLkY06OwBuKzwQUVKWLWYY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qd/4U/OZHaP1xcDlIDOszn1B2LC/M6wuHNeDhrnZNOkNwc7twhPaP+4qOEpWMQ7VTIOOhuezwtV2OwSa6qGt/H1dat5j1FXrbpFMPU9FRk4OYBFmCxTP4gMr78+0wfL15+4M/4svQnVjNGek+dGHf5NSktqw3DgLzkzqV9JzU6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qVICAwMu; arc=fail smtp.client-ip=52.101.53.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qVICAwMu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p3TMisvzR8ZwdXmLeMs3BpNoDwC4rKI1dd2v9L0YBceOrWQdP3CVSbYeWji8dplXzg3QSno+SoFnFwWKmqdoDHxBO7lXxL5WIRe1NXB54NqqwNLjocOANlukx2FMg8SPnn3F6ZyUXjOWql5I3e2WRlTJ0tbAdZ41faPk7cpZltvfyk9cmPwGG3/zjR8rFAvEKhDU9y04Z1v4yvSxCEXwohbgcYTCOoMMvYHOCkYScpXhXqSWGEKpDUpQW8Y0q6AJ1WtQhRQADMCCpydIRcZ+weANfhEpyQTbCgCfhnLiF+EvbE8LsM5RmcZ5P5ea/dgQkwl014i1wtk1wnvMqy6Kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxLEJkQ66hkE+87bVuL1ouLkY06OwBuKzwQUVKWLWYY=;
 b=rTNYWGq++U6EAJHJzJ3e3X/i4cpJktmyZMeUTkWiOdF4y5XFB8JQubHq1kSOYOjliQ04fGal1G4fOuvPDNenL5wcZKExUNsKiJGxeDUa4xbnBjKl0TBhIW379GBrYhbPtXa6WoMBF1rHpFBDBiJhispSu4LQUVGt39LKRd6M42J0aoHy5adLPrkcXISDk20RTmE8PyjYJx6dIrNPF0e/XMmhpKLqNulkMaTBMqTXgzE/pB/qR7PXHpb7881OykKTfeFJWRkd8cw6qL+V1OnMd59fPnH+6RqdmrhhmmBTCYPe60cXM4i3UM4xcLgPjG85j+qfs6OLjb3VbEImU7gvXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxLEJkQ66hkE+87bVuL1ouLkY06OwBuKzwQUVKWLWYY=;
 b=qVICAwMumINJIQPBckK74+mYAzAQy/1KB0SatWmt314+7z6pRBgoT7aCd1w9geO/PvkpU5HwFhPH23vVcccO8CGfXMivpskpn+wrd9fdM8+qQJC/jqytAsSOKWWgYWDMtwg0cg5DIB67HzohIVG22W3XYK3dJy4dns8YY9CP5bQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ2PR12MB8182.namprd12.prod.outlook.com (2603:10b6:a03:4fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 23:51:09 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0139.018; Fri, 19 Jun 2026
 23:51:08 +0000
Message-ID: <e68a126a-6f2e-4a76-a691-f514b7f37489@amd.com>
Date: Fri, 19 Jun 2026 18:51:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/7] crypto/ccp: Disable CPU hotplug while SNP is
 active
To: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <1feccf6e2a56d949b30f403c0ca7949f580e5982.1781419998.git.ashish.kalra@amd.com>
 <49380c3e-c275-4211-876a-c51f644aeb17@intel.com>
 <bd2dc2e0-e975-40a9-8e0a-4403db858316@amd.com>
 <20260619221022.GBajW-TvxyCuGo0FWX@fat_crate.local>
 <d91bf0a8-0c4a-4552-9009-0ecef46aa279@amd.com>
 <20260619232007.GCajXOpyPbiu4FVZIW@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260619232007.GCajXOpyPbiu4FVZIW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0259.namprd03.prod.outlook.com
 (2603:10b6:610:e5::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ2PR12MB8182:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a687bcc-7431-4216-6a38-08dece5da279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|11063799006|4143699003|56012099006|5023799004|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oxGTtt7nbgGiY+bdSqEet1+kZPEXAAb9xLo01ICRcQKLsfwtcQ3AIhtGcMRzvhgGgiyAPGLKeZN0KZUB7vATW5xKb+q3WoIKPf15cjQaSz3OukXU7l80z4OZjUl/Cr5Xo/mTOp61eKxsIxnzj58q6av8vgbjdCosfzuU86BVCSIHVpRuF9aJLhld4+fwKe6prYAQ+h0eunyw7t8AzAlTrjRLARldKb5yhSyW5a0G8L9m8TqhO2pgm5lUjAzu3ZGKRsv9CEsxznUi/bjXx+5JHeeXJg/N6wBWsYZiI24TvC3t6tD8SXCKWF51tapg7Gt0xF3SRBis65IxYNp7EbqpTR0sbFBuuBCPCO4gsQvdFJet5DHTGeQIAjX7IQ980uinjugaJpPXT++cKbCdhPlCm2vcEaxiMxX5s+hVlNJhK0t5noLEdcEtuUSyBuVnoqeOHcIubuEVWI3gfjHW2Y1pKldTsoHzPgEfuscJ4zd6lFrhg6y3vcmaa8tuWuFCbarAw4jWAEJOJ00mTi+drXUrjamxEkUuQ7Bh6xiAuq8E/XqO8QRolVbXQg03EX8bDI/Sonl8WqEc6ZpdCTGuatVfofwczzzrVg5NSX9KtiCa8x50RGPydKUho6vQP9deH9PUHI//TREav4loWJTWJeY5Lelpbi8GqQ862Q7HBkJloV0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(11063799006)(4143699003)(56012099006)(5023799004)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTVWSnplVjRnMGNlaWhhWk9NdzhURFRJTFNDOEZZT3NrV2tJU3FGVjhENjJv?=
 =?utf-8?B?MEN0Q0tFNVFwN0V5M0lESU5Vc3pBUnN3dEZOd0RYaFhnc1hTc2hMVlNZSXJm?=
 =?utf-8?B?anhqZWg4S0FjeGNsTC8zb2J3VDU1TlM5Yi8xUjRnWE1JK1lMc2xyNytkamFW?=
 =?utf-8?B?TEFUcm1mZ0V5c1JtUTVZaU1MK0U4SDJVZ0dHbWVJVTBTbG1IMW52MWFMRWxQ?=
 =?utf-8?B?Z25HVU92bzVaZ0M1N2xCWXVqZUhHSXZQMmlUWGVXY1pNbG5rQ01RbDY4T2du?=
 =?utf-8?B?RWZWUHJSOHFSbnVmZGkrR0ttQmVyZ0xUVURGazdEYU0vTDdXaHoxRDJRRCtW?=
 =?utf-8?B?UDV1T3NlUWdDQ3ZxV1VTMmN0M0loQ1UySEY2TVpETXQ0T1JrSFZvZklkZGla?=
 =?utf-8?B?bGtSbzJ5MThMMW5NVmdRUFhDakF4dHRiY1FKYlJCNE1Ma2pZaFAvYmlCMXpL?=
 =?utf-8?B?V0sxNWFZT0lwcGJoL1Rkc2YzbyttKzJhZzM2SHRHVW16R2M2b1Y4MmJWdWMv?=
 =?utf-8?B?cXpNNzJ3Q3dYa1ZYVXZuR2RYcXVqbmFDRDhLZVMrRHQ0Smg1QjUreEJBWXhn?=
 =?utf-8?B?akRNYnhOekVpUEdZMXdQWDk1b0lMWXNHQ3NkTTBGZnhKM3dMOXNvZHplTWRq?=
 =?utf-8?B?K0FQa0NjSlp4UHFoc0tkcGp6RG9kU0N0SmF0VHRjL2J1K3YrUXhFRW5ST1Nl?=
 =?utf-8?B?MnJ3UGN5bkYvYnFPZjI4czcxOC9ldFV2b1hPNFQrT29jaHV6WlBmVXNOSkFY?=
 =?utf-8?B?aFZoYWVhUE1wMExEeEdIVGlxa3lPcWVUYjFyeGJ1cUZTRmcvTVRLdlZCdFBt?=
 =?utf-8?B?OTBJNVpaNGpqWHBqRlZEbHZGd2kxVUsvdDc2UHVnR2NLNVZ4UlBES2pWRkV0?=
 =?utf-8?B?V1gzeXZ0Mk5rTkJ2V0w4N1hhWmlkWGJ0RmZzSklXMVhBbmRGUFhVbkwxaW9x?=
 =?utf-8?B?NGlFNTNXT2w0VUJwd1ltTDFTODVLQWE0Zjd1MktWRWErbTNyYURVZ0RLWEJn?=
 =?utf-8?B?djlhdGpmTTdBMTVoVWhoN0d2SUVQRE9DV3ovdlJDRnI4Z0ZmR0NuTU9XUEdn?=
 =?utf-8?B?T0gvd21jR1J6ZVh3alcwY09IM0NxT1BnY2R5TWxyeVFlTUpESGRUcEllMkox?=
 =?utf-8?B?cVYxYzJ4a0o3SVY0OGVyK1FaUWcrWTZ4NzVVOXFRVkMvSlBwTG4yZytqazlN?=
 =?utf-8?B?Nlc3VnN4aGFabGtBa2IraTJmQjRqYmtHZEJDTHF5Lzc5eGpjMHBSZ2JWWjRI?=
 =?utf-8?B?d1dUNk5BMUdXdUFKendENlMvQ1VCcWlJQWUzWStxS0VyQ2hVRjcvRE5VTG9v?=
 =?utf-8?B?T0NvRzBaQldOaTRmd1BmSHNPQkwyWFpIeCtoanMrS3ZrSU01RlVQWC9MRlR5?=
 =?utf-8?B?ZjhpUU1FTVZrVGhnV0ZyT1pHb3JEekU5emdCNkJsSkFyWVZtQUxQOFFreUxE?=
 =?utf-8?B?LzZWRlhNaEFqNUhpTURLcUM0S0ttYWU2aU1jckJVUlpTeUQ2MU5VcXdYTk9R?=
 =?utf-8?B?bzBEUHFDRVByajhRa2FOcm9hZFU1N0FWM2hDUEhaYmVpUnYyWStVWXBKc3hy?=
 =?utf-8?B?RGVOcjhOS0pKbWpvMWNSOEJ3cmhPYXhSMlB1UzB3eUZXQmZraVFQU1RuR3dU?=
 =?utf-8?B?dXliakxGdDc4ZU5DQXovSTBvbE1qY1hPVmx5SCs0Y1ROVWdrZkwyQmNXbGpY?=
 =?utf-8?B?UWovc2tOSW5YNExYbzFJcVdaOFVhK3ZpSmVsd21PbVYveU9rcitsS0pkRGpF?=
 =?utf-8?B?Zks3ejJHSnBNZjRkWVJsZE9sbThtdm9sSGtTNUY0N3hBK0cxSW4zbzdBVUl5?=
 =?utf-8?B?TVdsb2RTazVzZlZWUlloYmV0TWwweDJkOGh2cmxVZmFhVGdVQ1Q3ZC9iOFZP?=
 =?utf-8?B?NTVPZ3p4a3BSNjlGczBPZUxsSzVPaWtaamJaV1pqRllDY0NmNGVCaU0xdElX?=
 =?utf-8?B?ejVlOG5YWVpMMWMwSkk5SENuN0FTRTBjY1VQcm1pUkdJM0VVVjRQTFd5NkZE?=
 =?utf-8?B?b1U3TXpNbHN4TzNnRnJjZkVXWHNTbDF2RENZN3YvWHZZb2JjQjB1d25WVXZ4?=
 =?utf-8?B?WnV3ZWdIR00xSVRUMGFFUDVoUndWV3htRnU5WElHaUgyK0E4YnpKZkNrL0Zw?=
 =?utf-8?B?MXZLZU5IbVl5dmtQN2JNUnlkR3E2ck5lVktEWW5wZHFFZXZGc1NCcmMvdGhC?=
 =?utf-8?B?eXRTSDMzTkx5OWhUNlRxRERrZjB2RDhZU0Z5am9HZ1NrQ0xYODFFTmNZT1hY?=
 =?utf-8?B?Y1FGTEZWdHB2aGlEZWRJT1RBbGIvQnA5THZWSzJoMXE1bzloeHpMN1lDaEp3?=
 =?utf-8?Q?eBwFLI+l+UaE8XP1EQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a687bcc-7431-4216-6a38-08dece5da279
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 23:51:08.7873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uam7fWpN2lL3+k4m5i8f97MXXlrcGwzcMsxc7eM40BO6ckOo3e5MI+6GGr4kY3CrO1DKX5jc0U3X0H+6++B/rQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8182


On 6/19/2026 6:20 PM, Borislav Petkov wrote:
> I'd let tglx maybe give a better idea but this cpu_hotplug_disable static var
> in kernel/cpu.c could get a getter function and be used instead of you
> reinventing the wheel in here.

I don't follow — I'm not reinventing anything here. Patch 3 will use the existing CPU-hotplug callback interface: cpuhp_setup_state()
with a down callback that returns -EBUSY to refuse the offline while SNP is active. That's the standard mechanism for conditionally
preventing a CPU offline, and it keeps no private "hotplug disabled" state of its own — so there's nothing here for a getter on
cpu_hotplug_disabled to replace.

I chose the cpuhp callback specifically over cpu_hotplug_disable_offlining(): the callback can be torn down with
cpuhp_remove_state() when SNP is fully shut down, which re-enables CPU offlining. cpu_hotplug_disable_offlining() sets
cpu_hotplug_offline_disabled, which is __ro_after_init and one-way — there's no interface to clear it, and adding one would mean
dropping the __ro_after_init marking and a new core "re-enable offlining" API. So that route can't re-enable offlining on SNP
shutdown without new core plumbing, whereas the cpuhp callback gives me that for free.

Happy to go whichever way you/tglx prefers — if there's a specific variable/getter you had in mind, please point me at it.

Thanks,
Ashish






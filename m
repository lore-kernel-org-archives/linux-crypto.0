Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8ED197543;
	Fri,  8 Nov 2024 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731086682; cv=fail; b=GOS48l9YB9TMVUCbXOXGtkxXg2QqW76xj1BMAslzEByNV9dV8B4EbeW/QxyblOHmglu5ID1fJAmldmpm/VO0ADB2xGtMFRsbZXg8gRVeh9BRZulk9dIayAcSyeOISRCUISr5TFx6oVKsW3wqP/qi7rcpPnFZNzw3k2dVegzl9P4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731086682; c=relaxed/simple;
	bh=2+q/D0RKGxdpzrvjTME1aZj6mni/7qQ1G1x6dalLkb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jh87qfUE/E/fjVIt+F4FtV7djqCAvuO5LvNLZItKSnPypJGTzcipgJbwAf2LbjAl7f0uaCo1jXaMrVgNcLoh0I3rklxc0BdXOzqlHwqDcvZ/4s9AG4OagPRVJaNv+uqzdRkFljp+uo64zzPx77PvEKc3ZN8EKmNX8AXbI+TzsWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QERpgLAL; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QERpgLAL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kTqY9u9CEoui5hz1d8qiZzlebEQ4gnGRJGScFXAgxIm/Dp100Isr+1Og9TmERgzstmFG8tGFEkL1joD2HedOPC2ZU60eJcbUnuB4D8ie59o+bETGdIB7SFD1lc+g/awaVygQ5nnUApFDx850iKYtsmHsTFW+FuKkHusrhbePOz4b+buWVizsIPDuhuENm4Lntqr5/ol3qxP5rVV0DFLy5NGrkUL0axSPubCUKVDrkqOYP1n+2To0XL22DDAteO3qVFVbjeYwmDLHeubUBCAZVubJjWEvrdufFTiPhnM/zcM8ZLhd7Ghql9n8hOez/KRt7BO1DlItb1/NebNRvcsqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6S3rQUj4M5EMt08SSfi5wADV6M2uSr2YXSBpbYSTZR4=;
 b=rVWNkE2TwXyTZvmRmM4kO13EMhKxFb4Z/nzECl47CuA4iiGirUj66VvR2Ms8XKzogsNifJPSxWSCOAQ8y39jiHxtOE4s4Rh5cHiUBrMNunYGuE6jRmi9GXxJB2g5j7FdxlOKBX08fP7gl4Aq6FbXnwHOq5frUf90GDCNBwhY6+EtbG88JfKvwa8vfnOSTIACuOJhzom/pZJ7Bp2hoqHF0xSsaA/bgnkIGswHwwsEZAm5evtGz4VdDnkYK3S4alnfE3zMP0q5Yu3DRBiw1PcU7IDBEgZsa0BZj1qhlJebPPLWiwtrfc6cem92oCmWFtI0ih/ZTjTx9b5OFpkPMT5ebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6S3rQUj4M5EMt08SSfi5wADV6M2uSr2YXSBpbYSTZR4=;
 b=QERpgLALQrOgsUfDXCrypF7ciPiTTEJG7M5Nv9oBeAXSwJB4M1IUhaZ1euKGPaKmnFFDe2gPejib6GZwatj6Ttu28QHpQzImcH54F/IOqnodN1HtRtnsZ2Djnm7Mz2GQgKmLptFVla5dKbM+ZC3ZbK2R6PZKIwsvkoLCXggbxMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7474.namprd12.prod.outlook.com (2603:10b6:a03:48d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 17:24:35 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 17:24:35 +0000
Message-ID: <71db9119-a667-96c1-7aaa-4f0241f203ea@amd.com>
Date: Fri, 8 Nov 2024 11:24:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID
 assignment
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-6-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241107232457.4059785-6-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:806:126::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7474:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3400d7-1597-4128-60f8-08dd001a3765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UzVENllvSG5CeW9VWHJiZWtvZHZIRlR1ZzBkMWFSQVpPV2IzcndRd1ZwbVBq?=
 =?utf-8?B?TWtQenhINnFZamlqTWEzcmJKaHd0dGlPVm5BOERJMTVTa0hEL21HWkQrRGpW?=
 =?utf-8?B?Ylp5aHcrcGtLTTAvaFJuWkhXL2lKNGN3UGszeHEyTE1LSGFvaTFzWCtBaEQx?=
 =?utf-8?B?ZlU3QzdvRmhoYkhWMm1RYXNha0dLSHVXRXUram9ON0EyU2ZMZCswM2ZlZFFq?=
 =?utf-8?B?SzFleENrYzdjdm8vMFhhS0pkTFlVbm5VRmtKVjFYQUFidjFSSG01OG85RXJE?=
 =?utf-8?B?WXlwN2o0cGJ2cUt3ZkR1WnFLS2Fkd0dvay9LTllhME5VZ25kR08yK256WXJF?=
 =?utf-8?B?bEFBSEF6WXIyaFp6Y2FuUERqRjFzU1ZMdXhIN3E0b3JmK0RaakJ5alAwKzV2?=
 =?utf-8?B?dUtSQzBSd01yanlQODczUjdvakdJemhRV0NuOElYTDJ3WnB6bnhnbkxTNWZm?=
 =?utf-8?B?bVVXZmxuajJJMDFYbHlRbFdLQ3FQM2VIUUV2UTRoTG1vaU9JK2w2V1d3R3Aw?=
 =?utf-8?B?YS9iVGFBQ1hoRlBNTVVUdnhYdklEYUh0clM5S0k3ckluNjh2YnM2aTR5WHJn?=
 =?utf-8?B?d1hyM2taaVZjckZRMXZVZGlNWkxVUUJKMFZIazdwdng4TzRYbjJ5Mzlrb0pk?=
 =?utf-8?B?eStTYjA2ZGs5MEYzTVU1dzRaNU9iYWx1aCt2anJkUStHOHAvdk9hd01sTVZ6?=
 =?utf-8?B?RmNQZlhLdUhzTzRBdmg4WGY5NHFDTHdxTGNGc1A4OTZZS1JQSEZXOGJBd0U5?=
 =?utf-8?B?TWxWcEszRkxrM2ozRzRSTTNDeE9JSDNTQ1hWdWJpQnQySHRGREt2TDRtc0Jz?=
 =?utf-8?B?K3NVQ1NyeDF1YjE1T3VEejdFVU15Yk5VM1Jvbm9OKzUyYnVXdnVybCtqdTBn?=
 =?utf-8?B?dVdMMllrT05IYzRPNU0wN3pVbURHZ0toTGhUeGhPbGVnc3paSm5VdldFNnl6?=
 =?utf-8?B?YytJdmFHZHN5MUxyNmwyeFJCU00yemNic2NXRGVScmlScXFteVRBMWVpcmpT?=
 =?utf-8?B?NVVaWmNPSlFwZmN6emp5dkxzQnpwSHgwMFBXbks3NW9nTVN2RXpwd095RU5B?=
 =?utf-8?B?cFpNbk94WFRsU1FON3JTZ0QyVS9CamxhWHBpUG1lc1Bwb00zU0swM0pyTW84?=
 =?utf-8?B?bXRTMXJrSVpwOFFIQkUzaVVZUnY0cjUxYzlZcGZWRzNpeWx4WHFiTDd5aWtv?=
 =?utf-8?B?TFN0SG8zNnU4STJtMzZ6WnB0Q3R4RmxQVFROK0VCL2VpcGhKTjZrWVZyK3lp?=
 =?utf-8?B?UVZJeWZndDZQVmEyMndFcmlzREU1N2psY2JEZ2dialptZDQ5THlNamExdDR2?=
 =?utf-8?B?V21pWk5vTFZ5RDYvL2hqTUtqRVZ2R1JKOVcvb0Z2WVlDWENRdjYrNWRnQ1RX?=
 =?utf-8?B?WXZDMjhNTGZIZkl6WDIwSEhETVpmU1laakV6WjI5OG95cFFxNmh2Q2NPdW5h?=
 =?utf-8?B?djB0NXh1bmk3akhHdk4wUUNvNm9qcFhFOVhVMVZMSHV4aUJHcm5oaCtPc0dP?=
 =?utf-8?B?ayt0eW5jOTNVQnl4aEZFS1d0V3FXV1pDbTFaZDIxeXJpd2dqOUlWb010ZXND?=
 =?utf-8?B?U0paYnQ5bTAzV2hMVTRqOUo4NzF3MXdKMHMzM0s4S1lHc0REa3lyUUpwOUpv?=
 =?utf-8?B?MEsvbmJMcXdLZ3gzSWppc1VoNFJhTXNYdERqZENIeWNPMFZoYkVQRmVxVlNP?=
 =?utf-8?B?K2tKSXlidjYwNXlESHc0cllybzNsOTVLYkxFSDlBck9MckRUbGR4YUozbkxF?=
 =?utf-8?Q?ta3P0u5GVUYatSY1AlcSkDTf2xkhaAMA8ppjVGt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTVCTU9CbFZJYlh5ZGM5OVRUOUFRZFJUT2pxemtOdmZhZ2xPbXhPSXN0aitV?=
 =?utf-8?B?enB5U3hBUTNzai9lNVhpaFVBTGJ1ZU04cUVUaFpIckhUVGNuTk9LNUgvVjNs?=
 =?utf-8?B?YnFsUERwbFhoZ3JtTHdZSk5nWmYvZDdQZGU3MVcxclFtNUthL0NSR0lURmVM?=
 =?utf-8?B?Um9BVmRWMUJ0MWpHYUVKRWFDQ3FpSjg5K0dFaTFrRko0Qy9FSTF1WTQ4Rkwv?=
 =?utf-8?B?S01TcnlQOEZ2SHNZNHpka3FnMVFJWm1FTWh4V3ZkZXNCdnRNR0Ric1p1bkJY?=
 =?utf-8?B?QmV3Z25MNlBxYWNJUlFYR0xDMSt4L2lPcFl4Rml4WGpOczU4Smx0THFwSzk1?=
 =?utf-8?B?VHBmK3M4TWErUU5tQkdwdHlTSjdka29pSkk1SVFVTE0vSHd0QSt2dlF2RnpV?=
 =?utf-8?B?QVFnM1FVVEZHbncxVW5PTitxOS9DMlA4UXBlaFdDSmFsQUl4dlJRUVlHb1U0?=
 =?utf-8?B?VzVpYWQzU0RUNFRiWDZ4TGcyODRqYnZUTm5ab29iZXJQMlRIN2lQUmZnbktv?=
 =?utf-8?B?d0dRK09NYlBRNkI0QW1DWU5SV1BpRmFqaU1LdUE0WU5lTTNjYiszazNQNEw4?=
 =?utf-8?B?WHdScS84dC9nVkZ6dnRCVHh3MTliNWFhc2oyakhicTM1ZUlrMGlhWmZvTzI2?=
 =?utf-8?B?a2lsQUFIUy9SY0EwTmxIUGJSejVzTGZ2K2Z3Tlplam9SOXdVZjZDa3NpV1Vl?=
 =?utf-8?B?RWtSN2h0Z3RnWWNMUkxxaEdpVXkrQjFESDVhMUQ0YSs5VHJmYUloaEJlTVEw?=
 =?utf-8?B?dFVJNmQzL2Nub096SVJIYWRPLzAvSEJFR1l4Z2duU3NqbUhHdlNER2w3MnYz?=
 =?utf-8?B?eDg4eU10T1hpOURyMnFkcnZ1U1dQSVkySG44czVjdWYyQUFZWWkvVFdMa2tr?=
 =?utf-8?B?U0tRUmRaei80M2ZaSm0ydm92YW5kZGlxOHgydzhqSFFQdWpiTFpER0xOQmJi?=
 =?utf-8?B?aXFBWCtuQWtGd0Z0NlVRTlpQcXBEcTlaZHpoc3g3SUprQXdURVQ3UENGKzR3?=
 =?utf-8?B?RERXa0xEZitDWUdORk9OaURNT2lHNUI1TjFBZDBNczFvOSt0M0pmWmFRR25V?=
 =?utf-8?B?WTFDaW9PNXU5NUZjU05DbFY3RnVSTzN4ODBUT1Yzc2tueVlLTjhOZmdtZnNO?=
 =?utf-8?B?RHFmeCs4bTZmc3VSVHd0aS91a1A1eUJxZmpKdVNwTnhkZjVlMSt6SVJERmM5?=
 =?utf-8?B?d3l5REZmRTJjRjdJMTczbGF0RGdnWkJZLzF0QTNlZWRDWHZFV21UaUdhUXNV?=
 =?utf-8?B?OUxaOXNYQ1VrZmR1aXZDQ2dGMjhtMzgvQkFYbDRXV2NoR1QwRTVvMkdnUjNh?=
 =?utf-8?B?dEJnT1QvUXJtc2tGMHFHaXhWTzA1S0ZnQ1pWZC9RTjhZd2hnQmtpazdSUjNP?=
 =?utf-8?B?dmE2UVdleTZrNVI5Ny8zaGxKTUxTTFo5NEpHMy9lVW9LbUF0S1FHaG5yVTdF?=
 =?utf-8?B?cHVRVnlMSmZ1VEVPMGNxc2NwaSswUkgxcUxkM3lXQUo1WFhaTXo5TmszWHlm?=
 =?utf-8?B?ZW1rdndFT1VHM1N0NlBWOUNvU3BPL3B0SHpwVzdMdm9UNXhWL05yMFhkSmg4?=
 =?utf-8?B?enJWUlR2Z1F5aU9jTzUybG4zVU1wTlpvYjF0QWVMSzE2eWxDYVg4bW5nTWNm?=
 =?utf-8?B?TWlOcW03U1FVWlpYQ24zK1hJUlBtajMzRmZGUmk3MUZod1BmWTVBazNEK1pP?=
 =?utf-8?B?Q2ExbCtDclhqK2RsN1N0OWVSbE9FNVlUZ3lueVVyVlNwendJVXgrWWZWTVlk?=
 =?utf-8?B?Z3pVeFpheldibkhJSG5YY0xjSzh6RmdkTHJnSUYzSndNTTFTM3JEY1FVNWtu?=
 =?utf-8?B?THBZaUYrMnZUamY1bGZxaStBK1dBNEJON0FvL0JxTE4rYllrNEhSQndXRXhk?=
 =?utf-8?B?WFNjRDVxSlV1TUhhUDRUOG45RFVuelBUNXpaTkZxczBhcXpKL21icFlUNVpq?=
 =?utf-8?B?Q0NIUFpIbmxpc3ZUOHJxL2tCd1h0WVp3cHhqNVFJdDV0Q3ZTNkZHRXZjRjE5?=
 =?utf-8?B?QlF6VEVFa2dPUmN5TnFjdkF0eEUxNW5rZUhiL1kvek1yS25YcUk2YVdueGJV?=
 =?utf-8?B?TG1XeFdFK2VrOEt3enlUS2R3NE1PMXhUekp6d2xEdmZtd1A1elZnTERNWHJ0?=
 =?utf-8?Q?SjXAO3nDhF2tzcNEozs/87R4j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3400d7-1597-4128-60f8-08dd001a3765
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 17:24:35.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PUN/PTP3qher18klZxuEZZW9fxzcP5ESNXSbZ9+EOGQGlikg3jNXsXxL3Aid0dWz7cJwaxTBWMaEIVAUd6ZbvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7474

On 11/7/24 17:24, Dionna Glaze wrote:
> In preparation for SEV firmware hotloading support, introduce a new way
> to create, activate, and decommission GCTX pages such that ccp is has

s/is has/has/

> all GCTX pages available to update as needed.
> 
> Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
> Live Update: before a firmware is committed, all active GCTX pages
> should be updated with SNP_GUEST_STATUS to ensure their data structure
> remains consistent for the new firmware version.
> There can only be CPUID 0x8000001f_EDX-1 many SEV-SNP asids in use at
> one time, so this map associates asid to gctx in order to track which
> addresses are active gctx pages that need updating. When an asid and
> gctx page are decommissioned, the page is removed from tracking for
> update-purposes.

You should be consistent with capitalization of gctx and also capitalize ASID.

> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 107 +++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   8 +++
>  include/linux/psp-sev.h      |  52 +++++++++++++++++
>  3 files changed, 167 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index af018afd9cd7f..036e8d5054fcc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,10 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
> +struct sev_asid_data *sev_asid_data;
> +u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1093,6 +1097,81 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +void *sev_snp_create_context(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_addr data = {};
> +	void *context;
> +	int rc;
> +
> +	if (!sev_asid_data)
> +		return ERR_PTR(-ENODEV);
> +
> +	/* Can't create a context for a used ASID. */
> +	if (sev_asid_data[asid].snp_context)

Should this be a WARN_ON_ONCE() check since we should really never
encounter this situation if things are programmed correctly, right?

Also, should the ASID value be vetted to ensure you don't go beyond the
end of the array?

> +		return ERR_PTR(-EBUSY);
> +
> +	/* Allocate memory for context page */
> +	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> +	if (!context)
> +		return ERR_PTR(-ENOMEM);
> +
> +	data.address = __psp_pa(context);
> +	rc = sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);

Since psp_ret could be NULL, maybe use a local int variable "error" that
can be supplied and then used below in the message unconditionally.

Then check check if psp_ret is non-NULL and assign "error" to it.

> +	if (rc) {
> +		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",

I know this is replicating what snp_context_create() does, but the SEV and
SNP specs specify error codes in hex, so we could simplify the lookup
process by outputting a hex value for fw_error here. Not completely
necessary, but would be nice.

> +			rc, *psp_ret);
> +		snp_free_firmware_page(context);
> +		return ERR_PTR(-EIO);
> +	}
> +
> +	sev_asid_data[asid].snp_context = context;
> +
> +	return context;
> +}
> +
> +int sev_snp_activate_asid(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_activate data = {0};
> +	void *context;
> +
> +	if (!sev_asid_data)
> +		return -ENODEV;
> +
> +	context = sev_asid_data[asid].snp_context;

Ditto on the ASID value vetting here.

> +	if (!context)

Ditto on the WARN_ON_ONCE since we should always have a context when this
is called.

> +		return -EINVAL;
> +
> +	data.gctx_paddr = __psp_pa(context);
> +	data.asid = asid;
> +	return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
> +}

But, I don't think that SEV_CMD_SNP_ACTIVATE needs to be here since it
doesn't change anything related to the sev_asid_data struct. KVM has the
guest context and can issue the commands similar to the other commands KVM
issues that use the guest context. So this function can be removed and
still performed in KVM.

> +
> +int sev_snp_guest_decommission(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_addr addr = {};
> +	struct sev_asid_data *data = &sev_asid_data[asid];

Should do ASID value checking before assigning.

> +	int ret;
> +
> +	if (!sev_asid_data)
> +		return -ENODEV;
> +
> +	/* If context is not created then do nothing */
> +	if (!data->snp_context)
> +		return 0;
> +
> +	/* Do the decommision, which will unbind the ASID from the SNP context */
> +	addr.address = __sme_pa(data->snp_context);
> +	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, NULL);

Ditto on the psp_ret thing here, too.

> +
> +	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))

And then this message can include the fw error for better debugging output.

> +		return ret;
> +
> +	snp_free_firmware_page(data->snp_context);
> +	data->snp_context = NULL;
> +
> +	return 0;
> +}
> +
>  static int __sev_snp_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1306,6 +1385,27 @@ static int __sev_platform_init_locked(int *error)
>  	return 0;
>  }
>  
> +static int __sev_asid_data_init(void)

No need for the double underscore at the start of the function name.

> +{
> +	u32 eax, ebx;
> +
> +	if (sev_asid_data)
> +		return 0;
> +
> +	cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
> +	if (!sev_max_asid)
> +		return -ENODEV;
> +
> +	nr_asids = sev_max_asid + 1;

Can we get rid of sev_max_asid and then just use nr_asids or sev_asids in
the cpuid() call and adjust by 1 after the above check.

> +	sev_es_max_asid = sev_min_asid - 1;
> +
> +	sev_asid_data = kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_KERNEL);

Is this using the full ASID range in case we want to track non-SNP related
contexts in the future?

> +	if (!sev_asid_data)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>  static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  {
>  	struct sev_device *sev;
> @@ -1319,6 +1419,10 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	rc = __sev_asid_data_init();
> +	if (rc)
> +		return rc;
> +
>  	/*
>  	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>  	 * so perform SEV-SNP initialization at probe time.
> @@ -2329,6 +2433,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  		snp_range_list = NULL;
>  	}
>  
> +	kfree(sev_asid_data);
> +	sev_asid_data = NULL;
> +
>  	__sev_snp_shutdown_locked(&error, panic);
>  }
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a3..7d0fdfdda30b6 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -65,4 +65,12 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +struct sev_asid_data {
> +	void *snp_context;
> +};
> +
> +/* Extern to be shared with firmware_upload API implementation if configured. */
> +extern struct sev_asid_data *sev_asid_data;
> +extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;

Move this to the patch that needs them made extern.

Thanks,
Tom

> +
>  #endif /* __SEV_DEV_H */
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea85850..ac36b5ddf717d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -942,6 +942,58 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>   */
>  int sev_do_cmd(int cmd, void *data, int *psp_ret);
>  
> +/**
> + * sev_snp_create_context - allocates an SNP context firmware page
> + *
> + * Associates the created context with the ASID that an activation
> + * call after SNP_LAUNCH_START will commit. The association is needed
> + * to track active guest context pages to refresh during firmware hotload.
> + *
> + * @asid:    The ASID allocated to the caller that will be used in a subsequent SNP_ACTIVATE.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * A pointer to the SNP context page, or an ERR_PTR of
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +void *sev_snp_create_context(int asid, int *psp_ret);
> +
> +/**
> + * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associated guest context page.
> + *
> + * @asid:    The ASID to activate.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * 0 if the SEV device successfully processed the command
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +int sev_snp_activate_asid(int asid, int *psp_ret);
> +
> +/**
> + * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's guest context page, and frees
> + * it.
> + *
> + * The caller must ensure mutual exclusion with any process that may deactivate ASIDs.
> + *
> + * @asid:    The ASID to activate.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * 0 if the SEV device successfully processed the command
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +int sev_snp_guest_decommission(int asid, int *psp_ret);
> +
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);

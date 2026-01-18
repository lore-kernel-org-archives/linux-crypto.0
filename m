Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F5C1E98EF;
	Sun, 18 Jan 2026 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768750263; cv=fail; b=o4RB0j9sNjrWRWY4hdGQVCF9+oKn1OBDMJC2uDLiGBb8MwwdxzTXwkM+o55fZsIqAlmuJvpaoH3DSv55S9ISTIetOvIwtwJuSMl75JIJxxcY6HKl26cST0QWs0R8dYOO3WxNw9nt8CFcudu0Fa7OeKYwIX1pTFJLEQ1JtIUVmHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768750263; c=relaxed/simple;
	bh=x14ICpLQTCgdfguijM8P3N8keJNzcaJuybT1SC/Q50Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=njcm+X/0svtWL+wHsgkHPeIos5zqPC4GxPr9/UdttLQaP8O+m3NEcVVbyxGQovIajoq3oXEIodvVo3Bq9h5xb684UfAxbqsJmM8MTDuFk0Nz8xSMTlhynWPyHf7KOSne2rvXBeqNs/i5W6FKtCMxJ+ngxaLxeEl/x1vcLwrA/5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X8lWOJwT; arc=fail smtp.client-ip=40.107.208.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X8lWOJwT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kE8Z65s5UkwsCvRChlOkwZahfgCjJ/9A33NrJToWjUyHAzCj3v8BAWRrigsJl0VCQRYTkM3iL21Y8UEKGc19GURCLOYLha+xCPjBJ/slszCWsHTMwLo+Z6M8xicqvfav9J5HJxJZk2wu1yzROHxq1pB2LDyAHrGAU6LuvPucsYfjl40C5nZjAGcJqZviML+lGVCHUJfgnRhNUpdt8QGm3m39QAz6eHxd70ppr5cIVXaf9cz/0Ffx/2PFCg8fEtuvav0pBnuE2B1cFD4HRyoA1M2BQD3GFKwV1hpNCSVYI9wjIqp8uR4h6o5I1q6He9rhtKnVf/y/I+GhCyl5MHQWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5nkYjDfPEVfFtN7p15XEx2iOR/tWyWf1Jh0nKEEGrQ=;
 b=VNnVf3juKBex6HVamI4+GkDhy9A5HJYcL2YmhXtGzbiz/wAMoH+UAyc8GB3wD2mUQcGpuRme8ux9I2Sucj1wRUIxfl5A6Z47R8iK5CEXBt7koYVv4uuAfIFHjqvnLvFmATwm07eQvCTKEq4J5i0054A35sRdBveFOKw8QJxO57Uq7B2NUm5McMN0Y/+xTAFKxCQYsNGma63JmoChie87KVvPXRHfBboKCNE/Wgtex6BxtgmRxIkukU7/QzHYfOiW2gUTcOSFYDMj2sKo2pvbWtSUAfA6Htn6jueRzNHy3ltd/U/mNwFmgRbaAcX3kf1nC49k3JJikyVL+KsPoI1ZIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5nkYjDfPEVfFtN7p15XEx2iOR/tWyWf1Jh0nKEEGrQ=;
 b=X8lWOJwTvgue8Y8U7Pd1TEqUlZOH8V8d8Xv+UVBtKr0y21CUjkYDbTp25aiaTmCy2lNzHCubSPHy5Z9vDJ7ydMGOARtTi64PmH3dtjorkqZ1lQMELs6Qhi2IIHkUw6c+XQUDTAoeszL95ZD8em/h4TO3ubbWRzlwKH+IsVlTBpA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Sun, 18 Jan 2026 15:30:59 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9520.009; Sun, 18 Jan 2026
 15:30:59 +0000
Message-ID: <e5932caa-0c84-4b18-af5d-3d5a36bf1f27@amd.com>
Date: Sun, 18 Jan 2026 21:00:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] crypto: ccp - Factor out ring destroy handling to
 a helper
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260116041132.153674-1-superm1@kernel.org>
 <20260116041132.153674-5-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260116041132.153674-5-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::34) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 47656c16-2676-4af3-a216-08de56a694d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEplSGxUeUxhMERRL3VhV0dwZ0NQTDVlRkZCRHVlRTR3UzBOaU0waXhEc3Zs?=
 =?utf-8?B?NlZWdUNrbVlGSUtQTlBzK0pZQnlYRzRlUS9NWmJlaVdqYnNkTXRoQUppUEJs?=
 =?utf-8?B?Ym1IdjltdnlxTXAveWh5ZzlBSTg0OHFhTUF0dmNIZHJYdTRwZkc2R25pbkJV?=
 =?utf-8?B?WWNoSkVnckhsSGdWTmF1b1gzQ3ljUmh3MmtOTG5TYWl3TTVTamJqOThJQTZG?=
 =?utf-8?B?WWlUKzYxTHJjeDR4MFJtTTFtRHdBaGFidGJmTDQ5UnBnaGYwU1BIQkw1QXhS?=
 =?utf-8?B?Nkx0R1Y4cy9yb0M0eG5aWXVzVmdOeGR4NFkxQTYxV3pUakhwU0dGeEV2UnVE?=
 =?utf-8?B?WUc3MTBSa3dOOGVlUTRUWCt1V0VPQ0Nyd0hFbkNlTFBISzVyd0tsNkcyVmNo?=
 =?utf-8?B?alFjbC9WWFZmaTZNdFQ1M1Q4elhka09SeXVaZXhEamRoM29HSUhGYnNHNWhw?=
 =?utf-8?B?V3ZQKzdZRDhBVnFpWWVwUmVXN1JpcUh5R21RVVl0aUdHa3RuOXFpM1Mwem84?=
 =?utf-8?B?bFZyOUFma01vL0Z5T3J6SGw4TGVQT1pzQXlyRkhxZE9KZDd6NGNjZ0xFbjJ3?=
 =?utf-8?B?REtVSitoNzQvNjJBdm9lNFA2Qmc0R0ZDek8yZWZicElkWlU2TXp6bWZ5UDRH?=
 =?utf-8?B?engrMStLWjZJUnBNZnRDbklzU1JOaE1IbkJkUmJaUXRreEVOR0ZDNE5ZYVNu?=
 =?utf-8?B?cHJPeWFRT2hwUXhTUkI0YnUzbGdEeHZ5Wm9ISWxadjZ3aDFqbkJmcTl3WURY?=
 =?utf-8?B?TytVTHMzSk5abmNlL0VwMzg2VlkrVUphSGFvM1FUN0tPYkVlNVowbm1vK1kr?=
 =?utf-8?B?MWFNNnpPSjV1akpXa0Zkay9WV2tUYUtycUFKTDRzRFdPMzFvbFZaakZia2cw?=
 =?utf-8?B?SXQ0OTBBS0JaN3F3QzFEWGVLenZuMzZPR2FrYW9ydVdKYnlzcldkakJjNnlH?=
 =?utf-8?B?Sml0ZnZRTHkrT2xFU2NTQ1duSm15bzcvT1kzRU5NYTQ2WnZ6SStmQWVuSWZv?=
 =?utf-8?B?SnpQZjU5d1Z0ZmVMelJIcHVPdmV5RWNuV0ZtTGlXRDZud2svRlA4cExoU2pD?=
 =?utf-8?B?ZVpXMUZmWkVVMUg0TDVyRENGZHBpWWczUzJRWEIrNzllcHFaQTcyTFpLZVQ0?=
 =?utf-8?B?RGdnNUVpT1NVQjV4Tit2MnZ4Z2g4aDhoakhaRFV3WlVTUDNmSWVDb1BQVmtv?=
 =?utf-8?B?QWc3QWtiOHVTL25Va2NOK2Y0MmhxaWE3NFZETDBLRFM5aXAwY1JJNy82VlQv?=
 =?utf-8?B?UldKckVZbTRBNlR1WGp5TjJkRndzTUovNWVRVFpCdmJZbnR0U0hNeVVoZWVw?=
 =?utf-8?B?NTVwTU8rbGJqYTJUZjZOenA0MitLUlFRc0xQbktrTG9KTlZsVkwrSXhiazZT?=
 =?utf-8?B?WU9zZmo1R3RldXZ2Rzgveit4Wis1YnlabGFXamRtVXVFZUZibUc5NDdBSjBK?=
 =?utf-8?B?YkthQzZxNEVPZnVEVmFESHVMbHdkTHdGYnZKV0VBYkhtaWxHdVlYODh6N1Ft?=
 =?utf-8?B?R3dIdzhSdlJaSlg0aEFmSkVYTmxubzEzaUptNjNoZDlwb0IvNUFRcFgyeEhE?=
 =?utf-8?B?MWFOT1B4MjhrcEZtanZmZXE4RFpTWEhpNVE4cUgwVVVQcnJCWTFzY1Q4ck12?=
 =?utf-8?B?RGRBSHdFeFNza0NwUGpROGJrUUkvaExlRWhXMEZUNUIxS3VwTTgxWHdMTXVT?=
 =?utf-8?B?NWFlUGt3Q0JHSUNIUTFZaGlndk01cUNkejJLejdOR0FKZ3h4RURjTS9kMk5R?=
 =?utf-8?B?bTJCMEo3ZHVCZG03SXBKTGs3Y0w4SFBLRXNnN0hYVXloK2d4YVZqTXQ3Z1lS?=
 =?utf-8?B?bFlpKzA2NUVUSUo3RzNJMC9PaFh5ajJiaTVFV1d6ZllWS3BER3gzMzAvMTVT?=
 =?utf-8?B?RmdsT0loVC9ZRkdRSmNwVmJLVktIME83R24rT0dUOTdBWmlvMW5NYW04anJ1?=
 =?utf-8?B?WGh6V09zbFVSOXQxVXRqU3BvTERFdkdSVFgwa0cvQUdNc2tzUmtkMHJvR2c2?=
 =?utf-8?B?Qml6cE5SWFdZek9jSmd3dWQ1dUpqU2taeUtreGMyUWVFcXFrL2gwdTFLQWJu?=
 =?utf-8?B?R0ZRN0piQUFqUnRzcTBQZkhIR24wY2VEVTVLS1RlWXA0UHhaWmRoNyt4R1Vk?=
 =?utf-8?Q?Gbh4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0wyTGVlUWxORzNLR2ZHRGJyU1BmbjNuUWFYdG5RMlBiUjFuZjFkZXJDNklS?=
 =?utf-8?B?NGVnRTIxRXFyUVU1UExnS0w5TklDWmRzWlpNcmRDVnRjS2tIOStkWktEbzIx?=
 =?utf-8?B?RXdlUmF2S2l4b2ZFZzhDRHlySHhtRTB1Zmx4aURGVGROdjRYeDU5TmJGejIr?=
 =?utf-8?B?a1p5b3AyczlYWHBlMGNnZEJwUVVPZzdSeURLZUoyS3JuM3RlTURVS0xnazdz?=
 =?utf-8?B?RHAvSC80TmV2UkJiQ0lGSElBajh0dGN3Y3luQXk3Sm1NOXJ6bWJqcnVxYkxM?=
 =?utf-8?B?dXh4blNJdTdEMFdPcVV6TXZqakROZDA5Y3dsSlhjUXRXZHVIMGtRVkxVREZ2?=
 =?utf-8?B?OFd0Z2NiR2RXb1NHaUVkcUowTVkvM2Z6bXljN0txL3ZRcmRmUHk5M0FXM3JQ?=
 =?utf-8?B?TWIxUmpmaFNtRVNwSm9DZlhiV0NJbTFFeE5mcmxvdkRsUnYvbCs0Z3VKc3BX?=
 =?utf-8?B?bUl5c09wVVE4Vm4rZEdvSm9QTVB3ZUpVRHQxLzFwU1F6ck80RUI4NzF0QUtu?=
 =?utf-8?B?MWEyVHlrbG54dXh0YUhhTnA1RW1FR1BFOVE0SHRVdEZpNW5EZW95MDIrRk54?=
 =?utf-8?B?UW9KUGdMR2hRVXZzbWx1MkprRTFibEtWeWg4WkR0V1EvSjdxQmJTc0luYmt4?=
 =?utf-8?B?TEh2V3JlWkUzbmRFV0ZmYTNLR2Q5NThnU1ZlTHZ4KzlCMWlkcytrZXNtRjdV?=
 =?utf-8?B?YUVadmt0STFhTEw3OFBxV296b05GdlgvaUE4RmJZbkdsamZhclAvaG9iK0xH?=
 =?utf-8?B?UE5OMmo0T0d6NVVOT01ZaERFZzBnTnEvOVpRaU83aW5WVEVmQnZ6eUVlSU5w?=
 =?utf-8?B?NGo5bkRvZkhLSnNyay9mNDhKa1B0YWp2bUk5Uk9MeEYveXJKVjYvdVB5NXJJ?=
 =?utf-8?B?cDFDdG81N3ZQcUNvM3BsenNSSnZoL0ZOeUVkN1gyYkVKcFh0TDJjQ2FTaXZm?=
 =?utf-8?B?TWlkZzJPWTNtMVl1RDhqVlpENnRWbnh4ZkhLb25WYzZSOCtPRXkvbXFCVkJR?=
 =?utf-8?B?WnRUVlRpLy85WXFPMnNtNGpxK3ZXcVFuRU1VTG9sTDFaa0hDZWMydHg2Ujdn?=
 =?utf-8?B?S29veWtncEptcy9wSnJkY0tjM3ZicHpjQnBBbVExU044cHJZeDh0emE5SWpU?=
 =?utf-8?B?eitrRzZqU285MHNXa2JpdXRzcVV4RHc1RTVuaHUrYyt3SjFxWjlxZmtTZzBU?=
 =?utf-8?B?b1hJSHZvdUpVOWdKRzU5RG5ocmg0OGE0eExYSVZNU3g2aVRlbzR4T0pOY05x?=
 =?utf-8?B?QWQwNlJzUy9SaEZLZ0pYdmpaTVBpdUxFYlBZWHA1QXJoMFRnM1hwYWlvTy9T?=
 =?utf-8?B?VzdObFhSWjV6Zlp5QzVPYkowYlFYOTQ4cElpcWxmVGJtci9sNXRITzZIMWxj?=
 =?utf-8?B?UW5HK3I2aHkvZGkxY1BnYlBmMTlKZWR0dEdrbWNkUVZrWnlIaVJrKzRKZnZJ?=
 =?utf-8?B?bzgrdXprYXU0anIyeFNWcWJKeC9ROHJkbUIzVTJDRCs3NjBPc05IY0pZeUlv?=
 =?utf-8?B?ZVlVdGdPZk5MMDFVRldabHczMzVEZ1pRcHBPOUtZUUJyaUZoN3RiUkczeW5q?=
 =?utf-8?B?eWV1ZFVEWVdES3dIenMyUzZzYXBQdEhOcUJZdDBmeVNOSEZ1eWN4SXJmY3lv?=
 =?utf-8?B?TGJsQ0dhZzU2bDZ0Zk1WN3d5ejh0WWdSS2FKbHE5WU9qOEpTNU5aQnMzTjJV?=
 =?utf-8?B?NmlvVFVOSUdoaWFtRFNnYWVrTllwUkczaG1EYjU1VUtXN0JaeVJ3MTdFVklS?=
 =?utf-8?B?ZzIrWUpRSTh1aTVtVlh6T2N1NjdkcFFRcHVMV1k3T0UzMG8zNmN1L3lETUY1?=
 =?utf-8?B?MDE4OTFiV2ZqSGlqVE9BRzFma2ZwZ0cxZXNlR25tMHRBOGJqbEFIaitZZ1Z2?=
 =?utf-8?B?ZUUzd2FtN25EdjRDMGdjSmQ3Znk1dFFhSzY4VkpwQVJhdTgrMlgrWFdqeHJF?=
 =?utf-8?B?dE5QZWVDVmI2NUNsL3ZQZGpIZTZqNEJJYndKMkdWMzJGVndjZ0IvZFRTSGZE?=
 =?utf-8?B?VmpsSWovaHRrVzNMUlBqRDNjYTFTYWJSMEhWWndvVW1BQTFTTk5zejhKbzlx?=
 =?utf-8?B?eEx4YUlBQU02enp0Q0FKU2xGVm5pRm9KL2dpa3RZQ1l1aEpJbDFkZjlkRmpV?=
 =?utf-8?B?ZER3bGF5R1BDeHdvemtEVzhlK2lLU0hGMDM3ZG8reWxYVW9OY09zMWJjdTZC?=
 =?utf-8?B?bUNzeml2dzFoeWwyeFNRNVBoSXduSE9RV083ckxyYkZhVmZadEhpVHkrQzdw?=
 =?utf-8?B?NFpXMnhpQklnZWNuTndQcEVqUUFFVTM5YXBEQURJTG16QmVMU3FpNERBMjE4?=
 =?utf-8?B?RzY0ckZIWjIzQUdmb0xCUEt3YTdDRHROZnl0SUlMT1JoL1Zhcmp2dz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47656c16-2676-4af3-a216-08de56a694d4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 15:30:59.5963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inAtcGLyAu9MUXPbCh+4gdRYuhPPGtCYTbAA1DwydH/YfxR6y276uZ6RzLy44u0DoEpIRfal7RMpsdwhg2By8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964



On 1/16/2026 09:41, Mario Limonciello (AMD) wrote:
> The ring destroy command needs to be used in multiple places. Split
> out the code to a helper.
> 
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Thanks,
Shyam

> ---
>  drivers/crypto/ccp/tee-dev.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index 11c4b05e2f3a2..ef1430f86ad62 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -86,6 +86,29 @@ static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
>  	kfree(cmd);
>  }
>  
> +static bool tee_send_destroy_cmd(struct psp_tee_device *tee)
> +{
> +	unsigned int reg;
> +	int ret;
> +
> +	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> +				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
> +	if (ret) {
> +		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
> +		psp_dead = true;
> +		return false;
> +	}
> +
> +	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
> +			FIELD_GET(PSP_CMDRESP_STS, reg));
> +		psp_dead = true;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
> @@ -137,24 +160,13 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  
>  static void tee_destroy_ring(struct psp_tee_device *tee)
>  {
> -	unsigned int reg;
> -	int ret;
> -
>  	if (!tee->rb_mgr.ring_start)
>  		return;
>  
>  	if (psp_dead)
>  		goto free_ring;
>  
> -	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_DESTROY, NULL,
> -				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
> -	if (ret) {
> -		dev_err(tee->dev, "tee: ring destroy command timed out, disabling TEE support\n");
> -		psp_dead = true;
> -	} else if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> -		dev_err(tee->dev, "tee: ring destroy command failed (%#010lx)\n",
> -			FIELD_GET(PSP_CMDRESP_STS, reg));
> -	}
> +	tee_send_destroy_cmd(tee);
>  
>  free_ring:
>  	tee_free_ring(tee);


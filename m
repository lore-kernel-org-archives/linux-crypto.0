Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7273E1CFF;
	Mon,  1 Jun 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780336999; cv=fail; b=rNuwM4nwksQzpcP9ju6C5WJeXvss4QYVNautvBpGC6Q0CEWpxh1MmY5hnyF1xjgV+lW2JYz23kYGYlFsv+4SGPWXoD1DbGuoNpZyEYvtuXesJYSXh7m6I2CKEgOELLjuqsk9x4EmDFmEzY2T2o/hT4//EQ0KUHfwYmaheSQyAl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780336999; c=relaxed/simple;
	bh=+bnjMvM1WM3z1Kh/AwPKVh32w/l0vtqgzn4Bwa4shnE=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eXqcjGOGnWyz4vMynpe9AMwnLc+Yyzc5BCeeNTizIoekBPMoIOKiDj0rruY/zLOboNpyvMv9EsabtshJk9u4+NTts9t0gHX7JNZK95lP77HHvtli7V1XjAxS96DWWT9+eT+NW0TXaZUTniKvpq2nQxbm+n48E9dR+EVtXMxmWec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GFts2m17; arc=fail smtp.client-ip=40.93.198.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GFts2m17"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jlmTMNNe8eEDUHMs11bts5fxxXReA+4UL8dt0TYFuLEQByDGqoUA8lyq0hTyaPcQXxptLtU6FkjFE4bCuO/icr2ni18Oxq8IlJpBsAaF9cd8DBTb2VSjsdney4/25g0UMX6fpXN0gMbpblS8vF9DrIVOEBsirvNEqSTXmpVLBGYXZVi5nANZ5e+UMzWjr/cWG+kj/X2Zdh9fWuUAJ95k+22jI50H6NInL+isE65obHT4gOxfCIBdm+cbbG7SsHyvoma6xL5IjIJppvHpmFWtCiVFODHu/dqxNSaTuCG66qyA67pq5Ib5fHkgBsBd/W6xR1CiYwV/NGVfaMQCpKxuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xn36oogcTKrYeiVIdnmc/zehzbtdM03wJij0Rym00cQ=;
 b=nOIsJXY2+iG8baUICTqnOM6rnDCIVwycbwBKWkPd5a7nhnT79MNkIc9dghocL5ok43+0qMLM5JIScNrnkYn2+IcsqvErKJkEbOzwIsebnHVGblRLafXQSFT9i64zVRBvSA2lJiVEAo4fIixsQqh+qXSK9vNo/0290zgdzryieVUgjPXq/io0ZI21OuxOXPfQPx28zagjDsl0IOtZRyDkmR+AR3r/O+yyBgG4E5GCDUfJCe4MUtXsz4w6I8O7z1b/q3WcTlp8iJftHGiBQc7xETCXJst2zMvVN0wpKvDK5fZ+WOcMGsLUzRsoRDeOEarmJBuhIssyBJ8EGTcqxcqjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn36oogcTKrYeiVIdnmc/zehzbtdM03wJij0Rym00cQ=;
 b=GFts2m17WQ7yarGy6F3/TitbusJOsDAM14J4B45n0o6hgnFpIv2ESymXCwlShekwaqiM4wxC2/JpL93t4KsPVsfAXgu9N7YWS6u7ipDfM3fJcdK52KejUqUJtPtrpjJZ0PPg9/7iZYk0JpQNK4IMyfxi3aaS4Qc/YxQgC3OBeaw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 18:03:14 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 18:03:14 +0000
Message-ID: <af2d0e4a-b721-4273-9a2e-328d61421900@amd.com>
Date: Mon, 1 Jun 2026 13:03:10 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] x86/sev: Add support to perform RMP optimizations
 asynchronously
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
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
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <6f1ec3d8ebcf3aaceccc099c07d0deb545dd4ab9.1779133590.git.ashish.kalra@amd.com>
 <CAEvNRgGfyb7zvZ1u1j7YLomD+JdAxnVW36gtvNG9gxgZ80vMyQ@mail.gmail.com>
 <8b7f6c93-ad5a-45e1-aa70-945518d29ddc@amd.com>
Content-Language: en-US
In-Reply-To: <8b7f6c93-ad5a-45e1-aa70-945518d29ddc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:610:4f::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b148a83-8f98-4138-107d-08dec0080ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	dKv5dUAFA68BXHT2n8DrFcb8AMvwIyqjvVKfsTkDdpWAHF5MSj6Xdcr+BEmfTdCtD6Gk69QexmkkVDZDYbrMMEQrmdQl+5KYJhYQdwOj/eizwmhIWlZaIu4TlBwskZC4ppAn/9xNZo4pYDa/YeInmN9uY5YnVtU+MjEs2IiBKU6xhiy+/TY/8sWfBkNEjmCy74aEJvkoPM4johRD7rYHEv+Rd5bXClGxtR53HPWkg/wKZuAeLGFaO5+BGfDDu41EpxxGbTS+GphpQGX5rcDIXe3SiFd8Aefs807+Ba0oHrDDD7IODZIj6UQzOcE1sHf6QRpIog9vLfWqcpwzY4BdkResGKatJumyw8RVNUu94LLFCMJQwRYTRQDO7MPtNNZ7B8ZvmjJ+PZF9ZzEprNfqeWQQYETTvKXeWfzst60rbfv6LOZhFsd04DB7Mxl4Psx6knWeG2VEiTQVgSI/s4QmuPf2ZZIDB3KvSgRrXjKhq/3TzvggVIumR41e8YmdXTGC0iuoZm78Bcn1Co6XYyQR7N5XBUZkbpoWI+8XMG9ufF2OmiB5eLhZXOLosL2mvrsJ/yCMEW9qkxSpsUoZTHBMko6JOyFSpQu0TPLb9dX3+pd7qPfUQXY1speobpvXZRDLNgJIl83kax+bjoYa8NMsZgSRgl9w6B2YNWYgUTzhNdQXfN93EhS+vCS5HmN6k/W6JTiVVB62Cg2KaSCL7TG9KPdUzH3ZWFtCtrtt+z3B5T8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUw4NnNSbGRDQUwrR2JJb0JEMzFhSUppN3NvSjB4NzJnckpSTUVPOGZ5a3lL?=
 =?utf-8?B?R3h0R3dsMTV0RVE0c2pVV1lCRkhwNi9lckozdERoZlZTNDFXK3Z5MzYzK2Mx?=
 =?utf-8?B?cjJwUVRwRGdlWm92Vk1FdDdqSTdYcTRBNi94RUNZdVZERWxJTVFzc3h2RDJU?=
 =?utf-8?B?QTFFaDU2SHY2MmJrMnphRU9wSHM0dmJHbHBNSGdvS1VTdEFRM2xPNEhoTkVp?=
 =?utf-8?B?UEh2VUFORG5uVWk2Q3BsYVZJUVBLWkZIajEzOFJ1bzZqN2V2UC9xM0ZQZGxj?=
 =?utf-8?B?TzRwUk10cmtUMk45aVMzMWkyTFVJTWRMOEhKZ053YmVLMjdUOEFUNklZUkdH?=
 =?utf-8?B?WVV3YWR3cWJCZjVmbk5BZnM1cGtZVGg1V1pUQXI3Z2I1Vlh0QUV5MHErSlRp?=
 =?utf-8?B?c2tETmxRcWNMYm5WMDZCSXc3c3d6ZVNNU0hXdTMzOVJ1RXU5YXhMM3EwWjB5?=
 =?utf-8?B?bTlGaWVoTGwrTXdhSmZ5cEF4NWlpdzk2ODBkb3ZtdmtlRGc3MjM0QXF6VHZ6?=
 =?utf-8?B?OHAzRW5RaldqNVFlSFZ2TE9GNktvRXU2T2Y2WDBwMm5vYzRESXhvamVGYTJB?=
 =?utf-8?B?VVdjZ2kza0t2cXp2Si8zN1RxUzlUSFpFaUJVVUMwTnJoUk9oVy94d0RXMDJY?=
 =?utf-8?B?UUp3bGFyeUU1Q1hVWEFQYXBGNG1RUzlKRFo4QnloZXF2TTNXSzV2VEhQbVNh?=
 =?utf-8?B?d0RDTVdnTndOa1BxOEFhOFoxenFZM2d0SHpaeURJM3F2WVI3M1lXOFZkdlRO?=
 =?utf-8?B?dGI3N2djYndmYS9sM0hDZnZjZ25nYThPVnRqS2J0Y2JKVCtDOXNPYXZ3Wnh4?=
 =?utf-8?B?TVNDaGNUVElMVEdHd0tZS2R3T25SRm14aENhcGdDOW5FVXNIbzhCeitWalUy?=
 =?utf-8?B?ZWx6b3p4WEx4UHVBd0Z6NGp5VytJMXBRY1Fub1o4TzR5WHk0b1d3SmRLbEs4?=
 =?utf-8?B?RDUrWXZHVDNaQk5OTW03Tk05Nk0rRGhhM2lEZzY0MURVbGRlNTVXVVBjSmNE?=
 =?utf-8?B?VTFvcmZBNWd3MU5hUUlZNWZMMWdVNFNSbklXRG5iZkxDM214aDN5dWJ6ZHNt?=
 =?utf-8?B?aTFEcGprNVFXZWUzUW0zZ2pPdU93cS83NzBwaDlmdG5oVXNJOW16T2p0WXRD?=
 =?utf-8?B?VDVyMklNTTR5Q2Z3a051cTV4cUxGbXVjU3JIcXJaU3grVURtTy9yNDA2RkZW?=
 =?utf-8?B?L0FpZUxxQTVUMmsvYW5Ud2ZWTC9IZDlud3FQdFBxSGx2MmtYSkJBT0NIK2NT?=
 =?utf-8?B?cno0akZZYlpKUlk0Z1lwUVpPczh0TmlPdS9kS09tTFJwYlA3ZWNwSTJiU25S?=
 =?utf-8?B?TGErRm4xSnZHWVRYNFdkN00wcEFtenNhL29DVUcxYkVjcVlTMDVEU2ZFbGJm?=
 =?utf-8?B?MWdvUUM4QXlwU2tpVndKVzlTekZzS1FveXJ2dWNqaDZ2MU9ZNk8rbEhLYUVU?=
 =?utf-8?B?SlhjZldDeWpjZW12VjRERlFrSjVsTnUrTVlacTI2ZGhjODRYeG9iQTlIRy9J?=
 =?utf-8?B?Wlh4RkEzZGdUbTNpVVJDUHJsWlU3UXlPZDlOZTNPRzdUc3VFdVZ0NmtQWnNB?=
 =?utf-8?B?ajFrSnExTm1YeXRQL3ppK0lRYnA5d3N6Z1M4QWJocDBLYituUlFTRTVuNHM1?=
 =?utf-8?B?WkpKRm1GNTdUcDZWaE43czAyYzFtd3lkQzFkbTJxRGpuZFE2SzNrelFlMGpa?=
 =?utf-8?B?MU5IaDFJRW83bWdzc2U5dVZydk4xcDdKcUJOais2Ky9lSkJ2ajlsWERwNlJ5?=
 =?utf-8?B?SFpUMEJRQXA5Unl3OUZDdlBtRXdqNU8vcVR0WXZhZnZLMm5Nb25QREh5Mkht?=
 =?utf-8?B?U3FEYXl1WFQ2THU5MHZtQzZsMElobks2NFA2UVBhZEROY1FiN3AycXUySHov?=
 =?utf-8?B?czA5c20zQVl4bjVIdFhZcnhBL1h2QVVoS0JFQUJ0Y3dEZGZ3akV0YnVTblly?=
 =?utf-8?B?VjBrWWFzZHV1WGRocXE4UnZWTlFoMG1TeUN3TElYV2JuOFRoVi9LbHE0YkRr?=
 =?utf-8?B?UTBQU240cnc0UThwUmh0a2VyRlFLNmtic1JpZnZYeFFEbVgyTFhBMTQxZWpB?=
 =?utf-8?B?S0ZmZkZlMmFCUnN0cFpWSGN5OXFiUzk0aW9pWHRxMVY0OGFoOWp4bmw1ZWht?=
 =?utf-8?B?dk1IZHF5aUZOVzlDdmtUT082VzBjVTUzbkhtU25idkxCcjBsN2xLUGFWMkkr?=
 =?utf-8?B?VTMxTG1rUk82aHVRS3VPMTR0VDhValFyRGY2eUUyM1VPVklRM2FoTE9DSklw?=
 =?utf-8?B?WFl5OG45TEdhL2RacncvRENYRUdoSUUrWFVBcm1ET1hDZnloalFRdEViS09w?=
 =?utf-8?Q?FxuaLvFjWO3puU1iyz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b148a83-8f98-4138-107d-08dec0080ce3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 18:03:14.4290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCOYaF2NnaoP1/22vNy487M3y3aSV06JxtEceaCVHTqyinDg2+x/AOFIuNdY1+AOQtPlaoWmu4PF5giF65QyNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308


On 5/28/2026 6:52 PM, Kalra, Ashish wrote:
> Hello Ackerley,

>>> +	/*
>>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>>> +	 * reserved processor memory. The RMP scan is the most expensive
>>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>>> +	 * if they can see a cached result in the reserved processor memory.
>>> +	 *
>>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>>> +	 * on every other primary thread. This potentially allows the
>>
>> I like the leader and follower comments below, thanks! With this
>> leader/follower setup, will the followers definitely see the cached scan
>> results, or might the followers still potentially not benefit from the
>> caching? If it's still only "potentially", why?
> 
> I am verifying with the H/W architects if this is always going to be true or not,
> will the followers always benefit from the scan results cached by the leader (first CPU)
> or there is a possibility that the followers cannot see/access/get the cached results
> and instead do full RMP scanning ?
> 

Following up on this, i have checked with the H/W architects, and the feedback is that
the: followers are "designed to" skip the scan if they see a cached result.

Thanks,
Ashish

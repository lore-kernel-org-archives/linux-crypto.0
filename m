Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010052.outbound.protection.outlook.com [52.101.61.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B547D308F28;
	Mon, 12 Jan 2026 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768255601; cv=fail; b=V6O9l0cKG/jcWkTfGtGrFij3LQs8ydceo1FjrmGvzvONisxXQkYv1ERibugK5PadOXDoOah9J7mC7IQ+6q+d1+CLR9qYuQ66ABpNjaek5RzfYVsgmeb6PtCW/SguIXehbc9o08mN9WyyQMWHqpQCkG55RbgOJ2e7cFIwIdFlTXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768255601; c=relaxed/simple;
	bh=AuHYFPeHLTVVqfM9ajcwe86VMiR9mpffWQScM2CCqcM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YBWCdPd6Pbivh3e5IbY4nu+Qm56URV+Pppr/ceJlZ/BmDazr2dIgMBlKPvmMh/ddYFqt+2ao2N5enCOfX7m2z72IBfnI1U1Aia/wzBKaUkvwwR0P83VDOjw7+xtxbrsvWKUoIswe+brpb2o1Paf9gcRkBj7j6nQelk7DEtnSXNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tcCB/n94; arc=fail smtp.client-ip=52.101.61.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tcCB/n94"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I04TryNYFhB9K7u71Gzjrp1OhGfGjdpAhLFZpz7YnfYQzSGEQ5WSr5dwN/Ifch68Bay1otkpuHT+XPl/+8mtfIUc9AXaKIjFaIBS7FWK0BaT6H+KRRZa+xxYI78lf4K/lWhf6RNc6YEGGBVjt4ZKisVc1RJXq/aS/IgyKucnAGXrrau14jYNPiQSkMHCG4ySmERog9SSF9ll9ESRSNaq+LHsRamQ32eFqaTzlv93oJbgrgiY0bG3hLIV7xOIdKrZsGcyFd8dM/Yn7971Js99a5kAOdIK9k/yAqpXMR5baLvTmAJtmU5eJBk0iudHHxVXuj04wkyTaiMs9gChhgy55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MH8q/TglO7aG+1NbgUVhq9cHjzmbGtjnN8LX7nCwsmY=;
 b=M3s3NfvHpx8kik4986HkH2ujO9ppzvJwhZD87rcRFqZeLORpFkFP9VU8a9GApG19RyIKLwEEB19MhNMHdYPpUBUoJq3qThnLass7oF0Z9OEZqoVQMQ6eynhwfK9dVcCL24VMqMa9BYQTne1FEMaXZFZBgNkK/fPMVORsbO8sNxZALESkOKTzkG3pA0hXAYZRwKU0iWMeynz8BN9ZHONLpK25QC/8eq6uOjpc+6UXDZwX7dZUQ+QsDjPGV1W9SnaPxcuFzfzzdeLYGuS34LmpU9naAe+LXDNdr3PAq+XaKuH4zrioL+Mmjfr9nvx0sdIlGws2jTMm3kn4BTzu7K3nnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MH8q/TglO7aG+1NbgUVhq9cHjzmbGtjnN8LX7nCwsmY=;
 b=tcCB/n94+mBtUxo83skEXzc+Uxccvlfcp4FQCww3UJR72A6W+xnOcJJFculsvAdCTYFiVrM6Y8xbbXsWVwbkixPOK4oEElvNGsVp3Tb6lLfhmMMVlr0M9o9jVbR0GNfZkhOWc01Nz28D8bdlLCS4MNSAMURQCYrOwPQ8cEJ52oQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV8PR12MB9336.namprd12.prod.outlook.com (2603:10b6:408:208::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Mon, 12 Jan
 2026 22:06:37 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 22:06:37 +0000
Message-ID: <4505efb0-d44c-4fe8-b10a-cf4c6f9b17a4@amd.com>
Date: Mon, 12 Jan 2026 16:06:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] crypto: ccp - Add an S4 restore flow
To: Mario Limonciello <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>,
 Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
References: <20260112053610.2566943-1-superm1@kernel.org>
 <20260112053610.2566943-4-superm1@kernel.org>
 <69f9b4eb-02a7-4a8f-8e77-903dee9e2de5@amd.com>
 <20acfb14-02a0-4f7a-9924-fa70fb485418@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20acfb14-02a0-4f7a-9924-fa70fb485418@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::11) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV8PR12MB9336:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bcde43e-0e7c-4388-91ca-08de5226dad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qm5vcVJhckh2TTI2QlRROWZMUXR2Y3AzOEpvbG8zUzVGTUhYQnpTOUJDL1F3?=
 =?utf-8?B?dEFoYk5JODVHcXRHNDdDd0RIWHFZSGJuOGFRRkpNUnp0Um9KdEhWVmZLYksy?=
 =?utf-8?B?Y3E0YTd6cElVUmtCN1ViZVBEV1hYMFZMWVZpMFBEOVdBRTlxcjlwMmQwTEdD?=
 =?utf-8?B?QU1CazYvbUFEcDIxc2lTT3VCaUhKdzlkRjd5RlNMblpIVlFPbGxxYy8zUDVU?=
 =?utf-8?B?bXZGNFhWWDNJTVcyZkFlU0JQNlh6cE04bDB0L2ZDRWEzTkV3WFgvVFlSTzZv?=
 =?utf-8?B?aXpCRmZyQ3lpWElyQnNMMFpKV1RzL2Ywc21aMHdtaktXellsbi9jeUwzUFN3?=
 =?utf-8?B?cm9STW1Uczd6azFEK09qM1pMalpyblVNUXlUcml2ajlud2c4THQ0QTJtdC94?=
 =?utf-8?B?T3RIRm04NGpmRWtqNGVjb2NFdVpobjhYcFJhZTVuTEdidWRVVXYvemFlam42?=
 =?utf-8?B?YVNIZVlsdUNJSEdqU3RxdklIcjQyOUsxblYxQ3VveDdGeThicUdRU21jcjds?=
 =?utf-8?B?S3BOM2JVWklKSkkvcnAxMjFyRHdpQTdUUDdFQVFKZ2Y1Mjkwa0F3SDJUa01w?=
 =?utf-8?B?MEdIU1dvZnRmNVJaM293cmU5UHJoTGk0dXRuYzlXcU1zM0VkSk1ieHJwVkRC?=
 =?utf-8?B?Ry9EZ3lQaHM5YVh3YW9xOGpXQVArU3IxOXR4UDZvakkxZGZxTkNTMkJqczdj?=
 =?utf-8?B?azY2cXVEdDMxZWlUUUpBbnN1M2FjQ2pVNkRGSE9YTUl6ZDVON1dlK3hSRmZM?=
 =?utf-8?B?MTBjMUZsNmNYaWxVU3dDNnVpampKaG13aHQ3K2FlZGdENzZkcW9XRzYzdTdk?=
 =?utf-8?B?SlJ3ay9YOEtYSHQ1T2xhaCtKTit3RzRGRlVjaFhIWUkxYWdjdm5SUW1rYk5K?=
 =?utf-8?B?RjlmbDBmNzlUTDZyWlRyZ3hQeFJ5eTlFOUFROEZQTjB5UG9jbmk3bWlOeGlM?=
 =?utf-8?B?bFZGSFJnNUhqZG5LRUN3V04yVmpKOWZ3M1hKNzF5SWVaM2xGTnJ6N0NMMDJU?=
 =?utf-8?B?RkRQaUtuVW9kRjVERzZmcjA2dVEweGhJL2gzaC9xU3o4TEFJdWptOWJjT1la?=
 =?utf-8?B?UUYvMlQ1NzQvSzg0NlZYa1pwUlFvR2Vvc2ViL1BjME1UZytrcStTOHNXd3ZK?=
 =?utf-8?B?Y3R0Kyt5WlREeGVjMm5LOW5jaXQzYWdWWnNWeHo1WXdCSmJpZ2dLQzJrQk14?=
 =?utf-8?B?NmM4QkZNd2NVV1ZML1FBbXFVaDhyVjE2V2NLK0FCRHhscnd6V3puVmtkZSt2?=
 =?utf-8?B?RFB3N1RMM2FvVVZSK3hwalJlYjh1SXRRdllIKzFsTmNFUElWbm4yeFh6Rysr?=
 =?utf-8?B?SGpqdU9UcUhZa2FRRVQ4QS84T29JczZkUm00cWhSR1VlM0NFSE1UYmpIS29S?=
 =?utf-8?B?VWhIS1hEbGcraEVVa3JEQjZMRGRhWDh0a1hUZVpkLzh3K25KSC9ic3ppdVJ2?=
 =?utf-8?B?NEhud05zem8xNXhSaU1VaThGNnJCc0pwSDFWSzFMZ0o1YkFLRFpPdmVEVVZ2?=
 =?utf-8?B?MDBzVzRNa3U5c3pxdGx5TUxEQ2ZHV2I0SUNXWVkvY3pxY1JFYXpFR1pqTjla?=
 =?utf-8?B?QXQwQXBpaC9vQlY3dklSMURuRG5iZWtWa25MbXNkcmZmcWJvaDdrdGNlYkU4?=
 =?utf-8?B?RVdacUNYcjdPZ0tmdmErL0hnT1k2WWh0bWYrWVZheWZhT3RQQjFhM3ROSHd3?=
 =?utf-8?B?SDcxTEZwaXNIYm85R2wyajlHcCtxZmticWRmSjdueExkcXowZ2d3dnNBQVM0?=
 =?utf-8?B?RUxYU0tJRmtZdGxqbGY0NStaRHMzNFZRc2twSXdOUjNid3I5RjE1VXNiNTlZ?=
 =?utf-8?B?U0xyTXgxajZNLzRoZDlBRC9ReHJINDloN2lBOWMzaHRTeFhwajhnZEFOYjl6?=
 =?utf-8?B?YzBPOHVJSFRpbU5scUdkeWw2aGI0Y2krNXNtZHFzTi9hVHppSWJvcGRzbzBi?=
 =?utf-8?B?VWI4dFZGV0pwQzY0K2llN0NMeGJ3RUtsRGluWWIrMUV1SjlUTEdMclVBd2Fw?=
 =?utf-8?B?dGtXSG5sMnlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R01vRkRYR25ZQzFJMzJHdk1BNnhzWUlSaWR6N3VoWWpYcjRpWWNvdFQrRnlq?=
 =?utf-8?B?czkzdVFhZktQbGwwY3NDZFlVZEtLYjJBSkI4K1dudmhaM055ZmlsNEtQVGQ5?=
 =?utf-8?B?WFgycFczNFFSQ2lBcHhudTdLSmRTUG4zSHlQTWJkdnU1MDAvRjVNSXJlU2pa?=
 =?utf-8?B?RjJxMFNFc2lzaW9HZEkzclFJTWdXVzFaK0VRVitUR3RQTzlrOWV2TVEzZCt0?=
 =?utf-8?B?aU5PZUJILzJqWlFwek1FUCt3TE9rbitLaHJITUp5cWxnVlMyaHIvV0lpVFBB?=
 =?utf-8?B?RnZxc0tQOXlIeDdGdnB3RjU5bGh4cGwwMXhNZzIydWlSdE9nNytLV0pOcENO?=
 =?utf-8?B?WGp3MnFYNDhPT3BXWHcwSUZrbFpkWktNeVdTeE1ieHdVdVVNN0VCZFo3aEhv?=
 =?utf-8?B?UXcxd1ZFQnFYVUU0ZUp1aHZYcVZKc1JiN3J3WjZQa0JGQURHQVZWc3MrZjhU?=
 =?utf-8?B?Z0hpV2RLMTNrRlJNNzZWdVJkR2YyazMvNWVCb3lOeW9CY0tuSjJpcnlTL3hm?=
 =?utf-8?B?WUhaamdtRkpGNmtsZ0ZZZ0VWTC9wSFJsMkViYU5BMEx0aDRlYTBPczA0UXhp?=
 =?utf-8?B?SU5xN0F0MUV3ZTBMbmRXZVlCT1BRSlNMQVJBb001V0p2Vy9YMlN0dUtkTjE4?=
 =?utf-8?B?bTkwOXJrUWJBWlE0cmNsUVZ5andTS0p0dWlaSDZsakdFbHozcjJISjdkVE9G?=
 =?utf-8?B?YUxiZS95Q2h1UzRlL3B0clBaS1RYb0tCc1lGbzgyMzZ5YVkwT2ZQV1V2T1BU?=
 =?utf-8?B?eHlITHhSdDlXTHF2c0F2emRzRndYVUtMVlJXMHpJMXF5SHh3b3JicnA5cXR0?=
 =?utf-8?B?N3pvYWJsVmZPUlZpVVdmL3lvNTh5L0NLRnBrY1ViMHQ0WWJFSkdCc0xkUEY4?=
 =?utf-8?B?ZEtXNmxlNG9iYWJHN3UwNyt2ZCs4bzV1ZW9HUGIwZ2xkZ3dOcnFLK1B0ZCt6?=
 =?utf-8?B?eUJZZGJXM3gzNE0rcVJvOTdCSkxJYlc1ZWZMakU4RXhJYVlxYXVlRDBjeTRV?=
 =?utf-8?B?cGlRSWtaQmJKbzZ3SE0yUHE1ZDBlRmI2cjFFelJ2QjV5WjBDVWJFYW1Vd2Nl?=
 =?utf-8?B?YndZb1RzNU9sUVpVMjRLbUtiM3N0b0x2OXNCNWxpc0g1SzVJbUduTEVkQ2N6?=
 =?utf-8?B?ZlpmenVpSld1OWUzU2pwTVQ0Y1lEWEhnUVpKM2J4aGNKTmh6VlNPZU5nK0NG?=
 =?utf-8?B?V2E2VG54QU91R2pLcVhWNjlpMGtVYlZiRHAyMGpUMDd0ZElIUE1oejhTbW9I?=
 =?utf-8?B?QUttQlMvdVhQRFQ0QlNGaitQdUM0TjAyY21BaEhLbGVlbHUwT3JFODk4SzJh?=
 =?utf-8?B?N1NNRnNEL0NjR25wZVpzekF5R1NhM2NVM0ZwU2JzNUdDN3BnQ01JQUphaFhl?=
 =?utf-8?B?ZHh6L1RuckpaN1JrVnpoQmtseU4rbm96M0dpY2dvc3VEcjlFamw0T0I1M1Jr?=
 =?utf-8?B?bWlBbmRZWm1WL0c5a3dQSWZlSXhiN1JjQ1h6bWdMdmk0RXlIdnpSRXdXTGUx?=
 =?utf-8?B?V0VQUnVhOXhhTWZYbDV0bXA3TVlFS1FsejlZaHljbTlVL0VkY3dnYy96Y0RU?=
 =?utf-8?B?YnFZQzBqUmdoVUhpci8raUtrRnpaK0RRNzNGVEc5NDVjNGZGVUtEaVRtd3hz?=
 =?utf-8?B?d1FzWXBoWmc2eU1GSWtwaTFEY0Qzc1ZGQm1iYncxVUw0VmMyWnBCQXRuVmIw?=
 =?utf-8?B?ck1ra1lCMHZweFlnVlVGOVRqaExsNGdFWEFGdHI4VHpFRy83N2dsNnNpQjZN?=
 =?utf-8?B?SHZ1WEtuSXgrbE40ek1MbEhDTzNQMG0yd3U1NWcxL0VZdExWWjgyeUpSQllt?=
 =?utf-8?B?Z3FWcXNWbkcrRy8wQzZqN3ZoamNuSndJWWpHdndsZDlqQnJSTDJiQ1kvcFZ1?=
 =?utf-8?B?d3h1VFRjVEM2a2l5bUIvRUZieURRVUs4U0JCdjg4WEJ4MC9JUmFTU25yMWdq?=
 =?utf-8?B?U3Q4UnRVUHllNXJyb3BrVUNtM2dvU2ZOZEd5NEhrWjVHQ3NuTk1uNHgwUXIv?=
 =?utf-8?B?Uk5wVmJsdXRDbjloQUt0THZrOXhNMzc2UHR2R0d0NkVOam52SGhKWmlNemtB?=
 =?utf-8?B?Q1AwUmt2OFh3ZmJmcmZ5bTh0Um9rd0tNZWR6N3JtbDNNdkNDaFRDVXc3UmZK?=
 =?utf-8?B?TFhTTnFFTk1CdjVNRXJqaEl5cjlSYlRpKzJyQWdxM1JNdzc3L0hobDMzQXhl?=
 =?utf-8?B?QUJQclpYWUFLRyt3Q1hDSmtoYXVVZDRWRUZSbjlMOFU5MzF1MytzS3pEU2c4?=
 =?utf-8?B?UDI5dFBnZ2xoRlhSNEgvRTlYcHRnUWxVSkdMdEE5WGxTNFd5aXNWOUx2WkVi?=
 =?utf-8?Q?8yiPsWLFUT2nbW5CHY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bcde43e-0e7c-4388-91ca-08de5226dad8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 22:06:37.1182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy5Leq37FIhquW42S1IxbebB+uIyK4t9xpPlA2MH1EM8ROndlgeTrTmjcs6g+15sXnJ7zrK30JMR0gFDiZKKEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9336

On 1/12/26 15:25, Mario Limonciello wrote:
> On 1/12/26 10:33 AM, Tom Lendacky wrote:
>> On 1/11/26 23:36, Mario Limonciello (AMD) wrote:
>>> The system will have lost power during S4.  The ring used for TEE
>>> communications needs to be initialized before use.
>>>
>>> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
>>> Reported-by: Lars Francke <lars.francke@gmail.com>
>>> Closes: https://lore.kernel.org/platform-driver-x86/CAD-
>>> Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
>>> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
>>> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
>>> ---
>>> v5:
>>>   * Fix return for psp_restore() (LKP robot, Shyam)
>>> v4:
>>>   * Add tag (Yijun)
>>>   * Remove blank line (Ilpo)
>>>   * Adjust whitespace in psp_restore() (Ilpo)
>>> ---
>>>   drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
>>>   drivers/crypto/ccp/sp-dev.h  |  2 ++
>>>   drivers/crypto/ccp/sp-pci.c  | 24 +++++++++++++++++++++++-
>>>   drivers/crypto/ccp/tee-dev.c |  5 +++++
>>>   drivers/crypto/ccp/tee-dev.h |  1 +
>>>   5 files changed, 42 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
>>> index 9e21da0e298ad..5c7f7e02a7d8a 100644
>>> --- a/drivers/crypto/ccp/psp-dev.c
>>> +++ b/drivers/crypto/ccp/psp-dev.c
>>> @@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
>>>       return sp ? sp->psp_data : NULL;
>>>   }
>>>   +int psp_restore(struct sp_device *sp)
>>> +{
>>> +    struct psp_device *psp = sp->psp_data;
>>> +    int ret = 0;
>>> +
>>> +    if (psp->tee_data)
>>> +        ret = tee_restore(psp);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>>   void psp_pci_init(void)
>>>   {
>>>       psp_master = psp_get_master_device();
>>> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
>>> index 1335a83fe052e..0deea1a399e47 100644
>>> --- a/drivers/crypto/ccp/sp-dev.h
>>> +++ b/drivers/crypto/ccp/sp-dev.h
>>> @@ -174,6 +174,7 @@ int psp_dev_init(struct sp_device *sp);
>>>   void psp_pci_init(void);
>>>   void psp_dev_destroy(struct sp_device *sp);
>>>   void psp_pci_exit(void);
>>> +int psp_restore(struct sp_device *sp);
>>>     #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>>>   @@ -181,6 +182,7 @@ static inline int psp_dev_init(struct sp_device
>>> *sp) { return 0; }
>>>   static inline void psp_pci_init(void) { }
>>>   static inline void psp_dev_destroy(struct sp_device *sp) { }
>>>   static inline void psp_pci_exit(void) { }
>>> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>>>     #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>>>   diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
>>> index 8891ceee1d7d0..931ec6bf2cec6 100644
>>> --- a/drivers/crypto/ccp/sp-pci.c
>>> +++ b/drivers/crypto/ccp/sp-pci.c
>>> @@ -353,6 +353,21 @@ static int __maybe_unused sp_pci_resume(struct
>>> device *dev)
>>>       return sp_resume(sp);
>>>   }
>>>   +static int __maybe_unused sp_pci_restore(struct device *dev)
>>> +{
>>> +    struct sp_device *sp = dev_get_drvdata(dev);
>>> +
>>> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>
>> This isn't needed since you have the "#else" definition in sp-dev.h.
> 
> Ack.
> 
>>
>>> +    if (sp->psp_data) {
>>> +        int ret = psp_restore(sp);
>>> +
>>
>> Remove blank line.
> 
> Then checkpatch complains:
> 
> Missing a blank line after declarations

Ah, yeah, bummer...
> 
>>
>>> +        if (ret)
>>> +            return ret;
>>> +    }
>>> +#endif
>>
>> This isn't the way the other functions work. This function should just
>> be calling to sp_resume() and then sp_resume() should call psp_restore()
>> (or psp_dev_restore() ?) if the psp_data is present.
>>
>> And if you need to distinguish between the resume and restore case in
>> sp_resume(), then it sounds like you need an sp_restore().
> 
> We do need a different path for resume and restore.
> 
> I guess the call path you're looking for is:
> 
> sp_pci_restore()
> -> sp_restore()
> ->-> psp_restore()
> ->-> sp_resume()
> 
> Basically move the contents of sp_pci_restore() into a new sp_restore().

Right, without the #ifdef's in the .c file but in the .h file instead.

Thanks,
Tom

> 
>>
>> Thanks,
>> Tom
>>
>>> +    return sp_resume(sp);
>>> +}
>>> +
>>>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>   static const struct sev_vdata sevv1 = {
>>>       .cmdresp_reg        = 0x10580,    /* C2PMSG_32 */
>>> @@ -563,7 +578,14 @@ static const struct pci_device_id sp_pci_table[]
>>> = {
>>>   };
>>>   MODULE_DEVICE_TABLE(pci, sp_pci_table);
>>>   -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend,
>>> sp_pci_resume);
>>> +static const struct dev_pm_ops sp_pci_pm_ops = {
>>> +    .suspend = pm_sleep_ptr(sp_pci_suspend),
>>> +    .resume = pm_sleep_ptr(sp_pci_resume),
>>> +    .freeze = pm_sleep_ptr(sp_pci_suspend),
>>> +    .thaw = pm_sleep_ptr(sp_pci_resume),
>>> +    .poweroff = pm_sleep_ptr(sp_pci_suspend),
>>> +    .restore_early = pm_sleep_ptr(sp_pci_restore),
>>> +};
>>>     static struct pci_driver sp_pci_driver = {
>>>       .name = "ccp",
>>> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
>>> index af881daa5855b..11c4b05e2f3a2 100644
>>> --- a/drivers/crypto/ccp/tee-dev.c
>>> +++ b/drivers/crypto/ccp/tee-dev.c
>>> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>>>       return 0;
>>>   }
>>>   EXPORT_SYMBOL(psp_check_tee_status);
>>> +
>>> +int tee_restore(struct psp_device *psp)
>>> +{
>>> +    return tee_init_ring(psp->tee_data);
>>> +}
>>> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
>>> index ea9a2b7c05f57..c23416cb7bb37 100644
>>> --- a/drivers/crypto/ccp/tee-dev.h
>>> +++ b/drivers/crypto/ccp/tee-dev.h
>>> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>>>     int tee_dev_init(struct psp_device *psp);
>>>   void tee_dev_destroy(struct psp_device *psp);
>>> +int tee_restore(struct psp_device *psp);
>>>     #endif /* __TEE_DEV_H__ */
>>
>>
> 


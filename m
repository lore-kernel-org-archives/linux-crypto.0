Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2C030B52F;
	Mon,  8 Sep 2025 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757347255; cv=fail; b=kW8va4btDCdPqxR7eMbEVVpwHrh6LcSayYDgWvonWSgPduup1/Y9LC5thl1RcDU/aPKJEF4hMzjGCOoe4qCs56GIUIUMxWk4HNDN8BOT2089XXLO+AKsq5lFJw7lsHzo8SSLpJSjrHHeOP9P4x8GHpu/uBRwldafbZndaYbYONA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757347255; c=relaxed/simple;
	bh=GMsExVf2SJ6eUDUSNQq2gwyUgNXqpknz6U9+ZPDDjM0=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KbsxdAv+F1tf31CQnY/quVgvJo+RgPOFvVAk6DguvIjk2VRYJpiWUFJjqONoQ7Fy89qj/Cm1GH2/HATPiUISstgzup+EvOhFg7zZRq9iYdq0gKBq4Aivmlap7tT/xiVJwwtWxBXGnV4M3umODHHgNm5BX3LsT4nIeqiut1s7hjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XXeD8Qko; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XXeD8Qko"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VbBzvegRV95+kUuVID2Z1dmCBeADE940Kc/XRXj3wrjTTpgw77t/cRqnbFoQpWJdAt2A8xMbnOT8paCdyPZu/itFvZMrUAU60k8xwSRVFICc9Ahj9kkgP2w3EEul/Z9uhhjUZymk20fhHiTZuJJSAi20P6D00CLS+j0NE40XMld1+SS3eva97FwPxeuraV8c8fQjSpE0AYDbvAdBW4tCNW2F+2Uti31BJc73Ye6g71haXrJpF2lbpanBup2wwPWX7GPzkel75fSoq/FAKfBoGpc4AkV50eufBbznSyG0/lSFs0sJxLNClqspkmqao9EiWz+jTJi33yO6NiM2w3TWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKIr68tKyZZrc//MHV2ntcH7u4JfrnokhIqG0muz5+E=;
 b=aaJRKrf7tTCN+3Lnjf9kQXk6Uv9LzwVQId+kzCuVbPTur7berczxGIkB6U1FO1/5fsivcIoGAbhq3Jdt3+fwanbN3Qz6xXVL4o62w/120A3pfwLtQL4Ckqn35SVrDT29kN/lRFSquftEjKA3EqPtZgIB/IiUNjJnX2YgRfqgHjF7TUTW6kA2HY6R40cKWmJBlL96szCy6bUvJ/r9MU1mAs8YmKi1175yC62yh4YYyvvkv+tZz4wVLzCP2/Uq9sfjwPqxGYHSHYULqalIP2pFhIsgUQkk2tADBLMurPjyaUnWjhHj6No5rUmpl5bGK9SY+Ff+X3H+mbyH8/PcyP6ihg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKIr68tKyZZrc//MHV2ntcH7u4JfrnokhIqG0muz5+E=;
 b=XXeD8Qkody+hUgc88epE4mtm8lp/2lGM+zeeoDDTTLYO34QK5zrRtVkr+OZjAxS9MYWDIz1dvpeP0cNHLAVDjkHyYw2ofPVfwjWemsP12OFJkbbPjkiaML9X4RDq6BqaYeE75v7kaBcxURf5ylGGNPRDFtyvWJiSnNc6r5H1ZiE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6081.namprd12.prod.outlook.com (2603:10b6:930:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 16:00:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 16:00:50 +0000
Message-ID: <cdd5f593-0ed7-099e-1a72-9a190edbf02c@amd.com>
Date: Mon, 8 Sep 2025 11:00:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/3] crypto: ccp - Use int type to store negative error
 codes
To: Qianfeng Rong <rongqianfeng@vivo.com>, Ashish Kalra
 <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..."
 <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20250903132539.416439-1-rongqianfeng@vivo.com>
 <20250903132539.416439-2-rongqianfeng@vivo.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250903132539.416439-2-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:d3::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6081:EE_
X-MS-Office365-Filtering-Correlation-Id: 54ba8a3a-c76d-496c-db12-08ddeef0e18f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q1EyV0xRaTRhWTJyeDRDcm0ybEs2MEN4aTk2ZmpXL1V1WmhzUmZ4ZmdNYTNv?=
 =?utf-8?B?V2UwK1YxZlRibG9JNjNvRHhaWjBkRUlvQnVDdGNUOW5ZdUxSc2RLcGgyb1Fx?=
 =?utf-8?B?ZWM0cndLZTByL3JXUmZsMXhpNXV3MUt1dnc5Si80RG9TVnJaNlg1YnFacVZO?=
 =?utf-8?B?Y2laMzVCTmdnM0FMMTg5Y2wxeEJ6MkJlaEtzQmRtN0VzZGsxNzJ3QkVGZzhW?=
 =?utf-8?B?Wm1yclFoeFpIeW8vYitRUFVUdXhEYjhGMi81SFNNRUg2QWZQdFVxcGQya1Nq?=
 =?utf-8?B?SnFVVnpUWXZqVUNJQWp6em0zVEwvVE1rZmtKOFdvVUhtd2ZXTUxvcDZHU1Vt?=
 =?utf-8?B?eDN6dkdrdWRaUVBQRU9HYW8yS3JuNnZYbDYzWnl3OE1HbVE3WlpUWS92MGlV?=
 =?utf-8?B?YkVVclA0S09HL0lsVHlCSUYvMEhOTWkxTzVOQTJWZ0xCenhacm1WeUNBRzRR?=
 =?utf-8?B?QkpabHJsMUNZK0U2QXZPQXFSeHdxbGxRS1k4SzJkZzBaZlRwV2lSWDB2eU52?=
 =?utf-8?B?ZzB3NndoVURtTXE4SVdVaTIvWll0bHExQTJMM3BNeDc0aFNjYWxaMHJ1d3ox?=
 =?utf-8?B?Rk1QRkJLL2h5TWF2REpCa0wyV3hNT0FsZE03MWRsRWJPVURCZWRxTjI3aTR2?=
 =?utf-8?B?bm5ZTjE5K3EzSUdJcTNGMnlpUGZEclRFeXdqcnZBZGdQb1h2bGo0ZExWVTF2?=
 =?utf-8?B?cHB3ZW9Pakt0ZjM4cmdhQnNwMHlPZWRpNzhkeVBOMTMwZmt4YmFaaUF4M3Q1?=
 =?utf-8?B?UmxvaFVyUmJyWjY2dWlXR1hjQ0MxZWh5S0tKZ256cGtKNnZ1UGhhTDY2NE9p?=
 =?utf-8?B?MFJzZ2RYV0loNFdxbld2OG9oaFg4endMZ09tNEVBZWgrdUllNklXODdna1Yr?=
 =?utf-8?B?dmV4RU9Td2JmcFZBMCtvZFlxbE5DbVBYWWZtem5Ka3RXSnFjRW9ZU3p6TzVa?=
 =?utf-8?B?ZkNlRC9YZ0FCWFVwd3Z2dWc5b080eHNZNlo4eWM2MXEyUTQzRDJFcEUwUlBJ?=
 =?utf-8?B?QUROWlN2dW5LVDRHR1dRSEpnUkJSQkZWdllRRlJMZTdWdCtwNUk3M0ZqUHla?=
 =?utf-8?B?eVZyZEhCbE5aWVoyaWxtVFhKbXR6K1paWmZQWnl4My9iVTZDVGk4OFdMRjhN?=
 =?utf-8?B?QzNtSjJ6dFNlUEhaTkZKalUwTlpBM1RzWmMvTHZsdXRnZVB2MlZONldTbFBv?=
 =?utf-8?B?WGdNUHorWHZxdFhuQnd1VUVoa2xpVFJPSmNDNWtyUllOVUo1RG5GQnVPTFZV?=
 =?utf-8?B?bkZXalFraWJBQ2hrSytTUjc3aVN3NHUweEJaTlZGMmZld2E5VUZ3bXZ6ZHNK?=
 =?utf-8?B?Sm85ZFdneHZqZ1R3Y2cvbURsb3lkaXhnWVMrUGRkakUwdzM0RzdqQXQ5dkNU?=
 =?utf-8?B?RThMdyt5aG8yRzg4U0pWMUdhSXhBNTFKNUx1VmR1VGY5bHdvTTg5QjJJQmtU?=
 =?utf-8?B?RzRETitKVEd4MElCTHF2SWRmU1lHc3oyQTJJY0tGeUhyU1ZZQkdaczZEYTNs?=
 =?utf-8?B?WmVjT05IajNTeENSanV1dE15Rm1ZVHBsVFY3c3VIWElxSFF1Q29jVnNuMWJZ?=
 =?utf-8?B?K3o5WC9HNm01VFRkWkh5MGRuMUhJd2xYYUdkelFuZ2d3Lzd4LzJXS0E1cnBF?=
 =?utf-8?B?RUw0Z2ZLa1Zid1h3WlZFaHRvUEhGRWR3bHpGWGlmR1dLaHJTbGM5YXJ3VXRS?=
 =?utf-8?B?M2hjYXBPNjMvRmpTM20yU1lmNEVCQ0d5eGQ3NEI5SHI5UW83VnFQVldXd0xG?=
 =?utf-8?B?TTUyTE50aitHWWFDSGpscmdSeVcyRjE0V1NTVmZDY0lUeHRFNU5ETjJHeEU3?=
 =?utf-8?B?RnhsMzkyWjZiSUJLZFdTQzRoL1FVOWtJWm52d29KS1lFN1c5V0JoRVhTa2VD?=
 =?utf-8?B?cStFN2tQZnhUUVUveUFYNTE2SWJmNzVKS2RJOFo5cFZqaGt2Q2Q1RnIya3dH?=
 =?utf-8?Q?ShuCMwqoGL4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzhDd3AxUm90YjFMOHdlb3FiWlp6VDlZbkFaWkF1aU5BdnBmbkpJbElVWFBn?=
 =?utf-8?B?MWR3S040NHc1ZFRET2NwWVZuZ0hPaEhkQ25GVW9MYmw0bGplSDZCbjkzbXVB?=
 =?utf-8?B?dHFXeTkyUlRNKy9Nb1A3cVFUSnc2QUFHQlk5UEQ3RmxzV3FoWWYrWGF3U3Fk?=
 =?utf-8?B?NUZ2aFJuMGt3eDFyeWJGa1VLeFo5aFNyQ3RGcWNFcytST2E1cm8xQ2dLMXRJ?=
 =?utf-8?B?TnVSSFZ0cCtHdzE4VWVWQTJIa0xaOTRjQmtoU2xvbG84bG50QkloZXArL3RU?=
 =?utf-8?B?a0doOUJTR0w5d3dmRDNSbDZOaDlFZFdXQllMSkNLZk9yc1hUTEtLeXhhbEV0?=
 =?utf-8?B?eitNbklLL2huVVVtelV2c0R5c09IeXhCTjJOME91NEJWMzQ1VWtmb1VWV1Fj?=
 =?utf-8?B?WGFidEVtNVduZG0xQnp2Vkh3S2tTa1BmYko2UXBXd0lFRmtzcDVlL1h1Y0pq?=
 =?utf-8?B?VisyYTJTQUpZLzBLRHNKYk1RWnBGZmJ2UHVSd3J4eFNRNTl5cmdtM3hnMlgz?=
 =?utf-8?B?aEFwb3dKVUVrdVdNNjV6TGpSOFlxdHI3MFdVcHhCajlIMkRZa295Y2xCODQ4?=
 =?utf-8?B?dVdaNnBxNnQvZ3pORmJSQldXSU42dk1tL0czM0tLUDlMNmYwQW4xcWZnSTZq?=
 =?utf-8?B?UllRQ094ZWoyUUczU01zLzRQcUxnY3lEVDJXbXZBZFBjRDhNc2swTERrcXhm?=
 =?utf-8?B?bWdRVGs5N09ab1VNa0JHQkdaMGVycjhzL253WjRWcTlJaDc3RDNsZ2w2UFZL?=
 =?utf-8?B?cWxLZEpha2s4c1B4eFpJdmU4UjIzRW9sdHFEUC9DMzhiZ2ZRbW1hQ2lJd3ho?=
 =?utf-8?B?NEFZZm5sRFFtcVdWVFAzNU1OWUg0MHA5SnZTTDlpbDE3NTBIVlJOWXdyMjh0?=
 =?utf-8?B?QU5HN0lWaXZOT3Rpei9ENGpTb095WjZaWCs1MTdnTEZJd2xUQXJPQ1JMci82?=
 =?utf-8?B?bGE3OTdEckxOS1dzY05QQk5KdG1ybTY1Wk9MQ1ltRDVKeTc0eGpUWnppbWFQ?=
 =?utf-8?B?YzE3bVBqMGZCODBlZ1h4WGJwV2psTUh0V1lCM0ltaXM1d0ExaDRSbk9kS2NZ?=
 =?utf-8?B?eWJRa1gybEVrenR0dS9yU0Ewek02ZjZXTWd3Nm1qUmQ5dWRScWUrVkdDdm1s?=
 =?utf-8?B?aVJzcW9XVFJzK2R3WnFiMlRaUmttb0d5UTlRbVdUWEdMdkJUdFNVU1dkbVRw?=
 =?utf-8?B?MExWTFR4d3VtVnorcE1Ta1NDSEpNRGtTbWNvbG9Vc2pWMGdRWTIrajYycTZB?=
 =?utf-8?B?WExNT1A2RDBmUWk2TklQZWd5R01vSWR4MlE1Tmh0RnBIMkdVeHJTeDVmemVw?=
 =?utf-8?B?Wk5OTEVuWWhMalQ4ZERodVRva2YrTGlVakRxNi9LUjlxL2E0R1ppbG14L0ZD?=
 =?utf-8?B?V1ZJZlVOdWJNOGMwSzlpaG5YdjBvY0hUQmpLTWZMT2ZxdzY1YkU2RUhpRkJl?=
 =?utf-8?B?WFRZbEp6TzBCRFdCbW1xeHg2Y0NvU09zODNtOFNOWXBmanB0YnlkWHBMZ1Bp?=
 =?utf-8?B?cDZIck5LekZsN0ZEUWNjSDJnbm9RRnRSZWo5MDVQdGNhbFR4MDBna1lKbGkw?=
 =?utf-8?B?TDNyOEZtOTNZaWtVemppUnBqQjJVcGx2QzczRFNoWGRPMUJWVWtXZ1BVc1ZL?=
 =?utf-8?B?SVNNUFhIUElxUDBTS3A4Q3RiTFd4Z3BqRHlPa2VkcUpXc3FTTUlKZ3cwWXlQ?=
 =?utf-8?B?ZmYyRUpQVE44OWEyNHNYdStiRk5JT3IvV0pNWGs3QkJjN1RSd3ZLUUxqWUxO?=
 =?utf-8?B?TGJVOWdRSWswYktnU3NzN0tCM3VvTm9lakI0QUVUbThnTVVrOTlNZTlQQ0w0?=
 =?utf-8?B?eDFNa3piMUlzM3Z0L3B5OHdnb2VBNllBSnlma1FPd3hSYjhFNVJjQXJ5K3l2?=
 =?utf-8?B?NHQ1aDk0RFJDU21OcXNjbENvSXc5Y1FURlJhYmRBejViQTN4RXdmd2xkb0Qr?=
 =?utf-8?B?NXJBQjJlb0hhTkhBRldkSDEzTDVHMzVVbG5FQjVtaHdHVXlaZzhSTG9PalJD?=
 =?utf-8?B?R0ZETDUxcGQwNEFOZFJKd1JpMm1WNGdYS09zaGlxOEo5U2ZPNlBHRTIrR3NL?=
 =?utf-8?B?bjc5TmQ5Mk9Hcjg1UjQ5bUJsWnRSL1NET2E2cTdjbVZ0alVJeUx4Rk1sOTQw?=
 =?utf-8?Q?td/1ZszEgddv1HXqbL6TEV2yt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ba8a3a-c76d-496c-db12-08ddeef0e18f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 16:00:50.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+bG2rfL5rgvNmImlEb7E/UNM2CsRzNPjm7RxTMBVluSQ+XRtNRgZfQ+OO79V8hYIMfoM6d5//DCcWp9bZVrvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6081

On 9/3/25 08:25, Qianfeng Rong wrote:
> Change the 'ret' variable in __sev_do_cmd_locked() from unsigned int to
> int, as it needs to store negative error codes.
> 
> No effect on runtime.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Not sure it needs to be initialized either, but not worth changing that
as part of this patch.

> ---
>  drivers/crypto/ccp/sev-dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4f000dc2e639..6c116f6f9b79 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -848,9 +848,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	struct sev_device *sev;
>  	unsigned int cmdbuff_hi, cmdbuff_lo;
>  	unsigned int phys_lsb, phys_msb;
> -	unsigned int reg, ret = 0;
> +	unsigned int reg;
>  	void *cmd_buf;
>  	int buf_len;
> +	int ret = 0;
>  
>  	if (!psp || !psp->sev_data)
>  		return -ENODEV;

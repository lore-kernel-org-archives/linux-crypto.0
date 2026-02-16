Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349ED287506;
	Mon, 16 Feb 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771267252; cv=fail; b=u1eT/Oav7Nf10oqMgnA1CCiKQEhQF2NldIP3zEQKZyAVqyu3iUFNskiPiQLzR6694S+n+Gw5mfXXhaZCebwKnHCwQ2olGOQJMLft2l9rl6+BbiMELBmCsGbkVjXHllCgtxFryucy3NI4FO997IxOWxEO4usA1UCYf2iK34PCX+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771267252; c=relaxed/simple;
	bh=v9YlSEuYeoVozF+yt356F4ZVu0XykT1C2X2Y12uG9Bo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VmjPqmSaqFoMHPILxeasl//E+5dpsCqeM5r+5o0o9OO/ExLw3Z2IPiHR5ibDYALcUp8z/DtpvUFaxoujPZC/m0II6a0lPSRU5IGU7qXOaM66G7KCAr8tPV9ni4STl4Pa3vdfxjGsMU95deXbcR6JnniMKOxxLHsJcgiy5AII0JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PqqAWmgf; arc=fail smtp.client-ip=52.101.61.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PqqAWmgf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ujXcSwlZaccoQ+UPZUYkugDcbfrjkyTF3nzVWMk79Gba7ER4QGgOYeRG6LrN2ypOpWSJldCR6i+CP+LavTgQc+KTOPEvzpkIu9s442/5ggAGI9HXlFjWDSlLZUFvgE0xgJ1/KrywS1KIleuag6d5E0UjN9EuOHBlXqTWi2gai8dxnw89ZeRS9sZCppLCBtKiC5XVDcvRLAN0DTqXKqRn60gZSbOAHTPIMmL11xJ+f92YJqbBibRWSksvb7VH3kOp9ofcBMO7EY4i2sVOLph+PcQS+xGftaVqKFxrbf7vlyi304HMPw2j0T4PcXiWrBGW4hq6VdtycrPQ2SUSXilZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYVpc3rcNrvN+1v+GwNR7KvR14BIrI5lGUqvnaPxqqw=;
 b=hU8Ne1k3OAldFqmxQPYsTnJNzGm9dSJBNNl9Z2dNtMt7n20yt2I29SyR3ZRcVBUnPOjDzmkdDMYLX3W+Hxh89YwrPaurIwEC20eLEUPaprLoPTZHPaLHEmkw33O1riRGZxsMK/g/3FV4oxXiQMLtPUr+ehSJCYQalwZmR8AW9xGbtiBpKFHlMQMtKRVGGAOa40pmhQLTvcLD+kwBySOfpyZgarbccrVV5Y7VHE+CBN442Zz3XLFh2hFvwmQ7PHKwJJou00obUdiPZb3QFbjcCuQSPqmxEbchl8zj5MKtWo4u0t7rVsNfNgHCKCKj9hkFdYo24uaLu98Sh+MZ3qZ+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYVpc3rcNrvN+1v+GwNR7KvR14BIrI5lGUqvnaPxqqw=;
 b=PqqAWmgfn7IZWhPm8iiNxwyRwtYwzbwEvm+5hVnxpXf2dE4e3qOZqTe1pENHYCB4ExLem3YBx1zTtx5WIQH2Fw2KCm3Izl5cGpKTN8lb4UkiKQbDcXfMhr+KrDtepZWUfXDHfK9z6gekv4hYDg0VBMtcrcbKKTn98+To/wdZZ3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB8112.namprd12.prod.outlook.com (2603:10b6:a03:4f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 18:40:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 18:40:47 +0000
Message-ID: <84360407-8bd6-45ac-a950-0a1d0c12b2f3@amd.com>
Date: Mon, 16 Feb 2026 12:40:33 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto/ccp: Fix use-after-free on error path
To: Alper Ak <alperyasinak1@gmail.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: ashish.kalra@amd.com, john.allen@amd.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260209103042.13686-1-alperyasinak1@gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260209103042.13686-1-alperyasinak1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0162.namprd04.prod.outlook.com
 (2603:10b6:806:125::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 072dc668-60fc-4e23-7b80-08de6d8ae675
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2c3VGZMdmVzVERmTjhLTWk0QmFsY2VUR2R4SGprM3pVUm51S0Nta1hXeTVW?=
 =?utf-8?B?eHRrZll3VnN4Zk8wRVZtUC9FLzlVTUpHblpkbWVNTGdTYjlCREl6M1d6eXBO?=
 =?utf-8?B?Vkg0Mk9vVlJ5Q3JhZGd1ZktxYzRIbFM0bDRSYWZFMU9aWnZsM21EYWxHUWdU?=
 =?utf-8?B?VkRQb2tEWFJkSURqOFdLNmVhU214OWV5R29aYy9BNGZ6RmpHVmsyL2hNbDN3?=
 =?utf-8?B?TDFLSVdVaGVPRkl1SHQ4QUdHc3AwN2pHRVQ1dm1RN2dQSUtGWEJzT044RCs0?=
 =?utf-8?B?SFpXcHRiUmxxbkI3SWkyV3pydVN3V2J2UTFCS2x2ZW1ETVFsT1I1anp2UGpE?=
 =?utf-8?B?SnVxZzNGNENibWM5QkNIVmFlM2hNVHRNRkl0ckpqZ0NnWEFvNFZYbTJxUlQ1?=
 =?utf-8?B?bVpsU1dPeVdhQ1owZE53SWNSSmZsanZoZGlVbkIwSG5iUDI5MlowaU9BdW1z?=
 =?utf-8?B?cDBDNVBmMXhHeTVmTHo1YUZQaFRMeGNlbkFPS0ZVcFY4cjREWUFPNkZscWNM?=
 =?utf-8?B?eERtanUwajdSeHRWUE44aWpTVFgwd2RhVHdSc1RHNDcvcE5Jb2kySDMyNEp6?=
 =?utf-8?B?djRqc1p4V2tOOWllVVFHY1o5K2lPMFh4WDhmei90RzhDd2JLOHhWcGpuanRj?=
 =?utf-8?B?a2ErejlsV1djT2xkQ2tNMFloWnlKWW1FRVA0WGJnS2piRk5aQzlFREMxMElr?=
 =?utf-8?B?MDJsT0NjTFRNYWJDejdFNFlac2xYb3dsdUdMK0V5QzJTOXduRWhoVEZQRDl1?=
 =?utf-8?B?SytrZkZqM2p5VWlaSUpyR1ZYUmhzc2JYc3VTUHk0SURNM2FNbHlPdU13aDdx?=
 =?utf-8?B?UmxOV0JDSnZnZWNJYklud1RyNVYyVUVFVXFUMkNXaE5KQWgzT3MwNHhWVGFs?=
 =?utf-8?B?VnZWVyt6dXY0MEdlRFNhWlhEelBTUW9xcllMbzFaL0xBUEllajVYOThUcVEx?=
 =?utf-8?B?ZEtweGE5RnFYUVViQ1E4Rm1iWmRJZUt1TVArODdIa1hVQkhVZUdUcmtCRWlw?=
 =?utf-8?B?R0xTQ2pMOHAyUFhhRTRXcXd1dHhZa0hrMTFoaHVhY1pFNitzL2R2ZEdJYWZX?=
 =?utf-8?B?ZnRTb29QRDkzSkNnY09tY3kxcjVaNTJiS0JRcU5Qek9nb2hCVzU5SUhlTG02?=
 =?utf-8?B?QmlOaGJFSkt5ejNhTllxV3h5UXNFbVdpY1paaHJyUkEvR2pTWVVRY1duR05P?=
 =?utf-8?B?U1lNdHFoMUV5K0dYNTd2VFhmNGZ4QzhxdmlBSnYxN1o0RFk1OUFwOVhVUlpr?=
 =?utf-8?B?T29hR2RXVkNXOHMvQTBscXB6cVY1UmhFbCttUVp4Tnd2ZjZaTDAzazVtQkI5?=
 =?utf-8?B?T3Q4WHJPSE1zaVVsRDRiRytzSWNGSEpSV0hQL1lMS3loMFZOOWI5ZG9ZUHpV?=
 =?utf-8?B?ZUQwWUFyUEdFQXhQMURaSzFoV0NKek90OHlvTWJRVWVVVUZaSThmZlVrazRE?=
 =?utf-8?B?ZW1OL3ZQV2pKeDdJYi9RakdEaFM1ZllBbFVaREZTcWVjRnJoTWY0c2pOWDdn?=
 =?utf-8?B?dXBTYmV2MS9RaVU1NWVQVFcrTWRWa1c1K0ZUbXozMHVyS2NkNUFGRFBZbXlz?=
 =?utf-8?B?dkI0c3c4Z2V4ekFBUk5YdExMZ21iTWQvTDFFcWJrZ2xzNFZvc21TUW5RRFQw?=
 =?utf-8?B?K0xYaXBFd0w2bEpHQmFzaWJWbkFwQTNXMHNCSkdYVFJNaTJVeFJ1U08wa0dX?=
 =?utf-8?B?NFRZRjlqODdzQ0FxV2Fza0twOGR1MmVJMWpkYnhZUGtjekVCS0R3NUdndlpX?=
 =?utf-8?B?NHM1T0cveWJSaGFDYnV2Y3VjbHhYcm1VaTB2YmxIU2lHUG9DY1ZJYzBvcFo0?=
 =?utf-8?B?WkpDNFBJczRRWThrbXBFVTVVaEhvTTVVblhWY2xMSmRwTGUrWVRUSzdLaTNN?=
 =?utf-8?B?aEpWcW1rNmNvaWo5T2xwK25RM3RKS1B5QWIrSG9FVEpGbUhwdVhiUWxVck1D?=
 =?utf-8?B?Q0g5dmtIcjdGL3N0aUtqamQ3N1UwaUhpaHBMTmhNS3k2NVN1b1hJMzRTdStz?=
 =?utf-8?B?d3dUdVU2U2o3cm5wUVB0YUF2aWsrVGV5d3F6Wnp2WW1Fd09ibktUSDNsbk5F?=
 =?utf-8?B?ZFd1RnluWHJvNXZOeG8wWm9CRzd4clJXcDhSWURkZXRMK1FWL0ZNU3ZqMmxB?=
 =?utf-8?Q?+vpI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnUzS2JJWFVoek1DRWFSQzMwS2hrR0FwRDRLOEkwMmRVS1h2RTUxZTRqb0Zo?=
 =?utf-8?B?d2U2ZkppRTVIMkxybGZQcWlwbVdOT0w5cXhXZ2ZCak5LU2hmUjFtUXQreERL?=
 =?utf-8?B?RS9JV2IxYk53bCtTNCtyNjRJeUR0VUJrSTdTQ2tjNTl5RUJQd1cyQmlBRExs?=
 =?utf-8?B?M2MvT3VKd0xlSElWdWRiNFIwZXRIL3ROc1lJeU1IeUcvUVl6UzJ1VU9ydkJN?=
 =?utf-8?B?Qm1Mb2V3Y2YvNHZkbEpXajRlVHNTZ05sL2oyS1pLam43ei8yQ2lZVjEvZXpE?=
 =?utf-8?B?MmNOMHVUTWJyVjU0by85UVUybEc0N1IwSU41UGZCR0pjWUlnclJ5TlhTcy9n?=
 =?utf-8?B?ajBGNUhFcEVwYjk3RjBIRWR1U09QeU05ZEFVQmwzcW5BSnYydU5EYm5BNW9h?=
 =?utf-8?B?bUR2cUZhMm5QVldiQXhLdmhXSXZpaWowaVMxOVpGWEFyd1B5d3ovVHBWbWU0?=
 =?utf-8?B?TTZudS9yNmlCcCtyMERKOFIzUk1xdEZud1pKZlQ3aFU5N3huYWFHM2Q0dzkw?=
 =?utf-8?B?aDlWdnFBVUdqaXp3Y1ZhdEtud2hRbkpiVmd2RlVjUHUrTkdJUU9BZm5IUU9N?=
 =?utf-8?B?aUt3UzE0QzEyVllhVmYyQ1lKcVRnc3lVZUxFbnVIby8vS1RlNFlGUDRxVkVT?=
 =?utf-8?B?YXdoRis1VFZ6RXdHV1RKYndjM0puZjc2dVFyeXcvU3RVSi9yTmhRKzJDMHBR?=
 =?utf-8?B?akZVTFIzb0R6aFZxdU4zSkFEVDkxZFJHdlJpeDRCZ3Zvd2NaNjcyTmJvT3Rq?=
 =?utf-8?B?ZmhJc2krVytKZDFUMzl1N1ZvMm8ydEpjSmZEdGwzem9CYmZOZ01jY2pwbXNU?=
 =?utf-8?B?TTlZU1RUQmVYeXpmOUtYMzc3QytDaDRqNEplNkxPZWM1aEhSd1NjWGpNSUJN?=
 =?utf-8?B?QkpVVWFoaGZOa3RFR3ZMLzV6Rml2REEweERraW5YVGtVak95WkJRZFpqSkR0?=
 =?utf-8?B?M1FyeGJTMXpQVFVGM010T0RWRjEzY0NGZ0Z2QVlCYUNXYTlzUE5kQjBna2JL?=
 =?utf-8?B?VkJrWFJXWk1VRFBUcnpjU3AwN2dOTTNBM3dLRTJLekJxeXZIS1dGSnl1L3gv?=
 =?utf-8?B?OWV3cHluMkVlTUhObDlXVzhFY0RWZnBxQ3ZuTjVEbXcvZGNqVUc0MkdCR21J?=
 =?utf-8?B?TERsZHNER0NBVFVPRDd4TENKNXNwU3lPdnFlZEttdzhweU9wenJaQWN6ZFBR?=
 =?utf-8?B?L2JZdkVORWVUcUJqbTd3SnQvKytxODJsSHdNVWxjVHZDSjV0N1o5S044MXpD?=
 =?utf-8?B?S3pEWEI2M2JlWUgzRGJUTVpWczF6UGQvS1FvcXFBZnB2Y2Q1eTBhTEM4dlEr?=
 =?utf-8?B?OXMreWRDc0NhbTJTSHMxRTZkWEt0L2w2ZzFoTXJyb0VHalFlcHMramJ1YzBQ?=
 =?utf-8?B?SXNmK3RZWUtQTW5DcGZyejhUZ2FvOUo1UkM1ZHljOXN6dTdCTGFSSnFuYzNE?=
 =?utf-8?B?Q1RnUFMranZvd0VRcnl2dkt4c1k4V1hHYkNMRXk2UjZPd2FXL3ZUK255Znli?=
 =?utf-8?B?YUlSQVZtcithUXg2a0lWa1FWeHdpaU5UZ25vZFdzTlpWN2UzbWRuV1lzTi93?=
 =?utf-8?B?VEdHZStWY0JwOG9CbUxQcW1UZFJ2byt2YjcyRHBOVVNBdkpCcnc3M1Y3d0Jq?=
 =?utf-8?B?YmpHUlY2Y1ZtYnJHditSL1RydWpDd09jRlhXaHF2bENKVE0wTkU2bFdQV0xL?=
 =?utf-8?B?d1p2bGxNc09qMW0weWVReVo3OWNaRDhUZXd0cmV2dTNmZ1Y2WEk4cmU0cDg3?=
 =?utf-8?B?d1pGRU50a3VlV0FEMWZUeS9rRGpPR2NyVkk3UFh0YUhlZmtNZ0NXNEdvOFh2?=
 =?utf-8?B?TERDQjQvQzFPemo3aHNhRXFBL2tpTUkvSS8wRmlWMWxVcnVGcVFJTng3cTF5?=
 =?utf-8?B?V1Jxb25GV2l4S0ZWaVlrRVpBKzdUYXNhUkpKR0VUYWxlc2N5a3BtaXp4NGE0?=
 =?utf-8?B?VnBpNG5OYVZ1dUsvd1AvWFg0dXNTdHVadzl0Uk5GSVpGanVVYW1QT0RDVHdY?=
 =?utf-8?B?MnhyTFY1RUZ4U1d4TVVpdjhteHNSR3NTZFVvNEloNllrcGlKc0dmS0NzWEs5?=
 =?utf-8?B?Z3NqSFBPVXgvZGJWSVFMWmRyaDF3RWRMbWxwUGxkcE1xaGY4ZDFPc2FMWFhi?=
 =?utf-8?B?WHJMWHRUUUtsQzdReFI1WEVQY2ZmZktlcUlBTFlzeG9wcHhjUkVPNVcyNGFk?=
 =?utf-8?B?ejhxd1RUTUhGZnZuaEw3bHJvZkE2b05VREFaK0JnSW5YQnR4TWJhajZVWUJ5?=
 =?utf-8?B?eFRDWlAranIzZFY3aGJ4SG5aa1pER1dvUTgzb1BYN2NBQ3hSd1lsRW15RjdM?=
 =?utf-8?Q?877dlWw5U1XH6cLQMo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072dc668-60fc-4e23-7b80-08de6d8ae675
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 18:40:47.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +N4m4ER/bF4A3mZR0QLZAmUfWjqbnylGBt+rSB17ro5FtgXzR4v80Hmz5vMGRbq0OFuvyETVPgOvAzVKURfcxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112

On 2/9/26 04:30, Alper Ak wrote:
> In the error path of sev_tsm_init_locked(), the code dereferences 't'
> after it has been freed with kfree(). The pr_err() statement attempts
> to access t->tio_en and t->tio_init_done after the memory has been
> released.
> 
> Move the pr_err() call before kfree(t) to access the fields while the
> memory is still valid.
> 
> This issue reported by Smatch static analyser
> 
> Fixes:4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Alper Ak <alperyasinak1@gmail.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index 3cdc38e84500..e0d2e3dd063d 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -378,9 +378,9 @@ void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
>  	return;
>  
>  error_exit:
> -	kfree(t);
>  	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
>  	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
> +	kfree(t);
>  }
>  
>  void sev_tsm_uninit(struct sev_device *sev)


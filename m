Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2755832693E;
	Mon, 19 Jan 2026 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831936; cv=fail; b=EGSInKbBsBspz882/Muzv+FBebEYH4NjTXEmb9q9TeKt47ivbL6C9VVyK7EHBXTUbxcBgUghszzNt4e3kjLeCozjvcZqVUTkhoyBeGQtlfh7ZyGkg95HOoE6+NvDnLkEXY9FtXBrtEZ3/MOZcRrAyKGkbIQREb8kxaDOmbn+U4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831936; c=relaxed/simple;
	bh=YpcbxT8nMc2hsLHwpjeZxeB28HkYCxkwU9LGH3sbDh0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WFwY8ZTaZmq2UhEDqOKmXoYt+ulBiIWS8OX6oACOfQSlm1Bm9kTIdcMyPDfXHGqonQ1hcILyrMTjOvhbe15oeVluy5dpy5TSCX3U5xngeCaMvhSwV72eODLzwv67PvepVTFv6LGJXAJgY8e6bcOX9Ya8VMSTzgJZjA1uaIVkFeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=siQkL6F6; arc=fail smtp.client-ip=52.101.85.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="siQkL6F6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXcmEka/c1MMHXoXyOZq5B6EsJ6XaCQr68hjHJl3NtVrcSGKA0mjsb5s131IWtFu8rZ7bbYzv2KdV5cFq95OMXnPS0YFpQsBkVPtOG7er/mgEGtPHRWwqxbcIN1+ccmfyzChTVqSHZWFEV2L2LElq82zN8A5ETU4ehckAh/+5jc8i2QneCDi47eGBjqcuxcsyS4Ol2jahPyHjaceAk4IX6mF+HXtxZnrRLbrf/a+x/w5wduzSd30USR3JmzT/O652/656Yab9BJn++Af3x0YlpxO2+6F5k5pqNr1ubFkLNkGXteVclwiUdeT92gmtV6o7Q2GZnFOkpaUwseh9st0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tibq7375oMThU9yH9U5PBVXI7H9ByFepnEOR5b7Nfmg=;
 b=iOmimHTnb8c1EOaTbqC+38y6YxxiAArPHYf+EpTV6vL0HmF5J0392NB0MNjjP28v+PkwPGIr6P477yp/2VPrc+bJrnUOx4ivalk0I0BM7Jncms3D2MiDwWHV8MxdBT4ylYAg7jz2Lel3zSzXbxR1badmhy4KayyBdwgN+uxvKlQbfIN2UutDArqW9veo3RVF+Kwtu5myPSFwRYGZJk27qdgf92MKJrn4yutr+mWrZyqiwGJuTiB/SaBK/6XGNtNNCj1iMbFpVyYxV7NBbDzNU4DthvaZFPkTuFU8t7a7WcEqiUnTR3mWccL2yTzMZaMSZLTB/FfoBUTHu6DHkul1fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tibq7375oMThU9yH9U5PBVXI7H9ByFepnEOR5b7Nfmg=;
 b=siQkL6F6Jud2ccesTAkjJgFcfaaG5Kv+rD+P9n7fn4dFg2fwmfzwpHq8vs9/eY8icMz5q7Bdx7irNoExD5MWaRbar9kcMDTq9c7SQLgI84Aq/YHndGfATf5Y1CNKPzAzRPkBzbHT0ojnrWuaUnCT7Yz+jOJE+uWGGgNoMJL+MKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB7624.namprd12.prod.outlook.com (2603:10b6:8:107::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 14:12:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 14:12:10 +0000
Message-ID: <a0ab4c28-918f-4883-bad7-35b048202089@amd.com>
Date: Mon, 19 Jan 2026 08:12:08 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/5] crypto: ccp - Add an S4 restore flow
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
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
 <20260116041132.153674-4-superm1@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260116041132.153674-4-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0168.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: ea7b714d-ff12-42db-5897-08de5764bc75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejRJZDViengvdExTZ1hNTWRFc3hJSlAzL2lDdVUrQkhxM1RSRkZQV2pRS00v?=
 =?utf-8?B?ZUovSm41ZGtUUXprLzV3cVlEQlNWQWhVVU9xdzFkcDAzUzlYd0hZSng1WjMx?=
 =?utf-8?B?cWdIM0VkdWVLOFBRbS9SSTByejNYeTlocHhRbm43dTNFQ3E0YXJ0d1o4SG0v?=
 =?utf-8?B?bmF1T0NYMUFxUE14d3NPSld5TXo1cXMwMndnS2ZGWHR5b2ZMS1dyVVVpR2c5?=
 =?utf-8?B?VytIam1Gd2NFL2tRWFZhRzFHeHhUeFFYMmVBZndxbXdtZ2VCUitVRzdzeHV6?=
 =?utf-8?B?T3VBYU52RVdzcDM2Q3FBZlhXVlZFWG1yUUlwd1FoWi82ZjBXZ21aL3ViaEFN?=
 =?utf-8?B?SXZkZ3FQalg0MzdndmM4cUVtamxCRTY3MG9NZ25vTlc4ZVExaU11d3EvSlRE?=
 =?utf-8?B?YUJPZC9yREo4MzhBZ0JpL2crNUtDcVNZeTEwdGZIb2ZMdFZmY0VMbXZlOHNm?=
 =?utf-8?B?bFc4blNMS0FkRHhFVnNhbVN5cHc5MUlTemg4dUdjL0RmSzkyajU5dTZ3dG9u?=
 =?utf-8?B?VUgwZklRZHloRTRaNi8ycXBvME1xbFhFMDAzVWkvOFhxWXZvQkRBQXpZVW8y?=
 =?utf-8?B?Zlpuc29SYnl2cmZwMy9xOFY0K05QYk1PU1lDS0dGcjhhdWMxWENQRERFWWpQ?=
 =?utf-8?B?U0dZbjhuRzBOMzNuVVFvbk1qT2ptS0FXMFVMUXl0Ty9DZ3hzQ3VsOFltYWVS?=
 =?utf-8?B?eE84dzFFQXVpanY1WmZaWDJiNE1wT3FvL01oREkvNHc1L3FNNDR2N2RucXVH?=
 =?utf-8?B?QVpqczF2U0x6Vk5pUGVNOCtYOGlFcWl5L0pUdzdGbTVuekorV2h0VUtnMk9r?=
 =?utf-8?B?dU1xbUQrbngyaEF3ZUVMdW5CcDMzNnRQMWNsRGNFd1V0elFOQXNXNjEwcmhl?=
 =?utf-8?B?V09oQ1BBTXVuU0tpRS9tQkh1ZFdaMGlVTHdoanJNamF4YVVrUTBITG11TTl5?=
 =?utf-8?B?SU8zc3I4YUFOOGYyQzF2aXRpOXZ2dW5RQU5rTXhWWjc2RWJFb3BOL0lmNXht?=
 =?utf-8?B?Z1ZXU0ZtbW01UEVwdENlUnBBODIyUEkvSEFpWmNLblhXWjdYQ21RVkZDYzkv?=
 =?utf-8?B?NzM5NlV0bDBOa3AyRjlLSS82RmRyVmxMTlZzT2NRUzF4Vmw5YkJUQmRjUzdI?=
 =?utf-8?B?VFN0NmlnYmg3VGtRc0NEVk9ITXdXMmtDM3ZvajhoNHZjRUg3SHlEeG0zM012?=
 =?utf-8?B?MHBJT1RvR2oxM1VJa2lTOUd3dHJnY05xWHVZa0pzd1M3cWRYZ2R5azgxSVVW?=
 =?utf-8?B?MHFJMUxnV1dGMWhlM0dvNy9kRkZCM1NpUzdxN09OUE04VXdZaFgrWTZiS0ZJ?=
 =?utf-8?B?Yi9nbXg3VGVObXZVN1B6cHJxQjRjMG90Y0l0NmdQekVUMW9lNDFaSHdJWVA5?=
 =?utf-8?B?VzFXVzkzOHpOVVV3VUxWbGE0MzcyWk0rL2xHSUl2c0ZQWkpFT2F5RVNPbFlk?=
 =?utf-8?B?ZC9Cait0Skl0aU02QzRONWpBWGdHVkgvMDhGUU5ybjVyWFhXRkE2TEZURTN2?=
 =?utf-8?B?ZTVrQVd3dTlWL3B1ZGJEV1I0ZG52RUNRRGdHdk0yRTZMOTJta3Fjamx6RXRN?=
 =?utf-8?B?OGd3dGpyYmJCL243bVFXRS82cmN3Y0JjMVRBSGRiZCtTWm1Ra1grMkFGLzBp?=
 =?utf-8?B?Mm1tQm0rZm1pRmN0TCtmNWxqOC9lRmNkc29oRk5qUWR3d2t0elJaUU92cFNQ?=
 =?utf-8?B?T044SlQ0dEtyeWx2WE81dXFTZStRU3dXTi9FRzRrVUpxaGtjU0pmSmJKYUE0?=
 =?utf-8?B?MFY1RENaQ2QzMEZaUEUyakc0bjJRV3d0eHRXWmxKS0l2QmhxZGlpTkt5OHVD?=
 =?utf-8?B?TzQ5QUJ1TzhqWmRXSE5TUTBpa0tzTS9wdkM3WnhnV3V3MUZ4dzZETFJITkYz?=
 =?utf-8?B?SjFaLy95VlZyc1hJODhkYXpBMEFCNXBxaFh5L0xMcVdRMXl4eGlhWVdOcXF3?=
 =?utf-8?B?bFRMV09vaTRnZDg1WFgrQStmWjFQQkVYU0FaSXI5K2ptbENPSWNvclVsMVow?=
 =?utf-8?B?WjNiaktRTkJuYVJpRG1Fc2xXUlZ5TmtWWTU0ZmRzb1ZJN3NkSm05akwxR3Bn?=
 =?utf-8?B?SW9sVWR4N1krcmkrdXVUcit3ZEs2QU1yUkNaTDU1R2xtUHR5UWo4N1FnNS9H?=
 =?utf-8?Q?cIw48jybMr8lQi1eeigQ3tT7K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N21mQzNaejlTMi9Ea3NURkhoY0g1cy95bUNLcjkzMktoYzFaOVlxb3VtUUg3?=
 =?utf-8?B?WlhJRkY3WCtTckxmN0Q5NG1RejRobXFFNEtkcVZTV253cFdCLy92QWs3NGFQ?=
 =?utf-8?B?cWNXb1NwYUZpcmFaUGI2NjR0WVpPTDNPUXUvSjh1N2d0c2xLTGJIUjZILzhY?=
 =?utf-8?B?SWRmVng4eGhKM21JR3dOaHQ5VjdlenVjeUdZVnNQR3JPYVR2RGxXYStkRTJ6?=
 =?utf-8?B?b0orZWRrZHgrZmhnaTdIK2NnM0lRZUpVT3VxenVjYTUxT3czT3lGUmNFdlpw?=
 =?utf-8?B?Q0U5NnNPb1FQSTZKTnBpZ004YnphQjREOXpWYjNjZHpjcUhSZENsWTBnbHMw?=
 =?utf-8?B?WUZRMTFhemdoZHJZZmk1RHlSU3R2RlBKNEVHRDhyK0w0WFhNK2I3d2s4SlJL?=
 =?utf-8?B?d21xOXBrZlVUaTBwNlIvaUFzcE5yZVZDcGpjc0VncXZPR0w0WFJTbWNKc1dj?=
 =?utf-8?B?cm43dFVOS1BIb0FXa2lkcU1aMUlHeW9IRi9LYTdTKzNHUW1mMFdhcUtCTWpT?=
 =?utf-8?B?MWRiU1RicENnM3JWVVBKbnBxYmtCNHZkVjkrVE50aFdpanFjeFBxN3pSNDc3?=
 =?utf-8?B?c3hNa1VzUnRrUEpVSnJ6UE5iRHJvQXprdGFMT29TVlBCYVhqSlZTQXlVWktx?=
 =?utf-8?B?WjJWQWZSVnYrcXVoRFBubXRSY0o3SHEzREZ1clllN1podTVMaGQ3NU01RjlJ?=
 =?utf-8?B?amg2WVc5c3VVSUp5UUd2T0lrMkRyMS9HNFh6R1hBcXBXMUR4OEprdkY4ZjRE?=
 =?utf-8?B?eWdlak5SVEFma3cxdWtMMFdJclRzWWR5R0dTTWdFTk9qdGVXRzhja0E3MmJy?=
 =?utf-8?B?ZW0zQTRwQTdhNnNHcU5PUzJCRmdweWJxVnRXL2ZHSnMvM08zL3BYaWF5enlx?=
 =?utf-8?B?QkcveXdoWVR1V0JKYlNYU1l5VGxvS1diSXpOM3c0SUkxd0twRExWZngrSS9p?=
 =?utf-8?B?R1NwTThZbWUyOG9CMjJLVndlTUtSanVXMmRRZTF1Rzl1ZW5WeWxxRVgvcDB5?=
 =?utf-8?B?bjJmSjNLQnRwU3BxbGJyNVlnc2lUUUUycDVKTU92czVHb2s1aU1KUHFPbUJv?=
 =?utf-8?B?aG9BZjFDeE53YzVKWVZjZmNNVE5YZkFPMHFMaU96WTFRZjBFZHFuQlJQTTNj?=
 =?utf-8?B?NmdLZ0padjhzTHlseEVUMjJNaDZjWGZYOWg4QXVOMm94c2pLdEJscVpVUUJ6?=
 =?utf-8?B?MEhLbTlvaTRoWnFDR21tN0ZzSUNqVWxzZU40ZEc4dlAxWGdBczZpQ0lEQUV0?=
 =?utf-8?B?aThreS9FcUcrdzRHTG8rc3hpQ2hITjhQUGtWcW84aHhkTVdKN0hOak51MG82?=
 =?utf-8?B?L09JNkFRa28rRzJkUGRlM21rR2ZtNm1tbXhFeTRSenFsTlBmY25ua3J4cTIz?=
 =?utf-8?B?cm0wTUpXV2lteFJ4eHplanppYmJmOXVpdXl1QWpzTGx4ditNNmFKK0FHRFRo?=
 =?utf-8?B?VkhWRnhtRERoQWZpNFhIS0Jqb3JjY0ZvbWlWZFI0Mkl3Si8vNXpIZlVZZ3hn?=
 =?utf-8?B?ejUrMnZRdHVJOUdZYVQ3Wk5NNXhiRjQ1eEd5UDVsMjBWMlN1TmpGa2F2OW5t?=
 =?utf-8?B?c05VWFBPUW00Wm1ERzk2ckR6YzczOWhzTmdjQnNHUnpodHRCTFRKWlZ3VEFB?=
 =?utf-8?B?bHNrc1puM3FoNkl3UkZWZlUvTnFFQ3dTS09KUUc0SFYxdmpNdHQvOU5Temxn?=
 =?utf-8?B?ZXBla09ZRU9PZ1F5YTkwWmwyZVJGbmRuejhjRUFpeW83d3RNbnlVOVpPaTRo?=
 =?utf-8?B?KzBoZVR4NTZOUWhIN3o4UGZHd1BkbldSNkh3TE1aaGpoanBUMUNYY0ZvdW9v?=
 =?utf-8?B?VG9ScW4yY3d3bFdGODlBSTIxcFJZMHQxVEtnYjVMaUF2aGNvVWhmU2E3SDdt?=
 =?utf-8?B?RFEwL2ZwNDAxL1FQbjZIVW9XZGJLUjc5NnVpNXg3SDJ4SUhneXpNZll3L3JL?=
 =?utf-8?B?VE13eFhyUEtoUHBaSVlJbEp1dVdyL1ordk9IY1lUN0dHUTNpQUV6WmZFMk1l?=
 =?utf-8?B?WHF3ajEvRWxNcjZNWkFqSnovbmVITFdBWjFJUmprOUtyejJiTmgwVytrV0hO?=
 =?utf-8?B?c1k1UWo5NnA0eTlObndqVlIzb2U4VmMxK0tLQVRRVjBKTWFWSzVYNDVnNzhz?=
 =?utf-8?B?NUNrZytEV3E1aDRxUTVpZCtWU0JrbFYwajlEYWhHcmxKQlh5NUxJZ1p5SWJE?=
 =?utf-8?B?NVgyY2QyQ3VDYUFSdGlKZWpOUUhxeFY0NEMwVnl1S1QwZlJucVlyMUpRNDhi?=
 =?utf-8?B?VXZNMm1pU0cxbDRYSHhjcWZiL2VHTXVQbTJiWEptK3B1dCtoVjc3dTRTODY2?=
 =?utf-8?Q?/CVY1MgiHp4peFIOKl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7b714d-ff12-42db-5897-08de5764bc75
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 14:12:10.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/mvXpJzUGa1c+GrHNvHQGJdjik9siSuItIbjgXyw9eqX/QOqsEQW/eslFDG0UFBVgbbA7KNRyd32CySbQ/eXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7624

On 1/15/26 22:11, Mario Limonciello (AMD) wrote:
> The system will have lost power during S4.  The ring used for TEE
> communications needs to be initialized before use.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v6:
>  * Add sp_restore() flow (Tom)
>  * Drop CONFIG_CRYPTO_DEV_SP_PSP conditional behavior
> v5:
>  * Fix return for psp_restore() (LKP robot, Shyam)
> v4:
>  * Add tag (Yijun)
>  * Remove blank line (Ilpo)
>  * Adjust whitespace in psp_restore() (Ilpo)
> ---
>  drivers/crypto/ccp/psp-dev.c | 11 +++++++++++
>  drivers/crypto/ccp/sp-dev.c  | 12 ++++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  3 +++
>  drivers/crypto/ccp/sp-pci.c  | 16 +++++++++++++++-
>  drivers/crypto/ccp/tee-dev.c |  5 +++++
>  drivers/crypto/ccp/tee-dev.h |  1 +
>  6 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 9e21da0e298ad..5c7f7e02a7d8a 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -351,6 +351,17 @@ struct psp_device *psp_get_master_device(void)
>  	return sp ? sp->psp_data : NULL;
>  }
>  
> +int psp_restore(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +	int ret = 0;
> +
> +	if (psp->tee_data)
> +		ret = tee_restore(psp);
> +
> +	return ret;
> +}
> +
>  void psp_pci_init(void)
>  {
>  	psp_master = psp_get_master_device();
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 3467f6db4f505..f204aa5df96e2 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -230,6 +230,18 @@ int sp_resume(struct sp_device *sp)
>  	return 0;
>  }
>  
> +int sp_restore(struct sp_device *sp)
> +{
> +	if (sp->psp_data) {
> +		int ret = psp_restore(sp);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return sp_resume(sp);
> +}
> +
>  struct sp_device *sp_get_psp_master_device(void)
>  {
>  	struct sp_device *i, *ret = NULL;
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 1335a83fe052e..a83751cfd0060 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -141,6 +141,7 @@ void sp_destroy(struct sp_device *sp);
>  
>  int sp_suspend(struct sp_device *sp);
>  int sp_resume(struct sp_device *sp);
> +int sp_restore(struct sp_device *sp);
>  int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
>  void sp_free_ccp_irq(struct sp_device *sp, void *data);
> @@ -174,6 +175,7 @@ int psp_dev_init(struct sp_device *sp);
>  void psp_pci_init(void);
>  void psp_dev_destroy(struct sp_device *sp);
>  void psp_pci_exit(void);
> +int psp_restore(struct sp_device *sp);
>  
>  #else /* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -181,6 +183,7 @@ static inline int psp_dev_init(struct sp_device *sp) { return 0; }
>  static inline void psp_pci_init(void) { }
>  static inline void psp_dev_destroy(struct sp_device *sp) { }
>  static inline void psp_pci_exit(void) { }
> +static inline int psp_restore(struct sp_device *sp) { return 0; }
>  
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>  
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 8891ceee1d7d0..6ac805d99ccb3 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -353,6 +353,13 @@ static int __maybe_unused sp_pci_resume(struct device *dev)
>  	return sp_resume(sp);
>  }
>  
> +static int __maybe_unused sp_pci_restore(struct device *dev)
> +{
> +	struct sp_device *sp = dev_get_drvdata(dev);
> +
> +	return sp_restore(sp);
> +}
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
>  	.cmdresp_reg		= 0x10580,	/* C2PMSG_32 */
> @@ -563,7 +570,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> -static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +static const struct dev_pm_ops sp_pci_pm_ops = {
> +	.suspend = pm_sleep_ptr(sp_pci_suspend),
> +	.resume = pm_sleep_ptr(sp_pci_resume),
> +	.freeze = pm_sleep_ptr(sp_pci_suspend),
> +	.thaw = pm_sleep_ptr(sp_pci_resume),
> +	.poweroff = pm_sleep_ptr(sp_pci_suspend),
> +	.restore_early = pm_sleep_ptr(sp_pci_restore),
> +};
>  
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index af881daa5855b..11c4b05e2f3a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -366,3 +366,8 @@ int psp_check_tee_status(void)
>  	return 0;
>  }
>  EXPORT_SYMBOL(psp_check_tee_status);
> +
> +int tee_restore(struct psp_device *psp)
> +{
> +	return tee_init_ring(psp->tee_data);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index ea9a2b7c05f57..c23416cb7bb37 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -111,5 +111,6 @@ struct tee_ring_cmd {
>  
>  int tee_dev_init(struct psp_device *psp);
>  void tee_dev_destroy(struct psp_device *psp);
> +int tee_restore(struct psp_device *psp);
>  
>  #endif /* __TEE_DEV_H__ */


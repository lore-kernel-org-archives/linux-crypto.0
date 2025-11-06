Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010020.outbound.protection.outlook.com [52.101.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DFE29BDBF;
	Thu,  6 Nov 2025 20:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762462194; cv=fail; b=NCqVM3UV8xhZQGg1OEjxER33Fa2o+AefNYCRZ7fcrurAenqAuKU8ghCJwI4nH04uXNAqbYEr22LUNmnInM7kYLTCiPf+iyNFoTkOwbOWG700TGHETTtjIBb7V9r+mNRDHHry9Ev3vx6XYpA8P0GsY1beYYagolVp4qamUeLI/C0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762462194; c=relaxed/simple;
	bh=k+IrRBxLqmJzNTkmQEm6O1EKO683G8fR9+se4tYD260=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gUaQrNTLX78YmDzHgTB/UKp4bfZnumZEPw9ygP+yWNYPn5wQijwLAnX+LmCFRkjAB+UcDVDBmG8Ncw37DRQF1PkWu3ln2JPLWCuJn3F/Gu8T1uTx9wy9kZVf9TH9OLuIAXJ0iIv+jv8Kufmo+pKArhYM9FL3LHUaQsAwxEC6iiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aagTMOvu; arc=fail smtp.client-ip=52.101.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aagTMOvu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBSOPYoJUaxdOlOfcq196y/LR2fLMSyFJZJHwVezzTG9Qbu7kA4hxWrw+wiZoPsBorYmODkBdscO/gXPQ5nTLFjdR4/0NjbF6xjeUUGp8+C59WiNG5zj0kI/WCAkl7TakbQFxARaAuqTtoaQErxGpL6t/gLawLO+axM/fLoq7HmfaFL4pY6QEeLZXC5N1lFA1iHTmXjw/BSkr+JP/DF5tuDwgbZEMHDJ89SjKyzyP8efHzhrrHG06ZV0NBVAm0mH8dEdLoU4ROgjqW7SqQn9IyaSiPzL5GKQgiulBJq9CTuiMWZOeaVvKIQBZOKgtZrRp1z8FM31kDy0dfIqdZ2/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCORJ4cSzI4vpeFbCn+Nt3wQpNPQilGdFbuM5oYicdQ=;
 b=pSb1J+FsMpZ8yf87gvcGfqnYdKv9iyYH3MyFukbdNoJMYpdN1BZA/5/ScdQoDBvg8h35Voob3qGgpVXOZMMfqxkRaVV5WYwKJBZ3c+u7yj40LUsIDcYoJtjaRkdNHE30WjXMFzFWFaYZ88A5PsPg8gDWGYs0KtcCUm4ue58XBJTB/ipJ7XdYWOcEwQJ4gH80BOV1UlPvTnGI5E2wXGDS+gZZsoCLEQtLxLIWDG6kaIsrLyU99nFAVOOofoAAJV1yzsQNrK06JitUwSRKya1jrbwOLLNtiNonYwnx16Y64YVsUw0e1sNBsQZTVGVcXeV6zpo1twXz/fOXQoMQil9Ivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCORJ4cSzI4vpeFbCn+Nt3wQpNPQilGdFbuM5oYicdQ=;
 b=aagTMOvud+4Lk2b3awNfY6T9p3BhE/BwLV4MtjsxuggYhhD7NAzyv1kLfk3qW9QXuExq6re4cN4LC/DQw8/WhiRn0l9acmUe7J39JpSnuvbKMkMboS9+RrDfZqkkCQzKqcJH15jFMx/+t46aUVm27mrMQAXg9lKM4e20UyB6txE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Thu, 6 Nov
 2025 20:49:49 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9275.013; Thu, 6 Nov 2025
 20:49:49 +0000
Message-ID: <9b4ea41c-9079-4a49-a598-6ab0b4f885ba@amd.com>
Date: Thu, 6 Nov 2025 14:49:46 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] crypto: ccp - Simplify with
 of_device_get_match_data()
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Scott Branden <sbranden@broadcom.com>,
 Jesper Nilsson <jesper.nilsson@axis.com>,
 Lars Persson <lars.persson@axis.com>, "David S. Miller"
 <davem@davemloft.net>, John Allen <john.allen@amd.com>,
 Srujana Challa <schalla@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@axis.com
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
 <20251106-crypto-of-match-v1-5-36b26cd35cff@linaro.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20251106-crypto-of-match-v1-5-36b26cd35cff@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0005.prod.exchangelabs.com (2603:10b6:805:b6::18)
 To BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|BL3PR12MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: 83839377-a687-48c7-871c-08de1d7606de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXVXRGcwZkJLRENQUU1QZ3U0SUc2ZFplT3g1elZKdUU2NCtTZm5PTWw4MDFz?=
 =?utf-8?B?UGRUTG9pTUJaMGk5NDhOM3V2M3VwbVBKL0xEZENmWGNNS3FnRGMxSUFBVndI?=
 =?utf-8?B?NExSTS9XcnU3SStiYkdWZWFTV21QTXV6eTZValFJUXhneGFTc2thQ05nN3lV?=
 =?utf-8?B?UEJRZWp6dXM1TDEzaGdJOWdGSTR3STF4NUpVZHE0bk1kcjhEaHFXU1p1azla?=
 =?utf-8?B?NjF4ellGeUFRWUFtbUdtTnpkcGsrcmY4Qm9YT1R0dEdmRXNnV1B4ZE9oam9k?=
 =?utf-8?B?ZzRRenZnVjBWTzVtU2NVNmQyRjN6bjl2RGxyb0pYbzFaeE5aRG1UelJoNFpz?=
 =?utf-8?B?U0FrcFM3M2Iwa1pDZmNPRGIxNHBjRnliNXlKY0FLTWZqMm55S01yZFdmUGJs?=
 =?utf-8?B?WVVpTXo4NCtSdENDeVNVTDUxLzNrQmV5eFd4QUV1dzAzU2I3a1ZKT25TWjRu?=
 =?utf-8?B?Ri9zNzB2UytYMkhaMy80ay9QWFVyYW9zaUFHUmF1R2xzR1ZSOTk4ZUpacEdM?=
 =?utf-8?B?MHMyb0RVSHlkOGpucHBYTjZWQ0ZyVTZvS1l0Q3ZVckVreGozQWVrTUJhMVQr?=
 =?utf-8?B?OGRMZTM5SUlQazJCTXVaU0Z3Q0ZHK2Y0N0JKcDhnQmUxTlhNRU03NXppRHo2?=
 =?utf-8?B?V01WR0h6dkxHNjVEUG9aQmpZNU5CS0NPajR5c204aEI1QzZJVGVYNXZzTDJL?=
 =?utf-8?B?dVNDSFdLUWM1elNqdVhDVmY5QmxrZFY0ODNHUmkwell3NkxoWnphcXZWVU9T?=
 =?utf-8?B?NzFPS0tlcndqUTl3R2pGWVh5aWFwNTRIb2dEQnE0ZDUzNmVxeHlqdFdJVkU2?=
 =?utf-8?B?RW1RdUtjZk5BTWJ4MnlleS9XRUlBYnpDSUFGa2tNY0ZYMGVNZS9DQ2MrY1Fk?=
 =?utf-8?B?ZlJHbVVaQk1NYVhLdU03eXdBNVBpUUdTSkhraXgvWVBvTE5vMFBqL2FzaU5m?=
 =?utf-8?B?bEwydGdMYkp3S2VmTGM0VFA5ZGxjMEVicDFrd3ZQSldmbjA4NnlXa1BzWFoz?=
 =?utf-8?B?NGNvL3BxajFoRE8vRGQ1UVZuYnJtSHQvMGRPMEVUL0RJU1dBN3FYMVMxY2Ra?=
 =?utf-8?B?bFNLMmczNlplSklFUG1LdFhhQS92WXRqOERKTnF0cXp2bFh6TDNNNTZhclJx?=
 =?utf-8?B?Tlk2TUl6OXNXVkd3YWJ3L2NsWk5QT2ZXMnd3dFBaM1cxNERqWFg3RGtYUHFm?=
 =?utf-8?B?cFNYWVRyRlF4UEpjZmROUERzb0g0cjArT0FoY1ZDT3VSaGpac0xBaXBURDBD?=
 =?utf-8?B?a2dRajR1MU5waUtLR2M5Q2k2TFhoaG9jM3RGK3dtRDE4RUlOMGU1N3VpZjdu?=
 =?utf-8?B?bGwvRytNajlCZDVYcW5jWXhaMTJkN2ttUlc3cnZ1T1ZhUnQ3ZU5LamU0Uk41?=
 =?utf-8?B?UzlpY0ZBeG8zMUxCRGx6K1Y3c1BBaEp3OWUxTisrdWx1a05kdjhFeXloL252?=
 =?utf-8?B?dGVoVDlURS9iSVhFb2dQL0JsTys0dXFtUE5IUUxTV2p3MFVJWFJsQTMvejl4?=
 =?utf-8?B?Sk1WcDJRcTMxNUF6V0Z6L0pPeERseWc1YUJETkdLb3h3UWdLcDBlQUVrZXhD?=
 =?utf-8?B?cFd6RTBRYzVpaTZrR2JhbVFYRTVXZ1dTaEJWbGFiczFVbE9vazl3b25zdExh?=
 =?utf-8?B?aU5HUFhRa0tSTE1aaFRld2tpOU9WdG82RUhsUm5KSDduaVQwOWtoMy95a1R4?=
 =?utf-8?B?QWl3NXZVMmk2TnZPYVQ2SVlrOThPVVVtazhqeVV2QThYY3g3MDdOZS9RMWRk?=
 =?utf-8?B?Z0lkMlVJamM3Z0tublArU3h3ZW9NRU1MVGRsZ2tIVGg0M2E4alFESmt0d0pU?=
 =?utf-8?B?Uk13SnRNTkdDSzlSQzdibGM2dzBma1FLOHFjUEtUejBiT25sQ1pYK3RlUm1H?=
 =?utf-8?B?ejFGalRXR1RXV1dFVDNIYXBDYTg1aVZmNmp6QWZEaDQraU9oN3FDcmRMc3FH?=
 =?utf-8?B?WWh1UVp6b2VRbnJFWHFtUHFGd0NIYzlGMHhYRnlyTFZVM3VjSmJzUzNzZVFV?=
 =?utf-8?Q?+WuRcGb+IM8EQEuwjRu4+LFOFSCG5g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEZzODFIV3ExVFQ4em9yalNHaFZEWnZMOEtWcmZMVkc4aW1xN1ZyTnZiSWJM?=
 =?utf-8?B?M1FyeE04NXNTc3o3ZE9wZGJEQmlnbUxSV2NuSlJha1JSRWtzS0ZiK25teVNu?=
 =?utf-8?B?ZWJINEhRR20rRG1WeU5CTmFvSmdEZW44V2Z4djZzNDJZREdrNzRvNjJEcmZI?=
 =?utf-8?B?K2pyVVNmOGpqNlZSK2l4V0RwcTNDR094dWdycXF3cFpiZWdrOU9PTnkxY2VW?=
 =?utf-8?B?dS8zOGVpVlZOVmROQnN4eWdWSkRuNlBnNm9LeDR5SDZacklmdE1lemROL0FF?=
 =?utf-8?B?MUFhdEFVa2hoVlQ0dFd6cmVwRE1MdVc4dVpTb3pqeUJQa3BoY1FEVkJrSFg3?=
 =?utf-8?B?Um9CR2hGSnJ0eDZZOFFqeWt1YXovWnRmV0JhY01tS1FJS0M0MDVnMlAyYmFL?=
 =?utf-8?B?MGt5UGw2aGg1MWFSc2pOYnFDS0Z3Z040NGZpT3NTNVAzaStmbTZMTlhndGxi?=
 =?utf-8?B?cWFUMDNOaXplTi9GYW5WeURKOU1RWHdaK0krK2xjMEtzQ1FKNVFGVEgzMVZ6?=
 =?utf-8?B?N3RkUkhaU2hwZzlHblFJQ3JoejNZUjA3UUM4R25OS0dTTXMrYkRTaE54bTJo?=
 =?utf-8?B?dUNXblIxWlZPd2ZGcXVlT3B6dGN0b2Fyc0lrd3crK0c5c2RyQ1ZXaDlzTG9a?=
 =?utf-8?B?NHdqdFZGMUIrMTdWa3F5OWtrL0wxY04wMGxUWlc5VEgvSUFlczdXM0pwbElu?=
 =?utf-8?B?OGhGb1JMb3JqeU5iVHJkK3U1VnUrZFBMRnRVcHkyU05HeVNvYUxac2J2bVFE?=
 =?utf-8?B?dUpiODkrN3Z0MENrdzVSK0NLL2oyY0ovQ2VjQ291NWxaRXZRKzd1ZTlvRy92?=
 =?utf-8?B?dWt5NjR6MGh6MWVYb3U1bWxFczNGdVRuSUwzZGk5SVNyVmduaFVzeVNBRGZx?=
 =?utf-8?B?ZElzVHZPZnIyY2RhK2d1VDV1MXppS0tObnRzQ09TVE14RE0vbGsyZlViNVNw?=
 =?utf-8?B?SDlJV2UyS0MvZUlDd3UwTHNORzZCU1JNNzJ3YVA2dUJvUHFOY2Z2OXpLbGp1?=
 =?utf-8?B?TXI4SHk5MkU4cDZvZDRiYUg3SkVoVlE3dy9Kemg4RGE0QjRKNTNaRTNDeHRO?=
 =?utf-8?B?Vlh0bDQyRGtQcFNyekFIR0hrZ00xMVM2R3UvNmtlbkt0dDBaYW0zamdDY1lU?=
 =?utf-8?B?T09Cajc0RUhTNFdTRzBIRmZhNUVpWWN3QzJpczhwM1NjUkRiLzUvWldZN0tx?=
 =?utf-8?B?K0d1aXhjVDY5R1dLSnczOVM4Q1VEai9ZZmRnM0dldGRFclFvN3FnQzF4WEo5?=
 =?utf-8?B?VWFvN0JIZm5TVHA5ZDd0ZVArQnp0Z1poSzNKRUVPNk9xOHpaSG41UCtnVzFt?=
 =?utf-8?B?cVh4MjdiOHhRd3o2SU56TFh0MjZmNFVwMW5FZUdrQWVwUllobDI1bTYrcFcz?=
 =?utf-8?B?S1NiYmgxcHZmL2k5eEk0enNjU0NCektDUWt6dzI5Ykt3K0lYYWxZL05HQ3Ry?=
 =?utf-8?B?ZWdWVm44WnpuV05NWUg2RFNxUWRFc2xNemxPZ1N1eGVuaGY3SjZ0ekp0SDRj?=
 =?utf-8?B?MitaS3BDZHBKUVFMaDdpWXd2WHpPc3ZSWXRmdSt3bHI2QWlrcW51ZlAzNnZD?=
 =?utf-8?B?OURubkIyQ3FYT3o0cC9tMXJ5NjEyM2xlNVpRRldWREZtZWY3VmduZVprSkxz?=
 =?utf-8?B?U1I3ZWMyS0xpVmIwYlhDbTgxaytNcjlhZGl4V1Iwc3JBYTd5aDB5SjhHVjht?=
 =?utf-8?B?Mmx4bjNLR1IxMFR0NXBjWndiR1FRS1ozVE0rV0YrR3dIWWIzTDZpNFZLSmZp?=
 =?utf-8?B?d0x3bmVtNUpDc2FXK1ZsVDJEVHRTWHQvUUhGOExjWXpXajBFRkFmdlMyTXN1?=
 =?utf-8?B?a1o4VUg2Sk9DaE5vaHBtazAxcUJ0OFd2anFxWTgxbXpvcVRpaEl0UnRLb2wx?=
 =?utf-8?B?dnpJOCtNQktHZHJSZWpHTjFIS3pvZmRBV1RrSWg2cFF0QmtEamd2MWtmdy91?=
 =?utf-8?B?bVg0TTgxK3VGUmFLTXF0RjFJL28wc0pMb0FDMHZzT3N2Tm1CSUFmOXJjQjhQ?=
 =?utf-8?B?Rk12RVZPZEFMSlZSclNKdENENUsxdmIreWZSUkJVcGJVNnMvQUxLbWdLOEo5?=
 =?utf-8?B?U0ZwQysrVmRmb2FNLzFWc2hDVE1MLzF3cFBXWWxoWXZYakt1ZkxKbDBVVHIr?=
 =?utf-8?Q?FRAiMDHIfAyBg7Dv0LJ0RlzQB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83839377-a687-48c7-871c-08de1d7606de
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 20:49:49.5518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNQHuIMlgi/b44l6D3WeEUwXhxdRTcrT6R6vGXqviyPxNwhetqh3+OEgsrBSLKA3UEdZgoC+BABEDnCm+7c/4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474

On 11/6/25 10:31, Krzysztof Kozlowski wrote:
> Driver's probe function matches against driver's of_device_id table,
> where each entry has non-NULL match data, so of_match_node() can be
> simplified with of_device_get_match_data().
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-platform.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> index de8a8183efdb..3f9843fa7782 100644
> --- a/drivers/crypto/ccp/sp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c
> @@ -52,17 +52,6 @@ static const struct of_device_id sp_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, sp_of_match);
>  
> -static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
> -{
> -	const struct of_device_id *match;
> -
> -	match = of_match_node(sp_of_match, pdev->dev.of_node);
> -	if (match && match->data)
> -		return (struct sp_dev_vdata *)match->data;
> -
> -	return NULL;
> -}
> -
>  static const struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
>  {
>  	const struct acpi_device_id *match;
> @@ -123,7 +112,7 @@ static int sp_platform_probe(struct platform_device *pdev)
>  		goto e_err;
>  
>  	sp->dev_specific = sp_platform;
> -	sp->dev_vdata = pdev->dev.of_node ? sp_get_of_version(pdev)
> +	sp->dev_vdata = pdev->dev.of_node ? of_device_get_match_data(&pdev->dev)
>  					 : sp_get_acpi_version(pdev);
>  	if (!sp->dev_vdata) {
>  		ret = -ENODEV;
> 


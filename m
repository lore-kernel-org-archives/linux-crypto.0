Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010036.outbound.protection.outlook.com [52.101.193.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF66821C160;
	Sun, 18 Jan 2026 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768750243; cv=fail; b=ERbQ6VhTteeh7f7FlCCoNU0Ac0ACCc0bjPvcEuVOkgZ/wgW58YnvjXaUyzq5E7zwIfbiAd4Uw/+jg1ZaYaODTAgE6Z8vWrnzV0y62xC/lI8m6gA83DONs/GV6mdOOS3pb7Ku4Z+904Vud4batahfX/ZTB/uTFVRw6QsvtMg2o4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768750243; c=relaxed/simple;
	bh=EYVa7jHc70bU++OFDBsuGqX8T0rH2RVpDHMb2FVQQ/U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lctc6z5eR1S2xZhPtylJt2mlMnS9+skkrvX2dqxAeyWv/W3kOHfbSklBxfWCXSWVCfEenCUMXTabvvWE98k/nlfVHS/Yd+nwF2nzsk2sC8VigTpzeGXatVGGC68iL9Yifb9b0bd7cGoR4robgxfIZuaq1rNbLzu3ty+AerCC8vU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IZ8TOYF1; arc=fail smtp.client-ip=52.101.193.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IZ8TOYF1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=StvJ73Y3g4TE+mWqXDXa0jH+tgss8HdFe4XaWNZhlOmVJGMWJ6ZMivfGiTk78+0CN3NiJMgD8HBskguwRVNq8D0rx0XxmmDOlFzWglXaGexoo13YLxIuzenAwqQu4h0ii/ga876kJ7epDSO93lvEWCYM0uW5Bxbk1g3DmgTLm6RGd0PaRlKOps1Hx4NT78NCSvisy2VYKlhlJhjTBJcBsnSus/9PprFMyopTqQY2ygo4tIl+yFLYgmzIeun869x0mlwAM/CZPKe3MVxI3CtChb6aL/0Ea8ps6fzcW72Vlt5nrdBdYPLWprRcK6T3aVmOMReiJ5XAiIJRzyF7Q0yqkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vhckrqunE0SYKJijqwOVC1KUquYM/CyQCGDPfYsPAY=;
 b=K/FCeyow+MoAm+sBcQ2pI45dsTR1G/WLxA0id128TigSy22YSEa9Op1mu8/fd8goS6Yx1yT5V9HXIsCP3xcr/5DoJm5PtQ+hXUZW4ChPl4TwtP7oyXEIALonE7idyvq/tI7WNVmuPXwsJFJREP7j9kBc6i86V5UXs35tVYTTY2ozfAjlTWU21hwZ/2VBd05y4flF75xTYm8S52YoCwBKLKlDjQYzfP6obr4gPVhEVtA0FiQcC0TpjLBGrrSXHbaEXF2pdIo0WRpGrJudUDRCt+rYjCepCxTLMhH6SHMIPsBhTC1/O6Op/3dMTlAFsYcn3+KGi4e2uxMsMT0BT8eLmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vhckrqunE0SYKJijqwOVC1KUquYM/CyQCGDPfYsPAY=;
 b=IZ8TOYF1xtWsFR4JwThX64Gf5AI6Afiow5pJG2jAGNGwB/ylQakTiWxA8hExwGeVKH/Iy8eWbt8KUpYrv/ffpg5DhsEUq1GabS18eVBRuQ+HimTXEEcqUVvX/0q6b9d+zKQcZu4EpA5rh4iqxaEGBLdxwGbHHh5oB1sUbp4XpKU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.11; Sun, 18 Jan 2026 15:30:39 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9520.009; Sun, 18 Jan 2026
 15:30:39 +0000
Message-ID: <cd5e0cde-d0d2-4b0f-b970-6eea003c1e9d@amd.com>
Date: Sun, 18 Jan 2026 21:00:31 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
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
 <20260116041132.153674-6-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260116041132.153674-6-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::20) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 63d9432d-843f-42c9-6837-08de56a688b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHpTQ1lCVlBwRmx4TkwxUWdhZ1dHcEZHc0IrVmJaRk02U0lzWktYOXBlMkto?=
 =?utf-8?B?MThQOEc4N2dZV2t3bElsL2orYmo0OUorVzZuaC9OZmpjOXFraVlWMXlMK3Uw?=
 =?utf-8?B?L2h2OHBDODB5dm1YdHU0dStIM001Wk9nb2x6V0RFYk5qN204UWpmVFB0VDh1?=
 =?utf-8?B?ZmpUWG9sdjJkV1Y0bnFFdkFvaDI0MG9ZeEcvWnlnZHFxNlE5NDlQblRQMHVD?=
 =?utf-8?B?ODFVOGtYTDVSaHBoSXZoa2ZiNkpCalY3cU9XVi9DUnlrY2pxV0RyM2t6ZHg5?=
 =?utf-8?B?WEN2VVh3ZG5yNnVVcGV1dENRbHZxd2lOUDNhWHhBSTMyTENxeVlwTXp1TGRu?=
 =?utf-8?B?Z0h6NjFwcERjREpmNHFUajBSd1pPY1VvMWlkNnhhWTVPWno2Si9iT3Qzdldx?=
 =?utf-8?B?WHhVQVRtTm00aFhBeFl3NTlwY2RwbERyL1ZHYlJrT1I5QW9RcGd0b0lmQXUy?=
 =?utf-8?B?UiszVFB1UjZqckJVbUwxbWRDS1paZ1kvak1QbDVBZkJvVFVEYkU4SGxud3pE?=
 =?utf-8?B?MklSRHR6TmxBQjNlbVFWc0RMVmlySU1UQXBaR3FzclFWeE1aSGhSa1l0Y1NV?=
 =?utf-8?B?cWlQalRnYXFMM1NTMjVpZmlPaHNhei9QSW5wNkUzNUZEQUNWVFJoT3FUL3J3?=
 =?utf-8?B?TTN3d3dia2RMaHo2emFscUxCV2x3dGI3Y3NnUWZ2K2xZQmRjOWVLeHF5dmNI?=
 =?utf-8?B?WkxURGVQK1VLSkovak9vTm16Z1U2ZmRkNTJBZkhYVXllQldpdHJKc3ZQVWNm?=
 =?utf-8?B?aXU2dnRsV24vZlVlSTNPM2lFdmFMY0tiYVh6Q0x3Z2tMdDVzd2F3d1NOSEFM?=
 =?utf-8?B?aUE1MjY3NUlVY0ZVdXBvTmlRQ2tkNDlWOTRyNzRTQmxPS2N6bDBPWkxwclh5?=
 =?utf-8?B?NjB3N0dQcXdHZFFZSTE5RHM5OVJ0ZXhPMXFqUEpuNU9NN3VkM1dmVXlZK1VM?=
 =?utf-8?B?VHNCeHYydXFGQ1J1eUJKUzJhSEtqVjBxcURwcUZnTHU5RWZQL3JuRDlZRkZE?=
 =?utf-8?B?S0NBdnk5UEJ3L2FiUUtQcDh0M2pmeFRUcGV1KzNUUUtzblBKRWgrTWs4WWNR?=
 =?utf-8?B?MXVRNG44RUVZK3Q3eC9QKy9kRDFmY1lTNFpQazk3RWM3REJ2QjlyeFZLM3dZ?=
 =?utf-8?B?MVVYMGZOM2QzbXZrc2E2MDhDdmZSZlk2YVVVQUpic1J1NWRUYmNsUnVjYVBI?=
 =?utf-8?B?WGJ4bUNSYnVjTERFWmppRyt6cFNKZzd5TjRJeG45U1dJV2V1YXJXNksxeGcr?=
 =?utf-8?B?WW5LOUtXOXhUbzdvNnpYODBRVXNnRjF6VWk1VCs5ZTlVbHVvZURZUGtHN2xG?=
 =?utf-8?B?UVRvdEk3TE9zZGptN0NqdS9MeHJPZFVRSjdxYWdrcFhkWXFXTFdqaHNBc2Vs?=
 =?utf-8?B?ckVpTXVQT3FWdVlsSDZTSWtUcU9raHAxZFRISzcyMEJRUWJ1UkhYSDNxc1I0?=
 =?utf-8?B?MnZUVHZuRkpZaVJtQzl4bFBjanZ4cVdIZm5Tc0hWL1g0ZTdKL3hiT0hkV0dO?=
 =?utf-8?B?TnI2cUZDSzdobUgwMngzamFobHpwVndTUHV0dXVQcnI1ZkYrUm1yaXRnZU9V?=
 =?utf-8?B?SjJSQzg4RVNRTzdZWmZLajhvemJTNmhZS2t1SDJJc2RiV2ZhSks0VkVRUG9O?=
 =?utf-8?B?Unc3amRLZXdCRk1hM2lYTU83bUNIeVIyNHpoRFUvMGRFQzQ1WiswRjk0U2E2?=
 =?utf-8?B?TExOZzErbmxKeWVIbnFNbGtSQWlacmNmMDJSdDhLUlM1dTFwVmFVTHUzbEhm?=
 =?utf-8?B?ci9ZSVlXa3FYMFJUSkN1RVFOaEZjNHp4ZUxTaEh6L2R2YVVKL2tlNGhUdksz?=
 =?utf-8?B?d3RzRWNCdlJQMmQwL0h0blE1NmFvQ0d4M3QwZmswSTJrcllYWll0cE1vVkg1?=
 =?utf-8?B?WVRueUpjVURHRUNiNGcwcDh5eDFXSHptbUZBYWczVE5GeWZPME1KY2x6Wjhu?=
 =?utf-8?B?cWprSzlVOCt4em05NHltWUV4S20rQXZIeWNEU0U2MDU4aW00RmVOb2JWQ1dJ?=
 =?utf-8?B?SlFyYUEzODZQV1NXYTBzRjVkMFlGWVBFbUd4MGo2NGJqYmdHMFNPdkk2WFU0?=
 =?utf-8?B?WkdPMjNtREJFM2tLNk0ydDBHelFwVkhZbjZHejhDb3dMYnlhaUpiUEZqUGJv?=
 =?utf-8?Q?v1Jg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW1iMDJzT2ZpR2MzQnI1UWYvc296U2o4eDRDczN0OXdHc1VpemlPRy9XeU1w?=
 =?utf-8?B?WmxvTktSVXZUd1VybDdtNGZkZFpFcWxyYm41TXBUNklOU2x4NFFXU2x0RHc5?=
 =?utf-8?B?SFF1K1pBNE81ZFFLeEFDS1I3bEp3WjQ4R0xZKzE2TXQ2bzFWWlFvcG9CN3Q5?=
 =?utf-8?B?SmMwV2hWeXdhYjc4dUlWMktja1ZnSmlCSEVTamFteHFSVDhUaWVmSTZIL1E5?=
 =?utf-8?B?RXl6c0ZFU2lKMFNCMWZZY0tYRnBvL3pDNzhSSUpwOUNYYk82bkMrWm9ETzlD?=
 =?utf-8?B?bWNIeFlNNEpQTURvcEdkTUkydTQrcWZPcVdSdlc2RXJXc2hrSHdSQ1dnNzBD?=
 =?utf-8?B?MDlYR3dOL1A2aC9WMzg3TnJhdGNmZHBiVEVBcjRtR3lRbUV6bEs2QklMQzNQ?=
 =?utf-8?B?aFlzU20xYUJ1NU9nMTBvbGtHT3JldzhnbDZ1Tm9JYVNXZUx0UkhUMWtBSis4?=
 =?utf-8?B?NG9HYm03bHNyR3dSV3FwNTlaa1lUS2M3b1lsQVJrNFY1aXdYR1pQTURrZHdw?=
 =?utf-8?B?aG5LY1psRWlYdytFRDk3M2xWaFNveHZaT1lIWlJ5d2hvTFYyZHIyQnQ1ZUkz?=
 =?utf-8?B?ZjNLNWRwSnNDbDA3TWhZMU1JT1hqMUwvbThvUnBTcjFrUG1UNldIK1pHV3No?=
 =?utf-8?B?Ni9keW5GUWxEUncvSzFkR2VVemYydTlzcXVqK2Vqc2lNeGF3Qkp6WHB0a0U2?=
 =?utf-8?B?SlFFbWM2dmxkRUpMOXZuVWc2YmFBcHVWNXh3enk0VEFWeXMwd1NWT0huY3o4?=
 =?utf-8?B?TzNOK21tQ1RNNk5Fdkp4S2pnVnhmbmJ2bjJqYmdHc3BGeFpMeFBvKy9RMWY1?=
 =?utf-8?B?VHdYODNQbFgzcUZNSzhLaUthVzBJZlEwSGJydWFCU3NUMnk4c3NpZWs5cXlJ?=
 =?utf-8?B?enZIblRoLzRJV1grNktLM1RsaXN5MkdiUmZDMjgwbHo2WjVqdVhOcmFhNWtI?=
 =?utf-8?B?THFPcG9RajJMNzR0ZWVsWlllSjhGSmtkL054NHRBZmJ5MGJZeFBscFI0eWtp?=
 =?utf-8?B?QmwrOW8yajZyQUZiN0hvVHpKVXE3Ynk5R3NxOXA5ekJPYUMvNGllbjZHdm1w?=
 =?utf-8?B?NXIyTEk0eHBTZ3BPeTBYT0tnbHl3eVNxc1hMT29JL3pkZ1lSZWxFYVRKRnpX?=
 =?utf-8?B?VXZTWmN6M2QvQXVCd29hRUFCU25vL1E1R1pxT2w1dEpmZS85UUtpU25kUXo2?=
 =?utf-8?B?VnBJWEZUMDlnNXltV3UwWDV3dTlwQ3h1bFpkQU15a3BDRUhzVEVnRGpsSFh5?=
 =?utf-8?B?V01vL0lpWlRnNElFUDNnTm80K2NkK1RoaTlPNFR0eE9iQzdLbVEwWEF1VUxB?=
 =?utf-8?B?RTJETURiVzFKeTVWRE0rZVlHbitxQk42UWxWd2JmYWgya1VDbXljaXgrREdz?=
 =?utf-8?B?bUIyQXF2QWkzWXkvRDEzRHcwMElXTmxpSDc1UEN5cDgwVUFQVU1jakkyMFhv?=
 =?utf-8?B?ekZsbUtEWk1YSCsxQjVFWlNka1BNQ2FZbmVmTU5BSkk0ditOVFVabnl2dk9i?=
 =?utf-8?B?b3AzZlZCYWdCVmhLU0tZTkxQbUp1SWJBYnBwaTc1RGphOGVzd2dkYkE0dHhq?=
 =?utf-8?B?OUtVR0Fra21ReTRRb29CbXBtRnBQV1N1T2JIYjU5L0hGNjZLRGE5Q2NUN1k3?=
 =?utf-8?B?MmlURkxSYWVvUDl0RklwckRUK0w4M21VbEx4bEV2aWhURk5nTUkzcisxUjFt?=
 =?utf-8?B?RWhVUmhKZkZsQksza25wUEF1a0pBMHplYVdOZXNCU1JROWlqNHl2T0E4K3lB?=
 =?utf-8?B?MThnOGdRWEFZVjVLUHVWdWRXZnFIZ2dGK1RMdC9PUUoxRUNlU2xUVHhzdGly?=
 =?utf-8?B?NWtZdldnTUlzYVNGbzI3Ymt5aTFIeEgrOEhFazJZME44cjF4ZVJFeHdPcmZt?=
 =?utf-8?B?Y3FNcXBNbHFHOURJMXVmbU83NjZGRzdJazNjcHRWa3Q1MVZKeERTWC93QmFl?=
 =?utf-8?B?bjBJMHlUZWxkS2tBUFJVZml0UEQ3NlZPQ1ZOWTJKUUtuUWFtTk1zY3lOeDlC?=
 =?utf-8?B?aHhncENLTzQwUkRuRG9oZFIzWEp3U1ZjWDJZa3ZGMlR2V1lEc2MzZTdQOWNL?=
 =?utf-8?B?cXVvT1B0cmhaQURhRlNlSmkxSmVGSklKTjkxMFloZGh6a3MzZlhTY05BTlQ5?=
 =?utf-8?B?OFpON0YzYWwxTjBZR2xwMGJUTGIzMGpFZ3crTEJCZzRZU1RDZ2VuUjladGdr?=
 =?utf-8?B?WXgyaVhCZkZWNHI4bUUza0xJLzJUd2FoTXJxZ1RoOWp1blVNTlJ6Y2FhZlBn?=
 =?utf-8?B?M05hYlBjbUpMMkJUM3dIc08ydEFPUm5YNGZDTWVBSHlVaFRVRHRIL245VFZ1?=
 =?utf-8?B?QS9LdCtrWFJYSmNRV0VyY3VTYnl4c1A0V1FDTkV1dFFtb1hrbUFrZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d9432d-843f-42c9-6837-08de56a688b5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 15:30:39.2525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ib9oBcm6nr+65Ig2dwu693JTpXmOVGxtxNW/YF8UeXkJz/ZFzO7jC7OU7fXHYA6xij//G2nqEoALUTHfO7PkwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964



On 1/16/2026 09:41, Mario Limonciello (AMD) wrote:
> The hibernate resume sequence involves loading a resume kernel that is just
> used for loading the hibernate image before shifting back to the existing
> kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>

Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

Thanks,
Shyam

> ---
> v5:
>  * Add retry=true for the retry case (Shyam)
> v4:
>  * Add tag (Yijun)
>  * Move and rename PSP_TEE_STS_RING_BUSY (Ilpo)
> v3:
>  * Add a comment (Tom)
>  * Add a define for busy condition (Shyam)
>  * Rename label (Shyam)
>  * Upgrade message to info (Shyam)
>  * Use a helper that validates result for destroy command (Shyam)
> ---
>  drivers/crypto/ccp/tee-dev.c | 14 ++++++++++++++
>  include/linux/psp.h          |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index ef1430f86ad62..92ffa412622a2 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +retry_init:
>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -145,6 +147,18 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		/*
> +		 * During the hibernate resume sequence driver may have gotten loaded
> +		 * but the ring not properly destroyed. If the ring doesn't work, try
> +		 * to destroy and re-init once.
> +		 */
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
> +			if (tee_send_destroy_cmd(tee)) {
> +				retry = true;
> +				goto retry_init;
> +			}
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> diff --git a/include/linux/psp.h b/include/linux/psp.h
> index 92e60aeef21e1..b337dcce1e991 100644
> --- a/include/linux/psp.h
> +++ b/include/linux/psp.h
> @@ -18,6 +18,7 @@
>   * and should include an appropriate local definition in their source file.
>   */
>  #define PSP_CMDRESP_STS		GENMASK(15, 0)
> +#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */
>  #define PSP_CMDRESP_CMD		GENMASK(23, 16)
>  #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
>  #define PSP_CMDRESP_RECOVERY	BIT(30)


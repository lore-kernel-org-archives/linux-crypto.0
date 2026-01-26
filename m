Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011017.outbound.protection.outlook.com [40.107.208.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F413A244;
	Mon, 26 Jan 2026 00:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769388301; cv=fail; b=rag4DZZ7jncURhXVLH3/6WjaL1chOvPdWTx0iMWkUVLTvdtzn1dSzy/d1VZNV4ao2SEFD35IG8/smzAtCxO+KOqFz/S6H3qV2vePATaDqB0C4xAV3u250taPKtyxHrKPblYcQSlGeUGsjPUtoBdZ7ycIQ8zHZi3X/LQVBUJ4TEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769388301; c=relaxed/simple;
	bh=kSsY+tv+1QRI/NTPaiz2huHoDUa8ZVfrdEauLA55q6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GsRetK/y5HUPrzRjPTI6IW0SW8wxp3Qn24KO0LToYw0jmNSEp7QE0p0go41ltzhUKnR+Czy3zlCpDk9M+5SyUIL59e6/hHo7t0gZvO9T0UJkhnc3cCbkKrUiwa3d9ZrBJcGQGIdy/DYA2Ig/DEJ7g36mGB8vFtZSJlVgh7IpEiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gE9gJyb0; arc=fail smtp.client-ip=40.107.208.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gE9gJyb0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqh8dk9hTME6qyqPEUghuQD/IvcyNZuFOVRmhWoSzWxaE8GBdqSDdxioTIX8zXw0NYGqMgVeaVscysnvq5FGPQN7TviPOkuUB2MsnlbQpMhfPuBWD06ZrF3EzqiA6MAShjpOer4psBX9JAK8PEZAPiDlnzUZTPcC906lBfGpbEcLA71xnRhAtezzx44Udpk6uPuU0KTAZuG4lSHe7SJ4owtSm6UD4YzzCfcuOqq+7Tb2rf2f2mPnDguJLJis56R005ZZLkY+UZCg2D2UwHPa+ZK0pZIn9cVOpuKtRpblipmg6kkQPtXN151LrZbdtavb2L9X/+E6ybcgH8BVBZokRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGRaprNqOvGa+ZA7GLhJyQzm5/YvIPQ96iOtWda2Igw=;
 b=g+sw9Ag/gFy75UYmAAvFnTzmAaBh4ZouwPC1gXg4yc8GmMK23eRuaL7FIrtGctbgkkDIPnmNiSSCmMkHMYA4mgQFQzBpEwxoWgSG3DMBzXq5mcpBz88yHCgQb7WIarg5XpZa6Z1pL+ZrOHneNkTpb3L96MhAXb/NI2W9JIjdX7QYoquaqRKQNhzv/0GH6oSRktQQ+ckkF4Mh9HtshdmAP8D8NFfFiE3E/cl9B0OjSPGr3YRI6Nw9BlJFyTD5hjCvKojtor/qrCjQkdnOvCwzmeInE8gg/rgn49tvLUYm3IRljFdBOayWRSvLtglUthdcE7hkLCP+KRoXlHVx6/2sdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGRaprNqOvGa+ZA7GLhJyQzm5/YvIPQ96iOtWda2Igw=;
 b=gE9gJyb0CvVzYbX3wICYEBN9wdfhk8wOem60MrflK0HPqLRdiz2/u8KulC1VexJ5mlVdfqzXA6NyezLc1s7Q6UP0SasInrSTl3gjmIf1faLoGW4mGUOAb2p1F1yxcAvmhA4R1FNBwo0x/nKYrfrlTKonDpPDtZFgnp7ImZfxYwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MW4PR12MB6707.namprd12.prod.outlook.com (2603:10b6:303:1ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 00:44:56 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 00:44:56 +0000
Message-ID: <196ef0d2-93ac-4872-831b-e803e02b5d95@amd.com>
Date: Mon, 26 Jan 2026 11:44:45 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 2/2] crypto/ccp: Allow multiple streams on the same
 root bridge
To: dan.j.williams@intel.com, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, x86@kernel.org,
 linux-coco@lists.linux.dev, "Pratik R . Sampat" <prsampat@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
 <20260123053057.1350569-3-aik@amd.com>
 <6973fd402a74a_309510049@dwillia2-mobl4.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <6973fd402a74a_309510049@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0117.ausprd01.prod.outlook.com
 (2603:10c6:10:246::28) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MW4PR12MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: 472405b1-c9ed-483f-d87a-08de5c741fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2tya0MwQlQrNkw0YlQwNkpUdTliTG5wRkR4NTNoZkI3OStHY0NlT014TzBn?=
 =?utf-8?B?MWNDdC9XSzB3d1dhQzFOTUdmSTlTQnIxRjlaamlKYjFwVitNYlRXdEhtK1Y1?=
 =?utf-8?B?SU1iUmk1VWdDZVZsVlQ5Y1NEMlBzM1pqNFlHRFRIWnNHSEpsdjJReURvOE8v?=
 =?utf-8?B?cXdsdUtCVVFoK3h0a0pXaFZhK2ptYjZac25aczQ3MnNGTWtjSjdTWWdqKyt0?=
 =?utf-8?B?ZC9LMUd3Nis0S3MxWHp5R0g5bkQ2Y3VMS2xlaXBhR1hWSGlpVzBvU3hxazd1?=
 =?utf-8?B?NnFucFdlSWRIbmE2SERGTG1OU0NjWmJVdExOU0xBVERRWU44Y2VmL3BDaXVE?=
 =?utf-8?B?TmhIclBvUTd6SU1ZbUdkNWtPZXE2RGl0SWU3MEtEdHVUcGlKc2RxZ2F6MkMx?=
 =?utf-8?B?ZXdGZTNQeVZyeFJJZ1hYaVFwSDQ5dGc5SnNoQ0pKcXlHeGFzZnN0eXBPanNV?=
 =?utf-8?B?b081WFNaaWQzd0NzbTJScGF6aG11OGpTNGJ4RVZ1Y1BrNGg5eVdCckU1dFJQ?=
 =?utf-8?B?SkExZk5hSzFWQ1Z2RllRQVFQRXJmQ3MwTWlqU1R0Z0hpZklDelJleHpEWWtI?=
 =?utf-8?B?LzBkc2N1bUwyZDVBNmxPZHV2b21qanY5Ync3YXMycjdXS21jMGR0T2VjUDda?=
 =?utf-8?B?dTZOdTRrczBmamlpUlM2bFRJZGpOYUVKSTJGYVJPTVNLYXpxQWQ0NjJKWmRN?=
 =?utf-8?B?RUY4RlpFRWNvSXZQNjNCN0NaOEFscG9GekZMalpza3NVMGRTNWlXNVFudHY3?=
 =?utf-8?B?OWVjWmhhRkYrOUFRU3lBOEd2ZFNmZURRTVhtT01MQitOZUtaK2VFWFFtU2U5?=
 =?utf-8?B?dGxSV1RUNnJHbmJGZnFsbG52V0pqWngxbFYxaDNmbFRsdUUvQk0wVk0vZlBN?=
 =?utf-8?B?K1R1Z3dUR1U1TjR6SjBjN05ZY3FhZ2VCUnJ6WS9reUNIdC9xYXpRTmdOQzY5?=
 =?utf-8?B?eS9obFNtR3RjRnd3VUl5eUtRbllCTG02QitXRjZic3dzenlKQ3F1b1RqVTI2?=
 =?utf-8?B?ZXhXOVZ1Yk9nYkpIZll5Y1RjdjlTdVlTM2h1N3AxT2wyZXI1MTFVa2o4L0F4?=
 =?utf-8?B?SUw2SG03U2pOVzRzNFhWNnVjNGhIeEl1VFpCNG1vK3JhVloybjdHK1FJZ1Fa?=
 =?utf-8?B?MUl4Y09XdnREMFpiTXRnVzA5K3VZc2lIc1o1ZHpuMk4rckFWWm1temxDUE04?=
 =?utf-8?B?L3k3OUltZDk5T1hEZEZtb3pOeU1oK3J3UzhlbjFzVFl5MnNSR2w3ZUxBd01r?=
 =?utf-8?B?ZjkwalhXUDQyRTZ5K0Z6NjRjVUVzVERnL0pDMlN5OHg4RlB6SVgwZDNGM3NX?=
 =?utf-8?B?UGRsWnM4ekk5eExtSnRKc0I0bmdmVkp1YjRpeDBKOUZZVzlhTkw4NUdXaVQ0?=
 =?utf-8?B?eFhLNWwwaGFvWVV5ZDlvZkdJL3llN0tBYitPOTVJcmFZVTAwOTVhd3RBZG4z?=
 =?utf-8?B?d0pYNnpLVkVHS0NOcTNXWW5LRi9PNWtHZ0tiQnZWdWNKdmtaRUY1MUwyMVRL?=
 =?utf-8?B?QzVLaEpkaVUzZDA5UTJwc2poeW9UUHJYd0tSTFdIcUl1WUtkRjIrZjZWcVlC?=
 =?utf-8?B?UlRBQmgrUzJvQThlZWJibmNEM0lRTlpHbXZsejY2bXlUUTVRVjZnQ0xvWVk1?=
 =?utf-8?B?NTNyclV1ZWcyd0toZExVMlVWSkdndmxBazNYazV1WXBVUldUVmtyVWxTK1U1?=
 =?utf-8?B?UEc3OUNlNmRveTFIWG9CRnZiVkxzS1NyVGZiaHh6R2d0NmR1Nkg4WncxUWZK?=
 =?utf-8?B?NXFnRDliSjJUMVRaSTVzdS9CWGRiSE1WQkdHTU9acnpHdUx3R0lxSjZObVJM?=
 =?utf-8?B?Z2lBcHhSV1d3Wm1yRUljamhBbVJGNFNHTUtobjNnemJxRm90cTBjYWgrRWF6?=
 =?utf-8?B?MVFWNEhIMjVLRE1FcHQ0WVM1WGJtak9VRXFlOG55WjRGZVR0UXVwUWVEOWlG?=
 =?utf-8?B?LzY5bnlUTFk2Yk4yNEdWUTNwZFIwdzZGTCtaaHNoVDg0aXB1SkRJTFZFVVpJ?=
 =?utf-8?B?RUlhTm4vZzY3MW1qeC9PbUQ3ZUFwZHlvOTBHUW1DaFE3bzR1VE5WUU5LSHJZ?=
 =?utf-8?B?Wk5XbDN0cU9FcHBuNStvdEZMa3JqOWNyaTZtTmU0UU5CTkVjRXlpUnRpMHFn?=
 =?utf-8?Q?qZPM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3JlbkZMcXRIZzJiL3p5eFNNQzBxb0tSckhmT1dMdzc3WmpkdUY2a3BHWWFa?=
 =?utf-8?B?bXlIRGllREk5dkkza21XSXBKWWVucWdjZ0hickhPczJLQm1yWkRWTTZ1ZGJJ?=
 =?utf-8?B?WmVRWk5SdVlHUFRXREgwN01HeFg4Q2FvTTJZYklzVTdicFN2QWxzUVBpNDhY?=
 =?utf-8?B?TWRoUUVVcWZqNlg5cUlGSVlzMXROSk9NUEE4Zyt6b0p3OGoySmtZYnNzMGEv?=
 =?utf-8?B?UlAvTGpjYVd0OEpwWmJ0ekJicDdyalV6TTlEaEJoY1liUUl6eVIyMlZ5WSs0?=
 =?utf-8?B?OXhIUXhXb1pKWkhocUhnaFJrZEVIeXFzRnNqdVdlMEVVMnlWaFJGRjFjTVFy?=
 =?utf-8?B?MlNjRTA2OUJmbTVyRnVNYlVadUdUZGczdDdmT2oyYThrTlNqRmNRUzg3ZTRq?=
 =?utf-8?B?QmNwYWt0amNwT3VNYWZKdHg5YnZsYndhS2hxTGZWeVZXZ2xRNUR0S3FuUG1v?=
 =?utf-8?B?SzZ1WE0ySll5ZHBiOG8vdVBYY2tnc1pXSEk3V0YzcWNtaDhhM2FJVko5NGlC?=
 =?utf-8?B?NFNVRXZBK3NiLzllZllXMERNV0JPbmxuZENkdHVKb1ErNk5PdVNWeVdWUFRL?=
 =?utf-8?B?N0hSN1k5RU5Dd0hIYmwxZWR1bnJKbHpXV3lGNWxDU052MU5OdFJOalVGUHZw?=
 =?utf-8?B?WU5SUWo5RnNqY1ZpYjhoUVppbkphMzV3bGZIRWtxOGMyY1gzVGIxSVB4TElr?=
 =?utf-8?B?VGNKa1lnN2R2NVU4QzUxeUdPS2VtaWNOSUZVMU5TMWFBdlhrTGxVUkhRME0z?=
 =?utf-8?B?VTZLMTJBM016VnRTUmJDZUh6LzYwSlJRRlB6YXVIS01VbGJQL0Q2YzNmZnVM?=
 =?utf-8?B?SnB5emo4bElJOU5udkFkek4xWm05UzFtKzhua05jdmprVjVGeUhaWXpRcFdV?=
 =?utf-8?B?N0RSQmE5aXNzRlp1b3hQTllVNU55a3FIV1YvWktYcDlPSGFpSFowZWdNUEdT?=
 =?utf-8?B?TThIZUJ1OWtDQUFGQUU0TEQ4RlJUTUt0MG9Cem1KV2p6OWM5ZHNnNXd4SnhI?=
 =?utf-8?B?UUpEOTF6d1RGMHZkaHJIZWxIQ3c1NE80VXhETklXKzZnejg2L0hSMjUvVGF1?=
 =?utf-8?B?cVBXUU1DNmU1MEt6dmloeDEwWURtR0RqNFd5ODNJSHptT0grUElvKzJlTk5X?=
 =?utf-8?B?cU9oQWdvTDdZeml3MmdSZE8xUjJaeGZlZ3piZW5kdFlRcmdsUEtVZ09FK1JU?=
 =?utf-8?B?Um1GVEJHMm9obkxZeW9QMmRrNnhhZFozcE1iZkxXVi9aTDR4eVpjemo4THVj?=
 =?utf-8?B?NXR0SG5FcjRHaUhGYVVUZlpWQ3prRHlHUDh1NWFhRGpNTXVSZ2IycGg5bzl3?=
 =?utf-8?B?ZmVBTFRpdk5VdCtYeDdSVU5PUGZ0TFBaSVcxQzMzd1p6NGNxb1grN0NFSzVz?=
 =?utf-8?B?M3VLaFJwSWNYbDA1TkN1Z05zTndOa1pGRWp5YmpJeWRzUGZBcGF4MEtxbzZC?=
 =?utf-8?B?aW93cCtUaThRRStDSDJSd0gvNmVoT3pkRXNudmUrT2s3cmg0bUN0SHpkTU5j?=
 =?utf-8?B?Uzd5dmJXSHZqQXBqcHd2Ykthc1Fhc1Mrby9LR3ordHkwei9UOGM2Nit1aER3?=
 =?utf-8?B?dWdxZjZibms0TmFWZWYzVVJXMmRxMlJtQ2VpRU85V1h0WnYvdFloczBjZG1Q?=
 =?utf-8?B?eitNOTR1U05Sb0pJc3dPSlI4ZWltNy9XV0xMSnQ3T1NmRTlnVXhQQy9ER1M4?=
 =?utf-8?B?MGVwZ2JFNHFJUnFaY3hZWGdWek9BK255eFk4Y0l3OVhsd3dyZFZvdVpXclg4?=
 =?utf-8?B?a2JyRkx0cU8vSncyMzlOVnR5L0tneEo5Z2NPVGJSbE9jWHY3S21obDFTUjg3?=
 =?utf-8?B?d1JKWCtuZTJxN2RJZFJVVm1sZ2liSDlXSTY1U0pqTkkyNWhYOFltMStxb1pu?=
 =?utf-8?B?eW5PZERTTzBKVytPUmZHNHR6Rmg1eEVxaG9lZlQvVFUzY1VKZlpid1g4aVQx?=
 =?utf-8?B?R0ZCV2t0MkNHSHlVZkIrc1F3UElPNW4zZVN4TlIzNFFITjN0MzllS2tOSDcz?=
 =?utf-8?B?ZDJqNkdSSEJSbUdwWXcxRDEvN2lHR2U3MGlqM2NRMzRaSnh6eVo1cWVCQnpR?=
 =?utf-8?B?bWNkQjBkbjB5T3Vuek4zenk2UU14dk5WcE1kamltVUw3ZzU5MTRwOEJMNU85?=
 =?utf-8?B?bjQ1OFFOYXRRTnJiT3BLR3FkTVdKcG1Fc0JmOHRKZnhmblRvd1pGWDc5ZDRx?=
 =?utf-8?B?VU1zdHpTMTRxRkhwc1JIUkNURXY3NFJmV2doM1JqS3VEUkVTQ0NGSGQ5TWp1?=
 =?utf-8?B?QzBoZnN6YlNKSkU4c1lCZHJieVlDUG1HUkp1cHpPQWFqeE9HYzN6aXRSdlJR?=
 =?utf-8?Q?+glZMR/n2g3MC6K/K6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472405b1-c9ed-483f-d87a-08de5c741fef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 00:44:56.0408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDajzXKMbe+eQ0eahl+0QdQdyT0MtUlZLVRZ+S6G3YacskTIS6vTwqryEJy1VzSZJda5YgDhcv2pzr1yszfdUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6707



On 24/1/26 09:59, dan.j.williams@intel.com wrote:
> Alexey Kardashevskiy wrote:
>> IDE stream IDs are responsibility of a platform and in some cases TSM
>> allocates the numbers. AMD SEV TIO though leaves it to the host OS.
>> Mistakenly stream ID is hard coded to be the same as a traffic class.
> 
> I scratched my head at this comment, but now realize that you are saying
> the existing code used the local @tc, not that the hardware stream ID is
> in any way related to traffic class, right?

When I did that in the first place, I also wanted to try different traffic classes so I just took a shortcut here.

> It would help to detail what the end user visible effects of this bug
> are. The TSM framework does not allow for multiple streams per PF, so I
> wonder what scenario is being fixed?

There is no way in the current upstream code to specify this TC so the only visible effect is that 2 devices under the same bridge can work now, previously the second device would fail to allocate a stream.

> Lastly, are you expecting tsm.git#fixes to pick this up? I am assuming
> that this goes through crypto.git and tsm.git can just stay focused on
> core fixes.

I was kinda hoping that Tom acks these (as he did) and you could take them. Thanks,

-- 
Alexey


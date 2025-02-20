Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B48200BA8;
	Thu, 20 Feb 2025 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740069298; cv=fail; b=h1z/IvsF4A547zk/tT55lSB7jl/mW8JcHJ6pPmdpR1hWHfVaf/deMODcKl2Tcr1WVqi3ukjLTnpzX3xSTYHNSjBppmQ6JqrnCbJY/zknU0jbTmK112fgFaSQbYHDVZSprQLL5fEuOH5d5Ht5xbSixPA/WGSIwOQ/fPwpMj9m7NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740069298; c=relaxed/simple;
	bh=QFE4OiDZaNWLXEXAJRi+U1OPThBK4yBGWulLE3+R4dY=;
	h=Message-ID:Date:From:To:Cc:References:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=WNef2gpDGVE6+wIOCZwRN7EAfI0gG0hbY2PqfZGGVxaZ6YaCi7SvcKWGP7Q+spzps2xCzrAlePfIoE2M/W0NBOj5K51OvKg1qgUu1J/r/rFwbNir5isUF+MAWKl+L7ZFPIIUCr18k+wv5ZwvBMmwIkU3+0cl5woKo31qPNe6fyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y2rsnKhq; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y2rsnKhq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QYhsDffP3nbioBxLkFAHaqzxqB3Y82S05mjBEyxFWeNTYVGtX1L/Eq8Y5btqSzC+HpOTvpGxh8MjvdecuSTNUuR+8OyrRQfjIR0f/frZS7YYt2geGVlK+jXRL+aVD5YfilGjMZv2j3xn407NDQX9reh+HDRJ3w+DCp4UH2ESgaYJGOH4awtrIi418GfuAHrsY/C1FtWLQp+olVRpvF4yuEIH1aHqkLiDzsmmraX2mlaZiRNYA2hVqu5T335h/V2nReic/n7sUwilgIN6YYRMKYdxZ1j4XGuxJGPSSl6565CIRXa3b4Vhseq2NaWTHjaj0vRyg+pBkBObOeMMHXAjyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+u/pUAMfvqEZJveWphoeTsijv+awaBgiD9u7BUKLIsM=;
 b=m0yaNzFMmBzSl5OwPL4xuhJ6OT6FxNbCdrX+iPdGSavvRgwPh/hJZ5s5vJwJgtb5J65j0b61+rkzm3ODAJ1tjTCrM0C+xIIQQDAOPHyxd0SomwxXmiTZjbdKW9uUySQY+SDwLrVk8IHFSj5JztEJwDB8KmnaHi9m7jWw7QUJmtXaNtA9mslYym9mXj1NgGXE0CGWbCWRHlWd+tDIYHSZp8njBk1nqmhhVIjtVhEmfnC7Jp3gcA/nRLqhIe34eHxyrc4Pd9FrMIl9rz0XeiVk53OXAL9pCxSzSDTAsHMci59kYtqp17KRvSZRCBT6m3k5rTSvIL2+oKqJmu4WBQayqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+u/pUAMfvqEZJveWphoeTsijv+awaBgiD9u7BUKLIsM=;
 b=y2rsnKhqkT52HaahHcsqtTG62MVRRAjI6evJGySQubA3g9TQcAELYhKYALVlWgqyoiN4ud8KFgoXwBMcyXOZbcRH+u1539qsPYYiMi3HozY94dblUwpryqf4f3fhJyxM0AopJzpWZRe+MPy9/FX68rQ8dmPpTNtXoEt4NEd3DcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6719.namprd12.prod.outlook.com (2603:10b6:510:1b2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 16:34:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 16:34:53 +0000
Message-ID: <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>
Date: Thu, 20 Feb 2025 10:34:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: linux-coco@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 John Allen <john.allen@amd.com>, "David S. Miller" <davem@davemloft.net>,
 Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
 <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
Content-Language: en-US
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
In-Reply-To: <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0011.namprd05.prod.outlook.com
 (2603:10b6:803:40::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6719:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ab8416-2ebf-466f-3df4-08dd51cc810f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHNtN2dSanRLbEVBVnkxU1ZDTGZ2cDJnVzdTRTNBMTY2NVFCVzlBY1VlTnA5?=
 =?utf-8?B?WGZjbVdudk5CbGlyTlNLUWZQU2VvRElNcWZNZUtucVRzNzNJRG9RQVpLbkNM?=
 =?utf-8?B?cHVXejVudVZnSWV1Wkt4ZENKc25tcEtxSGtmcXo5MXFyQS9HdmNGVEJpL1Fz?=
 =?utf-8?B?WThPN1VUMDQwcFZmWmE4REJMaTRBS0x6Tm5YcXZBYk93MkZ6eEdIMXNoOHhv?=
 =?utf-8?B?Q0kxOHpBbWdKdFMzeDFZMnZVT1k2bWMvM05tdXJPWmV4MFJnOHVHemRTaU9x?=
 =?utf-8?B?cTA2bVZPajFISTQxbDdZY1J6ZlBmdFFXUTNUVXVqQngxUndiRmxLaG5abGg3?=
 =?utf-8?B?VWR1RWNBUWFOTlpZTjIxNDEzeXFOcVFNMmFSdk1kN0hiekdBM3MySUVXWGJz?=
 =?utf-8?B?dktBdXkwNkpGOTAyb3ZqVDJYUVFuRXIvSFZLWDBaeVYrbjVHU1NnUTd0T29p?=
 =?utf-8?B?M085QnlWNlZ1WGV5RFllYVo1WTNtMU5OYnFKbWFwR250eXI5a21tcy81RnRR?=
 =?utf-8?B?UkdtNTBRb2QvS2duRnJ5MHd1WWFRTGV1Y1RpMjlBZDNFQXZkOFo5TjdwNTg1?=
 =?utf-8?B?RUhLWFp3WE9xVDNNdERmVHNCc05UY1RoaWZpcU1RSDF5V0VxQWN2Q2ZweVUz?=
 =?utf-8?B?VXEyaURkWnlLZzBXSXFtay8zWlNrenJ5Nkx1c1RmUkJhUUM1dkJSb0QvS3gv?=
 =?utf-8?B?RXVoT0NKYktqU1lpZ3ZKYnFsQXFocEc0ZUtQemxYc016alk4czhOL01RMndG?=
 =?utf-8?B?ZmdSRmlzZUQxVGloTXQyVkxZWkRDajdsTE1tb0VhNFhwSjNaYjlkei9GME5U?=
 =?utf-8?B?TmhMaER0blgxQVpFRmJMZS9vREt0aUlqSE53SzhKUFlqdERqSUJQdFZMMWZn?=
 =?utf-8?B?dGgvbnJtY05VdHJBZEplUnNFMW1lS1Z1WkxjN3NkbFg1QTZINTAwUW5tOGFE?=
 =?utf-8?B?L2p5cGhTZzFDSlFhTGFwd1JJaGE0bjFlOHJhYWJvVXgzZy9EaS9RcXZnOFlr?=
 =?utf-8?B?RjNJWklNMDRHa2ZtUzErTkpPMExIUG51ZTBydmhKUU9oTDA4YWorVWZhRjlT?=
 =?utf-8?B?Y2c0SVlaOGZHWGtJUExUMGpNTnVJVHl3VGF0UVpPcDBGaGdrempVN0hKT0ZJ?=
 =?utf-8?B?TFhBTGxOOXJBS1VtQzJXREIwcmp4V3JKcXJFOEZZRWdrK3krZTFLZGorVHlI?=
 =?utf-8?B?QVRLRTRDZEIrRTZzVWYrNEdZdzNZdFhIYUprUWdTdEhOd3pVUDZFNjRwN0lR?=
 =?utf-8?B?K1RPUGZqSGVISFhaVlhQU3ZZWENxWjR5bTZqU3BjMEpBWGNYWHhUMDZTVzhG?=
 =?utf-8?B?MWR4SkdTcGdhOFczczhjMTVEUS9ZU1Vxa0ZWQ3VGcStRbXI2d1N6YkliUTBo?=
 =?utf-8?B?Y3VoM25ORVFBeVZPQWdhU3FxdFpuY3BKYzVKS09TNDRRRFNXTHhMZkl0QStS?=
 =?utf-8?B?UDdHTEtqek9YOGRqZTFLZXFldVpPKytPMGt2eVA3TTVNakp1OE9BZ05CMXBr?=
 =?utf-8?B?anV0WHRodGZUWTB6Vk5PT1lEcGR0Vi8yNHRyTXZnZWpCMXJHZjJRUDZ4Lzd5?=
 =?utf-8?B?MUwwRi9kTXRSSDBxUXcyb3FGR05UQlcyQ0RtaXMrSVYwVUFDdTFNZk9GazZq?=
 =?utf-8?B?TVExc2pydTNnMDZHSlFrRTVYT29FSGpIYk4rRXFLV1pLclFPNDVkRzRMcW40?=
 =?utf-8?B?MUl6WkFOMEovdFBnajMzQmVYakk3aVJxWTdkNWgwV3pQTWQzc3BzRUNVT2Fn?=
 =?utf-8?B?alZtUFVaUGo3b2Z0V0RkaUpiWFZ5ZHJsU09UOUp1Z0xKK1RqTEg3M1Aycytq?=
 =?utf-8?B?SHRML0E2Sk9KenpBQXlJR2xJa1R1bXlGd3l3ODE0TlJCK2FvTC95cnNCMWdM?=
 =?utf-8?Q?3PKxL9EeI3tgL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjdUVzlRZm9nMnpmdXdidWZtVHl5UXliVWJqa1IzcFk0dUxDYXV4c0xNWnZT?=
 =?utf-8?B?ektNaTV1SnhCNGFjNVhHMEg2YU5xWmx5T3VOcFRqRUJBMWhRL0NibjdNc0Vz?=
 =?utf-8?B?b2RFRnlYZFBnWVc1blgzczErOEtlT3Z6NXV3ZVc5dC9lWnU5Y3FrYTBiWFhx?=
 =?utf-8?B?YjdNYXIxazFXYnJDenZUdVVoMktCcGZ3ZHNQUjV4WGJuMWJYZWNKK2lYUTZS?=
 =?utf-8?B?cE9lanUxZ1ZDQTI5eFI5TjF0bmg4N3NJaUVGM3Y4MkFENzNhU2lWZWRjeFYr?=
 =?utf-8?B?b1FZVkd5SmMrWWE0bTRNcEY0Ym9zRGJEaUVtR2F1YVNib2xQZkg5ejdEUHAx?=
 =?utf-8?B?M09sQlF5dkNEc1lpb1ErZEpZYit6clMvaCswYUk4cUVpbllsREtFamxRemZx?=
 =?utf-8?B?a1hSQ1U4MHhIbWR2Ti9LWXdqRE1QNEw4TkVDYXNscGFnc1BLSDZ0Q24zN2lk?=
 =?utf-8?B?VTc5VTJkWTZvdEQvWlpVWkRJZGhwWUlSUmJrOFQ2emJ0UGJRcldzcEY0MG1H?=
 =?utf-8?B?RFlCZEtVOER1Y2ZkdjcwUkJ1bW1sTXozWDlQblhFaDdQTE9wTHMrTGZ5NmxH?=
 =?utf-8?B?eDNzZEhnSXFyOXZ5bkNScE9TM0YwY3Rvb210dC9tQ1VuRU1WUUFzdXQrZ3dC?=
 =?utf-8?B?bkd2eUR6YitXVHhYN2gyT3JtNXc0NkhJMnFxQWVUOGVERFlTUlZ6bFF0RW9B?=
 =?utf-8?B?MGxLbUh6ZHU0WGsxWDZHY2dOT0Z4aEsxb3pnUHdnSUE2ckl1aVYvdFVOYUZQ?=
 =?utf-8?B?UWZzaHMyRmhBNzVna0RVK1kwcUxDWThtZ0twRXk5SzV0WUxiR2g1TzlKcGY2?=
 =?utf-8?B?bnJ5S0lHcnd2RVEzWVFEVERwcFZ4N2VlWjNhc28zYzM4RkVNZnBhY1g0cGIw?=
 =?utf-8?B?NmduUUZNWldSdUVCWjRzNWRqK3QweEVtb1F5TWVpdFhHYTRsbkVib0JseklH?=
 =?utf-8?B?ZmFuRiswaU1hMCt1QzlQWVVHSm8yNjMwdGY0YTZ0anh3bm9JZEpPRzkzeUxj?=
 =?utf-8?B?UFJkQ1RwRW9jMnZxaThtQUVEbFpBcU92MnNZcWpvb1RJYTBwZnN1QjNlOUJq?=
 =?utf-8?B?NGpIZWErRjdIYk5xdG9rMGViT0lBMzZFSWhLL1pUN2daTSt3UzFISmtuWFJ3?=
 =?utf-8?B?dUE5TFB0WmhlLzRGKzh4SGN4TmRnckp6bno2cVRxZENrb1dZVmlzVVc3cWht?=
 =?utf-8?B?N2txM3VicmwyTVhSV0NadndyTGhJMWpiWk1mODU5WG1RWWc3OXlxZHByQURq?=
 =?utf-8?B?c0hwZjNLZTlyVXpmcWk0MTZoeGJkU2lqWWgrYnVjZEU1NHJickZuSk1qT2VT?=
 =?utf-8?B?Q2U3YzIveXBmdFh5ajVzVkxPRVRDYU5HSGcrN0s2QXRMNUgzWUtZQlRFVnp4?=
 =?utf-8?B?NlZuOHUwcDc0MHFNZ3JqNUNNbFcvUXY1bWd6VmVhdGtCb0dzd01ndVZ2RFFP?=
 =?utf-8?B?QUJ6cVExbG82bVdEQk5tY2ROWTJaY3pGbFlsdjV2RmZycmpYTjhZNWMrTE1C?=
 =?utf-8?B?MFdyanI3TDFGVGdpVDVKTTNPY0x2MXJiVGlpMWVzZnBXMGdUQmJUMEplQzZB?=
 =?utf-8?B?bW1ZSmJ6K1Q2QkJGMERKQ3hMb3pLdXhlMmx1VjU3ZVV4cG5BRVBhWXloREU3?=
 =?utf-8?B?dDhQK3hOc3pxTlJ6ajJrTSs5SFgrRFhJcmcvZ2pKSm9KV1hnN0V3SFg3RnFE?=
 =?utf-8?B?MUpmK1I0Q0E3LzlSOTVWM2ZhNFYrS29VUi9vbk5UaGV5UkJaZmJYUWorUzV0?=
 =?utf-8?B?WC81a05nMXF2RzB2d3MxNnNRQU9DN1VmWlFDdXZHWlRFejljbStlYzVzc3Ry?=
 =?utf-8?B?dGRvaDZ0UWhHL3ZFd0dhcm1zSVZLNy91eWhRSEcyMHRnNmtqMkZpRDVHZ1Bv?=
 =?utf-8?B?TE5pSGQzTEhhUGlILzRVUG00NVdHWkxZU2lUdUpMV1dPUDYwY2M0Q2VNYzJa?=
 =?utf-8?B?UzZEanhTc2o4QXJDVEhydWVFendrMnZEb3hjQUVnNjFEUXErSkVhYzNnOHNN?=
 =?utf-8?B?blJUc3BlcWJONzZUOHRGejhpK2NQa3NIUEhZaEVPYTg2a29GZG5ETUxBd2J6?=
 =?utf-8?B?ZzVoU1ZBNkZFc2s4VElaaVhHcEExTDRyZzZ0cTFmb21Zb0V3S1ZDWmY4NzBD?=
 =?utf-8?Q?G3eDdpIIHcSxXBmfZVY26HbLR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ab8416-2ebf-466f-3df4-08dd51cc810f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 16:34:53.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H76D6BBEbEZ91zd3KwGcn0HStZzfozgjcQJ4wg/l58JQitbatYZW/8//jutnPCxprn8bQhQsRkkMYueYTrXESw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6719

On 11/13/24 10:24, Tom Lendacky wrote:
> On 11/12/24 17:22, Dionna Glaze wrote:
>> From: Alexey Kardashevskiy <aik@amd.com>
>>
>> Additions to the error enum after the explicit 0x27 setting for
>> SEV_RET_INVALID_KEY leads to incorrect value assignments.
>>
>> Use explicit values to match the manufacturer specifications more
>> clearly.
>>
>> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
>>
>> CC: Sean Christopherson <seanjc@google.com>
>> CC: Paolo Bonzini <pbonzini@redhat.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: Dave Hansen <dave.hansen@linux.intel.com>
>> CC: Ashish Kalra <ashish.kalra@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: John Allen <john.allen@amd.com>
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> CC: "David S. Miller" <davem@davemloft.net>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Luis Chamberlain <mcgrof@kernel.org>
>> CC: Russ Weight <russ.weight@linux.dev>
>> CC: Danilo Krummrich <dakr@redhat.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CC: "Rafael J. Wysocki" <rafael@kernel.org>
>> CC: Tianfei zhang <tianfei.zhang@intel.com>
>> CC: Alexey Kardashevskiy <aik@amd.com>
>> CC: stable@vger.kernel.org
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

@Boris or @Herbert, can we pick up this fix separate from this series?
It can probably go through either the tip tree or crypto tree.

Thanks,
Tom

> 
>> ---
>>  include/uapi/linux/psp-sev.h | 21 ++++++++++++++-------
>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
>> index 832c15d9155bd..eeb20dfb1fdaa 100644
>> --- a/include/uapi/linux/psp-sev.h
>> +++ b/include/uapi/linux/psp-sev.h
>> @@ -73,13 +73,20 @@ typedef enum {
>>  	SEV_RET_INVALID_PARAM,
>>  	SEV_RET_RESOURCE_LIMIT,
>>  	SEV_RET_SECURE_DATA_INVALID,
>> -	SEV_RET_INVALID_KEY = 0x27,
>> -	SEV_RET_INVALID_PAGE_SIZE,
>> -	SEV_RET_INVALID_PAGE_STATE,
>> -	SEV_RET_INVALID_MDATA_ENTRY,
>> -	SEV_RET_INVALID_PAGE_OWNER,
>> -	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
>> -	SEV_RET_RMP_INIT_REQUIRED,
>> +	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
>> +	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
>> +	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
>> +	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
>> +	SEV_RET_AEAD_OFLOW                 = 0x001D,
>> +	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
>> +	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
>> +	SEV_RET_BAD_SVN                    = 0x0021,
>> +	SEV_RET_BAD_VERSION                = 0x0022,
>> +	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
>> +	SEV_RET_UPDATE_FAILED              = 0x0024,
>> +	SEV_RET_RESTORE_REQUIRED           = 0x0025,
>> +	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
>> +	SEV_RET_INVALID_KEY                = 0x0027,
>>  	SEV_RET_MAX,
>>  } sev_ret_code;
>>  

Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E1B216443;
	Thu,  7 Nov 2024 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000040; cv=fail; b=IQjfOM8kwPTUKpY/tAJCZbuVVyFEW7iWKO2E3/tQbKfv5aZ2sW1RTXM/E3oUNlxQnDorfhFUj+pAXGS8nleGY2/P6VANScj9cpr7u6FhlrFhFK5PDC2lKtZfSIk/wqSOgufBgi9GU9pC8GxZVOFsRG0ikGYmRHr4CR0C+Xq9/6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000040; c=relaxed/simple;
	bh=i5JgLBj+j+/jyMqL+0Z8SSSjaHD6cflDqKi5WZ/0aww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QBASh+ZU01x6E7rHOl/PhEfGTQtKfOvV2IyDh1PxJf9kAM/H61/rs4mVBGODLg71kU2GPnHh+yGt4KoXwCScUAF00QPz9IZE642Mq2iQLz6n6bgkPc2qAQan3uxQ/K3FM7KnKtCoW1q56MC1QJayNTQl3Txcoobt+TXzRw/+Qas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mg+KOTzU; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mg+KOTzU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErjrRDSzZELf8WpgrUUVZKN83sxLpoqwLXGof4Q0LmJyqS5KRudYi+iO1Rk5grc/uTCfiP2VItnzwGwkHTCWWM/O2oBVGrIfQcfUWYabo4SnH0RsFXX5n0IN1jZbMsIr0ci/KQjwFSKmhZWnJdlvrYMKcq3cJcggYGS+KlGEumwoxBwJR41Yt3rYH2wlS+7mZLx6Mj/8Pj/9UsPkjUQqKd7hqHGAldXqfdW6LxrlrPF3/sZbKtbEtENhGdKt5+otV8RqWBJ7oemIrh6PqxewpVgCc8i93owgUfDHuoWDmChwl+Lrwk3XtsGaacmRTOw63bvqvrw8+xU0E2RjXTCPAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+6Zj1LhpVhV47tk5aoUJiJvc9OM4y3EMWEeP/8xDjg=;
 b=OUIXjtKWzwcoRQqPK8V1U0JRiQdZdybJEEV9R4bsJpPK3uFm/aGanVG8Hoq6T+7w2vxYizC9K0azp0dQfHVHfbhUuyM/fiN8nvUk5sBpOnhm7sV+voBM4fcI102yg9XajMxnS7s/j81ePhoq925Jhi8bN1GFzU364BTTfSYQKybCx0aNi+KDLwAjBWAs9rySPjemLlcYRDEe6Ky35ZtQdbGGLIQFMj+3xofLv1HmsrSGdMzr7kXTCjXu53kAwBm/ZGANruojb40fDfEm/KYbufLlX2otdTAJEd1ms5eV1rlps2rrb9SZn4J7xadDJh0ezaLfKkSr+qP87StXJFqLxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+6Zj1LhpVhV47tk5aoUJiJvc9OM4y3EMWEeP/8xDjg=;
 b=mg+KOTzUX0yGwkQUzfagPg30gt6xr96nF3dt3Of8XkyeJrqAYe4Srd8j00OlsejFyWdSW085yTSrYAz9uH9vGxB76NiZ9uwY/CiKqKR8EDxrJAqMEtAbt2GJwmt4sfXHBLo48eF8zXKp5tk2QThKWgewmHj6QCR75gMfykeSzeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA0PR12MB7076.namprd12.prod.outlook.com (2603:10b6:806:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 17:20:35 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 17:20:34 +0000
Message-ID: <3b321462-e62f-7d68-340c-fcb23ff3df18@amd.com>
Date: Thu, 7 Nov 2024 11:20:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add SNP firmware hotload support
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241102000818.2512612-1-dionnaglaze@google.com>
 <20241102000818.2512612-4-dionnaglaze@google.com>
 <91984541-504a-f029-47ca-bde538e07436@amd.com>
 <CAAH4kHYqQAkUO8phdQaE=R0qHZjKBB1uXsKR3Nq5yJxeZS-o=A@mail.gmail.com>
 <b0a5d1a6-39ef-2637-ece0-387582b09fcc@amd.com>
 <CAAH4kHbqE4X4zDFNLdY_xRhVCCWa_qaH_X2cyY4WbQfj-OkJGw@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHbqE4X4zDFNLdY_xRhVCCWa_qaH_X2cyY4WbQfj-OkJGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR05CA0013.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA0PR12MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 52699fad-d58c-4933-8b03-08dcff507cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWxnVXh0dlIyaGsvZ01oU29JbTFFaW5vWlBpOXVxb3pBaHVYbHE1cTZSTlE2?=
 =?utf-8?B?b052WkE4ZUNsdkJBdkh5MVAzRlhpTUV3b1p0YXlXMUZWbzZ3bW52WFllTnRD?=
 =?utf-8?B?RlJ5QXJ4T0QvcmFTWHBGWVp3SzQ1RHdtekpCcXF4MFNiQTc1VDFJUHEreGRT?=
 =?utf-8?B?R2EzdGlFeHlITkw3b1huWFlnQThDQWlseG1TcXRwWnFnbjltRVNrMDNXKzdK?=
 =?utf-8?B?QzNlVGN4dmo0Sk5YTVdiL3E4YlFQaXFWMExRWmtWcVA3WVdZTE5hZW1WM3JV?=
 =?utf-8?B?UWxWZjJuNDFJWXoxMVdrclhxUTQ1VjBpVVpUUDIyWFRyRnV6dmNGQ0JnZGxw?=
 =?utf-8?B?alRwWHIvMTRRMGZnaWRST0ttQlN4SnF0T3owenovNmpIbHVETlQ1Tk1TY3lD?=
 =?utf-8?B?aWVVelBVVlhLWkZ2QWJmNk9SazB0eXZZL3d1ZGhHdUEzTHliUVkvSFVKUWFN?=
 =?utf-8?B?UVAvbHA4N0xQdHZIMys4OGJrNEg4NWRNYWJJOXNIS0syVU90V1c3UEx5cDBG?=
 =?utf-8?B?SzFmQ1A0d1FtOU4vaXNoMldKODdZbTBWSldxVGg0MkM3b0FEZnhUbDFxcFo0?=
 =?utf-8?B?Q3BlRE56eGgrOG41YVg1Z0hidFJiZlhFRGdJeFo4Qi82a1p0Wm5vSFRMMGlu?=
 =?utf-8?B?VnZIUGszTWlvWm9qOXNqQTNDem5mRGFHckVmeUp0K25yRmVCeUV5bHRhUlV4?=
 =?utf-8?B?VXdsekxVWWVSL0hxbW9XOG9YSFVha1hJL0s5bkdmaFZ1OVV2VkZsR21OWGZC?=
 =?utf-8?B?SE1JYWwwbDQ3K2pFbmFyMTlJTkNCQWhJQzFuZjA4dUJGeTNZa3VxazI4WTd6?=
 =?utf-8?B?ZUpyV0wvYVAyR1pZSjdWV2xyQkwzSHIzZmpNLzVBandSRlNiZGQ0b09qTkQ2?=
 =?utf-8?B?UDZsbDh0OU5YUldVcGhubjNkUGh1NjNTekFlWXZOV3pkYWVlVVQyRktCcVlw?=
 =?utf-8?B?d0toY1Bud2J4LzkwUEorMkx5Wkk4eGNPNEJFcFZqcXRvbEFDSjNSUloyWnRx?=
 =?utf-8?B?TVMyblJmUjVyTi9SZWg4UkVpMW5EY21qVnVsYnZOWVpGNFFNTUJYaGttZnIy?=
 =?utf-8?B?b2hHZ2Y4SW1MUnRsTW1WSHQveUQyU1U2TnhCUXNiUWFDMUI0c1l2S3BnaC9J?=
 =?utf-8?B?emlIbFVCNk54eWdTQnFGVUprZS9aSnVsR2liL0orYUxlNCtYTHJlLzJEcm80?=
 =?utf-8?B?Vm5PTkd6ODJ6V2VSamRqWUx1MDA4czlvb2lkcCt5b00rQlc2TVBnSHJKVVY3?=
 =?utf-8?B?M2hQUFZmR2d5TElVNnBoSnNRVFZTYmNCNEpZWXcvL3hSV294dFhwQllPTFVQ?=
 =?utf-8?B?dzljQzFac2NIU01TN1dmNEgvRS8xTGhDaVoxemlIVkNqMFZ3cHAxcmwzUjR2?=
 =?utf-8?B?NlkzMnFzQ0s3bXNsY2pHdmV0QlUxQktsb2RZeE1HU2lML3JRN2FZNkl3aSt4?=
 =?utf-8?B?M0RFaVVRRGpNT1dPSTFaS2dFT1U0MThIejFuUWQ1OW9hRk1VcFltYTRyaUV0?=
 =?utf-8?B?dGhMc3gzMDlQWHJkQ0NxY3ZvVXYxVE81TTh4d3RidzV2SWtaOUk1UUpZTktN?=
 =?utf-8?B?RDNqOUU3M2E3b2Y2N1hhd0lBQWlncW9XWmM3R2RFUWduemZjbjBXTnFLVmoz?=
 =?utf-8?B?SEpDYVA3YnJ5RGFPT1hyK0xsTkY4bmpjL3p2eGFacVhKMGsxdDFkWitWK3Fw?=
 =?utf-8?B?Q1RXdFpibVdsYjFiYlY1RkI4QTZQVjBOV3J4ZVNEVXBHaXZCajZZaW5kRTJo?=
 =?utf-8?Q?4nBIYg81k3WEtm73/ufj0AaDY/Z3f7F2y4egS/k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHA0QzM1VTBSQ2FuTURlcHpkbFluVTg5R2F2NS81Q0pWRWI5VjlrQjVFOXhp?=
 =?utf-8?B?VDdZY0lPVUhEK0tOaEJqdzNUcklKbk9ua1kwRDVOV09LRTlXamdnVnVsdkND?=
 =?utf-8?B?QXdHU2pxWGVBUlgrYTlnTFo1WERsV09WRkV0czFVK3B4c2dBNllxODV0RnEr?=
 =?utf-8?B?OWNabEd1Y3pTeStnbVRjQnB4azdQN09HZTduUVVhcUdBRGs1WnVXTURHVDky?=
 =?utf-8?B?ZWF0UWdseGNQQm03NHdWZDVGZE5odlhrWUNrTmVGMUhRc3oyWWdwc3VpRytO?=
 =?utf-8?B?Uk9teXArM0MwOHdsMldvUVo5VVlLbkVsSkRnN1hxVHBHNW5sblMveDY3M1FH?=
 =?utf-8?B?L3IyWm11RzJRSzNVb3B2VDJ0SFhXYmxJLytnMFVnMmxyYVc5Z21GblJOc0lU?=
 =?utf-8?B?Z21xRWxZWWJhd3BGcFk2aVQ4Wjh1UzNIZldzTmVsSGRFV0NsbUw4bE5PWTVN?=
 =?utf-8?B?SWhxOWM1VmtVZm1FVU84ZWI0OGdRUWsvVFZlMEgrT1RIdUtpRi9Idk52bUZz?=
 =?utf-8?B?cnlST01GTHRqQ2hVempUZU85V1d5TTZSMExwQk1XcjIwdUJDTFVZK2M4QXgz?=
 =?utf-8?B?UjRWeFFTdjFjcjI0ZE1xbjdRWm90c0V0bDJNTGdPTmZWMzJ2ZUxmcWdFWUFh?=
 =?utf-8?B?a2NzT2RMOUlTYi9SdzZCWmJ1MVMwczJZeDR4WlVJU05FaTFweDBoZWh1VmtC?=
 =?utf-8?B?c2NQdjBhckJha2V1MTB2eTVKSDlPbUhkOXZTN1NuODZBQzZGOEZxbkI2bzZw?=
 =?utf-8?B?dHhYYUtncWQzRnQ3aEM2UXY1b05sWlJrWHoyTEJuZ2crcVNaU09DWVVLRVp3?=
 =?utf-8?B?ZFNYS0oxanBQM2M2YkFqZElkOEZKSkswRlZNZFdNeC8yVEVZeWJTaWxEVXR6?=
 =?utf-8?B?TWpHU1RsQmlnN0M3dkZGeTJmZHJ2Qzc2NlB5SDl2Y1pFZEdiY3lzeTJCZGJh?=
 =?utf-8?B?TTdvaDBYaXg0NzlGazdLTW9OeDNBL3B4ZWxQWW9kRWpGZ0J5Y25ZUzJaTy9r?=
 =?utf-8?B?NTQ5MnNrRHdwR01TQmU1WEMyb09nUWN6cWtZQmFEVTRHTjY1WnhsUHl1Tmk4?=
 =?utf-8?B?RXhOZEJUTCtiM0JCb3IxOFRlMzRyb21GR1ByalhGNXJnNFIzRW5HbytqWXY4?=
 =?utf-8?B?K2czODM5d0g3M1U2Q1h0UDVwUC9LVkUyWXN3VG1BYVFZdFllTERzVG9ZbUJI?=
 =?utf-8?B?bHN6aFBaMVNmRmxZVG44a1hRbEIvamF3VENGVkdZazErNFVDVEtWa3pWRis2?=
 =?utf-8?B?cFFNd3ljMDdqOTVrNzV3YXF3eW9oRlRzVHA5WG9FMFlvRVpzWFRiQWxUWEFJ?=
 =?utf-8?B?ZFpvcStRMFZudnRkd3MvVFRhRi8vYStNazRqNHl6RkFObDdudGdGMEZaMHp6?=
 =?utf-8?B?c3RPcXFEUlpSU3ZNY3FlSnVSMlV3dFBnZXE0djdzNGFtTVc0eWVRZSt5bjNP?=
 =?utf-8?B?NjRTWXRRZWoxb1BZNUpGeFh1enk4SGE0a3IwWXpCd05MT3ZPaW84UXUvNldI?=
 =?utf-8?B?WEtIUzNsQnU3OTVSNGhTY3o4Vi9qK2IycFpqRXFHTE9QZWQzKzlabXpxcSs0?=
 =?utf-8?B?S2RMU2dLdFA5dHlHVmhBZnRaaU13WTNqL0p2T0JNTjc3OWdVaUpWc3daQmUw?=
 =?utf-8?B?MDgxUkFjWE1FM0xxdE5DQ2VvNi9PREtrNTA3bjFGeWxLSGtpWExKNlNFdDlF?=
 =?utf-8?B?bkU4N09MR0ZsZUY0ZE1EN1dKNHlPOHlMYjlVMjlIeTVzS1p2bFZDMW90YlFo?=
 =?utf-8?B?dUNqaGdzNzA5dFNCWHpCZHpQdW04elVNNURHdFhENk9IZnZiUFlpNEVqQ3dw?=
 =?utf-8?B?V2Ryd3pDNzF0OUZkdFFyczUwcGkzN1htRzBLY2ladWY1MXpDMG1ueGFySERS?=
 =?utf-8?B?YnNVQmZFT0VRQzhiOXhGOHorTS9jTDNMZlhWYXYyaFlDQ2ZCa2l6UEpUaW9h?=
 =?utf-8?B?bWcvaVZLVkl0VWtXZVlWbDhvQU9KUWFoNUI3c0w1K2ZWQlZ2NXVyK3RPa1oy?=
 =?utf-8?B?OUZSZW1BbzdnVFJTVGlaUGNwV1dHZnlqTkwyN0VpTzFTYmxJRGQ1MUhKRlZm?=
 =?utf-8?B?NEFxeDhlUG9ERlFudCtremg2TG9QY3lkcHNCZCt3bWIzV0xxNFM0ODNqeEhP?=
 =?utf-8?Q?ZvttHUHSYPs7jIZH8631A5yMl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52699fad-d58c-4933-8b03-08dcff507cef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 17:20:34.0444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9aYOF3/3JWYLX79i0EgSXtNaOisSnowSwShNW306CwgckNwPAi0Pz4oO9NwW27OTu1J+B92eXdD9yBPvS51wbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7076

On 11/4/24 15:27, Dionna Amalie Glaze wrote:
> On Mon, Nov 4, 2024 at 12:45 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>>
>> That would be best as a separate patch series. But doesn't the
>> SEV_PLATFORM_STATUS or SNP_PLATFORM_STATUS ioctl() give you all the
>> information you need?
> 
> It does, it's just that sysfs is the preferred method of getting this
> kind of information. If it's seen as duplicative for the upstream
> kernel, then I can drop it.

I don't have any issues with exposing via sysfs. We'll just need to
decide how best to expose the attributes.

Thanks,
Tom

> 

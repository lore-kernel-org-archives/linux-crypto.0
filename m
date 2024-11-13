Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC117C0BE;
	Wed, 13 Nov 2024 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731515106; cv=fail; b=XNhbLCxrkFtwoaltO+xhO/fqkkRVpb3sIf8h7uD2FVYPV7iEQnGO3ro/pYpuJbGZf9KJR0Et81PnL3zMZ7rIBTO3MmyAy8sCAAGhpy5SkiqpkTd0xDSPSE985WFG3gUqem8lA4wM/f+U2I3fSxC4m+jYd7eaGgInECHfVRLeHpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731515106; c=relaxed/simple;
	bh=RCGmk53sNUh1t1yYB+IQKoABqm7qd8/eSxCNOTUz0Zw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nLg5IzxzQXKdK6pxr5dD/5zCR9KvdnTyPt7W+JQXZpcYY83zH236Aj7TxTjD2LyEvac0WsY4fCqHftlIJplWBnejoZup5+87mAYnujwVNxk6f9HCPkeB6dOahu9tzOxO23ajmrq6AFZy6ZSXT32QliFFgipd5MatWArVwmrBQGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Rh414g66; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Rh414g66"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCLXnei4A9kDjrhp+Txy/CXgoZMUqyi1d4Pjl+UZf1PI1LY4QAFtZDBJMBL+enUSzF/FmemzIJBciHQcKAlwD1Pc4X+sTi/DEnIo7BEnTfLopBXi9KLSzdNxEiA9XAeTYlkiag4QmkZSy2k8hhp8tpxz3/LxzUNx/ObCPWRDT1a5yuZjMy0+WaOZPR6z2WkWOnh+xTFU9SBXWRwySd+Vr8u6hB1HbEJojLfynx0LI1Ndy1sm82ey6UAceAlZj0CXBBQo0GBz+M3Zz1Ix7oy2tHC2USILmjeD2Mqori0B+B6q0alD+6OypH5hBr0NZRnq50XdoaFLsapkH2DAC9hHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGOQmLjWSlTBGAhNhf6NuOjAtA8LWGHxrKLZSwsoGKk=;
 b=N45/KJifhEWkM4IfQvgqm95EBsxafkCaTaADADXlK6VElAFdFjA9sH8566JHbqy2nENIWUkg2G9rcs2QV+mg0S6UV6k5CoFX5hgOhDvMF0KE7JSZzc3z88ddmVilF4hRhOm75jnh+8MAxV9pLDu9nK/XAb29r9KVSJ3c7D/0dqocNZV8cCnrgZ2Hj8UVczpz24r5yshffzISvgLawYA35hP/HF/YGWoWO+18kVFidVGNjBwGihox62tdlNoPFsdSJ7JI3RT0D9A4G8FIIjIufIMoGjYpIcVk2ldqlEsUEwlRKVW3jQzjvlIkWmigN3bcxVfHDEDxywq+VN0BxoRU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGOQmLjWSlTBGAhNhf6NuOjAtA8LWGHxrKLZSwsoGKk=;
 b=Rh414g66THNqlHRaTpl4flOVPF0XvvrDrOtT+avPJAMzjmMh6YopMM69kj8F9Id+38UX2o45hYZtqSrRgGjwKRgTeeRpLZdBFDC61abw1o2Xz9OwLh00FvpV3cP+ITrRMwYbXywLI7i5qq0srsgBgKmXb4K+1IUZ6bigoyWTsCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7636.namprd12.prod.outlook.com (2603:10b6:930:9f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 16:25:01 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 16:25:01 +0000
Message-ID: <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
Date: Wed, 13 Nov 2024 10:24:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 Michael Roth <michael.roth@amd.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-coco@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Luis Chamberlain
 <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>,
 Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241112232253.3379178-5-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0057.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7636:EE_
X-MS-Office365-Filtering-Correlation-Id: fad8529f-4563-44e8-05b1-08dd03ffb900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTRqSWVyZEdlWWRvUkFTNERYUjk3TjJGQStIdlo5TWw1Wm1GTXZzNUxaby92?=
 =?utf-8?B?MUJuTVE4alpwN0dnc0huSUNKZXFpNGtZVFJ4eVJRMzVGdUk0dmZTdXVlRmo0?=
 =?utf-8?B?UlBaYS8xUjNSUmFMZ3VPck9kdVlscjZ1Z0hLd3U3dm5hUkdWUFBIbTZhcFJo?=
 =?utf-8?B?b01yQlJGSHFSRDdoZG01VUloZkNnL2VhT2htQ2RKWnVVVVBuRkI5MEJaWlRY?=
 =?utf-8?B?blFHdzVXN3d1VUtWNWVxdVlHSjF4SXRVVkZNY0QrTWQ4Z29QbllRUEdUejFP?=
 =?utf-8?B?ZjduLzN4U1lvK2FOQnV6RkVpWWttQk1HMUxvc21kNHRzTm1FRm9jcnFnMWdu?=
 =?utf-8?B?YnFrbm5RRzlWS29oUUlud29SYXFQU1FwZ21tL3JDRU1oRE5zSnhYazU5VFhL?=
 =?utf-8?B?Ly9vMUFlbm42TFRhb1VVYXZTR1hJTTZoenhRdTYyTlhsOG1DY3ZrRVluNWxX?=
 =?utf-8?B?ck4rMUk2NmFveldoQkFUYmt3U1gzalQ4RnZlUTRjTXNKa0k5cUdoUTM4SVpi?=
 =?utf-8?B?RnEzaVlWclJtZE9NVTRvQlk4UmlSMmlNT2tMVWdIRGdMWkRvUm8yZTByYzE2?=
 =?utf-8?B?aVNNeUI0RXYyT2RJc2hoRFRWTitzdkN1UGFURlp4emZ0ZzFwMVJCR3BlTTVJ?=
 =?utf-8?B?bVh4eWJmNVgxNk82T212NldDNmwzWmF6ekpjTEIvQnZVaXI0QVpJM2gvNzE1?=
 =?utf-8?B?VUhXdUFseTRMYW9nQ3ZyZ0Q4WFZXcGhWbCtYdmk5aHZ1K0g0Q29UOU5SMUo5?=
 =?utf-8?B?K202UlVQSkZicUJBeTRhL0NIa2pMMnRkNGQ5RVE0VW1UOFFsSm1NNHFCcUNT?=
 =?utf-8?B?YnAxYzZYQmM3c25RZytEeHBmSUF3YS93V1laRndKd203bGdqMTBBWTYyWTRW?=
 =?utf-8?B?U2pzWXAwOHVMRForQ1Erak9ZY0VYLzcvanNzMGlrNjIvNjJhWHB0c2htNVo2?=
 =?utf-8?B?S0lNS1RtNTUxTVdRZVRRZlNpU2p1aVlia05JVXpPUWlLZCtGelZpRWFqYzE3?=
 =?utf-8?B?bXB1OXlJODB3dEUrY0ZGYk5BSTczaTd5UFdxa0NxOWdYOFJiL09zdmxKMXRK?=
 =?utf-8?B?aTdJcHQ2OXlSanFtWlA0WmZJRjZPbnVFVEdONHowWXliVSt3K1pyeVMzbnhN?=
 =?utf-8?B?bnpzZnFyUkVIUHRwN2d4ZUNSN3JRblAyRVZiNWgxN0NkZVZ3L1gyank5TWtV?=
 =?utf-8?B?UEZJelQ3SXZkTlk0c09PUTFXSDFmNXZZdkZKN0JNUjM4MVZOdkxXV2hIV1Zt?=
 =?utf-8?B?R2V4c1NDMTFWMktkU0VXc052VFB0L256UmdTMUhReUJQTFNXWUZoeUx1MGUy?=
 =?utf-8?B?bDkyaUpLbnNGV0tDZzdVL2tjQ0RtMitiaUZ2ZDlPR1NnR29wYTNObmtnL0tj?=
 =?utf-8?B?Z2hMNDFzeSsxQ2UyUmVjMmpwbUhuVEZWc2JLakFuQ0ttZnRhU0E1cHM2Lzlt?=
 =?utf-8?B?M1hoeDg3UERKbm5LVWN6dFFVaUpJVXBBcGQ5d3FDNFdySGxINXE1cFNSd0Nm?=
 =?utf-8?B?TTVjaGNMMHdNL1dIQzVVdmlQenRVanJ3Q2FHMitMMlduZXBQVHI5MUs0S0lQ?=
 =?utf-8?B?UEVwYWdoWHdRVit2cUVTWWM1c2hKcmNUZkt1M1djWE00UitMNWhBNlhXdmQz?=
 =?utf-8?B?S3ZCTC9ucmpEOGdXdk1kc0dhbDZ0QklHYVpVWmovZTJ4MnBnN2dwS1VJM2lN?=
 =?utf-8?B?SHVTbzVsa2pXOThQamtTTHVZK0d6NDRNZ25FL1p6THhZUFYrL2lKdUlRMlVC?=
 =?utf-8?Q?Nwa6LyCoe0r7F0OjS8xO/czBvYsgW36SPZx6/2b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUtrbkJaSzZPcUt4NWp3RTFFZGxSOTEvUmxadW5VS3lSSmt5cm01VUp2VlIz?=
 =?utf-8?B?amZERytYZ0s1M1BZNjhnMElweDdvQkFVR1Y5YWFua2k2RHJpWTBrSHhOVUlP?=
 =?utf-8?B?QVdCMDQzV2xNOTNDU3ZKeFdJTXF2TWNUZDRESXlFR1paNHBsMURqTklVR3ZG?=
 =?utf-8?B?MzVzNjhpT3ExN3hNd2srMXNjMk5ZcGFuN3NZdHBOeS8zNmZoSlAvUDJsSlh1?=
 =?utf-8?B?dFgyTWtRMWxiQUVWTEdvUDlETDh4K3plMG9TcmsxSWd0dFA5cnQ5bjdabS9n?=
 =?utf-8?B?c0w1WHBRb2JkK2pzVkxqNFplZlFWT2R6MnFqbk9Bbm96bXU4bElKcjNNajRv?=
 =?utf-8?B?TG9RUi8zVCtHeXphb2FtMTV2TnZPSlJHVitmNUtVTUp2MG9reERsQ21YNFM5?=
 =?utf-8?B?NTFYc0o4YUdKd24zOTVBdmlyNk1zQVRxUXFzeTJyODN6OEF2MnhQbGpLd1hv?=
 =?utf-8?B?cHpuNE5ObklvaThVZkR3bXdtZG01bEJjdkJ1YUJxVEZTRmdxT1hPOTlmSyth?=
 =?utf-8?B?eVh5WUxSMk1hSzJVaDZDR29KYTlTK1JzejQ5QmZNR1lCUWF6QklaQVZLbTBE?=
 =?utf-8?B?ei9oeGREL09lcWoxTkg3Um5PRHlham5KcFloZHdLYkkrbzdvWDFLQzFjZUVJ?=
 =?utf-8?B?ZjdJY3U3a01NaDJ4Ym5OL0NZRFFzbW0rWmdPMDE4bjcrVmZZVHJEdDZDLzNI?=
 =?utf-8?B?WnFYd1FZWWlGRE1acERzSGNDSUw0am8rWFZvQUUwQzhCVnMwWUhGWFJqaTVo?=
 =?utf-8?B?LzdPb2VuUXAzZW5NMklyZ1pLL0l5RVo2YTdsdGw1MjJ6NGNxblVYTVJETG85?=
 =?utf-8?B?dmFPWEd2ZGpBeHRmVGhRbVgvVFF1V2xpeFNJK0YvV0hUc042MVRkSkNUd1hT?=
 =?utf-8?B?TmxXcGgrNzdvQ3d2VVRZa2hrc1NKa1p2Nys2bVV5eWlwOUY2K2dWNjdGM2s0?=
 =?utf-8?B?U0NJK1RzbFduNGtkdzZWNnQzcGNXQTZRbzVOS3pjOHFleVRhWWFTbkhLckox?=
 =?utf-8?B?T2Y5M0s5TUhMQmNTVkp3bVVGY1hHSjh6UUE2b0NhN2NBcjVET1R0RmcvWnBm?=
 =?utf-8?B?QVoySTUwQkhJRjdiZWZUVktrOGhMWllJTDNZSUVIeWRCdERlKzNCZTl5Z1pw?=
 =?utf-8?B?dktnZDdLU2Z3VWJaQzJmNkVyMkUzNld2MGxTd3NDSkJOMG5tcThkTDlRaFBJ?=
 =?utf-8?B?Z1RQSERCbEluSysrLy93eTAzWGkrWXpSaVE0bUpGbTBiQ1BPTnJJMHBaRy9R?=
 =?utf-8?B?Zk82NlRrbjVkSHFjK3NEb0JhRWowYkZnaDFJai9ZdXZ3YUZsa3F0UkJxdXFp?=
 =?utf-8?B?Qm10SDFHVkpVZWY4VGVlSkdJclQwRHd1cFVLc0tDTGp2Z0EzQkNQWGZhL29h?=
 =?utf-8?B?M3ljYVN4WFd1cTY2ZTRLWjBLczJYWmUwVTkrOGJYMlF4aUxQZnV0c2lpTXFw?=
 =?utf-8?B?Q0k5UVFiaHRrOTV0Y2crV0xXbnNIUGJZa0ZjVkdhMkJhejk1TE9jRkZkM0N1?=
 =?utf-8?B?MGZSTnFOUVJ0Wlg3QzRqVWJoOXRZMFp2MTZLWkc4dWM2M2lvOWp2MFhwM1Rl?=
 =?utf-8?B?cmhZM3VFSjlPeE5FU1NFVk1lY29mQzZnQkpGdlhqNTFSdXVmc3laZVUvbC9E?=
 =?utf-8?B?WGF2WU44K1hBS3A3SllBa0srUUJZKzk0b3lhbkdUN1FUUHo4eG4wTnkvWnVD?=
 =?utf-8?B?Q05lRHBlRzRzM21aYmNyTXkvNG92ZXVQekZBUk1tVDN2SDNpYzc0NFpsUHBs?=
 =?utf-8?B?eDlHN2d6QkpDUDdYRnozajkzRXpiUWJ2OWdmR1RtVVJheUIyaFV6eFk1MGFw?=
 =?utf-8?B?Qms2bzNCSlBZK1l1YXV5Z3BPK3c5YlVLNmNqZ3Q1TDFIZUg0RUxGbUMwajQ0?=
 =?utf-8?B?ZE1qcWFTMDdFWnlhRS83T290aTFsWWtvV29xbnVGNGhEeXhqbXF0c0lVN3lC?=
 =?utf-8?B?Ykh1OVNDQVBGRk4rTzRrOGNNamsxL0RWVnZGK3JwSkVSSFdxRTNFUGJhRkVw?=
 =?utf-8?B?MVBBWmZlNXRjQWlRdWNzc2JSWTRwRUUwd0NhSU1JRUIyeVN5NEpLb2MwNXlp?=
 =?utf-8?B?Rk1DZ1NGYXhXWVRBbUhIa2pObU4wRmthZnM0UXJtaWNSSExCTjIxMEdtNHMv?=
 =?utf-8?Q?j/LcWMrN2X6qNMa8t6AFrBlng?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad8529f-4563-44e8-05b1-08dd03ffb900
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 16:25:01.5144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mBhcBpEfVWM179iVe7Qx6/VwQX0N8cOcE+spf+AK7pQ2+YmQWTq3PVjwCcutIi794ziqQ78UQ5MX0dAgxOGQUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7636

On 11/12/24 17:22, Dionna Glaze wrote:
> From: Alexey Kardashevskiy <aik@amd.com>
> 
> Additions to the error enum after the explicit 0x27 setting for
> SEV_RET_INVALID_KEY leads to incorrect value assignments.
> 
> Use explicit values to match the manufacturer specifications more
> clearly.
> 
> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> CC: stable@vger.kernel.org
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  include/uapi/linux/psp-sev.h | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 832c15d9155bd..eeb20dfb1fdaa 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -73,13 +73,20 @@ typedef enum {
>  	SEV_RET_INVALID_PARAM,
>  	SEV_RET_RESOURCE_LIMIT,
>  	SEV_RET_SECURE_DATA_INVALID,
> -	SEV_RET_INVALID_KEY = 0x27,
> -	SEV_RET_INVALID_PAGE_SIZE,
> -	SEV_RET_INVALID_PAGE_STATE,
> -	SEV_RET_INVALID_MDATA_ENTRY,
> -	SEV_RET_INVALID_PAGE_OWNER,
> -	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
> -	SEV_RET_RMP_INIT_REQUIRED,
> +	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
> +	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
> +	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
> +	SEV_RET_INVALID_PAGE_OWNER         = 0x001C,
> +	SEV_RET_AEAD_OFLOW                 = 0x001D,
> +	SEV_RET_EXIT_RING_BUFFER           = 0x001F,
> +	SEV_RET_RMP_INIT_REQUIRED          = 0x0020,
> +	SEV_RET_BAD_SVN                    = 0x0021,
> +	SEV_RET_BAD_VERSION                = 0x0022,
> +	SEV_RET_SHUTDOWN_REQUIRED          = 0x0023,
> +	SEV_RET_UPDATE_FAILED              = 0x0024,
> +	SEV_RET_RESTORE_REQUIRED           = 0x0025,
> +	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
> +	SEV_RET_INVALID_KEY                = 0x0027,
>  	SEV_RET_MAX,
>  } sev_ret_code;
>  

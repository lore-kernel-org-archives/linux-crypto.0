Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555B370824;
	Tue,  2 Dec 2025 04:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764651471; cv=fail; b=Kx1TYheg5N7IiX66Lr5EwflZ+0eGH3Gv50XTdiM6hSQ/KjwcnwUZhbu+V51mkA8iDyeQoZi6L1ug7WqCB7WLx07kasWk+OwCHV8ZGUjupIFfCx09jqgKHUUMEx8OnCFLIOnEymtuDAwxZ12IceWd07uAxq0AeuE6O+fAmKmx2c0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764651471; c=relaxed/simple;
	bh=tKvbbho/VEtrvmpqjNfhaoITYv5nuu1/1yRGnDbnWjQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pda96fzkj9islLWs2r8E7Lq3DbnGlAiseEPI+K3I7mE+O61HDLA/aExMrmpXoLeCtMEsmL/bdyio+Xoi+UzD4dgN+1i52qJJPJc/QG5ZdQMYYshl9ros9+9LVwfgjldh7sSKooE7SPdeSeShkBLgHFHtlewbvcqHDYODh+m5v2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KK4Fkh05; arc=fail smtp.client-ip=52.101.52.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KK4Fkh05"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/2B0ZtnL+rprQ89HzZ9QNZVgnuvwOwFetEyhXIz47FTpDiCZgoWd+0jha6GxQUCpahFE4g+HQlBRxNtj5LyEJNXCMinKp+X6Qc+4m1rETgLOah/FbrhoVs3fxyclTwGRviQpeoPqtBOvcjXcRIwoLlSRTMNk87Bt7D991sZTpjSDHsyqBcSJBzh6v/kpmoSaXYHyVAaB/DSrlxaUlkRtwjhQ50eKs4jusgTmU6LQ5aZITaCyg6WlT5ktbtC37LFO8AF2kESciPNyz68RyMh0GejpiF4xRs/+kh6YedZsfM0DR9BlUTSMh3fQ3CDJV2RBwWnP6sgyarAqkYtFvYy1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cPC8e75HMKTmJHD8A7fQvnI9JxiR0K3Fey6EMMGRUFo=;
 b=xDI6KWpV0pDJ4YyBj9A4N5L9LDh4vR+ou1CoEhWwStgkBd+rubnJIbSGX9thUxYOJxZCFLLetu+uxlqxV1WLX42e8sCPxr/6mF9yamW3H+1duLDBYIUzVZnc/pofbpe3PF6SNJsLhgiIdarIzEZrynAuiix8LvExtbhhvAf3uZBdqT+gaC+Rb1HcyIpKVInVa7XWIrSdtcj8/Np5cNZI1RHTBC7joZ38yT17VfLBIU4EraHuqpee0NM8yLSG31kmPXxxCFt6MsCxjoL7htg5Z9CKeqkb60b9uJiAF/r7bXVmQJpDYGiV9z3ywO+1Ea66A5qE8OnW7rMEME07Xh+AqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cPC8e75HMKTmJHD8A7fQvnI9JxiR0K3Fey6EMMGRUFo=;
 b=KK4Fkh05TCscLCGzd2mpwMQxbDcTxfC1ngNhf+r4/B/Td/GftHNWY0jAa4srT8DK/nR5oMvSTr7eTVRiSISMmVW+hFNyYj8I6zbEuMuEP0kU2fe9blMYxfMN0SIEMD3sDdmIM3MARngvHnS+nper5fZHIovkbr57bRrL+6Hu9oQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 LV8PR12MB9665.namprd12.prod.outlook.com (2603:10b6:408:297::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 04:57:45 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::a5e0:9d7e:d941:c74d]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::a5e0:9d7e:d941:c74d%7]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 04:57:45 +0000
Message-ID: <be439730-baf7-4c0f-86fd-cd84b8e34158@amd.com>
Date: Tue, 2 Dec 2025 10:27:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v3 3/4] iommu/amd: Report SEV-TIO support
To: Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Gao Shiyuan <gaoshiyuan@baidu.com>,
 Sean Christopherson <seanjc@google.com>, Kim Phillips
 <kim.phillips@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 iommu@lists.linux.dev, x86@kernel.org, linux-coco@lists.linux.dev,
 Joerg Roedel <joerg.roedel@amd.com>
References: <20251202024449.542361-1-aik@amd.com>
 <20251202024449.542361-4-aik@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20251202024449.542361-4-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0169.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1af::13) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|LV8PR12MB9665:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb5757f-978a-4506-939e-08de315f54b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHd2TE9MT08xVmtITWw0VjQxYWptNHhRZmVNb0xlbkt0aERNeHRmRUwrKzVW?=
 =?utf-8?B?SWRjNVRkNS81OEZvaEFMWEVaaHN2RlR1SFdPUDNmU1NuNzNocUhkNURYbC9J?=
 =?utf-8?B?dnVnVCtrRlZha2lOSlFkU3p0K3JHN2czcUMybnpNQ2hSRWs4eGxNYWpNZXh4?=
 =?utf-8?B?M0ZKamhyanBzTkovaEZ0VXZnb2JmN0cxUUxaUEc1M3YrM2txY1ZBQXZOZ0M5?=
 =?utf-8?B?bnBMNUpCZEhGZjlHYllmdVRsM01BeUxhVGE0aHFOZmUzQ0daV0p1eUdlNHU2?=
 =?utf-8?B?ZG0vMU5VZFluazNOK1pOSGRQYlE5eFM4MFNhUjNQVzljRGppRUNVU1UvQWJC?=
 =?utf-8?B?Y0UxdlFsZm5DYmI3aVlKZnpXZ1RWeS9lOUVsZHBGVjJPZHRIdFM3bnpNcnRE?=
 =?utf-8?B?b3NEdnF6cTFPdnpLQkhJTjltVFQ1ODkxdVV0WjQ1bWtwaXY1VUZPRmZwLzlM?=
 =?utf-8?B?N3llOEM5ZUZEaDRtUE5zR3VYSmFxak5pWElLVEdONlJ0QjQ2OHRDVEpvVHpK?=
 =?utf-8?B?Q28yT2dnWWtwOFhjL09MeUJIYU9kb2p4Wkx3SStCTkhqYlV2ZnBieFRhWEFh?=
 =?utf-8?B?N0w4aTUzRS9HcjZidnVJcHlKTGJmZSs1YjNWNDY5VlAwWXVnb1AxMUZuNkNP?=
 =?utf-8?B?QXpnQVFzeGlvcWQzY1pweDg1aGd1S2RsaGwweGZ3TWEzSkFPZHA4MllUdEQ5?=
 =?utf-8?B?LzN1SXViM00rWGZmc0d6Zy9QWHdJTC9RMTh2K1FTbjFxeUJMT0JpRGxkRXV0?=
 =?utf-8?B?QjJVVS9acFd3elRsR3NpZXgxQXBVblkzWTRxVklqdWNRZmJSMWRwdzRwcTBM?=
 =?utf-8?B?ZDFsV0Ura1h5K2wzY3BIN093aWs0SEtqWCtZa1dwajJpVmpKb055NnkvbDAw?=
 =?utf-8?B?VXFhTkNWeDZKMVpudnZlWkZWbStaUE1vdzNHTXJQK29icEw0WjFyUEJzNVE3?=
 =?utf-8?B?aEUvOWpici9FMHFicTRZV2xCQ2RpajBmdUtWN0hyYzNQT05qQnZqTmNLZERI?=
 =?utf-8?B?R09CRlBxSVV2TVZacnRROVNhOGd6K1ByeEg4UmR1WC9CTkY1OFB6cE85eGxY?=
 =?utf-8?B?RDlremc1SnU0Q3hqUHZWR2VMd3phcWEycnM1QStMekRkaHpLNmNPLzNDOVRi?=
 =?utf-8?B?UHBGb2RTU2cvTzBtYW44Q0VTNVM1dkFIWVlIMERYMWcveTRzNnZQWlo2Zkd6?=
 =?utf-8?B?VnE5N2d4VitvZXJwaWljZ1g0dWo5RElQK052WVMrbzljblRXTHVzUGw2b05s?=
 =?utf-8?B?R1A2Q3BFUXJyOE53L3pyS1VmSER1aHVkSG05WlV4eDFXeUV0SFZVYWtvZXNu?=
 =?utf-8?B?bC9jUXo2NE4xLzNzeGpYL1FkMlFyZTNKY0pycWxCcWc5aFB1M3dEbnJ6VERh?=
 =?utf-8?B?ODQvamkxTzRqZ1k0MG9XSmVadkRERzdad2haZGovd2E0SlErNW9VTnp5bHJN?=
 =?utf-8?B?U1EwTzdtcjNIbGVTWWtyS2ZtVTVhSUlCOTFBRXNLR3Rzc3QyUFFtdEVJUVFt?=
 =?utf-8?B?UmdjcG1QVWkzY1EzdGZ3RUhzU1ArdUpsTHVqeE85ZENzcklEeFpZOUZ2UzFT?=
 =?utf-8?B?d3d4dmowV21rRFJseUZpVkgwMTM3UFNFZUp4WXZIb0hkVTBIdENXdEpXdzJx?=
 =?utf-8?B?cVNsK3ppOFBFY092SXp3RDNuMkhhK1RmNzA2QjNPNmFmS1kvdVovTS9oY3FB?=
 =?utf-8?B?Z0dreEE1OXQzZzU0REtHYkpsd1dwZVF6UVhjUFFReUZzclRCcXd0dXozZk5z?=
 =?utf-8?B?dXpaUHNrV3lQelBOZTk4OHovcDVFU21GMzFnL29SaUJwU2tSTlpWZUxWc3I1?=
 =?utf-8?B?OTl0WWtkZjdRY3dwa1hVaG4vdTBiMGVzdVZxRFhRTWhnTk1OaVdLSXJhL25m?=
 =?utf-8?B?MTR1K1hwZVVtN0dkTWwzQkVpN0grdlFNR3FldTFkTG9VRGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEdicGE4b0ZZUlExbFF6c2JpbVF6UmxFL1BMNGVRWjlJcjZRN2tCRDl3UC9h?=
 =?utf-8?B?bThQTWQzNnNNM29NRVk2akg1aGN0bTIxRGwyRk9Wc3ZJakprOFlLbmI0RktB?=
 =?utf-8?B?aXNlQ3JDaUhBRXVOaStaekVXZTNweHIza0M0amxEYWpYV2h3T3ZBTzl1a21D?=
 =?utf-8?B?NXJqZnRqd2VudHk2cDkrTFlzY3FKai9OQVlIZFdwSTNWK0Z5cFdSQUdDZnp2?=
 =?utf-8?B?RVgzZ0JuOG10R0dKTGlxWGJ5eG5PMGFwWFk1NTRMZ205a2Y2WUVKVmUxdmI2?=
 =?utf-8?B?Z0RFSHoxTzZSRGY4TW9FMWNOZVVkRVhFVFNaeGZJemVPd01VZ3lqS0w1WTVF?=
 =?utf-8?B?NXNpTENGTzJqMERYODJTWWZOUG1hNk1PM2creWk4ZXQ4Sm1Lb3EwV1crNVhv?=
 =?utf-8?B?eWt4RUhwMGFETE9kWStqN2ZyUFZHdC80NUlJYm9OY3NhNWljbXY3aFAwbmtP?=
 =?utf-8?B?ZGFzQVlDeEY4ZE9id3VCNHZmWGpDWUpDM1gxOHV3MXRXUEVjV2hXY3NLYytr?=
 =?utf-8?B?M3lnL0pzQWRkRXZRU3lkV2R0dHVlUzFsTTlaRXZWRi80dlc2bjl1R2xJNjJK?=
 =?utf-8?B?K05GVmtNMWJWMFVtWllnUDhYRDkxWnVyK1hZTWM5Wm13QWJ6VDZhTi93YmlR?=
 =?utf-8?B?Nk5HRVF4RnZ2UUNTaGUvWDZTUDQydktqZmtOS1VVM2hmMTBra1QveU9XRUxT?=
 =?utf-8?B?dUJHMVU0VFlxWURTYVdHUDdqdlg5OTlVOXVPQldDT2hFcnZ5OVZ1cUdkbXdx?=
 =?utf-8?B?Z0dqZm5ZbEkyR0x2TmlCWnovYVJOMmZocWQ5M3Rad2lOQm5namtReE1SQ1E4?=
 =?utf-8?B?ckJYbXNraXpSSkh1ZVJBc2pnQWd1TFkvbHA0bDRGU2tvcVczVnRrblhyOGgy?=
 =?utf-8?B?b0dHd2tHYWl6MG9VV21kNkpibnlUSkJRdnRzaDJtRmFzVXc5YXI0THEyRlpQ?=
 =?utf-8?B?a2RwWGxZQiszVjFWZ1E5N0NOQVl0djhnSkhmN01OUTIyRXJFS29pTjZPZERT?=
 =?utf-8?B?RHJzbFprdlJMQXFEZ1hSUXljcVlyanZXTDhGRGgyL2dSd0ljYzB3dHRNbFZP?=
 =?utf-8?B?R3laS2I5aVVqenppd1pXNjJOU3UvcFcxNittc2xWbVg0VysvT3ZqSC9DZUZY?=
 =?utf-8?B?M3hOSEZLMVk1NnJYSk5uOTBPSFNkUElGYys2Zk9ET2lBdTZuL29iNXI2bHN2?=
 =?utf-8?B?bW85cDBLL0xlMUxzMDVXNElWZnFHcGRYNFMrSXFRQ2drY1JxTFVaZ2ZFTzBH?=
 =?utf-8?B?OHhtN2MzK0ZtUTRPSzh6MFhocE9DaU5uN0F2aThHdVB4Y0QzVjhVZUN0a2du?=
 =?utf-8?B?M0JyTzB0QTc0RXhwdTZxT1FWQ1RJdERqVEFMZjllOVkwVUdKQi9FeHg1Y2s2?=
 =?utf-8?B?S3REZ1hra1RORGw2MG5sRTNEWEJVbCt5OFAzYi96M09aUkZuaDBiV3Vicktu?=
 =?utf-8?B?cThtSUI4MHZmQ1c3dkFDY0ZJWTl6SFFSWGwrOGZ0ZGx3RlliYmtzOG4vZ1R3?=
 =?utf-8?B?OTl4UTRyWW1BeTFzRzNzZmgyZDlVbW1Hb1Rzc1RwV1VlVFdzVjdneGpOdnB3?=
 =?utf-8?B?TGJxU29uNDllMnpNWWRHcWUwSEFEUWdSam01WXVVSWp0NG5QUFZtVlZwMEt2?=
 =?utf-8?B?M04zVFJCbDBCQVVmTng4eFBiR2F1UjQwNm5YRUdocG9CMElDUjJUWG4zQWV0?=
 =?utf-8?B?R3U1RzI4UVRPOVdBSENEQTYwL1pTYVlwYUhQSzF0dHhyVzkrREpjM0YwRXJq?=
 =?utf-8?B?cnJqdUEvVmw4UFdUYmt5V0NRalY2THoraytsajhmaGw1YzVFejVRQzJQS25q?=
 =?utf-8?B?dUNDbGlKU3lmODdGTCtNNGhxMFFwZ25XYlEyNmR3T2VsSXNRa0NCMzlkZnZP?=
 =?utf-8?B?K3JUZWM1bGFQUW9HUFhQanAwbkgrVG13TyttVE5OWGxWRnNqdTJtcjdJRSt2?=
 =?utf-8?B?ME1LWnRQVlp1VVEwTCtuU01NcjI1cXlTVWxJQis1NHhSNkVuY3pRekhXc0NK?=
 =?utf-8?B?T0c2NTR5SjR2WXZWMCtzUStZanNjSkRlT2lZZUtacmdyVU5JUGVPaTZtcGc0?=
 =?utf-8?B?L2toOWNmcnEvNUVyYTJPQ2p0YlFlMG1jZEg2VHhpem1pUFFlbkUyYjhXSUl2?=
 =?utf-8?Q?3o9zP2brrJRu9ZQRZlF2Rdvb8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb5757f-978a-4506-939e-08de315f54b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 04:57:44.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j0KmhItnxzL+NbzzwKirEnkTZg2+LKA/MNq0fku3vfv+TdU/aXHHoGizjHwV5rbVhj1fL+ZMldN94SqgXA0Shg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9665



On 12/2/2025 8:14 AM, Alexey Kardashevskiy wrote:
> The SEV-TIO switch in the AMD BIOS is reported to the OS via
> the IOMMU Extended Feature 2 register (EFR2), bit 1.
> 
> Add helper to parse the bit and report the feature presence.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>
> Link: https://patch.msgid.link/20251121080629.444992-4-aik@amd.com
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


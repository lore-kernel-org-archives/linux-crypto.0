Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012006.outbound.protection.outlook.com [40.107.209.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2A91EDA3C;
	Tue,  2 Dec 2025 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764687157; cv=fail; b=WhHeNq9DXB4tuLzoxhoPIjVy03LdCmfuKiO/FpDlxAxGAGhRuMPONjVtpor6Ya6MrULMxoAugkZe9IrdHd/aO2+ksA5+LkbwUbn2blrld/0XGwGAev9FPAQLsjqVA4lxndsLUZp85Qu3a690hSZ/ZFH8/REUxRGlc8kDhbLPbko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764687157; c=relaxed/simple;
	bh=p5UfqwXt+WNIBZQ7fF3jeZQ+wA3/FcqfdDXSmcdtkdE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d3sZq4sbe7A8bwk84wcTiWSV4MDW68lIiM49KiGctfMUAWscr+Et/KAyCmncsSKlRZXsv4aL0X17osOSBLVbuSiNufnA8nR4opDWMYfrVYxOghi8wnXwR6DJnrcBMUPVk0gAmQZMtSGj0v4YK44a3VU35lCZXHCz0mAeQJ0iQLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UtdkGkFT; arc=fail smtp.client-ip=40.107.209.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UtdkGkFT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpnc7Ck+cHyV1YesqmKnLq/Rv2CYH2rhcSNew44kdmvuQqUFpQ7Y5at6XtR5n/GG6liU/lkK4FuCRoDPDeysmgXgULVDKhIa/mgFS5e+oXb2kOsYr0JmLf+XrsBL68OUZGl3OPenUvrD2n9q0eby8IVqU2U7GbbbPIgqaNieFtMU5z7m8iSII8YXDz+CjqRWEZKf9VMeWanh7EfUwxExNEWjTo9vUFbbBTSPgtgwGJS+eGcv3jpsP5EJkOJ0qk2pnszLbX6ZfBmGYhve9F/oqbrIVjQwKkbpAbk1MFXEvQCjBBVQCrbIO30Uqowf2Yjnt4FZm380qfuae7Wyl/iLXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6Jb97/oCsvlcIdP7qpz3msjcbOCbYIChw4b6dOAUuk=;
 b=IZ6+S2XVOqmwwwhIT9w/Wi6NSyTntEs++cYQ8xNtM9tuVf1LQnJhUImynbZ6h2x3onUVSByVlVtDYusRUaqTHqR8FFrdwrRE0NAoh9bML+uapxSogUXKw+aYE5AM0CNWNzil9sZp2837o8nheS51xieWEv++AjQCX66QXvHf94BhpOZdOh81KnRldUyJe2UsWAzaF2xc/uZU3qckJff6ScXLQdQSF1STE6tMn2OzChkc14Gf+ARauPwzH6NOwnnGtP2fQWwBmPuxeqMvVXqc2oDdClmBrxyGQn3cvzHJ6li3XF6bSFKeUcyRmzbEVjZkLSPnfMDfhBUbpL+kmSmilQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6Jb97/oCsvlcIdP7qpz3msjcbOCbYIChw4b6dOAUuk=;
 b=UtdkGkFTacmbC5yOkvn+GP1pBrgu4RjZuLzZHtLscwG9PRZNl9sX9MUF28HZvmrDLQt3LXgaDnCVh67RB2Y4+dEGa4Icb1Noon7Ji9f063TP82mCHwv1MM2n3bY+/cZaGa0VQWO4EJ7Nz6SKE4E6JZfObFGCpbGjhkjzn24VNfI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB999081.namprd12.prod.outlook.com (2603:10b6:8:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 14:52:32 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 14:52:32 +0000
Message-ID: <b6d45b8e-3eeb-4b96-b781-e0ad28861a2c@amd.com>
Date: Tue, 2 Dec 2025 08:52:16 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v3 4/4] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
To: Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Gao Shiyuan <gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>,
 Kim Phillips <kim.phillips@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 iommu@lists.linux.dev, x86@kernel.org, linux-coco@lists.linux.dev
References: <20251202024449.542361-1-aik@amd.com>
 <20251202024449.542361-5-aik@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251202024449.542361-5-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0073.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB999081:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eeda4fd-1069-4e73-5260-08de31b26c0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVY1eHVyVWN5RFZ2L1lBM1VBNWNxU0V0QXlGOGl6L0FzVEdhZlBRMFhLVHZx?=
 =?utf-8?B?Znc4QlpLRDViNmtwZkhKRE5kOFM1L2Nma0dJOXZhRDNKcVN6V2oxY1pST0dK?=
 =?utf-8?B?Vko5aUp3SVBvNzQvSVJnYWw3RW5Cek9wdTdaWWFOcnliVy9XZDN0bWVvazRm?=
 =?utf-8?B?N2xEU1lPbFZubm9rcXdFeUFGL3lrQkQyNzYycUZZK2drd3NhSnRvakpjdjdr?=
 =?utf-8?B?Q1VQVkswckNydjJ0dDJORUd1WGpIdHVvZjRESFV1QXQrRFM3dUdXVzdzdFF4?=
 =?utf-8?B?RnRkajY5SHRVa3ZTdjhkYkJrblUvdk1PbnJUVlVtYS9TLzR3NnpWKzZZRkxB?=
 =?utf-8?B?U3FxbXNvM3hyUGE5TGxhSjlDbHgyZlgrRXIrcks3TDZBTndYdGRsZzFZSVJo?=
 =?utf-8?B?eEpmdUVlSzhBdlMySmRveEc2d1pTKzgwTUkvamk0NjJrM0Zkb2lJMFJNWGRa?=
 =?utf-8?B?QlF0UzR4cXNEZmc5YUhIWHRjK1R2YjdaV1kzSW9QTVFNU0NQWWdkOEE4OTB5?=
 =?utf-8?B?U3QxVDVpb1VDTWdJeW0wem5mNjdsbjFNRWxKMnlJN0w4U2pCTVFRN3JyL2JP?=
 =?utf-8?B?bzdpbUE3M2JLUm91Q2RKQUNBRjk5QUlscisxOGNEd3E4M01VcWx2YlFENUU1?=
 =?utf-8?B?WjJnZmx0NkZXQTFLRnBrYUpMeVFBQlZJYWZ4em5LeGIyR3BBbG5rY1JQR2JN?=
 =?utf-8?B?YjAvSnJjbnFlTXNmSjlPZStUYXhuZXU4cnZDekFNK090ZFRvRnd2L1lCVE5U?=
 =?utf-8?B?LzRydjRPOEY3M1JldjFUREwwSFA4Q0NjVFUrTmVibUVuejFPd3N2REllM2pT?=
 =?utf-8?B?dWJpY0NCdmd2ck9YYXNGaEhnbFcvM3JFL1NURUU3NTI0aTUrdlcvcTZ2RUsr?=
 =?utf-8?B?QldRVy9FYkVRMy9Ob1EybytldWErdXZYOHhCRUE4ZDYySlVYMVhEMHE4RjQr?=
 =?utf-8?B?aEFRMHlrVFpOb01YMjk4NGdjbzllMXFVb1Bxby9zd3VyQWp2VnpvUGY5Smhw?=
 =?utf-8?B?TFF1cG4xOFd2Y011L2RMb2J0eS9IQUxHOTBXWCtrc3lTa3E4dGIvTEYwVkx2?=
 =?utf-8?B?Nmo1NE80QWZFTFdqcnp6U2hXUlVMSjRXTHhhOCtPbk52VnhkZUFTT0NIVWw0?=
 =?utf-8?B?b0ZhcjNjbWtCamlGYW9yT05YUTlzNitTSmFOTTFvQWUvNHVYS1RnTnY0OFlw?=
 =?utf-8?B?WGk0cTdteTNkV1RkajBKNjBOWStBKzJXcGtmc0paNE1WdjFKaUE5ZFdYbkFT?=
 =?utf-8?B?UTQ4cWZEYVBOUmxSa24zTUxCLytkcXByd1BjK1RsRmFpSmUzZXZ3UG14ZDBk?=
 =?utf-8?B?cXBkN1B5aVdzcFd3OXMzQ3hjT3g0d015NU94c0ZuaWpWb1pWYUVGcndWbkVP?=
 =?utf-8?B?K0ZLVmtMV3kvTHlJQUxERy9vcXFNNzhBUjFhV3dPR2xtWHFyRG80aERyS0Vy?=
 =?utf-8?B?S3Z6TTBXSVBwUEc2WDNNdkE3NGxJRkhxUEhQSnozU05IS1NFOTVLNDR2Z2pL?=
 =?utf-8?B?b09MUU1ZSnNEdWVtOE1LQ3NIbHRYQW5wNG85cXFJaysxYlliK1pSQ2RmaStG?=
 =?utf-8?B?aHJMMEhzQk1aYmVSbTl0T3NvZmgwS3BkSnVKdEVoRWc4U2lkQW9RWHlMU1pa?=
 =?utf-8?B?SjFxSXNUaSsvcWhscEFZc085ckJGQ0djZ3VScUsvUVdtZGZRRTVOaVV6ZGd1?=
 =?utf-8?B?TmNLa1hacktxSUUwb1VieTJJa2FvSnczd2RudjFWWGZlbmpFK1N0VFZtRDR3?=
 =?utf-8?B?Ymk0K2x3VzZpZ245Vm9paUlqZk1sNmdoa3I5ZGV5TGs2N3VaaGZwU3Q2aWpF?=
 =?utf-8?B?WUprSXYwYVluUlVUc3B6UmxMVU1XVEh3QVRMb2pxK1E4YXVTbXZKbk1DdHpx?=
 =?utf-8?B?aCt3NjUvMExkZ21URVE2MmhEUkRqTU13T2lKSGZZb0lCTjVNQUd6SXNCekMz?=
 =?utf-8?Q?rdsFKRYRxgzmCXad/b8jshlOKmcSo1O0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjJnZitYcmswL2tDd0d5L1dQb3E1UHFsNWhKc2llYUR1bGRkbVJUQnVaOXFr?=
 =?utf-8?B?cVNPcE5scExWYTZBRnNlbkgzZ3FuZzJNUlR0U1BNdnZzc0JGWjJSdlJsMkhy?=
 =?utf-8?B?WG9ZTGd3MUZxbGdXcGp6a2JUU0htUzNLUzkvZXp6MVpwK0VwN0Q4YTJGNloz?=
 =?utf-8?B?K2JLTHJlWWZZazFnUXhCOVV5b3pnR3NwdmQwN1NYNDB3cms0RzRLYk1xUFhO?=
 =?utf-8?B?U0FGMWcxMGl3REkxSjFDUmgxOXkxMUZuT3FlMCsxYmVueCtjV0JoN2Q0VFJK?=
 =?utf-8?B?UUVEcEN6VVRGSnI5L05WWXdDUE8ydmVNRHdTeUlVMmlkUTlqRmhINVNPQm9K?=
 =?utf-8?B?cGZBRHlmNCtGbzdpTjRxTFBCVVBZejV4amVlQnNnVWt3cURaYlpERVUrM3RT?=
 =?utf-8?B?dUhsbmFiZ3FHV01XQS9rdytySkFLb0daT3lsNkdpVnJZU0lBMVlNZmtpbXhF?=
 =?utf-8?B?TmRyODdXWU5adVM4Z0phTGRSTk51eG5qSnkrRnNaTzlhbkxubGhmamh3YlBY?=
 =?utf-8?B?ajdLb3Arb0VSLzlXS0tiZ0VoRGcwbkJTYWJEeXNZcDNta1BMT1MxVzVWNFhY?=
 =?utf-8?B?RzFuYjhoNk1HSVkvRGx4V3VxUjZIeU9pU0JaZDlzdlRqSlRENTRHcUtKYjVP?=
 =?utf-8?B?c0dxL3M0MkZhWGs5bzRVbm4yRmE1aUI4L0xpdk53K0I0S0RkNU5HZ3k1VjNn?=
 =?utf-8?B?VmxremVOYUYxYk1RRXBFT0lBVk1nYk9BRnBDdU1oL3BXUUhUMmZsRG5aTFJl?=
 =?utf-8?B?ZWNUWkpSVlE0TUFjamg1S0o5eExOOHdoMmVkMWFMb0FablFKTTllbVpQaDJG?=
 =?utf-8?B?UkdwNE1LUG5XaUliK1BFSjBPV3Bqc29tbjN5VURWQzB1Vk9aYXVCWEtUazNN?=
 =?utf-8?B?K2RiZ0hoN24rN0htOEdzbm1BN3c3K3grTFZCQ2c1MnNXc29IYW1ObG90MnYy?=
 =?utf-8?B?Tk5MMmM2SHpxbDRTazg0VysvT09kWDhScnlZK0YxOCtRNUEzYWZOWHRVTTk2?=
 =?utf-8?B?d2drTjA0dUhPTW1NZFV1SEVCVWlvWHJkMHJNWURBSWdKbDIrTzZERmh5ZXVy?=
 =?utf-8?B?bG9ORzVxQ2kySVhuaTJoeTJGUUZQL3VyQTM0UEJLTG9JTTRUWlpTM2hONHUx?=
 =?utf-8?B?d05wQjR0QmJ4MHM4SnJJNkhzT1Iyd2JqdXFKOXhuNkZjZXhDMFdWN0Y3QlEr?=
 =?utf-8?B?c3E5bVZYaTAwSFpwSXZjUWlZMkYxSlZuUk1CeENEdkc1d0tSdWo1cjVlUzRV?=
 =?utf-8?B?V3hyMUlNYjFkbmdwQy9wZU9tRHVTZy8zaCtTcUE1eXJYalpzYjhHbko4YlZK?=
 =?utf-8?B?Zi9EempNRDcxejMzeDV5dis3U2RDd1ZqL3d6MGR1VHoxSklNa1VDNmVPTkg5?=
 =?utf-8?B?cGRLQzdrMHZkVXd5QjJVeldxdTQ3M3RkV2U4VmQvOEdjWkoyZ1N0WWRQcW5K?=
 =?utf-8?B?K1FtcENpRVREV0VNcEtUUkhNWjFNY2FxK016Qm1qTmxCU2JERDRzeFFRVmNl?=
 =?utf-8?B?Um5ObXk3UzdjT3czMnJmSVc1bUs2bFB6cHNYWmxtak5rK3dVMy9zRVVnYnZB?=
 =?utf-8?B?V3ZkM3ZXM0FUTDBqb3A1UFRLQmc3TU1GaHRLVXRkR0tDT1o5NDV5ZWphUi9B?=
 =?utf-8?B?MnkyZFpxMGdYNktRTjJ0OUVZdTg3REFqazJ5N09JUmlhYjQ1MDZFTWF2TkR0?=
 =?utf-8?B?UmptbzI0cmk1OHQ2bGlFS0JlbHA4SmpydGl1NEtHRUx6YU1DTTA2VXMwdVVJ?=
 =?utf-8?B?aVhxMjFNR0EzaGFqRGo5bzJlR1k5aFVpbDZEUWNIQWhENFR1Qkp6ZTdjME5z?=
 =?utf-8?B?VUZieEUrZ1Jxb242azN4N0lQWGZNLzZiMSs0SjIrL2U3WDNHWGl5akx5VHdj?=
 =?utf-8?B?Skx6MThuZEVGUTc5RlpxSlRENXpWdlJUYURxbEtYTkhEVzVjWkVsYThkckJl?=
 =?utf-8?B?R29mbkk4cm1YZUd2QTEycmltd09UZnhLQkVxTUdsRkpxVE04MFhjazhGQjN2?=
 =?utf-8?B?ZW5HVHdOZmltUFpxUWFOSlRRZVRUOHpMQ0hjaVB0V0FiTmpYWGh5dEtDeVZv?=
 =?utf-8?B?aWlSaUY2Vmhrc3Q4VTVYcllyWWNhSmFqYXdSR2pjRGNTMk9NWVh2MnB5MWIw?=
 =?utf-8?Q?HOfBBMsGNWjnovJUBf0vgC83f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eeda4fd-1069-4e73-5260-08de31b26c0d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 14:52:32.1304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgIiogbWTz3G0LSPUSTzA31Ql1ww98WVNsQSKzXpJ+hYXsSvcEYOvo0lIQ87OxF0Sw2aL8ZjZWEbuIRqYcD8AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999081

On 12/1/25 20:44, Alexey Kardashevskiy wrote:
> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
> (Trust Domain In-Socket Protocol). This enables secure communication
> between trusted domains and PCIe devices through the PSP (Platform
> Security Processor).
> 
> The implementation includes:
> - Device Security Manager (DSM) operations for establishing secure links
> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
> - IDE (Integrity Data Encryption) stream management for secure PCIe
> 
> This module bridges the SEV firmware stack with the generic PCIe TSM
> framework.
> 
> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
> 
> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
> The CCP driver provides the interface to it and registers in the TSM
> subsystem.
> 
> Detect the PSP support (reported via FEATURE_INFO + SNP_PLATFORM_STATUS)
> and enable SEV-TIO in the SNP_INIT_EX call if the hardware supports TIO.
> 
> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
> the data in the SEV-TIO-specific structs.
> 
> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>

Just some minor comments below. After those are addressed:

For the ccp related changes in the whole series:

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Changes:
> v2:
> * moved declarations from sev-dev-tio.h to sev-dev.h
> * removed include "sev-dev-tio.h" from sev-dev.c to fight errors when TSM is disabled
> * converted /** to /* as these are part of any external API and trigger unwanted kerneldoc warnings
> * got rid of ifdefs
> * "select PCI_TSM" moved under CRYPTO_DEV_SP_PSP
> * open coded SNP_SEV_TIO_SUPPORTED
> * renamed tio_present to tio_supp to match the flag name
> * merged "crypto: ccp: Enable SEV-TIO feature in the PSP when supported" to this one
> ---
>  drivers/crypto/ccp/Kconfig       |   1 +
>  drivers/crypto/ccp/Makefile      |   4 +
>  drivers/crypto/ccp/sev-dev-tio.h | 123 +++
>  drivers/crypto/ccp/sev-dev.h     |   9 +
>  include/linux/psp-sev.h          |  11 +-
>  drivers/crypto/ccp/sev-dev-tio.c | 864 ++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>  drivers/crypto/ccp/sev-dev.c     |  51 +-
>  8 files changed, 1465 insertions(+), 3 deletions(-)
> 

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9e0c16b36f9c..d6095d1467b3 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
>  module_param(psp_init_on_probe, bool, 0444);
>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>  
> +static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM);
> +module_param_named(tio, sev_tio_enabled, bool, 0444);
> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");

Hmmm... I thought you said you wanted to hide the module parameter if
CONFIG_PCI_TSM isn't enabled. Either way, it's fine.

> +
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -251,7 +255,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> -	default:				return 0;
> +	default:				return sev_tio_cmd_buffer_len(cmd);
>  	}
>  
>  	return 0;
> @@ -1434,6 +1438,19 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> +
> +		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);

Please put the variable definition at the top of the "if" block instead
of in the middle of the code.
> +
> +		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();

Don't you still want to take CONFIG_PCI_TSM into account?

	data.tio_en = IS_ENABLED(CONFIG_PCI_TSM) && tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();

or
	if (IS_ENABLED(CONFIG_PCI_TSM)
		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();

But if you change back to #ifdef the module parameter, then you won't
need the IS_ENABLED() check here because sev_tio_enabled will be set
based on CONFIG_PCI_TSM and will be false and not changeable if
CONFIG_PCI_TSM is not y.
> +
> +		/*
> +		 * When psp_init_on_probe is disabled, the userspace calling
> +		 * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
> +		 * unexpected state loss.
> +		 */

After this is merged, lets see if sev_move_to_init_state() can be
cleaned up to avoid this situation.

Thanks,
Tom

> +		if (data.tio_en && !psp_init_on_probe)
> +			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
> +
>  		cmd = SEV_CMD_SNP_INIT_EX;
>  	} else {
>  		cmd = SEV_CMD_SNP_INIT;
> @@ -1471,7 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>  	sev->snp_initialized = true;
> -	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
> +	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
> +		data.tio_en ? "enabled" : "disabled");
>  
>  	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);
> @@ -1479,6 +1497,23 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  	atomic_notifier_chain_register(&panic_notifier_list,
>  				       &snp_panic_notifier);
>  
> +	if (data.tio_en) {
> +		/*
> +		 * This executes with the sev_cmd_mutex held so down the stack
> +		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
> +		 * unlikely) but will cause a deadlock.
> +		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
> +		 * for this one call here.
> +		 */
> +		void *tio_status = page_address(__snp_alloc_firmware_pages(
> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
> +
> +		if (tio_status) {
> +			sev_tsm_init_locked(sev, tio_status);
> +			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
> +		}
> +	}
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
>  	return 0;
> @@ -2758,8 +2793,20 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  
>  static void sev_firmware_shutdown(struct sev_device *sev)
>  {
> +	/*
> +	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
> +	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
> +	 */
> +	if (sev->tio_status)
> +		sev_tsm_uninit(sev);
> +
>  	mutex_lock(&sev_cmd_mutex);
> +
>  	__sev_firmware_shutdown(sev, false);
> +
> +	kfree(sev->tio_status);
> +	sev->tio_status = NULL;
> +
>  	mutex_unlock(&sev_cmd_mutex);
>  }
>  


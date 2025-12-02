Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B23270557;
	Tue,  2 Dec 2025 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764714633; cv=fail; b=rrineLhOhSaBdKkCnrvhxkaCW/+5QNvknfDcVcty2Ku0bxxeGJGxwnE5B5G3rIUAh6iYI/AnRuKnVhU/Plg7sdbChp3U347BTmJ+7Zm3aHyhm2MwNzTqjABxUji7aX4fpe3Efb8Ic7B1jHqOqGVKulHMT8o25QzksaUL4xYXBSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764714633; c=relaxed/simple;
	bh=sBLSi3MeX5wXt4cFQRUAiUpHzvlSLGRM9FNpwaQErEM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dWBTLSDA74MYBT/N8DhACYdCpPrb9o2vAyy982jOXXV2z/KBvJPL1ruSg/8f2mj6E0dffachLst9S4PyxYMiqst1K2LL7NKluRaKfpl4dfOO5M9L4qpVzLPfgj/T5fi24mYpmjDYpgm1YDjQKWKgKdbhjO7dLB/smkA1PeOvLl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0kkvFF73; arc=fail smtp.client-ip=52.101.62.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0kkvFF73"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbR5b9rjng6XtlhEastHDamR+tx56fKeBknuVvRT4RkEwtbNs7OO7OZNvVGJuJHEGdoQhgkdoHVDYbExctoiMEZS2xacyu4yjXXE1HWWPGwP9eBVSX7nTbd+5ILn324TZUA2OG+SvsN62DarnYTA0DomdlnN5T/N18S5bZ13Zn40nc9/ifZU+LkQhM3By8ZzqDXTtGpyMr9UXyYwvACIMuZw8ZRaPPKYJnaFAaiCQLpJRr9bcxNMVgNJ+IHKvSVG3UaAOIWnamMD2Xjp2S6h7Ni5PV2rta7bXlNeOxj1at191t1AVY02H9hXJUeYFbGhrk5fuIb8qDs1ChMcPv9eAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j44N3y5FGabMmcvhwM9E6QTkLLbKNHF1adoSLpRqn3U=;
 b=VwY0e8e+GjAZGFsao/m1Ts9S1Dvrp4alwfyAJabLDZ3CcB3FR4pD3jGLdDIifdBzLflGpsl0IoaemBkhuzTsrvnrTcY1i0+0s+/spXhLMEN//O4yalzDWEex9Xh/28lZ96DNEnzLB2BRKSYGeztEe+PYG+WrTLStHDb9NfqbpYHKxKGp1BhjUmXS0yCMLSK1nVzSMOIEZZI7AQELo21J7vzHn+PYwcKC+PNv588YA6APRJYTgt+KbVBK+u6vRouszimUixL9oYjAMEGX2Eqo4cMNBgMVPVWLf97ahbKeu4qDDIkQcCpgnUnemicvy7r7xMm/0fTZ8gzY9RA52+V01w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j44N3y5FGabMmcvhwM9E6QTkLLbKNHF1adoSLpRqn3U=;
 b=0kkvFF73VqaIiPRSifapLQv7B1GRwsHBH88BOVlAeWABX8a5VVbryfZ1pmbuc1hLYG2tgKXtV0/EBA1k0M3uTp0oa73Hx/L53pWprj6jeHKZkRG7tvqlqbUjMooeMEbgogrzUL3TSaWy9ZemYvgtCAZ7FkiO6ZEQOlcHDTkV70Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 22:30:26 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 22:30:26 +0000
Message-ID: <36929d3e-b56c-4e65-9ec1-42fc52fdd962@amd.com>
Date: Wed, 3 Dec 2025 09:30:11 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel v3 4/4] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
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
 <b6d45b8e-3eeb-4b96-b781-e0ad28861a2c@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <b6d45b8e-3eeb-4b96-b781-e0ad28861a2c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: b3bb43b6-3a43-4156-26ab-08de31f263fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXpoNExMM2ZjV21HZDd3WVErNjhMajVGUUJSSGxpclp5WkNJOVEwUkhsRVAx?=
 =?utf-8?B?S1F6QytENWt2d09wV0lnRllsbTVQdHBnMkhoYWFWVFB6bWU2NmlYeCtLSjRv?=
 =?utf-8?B?Uk5CU3BsaWc2VnV5ZGZuU0NsRlU2Z0dHblduYnAxRE9GSGxuVzFVRWlUNFA3?=
 =?utf-8?B?blVwMk03R1Fpc0k0YVh2blZFeHN4WWlSUzZBdlhWTSs3V1VvSzkrMVRTU3pp?=
 =?utf-8?B?Z0NLNEZRN3Boa2wvQkZUMk41RlQvYnRIOW0vNUdBWjlIQTBMblB1eFBZV1pm?=
 =?utf-8?B?aE5HS0hFSU0zbVI1QUl4bjU5ZU1sYzNYUEpKNHlqTWRKU0dWTjdaQzRkenRS?=
 =?utf-8?B?dW9tMG5uVVFiUkhEVTFERm40UVkzWGwrQ3BzcVhYQ2NWeXhjdUI3ZkVRSHpX?=
 =?utf-8?B?MHVoQWUvc1JDUlF4TjJMclc0eDhKa0FndmxZWVJ5MzZJUUw0M1lHT1FiZTU0?=
 =?utf-8?B?Mnd5OUpvV0d3SnNMTzBpdEt1bUhiYzNkeHo4Z2xvR3hDSW9WajIzNjVYV3cy?=
 =?utf-8?B?V0JOYVFpY2ZMQ25OeDFzL2xweUlNRVNVaHBZdmhmOFF5UHo5eUhRZXcydlE0?=
 =?utf-8?B?UGtwdVlVTjVQQ2RBbnM4T1IyTDFPaStGTHFhVlowenMwZS9iYU12N1JRcjVk?=
 =?utf-8?B?c0pSbE5Pd21iQUZ3bzFiNmZkWDN6UmJtMTZMU05ITXN0SHphL1U4VjZMc3JD?=
 =?utf-8?B?YW05a1JkZlZXQVZ3K2EvL0xTTTJ6TVVXeklVQkhlSzdqd3VnL0s4QW8rZmIx?=
 =?utf-8?B?M0RMOE9FTGt6WHBNd09FSDZ5RXlwYy9Hc2x0OVBhZmxlaTErSTUya1RBM3N0?=
 =?utf-8?B?bGhlYXFMYUoxcDlZM0lzWXIwTUN6R2RNT1pxV3RyNkQ2U291SnhpK2l3bDdo?=
 =?utf-8?B?aVJiRFR5WTB6UzJuUElGTDBDZ1IrNDMyTGR0a2NTTFpmZWtQa29ucVNRbW1I?=
 =?utf-8?B?c3g5MUE4emZuQmpkcTVWVmlHT2o3aDJMaEZtMGtMUzh5TkFZTkF6KzBqWkZq?=
 =?utf-8?B?VnFNYUtQN25XalFTamtpdDNicXI1SWpPSUZLR2p2SnhiTmFHeG05empEMUZ1?=
 =?utf-8?B?cHJaUys5YTcxeEhkMmJtZUNLNFhIUUttWkxYdmJaUlhRZ2g0MjZrWWljT2Yx?=
 =?utf-8?B?WU1JMk9wcktFazFvUGVjbTZRaVZYQkNnL3NJcVAxd3F0cG9UdnNCTDVmaW8z?=
 =?utf-8?B?YWtOb3VFa21VYTg2TzI3YnNLRjJXMEQrblg2andUbGZQZkhhNDhyS3cxTTdn?=
 =?utf-8?B?MDE2bU84aTY4NE1EWE5qUUlHUFE1WlRZYjJCR1VybUxlYWoveU84elA0TGtZ?=
 =?utf-8?B?aDRjRWsvSGZBVWN3SlhZU3g3eUEwQVFZeFF2RjhsUE5uRHFCeTd6MFFMZUt0?=
 =?utf-8?B?b1ZTd0x6TnVZanNFNmoxK0o5NmxyeUtUdFpQNHdhaXhXaDhPcWVENkRmbEQz?=
 =?utf-8?B?Ym9aaFJkeVZZWDQxYnlIcERQNHB5NWQ1dFRBb0NzQTRDSG1STkdocmZpeFpG?=
 =?utf-8?B?dGJYbVUwZVhoaTdyTE5oUXVvcHRGUEpEZmZ1WndSeVBXK1lVNXE4STIzK3Yz?=
 =?utf-8?B?Q3d3SGNuYUpibGdkc0k1UmtaWm1zaUFqT1VsaUN2NkQxWEFFaXA4Z29vSmo4?=
 =?utf-8?B?b0ZDUzdTZ1VjeUNCZmp0QnVtNHVmMjJ1VjRLaktRb1pmWjhVOUwwVWxva3d3?=
 =?utf-8?B?NTVTMjN1M0g2ejhlRHczUzMwbENqLzFhanRWWnlSR1ZEYmpvYjNzcGpxRjBN?=
 =?utf-8?B?aitZUGpEaXFuYzZKVUdhcU9LWEUyRzNaM1A5aTFGRk9rYUV6MVdac2JGQys4?=
 =?utf-8?B?Nk4xYWpWZExSMzVGbFRVd1haUHJlRU93OWlXSVZxcHNKUmNRZS9FTkFNVk5N?=
 =?utf-8?B?b2s3TFVOeHI2bTFzc2ZkMm5oYVBmSEdLTDdpTVFhQ3p3bzdQUDFrKzhRYmxC?=
 =?utf-8?Q?jGFI+d4JfGxiPq8xUepG9KRHAYzdlS8H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dXpLRm9CczBZVWJWOUdXNVptd3oyelVSajVCRS9iL0g1UUpWUWZHOFJZM3A2?=
 =?utf-8?B?M3BmZ3lqeWx0ODl0dG9aOEtCWHVuTkN5MHlSOFBOcnN1bHJqZkNhUVl6cWhT?=
 =?utf-8?B?ZFprbTJqUUdrOTU3TzRTNURSUWc3OE9KTjVyVEtOTVpqdnEydmFCNHhhdWEz?=
 =?utf-8?B?TVB2UndPSTVoU0RqaEo4d2F4R1JINFYzQ2hiaHQyMW5vWlNhUWVibTcwa3JT?=
 =?utf-8?B?QXNRUlVhYjlSZ2tnRUxKN2Jrc0d2cEJaT0MwWXNHVUhFNHNOMFN6QW5qVlBk?=
 =?utf-8?B?REszQkRCQWlHZG5TVDhXNk5ZeEg4clJkQU1VL2RrMVFXenB0bGlGU0I2R1k5?=
 =?utf-8?B?dTlYUFQyQjJDSU9ReW8raWNUL0ZwTXdFamJCcWkwMWliL3dYc21sRkN0MkQ0?=
 =?utf-8?B?UWVMaXU1Y2wySlllakk1a2J4b3pQa1dJRC9HZFIwT0lPaWVoZXo4eGZkL01L?=
 =?utf-8?B?VkluT3l5RHArajI0bXFtUklEK3daWklqUktuZ0Rkd0twSEp0b2Q2MDUyNDFm?=
 =?utf-8?B?UkVqV2tWUEJNbkxhVk82MmZObWVrTk81RU45QzRiMUJicEhiQ2VpS0xyOWtp?=
 =?utf-8?B?ek82SXRKMzR1czhFL3ZNMFRNN1U2SENQS2QwUW5DNlpTYkphcFN2ZWk5THRs?=
 =?utf-8?B?bEFmaEQ0eUF2OXYxd3FGcHM3VzMvOS9XVCttQ1BDWEhQa25iaVVLWjhtcEQ4?=
 =?utf-8?B?cC9DYTZtVFMyQXJnMTVaa3lWbjFhU2N0NTA0UDNDZEw4WDRpTUZ6cDhvTU5z?=
 =?utf-8?B?bGJZL0I5ODZYUERXQmpUeVVTV1l3NHgxRUhEbStrbDZBUDJNRDg4aVM3SHN6?=
 =?utf-8?B?c3JYMW1PbFNsa2RWYTRLdVNVNCtuU2FXU05kdE5EbDloYXhSVTI4VnpUTXZY?=
 =?utf-8?B?T1l6RnhpMWJJRm0yMm5scE5QSllMYm5sY2VzaHkvajE3NWxoN2J2alNGeDln?=
 =?utf-8?B?cjJ2KzRpRjYxcFhPbU9Odmg2TVM1U3dTQ25HM2ZZUGFKYmdIMS90N3U3cktT?=
 =?utf-8?B?TlRjbkpTbUg0Tnh0N001T1BMcFE5OHhrZ09SMXJFQUtOb0N2QTFLdURLVkJO?=
 =?utf-8?B?YmlHWTJoNXRsK01WQlNINUY1Y05FRmlnbWRKVnlzMlZBSjhSRExZMmZYdHU4?=
 =?utf-8?B?U3QwUGtTS2xVTE9hTk9FRkdaVmhIbys0ZkYxOGlPTUdScGpZbE8yZmUxSTc2?=
 =?utf-8?B?REw3VzVKcUtaVGZXS2RYV1luSzVUZWdqTTJQNWw3ZG9uVTdaeTlWOUwvcU0r?=
 =?utf-8?B?Ui9ucFA2dVE2TEY5VHlpUXovcE9RY2hIdEZNZGJTajFPN01LNUUvM2lzYi9k?=
 =?utf-8?B?QUI5ekgxY2tuUnRQL3BCZmpVZzdUcStOZjh2M0R6Q1F6c3dGNGROTEJka2gr?=
 =?utf-8?B?bExXemVyWDRVZUgxR3UvTGU2VXB6a3FxMUo2VXk0ZFRYYW9ya2FJak5BTUxU?=
 =?utf-8?B?QTZ6eWgvd2Y5clhWRzdKNHIzb3cvNTRCK055OCtMb0ZXYkxVYmc1QTRPUGtv?=
 =?utf-8?B?QjVDcENNTEJNQjZqM3hEYytGMVVZb1FleFJOZlNLUE9KcDdRajRVTEtsZWs0?=
 =?utf-8?B?ZVExMC9ZZTh4Mlg3dGd0Z1hrN0E0aUhYV1FycS96M3QyZWxPUkdwbVhZWjht?=
 =?utf-8?B?aUZIWkFldlFDTzFja3V1L1FjYUxmdTBXUjk1Yk5KbzVjSHhNcFRHblU0dnNO?=
 =?utf-8?B?MjN6K09jK3N6VVJWcmpVdStadmgvL3U2MnEvT0huNmpXVjlIQUNWYmNTTEtV?=
 =?utf-8?B?Z01vdW5Eall0RmtxZUZjZXEwQXFTVzJKeTFvTnZoZnhiTkY1TkNZU1RPRC8v?=
 =?utf-8?B?Z0ZzOWUyWFduUkJLcXRIWGhSSytOdXl4b2V5cTBRU1QvRHdOMjFFRkloT3U3?=
 =?utf-8?B?ekt3NUttaU9nWEw1UmhkTzlXOGs2ekFLRzB4b3V6ODNMSHAvMkdRR1J0WWwy?=
 =?utf-8?B?eit2NmF4TE9xWFEyeUsrdnBTTEZadTlYZ1FNZjJBd1I1V2Y0M2lNM0FwSDJn?=
 =?utf-8?B?SUszMDdPQ0NTUXV5VDZGK3JmcW5yM3NLQzVSYW5Lcjk0WDVFNkRtYWlseGNT?=
 =?utf-8?B?VkJENUJyaE00bm54VElIdHF5ZTNGK2VaMXVPajRnQ2ZMYWhkQU9vcjhDS1Zr?=
 =?utf-8?Q?VaHdZ6JcLGZWzATqE1+a8M9P8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3bb43b6-3a43-4156-26ab-08de31f263fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:30:26.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +p+b/RrsjtOLtVhyqFfEuEr6lT5lhk5etjd0ftvMu/ETJkXhAkOyvFORBOy5SK2NlMlfcOmDKpeXolBrKfsm5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851



On 3/12/25 01:52, Tom Lendacky wrote:
> On 12/1/25 20:44, Alexey Kardashevskiy wrote:
>> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
>> (Trust Domain In-Socket Protocol). This enables secure communication
>> between trusted domains and PCIe devices through the PSP (Platform
>> Security Processor).
>>
>> The implementation includes:
>> - Device Security Manager (DSM) operations for establishing secure links
>> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
>> - IDE (Integrity Data Encryption) stream management for secure PCIe
>>
>> This module bridges the SEV firmware stack with the generic PCIe TSM
>> framework.
>>
>> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
>>
>> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
>> The CCP driver provides the interface to it and registers in the TSM
>> subsystem.
>>
>> Detect the PSP support (reported via FEATURE_INFO + SNP_PLATFORM_STATUS)
>> and enable SEV-TIO in the SNP_INIT_EX call if the hardware supports TIO.
>>
>> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
>> the data in the SEV-TIO-specific structs.
>>
>> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> 
> Just some minor comments below. After those are addressed:
> 
> For the ccp related changes in the whole series:
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

Dan did it right (thanks Dan!).


> 
>> ---
>> Changes:
>> v2:
>> * moved declarations from sev-dev-tio.h to sev-dev.h
>> * removed include "sev-dev-tio.h" from sev-dev.c to fight errors when TSM is disabled
>> * converted /** to /* as these are part of any external API and trigger unwanted kerneldoc warnings
>> * got rid of ifdefs
>> * "select PCI_TSM" moved under CRYPTO_DEV_SP_PSP
>> * open coded SNP_SEV_TIO_SUPPORTED
>> * renamed tio_present to tio_supp to match the flag name
>> * merged "crypto: ccp: Enable SEV-TIO feature in the PSP when supported" to this one
>> ---
>>   drivers/crypto/ccp/Kconfig       |   1 +
>>   drivers/crypto/ccp/Makefile      |   4 +
>>   drivers/crypto/ccp/sev-dev-tio.h | 123 +++
>>   drivers/crypto/ccp/sev-dev.h     |   9 +
>>   include/linux/psp-sev.h          |  11 +-
>>   drivers/crypto/ccp/sev-dev-tio.c | 864 ++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>>   drivers/crypto/ccp/sev-dev.c     |  51 +-
>>   8 files changed, 1465 insertions(+), 3 deletions(-)
>>
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 9e0c16b36f9c..d6095d1467b3 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
>>   module_param(psp_init_on_probe, bool, 0444);
>>   MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>>   
>> +static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM);
>> +module_param_named(tio, sev_tio_enabled, bool, 0444);
>> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
> 
> Hmmm... I thought you said you wanted to hide the module parameter if
> CONFIG_PCI_TSM isn't enabled. Either way, it's fine.

I did but you did not and I do not care that much :)

> 
>> +
>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>> @@ -251,7 +255,7 @@ static int sev_cmd_buffer_len(int cmd)
>>   	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>>   	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>>   	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
>> -	default:				return 0;
>> +	default:				return sev_tio_cmd_buffer_len(cmd);
>>   	}
>>   
>>   	return 0;
>> @@ -1434,6 +1438,19 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>   		data.init_rmp = 1;
>>   		data.list_paddr_en = 1;
>>   		data.list_paddr = __psp_pa(snp_range_list);
>> +
>> +		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
> 
> Please put the variable definition at the top of the "if" block instead
> of in the middle of the code.
>> +
>> +		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
> 
> Don't you still want to take CONFIG_PCI_TSM into account?
> 
> 	data.tio_en = IS_ENABLED(CONFIG_PCI_TSM) && tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
> 
> or
> 	if (IS_ENABLED(CONFIG_PCI_TSM)
> 		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
> 
> But if you change back to #ifdef the module parameter, then you won't
> need the IS_ENABLED() check here because sev_tio_enabled will be set
> based on CONFIG_PCI_TSM and will be false and not changeable if
> CONFIG_PCI_TSM is not y.


Ah true. I thought sev_tio_enabled=IS_ENABLED(CONFIG_PCI_TSM) does it but missed that sev_tio_enabled is exported as a parameter so not a constant at compile time.


>> +
>> +		/*
>> +		 * When psp_init_on_probe is disabled, the userspace calling
>> +		 * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
>> +		 * unexpected state loss.
>> +		 */
> 
> After this is merged, lets see if sev_move_to_init_state() can be
> cleaned up to avoid this situation.

Do we want to keep psp_init_on_probe, why? Thanks,


> 
> Thanks,
> Tom
> 
>> +		if (data.tio_en && !psp_init_on_probe)
>> +			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
>> +
>>   		cmd = SEV_CMD_SNP_INIT_EX;
>>   	} else {
>>   		cmd = SEV_CMD_SNP_INIT;
>> @@ -1471,7 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>   
>>   	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>   	sev->snp_initialized = true;
>> -	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>> +	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
>> +		data.tio_en ? "enabled" : "disabled");
>>   
>>   	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>>   		 sev->api_minor, sev->build);
>> @@ -1479,6 +1497,23 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>   	atomic_notifier_chain_register(&panic_notifier_list,
>>   				       &snp_panic_notifier);
>>   
>> +	if (data.tio_en) {
>> +		/*
>> +		 * This executes with the sev_cmd_mutex held so down the stack
>> +		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
>> +		 * unlikely) but will cause a deadlock.
>> +		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
>> +		 * for this one call here.
>> +		 */
>> +		void *tio_status = page_address(__snp_alloc_firmware_pages(
>> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
>> +
>> +		if (tio_status) {
>> +			sev_tsm_init_locked(sev, tio_status);
>> +			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
>> +		}
>> +	}
>> +
>>   	sev_es_tmr_size = SNP_TMR_SIZE;
>>   
>>   	return 0;
>> @@ -2758,8 +2793,20 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>>   
>>   static void sev_firmware_shutdown(struct sev_device *sev)
>>   {
>> +	/*
>> +	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
>> +	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
>> +	 */
>> +	if (sev->tio_status)
>> +		sev_tsm_uninit(sev);
>> +
>>   	mutex_lock(&sev_cmd_mutex);
>> +
>>   	__sev_firmware_shutdown(sev, false);
>> +
>> +	kfree(sev->tio_status);
>> +	sev->tio_status = NULL;
>> +
>>   	mutex_unlock(&sev_cmd_mutex);
>>   }
>>   
> 

-- 
Alexey


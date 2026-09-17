Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF50390214;
	Thu, 17 Sep 2026 02:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612194; cv=fail; b=VvYot5ou9Abtw/oaVIG/htF8tBUP4+sO7iOE2+jNkrTq5htkZldzqkJmMZU39c4rru/NANeKJADq40Xk9zsIw9rxXq2b51gsXdeQKAlMU25cG5Trinw9p/wbmEn1rd3wWcwgFZuOm2PyXgMxOgtYMoWD8qjfL6OOpt88K//woIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612194; c=relaxed/simple;
	bh=Dl9xukujFB2OvoxC2eIRWmQVzpJHGmwH76GWE/nI5gY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RalZiJjGXbceznpiVuyvymoiwKfcR/c1b+YaFxIRt6IyjPbk+6xBKb/j5GXWDEVsvKpThJBEh/la14KnY9AE3j3Wp9tKkSQxSwiRn+J39g/utDX6BiBDZLLG3eD0qILZfTVgRRaJZ3WU+t5h27FZFssAuLx/KGbM0ZddUjZ+al8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ChHaTJWz; arc=fail smtp.client-ip=52.101.48.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ChHaTJWz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aU5atneVhycdmMhtLSwfg54zKU3yGrUYjvprNXNstXA6CZ2sIEs9AK1SdM+nPwa/q8huXKd8M97yd/JlaAbJ6lseyYr2G4qrpEdECyIPSTk5E9m2LwcJ5rAfGCJG1R/11dJBFbmQiZBwXtxfgcScinUMMQ5h3q4EVQ+d8O8Vo50z3pk/EGsPDgVUri4pg7Y8jE+/vlkZSa7m9Za46n6i+bmfdsWwX5f4lPPN4ISl+VJ6pSwc+DD6eh4yFNv2BbuBfmqSqV4t6t7l0CiNeAM/DvYjxBcKqHG6AqOr9VMrJeWTOrW2ZOYFmCD1T1bFNTvR+56tAP3878Y5fRcud0QAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnOSeT827JqM1WHSr2HBLUMH3Xd9V0DEn2LgQLiflk4=;
 b=TtI7glOzplsZ/P8IzLNNf9lZYdYnB0qW2c28zQlXq1hrzFoXPbvBG+ZAiPMWCSrgoL2cilXPR+CkY8/87z3cijXZyUtKGCMMtf7rNud0LeWpp+gZkGbhmQ/1eJmNYln794C63W8e+0dqi504QHI44byMjHdeEEZ5YBbaGZwPYs1KYLoTsGp9zBkm3t+xkgT0eZmyrexJuWBQKyor++xqUTP8CApPWa/baMtBdmLZMsI61JoFrqdTbXYLISRuZHul93jY12ta1FbIK7Dh/BPyc7tloWtdnExLiVvnRnRwK719jpfaRQsYT1Yq+Y8JghNs1AM934wloSPBQ3xcYCGLzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnOSeT827JqM1WHSr2HBLUMH3Xd9V0DEn2LgQLiflk4=;
 b=ChHaTJWzZ+TxxrfC9iMO2WNgY60TZrG4LmDyunjLzpNzxCq2HVuEjwdJKOn+6zpHMSHNL2Hknt3xRIv89K4z4pIEi1WgGeQac6Tc3TGO1EMQmJ0JVXx9cp+zdfw0dW595Bv+9O1zLelSOaq7vB1xbppzV+hy3X2HsGm+SmzvXLg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8) by DSVPR12MB999123.namprd12.prod.outlook.com
 (2603:10b6:8:388::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 02:29:23 +0000
Received: from CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408]) by CHXPR12MB999219.namprd12.prod.outlook.com
 ([fe80::da19:941f:da0c:2408%2]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 02:29:23 +0000
Message-ID: <9c83efe9-9367-472f-bf39-e07252e70c3c@amd.com>
Date: Thu, 17 Sep 2026 12:28:50 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook
 on cleanup
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ashish Kalra <ashish.kalra@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Bjorn Helgaas
 <bhelgaas@google.com>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Jini Susan George <jinisusan.george@amd.com>, Kees Cook <kees@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>, Nikunj A Dadhania <nikunj@amd.com>,
 Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 Kim Phillips <kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>,
 Ethan Nelson-Moore <enelsonmoore@gmail.com>,
 "Tycho Andersen (AMD)" <tycho@kernel.org>,
 Liam Merwick <liam.merwick@oracle.com>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 Suresh Siddha <suresh.b.siddha@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
 Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
 Andi Kleen <ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>,
 Tony Luck <tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Lu Baolu <baolu.lu@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>,
 Jonathan Cameron <jic23@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Ian Campbell <ian.campbell@citrix.com>,
 Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
 Petr Tesarik <ptesarik@suse.com>, David Howells <dhowells@redhat.com>,
 Haavard Skinnemoen <hskinnemoen@atmel.com>,
 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Christian Marangi <ansuelsmth@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
 Michael Kelley <mhklinux@outlook.com>, Ilias Stamatis <ilstam@amazon.com>,
 Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Toshi Kani <toshi.kani@hp.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Vinod Koul <vkoul@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
 Arnd Bergmann <arnd@arndb.de>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Palmer Dabbelt <palmerdabbelt@google.com>, linux-coco@lists.linux.dev,
 xen-devel@lists.xenproject.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 aik@ozlabs.ru, Santosh Shukla <santosh.shukla@amd.com>,
 "Pratik R . Sampat" <prsampat@amd.com>,
 Scott Soule Cheloha <scott.cheloha@amd.com>,
 Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-2-aik@amd.com>
 <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260916174929.GCaqrWqZ1fIhi4Rgbn@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0119.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::13) To CHXPR12MB999219.namprd12.prod.outlook.com
 (2603:10b6:610:2fd::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHXPR12MB999219:EE_|DSVPR12MB999123:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c5369cd-ffef-47fb-d79a-08df14637cb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	OTWkJ3BzLvXlpYrhzvzJ/m6bDLG6FVqhqVagagcJJmrDwex9mkmlsGSPyD9vZbM1EorDdeY5zKRT2tKL3AwI/77eRPKsj8+0JjxUGKuqVkCtXvgYVHwHyS/uYGS7cOh2d5NtBtDAx1RGUTLnGBmfyHSkGKtRJWFbP2Oz4QdmrLHy/3tmWtTLREvL78kzH8AXrMHNDj6ePCq/fJiOEiezoiSdL3Si90dGeEcVxGLU/z02aAx1L5fJX+gAztzdfHBlvf4TJLbKg6eIttIJjLnZRYIIsgPlOK+mT3piX3Do7D2sGM4ifLcEeg5LS15cwCnkluKzId3YlyGxXllznR6+JejZgHECA/1s6tJxny8I3oXWdRe+bUkGeX7y6zKdgElS7rqTOE4b4kBg/0S6nDdhVvLH+eYGU9+FJM6aRrJKlVCpdS3Ir7cqZ8TjJ9CV76xmgFiNjVxuc5cjPmL7AyTPKC//iSRb/5xKpLQtIL6Qz384357y9I6YF3u7GKlv2K1MORL7kdBwPo2WR0VhuOuDXxiQrGMjiRPcBu9oR0kVhPAo9iKn1Mn5D3dloVVmz2VPCdlyxE0Xqgf6GKJxgVvqCnvUPG2lHFvPj76Po8MxlKqS98nek9hAhC54VcRzdvJMXLv1L7KJtjXjCJuBmpala/hD/nk4Mg8YbJVWeuy0rdY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999219.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3phOU4xTkYvemVvS0duR2YzKzVHY3BFVmdnQ3VIbERGSmFQZ3NNdXhKRGx4?=
 =?utf-8?B?b3BDUlRZMUpiUGVTQ1MzbThWRlRZZFcyYVFSMVFLNldzbDh2TDNBTVl0MmNv?=
 =?utf-8?B?amcySUpwTWRuMFFtcDNCVWNHWUw5VzFlU0dPMWdrT3RKNjhIa0tTcXAvL2lJ?=
 =?utf-8?B?TDZnN2JMaFdwblR2aTd3aTVaUEphNWFVUE1yNTZvRlpCT01WcXU3SDljY3Mz?=
 =?utf-8?B?aTYzeWVING80UjR1V29vcGJEQmlXaEc4andDL3p4ajUzMGxIRXZkbUZiQk1T?=
 =?utf-8?B?Q0lDQ29wMlprN1JsVnNJQk8xSDRuOEJKRzhqSllydnlQWDNudTVaQUpkVm5H?=
 =?utf-8?B?RXJRczJQWlcwaGx0MHdJUWN6T3UzSGhhZ0VTUFFBaEJPcWlocEhENEVXK3M1?=
 =?utf-8?B?Zkp2Q1lBdm9LYXh0MkIvOFh2b0JFZWxjUFNkMTE5ZnVUdlpVUTdrbzg0QXdk?=
 =?utf-8?B?ai9pVTBrTkF5azZXaW9DOFV4VDhDeFJBb0xZR2d0bEJsbFcyNVlUbTRaOXZa?=
 =?utf-8?B?Q1owbHV6UHpXZUNselRyeVBMSzZhR1JKendIcUJId09CQUZGdWtSeW5sTVdJ?=
 =?utf-8?B?ZmE4MzArejJ3RThDWUJwYWlzdjRsMHRscDJjVjVMOXpZRjVDRWNxNjlZczd6?=
 =?utf-8?B?VHR0ZTMxcDdtUWlXQUUzSFlLR2dJSTRPeTdSOHhuQ0Q4NHY4VEN3a2laNHVt?=
 =?utf-8?B?TDc4NmhZT1cxWUpBbGVNaytCRkJMckVIaDQySERqSEN4WTZmUzdya0kreGVU?=
 =?utf-8?B?eTBQTWlHRHQ2aFlFNnd6UHpxT3h2M09GRnZtTFE1eDhIVE5ZNWhVdXVkMFpH?=
 =?utf-8?B?a3cvS0UwNURYQUZuSkRiVUZhTTJkTldURWhUTDgyS3oyVU5VcGdWRE9Cc0d1?=
 =?utf-8?B?a2pxbEcxL2xMaFJodFVVakFMYXlzY29QS09aMnVMeFlIdE96WlRtaGt0clo3?=
 =?utf-8?B?dGZvbjY2T3gxMkVoenYxakM0L21kSFczb2RqeU54YTBaWXFKOXI0M3ptdVZX?=
 =?utf-8?B?MkRhSEZsY2lYRktnMUtZSnE3bVNiS0VrcVRucGpxcTRpdkFtY0M5amtkTmZ2?=
 =?utf-8?B?MTNVUDNISS8xekxOVkxadnAvb0pJWGRUdHUrR3NpVDVCSFl0ajZ5MUpHdk1p?=
 =?utf-8?B?R1BhQXFUMGVrRkxkYm51dXJVWFoxZHVwMWlMRGp3L1k3TEpkREdkaTM1K3Bs?=
 =?utf-8?B?aVpHUG51bXBTVFpnY0g4TFM0SStRNWRjK3hpM295ODV2QTJzTVl6Qk5Ba09z?=
 =?utf-8?B?cS9NQlhXcWhOUGV2NlVIdFJ4SGdnOFZNdEl6TU8xL2JSQi9QdytxUjdBclNI?=
 =?utf-8?B?ZUVLazRoL29YT0dtdlN0L3dtUjc2ckorN2ZRTUl6blZ0MTR0TjRPWDkyaTVX?=
 =?utf-8?B?VVhVbkFZQ2NOdXIzUFkwdUhOZ25YYUYyeXhQNE9YWUYzQ1BhK2NIejBoM0FW?=
 =?utf-8?B?N1FHeHBKZjlkc3FPSnJGSUdoUG9tNnIrSGlQZnFqQytleEZtdWpqR2VFNS83?=
 =?utf-8?B?ZHpTeFliSHRhWEFMQTE4YVBxcHFvc243cjNJOVNGYWZPdjZaQk9vOU1UK0lX?=
 =?utf-8?B?QzlLcHJHbmkxMnYxYnI0clc2d2QyY2lGUERUem1xVXNtUVdKeWVZcnRhNXFV?=
 =?utf-8?B?VUFxWXhGZFROaUowbWRFMGQ2NlNzQ2JrWjZqOGhSNEMzQXlGS3VNdk0zck81?=
 =?utf-8?B?L29CNzkzWXJNUmxtQmNONjFsUTdONjFtK0JTbUNEcGMyaXYwS3MxYlJ2MTlr?=
 =?utf-8?B?WmVIN3pZQjZYSUxjdkFyODdQZHgzdzZqYlNWeUtmcGR3VkFuaWIraU4yazVx?=
 =?utf-8?B?STFoNURCalJxQURuekxKdW1qRlUvaGdUQkFva0dtaUZyN2djRUppNTdvTU1H?=
 =?utf-8?B?S1pYbkRXc1dxM1h6M0dycWRDREdGR1ZQWngxcUZwYnQxYXdjTW1qcW1Md2JR?=
 =?utf-8?B?a1Q4K0w2RHE4czVBQm9pNHQ2U3J3TzBDb3N1U3V1TFVheTlwc2ZJZzdLSFVi?=
 =?utf-8?B?dld0UEE3MTBBY3BQdVk0YVNZdXJqVzFlcW9EU2p4Z0cyL0NZc2FDaFM5QnNk?=
 =?utf-8?B?K2xnN1hVU2JmTmpPTU8xL09nd2lFYWRQYVdLSTlmOWozMG4vV2FURVJ3bzBK?=
 =?utf-8?B?Wi8vL1VDMkV5MzFBVnpNZ09hZE8yTjJaMGY5V3RaOWxnZ0U4WXNVNGV0cFdl?=
 =?utf-8?B?cDNTZGJRV0tkNHFzUEJvUTR1d2g0SXYvS09xcnQ0L1pGaDJFZFNzOFBjM2dy?=
 =?utf-8?B?aWtBOTlPQjU2dTBoN3BEVkZKRE0weFpxOC80bGVrbHI4eVR6bkUrTnBPWlJR?=
 =?utf-8?B?ck5aWUh3NnJ0dUoxN0JRYzlka2NXSTlJZzN0RmNHL0JuNWk4Wllvdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5369cd-ffef-47fb-d79a-08df14637cb1
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999219.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 02:29:23.7911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T2crqjoZUBnh2uJavoqc94OSC7soEz1LMPV53bIpK5Sn65abFUdpyx8ya+Nl4NVL1fkkL22sad+ivtm+rsm8XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999123



On 17/9/26 03:49, Borislav Petkov wrote:
> On Wed, Sep 16, 2026 at 09:51:41PM +1000, Alexey Kardashevskiy wrote:
>> +	if (device_tcb_trusted(dev))
> 
> Where is that function and the rest of the gunk needed for me to apply before
> I review those?
> 
> The patches on that branch:
> 
> https://github.com/AMDESE/linux-kvm/commits/tsm-next
> 
> which come before those here are enough?

Correct, the patches between v7.3-rc2 and 01/17 (can drop samples and tools, obviously) are enough. It is basically recent tagged upstream + rebased Dan's https://lore.kernel.org/r/20260705220819.2472765-1-djbw@kernel.org

What device_tcb_trusted() means is still debatable, the earlier proposal was including a module flag saying that the driver is trusted too, I think we are ditching it now.

Thanks,

-- 
Alexey


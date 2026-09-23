Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1B36A367;
	Wed, 23 Sep 2026 04:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790138120; cv=fail; b=jB6k3vyHv4+XKfXleYV6Rb0LVwS1LBmTV054LJjimA1u6L3e01WMF4j6GDoDBMjhc2hkNQUlglXZc/waEaEe0SXwbzkyM3Y5yZeqkjiIyhxWj7DSSukRgQZRWx6/6PjtrgyDvvkqyAEk7ZGjx1nNxTMA411wdqP+OoP4og4q0no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790138120; c=relaxed/simple;
	bh=IT7J2YGsuvV58JIxzs8L4yLzEk+mz2hQ+4LQ8R/V5D8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=brQX1TT1j3iZ4vdwiRLoq2Ek1D7r/BjB8Zq+cF5sP2SpWNnqzH10RYa01OakFI/g2SIUAUoJ/zC8ULjfNXb/Z1cvn/ia3JfYJqr/7nHaWNwDhd+zGVfeP1JFDbQ+4dWROQa3+f6gUtxlZ/LY76Ai7sahov6nTtvvpyg2b8oMWwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4BqnvGAM; arc=fail smtp.client-ip=40.93.195.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4BqnvGAM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p6L730XBTm6fBb+8RyilodyYPqmdNmUUqWZ25+2FvG4VzBKWh6y0c0OIszK/mFNJYP8gWpnt4Ix/WXTzIwvGmAZfSzHYxbqv4H+EEn8fpHuVoM2VQrKIHRoN933T5gUgsW6lcVyiY9VTA6YTIT+M1akhzQK1eaODHY1hWrw0WneeqO4/XVkmwBI0k0e7OsRRDsMqcq4mqUOsjBDZ7czDoJIBZF6ST52g/PdEY3NcqlEWxqI8PwkSy5rAlSD5vgSDSMlhpkSD1ZzwyxS6nd9xffkiyqktdLZZtdiRzJ33X2PdtalTtYqEVaC/HRg6fpFk8NWHKh8rXmevh5mdc6wwZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2d3KccSK+qwgXdBkoUCmUtGaaT6R2qysxXQ1M1RQEg=;
 b=b37Xj3IBtQbLMw2hqRviggBRCePqg+DOqmn5yilJMyuz+/bq2F9gJdFZZsxGf8WeA4211TBJAQGXpfWXbEJXUatRv3Ll36PNwMf2oLTX1ZDehmYHxyubsajfhNWcu7LZO4bMOzpEQtphW009DEqVgB7+rdSbEhQtStU/vibpjt1+rR+ZraoVdLTvmylXPeX0xIZb+cqJB/qiY/s+qZJaCvSyoFawZtbPApR+8YeDQEs2+M5AyOBGhYuN/ZR5mk59vYQ8C/+IfyQ+kfMp2EnmqfqEWMg6/cPs8hlbjTP89uoQD15CeY7ebvCupr7vjaTkaao77URew/luTNTtG+p6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2d3KccSK+qwgXdBkoUCmUtGaaT6R2qysxXQ1M1RQEg=;
 b=4BqnvGAMXrhcsSSujKtI25AOlwa7oPoLWhi+SQZ0KHUME9N6oV/I9gTGkoE1RzoO4LS2jQtGlRuRf4VfU/11luXYJYbhisHtOgXklFiDNdWk7CDSmBlwvN2zfCAUiExI1gEXV0NmghdcBZ2JF69TUghb6nGnIrqX56yKL2j7EuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10) by IA1PR12MB6650.namprd12.prod.outlook.com
 (2603:10b6:208:3a1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Wed, 23 Sep
 2026 04:35:12 +0000
Received: from SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3]) by SA1PR12MB999228.namprd12.prod.outlook.com
 ([fe80::4dba:119e:8e7c:37b3%6]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 04:35:12 +0000
Message-ID: <8ff51404-d752-499c-af65-cd25e0731a2e@amd.com>
Date: Wed, 23 Sep 2026 14:34:49 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH kernel 17/17] x86/sev: Flush IOMMU TLB for trusted
 devices
To: Jianxiong Gao <jxgao@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
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
 Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 Darwin Guo <darwinguo@google.com>, Shruti <shrutiss@google.com>,
 Saurabh Singh <saurabhsinghs@google.com>
References: <20260916115159.1938195-1-aik@amd.com>
 <20260916115159.1938195-18-aik@amd.com>
 <CAMGD6P38zYT8FzkFHoaKNEL0tVErK7G+ZLPMzgazAmVoMcD=yQ@mail.gmail.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <CAMGD6P38zYT8FzkFHoaKNEL0tVErK7G+ZLPMzgazAmVoMcD=yQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0107.ausprd01.prod.outlook.com
 (2603:10c6:10:111::22) To SA1PR12MB999228.namprd12.prod.outlook.com
 (2603:10b6:806:4db::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB999228:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 8981c364-a945-4747-3f40-08df192c0e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|11063799006|56012099006|3023799007|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZaDuQetgahZL0POAHplLHKM987LEJ/IKYS6CK/okFsjPboBL5sRvVMf8LQaMVfpusvykSSJRhs2QkXWUaubCCqxVe1yn/v9AUeYZhMT6fKcT2gaHASLNsmqHLUcxfUHz3nONwDrGrTbOLy/nWbN+t7T0NyjxR8sfdFx5dDAMeyHJrVSfNekpqqGlpi8L9nfCkrGdigRnUhnCkSnYIdBeHRDMSt7NC9/Jvwa/zr4l+Gz+bPOpqG1zd5oxynPg7qLs88uhjnMUiRuDl5If779W/jx+SDEVc++ZUOl+3aM2+/e+LvbV9t/OI2D0P3aS05ALNVG0nNIWiw8X+jOm60j7KO3wEbo29z3C85X7Hx1wt8KoKe1Ybxckjec3duxdjktfy1DGMDFJe0CaNQZHIVboaZN/6bxERmKKU7FSO9NVjcbZ9Y87wW8da7q6kuZmf5pdjnLT06CjSilPTz7NDZtU9Q7Rseh7hRvLN7Xix1lK8m+x59QyEnMFay8x5W3dSPtd5h3o+P0HahtYIhmCIjHhyBeSYYBaki9PyCYMYpyWYTFDNFvmzY9LVG/UgcwJr2DydhS4vqzExQe/Io1YkUN0EYLafefs3wFS0q+e1mAqYnLgumtOY9fzJnIAwALAZB0nZCgzrhV/Gzd+CWZj/WvLcyO4dkCKwpsCQu9ij+8Oka4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB999228.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(11063799006)(56012099006)(3023799007)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2dvSUtpRE8rSkNnc3h5d0gyK04vRC9QMmVSVWE4U3I2VCtrbVlwTEFjRlNn?=
 =?utf-8?B?NnZ1U2V4eUNPdGQ5eDFuMUJNNDZ2R09KMkN4ZzF5bTREdUoxTVAvT29nRTJQ?=
 =?utf-8?B?R0J3cEsxVVJDM3k0M1hRMUhLejBmR3hrRkg3a01FUjdkK0djY3UvdFM5NFFE?=
 =?utf-8?B?b3FoUmFCUklHSTJWM3pNODA1WFVGVnNaU2NjV0MzRU9FMlM5Nlp0SllOTmpo?=
 =?utf-8?B?R0JRRGJlL0xWbG5PT3V6bk0xWjQ0Z01hVWIxa3oxcFJvU0RvYlF3cjhteXBn?=
 =?utf-8?B?UXRtU25DSjdjRlRQWXVMcFRRK1RmZ2lmaUgrWmdQV2hJR1pLL2QxL1BmelMx?=
 =?utf-8?B?VXlVekpVWWJkbEVsQnFydm9PZmZEczJIVDRTMCtBV1BDMXlZcmlkbkx2R3hW?=
 =?utf-8?B?M2xoQ0hQNWlmUm5DTG01RTc3VFhIeEVXSVFXNjIxcThpeVF6VG5oZUNwdUs0?=
 =?utf-8?B?RTJkY3lOK1FyTnMzenJOT3dudUhqV25aK3RPWjlYdmtLcVZaWGJpcW9HMkE0?=
 =?utf-8?B?SDVLRWJMSTVFVXBWZXllNWtsL3hia25DNU5vVEUyMXF0Z2NuaG41Um8xYmRU?=
 =?utf-8?B?QmxsVjNRQXl1bERvaTJQQ3Fpd2RHejV0bVNxbU5XZ3dDR1BCSUMzS3o3R2Rm?=
 =?utf-8?B?M2hDUDdKcEhkaVg2d2Zya0I4VDVwOUY5R2E5YlZYRGFyNjgzd2lTYzJmRlhD?=
 =?utf-8?B?dFNsRkt0Y1dybExWT2pvZ3N0WGcyNnkwZngyVXRkMlFOSzlaU2tLb0JON3pT?=
 =?utf-8?B?UEtJdTc2elRjNGM3NFp5SHpvWmZERWUrS3puYmtOQkM2MFVsdmd1ZFpUWkJz?=
 =?utf-8?B?aHhDaHBWcmREZE1nb1BOMFhWM3ZCSlBaMGI4bWVzQ3RzUU95RHJKK2ZIcjd5?=
 =?utf-8?B?K2ZobjlKenE3K1lJb0F2RW9CMVBZZ1lOTzNIRUU0a0toQlRSY2RrSEZaa2J2?=
 =?utf-8?B?VFZrKzN0VTlraDZpcVNYYmhKVGsweUpBZVorWDJCbnU0Tkk2M2FtdTFaanA0?=
 =?utf-8?B?ZUx5bXVibWxNOFhmRnVCMHRrYWhJWnZxUyt5OGNRalFhdUZjcGYxZmwyRDl0?=
 =?utf-8?B?VWtEY2ZmbmFVWHYrVDJaQ0h0b3lHbmNzNHR3bEV5aUVEK0htZ1RQY0VzT0NV?=
 =?utf-8?B?dzFIa1BSQVdKSmZkaXJMMUhCZWhDNjVpRlZES0NmQ2ZOM2MyM2NCUGtTdUF1?=
 =?utf-8?B?V3RWT2FiV0NvRTVWUnhmYlJQcjRGT0dhS1lvL1V0S3VxTlBYMXZkNStIWlVl?=
 =?utf-8?B?ak1laVcyUUhrSnp1MmpIekFRYjRUcXdDcjRHa2ZWVFhGMlhteURpOVBJZmY2?=
 =?utf-8?B?ckErSXNvYWJMb1N1aXIzZ0w2QUw3bUo1N3hJN3dRVklsdnBxZU4yQ3JJdlhr?=
 =?utf-8?B?elMwWmxDUVdqNzhqVWdGbDluOW15L2UwM2VkVUp6YTBFOEUzalpVNitONy9B?=
 =?utf-8?B?NHRmMEsvcHRyZjVMaEtQRk5qWnFZWHNGYnlrTHVBVHJmUmZuTHRvTlhhYlJJ?=
 =?utf-8?B?RmpnUm84SkJjTlZ3VHpjZDJjcytmTmNGOFNDeGpxdCtKMzlFTkdsdFI2Y3dj?=
 =?utf-8?B?VWg4RWJXbW5qQzdiY1ZLZmZ4ZUdIWGR0cXE0SFdpWDVrbEFpaHc1RGh6OEJW?=
 =?utf-8?B?UnN4ZFlVVk8vVHBTb2tpbUFRdWE0c1djZHhjeDRkSTZ4Rjl0OXpsQmMvblhl?=
 =?utf-8?B?M0p0TjNiOXFpWDlobnFQMTZwdytNZitySUhXcitUMW9PSVNWMWVucXlrN21Z?=
 =?utf-8?B?a2dJZ0JiRmwwR0k3eUt5SGRiWkZVU2dBOThJTzExWWlkMC9lREZrcnRabnNV?=
 =?utf-8?B?M3dhZjZPdzczNlZ5ZExNQWVUbGMvN0huM3pITFczNHZTNTQ5T2RjOUxHclV5?=
 =?utf-8?B?TDM3OXBjSk5xQTVWVHFIYVptRW9RdTN0RzBQdjZvb3dXcGR3MFRoZGlkRjUy?=
 =?utf-8?B?bkxOVkpiVW11NEVWNk0xQ0JpSUdZQ0F5bW9xb2FpeFlYOVA3ZHFHSy9VK2lH?=
 =?utf-8?B?UFBOQ2EwTDFqT0NPaW8xZE5OQUt5ZDJJaCtpa1N3RitVRS9rU2JLRHQ1Ui8r?=
 =?utf-8?B?U2FPMXJxVXU5QUh5QWUxL0tRdGdVaEhwc1h6M3AzUFVIRmVuR2wyRitJRjg1?=
 =?utf-8?B?aHZudEFXU1U3bDBlUERPZjBLVUZhWFhBaWRrRVA3QmV6Y0RQMDVxRE03Mi9Z?=
 =?utf-8?B?L1M5WWtYdnlTK1dqdUsreWRwRzRtWXpNaHF4cTBNMlpSYWVIOHRHdS90Und3?=
 =?utf-8?B?alo5ZzU2LzZpQS9KREtseER2dXFZcnpDZDJlYk5GMFR3NWUwbVVFZHJqK3FK?=
 =?utf-8?B?L3pIWk83dEFsdC9wTEtEcVBmcS9lM0pRbXpKdHk5bG9OOW5OY3VtQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8981c364-a945-4747-3f40-08df192c0e65
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB999228.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 04:35:12.1580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZs7rr9HjiBZLbw/+tgcevxZC4wiBrtIsCkocA1rCwwo3zMPw8jTnfk0grI5DrECh7sD98PZlZVY1ra8DYA4bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650



On 23/9/26 05:22, Jianxiong Gao wrote:
> On Wed, Sep 16, 2026 at 5:07 AM Alexey Kardashevskiy <aik@amd.com> wrote:
>> +static int alloc_iommu_tlb_flush_ghcb_pages(void)
>> +{
>> +       unsigned int cpu;
>> +       struct page *pg;
>> +       void *p;
>> +
>> +       /*
>> +        * Allocate per CPU pages while encrypted DMA is not happening yet
>> +        * and smashing is cheap.
>> +        */
>> +       for_each_possible_cpu(cpu) {
>> +               if (per_cpu(iommu_tlb_flush_ghcb_page, cpu))
>> +                       continue;
>> +
>> +               pg = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
>> +               if (!pg)
>> +                       return -ENOMEM;
>> +
>> +               p = page_to_virt(pg);
>> +               /* Trigger psmash in the host os now to avoid psmash race later */
>> +               snp_set_memory_shared((unsigned long)p, 1);
>> +               snp_set_memory_private((unsigned long)p, 1);
>> +               per_cpu(iommu_tlb_flush_ghcb_page, cpu) = p;
>> +       }
>> +
>> +       return 0;
>> +}
>>
>>   int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>>   {
>> @@ -111,6 +142,24 @@ int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>>          struct ghcb *ghcb;
>>          int ret;
>>
>> +       if (!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO))
>> +               return -EPERM;
>> +
>> +       if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN || op == SVM_VMGEXIT_SEV_TIO_OP_STOP) {
>> +               if (!(sev_hv_features & GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH))
>> +                       return -EPERM;
>> +
>> +               if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN) {
>> +                       if (atomic_inc_return(&sev_tio_devices_num) == 1) {
>> +                               ret = alloc_iommu_tlb_flush_ghcb_pages();
>> +                               if (ret)
>> +                                       return ret;
>> +                       }
>> +               } else if (atomic_dec_return(&sev_tio_devices_num) == 0) {
>> +                       /* Do cleanup or leave it like this? */
>> +               }
>> +       }
> 
> Hi Alexey,
> 
> When testing this series and accepting a locked TDI in the guest
> (echo 1 > /sys/bus/pci/devices/.../tsm/accept), the guest immediately
> terminates with 0x1:0xd (SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH).

Yup, you are right, I do have it fixed exactly like this in my current working tree, just screwed up my rebase (as a newer CPU will do this invalidate differently) and posted a broken version :-/ Sorry about that. Thanks,


> 
> In sev_tio_op(), sev_tio_devices_num is incremented from 0 to 1 before
> alloc_iommu_tlb_flush_ghcb_pages() allocates and initializes the per-CPU
> iommu_tlb_flush_ghcb_page buffers:
> 
> 1. atomic_inc_return(&sev_tio_devices_num) sets sev_tio_devices_num = 1
>     while iommu_tlb_flush_ghcb_page is still NULL on all CPUs.
> 2. alloc_iommu_tlb_flush_ghcb_pages() allocates p for cpu = 0 and calls
>     snp_set_memory_shared((unsigned long)p, 1) to pre-smash the 2M page
>     before per_cpu(iommu_tlb_flush_ghcb_page, cpu) is assigned (and before
>     other CPUs' pages are allocated, in case this task is running on cpu > 0).
> 3. snp_set_memory_shared() -> __set_pages_state() sees
>     atomic_read(&sev_tio_devices_num) != 0 and calls ghcb_flush_iommu_tlb().
> 4. ghcb_flush_iommu_tlb() reads this_cpu_read(iommu_tlb_flush_ghcb_page),
>     gets NULL, and returns -ENOMEM.
> 5. __set_pages_state() treats the non-zero return as fatal and calls
>     sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH).
> 
> Calling alloc_iommu_tlb_flush_ghcb_pages() before incrementing
> sev_tio_devices_num avoids triggering ghcb_flush_iommu_tlb() while the
> per-CPU pages are still being pre-smashed and initialized:
> 
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -150,13 +150,12 @@ int sev_tio_op(...)
>               return -EPERM;
> 
>           if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN) {
> -            if (atomic_inc_return(&sev_tio_devices_num) == 1) {
> -                ret = alloc_iommu_tlb_flush_ghcb_pages();
> -                if (ret)
> -                    return ret;
> -            }
> -        } else if (atomic_dec_return(&sev_tio_devices_num) == 0) {
> -            /* Do cleanup or leave it like this? */
> +            ret = alloc_iommu_tlb_flush_ghcb_pages();
> +            if (ret)
> +                return ret;
> +            atomic_inc(&sev_tio_devices_num);
> +        } else {
> +            atomic_dec_if_positive(&sev_tio_devices_num);
>           }
>       }
> 
> On Wed, Sep 16, 2026 at 5:07 AM Alexey Kardashevskiy <aik@amd.com> wrote:
>>
>> IOMMU performs RMP checks when SNP is enabled, the results are
>> cached along with the IOMMU translations. When a VM lowers permission
>> of a mapped page (moves to a lower VMPL level or from read+write to
>> read-only or private to shared), the cached RMP check results require
>> invalidation.
>>
>> At the moment the only way to invalidate IOMMU cache is the RMPUPDATE
>> instruction which flushes all IOMMU TLBs. It is a host privileged
>> instruction so a VM needs a way to ensure the host has done it.
>> Note that the guest's RMPADJUST/PVALIDATE do not flush IOMMU TLBs.
>>
>> The host implements a new "IOMMU TLB Flush" VMGEXIT code which is
>> advertised via bit#11 in the GHCB Hypervisor capabilities.
>>
>> Use RMPUPDATE in the following way:
>> - allocate a page per VCPU (to allow lockless flushing);
>> - When invalidation is needed, copy two patterns (A and B) to the page;
>> - invalidate the page so the host can make it shared;
>> - use new GHCB call to request RMPUPDATE on the host;
>> - the host makes the page shared;
>> - the host clears pattern A;
>> - the host makes the page private again;
>> - the host returns to the guest;
>> - check if pattern A has changed and pattern B has not;
>> - if the above failed, panic().
>>
>> The patterns are located far enough to not hit the same cache line to
>> work with the cipher text hiding feature.
>>
>> The host can choose to not execute the request, WARN_ON if this
>> is the case. Further patches will attempt to handle this in other way.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/include/asm/sev-common.h |  2 +
>>   arch/x86/include/uapi/asm/svm.h   |  3 +
>>   arch/x86/coco/sev/core.c          | 92 ++++++++++++++++++++
>>   3 files changed, 97 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index ff763c3c5d63..51abf8d061fa 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -138,6 +138,7 @@ enum psc_op {
>>   #define GHCB_HV_FT_SNP_AP_CREATION     BIT_ULL(1)
>>   #define GHCB_HV_FT_SNP_MULTI_VMPL      BIT_ULL(5)
>>   #define GHCB_HV_FT_SNP_SEV_TIO         BIT_ULL(7)
>> +#define GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH BIT_ULL(11)
>>
>>   /*
>>    * SNP Page State Change NAE event
>> @@ -210,6 +211,7 @@ struct snp_psc_desc {
>>   #define GHCB_TERM_SECURE_TSC           10      /* Secure TSC initialization failed */
>>   #define GHCB_TERM_SVSM_CA_REMAP_FAIL   11      /* SVSM is present but CA could not be remapped */
>>   #define GHCB_TERM_SAVIC_FAIL           12      /* Secure AVIC-specific failure */
>> +#define GHCB_TERM_IOMMUTLB_FLUSH       13      /* IOMMUTLB flush failed for SEV-TIO device */
>>
>>   #define GHCB_RESP_CODE(v)              ((v) & GHCB_MSR_INFO_MASK)
>>
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index 93597ad492bf..269050942c8e 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -160,6 +160,8 @@
>>   #define SVM_VMGEXIT_SEV_TIO_OP_UNBIND  1
>>   #define SVM_VMGEXIT_SEV_TIO_OP_RUN     2
>>   #define SVM_VMGEXIT_SEV_TIO_OP_STOP    3
>> +#define SVM_VMGEXIT_IOMMU_TLB_FLUSH            0x80000022ull
>> +#define SVM_VMGEXIT_IOMMU_TLB_FLUSH_NO_ACTION  1
>>   #define SVM_VMGEXIT_HV_FEATURES                        0x8000fffdull
>>   #define SVM_VMGEXIT_TERM_REQUEST               0x8000fffeull
>>   #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)       \
>> @@ -285,6 +287,7 @@
>>          { SVM_VMGEXIT_AP_CREATION,      "vmgexit_ap_creation" }, \
>>          { SVM_VMGEXIT_SEV_TIO_GR,       "vmgexit_sev_tio_guest_request" }, \
>>          { SVM_VMGEXIT_SEV_TIO_OP,       "vmgexit_sev_tio_op" }, \
>> +       { SVM_VMGEXIT_IOMMU_TLB_FLUSH, "vmgexit_sev_tio_iommu_tlb_flush" }, \
>>          { SVM_VMGEXIT_HV_FEATURES,      "vmgexit_hypervisor_feature" }, \
>>          { SVM_EXIT_ERR,         "invalid_guest_state" }
>>
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index ed0e4546d5e5..aa5a3abb4796 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -44,6 +44,7 @@
>>   #include <asm/cpuid/api.h>
>>   #include <asm/cmdline.h>
>>   #include <asm/msr.h>
>> +#include <asm/archrandom.h>
>>
>>   #include "internal.h"
>>
>> @@ -103,6 +104,36 @@ static unsigned long snp_tsc_freq_khz __ro_after_init;
>>
>>   DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
>>   DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
>> +DEFINE_PER_CPU(u8 *, iommu_tlb_flush_ghcb_page);
>> +static atomic_t sev_tio_devices_num;
>> +
>> +static int alloc_iommu_tlb_flush_ghcb_pages(void)
>> +{
>> +       unsigned int cpu;
>> +       struct page *pg;
>> +       void *p;
>> +
>> +       /*
>> +        * Allocate per CPU pages while encrypted DMA is not happening yet
>> +        * and smashing is cheap.
>> +        */
>> +       for_each_possible_cpu(cpu) {
>> +               if (per_cpu(iommu_tlb_flush_ghcb_page, cpu))
>> +                       continue;
>> +
>> +               pg = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
>> +               if (!pg)
>> +                       return -ENOMEM;
>> +
>> +               p = page_to_virt(pg);
>> +               /* Trigger psmash in the host os now to avoid psmash race later */
>> +               snp_set_memory_shared((unsigned long)p, 1);
>> +               snp_set_memory_private((unsigned long)p, 1);
>> +               per_cpu(iommu_tlb_flush_ghcb_page, cpu) = p;
>> +       }
>> +
>> +       return 0;
>> +}
>>
>>   int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>>   {
>> @@ -111,6 +142,24 @@ int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
>>          struct ghcb *ghcb;
>>          int ret;
>>
>> +       if (!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO))
>> +               return -EPERM;
>> +
>> +       if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN || op == SVM_VMGEXIT_SEV_TIO_OP_STOP) {
>> +               if (!(sev_hv_features & GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH))
>> +                       return -EPERM;
>> +
>> +               if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN) {
>> +                       if (atomic_inc_return(&sev_tio_devices_num) == 1) {
>> +                               ret = alloc_iommu_tlb_flush_ghcb_pages();
>> +                               if (ret)
>> +                                       return ret;
>> +                       }
>> +               } else if (atomic_dec_return(&sev_tio_devices_num) == 0) {
>> +                       /* Do cleanup or leave it like this? */
>> +               }
>> +       }
>> +
>>          /* __sev_get_ghcb() needs IRQs disabled because it uses per-CPU GHCB. */
>>          guard(irqsave)();
>>
>> @@ -347,6 +396,42 @@ static int vmgexit_psc(struct ghcb *ghcb, struct snp_psc_desc *desc)
>>          return ret;
>>   }
>>
>> +static int ghcb_flush_iommu_tlb(struct ghcb *ghcb)
>> +{
>> +       /* AES encrypts with 16 byte blocks */
>> +       unsigned long s1[BITS_TO_LONGS(128)], s2[BITS_TO_LONGS(128)];
>> +       void *p = this_cpu_read(iommu_tlb_flush_ghcb_page), *p2;
>> +       struct es_em_ctxt ctxt;
>> +       int ret;
>> +
>> +       if (!p)
>> +               return -ENOMEM;
>> +
>> +       /* Keep patterns apart far enough to not share the same cache line */
>> +       p2 = (u8 *) p + 2048;
>> +
>> +       vc_ghcb_invalidate(ghcb);
>> +
>> +       BUILD_BUG_ON(ARRAY_SIZE(s1) != 2);
>> +       if (!rdrand_long(s1) || !rdrand_long(s1 + 1) ||
>> +           !rdrand_long(s2) || !rdrand_long(s2 + 1))
>> +               return -EFAULT;
>> +
>> +       memcpy(p, s1, sizeof(s1));
>> +       memcpy(p2, s2, sizeof(s2));
>> +
>> +       pvalidate((unsigned long) p, RMP_PG_SIZE_4K, false);
>> +       ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_IOMMU_TLB_FLUSH, __pa(p), 0);
>> +       pvalidate((unsigned long) p, RMP_PG_SIZE_4K, true);
>> +
>> +       /* Ensure that the host change is visible */
>> +       smp_mb();
>> +
>> +       if (!memcmp(p, s1, sizeof(s1)) || memcmp(p2, s2, sizeof(s2)))
>> +               return -EFAULT;
>> +
>> +       return 0;
>> +}
>>   static unsigned long __set_pages_state(struct snp_psc_desc *data, unsigned long vaddr,
>>                                         unsigned long vaddr_end, int op)
>>   {
>> @@ -404,6 +489,13 @@ static unsigned long __set_pages_state(struct snp_psc_desc *data, unsigned long
>>          if (!ghcb || vmgexit_psc(ghcb, data))
>>                  sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
>>
>> +       if (atomic_read(&sev_tio_devices_num)) {
>> +               int ret = ghcb_flush_iommu_tlb(ghcb);
>> +
>> +               if (ret)
>> +                       sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH);
>> +       }
>> +
>>          __sev_put_ghcb(&state);
>>
>>          local_irq_restore(flags);
>> --
>> 2.55.0
>>
>>
> 
> 

-- 
Alexey


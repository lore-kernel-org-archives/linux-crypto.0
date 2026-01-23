Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD1D2C08BD;
	Fri, 23 Jan 2026 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208529; cv=fail; b=csCtQIXKfYztnYzUBKdQEW/vDvfbrkjtmNP2cOiY74IlsVIPvK0G6dVZbsFngLaR5i1Hp1Y5BD1JB+afwI60EQK3jWTjhIX6kolOQFkA48T0ItakJfsc691FJTxCA5lpGcP3kpqL+DcSGN7IwkV/msFjtlzlmSFKTZJHIppfYvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208529; c=relaxed/simple;
	bh=lQEC8aCxiYXWsNrkEqQ3V64p0X4JXSOtXasyZw1yuic=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ByQiyFFBJvjrX45AJuzdqEiXK8eGqfqK6BSl/vVVdKnJP+TxAsQbQle5v9GlGp5jeHUJUPSqpkWPwE5089xJv6FdzeeqboIcT2KcIb5DVXwoKAXgB4JId2vAzVgUSrWSbFY5tG9YjiaGVsFsKKASMY0DeZx+mFr3JDEvn/k0HHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j08GnTgX; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j08GnTgX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769208526; x=1800744526;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=lQEC8aCxiYXWsNrkEqQ3V64p0X4JXSOtXasyZw1yuic=;
  b=j08GnTgX4qwKexvXVzloVgEy2/vkNCKqjSD1djWAx5TqOUi+VbCjxPry
   4QleTo7ywSnlg425R3eCwYW7WU+nvNQfR9o8RvykUSYt2sIxGThwsBFbQ
   yGaJGbcEXogN+9yz9ObQzC2hRFvNi55X74+f878HCkTVOI8lUDTA0HEag
   uD93xtoejcbhRNnq+ZOHtkzkZwPgZPOBjisvG54x7pzin5UINU5MuBPFD
   LEjGWTj/le323WRLaD7fnBllta2dPSnA1hG5y+LlpdrAi1QE09KhHNgdB
   Q1u77k1ZG8dXhOabMAtXPiTiPu1zMgRaKvmy6A+MoiLqSggamw2nKgMy2
   Q==;
X-CSE-ConnectionGUID: 5pDxVSOPQxGX64LeuosBbA==
X-CSE-MsgGUID: gEMcNKV+R4u7EN2EBB1fDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="74326688"
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="74326688"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:48:44 -0800
X-CSE-ConnectionGUID: BY8WCO/bQzWH+fhEzDRhAg==
X-CSE-MsgGUID: JE9f0gqyTyKAfuuovdSOnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,249,1763452800"; 
   d="scan'208";a="237792517"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 14:48:44 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 14:48:43 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 23 Jan 2026 14:48:43 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.49) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 23 Jan 2026 14:48:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHOJc/h1JaYrgm2M8xbHvdqp0SRrlG7PI5ZgzbyJMsienRIia+216GfL5h/yM2yz/+jBt4Q85mrqD2kWZIFD/dv9RzePPZZoujbyMRBh0c4E7KyQo3/OTNsncMsRh4j1x4qFpaW8iveTnYGmrfL5ceAGktMKDG73i0ez14swCalECYB410h4qMaxksWElCXuSHoPp1O5A1xsJDbPSdBrof+sd366N2+7CDZwBl6IDX/pHdLiKEH+wJoq9j41IX16gQNSgBzKItxvrBppA7+0WfG8nVAUxaAEWEkh/yeX6+5u1bsLjbC5g8eKymqzKJkh5DKp0rAQ9pjufOnGMSWcYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymi7cyJE98izgc8c7HwRQwT8H6L6JO9Nj8j8pkw9LzA=;
 b=hhWgYo06k7QbsccffUkMv8L/B+HY4NVkWIg3vAkvCMPyCDSBFYBxbDrTlN3brY3z5uaBnkyPa26NDgpkICKOJjAtniaB1TBbC+sX1Sds7jJzIL/FZp2G7MldVvZ0vYGEoLRkLMdznJTY942hK+TMKATfxP6iC5Wm1oIc9YXvJfOs+07AupghJ0RtZXkuD8zyb65CW7dPZYY4yDIJT1yi+CkUN+Bo9fQJ0yJY/ulHLbFTETbbU8kLG2X/gJEu950TioOvjb78fPqOp9RBIQXiZrbcJFIfYWDuI7N2enaYdtWGUDcsx2dplt2S0WCHDNt76gcyDRlwA4xe2x8/Sbz+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6166.namprd11.prod.outlook.com (2603:10b6:8:ad::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 22:48:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%6]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 22:48:40 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 23 Jan 2026 14:48:38 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, Alexey
 Kardashevskiy <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Message-ID: <6973fac6a8fea_309510044@dwillia2-mobl4.notmuch>
In-Reply-To: <20260123053057.1350569-2-aik@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
 <20260123053057.1350569-2-aik@amd.com>
Subject: Re: [PATCH kernel 1/2] crypto/ccp: Use PCI bridge defaults for IDE
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0167.namprd05.prod.outlook.com
 (2603:10b6:a03:339::22) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6166:EE_
X-MS-Office365-Filtering-Correlation-Id: 225e7705-535e-4c6b-ba2a-08de5ad18d6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RE9VeTU1M0lHbXprTGZEcysyc0RONDFZbWt3eG92djZQZjhBNXRBdUlSTkFk?=
 =?utf-8?B?cUVYVEFFZGdOcHl4NlphdVZkTEhtVnpGYTdjcnA5dzRkUGRXREs1dUcvbnBj?=
 =?utf-8?B?akFXWjRFUDkwbW1BZmF0VmFqUXdoemNLNXM4QXhJdlBUUllDZW9FNWovWGNL?=
 =?utf-8?B?VHZCandzS3VrMmlseXA5ME5oUjJGTy9GNVZ3enNMN2RieHg3czhrU1JJM0N1?=
 =?utf-8?B?NGRuUk5VcEE1ZzRYU0tJSW0vdHk5Z09meDdRMDVHMFVDMVh2TEhGQytwcUZu?=
 =?utf-8?B?cXdlZHBnMDN4enNtemF3U3VXcDdwOU5MUWlhNnFhdXljdjMwckUraWNNRWU3?=
 =?utf-8?B?ZlVxSGFFdnc5RkV3NVl5NjBacG9iMGk5R1VyTEI3K1ZwMmtsSWdIT21weTA5?=
 =?utf-8?B?cUFNUE9ubEpRRE9rUTcwMXdIdVZOK1M2NFhVZEdyZDJkV01hdlBXeWRGdUJj?=
 =?utf-8?B?UmpueHg1ZFVzZjRGN3hJS21oeEgya0JLaURKUjZMelFDWmdCV010NmJGUXNq?=
 =?utf-8?B?OTFvSFZGdG9vaGREK0gweFNmdFFuZmx2Z3VCWWNGMjU4aEN0ZjBlVWRyekRW?=
 =?utf-8?B?WmRzNERONXNsVEd3UTVsR3N2UldBMWNOZ0JTYjg3ZzlkemdwL3BvdmljSmxV?=
 =?utf-8?B?L0kySWZDdENHM2ZoNGIyeXNQZGRBbnZxYllYRThpdmY5QktLWHBLbitTVnFl?=
 =?utf-8?B?RDFaenlTVWV5ZmNxNUFvYlVOTXVmb0p6dHBwV1VDVDExWTBWMFNUN25KVkpi?=
 =?utf-8?B?cEE5Q0lNcUZVK1Q4SWZhVitaRlpjM1JmZWNPOGNuZFEzZVYzVlpnemNHbUtQ?=
 =?utf-8?B?aE5PZUt2OVkyeGRVd0FLQ3Q1K21mR3pubnNvcUZOVnFUUlZPWGJNV01PWnJV?=
 =?utf-8?B?VjVxR0N2Q3VBdE12cmJTTmhzc1gwZTA0ZytpL0FJQ2VoSGVMRGhacmhBQjN2?=
 =?utf-8?B?dkxXR2p3aWh1RmluUFl5b2RYbkZjajQ0MmZWbDJMUkltV0dZMHdBR1ZWRlRL?=
 =?utf-8?B?U2J4QVFTTWNhUHFkcFZMZk1LME1EeWYrWVVzMlZzUHBnR0xCK2xjS0J4blNv?=
 =?utf-8?B?WlhqZlRqeUlZakhVbEtIcW0wdUlnano3TVdXbFN6eTJqTjRkMXBzODNxQnIr?=
 =?utf-8?B?VzZpOFR0ckZxb1NlZjlQaUJXZkNETkFxOU4rWjV6dm5sbHJCNkZRUW4zdDMw?=
 =?utf-8?B?RTdvSWRCT3R2WlVPY1l4NU9XL3lybUZ0aGxJeTVhdkVsZDFNSHk1aDZpSTZs?=
 =?utf-8?B?QmRyb3lMek9URFJpZFVBYVNkVDRCeXZRdWFhT29IRWRlazg5WGtNdE1PQmU2?=
 =?utf-8?B?azMxY3RpdXpQV2ZuNTNkZ2F1NUVHQmg2MENPRnp4VGpRdndqWWRGbXFrYnZv?=
 =?utf-8?B?ekRhMUZuODA1ZFF5cXhoeGsxQ3E0dyt2V2tNS0lGM1JOT2h2bmpLTDdveFox?=
 =?utf-8?B?Vkdjc0lQWm5zbTdOU3ZVVHE3SmpaRm84VWZ6a1ZpRWtiQ2JmY2RWc2xaSTJE?=
 =?utf-8?B?WUtLem16T0tqeXFjNlI4SzQ3QWkvMXNwdEw4ckhqejYxakMraXpFOHVnY3Bv?=
 =?utf-8?B?VmhqY1N2TnZETlJLVHN3SWpwRHo0d3dpcFJibVVGTFc4MloxTXdXNkRyWGpQ?=
 =?utf-8?B?VkszM3lnYmw2L3plM2hRc2N6QktyNXM2bS9BT3NzRDJ1UGwwc2Q3bUdLeCt6?=
 =?utf-8?B?UENPS2h2MmFka0Z2YzhDWTJGTCtieGVuRUNLdkY1eDg0dEJnZWFPRzRDZERJ?=
 =?utf-8?B?SVFIa2FuVDROK05pYk1xM3ZiVUN6SVlSZi9aeHBWd2p6VGp1VllBVmxlait0?=
 =?utf-8?B?UVBuMDFRdnFCdU1wNDFVdkZqeXhJa3MzYnBWemxqL05QS1EyZ1NBL2JLQ05T?=
 =?utf-8?B?d2hONjBiTldzUnBRVitIcktuUmd6MlFPVHhsMlQ5MUdxY0RUWklBQUlkMWV2?=
 =?utf-8?B?b2xESUwyS0lNZDFoaWF3L01GMDlkNk1Ma3RicTd1d2lMcUpaNi9rSnZCYzlt?=
 =?utf-8?B?a0V2ZzhyMkZScWZxNm5rakRUOEZnUXB2MEpJa1E1RGtWSHpUUzhjN0oxZ09j?=
 =?utf-8?B?MDR0d2J4dXhSTngrcS8yTVhoY2dxeUIweDh5RXZWYVg3K0tienVnSm5WQUxG?=
 =?utf-8?Q?pGLU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjJ4c2JrUVdZeWJuSnJWSnZCNEtYbEFSL3Bqd3FUSG5UdGt1MnE5VVlubU1r?=
 =?utf-8?B?djgzaHF3bGNRSEpzY2hQTUM5WUNpNlBLRFlFYTB5QVVoMFZFb1REN05WZmdw?=
 =?utf-8?B?eTA3K0s2VTJpSDN5L2ZBU09ySHRHQjNwd2Q5Yks1dXNUOFJzK1dKNGZYb1VJ?=
 =?utf-8?B?M0xVRVIwbXpOTGs1UjFxcWFqQmNJWW5HdDlHaW5HejRRdUhkVUMwZTVqN2tZ?=
 =?utf-8?B?SUs4UHVMc2d4K244TGgxOXh6NTh5alE4SFNGbFJIQkNDV3BoSnhVL1p2VGE1?=
 =?utf-8?B?Ym5JRVlLUWhxd0pENm9teEhPY0dzMHhMZDAwODhQc0p4OGpEdTBoUk1FcXh0?=
 =?utf-8?B?SHgzNTNudFFPWFkzT01wbnBwdHdZMkNRKzlEbDAwb253QTVRdkVzUStObGlO?=
 =?utf-8?B?QzRGSjBnQ1paMm43dlBrRmRBWFlpWlJRVTN2VHZZVkVsaktzY0t5bms1cFVw?=
 =?utf-8?B?WURoUTFUUmNza245UUwyeEJ6SEZvQkh3YXNoemVUaS9LY2plbGlFVk9kRjJG?=
 =?utf-8?B?TlQyVzVKZHJIWHZKUWtYUTNuUk0yQ0FxMjhqOEdQR1RkV3pwUzduVXlYamd1?=
 =?utf-8?B?ODV0NHh3Nm9yUVNML2sySGppdUx0VHNLYVh1WUl5b05Ic05CdHJuUEhkQVR0?=
 =?utf-8?B?THhvYTVBSFBSQk5NMjZvWWpwSFJZV3ZJVC84Sk1FNHYzYkNLMUg2L0J6Ty8x?=
 =?utf-8?B?cXNXUG5VTDlTdFQrVS9NUm9MTkp6ZzNlYmUvdnh5UVV4YWNkRk5xY3MvOEF4?=
 =?utf-8?B?TGFUdElHNzA5cjFqL211Vko1WHNJZ2IxR0EvWENyYzJXRmtIQ3N0NGhybmJt?=
 =?utf-8?B?Q3BpYVJTcmJuYUV5U210cTc1R0xoUmQwTTNIM3NneGpzdUZxcUNzOCtodzdI?=
 =?utf-8?B?UW0rWnFZMHJhL2p2c1dtMU94bXlDb01WWTl2WGVvTXFRdGhFUytUZmxUQ3d5?=
 =?utf-8?B?b0txUCtWRkhPL091dXlYeUF6dnRBUHhGSGhXWmJCMTMwVGtQVE0wci8zdDh0?=
 =?utf-8?B?Y1BYSXZrVjgrTGxtMWt2VHZIcUNHRUFiZWYrWlRpa1hZdC93L3NRb2daaWlG?=
 =?utf-8?B?UHdLZDdpb3Q2NkZvd0dyTlJFNExZRlBORlFSdUZnaDAwemo5Ly9NZTFTK1JV?=
 =?utf-8?B?M2tXa2dLd0dNTnloMzZoYXlGa1pEcHRUcW9IZ1RwV0ZsWmF5ZzhRblZIbjRi?=
 =?utf-8?B?Wlk0TUQyZWFhazlSQ1U1Z0pIbGlrdEVQQ1hUYW9FZitrWWVjNkk0RXhzVW1U?=
 =?utf-8?B?SmdJekdlZGd5Q1lFbTVKQitxM3haSWpmbXh6NHk1VzVVamw1Qy9jTEhIWjZK?=
 =?utf-8?B?b0kvRUx3NTRsVFJjTkJ3ZTV4UEJ0NDIxdHNxMktNdFAwRVVlUFJhUTBWbW5Q?=
 =?utf-8?B?NG40ZlVFSGVqWTJTbUtZWktEUlp2dmpZdzFSYmpRQ1pidHZkS1BSMm1JMU01?=
 =?utf-8?B?SFk4VnNRU1pwYlF6RllHVmRDYjFGWjRkUHUzYk1FUW1UdjRNTUpFdmw0NCt1?=
 =?utf-8?B?WVB3YWJObi9jYXFtZENOdTJOYnBKcUFqUWNBT3BnbzJGTjN2eVhZZVFlbGkv?=
 =?utf-8?B?ZEJnQ0ludmkrT0g4ODlJKzE3eUQvQ3N1RjlDRmRqM2J2QjJydDdSaVIxTzlG?=
 =?utf-8?B?a1NSeUZ1KzdFZ2lFWmNRanJMdjIrVDh2SDBpVXBtZm9HclZqZnpYSXgwM0tC?=
 =?utf-8?B?alhUVGZkMWxtZzl4dFFWWVlBRVJseEttNU12UHFMa2dJN0U2blE2K1ZKeVJy?=
 =?utf-8?B?ckFHYWpxU2pXTXlaQzd3UlVBWTFoZDdWTWNiNjJySzJ0L0dQYXR2WnQ4NzdQ?=
 =?utf-8?B?c1c5dDRab2wwRmJkbEhoclIySU5UdnkxRThleVA4NXc5am93dngvSkZibkVR?=
 =?utf-8?B?bm5vMXJtTTRwWUVZMUl0VUlCZldHMndMMmFDMEVBRHR2K1JPNDBrd2F1RndV?=
 =?utf-8?B?SG83RWp6WEt5ZWI1WW85dnhmbXZGdVN0dUJ0MUt0S2srZk5vM29lVjZCUEhl?=
 =?utf-8?B?VkhPeFo2NkY3UXNUN3gyL0NBUTc5TUhReXBMR1RRdFVOSG1pWDc5cHdBWmVK?=
 =?utf-8?B?R0dYMWU5c3daWWdKejZaZVR6Vjk5WXB3K0tVaFNOby9lNzVoREVUeXk5TkV0?=
 =?utf-8?B?dldBMFN5Tk5GSk5ZZzNGSTNWdVB1RWo3VEh3N296Zi9HV25VbmJ5Vm9QY3dt?=
 =?utf-8?B?emNBRDArcHNrbERRZk9TanRERHBwdnFrdjcwUm9xa1NNVlNHZHB4eFJjSWE4?=
 =?utf-8?B?bjJvTTREdVNXMEpydCtFb3dtQUVOanZEdWd1MkNaSmFQaWsvbE91TktQWDBs?=
 =?utf-8?B?L1FHUVRINS9HRUdrdDJoQUZ2d2lQblBFV3FraC9Qd3JScEwrOEF1RnFRM282?=
 =?utf-8?Q?Yvnp2y91sZzLsKh8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 225e7705-535e-4c6b-ba2a-08de5ad18d6d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 22:48:40.1678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LnjLD7jND8wc4nj49CyNPZQbNhf9WYczy4SeYLdPq+qdJjFhzhkg4rYSy6RXuZuwvVr+SVHf/qbmH7vuVHVpNJDe3OAAnYLofQTZkiX7kKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6166
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> The current number of streams in AMD TSM is 1 which is too little,
> the core uses 255. Also, even if the module parameter is increased,
> calling pci_ide_set_nr_streams() second time triggers WARN_ON.
> 
> Simplify the code by sticking to the PCI core defaults.
> 
> Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index ea29cd5d0ff9..7407b77c2ef2 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -19,12 +19,6 @@
>  
>  MODULE_IMPORT_NS("PCI_IDE");
>  
> -#define TIO_DEFAULT_NR_IDE_STREAMS	1
> -
> -static uint nr_ide_streams = TIO_DEFAULT_NR_IDE_STREAMS;
> -module_param_named(ide_nr, nr_ide_streams, uint, 0644);
> -MODULE_PARM_DESC(ide_nr, "Set the maximum number of IDE streams per PHB");
> -

Yes, happy to see any reduction in ABI surface, especially module
parameters.

Acked-by: Dan Williams <dan.j.williams@intel.com>

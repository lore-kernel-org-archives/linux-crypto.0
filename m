Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31022472BB;
	Mon,  1 Dec 2025 20:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764621649; cv=fail; b=L4kKGmBNZCX9+SyLSUq9i1nayUENpMiA0sOMSe5fdrQ26gjK55tQYZlKHlHs3ngIsJdIxKErz4JWKiYY6C69OfvyqNS9btfpOuV+qpX6rqvMPWK48D7I8ahZMpJzl24hVpj/oIboA/50LEeF4eKWjZkkdwMWK8z/s6Gv0Gc/d1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764621649; c=relaxed/simple;
	bh=QFuzJoJNsQX7Xa+jf1cwq+2BmBxi3buvl6/9bhHSQ7w=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=ZNpKFdmNhrODOyA/tW6f0S4608W/7I5dHNmvudlYJmtyuDM8e6iu7+Pgasespo3TPGx2oCbdBAsV06/uMKjtPr0/dNUz7IpytcVoVQGi1OG/V0Xp/wwWzSb6q6tU+OYMnQVyc7spkDuEsjLDq35+US6V6pCAefejfopDYAzu7Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lyfBQcbs; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lyfBQcbs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764621649; x=1796157649;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=QFuzJoJNsQX7Xa+jf1cwq+2BmBxi3buvl6/9bhHSQ7w=;
  b=lyfBQcbsqKJKcRDn5vLDu162agAdLbW92iqtVdZ3OMYsHOovhI5PLd/F
   r3HnrF8Lj4pQ50871Ntev9Lml0CkYIJkfOgqJHCMcsNXJVlfLxFkjYyHt
   6vJi5UtnRz8plfoO375Ojo/frwzvsftMv04NSBL7HYNavkSwqjBc4Auz1
   f0vpgakodz+TVpNzKG7krHPxLPtuPkX83Hd2kp+ok2h5p//v6jyw6blpw
   GUs8hPEoyBlExoxAoYRmBZrfzvEJKs4NWDEvCLzTWaQlYym56/FmSljNm
   GlILoGXDR+IdbRajorP+fos0YDVjJkypshnIZ3MQXnNkaL81T+qCgZbJR
   g==;
X-CSE-ConnectionGUID: jUkZOkSnQy2b8L14dZLCNw==
X-CSE-MsgGUID: 542lv9H2QuuHxE//0dDZkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="83968452"
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="83968452"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 12:40:48 -0800
X-CSE-ConnectionGUID: BaGJIQgmSFy40lNIy8RNIg==
X-CSE-MsgGUID: w4P3NFzQRvy4uY6ZA2qLSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,241,1758610800"; 
   d="scan'208";a="199104943"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 12:40:46 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 12:40:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 1 Dec 2025 12:40:45 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 1 Dec 2025 12:40:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ak9MZXs6ezvLXxjyS5wrbafA7EGdX+fBhNqM1V3aroxq59hst/bRSjtgJXPslApxogZKzpX5K9fB5/+aetngrro8GWj8om7MP2/dEPzuJhfel4eOHRB1kz5Ds/RUOt6fxb//uhsYWXb8ACR2OP+4vue4T39qOank7Zm5XBtp48GLvEptR6USp7MRPx97xUI/iIGsE3xjsSvaLldPy0ww50SPOpgPofJe35ycNjOXM2WjFZ6xPxwnBrLPneRc58fqZW46y3yUDFPvRVLLZcMj79v7VTkgCvNzAVQhgpK8VLoc8FPKWuT0eqzQwxzwiwABzCQB3dY7p+EUmTIXdaCMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMx85KVJOQyezvDwNFcFpjm6GyXXIA1LbxHnqG/4Upw=;
 b=aij2gYx4Yr639tqSFZ4NnaSbQC/Rj+CXQUJxtBWG8OZOOkXoBRJJBaRp3wu80b1fRoNHoCBbzpxp5tZoGaoF86TTVmC4EulC97gbLEeIC5bYay4zTqbbgEIaeunVhNHnlsqIkw+5O+9wPNvDS/9qOxTPqXPcE+zmwoOPVrIetmVqfKaGoQaJ0iVZJbZtPYBvxhuXyzmQKdMoRHcTspI3+osqAKlFHy3spm6iA8dw5Oi7KsYl+JbbXlagf5BgpHExeUaGoWxxGMLdNWJ7x2aDTIeaOmh4jwT4zBRSkFwanFGGuRuytLS9p+CyYiYnb5dmwtvfZEXSE2lDbx/ghIefmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 20:40:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 20:40:43 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 1 Dec 2025 12:40:41 -0800
To: Tom Lendacky <thomas.lendacky@amd.com>, <dan.j.williams@intel.com>,
	"Alexey Kardashevskiy" <aik@amd.com>, <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, John Allen <john.allen@amd.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon
	<will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Borislav Petkov
 (AMD)" <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>, Jerry Snitselaar
	<jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, "Gao Shiyuan" <gaoshiyuan@baidu.com>, Sean Christopherson
	<seanjc@google.com>, Nikunj A Dadhania <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Amit Shah" <amit.shah@amd.com>, Peter Gonda
	<pgonda@google.com>, <iommu@lists.linux.dev>
Message-ID: <692dfd49c9765_261c110071@dwillia2-mobl4.notmuch>
In-Reply-To: <2dcb2fba-5bcc-42ba-97db-f275fb859cf8@amd.com>
References: <20251121080629.444992-1-aik@amd.com>
 <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>
 <2dcb2fba-5bcc-42ba-97db-f275fb859cf8@amd.com>
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::28) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e0d30f0-1ff0-41a7-7c25-08de3119e5c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TWFjdzFvaFpwZGRZUm5KVUpwR3ZrNmYrR0llZ1JRWFE1TmwwUzk0RGRHdmtj?=
 =?utf-8?B?d1FhZGdrOG1tRlNoQ25ETHpBSlNmbVBZVnlQMmlhejg3VXhpOVR5Q0w1Sk5i?=
 =?utf-8?B?VEJEOVhqNy80eHNBRUgrSXBKaUFYaVc3TkJST0FXZE54Qk9oclRHLzlSTjIv?=
 =?utf-8?B?N0kwcHJ0eFA3ejlwbDZHSjJEc0ZmcHMxK3RuUi9WOWdVOHJ2L3J1bUNMbkdG?=
 =?utf-8?B?TlZtQnd0ODFzMi9ralV3WXBFeHA4UjQyQ0xaRGVCNUJqZXRXY0tMaXl6UEgz?=
 =?utf-8?B?TVlsQ0w4VzloWkhITXJVaFg3QWRVSEtBWnVWalpvdWcrcFM2ZDBvY05zQTlw?=
 =?utf-8?B?dVRGQnNYNFRUeGZ0elJRUG1XbzVHSzY4eWh3ZWtyVUF5emN1NEprN1B1Y3Zq?=
 =?utf-8?B?N1pFR2RXc01md3E1eThtRG53NzBjTFRwMHNCZ2Q4UTJBcEpGMk15UkUwZWoz?=
 =?utf-8?B?YzEydzFXVjl6bzRkc282LytEU1ZRa1VWa1ZyWTZidkJ5YU5kMVY4dms0YktM?=
 =?utf-8?B?bFVQRVFUc3pqSFpFQVB1dVovdEJXZVcrS2diMHVPK3kyd0pnY2QxSy9iY3Uv?=
 =?utf-8?B?VUhKT20rcXJuQlg3K0pDSUdFcDR1ZnRUWGx1eDhzYmxtV0RTR2lpbXp2KzJJ?=
 =?utf-8?B?TWNQSnY4R29FSVpiRHlteWtiQitySkl5cHhOZk9FM1hhbVUrZ3k3Ti9LbWNB?=
 =?utf-8?B?a2pKeXBWTmRBZUF1aHhBU3lRYmZlSDk0Z09pSW9xZlZTK3lRUDlVM2dlK2NZ?=
 =?utf-8?B?UkJ6NXRwUVVKbVFFUkZMRFZzUlJwS2F1c2d3cXpTNlppSVZwdW1Kbnh0eFpa?=
 =?utf-8?B?emU3VnNBT0twcEphOVR3UFJsM3JUdG1oM0lFSm9TUDNBOFZDQ0Z5emRORWlL?=
 =?utf-8?B?NnJldjQraFE1aENkM3NTVnRSVTBUMnhydWRueTdvYlJFQUdWNm0weUgyY01S?=
 =?utf-8?B?Y0hIZlY1TGkyMkJkTCtJbFJURk5kaTQ5SG5EbzlvOUlFWUtZRjFhTmkxTFRp?=
 =?utf-8?B?Q0Nya21ISVBRM1ZVWGE1VUpQU2dQVFdZU2lWdzJLTkxYZktBZVp3YzJZRE9r?=
 =?utf-8?B?NHNtajVGb2VrQXlVK0dTTE5NZ3Nva2ZIU05XclZ4U2tUT3F4RWRqNmJBTXdt?=
 =?utf-8?B?OVZEUS9UQk9nTHY3c0hNdG1DRkpGRTBlY0Z6ZlBYbGlzalZZVWxSR2dScVFo?=
 =?utf-8?B?SXozU0YzaDVOK2tqQ0hxcXdDWlI2TVdHOVJRcW5ka1NxM25SbmE0MjhCNGVu?=
 =?utf-8?B?UmZOdGpSakZnTUdCVWVHOVAzTjhpNjdDRUdGbGl2MFJyTVc1bCt5cjRMSEF1?=
 =?utf-8?B?QWZkR2tPcHJpZENXVkNZUlJzaTExREdrM0d4QU9IbWROWVVPc1VSYkdFdzlM?=
 =?utf-8?B?RVhqNG04YWdob2U5R3dyaEdYQzE0QkppcGxwTm5yYmplMVA1THVsRm9CaVNS?=
 =?utf-8?B?SUwzNUdsU0I4OGxFZzFUTWZubXdPVHdCdTg4bVgxendzeS82VDl3YkN1WDRz?=
 =?utf-8?B?cHZ4NmdtR2s4ZWlpdXYxR1daMjM3cEJkOUFZZ2pldkFpUm5YQ2FZWUhXdCtQ?=
 =?utf-8?B?MjlFYkxSaTljbnRzOXliaEp3Y2NCTVhmVTg3VHhYL2hCZWdWK3V2Tk12ZnlX?=
 =?utf-8?B?bWU1UmJEYXk5SUI0NE03QzZXcUZJSUsrSGlGc0toYklKNHhiN0oxbWNuYVNK?=
 =?utf-8?B?Y2dPTW9pTWVMME8yL2Z3aDlyTzNQRGJRZ3A3emp0Q2trTmF0S1BZOTYxOFI0?=
 =?utf-8?B?ODdBeUlUT1ZvU3lWSnpKTzN3MFBCVmZuNE5HN0dVRG9kUjNWWDNUSThYS2l3?=
 =?utf-8?B?dXFzWEh0dm5Sb2piNTFaN09HeUhCemEyNUIzS25KTis0Uy9XSW9EWTdRTDNr?=
 =?utf-8?B?aGpoaFNSd0hreitxeTQwVkVGaVhmVHBhK3N0aUJPVVRmRzBCOXpXMXBIWGhi?=
 =?utf-8?Q?vlaxAQtnyhuZqt99w0Eenjvr515RcFJn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDdYYkNNT3NHcE5YcE4vMytaVEV3eUMxbG95dW9HQnBxdFY3QTdaLy9xNEtj?=
 =?utf-8?B?Q2hFNUM5bkNTSFE1U3hpUDJPMTY2RWZTVzJhSTE0bzlvb2FSTXFQd3k4QmNC?=
 =?utf-8?B?YnpJUUNSQ0NzV2JjWUlHUGs1TE1OMDVzNGxGRW50bVVzaWI2TFZoWnZIT0cx?=
 =?utf-8?B?M2RIMVV4M1JzaCswUVhLdms2bVcrNFEzSXloMGdTNVM2a3pVTmltVE1IYUIv?=
 =?utf-8?B?cWE5YitESEVrNG03WVRLdnVjU0lLUWIzUDc4ZmFOdDVQTDkxOWhTMGJVZjEr?=
 =?utf-8?B?dkN5cjJ5T2NlQ0pwK0tYYmxVa2xhNE1BWlp0WXlldU8xTm1WbzdaSFMxajJR?=
 =?utf-8?B?L0d6ME1VK3NaclZ3ZzFSZHNKZG9BQXMrZnhQcEJUWmRPd0FvenlyYm1PL1dR?=
 =?utf-8?B?QmZPRVdWVW9mZ1Ewb2E2RVNGNWIyZlFKV2krc2ZVTDAwNjBSVGYyRGZJSGFl?=
 =?utf-8?B?bGoxR3cyck5USmg3djlTcVJ5U09iOWRVZDZhekZ0bm0rd3E3aVhIY2RCYlpz?=
 =?utf-8?B?cVZhTHZRRUpvTWdWOTY4OVl1TUtIZHlnMDkwQk56Y1dTZXVpdSthVm1id3k5?=
 =?utf-8?B?cmEvVGQ1NTE2dVVzb0FtR1NhTkFieHNPNHZQa2FheVB6STR1QkFBK1pBTFgx?=
 =?utf-8?B?cUhheVhRUmVtN2Znd3F4cEcxM0pOVEoxYXpTY1ZUOU9xazBXeGErMnpCT0JH?=
 =?utf-8?B?MWdCTnV0R0Q3TlFKOEhweGFFSTJ1NHVuVFRoMUNMS3l2emgwMDlVaFBmb0kz?=
 =?utf-8?B?bUJDdHNqTm5EcXBncWQrWEdDTmlMUUQ0WlRwcm5SZkI1dzRMR0llTGtFeG05?=
 =?utf-8?B?UDlSWDl0M0pnRmlPSjlEY2x0ZnVXUVdWVEFMWU4rS3Q2Nk45TFhrZC9teXJU?=
 =?utf-8?B?Q3U1MEFnTXlhazRXM0NOVVFCNFFncFhrd2FzTTllb2NVdFRGdnpLRzllQSsv?=
 =?utf-8?B?K3diL2ZzVDVwMWQ5REJ2dkhhRWxxQ3prZm9URlJUbEl2dG9RQ2lzdzZkZDNr?=
 =?utf-8?B?NzBxL0hlRFRvTGRteCtNQmEyR0lmMmFvY2F1Um80dFBobEtSbnUxVWE3K0s1?=
 =?utf-8?B?RU44eCtWY3B2d1l3U2twOWZCamhVVkRRQ25DQ1h3clBxMzNCNUJQUTBnYnE2?=
 =?utf-8?B?TjJqZ2NuaXR1dDdlV0FqL2FpTnNVeFN4Q05nRHlqQ2IyUHRyeGpYOFZzbGhn?=
 =?utf-8?B?QndKeitueUdYQ011Z1h1WU0yWGxRSS8wNUl2Tm1sVEZJdVpRVE41REJzaTMw?=
 =?utf-8?B?RXhCc3RKSkkvcGt0aXQvT3pkNjB6U0pNaS84cXZsVWNUejJvdHQxdjQ5RmVX?=
 =?utf-8?B?Z3J0SXQrOGlraEtYNEJXSDhwRlh5aVJSSWs5WG1PeGFxb0w4WTlwYVlET1FM?=
 =?utf-8?B?a0J1a29VK3dsZ1ZWTHNCenp4VjdpL1dSYVBsRlNSQ0NRTGpya3NqMGpvYWR6?=
 =?utf-8?B?NGNBcU9Rd3VVTkVXSHV2TnlrZlF3V1AyODRYUUpGNnNyZEplK0Z5cHNZcE9I?=
 =?utf-8?B?N0d3MWkrY2dicE05bThENWZUTWVZTVp1cEtEUm91amFQUEhUNlBhZURrYkd4?=
 =?utf-8?B?OUZQbDBlcGZCdGxpMCtUS2xuMFA4ekVNZkxZSXVhcnFNZmdOVDRlOHZYa0Yw?=
 =?utf-8?B?R1YxbWxNTTBNKzNvdDk5MVpYeFhuVlJybkhQK1N1MHUzOFpUcFprazJMdTla?=
 =?utf-8?B?WHpsemdpSHhvY1BTR0M5YXh2NS9aZkhoV3pBOTlIQTkya0UrakZQbmo0V1JN?=
 =?utf-8?B?ZEZ4Y1hFc09vcVAzOWI2VDBjNlFZM21tZldsTEN5U2tkRFUzUFpMNnpIK3l1?=
 =?utf-8?B?RnlmMzFIMVhtbS9nM21jV1B4R3RwR0pRSERNeDNjK1hxYzRGRWdSdjUvbmhY?=
 =?utf-8?B?UGpNUG5Wb01JYWZuVDB4blR2RjVha25iZlRKZEN0MmE4YnN1YlRnNGNDczh3?=
 =?utf-8?B?d3I4VlY5QllacitUd0pSKzRjZHdaamJYUVdnNnFNTzJwdVF4ZzM5UXVQVXly?=
 =?utf-8?B?NUE1TUMzSFVaUjNiYU1OaWYzVUhEOXdsaXNCUmdwOVUvdFpqUHR2N2hXR0dB?=
 =?utf-8?B?YklnbnZ2YWgyQjVOeHZTRjlrRnB4b2lsQUdXRUVkL3RuOEwrdS9VQ2I4VFY1?=
 =?utf-8?B?R1A4UnMrc2ZYTytQcG1PMFVvUm1VQVFZM1NoMHR2YXNhRVVVc1h1OFRrc254?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0d30f0-1ff0-41a7-7c25-08de3119e5c9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 20:40:43.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aRO5F6wQYddCbdJFRhsZFsIJ9p7GuzGCd5KVEI/zz9RBpIubT8OeZ1mj3+jGZPg1AW5UR78y8sxrNwkp5GIMV82Lo1mOQ76eTCQ3KxMHLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com

Tom Lendacky wrote:
[..]
> > 
> > This looks ok to me. If the AMD IOMMU and CCP maintainers can give it an
> > ack I can queue this for v6.19, but let me know if the timing is too
> > tight and this needs to circle around for v6.20.
> 
> I had some comments in patches 4 and 5 that I hope would be quick to
> cleanup.

Those comments look good, and are significant. If Alexey can do a quick
turnaround on those and I can get them in tsm.git#next before tomorrow
(PST), then maybe a Friday pull is still in the offing. If not, this
will all need to wait for v6.20.

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D4825D21A
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 11:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758110257; cv=fail; b=ZVTR6H9NcDXiqyivkCPVN0wadnvFEX8Qq4oZxK6cLB9zjzG1CjJ9FmiIP1lZOoXnhpSymStGP6MK8EwVei6LWEwvhqqOqPSfVZ0avge+rcLnErONBIu73iB7AN8QaW/OBzJyjRreWeV9NyDodl3TW/e2BPwS2S2ON6Zv/amydHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758110257; c=relaxed/simple;
	bh=YV1QmGgTbng1x7WqhGf0XUM3fdqTKVPHzzmXbWdGZjo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mCanRDGxkQn1GOCGZO5ZLobdVMxwbZkOg/ABDrrfGSsSn7c+rdZLsfWjCnPred/qi0CPDLEXbOw45PHJf1O23wNETNOzsPmLfBH+B0OiG2R78/VyuiujCFXyVn4KK8BOaIP6Twr/PcvQZ5O1zgz5XVu6XcIkIg33vYLTMqEOqaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYVYAgh8; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYVYAgh8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758110257; x=1789646257;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=YV1QmGgTbng1x7WqhGf0XUM3fdqTKVPHzzmXbWdGZjo=;
  b=LYVYAgh8SzRcoAwrOQHFc8IhC7DEXA0tkyhingYbI059jVmE/OVH+SJV
   slZE+aZp0+MSc2a09LwN13bGDsCLvUJIrm4exJ8hjNRV/jvVk2h+cdT2W
   vas1sxqWigYm5j7kgTFr4+7g6FwBbme+IbCWpgZVUBcK/cs0bLZNR+dwo
   LMWdlr4tFp1ikbVIXGdt3XmggYRJN9/mh+niFVbtmLQdQkBeeQEcIBPq5
   rL9tzPW0Jl8pJBF6Wx982ykCgNlC9w43zIscgazgTIJylTY7SO4wq48l7
   /3EfcQpx+nqHtWXOFhlTVpUs+1iR+nab+K0yKz8P1CLDS4/xnDIzz0QiW
   Q==;
X-CSE-ConnectionGUID: GKM3uq4tQoyO7sB+/JOLgQ==
X-CSE-MsgGUID: C0kjyExoQFC4VAl0S2uaBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71838003"
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="71838003"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 04:57:19 -0700
X-CSE-ConnectionGUID: FIqoMnUIQ/uJTFuafgjOPw==
X-CSE-MsgGUID: 9wgAFtQlS3SarGdYa1jPOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,272,1751266800"; 
   d="scan'208";a="179629831"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 04:57:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 04:57:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 04:57:16 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.28) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 04:57:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVl2MjPOvrz90ehJ0rhnJ7HY2HOmlMdfJXEwIV2/i4zyfrstu9hzRwEf7THS1roPnCH5PtkuKLA4XfNJ/tbvhcScS2b2vIk6+I65Y+mqkcv1zZ6SnYO3dYtm3wjDk3vG9EjunERpXM8IK98xoHaVXXKZATW65IWJJjPPX+1HR3WTjAi+wZSNMM8A4wYfmTw/wTZ8xgB6EG19rKRvRYgblVYc+6IVvDjyepU4AQOKQ+1eYnKoYPKX93QC+56HhfcdWl67O+I+8AdLuWjEz2vJG/+DKmQdO+OIJ2kyBmy1ZoYIsiovL7YSx4PWzPDR5Yb8+H/0VeryMtlZiTmEf4dnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fugd0/H6sCjrWQ/AYFGKhHtSxsSW/k9nlvuXZgAuvYg=;
 b=CQWV142sj3GuuSttP2IjtsYsyWlnUWAkQhtQ8GR8GrgnpI7bsfjco3oxfFzCryLuujr1zKC9b3b+O33fPJndSjsvK92AdziJdbFh859SJ4PqfiSx/7fT7FWphlLmQavdPJzSfRQLveVHR9hlU/Kul/vICyLKaGRqZNdJVfM+FDKUeUlMkx7IZzabCU4jBLr+wKjSx/n43j6EpYv1s8lKFOtkKbgy87jk2SA+M/BauxhMRu1tmgXpH3zmU7zcCK1O5Zzs3MOd4s4m5u43yuZ9rcGiVzCOgBU9Bsh2Y1S3jQ0hAnR48Ynu/jrQeoA9Th6PTHbCSkNgXNOrEu7HLJHz+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS7PR11MB8783.namprd11.prod.outlook.com (2603:10b6:8:254::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 11:57:14 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::22af:c9c9:3681:5201%6]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 11:57:14 +0000
Date: Wed, 17 Sep 2025 12:56:41 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Thorsten Blum
	<thorsten.blum@linux.dev>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - Return pointer directly in
 adf_ctl_alloc_resources
Message-ID: <aMqh+eZrRvyLQGUF@gcabiddu-mobl.ger.corp.intel.com>
References: <aMTyFx91lhp9galJ@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMTyFx91lhp9galJ@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0012.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS7PR11MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 4305f89e-dddb-4e24-4fef-08ddf5e1574b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUQzNjFwemRtRzhOam1QSGNTbGJDYnFpb2FnVnJ5aU1YN3VqVm5ncXpTTGtw?=
 =?utf-8?B?S0pEU3RDTG9HUUZjTERDN0ZFRGlhdGF3NGNWYk02eXN2ODBDYnF1T2FVdnJy?=
 =?utf-8?B?eHZNa1hKVmVCdElJNTBZd2RybEU2ZXIzVWhaVklOT0tPSzdCdHpKd3hsTXRu?=
 =?utf-8?B?M3RHTnU1RjZHVmlGOERzRTJuWkZocWFBRklCRTI5Tkk3NmZTdkxpMTFKT1hn?=
 =?utf-8?B?aUorUWxrRkdscnNZbTcxQXRObzJsem4yTXlYVHBGR1JtcE9MVG9hTC9PU2Yx?=
 =?utf-8?B?MThtN21Ib1BlNEpaZFNxN3ZXOHNzc0xUM3M3aTc3Q2t5T1V4dEg4YlJQL01V?=
 =?utf-8?B?QUExa2ZtTXVLMkczVUxRMElHZHNFek5YbDUyTndpbHBzU1UwT2IyL2hRVGdT?=
 =?utf-8?B?WFF0U0xlU2s5K3dXQ3BZQi8zd0lOSVdIcTFyd1ozTTlHZHpxRkhELytpM0Z1?=
 =?utf-8?B?S3B4b3ZYcGR6OEU1REZuNGhwL0g0THFVY0NVaEhyYzBmMGJpTXlkS2VoYUNC?=
 =?utf-8?B?STU5NjV2SkRMZjdCcWdQb2ZNNmVvQWpqMWptQy9iVDBRY0k3QjJlY3NnRk1p?=
 =?utf-8?B?ZUQ3YTZ6UHZKZ0ZQaHFsQ1B2MkZFTXJBTFVYbTVKVXYybW5NWXQ1eUE0VnlC?=
 =?utf-8?B?Rjl0ckIyRXlqdkllMDEveXhhMDlROHl1WkIzWlZtd1NFTmNyZi9mNTNBeDZI?=
 =?utf-8?B?VlA3UGorMXB2MWs3a1FyTjh1bTlwcGN2Q3NESHhzWXByV2wzVkVtYU9tTEFJ?=
 =?utf-8?B?bTZac3hsRm94SDN3Yng4NkVydCswdDI4NVBYYkFhZjZyWGwzejN1bldEcVJt?=
 =?utf-8?B?VE5VTU1mMWdLWk9Ya3NrNHBIbXA5M1YyNTRTSmErRXJCMFFBaC9JVUpnOEg4?=
 =?utf-8?B?bzljTDlDRnVjSW54UmJKRFREVnplWFVIWno0UEFtYkdyS2JGYVpZdi9qNVVT?=
 =?utf-8?B?YWVYaWNhK0s5bjNYVm5vNUhkOTE3Y3RKTUs0OFlnb0E3bW9WeGZ0QXhReUwz?=
 =?utf-8?B?bFZ3enpLTlZQa24wdkliZ1VEV3IyVkxqWmlGK3FZOU1qTktoL28vZXdmNzRV?=
 =?utf-8?B?UEZ1ZXdyeVMrQXVMNTRMNzNmWGdWQWY4VUhFYzhhRVp5VmZHRjlTSjNpelBk?=
 =?utf-8?B?a0IwZndCbFFjRUxlSCtWTUphR0VGU1Z0L1g1Vit1dGxza0tGSWpjLzIxTVdu?=
 =?utf-8?B?NkVYSEtBRENPaFZJMkVOeG16NTJjOCtNSjlVbWRhbzJvMitQRm1wZ0FIVVF3?=
 =?utf-8?B?QW1wV3F5b1g4WDFYd2RQWGJNSGYraHJFc3VnVURxaS8vL25RY0JFOGk1dm9s?=
 =?utf-8?B?bndIbFptRi9MQnBqeG9FVUo4WTI1KzJ6TFpDazFhRWhLaElWNmovTWp5UUlD?=
 =?utf-8?B?RG9iZDE5YnNEbWt4RU5UL2tVNVBDSFlmOGlqZ2o1emVMM2pwbVYrNVpxUUxF?=
 =?utf-8?B?V0xJWjhock4xQzN3K1RmN2QrZ2tidXJ1ZVBHMHVjWlcwNWh4RmpTclJ1Q09p?=
 =?utf-8?B?Um5GYU5wUXZnTXY3c3grWG81c2s4OWozNUhGQi8vTlhoUERKeXZJTFRlbzA4?=
 =?utf-8?B?ODVSak54am9sV3p0RE5UYm5Kdkw3OERaNHRXKzVLc0s3cThYTGdwQWNxalF0?=
 =?utf-8?B?eU1yZWRFb3JWQU1PUEVxaTY5dFEzak9MSXRsTjdJVUtiR2d2WXBya3BXdjA1?=
 =?utf-8?B?WUtuZkNTcnJsZEJpR0p2T1o5ZjFVVWpWTlhZeW9RcjZYZ2xMTDBXSCs1bmJ6?=
 =?utf-8?B?NXE5MEhRRzdvZ2NaY0VqTlRZSk5rWFJBelJIMWkxSEhWOXdjWXk1dllZazhU?=
 =?utf-8?B?Tk51dVdYSVBBdXVrazBxUWxkeDYwNEVtMGdlVmRZWUxkSWJkUzNyUkl0REg3?=
 =?utf-8?B?TkhoQTdSWG5OUFdtZ0VtRjVDTHc0K0FqRDAyTGNMKzZsMWpjcklCRDRQejlx?=
 =?utf-8?Q?fPN+xYT50z4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG1CeVJuUTM1MlFiaW1KTVg1Q3YxR2JYSkM5RnhDNXBKclhjbmNWNjhUcVBn?=
 =?utf-8?B?bTU2YW5ZcnVtMm15eFRSZWY2clR2T3h2LzNFWDkrN3NMbWM2VWd5dFZhTEV4?=
 =?utf-8?B?THpIc2VrY1N3VldBZEQyRWZFQ3lpYWxLY1hYTGE1UlpYeVBkLzBFdEU1T2JE?=
 =?utf-8?B?UW9keFp5dlU1RzJZQzFTRnFRQ3ovbDFUbytGb1NCTFFNS084RzdEeU1FRXU5?=
 =?utf-8?B?UVhKTFpLaGtXdzNkSDVsTkxPcUY0TkpOOWdqOENqYlU5eE1JZnpIMUNVYmVR?=
 =?utf-8?B?MjRJeHZwbHozUmhhQWRRRng3OXhlUkkvWnJGSjQvNHcyeDNZOTVDMkM0dXo4?=
 =?utf-8?B?QkNRa3ZwenJpaXZRK3d4WTg2TjBSWnU5WGY0dXVBdVlEQUk0ZGtITXA2NmFX?=
 =?utf-8?B?QkpaZ1FQRDUycXptOGsxWTdDaUptVlh2aDhQWGFFSElHalJVeEtoWjNYcXFv?=
 =?utf-8?B?QVlTbVl5azhvcG5RRXMvY1NJdUo5UjBxMnptVTFFYWtOeElVVFNKWEhQK2gy?=
 =?utf-8?B?a2lyT2dWSmp0WHN0RFEvdVJEZFpRa09jMU5pUUNpREkvcFBmMUNla0huZXBy?=
 =?utf-8?B?UGRhMEZiazA3b0o0M1E3NmU5SkF5VXlOTGVaaXoxTkY4S2xlWnptRGs3ZjBO?=
 =?utf-8?B?ZFBZRGRYckMwU25kTnlDQ283THVDL0Z2V3dFTXBFZmh4aTZUSDFrMnNtRndT?=
 =?utf-8?B?VkxCaW1vRE9VaVlhdlhFSjF5cGFSRjE2bS9OOGx1NnpNcjFlOEFqUkN6TWdG?=
 =?utf-8?B?UkRFK1NUcEdzbVErakdudzQxaE9oNThHMEZKcEdPNkVaUkZwQkZJclJyK1JN?=
 =?utf-8?B?ZHVkaGZBUFpFVkZBNkpYK2lwaEkvZXBGdGhscmFtOWlwdU56dVRiNmd3VW1T?=
 =?utf-8?B?U2t1NHlUSUVYTWlFQU5KaGtodXZBSitBakFuYU1hbG9UYlVjdnh3VTF5K0oy?=
 =?utf-8?B?eEFSQzNGVlo3V1lPckdkUkw5bXVQdkFldVR4UW1idTdGRVlsdkVMWDgybU96?=
 =?utf-8?B?cnFlRnBGaU9MeCttOW5jb1RheFVQd2E0NkhtNkVPVEx1cTJjckc5QkZ6NXM0?=
 =?utf-8?B?UXpzM3JEb2FJaFhnZ1FOLzZjZEVGVi9kTU8wVkdMOTdhRzl0TG1sazlMbVd0?=
 =?utf-8?B?UWxvZ0NXR3hjRXpjWlMrNVRsNk1hTlU1NU55TkFsR1ZCMW1tUjJoWmpZZEJP?=
 =?utf-8?B?TFovRmNzS1FDTGRKNGRzNmVSTjVQM25CYlpzQllxdGFEYklVQTBhb1Npc3Nr?=
 =?utf-8?B?UUhXaENvVlFtMzltZDhCUFlaNmdlc1Zmc1NocGpnTmkvU0pnQlBsNytJaXZ3?=
 =?utf-8?B?eHlQY2hNUVlwdk5DQ1g3aVo3eElNQ0V5OEVPcTRmQ0ZLd3lieW4yRkFLRmdK?=
 =?utf-8?B?T1pTeFpWUFFjc0VzYzVkSEx5VGhPaVZQcHdBeDVDTWhna211REZ3RUYwQ2F0?=
 =?utf-8?B?OUUya3l5bWw1cE8rYVRvbDhYRGNmaTZKTXRpeTl2SFBkcTk0REFBWTJENkky?=
 =?utf-8?B?MTlmaEhOVGI1YmlEWk9BOGo5MXVZd3p6dkhGWHZsejNXM3o5R3d5cFBlTGtu?=
 =?utf-8?B?M1NCdm16NTVBeTlIakl6U0paZG1MUU51dkZlZGx0Y0FEa2Z2Q0Q2dE52THdh?=
 =?utf-8?B?MDNOQXFCRzFQaGRCYzF4Tm82ZGZBazgvalZzTG1VM0I1TDdpNUJ5V3ltb3Zt?=
 =?utf-8?B?YUFqd2FYcDk5TXd1bURYb2lsN1JkQUxnSkIwTERBY0huNVlSNEpDY08rZEc0?=
 =?utf-8?B?NVFrTU02RlcxSG1OWjgvS1FPKzh3UW4vakwxOWJ6Smt0Y1FhQmlDK0N0MmVV?=
 =?utf-8?B?T2ttYndXOHJaQnBzV1E2QXBnZEU4akliVGhRc3FxbVppbTdhWnN4MEF5WThz?=
 =?utf-8?B?ZFhiYUVlTTBzVnJsclZ0YmQ5dUx1cXR4WDA2Q3dkOGNKYXZFa0FQemNEb0lw?=
 =?utf-8?B?dHVmLzQxd1NhTm5MZkFDUVI2L2FSV09WL1dzd2FOMHVpaHpGeUR6Y2xOZ24z?=
 =?utf-8?B?Y2l0R2JWTGFnSEkyc3ZFc1pBVWJTaTJabVdiMW9xTURSOHlLNHkvV2VZd0RV?=
 =?utf-8?B?VlJNMjhHaTBidGJiZ21XejVaYjdWeWRQbWhkMzliT1RPMGxib0Nhb0ZpN1NX?=
 =?utf-8?B?T1MyYzVlSDJ6S1JZSEJMZjJ5YUtUaCtaZE4xRnR3OGxRRzFhdW5CdCtLUHVR?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4305f89e-dddb-4e24-4fef-08ddf5e1574b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 11:57:13.9365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m5j///YAqhXEUr63uSYtIsEiwOt8Jeu8GFrMsg3skSfWGQadnO+FGDmUOQpBJapxLJyDCVEYRwJ9GX9xnHbTdWkyGj9yJQWFOxUC9GkP6B0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8783
X-OriginatorOrg: intel.com

On Sat, Sep 13, 2025 at 12:24:55PM +0800, Herbert Xu wrote:
> Returning values through arguments is confusing and that has
> upset the compiler with the recent change to memdup_user:
> 
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:308:26: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
>   308 |                  ctl_data->device_id);
>       |                          ^~
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:294:39: note: ‘ctl_data’ was declared here
>   294 |         struct adf_user_cfg_ctl_data *ctl_data;
>       |                                       ^~~~~~~~
> In function ‘adf_ctl_ioctl_dev_stop’,
>     inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:386:9:
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:273:48: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
>   273 |         ret = adf_ctl_is_device_in_use(ctl_data->device_id);
>       |                                        ~~~~~~~~^~~~~~~~~~~
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:261:39: note: ‘ctl_data’ was declared here
>   261 |         struct adf_user_cfg_ctl_data *ctl_data;
>       |                                       ^~~~~~~~
> In function ‘adf_ctl_ioctl_dev_config’,
>     inlined from ‘adf_ctl_ioctl’ at ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:382:9:
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:192:54: warning: ‘ctl_data’ may be used uninitialized [-Wmaybe-uninitialized]
>   192 |         accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
>       |                                              ~~~~~~~~^~~~~~~~~~~
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c: In function ‘adf_ctl_ioctl’:
> ../drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c:185:39: note: ‘ctl_data’ was declared here
>   185 |         struct adf_user_cfg_ctl_data *ctl_data;
>       |                                       ^~~~~~~~
I don't see this warning with W=1 on gcc 15.2.1,
    make M=drivers/crypto/intel/qat W=1 -j
What version is reporting this warning?

> 
> Fix this by returning the pointer directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

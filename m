Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEFA2DECBD;
	Tue, 25 Nov 2025 20:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103146; cv=fail; b=EfhvXtkVYeAhn1c7A9UfP0RlmG9eVbrYgLzYaNX/RmLvn5tBgi4DIkzwwzxNce+V+2isFhulKHyG4LvXASblLLZ8ecDlZPRgq8iivaS+AqAMBt2vN992rKunyHsxN3lVMULbgtI12YpSg+GTu3oL9kKFMjxWuDSu1MtdX7uoawk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103146; c=relaxed/simple;
	bh=EYSxP5p9ffcypHR2mSzDaALfSqKNDXnpaYtEEJSQ2aQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=Le1G17AdGX+JRQdllfMVzNq0Wqjd39miTbfVorWLEKojy6RzGW+RHhFhhdO+edbDM5foj8qLy/bGTzSwUEJ454xr+8jqVFMgCBuL5tGrINqyyleJmN5amYJDyohli0pu/5QLrVgUyD4FTNZqwIlfYETn4QTrXZeXG9pij4Mr7QM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JQdFOlaL; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JQdFOlaL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764103143; x=1795639143;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=EYSxP5p9ffcypHR2mSzDaALfSqKNDXnpaYtEEJSQ2aQ=;
  b=JQdFOlaLU8x497ye3gryrIaSJI9Y0zBBkypubghZSYNtSwMKoDqo1Tzx
   Q/oCPXQsxufDDTEMKsC39Mvx7UFfpQy7Rja6DeUttw48UmHYvQDuycRWo
   rvlRoNe4HIovvmzRzeoThkjOaca8GjopaMvDRDfe/MrIfVzVq+Y9Gk7gs
   qZOWA6a/Qv1+6RfSwKV0uCGfUkqS906rxHNhtKfrxvb+gfLnI77y0t036
   8IzXNqV+aHGo9VytFZXiBvBf5snbnugNlO+5UTR/LyZWDajnXXFRRC5U6
   4/B4zqTIIsQI/3JXSBTUItX/A0kOwz0tvEQ+2uYl8d0u9rgPwU1Iz64B7
   g==;
X-CSE-ConnectionGUID: BPArcO1yRZ2XkimR9HDI3A==
X-CSE-MsgGUID: gopbQUA8RiiOElLz0si44Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="76455123"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="76455123"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 12:39:02 -0800
X-CSE-ConnectionGUID: kPK1ffzdRlyuSh+zX2rzqQ==
X-CSE-MsgGUID: XO/apZObTeG/Cw2R+Us2zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="197059868"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 12:39:01 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 12:39:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 12:39:01 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 12:39:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WrGGKCAumeGCN/cTiRWPu8k06ETB0OknTphVAtC2iXUl6d3Bwzopm0SGogrG0Onfc+WBVAsFD2N+/41yROhe25Z0smxWkgzuheOASP93rWow09Y86Vl9xHKz4IUN+XEAAyf735+wsg0Zwy7XpgK6JWuQfu8sCjY/x0W1VJ/Ih+Sj/Z6VgJEnqRtZS5/TVqr6WR1CE8FjKPDD0D9vN3P/fkjI4DouFMY0rjMNq+EqOl+m3+zcRZCq51lW8iQfkHBje3iRlIIxrStG35/zJeJBrNfx53DwB4WI898s+4Osu8KdLrrSy6gFDNgXtz3yu7Mtfcel/g8spi77koRek3sWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmlP6j3dgkJOyzfOWAsVdvqbFhSPVzq6GPB9L5TsIRk=;
 b=On8D5QmQgwGYt4MNIuz9SMjR9xNdpdpywgslDKVqeEWv9eOHBpGHZzULCKEZG0Gi9lVvLEPkf/dUaUu9ikcaVSLVk08GWa1jNZR7h8vi2g1gaqD2ug0YArLAA3CBjt0KDVSSvQV5ydC4PCEZ4U5/A/MOB+IF5BOR1AJuTN/Iq/1V6AtlOCmOpiWuKsJ5I+zxPiTVGtoFUIZwwwwjlUl7Z1H1ZQH1RxO/BAvd2r9b3CgCPlL6ATUDIaEDBIdEQlEeJ2VkH+TVlJ2aaT03wmMVTnZU8+4tXi1qJOOezNvDB71sZhoVS4iLfppqmG37mONVQAvYVPfXZ1JVxngAVKy0vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB8231.namprd11.prod.outlook.com (2603:10b6:8:15c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Tue, 25 Nov
 2025 20:38:58 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 20:38:58 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 25 Nov 2025 12:38:56 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips
	<kim.phillips@amd.com>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan
	<gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Amit Shah
	<amit.shah@amd.com>, Peter Gonda <pgonda@google.com>,
	<iommu@lists.linux.dev>, Alexey Kardashevskiy <aik@amd.com>
Message-ID: <692613e0e0680_1981100d3@dwillia2-mobl4.notmuch>
In-Reply-To: <20251121080629.444992-1-aik@amd.com>
References: <20251121080629.444992-1-aik@amd.com>
Subject: Re: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:a03:100::25) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB8231:EE_
X-MS-Office365-Filtering-Correlation-Id: 629df09c-79b3-496e-e931-08de2c62a860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cjlobmtzSFlQSFZ3Um5PTEFHWWlTUHNxaXZMK2JDODN2ZnFMY2hMY1F5a082?=
 =?utf-8?B?RzFCV0RUZ3hZRDR2SUhlNG04ZGlGT1JDeUs4Ykt3WmxWUDRSMlU2Q2ZGYmRp?=
 =?utf-8?B?T0t0bk1sbXZKSnR2YkcyVGdvTEV2bTB1cllQQ3pCZk1nd29nZjZFRHhLSmp2?=
 =?utf-8?B?UlNGS0JwbCtXVjU2d2xITXdvNVBIUG05VkEzd3RBN05jbmJWWnkyZHMxMDYv?=
 =?utf-8?B?OWtBL0V5SGRyU1pKME1EK241MmxkbjMyYWRpaDI2ZmxyMUNpeUlBWlN6b3Bj?=
 =?utf-8?B?V0VjRlVxckVJNlMvNEE0UHVTbmRsdG5wSjcyVThqTUdsdUlObURDS3dwSnVR?=
 =?utf-8?B?RjlTN1V6ekswT0FwN1Q2ZXhGaFVIWHE3WXVEUEJCdEw3Wmt5OWRIdDNQTWlO?=
 =?utf-8?B?Ny9wNVFxM3FVRitiSEt3b0dOODBNZEhNQmlzeFZqY0RNVWQySFlwSXhUWFZz?=
 =?utf-8?B?eksvM1dBdElUWmRtekNnaWlWZUxLTHZmeGlQeXNkWFF5NllPUWZvbXZ2N1NX?=
 =?utf-8?B?bHQ0SzY3YTZLaXJsVGt1RVlpM3VwVGt0UCtBeFF5SGtnZ2RkWGlrSGpCbXB5?=
 =?utf-8?B?dEhXY2ZEdjFWZmozVE5COTlXV24yd2J6WnVaZ1FWNkY2enlKU1FJd3NkMzJ5?=
 =?utf-8?B?MXdjU3BtVXQxc2Y4ak1KbFBPUmRSU3VNczNaaFp2UVF1NVltcXRDYVpSbXV4?=
 =?utf-8?B?ajNHNnBzc2xoZ2REWEYyREtKSWhWdUlnaHRMQWUzSFduN3QwbGZDcXB1QkZq?=
 =?utf-8?B?MlRXMEtVaHhPMVZuWXRTczRTRWF6YlhlYjQ0Si9rNzJOUHBNUVkrRUx5djRq?=
 =?utf-8?B?RWdLK0JhSGgzbFpsVHRWaml6emtaYkRMT0FBcC81MGNCamg1dXVHWFdkU2h2?=
 =?utf-8?B?SW16aUtMTzhzQ2JuOGU3V0JLNllSL29MTVpHQVY3YXN4QjZBSHNWS1dYVDR1?=
 =?utf-8?B?TEozTVBVZUpPeTVuUHp2dk1lWEFRaVNtQ0RUbkRTZ0xCTVJJdzBZelh0MXVT?=
 =?utf-8?B?WjA1YWRvYXBqVnpBcnNlVmVnNlFranhtZXZrc3FoNHoxR3dBYVJnZ3pDdmZr?=
 =?utf-8?B?ekVRKzdHWEdkRWg4QzYrNlZRRDNGaDFzRzN1WHNDYVdFTzFUOVJoMks5Nldv?=
 =?utf-8?B?dWFZdHhXeDcvYWwwWFFyaVNOcDRCYTA4SkRrQ0JwbkhKOWpSSnZlOVJwWFNU?=
 =?utf-8?B?WCs0eXVaWWRBclZ0V0cxemNvanJhd3F3SS8zaFA1WVdXdEpTSVNBMEQrRTNB?=
 =?utf-8?B?Wjg2WTZVS3NKd3hGdVJpUlFrTFFGeTB4dWcvVG1rdW1ZTHkxY2pJMHBRMUho?=
 =?utf-8?B?cnhNUnVaKy9YNUFGbXhoQmVsOXcvU0p4UlJGWHFuVjJCclp2cEt0VXZEdmRF?=
 =?utf-8?B?MXNzWjZwclRKR3lieXRZM25aV0phMnA1MXZtTC9SWmZTR0I1Qyt5dEdRSlJP?=
 =?utf-8?B?Ni9VN01ZcXA0aTNPdnlWQlFRRDlsa3Z0Z0gvK3BoSVJEMFd6K29NcXEzeGRh?=
 =?utf-8?B?RXIybis2T0NoYjFsa1ZEZ3BNclVtclRNQjlXR2VOZ1pqcUdWQjdWZ0NXc0ls?=
 =?utf-8?B?a3V4TnVydmlJWjdmYVlwODAySXhtQnRXcUo0R011R25SV09EalBYSmFMWmlP?=
 =?utf-8?B?MzVLYXlob1ZqM2xOL1k3ZGhhM0pZZlhnNUhKV001OHlNNjhJSUdVa3JXb3BM?=
 =?utf-8?B?OVVzbHUzSXU2dUlJck5vck5mbUVnYjhBNlNyb3pxUmlENjhCOGJLbXByV29E?=
 =?utf-8?B?VFdrNG9uN2FZWDF5c2U1WGxHUzRJRzlvWmN3QStVYjI1eWxqSDdQNlFlMkMv?=
 =?utf-8?B?RUlLK3hTaHFobXp0U0xPMXN2bUkydHJvU0tOa29FTEJwdHFTMHlLNGhybTRq?=
 =?utf-8?B?MEg4c2dZMitQZzVmaVhUYUVZVzFadXFyYlhIaHEwQXpEYlpGQUl6aHRFa0dQ?=
 =?utf-8?B?MU1vNW5EdmM2R1FvSlorOXRzdVBQTjM1d2c0a2dpOXJFM3hYdmo5YTRIaGx5?=
 =?utf-8?B?MU0yZ1FLZE53PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eS9WNmoxd3lWVUNaRjA4Y2RPaWJaS013OWFiQXRwSTJwNlNFU3FTNnNBZDV6?=
 =?utf-8?B?K29uT3VtcVVHazBmc1ZWM2haUDZUY3VKMUVFK1Y5ZTc5dHhZZ1l2ZGxralRC?=
 =?utf-8?B?RU80T1psVzgvelAzR0NKR0xwLzZzV0o0aEdkUTFJT3IxdkF1SzdDZ3N4Q2lF?=
 =?utf-8?B?endQOGRDd0t0NlM4M09hMVdFc0pNKzdrQ1NaYVBSaXpQekE2bmdpNTFET1F0?=
 =?utf-8?B?cUFHMzB2c1FXV0Y1c3k5WFlVWDB3TnVwc3pZTmFDcnpuVWNFcDBOcktmcXBz?=
 =?utf-8?B?SlVMRG5KalVQb1VId3VrMitwdFNjYm10WkJKV1NYLzJSSUtjTFRpcWpWc0NG?=
 =?utf-8?B?SkM0RjUxSXVpVmtjWXFCZ01XaWlrN2NNZE5WQnF0UkJoQ25pV3RhRXJDVnI1?=
 =?utf-8?B?bkhBMlJTYjVvZTFycmQ0MlBBZUdPY1NyeFU5L2JjbUlwb1FyaitkR2ZEcG9r?=
 =?utf-8?B?LzRud3p3VlVjSjB5STdaUEpIQmhQSkJvTUl4Rkt4dm5nbFI1ek96UmRVNFky?=
 =?utf-8?B?alp0eHgvekZLYitrVEMzdFNpSlRCdW1qUnpkSzRoSXB6WG10dEg4MDRoVVJk?=
 =?utf-8?B?ZGdFN3VqWkg3dDhLKytaZWY3YU42MnNzc3hwSHpNMXdHalIvYU8xcXpjUDVr?=
 =?utf-8?B?bHNPeWR3R1BVelZZYTNuNjZ5NjJTMnphdGFqT2dBSEZSNjQ2bG9ycVdObFZh?=
 =?utf-8?B?NDVZbWU4L29lbU1KdE1Da1p0bE56VC9kaWlWMVNhWVVMQ2Ryays0eURkdDIv?=
 =?utf-8?B?WE5DY2drUDA1SkE1c1NKeG9lbjY2cG9YdVlMcktwcENGSkxqU2N5V3oxWVRl?=
 =?utf-8?B?WFU2U3ZaQ2E0TElDRXE2OVFZR0RmaWtxam0rd3BxZ2VwbzloUTNKT09jVndw?=
 =?utf-8?B?aTE0KzBsejZCaGZGV1Mxc0Z4YkRhS056K2hSTERUbHNFTGNFb25WYUh3WEsw?=
 =?utf-8?B?WHc2Q09aZHBuNk9VUEp3aFBpNmxLMFBBdlJRMThHSElLZTFyMWpGeUtHZWVY?=
 =?utf-8?B?T0FnWjFFVkRUZXVWUnl1WHJjYi9CSmNGVHFyMDRNMHNtKzBSMlZNRkRDN2hn?=
 =?utf-8?B?NmpNMEF2elZaVGVHVkVmMStsOTRDbzJIZnl5RUJWQmlaTzMzeURMdFdnZXJU?=
 =?utf-8?B?WlhiTHlSZ3ZKTHlFS294Y3ZrVm9mM3RYbEJidkVvWWdxZFJrY3E1NWNzd3N5?=
 =?utf-8?B?blZ1N2Y0ME9rYUNpZS9wd21DMnVjc01LVGd1ZGFlblNSS0FsbFRheE4rVTdM?=
 =?utf-8?B?cGRTSk1wM29EN2c2OW5uVEpXa3MxU0tIbldEemZwdVgwd3l5aEYwRnV1Q01T?=
 =?utf-8?B?ZDNkN1FUQ1VNV2pKWTlTWkZiVjhxWjhIeTZxWG9yVEdGSzE2NFFwN2tGU2VN?=
 =?utf-8?B?c2ovUHMraXcwSkpLckV1VE03NFF4MGpWRkZtNFBrUFpydXVKY3gvMFY3a0Jx?=
 =?utf-8?B?ZE5oSUJKaWJSVDVpYTFwNzJXTXByVVlnZEhVa2R3a0ZhTGZaVi84MjRyYjdm?=
 =?utf-8?B?RGp4RjlLdHBNNHV1VTJZNnVaSkU5cFF3cUsvVm5CMUF5T2RsNTN1M0pidSto?=
 =?utf-8?B?cjVwN0ptbTJjWm1WUk5odk1jNDVMNXM3UkxsRklpVkhCMjFwRnk3aFpqVHRh?=
 =?utf-8?B?VzJ4L0ZUQkllY2tOQTlvajVpOXYvM0JCcjQ1Y1NmMEZsY2xwblNZaDdpRTFZ?=
 =?utf-8?B?ekt6UjhVSVR0a1Q1bzZ4b0ZFdnZCVTQ4TTZENmV3d1VlTVY5amVvUDBYOGRx?=
 =?utf-8?B?VWtXeWIzQmkyUjBxWVZhR3Q2UjE0OG5UZnJYcGpESUJRSndCVExNdk1SKzg1?=
 =?utf-8?B?SDB1R2pGN1BQckZNRGdVa3lzN01RWHRNQXRkdmFuWFBWZVo2dmVLRFBETmp6?=
 =?utf-8?B?QlZseXRUaVFkKzM4clYwTTFLQVprRktodDA3R0dpL0FZTTFSNm9VRmNnaTln?=
 =?utf-8?B?L2VTbzVKYjdPVVowdVREVENkaXRXMUY0ejg2VERQWmUySDRabDJya1oyZWdC?=
 =?utf-8?B?am9jOElBNDVTYi9scVZQSEd6bjVzcUZKUWRRY0hrajAyVDJnRW1uWkVoNnAx?=
 =?utf-8?B?d25XNWpxV3kyeFAvbmM5cG9jUDBMT0Q4cFZNU3VaSHlxTUY4Y1gyVEFyMThC?=
 =?utf-8?B?Nkpab0hnSGRTRjR3Q1grbThsV2hBWXhwS1E3bnNIR1dOTVJhK2JuRk5sM3VC?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 629df09c-79b3-496e-e931-08de2c62a860
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 20:38:58.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dk8ikqQKQ9uohcHXdM+BxxEDJniWV6+ERnw7crms9mqr5eTFv7rhZlJrlFMevpgnIxgSFr1/Gue+ZRw25y3equBJQ9oQpxqK4O63ph7WVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8231
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> Here are some patches to begin enabling SEV-TIO on AMD.
> 
> SEV-TIO allows guests to establish trust in a device that supports TEE
> Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
> then interact with the device via private memory.
> 
> In order to streamline upstreaming process, a common TSM infrastructure
> is being developed in collaboration with Intel+ARM+RiscV. There is
> Documentation/driver-api/pci/tsm.rst with proposed phases:
> 1. IDE: encrypt PCI, host only
> 2. TDISP: lock + accept flow, host and guest, interface report
> 3. Enable secure MMIO + DMA: IOMMUFD, KVM changes
> 4. Device attestation: certificates, measurements
> 
> This is phase1 == IDE only.
> 
> SEV TIO spec:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf
> 
> Acronyms:
> TEE - Trusted Execution Environments, a concept of managing trust
> between the host and devices
> TSM - TEE Security Manager (TSM), an entity which ensures security on
> the host
> PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM
> on AMD.
> SEV TIO - the TIO protocol implemented by the PSP and used by the host
> GHCB - guest/host communication block - a protocol for guest-to-host
> communication via a shared page
> TDISP - TEE Device Interface Security Protocol (PCIe).
> 
> 
> Flow:
> - Boot host OS, load CCP which registers itself as a TSM
> - PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
>   TDISP-capable devices
> - Enable IDE via "echo tsm0 >
>     /sys/bus/pci/devices/0000:e1:00.0/tsm/connect"
> - observe "secure" in stream states in "lspci" for the rootport and endpoint
> 
> 
> This is pushed out to
> https://github.com/AMDESE/linux-kvm/commits/tsm-staging
> 
> The full "WIP" trees and configs are here:
> https://github.com/AMDESE/AMDSEV/blob/tsm/stable-commits
> 
> 
> The previous conversation is here:
> https://lore.kernel.org/r/20251111063819.4098701-1-aik@amd.com
> https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com
> 
> This is based on sha1
> f7ae6d4ec652 Dan Williams "PCI/TSM: Add 'dsm' and 'bound' attributes for dependent functions".
> 
> Please comment. Thanks.

This looks ok to me. If the AMD IOMMU and CCP maintainers can give it an
ack I can queue this for v6.19, but let me know if the timing is too
tight and this needs to circle around for v6.20.

Note that if this is deferred then the PCI/TSM core, that has been
soaking in linux-next [1], will also be deferred as at least one
consumer needs to go in with the core infrastructure. It is already the
case that TEE I/O for CCA and TDX have dependencies that will not
resolve in time for v6.19 merge.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=next

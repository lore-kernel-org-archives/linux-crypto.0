Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798F32C31D;
	Tue, 27 Jan 2026 06:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769497199; cv=fail; b=LHpt6eKTlujQmtbF5hKu+VOGJXdBA0VA/wldxWX2F+t5qSCqGyAY2skqy2bJTGPK5+d1rFc2Bb9U8r9sQmrbGUb+xWd65uxfFUMcc/6boZMjIIBPVOBV6kqMQdRGBE4gOgcmRECHhKebOAFE5fo6XSDu3fq+FULfRODvqa45Qs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769497199; c=relaxed/simple;
	bh=7l1TVsGiYz17M1ETfZ18YP48IPSvzZg4MZQqEFs19Jg=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=tjWFZVLsWl0qfVSscVSTj1NoGN9/w8iv+ytoBmWvJm4r/ZhhA0V9BVRM4d/EISyINztKpBUQLcN5J6B3x7Iu1IrdxgLX10/omdLhGHzunkkpLBS9eG6BBRX7rVKFPHXwbHoWlqliujuGIBZXsKyZtYqJp3Jk8muoCroSZXVrjwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9jy1K/4; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9jy1K/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769497198; x=1801033198;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=7l1TVsGiYz17M1ETfZ18YP48IPSvzZg4MZQqEFs19Jg=;
  b=X9jy1K/49tvAdh7kV1x31EzmekWwuiAQFdWSJaS63Os4L/rUGNM98RJT
   Gi/DkSFnvzFF3DfE7mM9JazBCMFDElwqJk9l1c5Pd6ygIYy14zatJQgdg
   KJdLUa9e8/Np4HzAENghJrUW9AQlqzTjlueP/KmWsiweeXJc7hAOCQFn3
   zb7VLOfMKBbi0ioOVaagsTSppE9ydpSMRCIlLf2iUJX/nTw8tqt5sollL
   zpJHcgPELf9fmvJ7p2ufW4rfATto45YxsVRpH3ALvvz45uHUO/qBAAcgT
   RpYDcUnPmKMgz83VI/k5JfaO/hK8i0ZFKzPMZ1sDzsEK7whpNQGs8iHWw
   g==;
X-CSE-ConnectionGUID: xyspXo6GSrmQxRw2mhOR8g==
X-CSE-MsgGUID: Df+/lietQHaMbd9lvAXF4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="81405429"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="81405429"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:59:57 -0800
X-CSE-ConnectionGUID: lnVSpAt7RyGUrSFkMWUYQw==
X-CSE-MsgGUID: u5ujUaq7SbiuBMLvVGBrRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207915595"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 22:59:57 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:59:56 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 22:59:56 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 22:59:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qz0YSocalpmdwZ4a3yssfQNnMtJJ5d+Ii8h6ebPzOq03n/2pHK0eAoM7ECzTSv6suNgiKXcRJJnUtsdzIu+kvb8hllBSmS1fzU8l6JyVEtwkgwWZMQd2vdcqrPEhXGjNemXwjqMmbtM0mySXNFEYLnqdfreg9S+ijkUP2X32tOQmqh3j7Cmrd17A4TFf7SSivGkImrCZMdovt69Bo1dJeO8XkqYpPymczKpFSGJmVHJqrq8G6x5mObe/8Z9LUanR+DxpOfVK8ZPnulUhA1ze5LttPHiUIm9m9dfz0aKoqTu47PPvkEx+wSvZ/5+m/VJ+U4gFJhYSeTMLNrE/tvhTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKyHaaXLxPNbauyqc0bJYNQ7f1NhDxVtsaaLhHcGu9Y=;
 b=ULzcLQ14x0yz4vWW/ZxGOiIOog2wEjBNuK93l9m+mXNeod+VRY7c/oVGe5HEnUiT69jRS9o2RHfv8x2ODtaTRO3klfyQXP7CCjAX0KuqlfV1LBGFN56xxPVZc5HB+PkAH1a1MnR9JjEclzfhT7Gyp8klj5bEw4rpQbWQtI9ikrk/ybB70ootqMydn8g9/QuvvAgVpgsOM5HYgtyjgmS2A5EgnDQL/xoiZ1c6kNIQeQ6SbsUu9+aSS6S7gMdgdx7UrK4D+EiOkvj9tSD4IY2sj/8TmxcKatiKLeb5O22ogYzURs2066MqToh0PYZ4m0keIopouBJNNCaIkEj5onJ09A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by DS4PPFA08475C7D.namprd11.prod.outlook.com (2603:10b6:f:fc02::3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 06:59:54 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::b2e3:da3f:6ad8:e9a5]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::b2e3:da3f:6ad8:e9a5%2]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 06:59:54 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 26 Jan 2026 22:59:52 -0800
To: Alexey Kardashevskiy <aik@amd.com>, <dan.j.williams@intel.com>,
	<linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Message-ID: <6978626886a50_1d33100c1@dwillia2-mobl4.notmuch>
In-Reply-To: <196ef0d2-93ac-4872-831b-e803e02b5d95@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
 <20260123053057.1350569-3-aik@amd.com>
 <6973fd402a74a_309510049@dwillia2-mobl4.notmuch>
 <196ef0d2-93ac-4872-831b-e803e02b5d95@amd.com>
Subject: Re: [PATCH kernel 2/2] crypto/ccp: Allow multiple streams on the same
 root bridge
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::31) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|DS4PPFA08475C7D:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb6adea-fa35-40d6-422a-08de5d71ac98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NjlaR3kyaUdaV2VTb0V4YVVIa1BmZkcweUJIYm1OS3NoVjA3OVBISDdPb21I?=
 =?utf-8?B?bmYram5hVWFOSlAzYUhXRTRuNDQxYXpaR0t1SklhZUhaYzJvMjBoZzhRdkNp?=
 =?utf-8?B?bTVidlMzWi9IYklqNWlaYmphdnZpNE1UeExHV0IwQVE1Zm5TNWd1Y1ZJbkdu?=
 =?utf-8?B?VVp4SkVBTStKVlR1OXBsdGlXVVJrTjRjVFgvbWFsMndxa0t1M2lvMXlDQ1Z3?=
 =?utf-8?B?L3owWW1EMzF1d0pPS2pPZ0dyU2JiUUZpSSsxaUplR1d1Y2dBdERBOHBmSFdo?=
 =?utf-8?B?UkM0aGJtc0NMWHY3VU1TbnFneU5HWUZkQjR1L08zUlNRTUQrQklRRWE4VTlO?=
 =?utf-8?B?bnRTZndIbzd4TFdpL1QzbWRsaGxpNzVMNDJXbzlZRDIxYitrUEloRW5BWFNv?=
 =?utf-8?B?dWM2eTFUSStBSE1BN1FucThlSUJkb2RFZzNQa1ZYTmZqSXEwd2E3ekd1M0dY?=
 =?utf-8?B?dHoyS2FVTkJZd3RUTnozeVdlN210MHpyZWZvS0R0d0h3dUNPYmE3MzR0WXhq?=
 =?utf-8?B?UjZiSkZsTU1rNkhJdTRuTEtQZTJXdTBLQmlaVG1hL2JUY1drVTdWYVlzNm5R?=
 =?utf-8?B?T04rbkJsTjRQRDQrdFVSbVhxS3B2VGVTUnBhK3VBMFd3S0hyUHgvUUxlYldH?=
 =?utf-8?B?aU1SeWtVNTBHMjBNTVlXcXBGZ1hjbld6ZEhsSXp2dG9JZXhyalNialk0MEd1?=
 =?utf-8?B?MlBNblMxNDV5RCtUU3BIWmF6Z25ocWIrM3RkQXJkc0VDdnhZbkNaN2NlZlk0?=
 =?utf-8?B?azZ2OHEzLzM2SmlrOXhrdXpPVWlCalFieFFPRUlkNFlMTEhyK3AzR0RocHRF?=
 =?utf-8?B?OGxBTmd2cFNTeDA1WFlLR3U2YVltd21zUm1SbG9GY054SXQ1MGtWVVY5aFNm?=
 =?utf-8?B?alJPVlo0N09BUThwclozNHIzakI0d3dRWTk2bWJUSFh5SStBYlkrd3JQR0I5?=
 =?utf-8?B?RnJBblB0VVY0QmdZL0E0U1VOanBzQi96dVppenpOY3loaUZBWlhtZjN2aThv?=
 =?utf-8?B?UDZZLzNYK3NwQ1YvdDlmaWw2OGRaQUpqQXRndVFheHd4MzFGOXQ3cElvWXNz?=
 =?utf-8?B?ZHN0cVFBVmhxT2w3SXE4Wk11RmY1T0lZeHRpRGRXdTVvK1NpZ2VRL2crRlhP?=
 =?utf-8?B?TkRLN0xQbEtOT1htVFNvNUhYWjN5OHQzV3FnK0lPRnZDUENWRHhYZEpPenpa?=
 =?utf-8?B?S1I3U2MreVRGMWdMenhocXZXZVBGeVp5NWpJamFJUERUK3JHWVR6ZXhiUHdF?=
 =?utf-8?B?ekJRS2lYV21VTkp0UzQ1WE9zYkJNYjFRNmRKdUwraHZPZk5XaVd2WFFEZTk4?=
 =?utf-8?B?STJ5R2RHTlFwQzhoZWZkVFlMY2dUTVlQcmRlVkZEVDJBZjU4aUU0REdDcC9t?=
 =?utf-8?B?M25TMXlvVGo1cW01eFk2dWtuVkU0blB5UEtNdzZKMjlSaldneFVMRDB2Zjdj?=
 =?utf-8?B?RmU5aHhYSU5VMi9lYjFudER5L2NpYzRjTGFlRDQ1dzlrcitlS1B4bGpxajY0?=
 =?utf-8?B?SGZ5Ty85R01IZkhQYk9RRDczWFRGbmpHSXNQbCtMdyt6ejA0cjdOZHppaGgz?=
 =?utf-8?B?cmpMQTJrbTIwMVQxVVJubDBzMTFTNjVXdDJmZmdaN1N2eUxlY3l4S2VyNStF?=
 =?utf-8?B?MnJRWEt6SnZuL1hPZDVkMzF6aktRLzg1cXBHNlMyeUhaNUR4bHEvT1pFc3BD?=
 =?utf-8?B?MnNYZ1pFNElIMGR4dC8rZjRrdVZsMWp6K0Q0MitMTURHOFcySUt3R3lFT3ZY?=
 =?utf-8?B?OVk4MkxXS0lsMk1vQW1NNVdBeTE1dEFjcTdKU1RGbm82OUpYREJvZFRiMU9N?=
 =?utf-8?B?Q2IxcEQwdjEyankwbTNpTUlUTEhkd3BNdHFBNHZOWjJKRFd5SXdhZGtKRkhJ?=
 =?utf-8?B?d2ljWHpJTk1wMFpVajIyTTQ1emgwU2dRcEJTWm1kbnd1cElHVTNzdmtMRVpL?=
 =?utf-8?B?N24zSHFEN3FYbDlNWUZpNmR0c3lZYmtWajlpWE54WmZnSmdTa0tRZnQya01J?=
 =?utf-8?B?MXord2RmWWZQMXpDVzZCWmg0aWZCMDdqOW83YnYyUWdvRXVnamF2ek16L0hQ?=
 =?utf-8?B?TXRORDlJNGI3Y3ZRMlZEU2Z0enhRMUpvSFNnTkJzeHlKL0FVV0xTQmFObEdD?=
 =?utf-8?Q?38ao=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUlMSC9Db2Y2THFpTktCdTFnWG1TcVpvUFQ0TXpPZ3NvYlVhUHZPNlRLZzdy?=
 =?utf-8?B?QVoxQlcvemIweTVlMUhmMWxha0NYdXd5R1ZvaUV2STYya2thRlg3MVIyK0RW?=
 =?utf-8?B?Z3pHQURMTkxlSGdIeXlKR0NpR2VIN1k0dDJXUnM0MjdYaldHYnZadnlCVHln?=
 =?utf-8?B?NjJneFlZOXUrUnduK2hZSWRUM29qNURYcCs1Tk9qOHEyZDdjK2NtVDBka1lo?=
 =?utf-8?B?ejU1anVNSi9peEtBai9KekZTR3lKT1dFOUdES0haT2FKOEhzbXNXcU81M2pP?=
 =?utf-8?B?dVpSdFhFZzNvSXJoWjZyVkprRzE4Njc3amNzcDlBUU40UnAyOXdZQ0diTEJ3?=
 =?utf-8?B?MUl3NEhHOTEraG1FTWdOWUtURTFtOUlqMFNkT3NTU0tHWTVvSWpFZGNuUDdO?=
 =?utf-8?B?NnViQmJJQVh5b0xKT1J4d2JJU3FHYVdZVFdJZ0dFUVkxZ0w1TU9aYzU3Z0p4?=
 =?utf-8?B?b2FLbjI5NUVCU0R4MmhXd1lNa1RZUnJlamlCOFRieE0yMVJhb2dDU1lmVkM3?=
 =?utf-8?B?MWR2WW5xUnpXRlQ3dEdwcTREUm8yK3g0eWYvNVpHUHZwTXNWMjhwMTBzaVpJ?=
 =?utf-8?B?ejBTdytZL1A1MlZMZGg1T2NkakxJaHlaWTBpakRydWNQdkZqRzU3YXR6VmJI?=
 =?utf-8?B?RVJqUXE4aTI5dXhlNGN3emJDTzVlclJVeUxrSmVjQktVVE82NVQvd1cvZG1Y?=
 =?utf-8?B?bFp2SHRvVnEraGhtbUo2YnpBNVpYN1NiVmN3cUN6VmdkdTQxZjlxRG41Q0xy?=
 =?utf-8?B?NlVsNVozNmU3a3FhZTFWVW0wNjA3alp6NzJxYXJ5bS9tZU9OaEdsN3NEWU4x?=
 =?utf-8?B?YkpJMWJkUnFlbEYvUUgzNEFKMU5jOXJqNExVRklmZllPTng5Y0FCejlwTmpX?=
 =?utf-8?B?MnVDU3dWa2k5YnZxNk9YSUxJdk1OT1ZiOUhxVHpIWU1EcjJnbExxaFlWVU8r?=
 =?utf-8?B?Q1F6MWNUNzJGZ2hsTzU5Yk9tN2swdGdQeW8vbndYUFpGYVZQd3hhWmttUG1P?=
 =?utf-8?B?b0JlTk1jclQ3WkFSMmFiMWpldVZWL2Y5YTJlb3ZPTFFidEdVb0NjK3ZLaHRw?=
 =?utf-8?B?RGQ5RUVxMzFvOUJQNnhteWxqSDAxRTEwVzMvbnFsZTFmUkJNc0ZmS3F4WEJN?=
 =?utf-8?B?ODNhVlhHNUMwRDR5SnQ2cyttQ0M2ak53Qjc0NWR2YTJWdWtsY2c4cXR0cGV4?=
 =?utf-8?B?RmFuRW9vQXA3M1hHREFOSzBPaW1WTWJvUWFwbUlhcDdZUTBKbmp5eEJFd1h5?=
 =?utf-8?B?T1dmMTFGUUd2aUp4VGpoN2ZFWFZ3d1BRT1IwNHNMbFFYakJvNDkxL1FwQzBi?=
 =?utf-8?B?TTQ5ZTY5ZTRWNkJ4cW1uUkU2cVdBZ2ZodmRmMTZxUmMwM3duT2hWd3dTSVZI?=
 =?utf-8?B?bXZZbXBKZGRwSmNMbStaZWRNU0xPb09jc0FtWStwa1VoMDJFQ3FHRGtza1Fs?=
 =?utf-8?B?V1FzZnp6VjRZMDlNRXAxa1JTNjFKeEFHRGtwaCtNeGxKcHdGU21SWjVWbVhi?=
 =?utf-8?B?aTNhQzFqcnY1V01MekJBS1g5WjFPcWNOR0xPM1Q4RzJBd01kS3ZJZVpSTU1B?=
 =?utf-8?B?cXR6UWt1dXZHNTdlUGQ2dkIvdGRHbDVXRGhpc29LUWxjMmtQRW43d2locUFs?=
 =?utf-8?B?UmM0eGh5Q2hiTEFOUHkvTXRxcGI2YUg3VEREUUpRdndkdFlmSlJFWWU4RGEw?=
 =?utf-8?B?Z0d1TmVzNHdCVkdyeFZ6NGNLaTRxeGxNVWFkLzN2OVM0bVB3VjIxOGJkZExm?=
 =?utf-8?B?UG1rZ25iNmlNN2FpMTUwL1I4U2I4aE5hUWdWcFpBenhNcExWbW55aVdvK3c3?=
 =?utf-8?B?ZGd0WXdLOWNEYkhrd29EVU5jTlV5LzhQU0x0RnFqM3NPZUV5Y0Z1OUYzWVpH?=
 =?utf-8?B?MXBrWGd2ZjZzN0s3dXgzMTl0LzRsZWRzcUh0R09oT3c0c3lrd01VQXpQWGlh?=
 =?utf-8?B?M3JjNFNCL09DZW95SnF4VThnZUVZZnppTU9kb1lKVnpNd2dqT0t1bzUraU1U?=
 =?utf-8?B?b2U0SVJlNmE3emltbnpUU0ptT3lUejBXZkJHYk9XMFkrQ1VkNm41QlRtMWFS?=
 =?utf-8?B?STBSUHd1eWQ5cy9vaDFvb1FWdldIUlRid2liV0VaNEhoQk1jZ1FxM0ZCTlFX?=
 =?utf-8?B?OEE1NzA1MVVjSmhpUEZJbWdGL1VKbmUzSUQvQmF2R3p3UTZXV0xOVkdTRFM3?=
 =?utf-8?B?UmtlSTduR3NjUytvQ2FhSG9lS0M1R3hGZmxTaU5NczZtRkUrVkF3U0NoOWw3?=
 =?utf-8?B?ZENVU0R1M2JxRHJlYTl1bXRqd1RRMkhUamtBaXFSWVBYcEpkZ2hKVjc2RUta?=
 =?utf-8?B?TFNTV1gzeThPMFNlZS9QMGxOZEZTL3VYNW1qaHlVNXQ5U3U1N2IrbmdWQktn?=
 =?utf-8?Q?ke1W9kTtmzqWTNWY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb6adea-fa35-40d6-422a-08de5d71ac98
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 06:59:54.2769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cI0xHj+V82AkvbNzs41R+gv4VebCkROoxLftKee+HbWxmsBCQMv5x+dhcP0P6dPWH/ZHG4faqNAr31PXdopc6FCC7Y5THuRJMbdsxH7Wbik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFA08475C7D
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> On 24/1/26 09:59, dan.j.williams@intel.com wrote:
> > Alexey Kardashevskiy wrote:
> >> IDE stream IDs are responsibility of a platform and in some cases
> >> TSM allocates the numbers. AMD SEV TIO though leaves it to the host
> >> OS.  Mistakenly stream ID is hard coded to be the same as a traffic
> >> class.
> > 
> > I scratched my head at this comment, but now realize that you are
> > saying the existing code used the local @tc, not that the hardware
> > stream ID is in any way related to traffic class, right?
> 
> When I did that in the first place, I also wanted to try different
> traffic classes so I just took a shortcut here.
> 
> > It would help to detail what the end user visible effects of this
> > bug are. The TSM framework does not allow for multiple streams per
> > PF, so I wonder what scenario is being fixed?
> 
> There is no way in the current upstream code to specify this TC so the
> only visible effect is that 2 devices under the same bridge can work
> now, previously the second device would fail to allocate a stream.
> 
> > Lastly, are you expecting tsm.git#fixes to pick this up? I am
> > assuming that this goes through crypto.git and tsm.git can just stay
> > focused on core fixes.
> 
> I was kinda hoping that Tom acks these (as he did) and you could take
> them. Thanks,

Ok, so can you refresh the changelog to call out the user visible
effects?  Something like:

---
With SEV-TIO the low-level TSM driver is responsible for allocating a
Stream ID. The Stream ID needs to be unique within each IDE partner
port. Fix the Stream ID selection to reuse the host bridge stream
resource id which is a pool of 256 ids per host bridge on AMD platforms.
Otherwise, only one device per-host bridge can establish Selective
Stream IDE.
---

Send a v2, and I will pick it up.

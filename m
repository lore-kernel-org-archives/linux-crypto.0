Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48A7468C27;
	Mon, 14 Sep 2026 15:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401301; cv=fail; b=QZI2Iseh4eR+EnptyDpGoopHiIHKX4uO6B1VA0Vv2I0ImOx970bUBypTcp9AcfnQNyb40ICrfn+WJMyCygd+hlwxixGB+HP0Y4uHrXdIJUcY03w5URNb/WgAOPSEogPCQenPH2A2wEU3I4KNh/+c//G1ctNGsax+m0eLDul8rMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401301; c=relaxed/simple;
	bh=tz0kGCFO8UJKs7OlRSI5fOcp+hF2EbB44q3ez+I5y2s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=njVKtBz5lq5olUUNus3e20sEQZuXHKgvRti5VfhkXlWEmih0TawXPKLCRxfIM79MCm1F+Y4HuUHf1kpebg3cF5bHCr4zIC70mLn+C9wjdPA4+jD83H9xD/cBittEgqMyq+RG9cT3pQgXmQltbLGjEu8E5ozKkb535+dog26uMug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eEIiKgjp; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eEIiKgjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789401298; x=1820937298;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tz0kGCFO8UJKs7OlRSI5fOcp+hF2EbB44q3ez+I5y2s=;
  b=eEIiKgjpA6QMcvg2MWlU8NKt0YoYMagWZ97cQP++PpLJ9lQ0bcqjY0bA
   Z6lrUGnsZaRaJxx0xwsxv2y54Y0oKC7trQNkoWW6tMr836koxFQAUcZaT
   Ojk4RV1KtB6R7ZpAWsK5G6Y7I/+NFWlXvVq+k5hctEM6w0GdeqeiB+3Z5
   B4iLDQf16H0f0Lc/PoPAoL9opfXvqSXuQqM4PsQZIyWDljbzdoG2NGYPm
   LZOgD7ZA57L416I+Fu82McfpkImTWbRW9Bud8ZyC3ITT8pPBozKwrhrJh
   x9S/gme5ofu422PBuOB2yYw9Z2TX6alqxDjt91aCcC3mfJF04l/jwhn22
   Q==;
X-CSE-ConnectionGUID: lIAgwGWDRaa4/1cb3mQ0Tg==
X-CSE-MsgGUID: Tc/Engz9RdaGS5MazHjWVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="88893861"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="88893861"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:54:54 -0700
X-CSE-ConnectionGUID: GAKaSmkeRIeb/AsJULLdIw==
X-CSE-MsgGUID: xOuHZigwRJOE7FyzMD2fgA==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 08:54:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 08:54:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 08:54:52 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 08:54:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X6IjsL3/Dl7c+Bonbh13vnjEG/5KJJhyeUqwy1KVmGBwKkGVyg4sdQcGUOJOrRKTfP137+nJAP8i8WTKT6fV932YRiU2WCc2iQs14oJz7FKVw5zSns2aVfZpKyzLnn9xJLDqdupUekrWFaqRGhRLgBcfy7XWt+y8qbmtgkOR1SkhyPrBkUQubG08CO8fTo2fkpEfR+dWkVTm3uiX+9OMhz/5H99HafC2G4fN/YosTvZJMwZCLTKgC8maYYxCjUdvAwkwChaUAKOdnbIqk7M+4wwaE9u7Ext7SbYw/eicLM7atRC5Lb88ohdsZd03l/gYB8OkR31hqhn93CWMNlyaQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJywIoQ62JkPFaRDKdqkSpKHrELoIjFnIMHh4GDwy5M=;
 b=TMNampOHWSONDb5XzQ+gnvcDil50bPYlhc6VxF4OTqh2BbnhLyzQXjNHuAD74WzyJPe3UfWZ/WYCF3A0xVDjIW/paprfTNR+tG5QM45qYT00y1zN/zQ+71EiEwZTUc9obti8oGkm+1NyIXQcXFhA6AKyxjmxAnF91iCYXrr3Hg2LKVcwGZwrR1LH8Dhj/wZT1Y9KNvqQXgryLUrIUNo8z4lXv265nZBrfuEM3vsi6t1nLOm7/OA/L3QPqxgPn/hGKSRGXITdshy8GkDh+pKvDkpcTSj3DLk4eX2DlPBxQxbFod8LkQe/Pkd4Yxl2q9a7RTNlKSe93fd5e8wMkQoWww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB566415.namprd11.prod.outlook.com (2603:10b6:806:589::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 15:54:50 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 15:54:49 +0000
Message-ID: <13c52f11-61c9-48a4-ab6c-3ebe7676fdda@intel.com>
Date: Mon, 14 Sep 2026 08:54:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/13] treewide: convert rdmsrq() from a macro to an
 inline function
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-hyperv@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-edac@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-acpi@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-crypto@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
	<linux-hwmon@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
	<platform-driver-x86@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, Long Li <longli@microsoft.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Ajay Kaher" <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, Broadcom internal kernel review list
	<bcm-kernel-feedback-list@broadcom.com>, Josh Poimboeuf
	<jpoimboe@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Pu
 Wen" <puwen@hygon.cn>, Tony Luck <tony.luck@intel.com>, Dave Martin
	<Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>, "Vitaly
 Kuznetsov" <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
	"Pavel Machek" <pavel@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, Boris Ostrovsky
	<boris.ostrovsky@oracle.com>, Len Brown <lenb@kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, "Niklas Cassel" <cassel@kernel.org>, David Airlie
	<airlied@redhat.com>, Olivia Mackall <olivia@selenic.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Viresh Kumar <viresh.kumar@linaro.org>, Huang
 Rui <ray.huang@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, Perry
 Yuan <perry.yuan@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Srinivas
 Pandruvada <srinivas.pandruvada@linux.intel.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>, Linus Walleij <linusw@kernel.org>, Bartosz
 Golaszewski <brgl@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Artem
 Bityutskiy <artem.bityutskiy@linux.intel.com>, Artem Bityutskiy
	<dedekind1@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>, Hans de Goede <hansg@kernel.org>,
	=?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Rajneesh
 Bhardwaj" <irenic.rajneesh@gmail.com>, Xi Pardee <xi.pardee@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>, Helge Deller <deller@gmx.de>,
	<xen-devel@lists.xenproject.org>, <linux-geode@lists.infradead.org>, "Michael
 Kelley" <mhklinux@outlook.com>
References: <20260911074530.3140830-1-jgross@suse.com>
 <20260911074530.3140830-13-jgross@suse.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260911074530.3140830-13-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:303:8e::28) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB566415:EE_
X-MS-Office365-Filtering-Correlation-Id: 551bf591-1ca3-475a-2be7-08df127881ec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: FCdcRAsMIgf1njP/rTi6g0mD5FTBwjqPKJlKMfYLIzHABACl3yu+Bp9ABUa4YIxLOSf0A4/1LlfPNfOdSCAagLX6RNR5w/+ZgtlriDS3e8Ti8P7F5MiclfyTSBUc26pDgq0FXpleG0oOAIb21Lenjsm6+eE8MHtwetKU9nH2yPusdp8tmbXqUEjEUtE/3hWH4X4oRvaLaFcohO36Xw4xt5MfwuZtVLhw3Zh0T8J9Z3zVuD5tuGDpLG3NZ8Xh/uBJq+9WXtZFbJPvUTb82v+WUBmHQ7/+emn6VBPh5kEsl9e0p4EUe+gIN5EBx/SckIUTh2+Pfh4Hp9CibOxmo4FI5ejLXsjJpc2uzA5zWmYkVZUBskPNqr/Ce39z3Pth0MTdfwlwzV6voFNyCZCTVTwVORyollyZlS/MfkDul9lHdqhaytdpeVZe316vpXH2UcUga8Iscx3Hl8pvjXyKhORvWGP3muHgAMsRa/RXgHwEzjOJLsJCvZgYPOszsq8iteGLFEQd8JLAAjzX0xmBnLUtLpGvJKy6f2zFtsms3NjiLqoNXkxqQEfytQhOwgFt6i10KrP4H/5cvwqr03FJz3Vldkddg7sqR/f10LoY6Fw73QQrit7NZYQyej5ZfjArn9hQQD3beKMjL0YWKO1Cs+OAFqQ/DnoxSvrg0+YIOX/N0ynQgrUJZ3zVYBUS6cP1N31ZkmfNaPDsQdZ6IEZoL44uOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blV5NUQ2NHJ2ZThBNHlRSDlwbE83YzhWd2RKV0pTNkJwTGVITnVqZ3FvWTVm?=
 =?utf-8?B?TDlzNXZwRFkyWkxKYVk3bklTNktuNFF3MWVRZTJkbUkwR28zRitueXBjUC9z?=
 =?utf-8?B?cHpRRlFwa21hcGdUakRndjEvNE9vbWNTK3dFNXI1NEt6d0s3ajFuTVY1c2tR?=
 =?utf-8?B?Rk9HbEpqcEN2UlhoRDhUOC9tM1c3NmFrL3V2UjRQQ1QybEI1VG5WeVZ1eEll?=
 =?utf-8?B?N0FKWnp3UDUwUmkrcjFhNnVDcEN2REZzbEpnMFdTdG9mcEhTOGRFc0dlTGJR?=
 =?utf-8?B?eHZJaXpBWENBd28yYnp1cGQ1T1pjNjlJNWJ2bzYrZlhhU3VrMGZFeVZiNTVo?=
 =?utf-8?B?T0hDUFNqaVdMcXZRc3lTMFBIbE5CQzdsenJzT3QxbFF0UGlhN0kyS2thMDhh?=
 =?utf-8?B?VkNiME1ZZEhOVUJ1Q2hCMm9DYUNFemlBWDVpdG9NYnJDa3RQUkZ4akNVNXZS?=
 =?utf-8?B?V0NWRnhBcWtMQzBFTTREbVZ1SmZ6YjdmampncFJxR2xvMWdSYmRUdy9kNlJw?=
 =?utf-8?B?SWtGOEc5QUt1V1F6Z3A2YmR2bnFRVDZMQ1FZd0VQckxCRkpUVEhQcVFwWCtn?=
 =?utf-8?B?YUc0T3pRWHNvd1JzYVVkaWxmZHRYQ3ZBalZ1a3FuazNyNjVIajNpNFNkT2Zh?=
 =?utf-8?B?RTJsUVVSR3ZuME12a1k3Y21XWWJGKzR3TmQ1bkpUZHJ2cFZZbHpFeDJybyt3?=
 =?utf-8?B?enk3N01DL2syc2tTeUlKdG1aaGN4S25TWG9wS0hwcHFNeGJRV0oyTVl6TThJ?=
 =?utf-8?B?WnJMaFBDMjFXNndNb1hxQitNLzJqM2E2WFZjTWNwVDlXbVpLTGtzWDJWb0g2?=
 =?utf-8?B?V0s2Q1E3STZ5UklOSE5HSzR5UUJEaXpkVFNRRVRCVDBTczdiZ0U1NVF6YVE2?=
 =?utf-8?B?K3cxMjFIZTVLRUorWTdzK3M0QmRVNFFMSDk5T0JNL240SlhhQi9ieFo4SWxn?=
 =?utf-8?B?eStPOGZMeUVwQnhRTkg3M0ZyM3NaWnQybTZGbnJ1VXg3a2RTdWo5ODBIbDJ6?=
 =?utf-8?B?YmxUeHBYcFpmdzZvZS9sM25ZWC84SHV3Q2tvZ0s5b0Y1K3NzV3ZMRmhtVExu?=
 =?utf-8?B?VEU1OFdpdnZqZzFabi90SHVla25CeEVWZDdwOE9DY2EvT2ZZVk1FL0ovSXho?=
 =?utf-8?B?QXdybWVKM00yNEVPSWsyUzUwcUJGOHp2VUFVM1lQTWZncUZYaWxaaG9LL0Jk?=
 =?utf-8?B?QStDRUlJaVM3YmhVb3RiRXhkVEZQbmdxczlub1NFbkl1RzByWHJvWW5FUm1Q?=
 =?utf-8?B?UFlwejJ6UnE1RGV4aGQ1a2NGYlliT3U1VjZRL25LekJhKzZIVWRkQ0M2YVdU?=
 =?utf-8?B?QXhRc040MWJ3aDRUSmtuZzMwZ1JKaHg0QXBLUXNlWDE5UHdMQVlPSFhyUkRt?=
 =?utf-8?B?cEIyak13UGtmcnU2UmxVVlVXVnEwVzhzR1c1NWpsYlJqNWsvQUtyMUlJUHN5?=
 =?utf-8?B?bkxrRlVJWU05akJoRkd3WGE0TVhubU15OHZtTjJCYlRwVERFSHUxZkdYL2JI?=
 =?utf-8?B?SFNMVkVsT3R6WlFMeFpZSXlFTGl0ZWxjaFl6OUx0SFVVNzYydXJodkRwS2ZH?=
 =?utf-8?B?YVZHUC9RQ0g4ZGZ4K0VGYUlpOEZFbmJxempscUg4NFpMaEpWSlBzckovQ08y?=
 =?utf-8?B?UXRibTNOSHNJdnRrV3Vtdkl6YmRLNE9jZnRvS3A3MG04V1pQUWFpN2NtekNT?=
 =?utf-8?B?ZldPdkU0R2owYldDYzdwQWdIdVdEU2RPdFVaUlRHL1FMTmxsZmNhdDZvMFo4?=
 =?utf-8?B?bkJ1U1BCY2JVUFJURW50Z1ppS3ZhTVBqcWNVSTNUbW9vdnNQNHNveVB1UThI?=
 =?utf-8?B?SGp1YkZhYzBsenB0YVpwN2NzQkVhaGJwNDFiU3lMYk9WSWhIZlgzSThWSElW?=
 =?utf-8?B?UGdEYlQ1NHNoNmRuMG5CZlU5dVFEYVdiaG1oRUp3VUhvUHpMMG1ZUGlWRmli?=
 =?utf-8?B?RGNEVWVselVGSzJkVUFjWFVkQmpzVU1PVktPcGRJd0NlT0hiUlB2RWU1SUZY?=
 =?utf-8?B?OCs2ak1RSXlsajlxUXlkdGFBckRZYVQ0RlFHUGcvd0RiNGs1eTBPMTc4ZHJi?=
 =?utf-8?B?cnNVeU15by9wUXl1QVpxZWlyUCtjOWdyOXpJSU4xb0tiUXZ1M0FLV1Z3VGVy?=
 =?utf-8?B?ODNTOEM3ckg0cklNelRmOWxTQlAyWUI0c01hSG1oVGFqRnh0aUM4djVQMW9T?=
 =?utf-8?B?Z2V2NHFERkpYaXpROHZYOXpOQnNyRW5QQ2hwTCtuZW5PT1N0ZWpPU2tFdU95?=
 =?utf-8?B?YjRUU0phOXhSK29pa2xadXRsYmZmVC93aWh1eUxEQkZWbW51Tm10ZjJPVmpj?=
 =?utf-8?B?WXFqSVRJTGtiZ3R5R0RNTXNVc1J6VVNyWmowVEJpcnYwemlmR09NajZIV2R1?=
 =?utf-8?Q?wLXmYqB+hVXFJCZQ=3D?=
X-Exchange-RoutingPolicyChecked: cyJqkjq6LyZ2s/C+Xz7GWP1SYjQVauCVMSHvaQuLdJ+lkqMVaOgWZxc0DGnNUiNWVwimNV2eSi6F0Gre6pt6CeAetaTxAiW7qjQ82x/dc2LflDMjYvQzKoek1JsM0VXNKs4/nbh/qNYCXy92HxilQngMPjr7og596FIb+ZRQlVkbp/LKWvzvLnenDaaN2uOZ5Re1g7yzInlf2pPBx0AkkUuVxJyRE4/c4e2+bpvoXElbhjoWUiKW7HPqwV1j8mvsvDc5S0kORlABwth4SuwapiMqpm5AedSpNYZiuiIVqQORwovJaRjSsQzA5TkohpYyNIp1YWPObfx+EVzLYznZJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 551bf591-1ca3-475a-2be7-08df127881ec
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 15:54:49.7466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SaRdg+Ghp5yz6Z/XSmHZMZPrm05TT0dIoDTHljLMsUnfo0Fa/XkbNuA7gxHhR3aB8ylqcr2YZxDn7J7qkI77a4ZJFExbfFgBGARpRscpYkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB566415
X-OriginatorOrg: intel.com

Hi Juergen,

On 9/11/26 12:45 AM, Juergen Gross wrote:
> Today rdmsrq() is a macro using its second parameter as the target for
> storing the read MSR value.
> 
> Convert rdmsrq() to an inline function returning the MSR value.
> 
> The users have been converted using the following semantic patch:
> 
>   // Options: --include-headers
> 
>   virtual patch
>   virtual report
> 
>   @@
>   expression msr, val;
>   @@
>   (
>   - rdmsrq(msr,val)
>   + val = rdmsrq(msr)
>   )
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Damien Le Moal <dlemoal@kernel.org>      # ATA
> Reviewed-by: Michael Kelley <mhklinux@outlook.com> # Hyper-V
> ---

...
>  arch/x86/kernel/cpu/resctrl/core.c            |  2 +->  arch/x86/kernel/cpu/resctrl/monitor.c         |  4 +--
>  arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  4 +--
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c        |  2 +-
Thank you.

Acked-by: Reinette Chatre <reinette.chatre@intel.com> # resctrl

Reinette

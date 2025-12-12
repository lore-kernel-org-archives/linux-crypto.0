Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7779CF;
	Fri, 12 Dec 2025 04:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765513965; cv=fail; b=PHwXeJYxnJFf5lERazSH7Ryx5G35ito4Rg50XHt/MT8m03F7asY8ZaQZU+9fzfmto5VzpXwBPfzxn+akDyXmGAkedT2A1DjTY7PbB11mzCkKSdFq9IJgb0vM0r1H308U7+n7g4dk7N/lgJTT1PFm5HTqztxCggKVC0GwUZlz/L8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765513965; c=relaxed/simple;
	bh=0A+bV5V/urgV5jNDZmpNR8hnAhZmqcCiWp92kRB1dQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tdcjQ+EJOAO4bDXg7aBjHbHXxxIQhsWTpuXeEWGikTiu5+HfFcm305/ORmTB+y+QLdzDoeWb2XUX+GeuZGjbjQK6kiKKGAZ46Mim9EoMfa5MtTeesDvP3tSrBQY4GRry1jKf+YVN3pvYjLa7D9snMcJDZAPK4HIzhRltjtRYTbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JPlII61T; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JPlII61T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765513964; x=1797049964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0A+bV5V/urgV5jNDZmpNR8hnAhZmqcCiWp92kRB1dQY=;
  b=JPlII61Tv4JC/0TruIxBSdoPrn2s0oAsQOEIU2a5kHhwNZXk17CxsuFL
   BFPhC4EIDKfbjD2ZyyRShL+9E9g1dWJ88Yz1s5jGEsq3Pn/Q8P7J2TqkX
   shHtKKJ2cn8opxajRqz1GkME5qLVgl/ZQL5cNqxj3Ur29AuCEHacD7C6X
   4SRB9DUb7OPZvb7Wt7BZKcjjhzkb/hGF7hGCXJ+JrQM/WCI4vflyqiyYz
   hQYbznjG8vns20XhR6RLXGdjXmSiIFnfKcDF575Thpxp8fqyfFyMMpqua
   6KY5mBY2gFtpw0VdLkIKiaGlxrWWRsshRtG//OF3igBHEarYLxRdZuxMK
   w==;
X-CSE-ConnectionGUID: z0UuZTTjRV+aj0lOtQuDHg==
X-CSE-MsgGUID: Vv4tUhfYQpKy9260844yuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="71128102"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="71128102"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:32:43 -0800
X-CSE-ConnectionGUID: 8Jd/JZthQHCtCnLiZjPLpA==
X-CSE-MsgGUID: mACf1P6OS7u/MflcsMiwug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="201403522"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 20:32:42 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:32:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 20:32:41 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 20:32:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lPkipGYITlCz7cfm/3ImcEkT8+rt3wbWo6EHmsauWcU+SIcC3eJU9XZD6qVrwnzEnpzimXTLXxstUEZelakEpW0ZfmqcOqJRzqzlxUkKz8tkdDc5vFZpjxIORyP5++PWZpLn8H7tgZh/CI7yhW6UEPUupvqdugbQIz4kj6udxV3V68WPcMb6CdoXWNlqoF0VDM9c5p7lKev6PkGpkvKwY1Rhyg6wz59ioRmd5EgfJxoGIYZ/4NzLXp71332mwNLOk4vqvI6/pCreUuTYs+QC0UyAVms9OSz4wFFcYjc2z9EAtgHS1XLDYGeeN7HI/dolfJPJx6Wij3UpZTPLEPl/xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0A+bV5V/urgV5jNDZmpNR8hnAhZmqcCiWp92kRB1dQY=;
 b=j5BqLwxoSuZzCMi02EsrmXIgEcm292d222ZXEvNlVkKm9Yo2l38PvxQsDDZhcbaOS4l11dmNNHacm8tlgG3f572QK8SV+uhIIBtIRkGiUT7eTrXF1F+a1eN40PD8TzLGJ+KWZcQNJK5n4CIAW8ZGCdGTx701AzLOruYfzS7R+CqR40T3bDG0iYrgN044gwdDl6maLxsx02A1QnGd22bkSMoUj7PrMMqqutNEFCV6lVfrkpXYDYtCSzKMIFHv22KgO1uzOTVfhdqb566eqFHoewm1xsQCOEBmDvCwFQ+MHQKozoVGL/MQfiw5OymklDkos8L1Exl1GIMExiWNcwpjEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by BL3PR11MB6386.namprd11.prod.outlook.com (2603:10b6:208:3b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 04:32:38 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 04:32:38 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "sj@kernel.org"
	<sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "Feghali, Wajdi K"
	<wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>,
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Topic: [PATCH v13 19/22] mm: zswap: Per-CPU acomp_ctx resources exist
 from pool creation to deletion.
Thread-Index: AQHcTWsygycgPn5uUUWANDAP/laxYLTxHCiAgCxKvnCAAAU8gIAADInggAAPzICAAB1CgA==
Date: Fri, 12 Dec 2025 04:32:37 +0000
Message-ID: <SJ2PR11MB8472483C9217DEE7885D0113C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-20-kanchana.p.sridhar@intel.com>
 <yf2obwzmjxg4iu2j3u5kkhruailheld4uodqsfcheeyvh3rdm7@w7mhranpcsgr>
 <SJ2PR11MB8472E5CE1A777C8D07E32064C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bv3uk3kj47iiesreahlvregsmn6efndok6sueq5e3kr3vub554@nnivojdofmb6>
 <SJ2PR11MB847266BEA195A20A095AFA73C9AEA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <d6a7cbdd9d16c5759d6511cbad3f7bf7b99d2247@linux.dev>
In-Reply-To: <d6a7cbdd9d16c5759d6511cbad3f7bf7b99d2247@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|BL3PR11MB6386:EE_
x-ms-office365-filtering-correlation-id: 40ddce20-0c10-416a-a743-08de39377ad6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|10070799003|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a0FjWnZ4MHNSK3hIZjFvVTdONjU3aG0xN21lV0VsUW1WTkRBQkNCK1RmWWIy?=
 =?utf-8?B?M0VKWDBheUlwUzdEOHdraFhxZkdXOEJHd29VVzFCNDhyRFdBWENZbG9aZ0RJ?=
 =?utf-8?B?LzBGbnFPelBXU0pnajV0MjQyTzB6RzRJS01rZThZMHBUZWQ5WmVzNGErczNU?=
 =?utf-8?B?bFRXeDBnaDdNNG55RHRmUDhzOVg3TzRtQ0JZMGo0ZEhlRUF3ck1KNlMvSnlH?=
 =?utf-8?B?YVd2ck5aZlpZUWdkK0ZxeDR2VGdaYzF2SzRxZGFKSTJHcjhCQkNlZDFxdkhj?=
 =?utf-8?B?c2JrTEpEWXpCVHRVODJOYXB2L1VOK21OUlc0Y1VoMlNtOTJiUjlSdU5ybnBL?=
 =?utf-8?B?ak5TbFh0K0ZVWnlMUVRmNVp2ZCtRMXlSUmY5eThoNXJsUkRMSDc3K1QxQ0xt?=
 =?utf-8?B?R3hyVm5KRzU5YzROdDRjWXhqQWxoN00yRFFBMFE3ZVArUHNrdjl1aWFxdW11?=
 =?utf-8?B?bXJ4Q3NxL0xYQVE2Y3JaSG1yMWhGYmZmcnlHT3BteFN5SEJ1VUJobmNPdnVG?=
 =?utf-8?B?ZmFLM0xrOXZtY1FHQ0p0S3ZCZzd6TllFUFV2aVlXK05yWThYQ2VwM0pKSDhN?=
 =?utf-8?B?K0ZNeS9rWG1BREQ5SE13MnZGREMwY0pFSnZCaHh0NGZQM0hTQmw1cFhLU0pr?=
 =?utf-8?B?UG1ndmlaYS9WUUI0K3NMWGUwQTFFbEtPMW9xVTI0YVZPYVJRalpmYmhUSVho?=
 =?utf-8?B?a1A1MnBiL3MrTkZ4SmtoK2Vkc2VkSk1PbTJoVUlybWFoalR0TTdQUzZkM1dQ?=
 =?utf-8?B?NkRiM0U4Wk5QNHVONURGYytUMjBXZ3NVejl5R2lrYUU4UVIvRElBSHVJdGIy?=
 =?utf-8?B?ZjVBbk02WnZHOHBwNFdRQy9teXBLRFFzekc1dTJYK0w5cXp0NFE4UjZuZFZ5?=
 =?utf-8?B?bXZaaU85Wk9DOTdrY1hkVHZvaUhiNjhMUEFKMDBWbVMyQUl0dUhKbVplZFBx?=
 =?utf-8?B?RFhJTFN2T1dsRjVhc0tDbE5nYTAyeTE4WWUxNHM1TWJGazRWNENpOTVVVll4?=
 =?utf-8?B?Um9OWHdyRjYyOHBsRlN4ZEIwVGtNODdCb3IxMms0bW9FNXF1SzhVTlhubEV3?=
 =?utf-8?B?ck16K2FoOTYyUDBaRjRXeVMxbkxCbXA1U2NEdWk3eThBcUVJN1VFaXVpUFow?=
 =?utf-8?B?Lzk4M1VmMTNDMDRQQlRvLzc2RWF3cHFZWm1maTVrRTJ1OVQ2clZPWTZxM3I3?=
 =?utf-8?B?NXZNSUtBa0pJY0ExTGcvTDVIdzBqU0RZTVE0YWNFdTRndGVGdDNHZ25rNEQy?=
 =?utf-8?B?MVg3VXN6MkVCUTVlYXVRZTRsdzVtOElWOEpRdGZuZlpBUjZsbnNWandBUi92?=
 =?utf-8?B?c1VzOTI0V29CYjB0d0lGeTJJcE9lVSs5bnVsTWZ6eDAyQzFnbEZsUHd6Smdy?=
 =?utf-8?B?VVBpVklLRzZacDcxMzZocTU3YUwvQlBvTjdPZ2lweElwV3UxNDFQZ201cmNh?=
 =?utf-8?B?VnJtQlBQNVh6Vk4xc09lQXZOVkNUT2NWMHhYa0h1VHBQZzRUTGMzV0VZaFkr?=
 =?utf-8?B?OEpadjhTNS9pa1YxR3ZDSERvMXpvZGdidkNqMXcxS2JRSEg4NE40UDI5dGFs?=
 =?utf-8?B?NGdtNy9FQ25wd1BaTldoeEUwVm1UdTJPcHBmczE2ejFIRTB0ZngvM2RtSlhK?=
 =?utf-8?B?NWM5ZDBTcGRuZk93OFVId2l1VFBvRlRaNmxFTXRlOFVSWk9CbmF1dnVibWNs?=
 =?utf-8?B?aWVqNXBCbkhQRjR1WmtvQnJ3THRDcVBwTVdsa3ljRERyTTVvbmdvUDA3ZGpq?=
 =?utf-8?B?TVA2YUp3NGhRaHZMSkNtUHVXYnpOSUVSd1hIK0luTis1UHZCcy9OV2FlZk51?=
 =?utf-8?B?NmtITUFubVFyNk5lVW1CWmM2c0xHeDBrVWI3bHE0VzZwVmg5Q2RVa2g1c3F5?=
 =?utf-8?B?NVIrdG0rTnIxbUFqYTFiUUxzVEk1S0k4ejE5ck5hNUpteFdQMmk5N0VQYU1I?=
 =?utf-8?B?TTF6L0hjNFlrYkIxbkx5Q29vZk1RYlIxaHk1VitaVGJya29NT1k3T09iOERP?=
 =?utf-8?B?R3Bla2FTN1VqTE8yaFRlazNOSFAxYm9odTRxaTVTSmo2N0ZmNzBrRUJ4YnRB?=
 =?utf-8?Q?kC17rP?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(10070799003)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWRqaCtyVFJPQ1VHSEgveUszVHNjb3dLWDgzQXZGRi93VGVKQ0RhOHVyNzl5?=
 =?utf-8?B?TCtpSklYZXZ6N1RxWEMrcUJzT2Fmb2huNklqTHdvYUNHM28yYVhqaTFiWlhW?=
 =?utf-8?B?K0VHQkZrRFZVTmZrNU9iZUNuMnJkTmJjV0tQUTF3Q3ZaRGl6MjY1Vzc2UVJv?=
 =?utf-8?B?d1hMT1JoWldVTjVuOVBRTHF1M01xSEw5M0p6RUd6OWtnWFU1OWtUdnFDNVkr?=
 =?utf-8?B?MWd5S09iV1d5YzFVaHkxWlZnR0JwSlBlVUFRU05TMTdaYVdjOTIvRzB1OVZR?=
 =?utf-8?B?UXMyTzhLNDhQS290UDdwRmlCb3Qvcnl4OGdWQmNTZ2tZMkExV2hYb2kxc214?=
 =?utf-8?B?ZU5PZmk2a1ZqQ3NGLzlka3owSjIrV3h2YURub0pqd2diUU41SFNIbWtPSWdR?=
 =?utf-8?B?ZXM4NWhGYno0bFNuWFRFNUxUVStLVFdYZG1KR2tRQ3Z5U0hXU1BSN2tmV0g4?=
 =?utf-8?B?RXd3VWs5SkxGdE0zQmluQWYrckpibDRMY25CSVpHSVhSMWlVa3FOZFM5aE5u?=
 =?utf-8?B?amc3MkdETVgvQ1pmMURoOVMxSnBZQ3AzUjZBdlE5aUpkb3dZL1k0NmtyZ2l0?=
 =?utf-8?B?RUE1ZkVnU1NTR0l2dzZwRzJ4NFRMakd0Q3FTNFZDdERWZXlqNk4rS1MyRy9n?=
 =?utf-8?B?UGx2NGY4UUFwSDJmNVpLMVNQNG1COWFvbmxZTk5QUkRRZG9NT2VEK0k2clli?=
 =?utf-8?B?bnJxc3hGUlZtZnp0MnNmNHh2ZTEzMzRUdFN2eXZMcjJIY3N6MGZFelBSSUFN?=
 =?utf-8?B?WHE3SzVWbXhFWi9ZQ3hxem5Kc2lFYTAzbGJTK0lKQko1cEk3NFNNRFF1dHNy?=
 =?utf-8?B?Tk1jdnc2Q3EzcUtJVmhsVU5PWnBiRUFXL1RWZG9xc0FYOFp4bjliclJJdGxy?=
 =?utf-8?B?QW9LTHVCc2REcU1DZTFRYURXcGlKaHUzcktHajV1SHhMeUlpNUk2cVNNY09h?=
 =?utf-8?B?T3RzVlZNSnQrTVRvMTVzbkRLL3VCTElKeXdBWlVMMy9DdVV0Q1FUTGlNTjhY?=
 =?utf-8?B?TFVuQVRneEozK0dLNlk4dmJEWC9SQ3ZtK25zTnhzRnFObHd3MWpGWkpwbnUy?=
 =?utf-8?B?eFhiT0pKNnV3dVpIcDJNdXFCd3J0YjA1RGJFQkpnRGlib1hzYzQwZlc4b0g1?=
 =?utf-8?B?U3lDMXh2VWgvSk5kcDRxY3N2T0VaUEhPTDZoL3U3b1hOcnlmaGxNOUk2a2lp?=
 =?utf-8?B?R3FIclBCV0xUbkRYZzEzTkU0TkJtaXNzK1pqVDViVjFSZ21XRTA0L2x2L1Fp?=
 =?utf-8?B?cXdRcHVFOGZQdGtkK2JWZWd2RWUzQk5wcFo2aFNJZWI1blpYZzYxN21KSFRa?=
 =?utf-8?B?R3BvNzVIOE9VTWpaMzF6UWN3RTR0NzRnOW5yVmlrcHJvRU8rVitaVmVXelg2?=
 =?utf-8?B?K29XM1NWQ2oxWVphcG9qSjBrQ3duNk9aa1pKZDRsUm9TR3Z5dm5IbFozb0NI?=
 =?utf-8?B?d1g3VmJsNGNXbDQ1azBrTWRjQmNibUR2cXp0WENGOXUzWFFJOFRNTTZaeFZN?=
 =?utf-8?B?R0k0ZHFjVjJleG9MR2UvckYwOEh6VnFoUDBraEpOeHFvMXh5djM2NGtEKy9z?=
 =?utf-8?B?UkNJY1BneE1JdUhKRFY3WlhJSld5L3kySFhDVU45Ty9XcXZuR2Z5bVRMUE1I?=
 =?utf-8?B?ZmlRcWpEZzdNS1o0TS9vRU5YLzhYMkMyYUxjYnZUTTl1VTRROEQwaXJHQzcw?=
 =?utf-8?B?TGZNVDQ5RTUzUW5DTFVlZ0pBVEtVRHpQVmhFMjlTM3hHY0hNUjhWQ1NhV1hC?=
 =?utf-8?B?VzZvOU9vM2F3SWFaMUpVTStOY2FRM2FYMjRuRGVKcndNMUI2OEZtQXhIQnJZ?=
 =?utf-8?B?SXJ5em4vcTFkZEZObVE5S2ttdVFmanpYQmFuZnR0dmVZU0tFVGZGajdoWlhs?=
 =?utf-8?B?UHFZMVpUanJZYThnRUs0RW90d0tSMnp5M1c0ejNQanVUOEVwbmJyODZBVXdo?=
 =?utf-8?B?TDFZTWFPVHM2a1VFZlcxb296R0lpeHRtbVJ3emZCczR1MUdvY3gvS3A1djZH?=
 =?utf-8?B?TDEzUWUzTzJheHpmTk9jSTZlNEdpVHpzUUtoL2wzeDV5cC9XTUh6TTY0Nkha?=
 =?utf-8?B?VldNMGJCNmhucERyMU1NSCtWMmRMQUhQREtpVVRXa2FLV1hoNVJaQ0ZFTndo?=
 =?utf-8?B?Q3N1YSs5ZmRtUU4vSTRvVmZFQ1EvY1JtU0ZLNllkOFRGZ1EwUkFSS2oxUE9i?=
 =?utf-8?B?VGFIeFduSGRmQ1hKU2lWbzV2TGtYN0MwcTZ3UEF3Y0hRRU1VYjdkYnFycnRx?=
 =?utf-8?B?VFBOdFhBTWptaDgvRXRsQ01BNVpnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ddce20-0c10-416a-a743-08de39377ad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 04:32:37.9471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfThw0vBcg0RYtB6xYeJMOHe+v2rG4kEzBeMwrDlC34EFRh7H9AGWQRhWroWlCAHLO4F9MfSk9XWqo0mbTktiXZ/frjqPoDBroQ/05VkZ3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6386
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlvc3J5IEFobWVkIDx5b3Ny
eS5haG1lZEBsaW51eC5kZXY+DQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAxMSwgMjAyNSA2
OjQ3IFBNDQo+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxrYW5jaGFuYS5wLnNyaWRoYXJAaW50
ZWwuY29tPg0KPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3Zh
Y2sub3JnOw0KPiBoYW5uZXNAY21weGNoZy5vcmc7IG5waGFtY3NAZ21haWwuY29tOyBjaGVuZ21p
bmcuemhvdUBsaW51eC5kZXY7DQo+IHVzYW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0
c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWlsLmNvbTsNCj4geWluZy5odWFuZ0BsaW51eC5hbGliYWJh
LmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gc2Vub3poYXRza3lAY2hyb21pdW0u
b3JnOyBzakBrZXJuZWwub3JnOyBrYXNvbmdAdGVuY2VudC5jb207IGxpbnV4LQ0KPiBjcnlwdG9A
dmdlci5rZXJuZWwub3JnOyBoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU7DQo+IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGNsYWJiZUBiYXlsaWJyZS5jb207IGFyZGJAa2VybmVsLm9yZzsNCj4gZWJp
Z2dlcnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdvb2dsZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQw0K
PiA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzIDx2aW5pY2l1
cy5nb21lc0BpbnRlbC5jb20+Ow0KPiBGZWdoYWxpLCBXYWpkaSBLIDx3YWpkaS5rLmZlZ2hhbGlA
aW50ZWwuY29tPjsgR29wYWwsIFZpbm9kaA0KPiA8dmlub2RoLmdvcGFsQGludGVsLmNvbT47IFNy
aWRoYXIsIEthbmNoYW5hIFANCj4gPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggdjEzIDE5LzIyXSBtbTogenN3YXA6IFBlci1DUFUgYWNvbXBfY3R4
IHJlc291cmNlcw0KPiBleGlzdCBmcm9tIHBvb2wgY3JlYXRpb24gdG8gZGVsZXRpb24uDQo+IA0K
PiBEZWNlbWJlciAxMSwgMjAyNSBhdCA1OjU4IFBNLCAiU3JpZGhhciwgS2FuY2hhbmEgUCINCj4g
PGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20NCj4gbWFpbHRvOmthbmNoYW5hLnAuc3JpZGhh
ckBpbnRlbC5jb20/dG89JTIyU3JpZGhhciUyQyUyMEthbmNoYW5hJTIwDQo+IFAlMjIlMjAlM0Nr
YW5jaGFuYS5wLnNyaWRoYXIlNDBpbnRlbC5jb20lM0UgPiB3cm90ZToNCj4gDQo+IA0KPiA+DQo+
ID4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ICBGcm9tOiBZb3Ny
eSBBaG1lZCA8Pg0KPiA+ID4gIFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAxMSwgMjAyNSA1OjA2
IFBNDQo+ID4gPiAgVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPD4NCj4gPiA+ICBDYzo7Ow0KPiA+
ID4gIGhhbm5lc0BjbXB4Y2hnLm9yZzsgbWFpbHRvOmhhbm5lc0BjbXB4Y2hnLm9yZzsgOzsNCj4g
PiA+ICB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyBtYWlsdG86dXNhbWFhcmlmNjQyQGdtYWlsLmNv
bTsgOzsNCj4gPiA+ICB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBtYWlsdG86eWluZy5o
dWFuZ0BsaW51eC5hbGliYWJhLmNvbTsgOw0KPiA+ID4gIHNlbm96aGF0c2t5QGNocm9taXVtLm9y
ZzsgbWFpbHRvOnNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgOzsNCj4gbGludXgtDQo+ID4gPiAg
Y3J5cHRvQHZnZXIua2VybmVsLm9yZzsgbWFpbHRvOmNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IDsN
Cj4gPiA+ICBkYXZlbUBkYXZlbWxvZnQubmV0OyBtYWlsdG86ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
OzsNCj4gPiA+ICBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBtYWlsdG86ZWJpZ2dlcnNAZ29vZ2xlLmNv
bTsgOyBBY2NhcmRpLCBLcmlzdGVuIEMNCj4gPiA+ICA8PjsgR29tZXMsIFZpbmljaXVzIDw+Ow0K
PiA+ID4gIEZlZ2hhbGksIFdhamRpIEsgPD47IEdvcGFsLCBWaW5vZGgNCj4gPiA+ICA8Pg0KPiA+
ID4gIFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEzIDE5LzIyXSBtbTogenN3YXA6IFBlci1DUFUgYWNv
bXBfY3R4DQo+IHJlc291cmNlcw0KPiA+ID4gIGV4aXN0IGZyb20gcG9vbCBjcmVhdGlvbiB0byBk
ZWxldGlvbi4NCj4gPiA+DQo+ID4gPiAgT24gRnJpLCBEZWMgMTIsIDIwMjUgYXQgMTI6NTU6MTBB
TSArMDAwMCwgU3JpZGhhciwgS2FuY2hhbmEgUCB3cm90ZToNCj4gPiA+DQo+ID4gPiAgPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gID4gRnJvbTogWW9zcnkgQWhtZWQgPD4NCj4g
PiA+ICA+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciAxMywgMjAyNSAxMjoyNCBQTQ0KPiA+ID4g
ID4gVG86IFNyaWRoYXIsIEthbmNoYW5hIFAgPD4NCj4gPiA+ICA+IENjOjs7DQo+ID4gPiAgPjs7
DQo+ID4gPiAgY2hlbmdtaW5nLnpob3VAbGludXguZGV2OyBtYWlsdG86Y2hlbmdtaW5nLnpob3VA
bGludXguZGV2Ow0KPiA+ID4gID47OzsNCj4gPiA+ICA+OzsNCj4gPiA+ICA+Ozs7IGxpbnV4LQ0K
PiA+ID4gID47Ow0KPiA+ID4gID47OzsNCj4gPiA+ICA+OzsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+
ID4gPiAgPiA8PjsgR29tZXMsIFZpbmljaXVzDQo+ID4gPiAgPD47DQo+ID4gPiAgPiBGZWdoYWxp
LCBXYWpkaSBLIDw+OyBHb3BhbCwgVmlub2RoDQo+ID4gPiAgPiA8Pg0KPiA+ID4gID4gU3ViamVj
dDogUmU6IFtQQVRDSCB2MTMgMTkvMjJdIG1tOiB6c3dhcDogUGVyLUNQVSBhY29tcF9jdHgNCj4g
PiA+ICByZXNvdXJjZXMNCj4gPiA+ICA+IGV4aXN0IGZyb20gcG9vbCBjcmVhdGlvbiB0byBkZWxl
dGlvbi4NCj4gPiA+ICA+DQo+ID4gPiAgPiBPbiBUdWUsIE5vdiAwNCwgMjAyNSBhdCAwMToxMjoz
MkFNIC0wODAwLCBLYW5jaGFuYSBQIFNyaWRoYXIgd3JvdGU6DQo+ID4gPiAgPg0KPiA+ID4gID4g
VGhlIHN1YmplY3QgY2FuIGJlIHNob3J0ZW5lZCB0bzoNCj4gPiA+ICA+DQo+ID4gPiAgPiAibW06
IHpzd2FwOiBUaWUgcGVyLUNQVSBhY29tcF9jdHggbGlmZXRpbWUgdG8gdGhlIHBvb2wiDQo+ID4g
PiAgPg0KPiA+ID4gID4gPiBUaGlzIHBhdGNoIHNpbXBsaWZpZXMgdGhlIHpzd2FwX3Bvb2wncyBw
ZXItQ1BVIGFjb21wX2N0eCByZXNvdXJjZQ0KPiA+ID4gID4gPiBtYW5hZ2VtZW50LiBTaW1pbGFy
IHRvIHRoZSBwZXItQ1BVIGFjb21wX2N0eCBpdHNlbGYsIHRoZSBwZXItQ1BVDQo+ID4gPiAgPiA+
IGFjb21wX2N0eCdzIHJlc291cmNlcycgKGFjb21wLCByZXEsIGJ1ZmZlcikgbGlmZXRpbWUgd2ls
bCBhbHNvIGJlIGZyb20NCj4gPiA+ICA+ID4gcG9vbCBjcmVhdGlvbiB0byBwb29sIGRlbGV0aW9u
LiBUaGVzZSByZXNvdXJjZXMgd2lsbCBwZXJzaXN0IHRocm91Z2gNCj4gQ1BVDQo+ID4gPiAgPiA+
IGhvdHBsdWcgb3BlcmF0aW9ucyBpbnN0ZWFkIG9mIGJlaW5nIGRlc3Ryb3llZC9yZWNyZWF0ZWQu
IFRoZQ0KPiA+ID4gID4gPiB6c3dhcF9jcHVfY29tcF9kZWFkKCkgdGVhcmRvd24gY2FsbGJhY2sg
aGFzIGJlZW4gZGVsZXRlZCBmcm9tDQo+IHRoZQ0KPiA+ID4gIGNhbGwNCj4gPiA+ICA+ID4gdG8g
Y3B1aHBfc2V0dXBfc3RhdGVfbXVsdGkoQ1BVSFBfTU1fWlNXUF9QT09MX1BSRVBBUkUpLiBBcw0K
PiBhDQo+ID4gPiAgPiByZXN1bHQsIENQVQ0KPiA+ID4gID4gPiBvZmZsaW5lIGhvdHBsdWcgb3Bl
cmF0aW9ucyB3aWxsIGJlIG5vLW9wcyBhcyBmYXIgYXMgdGhlIGFjb21wX2N0eA0KPiA+ID4gID4g
PiByZXNvdXJjZXMgYXJlIGNvbmNlcm5lZC4NCj4gPiA+ICA+DQo+ID4gPiAgPiBDdXJyZW50bHks
IHBlci1DUFUgYWNvbXBfY3R4IGFyZSBhbGxvY2F0ZWQgb24gcG9vbCBjcmVhdGlvbiBhbmQvb3IN
Cj4gQ1BVDQo+ID4gPiAgPiBob3RwbHVnLCBhbmQgZGVzdHJveWVkIG9uIHBvb2wgZGVzdHJ1Y3Rp
b24gb3IgQ1BVIGhvdHVucGx1Zy4gVGhpcw0KPiA+ID4gID4gY29tcGxpY2F0ZXMgdGhlIGxpZmV0
aW1lIG1hbmFnZW1lbnQgdG8gc2F2ZSBtZW1vcnkgd2hpbGUgYSBDUFUgaXMNCj4gPiA+ICA+IG9m
ZmxpbmVkLCB3aGljaCBpcyBub3QgdmVyeSBjb21tb24uDQo+ID4gPiAgPg0KPiA+ID4gID4gU2lt
cGxpZnkgbGlmZXRpbWUgbWFuYWdlbWVudCBieSBhbGxvY2F0aW5nIHBlci1DUFUgYWNvbXBfY3R4
IG9uY2UNCj4gb24NCj4gPiA+ICA+IHBvb2wgY3JlYXRpb24gKG9yIENQVSBob3RwbHVnIGZvciBD
UFVzIG9ubGluZWQgbGF0ZXIpLCBhbmQga2VlcGluZyB0aGVtDQo+ID4gPiAgPiBhbGxvY2F0ZWQg
dW50aWwgdGhlIHBvb2wgaXMgZGVzdHJveWVkLg0KPiA+ID4gID4NCj4gPiA+ICA+ID4NCj4gPiA+
ICA+ID4gVGhpcyBjb21taXQgcmVmYWN0b3JzIHRoZSBjb2RlIGZyb20genN3YXBfY3B1X2NvbXBf
ZGVhZCgpIGludG8gYQ0KPiA+ID4gID4gPiBuZXcgZnVuY3Rpb24gYWNvbXBfY3R4X2RlYWxsb2Mo
KSB0aGF0IGlzIGNhbGxlZCB0byBjbGVhbiB1cA0KPiBhY29tcF9jdHgNCj4gPiA+ICA+ID4gcmVz
b3VyY2VzIGZyb206DQo+ID4gPiAgPiA+DQo+ID4gPiAgPiA+IDEpIHpzd2FwX2NwdV9jb21wX3By
ZXBhcmUoKSB3aGVuIGFuIGVycm9yIGlzIGVuY291bnRlcmVkLA0KPiA+ID4gID4gPiAyKSB6c3dh
cF9wb29sX2NyZWF0ZSgpIHdoZW4gYW4gZXJyb3IgaXMgZW5jb3VudGVyZWQsIGFuZA0KPiA+ID4g
ID4gPiAzKSBmcm9tIHpzd2FwX3Bvb2xfZGVzdHJveSgpLg0KPiA+ID4gID4NCj4gPiA+ICA+DQo+
ID4gPiAgPiBSZWZhY3RvciBjbGVhbnVwIGNvZGUgZnJvbSB6c3dhcF9jcHVfY29tcF9kZWFkKCkg
aW50bw0KPiA+ID4gID4gYWNvbXBfY3R4X2RlYWxsb2MoKSB0byBiZSB1c2VkIGVsc2V3aGVyZS4N
Cj4gPiA+ICA+DQo+ID4gPiAgPiA+DQo+ID4gPiAgPiA+IFRoZSBtYWluIGJlbmVmaXQgb2YgdXNp
bmcgdGhlIENQVSBob3RwbHVnIG11bHRpIHN0YXRlIGluc3RhbmNlDQo+IHN0YXJ0dXANCj4gPiA+
ICA+ID4gY2FsbGJhY2sgdG8gYWxsb2NhdGUgdGhlIGFjb21wX2N0eCByZXNvdXJjZXMgaXMgdGhh
dCBpdCBwcmV2ZW50cyB0aGUNCj4gPiA+ICA+ID4gY29yZXMgZnJvbSBiZWluZyBvZmZsaW5lZCB1
bnRpbCB0aGUgbXVsdGkgc3RhdGUgaW5zdGFuY2UgYWRkaXRpb24gY2FsbA0KPiA+ID4gID4gPiBy
ZXR1cm5zLg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiBGcm9tIERvY3VtZW50YXRpb24vY29yZS1h
cGkvY3B1X2hvdHBsdWcucnN0Og0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiAiVGhlIG5vZGUgbGlz
dCBhZGQvcmVtb3ZlIG9wZXJhdGlvbnMgYW5kIHRoZSBjYWxsYmFjayBpbnZvY2F0aW9ucw0KPiBh
cmUNCj4gPiA+ICA+ID4gc2VyaWFsaXplZCBhZ2FpbnN0IENQVSBob3RwbHVnIG9wZXJhdGlvbnMu
Ig0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiBGdXJ0aGVybW9yZSwgenN3YXBfW2RlXWNvbXByZXNz
KCkgY2Fubm90IGNvbnRlbmQgd2l0aA0KPiA+ID4gID4gPiB6c3dhcF9jcHVfY29tcF9wcmVwYXJl
KCkgYmVjYXVzZToNCj4gPiA+ICA+ID4NCj4gPiA+ICA+ID4gLSBEdXJpbmcgcG9vbCBjcmVhdGlv
bi9kZWxldGlvbiwgdGhlIHBvb2wgaXMgbm90IGluIHRoZSB6c3dhcF9wb29scw0KPiA+ID4gID4g
PiBsaXN0Lg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiAtIER1cmluZyBDUFUgaG90W3VuXXBsdWcs
IHRoZSBDUFUgaXMgbm90IHlldCBvbmxpbmUsIGFzIFlvc3J5IHBvaW50ZWQNCj4gPiA+ICA+ID4g
b3V0LiB6c3dhcF9jcHVfY29tcF9wcmVwYXJlKCkgd2lsbCBiZSBydW4gb24gYSBjb250cm9sIENQ
VSwNCj4gPiA+ICA+ID4gc2luY2UgQ1BVSFBfTU1fWlNXUF9QT09MX1BSRVBBUkUgaXMgaW4gdGhl
IFBSRVBBUkUgc2VjdGlvbg0KPiA+ID4gIG9mDQo+ID4gPiAgPiAiZW51bQ0KPiA+ID4gID4gPiBj
cHVocF9zdGF0ZSIuIFRoYW5rcyBZb3NyeSBmb3Igc2hhcmluZyB0aGlzIG9ic2VydmF0aW9uIQ0K
PiA+ID4gID4gPg0KPiA+ID4gID4gPiBJbiBib3RoIHRoZXNlIGNhc2VzLCBhbnkgcmVjdXJzaW9u
cyBpbnRvIHpzd2FwIHJlY2xhaW0gZnJvbQ0KPiA+ID4gID4gPiB6c3dhcF9jcHVfY29tcF9wcmVw
YXJlKCkgd2lsbCBiZSBoYW5kbGVkIGJ5IHRoZSBvbGQgcG9vbC4NCj4gPiA+ICA+ID4NCj4gPiA+
ICA+ID4gVGhlIGFib3ZlIHR3byBvYnNlcnZhdGlvbnMgZW5hYmxlIHRoZSBmb2xsb3dpbmcgc2lt
cGxpZmljYXRpb25zOg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiAxKSB6c3dhcF9jcHVfY29tcF9w
cmVwYXJlKCk6IENQVSBjYW5ub3QgYmUgb2ZmbGluZWQuIFJlY2xhaW0NCj4gY2Fubm90DQo+ID4g
PiAgPiB1c2UNCj4gPiA+ICA+ID4gdGhlIHBvb2wuIENvbnNpZGVyYXRpb25zIGZvciBtdXRleCBp
bml0L2xvY2tpbmcgYW5kIGhhbmRsaW5nDQo+ID4gPiAgPiA+IHN1YnNlcXVlbnQgQ1BVIGhvdHBs
dWcgb25saW5lLW9mZmxpbmUtb25saW5lOg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiBTaG91bGQg
d2UgbG9jayB0aGUgbXV0ZXggb2YgY3VycmVudCBDUFUncyBhY29tcF9jdHggZnJvbSBzdGFydCB0
bw0KPiA+ID4gID4gPiBlbmQ/IEl0IGRvZXNuJ3Qgc2VlbSBsaWtlIHRoaXMgaXMgcmVxdWlyZWQu
IFRoZSBDUFUgaG90cGx1Zw0KPiA+ID4gID4gPiBvcGVyYXRpb25zIGFjcXVpcmUgYSAiY3B1aHBf
c3RhdGVfbXV0ZXgiIGJlZm9yZSBwcm9jZWVkaW5nLCBoZW5jZQ0KPiA+ID4gID4gPiB0aGV5IGFy
ZSBzZXJpYWxpemVkIGFnYWluc3QgQ1BVIGhvdHBsdWcgb3BlcmF0aW9ucy4NCj4gPiA+ICA+ID4N
Cj4gPiA+ICA+ID4gSWYgdGhlIHByb2Nlc3MgZ2V0cyBtaWdyYXRlZCB3aGlsZSB6c3dhcF9jcHVf
Y29tcF9wcmVwYXJlKCkgaXMNCj4gPiA+ICA+ID4gcnVubmluZywgaXQgd2lsbCBjb21wbGV0ZSBv
biB0aGUgbmV3IENQVS4gSW4gY2FzZSBvZiBmYWlsdXJlcywgd2UNCj4gPiA+ICA+ID4gcGFzcyB0
aGUgYWNvbXBfY3R4IHBvaW50ZXIgb2J0YWluZWQgYXQgdGhlIHN0YXJ0IG9mDQo+ID4gPiAgPiA+
IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSB0byBhY29tcF9jdHhfZGVhbGxvYygpLCB3aGljaCBh
Z2FpbiwgY2FuDQo+ID4gPiAgPiA+IG9ubHkgdW5kZXJnbyBtaWdyYXRpb24uIFRoZXJlIGFwcGVh
ciB0byBiZSBubyBjb250ZW50aW9uIHNjZW5hcmlvcw0KPiA+ID4gID4gPiB0aGF0IG1pZ2h0IGNh
dXNlIGluY29uc2lzdGVudCB2YWx1ZXMgb2YgYWNvbXBfY3R4J3MgbWVtYmVycy4gSGVuY2UsDQo+
ID4gPiAgPiA+IGl0IHNlZW1zIHRoZXJlIGlzIG5vIG5lZWQgZm9yIG11dGV4X2xvY2soJmFjb21w
X2N0eC0+bXV0ZXgpIGluDQo+ID4gPiAgPiA+IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKS4NCj4g
PiA+ICA+ID4NCj4gPiA+ICA+ID4gU2luY2UgdGhlIHBvb2wgaXMgbm90IHlldCBvbiB6c3dhcF9w
b29scyBsaXN0LCB3ZSBkb24ndCBuZWVkIHRvDQo+ID4gPiAgPiA+IGluaXRpYWxpemUgdGhlIHBl
ci1DUFUgYWNvbXBfY3R4IG11dGV4IGluIHpzd2FwX3Bvb2xfY3JlYXRlKCkuIFRoaXMNCj4gPiA+
ICA+ID4gaGFzIGJlZW4gcmVzdG9yZWQgdG8gb2NjdXIgaW4genN3YXBfY3B1X2NvbXBfcHJlcGFy
ZSgpLg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiB6c3dhcF9jcHVfY29tcF9wcmVwYXJlKCkgY2hl
Y2tzIHVwZnJvbnQgaWYgYWNvbXBfY3R4LT5hY29tcCBpcw0KPiA+ID4gID4gPiB2YWxpZC4gSWYg
c28sIGl0IHJldHVybnMgc3VjY2Vzcy4gVGhpcyBzaG91bGQgaGFuZGxlIGFueSBDUFUNCj4gPiA+
ICA+ID4gaG90cGx1ZyBvbmxpbmUtb2ZmbGluZSB0cmFuc2l0aW9ucyBhZnRlciBwb29sIGNyZWF0
aW9uIGlzIGRvbmUuDQo+ID4gPiAgPiA+DQo+ID4gPiAgPiA+IDIpIENQVSBvZmZsaW5lIHZpcy1h
LXZpcyB6c3dhcCBvcHM6IExldCdzIHN1cHBvc2UgdGhlIHByb2Nlc3MgaXMNCj4gPiA+ICA+ID4g
bWlncmF0ZWQgdG8gYW5vdGhlciBDUFUgYmVmb3JlIHRoZSBjdXJyZW50IENQVSBpcyBkeXNmdW5j
dGlvbmFsLiBJZg0KPiA+ID4gID4gPiB6c3dhcF9bZGVdY29tcHJlc3MoKSBob2xkcyB0aGUgYWNv
bXBfY3R4LT5tdXRleCBsb2NrIG9mIHRoZQ0KPiA+ID4gIG9mZmxpbmVkDQo+ID4gPiAgPiA+IENQ
VSwgdGhhdCBtdXRleCB3aWxsIGJlIHJlbGVhc2VkIG9uY2UgaXQgY29tcGxldGVzIG9uIHRoZSBu
ZXcNCj4gPiA+ICA+ID4gQ1BVLiBTaW5jZSB0aGVyZSBpcyBubyB0ZWFyZG93biBjYWxsYmFjaywg
dGhlcmUgaXMgbm8gcG9zc2liaWxpdHkgb2YNCj4gPiA+ICA+ID4gVUFGLg0KPiA+ID4gID4gPg0K
PiA+ID4gID4gPiAzKSBQb29sIGNyZWF0aW9uL2RlbGV0aW9uIGFuZCBwcm9jZXNzIG1pZ3JhdGlv
biB0byBhbm90aGVyIENQVToNCj4gPiA+ICA+ID4NCj4gPiA+ICA+ID4gLSBEdXJpbmcgcG9vbCBj
cmVhdGlvbi9kZWxldGlvbiwgdGhlIHBvb2wgaXMgbm90IGluIHRoZSB6c3dhcF9wb29scw0KPiA+
ID4gID4gPiBsaXN0LiBIZW5jZSBpdCBjYW5ub3QgY29udGVuZCB3aXRoIHpzd2FwIG9wcyBvbiB0
aGF0IENQVS4gSG93ZXZlciwNCj4gPiA+ICA+ID4gdGhlIHByb2Nlc3MgY2FuIGdldCBtaWdyYXRl
ZC4NCj4gPiA+ICA+ID4NCj4gPiA+ICA+ID4gUG9vbCBjcmVhdGlvbiAtLT4genN3YXBfY3B1X2Nv
bXBfcHJlcGFyZSgpDQo+ID4gPiAgPiA+IC0tPiBwcm9jZXNzIG1pZ3JhdGVkOg0KPiA+ID4gID4g
PiAqIENQVSBvZmZsaW5lOiBuby1vcC4NCj4gPiA+ICA+ID4gKiB6c3dhcF9jcHVfY29tcF9wcmVw
YXJlKCkgY29udGludWVzDQo+ID4gPiAgPiA+IHRvIHJ1biBvbiB0aGUgbmV3IENQVSB0byBmaW5p
c2gNCj4gPiA+ICA+ID4gYWxsb2NhdGluZyBhY29tcF9jdHggcmVzb3VyY2VzIGZvcg0KPiA+ID4g
ID4gPiB0aGUgb2ZmbGluZWQgQ1BVLg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiBQb29sIGRlbGV0
aW9uIC0tPiBhY29tcF9jdHhfZGVhbGxvYygpDQo+ID4gPiAgPiA+IC0tPiBwcm9jZXNzIG1pZ3Jh
dGVkOg0KPiA+ID4gID4gPiAqIENQVSBvZmZsaW5lOiBuby1vcC4NCj4gPiA+ICA+ID4gKiBhY29t
cF9jdHhfZGVhbGxvYygpIGNvbnRpbnVlcw0KPiA+ID4gID4gPiB0byBydW4gb24gdGhlIG5ldyBD
UFUgdG8gZmluaXNoDQo+ID4gPiAgPiA+IGRlLWFsbG9jYXRpbmcgYWNvbXBfY3R4IHJlc291cmNl
cw0KPiA+ID4gID4gPiBmb3IgdGhlIG9mZmxpbmVkIENQVS4NCj4gPiA+ICA+ID4NCj4gPiA+ICA+
ID4gNCkgUG9vbCBkZWxldGlvbiB2aXMtYS12aXMgQ1BVIG9ubGluaW5nOg0KPiA+ID4gID4gPiBU
aGUgY2FsbCB0byBjcHVocF9zdGF0ZV9yZW1vdmVfaW5zdGFuY2UoKSBjYW5ub3QgcmFjZSB3aXRo
DQo+ID4gPiAgPiA+IHpzd2FwX2NwdV9jb21wX3ByZXBhcmUoKSBiZWNhdXNlIG9mIGhvdHBsdWcg
c3luY2hyb25pemF0aW9uLg0KPiA+ID4gID4gPg0KPiA+ID4gID4gPiBUaGlzIHBhdGNoIGRlbGV0
ZXMNCj4gYWNvbXBfY3R4X2dldF9jcHVfbG9jaygpL2Fjb21wX2N0eF9wdXRfdW5sb2NrKCkuDQo+
ID4gPiAgPiA+IEluc3RlYWQsIHpzd2FwX1tkZV1jb21wcmVzcygpIGRpcmVjdGx5IGNhbGwNCj4g
PiA+ICA+ID4gbXV0ZXhfW3VuXWxvY2soJmFjb21wX2N0eC0+bXV0ZXgpLg0KPiA+ID4gID4NCj4g
PiA+ICA+IEkgYW0gbm90IHN1cmUgd2h5IGFsbCBvZiB0aGlzIGlzIG5lZWRlZC4gV2Ugc2hvdWxk
IGp1c3QgZGVzY3JpYmUgd2h5DQo+ID4gPiAgPiBpdCdzIHNhZmUgdG8gZHJvcCBob2xkaW5nIHRo
ZSBtdXRleCB3aGlsZSBpbml0aWFsaXppbmcgcGVyLUNQVQ0KPiA+ID4gID4gYWNvbXBfY3R4Og0K
PiA+ID4gID4NCj4gPiA+ICA+IEl0IGlzIG5vIGxvbmdlciBwb3NzaWJsZSBmb3IgQ1BVIGhvdHBs
dWcgdG8gcmFjZSBhZ2FpbnN0IGFsbG9jYXRpb24gb3INCj4gPiA+ICA+IHVzYWdlIG9mIHBlci1D
UFUgYWNvbXBfY3R4LCBhcyB0aGV5IGFyZSBvbmx5IGFsbG9jYXRlZCBvbmNlIGJlZm9yZSB0aGUN
Cj4gPiA+ICA+IHBvb2wgY2FuIGJlIHVzZWQsIGFuZCByZW1haW4gYWxsb2NhdGVkIGFzIGxvbmcg
YXMgdGhlIHBvb2wgaXMgdXNlZC4NCj4gPiA+ICA+IEhlbmNlLCBzdG9wIGhvbGRpbmcgdGhlIGxv
Y2sgZHVyaW5nIGFjb21wX2N0eCBpbml0aWFsaXphdGlvbiwgYW5kIGRyb3ANCj4gPiA+ICA+IGFj
b21wX2N0eF9nZXRfY3B1X2xvY2soKS8vYWNvbXBfY3R4X3B1dF91bmxvY2soKS4NCj4gPiA+DQo+
ID4gPiAgSGkgWW9zcnksDQo+ID4gPg0KPiA+ID4gIFRoYW5rcyBmb3IgdGhlc2UgY29tbWVudHMu
IElJUkMsIHRoZXJlIHdhcyBxdWl0ZSBhIGJpdCBvZiB0ZWNobmljYWwNCj4gPiA+ICBkaXNjdXNz
aW9uIGFuYWx5emluZyB2YXJpb3VzIHdoYXQtaWZzLCB0aGF0IHdlIHdlcmUgYWJsZSB0byBhbnN3
ZXINCj4gPiA+ICBhZGVxdWF0ZWx5LiBUaGUgYWJvdmUgaXMgYSBuaWNlIHN1bW1hcnkgb2YgdGhl
IG91dGNvbWUsIGhvd2V2ZXIsDQo+ID4gPiAgSSB0aGluayBpdCB3b3VsZCBoZWxwIHRoZSBuZXh0
IHRpbWUgdGhpcyB0b3BpYyBpcyByZS12aXNpdGVkIHRvIGhhdmUgYSBsb2cNCj4gPiA+ICBvZiB0
aGUgIndoeSIgYW5kIGhvdyByYWNlcy9VQUYgc2NlbmFyaW9zIGFyZSBiZWluZyBjb25zaWRlcmVk
IGFuZA0KPiA+ID4gIGFkZHJlc3NlZCBieSB0aGUgc29sdXRpb24uIERvZXMgdGhpcyBzb3VuZCBP
az8NCj4gPiA+DQo+ID4gPiAgSG93IGFib3V0IHVzaW5nIHRoZSBzdW1tYXJpemVkIHZlcnNpb24g
aW4gdGhlIGNvbW1pdCBsb2cgYW5kIGxpbmtpbmcgdG8NCj4gPiA+ICB0aGUgdGhyZWFkIHdpdGgg
dGhlIGRpc2N1c3Npb24/DQo+ID4gPg0KPiA+IFNlZW1zIGxpa2UgY2FwdHVyaW5nIGp1c3QgZW5v
dWdoIGRldGFpbCBvZiB0aGUgdGhyZWFkcyBpbnZvbHZpbmcgdGhlDQo+ID4gZGlzY3Vzc2lvbnMs
IGluIHRoaXMgY29tbWl0IGxvZyB3b3VsZCBiZSB2YWx1YWJsZS4gQXMgYWdhaW5zdCByZWFkaW5n
IGxvbmcNCj4gPiBlbWFpbCB0aHJlYWRzIHdpdGggaW5kZW50YXRpb25zLCBhcyB0aGUgc29sZSBy
ZXNvdXJjZSB0byBwcm92aWRlIGNvbnRleHQ/DQo+ID4NCj4gDQo+IElmIHlvdSBmZWVsIHN0cm9u
Z2x5IGFib3V0IGl0IHRoZW4gc3VyZSwgYnV0IHRyeSB0byBrZWVwIGl0IGFzIGNvbmNpc2UgYXMg
cG9zc2libGUsDQo+IHRoYW5rcy4NCg0KU3VyZSwgd2lsbCBkbywgdGhhbmtzIQ0KDQo=

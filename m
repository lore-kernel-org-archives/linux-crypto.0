Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26BC1F5842;
	Fri,  3 Oct 2025 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759518662; cv=fail; b=iClIto4qOGVXzCa6rHX0c753QWxJkw50K94pe9N+BG+2tBUKmdZdwX9kA4WotDW4vN4jV189ZjSQ9cmxGQkvWrEu7Z90pTMDoqQ9/PMWyStVlpyXokEFCwqy+nshfGKDYQbK1vM23pUetMHIGC7ZE+J9lWAqrnGj/FrNYVnJEbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759518662; c=relaxed/simple;
	bh=QbQHGvSLzgoCNMnJqPex8bXVNWc1BPJM3utNYamGmII=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DDMG+T+IMdpVRsdGbAlx08Yf43JQQPGHBwUld0q/DxZX1lW9AL2t8TMPvD/YhtbsyarH4AjhUq3GajUoQePQp/fDkG0II+Rwv89IdmgL8RcMr0Ov1DP1DkEzCScCsi+igkwJjcG1YwBGVxoVMrnYdXCDb65/NBNg2OY1994UxlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Umupv2hT; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Umupv2hT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759518660; x=1791054660;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QbQHGvSLzgoCNMnJqPex8bXVNWc1BPJM3utNYamGmII=;
  b=Umupv2hTHlrFi588lFjnnUGlU96yhxZNMw9D//RAGi2fn3zJWCzIG4+P
   4ujFLu1P633y7tM/r7Oyp9BTBLnyrvOXypr5NsuZmfdsesigjtdM2TTOe
   OsYKViD7lFFulV0IS1X36drQqQvOr26rx6RYuFPbHgc1EZ1ZJCDTlrUN/
   t/JB6jsTtPU9hqAqG42Bidh7reup1MZPVLSqqDellymxlgyCgcqZAJMdW
   5qWZESLlNc1l/mce9mE9sQ6pu1BRIrADuNkJklJgBJWjEvJOipj7hJndx
   JbI2lVdjHeSfpzrTVaEeDFX+W1Aof3Q3md8g4Dp02zCCLwCko0R6f1Zkp
   g==;
X-CSE-ConnectionGUID: u2lGUBiDSjaVcyXqKflDZg==
X-CSE-MsgGUID: cvFEXsfxSnSMZyvEiiCU7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="65445597"
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="65445597"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 12:10:58 -0700
X-CSE-ConnectionGUID: 8a82kJ8URai01CEDgoPy1w==
X-CSE-MsgGUID: IjJdfio1TKKqDg/NzXhs/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="179782426"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 12:10:58 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 12:10:57 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 12:10:57 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.39) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 12:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P27Z2Mj1dUqyjbJZB3qRAoLSHdEGcPrdljA/m6pAQlDtTZYFUBZKByeyDPNug+rKg0IqHnRDBIm5MBP1dRSn3oECGY/poNaNGhZ88T11bsG2nKU6//Ic8Jg81tlc9gPouYtmsYfFdPP9pQbIlF0UsMZr0G3mzTPR8IEsmKVzYi9bnlZWCCEUkSAzkUMk0nnAVl+3ZEdP0OCd6hFabRy7jCOUBCbEsoZ8vXB/9kd8VGQ5R1omVXJIeKoeJgLeUwzsY5PV3kiBg54Y6Ykqmb0IsbBDnItyhUJSKgMbQint5r7LjPGJ/3+Q0Q4gXQgN+i5MP7Zts3/utdOUVatw+swQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aV4IFuRqSEWExv6pDFgPPDW+2ZC5816E/JhtmhYZzTE=;
 b=Ymoi6DLv3qlSwjYovrRt0tyv9kA79wmFtC9ynPLVBvQaalkyTuGO+crhYzbDSkl/gaCA1HgvMWeRZbNwxPZPjZDu+UlnQADkGTLzUxHZElxWN1EF5yzegNfSHuG7UTvfCxnhB8Bk/3TQUg/4DFmsOwX5QhTgnZOGzMfK7fCaUsQMOmW10MKT377IhVGJE9MdbLwtmSlz9BgYhhlpqxnKWMQ8OMSkxlC6JDK7Bma4lwQBq8zkQGwpuXr7CWOSNQjxrh+hQldnYRlqAK1BlogvmRYVONIO+6mNFR6pNGSB9NWeuSUNR06Z9jOJc9VwXSywssA0/1D42164cVLXXTyezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 19:10:49 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 19:10:49 +0000
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
Subject: RE: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Topic: [PATCH v12 22/23] mm: zswap: zswap_store() will process a large
 folio in batches.
Thread-Index: AQHcLpaY70ekQ7dio0CIg97nnm1fBLStgQgAgAAW5fCAAzXpkA==
Date: Fri, 3 Oct 2025 19:10:49 +0000
Message-ID: <PH7PR11MB812152287E850FA7CBAE2FD5C9E4A@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-23-kanchana.p.sridhar@intel.com>
 <2qvfjavbepw3sq2pvvcez6jsc3bxkxej27674l4ztfdza7jqaq@xi6qndkj5xhh>
 <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB81216AEDFD10B5BDCBCE1F19C9E6A@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|SJ0PR11MB4894:EE_
x-ms-office365-filtering-correlation-id: 8be8ac64-c6ea-4cf9-93b9-08de02b090a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?kAznOBSy3ycHmGEPcSigALt+E8Fwlfewui5WUPrPj8sC0susyrq7pRDNYS?=
 =?iso-8859-1?Q?YhkVFJQdKYjAwsQEOmtJ0Fz/jj93bpyTYid1HWKWP20zyHOCjH30FKhcBn?=
 =?iso-8859-1?Q?7eWckfiPaUw1Fu4/vY6CEzkT2wpq1EmU6wyYgfUPfDcswLjlG49HwqTI+b?=
 =?iso-8859-1?Q?JQfIAezKzdffgpWt9PrG1j+WeksgnmW0lBa89iZV/rWcRtoAleVz22hwdg?=
 =?iso-8859-1?Q?3HRhJYEEHQknZdvVJDF6v2oaKA1l71RIFDtd4bf2/ryXMIKeo7hThQDawS?=
 =?iso-8859-1?Q?wORp3S/nTZS1TGjcHXyha4+qum5dwjuLORHFgcKFSpgPnF94edR5AI/sib?=
 =?iso-8859-1?Q?5JkZCFa6KYDUDUTqooTDbwOWTmRfZ7iJvU/MNkhjRAUNes+kFRrJp/XFjE?=
 =?iso-8859-1?Q?G7ae57KPYJrXVhj405rLk9WrH6kS3tVWX7aDwptaznUowbv3HIEyO8rBFg?=
 =?iso-8859-1?Q?K2qay2QSTt6L6VNeiPsLCzcT5I6YT9DVw+D/JeAg/LJ27qz29egJWx+TPC?=
 =?iso-8859-1?Q?bWJfGAuFzulkexxACWqNj27nJFpmKGEgF1WEALTa1ygJKgvPJ2fMssOzEb?=
 =?iso-8859-1?Q?JN6tblL+ImbE5etphNt5YuyAaKR09Y4hfeznaE36F3TZjVbj5Kk2xiGFrr?=
 =?iso-8859-1?Q?I78a/SCS8/XLy1J2eRdHf3Zq/OcmeMPWOnuSItf6omUdSPSXLhI9tIBbcg?=
 =?iso-8859-1?Q?+IKcP95O/zCP3XkbEVe/4DqKPUj+CkEnlJfQWtD17wo68w9SRvhfZVJVic?=
 =?iso-8859-1?Q?lAfRIpJCFQnWzHlIpJAK5QG9EzZsHsLiQTHlhTojSpz+c4jUy97sUbO2lX?=
 =?iso-8859-1?Q?ZLMfJ1GX6RGjoynbheAeA+ZOAF7aFItIR+yge+jJpij8gXXwmswvJN9/YP?=
 =?iso-8859-1?Q?9l+o2o17MKc1gwk/QOBl0jLtA4aF8iGOMceGTltPNfqh6gu1kcqNqKSWcL?=
 =?iso-8859-1?Q?K+OIvX4Tjs9AvJ7kZQwAEaKZvQ75ZQdAeGgsgy8g3+5HNgOvtQw8JQq4j3?=
 =?iso-8859-1?Q?IqdhYfOjsDD+xNKSY1JOpJWN4SX+QG9+UixEmLaN9UxbTP1dOBFx+r14q2?=
 =?iso-8859-1?Q?dh6Ny/yiFKfPM7OmUtXlI7kCCPF7OwI9OPWUC7Wv+nGounniMXQ1G2gqZe?=
 =?iso-8859-1?Q?TuUOLs1c68Us15/yanyTGe7FMIpZAZEgXr6Vl8L1qrP7qhKQDiYIPVzO6+?=
 =?iso-8859-1?Q?9AtnEAu5ZVTjAIcq9hLswrmnGoMtbTJTNF96WUrbGuJxFlO5DHYEe+PpEs?=
 =?iso-8859-1?Q?0ns35a+THIlXKlRxmSGrRaRVicTBZSU3i93Bw1wA1wFq5KmU9OOp4zeuG0?=
 =?iso-8859-1?Q?xqMoHDrtghWXK+BGDXhvCA/ImfF6pDOIWW6QfJFjcTao+i1HlUdFLx/LCW?=
 =?iso-8859-1?Q?8cCMq4Qe94gjcX+0LvhM0HpCRCOuP5KDkWiHhFnlotCdtJh73rFfYzcbX8?=
 =?iso-8859-1?Q?nIHICykanXITLmRd4eL4pcYdyGIncOteRMtityzeMHITG+bA2J3UQSvhIb?=
 =?iso-8859-1?Q?aophoM/hE/d0QRuEsGmTr+6y2c3IM/xxtpqsazxKxtLqzclFtrHRD32NZJ?=
 =?iso-8859-1?Q?F/1/OeUPM/bv2BEszCRXAsF1nJd6?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?PsVBPQ+LcbT50YIPVTYFNEzYDCmgGYGiXFBmzZzKF7dadgVCs7MyVyxIWt?=
 =?iso-8859-1?Q?ZEn62Vr/5p9wfgJOAPffmmgJ9NQvUTZSTLKWg6g6zDNK792kc3wHEH9Xoh?=
 =?iso-8859-1?Q?k3KY2PwkU4MAbUA23vdenceQnMulnOnmQzcaT+as5F6bQryJX7ujeAfdE7?=
 =?iso-8859-1?Q?xuTVApOLAwsC9sDzCyLddLSQiGBTDqeIZ8tBa4XgFMO7LoodX7qbaYWvX7?=
 =?iso-8859-1?Q?6nd3Lu6i05AuVZs3t4z5CEgWlHk43hEiguT2X/7ZFDh4J37JPf7k/817g5?=
 =?iso-8859-1?Q?PXEa7odnI9/mC/cr/aVXTdghtJGSHknvWf6x6sVsLP2Iul0hmoprnNeCNj?=
 =?iso-8859-1?Q?N+J38zcSbbnNr1Zmx2LfIfegBjSI5ijZxsj1yAch8UPFFqcDUFY4xkje2s?=
 =?iso-8859-1?Q?OO26oV4+0NJ3xJ81PFr0XN7s9sStFNWUZNvW3cUhVZGm9X5oPQpct0NQ7n?=
 =?iso-8859-1?Q?BgcXMgNVZbE79bIg7YTDyQ2y8f32fXkoJuUQpJJdbczX2s3CLHROLY0/m2?=
 =?iso-8859-1?Q?I7gKyyLY242aQOtY16U7su7at1HY8Xz6/dhwBLPyxP56a8pkHAnjT9+qiW?=
 =?iso-8859-1?Q?Q1SN6BzVTjliaO8O7eGnWZi0LqZ26UJ0VzlF4McI7V42DO54w2xp+ViZ58?=
 =?iso-8859-1?Q?+MGUZj6TkY040DzyPGF+8hSG4sLRI/cwwZwcN0DZjrDzmLdxK9QbI761FW?=
 =?iso-8859-1?Q?3qaSjpPzg8PNwpI7uWnqF1F8QRO3J8jud+rFgu44lTtnqX/7SLkMlldBLs?=
 =?iso-8859-1?Q?Z3wMpD0uL22aoueG5UhZb3U46dXI/MEM4Dn+cueMQ+2M7q0AGrSQ/RU+fn?=
 =?iso-8859-1?Q?tFG+iLMC3HKbSV6rAXZljKIYH4TNjRvLSzvNdgoJ3ymCDT3HvcGd4AoY6M?=
 =?iso-8859-1?Q?Ia6Z08VT88OiJ0nhYQCIbgeaTYMODKjSFBJp5YXfcXK+vFmQb53msSaVGh?=
 =?iso-8859-1?Q?hRAjJtVKiZTwRnEvYJm98NeL8EFp8vFBOAGglUwA5qz81IiG+IWN3TbG/i?=
 =?iso-8859-1?Q?rZimk78uMGbHdOwjbzn1SY4iw+XyhFATKCpOxY6ymCyRL7UqhgnamZbHcn?=
 =?iso-8859-1?Q?vMZwvomhaVFx0jcmdC5/FL+0GFtZqmz3pC0uHKNm/R4NmGIFu+JjyJX7Xl?=
 =?iso-8859-1?Q?Z/FJHHCtGwkPzpgEEwbsJ9EfzJv/beoWaA8FU4HU2fWWI0dDEYkFyvsXGl?=
 =?iso-8859-1?Q?yptNTR/fyss4oFk9+2ZzM+td8dtlG9WJ0fUL+cut6VDADlzsGOj/iKjigZ?=
 =?iso-8859-1?Q?ZoKCUhkAp6pKobu6if9p7RnOVO9jnQJXCwdSNoHnP+Gwn2CYyfVV5hYSWM?=
 =?iso-8859-1?Q?nB9X5TdmNDRgpa9ViaTc82bDzks/tHjafsnvCbz0LfM0uyR4ct8SyaleGO?=
 =?iso-8859-1?Q?jfvgDxzf7C2tqfx1FCSdNlrj/4ZpneSrf514i3IPkm6QN+FvBCd+3Rod2b?=
 =?iso-8859-1?Q?imolTHVx3h9ZDkTAFjRO9Ze99R+ZYIzt60Q5m+my5potKhEpNL4JwDsa1h?=
 =?iso-8859-1?Q?nG7HUMrbAuJ7hPlY0+PmgHb3aV0jJL9TymViOiKRzvzutQ7H0BG+QwsUKB?=
 =?iso-8859-1?Q?ytJJ25fkM9F0AeYZVKUR0i2JIn9G1IQH6cLgFcswe3UA/rjinGKeJoqvFU?=
 =?iso-8859-1?Q?j/sE+aXCrPF7aVBwsMjY5UKgyGqD2pLB3oZv6luDRQm3+Z0nUHqcLZeg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be8ac64-c6ea-4cf9-93b9-08de02b090a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2025 19:10:49.6714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OB72qpas4Dk09qjFbnlu511toybIW4wpaq3c280ra1KRwJtgNyNJde3itUq62Cp47CRqiggCcjqne+vhciQoRLbmtw9150AAQwaMY8e5gOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
X-OriginatorOrg: intel.com


> > -----Original Message-----
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> > Sent: Wednesday, October 1, 2025 9:19 AM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> > ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> > senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> > crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> > davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> > ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> > <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>;
> > Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> > <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v12 22/23] mm: zswap: zswap_store() will process a
> > large folio in batches.
[...]
> >
> > > + */
> > > +static __always_inline int zswap_entries_cache_alloc_batch(void
> > **entries,
> > > +							   unsigned int
> > nr_entries,
> > > +							   gfp_t gfp)
> > > +{
> > > +	return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries,
> > entries);
> >
> > We currently use kmem_cache_alloc_node() in zswap_entry_cache_alloc()
> to
> > allocate the entry on the same node as the compressed page. We use
> > entry_to_nid() to get the node for LRU operations.
> >
> > This breaks that assumption.
>=20
> You bring up a good point. I was looking at the code in slub.c and my
> understanding thus far is that both, bulk allocations and
> kmem_cache_alloc_node()
> allocations are made from a per-CPU "cpu_slab" that is allocated by SLUB.
>=20
> IIUC, the concern you are raising is in the mainline, the entry is alloca=
ted on
> the same node as the compressed page, and gets added to the LRU list of t=
hat
> node. IOW, the node to which the compressed page belongs is the one to
> whose
> LRU the entry will be added.
>=20
> With this patch, with kmem_cache_alloc_bulk(), the entry will be created =
on
> the per-CPU slab of the CPU on which zswap_store() is called and will be
> added to the LRU of that per-CPU slab's NUMA node. Hence, the end result
> could potentially be that the zswap_entry for a page could potentially be
> on a different NUMA node/memcg than the page's NUMA node.
>=20
> This is my thinking as to how this will impact the zswap shrinker:
>=20
> 1) memcg shrinker: if the memcg the entry ends up in is on the zswap_list=
_lru,
>     the entry will be written back.
> 2) Global shrinker: will cycle through all memcg's that have pages in the
>     zswap_list_lru, and the entry will be written back.
>=20
> Based on this, it is not clear to me if there is a problem, and would lik=
e to
> request you, Nhat and others to provide insights as well.
>=20
> Interestingly, most of the code in slub.c has unlikely(!node_match(slab,
> node)).
> Does this imply some higher level mm slab allocation requirements?
>=20
> I am Ok with just calling zswap_entry_cache_alloc() for "nr_pages" if we
> think this would be more correct.

I wanted to share some updates and summarize my understanding from
looking some more at slub.c. The "zswap_entry_cache" kmem_cache
has slab memory created for each node. The main change with v12 is:

before:
The page being compressed and its zswap_entry are in the same memcg,
thus, implicitly on the same slab node.

v12:
The page being compressed and its zswap_entry could be in different
memcgs if the process that owns the page gets migrated to a different
node.

Impact to zswap LRU list vis-=E0-vis the memcg shrinker:

before:
The original NUMA node memcg [hierarchy] would need to face memory
pressure for the page's zswap_entry to be written back. Hence it is possibl=
e
that the node on which the process is currently running may not see the
benefit of memory being freed up.

v12:
The memcg whose node on which the process was running when the page
was compressed would have to face memory pressure for the page's zswap_entr=
y
to be written back. This node will see the benefit of memory being freed up=
 due
to writeback. If the process has migrated to a different node than the one
on which it was running when the page was compressed, we have the same issu=
e
as "before".

Is my understanding correct? Please let me know if I am missing something.

The bulk allocation does improve batching performance, especially with 64K =
folios:

 kernel_compile, 64K folios, deflate-iaa:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
           mm-unstable-9-18-2025              v12     without bulk alloc/fr=
ee
 --------------------------------------------------------------------------=
----
 real_sec           874.74                 821.59       870.82
 sys_sec          3,834.35               3,791.12     3,794.06
 --------------------------------------------------------------------------=
----
                       =20
 kernel_compile, 64K folios, zstd:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
           mm-unstable-9-18-2025              v12     without bulk alloc/fr=
ee
 --------------------------------------------------------------------------=
----
 real_sec           925.08                 853.14       899.40
 sys_sec          5,318.65               5,172.23     5,415.20
 --------------------------------------------------------------------------=
----
                       =20
 kernel_compile, PMD folios, deflate-iaa:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
           mm-unstable-9-18-2025              v12     without bulk alloc/fr=
ee
 --------------------------------------------------------------------------=
----
 real_sec           808.10                 794.85       809.33
 sys_sec          4,351.01               4,266.95     4,169.07
 --------------------------------------------------------------------------=
----
                       =20
 kernel_compile, PMD folios, zstd:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
           mm-unstable-9-18-2025              v12     without bulk alloc/fr=
ee
 --------------------------------------------------------------------------=
----
 real_sec           848.06                 845.42       836.06
 sys_sec          5,898.58               5,741.31     5,795.75
 --------------------------------------------------------------------------=
----

Based on this, and if my understanding of the v12 change's impact on the
zswap shrinker is correct, I am not sure if the change in the assumption
is necessarily a concern.

>=20
> >
> > > +}
> > > +
> > > +static __always_inline void zswap_entries_cache_free_batch(void
> > **entries,
> > > +							   unsigned int
> > nr_entries)
> > > +{
> > > +	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> > > +}
[...]
> > > +static bool zswap_store_pages(struct folio *folio,
> > > +			      long start,
> > > +			      long end,
> > > +			      struct obj_cgroup *objcg,
> > > +			      struct zswap_pool *pool,
> > > +			      int node_id,
> > > +			      bool folio_wb)
> > >  {
> > > -	swp_entry_t page_swpentry =3D page_swap_entry(page);
> > > -	struct zswap_entry *entry, *old;
> > > -
> > > -	/* allocate entry */
> > > -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> > > -	if (!entry) {
> > > -		zswap_reject_kmemcache_fail++;
> > > -		return false;
> > > +	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> > > +	u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> > > +
> > > +	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
> > > +
> > > +	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
> > > +						      nr_pages, GFP_KERNEL)))
> > {
> > > +		for (i =3D 0; i < nr_pages; ++i) {
> > > +			entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL,
> > node_id);
> > > +
> > > +			if (unlikely(!entries[i])) {
> > > +				zswap_reject_kmemcache_fail++;
> > > +				/*
> > > +				 * While handling this error, we only need to
> > > +				 * call zswap_entries_cache_free_batch() for
> > > +				 * entries[0 .. i-1].
> > > +				 */
> > > +				nr_pages =3D i;
> > > +				goto store_pages_failed;
> > > +			}
> >
> > Is it okay to use kmem_cache_free_bulk() to free slab objects that were
> > not allocated with kmem_cache_alloc_bulk()?
>=20
> I recall verifying that it should be Ok, but can check again.
>=20

I verified the code again, and yes, it is Ok for slab objects allocated by
either kmem_cache_alloc_bulk() or kmem_cache_alloc_node() to be
freed by calling kmem_cache_free_bulk(). kmem_cache_free_bulk()
opportunistically looks to create freelists from the list of slab objects
to then "bulk transfer" them to the slab's freelists, with optimizations
in synchronization as compared to calling kmem_cache_free().

I verified this with usemem30 with the following code change in
zswap_store_pages(), and saw no issues with deflate-iaa/zstd:

for each of nr_pages: kmem_cache_alloc_node()

kmem_cache_free_bulk()

kmem_cache_alloc_bulk()

kmem_cache_free_bulk()

kmem_cache_alloc _bulk()

[proceed]

Yosry, please let me know how I should proceed and if there are
other experiments that I can run to verify this change to bulk alloc/free
to address any concerns.

Thanks,
Kanchana


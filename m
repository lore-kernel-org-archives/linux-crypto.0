Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE515539A;
	Fri, 22 Aug 2025 22:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755900066; cv=fail; b=GgZVjGpDI+YKCQdsbADiJzHjCcLvuJrJQxNX8fiLm3P1lhIxZOPnT2UuCxRAYENA/8o9RrTDJ+I9tZ4+LsSbSwpAi6uJ4vnoeTR+KLMOiSp4oG3s+EKOvd6ZqiwSxM6gguAqgGtvIj9MENrbuwsI8WIJ6h5s1W0C2qyKyeVoKX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755900066; c=relaxed/simple;
	bh=iRojhzOf304ggx1B6oSF1aaZzD8m1nYGpo6g3U3BWcY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oeh7cRR364GnKncsbeqrtqf118LECRGHI5ujxMC4Cenu9NEiLx7UsNzRTBYpCVXKKFLXgPS+9u7Q8Qr/gD7zUIBubpwr1/cTpeQNDX/luBXxnAIU2MGRApdCwf2j9AT8KHWfnZf032aV4owJkK7gx/0gVaoJyMkvWEcUzkI8Wig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jjGGtFk5; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jjGGtFk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755900064; x=1787436064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iRojhzOf304ggx1B6oSF1aaZzD8m1nYGpo6g3U3BWcY=;
  b=jjGGtFk5FIe3XBEJuzERPGi9+v6leWJTCVBl17LjoOj3HMBNEKS0CbwP
   UNSLlbVk3TbmI98q87+MGlWji1F2R0oNLR0iS+6jmGjbBWPAS8PTyJ4R+
   /WgQjZaJdet+wbCpo1rUKbqHFeg1h7be3XKxEnmiBeRzM3GzqqxF5L8uT
   x5eXeU7Q+GKTSc11XHYS4rDzb5kZq4x16ID51coxpBoXq1qUzzyRfrMOH
   NNFq/XjYRRegp080TBizwAXObxtIrLjJi2mRCknDH9UEI3YCI4j38rips
   +XzE1mjtdwIGle+hzkDvZbCtm7oXzIq6TWhjhGaSmZ8yZMKxkvMCwSX1y
   Q==;
X-CSE-ConnectionGUID: 6wgK42AYQRO/jcngRb3LIQ==
X-CSE-MsgGUID: jvbgklSQTPWKsbrBE+ATKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58359623"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58359623"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 15:01:03 -0700
X-CSE-ConnectionGUID: OhtYmx+MTi6l4XQKGq4L+Q==
X-CSE-MsgGUID: uzk0zS72RpWbtfiT2VDUbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="192464957"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 15:01:03 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 15:01:02 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 15:01:02 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 15:01:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uw8UBIKfkmot+qDkmRaXiQrnVI7d+C3NhOXAYLSZ7OPFZJKc2dUNieBEIBIHEQhd6IP8ZmH4k3xc69UvqfDIoCifu4BYElT4t6Hwr+W+tn4We3dMjr05JZwXtjc57Y57O64ZpYUroZav/qnF/pyE/58KIIEBELHllpIkGlI5sTImumzIrmjr1M3Ii/3sEwQMpC8CMdZtrCFLmFOMvnLG+JfCrZ0tDLw5Gz+sr2yNQJys8AW82tm97QeivX4wC2OnGW4Q4ynr5jcnoZMZGJ5CbD2ySsbd4FA944rnDkoiBQ2mqTC1jN1NTbF2S1eFqfcHbXpcWdRsIo3SCHFU5B6uGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRojhzOf304ggx1B6oSF1aaZzD8m1nYGpo6g3U3BWcY=;
 b=QE8abGv2gbdZvtAJktWqoumdExddl0gkOsQoI0ybu0EHAdHqZptyQTMS5ku+xROkAKeSDEgilNYRUEMHG/50koGL3Kgcr2S39YIoR5QRXTy6kbOWXhLpWanIee8dQF2skjx0tVi45n69fv/p+wk+wtE8T61ewWenbgnMmAAuAEvSfLVuAB7fIAtwMvt8dUE2wvDH37eeNXGOsoS+ugDqAi9mqsXVrTVIw9YVmOPjXDo2GLNL7YpWj9odoj2RMeVZ+DUoI6khIS/AWTAfPfJo0sIQyZNINTu1aCxZv+Pj7zx6bz22xhC/AKEZbmQXEIWkAF983BTQsx9+uxUqoknZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB8121.namprd11.prod.outlook.com (2603:10b6:510:234::14)
 by BL3PR11MB6530.namprd11.prod.outlook.com (2603:10b6:208:38d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 22:00:58 +0000
Received: from PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab]) by PH7PR11MB8121.namprd11.prod.outlook.com
 ([fe80::ec4e:64cf:cf1f:daab%7]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 22:00:57 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Nhat Pham <nphamcs@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>, "chengming.zhou@linux.dev"
	<chengming.zhou@linux.dev>, "usamaarif642@gmail.com"
	<usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Topic: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Thread-Index: AQHcAp3rrlgug3tz+EGLnem5m/WFabRjRbuAgAvqfqCAACeGgIAAAnOAgAAArHA=
Date: Fri, 22 Aug 2025 22:00:57 +0000
Message-ID: <PH7PR11MB81211503875939D2FAFDAED4C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
 <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
 <PH7PR11MB81210ABFD0BF9F73214080E8C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAKEwX=M2HCsPZVmXpvpAuF2N=4BXbXAMQMrLLRp7nCdotb=abA@mail.gmail.com>
 <PH7PR11MB8121E83F0EBE9BEF5F777466C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121E83F0EBE9BEF5F777466C93DA@PH7PR11MB8121.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB8121:EE_|BL3PR11MB6530:EE_
x-ms-office365-filtering-correlation-id: 1d75fb52-94ed-41c5-cf62-08dde1c75fd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bVZBeDNYa0htKzkzV0FzKzc3eVQ2Z0lqK0Y5RWRoYlFrT1VVRENzbnFINTUz?=
 =?utf-8?B?dUx1S2ZPK2d1OXB3ZTJoSlpER0x5Uy9TMHNPYUc2OGdjMEczQjkraDRwU2xn?=
 =?utf-8?B?ZVptdE1pUjJWRlNCbzg1MWRiOHVTRDk4YlVseVdycUdadHpDWjZWa1F4MUlI?=
 =?utf-8?B?alJTNUtCUUc1ZS80RnVmcWRUVEpNTFEweFIyWUZ6QVMyeHdLMnRWRFJNQ2Yw?=
 =?utf-8?B?UU9HQUU3UzlhRG4zT3dNLzNTbTZCc1R6WXRsOG1iVG9vMERVRlFvZ0xPM1VZ?=
 =?utf-8?B?akp6cGUzYU5Ec041WjRpYktuSFlKc3pUR3Jxc3lTdTBWVE0xNjNodGh0TXJ6?=
 =?utf-8?B?eDk3SndkZGtKVzJYN2NPcUFGVUFtVC9VTjViazBKUTBoSFMwcTRhN255UCtG?=
 =?utf-8?B?VHBqWGRWdUY0c2FmckJEUXdwZUFwMWI3Sk43VWMxbVQvR0xuekZKVUt6d2lJ?=
 =?utf-8?B?bmpFTWdTbjhMYlpGOHRQMXYydTlFNENGVlZYRzlFK0dHdWx1dFJ6Y3VmVlNH?=
 =?utf-8?B?ZHByRkMxcFVsTXNuRFlXcmJvbDBFRzBVd0lLdzlIL1ZJT24vUVVvTVJFRGhG?=
 =?utf-8?B?Q3JSOWxlN1ZqUmdFbUNOZE1KYlVyRHJUR0Nzb0F2QzhGMG5xaklIQzI0NDM2?=
 =?utf-8?B?Q1RyckgvYTdLYXpodnVFZjNGR1prVXBteVU0dmx3YTVKZitkZmIzWXZjaDI5?=
 =?utf-8?B?M3RCc203V0JnS2R6bHlFQmFPejFUeTRSMlN5UDFsYi95YmhCYjNHR1BYMmx2?=
 =?utf-8?B?NEgzY1ZPYzV5bGhETWZjeEtrQlJUL0pmbDJDSC9DNG83Vm9kZy9LT25QM1Fl?=
 =?utf-8?B?YWV2UUc1M3g2UG1MRXI4RFA5VkUrd2QrZFFTUnM4Tkk2b1hsK0xLb3c3UkVq?=
 =?utf-8?B?QW9kQlZ1VUEvNlNjWUcrdWR3dFJkbWs3R0JJb3F0REVkS0NKSEdNVVN6eWMw?=
 =?utf-8?B?NVUwcTd0Mk5ZL1hIL3JXMTgreG9PaGxSYXM0STBGNlJkU2o0WGMwdUo2MjVh?=
 =?utf-8?B?Qlh3NjEyUS9CN2dsMlVPbm4rRkQ3aTg4cHd0UW1UNHN0QkFrNjZHQ0RmekJy?=
 =?utf-8?B?VVdXNGJiM2U3a1lqVHJPMlByanM1NHRObDlIeXU3SEJteDBaZGYzSVBzeCt4?=
 =?utf-8?B?MEV3RjNpQStqV3o3WithdDNtUmtKVXozby9ERmtxNlEwWiswaHpZWVRMNVRH?=
 =?utf-8?B?MWRoclpXUXBoeUI3d2hvb2lyQnFuU3UvY21lR2J6bGN5RTRTRHFJV0o5R1A0?=
 =?utf-8?B?RVBZNU1GSXFzamhJOU1YVkdqYmlHeXozbC9pK043YWs5Tm1vV0lpcFo0TTE5?=
 =?utf-8?B?eVROUGVuOUpLNzQ5Zm80V1YrSk5WY0d3c2pPK2xvQVNkem52NVI1MTlHZExi?=
 =?utf-8?B?Smo0V1RUbHB4NENHMVRYSzl0V3oyTHZSVUZ0YW9xTW5jUDN0YTFZOUVvZDhY?=
 =?utf-8?B?ZklnUVVZVHpvNUd2cXlVYnlWMjY3VVNLbVNCRDk3UURxVnB1TU9Gd1hmNXhP?=
 =?utf-8?B?SW05eXEwU0t3L2xua2U5RTlBQWZKWTRJLzJJdFp3MWpadExpQVRUWHQ3VVJH?=
 =?utf-8?B?TUcxRmZqUSs5SVBzYkhORGp6TWltYkUzVVZ5dTdmc3QyWFYrdEs4VUhDZlRy?=
 =?utf-8?B?aldrY2FBblVmVGhWeXI0QmhQSE5pTlBuTFhkYW1kUThwUk9sS3Fld0JDWjEr?=
 =?utf-8?B?UUg3S3JSTDNTRE1EcFRSNFlVb3IyVUhkNEdXU0p0c3hkbEhMSThSa1B5ek5l?=
 =?utf-8?B?YkFuQy9YUFJkVlNqMzhIN3Vkb0I4dkRoQ3RReEpKMy9qekJSVS9BWU1BNUVB?=
 =?utf-8?B?ZjcwMzE1V0tpYjBtSnpWSWozSU15Tm1xREFzL29hU2lCWEtaY2FTSHJnVUJU?=
 =?utf-8?B?Tkh6NE5kRXV3YitHZ2ovUjRleE51WU5iL1BScWFCbVIwcWpxRWlPWnFMM2pa?=
 =?utf-8?B?RFg3anBoVnE2WU51QU1XT0JZZU5hdytrMmxVYm9ZVlRKTkNpYWZabXB6YjYw?=
 =?utf-8?B?dlNsUkxkeXJRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB8121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVVIZlhtZ1FyZm5mNUFDRktYVUY3RG9wb2dHanIwVnhxY2FvSjBNUEtHaThw?=
 =?utf-8?B?ODRoL3Z4UDlNM2FBRUlZSVJUQ2ZCWnRhd2xQSEJ4MU54aDJxb3BPcGtlakxa?=
 =?utf-8?B?VVJTTnBDSE1vNUsrNXdpeFVDajg4QVR6bjIxMHB6R1l6Z2svbFdXNmVaK2M0?=
 =?utf-8?B?QWJtL3pDZndSMnNGYkEyUC94Qm1BVFdUR1duSmowMTFRcjlmREs5SElYa2VV?=
 =?utf-8?B?QXIyd1pWbVlRUzJSZmQ2TGNuTkVHQUhxNGJUclBRdmxxYitzYktKVjlESDR2?=
 =?utf-8?B?YmxiSk1Hc1hvcVNSdXBrS01EakQyYjhuK3M2dWRJWXF4MG14TEZuWVpnN3lu?=
 =?utf-8?B?NmwxZ2hrM0s4bVE4NGx6SFZsRC9IYUE5NmdLTEw1V0tSUjJZclg3Sm4yd2Fi?=
 =?utf-8?B?Y0ZWV01kY0EvbC9Td0xSMStsTDJFaGhhbEJmOTYyRUFJSURualhpOEd4aEZS?=
 =?utf-8?B?ZFJrNmxEV0t3ZDRxd1dPMXArV0t2aGdjWGV3eXAyaUpoZDE0SHpLZUd3Ujd0?=
 =?utf-8?B?ZHJMYmFTTXJ3RlFGTExnUXRIUTYxY0RBbXJwc3VHdTZwNFFITjZYczdMVkxD?=
 =?utf-8?B?SzRKanUzYmVHS0k3Z2ppSXBLTFRsMzZFb2dheXdFRlppUEtUQ3hGdDlFNFk1?=
 =?utf-8?B?MkNLc1oxaEtYZW02bHZsSDB0WCtOUEVQN0dUVXVDelRIazZMUVM0QnQ4OUVC?=
 =?utf-8?B?cnEzbVBmbjZXVEJuTHBZUmZ5bDkyVVZyd09OcTNEV3d2NlpwbjA1YzRRdnVs?=
 =?utf-8?B?OVplZkdCTDFtcU1rOWd1WHVWdnkwNUZta2o3SnloNkdEYi9UblZjK2RiMG95?=
 =?utf-8?B?c005WDVuNjdJVjNxM1ZwYmwzSG15MXJUVzFQeVRrYmZpTGhDV3VIZUR1Ym9v?=
 =?utf-8?B?dXhSYmNoRVpmZnd4MUJSaU5QWWdwVTE2MTRGdU43NWNNNmNYbW9hVmxQRmxl?=
 =?utf-8?B?NWExYTI0NHl0eUF6Z3RYYWRTVXN6Qk1QWXUxV2tCSDZ2a1pHUVhLTDNsYURm?=
 =?utf-8?B?eXlEclZ4WEViRVc2dGY2NkczL2Y4cWd1VFBTYWFVdkFHeGVMc0NOMnI1N2Iy?=
 =?utf-8?B?ck9FNjJUZ2ZGaE5WdEpRU1dvV0pkMkpMZ3gveU45WXdTQ21EMVFLQjRYeTM1?=
 =?utf-8?B?Yy9UbE5vVWJ6KzVtaDFBSFhGNDdJN0w2YlFyVnBFS29yalNGZUdJdXdKbW1j?=
 =?utf-8?B?cXdrNW1yUE10ZlU5QXNKTmhBWldGQUVuMDVsOStPV1FsM21MWTBFbjdZTDJo?=
 =?utf-8?B?Tk1uUTVNNHIzcm8xelJLNkhCWHNtaXFXTTExR2JCTCtUQnR1VGlxYWxMY041?=
 =?utf-8?B?S2lIcmd0bmg2bWNOcnZucVk5QUVtTDN6SkkrZ1JLbFpwdjhsS1Avakxwa1Jr?=
 =?utf-8?B?MjBUdFdtR0dSSmI0VitEZWN6V1NJTnUyb0lpbGNxRzZyZTZPQ1hEU2hxdXVD?=
 =?utf-8?B?L0FTTElZblVnMU1Tb3EzRlNMQ3hYcDFwWTNsYUlPTTUrL3dPYzltYW91UHZr?=
 =?utf-8?B?TUhmakZwSTVJcDBCQThPNk9yWjY5WnQza3djQ0E4T056NmxjaERNeUpkeDY2?=
 =?utf-8?B?SFY1MDgyaFZoOHhpRnpqbUFOa25CZkMwekl5MWgyUWdBZzNmdUVSc2xINGs3?=
 =?utf-8?B?djJJOVpWMDVNQ1pjbHRyNHFZbFNtYlQ5SUNHam84MWxNRFFLTk9mZ0VaT1JR?=
 =?utf-8?B?WmVDbWNieDBwcS9Hbk1Bbk52MnlzUU9SNHBOUWRudkVNVUdvbFlMTmVucjBD?=
 =?utf-8?B?b2pMNDROSHdpbXl5MXRkdXBpS2VZalUxVTlkd053Q3Y1T0dlY3dlbjZOeVRk?=
 =?utf-8?B?ZGc3dnp0Mm9tZTU2VUVuWnVITEpUS0drblBvUEMySWJCamhTbjNRTC85cjZz?=
 =?utf-8?B?RURHNU5WdWtUYXZGL1RzKzh3Y1JKUEVrNlg0OTVDSFk2NGZLb1ViODViZEFk?=
 =?utf-8?B?bXlFZHhSeDVLOVdWRFl2emhFNUpadzlyR2Q2VENBQ291ME9NOTROZ1RWZFUy?=
 =?utf-8?B?QkxyZGM5QjlRa0c3Uks2aDR1Q0UzMjR3U0t6aUtna1BJWmJQamdqNXF0UWJv?=
 =?utf-8?B?enp4RDl5N2xic1l6cGJzZEkxYi9INS9aaVdidEM4d0VXZmpiTjY0YThTOHRV?=
 =?utf-8?B?cEFwUnhxc3p4QnNqSFNtUnVvdDdCcTVlM1owbVZwZjBPMmVEQStRcnZJUmtH?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB8121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d75fb52-94ed-41c5-cf62-08dde1c75fd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 22:00:57.8924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fonIS4t1GJWYFDaUlmncREPryUPMmUeG3jGZcaCwBqW+m1kg8hEDcinEyIM5JPgCDlKzYsgn9tsshhuy+t9aFVdW0GMUaJGGrDShbQQNkh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6530
X-OriginatorOrg: intel.com

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNyaWRoYXIsIEthbmNoYW5h
IFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0
IDIyLCAyMDI1IDI6NTggUE0NCj4gVG86IE5oYXQgUGhhbSA8bnBoYW1jc0BnbWFpbC5jb20+DQo+
IENjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBsaW51eC0NCj4g
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOyBoYW5uZXNAY21weGNo
Zy5vcmc7DQo+IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpob3VAbGludXguZGV2
Ow0KPiB1c2FtYWFyaWY2NDJAZ21haWwuY29tOyByeWFuLnJvYmVydHNAYXJtLmNvbTsgMjFjbmJh
b0BnbWFpbC5jb207DQo+IHlpbmcuaHVhbmdAbGludXguYWxpYmFiYS5jb207IGFrcG1AbGludXgt
Zm91bmRhdGlvbi5vcmc7DQo+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgtY3J5cHRv
QHZnZXIua2VybmVsLm9yZzsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgY2xhYmJlQGJheWxpYnJl
LmNvbTsgYXJkYkBrZXJuZWwub3JnOw0KPiBlYmlnZ2Vyc0Bnb29nbGUuY29tOyBzdXJlbmJAZ29v
Z2xlLmNvbTsgQWNjYXJkaSwgS3Jpc3RlbiBDDQo+IDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRlbC5j
b20+OyBHb21lcywgVmluaWNpdXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47DQo+IEZlZ2hh
bGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBHb3BhbCwgVmlub2RoDQo+
IDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPjsgU3JpZGhhciwgS2FuY2hhbmEgUA0KPiA8a2FuY2hh
bmEucC5zcmlkaGFyQGludGVsLmNvbT4NCj4gU3ViamVjdDogUkU6IFtQQVRDSCB2MTEgMTgvMjRd
IGNyeXB0bzogYWNvbXAgLSBBZGQNCj4gY3J5cHRvX2Fjb21wX2JhdGNoX3NpemUoKSB0byBnZXQg
YW4gYWxnb3JpdGhtJ3MgYmF0Y2gtc2l6ZS4NCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVz
c2FnZS0tLS0tDQo+ID4gRnJvbTogTmhhdCBQaGFtIDxucGhhbWNzQGdtYWlsLmNvbT4NCj4gPiBT
ZW50OiBGcmlkYXksIEF1Z3VzdCAyMiwgMjAyNSAyOjQ4IFBNDQo+ID4gVG86IFNyaWRoYXIsIEth
bmNoYW5hIFAgPGthbmNoYW5hLnAuc3JpZGhhckBpbnRlbC5jb20+DQo+ID4gQ2M6IEhlcmJlcnQg
WHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IGxpbnV4LQ0KPiA+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgaGFubmVzQGNtcHhjaGcub3JnOw0KPiA+
IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgY2hlbmdtaW5nLnpob3VAbGludXguZGV2Ow0KPiA+IHVz
YW1hYXJpZjY0MkBnbWFpbC5jb207IHJ5YW4ucm9iZXJ0c0Bhcm0uY29tOyAyMWNuYmFvQGdtYWls
LmNvbTsNCj4gPiB5aW5nLmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBha3BtQGxpbnV4LWZvdW5k
YXRpb24ub3JnOw0KPiA+IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgtY3J5cHRvQHZn
ZXIua2VybmVsLm9yZzsNCj4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBjbGFiYmVAYmF5bGlicmUu
Y29tOyBhcmRiQGtlcm5lbC5vcmc7DQo+ID4gZWJpZ2dlcnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdv
b2dsZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQw0KPiA+IDxrcmlzdGVuLmMuYWNjYXJkaUBpbnRl
bC5jb20+OyBHb21lcywgVmluaWNpdXMNCj4gPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47DQo+
ID4gRmVnaGFsaSwgV2FqZGkgSyA8d2FqZGkuay5mZWdoYWxpQGludGVsLmNvbT47IEdvcGFsLCBW
aW5vZGgNCj4gPiA8dmlub2RoLmdvcGFsQGludGVsLmNvbT4NCj4gPiBTdWJqZWN0OiBSZTogW1BB
VENIIHYxMSAxOC8yNF0gY3J5cHRvOiBhY29tcCAtIEFkZA0KPiA+IGNyeXB0b19hY29tcF9iYXRj
aF9zaXplKCkgdG8gZ2V0IGFuIGFsZ29yaXRobSdzIGJhdGNoLXNpemUuDQo+ID4NCj4gPiBPbiBG
cmksIEF1ZyAyMiwgMjAyNSBhdCAxMjozMeKAr1BNIFNyaWRoYXIsIEthbmNoYW5hIFANCj4gPiA8
a2FuY2hhbmEucC5zcmlkaGFyQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+
ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4gRnJvbTogSGVyYmVydCBYdSA8
aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pg0KPiA+ID4gPiBTZW50OiBUaHVyc2RheSwgQXVn
dXN0IDE0LCAyMDI1IDEwOjI5IFBNDQo+ID4gPiA+IFRvOiBTcmlkaGFyLCBLYW5jaGFuYSBQIDxr
YW5jaGFuYS5wLnNyaWRoYXJAaW50ZWwuY29tPg0KPiA+ID4gPiBDYzogbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtbW1Aa3ZhY2sub3JnOw0KPiA+ID4gPiBoYW5uZXNAY21weGNo
Zy5vcmc7IHlvc3J5LmFobWVkQGxpbnV4LmRldjsgbnBoYW1jc0BnbWFpbC5jb207DQo+ID4gPiA+
IGNoZW5nbWluZy56aG91QGxpbnV4LmRldjsgdXNhbWFhcmlmNjQyQGdtYWlsLmNvbTsNCj4gPiA+
ID4gcnlhbi5yb2JlcnRzQGFybS5jb207IDIxY25iYW9AZ21haWwuY29tOw0KPiA+ID4gPiB5aW5n
Lmh1YW5nQGxpbnV4LmFsaWJhYmEuY29tOyBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnOw0KPiA+
ID4gPiBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5v
cmc7DQo+ID4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGNsYWJiZUBiYXlsaWJyZS5jb207IGFy
ZGJAa2VybmVsLm9yZzsNCj4gPiA+ID4gZWJpZ2dlcnNAZ29vZ2xlLmNvbTsgc3VyZW5iQGdvb2ds
ZS5jb207IEFjY2FyZGksIEtyaXN0ZW4gQw0KPiA+ID4gPiA8a3Jpc3Rlbi5jLmFjY2FyZGlAaW50
ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzDQo+ID4gPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT47
DQo+ID4gPiA+IEZlZ2hhbGksIFdhamRpIEsgPHdhamRpLmsuZmVnaGFsaUBpbnRlbC5jb20+OyBH
b3BhbCwgVmlub2RoDQo+ID4gPiA+IDx2aW5vZGguZ29wYWxAaW50ZWwuY29tPg0KPiA+ID4gPiBT
dWJqZWN0OiBSZTogW1BBVENIIHYxMSAxOC8yNF0gY3J5cHRvOiBhY29tcCAtIEFkZA0KPiA+ID4g
PiBjcnlwdG9fYWNvbXBfYmF0Y2hfc2l6ZSgpIHRvIGdldCBhbiBhbGdvcml0aG0ncyBiYXRjaC1z
aXplLg0KPiA+ID4gPg0KPiA+ID4gPiBPbiBUaHUsIEp1bCAzMSwgMjAyNSBhdCAwOTozNjozNlBN
IC0wNzAwLCBLYW5jaGFuYSBQIFNyaWRoYXIgd3JvdGU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9jcnlwdG8vaW50ZXJuYWwvYWNvbXByZXNzLmgNCj4gPiA+ID4g
Yi9pbmNsdWRlL2NyeXB0by9pbnRlcm5hbC9hY29tcHJlc3MuaA0KPiA+ID4gPiA+IGluZGV4IGZm
ZmZkODhiYmJhZDMuLjIzMjVlZTE4ZTdhMTAgMTAwNjQ0DQo+ID4gPiA+ID4gLS0tIGEvaW5jbHVk
ZS9jcnlwdG8vaW50ZXJuYWwvYWNvbXByZXNzLmgNCj4gPiA+ID4gPiArKysgYi9pbmNsdWRlL2Ny
eXB0by9pbnRlcm5hbC9hY29tcHJlc3MuaA0KPiA+ID4gPiA+IEBAIC0yOCw2ICsyOCw4IEBADQo+
ID4gPiA+ID4gICAqDQo+ID4gPiA+ID4gICAqIEBjb21wcmVzczogICAgICBGdW5jdGlvbiBwZXJm
b3JtcyBhIGNvbXByZXNzIG9wZXJhdGlvbg0KPiA+ID4gPiA+ICAgKiBAZGVjb21wcmVzczogICAg
RnVuY3Rpb24gcGVyZm9ybXMgYSBkZS1jb21wcmVzcyBvcGVyYXRpb24NCj4gPiA+ID4gPiArICog
QGdldF9iYXRjaF9zaXplOiAgICAgICAgTWF4aW11bSBiYXRjaC1zaXplIGZvciBiYXRjaGluZw0K
PiA+ID4gPiBjb21wcmVzcy9kZWNvbXByZXNzDQo+ID4gPiA+ID4gKyAqICAgICAgICAgICAgICAg
ICBvcGVyYXRpb25zLg0KPiA+ID4gPiA+ICAgKiBAaW5pdDogIEluaXRpYWxpemUgdGhlIGNyeXB0
b2dyYXBoaWMgdHJhbnNmb3JtYXRpb24gb2JqZWN0Lg0KPiA+ID4gPiA+ICAgKiAgICAgICAgIFRo
aXMgZnVuY3Rpb24gaXMgdXNlZCB0byBpbml0aWFsaXplIHRoZSBjcnlwdG9ncmFwaGljDQo+ID4g
PiA+ID4gICAqICAgICAgICAgdHJhbnNmb3JtYXRpb24gb2JqZWN0LiBUaGlzIGZ1bmN0aW9uIGlz
IGNhbGxlZCBvbmx5IG9uY2UgYXQNCj4gPiA+ID4gPiBAQCAtNDYsNiArNDgsNyBAQA0KPiA+ID4g
PiA+ICBzdHJ1Y3QgYWNvbXBfYWxnIHsNCj4gPiA+ID4gPiAgICAgaW50ICgqY29tcHJlc3MpKHN0
cnVjdCBhY29tcF9yZXEgKnJlcSk7DQo+ID4gPiA+ID4gICAgIGludCAoKmRlY29tcHJlc3MpKHN0
cnVjdCBhY29tcF9yZXEgKnJlcSk7DQo+ID4gPiA+ID4gKyAgIHVuc2lnbmVkIGludCAoKmdldF9i
YXRjaF9zaXplKSh2b2lkKTsNCj4gPiA+ID4NCj4gPiA+ID4gSSBjYW4ndCBpbWFnaW5lIGEgc2l0
dWF0aW9uIHdoZXJlIHRoaXMgbmVlZHMgdG8gYmUgZHluYW1pYy4NCj4gPiA+ID4gUGxlYXNlIGp1
c3QgbWFrZSBpdCBhIHN0YXRpYyB2YWx1ZSByYXRoZXIgdGhhbiBhIGNhbGxiYWNrIGZ1bmN0aW9u
Lg0KPiA+ID4NCj4gPiA+IEhpIEhlcmJlcnQsDQo+ID4gPg0KPiA+ID4gSSBhbSBub3Qgc3VyZSBJ
IHVuZGVyc3RhbmQuLiBLZXJuZWwgdXNlcnMgc3VjaCBhcyB6c3dhcC96cmFtIG5lZWQgdG8NCj4g
cXVlcnkNCj4gPiA+IHRoZSBhbGdvcml0aG0gdG8gZ2V0IHRoZSBtYXhpbXVtIHN1cHBvcnRlZCBi
YXRjaC1zaXplIHNvIHRoZXkgY2FuDQo+IGFsbG9jYXRlDQo+ID4gPiByZXNvdXJjZXMgZm9yIGRz
dCBidWZmZXJzLiBUaGUgZ2V0X2JhdGNoX3NpemUoKSBjYWxsYmFjayBhbmQgYXNzb2NpYXRlZA0K
PiA+ID4gY3J5cHRvX2Fjb21wX2JhdGNoX3NpemUoKSB3cmFwcGVyIGhlbHAgYWNjb21wbGlzaCB0
aGlzLg0KPiA+DQo+ID4gSSB0aGluayBoZSBtZWFudCBzdG9yZWQgaXQgYXMgYSBzdGF0aWMgdW5z
aWduZWQgaW50IGZpZWxkLCByYXRoZXIgdGhhbg0KPiA+IGEgZnVuY3Rpb24gcG9pbnRlciAoaS5l
IGR5bmFtaWMpIGxpa2UgdGhpcy4NCj4gDQo+IEkgc2VlLiBHb3QgaXQhIFN1cmUsIEkgd2lsbCBt
YWtlIHRoaXMgY2hhbmdlIGluIHYxMi4gVGhhbmtzIE5oYXQhDQo+IA0KPiBCZXN0IHJlZ2FyZHMs
DQo+IEthbmNoYW5hDQo+IA0KPiA+DQo+ID4gRG9lcyBiYXRjaCBzaXplIGV2ZXIgY2hhbmdlIGF0
IHJ1bnRpbWU/DQoNCk5vLCBiYXRjaCBzaXplIGRvZXNuJ3QgY2hhbmdlIGF0IHJ1bnRpbWUuDQoN
ClRoYW5rcywNCkthbmNoYW5hDQo=

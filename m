Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0232ED14C;
	Wed, 10 Dec 2025 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765345002; cv=fail; b=byhFfYKPWhJx/S2bAzCUUNaukrpN2GL9ztP9AkKQ8kMNUnk7WebAK+9T5wDm3zfe1n0f0zppXXLCciPwTTV9yyVKQE6+ygsievCXOhjjAnzrRJIP/0L9DRM96t5uh0zoBPMEnmbhbKyeN17kWjG/7shBxkb3bSnj42K/GrIbvAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765345002; c=relaxed/simple;
	bh=1WwEY0uIH+2G2Ouy07Yv+MLL44RkFYA9Ztf0QXC9E84=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EGBay91i+FwGiYSz4zqmwRG2rxUuvpQGkkQaNboX8RoN4YKHPpFGporE2t46wle87XULnCzHxB9NtxntEQ4nMSChKNvWM+t8HYeVuqp4bgTjErbo4spqIG5qtejWlUNr1UstAePWzPFUG1+H52B2xMx8WIN6V3TFlry1TZ22gbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lO1eRXQg; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lO1eRXQg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765344998; x=1796880998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1WwEY0uIH+2G2Ouy07Yv+MLL44RkFYA9Ztf0QXC9E84=;
  b=lO1eRXQg9F1ne0KbDzhurIyRPeiI36c6nnV9Tkwn6b1QnLJhwsFg4W52
   rSwP727b3DKQyMw5p0OTGMYmaEI+QtCUBMp9W/m5aq+ib06oiuckwTe6W
   aah4kkWBtE7tpMyciZTthrWq9zl65USilJwOyNeKT69z2HhD1ab7m9Q0s
   66ymTAeNyIIcWDti8XtpIUlwt5Meewb9Uvv/MQrGIQ3STbtApHyUAQ7el
   d1wV1q+5pz4cyDexuJWChHuQ/9U0SPSD7dnRUYQRatq21K9gR1HtdiHaT
   yCK2Xqq6Epnx5ssZDffL+d2Eio0N6FlJX3wTxiKKKVqAVpG//pcKKkvT3
   Q==;
X-CSE-ConnectionGUID: UfyzlZ4CTwalOX1LjWOsKw==
X-CSE-MsgGUID: oQk24LVBSS2wbSDlGV6Fgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="78422304"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="78422304"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 21:36:37 -0800
X-CSE-ConnectionGUID: uub2QEY2QC2y6COMSWXGzQ==
X-CSE-MsgGUID: PfEidTVcS8Kd3CguSzFu9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="196713100"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 21:36:37 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 21:36:36 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 21:36:36 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.14) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 21:36:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PH0O2uXg13ZlN9Tkd9kJH0DLNsJXNg8oExIwoFx/d2gNWHvWphmU3V6oqllmr/xgpuRuhWh0qAXz+bR+hVtWcPPZ5IaznRxFMsuxLV9sUYJ1Jg+2QjbN8DGBjHasgcc3MzlHjcF7pcsGALPfHDenFbLbH4VzDbkEW8koTQLfdMhscZcHEVS7q80rVNOAzDkf/eysJfMKI85XlOTgdRHiD+WjVQCPlXRAKmI4nbBg9Mj5pV/9pEXFCWRnl+mlxXTmOAtrwj5L/WzDYuPWnzzlHm3M0rG0RDJR2m8jGyWKvgkgUU1lbfhCpPRkdE86sijyAbn4Fx+Ag63cHLEzSy4RDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WwEY0uIH+2G2Ouy07Yv+MLL44RkFYA9Ztf0QXC9E84=;
 b=PYySKeP8yhWad9TK0zanMCQwsV/1fe0laecG1i0BKFnj5yXk7ES6bVAImbns+XBVXRCKGUtyjtFA4Zy19CL8yMAnjiAclMtkcl0xPfakZcNumQUTJHU2imFK4wRCfU6QvZw4WfLKSjfONRKYJyq/+n4f5RoSHI2XkpXyF5B68RJxiWIy25dmqmms66Qy/n6eP5byIX0mA2LaYiLRQBvWwdsekCldTyrkxTwgwcsKPjy3rC66M1gqncRfOVyE0SSkPHUmB4GHVbs6+n2kub64njVWPZ1+j5OYYxMbxfkYBNKhks/k0DRBc7Ozv3auVpzQdGTp0TQPikenQIFRGp0Q8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by LV8PR11MB8697.namprd11.prod.outlook.com (2603:10b6:408:1fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Wed, 10 Dec
 2025 05:36:27 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 05:36:26 +0000
From: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Yosry Ahmed
	<yosry.ahmed@linux.dev>
CC: SeongJae Park <sj@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com"
	<nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, "kasong@tencent.com"
	<kasong@tencent.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "ebiggers@google.com" <ebiggers@google.com>,
	"surenb@google.com" <surenb@google.com>, "Accardi, Kristen C"
	<kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAAG5HAIAABzqAgACcWYCAEjbfgIAADVuAgADeg0CAEcgegIAAC4yggAAFRoCAAV2IAIAAFZkAgADxCICAAAPuIIAABkmAgAC3dICAABKpMA==
Date: Wed, 10 Dec 2025 05:36:26 +0000
Message-ID: <SJ2PR11MB847264DDE6420139C9FF0749C9A0A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <j7vaexpi3lmheowozkymesvekasccdgnxijjip66ryngj66llf@kolcsjasxxdy>
 <SA1PR11MB8476756D7255F1EA1EBE322AC9DEA@SA1PR11MB8476.namprd11.prod.outlook.com>
 <aTZExW2LgFNTfwVJ@gondor.apana.org.au>
 <SJ2PR11MB8472529E92EC003D956DF530C9A2A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <aTZS4RKR3Zci8d_I@gondor.apana.org.au>
 <qux3i5m4weedza76ynfmjmtvt4whnkk3itwpuolozfvk3cg6ud@rylhkigmqn7t>
 <aTeKNEX5stqjG55i@gondor.apana.org.au>
 <j7rqzweklga72b7hdebljs7nziz7bs7kzvevkuhnbwi3uespkt@rmkdqlpku2gh>
 <SJ2PR11MB8472CE03A67C1161469CDE9EC9A3A@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <bfkkizyjmfulkzxgf45l7tjsnudtyutnenyngzw7l4tmmugo3k@zr2wg2xqh3uv>
 <aTj22_idykAfpDNw@gondor.apana.org.au>
In-Reply-To: <aTj22_idykAfpDNw@gondor.apana.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|LV8PR11MB8697:EE_
x-ms-office365-filtering-correlation-id: e5c3fdd8-51ce-465f-c300-08de37ae101e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?Q+rle8Apv3ewE24IZqLcT+4y1Yc4HNdmJMhrROKHpK/df4E/AVvdQyKlXLHF?=
 =?us-ascii?Q?Rwe1n9aZDi8APkKafJlGUpyadKhOCY8qUj2YPKlBmIV0Cn8dR+9m16dwe5KV?=
 =?us-ascii?Q?wShP2FL2ZAi//W6r2U5W4jn12uC8aOgDTn8EW9GDOZY2rS+cAvJu3LR4qR1N?=
 =?us-ascii?Q?u92XiBL5TBNi0HNfe8q7Ru5MNnpOGumR9VNovMrRpz4G4GzY7YzJD+kNocMI?=
 =?us-ascii?Q?L/PVhgAZ8fO1KQCr/EfJa/qt9NigES/HXnzQY0snCrp3oLFNnOBPbGLo82VE?=
 =?us-ascii?Q?zaGzBmLV/yFmOQ1sCzODaZAfcTkiuvb5MAAqvT1YocsrG6JcM0ehJsLUL0HM?=
 =?us-ascii?Q?zD0Of1bfvH4OcVEZt3xPppqOk9FaOQuGHvi9ZPrOulrH6sAUOoApZkVRXYK7?=
 =?us-ascii?Q?kfoLB5NylhEd6ahYzriDqQrlv7OrzJsbypB65JVLlZDjlFFB9AqhMsy0Chhg?=
 =?us-ascii?Q?p4ymNr2lBISWGwDyx0JyBS50NbOxXRdKtL3xLBdvXhVweOhUkId7Wrx8qZQM?=
 =?us-ascii?Q?PPhFP67ZHyxaQ3RdSjGvRKxuoIDfHKNbo+Wqmnra9XW1Ev4aXoYfHOztip9u?=
 =?us-ascii?Q?ualnfMl5FpnxaVutT3L8Z9Me7tKNu0OzVzFcmKt9KrVZv3ANESV8vpcvzH6H?=
 =?us-ascii?Q?s4lohFu9iwRaVSpq1ZnTaZd2B20/AVhyembGvbyslmXQ3e/ukOL1anD4+92q?=
 =?us-ascii?Q?zBOT5UBng2j9IN3aiEU9kd4T3npZMcjYxNLQ/sXB8O959E0xu4mWF+EI+G3Y?=
 =?us-ascii?Q?T42a9/8OIegxYKkfG+jJX5HRPSqFn4WIjpdvHshRfX7GUFo8mVlZFqNnU1H/?=
 =?us-ascii?Q?uXMhKjarl7biai94re/OtdHdiAuKs82k1cc15aVX1vEd0D3Ma3bg9hfhoONg?=
 =?us-ascii?Q?/C2ZU1dkDbdykYc0mnQRuI9edKEKoGfi0YeE4j5/4blI1qMrcTuPjnJvJUnt?=
 =?us-ascii?Q?Vg0efkWyCue9Oi7MlORbZuVJU9lA94ZFB+TsdJIfTOMWqhyHAseeP44EbQpL?=
 =?us-ascii?Q?OjkOVDU8GfGIYf6s9v2l06C3w3xqXQY8sIf+OToERt/x1LUvEFlcVV7YyXMX?=
 =?us-ascii?Q?4UxZYnwJoJXqNhgCP8ZGyv74z063fQmLwLfM6ydl/tc1iZ3SYxWLpaVMpdPd?=
 =?us-ascii?Q?5TDyLReC8qZC5jR0xfFHK9dRQSLJO0R8naH516B0bNXtA09UdKDkXKfzFDw7?=
 =?us-ascii?Q?uE9ojIB0duY0lyNtdLKiElDJjK5XHbacZLB9XiifGXzL70J0CbiMgf81KUyi?=
 =?us-ascii?Q?fTGb8m0+pnNJ1TDgnvwUbSWxxPUeoIwh7Plkeipq7BOgqTioILaPf2kTLOOS?=
 =?us-ascii?Q?+tozz2OI2h2Nmc09TEu/0mmUI4AaG71w3QFJnpHwnMXr943NIwG5rytJi1nQ?=
 =?us-ascii?Q?68IlmqQZKiwg4a49o+FaHRFW3WRwJhYEgjvSM5DAR65WylUiIxxYvzZ41jR5?=
 =?us-ascii?Q?m1ANYPYvgzsuu40V9FHZgWrBLSjyDIKTl+HwOa+g1n/2VDUp+oUnPg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qUnitcZR2QJZAaLDz9emoU72dxMdiJon3FrGl9J9dW64avu0/dJfhcrNerj1?=
 =?us-ascii?Q?LhdN2Y6mL+J1JwsfAWZLcGOBZGEFizmS/Dz2Ju9pv6Jf+nPcb/e6Hu1E2NDi?=
 =?us-ascii?Q?DgVXRg3IBaqRarz1vYP82iO4quXIMiGSDpl/lVl1XTNkfmFNqNqKmEpfcnxi?=
 =?us-ascii?Q?Rm8Uw7BQQTmKOSlxcaoWqIF2nwUMA83whV3acD8OhCL1+Duh//OUTneGXT/h?=
 =?us-ascii?Q?el3hQXIopLQyQehKie+KCi2GDKO94tP0/wRuWolZbBZ9tu9geBkdIco2bUqt?=
 =?us-ascii?Q?ce17HrVRp3BndA2O7hP1YF0TiVd0hdyJQFHCmN/FaCP+24jDpuuuxGChrFLI?=
 =?us-ascii?Q?aQp+A/Ae5umYpd5gHYGzkJRMw3bG1nmLV+OHJRTdDHXMzze4j0M0Bct9WWA2?=
 =?us-ascii?Q?eSPkBSsXNWYUKLT+E35zFdFeb0z+JsheFNVrmIryHsCPXjFnHlfO5zllRMiR?=
 =?us-ascii?Q?Lez0lQq+J5ESAnvUgnRshTpQ8/zKlB8ulfi3jnAC2TxET+8dFNMKeF15AUU9?=
 =?us-ascii?Q?mp2IcAW2tCu8KCytjXzR0WzlM7eg6OEcKebgLMsPN7XJFKfg6hwapVKWEknJ?=
 =?us-ascii?Q?6SXt7omZ9VtoMH6yHfHLvcBzLo96UghL2OcZBnyVVTBvXeeGAg6t92y3uT7o?=
 =?us-ascii?Q?V0d3lPf9eyZoE4tv2pXZjmUzawrVDaO++kZX8pFn5k0+Nfa2fq3leDdQBatf?=
 =?us-ascii?Q?3HQUvm5wcEPuyIX66qDEaYjmEQ2/tV1Iv/jKdA3VUflHwEdJnTsDmBYoUnzl?=
 =?us-ascii?Q?XNy9w6SOiZa+5D/J/bRRKeysDVkq0UPhoZhmLff7XDPTqSrBUEzvfnIJZhrm?=
 =?us-ascii?Q?f1vHYw2RLf/IllMUn706MroNWCDidDKMCXyeIuknagyjZB+0JoejvG+gTLud?=
 =?us-ascii?Q?yB5ANwqr8+BvVorMklzJorPYYaHko1u15CVTtaGRrg06uiMoIW/9Hr6r6QP6?=
 =?us-ascii?Q?h2OQ6twUJlthKUEfS+1GN9MSRd5i48ZX532PnxeoSZpXbbNzkn0QR6mtZQY6?=
 =?us-ascii?Q?sgksyLeLKY+RMUhZ0FyIIbSygkqV8A+1E9505IgYcEneBpI9eZnoLEpD08hd?=
 =?us-ascii?Q?UfIl//RqNpwiVD/56Q9ooEPLqMQQPOhfwf4dWZ1H+oiBzRHSoPopv1BMwStd?=
 =?us-ascii?Q?P/wCPeYP7zKkWSht6snWQX8A9Yc0VWcNv2B3/JczhwDzA3ThRqdxMknuA+WI?=
 =?us-ascii?Q?+n6CfnxWVtUySWBrV6xa2dMXVFCA8S4fW96haU8sFFB8gNR6RZOLvKDCDwLg?=
 =?us-ascii?Q?Eb6umSInlVUT6+DMJEmZptgueUClGgrH8D0Kp7oZpSqWBLI/wEdlcy3FK/f9?=
 =?us-ascii?Q?c9AlDLfB8DbNrpJjzGZG2GN3reDvbeGVfjyx6DqRkSneRFu2FllVA6bumPVe?=
 =?us-ascii?Q?Ze59tC7QbYfBUYxJ7fir6YRHMO4zGWJOlzFIGAaQzqxn9tIp7GIdicUpT50r?=
 =?us-ascii?Q?wUUHsSBI6rW6WSd18Yo160i0Zr+bEtcZ9JGHnrL7HJSACYcfGwOZcSuH6FRK?=
 =?us-ascii?Q?O2pB3KbXTnJxz2v6soop7ltoNdQqd/WFud0LWXFg3+DYdQwPTmsasmlKZgew?=
 =?us-ascii?Q?zXJoPI6zTMMwbN1lx0PnI98gyh0XD9oM5ElH6Zhzzdlf/Iw2kf3ArjMmifdN?=
 =?us-ascii?Q?GA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c3fdd8-51ce-465f-c300-08de37ae101e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 05:36:26.6842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xhrsKf0j9S6Mc3RgsZkngvvhfXHtOS/PuGwd4I0yFo8UsOECRlVj+ggaNkQtyXhePEiTd4HquOsmxvGYrhe4oOEYy5fCX6vBkGPV/0VXT30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8697
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, December 9, 2025 8:28 PM
> To: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; SeongJae Park
> <sj@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> Kristen C <kristen.c.accardi@intel.com>; Gomes, Vinicius
> <vinicius.gomes@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.com>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
>=20
> On Tue, Dec 09, 2025 at 05:31:35PM +0000, Yosry Ahmed wrote:
> >
> > Ugh, yes.. I don't think we want to burn 7 extra pages per-CPU for SW
> > compressors.
>=20
> OK so the consensus is that we're keeping the visible batch size
> attribute for now, which will be set to 1 for everything but iaa.
>=20
> So for now I'm going to just provide a trivial acomp fallback so
> that non-batching algorithms conform to the batching calling
> convention for a batch size of 1.

Thanks Herbert, this sounds good.

Thanks,
Kanchana

>=20
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

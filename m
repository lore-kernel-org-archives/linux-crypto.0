Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA94C80;
	Fri,  7 Mar 2025 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305710; cv=fail; b=qPBhhz/f/iK3SUgv5eCfR1aCuPHKF7K0Wiakv4wO3OVn/kthVaM/yjngioTGAnAk4e/0h3t2htxrd0FGF0SWJmoxBQcxrMapExhpGGWSWROkUEx2nsXO2Yb09R6S7pHUSmn8cTKO1Hz/eE/l3NelEZo2+n5f7/K2djjaXsbvT/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305710; c=relaxed/simple;
	bh=ljuNv/w9pSl/TTGZuayX2fV/g//c/H63RVnPP+e/qCo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fcH1U4eVc6Ms4ObO3iBLjK8Fs2hJvR7vYxTGG7HBuhYaQuNRTPd1Ml6bTdwrbybaweAuAEr/hck2KpWl+VQnJMHiuDN0Nh2mUhB3ArRk9K4BGy9EZGBNKYm529xmxrhAZKnM1EqNFH95KMnvBd3ivDpnWpacHBkYvQJ0xifOHNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pkz1DLwM; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pkz1DLwM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741305708; x=1772841708;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ljuNv/w9pSl/TTGZuayX2fV/g//c/H63RVnPP+e/qCo=;
  b=Pkz1DLwMLgho9SZpeBbPK89gCRh7+tf2nCQ6eF2bTgSKNYnUnZIbZecW
   HbCiZ8mtaVnKlxXyZIaV0T2qL6tdNx/jb2mQUleHYEAvEnQA8C1wdsSdu
   pPy8JY7gw00ibALNm6JKmSIDZYQxKZ+ezA3QFaOL41HXBMHOQcESkOdVU
   6+Lea5b1Vr9aJvldDe5a4Jrn48k2EisoraaJSk106yBqCjIef95xBXFgH
   8rNeJzbjJzMHvwEGK2qxRbQ4qeR2YMv5477avoFQj+W2j2qDI9aJpigb1
   avLCJ+wZEstV9eMVnxebNR+JO5tajsNCbI+Rj5qDfNwoyW53IbEsq4wRU
   g==;
X-CSE-ConnectionGUID: ++49ogGaRnKlcevp6v6vVQ==
X-CSE-MsgGUID: 5GKODmk+QYWUrUHY5amc2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46269702"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="46269702"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 16:01:46 -0800
X-CSE-ConnectionGUID: 28+/WHzYR+Kl7JJa8LVnPQ==
X-CSE-MsgGUID: zezJcn/qQtGiS02z0AHXSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="156389502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2025 16:01:47 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 6 Mar 2025 16:01:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 6 Mar 2025 16:01:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Mar 2025 16:01:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yKYpILOnr4fswrIPzJ6r1XYKzSzwLjblZBpEFKZzgi0jhOofXfmRa6skc3vqlf3wCtNvXAl/LyZSzduYFDe5zxdfneniSBL9jyM2zUKhgJ7d8WnFZ9iDdhAj/aOBK2Hpgc/8069aTS6sDJAHI1H8TYYzvf5NqnMe9jR7idiNfjAPBBIXH6w7XuyQ/H53p5l9QC2T0tPPdEtkeJ9k+JrXF7KLZ+jwx6hVQGlNDGFS7A/OELwPYPWra52S4Y89g+TAIdgiKRSNSfST9CTPbbLii5yFvD4XAz70DEkMqnx9UsbBF93BDYMbDgnHN0nTOPxiRofZomUdoMrxNobJqUkftQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Op29+/BroXAe2plZdFfsWrDwLoJw0+6yW+g9jtKJhWc=;
 b=nN/NCUNtdVZMG0DuYfO5YKFkxVucUFAZUtLXfbEm9HBQo0Qmqk97AknZVB3MIX0/yxGoK73oJBQarvzRAQmaRUYLjTTvJ2e6gDxTDnCIsgdnYVcHNG4lWVe7TQi578ir0ecl6RVLyKel7u1wmcPTHRwOjA03J7Bex7Jt4uxA5NowKckBNhCg45WkL5RzR0kqtMyu6GF4SWSTCadqrucHHSDuEDxKEN9xd1VUnuBXqFjVJn1vHzN53BNj6E0HQbTA/sAGTqCX6GX8NB4r1+ypuV/HoU8GBDTG/r6lpxcYeR/8ubWAbtAFQKjQTf3N7NbuL0squhZ4VegfZib7YGHHLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8SPRMB0044.namprd11.prod.outlook.com (2603:10b6:510:258::17)
 by CH3PR11MB8185.namprd11.prod.outlook.com (2603:10b6:610:159::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 00:01:15 +0000
Received: from PH8SPRMB0044.namprd11.prod.outlook.com
 ([fe80::3f76:ba1a:2e7b:43a4]) by PH8SPRMB0044.namprd11.prod.outlook.com
 ([fe80::3f76:ba1a:2e7b:43a4%4]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 00:01:15 +0000
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
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>, "clabbe@baylibre.com"
	<clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com"
	<surenb@google.com>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh"
	<vinodh.gopal@intel.com>, "Sridhar, Kanchana P"
	<kanchana.p.sridhar@intel.com>
Subject: RE: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Topic: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
 allocation/deletion and mutex lock usage.
Thread-Index: AQHbjBjx1q5dleb6eEq5EZF781nDprNmhasAgAA86hA=
Date: Fri, 7 Mar 2025 00:01:14 +0000
Message-ID: <PH8SPRMB004414B5E1E0765C18F9A89DC9D52@PH8SPRMB0044.namprd11.prod.outlook.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-13-kanchana.p.sridhar@intel.com>
 <Z8n5CCmELvpUwi3B@google.com>
In-Reply-To: <Z8n5CCmELvpUwi3B@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH8SPRMB0044:EE_|CH3PR11MB8185:EE_
x-ms-office365-filtering-correlation-id: 94564213-bbff-4110-4baf-08dd5d0b2db3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?TgJNnJXc0vCAinuIww/CUA++zh7o4pM+9VyFbTfjyGZz6+ZrfN/9ZVXGZbxy?=
 =?us-ascii?Q?71eamtUfbBhSNQDBvnIXvcmta02Di8DS4XSJFz6gRdfTfeb0QSJiTASXtNQ3?=
 =?us-ascii?Q?TNV/o+Z5Q5CbswQnV4j/EST4cX0bNs/q4O9+rTWTNSgR1FpIEOtllvgpej7u?=
 =?us-ascii?Q?fv+HKGPgTOIf2L+n9FP3lLVViHtOghsp/7ceX9XgAmclqMnDKSCrPvpWJIQ+?=
 =?us-ascii?Q?vCgGe2oy86abhGev+o1uq5PIVfdJ/OTvLHCiguApLr51ZML5F5hKdQyRinaF?=
 =?us-ascii?Q?CGGpgWhc4jTLTd2I5JCawfA0xr+cF/lo4/4j8RF+dW0yA0ZYTLDSpw/cTPoY?=
 =?us-ascii?Q?QCE6BNDVv1vUd+ITiWMKwtOCyHGcVCa5d5Ew0yjmHvZf2Ogj8IsTyuXc59V/?=
 =?us-ascii?Q?GYO2w17Yihxb4wnPcyVVOfNl7bGxi4AtSJ8W30fnLEPWh674+PJoawVx1K6R?=
 =?us-ascii?Q?GXwi4qcbL2Tk2erYinB6xPps6WzOP2+yGlcKbhVyTUjXNptkAspp9IIR98/r?=
 =?us-ascii?Q?tUrqbbgVlgPzxW4ekO/w+OGuPqKjdPWZeKWyc5sdhOY5E3mqGiRW8HksE8fX?=
 =?us-ascii?Q?5EwYQrt+LOws+D0GqZWsa+ScWCuCHS9b9S8m80ZlFuEa+SXCt1K84+ykrdL6?=
 =?us-ascii?Q?toPmwMuFIZPg89khKfQDEGRS5cBp5nL1sbfXh72+RJWHLbDYvgPE9cAlS0Gr?=
 =?us-ascii?Q?o5y7uF4t57a57iv21PdfSpsV8i+Y9zPzTssM8yfMbjT98vZl7CKLZPY9mTxF?=
 =?us-ascii?Q?99zSBmq6zsix9kaR/Pz/vQDe1IgNn7nWcEMS3LGRYvVMMcWYK7K9+1spf9px?=
 =?us-ascii?Q?tcvkp5F8EM/cvV2LxiCgJROWn5ff2/uoeYuUHYRs6jf2h/skeCO5B6Klx2Cu?=
 =?us-ascii?Q?HQ2tjDC3oAar31RWQBzk00ish8CxcSKO9hx6+prC3s+D593fs9B8CLDKddAZ?=
 =?us-ascii?Q?arlWC7ui9v6M47mbXoR6WYwlZ7kb7E5djLHuXvOvLDoNi/JNP0bXPJzRF/yX?=
 =?us-ascii?Q?/bDs4YVMHWccM5FMN50r1Im8OmKrsLUoD0VZWXvdjptImr8Vd50RkVZSqpdx?=
 =?us-ascii?Q?G1IRLRaqk741RB1vGIMIBv+Uopz3qDGMw1PC3AFb/aMwd1/ftRSw0z/6pV1M?=
 =?us-ascii?Q?RUfFp+mUQymsZEvjDA5dUTBzPOOYyTZIPvhp+9iJ6eYG+zwdJ0cbEfilpo0k?=
 =?us-ascii?Q?M+nHUOJjMo2xy3Brt2agCk+TzQzGo0c43UFwMRoAMqh/WVTNqnHKH5gUkqXf?=
 =?us-ascii?Q?N9AagaWVLm93/Pqr2bgzkgytfKVRUjPsp00OMY7xNmPz4IZZJXRnSOo2mMcF?=
 =?us-ascii?Q?SuppbCZTIHJM1Q4QqPG0NkoZkovbHeiIRQfvzoImXIaqLgva50l6gqY7GBgG?=
 =?us-ascii?Q?uQz9YMeOxzklecyk21zCUvueA6MSn47F/s6UEu4zMB8RJlfIjwJ36chtPkPZ?=
 =?us-ascii?Q?g7dyfR8eYRh5kxtXxR2Yb/fIUAaWoqEL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8SPRMB0044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WWK/EDIssnqQh52UKnGWflBgHrQtcIJmWt3efxnlLO4z0ED89gGX+gjV4Ap+?=
 =?us-ascii?Q?bwwLmd6vybCjdIRLGWT/SKfsYF0ZuYOx4rFKGj2C2br9LbblehxC83fawA8e?=
 =?us-ascii?Q?m+ZVdZ2mU6RxS5xHrzTkA4AxtQ8jpdXIlYEcIxoRkjkuuXho+S1U1pk2pWFo?=
 =?us-ascii?Q?L+xZlOl1OkVQoRL24RnD/MIJXzCOK9sTKRdWR6L/7SNwFZPdRZGS1SG8b0Et?=
 =?us-ascii?Q?siagfPJelF1EXMi1RX4+Hl2CXrc7lox9fSyJb6AA2obUCuHHG/KKbmEXtSar?=
 =?us-ascii?Q?gsl3XRdpQIBcwVsUw72WNzMvxevFoHuy4lxMlExaeSPdV0dp2kOM4z/rjpA/?=
 =?us-ascii?Q?7U80OK6n3F5LaGwxTXynWqbfhGdx6uhgajsklDa4WoXq4/a1rSzUd0AbIZIj?=
 =?us-ascii?Q?u4CSzLfd+VihPjN+6JUkO2ZiWkABwq5XVOfkizDkUZx5FYa1w7T1O4+l3SbT?=
 =?us-ascii?Q?mNiX1mubuuNe7YQWwzrF6fYYtA2MWwekn4pPREGvWHK4o6YfoJN5Z1GIbBUu?=
 =?us-ascii?Q?uqqoCK8V0cwpvvg5eRgPjq8IWcDeIwul/PLtxlZHtV2mcLrGoRKms+RZYeWf?=
 =?us-ascii?Q?h/LTSg3stiYMe62XfivVAaDW7IK0pbCteQo6HhG6GViseKEp/FVLBXFW34r+?=
 =?us-ascii?Q?RzQkG30wpntkF7h0eKcXyBb9m8QNpclsX3jjuc4ehAHSlne9kjQ3xFNEnMHg?=
 =?us-ascii?Q?rrg4VynggQX2aJSxCReIvafg+/schFpCWWpG1gv2VZzAA3QJrJiPJGvRIZw8?=
 =?us-ascii?Q?U5EWubcCPh9WSkjSGAfGzewCAo/YSLMTz6/dcDSOGOumF6OI/iyGMWPmV1Fm?=
 =?us-ascii?Q?iJgdZpT0midJ11mJFPAHQfQCuLI951+ResFYT7R5IpSgtiApYn2jAIUGecq9?=
 =?us-ascii?Q?tq9X+BQ9WH+9rQQLHNpvwcExcPVHZGu7o7YXHCkt4yHq3R05a/Xv89tFEzwP?=
 =?us-ascii?Q?Zx5Xl956pBol1d05TIoRi4oft+vvBVVvM2jnVyFk9SUN80Pt/c3Ixpa1Pdp0?=
 =?us-ascii?Q?Yv/iQllDxvI71Z7+jdtlw+U/Z0piBJOReAPAfV+YTwARN8fJpK0T09ClIXDv?=
 =?us-ascii?Q?joyGSzZUYUf07sop2LVFMQUfn9/nfFqO3GW1Vyqonf/CxDNxdO5tidtkuyk+?=
 =?us-ascii?Q?7gdWs/754AdtywV2ntpLnI6AF8uMu14D5F0RLeweHsj6A1zqNkNS32MFoXys?=
 =?us-ascii?Q?8Lcqw8vODvnWee13V7o4KDaBfLtuMXk2rpFxEFiMhVnLuk60Em5jClyht+/j?=
 =?us-ascii?Q?DvNib41EhBO1yhQSaG8UNe+VS+53Z7luoLxw0t9TYAmK9Qv7gW5MuM8uVhk5?=
 =?us-ascii?Q?VKxxucD7YnGxj+7KjvAnUH8XgD4JZnjmvYtwI/wBtP9ucICeMgH1gS/DEcXw?=
 =?us-ascii?Q?eUcOsXd7DAP/ylIgXjBroSkarCxM1CPapi31y0CV0TqURt8+YUk4z00YBMhU?=
 =?us-ascii?Q?xtPXEC0779MmBoIFxibwae3VEIqvtNwqzlEHmuQbI5K+geMCqL3SCZkoQTu7?=
 =?us-ascii?Q?VGriStF+dPx0FHVUpL67wAmByNgZEkeSlhA6+uJsJ/0+MV7hNrMrkvucC1ME?=
 =?us-ascii?Q?/sRoztnMMZ1aca/DWfRCVUsB2pa5E7jAJeG6yMfIaFGduf2AF5dUYvF6/cYL?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH8SPRMB0044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94564213-bbff-4110-4baf-08dd5d0b2db3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2025 00:01:14.8997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzOoyd1MrBdLdhcDFgFJItbfDLB5xD7y+zhYesW0qbZ+ChvoQNmnG8oEkVgOFhklOixpfSJN7axIReZ+tGiqLBDeSeT/VrdZBspNVbrcECc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8185
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, March 6, 2025 11:36 AM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Feghali, Wajdi K <wajdi.k.feghali@intel.co=
m>;
> Gopal, Vinodh <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v8 12/14] mm: zswap: Simplify acomp_ctx resource
> allocation/deletion and mutex lock usage.
>=20
> On Mon, Mar 03, 2025 at 12:47:22AM -0800, Kanchana P Sridhar wrote:
> > This patch modifies the acomp_ctx resources' lifetime to be from pool
> > creation to deletion. A "bool __online" and "u8 nr_reqs" are added to
> > "struct crypto_acomp_ctx" which simplify a few things:
> >
> > 1) zswap_pool_create() will initialize all members of each percpu
> acomp_ctx
> >    to 0 or NULL and only then initialize the mutex.
> > 2) CPU hotplug will set nr_reqs to 1, allocate resources and set __onli=
ne
> >    to true, without locking the mutex.
> > 3) CPU hotunplug will lock the mutex before setting __online to false. =
It
> >    will not delete any resources.
> > 4) acomp_ctx_get_cpu_lock() will lock the mutex, then check if __online
> >    is true, and if so, return the mutex for use in zswap compress and
> >    decompress ops.
> > 5) CPU onlining after offlining will simply check if either __online or
> >    nr_reqs are non-0, and return 0 if so, without re-allocating the
> >    resources.
> > 6) zswap_pool_destroy() will call a newly added zswap_cpu_comp_dealloc(=
)
> to
> >    delete the acomp_ctx resources.
> > 7) Common resource deletion code in case of zswap_cpu_comp_prepare()
> >    errors, and for use in zswap_cpu_comp_dealloc(), is factored into a =
new
> >    acomp_ctx_dealloc().
> >
> > The CPU hot[un]plug callback functions are moved to "pool functions"
> > accordingly.
> >
> > The per-cpu memory cost of not deleting the acomp_ctx resources upon
> CPU
> > offlining, and only deleting them when the pool is destroyed, is as fol=
lows:
> >
> >     IAA with batching: 64.8 KB
> >     Software compressors: 8.2 KB
> >
> > I would appreciate code review comments on whether this memory cost is
> > acceptable, for the latency improvement that it provides due to a faste=
r
> > reclaim restart after a CPU hotunplug-hotplug sequence - all that the
> > hotplug code needs to do is to check if acomp_ctx->nr_reqs is non-0, an=
d
> > if so, set __online to true and return, and reclaim can proceed.
>=20
> I like the idea of allocating the resources on memory hotplug but
> leaving them allocated until the pool is torn down. It avoids allocating
> unnecessary memory if some CPUs are never onlined, but it simplifies
> things because we don't have to synchronize against the resources being
> freed in CPU offline.
>=20
> The only case that would suffer from this AFAICT is if someone onlines
> many CPUs, uses them once, and then offline them and not use them again.
> I am not familiar with CPU hotplug use cases so I can't tell if that's
> something people do, but I am inclined to agree with this
> simplification.

Thanks Yosry, for your code review comments! Good to know that this
simplification is acceptable.

>=20
> >
> > Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> > ---
> >  mm/zswap.c | 273 +++++++++++++++++++++++++++++++++++--------------
> ----
> >  1 file changed, 182 insertions(+), 91 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 10f2a16e7586..cff96df1df8b 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -144,10 +144,12 @@ bool zswap_never_enabled(void)
> >  struct crypto_acomp_ctx {
> >  	struct crypto_acomp *acomp;
> >  	struct acomp_req *req;
> > -	struct crypto_wait wait;
>=20
> Is there a reason for moving this? If not please avoid unrelated changes.

The reason is so that req/buffer, and reqs/buffers with batching, go togeth=
er
logically, hence I found this easier to understand. I can restore this to t=
he
original order, if that's preferable.

>=20
> >  	u8 *buffer;
> > +	u8 nr_reqs;
> > +	struct crypto_wait wait;
> >  	struct mutex mutex;
> >  	bool is_sleepable;
> > +	bool __online;
>=20
> I don't believe we need this.
>=20
> If we are not freeing resources during CPU offlining, then we do not
> need a CPU offline callback and acomp_ctx->__online serves no purpose.
>=20
> The whole point of synchronizing between offlining and
> compress/decompress operations is to avoid UAF. If offlining does not
> free resources, then we can hold the mutex directly in the
> compress/decompress path and drop the hotunplug callback completely.
>=20
> I also believe nr_reqs can be dropped from this patch, as it seems like
> it's only used know when to set __online.

All great points! In fact, that was the original solution I had implemented
(not having an offline callback). But then, I spent some time understanding
the v6.13 hotfix for synchronizing freeing of resources, and this comment
in zswap_cpu_comp_prepare():

	/*
	 * Only hold the mutex after completing allocations, otherwise we may
	 * recurse into zswap through reclaim and attempt to hold the mutex
	 * again resulting in a deadlock.
	 */

Hence, I figured the constraint of "recurse into zswap through reclaim" was
something to comprehend in the simplification (even though I had a tough
time imagining how this could happen).

Hence, I added the "bool __online" because zswap_cpu_comp_prepare()
does not acquire the mutex lock while allocating resources. We have already
initialized the mutex, so in theory, it is possible for compress/decompress
to acquire the mutex lock. The __online acts as a way to indicate whether
compress/decompress can proceed reliably to use the resources.

The "nr_reqs" was needed as a way to distinguish between initial and
subsequent calls into zswap_cpu_comp_prepare(), for e.g., on a CPU that
goes through an online-offline-online sequence. In the initial onlining,
we need to allocate resources because nr_reqs=3D0. If resources are to
be allocated, we set acomp_ctx->nr_reqs and proceed to allocate
reqs/buffers/etc. In the subsequent onlining, we can quickly inspect
nr_reqs as being greater than 0 and return, thus avoiding any latency
delays before reclaim/page-faults can be handled on that CPU.

Please let me know if this rationale seems reasonable for why
__online and nr_reqs were introduced.

>=20
> >  };
> >
> >  /*
> > @@ -246,6 +248,122 @@ static inline struct xarray
> *swap_zswap_tree(swp_entry_t swp)
> >  **********************************/
> >  static void __zswap_pool_empty(struct percpu_ref *ref);
> >
> > +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> > +{
> > +	if (!IS_ERR_OR_NULL(acomp_ctx) && acomp_ctx->nr_reqs) {
> > +
> > +		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > +			acomp_request_free(acomp_ctx->req);
> > +		acomp_ctx->req =3D NULL;
> > +
> > +		kfree(acomp_ctx->buffer);
> > +		acomp_ctx->buffer =3D NULL;
> > +
> > +		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > +			crypto_free_acomp(acomp_ctx->acomp);
> > +
> > +		acomp_ctx->nr_reqs =3D 0;
> > +	}
> > +}
>=20
> Please split the pure refactoring into a separate patch to make it
> easier to review.

Sure, will do.

>=20
> > +
> > +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node
> *node)
>=20
> Why is the function moved while being changed? It's really hard to see
> the diff this way. If the function needs to be moved please do that
> separately as well.

Sure, will do.

>=20
> I also see some ordering changes inside the function (e.g. we now
> allocate the request before the buffer). Not sure if these are
> intentional. If not, please keep the diff to the required changes only.

The reason for this was, I am trying to organize the allocations based
on dependencies. Unless requests are allocated, there is no point in
allocating buffers. Please let me know if this is Ok.

>=20
> > +{
> > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > +	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +	int ret =3D -ENOMEM;
> > +
> > +	/*
> > +	 * Just to be even more fail-safe against changes in assumptions
> and/or
> > +	 * implementation of the CPU hotplug code.
> > +	 */
> > +	if (acomp_ctx->__online)
> > +		return 0;
> > +
> > +	if (acomp_ctx->nr_reqs) {
> > +		acomp_ctx->__online =3D true;
> > +		return 0;
> > +	}
> > +
> > +	acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0,
> 0, cpu_to_node(cpu));
> > +	if (IS_ERR(acomp_ctx->acomp)) {
> > +		pr_err("could not alloc crypto acomp %s : %ld\n",
> > +			pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
> > +		ret =3D PTR_ERR(acomp_ctx->acomp);
> > +		goto fail;
> > +	}
> > +
> > +	acomp_ctx->nr_reqs =3D 1;
> > +
> > +	acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > +	if (!acomp_ctx->req) {
> > +		pr_err("could not alloc crypto acomp_request %s\n",
> > +		       pool->tfm_name);
> > +		ret =3D -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> cpu_to_node(cpu));
> > +	if (!acomp_ctx->buffer) {
> > +		ret =3D -ENOMEM;
> > +		goto fail;
> > +	}
> > +
> > +	crypto_init_wait(&acomp_ctx->wait);
> > +
> > +	/*
> > +	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> > +	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > +	 * won't be called, crypto_wait_req() will return without blocking.
> > +	 */
> > +	acomp_request_set_callback(acomp_ctx->req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +				   crypto_req_done, &acomp_ctx->wait);
> > +
> > +	acomp_ctx->is_sleepable =3D acomp_is_async(acomp_ctx->acomp);
> > +
> > +	acomp_ctx->__online =3D true;
> > +
> > +	return 0;
> > +
> > +fail:
> > +	acomp_ctx_dealloc(acomp_ctx);
> > +
> > +	return ret;
> > +}
> > +
> > +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> *node)
> > +{
> > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > +	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +
> > +	mutex_lock(&acomp_ctx->mutex);
> > +	acomp_ctx->__online =3D false;
> > +	mutex_unlock(&acomp_ctx->mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +static void zswap_cpu_comp_dealloc(unsigned int cpu, struct hlist_node
> *node)
> > +{
> > +	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > +	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +
> > +	/*
> > +	 * The lifetime of acomp_ctx resources is from pool creation to
> > +	 * pool deletion.
> > +	 *
> > +	 * Reclaims should not be happening because, we get to this routine
> only
> > +	 * in two scenarios:
> > +	 *
> > +	 * 1) pool creation failures before/during the pool ref initializatio=
n.
> > +	 * 2) we are in the process of releasing the pool, it is off the
> > +	 *    zswap_pools list and has no references.
> > +	 *
> > +	 * Hence, there is no need for locks.
> > +	 */
> > +	acomp_ctx->__online =3D false;
> > +	acomp_ctx_dealloc(acomp_ctx);
>=20
> Since __online can be dropped, we can probably drop
> zswap_cpu_comp_dealloc() and call acomp_ctx_dealloc() directly?

I suppose there is value in having a way in zswap to know for sure, that
resource allocation has completed, and it is safe for compress/decompress
to proceed. Especially because the mutex has been initialized before we
get to resource allocation. Would you agree?

>=20
> > +}
> > +
> >  static struct zswap_pool *zswap_pool_create(char *type, char
> *compressor)
> >  {
> >  	struct zswap_pool *pool;
> > @@ -285,13 +403,21 @@ static struct zswap_pool
> *zswap_pool_create(char *type, char *compressor)
> >  		goto error;
> >  	}
> >
> > -	for_each_possible_cpu(cpu)
> > -		mutex_init(&per_cpu_ptr(pool->acomp_ctx, cpu)->mutex);
> > +	for_each_possible_cpu(cpu) {
> > +		struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > +
> > +		acomp_ctx->acomp =3D NULL;
> > +		acomp_ctx->req =3D NULL;
> > +		acomp_ctx->buffer =3D NULL;
> > +		acomp_ctx->__online =3D false;
> > +		acomp_ctx->nr_reqs =3D 0;
>=20
> Why is this needed? Wouldn't zswap_cpu_comp_prepare() initialize them
> right away?

Yes, I figured this is needed for two reasons:

1) For the error handling in zswap_cpu_comp_prepare() and calls into
    zswap_cpu_comp_dealloc() to be handled by the common procedure
    "acomp_ctx_dealloc()" unambiguously.
2) The second scenario I thought of that would need this, is let's say
     the zswap compressor is switched immediately after setting the
     compressor. Some cores have executed the onlining code and
     some haven't. Because there are no pool refs held,
     zswap_cpu_comp_dealloc() would be called per-CPU. Hence, I figured
     it would help to initialize these acomp_ctx members before the
     hand-off to "cpuhp_state_add_instance()" in zswap_pool_create().

Please let me know if these are valid considerations.

>=20
> If it is in fact needed we should probably just use __GFP_ZERO.

Sure. Are you suggesting I use "alloc_percpu_gfp()" instead of "alloc_percp=
u()"
for the acomp_ctx?

>=20
> > +		mutex_init(&acomp_ctx->mutex);
> > +	}
> >
> >  	ret =3D
> cpuhp_state_add_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> >  				       &pool->node);
> >  	if (ret)
> > -		goto error;
> > +		goto ref_fail;
> >
> >  	/* being the current pool takes 1 ref; this func expects the
> >  	 * caller to always add the new pool as the current pool
> > @@ -307,6 +433,9 @@ static struct zswap_pool *zswap_pool_create(char
> *type, char *compressor)
> >  	return pool;
> >
> >  ref_fail:
> > +	for_each_possible_cpu(cpu)
> > +		zswap_cpu_comp_dealloc(cpu, &pool->node);
> > +
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
>=20
> I am wondering if we can guard these by hlist_empty(&pool->node) instead
> of having separate labels. If we do that we can probably make all the
> cleanup calls conditional and merge this cleanup code with
> zswap_pool_destroy().
>=20
> Although I am not too sure about whether or not we should rely on
> hlist_empty() for this. I am just thinking out loud, no need to do
> anything here. If you decide to pursue this tho please make it a
> separate refactoring patch.

Sure, makes sense.

>=20
> >  error:
> >  	if (pool->acomp_ctx)
> > @@ -361,8 +490,13 @@ static struct zswap_pool
> *__zswap_pool_create_fallback(void)
> >
> >  static void zswap_pool_destroy(struct zswap_pool *pool)
> >  {
> > +	int cpu;
> > +
> >  	zswap_pool_debug("destroying", pool);
> >
> > +	for_each_possible_cpu(cpu)
> > +		zswap_cpu_comp_dealloc(cpu, &pool->node);
> > +
> >  	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE,
> &pool->node);
> >  	free_percpu(pool->acomp_ctx);
> >
> > @@ -816,85 +950,6 @@ static void zswap_entry_free(struct zswap_entry
> *entry)
> >  /*********************************
> >  * compressed storage functions
> >  **********************************/
> > -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node
> *node)
> > -{
> > -	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > -	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > -	struct crypto_acomp *acomp =3D NULL;
> > -	struct acomp_req *req =3D NULL;
> > -	u8 *buffer =3D NULL;
> > -	int ret;
> > -
> > -	buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> cpu_to_node(cpu));
> > -	if (!buffer) {
> > -		ret =3D -ENOMEM;
> > -		goto fail;
> > -	}
> > -
> > -	acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0,
> cpu_to_node(cpu));
> > -	if (IS_ERR(acomp)) {
> > -		pr_err("could not alloc crypto acomp %s : %ld\n",
> > -				pool->tfm_name, PTR_ERR(acomp));
> > -		ret =3D PTR_ERR(acomp);
> > -		goto fail;
> > -	}
> > -
> > -	req =3D acomp_request_alloc(acomp);
> > -	if (!req) {
> > -		pr_err("could not alloc crypto acomp_request %s\n",
> > -		       pool->tfm_name);
> > -		ret =3D -ENOMEM;
> > -		goto fail;
> > -	}
> > -
> > -	/*
> > -	 * Only hold the mutex after completing allocations, otherwise we
> may
> > -	 * recurse into zswap through reclaim and attempt to hold the mutex
> > -	 * again resulting in a deadlock.
> > -	 */
> > -	mutex_lock(&acomp_ctx->mutex);
> > -	crypto_init_wait(&acomp_ctx->wait);
> > -
> > -	/*
> > -	 * if the backend of acomp is async zip, crypto_req_done() will
> wakeup
> > -	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > -	 * won't be called, crypto_wait_req() will return without blocking.
> > -	 */
> > -	acomp_request_set_callback(req,
> CRYPTO_TFM_REQ_MAY_BACKLOG,
> > -				   crypto_req_done, &acomp_ctx->wait);
> > -
> > -	acomp_ctx->buffer =3D buffer;
> > -	acomp_ctx->acomp =3D acomp;
> > -	acomp_ctx->is_sleepable =3D acomp_is_async(acomp);
> > -	acomp_ctx->req =3D req;
> > -	mutex_unlock(&acomp_ctx->mutex);
> > -	return 0;
> > -
> > -fail:
> > -	if (acomp)
> > -		crypto_free_acomp(acomp);
> > -	kfree(buffer);
> > -	return ret;
> > -}
> > -
> > -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node
> *node)
> > -{
> > -	struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool,
> node);
> > -	struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool-
> >acomp_ctx, cpu);
> > -
> > -	mutex_lock(&acomp_ctx->mutex);
> > -	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> > -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> > -			acomp_request_free(acomp_ctx->req);
> > -		acomp_ctx->req =3D NULL;
> > -		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> > -			crypto_free_acomp(acomp_ctx->acomp);
> > -		kfree(acomp_ctx->buffer);
> > -	}
> > -	mutex_unlock(&acomp_ctx->mutex);
> > -
> > -	return 0;
> > -}
> >
> >  static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct
> zswap_pool *pool)
> >  {
> > @@ -902,16 +957,52 @@ static struct crypto_acomp_ctx
> *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
> >
> >  	for (;;) {
> >  		acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> > -		mutex_lock(&acomp_ctx->mutex);
> > -		if (likely(acomp_ctx->req))
> > -			return acomp_ctx;
> >  		/*
> > -		 * It is possible that we were migrated to a different CPU
> after
> > -		 * getting the per-CPU ctx but before the mutex was
> acquired. If
> > -		 * the old CPU got offlined, zswap_cpu_comp_dead() could
> have
> > -		 * already freed ctx->req (among other things) and set it to
> > -		 * NULL. Just try again on the new CPU that we ended up on.
> > +		 * If the CPU onlining code successfully allocates acomp_ctx
> resources,
> > +		 * it sets acomp_ctx->__online to true. Until this happens, we
> have
> > +		 * two options:
> > +		 *
> > +		 * 1. Return NULL and fail all stores on this CPU.
> > +		 * 2. Retry, until onlining has finished allocating resources.
> > +		 *
> > +		 * In theory, option 1 could be more appropriate, because it
> > +		 * allows the calling procedure to decide how it wants to
> handle
> > +		 * reclaim racing with CPU hotplug. For instance, it might be
> Ok
> > +		 * for compress to return an error for the backing swap device
> > +		 * to store the folio. Decompress could wait until we get a
> > +		 * valid and locked mutex after onlining has completed. For
> now,
> > +		 * we go with option 2 because adding a do-while in
> > +		 * zswap_decompress() adds latency for software
> compressors.
> > +		 *
> > +		 * Once initialized, the resources will be de-allocated only
> > +		 * when the pool is destroyed. The acomp_ctx will hold on to
> the
> > +		 * resources through CPU offlining/onlining at any time until
> > +		 * the pool is destroyed.
> > +		 *
> > +		 * This prevents races/deadlocks between reclaim and CPU
> acomp_ctx
> > +		 * resource allocation that are a dependency for reclaim.
> > +		 * It further simplifies the interaction with CPU onlining and
> > +		 * offlining:
> > +		 *
> > +		 * - CPU onlining does not take the mutex. It only allocates
> > +		 *   resources and sets __online to true.
> > +		 * - CPU offlining acquires the mutex before setting
> > +		 *   __online to false. If reclaim has acquired the mutex,
> > +		 *   offlining will have to wait for reclaim to complete before
> > +		 *   hotunplug can proceed. Further, hotplug merely sets
> > +		 *   __online to false. It does not delete the acomp_ctx
> > +		 *   resources.
> > +		 *
> > +		 * Option 1 is better than potentially not exiting the earlier
> > +		 * for (;;) loop because the system is running low on memory
> > +		 * and/or CPUs are getting offlined for whatever reason. At
> > +		 * least failing this store will prevent data loss by failing
> > +		 * zswap_store(), and saving the data in the backing swap
> device.
> >  		 */
>=20
> I believe we can dropped. I don't think we can have any store/load
> operations on a CPU before it's fully onlined, and we should always have
> a reference on the pool here, so the resources cannot go away.
>=20
> So unless I missed something we can drop this completely now and just
> hold the mutex directly in the load/store paths.

Based on the above explanations, please let me know if it is a good idea
to keep the __online, or if you think further simplification is possible.

Thanks,
Kanchana

>=20
> > +		mutex_lock(&acomp_ctx->mutex);
> > +		if (likely(acomp_ctx->__online))
> > +			return acomp_ctx;
> > +
> >  		mutex_unlock(&acomp_ctx->mutex);
> >  	}
> >  }
> > --
> > 2.27.0
> >

Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792598801;
	b=oKaVzIPDEqCvOu9ZC9WUSzEH/ciicr+SJWz9vYVqtMguPJF21yAdv79Krk7T56ijAZK7
	 r79LkCJ8JBfau7n40xrFJaaNkS2cypTc7qOqJ9HWgmgPLWqxmLYTG1V3nuvLgs2EkBj8R
	 DMcuOXz7kUjQPz+3T6g8Nv9qLmYpybc4wzMr/45Skay4Iky8Mpb5t8kTQx/fwyPbDzxjR
	 XFqyRniVWxANLkIva/lyzzOqEVUiL8cPJdxgU5fY2HoTp5Q6DUYo87I/z2E+oKd3KUP/s
	 AJRmr4rP1vTbLHljBDjmaDJv7uAJIJLaZITkIg4E3eTpVj5VofyWOSbJ/jH5rGmoKMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792598801;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:Organization:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=an9823I+eFe9XoLrhJItAgr7Sl8cOC/Uj1pUVXYLagg=;
	b=jZm6ArICaDJglSpB3dIfOR7BnUEvbn8ggGC0HWaaQ6Jk96UlYbdacLlXUHc/I/1eKVEC
	 ANCqtiJzrG+JNqq2cvWIoNiod4OIfHIm7ECBK+J+9mlNgdBelRcrOVavN1/HFRCkNO1a3
	 ytOLoRa+NrBwYYDl6IC6mHyP+1iONgFL3gwk/eaq0GyV3lqhZYfF0WxfK4nMBWF0ZDZQi
	 E1GJzF/AqubOAaRrIZpHtJGcG/KhhgzQeLFoqjUoGW6lqNAWHuJSEsAooHxrgUGpK9mJW
	 3YUrIDdDliGI5qZnj2x/czhSHKchhyweC+teOoiBtMBf9oPBw3baz7T4OQ+BqSoX3kQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aUuSKCpr;
	arc=fail smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76632606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 16:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76632606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aUuSKCpr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792598801; x=1824134801;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=opDkm1oajge4PpD8b0JPr0MDwlfMi0kHje9Vrm5CGgU=;
  b=aUuSKCprYCkWsumxyKiu6K1BHxXFr689xaD66cXrXnlVxq4rBcVFBRTq
   mF/sm1YBApWVMsg3paH0NT5iiYg7/UOKnsyvQbOytGcCq+U+xfi6+D47/
   ic9E0h8+SLCmA/KPDryFtOsXAcu6/RpZ//3Voj1pu26wOp+elCjiqXKsP
   Jz1APMSULCeF2gyDE4nBbbRhMxGCGyA8NsNy8N4Gf0Au3deWonXOB/AqT
   eKNpE6hccJRPcvrJ4ZzQfOHVHEylW3wK3ZUZJb/YLdnmZFWoqt1oNLxqD
   AbKGfp1L4ZdUI03fMwMmJmX6CoY9CborcDOiuUK/oHkogIX92ts2CwnGg
   w==;
X-CSE-ConnectionGUID: usOtXse4Sx+z9FUHveFXFA==
X-CSE-MsgGUID: bS1Uw5NLTCyJJdv6Kb96TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="1426347"
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="1426347"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 09:06:40 -0700
X-CSE-ConnectionGUID: Z2R1VZ40Sg6/YnRmopEKLQ==
X-CSE-MsgGUID: oRXcSsxqQzifd5ACfU0Q+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,170,1787036400"; 
   d="scan'208";a="3463751"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 09:06:39 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 09:06:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 21 Oct 2026 09:06:39 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.15)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 21 Oct 2026 09:06:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AJOqinVo3459vkOmp8mTXFnoNmiaO7feejG1O8NtYDQ1/pjy0lKcKJVWaHAew0N/Nf4K5vwB27D0TlXUvnN4L36q5d8u+7S026pxCEXCpQJi+gQqyKXQXDEkIbIH4PDZv9RZePeoB5v7bonk3Dak+vvE8YN2zE9rug/i8n5OKCVXt43DfYXVi3cjxY5Kxj7NF+p7eSYy5s+vBOkB/rRP14gX8yObeBU8iQuA9s3qnq9tIdZRTB02gijUGbbXpmjG+m8pKdEAVQsZSzsXjJJ6zvrOz26+5r1G9hr07+Bd6sNZiEJWLb4c8OXW1qNex1hxrNKB3GcEsoeRsFrgORQd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=an9823I+eFe9XoLrhJItAgr7Sl8cOC/Uj1pUVXYLagg=;
 b=YCo9sWRiEXEWKcy+dQ/rJwJjsDpQ3Sz59+YFt5oOdgjXT5CbkcUL6zo9dDfrJ8F94VRF+U4hvadnY3xQE/59D/Z913vuf7DZ81y3pmaXUzItGjY0HhuauBBANUpx/XkskB0gZgiEs7gD0GKivMn04aVmsBXHFuYmwx3fvAuMlFEAsdpGueWAyGarwvIrvtKGn2C5miyMZaQr7bZb/LpGvKpITjNKfZbC3DRwBzTqzcTsQrlRH1fh8YgC63GUPgxFzwtQ8I+Ta4C4O2JpWtRR/mffMUjG1CyFgjZwyDJY+N4HPiWNP5ktR6fgVl2vmbT9dbV+LjeFTfbUy0lcDguyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9230.namprd11.prod.outlook.com (2603:10b6:208:567::16)
 by DM4PR11MB8129.namprd11.prod.outlook.com (2603:10b6:8:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 16:06:34 +0000
Received: from IA4PR11MB9230.namprd11.prod.outlook.com
 ([fe80::578:a20c:8f82:7505]) by IA4PR11MB9230.namprd11.prod.outlook.com
 ([fe80::578:a20c:8f82:7505%3]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 16:06:34 +0000
Date: Wed, 21 Oct 2026 17:06:31 +0100
From: Ahsan Atta <ahsan.atta@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH 0/2] crypto: qat - enable three-service mode for QAT GEN5
Message-ID: <atjjByqRsd3sCKZY@soc-PF5467PW.clients.intel.com>
References: <20261006144840.2514754-1-ahsan.atta@intel.com>
 <atCYTTHMcE2KvMjf@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <atCYTTHMcE2KvMjf@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB9PR06CA0015.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::20) To IA4PR11MB9230.namprd11.prod.outlook.com
 (2603:10b6:208:567::16)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR11MB9230:EE_|DM4PR11MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 79cad5cd-7b38-4c99-b425-08df2f8d476a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10070799003|4143699003|11063799006|56012099006|10067099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: CYHfnv8TMj/R4G7gNIfdRzfAE1eWxNvfEey8XdZhBLSG0w7+EuIOvd3UMiOkiqvGOSKiQ4nZJQ7GTwhtZGeX4wcOblcE4hMgGBFnc9iXCXUt+gYgYKyUkPyqx41A5nV/LxwfiB55bMcUDqjCApErYY4PtABJCLLoh4HzSmCY5AY6eFFISfCGo5ALIUh1+nLPsdSf9lgfq5QPHsfkXeO0AMrhGUENA5BVVHGa8SUXCgOo7i5Wjrd6lrspi+KatofxiXKPc1TgutijLDcYgCK5e+grbhLhv/lTzhIYT8z5HLSvpGbpshWu0csowSrM77RKbyIvcuPmZvLMy1NMyB5PV+geCqYUIZRv80toCdRbGevQsZeAPzJUrgBHegq87xj4VjWBm2/p4cmA5tIQZuVvZV/A+Fll+itBTMBi88Ef5HjhzdDHlSMHtUSgNggO3vDSJLr3ClQYVFH2XEcEVKeQLteGx8lD53QHwAFje/6snQ/XQuMC/bMPSSFzWSPX+OragSXS8eINHhOPwbOhEtmnzzTXS8oJWwyiYTOQ6/0q7iYXNJi1i/kjMHyVa2KVN+THIORi66B6Ig29/mCJGjqR1UMgF5L162JTGprgnYuxgZ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9230.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10070799003)(4143699003)(11063799006)(56012099006)(10067099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JwQsj9tc09XLd1o1vQdpPpfdNyLirZZmFGmgM6019J5oH3Z8xWXt9uKTrAw?=
 =?us-ascii?Q?8zUpygypNR4GTbB9sVz6PaASr3BgmECDFcIcCoWPZr2XJukPyjjr++K2B56y?=
 =?us-ascii?Q?Fpp46p0ISxou4nrvyAGoitIm6rmX2KdsO03DHzofoNNKhnZsqon8Qe20I1Ri?=
 =?us-ascii?Q?tMPmZMm9gVq/zaDMK5Jx2r9VW1kSWPfVvTDzAMIUa6DqwjrWNwgeczvkY1X8?=
 =?us-ascii?Q?P8AKLF3aeVlr+TcUsKHPZx3mqaglogyFgPYK5JkZZbQBbQa5VBPRvkLKoAmZ?=
 =?us-ascii?Q?utyWqXuSCsKho0MZmcWWECnRE8EDrK4AFh8aD7HP/JmYfb0/xdOJJEqaKJOp?=
 =?us-ascii?Q?18W6AibviaElRBYT80B809Ypa8suCROBGCfTr/LmZY43ioRbGbIZkrh7P3pg?=
 =?us-ascii?Q?AI43aMxVOI+w+ZCGOu4qK8IXEWrtJE8F99qfcAuvXsgNAYs6xRQn8u+adsdD?=
 =?us-ascii?Q?VXo9O/hRmgGHL8gM71dKSo1F9vyvYkxMmPhaTv4cmZrSSnW8IWo4Ae8+xUEf?=
 =?us-ascii?Q?5Rmmp+YzkOoQf40+oY/l+BMxryOkrGi2UtTqOZyT2O8ZWKTqlec9YR1cnZfp?=
 =?us-ascii?Q?riTI+qAnWQN+SreUyvvP9VI7HlOTp+ad58Jh/tCOZh8Lkut/ciriXeWQquD6?=
 =?us-ascii?Q?y/3qnjMu+XwoZ1xwWbNMXMIBVJBCAD08+DcyQdw+qjjEem4S2G+AqAtxBq1X?=
 =?us-ascii?Q?ZTUEpNNQNGOAoiAaXtyZRj5wKwlMd0GFeglR0odTDQppZ5VVjCMG2UTAEyc9?=
 =?us-ascii?Q?jxygNGMPJLLUbKn64ry6St0i6QOA65rDn9WEnGDrLO4H0tRkA5wF1SqPkxKC?=
 =?us-ascii?Q?Uab6eJmV1gK8z54Lww6PbyjFMMKKqjRRBh1cq+WnwuUyY8PFB0073FbR07uR?=
 =?us-ascii?Q?1epiaWfy/tREaTe5B2gDEAVvyUb3I0r9l+cnQB56IziJq7SC+/TEmxKt9SUe?=
 =?us-ascii?Q?X4tKpfeoy4zSlvISKs7mSqEWDYcpSj6sodJ0etUNA8DWyuwnlbAXRPYaIp05?=
 =?us-ascii?Q?rbfDtDi6/dd6YxBv38Ne/5TITZwk2JcsQ1/De43SLuaLguQQaE1Tox/i7jkV?=
 =?us-ascii?Q?XNhTLj8IlfLE8geI+QdQu6ANKEtR5fBXR+Ia2mCATjPMETNIN8+FjQB99CIH?=
 =?us-ascii?Q?cd4tD9SgPzqxSGW1bM6JJv9EMUyXvA7GB9skPxEqdbZ6bJnmV3Hen02xqXyi?=
 =?us-ascii?Q?VwAVroEHoP3zAivQM/l0iEn3pMlpuKnDSpc1n7xEYO0yMnxIj/aLxShRFxkF?=
 =?us-ascii?Q?cQVQd51z8F/MZ81/HFe/+Vb1qQvtrkDXVvfSUY9gEpC1sNH71hMDXZXYq9a1?=
 =?us-ascii?Q?tAGoqrjZP6paVZLzrhfPa6vj33VbB0p6T7QftoagWBh25Tfev6/yaqOVh1Qr?=
 =?us-ascii?Q?IzvsHgNlKetmuTewxsd4bSqosL0BS1CxumzA3dwObUXIVBbnmEXlFW7pYrE4?=
 =?us-ascii?Q?RVdsdW84OvIRXtOcGK0PbR8Ct2Tvedq8oWyFbFl8rbXsLFI3UBUWpOIKA/Ny?=
 =?us-ascii?Q?LOz85VSZWriTOl74gyt03wS3DVX0tVvaarTb958LzlKNcnTvoMfsg4gzf+Dt?=
 =?us-ascii?Q?OpN2tn+suVBlsTmLL7JzHal/X+B99TA0oB1RmgtpSZRz1GDtegZZVce9FGMy?=
 =?us-ascii?Q?0wN21rMwnevV6OUv8O4/c+skoz7v4c53M9iKQPVg97Rn0TG2PrEcDD8b3g2G?=
 =?us-ascii?Q?tOlGeNRTFse6DB7GcmuqmtYbjF+35h9kQUNmLdaAi/3bb+Uaf72MXX3J1l36?=
 =?us-ascii?Q?F+gvh4AVqBuBubt+lTgh7n66OZzQ7lMkigeOh2dTXoeKhG6obU/1kACvdWMs?=
X-MS-Exchange-AntiSpam-MessageData-1: uwrmGevTdCO56A==
X-Exchange-RoutingPolicyChecked: 5tIg2Mk7/b+8EBZ/zvJmmnsb5QqfrCXxyrXzFCQFxS2Rqu8lyL1Q7EEiSMfyZPOJhyiQejye2qjc0c1cr6Lw7gDUGR3ZTG8z96zP7qL4a89dvDogo2Uuk36GgXCh6OALAfJc7Sq2u4lgaRE0kHJ7UGXfiowrPt5k3QukR+hRc52Gw3xxnfe0EX22QcXzsBbc8p2Qw6yc73ipaioUrYME24TvDwrbdUjTOSiiYbEv22vKEuWo36hTjAOLIzccz72QZn18wuMqsPEMF8vpR82dLXX+vCp8gxns6ny0izEDy3XKgZDJ5gX7arkpLTSKTIGQySy38PM54XuSCEuMLygn8g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 79cad5cd-7b38-4c99-b425-08df2f8d476a
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9230.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 16:06:34.6215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jA7+5iuSNIhBpb2JdM7sx31QrEQVNytg6wBabOC4sNAkqIiFFokr67IB+igiVYzvLvjdXvNDvDiZFP8cX7iJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8129
X-OriginatorOrg: intel.com

On Thu, Oct 15, 2026 at 08:09:33PM +1100, Herbert Xu wrote:
> On Tue, Oct 06, 2026 at 03:48:38PM +0100, Ahsan Atta wrote:
> > QAT GEN5 devices (qat_420xx) have enough accelerator engines to run
> > three services concurrently, but the driver currently only allows a
> > maximum of two to be configured at a time, matching the GEN4 limit.
> > 
> > This series lifts that restriction so that symmetric crypto, asymmetric
> > crypto and compression can be enabled together on GEN5, as is already
> > possible on GEN6 (qat_6xxx).
> > 
> > In summary:
> > Patch #1: Define the firmware object layout, ring-to-service mapping,
> > thread-to-arbiter mapping and service-to-accelerator-engine accounting
> > required for the sym;asym;dc configuration on GEN5, and register the
> > new service combination in adf_cfg_services so that it can be selected
> > through the cfg_services sysfs attribute.
> > 
> > Patch #2: Update the cfg_services ABI documentation to state that GEN5
> > devices (qat_420xx) support a maximum of three combined services,
> > alongside the existing GEN6 entry. Documentation only, no functional
> > change.
> > 
> > Bairavi Alagappan (2):
> >   crypto: qat - enable three-service mode for QAT GEN5 devices
> >   Documentation: qat: document three-service mode for QAT GEN5 devices
> > 
> >  Documentation/ABI/testing/sysfs-driver-qat    |   4 +-
> >  .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 104 +++++++++++++++++-
> >  .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |   6 +
> >  .../intel/qat/qat_common/adf_cfg_services.c   |   3 +
> >  .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
> >  5 files changed, 113 insertions(+), 5 deletions(-)
> > 
> > 
> > base-commit: 32117b78aa099e5991df76c34ffbe18260342ff6
> > -- 
> > 2.50.1
> 
> Please check the Sashiko review:
> 
> https://sashiko.dev/#/patchset/20261006144840.2514754-1-ahsan.atta%40intel.com

Hi Herbert,

I've reviewed the feedback from sashiko and I am happy to ignore it.
This is because at present we do not have QAT GEN5 SKUs that have some
of the AEs fused off.

Please let us know if you would like us to re-send the patch or you can
just apply the existing one.


Regards,
Ahsan

Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792773176;
	b=oRHmpsmvNYLToBy6EnBTLRsOJW3vdaSZmw2cutSdBzHk4Aiek+lX+pzXUuRMd9rXSSjF
	 o/O8IpWEHLksjquxpvFM47osEeP/AUQi+f7bDdcNOttbFwqQR63XDe7Nvw4fIf50p6ixg
	 ww9Q3mB5aQ6EdR1hu/Kw4tMUSbrYUtoMynjuE2c2UQp5yWz0AmMHs73K91fYqI1yYc+Xv
	 xgZjhTbGysuVKy9GLHj8ou+si4qbbXMdTBLTqEP/XN20s3VhnzLxzJolmm4xab9Ii+e3Y
	 G4wgpTyEAuQXfpxmC7tuZKjq1VT9W4Ab5O6lyHrShF8QicbO6kqoJs3vyoWpLpiIHtw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773176;
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
	bh=uvTyg6ZLRnYjy/bD29sa6uZNFZknVeyBKNU0kdZ+u8c=;
	b=iWw7OWHEu07suqvLJdXUVJpFnuyMiQV+UR9zJCDfQGO1OgVlVuDah6LPdzJqRcTm3kK1
	 1qVKcsAiOZDHdhdHwXEtP57YsMoWS1bVtlNBhRYoxiucM4qqgLTcnddIMFtWk6fUNeeN9
	 ew3Muk56LLbm36QA3ferIb+DQVdFO0vbtcw80uveAm2f1tPglkgkDJg2fR6Pb5BLWelK9
	 YrzIpRRdPjkc0fTHKcd+x+Qf9kHvd5Hpq95IlZOAwaJaP8d7TpfczsfGKA1yb0fMikbgB
	 EiUlwqhSjpa8J/n4W+5NNJALqrgTACYZ10QsX9cvbnCAFBWRe0ZpBezSN7MKy3P9SMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fwTuUev6;
	arc=fail smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF1606A338
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 16:32:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAFF1606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fwTuUev6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792773175; x=1824309175;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=undLnql+FgdWdR5e0mPX3uTiI09wc3t7hpsjehb0fGE=;
  b=fwTuUev6MSV/+GIbIwZrpWP6vVF+Sh4+GCVjjVz/hCtgacvmDpqz4pO5
   QDR7jVXyCLpgKIjSR4voG2Gp0u/QGSt/vtWJXugzbfjmwiP4ZGFj8gJjv
   iDS/BNTdl+NG0rjpS6hh6hkZEXNQbgaGhnolbcdJ+B3yT9SRVxyrjg83+
   Y1LWDCoACSLORjTT6F+ewQvCwg4YgH9irWlDQXLpXs5cPjbKTRqV1gKxT
   5P7qF0zM9e4v17xtIu7KXJNmFrTfxr91vTmoW3xzwMJKIU7NM8DCQo7y+
   eRoXVTQtz8SfGtKXRgbqmhbWIYYQ/Z+JrP3OQIb3oQaW4jxw9qsP6HOVz
   A==;
X-CSE-ConnectionGUID: rC9gLVcBTHuwSiitblifWA==
X-CSE-MsgGUID: bnW4ZGKaRJqA8NoNEzkgqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1426373"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1426373"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 09:32:54 -0700
X-CSE-ConnectionGUID: KNpNAQAaQ3u1xYpKKFmH5Q==
X-CSE-MsgGUID: sgh/jEgXRJyeqWnAPtyONA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3678325"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 09:32:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 09:32:53 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 23 Oct 2026 09:32:53 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.41) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 23 Oct 2026 09:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aiQ91UtnqZMYvnZXqEQ4Xk4G/Tr9D1Ue3XnmD22MpANkvI54SapV0Y3CHQ8PLgYeKhInu+s8AYtqfD4fn3/m7e2EI04PSa3mjaq7P4Scq5LUeRYummdIzAn8co7sqejdldWvVxqfzy8z1KHHeJugjj48u/SI4OXQtnTiYCK2tBuedAlOwsNxeUU1QVsEwYbqrfLI4zEqMlhXFM2X+8mtCmt8AqXeWaPbV5JJFSTfdkIXEjMCpZaBxiVMYjes3GmkFtUIwSj9V2BwZNd4yaHnrGj0CQNmKGj5FudJPa60i84z/1WvxmrwPf+UHzseKVBlLTbsWjhoCHl3KFfPpRg48Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvTyg6ZLRnYjy/bD29sa6uZNFZknVeyBKNU0kdZ+u8c=;
 b=uvCuajqzIU6FACMYLjpgD5zXiC65qu6gP6k+0QYHxloPxqy2k1WofONtyr0SJQSJUf1Na8bKBBD5QraIHKit9YcXUtT/UQASWmVnvMA/gcrTu4LhmqjafB/Gwi/mSwDnX1uEbRynuYzXsq9REBgI6j35made0epis8ZJzbbsZRF+KmuBCSJ/BuvnWTFTc751jYw71QQKh8pRwQiC7Ak1SgykkVxGl/WuQSeCKjrfozfKa9f4gw4E+FYWIRMnXUkryNWouLOUqK3bpieJY5PrF2RkzoETGzK7N/BTjUUF1IgeLCAq06Ka48Irxjv4X6SU8yD9idmDOe0vwdOp6SgWeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA4PR11MB9230.namprd11.prod.outlook.com (2603:10b6:208:567::16)
 by SJ0PR11MB4944.namprd11.prod.outlook.com (2603:10b6:a03:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 16:32:51 +0000
Received: from IA4PR11MB9230.namprd11.prod.outlook.com
 ([fe80::578:a20c:8f82:7505]) by IA4PR11MB9230.namprd11.prod.outlook.com
 ([fe80::578:a20c:8f82:7505%4]) with mapi id 15.21.0546.016; Fri, 23 Oct 2026
 16:32:51 +0000
Date: Fri, 23 Oct 2026 17:32:47 +0100
From: Ahsan Atta <ahsan.atta@intel.com>
To: <sashiko-reviews@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<qat-linux@intel.com>, Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH RESEND 1/2] crypto: qat - enable three-service mode for
 QAT GEN5 devices
Message-ID: <atuML5Yt9x9HwmIZ@soc-PF5467PW.clients.intel.com>
References: <20261023144835.170453-1-ahsan.atta@intel.com>
 <20261023144835.170453-2-ahsan.atta@intel.com>
 <sashiko-outbox-182890@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-182890@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0189.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::7) To IA4PR11MB9230.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR11MB9230:EE_|SJ0PR11MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: f8335250-89a5-4e47-8ce2-08df312347c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|10070799003|366016|1800799024|376014|10067099003|261009223027099003|3023799007|261022075727099003|261022105027099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: oI2asXAmupykNtv88I/lpRx7acQ3rUaRaVV/oy136KI/LOmx8QAWPssPo/5EuBp++BeUwNT7VixUh+vjOWYZDsCBUWwjeGn2V0HU25d3w7ly+KIvIF0HqYI9ML0w7xzpU1K3iH+6DHFeY6ZCwNaG7d+yYPXPrjf3G7hcUjAREPcFHkazHH6/oK9pDMRnXsCQY7avqEizoF8au9AHLhRbhN0VX//hcPAFpVbfKpy1bZeUstmD0TnC+5xP1fLYvxmsgUhAHbcxrChUyufr5Lx9Y/5m14aweSllUT+gANn9wC7cVUFL1VSSBGTbiqQEktObrdQW+lTHdGgOVHL2ecmdpg0EiYKlOO6hj037u7vypV6ZiHppNW1QBqVplnXTheoAlHrR8cxpUebGA+j8Sm2z4YaBEo/N2wG5OD5hZQeYAZkII153sEPb3PLqT1ASv27pX6Z+FxkYPCDDbj+x5zOUJ+9QOdzTN3dJkcFOBagwvMCdl1hW79WFliMX3RrfP7vNUPd58lM66npwr7ZdJ8L4LOhUwIVZ7IM8gmCiCEFGafr7ASp8gi+zjWTthitIzi+ZIh2HckYmpAFM9YjeQsA9bVECC0uT9Mjo4GpQoucEtdOmlXzwIjKa7e2ucNwXUD4c4ao4eBzyOb5Zr2yfhlppszjI49ICtD/A2WfOQcIHPzk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9230.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(1800799024)(376014)(10067099003)(261009223027099003)(3023799007)(261022075727099003)(261022105027099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T6G7bi/VvOea5ACid6caCjF6FmY4Lu5Ldswqo1JqoulXtIUhskAi127DVYGX?=
 =?us-ascii?Q?T5aTLjqfnT7XXRsNkWznPxKct4CDmlRfII/nt96PtP2ymE8aQJyybcIoGkze?=
 =?us-ascii?Q?GBDHW/r+6/5IrW2hQOVnOPj9ELJWFyzzwA8aJQG8nNFrzRum9Oj/IK0GvYVw?=
 =?us-ascii?Q?LFjSfH0o4LJIwHzeoqTqJ4fCHL1Ojd60qAj65IE83CQ086G8NQsps3QiMSB2?=
 =?us-ascii?Q?X1uYQZRKA8SEOuRbD/CMMWOledIizL2aEe0EY5PEmX4Kq3SdIwKOngloY2h6?=
 =?us-ascii?Q?oBhsvKq6B7uHlDyYjTLZRAeHlAE9MA39FDaUsVq+9JC07CPHxYru/GcLBQSE?=
 =?us-ascii?Q?2H5WNscUJzEAt28/x1QUZGOqmAH+JgP6GZ3MnzSr9lcF61FVB+GwI3q96JSZ?=
 =?us-ascii?Q?YywSzf35oyzXLL9ZtcjbQCC1OuFmvNjPPWgnPLGcrELTCApQw5CpzSrsGXP6?=
 =?us-ascii?Q?9XNzvQJrsqFbcX9OnA/172+jSTpYCUiPaoKAp4WI9vFlFT4uztC6lO87T5PB?=
 =?us-ascii?Q?zQQq9+Abo7jPqJWTXqZxYv8WotgJxqmXa2uXaRC9R2HxzMLyU+6+r2aBqnd7?=
 =?us-ascii?Q?srHFj1OH2aqClAdtb9NLLLAHPg2RUGtUgoYvRL02O2jDQ5j0rQh8zPxnWoid?=
 =?us-ascii?Q?l+LrtBqyLDsC1NrtsxHMk6SEx1v35wX0QPz5YGtQgZBu5ghq27nWQ3W8d9cs?=
 =?us-ascii?Q?lyuqIqZbzETomrbv2gkvflxUfavGKV0EBiOO1sqwSTBTRFJaAFtNYjqq7Nj5?=
 =?us-ascii?Q?Xi8VDz4CTtDXu4jmS6ng9iPXLuStfMmO2eP16Hn41bwknaIyNkfmQ/IEW6yZ?=
 =?us-ascii?Q?EKA7WbLl+VRD/W43sRs6mnalMKOc+9GdoGGxqkzyoZsqR189uAktQPlkPK17?=
 =?us-ascii?Q?jJl6onA8L5GAYJZVgF05vR8uPorqv1J0jfBmwRrvb67b0jrdqsS76WcmZRus?=
 =?us-ascii?Q?WrwP0a8Sz7sgsEh3Dy82xEqQ2cYhroki/eSrBO2A/TzYE9hnOlSxVNQczv7N?=
 =?us-ascii?Q?JzELPGn4IQZX7zawZndDKu+X9/U194AO90+pQnDh95sNht+PolzH8pjYiiGb?=
 =?us-ascii?Q?lfjdnzm/4GjY/mY5wAjk0A5TS7/+r0GFwqI2t33uqeGbfiIF6Um1xfpvg8Eg?=
 =?us-ascii?Q?8ZvhZwbH/kvRwty2oddFniL5CmJenhzDk9BbSFy5uKATN7J75nMgz3l5DRRr?=
 =?us-ascii?Q?cwtliqyuXbSpJKQLoez+2XQQnrWzbZWnKFAI+SH4eOGA2nzcowjurUI5DhPD?=
 =?us-ascii?Q?42o8idLGgOmtCa0pQT/nDsIV3em0z1HuqHo7f9PDnFtFIfZB0ALSzSOlqPgU?=
 =?us-ascii?Q?N8fDP7balD79GfNp037K9Au+3HgNiZYFqtgbnpagEDhEtr25pLGMlYYfD84O?=
 =?us-ascii?Q?f72fVLFVVlnzJgonQJZzYzqxTOfojmzpOXwEzV84KLNlJ12rQNMkJVyVNfJF?=
 =?us-ascii?Q?f0m/QAKRpXBRtbIafHawhp5W4k3d8LdtftDsEUE8Nd3fKtjSLMAVQoiWhIm6?=
 =?us-ascii?Q?mFp2LJwVpDHfF2923Fkq28JGasKLR+C0qTb1oWgcFnKB0p6XUhO9KBwbr+YO?=
 =?us-ascii?Q?mBhJw6gSdGviRuJF60EEKMWhcs/O8lImv2uYwhGiXwILyN9TxOGu/Idzd5IR?=
 =?us-ascii?Q?iEohwOULqHkc9sw+1feh2zxD4BUxxliRgVHyQp6kuDRNAHpFe5WGBnnT1aB9?=
 =?us-ascii?Q?JtYZSSQdDr9qAMrDm05+xB+TiSVSbdlgAz+NDx4MpD/liaXJU2lMXIKZ/+GT?=
 =?us-ascii?Q?QES+TxmI20wZlljAfkg9jnEpIJKUrEHJowAc+7jYLmSCUjvIDNoznxOHfzDm?=
X-MS-Exchange-AntiSpam-MessageData-1: nDLRyJ5TwQXLSw==
X-Exchange-RoutingPolicyChecked: dvatqr9CmlGiZigvoE3kZsiNv8U1mEGcIBAiabambutkTX8nVRjTEZbleaAt9UR8X+2swtqsV3p7Y0+aUUfanj6/8LL0Ik4BtMAenibPJ7fwpeK9FipGIYWAKWV/Riig2N9L8AtHV6mpWxzNQSAriQ5rOapGctnGIS1XxXg+T6ajQjTpvNUrL8yvLjKiaoOvnkyJPIZK8bCkZw/EUOt9lrqcW2qEKWKi3xfWeCm+xLL08Par5Km4CzZihdW7svmx9/9g/zRdSoLIOmKNMAMPpukr3QR7z5ndA2I+zxzvS/7UFe7fNDB6UoL7k/QPcQwKsnVKEd+vYc+EdbmgP077Lg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f8335250-89a5-4e47-8ce2-08df312347c9
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9230.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 16:32:51.1624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVGjjKXtHe7N1ITx2+jUlVztlMG29XgmiU3++rQycfy+9qy9+tPmMtHtBlRXq3pfKLdPrI7eZH+9arEwRy8S2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4944
X-OriginatorOrg: intel.com

On Fri, Oct 23, 2026 at 03:03:08PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] crypto: qat - unrestored rl_data.svc_ae_mask in adf_420xx_dev_config()
> --
> 
> commit 84452d0273c635ae08ee4c142e1d46cbf85da2de
> Author: Bairavi Alagappan <bairavix.alagappan@intel.com>
> 
> crypto: qat - enable three-service mode for QAT GEN5 devices
> 
> This commit adds support for enabling symmetric crypto, asymmetric crypto,
> and compression services concurrently on QAT GEN5 (qat_420xx) devices. It
> defines the firmware object layout, ring-to-service mapping,
> thread-to-arbiter mapping, and rate-limiting accelerator engine accounting
> for three-service mode.
> 
> > diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> > index 19f9f738630b1..281067f5b60c5 100644
> > --- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> > +++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
> 
> [ ... ]
> 
> > @@ -425,6 +450,79 @@ static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
> 
> [ ... ]
> 
> > +static void adf_update_rl_data(struct adf_rl_hw_data *rl_data)
> > +{
> > +	unsigned int num_groups;
> > +	unsigned int i;
> > +
> > +	num_groups = ARRAY_SIZE(adf_fw_asym_sym_dc_config) - ADF_GEN4_ADMIN_ACCELENGINES;
> > +
> > +	memset(rl_data->svc_ae_mask, 0, sizeof(rl_data->svc_ae_mask));
> > +
> > +	for (i = 0; i < num_groups; i++) {
> > +		switch (adf_fw_asym_sym_dc_config[i].obj) {
> > +		case ADF_FW_ASYM_OBJ:
> > +			rl_data->svc_ae_mask[SVC_ASYM] +=
> > +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> > +			break;
> > +		case ADF_FW_SYM_OBJ:
> > +			rl_data->svc_ae_mask[SVC_SYM] +=
> > +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> > +			break;
> > +		case ADF_FW_DC_OBJ:
> > +			rl_data->svc_ae_mask[SVC_DC] +=
> > +				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +}
> > +
> > +static int adf_420xx_dev_config(struct adf_accel_dev *accel_dev)
> > +{
> > +	int ret;
> > +
> > +	ret = adf_gen4_dev_config(accel_dev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (adf_get_service_enabled(accel_dev) == SVC_SYM_ASYM_DC)
> > +		adf_update_rl_data(&GET_HW_DATA(accel_dev)->rl_data);
> > +
> > +	return 0;
> > +}
> 
> [Severity: Medium]
> During probe, adf_init_hw_data_420xx() -> adf_init_rl_data() ->
> adf_gen4_init_num_svc_aes() initializes rl_data.svc_ae_mask to ae_cnt - 1
> (16 on an unfused 420xx device) for SVC_ASYM, SVC_SYM, and SVC_DC.
> 
> When the device is brought down via sysfs, configured to SVC_SYM_ASYM_DC,
> and brought back up via state_store() -> adf_dev_up(accel_dev, true) ->
> adf_420xx_dev_config(), adf_update_rl_data() overwrites rl_data.svc_ae_mask
> in-place with {SVC_ASYM: 4, SVC_SYM: 4, SVC_DC: 8, SVC_DECOMP: 0}.
> 
> If the device is subsequently brought down, reconfigured via cfg_services
> to a 1-service or 2-service mode, and brought back up,
> adf_420xx_dev_config() has no else branch (such as calling
> adf_gen4_init_num_svc_aes()) to restore rl_data.svc_ae_mask.
> 
> Additionally, if cfg_services is modified while the device is down and
> SR-IOV is then enabled, adf_sriov_configure() -> adf_do_enable_sriov()
> brings the device up with config set to false:
>

Hi All,
I will re-work the series and submit a V1.
The feedback here from sashiko is valid.

Regards,
Ahsan

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDC21EE017;
	Wed, 28 May 2025 05:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748409362; cv=fail; b=Ludi8+pfIdnJEautfmucQSvmBPoLS0pMTzFmygsuSdr2UH8cDanvaVnWHMi4RpkbGyFgFUhZupI9oy255u8WZA7KWnmF+rA0Da1R/wnaLsydvkQZbsbUXK+IN5GQ93b5E1HfBd2Q2EYqgQtrpIeO8xdBZVKMKifgLnvLFm35h0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748409362; c=relaxed/simple;
	bh=r6bn6YHQxq3foBchlGAsC1qhptfxmSddvOzXsEMIqBo=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=K38Uexbukl1fxePwkEPPkB2E0KDe0u/qBqP1qPAXTmp/9DELmSZWKXfK5GJJJqjO90u/Fusm208IbLrQFVEmyuySOXyt0UWR6UXaQND8dZKlWz8boXBqbDY6O7MJqkDNbslye+Na2NeVjQi9qffX7UaXLG2QUyGm3K/F0COHAvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=duQhL9w7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="duQhL9w7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748409360; x=1779945360;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=r6bn6YHQxq3foBchlGAsC1qhptfxmSddvOzXsEMIqBo=;
  b=duQhL9w7zClml19a5Sz7c7ypatsQbRWVjruGKdjruNxpZzs9i7zKLWrl
   sF0TprRUQXA03nYJkt2ZbxV3RmjRzoHIEwiFXKOQhbUh5DeFAxu7JB+7R
   gbO39yM5kXWzbBzStMzYjyNt7uzWi8mC6btWLNKiHLXXqkZNCb+LGCVUY
   eP/rytBtlTtaomoTklhjNvDb73NmJC698zkCu4Jv7iABNoEFb7c0pMhjZ
   IAC0hVpkUVqq9TV6qtUs3U17udW2HxLlATqWWwb7BLt2qINLzrjgF0s6A
   2Qc9pF1zZQwiL5S53alk9+fgja1/divpk8h7L5bBekVDnG9dy4GHwcVYV
   w==;
X-CSE-ConnectionGUID: QcJpf80GSm2tk9tV2MxNPQ==
X-CSE-MsgGUID: zEKOFZu6QJ+I0LzRaPP4sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="38042271"
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="38042271"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 22:15:59 -0700
X-CSE-ConnectionGUID: 5Pe5RguYTxeE/6TU+5YV8w==
X-CSE-MsgGUID: jElnol/nSyab5t7NeV9ISA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="174118440"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 22:15:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 22:15:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 22:15:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.85)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 22:15:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2TlZxmKCbSdaef+/Sz6X/9iXS/DETVIiQiarog7E/B4QregO9vgIuzNvsVQ7E7rY3vpJAheNO0Ddw6X1Inp8z2zGrJQ0WjkGmUEDVdcMQnUUS9g4pM8ckj2+JfK49nTIfRUUgZwvvQlqKKEW6JG2gYPmoD6aHwGf2wjZfJ/D8gzfJCbOTr1zNmi9ogvQLLTvvpU9OogLxOmieFgEFdFXukmN/6+SyKJrNtYvcaDEEIeDtwH0ZBk19F1NV61rEShPaaGmTFXIK6wooQQKKGGqgnihJY1riQ4mvIxG6RtPHdMwZye+V8PY8+NyOiQ0eBpdaVphbPtq8RMwpCyJ6oY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAUWnPMrzJA4nCuRp4y3FoZB03rY/GFxph8++0ShKRQ=;
 b=E9nyGxFK6dQ4PivStEm4zulyEUlAH6mOGGeRxrheTXSf1dlj62GCeWyzUe7DRr0j8gXESlP07XfB79GWCK1ds76IOPhCxf097Lq3TounKVjZFVIu6ukom0ezN+C7QkICQq/cK5fiCDx7++oqE3XoTuSShrFNoeOm0Hx0kNcbquoUaYltyVUuchEe3XVb64LxznkGEmat6U1zBCQday726a5RaGeqhPSHC5kBzKrQrLd3DsXzgt+hum7v7TpgaPE2jjPSKPnEnygJ/vzWY5ul50gd3iT9vDFx9FllQOaehFvG7pk+HGYcPoVvgR5MGU/n66s+BEPhtly1PF4u0f8wLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Wed, 28 May
 2025 05:15:15 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8746.030; Wed, 28 May 2025
 05:15:15 +0000
Date: Wed, 28 May 2025 13:15:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Eric Biggers <ebiggers@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-arm-kernel@lists.infradead.org>, <loongarch@lists.linux.dev>,
	<linux-s390@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [crypto]  40b9969796:
 UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
Message-ID: <202505281024.f42beaa7-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0145.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::25) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW3PR11MB4714:EE_
X-MS-Office365-Filtering-Correlation-Id: 70dbc30f-41a2-4627-2d97-08dd9da6a16c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KhtYxOYiUF8F+gR//w/ELJZ9zEzzvhrvpHuf2tOevAW89nLkpNBHvd+8MUOV?=
 =?us-ascii?Q?sli59Cz1ttt+4h5yQgO25gIbr7KRtEt8ZJHhINffDHcYmTTTRAAiqrr4yz23?=
 =?us-ascii?Q?6Ni7JghAqJyiSQgUHQZzs+GMUOk4KSJ14Pe/PQpFvl/vPW/uYhGnagsBMRFe?=
 =?us-ascii?Q?bNpygVwVqHhbhnHBhKh0+aC+q3lDPFcLDqy6ApTmG2sb4Yl9CZsl/5qcWT4g?=
 =?us-ascii?Q?y3kpFjbVeqyg7kn0gsZPpBg5uudMFPQCo6qmEKefqJA0PGpfF9GsvMbnOR+u?=
 =?us-ascii?Q?vr5bcGS4QA3D4HgMXLZDzk2fcRa6pnp50nCkAw9xEr18ps50xjyzx63GIUZG?=
 =?us-ascii?Q?uB5PLc8Q7aVYGxvjZ0EX0/+EVHH86BectxTfvj7FAeyF+2wVKPYwCx0oXLBD?=
 =?us-ascii?Q?s/cdfM4SN1MCgXiV4Riky2SOYT0jCzY9RnkJBUvKFCTLh+0VaMWxMlRUakn6?=
 =?us-ascii?Q?fZ2ejKwXMwrCEXzZ0yfgFMj7JY3Vaq9oC+oCGuSa5j569j3PaIK5WWK+pZMq?=
 =?us-ascii?Q?anZ5+dHwZ3FygVr5gv+EGL8SVkigthUV6iy2HRoBi71UhCTcJkjRIhIMW/gx?=
 =?us-ascii?Q?0gh9b22LmNNhTIsLPaZ7KkRuNtAldJVUOawT/nQmtL/JZH5vnuHoEjioJUMj?=
 =?us-ascii?Q?jyDW18BBsC8Yb+350Igxw1n8s/s/dwj4BILrcXRorJ+S6fSRVeYKQnNViBtS?=
 =?us-ascii?Q?pEPUtexc5nrgKAvK3pg98cuz+xdZe4vfR0L+aK1ryCDGWymtJfNc3eRO1C1S?=
 =?us-ascii?Q?YnScui4AaNLoBdLT+o4lc2WykRuIvMUKDu1QaakubmHBvU9gZ3kSFqV9TRyw?=
 =?us-ascii?Q?R5hAQxnz5S9jS53twqJiFJGtTlFRXKwW23GHVY/FLgRnNLAqCBRC5AW/g2ei?=
 =?us-ascii?Q?x7NGXaVPMuaBw8sojo18hZ/fGFQMwjrvMkPO/jt+OZERCNc3W/lVSUA11pFM?=
 =?us-ascii?Q?2lxVQzZKFwCxH2T0aIfU10Y9tjZUcJbYgi7oEPh6s3ShfnSnqLWeLXa1ZKzq?=
 =?us-ascii?Q?al/+E/BxzxriqaoKLEwRxlnWGnfUmTeXlcWla3jZOaemu4bLjRe192KQgBv+?=
 =?us-ascii?Q?oDKvMnqn14I9ZC6k18tgeHtbIsAyOE4b9SlaRYV6IzSbKbMVsRw+qfMtrfN4?=
 =?us-ascii?Q?q3zzd09Pr9src+pJI6OQwXUkr/DDRe81RUxQfgxXyKTTTs6PZbeq/k8wnnjr?=
 =?us-ascii?Q?TWgM/xw4DB8AZ9+Erm1Q2qcLRPZ9gNORYqnDgbfyNsQu/sj8ySfoEVDiGebQ?=
 =?us-ascii?Q?W/mCSUBo2sJeEwEESRslKD7xS2gmpj6l7WjeolE4ySmyO6rn0ZSauaCv5LNh?=
 =?us-ascii?Q?php0idYCGKeAFQR3u8V9Egq/7scnIxwX9YAsEeOWluQmhRkKZBYWLly9l1SC?=
 =?us-ascii?Q?4zOPAaX3LzhYrIYQVXCp5yRq76qv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I3h8BYKWZRIDO0Y/AEUIbK/OJXffyIiWSLWjGBbMx7hYPPmdZnKS6VyvCUzo?=
 =?us-ascii?Q?ngEVHpdEeBi8GTl8Didre8med0vPx1ufrsIsY0LlP6jib5Kelu5F7VPOFjZl?=
 =?us-ascii?Q?aG0GkYLdZywAmFHNg6q+6vF+mrMu7V7CIN6e4ncAJqJTvmDDFeNwrfXMwL+O?=
 =?us-ascii?Q?zUVHEnUc391LwM3lpzzjp8wPkfzLPTylj6jFhKnpcVZtf4L3phYj2+YQdQng?=
 =?us-ascii?Q?fnA6I9/BpFHwB4FD0Uzxdsh5IkvD4MrwS7X3Nb91LRQAj7Kvtxyjq4nfF5lv?=
 =?us-ascii?Q?YqcOPx2rZ8qK6zJ6PPMscQJdFtTJTZktrh1Zlc7od3qNEoTSu4wcghV7acYj?=
 =?us-ascii?Q?DRG9QhLfvFs6a41tfK/2uEtwgazlfbm8ubLlNFLxT/dZXsT58Y4wiHHj/4bi?=
 =?us-ascii?Q?YzMkf5YmiTc20SzVWVRCqN0QSQZE40kxvjT1pJXL0Vnt2/zRUSoN05UgDGeV?=
 =?us-ascii?Q?he+QO+5eCfkhInZqMamgQRguBoESMaxQ5BVE5hMXZ/ccL5l5TnHdMniLU5Yy?=
 =?us-ascii?Q?L2ZwZ5WgECqFR23VmIWsCPhGRrJNjjhHnJEoSfKc9sXO3KUcr5FuGaSycl3g?=
 =?us-ascii?Q?Y0NzNth/3uNYPcx49yK/3+l55KN66+lE8CjGw1j11IZBIvwKyS5PL32m6Nk7?=
 =?us-ascii?Q?BnGZtkgKSUJtkD4DNHqMrOGWzn+JR6uhrDTcxaBbdvrRG6jlocvq8zOyGWZF?=
 =?us-ascii?Q?ZoDEFYo7wQnRPIt+hGCVzaHYR6YVHPef65NwB3euKNfb36dM4oyW4KvH8pdN?=
 =?us-ascii?Q?FDiUSHQXKfCQ7fzoXFbRf5U/at/HYCUQGEbbixFPrNDdZDfctE/nQSMrJ5jB?=
 =?us-ascii?Q?ggCStgY/I1nYoEmhoRJ7R2D+xsP/9Zh3pYwgIb6WzLAK+uMEAyGx90ub1xDL?=
 =?us-ascii?Q?5N0tiOnyqVgmsfj8xd4O2AF6ywO5RvLeeYC2zjalZ1MrT0g7y0IXcHqCod+d?=
 =?us-ascii?Q?NHxaOFqvaTRx6GcA0VDK+BISlIkFHKyUvNf33EJYDKZdta2euTSUIKiMKj8O?=
 =?us-ascii?Q?duC9VvfEgvEj7qg3oRvWMDsA0NOekC1YQYoBpsjVvHTgqOMVisXG/DuM3Y+q?=
 =?us-ascii?Q?fk0p93hNpfUwOn9qps+lh2alKWd7IEKXXF3umuCw0CZvWowp7E8dbrHqytdg?=
 =?us-ascii?Q?KX+Le9dFCBsKc/3J+4lcD4KVlPcyza6p7YONIwS6jQhq/n1P3lT2fH1cR8jm?=
 =?us-ascii?Q?NV2G1joY3U94Y6mnKrQ/mW4OT58lvy50NolY2ojdgatPKzkB4pbrXIgjp5VR?=
 =?us-ascii?Q?eIc5Edx1Wb66jlGYoYoStEFAX30cyHO0ySUH0KAqdxCBMHRUG8tnRUx7Qn/I?=
 =?us-ascii?Q?FG/I0Q+uHBbWEEz/j0sJiAmBptXOWtXY10Yf+8pBDDPr4nT7m39rnCx7Y/kk?=
 =?us-ascii?Q?r5BNL+SUwncPXN80/4y2tD1a8h82VAdHJ3USU7BqdDy9DP8J8aSMwqvVkij7?=
 =?us-ascii?Q?kyG3MrlmxCWazEZf0NFhEspoURt2ULbIYc3zmfr+JTfaYXIp1q9T4qlXpcJK?=
 =?us-ascii?Q?nw91ueUlC7touuA3xyMvsiJJkOgDv4V+2HrPkiUOYo9B7jUyD1O8E9LkL746?=
 =?us-ascii?Q?9JgrEbEk1RKpi4mFqSBoXzSYzkj2SzdLHBob++mPcmy0cM99x1IOWS4q0cZT?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70dbc30f-41a2-4627-2d97-08dd9da6a16c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 05:15:15.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71Nbx30N8e3jl2EcRNcjxr3bgiZJyAEaZ7EjCwJBQI9m3w4SBBRWBpmw4Xln6YSXL2LK9yc9cGqyocgFYKQzTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com



Hello,

by this commit, the config has below diff:

--- /pkg/linux/x86_64-randconfig-101-20250522/clang-20/d469eaed223fa485eabebd3bcd05ddd3c891f54e/.config 2025-05-23 23:44:56.781716572 +0800
+++ /pkg/linux/x86_64-randconfig-101-20250522/clang-20/40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c/.config 2025-05-24 02:08:29.858605300 +0800
@@ -4837,7 +4837,8 @@ CONFIG_CRYPTO_ACOMP2=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_USER is not set
-CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
+CONFIG_CRYPTO_SELFTESTS=y
+# CONFIG_CRYPTO_MANAGER_EXTRA_TESTS is not set
 # CONFIG_CRYPTO_NULL is not set
 CONFIG_CRYPTO_PCRYPT=m
 CONFIG_CRYPTO_CRYPTD=y

it seems tests are enabled then we observe the UBSAN issues

d469eaed223fa485 40b9969796bfa49ed1b0f7ddc25
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
           :6          100%           6:6     dmesg.UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305.c

it's hard for bot to apply this commit to previous commits in bisect, so we just
make out below report FYI that we observe UBSAN issues in boot tests.


kernel test robot noticed "UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c" on:

commit: 40b9969796bfa49ed1b0f7ddc254f48cb2ac6d2c ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master 176e917e010cb7dcc605f11d2bc33f304292482b]

in testcase: boot

config: x86_64-randconfig-101-20250522
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505281024.f42beaa7-lkp@intel.com


[   12.442846][    T1] ------------[ cut here ]------------
[   12.443261][    T1] UBSAN: unsigned-integer-overflow in lib/crypto/chacha20poly1305-selftest.c:8854:47
[   12.444084][    T1] 16 - 114 cannot be represented in type 'size_t' (aka 'unsigned long')
[   12.444682][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.15.0-rc5-00342-g40b9969796bf #1 VOLUNTARY
[   12.444688][    T1] Tainted: [T]=RANDSTRUCT
[   12.444689][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[   12.444691][    T1] Call Trace:
[   12.444693][    T1]  <TASK>
[ 12.444696][ T1] __dump_stack (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/dump_stack.c:95) 
[ 12.444705][ T1] dump_stack_lvl (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/dump_stack.c:123 (discriminator 1)) 
[ 12.444709][ T1] dump_stack (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/dump_stack.c:130) 
[ 12.444712][ T1] ubsan_epilogue (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/ubsan.c:232 (discriminator 2)) 
[ 12.444717][ T1] handle_overflow (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/ubsan.c:?) 
[ 12.444729][ T1] __ubsan_handle_sub_overflow (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/ubsan.c:277) 
[ 12.444732][ T1] chacha20poly1305_encrypt_bignonce (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/crypto/chacha20poly1305-selftest.c:?) 
[ 12.444759][ T1] ? kasan_save_alloc_info (kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/generic.c:563 (discriminator 1)) 
[ 12.444766][ T1] chacha20poly1305_selftest_encrypt (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/crypto/chacha20poly1305-selftest.c:?) 
[ 12.444772][ T1] chacha20poly1305_selftest (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/crypto/chacha20poly1305-selftest.c:8903 (discriminator 1)) 
[ 12.444787][ T1] chacha20poly1305_init (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/crypto/chacha20poly1305.c:362) 
[ 12.444790][ T1] do_one_initcall (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1257) 
[ 12.444793][ T1] ? blake2s_random_test (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/crypto/chacha20poly1305.c:360) 
[ 12.444801][ T1] ? kasan_save_track (kbuild/obj/consumer/x86_64-randconfig-101-20250522/arch/x86/include/asm/current.h:25 (discriminator 3) kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/common.c:60 (discriminator 3) kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/common.c:69 (discriminator 3)) 
[ 12.444803][ T1] ? kasan_save_track (kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/common.c:48 kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/common.c:68) 
[ 12.444804][ T1] ? kasan_save_alloc_info (kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/generic.c:563 (discriminator 1)) 
[ 12.444806][ T1] ? __kasan_kmalloc (kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/kasan/common.c:398) 
[ 12.444808][ T1] ? __kmalloc_noprof (kbuild/obj/consumer/x86_64-randconfig-101-20250522/include/linux/kasan.h:260 kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/slub.c:4327 kbuild/obj/consumer/x86_64-randconfig-101-20250522/mm/slub.c:4339) 
[ 12.444814][ T1] ? do_initcalls (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1329) 
[ 12.444817][ T1] ? do_basic_setup (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1355) 
[ 12.444824][ T1] ? trace_hardirqs_on (kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/trace/trace_preemptirq.c:80) 
[ 12.444829][ T1] ? irqentry_exit (kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/entry/common.c:358) 
[ 12.444834][ T1] ? sysvec_apic_timer_interrupt (kbuild/obj/consumer/x86_64-randconfig-101-20250522/arch/x86/kernel/apic/apic.c:1049 (discriminator 256)) 
[ 12.444840][ T1] ? do_initcall_level (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1303) 
[ 12.444847][ T1] ? next_arg (kbuild/obj/consumer/x86_64-randconfig-101-20250522/lib/cmdline.c:273) 
[ 12.444853][ T1] ? parameq (kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/params.c:90 (discriminator 1) kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/params.c:99 (discriminator 1)) 
[ 12.444858][ T1] ? parse_args (kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/params.c:153 kbuild/obj/consumer/x86_64-randconfig-101-20250522/kernel/params.c:186) 
[ 12.444869][ T1] do_initcall_level (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1318 (discriminator 6)) 
[ 12.444874][ T1] do_initcalls (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1332 (discriminator 2)) 
[ 12.444878][ T1] do_basic_setup (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1355) 
[ 12.444882][ T1] kernel_init_freeable (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1571) 
[ 12.444885][ T1] ? rest_init (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1449) 
[ 12.444887][ T1] kernel_init (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1459) 
[ 12.444890][ T1] ? rest_init (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1449) 
[ 12.444892][ T1] ret_from_fork (kbuild/obj/consumer/x86_64-randconfig-101-20250522/arch/x86/kernel/process.c:153) 
[ 12.444895][ T1] ? rest_init (kbuild/obj/consumer/x86_64-randconfig-101-20250522/init/main.c:1449) 
[ 12.444898][ T1] ret_from_fork_asm (kbuild/obj/consumer/x86_64-randconfig-101-20250522/arch/x86/entry/entry_64.S:255) 
[   12.444909][    T1]  </TASK>
[   12.475589][    T1] ---[ end trace ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250528/202505281024.f42beaa7-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C286821B9C0;
	Fri, 19 Dec 2025 02:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766111363; cv=fail; b=qLhXHPGAO7YilVq/zBNX3fc9fS774kJnZytUU2xSjGOESLx2J+zJiys9wG1gQlp/JeVDDzHIYQLDMj0cXwmCs88OdFSyZ7m1y+2pkl11iwU5FppQrt2iDTXoQOc6BFYbqLT8Ohcmm/A0IqkFj6BgswaKyTdEC8Ewjxvi1mw3R4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766111363; c=relaxed/simple;
	bh=ivAbzoSN9J9NC44T02LfVVN/XGpN/daN/Oc1r1azaV0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VMh2SAsB0hx/pDVpbdrw9NvZUvY/Ir2n3smP8eYFtWZgeEyL4b4MuZmm/qn9DgSn8xnrdEoQGia6YK4vCamYdparvmYsEhBboSZt2RAVq3KPb5GGc8/Jv26wYZiVS/6HZvrRdREBkspLPtmMkZDlE+hhVwvHICilLfROIIEbcx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgbeNQ2d; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgbeNQ2d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766111362; x=1797647362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ivAbzoSN9J9NC44T02LfVVN/XGpN/daN/Oc1r1azaV0=;
  b=bgbeNQ2dIPGjQXBuUW6A1NyC3zadE56E1lBW+3U9n2xBXNVS+4njX0GE
   aiCI2SZmP7F0Hl/WR3ofpXfm/ZgwPbsZCYk2LUnlhQWYbYV+gde5vz0kN
   RUhjszpafYC/dCIqsm5UuuHci3HA2sP6T6qW3JX1ps7UaKjOBOSuWr8c5
   veO2j3OCX/ec73bGZWVDNM16vaCUlDAaBnUixtDFYbbTp2WA+8hJp7WJD
   Py3l7iKrar8pBUJ0aWVouG1oLuPiMrK2TKqbCCOlDwH0JeNIZkk7CdVtM
   ETKnSXRcApDuUjTQ7frEVQSIhIAQcCZHXRUOT63A1aukb1UPK1W/J9+Hl
   Q==;
X-CSE-ConnectionGUID: nN8SJ5BKT2mX0O45qAZCfg==
X-CSE-MsgGUID: E0iFu46SQR+PPUi8JAOzLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="68113779"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="68113779"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:29:21 -0800
X-CSE-ConnectionGUID: y69Vq2FTTVGPnp6fTdWJVA==
X-CSE-MsgGUID: riOJERMJR02kTY2/5GALYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="203258195"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 18:29:21 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 18:29:20 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 18 Dec 2025 18:29:20 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.59) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 18 Dec 2025 18:29:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QUSlLu7am0nM8HJvbcJ7pgbeUKGt90a+zmQl0q5ZYbbUnjFPCuwkzhy6ivsxQrHqteMQ5Vd06sSPMWi4MF9kidZz4a9gtqFRziAqxbb8h67gCbnnKeuYP2tbjvjBpPkZIM7klwtws6qt3q6nO84Repkq5gJ8m5Qbwguq5QXFSzM+7m3G1a9SnEbIboWblFfDvHIn/52Ma14R8o+ea1qIDHHSqGV2mp50B6yvxD4IEYsMvRQcNDgoihLgv0fzoJIrmn8vs/pjPdXCX0q+7zRzrVM5zOwJen7MshrykklhVuNtpnfK0oUCUOptRXVNlf5KKALsII5uPre6TkUGPenz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ok7UXkNqfZp7iDXlSwtBesqKrbMrQwCs3pOc8qPO9ss=;
 b=K8nhzfYGJm11GrIyUBTkuxgasXtW53jT9PMLunCWuHpEpqxAJPSwGdItmJtqXH+VewaWZ3OpnVhXsLHQrHipXPWEWDgGKs0rhzQ7+oN+8v6YQ+ywtDdVZWP4R+9I2eTuFWVkaLO9BVpTRhDtvoD7/K0mlCffRXcx351+nAz134lapv33uB+zkGRqGS+gTW2FJz46znlh7JO2SiSnt1KpgHdqYJQ5jclF9X6TbhmwjwPSv0x3VPFNCwGRLy4KcidD1VRSOsCObh2uUzBI4gvuPjDga/DaOvdWKwGjJoc5f6JvQR7L1/QTHnyoD28tQ9lcnu8iFIJeODlQzJoxO8agIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15)
 by IA3PR11MB9398.namprd11.prod.outlook.com (2603:10b6:208:576::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 02:29:16 +0000
Received: from SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860]) by SJ2PR11MB8472.namprd11.prod.outlook.com
 ([fe80::662:dcf4:b809:4860%5]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 02:29:15 +0000
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
Subject: RE: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Topic: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Thread-Index: AQHcTWs0Qo3eNl0w/UamTXF2PMbCz7TxL9wAgAAcuzCAABirgIA3HHXQ
Date: Fri, 19 Dec 2025 02:29:15 +0000
Message-ID: <SJ2PR11MB847267511A5B6CF9EBFA1A0DC9A9A@SJ2PR11MB8472.namprd11.prod.outlook.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-23-kanchana.p.sridhar@intel.com>
 <q54bjetgzmwbsqpgbuuovdmcwxjwmtowwgsv7p3ykbodhxpvc7@6mqmz6ji4jja>
 <SJ2PR11MB8472011B61F644D4662FE980C9CDA@SJ2PR11MB8472.namprd11.prod.outlook.com>
 <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
In-Reply-To: <vc65dxjoledwtojbcdgyxh2xt3hhlqrzgxcnbgufji7sgnhkus@fqkcflhwbags>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR11MB8472:EE_|IA3PR11MB9398:EE_
x-ms-office365-filtering-correlation-id: f3016e45-c56d-4ede-dfe5-08de3ea667ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?+3dT2uwTUyse3pHtKtnBX4Y2i7nbck6yn0ZqYe0uc1cTLEuvlvFr6xGJxKJf?=
 =?us-ascii?Q?1XcZgKpKpOrtN8WYMRnWb8alubKNMsUOTZT5krRc6+bFn/pv7MnW0u+Q5h/b?=
 =?us-ascii?Q?a64c8zhqzyLH54k2J9Ofy2HFbqUBPmf5n3WMs6eUqAetRHCuogt1B/nuhOEs?=
 =?us-ascii?Q?+MypYgu0prETxwKY5tC02iJwu8lwJcIJznmPHWyjElNr2sJXZroJoZTU68RT?=
 =?us-ascii?Q?f3k7GjW062W0jGRH1q0Kk/bWH0Y4zO+7HDAAH76aL2nWDcddHoVHoowKHKKS?=
 =?us-ascii?Q?HL0a5OGeGFXwtj6QgKHuZL1n+0dICIoIQlPTnKSklhVzLYuCzSz3R2vTqF39?=
 =?us-ascii?Q?1WLuSrgYanR1w4JsjSo9kkKewsZHmpZGHtN3W1LWuRYftU5jqU15QXFnYuKu?=
 =?us-ascii?Q?VJBWLvi5W15ulWc5drWNMu7nQKqPWhc+i7KVMwA1m1GUrsYf85kygclvYDCq?=
 =?us-ascii?Q?tybNlnnTYRisVW7RtpKpMjW7WW5bJ7gp6uNkfk4XwGwiCmk7bs4ZSOxK0FLM?=
 =?us-ascii?Q?0YdEB+khFk6HGmZk3vxzkUKi/YCUao8H1eE1PzyTOPn1Me3RIWUbrJuGWIFa?=
 =?us-ascii?Q?Mor5w5pRjD8jFDH+wnbLtKOfuwdEVEOYEL737XX/wTdOMBXD5LMOl5JRK/HZ?=
 =?us-ascii?Q?84/BJSUw0J+KVXhD8Ok9Ss+svTm6JgGngbzLcHpSxlIm/8BxjY2zkktxQd7W?=
 =?us-ascii?Q?V9ZCndQX8+7WumBX810wbjt+PvTlQgAymDfyWg+w5Ix5w4HPz4Q2qkw1Z6eN?=
 =?us-ascii?Q?s2LqPHXecVoTzIoBg3NTQkOXd/UGjaTuAHQVzmZW6hHPCfP3sJS1PIC0eUxa?=
 =?us-ascii?Q?+OFkEAOEvDnvtDct+UL/wszBJkFCoXpyLfp2YH1RLXrCLHzbDZEBkJn7s25i?=
 =?us-ascii?Q?Kuo4S9/BZcGO9luhJUyo6Dh/akZttmYuluKP/mLqsuG/OJKBZJ5e6j1e215x?=
 =?us-ascii?Q?/tH37xWGarlY797jVKLRzekljwOyGHfL2Yyp1gT6jwnqeqxPz2Q8bvYmO+zB?=
 =?us-ascii?Q?O3jzkdyNFNxZ+Q6lgkzCmkGnRAwuP65Se30v/bZeLKd8dEh+BtPHgtyrgELE?=
 =?us-ascii?Q?QClgy/dlr6DbLuOQvdzFDdXjEWKANxFG8iUAcxdIrBvpyPpf2aIA/0gPAL3I?=
 =?us-ascii?Q?e8zr938geOFZ5ZXSmORwwulvE5oWNIEbKBjVcAsPtjd+TL7BLAOsmuwYT0b1?=
 =?us-ascii?Q?57aH8abHbUI4fzHcG3xKMpH7U9Uu3zmAx8SbVv/b1Nc2NlNMUnRtXiViJBLU?=
 =?us-ascii?Q?3JNLIrOwPHBebpnfXinn7iJHklvD9pO1bArhZmkVDFS1lsLNdzQ+GxiY/X7d?=
 =?us-ascii?Q?rhMAPHr3wm8m/Prrk0Mb83p5ibN6ht8JMWK8mSbFnjoXwJp9xShRoJjKWhV+?=
 =?us-ascii?Q?35Mh9blgDTMH19idz7GtrTLltgJ2akNmtKXaf6k1jfU+YbZ0CjLiZKa9gXL3?=
 =?us-ascii?Q?gd86TMrXVqStuoBcO9W8dX5zgvWoNJa3UoZnY99TtW7eokIftYHjzMLPyktB?=
 =?us-ascii?Q?MNT0wfahagG5QQrF1M/cVgwHfpTF0i4OsDga?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0Vhmqy4OC88oqTrDT3HOyoRXG2sjVyNF/0z9R0ZaInLeBTodG/K1roWZGJbB?=
 =?us-ascii?Q?q1rLgaCNFD4hb7bEQjUdDd3/3MC/g8RzePHtJ6EqHrOBXYg7kkz5P35T1JbX?=
 =?us-ascii?Q?7VeJu8nDPc3MsFDRHA1nvE6mkPSMqz9LfWDDJuPhHmejN7Zf2YuJMy65wIxh?=
 =?us-ascii?Q?9XKvz9aZwg3u8/0M7M4FQYYJfB6Wu382D3ZWx2kbjM18TBAowtPaFud+vd6j?=
 =?us-ascii?Q?vmEVP5aVrc4wsDpdI4gumt+Od+T+crSlJpIzkZjSYx/APQhbWFAMCKaLVE3k?=
 =?us-ascii?Q?kDEdoBUZt02obKFoKzmOYXl8Jxu4p2X9Vuc52hpUoyy9hKBENfGNMvN8zukH?=
 =?us-ascii?Q?8TnCnFeV2Hbz/B6FYv4Yai4PXqtnjXOpCQKbZjSSbM2DlEyVmrhFHaWBwMcS?=
 =?us-ascii?Q?QxkyVMM7Q+kuQIK0kWNm0bEggzTm2uv5UQCkkhd3lopFpIatnxtOv3BH0mvO?=
 =?us-ascii?Q?OcGr8+2jq+cGnxILwC9MNPJk1GAaOFi7j3uNBIVtoPUm6r5drCnf8v9ZaPVA?=
 =?us-ascii?Q?H3eh6J+PUfmOfI/CUa0YUL7JEBUkvKRZrCEpS6w3W8JZ+BUmhmCAcGYFaAq7?=
 =?us-ascii?Q?99NbS29S+ocjtfaNaaQIU3pbZDbTqY8/v7ol6u912jqittnWCL0SF6HNGCyn?=
 =?us-ascii?Q?8bJgXZ4xBd7FtYQOjx/OYhq04V6WvjtToz/VRjSzPYi592Ffh5J421Ox6rS8?=
 =?us-ascii?Q?dOm9zywknfCx5O2G8Rc+ZiDJxTNq0BNLo/rTFcTQJOwctzy/MSThDCdAsYtt?=
 =?us-ascii?Q?QNk5kiGJdgLwmf1+SZhq0ZRZHVdmvOHuWaghJeu37yZ+oHLU8vcZo0D4bted?=
 =?us-ascii?Q?xzN5LWX4OMpDZ8uxlWISJfNW8mInNf7ePhOuLA3EHEUyk8ehWan+GZ3nNY4Q?=
 =?us-ascii?Q?JiPWOutgN4FGRcugsQOZhxXdFi5WVvbSLHYusJuCUqQrsiusGFgXIvkZCUgF?=
 =?us-ascii?Q?rB0u9vyudTqZM5Ej1UXJbSJa0ZPYABFiCJGIP1aqm38vfYPOKJeXMEh78ynh?=
 =?us-ascii?Q?Fs1UhCGiPlRKDHFVZqZVCOk3hqL8IcAFyGY6ghzzr4eGsiUwwFPwFs9Pxbya?=
 =?us-ascii?Q?4GiKMRheWNbhvE4SBp0iovkRxK4JZVZ85qCRRDBI40oFqxvMWN3ul7uRxBMk?=
 =?us-ascii?Q?tKs/tJnjtxaVuCsuv282ix15SLgABMuAFLs0z4CyRIe4yC56OFGfQxz1b4Gq?=
 =?us-ascii?Q?UrxAPEMQ5LdbOJJO4dUATR2mpfVLQGEupv4/V1chHpMvbnIMTeP/wdyqTm/H?=
 =?us-ascii?Q?JzBBF4f/4JiA6yvg2AHETOq3Ygsq7/Z7P5pDqK/mL+YaQUIEGaJknWwBgoeF?=
 =?us-ascii?Q?USgXdxY6h/piGUTuh6hKPwdEfZ8Lkv4v3SAt6eHn0sBr5YqhyTwuIvXCnKCz?=
 =?us-ascii?Q?OID2jCmZOHMaGfZLFsn6+DUkIl/uH0hBL7XhXrCCTgAoacbPos6AjXvgf2Gl?=
 =?us-ascii?Q?fRjM8pmSnrpJLAoqDwxPYMlAxcDWCPOuQD4OMf8lXX8MLO+fyagOn2xKoR5R?=
 =?us-ascii?Q?MmyyyR29lGhrtXbUG52y5NDWDZbKxyL4DxHcJzVpwhSJWsPgSwq50ljehVDr?=
 =?us-ascii?Q?JnQpnngYeGmlKy+PXCQzRq3lRAzrh70Avirrp+vcQg8eAc3v1w4vnDwPxza+?=
 =?us-ascii?Q?sG+Sc2uHYgzfVxGCQS56Itc3ODz3+MnJmrmCEGdN4ihW4FW23vbLvpzlaXWo?=
 =?us-ascii?Q?LksbYA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f3016e45-c56d-4ede-dfe5-08de3ea667ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2025 02:29:15.7895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBwwpL8+n0djhAnt1gL4C/W+hfzyVPsK81YrtB82k2zT5o3QGeqSToD3w2o1cXVbtPrgjmdzYpQXyJlqx/B0VwrLP1gSxmKoHTW9zEddeqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9398
X-OriginatorOrg: intel.com


> -----Original Message-----
> From: Yosry Ahmed <yosry.ahmed@linux.dev>
> Sent: Thursday, November 13, 2025 4:46 PM
> To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> hannes@cmpxchg.org; nphamcs@gmail.com; chengming.zhou@linux.dev;
> usamaarif642@gmail.com; ryan.roberts@arm.com; 21cnbao@gmail.com;
> ying.huang@linux.alibaba.com; akpm@linux-foundation.org;
> senozhatsky@chromium.org; sj@kernel.org; kasong@tencent.com; linux-
> crypto@vger.kernel.org; herbert@gondor.apana.org.au;
> davem@davemloft.net; clabbe@baylibre.com; ardb@kernel.org;
> ebiggers@google.com; surenb@google.com; Accardi, Kristen C
> <kristen.c.accardi@intel.com>; Gomes, Vinicius <vinicius.gomes@intel.com>=
;
> Feghali, Wajdi K <wajdi.k.feghali@intel.com>; Gopal, Vinodh
> <vinodh.gopal@intel.com>
> Subject: Re: [PATCH v13 22/22] mm: zswap: Batched zswap_compress() with
> compress batching of large folios.
[...]
> > > > Architectural considerations for the zswap batching framework:
> > > >
> > >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > We have designed the zswap batching framework to be
> > > > hardware-agnostic. It has no dependencies on Intel-specific feature=
s
> and
> > > > can be leveraged by any hardware accelerator or software-based
> > > > compressor. In other words, the framework is open and inclusive by
> > > > design.
> > > >
> > > > Other ongoing work that can use batching:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > This patch-series demonstrates the performance benefits of compress
> > > > batching when used in zswap_store() of large folios. shrink_folio_l=
ist()
> > > > "reclaim batching" of any-order folios is the major next work that =
uses
> > > > the zswap compress batching framework: our testing of
> kernel_compilation
> > > > with writeback and the zswap shrinker indicates 10X fewer pages get
> > > > written back when we reclaim 32 folios as a batch, as compared to o=
ne
> > > > folio at a time: this is with deflate-iaa and with zstd. We expect =
to
> > > > submit a patch-series with this data and the resulting performance
> > > > improvements shortly. Reclaim batching relieves memory pressure
> faster
> > > > than reclaiming one folio at a time, hence alleviates the need to s=
can
> > > > slab memory for writeback.
> > > >
> > > > Nhat has given ideas on using batching with the ongoing kcompressd
> work,
> > > > as well as beneficially using decompression batching & block IO bat=
ching
> > > > to improve zswap writeback efficiency.
> > > >
> > > > Experiments that combine zswap compress batching, reclaim batching,
> > > > swapin_readahead() decompression batching of prefetched pages, and
> > > > writeback batching show that 0 pages are written back with deflate-=
iaa
> > > > and zstd. For comparison, the baselines for these compressors see
> > > > 200K-800K pages written to disk (kernel compilation 'allmod' config=
).
> > > >
> > > > To summarize, these are future clients of the batching framework:
> > > >
> > > >    - shrink_folio_list() reclaim batching of multiple folios:
> > > >        Implemented, will submit patch-series.
> > > >    - zswap writeback with decompress batching:
> > > >        Implemented, will submit patch-series.
> > > >    - zram:
> > > >        Implemented, will submit patch-series.
> > > >    - kcompressd:
> > > >        Not yet implemented.
> > > >    - file systems:
> > > >        Not yet implemented.
> > > >    - swapin_readahead() decompression batching of prefetched pages:
> > > >        Implemented, will submit patch-series.
> > > >
> > > > Additionally, any place we have folios that need to be compressed, =
can
> > > > potentially be parallelized.

[...]

> For example, you should remove mentions of ongoing work and future work,
> simply because things change and they may not land. Just briefly
> mentioning that there are future use cases (with maybe an example) is
> sufficient.

Hi Yosry,

The mentions of ongoing/future work were included as per Andrew's suggestio=
n.
Hence, I would like to keep these in the commit log. Hope this is Ok with y=
ou?

Thanks,
Kanchana


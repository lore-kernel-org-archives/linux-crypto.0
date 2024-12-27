Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B6528691;
	Fri, 27 Dec 2024 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735269037; cv=fail; b=YHy1rfB2Usy6v0IJFX+Te5Ivw4I1c6UyuBw/TFe492QEyR79NN4A/CAEVfLQ7p161D0Ij4dXdM/QAymAoQTEGqQlFQFv+u5LMwmMabxqPdCg2RpTPA7lIi/VM6o+izaBFRfjnDTO88svqhuNur8SbuiC4aMUq5vaUwMrpNmVy8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735269037; c=relaxed/simple;
	bh=tot6OQH00JqeI+hUoa+0adMKOphFXDe+EWEffrQNkaY=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=s8DDLLe/ctOEKsJYubIO6ofZaeV2XgvbIaUPRa0wXACCARDAiOppUOIrWUyJ7gT1b0MQzrBMGEmlICKjtx0JglwRCJBZJGaY2ANpn2PXy2usnq6jMZI3gSkSbBToT7jj6L61MGRXNx6oIsnQRLRVlDH1dEHypvuwpKfGS5dIGd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KL4g4w8W; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KL4g4w8W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735269029; x=1766805029;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=tot6OQH00JqeI+hUoa+0adMKOphFXDe+EWEffrQNkaY=;
  b=KL4g4w8WiK4hOoEt1m3/m8TfkuIIloh6OhaoyUoX3cWSmnV6ktkrYPPd
   fdXzzulJZHYwUYHXCfI/Dwwvg6Z+KXnQOy6ANRYsKvUzB6tX5vuVTmDfQ
   2YX1nZmfjX8OAu4Wvafw8+bg+8T9k6JQFeD9d6l8TTx51ndIZ2BeW8uqv
   jABV7lmN7pcHzjBffElqRQzDWNnzi/tWhftXBiKWruGqeu3Hy8tUHcwHU
   dBCHCs0Pp1MAkcPbeGMJTutux0obv9EKXdGUIK/ug20BsKsm0eMM6Bi0O
   xpqEHVV6RNEwNBqXOfmGYjIsmhvPwoIUpdTJkhECWSRNXnSOwab/6TkFz
   w==;
X-CSE-ConnectionGUID: DVGMp/qcSrCYAHXGK+HFAw==
X-CSE-MsgGUID: seNdQ3kQQ+mqpB58k/HZ9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11297"; a="34989571"
X-IronPort-AV: E=Sophos;i="6.12,268,1728975600"; 
   d="scan'208";a="34989571"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2024 19:10:28 -0800
X-CSE-ConnectionGUID: qaKfRoKlR++i1EQfGYETaQ==
X-CSE-MsgGUID: 1sJLmu0yS3aqOsZdN8gR3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105066142"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Dec 2024 19:10:28 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 26 Dec 2024 19:10:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 26 Dec 2024 19:10:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 26 Dec 2024 19:10:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TerbKxQ9xwMR7mIIo8OkpIcpqoqSlnHoAgxux3xRuxODlGyR+48XZdLdQcjXe05IgEHCTE6yyGEYO1O5m0Zu+YhI7akiI7mU/Tyn8ZVwmfyOsU48OxhB+xjyd3VSPaqBEVCKo/ZnAmzLnHdR9uDCAJtfhMda7OY5iY5Q/ueW1Gn9qGJ8QfCcM4Ng6Q5qndnhKilUn+HMEW8Dar2CKFq17xd9YfomPw5ucCePRyHfMoEs0TWdc3PypQKPUTsIDGb+iptZji9SHH0cArCtjSi5+VAh0ZWkB9RCsDrqNKyNs/EVjeyap7iWzzqY/IFMKgSIQ5Lc9KEj2opmSRqSbVceWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4bsj2rHbRfxyefKJ2MScRQ+aRkDMiaLTw5AECBzVZE=;
 b=g+tRoHtA6PqaWe5SObI6P8cWApJuuNWiuoFyl6A1WEyuWaug2S5dUmTjdOd3mfpshGAscYji4f98tF3SjZnU3qv38QdxXiSHsf1wTQ0W0VIGrKAK9X4ZZ0JO51Al900jYkGSAJSywiczo/Ef8o/kKjoVj4Aw6yNP8df/Cm23i3+NEikyYGHQb1fZ5kJmSgS3y8KIhXsPb47pWbsroDyRhyFekiJkTzH//5KHdXAVNHMxatHsmEycIB2YUzf8F/gtyd1p8C89kQcytEbY4tmoTlcKzyn+BEmsJYjF5VhDVMokQ+RlTxKO0y8qur9TVNkAKQdjH3dUw2oSQCY8mGJ8kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 03:10:19 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 03:10:19 +0000
Date: Fri, 27 Dec 2024 11:10:11 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Breno Leitao <leitao@debian.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>, Tejun Heo <tj@kernel.org>,
	<netdev@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <202412271017.cad7675-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BY1PR11MB8053:EE_
X-MS-Office365-Filtering-Correlation-Id: dcacb869-0bd3-4e47-6327-08dd2623fe66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?CRzUzi+EbzIIZfeLV55E2jKPh9LrGgi/qDxX4XQUGH1/mcBmLOslaWkf53?=
 =?iso-8859-1?Q?a4zC/oAa0+eN6J6KIGudZlsMDhJPlBsgKvedpwHQl4xbP5ArIRJRyOh9yP?=
 =?iso-8859-1?Q?QdycvoRxdU2zVqCggsWTFaEIihOSIr3/Z1ifDZyQGOnxVxTnFtA4hx64Bf?=
 =?iso-8859-1?Q?qdX7kQEA6L/59CVktxVWXccx+eGypFzwzvkoh5HOUpe40PMHswv4nM/S+7?=
 =?iso-8859-1?Q?zIRUE532FZsQHdSObnUyP1HpUkzeODyxNGG002pD1qUG264R8jxBroXOpG?=
 =?iso-8859-1?Q?0q7IinMs9J8t0Jgr1YAnlb3jaNyAjDb89dvavp8YXupA3vYTUVFrrMMHQE?=
 =?iso-8859-1?Q?MxRkvmlz+wqyJs7ZOZ8ZPdfKmycEzmfguB7u3jexAoA/L888kv79jgaYb1?=
 =?iso-8859-1?Q?5Zny1g089cOETFEYNNnZX4l02aPMaHTW7jOZTkI12kFJDX0VmoQue3sVV0?=
 =?iso-8859-1?Q?GdXhx4fHFNKuvsb6Y6UiMu2kgziwcliJrRW+SzIVcHL6xv6vEEwplJTlFv?=
 =?iso-8859-1?Q?YbCLvPGP51VAz5hSHYOkl+McMp1oKYR15QJnWgKn2oaaqx11MFYKwPTUC3?=
 =?iso-8859-1?Q?OCOdbo9mA9V3LIUy7vRsWC9pXhieWk3pFQwD4Lixmo/ybEQXBrH7cE7IiR?=
 =?iso-8859-1?Q?z/xci2S7SP3qNm4XxwZrcv9Yv3olT+j9Iagy7YT1etfmkVnHqifsWWKlJf?=
 =?iso-8859-1?Q?KUK4bszL4Hnrw8Zod6bQYhNtScJ89g3WRbTzOUQbIJHeLgh8vORQ3giKsk?=
 =?iso-8859-1?Q?o9lq7moDfrql+gqeuCrjjRBpvI/aJdP3KiCwjDF2UmSZhresOH3FxxBP3J?=
 =?iso-8859-1?Q?zIMtMu4rkyDJjSKFaP10DDKsTDDshfvPYU8NhiNrk7pfCh3/r3MTpGGLaF?=
 =?iso-8859-1?Q?xJKSfJxwLrneQX1s1+vak8wLG0/xgYrvoaHsrF4pdz/iSVnLieqc63+j2E?=
 =?iso-8859-1?Q?aSVfGQmnWwfPTg2Vs8UX2Vm0a8RBvDzvNMmJLPWrgRcllAIlK1xsofyfDv?=
 =?iso-8859-1?Q?SZx0pMHxeLNDb8jJaPjePRYBQrE7ef8E7b7Av9lqSMGG3Y9GBsrPJoFZF8?=
 =?iso-8859-1?Q?i/XthcQqjgJQtADCvJv/3L9BlZVn7jGzKnwUSxk9gYKWS70T0TTnQec44t?=
 =?iso-8859-1?Q?KJUQdZv1Pp+7bttkigY7a7N63E2+X6f35OiUvWd5z2sAZAHvndg/mdJil0?=
 =?iso-8859-1?Q?Prd7r5oKgJ4d804erd+S2kKf/6gyl4scKZWZZy6td5nb3TezskeEGDLYuW?=
 =?iso-8859-1?Q?Kru94fKqxiFgJ8mZyexkfVv4OR96XdilmX/hmiA8fuC+oh9EUYL626COkI?=
 =?iso-8859-1?Q?zpO332JwkHQaxwAuGtxTuEIaZ1LD4mTpPIvu6XSLmG/hf02QVE8L2DKjSu?=
 =?iso-8859-1?Q?6E4uDnWIVD/ipYgyq3uIe99JOI3h9NcA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?yXZ7cj1SGdedvKqozwMwgIsk5ZnmfSIj9Eewyo0fHvhVfaUjoTpLM4b+JX?=
 =?iso-8859-1?Q?QheW+5Gh+nHbs9uMyAvVhJCpds4G0U8CoJUC2zndHCratqJaRwpOEklHnv?=
 =?iso-8859-1?Q?/MTIsyB61iDWsxt4rzZx9eNXqWWjv5GNFNLuYivdsarazWYFi2Kwhg0x1q?=
 =?iso-8859-1?Q?mWYD9ptfOjLgFOxbwO6x34MNbc7mjDsKk5kv+32ui0SAiFcx2uOObvZ8Pn?=
 =?iso-8859-1?Q?hEsF6BThv3MY9/Itm+d0xJ/kkSBLyK3u2cDFOx6iJagVrgwA+TTvjtS0i+?=
 =?iso-8859-1?Q?M0vfPKh1By7bKW46Gc74Xh4tgph5LjHyx2gWEnmUdm7H9QKtdPfkgJiGZe?=
 =?iso-8859-1?Q?2jZaQFh+whlcdF1dVTUmPqd7YIUqrdgYL4XwXJ3l1x9Xd2iZR6xscK3iUf?=
 =?iso-8859-1?Q?q7/d1IzGJjbxqlMtSa4qioi/LMboxMdTCT8khh67UNdAFznSzgQuxa1EyK?=
 =?iso-8859-1?Q?VjojsqduzhBefRPnwzSPuckLCdvoiZErPaKW0gMX/O0sHUwvgLPS/rwaF0?=
 =?iso-8859-1?Q?/ICgz4HuKqVYGtOE/mj4L039p7osRHbTDtPpZTlQzUGpIqSda16jTE94Jl?=
 =?iso-8859-1?Q?QCbfNZCYh8pz1ay5WPu8nxQragtctizgHlo1Waa3BrMtjw71wvj44nf6yY?=
 =?iso-8859-1?Q?aYuZyDli0Dry+2CeAFkMOjmmg9hAD4dd6fi/RPEYz3e3ZqJt57BxjHAK5x?=
 =?iso-8859-1?Q?A17LZEjV9YqX35OnE7QNKNmbhqJKSPpypWyYM0rh1IKydnxqfOFFpR/pOj?=
 =?iso-8859-1?Q?j+iavipFQd1k7YXek9sTBFLdxYkKTkC8x2kIuEmKHGbUFOoEm/LOPE+ogx?=
 =?iso-8859-1?Q?6G3H2GUVvF8U9ixkfX0vwNyima355dYLedd/t4wcxXg8D6PsTwjgeyNMI7?=
 =?iso-8859-1?Q?tGnY2GhYWLt7j8Af4HvBoXCwNqpV1h1ZUuiPpa4sAjflX98kDJ36/qozT9?=
 =?iso-8859-1?Q?wv7qExMFWxI2kAoy9Xg5B10lcO/wZySum+u4cYWFT8HARmNx+jtMZjR8og?=
 =?iso-8859-1?Q?j8FZQeLo/GxsYecOsSytBrqIaYisX9wWXX4wPbVgF+/66q4lcOlcg5degc?=
 =?iso-8859-1?Q?X0DM36mK8DEWqNd1xvZ+rRVZAYc6rk4viUBz6LmE9EDd/5VDpoBWO6oLnB?=
 =?iso-8859-1?Q?QwcIgo6k3q0b91DfpS0wu8Y3oeL0dw4JeGwF22fX3keI5MEypmJ06WRt13?=
 =?iso-8859-1?Q?Y9YQi+x5ublV2e/fr21oeWXGslduiVVMs8pjAv0wpeKqD3RHPbNyGQGJ+V?=
 =?iso-8859-1?Q?DdSfJ6/5VsSaHOs9aQRudsxxe4ksFEpVAh5dZVUfOosaSImBCeigLUaolN?=
 =?iso-8859-1?Q?8NymDoSud8lRYQgM6Hyj3CoIRrhl/QPbFuRZ6J1BfJbiBgx5nSYyIlIejj?=
 =?iso-8859-1?Q?VB9sWL8aUiy84E1urnoD1sVvqEKYEO3tGKRuhTpvjsei+LbYS1sTwMsswC?=
 =?iso-8859-1?Q?XyuOBiWM6HLJUb8vHVcBLVhhVcVnXEU7vSk+01MphbxUkJD7pD6e3FIKu3?=
 =?iso-8859-1?Q?A6ZlRmCeteoB5XCspNOj9qMEsmyU9ksgq7X04rd+T9n333O5I6d3/o+2KA?=
 =?iso-8859-1?Q?uNjwld9rsmAzgQ1ji21lAui2ENvY33Z+gasIlv/QLh+zXGGhOBV3plxN8Q?=
 =?iso-8859-1?Q?IJHqvBM58qXMPXRI8z9YYb0vldBsVYAOd7N0jWFy6QjnO7BrTG3k79bA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dcacb869-0bd3-4e47-6327-08dd2623fe66
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 03:10:19.8415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: km9hL2wuH8PLnHQ4bCaww6dUXry8vGWRkprgW4QnYIDw1vIosRwasLgQYxaiRmg1fSNLiKDvyNq2iOjvPt+H4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 98.9% regression of stress-ng.syscall.ops_per_sec on:


commit: e1d3422c95f003eba241c176adfe593c33e8a8f6 ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: syscall
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202412271017.cad7675-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241227/202412271017.cad7675-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/lkp-spr-r02/syscall/stress-ng/60s

commit: 
  f916e44487 ("crypto: keywrap - remove assignment of 0 to cra_alignmask")
  e1d3422c95 ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")

f916e44487f56df4 e1d3422c95f003eba241c176adf 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    104.58 ±  4%     +89.1%     197.72 ± 14%  uptime.boot
      7288 ± 24%     -98.9%      78.17 ±  7%  perf-c2c.DRAM.local
      9145 ± 13%     -91.9%     745.33 ± 11%  perf-c2c.DRAM.remote
      5568 ± 12%     -88.2%     657.50 ± 12%  perf-c2c.HITM.local
      3760 ± 11%     -87.5%     469.00 ± 14%  perf-c2c.HITM.remote
      9329 ± 11%     -87.9%       1126 ± 13%  perf-c2c.HITM.total
     46.50 ± 15%     -54.8%      21.02 ±  4%  vmstat.cpu.id
     51.95 ± 14%     +51.6%      78.77        vmstat.cpu.sy
    122.38 ± 15%     +42.9%     174.93        vmstat.procs.r
    286478 ± 17%     -70.4%      84880 ± 22%  vmstat.system.cs
    452634 ±  8%     -35.6%     291504 ±  7%  vmstat.system.in
     45.01 ± 16%     -24.7       20.28 ±  4%  mpstat.cpu.all.idle%
      0.61 ±  9%      -0.1        0.53 ±  3%  mpstat.cpu.all.irq%
      0.38 ± 12%      -0.3        0.07 ±  8%  mpstat.cpu.all.soft%
     52.46 ± 14%     +26.4       78.91        mpstat.cpu.all.sys%
      1.53 ±  8%      -1.3        0.21 ± 19%  mpstat.cpu.all.usr%
     68.62 ± 11%     +36.0%      93.33        mpstat.max_utilization_pct
  14408584 ± 17%     -85.0%    2162730 ±  9%  numa-numastat.node0.local_node
  14787130 ± 16%     -84.7%    2259108 ±  9%  numa-numastat.node0.numa_hit
    378415 ± 20%     -74.5%      96378 ± 31%  numa-numastat.node0.other_node
  14828942 ± 16%     -85.3%    2182831 ±  4%  numa-numastat.node1.local_node
  15140743 ± 15%     -84.6%    2326913 ±  3%  numa-numastat.node1.numa_hit
    310401 ± 23%     -53.6%     144070 ± 20%  numa-numastat.node1.other_node
  2.47e+08 ±  7%     -97.5%    6058129 ± 55%  stress-ng.syscall.ops
   4115705 ±  7%     -98.9%      45562 ± 67%  stress-ng.syscall.ops_per_sec
     60.78          +157.8%     156.67 ± 18%  stress-ng.time.elapsed_time
     60.78          +157.8%     156.67 ± 18%  stress-ng.time.elapsed_time.max
   1328018 ± 20%     -98.0%      25988 ± 27%  stress-ng.time.involuntary_context_switches
   8491001 ±  7%     -90.4%     813538 ± 12%  stress-ng.time.minor_page_faults
     12033 ± 13%     +48.2%      17833        stress-ng.time.percent_of_cpu_this_job_got
      7188 ± 13%    +288.7%      27945 ± 18%  stress-ng.time.system_time
    125.75 ± 11%     -93.0%       8.76 ± 10%  stress-ng.time.user_time
    928827 ± 29%     -53.2%     435103 ± 49%  numa-meminfo.node0.Active
    928827 ± 29%     -53.2%     435103 ± 49%  numa-meminfo.node0.Active(anon)
    498023 ± 25%     -64.3%     178033 ± 49%  numa-meminfo.node0.Mapped
   7955396 ±  4%     -42.0%    4616532 ± 27%  numa-meminfo.node0.MemUsed
    617968 ±  6%     -47.7%     323140 ±  7%  numa-meminfo.node0.SUnreclaim
    483959 ± 27%     -54.7%     219320 ± 48%  numa-meminfo.node0.Shmem
    751560 ±  5%     -40.4%     448218 ±  7%  numa-meminfo.node0.Slab
    560024 ± 13%     -52.5%     266210 ± 26%  numa-meminfo.node1.Mapped
    578281 ±  5%     -55.9%     254838 ±  8%  numa-meminfo.node1.SUnreclaim
    650628 ±  6%     -48.9%     332569 ±  4%  numa-meminfo.node1.Slab
    880716 ± 15%     -19.5%     709092        meminfo.AnonPages
  13672374 ±  7%     -33.9%    9031338 ±  7%  meminfo.DirectMap2M
    525978 ± 53%     -69.0%     163236 ±  7%  meminfo.DirectMap4k
   1056336 ± 13%     -58.0%     444169 ±  5%  meminfo.Mapped
  12809084 ±  5%     -39.1%    7797102        meminfo.Memused
     31264 ±  4%     -15.1%      26531 ±  2%  meminfo.PageTables
   2042045 ± 10%     -91.7%     169004 ± 21%  meminfo.Percpu
   1194576 ±  5%     -51.6%     578144 ±  4%  meminfo.SUnreclaim
   1400466 ±  5%     -44.2%     780902 ±  3%  meminfo.Slab
   1305233 ±  8%     -75.6%     318219 ±  5%  meminfo.VmallocUsed
  13021410 ±  4%     -33.1%    8710068        meminfo.max_used_kB
    232071 ± 30%     -53.1%     108799 ± 49%  numa-vmstat.node0.nr_active_anon
    507435 ±  7%     -92.7%      36998 ± 52%  numa-vmstat.node0.nr_foll_pin_acquired
    507435 ±  7%     -92.7%      36998 ± 52%  numa-vmstat.node0.nr_foll_pin_released
    124087 ± 25%     -63.9%      44817 ± 48%  numa-vmstat.node0.nr_mapped
    120883 ± 28%     -54.6%      54884 ± 48%  numa-vmstat.node0.nr_shmem
    154572 ±  6%     -47.7%      80827 ±  7%  numa-vmstat.node0.nr_slab_unreclaimable
    232071 ± 30%     -53.1%     108798 ± 49%  numa-vmstat.node0.nr_zone_active_anon
  14786897 ± 16%     -84.7%    2258853 ±  9%  numa-vmstat.node0.numa_hit
  14408441 ± 17%     -85.0%    2162474 ±  9%  numa-vmstat.node0.numa_local
    378326 ± 20%     -74.5%      96378 ± 31%  numa-vmstat.node0.numa_other
    514271 ±  7%     -96.8%      16274 ± 76%  numa-vmstat.node1.nr_foll_pin_acquired
    514271 ±  7%     -96.8%      16274 ± 76%  numa-vmstat.node1.nr_foll_pin_released
    139843 ± 12%     -52.2%      66863 ± 26%  numa-vmstat.node1.nr_mapped
    144751 ±  5%     -56.0%      63753 ±  8%  numa-vmstat.node1.nr_slab_unreclaimable
  15140638 ± 15%     -84.6%    2326284 ±  3%  numa-vmstat.node1.numa_hit
  14828391 ± 16%     -85.3%    2182202 ±  4%  numa-vmstat.node1.numa_local
    310848 ± 23%     -53.7%     144070 ± 20%  numa-vmstat.node1.numa_other
      1.63 ±  8%     -89.4%       0.17 ± 15%  perf-stat.i.MPKI
 1.637e+10 ±  6%     +60.4%  2.625e+10        perf-stat.i.branch-instructions
      1.44 ±  6%      -1.2        0.21 ± 22%  perf-stat.i.branch-miss-rate%
 2.136e+08 ±  9%     -88.8%   23845415 ± 17%  perf-stat.i.branch-misses
     17.93            +4.7       22.59 ±  2%  perf-stat.i.cache-miss-rate%
 1.345e+08 ± 14%     -87.9%   16337550 ± 11%  perf-stat.i.cache-misses
 7.321e+08 ± 13%     -89.9%   73757074 ±  9%  perf-stat.i.cache-references
    299339 ± 17%     -71.2%      86356 ± 22%  perf-stat.i.context-switches
 3.643e+11 ± 12%     +43.5%  5.226e+11        perf-stat.i.cpu-cycles
      6751 ± 26%     -91.7%     560.46 ± 10%  perf-stat.i.cpu-migrations
      2595 ± 16%   +1226.1%      34418 ± 10%  perf-stat.i.cycles-between-cache-misses
 7.931e+10 ±  6%     +65.6%  1.314e+11        perf-stat.i.instructions
    117398 ±  7%     -90.9%      10640 ± 23%  perf-stat.i.minor-faults
    117398 ±  7%     -90.9%      10640 ± 23%  perf-stat.i.page-faults
     10.99 ± 81%     +11.1       22.09 ±  2%  perf-stat.overall.cache-miss-rate%
      1733 ± 83%   +1769.9%      32413 ± 10%  perf-stat.overall.cycles-between-cache-misses
 9.827e+09 ± 82%    +165.3%  2.607e+10        perf-stat.ps.branch-instructions
    132156 ± 81%     +68.4%     222492        perf-stat.ps.cpu-clock
 2.221e+11 ± 84%    +133.7%   5.19e+11        perf-stat.ps.cpu-cycles
 4.761e+10 ± 81%    +174.0%  1.304e+11        perf-stat.ps.instructions
    132156 ± 81%     +68.4%     222492        perf-stat.ps.task-clock
 2.934e+12 ± 81%    +602.3%   2.06e+13 ± 18%  perf-stat.total.instructions
    220008 ± 15%     -19.4%     177270        proc-vmstat.nr_anon_pages
   6232998            +2.0%    6358264        proc-vmstat.nr_dirty_background_threshold
  12481236            +2.0%   12732075        proc-vmstat.nr_dirty_threshold
   1022803 ±  6%     -94.8%      53269 ± 55%  proc-vmstat.nr_foll_pin_acquired
   1022803 ±  6%     -94.8%      53269 ± 55%  proc-vmstat.nr_foll_pin_released
  62705989            +2.0%   63960492        proc-vmstat.nr_free_pages
     45430            -9.0%      41329        proc-vmstat.nr_kernel_stack
    264494 ± 13%     -57.9%     111376 ±  5%  proc-vmstat.nr_mapped
      7823 ±  5%     -15.3%       6628 ±  2%  proc-vmstat.nr_page_table_pages
    299083 ±  5%     -51.7%     144547 ±  4%  proc-vmstat.nr_slab_unreclaimable
    133237 ± 40%     -64.6%      47194 ± 23%  proc-vmstat.numa_hint_faults
     58867 ± 37%     -66.7%      19588 ± 52%  proc-vmstat.numa_hint_faults_local
  29930446 ± 16%     -84.7%    4588940 ±  6%  proc-vmstat.numa_hit
  29240051 ± 16%     -85.1%    4348479 ±  6%  proc-vmstat.numa_local
    688863 ±  6%     -65.1%     240449 ±  2%  proc-vmstat.numa_other
  34070547 ± 15%     -55.6%   15117810        proc-vmstat.pgalloc_normal
   9560812 ±  7%     -81.2%    1798778 ±  6%  proc-vmstat.pgfault
  32930061 ± 15%     -55.2%   14759500        proc-vmstat.pgfree
     91329 ±  5%      +9.2%      99699 ±  3%  proc-vmstat.pgreuse
   9915913 ± 20%     -98.3%     173339 ± 53%  proc-vmstat.unevictable_pgs_culled
   6757354 ±  7%     -97.6%     165554 ± 55%  proc-vmstat.unevictable_pgs_mlocked
   6757106 ±  7%     -97.6%     165524 ± 55%  proc-vmstat.unevictable_pgs_munlocked
   6757336 ±  7%     -97.6%     165550 ± 55%  proc-vmstat.unevictable_pgs_rescued
  30318612 ± 29%     -67.8%    9759801 ± 55%  sched_debug.cfs_rq:/.avg_vruntime.avg
 1.155e+08 ± 48%     -82.6%   20052364 ± 40%  sched_debug.cfs_rq:/.avg_vruntime.max
  12058632 ± 35%     -65.1%    4214240 ± 62%  sched_debug.cfs_rq:/.avg_vruntime.min
   8355440 ± 32%     -72.0%    2338972 ± 43%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.36 ±  4%     -22.5%       0.28 ± 22%  sched_debug.cfs_rq:/.h_nr_running.stddev
    469558 ± 40%     -98.3%       7970 ±223%  sched_debug.cfs_rq:/.left_deadline.avg
  34885682 ± 36%     -94.9%    1785497 ±223%  sched_debug.cfs_rq:/.left_deadline.max
   3648842 ± 36%     -96.7%     119032 ±223%  sched_debug.cfs_rq:/.left_deadline.stddev
    469304 ± 40%     -98.3%       7970 ±223%  sched_debug.cfs_rq:/.left_vruntime.avg
  34885597 ± 36%     -94.9%    1785497 ±223%  sched_debug.cfs_rq:/.left_vruntime.max
   3647029 ± 36%     -96.7%     119031 ±223%  sched_debug.cfs_rq:/.left_vruntime.stddev
     14470 ± 11%     -75.4%       3560 ± 37%  sched_debug.cfs_rq:/.load.avg
    538578           -74.7%     136360 ±117%  sched_debug.cfs_rq:/.load.max
     76707 ±  6%     -85.9%      10812 ± 95%  sched_debug.cfs_rq:/.load.stddev
  30318615 ± 29%     -67.8%    9759801 ± 55%  sched_debug.cfs_rq:/.min_vruntime.avg
 1.155e+08 ± 48%     -82.6%   20052364 ± 40%  sched_debug.cfs_rq:/.min_vruntime.max
  12058632 ± 35%     -65.1%    4214240 ± 62%  sched_debug.cfs_rq:/.min_vruntime.min
   8355438 ± 32%     -72.0%    2338972 ± 43%  sched_debug.cfs_rq:/.min_vruntime.stddev
      1.50           -25.9%       1.11 ± 14%  sched_debug.cfs_rq:/.nr_running.max
      0.36 ±  4%     -23.9%       0.28 ± 23%  sched_debug.cfs_rq:/.nr_running.stddev
    175.76 ± 86%     -95.8%       7.45 ± 46%  sched_debug.cfs_rq:/.removed.load_avg.avg
     27342 ± 78%     -98.1%     512.00 ± 47%  sched_debug.cfs_rq:/.removed.load_avg.max
      2102 ± 80%     -97.3%      56.81 ± 25%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      8.93 ± 41%     -57.2%       3.82 ± 47%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    473.80 ± 21%     -43.8%     266.14 ± 44%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     60.70 ± 28%     -52.0%      29.17 ± 25%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      8.92 ± 41%     -57.1%       3.82 ± 47%  sched_debug.cfs_rq:/.removed.util_avg.avg
    473.40 ± 21%     -43.8%     266.14 ± 44%  sched_debug.cfs_rq:/.removed.util_avg.max
     60.66 ± 28%     -51.9%      29.17 ± 25%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    469304 ± 40%     -98.3%       7970 ±223%  sched_debug.cfs_rq:/.right_vruntime.avg
  34885597 ± 36%     -94.9%    1785497 ±223%  sched_debug.cfs_rq:/.right_vruntime.max
   3647029 ± 36%     -96.7%     119031 ±223%  sched_debug.cfs_rq:/.right_vruntime.stddev
    285.83 ±  6%     -29.2%     202.46 ±  9%  sched_debug.cfs_rq:/.runnable_avg.stddev
    284.94 ±  6%     -29.6%     200.61 ± 10%  sched_debug.cfs_rq:/.util_avg.stddev
    713422 ± 11%     +21.5%     866805 ±  3%  sched_debug.cpu.avg_idle.avg
      4087 ± 13%     -38.1%       2531 ± 10%  sched_debug.cpu.avg_idle.min
     10.42 ±  6%     +24.9%      13.01 ±  9%  sched_debug.cpu.clock.stddev
    207318 ± 20%     -94.7%      10968 ± 31%  sched_debug.cpu.curr->pid.max
     17746 ± 56%     -89.6%       1849 ± 36%  sched_debug.cpu.curr->pid.stddev
      0.36 ±  4%     -22.2%       0.28 ± 24%  sched_debug.cpu.nr_running.stddev
     40760 ± 17%     -58.8%      16776 ± 60%  sched_debug.cpu.nr_switches.avg
     23292 ±  9%     -60.8%       9124 ± 58%  sched_debug.cpu.nr_switches.min
   -128.30           -81.7%     -23.44        sched_debug.cpu.nr_uninterruptible.min
     53.13 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.sync
     53.13 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.sync
     53.13 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.sync
     53.11 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_sync.do_syscall_64.entry_SYSCALL_64_after_hwframe.sync
     53.11 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.ksys_sync.__x64_sys_sync.do_syscall_64.entry_SYSCALL_64_after_hwframe.sync
     53.10 ±  6%     -53.1        0.00        perf-profile.calltrace.cycles-pp.iterate_supers.ksys_sync.__x64_sys_sync.do_syscall_64.entry_SYSCALL_64_after_hwframe
     52.71 ±  6%     -52.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.iterate_supers.ksys_sync.__x64_sys_sync.do_syscall_64
     52.64 ±  6%     -52.6        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.iterate_supers.ksys_sync.__x64_sys_sync
     25.29 ± 17%     -25.3        0.00        perf-profile.calltrace.cycles-pp.quotactl
     25.29 ± 17%     -25.3        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.quotactl
     25.29 ± 17%     -25.3        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.quotactl
     25.28 ± 17%     -25.3        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_quotactl.do_syscall_64.entry_SYSCALL_64_after_hwframe.quotactl
     25.28 ± 17%     -25.3        0.00        perf-profile.calltrace.cycles-pp.iterate_supers.__x64_sys_quotactl.do_syscall_64.entry_SYSCALL_64_after_hwframe.quotactl
     25.10 ± 17%     -25.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.07 ± 17%     -25.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
      0.00            +0.5        0.54        perf-profile.calltrace.cycles-pp.update_process_times.tick_nohz_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt
      0.00            +0.6        0.55        perf-profile.calltrace.cycles-pp.tick_nohz_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      0.00            +0.6        0.56        perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      0.00            +0.6        0.63        perf-profile.calltrace.cycles-pp.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.osq_lock
      0.00            +0.6        0.64        perf-profile.calltrace.cycles-pp.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.osq_lock.rwsem_optimistic_spin
      0.00            +0.7        0.67        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.osq_lock.rwsem_optimistic_spin.rwsem_down_write_slowpath
      0.00            +0.7        0.69        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.osq_lock.rwsem_optimistic_spin.rwsem_down_write_slowpath.down_write
      0.00           +98.2       98.16        perf-profile.calltrace.cycles-pp.osq_lock.rwsem_optimistic_spin.rwsem_down_write_slowpath.down_write.ipcget
     79.52 ±  6%     -79.5        0.06 ± 46%  perf-profile.children.cycles-pp._raw_spin_lock
     78.92 ±  6%     -78.8        0.09 ± 17%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     78.38 ±  6%     -78.4        0.00        perf-profile.children.cycles-pp.iterate_supers
     53.13 ±  6%     -53.1        0.00        perf-profile.children.cycles-pp.sync
     53.11 ±  6%     -53.1        0.00        perf-profile.children.cycles-pp.__x64_sys_sync
     53.11 ±  6%     -53.1        0.00        perf-profile.children.cycles-pp.ksys_sync
     25.29 ± 17%     -25.3        0.00        perf-profile.children.cycles-pp.quotactl
     25.28 ± 17%     -25.3        0.00        perf-profile.children.cycles-pp.__x64_sys_quotactl
      1.06 ± 28%      -1.0        0.08 ± 10%  perf-profile.children.cycles-pp.__schedule
      0.94 ± 25%      -0.9        0.06 ±  6%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.94 ± 25%      -0.9        0.06 ±  6%  perf-profile.children.cycles-pp.ret_from_fork
      0.94 ± 24%      -0.9        0.06 ±  6%  perf-profile.children.cycles-pp.kthread
      1.62 ± 15%      -0.8        0.78        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      1.58 ± 15%      -0.8        0.76        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.86 ± 28%      -0.8        0.07 ± 10%  perf-profile.children.cycles-pp.schedule
      0.87 ± 16%      -0.8        0.08 ± 45%  perf-profile.children.cycles-pp.__fput
      0.88 ± 19%      -0.8        0.12 ±  6%  perf-profile.children.cycles-pp.handle_softirqs
      0.79 ± 27%      -0.8        0.03 ± 70%  perf-profile.children.cycles-pp.__pick_next_task
      0.99 ± 35%      -0.7        0.24 ±  3%  perf-profile.children.cycles-pp.common_startup_64
      0.99 ± 35%      -0.7        0.24 ±  3%  perf-profile.children.cycles-pp.cpu_startup_entry
      0.99 ± 35%      -0.7        0.24 ±  3%  perf-profile.children.cycles-pp.do_idle
      0.77 ± 28%      -0.7        0.02 ± 99%  perf-profile.children.cycles-pp.pick_next_task_fair
      0.82 ± 32%      -0.7        0.08 ± 45%  perf-profile.children.cycles-pp.dput
      0.98 ± 36%      -0.7        0.24 ±  3%  perf-profile.children.cycles-pp.start_secondary
      0.78 ± 19%      -0.7        0.09 ±  9%  perf-profile.children.cycles-pp.rcu_core
      0.69 ± 28%      -0.7        0.02 ± 99%  perf-profile.children.cycles-pp.sched_balance_rq
      0.74 ± 19%      -0.7        0.08 ±  8%  perf-profile.children.cycles-pp.rcu_do_batch
      0.78 ± 36%      -0.6        0.20 ±  3%  perf-profile.children.cycles-pp.cpuidle_idle_call
      0.63 ± 21%      -0.6        0.08 ± 10%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.73 ± 37%      -0.5        0.20 ±  3%  perf-profile.children.cycles-pp.cpuidle_enter
      0.73 ± 37%      -0.5        0.20 ±  3%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.66 ± 17%      -0.4        0.22 ± 17%  perf-profile.children.cycles-pp.__cmd_record
      0.39 ± 15%      -0.3        0.06 ±  9%  perf-profile.children.cycles-pp.kmem_cache_free
      0.35 ± 17%      -0.3        0.07 ± 45%  perf-profile.children.cycles-pp.__dentry_kill
      0.41 ± 15%      -0.3        0.14 ± 45%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.33 ± 30%      -0.3        0.06 ± 53%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      0.94 ± 11%      -0.3        0.67        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.93 ± 11%      -0.3        0.67        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.30 ± 19%      -0.2        0.05 ±  8%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.81 ± 11%      -0.2        0.59        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.22 ± 16%      -0.2        0.04 ± 44%  perf-profile.children.cycles-pp.alloc_inode
      0.76 ± 11%      -0.2        0.58        perf-profile.children.cycles-pp.tick_nohz_handler
      0.25 ± 18%      -0.2        0.08 ± 44%  perf-profile.children.cycles-pp.new_inode
      0.24 ± 14%      -0.2        0.08 ± 11%  perf-profile.children.cycles-pp.generic_perform_write
      0.72 ± 11%      -0.2        0.56        perf-profile.children.cycles-pp.update_process_times
      0.22 ± 14%      -0.1        0.10 ± 44%  perf-profile.children.cycles-pp.task_work_run
      0.18 ±  8%      -0.1        0.11 ± 13%  perf-profile.children.cycles-pp.write
      0.16 ±  6%      -0.1        0.09 ± 10%  perf-profile.children.cycles-pp.vfs_write
      0.16 ± 25%      -0.1        0.09 ±  5%  perf-profile.children.cycles-pp.update_load_avg
      0.16 ±  8%      -0.1        0.10 ± 11%  perf-profile.children.cycles-pp.ksys_write
      0.07 ± 25%      +0.0        0.11 ± 13%  perf-profile.children.cycles-pp.writen
      0.07 ± 23%      +0.0        0.11 ± 15%  perf-profile.children.cycles-pp.record__pushfn
      0.01 ±200%      +0.0        0.06 ±  9%  perf-profile.children.cycles-pp.update_rq_clock
      0.16 ± 23%      +0.1        0.22 ± 16%  perf-profile.children.cycles-pp.handle_internal_command
      0.16 ± 23%      +0.1        0.22 ± 16%  perf-profile.children.cycles-pp.main
      0.16 ± 23%      +0.1        0.22 ± 16%  perf-profile.children.cycles-pp.run_builtin
      0.16 ± 22%      +0.1        0.22 ± 17%  perf-profile.children.cycles-pp.cmd_record
      0.14 ± 27%      +0.1        0.21 ± 16%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      0.13 ± 29%      +0.1        0.20 ± 17%  perf-profile.children.cycles-pp.perf_mmap__push
      0.00            +0.1        0.07 ± 10%  perf-profile.children.cycles-pp.poll_idle
     96.10            +3.5       99.55        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     96.07            +3.5       99.55        perf-profile.children.cycles-pp.do_syscall_64
      4.58 ± 67%     +94.2       98.78        perf-profile.children.cycles-pp.down_write
      4.48 ± 69%     +94.3       98.74        perf-profile.children.cycles-pp.rwsem_down_write_slowpath
      4.26 ± 68%     +94.3       98.60        perf-profile.children.cycles-pp.rwsem_optimistic_spin
      3.65 ± 75%     +94.5       98.18        perf-profile.children.cycles-pp.osq_lock
      0.56 ± 25%     +98.7       99.29        perf-profile.children.cycles-pp.ipcget
     78.03 ±  6%     -77.9        0.09 ± 17%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.79 ± 14%      -0.7        0.04 ± 45%  perf-profile.self.cycles-pp._raw_spin_lock
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.update_rq_clock
      0.00            +0.1        0.07 ± 10%  perf-profile.self.cycles-pp.poll_idle
      3.60 ± 75%     +93.9       97.50        perf-profile.self.cycles-pp.osq_lock
      0.01 ± 21%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_pages_noprof.___kmalloc_large_node.__kmalloc_large_noprof.ksys_ioperm
      0.01 ± 14%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_noprof.__filemap_get_folio
      0.04 ± 50%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_pages_noprof.pcpu_alloc_pages.constprop.0
      0.01 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__dentry_kill.dput.__do_sys_mq_unlink.do_syscall_64
      0.04 ±152%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__dentry_kill.dput.__fput.__x64_sys_close
      0.01 ± 61%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__dentry_kill.dput.do_renameat2.__x64_sys_renameat
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__dentry_kill.dput.do_unlinkat.__x64_sys_unlink
      0.01 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__get_user_pages.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.01 ± 45%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.__do_sys_remap_file_pages
      0.01 ± 32%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.do_mlock
      0.00 ± 37%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.00 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.__do_sys_timerfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.00 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc.bpf_prog_create_from_user
      0.01 ± 53%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_store_orig_filter.bpf_prog_create_from_user.seccomp_set_mode_filter
      0.01 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_epoll_create.__x64_sys_epoll_create.do_syscall_64
      0.01 ± 74%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_eventfd.__x64_sys_eventfd2.do_syscall_64
      0.01 ± 71%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_shmat.__x64_sys_shmat.do_syscall_64
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.newque.ipcget.__x64_sys_msgget
      0.01 ± 21%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.percpu_ref_init.io_ring_ctx_alloc.io_uring_create
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.01 ± 50%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_cache_noprof.seccomp_set_mode_filter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.__do_sys_add_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.02 ± 86%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_setaffinity.do_syscall_64
      0.00 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.alloc_fdtable.dup_fd.copy_process
      0.00 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter
      0.01 ± 41%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.bpf_jit_binary_pack_alloc.bpf_int_jit_compile.bpf_prog_select_runtime
      0.01 ± 66%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.dup_user_cpus_ptr.dup_task_struct.copy_process
      0.00 ± 54%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.io_pages_map.io_allocate_scq_urings.io_uring_create
      0.01 ± 88%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.io_ring_ctx_alloc.io_uring_create.io_uring_setup
      0.01 ±127%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_mq_timedsend.__x64_sys_mq_timedsend
      0.01 ± 78%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      0.01 ± 71%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_noprof.vmemdup_user.setxattr_copy.path_setxattrat
      0.00 ± 13%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.kmemdup_noprof.bpf_prepare_filter.bpf_prog_create_from_user
      0.01 ± 54%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_add_key
      0.01 ± 92%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_request_key
      0.00 ± 10%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_noprof.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.01 ± 79%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__kmalloc_noprof.user_preparse.__key_create_or_update.key_create_or_update
      0.00 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__put_anon_vma.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.part
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      0.01 ±130%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof.bpf_prog_alloc_no_stats
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node.dup_task_struct
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      0.17 ± 16%     -50.2%       0.08 ± 15%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ± 11%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus.wait_rcu_exp_gp
      0.01 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.apply_mlockall_flags.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.01 ± 65%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.cgroup_css_set_fork.cgroup_can_fork.copy_process.kernel_clone
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.00 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.cpus_read_lock.static_key_slow_dec.io_ring_ctx_free.io_ring_exit_work
      0.01 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.vfs_copy_file_range
      0.01 ± 79%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.do_ftruncate.do_sys_ftruncate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.do_select.core_sys_select.do_pselect.constprop
      0.01 ± 60%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.__key_create_or_update.key_create_or_update.__do_sys_add_key
      0.00 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.__mm_populate.__do_sys_remap_file_pages.do_syscall_64
      0.01 ±  9%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock
      0.01 ± 83%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock2
      0.01 ± 46%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.acct_collect.do_exit.do_group_exit
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.exit_mm.do_exit.do_group_exit
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.open_last_lookups.path_openat.do_filp_open
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.super_lock.iterate_supers.ksys_sync
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.01 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.00 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read_killable.__do_sys_kcmp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 47%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read_killable.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_read_killable.mm_access.process_vm_rw_core.constprop
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__do_sys_pkey_alloc.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__key_link_lock.__key_create_or_update.key_create_or_update
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      0.01 ± 84%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.mmap_region
      0.01 ± 67%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__sock_release.sock_close.__fput
      0.01 ± 83%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.__x64_sys_pkey_free.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ±124%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.01 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.chown_common.ksys_fchown.__x64_sys_fchown
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.01 ± 32%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_shmat.__x64_sys_shmat.do_syscall_64
      0.01 ± 72%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_truncate.do_ftruncate.do_sys_ftruncate
      0.01 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_truncate.vfs_truncate.__x64_sys_truncate
      0.01 ± 26%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.01 ±123%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.01 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.01 ± 91%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.generic_file_write_iter.vfs_write.ksys_write
      0.00 ± 46%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.ipcget.__x64_sys_msgget.do_syscall_64
      0.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.key_link.request_key_and_link.__do_sys_request_key
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.madvise_vma_behavior.do_madvise.part
      0.01 ± 51%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.__x64_sys_munlock
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.do_mlock
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.move_vma.__do_sys_mremap.do_syscall_64
      0.01 ± 50%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect
      0.01 ± 63%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.msgctl_down.ksys_msgctl.constprop
      0.01 ±101%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.semctl_down.ksys_semctl.constprop
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.shmctl_down.ksys_shmctl.constprop
      0.02 ±123%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.unlink_file_vma_batch_final.free_pgtables.vms_clear_ptes
      0.01 ± 61%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_link
      0.01 ± 66%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_linkat
      0.01 ± 12%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_rename
      0.01 ± 58%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_renameat
      0.01 ± 81%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_setxattr.file_setxattr.path_setxattrat
      0.03 ±139%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_unlink.__do_sys_mq_unlink.do_syscall_64
      0.01 ± 88%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vfs_unlink.do_unlinkat.__x64_sys_unlink
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vma_link_file.__mmap_new_vma.__mmap_region
      0.01 ± 67%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.__mmap_prepare.__mmap_region
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.02 ± 62%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.ksys_shmdt
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.01 ± 72%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__x64_sys_munlock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 87%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.01 ± 51%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.do_shmat.__x64_sys_shmat.do_syscall_64
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 51%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.02 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 88%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.__fput.task_work_run.syscall_exit_to_user_mode
      0.01 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.dcache_readdir.iterate_dir.__x64_sys_getdents
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_linkat.__x64_sys_link.do_syscall_64
      0.00 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_linkat.__x64_sys_linkat.do_syscall_64
      0.01 ± 41%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdir.do_syscall_64
      0.01 ± 60%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdirat.do_syscall_64
      0.01 ± 76%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_mknodat.__x64_sys_mknodat.do_syscall_64
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.01 ± 41%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlink.do_syscall_64
      0.01 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlinkat.do_syscall_64
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.01 ± 62%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.01 ± 43%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.mqueue_unlink.vfs_unlink.__do_sys_mq_unlink
      0.03 ±152%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.open_last_lookups.path_openat.do_filp_open
      0.01 ± 89%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.__x64_sys_chdir.do_syscall_64
      0.01 ± 45%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.__x64_sys_chmod.do_syscall_64
      0.01 ± 73%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.__x64_sys_fchmodat.do_syscall_64
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.do_faccessat.do_syscall_64
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.do_fchownat.__x64_sys_chown
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.do_mq_open.__x64_sys_mq_open
      0.01 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.do_readlinkat.part
      0.01 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.do_utimes.__x64_sys_utimensat
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.exit_fs.do_exit
      0.01 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.filename_setxattr.path_setxattrat
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.path_listxattrat.do_syscall_64
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.path_removexattrat.__x64_sys_removexattr
      0.02 ± 63%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_chdir
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_fchdir
      0.01 ± 50%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.user_statfs.__do_sys_statfs
      0.01 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.01 ± 37%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.vfs_statx.vfs_fstatat
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.scan_positives.dcache_readdir.iterate_dir
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.simple_unlink.simple_rmdir.vfs_rmdir
      0.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.simple_unlink.vfs_unlink.do_unlinkat
      0.01 ±  5%     -92.1%       0.00 ±223%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.step_into.link_path_walk.part
      0.01 ± 64%     -92.6%       0.00 ±223%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.step_into.open_last_lookups.path_openat
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.step_into.path_lookupat.filename_lookup
      0.14 ±186%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.terminate_walk.path_lookupat.filename_lookup
      0.07 ±173%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_rename
      0.05 ±169%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_renameat
      0.01 ± 54%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.exit_signals.do_exit.do_group_exit.__x64_sys_exit_group
      0.33 ±193%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_page_mkwrite.do_page_mkwrite.do_shared_fault.do_pte_missing
      0.01 ± 26%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_preadv
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_readv
      0.02 ± 95%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.vfs_read.ksys_read.do_syscall_64
      0.00 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.filemap_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.00 ± 14%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.flush_delayed_work.io_ring_ctx_wait_and_kill.io_uring_release.__fput
      0.01 ±  9%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.flush_work.__lru_add_drain_all.do_pages_move.kernel_move_pages
      0.01 ± 48%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.01 ± 53%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.01 ± 43%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.vfs_write.ksys_write
      0.01 ± 65%   +1454.6%       0.09 ± 71%  perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.01 ± 14%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 46%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
      0.01 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.d_alloc_parallel
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.lookup_one_qstr_excl
      0.01 ± 16%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc_cursor.dcache_dir_open
      0.01 ± 41%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.alloc_anon_inode.__anon_inode_getfile
      0.01 ± 59%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.create_pipe_files.do_pipe2
      0.01 ±  5%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.ramfs_get_inode
      0.01 ±  9%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.mqueue_alloc_inode.alloc_inode.new_inode
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.sock_alloc_inode.alloc_inode.sock_alloc
      0.01 ± 68%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_node_noprof.alloc_vmap_area.__get_vm_area_node.__vmalloc_node_range_noprof
      0.01 ± 72%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_node_noprof.dup_task_struct.copy_process.kernel_clone
      0.01 ± 81%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.01 ± 73%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_clone.create_pipe_files
      0.01 ± 37%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.__anon_inode_getfile
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.create_pipe_files
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.sock_alloc_file
      0.01 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.dentry_open.do_mq_open
      0.06 ±166%     -99.2%       0.00 ±223%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.path_openat.do_filp_open
      0.01 ± 70%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_pid.copy_process.kernel_clone
      0.01 ± 48%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.copy_fs_struct.copy_process.kernel_clone
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.copy_sighand.copy_process.kernel_clone
      0.01 ±116%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.do_timer_create.__x64_sys_timer_create.do_syscall_64
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.dup_fd.copy_process.kernel_clone
      0.01 ± 77%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl
      0.01 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.ep_ptable_queue_proc.pipe_poll.ep_item_poll
      0.02 ± 98%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.01 ± 14%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.key_alloc.__key_create_or_update.key_create_or_update
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      0.01 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.01 ± 30%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.new_userfaultfd.__x64_sys_userfaultfd.do_syscall_64
      0.01 ± 97%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__do_sys_capset.do_syscall_64
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__sys_setreuid.do_syscall_64
      0.16 ±189%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.sk_prot_alloc.sk_alloc.unix_create1
      0.03 ±115%     -97.4%       0.00 ±223%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      0.01 ± 69%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.locks_lock_inode_wait.__do_sys_flock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.04 ±164%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mincore_pte_range.walk_pmd_range.isra.0
      0.02 ± 82%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mlock_pte_range.walk_pmd_range.isra.0
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mmput.getrusage.__do_sys_getrusage.do_syscall_64
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mmput.process_vm_rw_core.constprop.0
      0.01 ± 48%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_chmod.do_syscall_64
      0.01 ±119%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmod.do_syscall_64
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.01 ± 48%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_chown.do_syscall_64
      0.01 ± 53%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_fchownat.do_syscall_64
      0.01 ± 64%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_rename.do_syscall_64
      0.01 ± 41%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.01 ± 21%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_link
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_linkat
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdir
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdirat
      0.01 ± 37%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mknodat.__x64_sys_mknodat
      0.01 ± 39%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlink
      0.01 ± 53%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlinkat
      0.01 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.filename_setxattr.path_setxattrat.__x64_sys_setxattr
      0.01 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.open_last_lookups.path_openat.do_filp_open
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.path_removexattrat.__x64_sys_removexattr.do_syscall_64
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.vfs_truncate.__x64_sys_truncate.do_syscall_64
      0.01 ± 90%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mnt_want_write.vfs_utimes.do_utimes.__x64_sys_utimensat
      0.01 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.move_page_tables.move_vma.__do_sys_mremap.do_syscall_64
      0.01 ± 24%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.__key_instantiate_and_link.__key_create_or_update.key_create_or_update
      0.01 ± 74%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.bpf_prog_pack_alloc.bpf_jit_binary_pack_alloc.bpf_int_jit_compile
      0.01 ± 76%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.btrfs_wait_ordered_roots.btrfs_sync_fs.iterate_supers
      0.01 ± 67%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      0.01 ± 81%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.ep_clear_and_put.ep_eventpoll_release.__fput
      0.01 ± 62%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.fdget_pos.__x64_sys_getdents.do_syscall_64
      0.00 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.futex_exit_release.exit_mm_release.exit_mm
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.io_uring_del_tctx_node.io_tctx_exit_cb.task_work_run
      0.01 ±103%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.pipe_double_lock.splice_pipe_to_pipe.do_splice
      0.01 ± 21%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.pipe_release.__fput.__x64_sys_close
      0.01 ± 13%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
      0.00          -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.srcu_gp_end.process_srcu.process_one_work
      0.02 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.sync_bdevs.ksys_sync.__x64_sys_sync
      0.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.vmsplice_to_pipe.__do_sys_vmsplice.do_syscall_64
      0.01 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc.bpf_prog_create_from_user
      0.01 ± 60%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc
      0.01 ±  9%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.01 ± 12%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.put_files_struct.do_exit.do_group_exit.__x64_sys_exit_group
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.__mmap_region.mmap_region
      0.01 ± 47%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.rhashtable_rehash_table.rht_deferred_worker.process_one_work.worker_thread
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_fault
      0.01 ± 48%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.sk_setsockopt.do_sock_setsockopt.__sys_setsockopt.__x64_sys_setsockopt
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
      0.02 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
      0.01 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.switch_task_namespaces.do_exit.do_group_exit.__x64_sys_exit_group
      0.03 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.task_work_run.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
      0.01 ± 22%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.truncate_inode_pages_range.evict.do_unlinkat.__x64_sys_unlink
      0.01 ± 49%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.truncate_inode_pages_range.truncate_pagecache.simple_setattr.notify_change
      0.02 ±121%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.01 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.userfaultfd_release_all.userfaultfd_release.__fput.__x64_sys_close
      0.01 ± 54%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.vfs_copy_file_range.__do_sys_copy_file_range.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ±107%     -88.8%       0.00 ±142%  perf-sched.sch_delay.avg.ms.__cond_resched.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 84%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.vfs_writev.do_pwritev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 88%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.vfs_writev.do_writev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 55%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.wait_for_key_construction.__do_sys_request_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 79%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.wait_for_key_construction.lookup_user_key.__do_sys_add_key.do_syscall_64
      0.01 ± 26%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.wait_for_key_construction.lookup_user_key.keyctl_invalidate_key.do_syscall_64
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.01 ± 28%   +1538.9%       0.21 ± 62%  perf-sched.sch_delay.avg.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.02 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ± 52%     -97.0%       0.00 ±223%  perf-sched.sch_delay.avg.ms.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.part
      0.04 ±110%   +1058.5%       0.48 ±151%  perf-sched.sch_delay.avg.ms.devkmsg_read.vfs_read.ksys_read.do_syscall_64
      0.02 ±  6%    +798.3%       0.14 ± 33%  perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.01 ± 11%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      0.00 ± 27%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.do_nanosleep.hrtimer_nanosleep_restart.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ± 18%    +983.3%       0.05 ± 53%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 26%     -91.5%       0.00 ±223%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.01 ± 34%   +2744.5%       0.38 ± 46%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.01 ± 31%     -68.8%       0.00 ± 72%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      0.01 ± 64%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ± 15%    +288.3%       0.03 ± 15%  perf-sched.sch_delay.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      0.00         +2441.7%       0.10 ±104%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.02 ± 36%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.bpf_prog_pack_alloc
      0.01 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.pcpu_alloc_noprof
      0.00 ± 10%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
      0.00 ± 19%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__shm_close
      0.00 ±  8%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      0.00 ± 17%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_shmat
      0.01 ± 36%    +126.7%       0.02 ± 33%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.ipcget
      0.01 ± 43%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.msgctl_down
      0.01 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.semctl_down
      0.00 ± 15%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.shmctl_down
      0.09 ±148%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.02 ± 35%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
      0.01 ± 23%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      0.01 ± 16%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
      0.01 ± 15%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus
      0.03 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
      0.03 ± 38%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
      0.01 ± 14%    +845.9%       0.14 ± 50%  perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      0.01 ± 75%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.schedule_timeout.synchronize_rcu_expedited_wait_once.synchronize_rcu_expedited_wait.rcu_exp_wait_wake
      0.04 ±  9%     +24.5%       0.04 ±  8%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ± 34%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
      0.02 ± 15%    +289.2%       0.06 ± 42%  perf-sched.sch_delay.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.syscall_exit_to_user_mode.ret_from_fork_asm.[unknown]
      0.02 ± 45%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 18%     +40.2%       0.03 ±  7%  perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ± 14%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__alloc_pages_noprof.___kmalloc_large_node.__kmalloc_large_noprof.ksys_ioperm
      0.06 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_noprof.__filemap_get_folio
      0.05 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__alloc_pages_noprof.pcpu_alloc_pages.constprop.0
      0.03 ± 86%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      0.01 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__dentry_kill.dput.__do_sys_mq_unlink.do_syscall_64
      3.88 ±194%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__dentry_kill.dput.__fput.__x64_sys_close
      0.01 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__dentry_kill.dput.do_renameat2.__x64_sys_renameat
      0.04 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__dentry_kill.dput.do_unlinkat.__x64_sys_unlink
      0.06 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      0.10 ± 75%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 64%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__get_user_pages.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.02 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.__do_sys_remap_file_pages
      0.02 ± 86%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.do_mlock
      0.01 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.01 ± 52%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node
      0.01 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.__do_sys_timerfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.10 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc.bpf_prog_create_from_user
      1.46 ±179%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_store_orig_filter.bpf_prog_create_from_user.seccomp_set_mode_filter
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.do_epoll_create.__x64_sys_epoll_create.do_syscall_64
      0.01 ±108%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.do_eventfd.__x64_sys_eventfd2.do_syscall_64
      0.06 ± 99%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.do_shmat.__x64_sys_shmat.do_syscall_64
      0.06 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.newque.ipcget.__x64_sys_msgget
      0.10 ± 17%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.percpu_ref_init.io_ring_ctx_alloc.io_uring_create
      0.02 ± 78%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.01 ±100%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_cache_noprof.seccomp_set_mode_filter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 45%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.__do_sys_add_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.08 ± 25%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.03 ±110%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_setaffinity.do_syscall_64
      0.01 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.alloc_fdtable.dup_fd.copy_process
      0.00 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter
      0.06 ± 84%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.bpf_jit_binary_pack_alloc.bpf_int_jit_compile.bpf_prog_select_runtime
      0.03 ± 95%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.dup_user_cpus_ptr.dup_task_struct.copy_process
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.io_pages_map.io_allocate_scq_urings.io_uring_create
      0.03 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.io_ring_ctx_alloc.io_uring_create.io_uring_setup
      0.03 ±149%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_mq_timedsend.__x64_sys_mq_timedsend
      0.03 ± 93%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      0.02 ± 95%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64
      0.01 ± 55%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_noprof.vmemdup_user.setxattr_copy.path_setxattrat
      0.00 ± 42%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.kmemdup_noprof.bpf_prepare_filter.bpf_prog_create_from_user
      0.02 ±131%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_add_key
      0.02 ±119%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_request_key
      0.01 ± 31%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_noprof.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.04 ± 62%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.05 ±113%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_noprof.user_preparse.__key_create_or_update.key_create_or_update
      0.01 ± 45%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__put_anon_vma.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      0.04 ± 86%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.part
      0.07 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      0.01 ±118%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof.bpf_prog_alloc_no_stats
      0.01 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node.dup_task_struct
      6.56 ± 87%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      0.03 ± 80%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus.wait_rcu_exp_gp
      0.09 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.apply_mlockall_flags.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.05 ± 69%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.01 ± 87%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.cgroup_css_set_fork.cgroup_can_fork.copy_process.kernel_clone
      0.03 ± 82%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.01 ± 28%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.cpus_read_lock.static_key_slow_dec.io_ring_ctx_free.io_ring_exit_work
      0.02 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.01 ± 84%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.vfs_copy_file_range
      0.02 ±117%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.do_ftruncate.do_sys_ftruncate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.04 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.do_select.core_sys_select.do_pselect.constprop
      0.03 ±118%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.__key_create_or_update.key_create_or_update.__do_sys_add_key
      0.00 ± 37%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.__mm_populate.__do_sys_remap_file_pages.do_syscall_64
      0.03 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock
      0.06 ±114%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock2
      0.02 ± 94%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.acct_collect.do_exit.do_group_exit
      0.02 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.exit_mm.do_exit.do_group_exit
      0.05 ± 83%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.open_last_lookups.path_openat.do_filp_open
      0.04 ± 47%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.super_lock.iterate_supers.ksys_sync
      0.01 ± 51%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.01 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read_killable.__do_sys_kcmp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 57%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read_killable.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.03 ± 68%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_read_killable.mm_access.process_vm_rw_core.constprop
      0.01 ± 51%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.01 ± 65%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__do_sys_pkey_alloc.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 37%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__key_link_lock.__key_create_or_update.key_create_or_update
      0.04 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      0.03 ± 88%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.mmap_region
      0.01 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__sock_release.sock_close.__fput
      0.03 ±106%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.__x64_sys_pkey_free.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ±119%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.02 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.chown_common.ksys_fchown.__x64_sys_fchown
      0.05 ± 24%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.02 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_shmat.__x64_sys_shmat.do_syscall_64
      0.01 ± 91%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_truncate.do_ftruncate.do_sys_ftruncate
      0.01 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_truncate.vfs_truncate.__x64_sys_truncate
      0.03 ± 38%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.03 ±159%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.02 ±108%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.01 ± 91%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.generic_file_write_iter.vfs_write.ksys_write
      0.01 ± 94%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.ipcget.__x64_sys_msgget.do_syscall_64
      0.05 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.key_link.request_key_and_link.__do_sys_request_key
      0.05 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.madvise_vma_behavior.do_madvise.part
      0.07 ± 92%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.__x64_sys_munlock
      0.04 ± 96%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.do_mlock
      0.02 ± 61%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.move_vma.__do_sys_mremap.do_syscall_64
      0.03 ±100%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect
      0.03 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.msgctl_down.ksys_msgctl.constprop
      0.05 ±165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.semctl_down.ksys_semctl.constprop
      0.03 ± 73%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.shmctl_down.ksys_shmctl.constprop
      0.04 ±104%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.unlink_file_vma_batch_final.free_pgtables.vms_clear_ptes
      0.02 ± 85%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_link
      0.01 ±102%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_linkat
      0.02 ± 44%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_rename
      0.06 ± 69%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_renameat
      0.01 ± 81%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_setxattr.file_setxattr.path_setxattrat
      6.06 ±195%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_unlink.__do_sys_mq_unlink.do_syscall_64
      0.19 ±147%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vfs_unlink.do_unlinkat.__x64_sys_unlink
      0.04 ± 43%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vma_link_file.__mmap_new_vma.__mmap_region
      0.03 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.__mmap_prepare.__mmap_region
      0.06 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.04 ± 60%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.ksys_shmdt
      0.03 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.03 ±102%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.__x64_sys_munlock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.04 ± 94%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.06 ±108%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.do_shmat.__x64_sys_shmat.do_syscall_64
      0.02 ± 94%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.09 ± 62%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.21 ± 61%     -80.4%       0.04 ±135%  perf-sched.sch_delay.max.ms.__cond_resched.dput.__fput.__x64_sys_close.do_syscall_64
      0.07 ± 82%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.__fput.task_work_run.syscall_exit_to_user_mode
      0.05 ± 43%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.dcache_readdir.iterate_dir.__x64_sys_getdents
      0.02 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_linkat.__x64_sys_link.do_syscall_64
      0.01 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_linkat.__x64_sys_linkat.do_syscall_64
      0.07 ± 47%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdir.do_syscall_64
      0.03 ± 92%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdirat.do_syscall_64
      0.04 ± 62%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_mknodat.__x64_sys_mknodat.do_syscall_64
      0.08 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.08 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.04 ± 62%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlink.do_syscall_64
      0.06 ± 41%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlinkat.do_syscall_64
      0.07 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.04 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.04 ± 47%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.mqueue_unlink.vfs_unlink.__do_sys_mq_unlink
      0.76 ±186%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.open_last_lookups.path_openat.do_filp_open
      0.03 ± 48%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.__x64_sys_chdir.do_syscall_64
      0.03 ± 86%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.__x64_sys_chmod.do_syscall_64
      0.03 ± 78%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.__x64_sys_fchmodat.do_syscall_64
      0.04 ± 47%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.do_faccessat.do_syscall_64
      0.01 ± 27%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.do_fchownat.__x64_sys_chown
      0.03 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.do_mq_open.__x64_sys_mq_open
      0.07 ± 60%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.do_readlinkat.part
      0.02 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.do_utimes.__x64_sys_utimensat
      0.03 ±116%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.exit_fs.do_exit
      0.04 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.filename_setxattr.path_setxattrat
      0.03 ± 51%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.path_listxattrat.do_syscall_64
      0.02 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.path_removexattrat.__x64_sys_removexattr
      0.36 ±124%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_chdir
      0.03 ± 64%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_fchdir
      0.06 ± 56%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.user_statfs.__do_sys_statfs
      0.02 ± 75%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.08 ± 87%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.vfs_statx.vfs_fstatat
      0.15 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.scan_positives.dcache_readdir.iterate_dir
      0.05 ± 53%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.simple_unlink.simple_rmdir.vfs_rmdir
      0.05 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.simple_unlink.vfs_unlink.do_unlinkat
      0.30 ± 64%     -99.8%       0.00 ±223%  perf-sched.sch_delay.max.ms.__cond_resched.dput.step_into.link_path_walk.part
      0.03 ± 82%     -97.7%       0.00 ±223%  perf-sched.sch_delay.max.ms.__cond_resched.dput.step_into.open_last_lookups.path_openat
      0.12 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.step_into.path_lookupat.filename_lookup
      6.86 ±198%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.terminate_walk.path_lookupat.filename_lookup
      1.11 ±190%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_rename
      1.47 ±191%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_renameat
      0.01 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.exit_signals.do_exit.do_group_exit.__x64_sys_exit_group
      4.25 ±197%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_page_mkwrite.do_page_mkwrite.do_shared_fault.do_pte_missing
      0.03 ± 52%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_preadv
      0.01 ± 44%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_readv
      0.03 ±100%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.vfs_read.ksys_read.do_syscall_64
      0.01 ± 23%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.filemap_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.00 ± 19%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.flush_delayed_work.io_ring_ctx_wait_and_kill.io_uring_release.__fput
      0.13 ± 32%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.flush_work.__lru_add_drain_all.do_pages_move.kernel_move_pages
      0.02 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.60 ±127%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.11 ± 93%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.vfs_write.ksys_write
      0.07 ± 89%   +3944.3%       2.64 ± 62%  perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.10 ± 66%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
      0.13 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.d_alloc_parallel
      0.03 ± 48%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.lookup_one_qstr_excl
      0.10 ± 39%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc_cursor.dcache_dir_open
      0.02 ± 73%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.alloc_anon_inode.__anon_inode_getfile
      0.06 ± 69%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.create_pipe_files.do_pipe2
      0.11 ± 61%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.ramfs_get_inode
      0.07 ± 15%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.mqueue_alloc_inode.alloc_inode.new_inode
      0.05 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.sock_alloc_inode.alloc_inode.sock_alloc
      0.02 ± 94%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_node_noprof.alloc_vmap_area.__get_vm_area_node.__vmalloc_node_range_noprof
      0.02 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_node_noprof.dup_task_struct.copy_process.kernel_clone
      0.03 ± 96%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.12 ±129%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_clone.create_pipe_files
      0.07 ± 70%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.__anon_inode_getfile
      0.08 ± 96%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.create_pipe_files
      0.04 ± 55%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.sock_alloc_file
      0.12 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.dentry_open.do_mq_open
      3.15 ±189%    -100.0%       0.00 ±223%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.path_openat.do_filp_open
      0.03 ± 91%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_pid.copy_process.kernel_clone
      0.03 ±109%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.copy_fs_struct.copy_process.kernel_clone
      0.02 ± 54%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.copy_sighand.copy_process.kernel_clone
      0.07 ±146%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.do_timer_create.__x64_sys_timer_create.do_syscall_64
      0.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.dup_fd.copy_process.kernel_clone
      0.06 ± 97%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl
      0.03 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.ep_ptable_queue_proc.pipe_poll.ep_item_poll
      0.92 ±178%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.10 ± 30%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.key_alloc.__key_create_or_update.key_create_or_update
      0.04 ± 57%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      0.01 ± 98%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.01 ± 43%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.new_userfaultfd.__x64_sys_userfaultfd.do_syscall_64
      0.03 ±107%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__do_sys_capset.do_syscall_64
      0.01 ± 33%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__sys_setreuid.do_syscall_64
      2.80 ±195%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.sk_prot_alloc.sk_alloc.unix_create1
      2.21 ±179%    -100.0%       0.00 ±223%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      0.03 ± 91%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.02 ± 73%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.locks_lock_inode_wait.__do_sys_flock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.13 ±162%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mincore_pte_range.walk_pmd_range.isra.0
      0.70 ±167%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mlock_pte_range.walk_pmd_range.isra.0
      0.09 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mmput.getrusage.__do_sys_getrusage.do_syscall_64
      0.06 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mmput.process_vm_rw_core.constprop.0
      0.03 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_chmod.do_syscall_64
      0.01 ± 96%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmod.do_syscall_64
      0.04 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.06 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_chown.do_syscall_64
      0.03 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_fchownat.do_syscall_64
      0.02 ± 65%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.04 ± 23%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_rename.do_syscall_64
      0.11 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.05 ± 24%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.15 ± 57%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.02 ± 48%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.02 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_link
      0.03 ± 46%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_linkat
      0.08 ± 85%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdir
      0.04 ± 84%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdirat
      0.04 ± 40%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_mknodat.__x64_sys_mknodat
      0.03 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlink
      0.02 ±102%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlinkat
      0.04 ± 55%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.filename_setxattr.path_setxattrat.__x64_sys_setxattr
      0.07 ± 34%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.open_last_lookups.path_openat.do_filp_open
      0.03 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.path_removexattrat.__x64_sys_removexattr.do_syscall_64
      0.03 ± 68%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.vfs_truncate.__x64_sys_truncate.do_syscall_64
      0.17 ±149%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.vfs_utimes.do_utimes.__x64_sys_utimensat
      0.02 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.move_page_tables.move_vma.__do_sys_mremap.do_syscall_64
      0.09 ± 60%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.__key_instantiate_and_link.__key_create_or_update.key_create_or_update
      0.02 ± 98%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.bpf_prog_pack_alloc.bpf_jit_binary_pack_alloc.bpf_int_jit_compile
      0.05 ± 99%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.02 ± 52%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.btrfs_wait_ordered_roots.btrfs_sync_fs.iterate_supers
      0.04 ±105%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      0.03 ± 90%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.ep_clear_and_put.ep_eventpoll_release.__fput
      0.02 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.fdget_pos.__x64_sys_getdents.do_syscall_64
      0.02 ± 88%     -94.4%       0.00 ±223%  perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.fdget_pos.ksys_write.do_syscall_64
      0.02 ± 73%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.futex_exit_release.exit_mm_release.exit_mm
      0.02 ± 61%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.io_uring_del_tctx_node.io_tctx_exit_cb.task_work_run
      0.01 ± 80%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.pipe_double_lock.splice_pipe_to_pipe.do_splice
      0.04 ± 36%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.pipe_release.__fput.__x64_sys_close
      0.01 ± 13%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
      0.01 ± 42%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.srcu_gp_end.process_srcu.process_one_work
      0.54 ± 95%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.sync_bdevs.ksys_sync.__x64_sys_sync
      0.02 ± 83%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.vmsplice_to_pipe.__do_sys_vmsplice.do_syscall_64
      0.39 ±149%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc.bpf_prog_create_from_user
      0.04 ± 89%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc
      0.15 ± 37%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.07 ± 63%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.put_files_struct.do_exit.do_group_exit.__x64_sys_exit_group
      0.04 ± 64%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.__mmap_region.mmap_region
      0.02 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.01 ± 18%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.rhashtable_rehash_table.rht_deferred_worker.process_one_work.worker_thread
      0.07 ± 57%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_fault
      0.02 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.sk_setsockopt.do_sock_setsockopt.__sys_setsockopt.__x64_sys_setsockopt
      0.41 ±103%     -78.2%       0.09 ± 57%  perf-sched.sch_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     22.01 ± 56%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
     35.92 ± 34%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
      0.01 ± 68%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.switch_task_namespaces.do_exit.do_group_exit.__x64_sys_exit_group
      0.09 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.task_work_run.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
      0.12 ± 51%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.truncate_inode_pages_range.evict.do_unlinkat.__x64_sys_unlink
      0.02 ± 88%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.truncate_inode_pages_range.truncate_pagecache.simple_setattr.notify_change
      1.86 ±190%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.05 ± 48%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.userfaultfd_release_all.userfaultfd_release.__fput.__x64_sys_close
      0.03 ± 88%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.vfs_copy_file_range.__do_sys_copy_file_range.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ±119%     -93.6%       0.00 ±142%  perf-sched.sch_delay.max.ms.__cond_resched.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 96%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.vfs_writev.do_pwritev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ±117%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.vfs_writev.do_writev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ±112%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.wait_for_key_construction.__do_sys_request_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ± 88%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.wait_for_key_construction.lookup_user_key.__do_sys_add_key.do_syscall_64
      0.05 ± 77%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.wait_for_key_construction.lookup_user_key.keyctl_invalidate_key.do_syscall_64
      0.03 ± 34%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.02 ± 62%   +2804.8%       0.65 ± 48%  perf-sched.sch_delay.max.ms.__x64_sys_pause.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.75 ± 81%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.01 ±108%     -98.8%       0.00 ±223%  perf-sched.sch_delay.max.ms.d_alloc_parallel.__lookup_slow.walk_component.link_path_walk.part
     40.61 ± 13%     -99.1%       0.38 ± 40%  perf-sched.sch_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     33.67 ± 29%    -100.0%       0.00        perf-sched.sch_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      0.09 ± 76%    -100.0%       0.00        perf-sched.sch_delay.max.ms.do_nanosleep.hrtimer_nanosleep_restart.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.05 ± 52%     -98.5%       0.00 ±223%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.28 ±122%     -97.1%       0.01 ± 88%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
     25.58 ± 50%    -100.0%       0.00        perf-sched.sch_delay.max.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.32 ± 90%    +235.3%       1.07 ± 22%  perf-sched.sch_delay.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
     15.48 ± 27%     -90.1%       1.53 ±125%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.08 ± 53%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.bpf_prog_pack_alloc
      0.10 ± 44%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.pcpu_alloc_noprof
     24.22 ± 56%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
      0.19 ± 45%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__shm_close
     27.28 ± 58%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      0.32 ± 83%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_shmat
     10.07 ± 58%    +207.3%      30.93 ± 37%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.ipcget
      0.09 ± 71%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.msgctl_down
      0.19 ± 44%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.semctl_down
      0.38 ± 35%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.shmctl_down
     11.25 ±124%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
     31.55 ± 26%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
     10.55 ± 52%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
     22.17 ± 18%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
      3.89 ±123%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus
     42.89 ± 16%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
      1.31 ± 53%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
     32.82 ± 18%     -92.6%       2.44 ± 43%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     11.39 ±116%    -100.0%       0.00        perf-sched.sch_delay.max.ms.schedule_timeout.synchronize_rcu_expedited_wait_once.synchronize_rcu_expedited_wait.rcu_exp_wait_wake
      9.09 ±141%    -100.0%       0.00        perf-sched.sch_delay.max.ms.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
     32.61 ± 28%     -69.1%      10.06 ± 57%  perf-sched.sch_delay.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.04 ± 59%    -100.0%       0.00        perf-sched.sch_delay.max.ms.syscall_exit_to_user_mode.ret_from_fork_asm.[unknown]
      0.67 ± 79%    -100.0%       0.00        perf-sched.sch_delay.max.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
     63.32 ±101%     -94.5%       3.49 ±  3%  perf-sched.sch_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      4.60 ± 17%    +292.6%      18.06 ± 17%  perf-sched.total_wait_and_delay.average.ms
    918368 ± 17%     -80.0%     183280 ± 16%  perf-sched.total_wait_and_delay.count.ms
      4.59 ± 17%    +293.3%      18.04 ± 17%  perf-sched.total_wait_time.average.ms
     23.00 ±  6%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
     21.30 ± 68%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
      0.52 ± 73%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
      0.47 ± 67%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
      0.50 ± 48%    +1e+05%     520.10 ± 24%  perf-sched.wait_and_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.45 ± 53%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      0.11 ± 21%  +29326.9%      32.55        perf-sched.wait_and_delay.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.02 ± 38%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.96 ± 52%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
    278.08 ±  6%     -35.6%     178.95 ± 27%  perf-sched.wait_and_delay.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
     57.35 ± 22%    +193.1%     168.08 ± 33%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.21 ± 19%  +1.4e+05%     287.09 ±  3%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.18 ± 60%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
      0.19 ± 50%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      0.09 ± 88%    +605.9%       0.66 ± 18%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.ipcget
      0.77 ± 22%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
      1.73 ± 12%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
      8.37 ± 20%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
     20.53 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
      0.40 ± 47%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     33.20 ± 11%    +707.8%     268.18 ±  3%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.44 ± 63%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    246.99 ±112%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
     15.85 ± 21%   +4685.6%     758.73        perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      4.20 ± 46%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
      1.60 ± 50%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
    556.80 ± 41%     -99.6%       2.00 ± 95%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     15103 ± 29%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
     28517 ± 13%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
     92856 ± 27%    -100.0%       6.17 ±  6%  perf-sched.wait_and_delay.count.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
     29147 ± 26%    -100.0%       0.00        perf-sched.wait_and_delay.count.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
     37888 ± 20%     -99.7%     124.00        perf-sched.wait_and_delay.count.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
     36632 ± 20%    -100.0%       0.00        perf-sched.wait_and_delay.count.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     40846 ± 42%    -100.0%       0.00        perf-sched.wait_and_delay.count.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
    251.20 ±  4%     +63.7%     411.33 ± 30%  perf-sched.wait_and_delay.count.pipe_read.vfs_read.ksys_read.do_syscall_64
    238.60 ± 24%     -65.2%      83.00 ± 27%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
     61257 ± 17%    -100.0%      19.50 ±  2%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
     98909 ± 59%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
    114447 ± 52%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      5629 ±125%   +2917.2%     169848 ± 17%  perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.ipcget
     27769 ± 25%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
     24184 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
     35128 ± 27%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
    218.40 ±  7%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
     37607 ± 20%    -100.0%       0.00        perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     65055 ±  9%     -88.2%       7708 ±  4%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     44511 ± 41%    -100.0%       0.00        perf-sched.wait_and_delay.count.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    371.80 ± 39%    -100.0%       0.00        perf-sched.wait_and_delay.count.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
     75701 ± 25%     -98.4%       1203        perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     25.72 ±  4%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
     33.15 ±104%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
     25.86 ± 46%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
     52.74 ± 45%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
     34.21 ± 26%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      5.44 ± 33%  +18010.1%     985.77        perf-sched.wait_and_delay.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
    204.96 ±195%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     31.94 ± 25%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
     39.87 ± 42%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
     31.41 ± 42%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
    384.88 ±114%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
    801.23 ±131%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
    192.46 ±136%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
     44.97 ± 14%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
     38.53 ± 24%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      3096 ± 27%     -44.1%       1732 ± 15%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    728.66 ± 51%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1657 ± 96%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.31 ±187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.___kmalloc_large_node.__kmalloc_large_noprof.ksys_ioperm
      8.23 ±104%    +763.8%      71.11 ±120%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_mpol_noprof.shmem_alloc_folio
      0.24 ±136%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_noprof.__filemap_get_folio
     17.52 ± 86%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__alloc_pages_noprof.pcpu_alloc_pages.constprop.0
      0.34 ±113%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      1.19 ± 93%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__dentry_kill.dput.__do_sys_mq_unlink.do_syscall_64
      0.35 ± 81%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__dentry_kill.dput.__fput.__x64_sys_close
      0.54 ±189%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__dentry_kill.dput.do_renameat2.__x64_sys_renameat
      0.48 ±145%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__dentry_kill.dput.do_unlinkat.__x64_sys_unlink
      0.53 ±111%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      0.35 ± 95%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.20 ±171%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__get_user_pages.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.24 ±114%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.__do_sys_remap_file_pages
      0.24 ±110%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.do_mlock
      0.03 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.07 ±117%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node
      0.56 ±123%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.__do_sys_timerfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.11 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.16 ±162%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc.bpf_prog_create_from_user
      0.39 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_store_orig_filter.bpf_prog_create_from_user.seccomp_set_mode_filter
      0.65 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_epoll_create.__x64_sys_epoll_create.do_syscall_64
      0.21 ±175%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_eventfd.__x64_sys_eventfd2.do_syscall_64
      0.40 ±196%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_mq_timedsend.__x64_sys_mq_timedsend.do_syscall_64
      0.61 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.do_shmat.__x64_sys_shmat.do_syscall_64
      0.40 ±133%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.newque.ipcget.__x64_sys_msgget
      0.32 ± 77%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.percpu_ref_init.io_ring_ctx_alloc.io_uring_create
      0.03 ±  7%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.76 ±191%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_cache_noprof.seccomp_set_mode_filter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.54 ± 97%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.__do_sys_add_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.17 ± 76%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.52 ±190%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_getaffinity.do_syscall_64
      0.04 ± 48%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_setaffinity.do_syscall_64
      0.04 ± 28%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.alloc_fdtable.dup_fd.copy_process
      0.03 ± 55%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter
      0.48 ±129%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.bpf_jit_binary_pack_alloc.bpf_int_jit_compile.bpf_prog_select_runtime
      0.09 ±125%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.dup_user_cpus_ptr.dup_task_struct.copy_process
      0.04 ± 23%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.io_pages_map.io_allocate_scq_urings.io_uring_create
      0.28 ±174%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.io_ring_ctx_alloc.io_uring_create.io_uring_setup
      0.12 ±157%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_mq_timedsend.__x64_sys_mq_timedsend
      0.06 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      0.05 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64
      0.39 ±107%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_noprof.vmemdup_user.setxattr_copy.path_setxattrat
      0.55 ±189%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.kmemdup_noprof.bpf_prepare_filter.bpf_prog_create_from_user
      0.08 ± 82%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_add_key
      0.45 ±186%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_request_key
      0.36 ±149%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_noprof.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.21 ±118%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.51 ±110%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_noprof.user_preparse.__key_create_or_update.key_create_or_update
      0.69 ±164%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__put_anon_vma.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      0.32 ± 79%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.part
      0.27 ±118%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      0.51 ±188%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof.bpf_prog_alloc_no_stats
      0.22 ±179%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node.dup_task_struct
      1.72 ±  7%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      2.45 ± 60%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus.wait_rcu_exp_gp
      0.34 ± 77%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.apply_mlockall_flags.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.40 ±183%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.03 ± 22%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.cgroup_css_set_fork.cgroup_can_fork.copy_process.kernel_clone
      0.91 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.04 ± 63%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      1.43 ± 65%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.cpus_read_lock.static_key_slow_dec.io_ring_ctx_free.io_ring_exit_work
      0.29 ±155%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.03 ± 31%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.vfs_copy_file_range
      0.57 ±157%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.do_ftruncate.do_sys_ftruncate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.35 ±124%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.do_select.core_sys_select.do_pselect.constprop
      0.30 ±183%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.__key_create_or_update.key_create_or_update.__do_sys_add_key
      0.03 ± 44%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.__mm_populate.__do_sys_remap_file_pages.do_syscall_64
      0.67 ±132%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock
      0.18 ± 97%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock2
      0.26 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.open_last_lookups.path_openat.do_filp_open
      0.25 ± 87%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.super_lock.iterate_supers.ksys_sync
      0.24 ±172%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.51 ±121%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.51 ±122%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read_killable.__do_sys_kcmp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.29 ± 93%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read_killable.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      0.56 ± 74%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_read_killable.mm_access.process_vm_rw_core.constprop
      0.44 ±151%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.02 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.25 ±108%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__do_sys_pkey_alloc.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.49 ±188%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__key_link_lock.__key_create_or_update.key_create_or_update
      0.23 ±102%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      0.60 ±158%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.mmap_region
      0.27 ±186%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__sock_release.sock_close.__fput
      0.22 ±166%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.__x64_sys_pkey_free.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.27 ±173%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.46 ±114%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.chown_common.ksys_fchown.__x64_sys_fchown
      0.34 ±181%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.60 ±119%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_shmat.__x64_sys_shmat.do_syscall_64
      0.02 ± 42%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_truncate.do_ftruncate.do_sys_ftruncate
      0.57 ±123%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_truncate.vfs_truncate.__x64_sys_truncate
      0.43 ±104%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.48 ±121%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.47 ±186%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.27 ±171%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.generic_file_write_iter.vfs_write.ksys_write
      0.13 ±151%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.ipcget.__x64_sys_msgget.do_syscall_64
      0.80 ± 96%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.key_link.request_key_and_link.__do_sys_request_key
      0.16 ±152%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.madvise_vma_behavior.do_madvise.part
      0.28 ± 83%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.__x64_sys_munlock
      0.68 ± 67%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.do_mlock
      0.24 ±136%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.move_vma.__do_sys_mremap.do_syscall_64
      0.48 ±120%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect
      0.87 ±109%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.msgctl_down.ksys_msgctl.constprop
      0.67 ±129%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.semctl_down.ksys_semctl.constprop
      0.31 ±178%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.shmctl_down.ksys_shmctl.constprop
      0.48 ±157%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.unlink_file_vma_batch_final.free_pgtables.vms_clear_ptes
      0.32 ±159%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_link
      0.08 ±143%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_linkat
      0.60 ±111%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_rename
      0.23 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_renameat
      0.03 ± 44%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_setxattr.file_setxattr.path_setxattrat
      0.02 ±100%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_setxattr.filename_setxattr.path_setxattrat
      0.39 ± 98%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_unlink.__do_sys_mq_unlink.do_syscall_64
      0.40 ±106%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vfs_unlink.do_unlinkat.__x64_sys_unlink
      0.32 ±161%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vma_link_file.__mmap_new_vma.__mmap_region
      0.23 ±169%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.__mmap_prepare.__mmap_region
      0.49 ± 87%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.49 ±116%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.ksys_shmdt
      0.02 ± 66%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__do_sys_mlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.80 ±136%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.63 ±126%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__x64_sys_munlock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.13 ±163%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.do_madvise.part.0
      0.32 ±142%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.03 ± 34%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.do_shmat.__x64_sys_shmat.do_syscall_64
      0.61 ±192%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.ksys_shmdt.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.39 ±122%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.31 ±153%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.30 ±162%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.47 ± 55%     -96.2%       0.02 ± 54%  perf-sched.wait_time.avg.ms.__cond_resched.dput.__fput.__x64_sys_close.do_syscall_64
      0.52 ± 87%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.__fput.task_work_run.syscall_exit_to_user_mode
      0.57 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.dcache_readdir.iterate_dir.__x64_sys_getdents
      0.03 ± 15%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_linkat.__x64_sys_link.do_syscall_64
      0.21 ±169%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_linkat.__x64_sys_linkat.do_syscall_64
      0.32 ± 83%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdir.do_syscall_64
      0.21 ±107%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdirat.do_syscall_64
      0.20 ±120%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_mknodat.__x64_sys_mknodat.do_syscall_64
      0.10 ± 82%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.26 ± 54%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.11 ±103%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlink.do_syscall_64
      0.56 ± 63%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlinkat.do_syscall_64
      0.35 ±108%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.37 ±134%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.48 ±127%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.mqueue_unlink.vfs_unlink.__do_sys_mq_unlink
      0.33 ± 97%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.open_last_lookups.path_openat.do_filp_open
      0.37 ± 77%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.__x64_sys_chdir.do_syscall_64
      1.17 ± 88%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.__x64_sys_chmod.do_syscall_64
      0.74 ± 84%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.__x64_sys_fchmodat.do_syscall_64
      0.40 ±134%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.do_faccessat.do_syscall_64
      0.10 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.do_fchownat.__x64_sys_chown
      0.70 ±143%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.do_mq_open.__x64_sys_mq_open
      0.33 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.do_readlinkat.part
      0.17 ±170%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.do_utimes.__x64_sys_utimensat
      0.31 ± 99%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.filename_setxattr.path_setxattrat
      0.20 ±158%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.path_listxattrat.do_syscall_64
      0.12 ± 95%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.path_removexattrat.__x64_sys_removexattr
      0.53 ± 80%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_chdir
      0.91 ±117%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_fchdir
      0.23 ±102%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.user_statfs.__do_sys_statfs
      0.13 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.54 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.vfs_statx.vfs_fstatat
      0.51 ± 67%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.scan_positives.dcache_readdir.iterate_dir
      0.23 ±169%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.simple_unlink.simple_rmdir.vfs_rmdir
      0.32 ± 72%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.simple_unlink.vfs_unlink.do_unlinkat
      0.39 ± 77%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.step_into.link_path_walk.part
      0.66 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.step_into.open_last_lookups.path_openat
      0.37 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.step_into.path_lookupat.filename_lookup
      0.37 ± 52%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.terminate_walk.path_lookupat.filename_lookup
      0.32 ± 58%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      0.42 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_rename
      0.29 ±115%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_renameat
      0.87 ±118%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_page_mkwrite.do_page_mkwrite.do_shared_fault.do_pte_missing
      0.19 ±169%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_preadv
      0.03 ± 30%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_readv
      0.10 ±131%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.vfs_read.ksys_read.do_syscall_64
      0.38 ±160%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.filemap_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.04 ± 49%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.flush_delayed_work.io_ring_ctx_wait_and_kill.io_uring_release.__fput
      0.20 ± 22%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.flush_work.__lru_add_drain_all.do_pages_move.kernel_move_pages
      0.40 ±120%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.35 ± 45%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.42 ± 57%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.vfs_write.ksys_write
      0.32 ±106%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     22.99 ±  6%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
      0.35 ± 95%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.d_alloc_parallel
      0.55 ±105%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.lookup_one_qstr_excl
      0.38 ± 81%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc_cursor.dcache_dir_open
      0.37 ±150%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.alloc_anon_inode.__anon_inode_getfile
      0.27 ± 72%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.create_pipe_files.do_pipe2
      0.40 ± 82%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.ramfs_get_inode
      0.47 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.mqueue_alloc_inode.alloc_inode.new_inode
      0.23 ±100%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_lru_noprof.sock_alloc_inode.alloc_inode.sock_alloc
      0.18 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_node_noprof.alloc_vmap_area.__get_vm_area_node.__vmalloc_node_range_noprof
      0.04 ± 20%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_node_noprof.dup_task_struct.copy_process.kernel_clone
      0.11 ±152%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.52 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_clone.create_pipe_files
      0.40 ± 95%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.__anon_inode_getfile
      0.34 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.create_pipe_files
      0.30 ± 82%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.sock_alloc_file
      0.34 ± 65%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.dentry_open.do_mq_open
      0.38 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.path_openat.do_filp_open
      0.34 ±181%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_pid.copy_process.kernel_clone
      0.21 ± 71%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.copy_fs_struct.copy_process.kernel_clone
      0.28 ±103%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.copy_sighand.copy_process.kernel_clone
      0.20 ±110%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.do_timer_create.__x64_sys_timer_create.do_syscall_64
      0.14 ± 94%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.dup_fd.copy_process.kernel_clone
      0.58 ±172%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl
      0.64 ± 58%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.ep_ptable_queue_proc.pipe_poll.ep_item_poll
      0.34 ± 82%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.51 ± 81%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.key_alloc.__key_create_or_update.key_create_or_update
      0.21 ±168%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      0.51 ±190%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.60 ±191%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.new_userfaultfd.__x64_sys_userfaultfd.do_syscall_64
      0.51 ±122%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__do_sys_capset.do_syscall_64
      0.03 ± 66%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__sys_setreuid.do_syscall_64
      0.25 ±118%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.sk_prot_alloc.sk_alloc.unix_create1
      0.35 ± 93%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      0.58 ± 78%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      2.29 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.44 ±149%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.locks_lock_inode_wait.__do_sys_flock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.06 ±120%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mincore_pte_range.walk_pmd_range.isra.0
      0.47 ± 53%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mlock_pte_range.walk_pmd_range.isra.0
      0.39 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mmput.getrusage.__do_sys_getrusage.do_syscall_64
      0.45 ±103%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mmput.process_vm_rw_core.constprop.0
      0.24 ± 76%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_chmod.do_syscall_64
      0.04 ± 12%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmod.do_syscall_64
      0.50 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      0.45 ±102%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_chown.do_syscall_64
      0.26 ±175%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_fchownat.do_syscall_64
      0.47 ±121%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      0.41 ±100%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_rename.do_syscall_64
      0.29 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_renameat.do_syscall_64
      0.39 ±107%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.37 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      0.29 ± 96%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      0.41 ±160%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_link
      0.24 ± 86%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_linkat
      0.31 ± 85%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdir
      0.18 ±113%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdirat
      0.16 ±139%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_mknodat.__x64_sys_mknodat
      0.26 ±167%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlink
      0.42 ±126%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlinkat
      0.37 ±100%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.filename_setxattr.path_setxattrat.__x64_sys_setxattr
      0.55 ± 89%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.open_last_lookups.path_openat.do_filp_open
      0.51 ±115%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.path_removexattrat.__x64_sys_removexattr.do_syscall_64
      0.58 ± 81%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.vfs_truncate.__x64_sys_truncate.do_syscall_64
      0.50 ± 73%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.vfs_utimes.do_utimes.__x64_sys_utimensat
      0.12 ±160%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write_file.path_removexattrat.__x64_sys_fremovexattr.do_syscall_64
      0.11 ± 76%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.move_page_tables.move_vma.__do_sys_mremap.do_syscall_64
      0.31 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.__key_instantiate_and_link.__key_create_or_update.key_create_or_update
      0.07 ±122%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.bpf_prog_pack_alloc.bpf_jit_binary_pack_alloc.bpf_int_jit_compile
      0.45 ±118%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.02 ± 73%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.btrfs_wait_ordered_roots.btrfs_sync_fs.iterate_supers
      0.15 ± 84%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      0.03 ± 33%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.ep_clear_and_put.ep_eventpoll_release.__fput
      0.03 ± 30%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.fdget_pos.__x64_sys_getdents.do_syscall_64
      1.08 ±157%     -99.9%       0.00 ±223%  perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.fdget_pos.ksys_write.do_syscall_64
      0.87 ± 69%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.io_uring_del_tctx_node.io_tctx_exit_cb.task_work_run
      4.32 ± 33%    +745.8%      36.54 ± 76%  perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.perf_poll.do_poll.constprop
      0.34 ±167%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.pipe_double_lock.splice_pipe_to_pipe.do_splice
      0.32 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.pipe_release.__fput.__x64_sys_close
     21.29 ± 68%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
      2.59 ±180%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.srcu_gp_end.process_srcu.process_one_work
      0.38 ± 76%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.sync_bdevs.ksys_sync.__x64_sys_sync
      0.02 ± 52%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.vmsplice_to_pipe.__do_sys_vmsplice.do_syscall_64
      0.30 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc.bpf_prog_create_from_user
      0.27 ±112%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc
      3.20 ±  8%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.22 ± 81%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.__mmap_region.mmap_region
      0.41 ±123%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     34.17 ±107%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.rhashtable_rehash_table.rht_deferred_worker.process_one_work.worker_thread
      0.58 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_fault
      0.28 ±152%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.shrink_dcache_parent.vfs_rmdir.do_rmdir.__x64_sys_rmdir
      0.64 ±138%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.sk_setsockopt.do_sock_setsockopt.__sys_setsockopt.__x64_sys_setsockopt
      1.89 ± 40%    +181.0%       5.30 ± 20%  perf-sched.wait_time.avg.ms.__cond_resched.stop_one_cpu.migrate_task_to.task_numa_migrate.isra
      0.51 ± 75%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
      0.45 ± 71%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
      0.04 ± 62%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
      1.26 ± 35%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.task_work_run.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
      0.26 ± 65%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.truncate_inode_pages_range.evict.do_unlinkat.__x64_sys_unlink
      1.00 ± 66%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.truncate_inode_pages_range.truncate_pagecache.simple_setattr.notify_change
      0.28 ± 96%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.37 ± 72%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.userfaultfd_release_all.userfaultfd_release.__fput.__x64_sys_close
      0.19 ±107%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.vfs_copy_file_range.__do_sys_copy_file_range.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.79 ±141%     -99.8%       0.00 ±142%  perf-sched.wait_time.avg.ms.__cond_resched.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.33 ±182%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.vfs_writev.do_pwritev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 67%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.vfs_writev.do_writev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.34 ±184%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.wait_for_key_construction.__do_sys_request_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.62 ± 91%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.wait_for_key_construction.lookup_user_key.__do_sys_add_key.do_syscall_64
      0.42 ±135%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.wait_for_key_construction.lookup_user_key.keyctl_invalidate_key.do_syscall_64
      8.75 ±191%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.86 ± 45%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.49 ± 50%  +1.1e+05%     519.96 ± 24%  perf-sched.wait_time.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep.__x64_sys_clock_nanosleep
      0.44 ± 55%    -100.0%       0.00        perf-sched.wait_time.avg.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      0.03 ± 74%    -100.0%       0.00        perf-sched.wait_time.avg.ms.do_nanosleep.hrtimer_nanosleep_restart.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.11 ± 21%  +29326.9%      32.55        perf-sched.wait_time.avg.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      0.02 ± 46%   +1469.1%       0.28 ± 13%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.35 ± 79%    -100.0%       0.00        perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      0.69 ± 44%     -99.3%       0.00 ± 72%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
      1.33 ± 56%     -90.9%       0.12 ±218%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown].[unknown]
      1.40 ± 55%     -98.6%       0.02 ±103%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
      1.94 ± 53%    -100.0%       0.00        perf-sched.wait_time.avg.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
    278.07 ±  6%     -35.7%     178.92 ± 27%  perf-sched.wait_time.avg.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
     56.63 ± 23%    +196.5%     167.93 ± 33%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.do_poll.constprop.0.do_sys_poll
      0.21 ± 20%  +1.4e+05%     286.98 ±  3%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.41 ± 66%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.bpf_prog_pack_alloc
      0.34 ±117%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.pcpu_alloc_noprof
      0.17 ± 61%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
      0.18 ± 61%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__shm_close
      0.18 ± 52%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      0.17 ± 59%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_shmat
      0.22 ± 45%    +199.3%       0.65 ± 18%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.ipcget
      0.59 ± 66%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.msgctl_down
      0.27 ± 70%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.semctl_down
      0.17 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.shmctl_down
      0.22 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
      0.75 ± 22%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
      2.03 ± 16%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
      1.72 ± 12%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
      1.47 ± 56%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus
      8.34 ± 20%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
     20.50 ±  7%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
      0.38 ± 50%    +110.9%       0.81 ±  9%  perf-sched.wait_time.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      3.89 ±  5%     +16.1%       4.52        perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.31 ± 43%    -100.0%       0.00        perf-sched.wait_time.avg.ms.schedule_timeout.synchronize_rcu_expedited_wait_once.synchronize_rcu_expedited_wait.rcu_exp_wait_wake
     33.16 ± 11%    +708.6%     268.14 ±  3%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.21 ± 88%    -100.0%       0.00        perf-sched.wait_time.avg.ms.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
      0.43 ± 65%   +1346.5%       6.19 ± 38%  perf-sched.wait_time.avg.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    246.97 ±112%    -100.0%       0.00        perf-sched.wait_time.avg.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe
     15.83 ± 21%   +4692.8%     758.70        perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.91 ±192%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__alloc_pages_noprof.___kmalloc_large_node.__kmalloc_large_noprof.ksys_ioperm
      2.50 ±102%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__alloc_pages_noprof.alloc_pages_mpol_noprof.folio_alloc_noprof.__filemap_get_folio
     27.16 ±119%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__alloc_pages_noprof.pcpu_alloc_pages.constprop.0
      2.26 ±101%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page.__handle_mm_fault
      2.36 ± 93%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__dentry_kill.dput.__do_sys_mq_unlink.do_syscall_64
      4.52 ± 48%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__dentry_kill.dput.__fput.__x64_sys_close
      1.05 ±192%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__dentry_kill.dput.do_renameat2.__x64_sys_renameat
      1.74 ±119%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__dentry_kill.dput.do_unlinkat.__x64_sys_unlink
      4.92 ± 37%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      3.89 ± 53%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__fput.__x64_sys_close.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.41 ±173%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__get_user_pages.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      1.84 ±105%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.__do_sys_remap_file_pages
      1.93 ±118%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__get_user_pages.populate_vma_page_range.__mm_populate.do_mlock
      0.04 ± 46%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      0.19 ±150%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_node_noprof.__get_vm_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node
      2.03 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.__do_sys_timerfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.40 ±109%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      0.70 ±187%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc.bpf_prog_create_from_user
      8.57 ± 26%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.bpf_prog_store_orig_filter.bpf_prog_create_from_user.seccomp_set_mode_filter
      3.06 ± 72%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.do_epoll_create.__x64_sys_epoll_create.do_syscall_64
      0.40 ±180%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.do_eventfd.__x64_sys_eventfd2.do_syscall_64
      0.79 ±197%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.do_mq_timedsend.__x64_sys_mq_timedsend.do_syscall_64
      1.99 ±117%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.do_shmat.__x64_sys_shmat.do_syscall_64
      2.53 ± 89%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.newque.ipcget.__x64_sys_msgget
      5.09 ± 29%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.percpu_ref_init.io_ring_ctx_alloc.io_uring_create
      0.05 ± 10%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.perf_event_mmap_event.perf_event_mmap.__mmap_region
      0.78 ±187%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_cache_noprof.seccomp_set_mode_filter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.64 ± 94%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.__do_sys_add_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.21 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof
      1.02 ±191%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_getaffinity.do_syscall_64
      0.05 ± 63%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.alloc_cpumask_var_node.__x64_sys_sched_setaffinity.do_syscall_64
      0.05 ±  5%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.alloc_fdtable.dup_fd.copy_process
      0.03 ± 54%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter
      2.36 ±110%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.bpf_jit_binary_pack_alloc.bpf_int_jit_compile.bpf_prog_select_runtime
      0.53 ±178%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.dup_user_cpus_ptr.dup_task_struct.copy_process
      0.05 ±  3%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.io_pages_map.io_allocate_scq_urings.io_uring_create
      1.06 ±177%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.io_ring_ctx_alloc.io_uring_create.io_uring_setup
      0.33 ±175%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_mq_timedsend.__x64_sys_mq_timedsend
      0.11 ± 84%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.load_msg.do_msgsnd.do_syscall_64
      0.13 ±118%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.sched_setaffinity.__x64_sys_sched_setaffinity.do_syscall_64
      1.85 ±111%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_noprof.vmemdup_user.setxattr_copy.path_setxattrat
      1.07 ±194%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.kmemdup_noprof.bpf_prepare_filter.bpf_prog_create_from_user
      0.39 ±108%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_add_key
      0.89 ±191%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_node_track_caller_noprof.memdup_user.strndup_user.__do_sys_request_key
      1.42 ±151%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_noprof.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.84 ±109%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_noprof.alloc_pipe_info.create_pipe_files.do_pipe2
      2.49 ±111%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_noprof.user_preparse.__key_create_or_update.key_create_or_update
      1.58 ±143%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__put_anon_vma.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      2.67 ± 57%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_finish_mmu.vms_clear_ptes.part
      2.29 ± 82%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__tlb_batch_free_encoded_pages.tlb_flush_mmu.zap_pte_range.zap_pmd_range
      1.00 ±192%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.__vmalloc_node_noprof.bpf_prog_alloc_no_stats
      0.64 ±183%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__vmalloc_area_node.__vmalloc_node_range_noprof.alloc_thread_stack_node.dup_task_struct
    137.32 ± 91%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.__synchronize_srcu.part.0
      6.00 ± 34%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus.wait_rcu_exp_gp
      7.57 ± 26%     -86.5%       1.02 ± 54%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.wait_for_completion_state.kernel_clone.__x64_sys_vfork
      5.12 ± 18%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.apply_mlockall_flags.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.07 ±187%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.bpf_int_jit_compile.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.04 ± 19%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.cgroup_css_set_fork.cgroup_can_fork.copy_process.kernel_clone
      7.76 ± 85%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.08 ± 87%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      3.31 ± 67%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.cpus_read_lock.static_key_slow_dec.io_ring_ctx_free.io_ring_exit_work
      1.57 ±173%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.05 ± 10%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.direct_splice_actor.splice_direct_to_actor.do_splice_direct.vfs_copy_file_range
      1.16 ±155%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.do_ftruncate.do_sys_ftruncate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.16 ± 95%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.do_select.core_sys_select.do_pselect.constprop
      1.15 ±192%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.__key_create_or_update.key_create_or_update.__do_sys_add_key
      0.04 ± 29%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.__mm_populate.__do_sys_remap_file_pages.do_syscall_64
      2.39 ± 86%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock
      1.58 ±128%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.__mm_populate.do_mlock.__x64_sys_mlock2
      2.77 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.open_last_lookups.path_openat.do_filp_open
      2.11 ±105%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.super_lock.iterate_supers.ksys_sync
      0.89 ±188%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      1.60 ±123%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      1.86 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read_killable.__do_sys_kcmp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.48 ± 93%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read_killable.__gup_longterm_locked.pin_user_pages_remote.process_vm_rw_single_vec
      3.03 ± 61%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_read_killable.mm_access.process_vm_rw_core.constprop
      0.94 ±140%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      0.03 ± 72%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.29 ±139%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__do_sys_pkey_alloc.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.96 ±190%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__key_link_lock.__key_create_or_update.key_create_or_update
      2.02 ±107%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.do_mmap
      1.50 ±142%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__mmap_new_vma.__mmap_region.mmap_region
      0.91 ±195%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__sock_release.sock_close.__fput
      1.01 ±189%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.__x64_sys_pkey_free.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.27 ±173%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      1.31 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.chown_common.ksys_fchown.__x64_sys_fchown
      1.02 ±186%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      3.82 ±124%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.do_shmat.__x64_sys_shmat.do_syscall_64
      0.03 ± 53%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.do_truncate.do_ftruncate.do_sys_ftruncate
      1.12 ±123%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.do_truncate.vfs_truncate.__x64_sys_truncate
      1.84 ±106%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      1.11 ±116%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      0.93 ±187%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      0.27 ±171%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.generic_file_write_iter.vfs_write.ksys_write
      0.64 ±184%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.ipcget.__x64_sys_msgget.do_syscall_64
      3.63 ± 86%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.key_link.request_key_and_link.__do_sys_request_key
      1.01 ±186%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.madvise_vma_behavior.do_madvise.part
      2.46 ± 94%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.__x64_sys_munlock
      4.72 ± 67%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.mlock_fixup.apply_vma_lock_flags.do_mlock
      1.23 ±134%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.move_vma.__do_sys_mremap.do_syscall_64
      2.01 ±121%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.mprotect_fixup.do_mprotect_pkey.__x64_sys_mprotect
      2.51 ±105%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.msgctl_down.ksys_msgctl.constprop
      3.03 ±115%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.semctl_down.ksys_semctl.constprop
      0.90 ±188%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.shmctl_down.ksys_shmctl.constprop
      1.49 ±130%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.unlink_file_vma_batch_final.free_pgtables.vms_clear_ptes
      1.17 ±167%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_link
      0.24 ±178%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_link.do_linkat.__x64_sys_linkat
      2.81 ± 79%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_rename
      3.05 ± 65%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_rename.do_renameat2.__x64_sys_renameat
      0.03 ± 44%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_setxattr.file_setxattr.path_setxattrat
      0.02 ± 98%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_setxattr.filename_setxattr.path_setxattrat
      7.59 ± 14%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_unlink.__do_sys_mq_unlink.do_syscall_64
      3.25 ± 71%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vfs_unlink.do_unlinkat.__x64_sys_unlink
      1.97 ±156%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vma_link_file.__mmap_new_vma.__mmap_region
      1.02 ±186%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.__mmap_prepare.__mmap_region
      4.29 ± 66%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.40 ±140%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write.vms_gather_munmap_vmas.do_vmi_align_munmap.ksys_shmdt
      0.03 ± 67%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.__do_sys_mlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.98 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.__vm_munmap.__x64_sys_munmap.do_syscall_64
      2.06 ±118%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.__x64_sys_munlock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.36 ±180%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.__x64_sys_munlockall.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.04 ± 60%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.do_madvise.part.0
      1.18 ±160%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.07 ± 72%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.do_shmat.__x64_sys_shmat.do_syscall_64
      1.21 ±194%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.ksys_shmdt.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.69 ±125%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.32 ±141%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      1.38 ±139%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.__do_sys_mq_unlink.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.40 ± 29%     -99.4%       0.04 ±135%  perf-sched.wait_time.max.ms.__cond_resched.dput.__fput.__x64_sys_close.do_syscall_64
      2.80 ± 64%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.__fput.task_work_run.syscall_exit_to_user_mode
      3.20 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.dcache_readdir.iterate_dir.__x64_sys_getdents
      0.05 ± 10%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_linkat.__x64_sys_link.do_syscall_64
      0.94 ±190%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_linkat.__x64_sys_linkat.do_syscall_64
      3.19 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdir.do_syscall_64
      1.96 ±119%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_mkdirat.__x64_sys_mkdirat.do_syscall_64
      1.93 ± 95%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_mknodat.__x64_sys_mknodat.do_syscall_64
      0.91 ±111%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_renameat2.__x64_sys_renameat.do_syscall_64
      4.56 ± 52%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_rmdir.__x64_sys_rmdir.do_syscall_64
      0.86 ±140%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlink.do_syscall_64
      4.22 ± 36%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_symlinkat.__x64_sys_symlinkat.do_syscall_64
      4.71 ± 46%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlink.do_syscall_64
      2.67 ±127%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      2.78 ±102%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.mqueue_unlink.vfs_unlink.__do_sys_mq_unlink
      2.90 ± 71%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.open_last_lookups.path_openat.do_filp_open
      3.49 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.__x64_sys_chdir.do_syscall_64
      3.12 ± 86%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.__x64_sys_chmod.do_syscall_64
      3.11 ± 78%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.__x64_sys_fchmodat.do_syscall_64
      2.15 ± 95%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.do_faccessat.do_syscall_64
      0.46 ±177%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.do_fchownat.__x64_sys_chown
      2.05 ±117%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.do_mq_open.__x64_sys_mq_open
      4.71 ± 49%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.do_readlinkat.part
      1.08 ±189%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.do_utimes.__x64_sys_utimensat
      2.69 ± 94%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.filename_setxattr.path_setxattrat
      1.22 ±157%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.path_listxattrat.do_syscall_64
      0.87 ±122%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.path_removexattrat.__x64_sys_removexattr
      6.00 ± 49%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_chdir
      2.81 ±107%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.set_fs_pwd.__x64_sys_fchdir
      2.42 ± 91%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.user_statfs.__do_sys_statfs
      0.81 ±127%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      3.72 ± 54%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.vfs_statx.vfs_fstatat
      6.76 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.scan_positives.dcache_readdir.iterate_dir
      2.26 ±194%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.simple_unlink.simple_rmdir.vfs_rmdir
      3.87 ± 73%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.simple_unlink.vfs_unlink.do_unlinkat
      9.20 ± 13%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.step_into.link_path_walk.part
      4.57 ± 75%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.step_into.open_last_lookups.path_openat
      6.16 ± 37%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.step_into.path_lookupat.filename_lookup
      4.38 ± 60%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.terminate_walk.path_lookupat.filename_lookup
      4.26 ± 34%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      4.18 ± 56%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_rename
      2.67 ± 96%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.dput.vfs_rename.do_renameat2.__x64_sys_renameat
      7.47 ±131%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_page_mkwrite.do_page_mkwrite.do_shared_fault.do_pte_missing
      0.67 ±186%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_preadv
      0.04 ± 37%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_read.do_iter_readv_writev.vfs_readv.do_readv
      0.27 ±149%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_read.vfs_read.ksys_read.do_syscall_64
      1.26 ±144%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.filemap_splice_read.splice_direct_to_actor.do_splice_direct.do_sendfile
      0.04 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.flush_delayed_work.io_ring_ctx_wait_and_kill.io_uring_release.__fput
     19.53 ± 49%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.flush_work.__lru_add_drain_all.do_pages_move.kernel_move_pages
      2.03 ± 97%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.do_iter_readv_writev.vfs_writev
      7.20 ± 31%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.iter_file_splice_write.direct_splice_actor
      5.23 ± 44%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.vfs_write.ksys_write
      5.59 ± 52%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.get_random_bytes_user.__x64_sys_getrandom.do_syscall_64.entry_SYSCALL_64_after_hwframe
     25.69 ±  4%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.key_garbage_collector.process_one_work.worker_thread.kthread
      5.98 ± 32%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.d_alloc_parallel
      3.49 ±108%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc.lookup_one_qstr_excl
      4.54 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.__d_alloc.d_alloc_cursor.dcache_dir_open
      1.46 ±131%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.alloc_anon_inode.__anon_inode_getfile
      1.73 ± 94%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.create_pipe_files.do_pipe2
      5.27 ± 51%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.alloc_inode.new_inode.ramfs_get_inode
      4.73 ± 44%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.mqueue_alloc_inode.alloc_inode.new_inode
      2.07 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_lru_noprof.sock_alloc_inode.alloc_inode.sock_alloc
      0.62 ±156%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_node_noprof.alloc_vmap_area.__get_vm_area_node.__vmalloc_node_range_noprof
      0.05 ±  2%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_node_noprof.dup_task_struct.copy_process.kernel_clone
      0.22 ±148%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.__anon_vma_prepare.__vmf_anon_prepare.do_anonymous_page
      4.10 ± 70%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_clone.create_pipe_files
      4.41 ± 54%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.__anon_inode_getfile
      4.18 ± 58%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.create_pipe_files
      3.14 ± 75%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.alloc_file_pseudo.sock_alloc_file
      5.05 ± 33%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.dentry_open.do_mq_open
      5.97 ± 43%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_empty_file.path_openat.do_filp_open
      1.10 ±189%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.alloc_pid.copy_process.kernel_clone
      4.01 ± 93%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.copy_fs_struct.copy_process.kernel_clone
      1.77 ±153%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.copy_sighand.copy_process.kernel_clone
      1.55 ±134%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.do_timer_create.__x64_sys_timer_create.do_syscall_64
      0.75 ±144%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.dup_fd.copy_process.kernel_clone
      1.88 ±144%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.ep_insert.do_epoll_ctl.__x64_sys_epoll_ctl
      3.89 ± 51%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.ep_ptable_queue_proc.pipe_poll.ep_item_poll
      5.06 ± 31%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      7.05 ±101%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.key_alloc.__key_create_or_update.key_create_or_update
      0.98 ±189%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__mmap_new_vma
      1.00 ±193%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.61 ±185%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.new_userfaultfd.__x64_sys_userfaultfd.do_syscall_64
      1.79 ±133%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__do_sys_capset.do_syscall_64
      0.03 ± 58%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.prepare_creds.__sys_setreuid.do_syscall_64
      3.44 ±152%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.sk_prot_alloc.sk_alloc.unix_create1
      4.28 ± 66%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      2.98 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      8.06 ± 77%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      1.52 ±130%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.locks_lock_inode_wait.__do_sys_flock.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.15 ±132%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mincore_pte_range.walk_pmd_range.isra.0
      6.88 ± 38%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mlock_pte_range.walk_pmd_range.isra.0
      4.80 ± 25%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mmput.getrusage.__do_sys_getrusage.do_syscall_64
      4.56 ± 86%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mmput.process_vm_rw_core.constprop.0
      2.98 ± 82%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_chmod.do_syscall_64
      0.05 ± 14%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmod.do_syscall_64
      4.08 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.chmod_common.__x64_sys_fchmodat.do_syscall_64
      2.94 ± 79%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_chown.do_syscall_64
      1.00 ±189%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_fchownat.__x64_sys_fchownat.do_syscall_64
      2.40 ±123%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_mq_open.__x64_sys_mq_open.do_syscall_64
      3.41 ± 88%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_rename.do_syscall_64
      5.81 ± 50%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_renameat2.__x64_sys_renameat.do_syscall_64
      3.50 ±104%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_rmdir.__x64_sys_rmdir.do_syscall_64
      6.88 ± 42%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlink.do_syscall_64
      2.38 ± 99%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_unlinkat.__x64_sys_unlinkat.do_syscall_64
      1.86 ±122%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_link
      1.68 ±100%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_linkat.__x64_sys_linkat
      2.78 ± 80%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdir
      1.38 ±147%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_mkdirat.__x64_sys_mkdirat
      1.36 ±140%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_mknodat.__x64_sys_mknodat
      1.17 ±176%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlink
      2.26 ±142%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_create.do_symlinkat.__x64_sys_symlinkat
      2.82 ± 79%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.filename_setxattr.path_setxattrat.__x64_sys_setxattr
      6.30 ± 38%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.open_last_lookups.path_openat.do_filp_open
      3.33 ±135%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.path_removexattrat.__x64_sys_removexattr.do_syscall_64
      3.14 ± 70%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.vfs_truncate.__x64_sys_truncate.do_syscall_64
      5.90 ± 30%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.vfs_utimes.do_utimes.__x64_sys_utimensat
      0.12 ±149%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write_file.path_removexattrat.__x64_sys_fremovexattr.do_syscall_64
      1.37 ±122%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.move_page_tables.move_vma.__do_sys_mremap.do_syscall_64
      6.36 ± 23%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.__key_instantiate_and_link.__key_create_or_update.key_create_or_update
      0.16 ±141%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.bpf_prog_pack_alloc.bpf_jit_binary_pack_alloc.bpf_int_jit_compile
      2.00 ± 91%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.bpf_prog_select_runtime.bpf_prepare_filter.bpf_prog_create_from_user
      0.02 ± 72%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.btrfs_wait_ordered_roots.btrfs_sync_fs.iterate_supers
      1.21 ±117%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.do_epoll_ctl.__x64_sys_epoll_ctl.do_syscall_64
      0.05 ± 21%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.ep_clear_and_put.ep_eventpoll_release.__fput
      0.04 ± 28%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.fdget_pos.__x64_sys_getdents.do_syscall_64
      4.78 ±137%    -100.0%       0.00 ±223%  perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.fdget_pos.ksys_write.do_syscall_64
      2.84 ± 87%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.io_uring_del_tctx_node.io_tctx_exit_cb.task_work_run
      1.05 ±160%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.pipe_double_lock.splice_pipe_to_pipe.do_splice
      2.65 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.pipe_release.__fput.__x64_sys_close
     33.14 ±104%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.rht_deferred_worker.process_one_work.worker_thread
     15.16 ±184%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.srcu_gp_end.process_srcu.process_one_work
      6.88 ± 33%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.sync_bdevs.ksys_sync.__x64_sys_sync
      0.04 ± 45%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.vmsplice_to_pipe.__do_sys_vmsplice.do_syscall_64
      4.46 ± 48%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc.bpf_prog_create_from_user
      1.84 ±119%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.mutex_lock_killable.pcpu_alloc_noprof.bpf_prog_alloc_no_stats.bpf_prog_alloc
    252.57 ± 31%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      2.21 ±110%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.__mmap_region.mmap_region
      1.74 ±109%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     61.14 ±103%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.rhashtable_rehash_table.rht_deferred_worker.process_one_work.worker_thread
      4.25 ± 60%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_fault
      0.32 ±131%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.shrink_dcache_parent.vfs_rmdir.do_rmdir.__x64_sys_rmdir
      1.99 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.sk_setsockopt.do_sock_setsockopt.__sys_setsockopt.__x64_sys_setsockopt
     13.30 ± 14%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.super_lock.iterate_supers.__x64_sys_quotactl.do_syscall_64
     28.53 ± 35%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.super_lock.iterate_supers.ksys_sync.__x64_sys_sync
      0.06 ± 78%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
      6.60 ± 25%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.task_work_run.get_signal.arch_do_signal_or_restart.syscall_exit_to_user_mode
      6.98 ± 43%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.truncate_inode_pages_range.evict.do_unlinkat.__x64_sys_unlink
      4.28 ± 59%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.truncate_inode_pages_range.truncate_pagecache.simple_setattr.notify_change
      4.57 ± 49%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      5.31 ± 20%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.userfaultfd_release_all.userfaultfd_release.__fput.__x64_sys_close
      0.79 ±122%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.vfs_copy_file_range.__do_sys_copy_file_range.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.60 ±126%     -99.9%       0.00 ±142%  perf-sched.wait_time.max.ms.__cond_resched.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.96 ±186%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.vfs_writev.do_pwritev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.03 ± 68%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.vfs_writev.do_writev.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.84 ±187%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.wait_for_key_construction.__do_sys_request_key.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.22 ± 83%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.wait_for_key_construction.lookup_user_key.__do_sys_add_key.do_syscall_64
      2.56 ± 95%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.wait_for_key_construction.lookup_user_key.keyctl_invalidate_key.do_syscall_64
    202.33 ±197%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
     12.91 ± 26%    -100.0%       0.00        perf-sched.wait_time.max.ms.__x64_sys_sched_yield.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
     17.12 ± 25%    -100.0%       0.00        perf-sched.wait_time.max.ms.do_nanosleep.hrtimer_nanosleep.common_nsleep_timens.__x64_sys_clock_nanosleep
      2.31 ± 81%    -100.0%       0.00        perf-sched.wait_time.max.ms.do_nanosleep.hrtimer_nanosleep_restart.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.44 ± 33%  +18010.1%     985.77        perf-sched.wait_time.max.ms.do_task_dead.do_exit.do_group_exit.__x64_sys_exit_group.x64_sys_call
      4.00 ± 38%    -100.0%       0.00        perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_exc_page_fault.[unknown]
      5.53 ± 31%     -99.9%       0.01 ± 88%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown]
     11.93 ± 58%     -98.2%       0.22 ±220%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown].[unknown]
     25.57 ± 12%    -100.0%       0.00        perf-sched.wait_time.max.ms.kthread_worker_fn.kthread.ret_from_fork.ret_from_fork_asm
      3.42 ± 45%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.bpf_prog_pack_alloc
      4.38 ± 79%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.pcpu_alloc_noprof
     20.49 ± 39%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__do_sys_mq_unlink
      9.28 ± 12%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.__shm_close
     18.16 ± 25%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_mq_open
      8.69 ± 12%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_shmat
      5.38 ± 52%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.msgctl_down
      8.02 ± 28%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.semctl_down
     11.25 ± 11%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.shmctl_down
     14.62 ± 74%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.__flush_work.__lru_add_drain_all
    373.50 ±120%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.__flush_work.fsnotify_destroy_group
    931.18 ±163%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.__synchronize_srcu.part.0
    801.23 ±131%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.io_ring_exit_work.process_one_work
      9.09 ± 30%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.kthread_flush_work.sync_rcu_exp_select_cpus
    185.91 ±143%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_interruptible.io_ring_exit_work
     44.93 ± 14%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.__wait_rcu_gp
     19.44 ± 29%     -79.0%       4.08 ± 30%  perf-sched.wait_time.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
     21.49 ± 11%    -100.0%       0.00        perf-sched.wait_time.max.ms.schedule_timeout.synchronize_rcu_expedited_wait_once.synchronize_rcu_expedited_wait.rcu_exp_wait_wake
      3096 ± 27%     -44.1%       1732 ± 15%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     16.52 ± 44%    -100.0%       0.00        perf-sched.wait_time.max.ms.synchronize_rcu_expedited.lru_cache_disable.do_pages_move.kernel_move_pages
      1657 ± 97%    -100.0%       0.00        perf-sched.wait_time.max.ms.syslog_print.__x64_sys_syslog.do_syscall_64.entry_SYSCALL_64_after_hwframe




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


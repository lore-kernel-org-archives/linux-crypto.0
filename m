Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KhlsB9jE"
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBE1C4;
	Fri, 17 Nov 2023 01:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700213726; x=1731749726;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zuRhGvT5NXHfGKwAHC3HLx1DtKWq0rLp00pdMSs/QBE=;
  b=KhlsB9jEu3mK8dwVKIABwhVRmcevzo6GoO0jgaHUoxiHoqULoL6evqgg
   MrWQvj6asb0JMR3NlZ5JQw2uBIvuEMrDnYYXBqWhntHaXLN8j5C4nM1pj
   w0LFhtM7bHCMC3YYmJ+c5L4r5ld+8CmjYfkbO9lNrju4xmr3rk2kSjWsu
   FMaBp8NYnzna0FVEZdEEFknr1pQbO2ah4peSW9OA9Kd3sCiG6FBHbnbVn
   jl/cCgRdeAI+JcRh2pzc2e0wvwNwR1pgUnUXzcAkXBGzWl2frZXTTM/Mw
   7qM86gOYa+DAKT6Az+3eckVrG+bRcgGimidL8ijFe+wIz1f7wEcnVdR/S
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10896"; a="12814302"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="12814302"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 01:35:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="13864494"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Nov 2023 01:35:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 17 Nov 2023 01:35:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 17 Nov 2023 01:35:24 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 17 Nov 2023 01:35:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qe55dCObeXK5dsUFP4m5035kDYayYcR9Hbrucq1VhCKBs2eVv9F0zVIcjPEWAYhAmyA8gbh9NZ6OTc/GJC6HIdPUAtffIGRqC8qEjt+2fggabu7EwqNjMLsJQ5OJY02wnCehtDiR40qoWR2Jg2tJF08dOYfiGYbzI8N+5CyWUtRd/8qVZe/A78Hj7CulGK/0+e1cheaVsqQCEj5DLi7ChLmzMdZnR/fa7rowxQTNDAHvvJYSZTkjiJnB47J/9gONe4qssH3WVN4WyH+lHf2UnTcwHqvcCYdGl9GLRN6ah2yqEgWTd+FrFbK3DkoNS3x8XFDbg7+ZrUL9z3pbvmHuhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QCXIXpgwU7I84pVNXUA9tHFyrO+x7W+HRkZ6/Xx+wbI=;
 b=TwVkMrCsj84Ftz3rCqPGA5FZYxS3NEXHYauwyLc9Zrpy48oqAJC5HE+p46qPViFAKElMPY7252c1RV2IU4P669FK0hqgzPe/Yd0t+KOlyBk9cqE1WbwRaE/hZEzvJ7OtMhjp8/VYR7HLO+AncscZsMSQ0sl1KFDShZ7PJp+fpoCqZNZjv2yG5+0sMyfVErLt+YJNzZ9ekPJSIjgyfRDLIRSOiA6STvSq1Jn9N1GCkUQGD9riRUpwFXE0KOnsRnzo2mP67Rei/l5ONa2scNmlAtyrOHQotEckLPyI053/7MvbNF3PFb8L0BQ/qyASOR/p7irdgW2VuVmMGFCn3y9tBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CO6PR11MB5620.namprd11.prod.outlook.com (2603:10b6:303:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.18; Fri, 17 Nov
 2023 09:35:21 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8593:7da:ec34:29a3%5]) with mapi id 15.20.6933.025; Fri, 17 Nov 2023
 09:35:21 +0000
Date: Fri, 17 Nov 2023 09:35:15 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: Ciunas Bennett <ciunas.bennett@intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Adam
 Guerin" <adam.guerin@intel.com>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Damian Muszynski
	<damian.muszynski@intel.com>, Tom Zanussi <tom.zanussi@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>, Tero Kristo
	<tero.kristo@linux.intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - prevent underflow in rp2srv_store()
Message-ID: <ZVcz08m2mI9h6Qb0@gcabiddu-mobl1.ger.corp.intel.com>
References: <3fb31247-5f9c-4dba-a8b7-5d653c6509b6@moroto.mountain>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3fb31247-5f9c-4dba-a8b7-5d653c6509b6@moroto.mountain>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0340.eurprd04.prod.outlook.com
 (2603:10a6:10:2b4::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CO6PR11MB5620:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2a69a0-8f25-4b32-80b6-08dbe75084e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qVh0KqQuVZetsMOtjgWJk9zvQrMAKCevj5qbxZ30bIGzsJeSyjewxENZ4v5j+7kkJ8+5WlzzpSazP373K38UhJRswGND7ntr//NiBth7zLK4TmhUGpgdlfETafK/a9k2+kO3mGJI8SlrHLXMhqSoB6IUXYVlSmgHiG4di1Fa2JIQ2ac26DiZ/o2HFl0guS49xYCKjy6ykiyqtN50nadwORLWc7XQ+kvDA3Evg5zp2BwpDgrcY6bNu/qVemBZfOd3wEjqYGibOywKGPiFtQhS2pcNXsiz+3I04m2V6e3ZtQnc3cB+qip8dLSMz40S1t2KZdYwjsjNJeWbyS05XVI7jPY6XiEQ5hEaszitE2qmOD65StCv9e1/c7limZnTLiChYlz/DnXPi1lJQliq7cCPG+ZQ+Tl09c1gK3DlV5QiJzhQobIDEXz5VZzdd/6UNf/EwNQy07p2/chPS6pkX6N082cRCkYl/5DbvOLPPfDusUYUNQiCKQr3kX0a5I7Nt+E+DEyza948LKhrY3KMjw8GSpuF8ZoTGbQd0YQbrc6m8N7Ogp1LlTA/UIPqbn6+oNBu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6916009)(82960400001)(26005)(316002)(478600001)(36916002)(54906003)(66476007)(38100700002)(66556008)(66946007)(6506007)(6486002)(8936002)(8676002)(6666004)(6512007)(41300700001)(44832011)(2906002)(4326008)(5660300002)(86362001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AcVeKar4OZd12rAaxH9V/11RoDmtuJykz9mP012SzdnLW7ssBEIEraVc/mgh?=
 =?us-ascii?Q?vcXyBWrkVrVakj0zWO3ArE5rdj41ZG4BkTRh0jMPZTn7cgjadyWw84Qc5SpZ?=
 =?us-ascii?Q?Ii7QVBX4VaWFjGdIRta0mD5+aA5NVX0Iw67hYswsbVcAMth8lW+HqiHZRaPk?=
 =?us-ascii?Q?KOJE8VRepcpTn1f0gD65H++6gTIOw3tC7oBcLwQ3/bM2kdDVhpGLIvkP4NB0?=
 =?us-ascii?Q?WSHMXCS5AOuJg2Qhd2shgYXqMhcw/IRT9j6sIsjDuyr0Kl/9Yxfo0iTNXFvv?=
 =?us-ascii?Q?0zFx3/JLmKkKwce1acrAbdsv0f94ntZQTaknbwTkiS+tsKkxbPgKgiMmooDE?=
 =?us-ascii?Q?bQ2zsAqMIb7p2LVXBNFH6hV4RYJ8ha6cJLUh/RRZygn6jSHKpAfkEowVwOFT?=
 =?us-ascii?Q?wOSwHq4GKZYvAoCYQQJvccGHiDWj3ZkicUYrJnKMYIPQhAc7mZQJJ4ruMC00?=
 =?us-ascii?Q?8gHulv56s01gtZ3hJzqxyLKw6JEo4oHhDkmNW211ZIEJXiQTDOit/Cum0UM4?=
 =?us-ascii?Q?IM9YrTvVF0FJaC5SzX9bo3WBpudwoprYLNG6/HM1g4vk/V0fQ87hzyMFoK66?=
 =?us-ascii?Q?YCjZPy6NJ5LEjfSNDAOIPfke7sAyfCp2dqpGVLYByIJUgcX5IRLPeBPb0ki4?=
 =?us-ascii?Q?4PqlNDjk2kiRmnjkUGvanjVr3VcTmZSzBkseKqABjEbbiFLQuWYQSvzjt864?=
 =?us-ascii?Q?LYY8pyAIgRFSGUz0j4msTNVot4mAM1ZkZl5lq3aWEgV4P9eJKVaB3iTXCQB7?=
 =?us-ascii?Q?HdJUdwC4HLXJ9ayxb0ST0KVglYE4dgSaoUDXk+fBRRZSgY0Wd/+0wPeRYkKs?=
 =?us-ascii?Q?iMxSkp8bdVSYylTaG/f1DxwZZmk2joEGpco6K2wjVGeEBhwcKqh3lsn5t71q?=
 =?us-ascii?Q?HpKdHrx6ixV3BJMR5KRi+aHlLe2oLhceKXOIkosH0dRzHZkRYP0SKP1MuHOA?=
 =?us-ascii?Q?vWbGOCNZOhrt/XanUpZH+oEOVmBNila7GnjPlKGcGrgWwfiu2x1maNypqTb5?=
 =?us-ascii?Q?Kp74i4dSPe7SMb61XLGjTAdzAecWFX658MPsuMmHxO64l2X5222T1QePdKIm?=
 =?us-ascii?Q?vM15owOc0YLQ2lZjJWtjR4BqubQSNL/nhwqSAYq/DXrH/yiHsTYZtWcV1u1l?=
 =?us-ascii?Q?d4tqU1e715AqxUXmYnxUpNpoRgi/dBL7mRVBlyrs+nrJEIZQ3ixmoPN9l4yQ?=
 =?us-ascii?Q?YUBHoTcUCndfDSIrsQNiqFOncbRsAvOxDmCt2ydY/3lMLjKLqCEFfpBp1HQs?=
 =?us-ascii?Q?WDOsF0cq11QazEEFeCw9s6Wmkbfr5y2Zz05gU9P3BxAgA1l0XiQbsSBHvmBn?=
 =?us-ascii?Q?5Te9VvEQ+EbR3xXQCxEnsVbJwa2n4oZm1wLukyuofz+r5ICYucbyy+XEDTMu?=
 =?us-ascii?Q?hntac5k2Ma9EGB0844HaVoGlz3U6xkIuOD7sumsDTPM8CSxFrZ+Oin+4usdA?=
 =?us-ascii?Q?EGHBZ2G5e4TCwBgHznesSAQLdepR/G4oHaE/294xSpg7JCnx+TyzU6b+aNcs?=
 =?us-ascii?Q?lyu6S0dUB3xyZV6US5HqkpY7q7Aon9MBu+Pt4w3z8d4kLY5lYeCTkwKPY4HB?=
 =?us-ascii?Q?XtwYhG85DnPKcc0dwx3tMGpp0adAIi6WQ7Xpk6z4EJoxvyC+t1lsW4OBVeXj?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2a69a0-8f25-4b32-80b6-08dbe75084e6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2023 09:35:21.7957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvW1x4vAHXfTA92DdBRNiSRmoEx7FldVZv9P8EYNbf5LMI2mWzLctF9Daw3PX7yf7WUpz6CbfejH27PspjDhULbE8tXuN341Q2Ei7bsHk+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5620
X-OriginatorOrg: intel.com

On Tue, Oct 31, 2023 at 11:58:32AM +0300, Dan Carpenter wrote:
> The "ring" variable has an upper bounds check but nothing checks for
> negatives.  This code uses kstrtouint() already and it was obviously
> intended to be declared as unsigned int.  Make it so.
> 
> Fixes: dbc8876dd873 ("crypto: qat - add rp2svc sysfs attribute")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

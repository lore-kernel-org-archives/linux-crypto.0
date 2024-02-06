Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14A2579
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 14:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707230568; cv=fail; b=ou4zvEU3km8eQ+TO6Ee1D4RuUgnesTHFvP79mUAbLJSgTQJ5cW1xikciBMn8bAp3qu/38MaTVFzRiy22H+sMw7fGkT+MqhU7Vajk/QRBAjbZsbfZKQwcpJ+sa0wep/Z/4ya5MMlpJHukIk6xX5PEqmztcI8I/kNxC6yQDWBisi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707230568; c=relaxed/simple;
	bh=BhXIe4oSRWxTGwYhtQxCbWZ2ZkmmSI7tcSMTr/awtTo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d0HTnLWU56KpE4Ay1Rkq73pmUDNYPtohXVxokNsS1jmAiX50IUGrWOZDNpK5D9o3f9MuZwR7WW9Qn6m5+IseXed6b5ppiO3duPEeqC1gULbBC4cF6mRJYXxPS7gK6e9SGSCgA5XhvKrx4k4JeaaAnsgw5QA40BX+Z24+oCvMPE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DqAfnAXX; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DqAfnAXX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707230567; x=1738766567;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BhXIe4oSRWxTGwYhtQxCbWZ2ZkmmSI7tcSMTr/awtTo=;
  b=DqAfnAXXFcHXVFOHS/YgxupkbDuIX2++5OgwfrJ0HKXqmqw463mRLZMl
   f4DMWHjHPDrGqHpNUY6iGV+fwgRAjGoEoDxNrlHdQLfUoUJQ7sv7lSkuT
   ML5T7bpasGV36Qku/PS9Io0KtruQHLrTTfbqYMMzvziZhZFpUBvTbwQVx
   bWsLFZNLGVXOilUn0on0Ff3vv6hoV0qHOcBJl/gptpdZ38lLNNrS8QVBH
   uFds54lhYX6C9AwpaI333sBTr+F/UYz015UAocdYZ/kPoTgxHG5qLUKS7
   ypMXy+zKEQqMkCbosFYgRbr1g1lsn8MJ9/tRh8YgQrBTYCVfy/fYsjqNZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="900179"
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="900179"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 06:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,247,1701158400"; 
   d="scan'208";a="5635804"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 06:42:46 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 06:42:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 06:42:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 06:42:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pqcpoizj+TBdRHLjmioHACSRQ0FoY2I/xSEUHy47lIO7Ml8ol2fAOed+BDkiaR8OYT3Ptdvfy+hcUHwCuXhSMSmamIV5cAwcfrj8ZbCpbbEXxM6siTWfO8Co/V+4xi3StDIC8J2NUuzSsOosrzMXQd2esrhwujnSQsHk9sOW0WsbogdDIciBGld3cNs+NKObZXzZayehEjtgSuCF+tcGQAlzuuWq/AL0zgeJuL5l8zv0Zoq+U6qY57wCBKkvyBi4VyRM++Fu9MbCyn3+mWv81DWgREfGt7RCWWygFLZ0RNrWQN7CS3fGRJAjf6XxUfI3Hta9R0EfT4Phmxpv0XYyHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mNuoiRLo4lguR/bZiED4GA9Ln5kjCSZLGxaGQ6pqQ4=;
 b=fK60c175E7i/OelagydRN7BV49ILIXVvmS3dmKvLLY3my7fGpRe/+QbVtGZMGDdhtfNctvHa4J1qnsQUZl2ngH24wy92GnjOLOgAo0vdmT2W3kQ/7gf66Zkd/lSAwswD+/MYqQOuYem3Oy3kGETbIK5CeqFynu9S5SEHfd9dVrcq6dEdbwZYgat+F+etYNvPCwK6q5mfnkOQgztUfPvz2vNFYAgKjz2Eji4HcryGj0hwB31oIupTBP7pbANlCxJErVMcVhmkV+ZwHrQSjrIboilr/zx6ZY7xtN9sBx1o0DcWUxDs8mCFnOpzRygSNw2037B/BDgqJVHcTqjiIDrSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 14:42:42 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::1819:577e:aefc:d65d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::1819:577e:aefc:d65d%4]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 14:42:42 +0000
Date: Tue, 6 Feb 2024 14:42:38 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
Subject: Re: Failed self-test on ffdhe6144(qat-dh)
Message-ID: <ZcJFXtTZXKng7hKv@gcabiddu-mobl.ger.corp.intel.com>
References: <ZcC/C/kpcKaoVPp4@gondor.apana.org.au>
 <ZcDwxipP+CR8LBE8@gcabiddu-mobl.ger.corp.intel.com>
 <ZcHAlLdWfMhcACn5@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZcHAlLdWfMhcACn5@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:10:110::20) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 01fdfb77-33a6-445e-d4e5-08dc2721dfd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztYi7xh5nINHR4gRmdiyrpUBiYGG0X8PFksRntoaWfz/IklyNUgqiAUYYockMUalE7J7Uz5KySBhMK7cnVU40dhYTQAuRPHPPMQl/jB7guLNNeJeQ9uOPtu1XULUN8gmA1rLERDrj2W+3+tb7KkSqZkMX6onTMsOBvv9+iiBKHYir4SkxQSP3kWOak2ThQkOyBW8Nrkxgh/zG3v7Ix4NoNMCWWLHfRs0W5+D8beBrTlWh4EQPLTSDSFP4YWkwmgQPkIL0PtOXvrQvhcYaSlwOMyHwfT0kOUw1jvMdHO0Qy9FmRsB+Qu25yuS/rs0QVIxN2YHJuTzUhucoS+Hkjyj90hXiKp/4ehRC1RNEi8WR548QvjItVNBk5WpkXwYDjxkTvAWary9NVX+dnepK/emCpinJv0BJwLa7ufHS0ry6jD9/efKBkL6CdV2KwGP5MqwbRDcwcMn8RlT/Yf2I+ytcBUA4KLOGjP+xCUWngVc05xHuyZROyTW4F+EYgzaES4lOSOSzCUZ4LW7OPxyyH3jjdgtaunToO57burP7wuyKUA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(136003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(38100700002)(82960400001)(6506007)(36916002)(6666004)(83380400001)(86362001)(26005)(41300700001)(6512007)(4326008)(8676002)(8936002)(2906002)(478600001)(6486002)(966005)(5660300002)(66946007)(66556008)(66476007)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W0Ty8EacPxovHjRHFDfkqjPb5pEmaslcQEY52OEHt4Bmm/7HMQ2F7h3Vjbm8?=
 =?us-ascii?Q?dHoz5Q2INkmNuAWMfgGhoM0DhjTX/8dLT/zkp9CZSGdsGiha87lfx2719yQL?=
 =?us-ascii?Q?1HaYrFJGZSlD+pRFryFnMpgVN5ruyvJvWUlUaLi+Nno0uPojwF/iVHryrmTp?=
 =?us-ascii?Q?VTNXlU5Sy3Q4iMi044vwCxmtfYmphbnoEeXtTmO1bRsfrRygapcrMuLHzl2z?=
 =?us-ascii?Q?rnHoQ4VKgdpiMgeWd/JcVPp0mZxEtIV4fLvI/RDjPd/Xbx2BaMQJ9EaxyvBa?=
 =?us-ascii?Q?h7q62hsGMfHaRvAFmiJhGx4zJXAug/yWIxLlFhfHwnpSOi1Owsyl0IJiVoqj?=
 =?us-ascii?Q?tbBnyAPdVUxLmWiIjdn3EXdkbx+Cdr7slbobLOD0wWz/iTCnbPEEJvM7jr2g?=
 =?us-ascii?Q?XEPuV0SiZeUBglbTTN5gzHSbvboOYGR0CP3tVBLQd80Dcb2VIYxYTbcQkdrT?=
 =?us-ascii?Q?uHzMlQJ5chWDu7AziIGDjrifYLt2fcNwNKrgFjosTapAF72De0KrPV0woyc0?=
 =?us-ascii?Q?2V/6iLvxbc6sn9Rfnb2Y0rWKXdB6MYMLZg51rxie7D0KKBKVc/Amp4goo6T0?=
 =?us-ascii?Q?js+wvmKtVosbtbZ7ZkHijnQ1ezX2RFAdXCaCtz0OJj6hY818pDSZrJ0UaM+n?=
 =?us-ascii?Q?9Z50OKvR+ASDzGBZI0Wu/tK76ruO2LGDzolBc0ERrQdoIqjQIxaoglKCXQmP?=
 =?us-ascii?Q?sulO+djFx71R+Y8dzb9fSIf6RsrgofitW4jmZzsewfL1yvP4WqP/q3ClMYHU?=
 =?us-ascii?Q?KXn65o3eIo5HXm4/PJCvGtqxhlyz66Xzuf+GwOv+JWuSRq1u6fvLpqhQqEp8?=
 =?us-ascii?Q?Z44PYoZT7INB0Pqdh3v3ZrngP4a6CGCwIh4Bb+nestx58yhFLYeMnRFCMVQI?=
 =?us-ascii?Q?Jk3MfHjos0kj23z97I5vfziSfp8bqx2MXbjpI4EwcLiQGixo5ulAIkWLMIUK?=
 =?us-ascii?Q?5LEPrulixatkW6UhKyotMTzZGH90/IWEvFDSfkVyTt3xrTvAAb3c5zaLGQCe?=
 =?us-ascii?Q?o5aXnp2Br8zxyI3xueRNfh1rw9AAEKhxsAUbh5rL4buV3DPI/dcD/VSwJasN?=
 =?us-ascii?Q?3wMkNMixAfj7pW2uGnqKp2fNN67gtqpsoFwh4HE/K5LB3VUsoYtd3gdCO0/3?=
 =?us-ascii?Q?bbgI9Lj5uAE0qgpOSB0o6RSFNiv+LrWjg6Jaix8vdnzRTe/qkJtmVOPPdiXZ?=
 =?us-ascii?Q?apLiqczJT8HXLr8TlNTGtWDZKPAZjEkWYPbU7Jf/cqGdVQ/LY4yeNL3nRUcN?=
 =?us-ascii?Q?wR/kdX08Xv78uk9nzOFnNzoE8ej6hlLajTCEKFPoyD8Ps2L+6r5JXPJlG5uM?=
 =?us-ascii?Q?AC2AwbavkXwi/bmeHGci0VCH0EzbLCSzNf0WgD2pqcArI8P4pCXEWKFgk+tH?=
 =?us-ascii?Q?vgmL4GIWj43UW81OsEIxkKbyRIUHX68ctCa19b/wiyZOQHvvXazJc6YJapma?=
 =?us-ascii?Q?muEmyZAqeceX7uzvZnOu8EiqFD6W/sJlpPlKKkC7RGchD9gPlr8MIc3V6lVw?=
 =?us-ascii?Q?imbf3WXa+dthVIjQ56001S23FyD1SQ5OG7F73jOBAbxtciiY3YKXsJPyGB61?=
 =?us-ascii?Q?XwzppFYLje63PH//6iC1+Iv1tBXLv1eH7qewhaQ4yz6Gnj8zCtcDh91TWIoP?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fdfb77-33a6-445e-d4e5-08dc2721dfd6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 14:42:42.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGAt+rewM8z7nkPtFKNGQ6/5IYlBUcUm3i732uM50lwmLs35kD0hC+EBtDSy6a513qLgIGODcRDEspcK2stlDhvhbZiQEWP8ApE+4VEsCPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com

On Tue, Feb 06, 2024 at 01:16:04PM +0800, Herbert Xu wrote:
> On Mon, Feb 05, 2024 at 02:29:26PM +0000, Cabiddu, Giovanni wrote:
> >
> > Thanks for the bug report.
> > I'm looking at it. It appears that even if I have
> > CONFIG_CRYPTO_DH_RFC7919_GROUPS=y, ffdhe is not getting registered.
> > I'm trying to understand what's going wrong.
> > 
> > BTW, do you have more details, like platform and kernel version?
> 
> This algorithm requires instantiation, so try:
> 
> modprobe tcrypt alg="ffdhe6144(dh)" type=8 mode=0 mask=15
Thanks Herbert. I can reproduce the issue.

6144-bit DH is not supported by QAT. The error code -22 (-EINVAL) is
returned by qat_dh_check_params_length() when validating the modulus
size [1].
The same is applicable to 8192-DH.

I believe the only option I have is to fallback to SW.

BTW, since ffdhe requires instantiation, I think we should extend the dh
test vectors so that they can find these issues with unsupported key
sizes. We can make those tests optional to
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
What do you think?

[1] https://elixir.bootlin.com/linux/v6.8-rc3/source/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c#L384

Thanks,

-- 
Giovanni

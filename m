Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DBA1482E5
	for <linux-crypto@vger.kernel.org>; Mon, 16 Sep 2024 09:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726479786; cv=fail; b=V7QePrPSmJZpwrB7IP1WHt1cNTAXFQaoubdyKzdsQxGkBtL4b/dgB7ZW6OqH9fZVLEtry0PJp6pcOXRNXhUd6rMrds8t8LJfeeuM5+4+nX12VfLmLk2Ie018PYv+Q/ODEqf8VkOFE0a0O+98wplLao0fWDiqwiycfuhPeXNspjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726479786; c=relaxed/simple;
	bh=8yeS3So7Iolbdt5eaNLzwONBISt0fLQZ+wuiCXiVcEU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S2sE9QAU/x6qQ2SU/oxdQT7nCROZRvUOoWgTgDzdcXlPvzOtymBqo839oIemExaaK48ZVSeHhCbAbJqjP5rpHslcrHl2ndLq3/9G6NlfHmw9IBgFXX/nFY2xQ79R+SliyW6fMiK16VdwDP4Iokc04ATdsQl7ZV5xZ8Uw2bCF/64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cOa14490; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cOa14490"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726479785; x=1758015785;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8yeS3So7Iolbdt5eaNLzwONBISt0fLQZ+wuiCXiVcEU=;
  b=cOa14490FYaW0ErizTTdri/ey9HBNYrnRbJPkTVUgpTkEBVfwzW/wI9t
   KYE3RaqhdktkH/ZkzFUyZCjOi9z82QVZ8G99EA6ahnDb/RbJDcdQRBqVB
   KjIKkfFOYpmj8rFHfnGainy3rbpKpkg3EdwADcbm7VH7xF0Zu5ZWleFiz
   dOM0MwhN/G6OAhRqaB9l5hfFBsQ+d/w4AcYrlYQgQWZ05+1AiVNcGxVz7
   o+Wm6+6o+G7t5H+tFH8lec+iMkMyC/cwaJ1RWhjqsj5PLsqrfbd3ddBnH
   sfnMbjtGOLm+RwGPUJ+UACqkIdEIsV8jABOgFotZQttMl9daIuZLHEJxn
   Q==;
X-CSE-ConnectionGUID: X/bfCdDcTD2gmw3/nWYscw==
X-CSE-MsgGUID: 7M1Dq3mNR/muUKAgTGsbJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11196"; a="36432434"
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="36432434"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 02:43:03 -0700
X-CSE-ConnectionGUID: 4T5g1K2kRmm7npiDKg0rpA==
X-CSE-MsgGUID: V0NdnE1mRweeJeNLyYH8Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,233,1719903600"; 
   d="scan'208";a="68512086"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Sep 2024 02:43:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 02:43:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 16 Sep 2024 02:43:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 16 Sep 2024 02:43:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 16 Sep 2024 02:43:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tXIihkDABhfey/Xi1vsIAXq6MrNRZh7stG9dfnZ1lSb72wXslSJPa2hUGXw7XS8JcYr4aXI7xntxX3FjtUL5dIkROvwTLOYLPddesB4zeJh3r7ZCdNQfHsPYmvxk/Go0Fz5GdRC2bjYfld1VkKNFCQmEUaQ7GxA16H9F7451zEgv0wlTtQo7shFMlcJA0/gwi9M+mpXCfADCJPfERq94sw+QbR1R7F1KDcyVx95kEIi2foYv4zBcA1m6ojDypxRXkSHl8nD4JoPxpu0o9Gk7hW3lfmqovstm/Hlhd81skIM5bI8OLwxzN7tOXQZlJmD/uJRpMB7Z/V4vM/OeK/quOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIGnMOY4xSFZS73ktWDdRoFCD85qVEI82Sh4JdKhEok=;
 b=rBzUSP2E0Cq3BCKTRgvW/GSd6Lfn1YzH/A2AGcJ0ycXqcNJ8hh52oLf9+Hlp8xdMkWnqmF+yUaKVSHffiIf6Mtt3z7e9/iW2Kep4nUq+xwBZGqdqmE3xx7702EggTvALaGRuw8nqffQzgYNcBH5FdlNqOxnt2YKsLYsDHDGtGjc+1tKPdO/8vnXI7MsjjZhJMQ7tZUnuKJx8xq1rw3jdpQsTh4BCy1utL7Y8bE2rEmdY3RXZESdYgPZo2bIYsiA4uDkwuB54Mv9mMNMNVAz5yaBGGZoDTOu0PhJMo5kuj0sO9C9KRsDx5EqPWl4eJ4W0+z3o1Z43eTa2uVveqy+9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Mon, 16 Sep
 2024 09:42:59 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 09:42:59 +0000
Date: Mon, 16 Sep 2024 10:42:51 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <lucas.segarra.fernandez@intel.com>,
	<damian.muszynski@intel.com>, Li Zetao <lizetao1@huawei.com>,
	<davem@davemloft.net>
Subject: [PATCH] crypto: qat - remove check after debugfs_create_dir()
Message-ID: <Zuf9m8HgYbXp3yIJ@gcabiddu-mobl.ger.corp.intel.com>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
 <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
 <2024091452-freight-irritant-f160@gregkh>
 <ZuV2L2WQXSEgcsy6@gondor.apana.org.au>
 <2024091453-champion-driveway-f9fe@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2024091453-champion-driveway-f9fe@gregkh>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: WA2P291CA0003.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::7) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MN2PR11MB4677:EE_
X-MS-Office365-Filtering-Correlation-Id: f6090995-bea5-4622-999b-08dcd633f382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?0fVOEIjBdW6sMRA3VaVWFCv/wgdIJNxff8MjMBiVpYsqk0RkKOhIrXV626EF?=
 =?us-ascii?Q?26S5Lisj3X88kVdMmyuvAmaeIeFKCjujjiCdiTAmcpVPmbkZzUDQi6s7A+MS?=
 =?us-ascii?Q?lwfLpJ5k5BcbMnb/bdRyusMS9cgP24jC+3BzO23RuOhdKFjW+nIfitM4Sljm?=
 =?us-ascii?Q?8XzFuJi0Sk45t/t8oSUOzvZCTSIewnHfFKmnELojYKdSa1skZs/Oh3mqVJS2?=
 =?us-ascii?Q?q5KYPJ0ZnW6xe13K7G062UU+VQjCNzLJo6+AXP+aCl922Zt8PWLKaSN1U+TK?=
 =?us-ascii?Q?pUWICiVw5ACpZIAPLFEa81PIt9XZOyyufH0q5TkNzMVEGrI0eKOYZG5XM/wF?=
 =?us-ascii?Q?QF1LvDIrRSQ98G73oU9YdPtnP2vAwBin3BxT/OC2FMAsQwRKkZBY4ROggYJ5?=
 =?us-ascii?Q?GJYcaXDPfXW81GRxDagpmA+/6gyGPXdt1ms9eoaybCznNYM2hnlDs+AJK+6g?=
 =?us-ascii?Q?wnxNsG2HRZ8PWX8HGOasdtAECF4ImaN/Ua3Xm3hw0GmokELgUpVeU6e6DoyH?=
 =?us-ascii?Q?JV7b+qzHAEfHvrhV1dBanFMI6yTcDm25zS/7oIvKULuYaWW2RJEbztm7d42/?=
 =?us-ascii?Q?S14p/dqGEWajlksm1n4liAWjsQ/hqf4nzqA0eHGrvomOFfG1knbHFA7AgnKX?=
 =?us-ascii?Q?cZFpqbbfIXaIvfT+3WyE97JETg4ctkSYHFmmBIji6ax5ruoWrjAPkoohZHph?=
 =?us-ascii?Q?BNaaRcMZRTvoQWrNju0+7EsRZ/NVeaWsCY6Z7ghJDoR3qLTdTVYsbeouPI17?=
 =?us-ascii?Q?tUHYiHGpZcOfJc4qBMaksxjn30BPelDar97Kzhi8MaUVi2uuqfkIakTLlncu?=
 =?us-ascii?Q?tPJaBXKumMuykuoAQ2U1X2/5TKFESIEesiNPK2VS3uHqxgFEiTSnHegPvarF?=
 =?us-ascii?Q?t7KJsR7JxRov5zMiSVfVSjdBJAWa4QiZzLsq+McbhsHESnRYDCur13FtG9zl?=
 =?us-ascii?Q?j4M73ZogMkAsgC7TPZKQ9QTrglRC+U9G1larvCuGcDJmqiY+PJb5BEeufeqj?=
 =?us-ascii?Q?0limrGTaSuKRKiNHz3BbpBOkho576Lly+CBMsYeCoqcbR2aPXv2keaJ3hpNz?=
 =?us-ascii?Q?idNdmTZdKj4tUmsqSaCgDVlbij4Fvdy7zEsBEZB8ohXEI3WWI17lYHGxmkPh?=
 =?us-ascii?Q?iwFh3I4Z+0SRFYrfZgPwk/1k+Jbf3e/OI5VOKrpYIAig4V8lQSjHlks3ng1d?=
 =?us-ascii?Q?c1KcqHMnobDDL0zidCjMaY+M9YsbLBnIbdqmaXm5suHKZd1eumDumJsm5ReU?=
 =?us-ascii?Q?LF6x7/WdMqCJBaf+mDyfg3C5JnCRKM/Zreh89mNTRg2ZMdpfBFAHtNfgUzT0?=
 =?us-ascii?Q?0MKchXkUm12Hgscjd7ApSp0+3PEgkEF1udueKDY2vIsCIA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wYmJeW/hhVuQ32tQELdoQme6UwF7G45XtNUIMJFZY8SpN73VB+Kvv3DqtR9o?=
 =?us-ascii?Q?vaXTRVYno8v+VfbFgzBOZj2cOL1vl0xQjh8v4SDyx8USLzhYXBnadZ8JpO2v?=
 =?us-ascii?Q?0tdmWr1r7R6w+10lhnhXM0cSqNNGJkU0bgvTk94EWp3+NA9JDvik05d1BFOA?=
 =?us-ascii?Q?+MLVn2z3a6UJkJ2t1ZLs8cT2M30qne5WP1fdPWGYj8jjcSXPvAEJZ55DaCFl?=
 =?us-ascii?Q?vEybKKanUQNM0AMBVQVW3NgV6ikdLvqX2gFE3vEw8voyeT+oYN3EoBs//ffg?=
 =?us-ascii?Q?qjynkWLEX2HcDpAyHnmZiRDJAeIDe22rv7JpWcfDr1zUUkoiNvI73y3H3fSA?=
 =?us-ascii?Q?FR3Kb0UrrIHvdFqzhR4vJ/Od6Wnoq2tCTqjdhuQWaIZioF7xQsuDURJH/Phx?=
 =?us-ascii?Q?/enKQfJ4tsDLqMQs/SYLpDUnMEQfHRcW3mxpOjdum+jI7WC67CfeFCjtXV1g?=
 =?us-ascii?Q?S98iVjDQ4fKds4OSjp4W/yAmSBKqfgXlg2LGw+UAO+kyvKw/JQU3s2uxcMpQ?=
 =?us-ascii?Q?iIK2Je7wGwch8+whcapKNORl3/sAEhRfNhllSlzur6exI+N/WbJwmD9YwQ82?=
 =?us-ascii?Q?SuA5+bGCs5+Go2WbVHQqF37OntlEm2+DdGLKoH1Xln3IjlJr57bDmj52IxOJ?=
 =?us-ascii?Q?GjuqDrfapZRfxlr+lIGt7psjB32gI4rPI1+teGMzyh84LjWZz+nZpsKnVtfW?=
 =?us-ascii?Q?wHRGSBYouMb4ID20kxF6VAliydoun8Mz31EuEie5cWFS54HL+Ro8sI+CLzEq?=
 =?us-ascii?Q?OoZ/q/VxmGAGdwPNxqgs0RzHUmQwpEVprXCnOWb1FRgIZyxnVhJNhRMLaUfW?=
 =?us-ascii?Q?eMYj5MI6ufpzGIs2tiYCTEML2LwWrzU1p1zApY1zuSN0OIwYmSGENgTB+fVq?=
 =?us-ascii?Q?K6GBJqMbg3CXiXa2JwyYvC3CtS2BDCl0mlMIbxfTlMCUlk9Zycb3gZpR50Rt?=
 =?us-ascii?Q?osRuID2ARREZxaFWmnIV3FS2JVPWAgcGdmiWMs/GXecCjQ3UUiXFXzV+lhcM?=
 =?us-ascii?Q?y1OWs3WQ07roN7MwDO3WPdq1LSu7cGqKnI7QHg/rP0o83H5amA2xFb3yIQs4?=
 =?us-ascii?Q?je+mMvxxLVNewrHWPVfNSOjykMsQ8FnSMOdiBlI6Ajje8t6viApcRMDfIRbI?=
 =?us-ascii?Q?4ncs3XOXylX3+TMcf79Aq4tTnyfmTn5GNVgn+5UCNOqyrrLhJJwzSGHvwFlP?=
 =?us-ascii?Q?JY8YuVesFSe1s+zWlUOPjnISUikA9keWLkImgoHGlTGwfHI0gJRHb1Lnhmch?=
 =?us-ascii?Q?WOfAvZD6nMmMe8DzgXrOXxis8u3KK6B/oRnysc2iAeJFVuBlMby/9mSgSqrn?=
 =?us-ascii?Q?MyvZTl0kc1BIyKLuoE5TRnqjWo0nA1EjOS1P/Io01kuUVWGmqguCy/PPmpkb?=
 =?us-ascii?Q?ShVaqfPZXLYufhHOewebHyYYMTDMEYQpqQ3l7F2X2j3WYbahe9/T2zKiqS5m?=
 =?us-ascii?Q?B8zb6qmdk3Q4LlXflsaqcil30/cTgu/bIn5mznAb+WeLwfvDlTjDyO75vgzX?=
 =?us-ascii?Q?IwGig1WbkmNc/haLKkY1+2HOSFJN0ReXDilKSqV5FdBKBcP3l23mg46LbqxU?=
 =?us-ascii?Q?Di5e+uIDT0ut29YdIG+hhlo9Pq5t06lkLhoRjlAaP4GPaZogS3RgFHUDBidr?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6090995-bea5-4622-999b-08dcd633f382
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 09:42:59.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sgoipvwe6E1hxQczi4v8azallj7B6zJkbL9BSG+IA488wtDOXMgXod97tODjgDdDHeg8yNqKIpsgtSBg1DGhSkfrvUpscPFT5Bb8GNbkZYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-OriginatorOrg: intel.com

On Sat, Sep 14, 2024 at 03:58:24PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Sep 14, 2024 at 07:40:31PM +0800, Herbert Xu wrote:
> > On Sat, Sep 14, 2024 at 10:50:33AM +0200, Greg Kroah-Hartman wrote:
> > >
> > > > I think this is still buggy.  That if statement should be removed
> > > > as otherwise subsequent calls to debugfs_create_file will provide a
> > > > NULL parent dentry instead of an error parent dentry.  This causes
> > > > debugfs to do things differently.
> > > 
> > > debugfs, if something goes wrong, will return a real error, never NULL,
> > > so any return value from a call can be passed back in.
> > 
> > Right, that's why we should remove the if statement so that the
> > error is saved and can then be passed back into the next debugfs
> > call.
> > 
> > With the error-checking if statement there, the error is discarded
> > and the next debugfs call from this driver will simply get a NULL
> > parent dentry.
> 
> Sorry, but yes, we are in agreement here, sorry, been reviewing a lot of
> these "clean up" fixes that were wrong and got them confused.
Thanks Herbert and Greg for following up on this.
Here is a fix.

---8<---
The debugfs functions are guaranteed to return a valid error code
instead of NULL upon failure. Consequently, the driver can directly
propagate any error returned without additional checks.

Remove the unnecessary `if` statement after debugfs_create_dir(). If
this function fails, the error code is stored in accel_dev->debugfs_dir
and utilized in subsequent debugfs calls.

Additionally, since accel_dev->debugfs_dir is assured to be non-NULL,
remove the superfluous NULL pointer checks within the adf_dbgfs_add()
and adf_dbgfs_rm().

Fixes: 9260db6640a6 ("crypto: qat - move dbgfs init to separate file")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
index c42f5c25aabd..4c11ad1ebcf0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -22,18 +22,13 @@
 void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
 {
 	char name[ADF_DEVICE_NAME_LENGTH];
-	void *ret;
 
 	/* Create dev top level debugfs entry */
 	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
 		 accel_dev->hw_device->dev_class->name,
 		 pci_name(accel_dev->accel_pci_dev.pci_dev));
 
-	ret = debugfs_create_dir(name, NULL);
-	if (IS_ERR_OR_NULL(ret))
-		return;
-
-	accel_dev->debugfs_dir = ret;
+	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
 
 	adf_cfg_dev_dbgfs_add(accel_dev);
 }
@@ -59,9 +54,6 @@ EXPORT_SYMBOL_GPL(adf_dbgfs_exit);
  */
 void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_fw_counters_dbgfs_add(accel_dev);
 		adf_heartbeat_dbgfs_add(accel_dev);
@@ -77,9 +69,6 @@ void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
  */
 void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
 {
-	if (!accel_dev->debugfs_dir)
-		return;
-
 	if (!accel_dev->is_vf) {
 		adf_tl_dbgfs_rm(accel_dev);
 		adf_cnv_dbgfs_rm(accel_dev);
-- 
2.46.0


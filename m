Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4D61581E7
	for <linux-crypto@vger.kernel.org>; Thu, 16 May 2024 21:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715894218; cv=fail; b=uR+7flJVa3PId0uJQeJmLGw/gtBYgmTV7LMXCGI8ovS1io2Z/BktzICsIumMbcKrmw2nsqp8soV/2IE8ojAJjHGWJIk3cAAzkmtVY1LHu0if9OoaN2ZVLau9uWW6V5DTN1OOjzoTnvJqX+1eEOCBP1KMQudaf7wyRsRsoQMKbAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715894218; c=relaxed/simple;
	bh=H1DCwhHec0hFYwAwpfd2HZS++8tduzUhwy7ziDr+7Zc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HZKxGWK/cs4uhJ3yUWwC78qIanLhskF5PsYzP8V9KTlcslEmAzBd+WJlf27OZKj/coYQBA2qlYc57Fh7dyxS0T00LvOuJIJDl8zngonCsSZjFJ1Laf1DKQtl4wkVDqpXiPaJ69PCvTdQlQQ5Dvm+W4qKBl3fiqLIWk1IOUdQpp4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gw0R2OQs; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gw0R2OQs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715894216; x=1747430216;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H1DCwhHec0hFYwAwpfd2HZS++8tduzUhwy7ziDr+7Zc=;
  b=gw0R2OQsyGDdNbPBJoBkltZmZ6uA8aueeYljtex4PS4C6VY4NO9q98Kl
   aQTcTszsR7/ds8JcxBvvAbeX80xnJdx2HnA1XIqcEtHkd8qYOJWLlM4o4
   ExKl6+pkdu4q3d5FU5oMps/xAgCD8B/PkCWOhEL1NUUwkInxK6DOi6+gI
   nXzz+RfqTdajhaMZLem62QEpaTvnDUze9huLHC9kHSZnzYx5YrmDY66PS
   w+GXpy86ZRV8Uhy/XnTc0+aRjNiXpitVMHPemHgSnu5xwVmBg7Y/fLRIr
   dWO9oGRIVzM7nTJFS7aHbxC5Cn2VHHIFUXY4RiirL55iC3L/g264ugtZe
   g==;
X-CSE-ConnectionGUID: ymbUD6o+QwaLhO0tPsVkgw==
X-CSE-MsgGUID: 3gw26ISYSMaMNVBo/sMGwQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11562081"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11562081"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 14:16:55 -0700
X-CSE-ConnectionGUID: PmDvtRGnTMO+jAKa3FFB3A==
X-CSE-MsgGUID: OHgOIO4bQXidaR4grLRUYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="36118720"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 14:16:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 14:16:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 16 May 2024 14:16:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 16 May 2024 14:16:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 14:16:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlbfxKpBpyGjTfqBDQqsgZ4/nNCwhCurnMxwt3RzeW4+UI2QbjLR1gqjStn+6crhL/5vkYuIomKf3NK61vmK3h3jg2qY249KjdDGo7ZMEE62u7A1wsRc/6mqdC9FiaCePQpn+NLWRGY5vHiAepAQwwOkHXy6UBEeixqvDgEqlKQ7dfzVcLkiTsDXE8DpkEbIC+9NuVWA9pCGwo5JylubiHPHQIzP/KuupbkEgwIna43LK69Pl7NxYHJM7q1SaPeKrDkiDtW7P7eBLUVZBmOHjeVWP6N+tNj6CDo0tVpucraoq5im3d5/0uKipP097Fwq+q86cChvtx2yvqn3h+OYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQHLYYz6F8qbAH8Isoz9/VN0Hopp3dgjGN6QOCLheNk=;
 b=jUEkB7NYmp7LZVPy8VTJgzaQJCd/EOJqUJV5ayY7TSeEU2hxmbbfsg7X0cRrtcGgrvLIIE6BpdAIh8IuzYZO3RNboucFsfThmep9XyhmN23mOeQxoNCB4/2qQQMrT0kQRBTEsvulgA28R0mU8z5FzcqM+K4/mKbMNU8jepFn/VKokLNLt6IN0M+ZShji4EXHsd6ZWSWhzlrSKGibheTkDn2iYbdevrFSC3zBrJZgcpPyZtfJmn7smxpSI8cd+5atiLEuhzmSmIIPvwzl7SCBneZm/RuhWjcVuZf6UrHEACFn/iqsjE0m7GG/GqdVwwqZEOkCmqghliF96QIR6x7slQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DS0PR11MB8739.namprd11.prod.outlook.com (2603:10b6:8:1bb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.29; Thu, 16 May
 2024 21:16:52 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 21:16:52 +0000
Date: Thu, 16 May 2024 22:16:48 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Damian Muszynski <damian.muszynski@intel.com>,
	<linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak
Message-ID: <ZkZ3wLoEN6qCuf6q@gcabiddu-mobl.ger.corp.intel.com>
References: <20240209124403.44781-1-damian.muszynski@intel.com>
 <Zjs6VxtkL8QLtHIH@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zjs6VxtkL8QLtHIH@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU2PR04CA0249.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::14) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DS0PR11MB8739:EE_
X-MS-Office365-Filtering-Correlation-Id: 94677eb5-afdd-493e-ec35-08dc75ed816b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/RsJOb1RaqEPPS8w3NPPxnWKnuh7kY1DFT8XLnCDbx66Fk7nIBdEvB4clBKg?=
 =?us-ascii?Q?WmpnOP+JRcet7EFyUxWVjrur5SnYap3WsTOqEm3ixYwbXup9FbOvPmF7gSGw?=
 =?us-ascii?Q?eN8TyCqU2p1RmEyFPULqyBmuN/XciIkoajVpgr5tSmHG2AqBaPbUoVKeff+u?=
 =?us-ascii?Q?9PBqwUPoGJqa828Gb3TbYIUfYxmauieVUziImb1r8/x+4SwkV60QByKTfafK?=
 =?us-ascii?Q?lWN5YgPkRPCn7oXZF2MytjtsAIvKR0PfO6PUWAD0YX/0F4TNK/FTHpi1uCcN?=
 =?us-ascii?Q?UflDUFGCwFb/j9o7gPzAphMacc902TLPodzEy7qFVC5+euvUlLxvD38/G/89?=
 =?us-ascii?Q?WC7QKgMNTYAMw7EkeFSgftKZ8Ihdf5HjiT8AX53Yq9kVUsLhe4sIIKLjwqH6?=
 =?us-ascii?Q?xLWrMRuCnLt3YGFaNjvBE4GBPcae1B7QRFxgUhXUknZn1WT1pKFGalLUuK07?=
 =?us-ascii?Q?ZSIoPlEoF358uDJbFojzbsvDPy1/BUAOgg/oRcHOowv812NOWgxqkc+D5Bbk?=
 =?us-ascii?Q?073hN0QRBkET90+Rxh9GsQ081IvAr2wahi1uIwPv4ycslev06XIqAYDeBQbV?=
 =?us-ascii?Q?MVLsaq50gKQnmoPabuUPJo3sEa4OQ7C4B0KqH9e76hbRM/WNiaWLhEMFJy7H?=
 =?us-ascii?Q?5fvyLRfxsSrT0BBPsBcn0Yc6fJJC+bfDDu7QT3yeEEAr+o5GlNeniPIN8xiR?=
 =?us-ascii?Q?M2pZ/45s5NGm4O922dj0cL1mK1HGU1eojxNQ6SZgRl/ADOAWlc+AVg+Zbavj?=
 =?us-ascii?Q?lZhpDV8EAmwi4uRJIpXDDWS/TXLLEVqRqOphUk4zSi5SCiML33AW7ScWAmgJ?=
 =?us-ascii?Q?rZsdVZxSPY/xoax7NQe6YWzSj423ZdgHuDI1P6IUMOiD51adPrXgxi5cwWrn?=
 =?us-ascii?Q?tKsqZvwy77FbjFni/GN3XWg/N2axmWj/pDqp5tJsoGU6cix9W4LVH0elfyAl?=
 =?us-ascii?Q?6h3SUblHhAARzdk/ea/KFox5IXWU6RO2+ok9adZXAIJjlrFsvYKnJvdDCBLC?=
 =?us-ascii?Q?dKoBzC80OiSq8TcO10TT+836iMeBmwSY+XMBnXm8UHWpfcOKGoPJ2Xdf69M0?=
 =?us-ascii?Q?od7uunF/t4zC7FjzwramDBQYqWlnm7MI18WmSdP8PwnGjGE05r8QTWtSHPwy?=
 =?us-ascii?Q?W0KIuyUc14OKiVGSMblRJVHw4a2zI6N6JZmVL1WZ9mBt/IaTyder3ntcyTAc?=
 =?us-ascii?Q?JAamzvveItYCDdkGrbuckgSTIS1mwCpoOTrXNLykxwxTNxHdTBbMO4Atcfu8?=
 =?us-ascii?Q?di3na5vJp/Qg30qCXVNigzOwVa0FMEa9hFW87rAcWw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HaQgo4rmmFMBamMZu28XjTXPlqPS/oRg9b0a81CUz6uGOBKp7JJwp+afsZgv?=
 =?us-ascii?Q?pkZcPln1H+GZsmME9DD/ldi7yQ7e5EosATEp/2EHKjUraxhA/sCvrfaqsK90?=
 =?us-ascii?Q?beep3pq3IXzS5EbY67nvd25LPFfAvzyYwP9iCgSLfucxT4Rh+DeGpsEDQtyG?=
 =?us-ascii?Q?/VVykEjNBzm5fMhBa0z7FyGQand3L2Atlek+Ez0lJCuDOVfDXozifVGgr63M?=
 =?us-ascii?Q?ah1B5sukA/epz7FjU5+sfyrtR2pqT2cUgU1I3e3xWUl4rNfH5+JCeIuz0wPn?=
 =?us-ascii?Q?ozBp3ADjaHkcBe8IyqmY2H1yIdqa1WpSSVo3mWN785Ia7YyLp+6ekgyTFVy8?=
 =?us-ascii?Q?onIjrunJhRryr5MSdlPsRmY9+EYnCZq+NQ4CBI7ahxjgEVG/+4Q1QoTP7F1a?=
 =?us-ascii?Q?FS1FusxmNAJbHoR28t5asFj62SHIz15gzZ5/IXuobF+gLXzZ3Yru9tGC9EUz?=
 =?us-ascii?Q?M/i5KU1A7YE91oeIeepgh33DlC3oyllzjeZrihSo0bd4M3NKohbZ9AWq0WNd?=
 =?us-ascii?Q?X8AC7WMs0vGXi/dxWBL5PxqoRyGtDrIlBi/3XC3xhWH+8HGAXRZ7LLK8ANT/?=
 =?us-ascii?Q?pNJ5KK6aNy1wQHLhhjv4p9qvFY6y+q4gm5V9PPeHgP4x3pMhMv4KSvI7qUsi?=
 =?us-ascii?Q?HbguP36lVD3CXEvFVQ48hDj4I6EphXDUtVJC8Sj2pVoRV0eS1rFftQggW2Z5?=
 =?us-ascii?Q?AaGaXARAELQG0mGHVzDUcc5zqJ7DPuKOUvxSljN6uNydFGvuke4E1l1WHpnA?=
 =?us-ascii?Q?khxnBGaVNE0fOjFmLGThpc7I+MVUVWxMlIWyqlDv9mHhCU4QD57slsiwmDiW?=
 =?us-ascii?Q?p/ZMvtoS9akzNz4RizxV42f2xf8J/RpXkacb0FsK3U1m3gLuHVct6V9SnfFq?=
 =?us-ascii?Q?M1Xo4y+C6tNahkurJ5E4nusiL6qlhHwcewCJzjodDuDJwujB0fHZ7XtYwI0W?=
 =?us-ascii?Q?zPPUz/IkqIWxd91oV7XQ3hEbFGGGNLg8EBB2xSBRtpp+ZTJn+eVHnOafjtpY?=
 =?us-ascii?Q?bsKZVMtKZ6xUsbtPyBBXV+cIhP7VY5i476z3TyOe2ZOO8jDepKEAzkt9spWB?=
 =?us-ascii?Q?zoKzPjT81z1lMTUMQUnHKAkOjDGnZUVId89lOCw81uGN1PyeeLtX2YM5jdVa?=
 =?us-ascii?Q?nLKi9fzGzvuDZaCd2ZMu7FzLCUoUiM0hneFbMC9ccvZxhkS9MtvB93PUCawS?=
 =?us-ascii?Q?0cJl7GsIfeNOGx4HahGCly1xFw2+RP2v3eLq4uMsjZkKH2uGAt02N+IiHoo/?=
 =?us-ascii?Q?h9PbXwTt2xeSdtoMRy2vNB2+ZVW37hTHG+mHqd9qe+l7+jAfTaZVojRQiC1O?=
 =?us-ascii?Q?rWdFiExC5bAkvKf17qZaz/0pIa4BjCmWs/Piig6y4yR24SNCJx89Wo6z5XXq?=
 =?us-ascii?Q?t/YSkekQOyipBKVC5crdFZ64b/so6JjPEnxtuNBs6rpLOVU7tZjcMK3uYoGQ?=
 =?us-ascii?Q?TB/DMs4xR7bqqRknXKxdjEH2xKlBPpJLk8aOwEacZgO+HLf1wTemeUf1kMTz?=
 =?us-ascii?Q?xae0mriK31hthJmYRJNvOW+r5Eg7PYlrQEWuDN/fIHWuYgD4HTtSPMCVRs0j?=
 =?us-ascii?Q?WtJ0b3bP76O9KPIfPuXa+rUAHvSb49tL9I1jc+QCofvrmw0F4CguWhhFdQfZ?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94677eb5-afdd-493e-ec35-08dc75ed816b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 21:16:51.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5j9NGIp1x+zV0imTW8qiPPkBKtTdSGzRLil4Y5NkY8XUyKKLx1z6WlHyhu9sbs2UF7t/EYFu53sSXx+RxFd/QWecz4AP+npT+59aiexyV8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8739
X-OriginatorOrg: intel.com

On Wed, May 08, 2024 at 04:39:51PM +0800, Herbert Xu wrote:
> On Fri, Feb 09, 2024 at 01:43:42PM +0100, Damian Muszynski wrote:
> >
> > @@ -146,11 +147,19 @@ static void adf_device_reset_worker(struct work_struct *work)
> >  	adf_dev_restarted_notify(accel_dev);
> >  	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
> >  
> > -	/* The dev is back alive. Notify the caller if in sync mode */
> > -	if (reset_data->mode == ADF_DEV_RESET_SYNC)
> > -		complete(&reset_data->compl);
> > -	else
> > +	/*
> > +	 * The dev is back alive. Notify the caller if in sync mode
> > +	 *
> > +	 * If device restart will take a more time than expected,
> > +	 * the schedule_reset() function can timeout and exit. This can be
> > +	 * detected by calling the completion_done() function. In this case
> > +	 * the reset_data structure needs to be freed here.
> > +	 */
> > +	if (reset_data->mode == ADF_DEV_RESET_ASYNC ||
> > +	    completion_done(&reset_data->compl))
> >  		kfree(reset_data);
> > +	else
> > +		complete(&reset_data->compl);
> 
> This doesn't work because until you call complete, completion_done
> will always return false.  IOW we now have a memory leak instead of
> a UAF.
> 
> ---8<---
> Using completion_done to determine whether the caller has gone
> away only works after a complete call.  Furthermore it's still
> possible that the caller has not yet called wait_for_completion,
> resulting in another potential UAF.
> 
> Fix this by making the caller use cancel_work_sync and then freeing
> the memory safely.
> 
> Fixes: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
> Cc: <stable@vger.kernel.org> #6.8+
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

This is also present in 6.6+ and 6.7+.

-- 
Giovanni

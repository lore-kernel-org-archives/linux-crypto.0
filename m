Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5D576405
	for <linux-crypto@vger.kernel.org>; Tue, 20 Feb 2024 16:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708447223; cv=fail; b=FQH/yifb71J9RF/LVe8ZG8BynKJIW1sfzyCT0hFtOM1Be8CV/RGWr3HJ049AXpYJJtwEfpQr7eqRANi9+BARa4rpI6BP+OQKRiU/y6XWZRVTQutgMjRJ2P9XLKgPXbDkXfKbcGx9paOYFMv7X3Dotxy1OB7X1WFbxRSsm9PUQWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708447223; c=relaxed/simple;
	bh=lUzOcPaBPzqeDKtebBv8BU1OCaGAFaaqDX8XVXSGo0A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gvWBCqXFLpmrjrHKObE8k3Ui5GHTJQGAhYTOPW19ZGz8nujXj+lx4PVnPCL5MRN4iSQJXr/ztUJkgobGs0SGCjnxNjkVsuR4dI2iYtGH9D/8OwuehIxf67TUW/W0oyO0d3hpaVOpWq2r5mI6xyedpAzvob4kppP+9LxJ4xT20Sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c5UjUaG2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c5UjUaG2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708447221; x=1739983221;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lUzOcPaBPzqeDKtebBv8BU1OCaGAFaaqDX8XVXSGo0A=;
  b=c5UjUaG2KKfLJHS7nL4CMKJlX53/25RRh+DuVx81vmmmL8e5lFcUFhKf
   EqqqdSO4enZHlAo8gbtRqak4o0BJbPdXjnh1TrUPrIYjdsDdAL7X6M7U7
   2zSWb6ty95//zZnGcGYe0IydvTYgkVQIPbWgxMMFKbQ9NW1ajwLilV03Q
   V4kpoWHxYdoT73x69NLVEwvKSXkmqtTVzb5BIq5uVv9rvgHO7RX+CfuIv
   2PTGifOdLBbpneVvMjsG0SAqoWhMBIo1p3bC//H6uInxIdewN0lDmU7q6
   sYq9XMpD7AmI/dB3GToKcee4YSJLQrRLGfio6nC1Z9oeT1/trdlbeepBl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10990"; a="2420391"
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="2420391"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 08:40:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,174,1705392000"; 
   d="scan'208";a="9490754"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2024 08:40:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 08:40:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 20 Feb 2024 08:40:19 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 20 Feb 2024 08:40:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Faj1lO+A9opTs0fWIkmu0NGjDBMdzp3bP/7FZZ7iYzWSwFxqvYQG1KuGWPKp6hn1kjBnnYtqWlqDXFqYQKu1WBgNQ2kXxfL59ydB+vhsl/jaI2BT+PfO0XA3o3r8yrFL77/N2nzqoCfd6nNzT9hVqs/HrwlYU7IJT4mleIWWAZlgKP9dTt8rFPpqg7n81sSJOAUJs8t8JZwgHBJQI7WLTtpcIp3uPvXz/qIPGancshesWReuur48Ur0b5t+vVxDhIVoezjXMQYbHJFXIqlQLuEH9kH1bR7v4WED/lih/pf1aLVD97yic95XwE+q82dhRtV/XRXSqE6k0NQrSkGL3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYRbzFZcKt6ydavLtdOXC6yn2+sXwrCwPE10IsfW56w=;
 b=NjPwres1mVldE5GDw3nx1O+Xw1MinLTdGW+Sgy2iFRWQ2RIi20ov9l69SrK05xF4UJ9Krkbe7KWOBgDfDiyLsvg4nPXRKzg3Edv4b4Lql7pAWmIqpOUgk0nmqOHAh7z0V+3/NIIblEszgK8LjUZFhIHMkpz1f8l7ahOGVu+MvkFq7leRTT1t8PHjAy0yWcEI26wgLX2fpGZk5n/cgfkDyiZdOzPz+1iwNzGUXLZoJ0uGAMFHctuRYl67VcrKR8P4PeXh8jxnuNl2vqYFXarRNI5R8T1Zk27Q4wUbeVni0FTssUZ/b0TuV3hMjeceYnQMK/aLLaRNZJEeE7upAeeUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH0PR11MB5444.namprd11.prod.outlook.com (2603:10b6:610:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40; Tue, 20 Feb
 2024 16:40:14 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::ef5c:bd0:ec6c:3d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::ef5c:bd0:ec6c:3d%5]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 16:40:14 +0000
Date: Tue, 20 Feb 2024 16:40:07 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Damian Muszynski <damian.muszynski@intel.com>,
	<linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - fix arbiter mapping generation algorithm
 for QAT 402xx
Message-ID: <ZdTV5zCLbhKM8cTt@gcabiddu-mobl.ger.corp.intel.com>
References: <20240119161325.12582-1-damian.muszynski@intel.com>
 <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>
 <ZdRnpyUNdOVUS9nf@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZdRnpyUNdOVUS9nf@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR02CA0023.eurprd02.prod.outlook.com
 (2603:10a6:10:52::36) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH0PR11MB5444:EE_
X-MS-Office365-Filtering-Correlation-Id: d00b6879-3806-4b70-b1ec-08dc32329cd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVItaRwT+nLatqIaBGV8yQrN9IkbLe6Voi1ZGnbhDa+2TVhoopAYdsyWZ6zkCouzxk37JkRsvStEd432vvTiVIlM/lk40xxsYxFY7KICVFBIghfLdulIljJfuxFR8AgxPAaVaHIFSYRnKd74O23W4jQA4VXzu2rCERyeRS2Rm6lbJzIjyhwtF0lO6EqLFFWxkiEl8Rmc/hz1k1t6GOVtE4jcvb/O/n2/wMb4sK+tD+OpjGOGrOK5mrk9AgrF4YpktrmbdYIjkx6gbbY7VAM0v/Qm8InDpnH0pObs+h02qao7bKmjt89UInJqDWCQJlR3WQoVeEEximgXaixKan5NpMMTIWX/C8pIuVzLpmG15QLTu7PUWJEoeWvPLyaKpZFhtkWAc3GCJKZfLRHmbaUun1HO1zTdnp15iSu7VJGqv4cX/StI7rRVqtNdiDlIcmQTOq4lvo7BAdllrv59MNc5R4jLWpux9DmOyJNOUk6Dv1vcC3f29uFn8l1yYZUYCe8me6RqwiCy4gkev1GDwNCTkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ieNMWm7s+DPt6Yvi/xSLfFlpGRz4haLV6MQTZGtJM+hj2+sXA7nkUnv5lay?=
 =?us-ascii?Q?dt2Mu4BeZLdP01upaJ4u0yie8PoFl6Jilb0KJB3SsIHAgVEa9QoNjJHMgmGB?=
 =?us-ascii?Q?VJJd57CP6DJFXMYylz+hBucwK+e95hKsIiGDyEqDA3qLGypCpaK5sNv6wa/8?=
 =?us-ascii?Q?ZOqeQbR8p4+nwMwymNZOzCsdfJgfdy0khz7u0X5UN6EMUlwaznAXoSh5wdA7?=
 =?us-ascii?Q?tjlRWinCIcWAf5n8dt2CTEm01XMZJWb7z+WRDCwEswdyxGmleEFkuZAqljkk?=
 =?us-ascii?Q?ut42bj9yYbDIj0ej0J5SpzmMloX+XT6rGn8syejsXJVv3REmNNocMS3Vr/Ee?=
 =?us-ascii?Q?+4tqewqzLN6lkvDogaxxNxdSmHlsDYDokdSJa0th5489RDeTQZAt6tm4R70k?=
 =?us-ascii?Q?ygt0lCHYMk6OE6Zjdq/JcT9rB+LM5s0jGb6LGq0BKEwySdlaNZDK+oLxdcTZ?=
 =?us-ascii?Q?g5PXJ4k1Ixn47qU5hjwiXcBqU6aKGb5w+PR0J2Nm5XBP7RmSctUq+nbwCcMg?=
 =?us-ascii?Q?GDtNeTno7DN3VpkLKDrTClonVR5MYZ/M0mjl/a6uHzU3l0DSEvG9VbImdoWP?=
 =?us-ascii?Q?FuEfL0GQXEyrMkOpRJFWeYMmmR8/yrTM/bosztDFVmd+DZakr7lcDO2HpgqH?=
 =?us-ascii?Q?3Xhje2TG7l+IPwe8UlfhoKWxH51dt4VbCEsgXhb5NTba3XRj4ivOoSPiqOhh?=
 =?us-ascii?Q?+ZcakdB++Bmve/G9Oe13xMmipl4ABXKRBpi+eeTrG2T8ne/orVrH9wSZbsaP?=
 =?us-ascii?Q?9FZ21iTMx9pHxEuyvoNM5FApPvXkne48N2y+/3Eej3u0IxJHjMK7eMIhgX9i?=
 =?us-ascii?Q?MHuqCYkCNYV8+AEOzSumrTe6ZqSmndOBzDwaL7es4mH7wpuVqh6RygziLRpS?=
 =?us-ascii?Q?ePuHtcL1VnKCVZ0rMLCNmR17z45otvFC6PxQZDsOjQ5V1wKeUd8lhfJ2MFev?=
 =?us-ascii?Q?/+yPR8yxLoNu+zzRWvM9mxpxw5t5CQjGTr2gPDmNFOv/Ic8T4VLECd8tpqYm?=
 =?us-ascii?Q?Tx+7u6sMkV81MZGlUbybtdJ8UF8dW3luUPZHW68KBCUJKqZasXux8/URiCGU?=
 =?us-ascii?Q?BJx0vAj6gqbFMS2cQKFN0QrifUOva7+jfCgjr7jj1yoxjQpWfqw8aeJi8ulV?=
 =?us-ascii?Q?rSpCjRJeUatVKTLLDDBy6nNZ8SW8d0Y/bRf1z7oewD+ClXqJtRxoIIuISUaB?=
 =?us-ascii?Q?wqzAoVcIbWSisH8R5cxUzPMCww8nKzK5OMXrJwUgrJzWvwKomuk54pZV+hi6?=
 =?us-ascii?Q?ynhHe6ridWm4tzbal02NaA+6B+7mx+X35CsgksqdR7C7wxG5PiWDo9s0tO12?=
 =?us-ascii?Q?Stbt1XRmePnCKgq4lQ4QEjoRaGVed24S6XPqIWQkLtAcKdYmsKkYO67vYWft?=
 =?us-ascii?Q?mLyZWUYzfZkvYvon/4GFViARG1/boi3xq76lHuIFScgsaKEGkeCDE+6Y9SAU?=
 =?us-ascii?Q?jXL/0E/DVmkXchFnNkUyTXkSiaCYDbfI28ET4YtOiv5JcUOw5bemFN9yYPIJ?=
 =?us-ascii?Q?WiVcWvnR/5zBkzrhnr8nKhFYnVkYyfG72L1NjeDdjMXqTe2y3oyZz9GdnfKy?=
 =?us-ascii?Q?CTOZRQMwU27u4BuH/A+byu2a9ydqLjInn6w+XPrXsjdSc8zimzjhTdw+KM2d?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d00b6879-3806-4b70-b1ec-08dc32329cd8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 16:40:14.2460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Iufx9uZMgQb1v9Mrlxg2wF76UCh19eHv8cOBsHSRbIWn8bUfOqxZd9yTKll8WDnRvrmm4osIOtKLcIaI/suZZnCIlBVie1rLiH498JlM+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5444
X-OriginatorOrg: intel.com

Hi Herbert,

On Tue, Feb 20, 2024 at 04:49:43PM +0800, Herbert Xu wrote:
> On Fri, Jan 19, 2024 at 04:57:11PM +0000, Cabiddu, Giovanni wrote:
> > Hi Herbert,
> > 
> > would it be possible to send this as a fix for 6.8?
> 
> Hi Giovanni:
> 
> The firmware file qat_402xx_mmp.bin does not appear in linux-firmware.
> Is it supposed to be there?
The firmware is published to linux-firmware as soon as a new device is
released. QAT 402xx is not released yet.

A version of the firmware for 402xx can be obtained contacting
qat-linux@intel.com as reported in our documentation [1].

Regards,

[1] https://intel.github.io/quickassist/RN/In-Tree/in_tree_firmware_RN.html#qat-2-0-in-tree-kernel-requirements

-- 
Giovanni

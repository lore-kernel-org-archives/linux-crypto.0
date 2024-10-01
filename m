Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4859E1BE875;
	Tue,  1 Oct 2024 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727780822; cv=fail; b=KvKc6dix/m5qUUiXSHuscB6/4hjULtmUtSs6InFR3r7l+D4jm+sqVntseaG5k5fqmz+lHpSkZKXSGBSwE3JOcbR9nlO398+7uTN53BiFav2hCy0HQU6MiFhpgJQoIvimqK5U71M7BUYpm7lGTYDK19AlHsaZmsegNc7WEHdDYis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727780822; c=relaxed/simple;
	bh=WGNhEZgCYbHWBWm1IaRl93XoBOGT0MXGvzfw2xk0M50=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bLLY4yDOo+greKGipkqq9iKY4sff9mn/XVOGr+Dp9KTW9cRMe3GxmIIU18++DF/3nOwhl7PtpBeECnQdb3MB3Nk0RcWUwOFpiaCQmxMf2/5ltdGHpm52yroJriq/j0dC4KGAE6POYko838z6iKh2wbDyybDcwvPe8IEjPzOsUkM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXgyDnjl; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXgyDnjl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727780820; x=1759316820;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WGNhEZgCYbHWBWm1IaRl93XoBOGT0MXGvzfw2xk0M50=;
  b=iXgyDnjluTRDXxx5PVYrNookQuA/n9l/oz7KPhcyqwXVUxUctzcqARxO
   0MyDsOeSdautQlWgebs8BcItYyCLiokSPNpmawmwgLk3kiFKFl3jS2+9X
   D5Wkz78aPD6r4K0YgBLenZzcnI7iIMZPGhJJE1v0EuAavOCT8kZnnD+Q6
   aJ14ABxi0OcwnKZUO0T65kxHeIpNWvA7jYKYIge1PF++CdhKa2mqS4cQx
   LeJ2dhTRPC8AYnzo5YvOdOK5sfRZeXaVzKxKgK4XYmH1MrtPB5Ff2QxDq
   kVnAG/7GedjhDbk0wEhYyHWeUGhC2Vykp7qMFyKldGtiuHw9dbY7kkYxU
   Q==;
X-CSE-ConnectionGUID: SATau7akSj+2fxJkVNn+NQ==
X-CSE-MsgGUID: SC/7j6jhSBeD7bi9uBkwwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11211"; a="37585469"
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="37585469"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2024 04:07:00 -0700
X-CSE-ConnectionGUID: PBPs0RUjRaC6terZXYg50A==
X-CSE-MsgGUID: aMqBZzWhROudwSIrnchSKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,167,1725346800"; 
   d="scan'208";a="78039635"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Oct 2024 04:07:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 04:06:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 1 Oct 2024 04:06:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 1 Oct 2024 04:06:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 1 Oct 2024 04:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xO00GuoL6Wd0RJu7+0Z9yqugy96lHiYCFH34l1iS/9aC+fb5Ou65xDUgYrMyMNU2xbcqYm7h3sW0iu92JTHmVAj1JaFJ1nOo/PR1eESmsf01MYaeteZ32QRK02qL7JhYlqZqacFl+OeXIGZC8dsJEqHIHMPt2AL4RfUoyV8H/unTrAamx93fN1MascQhIdVoHpYZ4vYX0F7bPqqeSihA5c+PXgaZ9DNex/5yxYH3FhpAP4EMH8uY+JyjJ24bwVf6+HbaD/T+v0CGWWis6y7jTpKYKon+QoUy7PaNW33dKyxFKb88RKRuo7I1Wm4uUdpV9aFu2ia1qH1y8vJK26lkZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zswJva4KbKeeE6spGW91Z2xUMD7EeOEqAHlic5aIzhA=;
 b=llPUywJJAypuej7M/0r6pKwH+FK75nPrSrO5nMo8qWbN7OrZuzd5cMSxiTcsZTglqk9ogzThiGv6KLb6MlOjQ/fiMC6uP5igmJgcS3zAraxsPGuZSBYHmVsEST+EQ02ePrPeBAmDNN9A3Wf74gTj6gJpTxH4cBswY0FuKlE5MlV/s6UPBf8e34YXiHpJJkpoSKVaqNWlrBwR4W18g/zY5z+G6tlpHfHWqUNvCpHw4XimsTvn54GjddcdvmDXde9/vn5Viq9BX9tv1Lq0OviY8BRLF3dyl999Z2JdsoMD/Ues/FHEzfOOvP1p3/jI4rTl6qqgGUnaGucK8W0Fk/Uiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by BY1PR11MB8078.namprd11.prod.outlook.com (2603:10b6:a03:52a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 11:06:51 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 11:06:51 +0000
Date: Tue, 1 Oct 2024 12:06:46 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: <linux@treblig.org>
CC: <herbert@gondor.apana.org.au>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - remove unused adf_devmgr_get_first
Message-ID: <ZvvXxiEzvPb4YQqv@gcabiddu-mobl.ger.corp.intel.com>
References: <20240929012442.435921-1-linux@treblig.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240929012442.435921-1-linux@treblig.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: MI2P293CA0012.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::10) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|BY1PR11MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d61c4d9-d740-4d2c-8926-08dce20926ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nAzOVQEifSZIH/r9fdaypxt0Ht4T7zvyZuCNktb2IwdXjh1bv1/T49DW7XrB?=
 =?us-ascii?Q?q7qlZsQ6XX3X0GaZQMr5SAbLPRuLfLP7X69qNHsooHBmveVHf0w7YtRJQA5l?=
 =?us-ascii?Q?arH1xszjCHVDpb+xvY5Je9qD0W4lKlr8UTKr1jeWcaRGVzqJdoxbwZG6iWvL?=
 =?us-ascii?Q?J8dCxvGigO90xBD2JqNMjA4ULz5D82lIKdeMwbN1ArlHEqa5onsVd2DT0pXh?=
 =?us-ascii?Q?Om4yk1vlWZPIBk5FvNpovak3+t3f05WaWIhsEp88JMPqKAoN86AJZx/3m9Zj?=
 =?us-ascii?Q?q949eTPcPxZf25Z5McCB87CIGx5rCe4J9rz+IcOGrY6kqyqpVHSSofr2JSrh?=
 =?us-ascii?Q?2yWr6LVf5VFNWR68C3CzglDaj6+pGeYdsTDGlIhovD8LeMlMeSZlGXdUbOR0?=
 =?us-ascii?Q?bOcbo1DS7qzEbLLBJQW8KVuhmFGhsiFsugObK2wwba0rI0ptJ1FrtAJzXlPS?=
 =?us-ascii?Q?r80l9Xr79PCwpK1QXvDJUogqPKHkMZ4bwjo8xgCdlUX0vA+aXjZNKNk9YPjd?=
 =?us-ascii?Q?oQb1uKbp4CcC0IyBiP7lRBdzNXnn/sbdkVXLVf5MQaSzjbmWxu7YuFIc7Sf3?=
 =?us-ascii?Q?xemeHqnR7C+wzMv8ifcn5aHm9t+79heZjVAxqyVwQWBFuQz1saXBEpjBPNjY?=
 =?us-ascii?Q?u+dLrmR/Bdp0m0Wc4fm7s8DlBZkP7qZl3htQl+eJ3qg1qxvflI7lvhC7HUE5?=
 =?us-ascii?Q?AOEJF6aYUCW+fQIkJkEZKavNIqYLdymN9+CzPraiJbH6tC2RnmUJqVm5vyUd?=
 =?us-ascii?Q?ClCNUBebTnukDDhx64BfQ/ovGZy+ynm7y5ZSLsjy92Vt9StYIDeW6O6XoNV1?=
 =?us-ascii?Q?QnSsti5T+pAFu7qH+ULHvdxFAyg0TTdSJi1sq2+MIzEVK/X/sYkP/qyF9+Zh?=
 =?us-ascii?Q?OzoW7c7JgDFwc15tYWPKKdy+//MTDjhNNEF0jJYh9ptU8QCuYfwqB2SvfEYf?=
 =?us-ascii?Q?or04KepBuKkhTWizRPwQI15FedxXjgDLSCBkeKg6zlizw0J3ibQjf2cl/hry?=
 =?us-ascii?Q?AJ8zTFSHjod0KbK1E8XgnTIAo8g48ZO4VK7OZI72UcGpg0SGgCqg6bcGv8ws?=
 =?us-ascii?Q?czEZa7fBPCr+hzfFwd40PpZgxzAAd248ioq8SjjhLQlg8Ndxz2TqMXW4NfXH?=
 =?us-ascii?Q?qgK7O9yYbFK0X+HFrXwYv2LsCartiDIGR7u16l24ZXDEK+Vi+ZxJM49sNbbz?=
 =?us-ascii?Q?XRNMQdKj9DA3EAclaPz2c18Nrp1XyJhVt/19tfEdwOYbEm9Iqh9XJU2ZWN1f?=
 =?us-ascii?Q?RHpaUG5yRZgg/L2qE+//Bb7z+hkKExXf1JVex9APgj6DoFV5Gf1PTl3nfPbd?=
 =?us-ascii?Q?NKrTUHhlLYgC8M0oSQqwO1b+wLEBt8CSE5jg2uZmE/574Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FJ8l/dWCS4C3tEotzDP10I2Cf9p6aEgzfAEkW73vE1Q/lCn/iXRjL3QtqXAV?=
 =?us-ascii?Q?woGg1cDDMNTwCASPmf7Z7PxG+VGdaYqkLoEwMbB4BXAS31vej5rglyDE3eZl?=
 =?us-ascii?Q?YveIqJM0gohYy02w7dug8TUIwaUf+o7q0ArZnSsN6tT0kfStPCr8ydspXlKe?=
 =?us-ascii?Q?w+zg9qqb4soDPvkR4pSjn6QIVeQHEyQzblOA74b+Y/PhmUmKWQboq4HvP4jh?=
 =?us-ascii?Q?RHOhSrR+VY4VAckPLJwLq5o8fbtLyCQkgOUitcbIO2Zt9oYKUDJggOAreL7J?=
 =?us-ascii?Q?R0Es0xX8TbN5CC2q55/mTxcj5dB15ux5kKEwZ8AtEwlKopIbtglr11GWz0IJ?=
 =?us-ascii?Q?ZkL7y3n7GziD0AOe2iZI9cJixThN1q1vSGNhYINZbSANPkSyTGJCB1PoMaNf?=
 =?us-ascii?Q?1pvQ9CUDoL+K1ucHnbxW9zCsf0a9RdatClv8NfkCa/D4wIQvb3jD1e5sjFbp?=
 =?us-ascii?Q?g0n1Jhel2vZLkj9HoK9kLdeEKsRGxKiYRSwEgZf4ohn5KppNEConGvmmeKoW?=
 =?us-ascii?Q?SvKI6pP1bGktcHCdF3bca52bJz9d584Wd/Dc18BiQRAOhYMQ1YXXumnzbjOd?=
 =?us-ascii?Q?Wp9O4JI6OmHuqvUc9IfsjMVxK3OveHc9km4LvTrY7VOqW8a+Z6JAiCQUa62y?=
 =?us-ascii?Q?LloB6V3S5hDQ09gEoI6Pvs+rLL/WVNt+5s13S4vTpHim2X3e/QDtnT38Knei?=
 =?us-ascii?Q?QEWwqXP4ZO71HiHbQUpY269GLixO2p6HuBz/8wK87jJLr3cjNOWC9IWvBWX7?=
 =?us-ascii?Q?F9jKF+1ssnU6GTQPRRXC0HW5azbTs0gwe0vmNValOBLNkQXGknxlRiCFlu2K?=
 =?us-ascii?Q?1yVbdsVS8xi/O9iYbp3KoB5T0qXZjO2316W9W+IGubhtUzjc8wavivVhDONa?=
 =?us-ascii?Q?QNSnq+UpZYYgUOUffJcRegpdftcESxTbT39VdGr1k/nY+ewVZmsjaa5J8kP8?=
 =?us-ascii?Q?DtqzzJCoR4m4YUaZyjbKf7i4gZTh2OkyPx8Pr1VUMC2ompjserZfBLCiGwvJ?=
 =?us-ascii?Q?jtZdbqixqLbv8vX0UC6NlMXuKqB0qvLcERtCXcZW0kSYWBCXRshjTaSZD7XQ?=
 =?us-ascii?Q?eWC8HjXO4SQFTqowX4JmRGlzAPr0VME0sWXFIk20pQ+A+Psqx4wqN+/IeVqr?=
 =?us-ascii?Q?dYmT+UuauVs7bne3shfVXpGpw52CBUcS1HtgNkCWpBVLbU79cJ5+nO7f8i4s?=
 =?us-ascii?Q?oR364gar1eNv6bk+nYdbjl3GXKhHECvZHZpOjBdH/8G2o+FhTK41n5zg/Lhg?=
 =?us-ascii?Q?99w9wJhTBvRRFu28ZtxQL4q4OCSUOn5RQ1AN3pffAMKAWmwpaK7nWq66fuzN?=
 =?us-ascii?Q?qBJzvuxB5Oz46xnmZXLQ/5HlrRerQps/nE0+YTTg1uzni7F8k2NjQ6kZpz50?=
 =?us-ascii?Q?qnIAwxdvvSJBM7yt0nJRIIP+QeFwX9ceys7eUtSbG1fOqgTXEvqMRuiNl3wn?=
 =?us-ascii?Q?8APR8b/PA4/+G/rsZS3sjmW+is42e2KCsyk+qzQDWm01o0zi/bx0Fhm5Y67O?=
 =?us-ascii?Q?gmSXE2PCBw+GeICFRFHNf696PCU/TElqrseJSw2vaiCpBiQANpwJKhKxaz98?=
 =?us-ascii?Q?BtHPg8iT6UYyXHDDJrl5l7wRc6nxKliAUByZTHkHaFcuziXnH99WVTf5ytpu?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d61c4d9-d740-4d2c-8926-08dce20926ca
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 11:06:51.3987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3g4oI3nKSV/XGRfPAFySv4p5E5CDXkhVV22e/PFxMrJYizkd2fLJyaeRGh1M9cvIKnJQEW04BfHtMZS/UlrKU7e0Y41PNH2pCn+cbKKRABQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8078
X-OriginatorOrg: intel.com

On Sun, Sep 29, 2024 at 02:24:41AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> adf_devmgr_get_first has been unused since commit
> 4a4b0bad0653 ("crypto: qat - fix crypto_get_instance_node function")
> 
> Remove it.
> 
> (Build tested only, I don't own the hardware)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

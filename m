Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E241DE2A0;
	Tue,  2 Sep 2025 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756825781; cv=fail; b=jvCrqlBWaKD1o32Ke3u0kJmTMTGMg1/+RzycLzK4mfLhEATOAGf6dDbcdNLI+OMGAovKkfBM1hUr1vWNNlMM91hK25ZuZpJlL8rSKT6Xl6DpYXDf2ZUmLU9YsIxbofQWjMvk2y1Vk/N46el0Ks7CtbA6d0DR8Za2NItJlVxWYVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756825781; c=relaxed/simple;
	bh=SZTGprnH/AF0pjzKt6zgg1G8QQPqqRsYiVXL9LaC15E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u87KSlDyXSa7VFbaLLhv+OyyT0y/E3T0zCPSSQuwGNm2hEw+qq0TFdKGFXl9I1RpxiWgCpj/vLqIxMp91fk2mPZ+yFBxA6WMJFWqXuPShaPPP5uRLKPlIBmx1IHKGE9SoDYuTkkFMP8dChAsMoTER8qaKhOPG8ANy35am/obpTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X890TB+E; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X890TB+E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756825780; x=1788361780;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SZTGprnH/AF0pjzKt6zgg1G8QQPqqRsYiVXL9LaC15E=;
  b=X890TB+EKalq6QOXEmwpGhPlliJVMXGSB5C6Ys/vF0W7Bw6EEcsX2URY
   AKfbgyOKuGAu/rbU8ca5tErh2PTGwgK4dAL4ML88NgiT16kmqR4NR33yN
   QfQNoa0AmfhWjKAjg3oZSOOEkjI7wnVZcEQPpFVOYBZKBLtPTY5HUd6WX
   exgCCPvgFlb7xZoMZ29MmbvyE41yImrc62W/ZzJgo03j3qglDpXGeRn1d
   oqSZ8DVu/crAcBIVGaPHz1fM6PvNPbYQhBnsqGtAGKTOdTpdauFLUPmWa
   H1C3dmcnldExl7cM7BL+aUoyk7OL4K162L1gHe5WcK5fw8TNVNWxStAd+
   g==;
X-CSE-ConnectionGUID: nZbJnsJQQ5Kexyx3aHR7Dw==
X-CSE-MsgGUID: vzIF5YnAQdK/O+Yzk4TGmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59173039"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59173039"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:09:40 -0700
X-CSE-ConnectionGUID: dK6V/YBAQ66/wK2gq+merQ==
X-CSE-MsgGUID: JVNUt0VySy6Fp5IShWr5XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="175668808"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:09:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 08:09:39 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 08:09:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.50)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 08:09:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9FvVTilrlYuiEHWig1UwKtq4VSb02E8ONRsBOXg9HHIbn6+1uYjhO7bBK+YZRVzVt5eWIOoGpZEXQBK5hQ1Og0InSCNopUA05v6MSb3jNriRG3fnTqqF4Tyoc5m2i0PwSfVpG91R/PaXuHLYIHQ2828bpnsKjfl2vZv7g6wRNftX+KDEojEwYnklOfnRXMui2DBCSiiiCWstVqqdm4KkThnft3vbdqFAbzY3kWWxGpnD+mkEhxvHl/0Ci5mM4P9EwWv23oJLPREQxf+OgkXAmKo0eqIicTQmF3tyFPhXhBNsEQ+q61pc89EAgpeVsRuw8fWw4N44D7/pA3b8ckLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bA9oh4nrjpHND7LuiTJrD43dOx70QneePXXUp4Ts5UI=;
 b=x9yQPmO9PSwzFMpNlLND/hwZ6O5KXxz1qO3uZPOcArE9TZHp7vRbh5hdmbeZN9khru7riCpDByTsDxNMiVjcPsPehNm7kNG4I06DBTtgUB53NtV73Y72I9sHoGunKBZvTjQyAwHDHYbFq2HPgj0ElRys2qZ2p3vlcRVYQe7MyBFUYX6afgNNRjBzFOz+Y/zMbtLV/UigmdxtzIoJEpDfpV5cZ2/LYa6F86WIh7rBD5+yEGPFOR9FUlDgmRMGCT1Xz0ERb/zG9NS9gJWMmOJ6/bEwqe83TIl3TdiLZtj/cbpJgsP7lOoa44zGJMHBiIyVFcb0SAKNNXitKgBDWKiaEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH8PR11MB6803.namprd11.prod.outlook.com (2603:10b6:510:1cb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Tue, 2 Sep
 2025 15:09:36 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 15:09:36 +0000
Date: Tue, 2 Sep 2025 16:09:28 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	<qat-linux@intel.com>, Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: Re: [PATCH 0/3] crypto: sha - Implement export_core() and
 import_core()
Message-ID: <aLcIqEoLnyEptTWa@gcabiddu-mobl.ger.corp.intel.com>
References: <20250901165013.48649-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250901165013.48649-1-ebiggers@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB9PR06CA0017.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::22) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH8PR11MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c7f4b0-88fb-4420-842b-08ddea32bb04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?F1jhgjwlXsUzNd2VVD5SBgAqLT3Rjoy0GUvw3+2kMDwbx8q2cgIFOS9kiPig?=
 =?us-ascii?Q?tsjtlK6/Qj80EZlIz5TTU3RUbBthTljldZxLeaibG5gW8ttsoe25+j0kCaMX?=
 =?us-ascii?Q?h19GFdAXgdgPLm+D2rDeN+CESl3rDCVygYmX+YWLadiWuO97Tt3r6HpEPIRJ?=
 =?us-ascii?Q?3xXaKjbA4Xv3Vro3rIs6Zqx0TPMHHS3JkhXpH8SSCT8Eavc52cJbSRl4WjYu?=
 =?us-ascii?Q?HyqoGP+SUPZhI9ZijaxV2UmtbkZKiQluIxq40f4W5oTCJY9OHgWAJK+Hx1DV?=
 =?us-ascii?Q?TLJnft1Ei1vcHqWO9zzjDeIoClSLztlcg6H5DERB6/pzJluiuevQCD+iwVap?=
 =?us-ascii?Q?3/tCsrccM+LzbUik4zUwcQWa/kutw8HiI91TcKkgT+AFA8mAVyoS5K8epUgR?=
 =?us-ascii?Q?zpM4UrGT/6RVb+VDSmfq6zrM4cHPmiiQHUpx8UYK9HQtMlecCiOjlXb7sPe1?=
 =?us-ascii?Q?q8aQ5e6nVapXGjCX1RGvYqfI+TQcAysRdbmP3yZ/ld0O8izW75B/+uLCNmBg?=
 =?us-ascii?Q?QB2mwI5s9zkvDulFi5Y+1lVvF2tK5zvXik5O/CrFIp6DZvCIVL23HRLj3OCh?=
 =?us-ascii?Q?rHEXEuU32g+802ORTK+1CC+TD0gJ0ounCDZdkOL9v9n5suhQPYJtMbkQ9ulQ?=
 =?us-ascii?Q?RdbdYWyf311bOTtF6sAZ0V9fByr6UQX7HRedyn3I92H+VuXVkWoCHMJYbtX4?=
 =?us-ascii?Q?dlMN8AP7hqrISe/X4sK41DDS0U2ZAUpHsxqfaY1WMQFxvoCWSaZKYAmVnP1c?=
 =?us-ascii?Q?Gf2zCWiUUu+FJKWUQvI9cwfQqOv+D7E3HPa9RRQ+52egVFEabgi+cbGKCuFG?=
 =?us-ascii?Q?vfbPH7ae9d1sm2GaW+TudK9kEe9LJ5ehITbUbHIXK9uWJd8N5ZD8mmPaODDP?=
 =?us-ascii?Q?qECwwvfC82vgCOUwPOybw2NXhAF/rYQe/XUS2I6DRwxtJYsdBw0hknhHqK4m?=
 =?us-ascii?Q?J2/EK41CTKkcGbQAufp035AXdobj/4w7j6k7RhT2pTxsHEm7k7R+etC2W7lb?=
 =?us-ascii?Q?UTs+a0108bFDKWqqKgC07UXS01f9Ygdse4KfJtY8cyrCUo6ToOuyl3ZqTx32?=
 =?us-ascii?Q?Mg56hNDxuhnokkrXExeDKfCx5d6+z9dpZ4O3wcINM+52r7e3fYZyryUJMjHk?=
 =?us-ascii?Q?usnhh29k+uM7r7Ih2lcoq+2QGByyA1YSJH3KXy6ibhoOy2AEX6JX2hba8R+D?=
 =?us-ascii?Q?/wEyByiprSnBzL8aBwsN/cupEyQGFvdW0boV34bQ08kDvc0i1Vq1wQrbRpj7?=
 =?us-ascii?Q?KTAIqvnGuDUlOLBo0axdw880ct3fAw793CVlSxqJYDyLnE3r96Hdqn/kGE2t?=
 =?us-ascii?Q?EBWFANDqH12RSzx1ECKEPZkZDwQmsY8qaJsgaXc1l78o2YYlMJV0C29qCJ7+?=
 =?us-ascii?Q?VwR5IFdwGkkZLwIwqgTH8G36pwA0k1YbS0HhvPg9fSRGpt6Meg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?226KBjqu6U75HHs81hmXDWoYeHYe4RdzEf6wsSgCY+3pbyfQqMOOQNn9PizQ?=
 =?us-ascii?Q?RA+Qoc8YNjKxcWdcA2LzFd+Rd/A1NSsTxyMxzNgQARhoRwAL5dnFQ7imm4Mn?=
 =?us-ascii?Q?zKOR4OuvCVk6hWt/6yLhqO/ndyifI9sXvd08d+YHPKnQcOD+cAaB3BxbPmtJ?=
 =?us-ascii?Q?G327qpNtaaT21h7L9KEgZMDLRzbzjr7gopu9BbvUC/LPGzQZ9+GOnTRm6s1Z?=
 =?us-ascii?Q?ntHlxFr3mw0GOEKfYSRODtHvpbJUoOe8EG+OKDy2dv+fb4TL6KrtC25movxN?=
 =?us-ascii?Q?OWQasKMuuODo+QX2BcIVmZ6n6mL41h5XyIPmVnwiJP47yu9/tpo7feWbgglZ?=
 =?us-ascii?Q?TT5OkhLhZC4e0KYsaAH2TYtUvp5nAtPPkTSIhiBlnISFy+EqTrpKy4Fxd3q9?=
 =?us-ascii?Q?rrfohKmfsshDMLc1b1aboI8NKOIiqSOWZwyqo2EpWnHJkeGkSpL/rAg5hk6n?=
 =?us-ascii?Q?Y/EkMT+gxExp2PEI8K4F1jNPJ1abbhvWzVmbm6e4v+/jkHyoLOW21fwbYsuO?=
 =?us-ascii?Q?S+t1mblEUjLXew86g7ncQTZXmBx177MpbIHSZlOrqyQNTIUYJ6+RnEQFowM0?=
 =?us-ascii?Q?s2HQR5cuClfpSZbesOQ2o4slC3SVdz5n5856wkiDPc236TFT5Z0T79tOi5sA?=
 =?us-ascii?Q?2l2H3fEcTb2CQ6ZXP1gMiXmzikMSRV7MAgkiDrtFl4jtYrqMsSM7OuiEiMcl?=
 =?us-ascii?Q?jUDhK17eIxekKjhg5gkPXH1WN7FLcPbGqC0skZyHYj3sQuQYB6bl2o8Acgil?=
 =?us-ascii?Q?uvcqwRPPVQc8wGIUv7+ondkfxkVLGj6lBeXshurAd8TaiHDmGPNEVk+MKBV4?=
 =?us-ascii?Q?kVa1Q+Opuc0tKceij+AyOAZopSBwMuORVKsNxLmlkY70JZBjHh+IPh5x4/AN?=
 =?us-ascii?Q?OH6th+3FfJlDwtLCiZg4Iy+MiAVQzOLUXDsE5JV4VCwulrG92wLGkcflPoFm?=
 =?us-ascii?Q?7Noqep/OjxZxyM8bW3geyDzlCrmubEaLjY8JcfyTw7kLjsaJDoUrtqmtdrzA?=
 =?us-ascii?Q?zJmneajMRP33pkLYSgIv2deS5Ou/NjDFwEwSvCh0GP6wfbyDqevbejUeyrlR?=
 =?us-ascii?Q?WMDpdPZE2RmkKjjBWfpE9DS+3FoevRltu4wkwgKO84x9qz5TguT6KRe9Vg7V?=
 =?us-ascii?Q?E4jZDZdzGxF3Gm9M59lzivZVQMxdq/afb1g+N+Qwx5Lr7IphcJD6wV52OZef?=
 =?us-ascii?Q?sN5Wm7f89eySH362aEmbwWKknt/xsT7p8pq93v9RaPM+AqrdWaqm923GQLo1?=
 =?us-ascii?Q?odnx+t8qFA9jbcgJi7F04P3niprwITwv7/EFlmuvapscG6aVNcGoAO02S4yD?=
 =?us-ascii?Q?6dzc3o/CzCx7++3FTHeyzXH+AD4NX9VfaW4wn4e9ZungHbOebwGA+34KUCO6?=
 =?us-ascii?Q?AEBMqrrPv6KmoR3Dk7o6r/9UDfGQSzwpW+COOWxzpSRfcd+YsU/dLm9H8Eko?=
 =?us-ascii?Q?qJDmhHb+krvmUiXg/9k5+fF+WANgkwon5oqwvrHpWMdOIJOzjCeEOrwHO8LR?=
 =?us-ascii?Q?iP2CE31Of/PhLDrFO+a/hsoPUA3ZEE9Un/Q7JvSnAaklV6LVoay5t5yxEv3c?=
 =?us-ascii?Q?hLUTyhAOJL9TL9OxCws1Sf+k4oGX6MxCzeua4xw7kLaUu89++afbUEuivFUU?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c7f4b0-88fb-4420-842b-08ddea32bb04
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 15:09:36.5989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXF9/xAN7oHAGO/4gdSo4J4q9niw9OcrzCWCRYN9zbZoDz2Wwgs6f87HRtpH5wCSYf5uv3AUr3Tm6Sqa8O9DkpFcY3uufsvfuxzZhynsvbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6803
X-OriginatorOrg: intel.com

On Mon, Sep 01, 2025 at 09:50:10AM -0700, Eric Biggers wrote:
> This series implements export_core() and import_core() in sha1.c,
> sha256.c, and sha512.c to fix some legacy drivers.  Unfortunately, the
> Crypto API partial block handling changes that went into v6.16 made some
> legacy drivers start depending on the presence of these methods.
> 
> This series is targeting libcrypto-fixes.
Tested with the QAT driver.
Feel free to add
Tested-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5E217F50C
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jul 2024 11:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721216825; cv=fail; b=S7WnfTgBcNxUnbnzJmtnGsH4fyDeqPKlzczuTLLd0ka0nYpakO3THd9v7VpyC3cxeiWWi2b5oEdXbxkha7mp028EX8DWZ2ClLxAVOx5pnDGtYhiEl1ASMGdbxqqi18dBxsZzdmbKZHa7xBtAYVfCF+UKD/nAJaN3q1evTOpIe1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721216825; c=relaxed/simple;
	bh=TKqXMUAOuYpdX1YLzxSKpzRS+v2n+QeQCp6nc8LVJtk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nra1+tVSnlZH0UclAzPraqqUs745lXcQeRHD5OMFSSNb3KHIPzdyS5bSPmYJU7yEQHEs0eaJaTXlZz9FdJ1yTanxflOxiikTLMF26MIEclVj6OYu8sLvHU4n2kgskG7z3EJYXcWW50nur8Zd5mLkNnFrSsYfdoMNnF4/sUrrNeA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYhtEHXX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYhtEHXX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721216824; x=1752752824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=TKqXMUAOuYpdX1YLzxSKpzRS+v2n+QeQCp6nc8LVJtk=;
  b=JYhtEHXXbkt5Y+iAqowyJQoqQddHh053iMIC0APTUFGL8WfqvTL+COpa
   NP0gQ48mJGzIc8HHcxeiS8aPjhOAUFuecv30fd+Pu83XJ+F+DV9buPVG/
   xE6tZhUfESVqmiGETSohKrjHoju4YUdBk4WhrZWrhjWL6jMFVqXOSZyh8
   GNXFI8Uh7gCdu6F/rUV70VJEWIDxl0A059WS9nC/IIeetNuEDLX+dx6iI
   XYhzkPRdXQkpGMGJpelLyhnvgOVCGyPsH7rxw6j/M9jpOZK3roOMYDaFb
   vGQiPihG8hB2rE9nSopAr2lXTJX1lHDe1Bq57ctIonloMafRXzG3EWnDR
   A==;
X-CSE-ConnectionGUID: j0HxVE6sQVSnp1Nuf6T4Sg==
X-CSE-MsgGUID: S7EKXem3Q4eqDEkdivKOqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="21617747"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="21617747"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 04:47:03 -0700
X-CSE-ConnectionGUID: cEeaZa52Sqe3esg2tisgEw==
X-CSE-MsgGUID: VCTf56JPRcW3w8HDZ8pjfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="81406974"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 04:47:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 04:47:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 04:47:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 04:47:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdCh6mjiw78HhxKjJ4oT+xgjB9wVRr+0mWgQ/ngKBuJ8GMNfUlo6PptQoD+ptdd58qxPYghBD/dxBQJiAN4+uMfh4izkmlEvU3rmtN0onS21PHxBYgzLmuj6uVa68nb8X0zj/xZmqepp4dohKgl/djNh+Md7E3UCi9sCx9klF5flyu5kG7lbWD7TLlh/fr7fJLC8LfG4Ifk1m7VAziYJRWWsm3ZMTEva2ezpIzBEGABQPXhm0buYEsuiyO4hf71ADcWwb1mo4whrU815AbSzVpaCRXkSsBkadsnsizGBA/TdqLgVZnBCGxWCLcxL7rT1SL7NtHul5d+gG3xcC7+z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOKp+VBY6/NEXOl4bbh0EI8plq3/VXD0cc9pnHqrr0k=;
 b=DAiBf7tZqzKMzt6oQdcI8zjY520vZfbEA5NvbtLfZJzSMy6jIRspJeB/8S6LKn6bbZDzFWTzkTr1lsokKetgAkTjirZkXuL+ZEgzDwL05hO2b69mISKQVq6cxyzGm/hU1t6py9gELEJCwaHkcVBnDyEkLl/jckrS8ToXkjqIeS6FWeCxeqze7NZZGTYAoNWgfdGGanMS1Z+E1NndJNLx/EukhXvnhHzYYokdWfGJYUj3xSRNIs87OHMOZyApt0dSZQWg2ADCYkuJnqq/ZwIHRO2IkZncKESQeQwEKNQiDRx9m4IHZ5a1JXkqmkwXX2+IUhLmMfho8RpvePSzrKJf6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5830.namprd11.prod.outlook.com (2603:10b6:510:129::20)
 by CH3PR11MB7794.namprd11.prod.outlook.com (2603:10b6:610:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Wed, 17 Jul
 2024 11:47:00 +0000
Received: from PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6]) by PH0PR11MB5830.namprd11.prod.outlook.com
 ([fe80::c80d:3b17:3f40:10d6%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 11:47:00 +0000
From: Michal Witwicki <michal.witwicki@intel.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Michal Witwicki
	<michal.witwicki@intel.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH 5/5] crypto: qat - allow disabling SR-IOV VFs
Date: Wed, 17 Jul 2024 07:45:00 -0400
Message-ID: <20240717114544.364892-6-michal.witwicki@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240717114544.364892-1-michal.witwicki@intel.com>
References: <20240717114544.364892-1-michal.witwicki@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DBBPR09CA0046.eurprd09.prod.outlook.com
 (2603:10a6:10:d4::34) To PH0PR11MB5830.namprd11.prod.outlook.com
 (2603:10b6:510:129::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5830:EE_|CH3PR11MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c1cc8d4-b15f-49a4-9efe-08dca6562b64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?scGfeSJ+rCenOkm4Bg/9Vv4tMjPOhi576JeRLgDmVjhP2uPFbkPCd/QuC0al?=
 =?us-ascii?Q?hSrwy9bKzwRZz0KptqGnN7zOCk+j0OW1TePJ1806JT06GJ9i5l2aV2ldeYU+?=
 =?us-ascii?Q?a+0pKe/JqT2c437GD+dNHF/92KNBq4HR2WlteyrwzbEZ/VFubOIDB9u6SiUW?=
 =?us-ascii?Q?1Yj/QLxdBdrMvr0aSSlTKLwcY3LS16obSydZZgdCJSerWL7v0wRrdnHe6mit?=
 =?us-ascii?Q?YUzvVuNmGWP9o6SUrZ0pRE+r9HuI7fs5/ZCniBBNhpHqgq3mbxGONfPVMO/a?=
 =?us-ascii?Q?2vlZwmSWPULCgc7xPL6f+51ERyNZalOCmNAgv3Kd1el2W8UQYnnBaWQzhty6?=
 =?us-ascii?Q?WRREuJlfzXIWIYo9i7ITT+6F1H8p5Kh3tvMw13Lp9B/OOMAivTANB4Sh82mD?=
 =?us-ascii?Q?otBKSROi6UnGPjhLzumPhtKHu7q61O8k+N7R2cWPT6xO5jm7tps7QeqJkkoT?=
 =?us-ascii?Q?RPaHDYP68DpS5dWGkBdQRleACaMs+HUNgFpNnpd3Zb+WGJceO0DP98UCsOPW?=
 =?us-ascii?Q?4TTjOaCqk9tXt9Mi1LRavwM5YuM70Uvxu93FZWjgeR5ZbLJCFCf1YogiXcyE?=
 =?us-ascii?Q?7fkzVVQtBXFWcTNabNt9GdTJmmZEkhyDX7N27oMp8e/F+ig377aTeAuHjHHX?=
 =?us-ascii?Q?ZDWO5KSmk6ddXUPUdRqttueK2MUCpDTE/4APNKqRZFx8kC8WAUUXGJLi7Uas?=
 =?us-ascii?Q?hV1+p5CH/4oo1zg8W0BeR2xLpZiLv9lJkhninlw+oP3152aNosLvcz0uBmaU?=
 =?us-ascii?Q?CzAglrrOcSxaN35esBtU/iIVmoQSfHWyVfSoa7p+31cpEnHVRAM3uKsOgn3x?=
 =?us-ascii?Q?SZ7t4f4pPuz9NLoTjP06VtnO5ll/tfGqZJE7xEbjkn2rZuL/xvks+Z/7eL4j?=
 =?us-ascii?Q?PBcw1+0B5jFv8MyjeD03vdmj/Ubpr6EPtVCcAlnkHgdX9UpEL5hMTvf0T4K9?=
 =?us-ascii?Q?ndVNoxW+lRfu9ndU3K9CTEgICqvtGJbYDBo3m/hM1bLP96cgaA0NiEA9njSF?=
 =?us-ascii?Q?hBIHuQGR2RGoxgbNcC3kj7IQFYniVy9sTGE4N01avl11N7J4z/BLlpxZZXG1?=
 =?us-ascii?Q?++rW2PqrSvjy8a8/eyouxTyp7b0mSDhdkst+nM0gFoHUsrjLLCEaYRBkFdXj?=
 =?us-ascii?Q?+j9Gby/nAw8p6glM1rBXk/KOm4jKYpTfL8tZQm4BkXPUAY3p8QySoh0m0yZG?=
 =?us-ascii?Q?lxfCAdE9GAy3tQRhDQ7bOqAX6Lfhe76GLotxnLqNyRiZR7tba7X37t3tzUZS?=
 =?us-ascii?Q?l/Z47kkgX+9lFrIvdtcKGGv5forST147Vj7pxrPMAT32cFlLx1PW49X1gGoJ?=
 =?us-ascii?Q?5/aGVLhn/gCZEkQOKukG6ZQbBHUJpSEcXafiPkvBO0vM5A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5830.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6t6hgLS1LaPVUpXYPs7d5Xz3/aNzPAIKzIpuE9tAjx5xo2QMPbybsxhSerTb?=
 =?us-ascii?Q?T8Fc2MHMEqFHXnGNF6ktZYE0p3iYGc38+IObnqPsMZ95j8IPgEmXLZoI0Uus?=
 =?us-ascii?Q?ZN2UY9FhbWYgpXSHVFvO005x1bKvAqzyCwXCvuzrC6vl3dVTmrf6YlA0GqNP?=
 =?us-ascii?Q?i5KaTQanadG0w2CNHxWO9KKnQ2nZAWHsFCGSXiDWeKYRtcs6QpEHg7t4C+Hn?=
 =?us-ascii?Q?Gam8+IRoQogaSmZ3opbFLx+m7eFR17HVjdq0OrY1WNS38v9WJEHAIlZYg3LK?=
 =?us-ascii?Q?aZjUkgIzdi7XAizqri/6luC5IxVE29FKX7Lo/+rbBuu9sKdvbJ6zM+r2hBkk?=
 =?us-ascii?Q?1pfcNVCETaFnUdeuGIIicfKzUTiUNDMkJpLxpiLRn7q2k9mKpQXt/SyVke2u?=
 =?us-ascii?Q?ljTnGLceVSSbuQSUfL5mjnRgXUyWyTYH9VX22BrbFlFufOI0NxzhXFhREqTq?=
 =?us-ascii?Q?CGSausAL9/1qvzzy0dhdwLd67wro2SpAS4P2zDQAGdVXTWFYAmoxuGMOJovC?=
 =?us-ascii?Q?M8DkY7GSCs7+IApdAiQEaWreCzHIyXF5M0YtqWBaOiXWlczIu5yjGQ18MxuW?=
 =?us-ascii?Q?DvJXn+waxFvYqyVKmqTv8620C3IJFIMCfO/45k66Tcab8VFfX8nF8eXYfifo?=
 =?us-ascii?Q?Z8OTWcXvVhC3xrMTXQeZ0sPqn3Se2TP8Mwy0Guyo9oet/Ld9Z9K3NqQE5q5d?=
 =?us-ascii?Q?T+vVBsDMTx8nOV0ubU7r8FfNYydtDc2yiuUjCszjt4eTMqw+S7s7c1OVmHG6?=
 =?us-ascii?Q?/hMVJIGcfvMS2l9+3vJ9aVXfn+8Bs/GmYfQ5EUFhi3b65V6/QUPKhkDGlIen?=
 =?us-ascii?Q?v39uapun458DUqeRXsHktUJWhSoB5TV0nf1ZXBVoqz0NenImX9Qq1aht7e9w?=
 =?us-ascii?Q?BzDbJKB7M9Fy3CB0ySVD2RMNAVo85rOeUnuAaY5VCUyRnpPVcNeKVbde+tBq?=
 =?us-ascii?Q?4MS+IQ9yZOV9FDzaHOsPqROfDMCHkvefc9HmL7rbLm2iN1w33ni9Ig5lM9Lt?=
 =?us-ascii?Q?r95kgn1Y0gad22r+MDY6cSNCkN22yBdAf1W9p3w4YG953tkx7YcHs86rsA58?=
 =?us-ascii?Q?Hy4izD/d5Yt35a18VBPy1ZMQyDifVjj0n2oi8cEl1f/ULMEwizNYCITgsJ5/?=
 =?us-ascii?Q?55fvoK7FLyqd/LCgqgq8b6m65gebdRFm1EY+YUw06T/QGUypiW/pJBwuzwf4?=
 =?us-ascii?Q?W9SiysYGysPXrFULAqEKUbKozcrEBoZcGDseY0jEswowbrS+jbEHtKBvhqNc?=
 =?us-ascii?Q?GEdvFxebnIJDQLGs8PBL25U5bDn6iku1gES3RaYkXBBwUkbABAQctcOZeDHI?=
 =?us-ascii?Q?HGtPRYx9tta72St7v4KSchE9NlxxDLXImVpqeirPIqTOCOAP2MC+/r7nkmUE?=
 =?us-ascii?Q?N6FXlt2LBwG/pMenPEMcGK+/GhlhcadtR3GX4PM5F15pqMEvHSUZYCYqtdY/?=
 =?us-ascii?Q?CEeZkQ1HEgzgDbEUTcTiSpknTzOZV9AvaKJHwWvtaRdUN4cY6MvqDnxpP3WQ?=
 =?us-ascii?Q?BFicqk1Hw0RVhFf1FGF0QbJBE7XSMcBWOL1+RYg4+hUs2xiuN34+k25vmqkd?=
 =?us-ascii?Q?Da5N32f4Csq1R6bALLJ1LI6kmKTUSPLp+WSqGGS5NlviaA4QDs5e4Bv5Lwr2?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c1cc8d4-b15f-49a4-9efe-08dca6562b64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5830.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:47:00.6450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vViLtKXPiuGw04I4WHl5c7zS0/8xfrR3rATWb8625K8AGzAN/61D05fhwIADpKYFBLz+Cal6XgQwli1F0p6fxKtoOZ6VLDr8MWb0lNXP38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7794
X-OriginatorOrg: intel.com

The QAT driver allows enabling SR-IOV VFs but does not allow them to be
disabled through a write to sysfs.
Disabling SR-IOV VFs can be only achieved by bringing down and up a
device using the attribute /sys/bus/pci/devices/<BDF>/qat/state.

The documentation for the sysfs attribute `sriov_numvfs` specifies
that "a userspace application wanting to disable the VFs would write a
zero to this file".

Add support for disabling SR-IOV VFs by writing '0' to the
'sriov_numvfs' attribute in sysfs.

Enabling or disabling SR-IOV always requires adf_dev_down() to be
called. This action subsequently leads to the deletion of the
ADF_KERNEL_SEC configuration section. The keys ADF_NUM_CY and ADF_NUM_DC
within that section must be set to '0', otherwise, the driver will
register into the Linux Crypto Framework. Because of this, the
configuration in the ADF_KERNEL_SEC section must be added before every
sriov_enable.

Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_sriov.c   | 194 ++++++++++++------
 1 file changed, 128 insertions(+), 66 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index baf2e1cc1121..c75d0b6cb0ad 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -86,11 +86,133 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	return pci_enable_sriov(pdev, totalvfs);
 }
 
+static int adf_add_sriov_configuration(struct adf_accel_dev *accel_dev)
+{
+	unsigned long val = 0;
+	int ret;
+
+	ret = adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC);
+	if (ret)
+		return ret;
+
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
+					  &val, ADF_DEC);
+	if (ret)
+		return ret;
+
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_DC,
+					  &val, ADF_DEC);
+	if (ret)
+		return ret;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+
+	return ret;
+}
+
+static int adf_do_disable_sriov(struct adf_accel_dev *accel_dev)
+{
+	int ret;
+
+	if (adf_dev_in_use(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev),
+			"Cannot disable SR-IOV, device in use\n");
+		return -EBUSY;
+	}
+
+	if (adf_dev_started(accel_dev)) {
+		if (adf_devmgr_in_reset(accel_dev)) {
+			dev_err(&GET_DEV(accel_dev),
+				"Cannot disable SR-IOV, device in reset\n");
+			return -EBUSY;
+		}
+
+		ret = adf_dev_down(accel_dev);
+		if (ret)
+			goto err_del_cfg;
+	}
+
+	adf_disable_sriov(accel_dev);
+
+	ret = adf_dev_up(accel_dev, true);
+	if (ret)
+		goto err_del_cfg;
+
+	return 0;
+
+err_del_cfg:
+	adf_cfg_del_all_except(accel_dev, ADF_GENERAL_SEC);
+	return ret;
+}
+
+static int adf_do_enable_sriov(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	int totalvfs = pci_sriov_get_totalvfs(pdev);
+	unsigned long val;
+	int ret;
+
+	if (!device_iommu_mapped(&GET_DEV(accel_dev))) {
+		dev_warn(&GET_DEV(accel_dev),
+			 "IOMMU should be enabled for SR-IOV to work correctly\n");
+		return -EINVAL;
+	}
+
+	if (adf_dev_started(accel_dev)) {
+		if (adf_devmgr_in_reset(accel_dev) || adf_dev_in_use(accel_dev)) {
+			dev_err(&GET_DEV(accel_dev), "Device busy\n");
+			return -EBUSY;
+		}
+
+		ret = adf_dev_down(accel_dev);
+		if (ret)
+			return ret;
+	}
+
+	ret = adf_add_sriov_configuration(accel_dev);
+	if (ret)
+		goto err_del_cfg;
+
+	/* Allocate memory for VF info structs */
+	accel_dev->pf.vf_info = kcalloc(totalvfs, sizeof(struct adf_accel_vf_info),
+					GFP_KERNEL);
+	ret = -ENOMEM;
+	if (!accel_dev->pf.vf_info)
+		goto err_del_cfg;
+
+	ret = adf_dev_up(accel_dev, false);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
+			accel_dev->accel_id);
+		goto err_free_vf_info;
+	}
+
+	ret = adf_enable_sriov(accel_dev);
+	if (ret)
+		goto err_free_vf_info;
+
+	val = 1;
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
+					  &val, ADF_DEC);
+	if (ret)
+		goto err_free_vf_info;
+
+	return totalvfs;
+
+err_free_vf_info:
+	adf_dev_down(accel_dev);
+	kfree(accel_dev->pf.vf_info);
+	accel_dev->pf.vf_info = NULL;
+	return ret;
+err_del_cfg:
+	adf_cfg_del_all_except(accel_dev, ADF_GENERAL_SEC);
+	return ret;
+}
+
 void adf_reenable_sriov(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	char cfg[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	unsigned long val = 0;
 
 	if (adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
 				    ADF_SRIOV_ENABLED, cfg))
@@ -99,15 +221,9 @@ void adf_reenable_sriov(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->pf.vf_info)
 		return;
 
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
-					&val, ADF_DEC))
-		return;
-
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_DC,
-					&val, ADF_DEC))
+	if (adf_add_sriov_configuration(accel_dev))
 		return;
 
-	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 	dev_dbg(&pdev->dev, "Re-enabling SRIOV\n");
 	adf_enable_sriov(accel_dev);
 }
@@ -168,70 +284,16 @@ EXPORT_SYMBOL_GPL(adf_disable_sriov);
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
-	int totalvfs = pci_sriov_get_totalvfs(pdev);
-	unsigned long val;
-	int ret;
 
 	if (!accel_dev) {
 		dev_err(&pdev->dev, "Failed to find accel_dev\n");
 		return -EFAULT;
 	}
 
-	if (!device_iommu_mapped(&pdev->dev))
-		dev_warn(&pdev->dev, "IOMMU should be enabled for SR-IOV to work correctly\n");
-
-	if (accel_dev->pf.vf_info) {
-		dev_info(&pdev->dev, "Already enabled for this device\n");
-		return -EINVAL;
-	}
-
-	if (adf_dev_started(accel_dev)) {
-		if (adf_devmgr_in_reset(accel_dev) ||
-		    adf_dev_in_use(accel_dev)) {
-			dev_err(&GET_DEV(accel_dev), "Device busy\n");
-			return -EBUSY;
-		}
-
-		ret = adf_dev_down(accel_dev);
-		if (ret)
-			return ret;
-	}
-
-	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
-		return -EFAULT;
-	val = 0;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, (void *)&val, ADF_DEC))
-		return -EFAULT;
-	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_DC,
-					  &val, ADF_DEC);
-	if (ret)
-		return ret;
-
-	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-
-	/* Allocate memory for VF info structs */
-	accel_dev->pf.vf_info = kcalloc(totalvfs,
-					sizeof(struct adf_accel_vf_info),
-					GFP_KERNEL);
-	if (!accel_dev->pf.vf_info)
-		return -ENOMEM;
-
-	if (adf_dev_up(accel_dev, false)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
-			accel_dev->accel_id);
-		return -EFAULT;
-	}
-
-	ret = adf_enable_sriov(accel_dev);
-	if (ret)
-		return ret;
-
-	val = 1;
-	adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
-				    &val, ADF_DEC);
-
-	return numvfs;
+	if (numvfs)
+		return adf_do_enable_sriov(accel_dev);
+	else
+		return adf_do_disable_sriov(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_sriov_configure);
 
-- 
2.44.0


Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2114C314A82;
	Fri, 27 Feb 2026 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772194877; cv=fail; b=snLfcQFd1c/C/S1hNZwm/RITVRBG7FIKwehRglR47a9Yj/siDb6rdqEqX79b5eSLV1j99A1M9fch+BEU/JB/AhRCba1UukKLMgX77IW3PlpifuBTLDAwJPAY3Uu5fZZ5khzsc1CAkq8sKIxNlMHKaTfNYPT2vz8f1ZVuV6fJ8tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772194877; c=relaxed/simple;
	bh=ySQwdds9OXF+xsTQfrTuUiWeSyKwPTQtyrkydxAdzhU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XjLD6SUB1LiNKVl/UmN0bJkVHfRXbFS3k/F5QMffxyhIukMDYk3ozyVRyosbeg+AgwBnVaeytsKttgD0adwWuDrPd9oJie/opOwVspVyYArY7FmCq+fxMI+I/gOJdJygnF6QvXdap6j8+fktA6s7lt6SAGH94hOlupbvMwjLHFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VfxAHT2p; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VfxAHT2p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772194876; x=1803730876;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ySQwdds9OXF+xsTQfrTuUiWeSyKwPTQtyrkydxAdzhU=;
  b=VfxAHT2p3wpVqsUT6V5K3L4luPb3GY/eaJgDAZnVR2t0aPHtCMCvp4No
   ZWgIWRgdkD8+ETVbs+OdeOmRqTd+VerJXyA32/Qj+xtavvqd/9M/h4+wQ
   UOU8B28/JWxSVyoukVgBZBHVp2wZeBm2k4DS4rUZduTjF7iLq2E+1z62y
   OT1tnj3Jb8hWzr3cw6n1P/37vHzP9mIDjgXF7Pm1kxu2dcGHNq3N/c82l
   agJG+oW3zNhsXK7PWgv4sWXpY5XjqOD/+mMk1t+hAcTL1JliD2sNOFHdl
   TBIJQnj3V0o8qdv/kFBzMeHTlNrEUqSVcTA15S/M/LEhsNFuy7vsss+6s
   A==;
X-CSE-ConnectionGUID: NEhSy9jQS0id+6ptbbzeNw==
X-CSE-MsgGUID: e5KZax6bQhKQ1CQ2+X6jgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="84738505"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="84738505"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 04:21:15 -0800
X-CSE-ConnectionGUID: TA4DFNMTRzeU0GjtmdNYkQ==
X-CSE-MsgGUID: qwOuC8LaRliKTwoLqA0GlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="215055880"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 04:21:15 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 04:21:14 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Feb 2026 04:21:14 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Feb 2026 04:21:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drSnpINnOlA1vAL5yZ106O44vJ24ANF8aiv0PxV0Ff5psqsD2YbsLxcbhgX9LgMpsqCXltLK32g8wDEA9YJEnHfdwK9/em6czCb8CpM/P6FmGPPA6VA+7mVTXe1E4q0FreoFSW2tLpK9EEGzpXoazlovJH5OP3Y2+UfP80U+kkr3BgsFCG+vNnF94SL9IYRG85c7u6Kz8/sgTR9XWh1GJYQw1NZIuLGWdBv+vZs3X9OPXNnzLT1JAPFxaLvC4xFteK4OtnTN5WCk8t3E0vqJYeynqUUGhauPiwI2il7XWcUGNb+6wHZ50+3OEwJ6+iqoPV49w/608mdNbTLQHMCr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIOJWasKSRuPkEK7xDRrJeCxpWFGTL6xjGALjnf5tGk=;
 b=Xebq1S7/DMFy3rV7eTysJHlS5G1K5DzmD7J5yFFemSMo7p91076Uzonm+sGJekCjkbrE6rfYWjwWYYr3I+urMh9sVy4K9DdpqRcWfcLHj854+JhpUlPkk3wrroSLI3tNrXr+cC/DY13PmXsA9fq2S0vpNmW0T6EP6eq0YpwhVRiyDOtRZFXU1r6J3Bvnj2CRUGUD3mNMdFdMbznACkEtCoRehpr9/ESluFwqB/hb40oqMUo8mXWwZtvZIUDvmwFkrNjRlmIdUGsHBFih5yQQOtaTfEJOSu8X9s1TMODCi0LMKibAbDfonpYSbJcdu4sIBeD4IFxyLI5U2VLvLXwsHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6407.namprd11.prod.outlook.com (2603:10b6:8:b4::11) by
 IA1PR11MB7944.namprd11.prod.outlook.com (2603:10b6:208:3d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 12:21:12 +0000
Received: from DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4]) by DM4PR11MB6407.namprd11.prod.outlook.com
 ([fe80::26bd:1704:645f:7fd4%6]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 12:21:12 +0000
Date: Fri, 27 Feb 2026 12:21:04 +0000
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
CC: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Suman Kumar Chakraborty
	<suman.kumar.chakraborty@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Drop redundant local variables
Message-ID: <aaGMMDV+MbCopzNW@gcabiddu-mobl.ger.corp.intel.com>
References: <20260227115359.804976-1-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260227115359.804976-1-thorsten.blum@linux.dev>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::20) To DM4PR11MB6407.namprd11.prod.outlook.com
 (2603:10b6:8:b4::11)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6407:EE_|IA1PR11MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 377ad7ca-cdfc-49f5-b938-08de75fab17f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: gGU6Q/LerEGynFOyur8N8Ip1nOHUQnSV5CfFa46MDUvXNDG9m0ScbQdGMIP8C4TXYNAOFNo1TrJZnUSljFYtJXIFHdu6ubitdIXfp8X5w4577qxmcXPbNttjCsm1oRQx3nTX/nk/bnaFmZ8kOf3CZbKzQW/dJr4TAR9+hdu6Kgvb0InMPNPD4COJHKdLAS2QQKt5sDJNMhLc2SrXXmR/BNkFKRGSvuqEI9j6tG+2RyjZ3TZ5KiIUFN9Xt7GolXeyXrsKElYbilSxWkrsq+cJpmjG3pTtLljUIJXr7SwfGPKX8b9NloGd3TU1IagUUDQi8hIxvp+eKzocPcNLDbNrbaU/7SvMGSkr7JM7TNPicRsbdK/QNqnhq3G1pnmLZ+XB09LbeuIxD9j8HhZNV4Qf/Vr/Yn1kodj6kjZ0pxeENysXxy7npczgSs/nlMstmWX64GdtSA7QCndcfja5Hqp7mlZ4+3YD2LsfA6y4iDqR1rtwPVpRKhIeERIBx0fa7R87pO/rPGkp1XbRlrupsM8rLapwQIBh9sOMJyNmbArIUSnN1qMxQg/9tdVLqhwigV8Gi9yJtq5TqEdEf/0RA2aiKfzasIl2NEgHSXN9Nm9EtCG+SJnmhX9y2GWvJ417xnC+o43RbmcvPgDV1Frzm19bC0QX00FuxjdplmuDDESbd/6CS7NfBwLJCytvaYWelAzhZRm2d5u3ffiTdrwQ9yY/gHxjGSQndusxEdjdYcjEHrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6407.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ljQmY1UjrhDtRvdpRUzq4BAqAeZuMDQ9VsaNG3QyzaWrxLbr82WcjGZaEQd9?=
 =?us-ascii?Q?CVygFgrA3yT3sFkfDDD0dwUiI4UQA1BZu+qD9jI7WrAzJfk80KP5mfvEKZkN?=
 =?us-ascii?Q?k4JuN3qrdrbJnDow6bj5Zm2cg5AtsARILmVontqkzmLHM+bKrpyvNDuF6Y/S?=
 =?us-ascii?Q?myizNsqUXwe+bErKCUbxgH1vr4l67+9iKQ7xF7R+rwvwVG6xtyPTuRPBY+Fv?=
 =?us-ascii?Q?ygu80QIXATUsRAuUdITbvN2CwLwcq/epmEHosmCrNsUeVuDNqlWCwwq/a42U?=
 =?us-ascii?Q?jER7DwBVuaz13tnpmXRXOAxbUdwRpsFv/s5TyvPB+dss7Mv5K2JJXc8t/B9e?=
 =?us-ascii?Q?uHf4fstCsMTmrT5Ox3BDx3OlW7OXiBQw15mtocfSUvDWEZSilg+KGtAAKgaI?=
 =?us-ascii?Q?4xD1y0YTexF0z4xw3H28bfVwmj4rXWHRC89WQ7wWAoFinSkGiTDhTDoTUEQa?=
 =?us-ascii?Q?OyudawB4YkstRYG9tolQc70qAbEvU2ZxS6bsmVw4YE2pCRTy0PtmRfa4UhYp?=
 =?us-ascii?Q?l4c/O90jxQG2XBkp/saNazyAsYF6MuQQP1mmPJdvHaM9nPYEWQrYeeyTD27+?=
 =?us-ascii?Q?LkVBGopzCyko2/GQC0Vm68YO74RKgl3WTsZNszwHvGadx9X23XN/xOyOOOSc?=
 =?us-ascii?Q?Os0g/G8QTjpo4EQGqknacEnUF+xWLZSPdc86maWqPc0UroOKhm4vvSliA+iE?=
 =?us-ascii?Q?Ge03dZI0iM2/IAa5TVXE8xVSzqPpwgBDGsebAuS6rxnJnBUZ3a1hdPsXvNqo?=
 =?us-ascii?Q?iVryd7e9Cf2BQmd3w2EZsN7DewglpCSZHJ7wXQyPm9/4/ZCcPjnuHw7708jd?=
 =?us-ascii?Q?Xmc/Y1N0IglUN4Nlm/GpIgcoccmDHHweAXsMWoMqe5YtlBk0TEd1OOTiNwBg?=
 =?us-ascii?Q?4HQUEPbUy10C2ylDivsY0izg7Xu0RBOeFz2YJvjzQMDYAtY69GuFAHbEh64d?=
 =?us-ascii?Q?aDIK9mc9hphTgT1hAlNbodBNbM8ScqljQyRMGj/fktqFHZ9ZtqQrfUdjHpkD?=
 =?us-ascii?Q?m9wYloNP3oMYb1V/pgL451XPC4emXGFVohmOej9+4i0jvGufurJVyjURufB8?=
 =?us-ascii?Q?Q7V2aYKMmS3wmKE74VfeCNrqy2i/Rl4i8WfEkhkWgzR5DgLoe8wLvt/l7MS7?=
 =?us-ascii?Q?JSEeA2HxIf5ocTxyO5iViB5CONMbcsBZLQhhY/Hkj2fNckH+cmRGYekuYJPZ?=
 =?us-ascii?Q?Esggpt8+9KEAT0RitP3bDIiK6bIuOyTJcTkQeOzMQQazGcUUo5eVmwgvSVF+?=
 =?us-ascii?Q?nqkrU3rvA0g+vJIp1fv7waDexqWbggE0t9YoW/B9c8pZjBQQUetNSZM3tWZv?=
 =?us-ascii?Q?Sp+VoOYiJz9KNPlU9iWhutZdHh9LlgVbchSc8eU9lrkdfMmXrmL3YgpU9QfF?=
 =?us-ascii?Q?8QwDhZL593eyzyfbGBbSvZSFT9TMMsMENW3RGKyog5P3798lb/+eI/vZ9JqP?=
 =?us-ascii?Q?3Q70pUcImObShWzD6RTp5oCjRgTGPsxHCYbVMf4wjDa0c+12WDUZR9/fv/1A?=
 =?us-ascii?Q?5SUFaAqUFR1Z0k3d58J6lBOB6H87pMgteT2v7I5Q9xbitkzw4MhQDMWGHuOU?=
 =?us-ascii?Q?2tzMma5r2XNLRWjf8pr3AsJPEmjbb0AfEQ9j2O+ECrfxxE9h6Z3dfHHrB+5c?=
 =?us-ascii?Q?R093t26bDiLg6/hEd6gz1lqz2EJd8dIJQ1UEqeTVE+EHZACOZ/VOEMlGfARY?=
 =?us-ascii?Q?Sq3v6RA3P+fCqW/twwfj9Hg+pSQnVi6MY1zgmU/Cwe4SrNN9nvymZOrLBTCh?=
 =?us-ascii?Q?46hBimJvASY4oeOsKZUA8fASvNrFLms=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 377ad7ca-cdfc-49f5-b938-08de75fab17f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6407.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 12:21:11.9676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gShTI7WhiqMgcOeeKurNCpUEqmTZ+zZNham/LK9Li0jR3FwZ1o1VWPErvRBuvLMIk7helhGZl0xfpOU92UH9pUBQX/d/4q9ZZzIAsxWZWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7944
X-OriginatorOrg: intel.com

On Fri, Feb 27, 2026 at 12:53:56PM +0100, Thorsten Blum wrote:
> Return sysfs_emit() directly and drop 'ret' in cap_rem_show().
> 
> In cap_rem_store(), use 'ret' when calling set_param_u() instead of
> assigning it to 'val' first, and remove 'val'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

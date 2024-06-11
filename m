Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981AF17B41F;
	Tue, 11 Jun 2024 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718105145; cv=fail; b=IeC1RmcXp81FEXjDmhny4+Z1bHm/u6KxSGCJP93nrIorQF/LnBx1koekrUj6YT50yuF5+vLSbfF9TggL6iyqd1EpbFCLYLilX9z0AiLQ8IxmNwDF7uDhZ1MR1Zv5zkKiRZ+/tpAasXAea0a9Fw+AgeRP0PD9WZwqDAnA/oh8WVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718105145; c=relaxed/simple;
	bh=OW37K4axEaaewfbDX2lxyBeCqBMT5KZ+zpErCE9KOOQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=frqKZgUVA+Ef9aEejL/uyz+JtNk6E96Z8AONm9DUVl+br+HN64qZ1rqlc0CW/KPxC+pGnGam2WZhJc4ZFBUM/A1V/CbJrD16/bfZtKCfb7PR7CdGv97Rj370lg7IBh8Gzypd1XYjwL8mn89q1rc8KrU7d2Z2YXustvQAvf1aRPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R1o6EWWI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R1o6EWWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718105142; x=1749641142;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OW37K4axEaaewfbDX2lxyBeCqBMT5KZ+zpErCE9KOOQ=;
  b=R1o6EWWILmQ32pcjkzbWuksV8fwGN7T2unWv5sAN1+z4kdEFkTogRWQP
   ktk6bMPcCzObQuj5FNbwUEoBa8sIlATolTQBD+Nb58Tj2w5T5YeotzzA4
   waI7YrWiuuTSKvlnXh7R61xZOPmb9OxSz0OZLF1tCj6Mpqd4J9tJ7UP2b
   EO37giLOkvSsr3oVfZAFrViVvOmxRHputgh0PvSeAlsmPCNYx5sTrGROk
   GJI7VBlfccObGcY9VkqNvCdw1sqa8DIICXiUJKbFbtafysiTOisTiZ57k
   0NLCu6WJUfZeUVrDKHKsQCT0zAzGiYqu0EW5rWqiowALgaDyBQC+xVty7
   Q==;
X-CSE-ConnectionGUID: zU03+ylRSLOPBXkTIsBqqA==
X-CSE-MsgGUID: dx2jPsUjSjeXi86HZdbMsg==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="14649224"
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="14649224"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 04:24:35 -0700
X-CSE-ConnectionGUID: zKc2dsNmQJSKkwUSHDfIUA==
X-CSE-MsgGUID: ewLgIKC0TpOSNWhPVRRFmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="70199421"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 04:24:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 04:24:34 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 04:24:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 04:24:34 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 04:24:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZN6bVi2myDojD/0128R/viCFzIf1x8hWDJAXezkHBWLiWyjcVr3tbuuuHAG/XUVrbU/8nL6B8AJ9Mr9hqVv7YPzAliCbcUEVJCYf3i0yXt3UqfpJ10OCaqCidB4/iSTR118vCPC7SbsnkXWAteXqVhkMjYm0Y5sNH7QrWAnfvwVF3o+wl8CjFOINkw2GwRJxI5GiRfHU5m6rPcpkjpaqzccdc0oZSSpxWEv51LhOh31oAtubo3/vxzGcgd7RaTW4tKAW0rukUatZvgwRapOr++QlN8pRThgtwUEKck1qWTGP4R8Ny2jTPFAdSq+am9HcLpqTzss/wzvGrwo6inj7Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osQnarIrz4VncYBdYoE9NazOUi9ajmB90+TwzZ0RCJU=;
 b=fWbacSOAIOe0qrkIy9Yw3lI+4A91MHa1OFGJChootHYONTIGrmZV1PMZUfz4mR0paqYaib2bjPa5RjKbnMKQumRuxJzA3Q8EfoL8gr+61qLQYVLGkHPQBPrdPTxZFGEgOIaaBJfE8gwy9vkHrExfc94WpP5gLb6/P5y2pR6n1g9C+0tUhyZC8MAf1XMZj8Bzbqx/Sd0PWoEqZmxTTIPEuW5JpvkPOzplZlsC/DnWza8JsHddMz8Os44m/XNWYQ9Ax/KbTzBB/iqtbLlnTsfX0EIXBUKJVHeB1xaqKGqLi6Y2hm+Y68AsOmuWVG3zy3xnFRxsoApxAkfSLFryY+o3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW3PR11MB4537.namprd11.prod.outlook.com (2603:10b6:303:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 11:24:07 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%7]) with mapi id 15.20.7633.037; Tue, 11 Jun 2024
 11:24:06 +0000
Date: Tue, 11 Jun 2024 12:23:59 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Chen Ni <nichen@iscas.ac.cn>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<markas.rapoportas@intel.com>, <ahsan.atta@intel.com>,
	<mun.chun.yep@intel.com>, <xin.zeng@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - add check for adf_cfg_add_key_value_param
Message-ID: <Zmgzz98P24EU/p9y@gcabiddu-mobl.ger.corp.intel.com>
References: <20240605031835.2916052-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240605031835.2916052-1-nichen@iscas.ac.cn>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU6P191CA0039.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:53f::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW3PR11MB4537:EE_
X-MS-Office365-Filtering-Correlation-Id: e199fb1e-d255-4923-35c8-08dc8a0901af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Js2V7fvrh5/iwkfMfIbUBVo+4T1088CiRR7eX5YO2++gHcgAu2yQyuqzwHUP?=
 =?us-ascii?Q?ai/VhXwDJED8rNl6/rghedgKg5D/j2J3v7N2CLoarjaLd24xehGY4Foa5EPQ?=
 =?us-ascii?Q?s3/CHnpmF1fojEifykqLyBTb/UChgNe+pObnLp7rrDLHHXFFaltdIcscP2RS?=
 =?us-ascii?Q?9cLXoqUtNi1qLThDXTg+CN3EiUJK4vXsG3E/6A9b7m8Gr+ndEQNj2DZmpDxN?=
 =?us-ascii?Q?n/09mMeoXlHLQnaSlj14NQI2fHoGwKM1jcW4Nr3h/iM8wsvOEV+bAc8H6o2z?=
 =?us-ascii?Q?zpaRVRiKfMZpAzAmK2j3kMuGNgsrf9HSKEym4suPgBQmM7fMbXaXOys3bb8A?=
 =?us-ascii?Q?6TLPw+Oykmf1oqKnYctAAo3n9Nn7f3pcYyaJlD+0H6SPBE1CLM1EZYWzh0Lu?=
 =?us-ascii?Q?kFYRgo0bg1N1sDWLUHTE+ZZsyuOZbrSEnLt31S4sdpjzHCaxWWm8EMGs4Qef?=
 =?us-ascii?Q?6WcLPzFON3DlLD+gFYXIhBX6NWC2qV6gXBnqJcBItj64jVnNxmmpnLe7OjrT?=
 =?us-ascii?Q?MB4Xhhq9vs6s8fHjuaMVdGYhx29qddK1ovUnQb6TORKZZ++WUHCN23Q/1zB1?=
 =?us-ascii?Q?C36q/6hjiXX6afO0ouNamhGQ1Yd8ghdrvzeOKd+0ScayLG9WwkbtOKL3i2hA?=
 =?us-ascii?Q?zyG0ysET4bkvXSfWw1iSbFPOLuQzcn83ggLOqSeAgqohaR6RpXYTLQjjjkWr?=
 =?us-ascii?Q?iqqBp6fzPQIfsXQsKxP7tgbUVV1LJEB69kQ4JWjQsMi/ZciyTukoOWg0IseL?=
 =?us-ascii?Q?a2uMwix1TzH7WKOwEDa09i7OcdGNJf2JYvGGe4LvC+Msz3wRerzyI6Jfgx1m?=
 =?us-ascii?Q?CmezQrYruVCCz8sz2GYniFxswMacnQZH0ezzCUEwO0osS73sctRNKt5QIxvY?=
 =?us-ascii?Q?7+PBAQhIwn7JDq0vK2gyJ14QYaL5a/drOFlNv474JJs63hLvxPmd1ws9Vxv8?=
 =?us-ascii?Q?DlnDzR0xqXPfMYWb1Apmh2Eu0b9t8xeKLncHl9G9Am1B9Rog/xoiZpTKewdy?=
 =?us-ascii?Q?LPGeErtswRbwUw2cpQgT+8gXiZRZAJ5LiVEFaXHVFZbknEHN7R89QvvTfule?=
 =?us-ascii?Q?bDPrMV62rrS+v9nC7xQDe6hdEnZPecJLeTCgkbp/gGtdtDQ3zboERmwd8Rnb?=
 =?us-ascii?Q?bqGvEWQS50OSBvIi7xZ1RtrT2MWTE3Ib/TOQPOdnN8PjF2xDZJRvVHeja8Xt?=
 =?us-ascii?Q?OL5K3UeZgPxECtFxCTU3diY2l0Avdm5uiaWUkihzVs20o2bvMQbWyEB7n2Rz?=
 =?us-ascii?Q?KmPN4iN168T3ddoxltHgdMxwaElaohnEEL8HeIunSGll8La/5fJjkcqfUL/Z?=
 =?us-ascii?Q?JfdIcb7igr3jmyha2iXPa8R2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mVOjeDIRIhmVe9JJjBUJ26fgqSle2uyLERMwSpJq6bRpdSLpmF/ZBTznjisI?=
 =?us-ascii?Q?th25uugv7O86InYkOT+C1ChywK4aB6CPFBTJTcCE3e60ALY76DAm0KXU7UQx?=
 =?us-ascii?Q?i9xgbfbyeKRh399bjaoZoE4JVcx2S0K/SpwGBJry/QBmReCeSCej3GAwaoMC?=
 =?us-ascii?Q?bSwnV2EodE5RdnpMmMq3pNgnCdc5wI1RV8Z5+vMtVgxEGpjh3XJd2THAYe9s?=
 =?us-ascii?Q?U2937eMV55WTriYVbMt9lRoVcvPnvQNJiBVEeMfWcV8ZANSy9A+CPOH6xd1D?=
 =?us-ascii?Q?NkQVm76MmoPCfFAgshNYv2qzLouh9d1n9QXFbUdyPVWe1EacKUUpF57IlSHe?=
 =?us-ascii?Q?ZtPG2KmBz51O6VTcjc7JM9AjbWXMwmyAZJhpOGiyhJJ1EmPU6mOswNY+XY7a?=
 =?us-ascii?Q?HHsi+idE8CpvmGl2oGeV12Xx9lp4I9/tvxnywPYVJI4YXmOHp+bOveWWLg4S?=
 =?us-ascii?Q?/CnP2XVF9iYRaOpBzLcA7ikp5VLSyLp8pW9N1YSYnEBe8bU8XraGEJKA8Kw2?=
 =?us-ascii?Q?YlqYHymdQqNS0KeKTelVVs3XwYJ1t9U2QuvqntD+ZBAM9lygV3a10pDMRyMY?=
 =?us-ascii?Q?zKZBU4IXqTbXvp7KJLHWgh1buFiLZsP9tyMTVg7yLgeG3NsSCQnDhNNV6aQM?=
 =?us-ascii?Q?Lnrcalbe3NVb9JbO/SBFbM36F34vCNKjB1u565yJLTj4R5wQOogjazBrwPw6?=
 =?us-ascii?Q?I+puihwvI7fCc/99ZB7bnmLssIG6SXwRn6ttvC6pUsMcZIv1BsqWyNYVmstJ?=
 =?us-ascii?Q?LECWc/GrZ0ZhdyGIO8v4irxl06otKqohB3ndjgMb8v/URpE+TCw/mOorVddI?=
 =?us-ascii?Q?wr4PJ2XsumvGGuWOjYbncCUXErFud5Q8zqEh6PKIBDMTTTLvVtkdnS4ihnnQ?=
 =?us-ascii?Q?Z1YZcfRN9NgKh+EcQ1sAwXsLWpmeSL8zA+7VaM7tSYqaUfSDG+Opd9xy71Mn?=
 =?us-ascii?Q?Vo7ZU7qInMmfhj5ldhh731k/1Wfh66FsTyus5EEEAjkvTQ8rbAm2nDUnDJkJ?=
 =?us-ascii?Q?wourDhr6BTN6WoRDr0oVYjwnu3PQxsGHxyW2xql5ng5ZgQrBN3My+Wanxxxm?=
 =?us-ascii?Q?sBVy0e7Kj7ulKaOA63Gbb+9Qf+CG+CFmnRWC40j0BDcfXIygF999coRltCcl?=
 =?us-ascii?Q?cHeH1udCGgnQLcA+E6mDjsqtxoOeT7xoP60dXXDfE2H2/6O3n4PI3CMlpjW0?=
 =?us-ascii?Q?6C8UhzuXZrB+3Ubvu3wHJoiN9GOevEQDbgC60bKuETEjC/fifgB4KlOtm+5f?=
 =?us-ascii?Q?RT4R9iL3HFMsYG2A4RsSiTaudTK0CUY1PMpKRwC9c/34OyEtcABComG+jWCK?=
 =?us-ascii?Q?QrQm/P+BWyxosIk6zYdmnZjHhib3u61azxzd/DKeSpJJF0UQMjklz+Ux5Smt?=
 =?us-ascii?Q?A2JMlZ9Lo9VMXloUAejuul3zG6R0ky2jqSQtWo6qdSHpu3297SfK3hXgNuAI?=
 =?us-ascii?Q?tmbZXC/OCx+p1mgUxxeFxi1IwL2aFxKP77U5i1yr4z7bPSIfJlv8N2RZwpUn?=
 =?us-ascii?Q?cG+NYnYYUZIVM5T+8uCAw+1j1na7YOefQyAMk11oiz2dvIIiihYSmWSQS18C?=
 =?us-ascii?Q?vOqAYR3az2TK17ebhNHxj+uKwBkJgTMh5p6N1lfiU9roRCWC2n9XBoQ5Rn1B?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e199fb1e-d255-4923-35c8-08dc8a0901af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 11:24:06.8718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dk+2BcA/w7OmizLGeWm57Uczxr93qXKEn46s4JCnkSBMgr6jEmo72bs1qBoqfFHClEVfojM4wJszq7MNcuutLu1mfkLt5VRMl+K2jFMTUGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4537
X-OriginatorOrg: intel.com

On Wed, Jun 05, 2024 at 11:18:35AM +0800, Chen Ni wrote:
> Add check for the return value of adf_cfg_add_key_value_param() and
> return the error if it fails in order to catch the error.
> 
> Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_sriov.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> index 8d645e7e04aa..30ff9097f527 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
> @@ -228,8 +228,10 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
>  		return ret;
>  
>  	val = 1;
> -	adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
> +	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
>  				    &val, ADF_DEC);
> +	if (ret)
> +		return ret;
This has the side effect of failing the enablement of VFs for QAT GEN2 as
ADF_GENERAL_SEC is not present.

For GEN4, where ADF_GENERAL_SEC is used, if this function fails, the recovery
paths is not going to re-enable SRIOV VFs after reset.
It is ok to omit this check.

Regards,

-- 
Giovanni

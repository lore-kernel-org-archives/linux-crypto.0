Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47A1E570C;
	Thu, 24 Oct 2024 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729782312; cv=fail; b=fLVWpWqJVAzPgU4sFjTm4HisijwAMOmQzU8AB4S3HcLTLcs4DJ1qdP/CpR+DHDGGRJb5VW/KxUUbE5vxYJYE4sSXc2L39BrFeal8E0Qd/8rYYP69f20PEX5HRoX2YIOdLM2uy3HEUirpAFgSNz0oDM506A5waRtfhPXRWN/4dB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729782312; c=relaxed/simple;
	bh=q7/y2c+PFzPmVAnVo5y0NuQIJ3n1aFGSmBYSmwz31m4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l5dBCzStmJCuWVJ34cwJqmL+iiicBFYH8pRfLMKJcOAkdzTfhuD5uAfQ5WeGljNTsqPC1MPE1N60h/+3mMtl+E4UXp/NufKuRfG9JXQCg/hr1y/rNHw+1BGDCeut8gpKbu0Y/6G7jTI3yYLyRNrH5fqRdrFODU5ZGz/bUs61Vec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WB8/7KxW; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WB8/7KxW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729782309; x=1761318309;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q7/y2c+PFzPmVAnVo5y0NuQIJ3n1aFGSmBYSmwz31m4=;
  b=WB8/7KxW3TNFzpOiEOft89xNW5reS3cJ57ofGq9dF7hWNEbQFlQDlgG3
   9Kuhdx/0b6ECMyWBzRZoCtgd5WsyR6XlCcJZOcNlqPLISf6kza6uYJoNa
   ru6DX7g4gat5Pdgi9nRy/Wyd+i1wiiiprs9SZA4lP7OYTvjEQMwiUNlGD
   9HdCW8T+TmqD5p7LPQ0BHyeGYcm6jXR3vA+7n0X39YE1cWGf6Gd0Gbah4
   /X+uBoMhfaaCHc3LSWuAM53NRGSFBccmL5e/Wd8X85U55u79pyvX5cY+v
   F1NBOCS5M/Vw939xuiDrxW8oZe5h0xNCrQXWNVjaubEm470pyihhTtaOx
   g==;
X-CSE-ConnectionGUID: Kjzde+FNQbydszPCldEjzA==
X-CSE-MsgGUID: TOy+SDbfT2yK3ymBdHJtUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="40784039"
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="40784039"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 08:05:08 -0700
X-CSE-ConnectionGUID: 2r7wXWSTTG6rEwlkavfY0Q==
X-CSE-MsgGUID: +7GQf5f8QJawmhPlwXr+kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,229,1725346800"; 
   d="scan'208";a="80786654"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 08:05:09 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 08:05:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 08:05:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 08:05:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lbIdZAPMfFmWsfm5GUEUvBttWnrYofHxjw/QV+enhBNF/COOxdwyMXYCXDsFfTIkaGU9ZfNmaVikKhjaeBDguhojhu13iVmWYWLKMzhN5mnjAJoVSwKmEpqMriLadvl8fT3mA8YUmr384bIhAc5F3XNIed+llHCU8v/vDN/64RzNxNh5+lb1TTrKat2sy4CQ58iT7fN+y+8U25zK8G7sL9b2HArzALBHmzh/qRbagutTjveZXhp4xdRCfGGOZGjfu0fkqgeTfo32g05Susleypr/fNGmqhrD+mZfmG7EFgN5oWQmNudX1Oo/c8QZio7ROe2bzaRT3jYsic3AHvXfnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nStevQETeH01wVGAdSehBD7dP4HvB2tlPAQDH5QwuE=;
 b=SGnpJgl/YlC2ItYC8eL4Q6iga/0S40/BgS6GSntL8OkIkii/XbiuipKFMR0FThJhb7Aye6dKR3wKdjLi3IG3eroL+FIPC9J8RrNZa949A5Fetkaeeo+ucXsZy5guPlOkiGhWqkwC1yW09DoIck4jug3ekmG4IxaPTwgAYu8oFBKdxhuV1aNKRiOZXxh0BYxHnMJUjw3wlCX/5WQyuc7zASBnbvylaj1YZgKHo3490rBB7vQI5dHE8Ez8yS89MS2c736+B1LfIfRjLu6JYNPFpDILZJWw7XiSLZNem1YwPmnq6Se2LTJjQqQIoJ3Sogx2yiD+SFX1EwpH2jSNJ4fW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ0PR11MB6743.namprd11.prod.outlook.com (2603:10b6:a03:47c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20; Thu, 24 Oct
 2024 15:05:04 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8069.027; Thu, 24 Oct 2024
 15:05:03 +0000
Date: Thu, 24 Oct 2024 16:04:27 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Wang Hai <wanghai38@huawei.com>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ahsan.atta@intel.com>, <mun.chun.yep@intel.com>,
	<markas.rapoportas@intel.com>, <damian.muszynski@intel.com>,
	<furong.zhou@intel.com>, <adam.guerin@intel.com>, <zhangxiaoxu5@huawei.com>,
	<qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Fix missing destroy_workqueue in
 adf_init_aer()
Message-ID: <ZxpeVD/D9Y7sfL7H@gcabiddu-mobl.ger.corp.intel.com>
References: <20241024140057.18548-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241024140057.18548-1-wanghai38@huawei.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ0PR11MB6743:EE_
X-MS-Office365-Filtering-Correlation-Id: b3bea309-b3f6-497c-9755-08dcf43d3d2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ouYk1U9Mg0djC+IvDBtpU3RV/nZoNO9iiNLv+P3Rygt5znXIj/jKacxU3gVc?=
 =?us-ascii?Q?J8eT8g0ldBRKULYNIq2LqiXcNwI8gBcxNtKAhLAZTLLfHE73KAw9lJX60T4R?=
 =?us-ascii?Q?FWbBdfEXCyCCf9sQ1dyVR6EO/hWDY86tRzmtuH/+5/PkyWcZUdYR9gbkiGxu?=
 =?us-ascii?Q?6CVVKGa6wqB3RtvMzcJZArTz0s6MTUdKdLFlPfpvHlCnLZ1g876tPM7Fjr9F?=
 =?us-ascii?Q?tE+1mJFT+kSvC9stQl9E+Jcwp9koZRYYdRCAMkXkBF+qTwf3BmNG62SBjr9Q?=
 =?us-ascii?Q?JXRv4kJOGFn2MAXR9ZbQWCPsztdFo9SNKSBcm5Y09ddRe20p7lODomBFckNp?=
 =?us-ascii?Q?SgvLA++1A+hSu5odk/Ykfs+22uxLnok37yTpJJHOFRXpliYmtu7eUU3eL6ll?=
 =?us-ascii?Q?JwdWDQ6h4r97J/FPfBg7X9ARazX88cVDVeIpoUXm0jL/81ftnW8Ms1mgiYlm?=
 =?us-ascii?Q?/nLLWrWNzCbnCObmEIPsHQlJp0Durhc6tBZZTHSvQpJ7vo7cLL8YKxzX9MNO?=
 =?us-ascii?Q?UpUfrNTcDUJ2YjZNL4WjcNSCz1h5uQbxHbqvrvU8WARwcPnvAyI9r36+ExjQ?=
 =?us-ascii?Q?Axpizc0KKFGKgnlPlXmZ8dp1aVkHrx0gM/Rq0S/LzztonO1rLhFWqVcS5lS6?=
 =?us-ascii?Q?2Eesu8+kSe+amBmyoVQZ1psbQl/9f3x0jy9M7IS5OfELDN0STao5cv97qCNA?=
 =?us-ascii?Q?BQEOxrKw40oxRW3c48eRhKrsbmtv1udMdFeXH7c9M5bVvMdLOuBxCOOC4joO?=
 =?us-ascii?Q?p6fEwQ7LS/K1Lm7bjmSchzGXJS5f1rmHXKkxemOtoKlxhV8MDZFxMpJgTO+/?=
 =?us-ascii?Q?MQ9Fq6v0kE6XUGmHiK9lY4Py2J5eqb6Duv+J5ATUKsyz+Bf5kZBeQjcgs+z8?=
 =?us-ascii?Q?5X7+cWyh7itUxT2428BFFylnaJqVcXA+m0gI0IVN2IIyqbEQWdZ6mCu7L1rt?=
 =?us-ascii?Q?lphrj55SUOIDcshGQ7iAO94IL4gQTI45lZ+T9gNnd/GuW64dt1de30yvwEXk?=
 =?us-ascii?Q?z+x6hfFTweTlY1kxqPJ0eUrRxbCEIDxWfxpt3DUK7IVsn6nf5VsjOWU1eZxl?=
 =?us-ascii?Q?b9tNPBc/RtDZS6yw5lli4SoyYre0PM6DGF8+CQjPIb7NfZo6Fi3L9ZUs6t8m?=
 =?us-ascii?Q?8qUGDQ27Tu42nUtA+c23kBfm2q3To7/JzTcFmWKqYT/CJoMO0oIaTwQaP4kW?=
 =?us-ascii?Q?K86etmDs/iVfCQ1+S/Q4M6YeEK2lgxYTbmRuO67KmtFdOxnpp/0zCN4lBduO?=
 =?us-ascii?Q?K4W4MyZ0HTDlTlBI8f+i?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VX93RW3sEVQGac65INUvpXkOrLa8zUdsMpq3xPiRCUJcphdQc88ak+2atH1a?=
 =?us-ascii?Q?euFjFXaZDGfpN7XZi3HC1LHzBfWCvEZMibMd6qKkktFFkf5tnKxRN4OI0IWx?=
 =?us-ascii?Q?3xG/EBktq2DdqopMKXUqE7Giko6piw8w4eNj8iD5NAdwqVi854BHF8OADUIQ?=
 =?us-ascii?Q?pTsB1BaM3xGnUSX0TJEHJb1olxI8ePCMmxaG1WE3pGi3fWPiHPsg8to8EJOF?=
 =?us-ascii?Q?6uZnfaieqcomMQrPnADs47+TMN+zzeg6Vp6e3EPZ9SzI4mvOKXfOualwjoC6?=
 =?us-ascii?Q?v7kklTPH8TZv7jphTLg5OuKRPyOszHsw6jVxHEU+A4vh0PL3Bz76XqG7VDBG?=
 =?us-ascii?Q?rSosnmKR2GOK6hwO8KKdfIDCw3UvP97huIvqmgx8+itGe7dnw19arxI09Hzp?=
 =?us-ascii?Q?mnIlsHTa746H9w2/Q4s452mLUme9f3/f5ieHWm0+qfzJRhrI61uthloa5tOs?=
 =?us-ascii?Q?YcMCRoUoo1wTY9PDvv7ZqQkFh/L7s43Tu4Yhm56ZVn1br3r5esjwofpNjBEA?=
 =?us-ascii?Q?CB9JxRyvmQwjInmNk7bv/6tsMYjAPAiYv2vIBmXj3SQUj8ZZaO0ytX0c88vC?=
 =?us-ascii?Q?CkhHT+ERccCyANfAfmgVoWvqQnAXygnholoI0NiaVo37xetV4dvIJSTY/oR2?=
 =?us-ascii?Q?gDafncf8OznX7Cw5kU0MdQMdDkfx2IP1qwmt9uv0r6+Ylea6FPcuPWf8UUR9?=
 =?us-ascii?Q?ArnoG6o72vEm+AWl0/aPh5CC7F2axkH5l/tv7TdmLlPWY9KW5pfLR0P5f87A?=
 =?us-ascii?Q?sQY9AL2KWwPT0+U7OwYf3GuuVyn1uHrtVDxblDS5uE6vIBXSKIA20KyfkGFG?=
 =?us-ascii?Q?JiTA//CGnnwLxlAznxM0HfdaP+po5wnfugjxDSKWVBpPJlrOJXceP3BOAvdr?=
 =?us-ascii?Q?2XwyXMZsAbrME/msmv247/x0UT/mZiWrngN3xR4ix18dWyPx/f0K9aD/5gMX?=
 =?us-ascii?Q?ceW8BNUpY626KBTbKdVNufyGF4iacmnuIGYFG2u1nT64tFzlYhEEry7G+czm?=
 =?us-ascii?Q?u8txQjbOu60F9okcUFNJjxWkBpohmjTPetDNJFzGPn05py46Zm7BfJMUxq4n?=
 =?us-ascii?Q?BPJhcd4lBoYsth4x6S8BmGcS5R594HBJPeb9yu5js+mcnTDobB4rHC4x+iwp?=
 =?us-ascii?Q?kSHnlkZU82SpAFXXJKlR0kor4JnEpjDghJGnu3pRezt/y6zwzGx2lYb+ICJ8?=
 =?us-ascii?Q?lIpWNOlIFMr8Yiw7UqubO1Ym8m0LEFmr24HhMvJxf3Ak+kZgumFXnDvT0cvX?=
 =?us-ascii?Q?6i+tRVw9IOwfPnnoAUXjaYZt2ff9IuPROukajw7So0TpKHyEvo9vShjMH4OQ?=
 =?us-ascii?Q?SfwsAi3pClt306KsqtiQFCNcK+jkXV9cx0mrdGg3oup+m0GafirvXC4yvSns?=
 =?us-ascii?Q?NucPocaH1/Z4ZqYVnId0HGhKvWGjyixKFvkoq9sBW2vhbcjhJd/qYUxj0xRo?=
 =?us-ascii?Q?8Xc/p8iNESeQbkt/bTLTmpzrK9L8pbrjedkQ8K5y2Z4xRcDC1SnntgXA/KZT?=
 =?us-ascii?Q?6DgTZb+j2HJiilLmT+5m3kGj2o9rrne17kGv52C6xajzcB/5MJ0bRPgQ9k+a?=
 =?us-ascii?Q?4EyiM7+ZLzlmuGoyMN72t7zkNBPlQHsv/Brr7eR33Aotfv18Ebzd+JtsZ6eA?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3bea309-b3f6-497c-9755-08dcf43d3d2a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 15:05:03.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y79xn+pUf7HNCn3e+J9Ep53oBwjhM+rDiGC+WHb/nTcC5HbKQM+1BX8La/qAH/YuBtP+EksFRxzgsWOwKBJIiD7buJzV6qNIo4oN+4fAh14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6743
X-OriginatorOrg: intel.com

On Thu, Oct 24, 2024 at 10:00:57PM +0800, Wang Hai wrote:
> The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
> for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
> fix this issue.
> 
> Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> index ec7913ab00a2..907144ec7e65 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
> @@ -281,8 +281,10 @@ int adf_init_aer(void)
>  		return -EFAULT;
>  
>  	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
> -	if (!device_sriov_wq)
> +	if (!device_sriov_wq) {
> +		destroy_workqueue(device_reset_wq);
The missing destroy_workqueue() here is intentional as the device_reset_wq
is destroyed in adf_exit_aer() which is called if adf_init_aer() fails,
see [1].

With this change, destroy_workqueue() is called twice.

Regards,

-- 
Giovanni

[1] https://elixir.bootlin.com/linux/v6.11.5/source/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c#L425

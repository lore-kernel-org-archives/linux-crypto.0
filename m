Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B02153E03
	for <linux-crypto@vger.kernel.org>; Fri, 19 Jan 2024 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705683461; cv=fail; b=I/G84ofaO07V+FQFL1N7tORmLn86p0wR0+agog+ptZcsXpvBHSeyFZevtCJs/1zRCfz8s62XmT5Cj4LFSBxtmoIoZvXUoEPIAFXj9ZHp27E4Gli/GZvmWtr6fghpN9Y2cybV6PnBhHS7+MqKn/ktPUxOgxRJ1krY3jQRr/EezZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705683461; c=relaxed/simple;
	bh=NGkQIZg5vTHMYqRV9tWj3vXGewgNImOHWv5T3MibEVU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F1YZJqhLyJjFOV2E8TltoDmndAfwXOrRtHpmaCRUOzGTnTM0TYnAJipl9qbTxNB3aEiZaqaKA3qIhc8SywIEAguarljKFNxnp57XEfHa7luhRxKysfDuc1Dk7cwyHuHrKSx+TQMwf3kEYj+ZMgGjCBuqpVYkm4MyHF9a5atdK2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xi7al/DK; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xi7al/DK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705683460; x=1737219460;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=NGkQIZg5vTHMYqRV9tWj3vXGewgNImOHWv5T3MibEVU=;
  b=Xi7al/DKC8+yquckEMFV+zApeTV88cJTaVZXOVFgmSe6KrT0qxDBV9G7
   gpWxz6bufcHWeaqV7IjtAy2aGf5/LAw3yy6AMzvI/5hxef9Jo2BnHqdCP
   htOWEvjsMHgO05H/nuHmYzsAfYCYiqEMlL6L2rzlobA+CwE4d2DiTnCVy
   nAmzOh1M1vZsL988TvWf32ZHaOnlm7yLN3w684AA8TOrP+2M7sbtRJT3i
   +M/qB8IqtckrStnpSTIRD+Zmtq1/9cM3YqNmmGrEk26mCFQd4vpa7FU21
   YMRUoOyqs6FrOvoubz0FRj+H8YO20E2N531HuRzYu5ppjve0hawYhZSEp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="19365739"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="19365739"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 08:57:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="785107625"
X-IronPort-AV: E=Sophos;i="6.05,204,1701158400"; 
   d="scan'208";a="785107625"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jan 2024 08:57:38 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 08:57:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 19 Jan 2024 08:57:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 19 Jan 2024 08:57:36 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Jan 2024 08:57:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGQ0BhVw/gYsG8YhulZIocHC6zolURlGXSaezRKwceXHzYIqbaE8JuillTjWbmT93hHnYwhPIla4qTawtHnC+VH6EDgxX8CWiLW+Ir51E7odZUI0TpmmC54EImnW8gzG18yW5gD44ohGBjpHZ+eFPvbP7JI3lJlY32wiz9wDm5u1W1PxEaZNZcsFX4nEecptIoHZNIteIGFMBpbfYlNOJo4M0XQ5TexwOQzxNbm9t7IDm5PJP4RTKX9rM1HFPKwjymfkHcbyHH0Kzu39Gmpvsdo32x15BRna1EXBzQLrsYngyTvYuDABWDEiFXqvIMDqEW8Ztbza2hPYFZQ20WaTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWEnASDwf+lcyOF4vBHae5DMMGhhvQxETuUWldPm3YI=;
 b=TDB7woYQ5DvXMy5m5qVzMBv+deJULQLUTW+VyD0LOR42jbt0Oc5NW24yJhnMADY6VkBH5C7k4thdTcgrObC97NARaji7KENwNKhn/HUNEfK5f3VFXG6ra3PKlA7weiRvYVb+VWoJopRj9yqc1gzN96GtpDyFBfjX7qYzg8ujlJwkz1EOTBB33WPzhxcYEUoz2T0BLEzELiM4a3YtDFIppUgHKq7slnNxU5HkkJeJdGjtFKQ+uFWxJ2h5On0i5LFDFoQ83LOmf1s8uP8ylgUWxZ+QiEXNnhq0v3/rWmkngZ59iVqyB2RB46zjknvYI21+k2Qo5YV19YgiG54C+DP4aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ0PR11MB5678.namprd11.prod.outlook.com (2603:10b6:a03:3b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.26; Fri, 19 Jan
 2024 16:57:30 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8de8:c1ad:7062:6afc]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::8de8:c1ad:7062:6afc%4]) with mapi id 15.20.7181.020; Fri, 19 Jan 2024
 16:57:30 +0000
Date: Fri, 19 Jan 2024 16:57:11 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: <herbert@gondor.apana.org.au>
CC: Damian Muszynski <damian.muszynski@intel.com>,
	<linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - fix arbiter mapping generation algorithm
 for QAT 402xx
Message-ID: <Zaqp5+mL/Gg2i/Oo@gcabiddu-mobl.ger.corp.intel.com>
References: <20240119161325.12582-1-damian.muszynski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240119161325.12582-1-damian.muszynski@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::9) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ0PR11MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b2f8d6-2bc4-4d61-fc79-08dc190fb968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dnqup+v04z3AoGA8okIv7cOo+FiMD6Z8EtGRCVsZ5jNbEi3G0hURUInL3K2AQWBOdDW4jb9JMxzVHCjn2ms816nZg7Y2l4odfAHRJQgrEUTx0ByZ9UQLdDvj1+X/W2gte2jpaCzRHQEJTGHEDFpI7XxJfQ8dFFJzqDsR3Sn7BovXc1gXZxIwYH6rMHPTfjWmjeRHBjHscD9q4jvGNbcYHfVr4hLBgUbjZvxDcoXqEvTn5QcJ5+sVKhYRguesMl7lZvaKdNwm+NyQ0AaMcHfC8d1PLSKqY5eoUBSFfKLduuKzBV4Iq5E9FJ5FX7U3yLdvruU/pSHTMZA9WmLBsi4M5uQ8eML9tH3XbwVubo1tb4veiPl9sac265zqGLL1/VNoTozFxIa3+3e6dkMmL6+SwFEDrNfPFIACrzOpcpO/KHDe2R7TkjOy6udcX4P9oQHkXYZUfgngi3JjX/QOG2WA76OvM4MTQ9kbd1iDBGTQhfYNnvFQk3Kn8DP8yPDKGnQoJqWNu9cxgxdeR2tbNjSggMklw1Y1+EMTgApysUb8QjY96Zepd83MUvGwAf429RaZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(39860400002)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(316002)(41300700001)(86362001)(38100700002)(82960400001)(83380400001)(478600001)(6486002)(6666004)(36916002)(6506007)(4326008)(8936002)(8676002)(66476007)(6916009)(66946007)(66556008)(2906002)(5660300002)(26005)(6512007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sePUK1zO4xh0hAiYecqy6AQDuMxH4q2cnH97XrWbUwtS/gb2fsBQv9u8uj4M?=
 =?us-ascii?Q?usAQmxTbKIoAaM/Pf/qiRxv8THYngKFW5k/+LyftpzWaWU3wIlywDSIxPsCS?=
 =?us-ascii?Q?33gJbaM4uKt/nDhUkC9B4o+cFHr3LoOFtoxU7+iu/bkD1WQ+IP1MzV0LEibJ?=
 =?us-ascii?Q?gVoh+g6WDCQv+oYzUOi7odVncRAi7x6CjgFA3WInVXUVh/H9mrPrUvd+2evt?=
 =?us-ascii?Q?IfhdX65Pa6FQmR07TPG5wyghubMuff6v+1GACgNsIsLXafIJW+UGUJ26EeO2?=
 =?us-ascii?Q?ydCtc645Eq1Zm5BXz3mJvu0cgPMNptkjHXNlacnysrKa5vZ/4N1VWFHZx/5p?=
 =?us-ascii?Q?OGumWtgWvesu6T/CK3AmsPXCYjJpv5pQWjfKdM3j+8chyjrivvWTWot894sK?=
 =?us-ascii?Q?3mCMWecsb+rDXHfNk0I22R7vYZYfe476/ApFpQyfY1i0wmBoZmUIX4Nt3Qw/?=
 =?us-ascii?Q?t8EnEhjTXMZ0IbBFJrCZs7gvWrHsrgmAAPzi40jFCqN+Sn6wQ09BzkSQ8rGs?=
 =?us-ascii?Q?kgi0ks4Iy/o4tJKM9I5EkFIEIpoDlbtGAcgzE9eYEslZRLeVoMjJu4sFYXxO?=
 =?us-ascii?Q?kcbTulzSCRulbpuz/6bXpJvJQqMCzmTVoCPJtvZ7SL0PQiWhZOXqmJyXFwvi?=
 =?us-ascii?Q?pf8S9feekWijO1x5tImTSD7DH2Rwq5xmHLK/Y1GC5I+/jHZ416vtXpkVY9dQ?=
 =?us-ascii?Q?egrm7VRmHs15BmvCTj4s/4B+LhiE0FjNnU2dutxexAGQbIJec9NkgANdAHz4?=
 =?us-ascii?Q?XGCLRgH+86HzS4Mm2LLMCPXqInhEN/8w/s1C5bwNfUpEfQAhbLCVtKGYwydg?=
 =?us-ascii?Q?Cec1mSMA1uut8AN6HSjFEHxdwDVOXoNey/8mzAA6b5kcPRncJnNj+JNVG6Je?=
 =?us-ascii?Q?28lZs6d9uksLgDP0Iqq/Dd0cjOTucWdM/sHjGsB+93YLe1Ewfy6fIfK6VTEg?=
 =?us-ascii?Q?yfc3Ax9VNXpcKhOWQAWSlagOuU2P4caUv4LVg/OaGotWRz4uzCiMxh+O3aRj?=
 =?us-ascii?Q?mBdwNWMsm60M3tax7UWXQO5BN2js2zspgeAGzrQZ43XEt7fAjiFneOtAU0hO?=
 =?us-ascii?Q?HS3SMRCkG8vMsdUME78+zDFoDAxOcNkmXrhzSgGlP8v9j2HO7hEP/zaCFbAt?=
 =?us-ascii?Q?l8zoijIqZPZKnblt2eMNwgIG340l2drM+OXxcXtD/B3Yfii83i8wVNfrMMdH?=
 =?us-ascii?Q?4vWDEZndqzPNOOrelRe4nZbR9KQpK2ItwI58SGDAWWaTDnj04OhybsCrMWWN?=
 =?us-ascii?Q?K/UmXYmmmn1Su8pSi9HS3OrEhasZShxyZ5uaGz7/1kbSgxlyls+I7CEGwOot?=
 =?us-ascii?Q?Nhm4qlzOoA2yHJqYgPFsuVV2ULTPn5hnalAYsykw0qBwKPpbRR8kyfxK2iBP?=
 =?us-ascii?Q?9zMwJPrYt4QBoyUZ2o+hkA/I3pIdYRTJVmSh9CE1u2166itcAhXQFgc+/+cE?=
 =?us-ascii?Q?W45IADf6YqJxwwQsI/tZCQeAV1ycdvWBdkg0dCykIGedl9i/iuJCa/4W1Tw3?=
 =?us-ascii?Q?utaSnPXO+8Hujgavx9L0KSiWGMuQINXm91vQkV7T1PPzKacDYEgplQdBj/Rg?=
 =?us-ascii?Q?XosKh2jgeRG48TnnXcZwCsiA5hmWYoGHmmSK3tddQMF4xX+i8ttEA5fx+Ebb?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b2f8d6-2bc4-4d61-fc79-08dc190fb968
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 16:57:30.7256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ASxw56AQWUmDpJAqz+AWPW4jTS/sZZoAsdKUQd0KboJlFP1dCD8LwCYGX8Fd13kTPjebGZb3pOoO0q292y+Er0hwXGQJa461pl7ak8OD2ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5678
X-OriginatorOrg: intel.com

Hi Herbert,

would it be possible to send this as a fix for 6.8?

Thanks,

-- 
Giovanni

On Fri, Jan 19, 2024 at 05:12:38PM +0100, Damian Muszynski wrote:
> The commit "crypto: qat - generate dynamically arbiter mappings"
> introduced a regression on qat_402xx devices.
> This is reported when the driver probes the device, as indicated by
> the following error messages:
> 
>   4xxx 0000:0b:00.0: enabling device (0140 -> 0142)
>   4xxx 0000:0b:00.0: Generate of the thread to arbiter map failed
>   4xxx 0000:0b:00.0: Direct firmware load for qat_402xx_mmp.bin failed with error -2
> 
> The root cause of this issue was the omission of a necessary function
> pointer required by the mapping algorithm during the implementation.
> Fix it by adding the missing function pointer.
> 
> Fixes: 5da6a2d5353e ("crypto: qat - generate dynamically arbiter mappings")
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> index 479062aa5e6b..94a0ebb03d8c 100644
> --- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> +++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
> @@ -463,6 +463,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
>  		hw_data->fw_name = ADF_402XX_FW;
>  		hw_data->fw_mmp_name = ADF_402XX_MMP;
>  		hw_data->uof_get_name = uof_get_name_402xx;
> +		hw_data->get_ena_thd_mask = get_ena_thd_mask;
>  		break;
>  	case ADF_401XX_PCI_DEVICE_ID:
>  		hw_data->fw_name = ADF_4XXX_FW;
> 
> base-commit: 71518f53f4c3c3fadafdf3af86c98fa4c6ca1abc
> -- 
> 2.43.0
> 

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7B25D554
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 09:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742808513; cv=fail; b=qJhG2gpmsSBT7CEar45uDLBaHEAbmKRdRabuVj6fwXkTHDidkXfF3uRmzj7aL8hmnnuc+oOebsKrKJ2FvIrs+W26nl7LOaVzeaADM+P0Emv2/M8WF117V9z9+8MGyj1+cXnDMu7wEOKkcK0h8VTbygzDXr+NMdpBPjPlxoUkC9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742808513; c=relaxed/simple;
	bh=caGdJqKRQiT0pkciWGFZrsPvN0r6eyKHTZRdh7Hg7Ok=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cNiYTly5n1LbeO0cGdqQZe5QaQabA4pVCvoJNbw+aFmtS7qiEuvw22taFYSnHYPGCwJlwUfcizGzZX9OLdYCJ3WPOLBa0QsU6rYM54V1S/tbvwLSUP8eoWhbXM4RY4n6gUEndEpfNbVqVeNsDQk+hen4NZsjmJweMdTwANA9Qp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WDvTQRmA; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WDvTQRmA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742808511; x=1774344511;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=caGdJqKRQiT0pkciWGFZrsPvN0r6eyKHTZRdh7Hg7Ok=;
  b=WDvTQRmA68cDMCB1bEVcZkxxUpD9egIxlasb/NGSg2VeHFOF1j1YlBIr
   jj4Wzr06JCYie2fwPIRTsMIPOyuS8HCwh6TnjPwfSOfHfEXOHmi3LM7Le
   B73kCjXcpWoj0uwlizP51vzz7aNupqKa4kj0v86xCa09UriEAtM+lEBdu
   2jKmiO0gAmwpjeHTWJG2UA/+neaviKlkkfFTSEtKoV48GLjO3EiXjQTAL
   ofhnokE8qWlu//+1m5EP5IPnn7Yh6od5aiTvaMjW9V7mqDgKNPmBh7/Ol
   Q2F33cDoPZbWZ5x79yXFILliBJIOFlQa9MXkEtAQ5CQ0BbkkRH0e1xUBa
   A==;
X-CSE-ConnectionGUID: GRoat1BjTSye4NL4crzIXQ==
X-CSE-MsgGUID: Z9AtLAVTR3mtk3WaucUGxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="43880461"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="43880461"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:28:31 -0700
X-CSE-ConnectionGUID: bHOrlIKtQAKkKC6hujcXeA==
X-CSE-MsgGUID: tEwOjTfRQwi0luFX8DiYqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="128157835"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 02:28:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Mar 2025 02:28:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 02:28:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 02:28:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fqiDS9SnHUgS3MKrgmjif+e33YBSvb4PLfZYbiQohqp3uanqZ6dAttWlDtGh8TyvKd1x5gnrR/EbRB+LEgQe/AEAszSIxruzUbZctYgrmxp5uiSGWq2qSq0vvg9cRT46GtbLkQ+lvUgqa2s4ui3dB7jo6BDgd0MKhpQVV4nU54g38pBOcKHUc2m0+QDpoMmyWsOOmXoCriALyJBaaIbcx5/sSTN02pLjceB8VfHHjr43waNChO1itKPyizsov3doA/i7XxC9cs6Vgu44RAsRUYLF9ZS94WMqKKev7yjxLaXM5aUlfmryzmyGGNVuaBCMYfXQFzTzpyus6iZ6PxHfuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+ZIS3ZRpC9cnP4rUzJw+dejGsvT4lV0w3fbM4luseQ=;
 b=l9DxHqMWAoKNoIiRtsG/1v1SvcAOIqgsTuNPraJMNXGwqtvg1P83ahh9PXqQTrJnt9NITsXRKQo0xzqNJq5S7Mg3iKHIwlo55ImD7Ayb+T610kowj+l10bQTcC9JObH8J+pSbk1c1u5jja++FQF34LSJ/4TEPLqdrL6maKJwJSC2XpQou48oeObADa7gsxnx7sT6VkhYd9o2DliqKp/hSsGF0xUV7lY+ep6nrVGFbpQyPM+iDWDflfSvmOJO1zPMogWj3mLum6m0avYyjEb2yL2KKMpmHgrcNnRADebI5bTPPPIGxvGqhyBh0u+eI+Gn9Xtj/nUd8zVqFaOLGb3loQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA0PR11MB7209.namprd11.prod.outlook.com (2603:10b6:208:441::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 09:28:01 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%5]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 09:28:01 +0000
Date: Mon, 24 Mar 2025 09:27:55 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>, Randy Wright
	<rwright@hpe.com>
Subject: Re: [PATCH] crypto: qat - power up 4xxx device
Message-ID: <Z+EliD/GQG30PX76@gcabiddu-mobl.ger.corp.intel.com>
References: <20210916144541.56238-1-giovanni.cabiddu@intel.com>
 <Z-DGQrhRj9niR9iZ@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-DGQrhRj9niR9iZ@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:10:54f::28) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA0PR11MB7209:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fbb9195-77da-4e11-dbd7-08dd6ab62be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7mGVtk5Ev8BtpCCvGZ/W7rHAE/2if4mLt7vbD22ELs/UHBQGoOtZOSMZdhHs?=
 =?us-ascii?Q?gJLScYQbS6xjp3YW4ufc8m/naYdTQxfBYn+tveqZqEUBuCtJa+r7oYRlGIQG?=
 =?us-ascii?Q?ERa+7dBHb5HlSSeXRJXRHJANj/ouN1G9lQMhWqB0CQHUIocgC+WjW3ffwtYZ?=
 =?us-ascii?Q?4PQE+nJW85Y1NTFtF9WtzSNh6v+YOtfP+4iaMXIItYLIX9lub7DXOq13MrmF?=
 =?us-ascii?Q?OXJP3DIwIjIsNRFxa+MWNSDzoEi50qdLoIwAeOVAxKq2kc3yIadkG4D4/+Hm?=
 =?us-ascii?Q?Er/nn2Fi7z+1iGMQsxQFjKayS/dlAc6ELUfTy9eqrO1DjVa8YG2oF6VN4DbC?=
 =?us-ascii?Q?mIJMiqbkiNKxOVfn9kRY54D7b8h7t2Gx9aFQ/8poAtNV8G/bDu0E8/NaL5H8?=
 =?us-ascii?Q?cL3X6FiuQ8GMP9GSJcUJe7t8QRtFVIwbSZwKQU840FsIboSp7k68BZ1OKwQi?=
 =?us-ascii?Q?Py39GhQ2FNdwUXhw6F6t6hnpme2/K1Mft4EtiwW590OWs8JvLYl0xfUYEdP0?=
 =?us-ascii?Q?mE6XUtHnu3EUyzM0CKQNHnAdMxxtfCPRCjcXBjlvjgEm3mqsdahj/kSzU/ok?=
 =?us-ascii?Q?VI+JZh3tZwIrORSpGAlqjPfY5deGToQkMFQIDPadMRJhTtCNKXTRk/cg11O6?=
 =?us-ascii?Q?I0jQn/4ntglyCRPjYupA7HGDOEs6Fs3pnmBE4AZQctqIZ7+hm8Rpup2LKEK4?=
 =?us-ascii?Q?8LAcRMdUmRiRqQcgaBCJrMs4HH9A8zXpoO6s5/soewBKBWP9gd8TBA/Gcg3+?=
 =?us-ascii?Q?HJQQtaT490K1sxqqOAnYVhB3QYGo7bcNuKtu4x0oYjNrPn52WhS3+/0Rzind?=
 =?us-ascii?Q?PvkvrbPm4hpro7xgipVUZ4Ox6x5SMFE7BVW0TQZj3W6gORJ0D3tQYFnC7hTe?=
 =?us-ascii?Q?iSUEOObWBXHxvECNaS8Cf2/6IiZISEuAKWNbpCgMjVdkei+dxaZL7Sv/YgWQ?=
 =?us-ascii?Q?HB9e3EfeWF3Z7rqj6dJdwAXGTgAm2AkuSPPbJYNE1fBYmRYXdhjh1eReigV7?=
 =?us-ascii?Q?esT4eRr1vrmIaXCG9xeHyDdmgRkj2M/qyafTRIwaRK0kM1wJZ6zaydt9UTc4?=
 =?us-ascii?Q?TdAoNLzN3MmB1vYY1ghJBUjodZLgqAxHLstBX+tdzKNhC5PCRGmFo/8mRFDP?=
 =?us-ascii?Q?ObU1Z/QJjymr8AD4hPF/7CidFYFPT2qLeAhWPZQvk/4YgtiDBncJfkhZfLBg?=
 =?us-ascii?Q?R+/zuOPyKL6mOSn3eMlP7wf28Tl5HeyG0l8DzXcd6s9g/ySjTvFN+ZrJeLnP?=
 =?us-ascii?Q?URvFwCuaAHM0uLlQ0jbRNhp8lQeFom7KTiK9A+0FncDCEO+pBixi2Vwk6EE0?=
 =?us-ascii?Q?7ZKhUDwGrKpg0TR1GtdKqZPYSbcEMRBUq5OhbgyHlfE+MVMGnM90kvNTOhjz?=
 =?us-ascii?Q?ZwwuqosovO/1eNIHCpVicvXKMSNV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PFiaD71P6kBzQhJ68miNe3Q8IhMbRmw/fa6txCxVLxLjVhYL5mNvbQ4Ppv01?=
 =?us-ascii?Q?50r+1nu4hVPAtD7JAL/oMLVOItwzThFH3fggICBKG/YwWH8PLOghOVR2+uKF?=
 =?us-ascii?Q?6QmWYaU6oExOED4kABBbMCJsrCtivI/Xe7Mpw1f54LxwhiY7V+EUQnKxwMv7?=
 =?us-ascii?Q?N9kdQiBqgLB2bcAngNznaXFZc915WnPlFTKok9UshpZrUAiO8Y6xH7JdMXCq?=
 =?us-ascii?Q?/PEPykUkrT35TSZsKGCjTo32xmxmfJjCQph8Lfwt0mK51c+TBWxNJ8VNeRut?=
 =?us-ascii?Q?ppKrjpqq1POE5aBoacmF8+0+UkCFFOCOpGwfzLWv43Xgx4c8t8XH2ML4Uek6?=
 =?us-ascii?Q?VTnX0SbDRBwrobJ/fHo1PGGrycThARYos6pa6V+Swd1PeyHr+aSRndB3ODin?=
 =?us-ascii?Q?UcL97JcV7uXDbLDEDhhlxK7VC6iyMy76DqQFvSatO2qzCQx6YTsEpoVWPlIy?=
 =?us-ascii?Q?fnTADES7fitu1vXxLt0aRQ5yE4jpi+apo8GbeDfEF1YRuipopsuANSUiJaYL?=
 =?us-ascii?Q?7SmJPkFFgebcPheXoT/i5rnH6nAACPeKqkf1XLUHvB0SvRN9j0u2e0KtAV6K?=
 =?us-ascii?Q?l+JZn3DdWtdMkszaIx8IPmE3zzvFbQUvtgilWYvJJ20+iBk93V/8Ck111KLB?=
 =?us-ascii?Q?mCzPiAETBjBm3tPxp0VwL75fbRHgGAs+VKl8xA2S0EW2WZpVY81ToKZYAI+B?=
 =?us-ascii?Q?//bACER/uoRotBY2ju15H0Ko0Bxcq6MeEC0doiDJCFlRbeJM1EVjE5IHAae+?=
 =?us-ascii?Q?6OmLYmE+QsOo2IeosjAHr2kapPjmYrmF4uXary4eCzv7FlOTHD4U7Cg2qMrJ?=
 =?us-ascii?Q?5+k4CQmLpS6aLg9aZK9HojMkfjvnE/eWapT3y+omCxiLQ+/1sfaspWquXW8F?=
 =?us-ascii?Q?2ufZBJ2S5Wue4KFpX8Bu5NNI0O/m3m+jwrGdziZxWWKN1ErVrXsef3Xi45G8?=
 =?us-ascii?Q?CC67KGxcYlYAqodIWgJzIFS0I7NagxCMieXj51u74XQom5LZcf1LiFN9hWMP?=
 =?us-ascii?Q?9p8z/17qDlfTf6JzehMHnPqOanLA9HeKFg8Bs5CrJ1lwZnSz5JNuuuJNJRdH?=
 =?us-ascii?Q?1oPpDAjfPsF0JzkImbZdWwhObcDnJvjnVmXSEdfUBL5hE9lAosberrkK5LWr?=
 =?us-ascii?Q?l3WutUUeSxpMLFHoq5251N/kwZ0kiEFjKrgAVHsnk5D5eQJ5FsAaPfGxaITZ?=
 =?us-ascii?Q?WNvHbgNxYjmP1JJ/Ue44sybL2zaEPBnncqiedC8e5E8HNP99DmzJHr8TLQ6J?=
 =?us-ascii?Q?0EGQMI47MRzjSW40bTjBQSvdyD+KkeRIq1XqsJJAqJmICPpqMhZ3oCr7XS3T?=
 =?us-ascii?Q?KhqhlH+dZ+4lk0J+nwv/nsVV+WrP9T7mZwjE3DA25Uwfahu57ujkRebkNbNc?=
 =?us-ascii?Q?e1X6SfiyAKqAWaJsHxbGCfx6KJS3Vi+pslMyJ+wAAsa+xS9Cg9yy+akaiIZS?=
 =?us-ascii?Q?dM+uKu7CJJwoSbkJe0NyzLHnoUvcEp/Mr0JogQfAMCeZEc13h89G0+/jBxlZ?=
 =?us-ascii?Q?yjqQlQGh0I10cJJsMrEUsu2QoGWK0R75t65uWzqtryJfMhBZHjd6uI1cRp2j?=
 =?us-ascii?Q?Yu4MzLPKKiVdbA3zpT3p2QSB/fufXUgNcKNbCHKmjT13feCSuylOgl8DMvq0?=
 =?us-ascii?Q?ew=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbb9195-77da-4e11-dbd7-08dd6ab62be2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 09:28:01.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUV7FnRiMFspUkcXwo83qAOFt13l81OoSg9aX9xVtldMAGR8YcxiX7AHt1RjG56aRbRK+B2+uTLPRdw+Go9whu1q60o0NYYdZL/LlsV1t74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7209
X-OriginatorOrg: intel.com

On Mon, Mar 24, 2025 at 10:41:06AM +0800, Herbert Xu wrote:
> Hi Giovanni:
> 
> On Thu, Sep 16, 2021 at 03:45:41PM +0100, Giovanni Cabiddu wrote:
> > +	/* Poll status register to make sure the device is powered up */
> > +	ret = read_poll_timeout(ADF_CSR_RD, status,
> > +				status & ADF_4XXX_PM_INIT_STATE,
> > +				ADF_4XXX_PM_POLL_DELAY_US,
> > +				ADF_4XXX_PM_POLL_TIMEOUT_US, true, addr,
> > +				ADF_4XXX_PM_STATUS);
> > +	if (ret)
> > +		dev_err(&GET_DEV(accel_dev), "Failed to power up the device\n");
> > +
> > +	return ret;
> > +}
> 
> I just received a bug report that this printk is triggering on
> a warm reboot via kexec:
> 
> https://issues.redhat.com/browse/RHEL-84366
> 
> [   11.040319] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Failed to power up the device
> [   11.148557] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Failed to initialize device
> [   11.148702] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: Resetting device qat_dev0
> [   11.148809] vpr089-p05-15u kernel: 4xxx 0000:01:00.0: probe with driver 4xxx failed with error -14
> 
> Could you please take a look at it?
Sure.

It could be that the device is not get properly reset during a warm
reboot. I'm going to have a look.

Thanks,

-- 
Giovanni

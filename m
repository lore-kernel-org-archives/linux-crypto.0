Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3A510E4
	for <linux-crypto@vger.kernel.org>; Fri, 30 May 2025 06:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748586644; cv=fail; b=vAiNpAelkrJedLu5eKXxww4NA594G29B3BiumC4ZL1gAQ+QYNIlxPNnb7StJDrmCSBhVz6ggYkcmb6OpDarNLEPkc89sAsTl4gX2Bk0ZFzDjCCg24hz5XDu/2vh7x1BcywKQhbvj3oOg7L56Oyd6iKFGJV4x3lmcZyb3mbHExqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748586644; c=relaxed/simple;
	bh=KxdGtTXaktmbSdlFvs1fMfTAYXM7a9W/V7b851wyELk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q/whuqRdwD6POrkEouOWLGVd3JFuEeOIgeK2gf8aa7OVmhOcTLV2vAWPdD1FVJudbuwXkDQ2O5LCkjL/GU1gzxHmC1Os9uyMjCXjoM82+PM/cQUeCzMsLkThHXnfSm8c1nHY2516zkvf3ckOpCQDv4vrEFy0cHVWcwh6TbZD3Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gYN4Ox58; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gYN4Ox58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748586642; x=1780122642;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=KxdGtTXaktmbSdlFvs1fMfTAYXM7a9W/V7b851wyELk=;
  b=gYN4Ox58Tks9df2kpLxZQDM1HUm/rE4o9faNoElygSwJETeez51hAbeH
   oDLn6cZo3iskC7fKEwaJObMemnO7qVnfYdJczJkD3FfRpFhvv78lRvpjA
   zhfv/JLNO/Bd73c/3jM3n2IaRFWCMKYqpKHhtEmba1w78KsprxqN7zmE3
   729Nc5PUgU+rjv+T8NvtOtwM3u+Elzs7V3gBs5N6Yzm2d+jIM6BC/bP2M
   GiP1NqeU4M88XWCyHAzfgUCih+alYb8t9JqTYXZFbogQf982qFcRIQ7Vs
   3dcK4yaajV777wu1qynouq9hruiNPIkxAJnxRmbfDujc19L+8SuUY6uLK
   w==;
X-CSE-ConnectionGUID: 0mQPKRrDSeGb0E/htd4wpw==
X-CSE-MsgGUID: 2qEPWtp8Tp+6oQkm925YVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="50820191"
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="50820191"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 23:30:41 -0700
X-CSE-ConnectionGUID: c8v4vcknQRuY4yc0zSC9Rw==
X-CSE-MsgGUID: 8BXH8oUeTVSVmq8qFS0jfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="143701983"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 23:30:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 23:30:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 23:30:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.64)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 23:30:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xP0a0ZmBd7FYVpQDoEANLwtHyL5EyBc95qVkHcpm9T9DqQ8Qz8RdUpm3HNDTjzAOBgz1OeYVkUzl4+mfXpW2a27ND0WN0zYgJ0I/KB85ZJuggEe2/DkQTqj4ioDHdoYn01bRlLRvOQc7cGUXIxR19N5yQV2QxGuEM6ONYvujUfTbWvvxwrvOqcjptfE9vQLMnAf151ehJbIXbNfw4maL2G1J2JhvOaov1blCzp8W/y42wR3Sy/cQrLb337LhEuTgHMGgOleW54aKkNQ3I0NPcjQA2r6ay7+L/kEyR7sRjm3OPq/SLghX+t8NgqRVRqkmKqtlypZkrj8QMoGnVdfHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f8KFWSIu2dXDK0mSQ66OLLDQJfuGwXT8LI6uXCcdIxg=;
 b=eIBkSYn1RCz68LChWSdnChikLSZPMHZOQYIlMuiwcJRKpnNZUS1I6Fwl1i3JEFnxyytSWWCuouM5kb4yTw0cyrzBDj+38cBFgBdcMOkDYCmALaI7PcQEfeHpOm7YJdYcOSs9hlrnorps1Wlu/IdY6EnAwAGAhqsedI0SNyXpaHiXDM6po8iaCRzxeIoih4Vrvxd8JSYWeZmTSB/hcDd13io/O/Pn+yXF0v0zJLauEKq22CFHgYl1OUsB9FpyJw2t0Q5XeWFu2XZTo1aa9gXJzMp5d6eV8Ec3U8kayeDGISljtsgZPJlHuZI20eOhxjZbTas8KW6kZfqKC+hPONkD7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB5000.namprd11.prod.outlook.com (2603:10b6:510:41::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.33; Fri, 30 May
 2025 06:30:34 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.8746.030; Fri, 30 May 2025
 06:30:34 +0000
Date: Fri, 30 May 2025 14:30:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <qat-linux@intel.com>, <dsterba@suse.com>,
	<terrelln@fb.com>, <clabbe.montjoie@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [v5] crypto: zstd - convert to acomp
Message-ID: <202505301305.ee79d8f3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250527124302.533682-1-suman.kumar.chakraborty@intel.com>
X-ClientProxiedBy: KU2P306CA0030.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::16) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB5000:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db3eddb-03c3-4aa0-dd9f-08dd9f437b53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FrOvBraxe9HSP8KUdGKNkeCDaC8fzR694e2tOlBz0cO/0BWq1AOMW+IELWRi?=
 =?us-ascii?Q?2378x7APz61u1JalxRVJ29ABLPCl4/EKmtGwEjdl8TEs/TrH4m3T9NfVYuic?=
 =?us-ascii?Q?55VwjTg0ndVPTkOELev3qY9JFJ5JdeAKF1gk4gzL0uCCpTtXwa2XHZ0nSoHU?=
 =?us-ascii?Q?y94M6Yat1YRswcpwWFK6pEjDsiWxsobVQOsXB2BnJGfp1FzEBSEhJAB8WcuH?=
 =?us-ascii?Q?8yA8gkl/Vq7UxavqDX2TxCasNUXIx7/Bftm3WOBc4ee4zRWMU13PvAvaxggS?=
 =?us-ascii?Q?uVFBi4moisdi+Vj7jcXYBjd/IHWefpkmDGQRAa7zbkQQdg05m5b8Rj+eMxv5?=
 =?us-ascii?Q?OwYTJBMDGWHJTN8rpi/ssG726Nn3MmeejLc3Xcxrx555qxS5pXyeOIzbBtX+?=
 =?us-ascii?Q?aqylg1+nUjdYHF06rBBRSozw3wPwxArnRNyA/C3o/goBETJq/2LY1kxOcngg?=
 =?us-ascii?Q?M3lMHy+cjLWrDIXvGWq9YYI+pgg/ftRu/ceA6uDWZKoOB/IPA9CX4z+SGBez?=
 =?us-ascii?Q?XlXSSqozOBoKmO9E04FfDUstWkXOTMyH4B4pie4obefdhlz5CvVOfvOH1Ig6?=
 =?us-ascii?Q?Rh/fXh8b0WqxtGJVPof16dQaqTQEMaF5P/7ngMl0ve/tobmfMVMDDvI06hac?=
 =?us-ascii?Q?wjPN0LIUqnvMVO82gZrLbn3MpGw4jnUhqCT2P6hjKIGgign3/96RJwAoRs2z?=
 =?us-ascii?Q?/yEXnWwwoB0zR53rl9+80K087UHYb0hlPdDNEUaGAOhxsCdZxNPdzkIXIuwN?=
 =?us-ascii?Q?431abn79jFAMgfcAm2zLIPJGrIbqPnqUmPDTOOb/ShvSgNK9Ore5d1DZKZ6Z?=
 =?us-ascii?Q?ZjNrbyZDVDhhqylBaUWr4YIGI1tquCv+6SSHPDxCaaWECW956XkuhYR1Z2+W?=
 =?us-ascii?Q?ZDkeUfWeypafPc5G8YLXLxd98PyRFDWh8BD2F/wxyLmz9YVh1c0y7bdIIHtt?=
 =?us-ascii?Q?VoLjgVhY50Fodry7Ti23hwjzfoSEYSZdLssISsC5BPhDVLcwNJ6aSw0pCGZY?=
 =?us-ascii?Q?2ybqxBVNo98buzcyIo5IMT+Filuq8e4Mc37hpLaqiw2IhEkJC5qpEpwilj6L?=
 =?us-ascii?Q?7r+IZaokLxiDpiPUdtI7+QADursAGgU32DSBTOQn76wluUTMTQZLUpXDsI7w?=
 =?us-ascii?Q?a99oJPBYrUiiyB7jQ4BBRNN580Wixl7E+BDbINfeGHf3rIyZtDEUuxb+qYby?=
 =?us-ascii?Q?AX8KvXmLGqekMGQF81WbULI5VZdp44zrGS+wR4Hqwww2aNdaZj+bwelYJsL6?=
 =?us-ascii?Q?++8cbaV8FlCFariv2XBA/PoM7XlW3QbhUZiIXX6D5qm2+hTelqaimU+D5f3T?=
 =?us-ascii?Q?kVdYoid3Pp/Aub907r/zSZbp/ylmiU3L/BsJOWo1xQzFCP+gbBQEkSN8sF/d?=
 =?us-ascii?Q?XJWb+ifmlVbwxmXVMCUbyyTvX3LO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0kWZtB5th0xYye5g1e03ZsyvWjco/fbypOUa8NaL4Lp4eVHJl2BDuPK7SCB0?=
 =?us-ascii?Q?gEx0he55JG1srpwpyZHh3J51BSeTm69DZ8+QAeYTX8qiqhO0LmG34GxSCMDm?=
 =?us-ascii?Q?kOrqitBGuZsA1VzyNjt6ERiOy219hlws3M4G1ILsz7f8yefxUAhIcOPjGH8e?=
 =?us-ascii?Q?MIXmvNXAS8UEnlKLZkem0WrsjLKdavD5HE/1oHk6iCRAp95Q7AVEj1h5E2cr?=
 =?us-ascii?Q?Yc24GtnakcZuw3Q/RSLsOn9BX7YotsUsQwJOSEyBCfmjEo//i5c136vR0eT3?=
 =?us-ascii?Q?LAdFbeerXugw+6IU7z0yBA94MXOIqvKc5UgEcQWb6SJ+g731dJ3422vXd+db?=
 =?us-ascii?Q?Pz4ieJX1KbtxlhKXqLmrpJw6K6qmRM4G8YOAEcypmcbqXehe13zqQ03ywdD1?=
 =?us-ascii?Q?JPyMnDqh9mJSi6TISWurYxOnVEWyeUQ0KncbKPUhoJXA+0t5PtsTZr7a5Blu?=
 =?us-ascii?Q?LGFPRwX60NMXuiVW5XxW64IbQPjly9Wb2FzmPSxqRxbKFFnLb5fgNBTOLIvB?=
 =?us-ascii?Q?QCbPhNS+uRXu/nOv4E9WlGSeQRtH3zX2H7fdeDmzP11sZPqytCJDrLvMdipQ?=
 =?us-ascii?Q?LnwmCwXLLBhGVfRaPrSpM/oQtkFS9frr+SH/jakGpXSnoQCNy86Hv1gPk01T?=
 =?us-ascii?Q?w86b3/dsvLmGmgRohl5BJQd24qPAY4MeXfMnKkmwpPaYKB+ZdgwxOO5mHcHI?=
 =?us-ascii?Q?Zm7N6/VuGmD3OVI1KlSc8pcuLI84GqHtbtfTQtTJUtw2QQUgvPt+wXFVVkkk?=
 =?us-ascii?Q?d9U56tt2zBD44NzuNABiJvUa5j4QHxGsNwxCex9niTE+WpbwWhIIydVRq0a7?=
 =?us-ascii?Q?nS1ATJUTOMu8NmTBpywB9glDJNeYZFV8Dp1Gr2+tX44LZIuAZKTs7H5zf7v+?=
 =?us-ascii?Q?/0u2WWw4uV3OOogZ5OTy2P2cr1W3DdJI8Ak8h/e8ajL1G9W/X0pvzp0evNk0?=
 =?us-ascii?Q?VxKbQdw9tf//oWPLmln1Zy09JmxJzd9R5Bfrl6YebrSWio2++4pUW2dvUjF5?=
 =?us-ascii?Q?LqELKv0lwPx32+BXEOHzDW5fXbl6/XO3vzaBtfs5Xb47muxQY5kkYMYX2P/f?=
 =?us-ascii?Q?jSo0Bhf9RvSju0dpLcrFfjUhmWW4Atl1nOljgomP/mw0phPKvoro08cF4EDe?=
 =?us-ascii?Q?OlKxfuu/dLymM0++rEdJIp9lhmJy8PKNo8llUw6yqbB0o7R4orr0W3UhOMj7?=
 =?us-ascii?Q?WHiXUfAGNtW+BhfPm18AYq28Zwo2k/vyS2dZJeepdtsevDQQdLIU+U64eJNp?=
 =?us-ascii?Q?EFE5zgUsUzBsr8SjmgHKZsMA6HlbTdb9K0iSHDtUkQsI/80z/hn5yvgBbn/m?=
 =?us-ascii?Q?ArtO1hnpA16TyqzRn1p90XTieB+0QmesE30ttgIWag6P+LLbwPMUlxhzjM6A?=
 =?us-ascii?Q?NMoDOu63z38dks70QFfbGU/1+JCAdEc3wTANNNI6sd/Dkl+hzoPK2YSXVbKi?=
 =?us-ascii?Q?H/tc/yDn1hqMLkrYN2/KJ9DaO9i4jlNVo7KaQdDIYlcqyowfcRguUzwS0dxX?=
 =?us-ascii?Q?NLTyUzNj9MTh73tM9SHbhHbwSvJRiqwMLwsIG1X/4tI7ba2u8Jgo3uMfbDyF?=
 =?us-ascii?Q?19Zw53yY02SHld2TZOq4edQZwP7aMnwb4/q/vQuB/q/gYhTT+BjiGwAjCIww?=
 =?us-ascii?Q?vg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db3eddb-03c3-4aa0-dd9f-08dd9f437b53
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 06:30:33.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5SsyL3WwUahC7UKpyrDsw2vwe9FiLS4bUfm5A6oBI2nFNj0kDKXPg2NoQDvX4UZJK/6zsEA1onwnTe+CbbDUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5000
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "WARNING:at_crypto/testmgr.c:#alg_test" on:

commit: 5ff7b07fa1266efb5aced0ad981974c6b0ebbbef ("[v5] crypto: zstd - convert to acomp")
url: https://github.com/intel-lab-lkp/linux/commits/Suman-Kumar-Chakraborty/crypto-zstd-convert-to-acomp/20250527-204451
patch link: https://lore.kernel.org/all/20250527124302.533682-1-suman.kumar.chakraborty@intel.com/
patch subject: [v5] crypto: zstd - convert to acomp

in testcase: boot

config: i386-randconfig-012-20250528
compiler: clang-20
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+-------------------------------------------------------+------------+------------+
|                                                       | b939a747dc | 5ff7b07fa1 |
+-------------------------------------------------------+------------+------------+
| boot_successes                                        | 6          | 0          |
| boot_failures                                         | 0          | 6          |
| WARNING:at_crypto/testmgr.c:#alg_test                 | 0          | 6          |
| EIP:alg_test                                          | 0          | 6          |
| WARNING:at_mm/vmalloc.c:#remove_vm_area               | 0          | 6          |
| EIP:remove_vm_area                                    | 0          | 6          |
| WARNING:at_mm/vmalloc.c:#vfree                        | 0          | 6          |
| EIP:vfree                                             | 0          | 6          |
| BUG:kernel_NULL_pointer_dereference,address           | 0          | 6          |
| Oops                                                  | 0          | 6          |
| EIP:memset                                            | 0          | 6          |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 6          |
+-------------------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202505301305.ee79d8f3-lkp@intel.com


[    2.703189][   T82] ------------[ cut here ]------------
[    2.704516][   T82] alg: self-tests for zstd using zstd-generic failed (rc=-22)
[ 2.704572][ T82] WARNING: CPU: 0 PID: 82 at crypto/testmgr.c:5886 alg_test (ld-temp.o:?) 
[    2.706216][   T82] Modules linked in:
[    2.706621][   T82] CPU: 0 UID: 0 PID: 82 Comm: cryptomgr_test Tainted: G                T   6.15.0-rc5-00384-g5ff7b07fa126 #1 PREEMPT(undef)
[    2.707912][   T82] Tainted: [T]=RANDSTRUCT
[    2.708361][   T82] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 2.709408][ T82] EIP: alg_test (ld-temp.o:?) 
[ 2.709886][ T82] Code: 52 68 87 c4 77 82 89 d7 e8 3f ef a4 ff 83 c4 10 b8 fe ff ff ff 83 fe fe 74 9e 56 53 57 68 f7 86 78 82 e8 45 69 ac ff 83 c4 10 <0f> 0b 89 f0 eb 88 8b 45 f0 81 fb dc 00 00 00 0f 83 03 01 00 00 8b
All code
========
   0:	52                   	push   %rdx
   1:	68 87 c4 77 82       	push   $0xffffffff8277c487
   6:	89 d7                	mov    %edx,%edi
   8:	e8 3f ef a4 ff       	call   0xffffffffffa4ef4c
   d:	83 c4 10             	add    $0x10,%esp
  10:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  15:	83 fe fe             	cmp    $0xfffffffe,%esi
  18:	74 9e                	je     0xffffffffffffffb8
  1a:	56                   	push   %rsi
  1b:	53                   	push   %rbx
  1c:	57                   	push   %rdi
  1d:	68 f7 86 78 82       	push   $0xffffffff827886f7
  22:	e8 45 69 ac ff       	call   0xffffffffffac696c
  27:	83 c4 10             	add    $0x10,%esp
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	89 f0                	mov    %esi,%eax
  2e:	eb 88                	jmp    0xffffffffffffffb8
  30:	8b 45 f0             	mov    -0x10(%rbp),%eax
  33:	81 fb dc 00 00 00    	cmp    $0xdc,%ebx
  39:	0f 83 03 01 00 00    	jae    0x142
  3f:	8b                   	.byte 0x8b

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	89 f0                	mov    %esi,%eax
   4:	eb 88                	jmp    0xffffffffffffff8e
   6:	8b 45 f0             	mov    -0x10(%rbp),%eax
   9:	81 fb dc 00 00 00    	cmp    $0xdc,%ebx
   f:	0f 83 03 01 00 00    	jae    0x118
  15:	8b                   	.byte 0x8b
[    2.711902][   T82] EAX: 0000003b EBX: 84f9fa00 ECX: 80000002 EDX: 00000000
[    2.720746][   T82] ESI: ffffffea EDI: 84f9fa80 EBP: 84ebdf08 ESP: 84ebde60
[    2.721478][   T82] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010286
[    2.722299][   T82] CR0: 80050033 CR2: 77d20327 CR3: 03341000 CR4: 00040690
[    2.723047][   T82] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    2.723759][   T82] DR6: fffe0ff0 DR7: 00000400
[    2.724246][   T82] Call Trace:
[ 2.724611][ T82] ? kvm_sched_clock_read (ld-temp.o:?) 
[ 2.725147][ T82] ? sched_clock_noinstr (ld-temp.o:?) 
[ 2.725673][ T82] ? local_clock_noinstr (ld-temp.o:?) 
[ 2.726213][ T82] ? __this_cpu_preempt_check (ld-temp.o:?) 
[ 2.726782][ T82] ? __this_cpu_preempt_check (ld-temp.o:?) 
[ 2.727341][ T82] ? __kthread_parkme (ld-temp.o:?) 
[ 2.727843][ T82] ? __kthread_parkme (ld-temp.o:?) 
[ 2.728433][ T82] ? __this_cpu_preempt_check (ld-temp.o:?) 
[ 2.729006][ T82] ? lockdep_hardirqs_on (ld-temp.o:?) 
[ 2.729570][ T82] cryptomgr_test (ld-temp.o:?) 
[ 2.730042][ T82] kthread (ld-temp.o:?) 
[ 2.730476][ T82] ? schedule_tail (ld-temp.o:?) 
[ 2.730950][ T82] ? unregister_key_type (ld-temp.o:?) 
[ 2.731474][ T82] ? kthreadd (ld-temp.o:?) 
[ 2.731914][ T82] ? kthreadd (ld-temp.o:?) 
[ 2.732368][ T82] ? kthreadd (ld-temp.o:?) 
[ 2.732796][ T82] ret_from_fork (ld-temp.o:?) 
[ 2.733256][ T82] ret_from_fork_asm (kbuild/obj/consumer/i386-randconfig-012-20250528/arch/x86/entry/entry_32.S:737) 
[ 2.733764][ T82] entry_INT80_32 (kbuild/obj/consumer/i386-randconfig-012-20250528/arch/x86/entry/entry_32.S:945) 
[    2.734274][   T82] irq event stamp: 389
[ 2.734695][ T82] hardirqs last enabled at (397): console_unlock (ld-temp.o:?) 
[ 2.735568][ T82] hardirqs last disabled at (404): console_unlock (ld-temp.o:?) 
[ 2.736449][ T82] softirqs last enabled at (200): __do_softirq (ld-temp.o:?) 
[ 2.737295][ T82] softirqs last disabled at (189): __do_softirq (ld-temp.o:?) 
[    2.738129][   T82] ---[ end trace 0000000000000000 ]---
[    2.746180][   T92] alg: No test for 842 (842-scomp)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250530/202505301305.ee79d8f3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


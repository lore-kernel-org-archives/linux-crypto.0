Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011005.outbound.protection.outlook.com [52.101.65.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A207326930;
	Tue, 25 Nov 2025 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089513; cv=fail; b=hK9ce48RcC8vwpraSi2Jtl9I/W29fwL1yVxOzMo8q+K27xWD+6kd+Gaf3DPvsbhmuoEJ0MIFagzvUII4Mt/tGvdqXkQ47maDmEHwrWZ1oFaK08JvMvnif0Z7lrN4zQY/vM/Uz3pjL+C/ztwHgRoQob+hzyECWfanW0LjglbyCv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089513; c=relaxed/simple;
	bh=lvV2oxBo2IVNI3r3mfW2M3AZKR9bDiOBF1htz6qq+20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oWfl75T4QvAES0eck4dZaZsUqkMrKvRVsvvY/ybfgCsU0nZRzB9DI2swtfdrsk4jQSATeMi5JIIgnthrU1Utxq2KKpOzLbIaU8vsWC81qGETQ36Y5IgZwkGEDZKjWRj+168NsYfj+9udXzV/okg6H+laAAdYACSD2WDAEKfjGX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=mMgRh28X; arc=fail smtp.client-ip=52.101.65.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="mMgRh28X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tvo1bqoJ5eUvRT7LbxVOij3XCLLr4c2WUXP9Mz1c9XG11IkqhHE3nUzVJvVFMB3jvPYAypqDYW/Idns/jnI1rPi0Ya3DAbYCIZnKUaV1hCHrAp77JXLj/NWvzMG8MmTYRz6YQSYKq5abS+sfPLffDSlBpLXg6Dvg44n9imXyLe685D4t67uKSTdCI3LrXQOTnny7SQe2433Az1ei/RWp9S/Ck/tBREeJWn22vUqbnmebG9tA3zJsKIOWZ0MJIQ6uxeQo6fwxIenE/C4ZB2B2UFVI5ME9lxlXKufhZMjcvJ2+HSZXHp/4+AqLYtIMXNDMMbHDcTvJV2zevhFWmCKqNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esieeSGM0P6MF42ZBRC44HSBreJyH05cavxc8O6M7dk=;
 b=Xoe0E/SlUNMRx39X00Cp7JLSpn541PSclOJqdwHmNCHxA0t5+00wO4cqdifukiWSKng6Y7bGGl8mL0AovD2y/vXwfKFeL0OC2JXN40xx05yR5/TNTiKliMSXpZiVbp3bxuD2duzVn+kg4j9P42Z6JGXQo+1B06Di74bS8VOsLSdw1S2yx7t98HZAK+tngRT5JO3ejOr7y/tpJGXXtzdmY7nV+DuPvIU9F8vI4MUGaGovedGicrBA5kf7Rx//NNEf7NwfUWiAaTqbW8zS+Olyi+nZpHvuW+SseDZW8k+eWjCdiBsEsXvuvj0N08gdTNdq7lkfKi9ZUrDgiQqEDbIAZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esieeSGM0P6MF42ZBRC44HSBreJyH05cavxc8O6M7dk=;
 b=mMgRh28XwiOsfd9NNC8CFZFsArDDtyP2t2HXe0dnUQ/flP3br3AZtXnCzRCYePI5EIto09kHazFCm1WxDtq5/KYVb3gX2s7ctAkfw7XyG0oEbVe8hD6jrM6rQ0UIAIoFltiYUliHLXPJU4ofGMZQWaAjH0MJ+/SshP3ueVaO3iS+d/rVKdJXpKdj0NHyisgpm++OvX8yKPE5ognu0CKGP2wwhb/+KSo05l7QgS7LQrW9mNXPILpQ1yjjgY4tSBwmyWkGC28Ryzp1IUmUfB6sbaVCpXV3B/5hnPv+MM8KwlaKpkr7iGkbQokEZ4K+yDaXm03yv2dO5kMErt1wuBii+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com (2603:10a6:10:2e2::22)
 by PA1PR04MB11469.eurprd04.prod.outlook.com (2603:10a6:102:4e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 16:51:47 +0000
Received: from DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196]) by DU2PR04MB8951.eurprd04.prod.outlook.com
 ([fe80::753c:468d:266:196%4]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 16:51:47 +0000
Date: Tue, 25 Nov 2025 11:51:39 -0500
From: Frank Li <Frank.li@nxp.com>
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, oe-kbuild-all@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/3] m68k: coldfire: Mark platform device resource
 arrays as const
Message-ID: <aSXemx7nWJJFRWwT@lizhi-Precision-Tower-5810>
References: <20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27@yoseli.org>
 <202511250103.RMNoU3xH-lkp@intel.com>
 <aSVgcoNNeLJshwvU@yoseli-yocto.yoseli.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSVgcoNNeLJshwvU@yoseli-yocto.yoseli.org>
X-ClientProxiedBy: PH8P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:2d7::26) To DU2PR04MB8951.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PR04MB8951:EE_|PA1PR04MB11469:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c312ac9-483d-4f1e-a2e4-08de2c42ebdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|19092799006|366016|1800799024|7416014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y8D1DNUIW6nFebw+yHi1FAm61NIfWmhHeb+U+aFz3f1ZLSKNbLkcuk952OP0?=
 =?us-ascii?Q?le7PP50rJ05jUBoNNaibk9mns3JnRHjq7dP86rdRVrv9hRVi5RgbFx9didAO?=
 =?us-ascii?Q?1iNye6NVSbrTV4/nfFPY5jegeyeI5+cIMxecm1UEgKbd+RgEXR5xsUo+qyLg?=
 =?us-ascii?Q?wZK8hDUKMup4vmhW2Qn+1GLQl/awppIWuVvLMB4HRJ20UKRzrt6421opkDSC?=
 =?us-ascii?Q?Ysp6NQ34sKX4pW42aY3phzh6ZoWorTLuGT69aO/ABVU9KXoL6pn7FWBC8+KJ?=
 =?us-ascii?Q?EaPHig/xHLCawV/ovMciD7xU6dwz0sq0TJwOIdi74+7jmxP8iYfnyI9Ahrp0?=
 =?us-ascii?Q?RU5pOCIWldLZWH8VC22rXfDNcnnHTKRNVhvEaY5f1oapgAwl3rLjpD4DtrvX?=
 =?us-ascii?Q?C58LWt3VP0JWwwGjA3XPZd1eVXikDjh8VuoM3Q3V8K6PqJv0HPoY9kTwUcgZ?=
 =?us-ascii?Q?anIpqCec+B2Lt6DJJ+itqtMoZ7CE7IdgJbLA6TLispNgbPkrNHQmWDsfWmtw?=
 =?us-ascii?Q?/vX75US+oEWYgVp+0qmbIQBakohQTV4JL4PislXj0T3RbE13A5XfTegsYyKg?=
 =?us-ascii?Q?MZxeCpP32xQ8jvnfy86Rx20ZQ1AtLcAcRIp0xDjl0A7LGsvrc2oi95cK0x8X?=
 =?us-ascii?Q?Abhwf03JdW5ngyOai5FR/6LcJeT3O4WYCRAkB9sABZYS0BDJQSqET59MAOcZ?=
 =?us-ascii?Q?cijmRqUVWvuygUAlCGOXrEH8EZJmLsAS6m8tijKiEywKYqiF81uYwzWr1jXz?=
 =?us-ascii?Q?Ky2Rj5LwBEglSMnPnhTgn/Aaywyj2xEZBByBd0/aXDTyL/MIyfdIl8luxm5F?=
 =?us-ascii?Q?e6wRc/OCzQcchAmHV0Jlanvbq8zvG96gzstJzvmXiJJy00MS6N9c8HVvX7RS?=
 =?us-ascii?Q?eIfomuQoG2X987HE9gyD1NdYUJo0GOD/3R9ROxql09HMnGE31Y1rUcWZWg7P?=
 =?us-ascii?Q?wq0lPXuliLlRbKr2ub9GJVbWEeH/soLc1PnNOu2Fd9G5GHHnLJXfAp6lFica?=
 =?us-ascii?Q?upN6j1NSydsGNY1Pa3d3Srueyvy9OnQHtIwwKbp748U+OzreHj6VEzKLVrE9?=
 =?us-ascii?Q?evpXPrOkCg4haGfjXD1d7w2HaiuS6rA9WRt8GO1SB4r+oCORC9aK6mH9F3NE?=
 =?us-ascii?Q?renCDL9RmJd09G1kHeGRBZ0klwNNzh/2tLToJUd7Ly/TY57DVwatOVJ+eSd5?=
 =?us-ascii?Q?2dd2Z0fzDG742dSYA81OAQKZ0Az2/wOcshXRtBEfKuR23u363uFwxV9TYVE9?=
 =?us-ascii?Q?lQBlNjaEQ/OXH6bMx4KjwiQvVxGwbe4fngjwVysdrzXzRFc5DeBBFO1bSR4g?=
 =?us-ascii?Q?WmgI7moRXm5Ao+PamKLilSg/ifCthlmRO6ZygAYccs5IQjNA4ooGxdAWkLwL?=
 =?us-ascii?Q?9CRZsdb2TAX5IxctRGVFEokOmGq9weSw9HzEixJRCi24Z7z3TJpV/NB2EjtB?=
 =?us-ascii?Q?IuTipKr8sh1UNjoAEUrSNfn044qniR7yn1VfPovNwDq+JcTKyLeF3w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8951.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(19092799006)(366016)(1800799024)(7416014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yAkmvWqzE7xQycYU/hAb3BQouGSpt4N7ieGRK9ozPaIMaH7XuTdd9KdVqh33?=
 =?us-ascii?Q?r1YcZLqGBj8uX2ntmV7E8ABMZ22OVJKo0LNtxD3OVbSQYGXSGvivWTottmgZ?=
 =?us-ascii?Q?qzaPbA1IXiY5+V2sT4LNta0lI8G0H9jlUXHcXo6KLkLLnbb/gr+co2DDsE3K?=
 =?us-ascii?Q?3cZdPB2Xe7AJQL5i9ax7fAl/N2qHQ5WMapN2cZLxdmdEowKZLA9dvgrF348t?=
 =?us-ascii?Q?tOdp1g8Jj5E43mtbTA0VE0XBIlzK+8hKAKX7lpknpqrhL5l47y/KADgFjHS0?=
 =?us-ascii?Q?SZ2woV9RfRnlSlp7QV52Yz/bRyq93I/pq9r6M4szwoLN214b69is6ySfdh5H?=
 =?us-ascii?Q?EBH9t3isWMRWiLscl7nsYQxxyetv8TscxAxecXJQ7p164KRdwXk5Y1Ujzc/2?=
 =?us-ascii?Q?K+jCyEvB2Wp2daBNKaURYKvUdu8web+oZYX55HBa3YV9qiLf7BQoCvfmJi9f?=
 =?us-ascii?Q?+YCOwuXhEf3YFqDCxRqXU2FJRUPdqElrP+mJqhBW+8OuidCPwwuzOFSBS8hl?=
 =?us-ascii?Q?9QYx3A1mC3lbWvSMcNBWNMQZTn5AooHxSoL92sWULNo1zevHV2ZvHTtME8zQ?=
 =?us-ascii?Q?NPyUqfuloWa0rfm1X2507qc4FR4nz8QMvDL6LMy3NfG+I+s/eVsDXGibn9mF?=
 =?us-ascii?Q?tz3YyIAAEV3KGYdREpUa8cs65a+JfmCiAvYSYbg22dILG9Bu4Is23f9pt7/Q?=
 =?us-ascii?Q?reju/dfawFfG2FvnXRQr6QcHM+7RkSUsPCtFRNF5E9e26POV5PEVPQlYBuPe?=
 =?us-ascii?Q?CtdbMUIG/m8LnfnTsJh3I5iBhUqpnbUXqCQH/4XMVU62unMZKyFkw9NZSoxX?=
 =?us-ascii?Q?3qgkdgLxe7MDcTRmzeo02a///7w/Dh4LgtK1NKUxF05pDJ9FmSIkhPPw+jWT?=
 =?us-ascii?Q?+JA3mCk9AL7mqsKAcnFH4RX8Ry8LcK334Qz9DjKyjc/XZhmWDsaZMzhLcyjf?=
 =?us-ascii?Q?nupPWHU6xp9GwfMVVehXOTeNve1KAYqtLCjF19OerhNG1q1xdM0yG8E0o4CD?=
 =?us-ascii?Q?1aUfDDLjb3x/nZWPsLybJI7LHc89vW/bLTO/AsYcR2uccp0o5akA47zOTEFU?=
 =?us-ascii?Q?rdsnxx+nl4X/qydTrCumH+ANzWWvJCEQVLJESNg2uFQhekgSIGJLyvdmw4B9?=
 =?us-ascii?Q?P5Vl19nLaMW+Tib4biGWX8imlPbiVqqv1QYDd+GQV2tcgkn6tWKFp9iyBXwX?=
 =?us-ascii?Q?eYpeI+XRa2TkepWawZMbEOcg86q4/L2y9S3M6g1Ls1rBVmpyzZXvJP9tyq10?=
 =?us-ascii?Q?lr4kse2NqdvhjIHjLD//B0S2xo65YBIHLOS6ODOYs72TBI01HeL9jgxXfhNr?=
 =?us-ascii?Q?GJ9p5fmifFvVDyx8OmIvKshueW83NLwF9GVHEBSG1OBAk4AMXYEKihu1ebbq?=
 =?us-ascii?Q?gtLAh97Uz2G2ePC4aoGGwii9GMrAWIIU407JF7+TNh5neQTN2zR04GOEw2xW?=
 =?us-ascii?Q?LggJ7439i7CfcoeAVhHuHYBNlRAVOe2jOfNiL7TnClqDRntdFa3OMPqkkuNv?=
 =?us-ascii?Q?1toiCVERPyE3CAT5xPxVEQ76sh4kzVDKUi9pi5HS+iFSp+r6hkI0T5iJpk8c?=
 =?us-ascii?Q?tP4CPyKzkvZ1r08bTEbVJKkCWpX1IONWkH1cRJdG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c312ac9-483d-4f1e-a2e4-08de2c42ebdd
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8951.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 16:51:47.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZGK6QhD+MLre4cd4LhyvbZn/BdjtabDYqGarw5TkRYFWP7UcsNGXGrNjVP9GwwzUa0+fmZzwv4yonGt1m1+dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA1PR04MB11469

On Tue, Nov 25, 2025 at 08:53:22AM +0100, Jean-Michel Hautbois wrote:
> On Tue, Nov 25, 2025 at 01:48:24AM +0800, kernel test robot wrote:
> > Hi Jean-Michel,
> >
> > kernel test robot noticed the following build warnings:
> >
> > [auto build test WARNING on ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d]
> >
> > url:    https://github.com/intel-lab-lkp/linux/commits/Jean-Michel-Hautbois/m68k-coldfire-Mark-platform-device-resource-arrays-as-const/20251124-210737
> > base:   ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
> > patch link:    https://lore.kernel.org/r/20251124-b4-m5441x-add-rng-support-v3-1-f447251dad27%40yoseli.org
> > patch subject: [PATCH v3 1/3] m68k: coldfire: Mark platform device resource arrays as const
> > config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251125/202511250103.RMNoU3xH-lkp@intel.com/config)
> > compiler: m68k-linux-gcc (GCC) 15.1.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511250103.RMNoU3xH-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202511250103.RMNoU3xH-lkp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> arch/m68k/coldfire/device.c:141:35: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
> >      141 |         .resource               = mcf_fec0_resources,
> >          |                                   ^~~~~~~~~~~~~~~~~~
> >
> >
> > vim +/const +141 arch/m68k/coldfire/device.c
>
> Frank, I mentionned this warning in v2, do you have a suggestion ?

Maybe defer add const until platform_device change define.

Frank

>
> Thanks !
> JM
>
> >
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  136
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  137  static struct platform_device mcf_fec0 = {
> > bea8bcb12da09b arch/m68k/platform/coldfire/device.c Steven King       2012-06-06  138  	.name			= FEC_NAME,
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  139  	.id			= 0,
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  140  	.num_resources		= ARRAY_SIZE(mcf_fec0_resources),
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24 @141  	.resource		= mcf_fec0_resources,
> > f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  142  	.dev = {
> > f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  143  		.dma_mask		= &mcf_fec0.dev.coherent_dma_mask,
> > f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  144  		.coherent_dma_mask	= DMA_BIT_MASK(32),
> > f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  145  		.platform_data		= FEC_PDATA,
> > f61e64310b7573 arch/m68k/coldfire/device.c          Greg Ungerer      2018-03-28  146  	}
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  147  };
> > 63a24cf8cc330e arch/m68k/coldfire/device.c          Antonio Quartulli 2024-10-29  148  #endif /* MCFFEC_BASE0 */
> > b7ce7f0d0efc1a arch/m68k/platform/coldfire/device.c Greg Ungerer      2011-12-24  149
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
>

Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA223C516;
	Thu, 25 Sep 2025 10:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795496; cv=fail; b=IOyq1RHG+Wwn5PlnWtS82yc7szPhc61E7oIG8A5OUVIV0MJ7opnDu7nQH1MmQFB/TNTuyK7LdDaB1RKS2JgKVjHu54cc3M0vw7WLDdcagKDjRYqC2ZochTtxv4yykqbNAoy11O8wVM7JrVbF3IUyWC5pJD4MrKSlE0bgd6ATF1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795496; c=relaxed/simple;
	bh=uetRFSApREvkjcajVabJlfOeHlcAM+mnExrgNgj0VMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rXVYpUjHxNOxFcnIIFGBeqRRhYvVTgQRyxiPL7A/XQVvb0gMrHv5cNowPO9IRUvmyKRB0tEU0cNYZfJvFsLBCuL3/lchVLLn24BjyIUWibc5ZwK2rCCVHMK8BxNtsNEkwDqQE+sk5L0oD4jSiZPITLQVBFM6owDTt6PMO7w7Tow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OgDAUrM1; arc=fail smtp.client-ip=40.93.196.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OgDAUrM1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXSc/cvLZQyV6ZoNuwKMyX8KpxHn9QIdRqsQlsUK3/XcfxvICRFfVFiJB8Dljye5WIkXvIjKYYK+xY9EIqnKfh5TE0GwkWXwDuQoMkHZJHi9VJTJKDTD9I/cpUKFn4ib67j/spiibtNXXE44fl68daPqgWKQTtz9/da0qnU3KElLy1nlft+Ldg5J9KhCKffjne0Wcx6tBkk8PmQ8+ySFZZOJIw8fBaKG3/xrCIe7sMO1px+cn4OFY1URs9GR3aaympaAVE+zCqDo0d6SEimBnct7sakVQcIXv4OqHGn8euFGvY+CtXaq/5Qv5D/iP8Q7VwpGiipOdRNklEV7Q5jAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnM03fidm3+aynXbMzePNi/boqkIryUjLWZfGcM8f7A=;
 b=vGobLOuQFS+VJdH4xpwGC1EEqku7C8GtlkbxZa1MVJ0IphIaRDGaU67TLZq4hWill4HaHDSacQ5zQmyYJcqMka2WiHU8MNKxEt6S2qlzY7R2N+ekiPCRD51TD3noJFdMAWdGYNrQ6dyadRoTVeHLLHBvo0Jpghvxv45/qgbC73n3T2h7AQfH6U1z6zE24lgfWvfEbpTjfUTgCSUZiTXugQHfdYeKGXlVPt2E6FJMAuypZdYPtkC+XTl/ZLYS7aNHK25m4/BxYshsjd9d+tH5CwVAwgSw57/Cewmlmt9yVBIEeLsImbdIAVcxL3KDQyIpjWCbGgP0PUYt92DmeJyE7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnM03fidm3+aynXbMzePNi/boqkIryUjLWZfGcM8f7A=;
 b=OgDAUrM1lJDCJrjFULB6h4xJy5f3EgeziseUkpkPEZKzWr7+HYhuBnyumqunxiJINb9mlbcktXX8NGyXueBM0ezIWqwf5ZF9ItnuRgxxDoa53x7jHx5oSiV22nHEi5KgoIMECkzCrfgbaym9Qfhf/P9rf5e+6gpLRY1kkjMWqeBk4X5lS4SMXP/1ZH4sXhTNPEpUBNBbz3TVJT2bU9BQXK+FOwvmpB3qzZYoBb4K6oYQbCkXhgnBK56VfZ4HoQjHCiJF8AGfGFOcYef7Knj1h/SKvxAcyvBmJ2X1NFuAq0qjVOce14O74OLDni3j+BgiqemCZuy9vgTm/eEyiS4P/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6092.namprd12.prod.outlook.com (2603:10b6:208:3ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 10:18:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 10:18:10 +0000
Date: Thu, 25 Sep 2025 12:17:57 +0200
From: Andrea Righi <arighi@nvidia.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Menglong Dong <dongml2@chinatelecom.cn>,
	mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>, tgraf@suug.ch,
	linux-crypto@vger.kernel.org
Subject: Re: [v2 PATCH] rhashtable: Use rcu_dereference_all and
 rcu_dereference_all_check
Message-ID: <aNUW1ZRt_pcR8eV7@gpd4>
References: <20250829021436.19982-1-dongml2@chinatelecom.cn>
 <20250828222357.55fab4c2@batman.local.home>
 <d1da3939-62e6-4ad1-afcc-5710ce3f6cbd@paulmck-laptop>
 <20250901170655.0757884ad7c2afb63ced3230@kernel.org>
 <615da75d-cb2f-4e7e-9e11-6b19f03fea6c@paulmck-laptop>
 <aLlflTV_SDwMB7mq@gondor.apana.org.au>
 <c3ada9ab-0676-4d73-9feb-9f401a031a4e@paulmck-laptop>
 <aL_4gCJibYMW0J98@gondor.apana.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL_4gCJibYMW0J98@gondor.apana.org.au>
X-ClientProxiedBy: PR1P264CA0038.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cb::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cc4d70c-5c95-4cbd-507f-08ddfc1cd3d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K0lC0dwW7BSY5bR/GENInWffI1RYNmyjhfTGF7A99p6I3GXAAHEAjRLluwly?=
 =?us-ascii?Q?2ReCusw3EyYc3m1e/ALLPETa46GbJRsDIJTvuKoCIf0Ywyg+NrcrncgnaWu6?=
 =?us-ascii?Q?3jsaqF43xU1HwV824aO2eBtZiy5KI0Z2xmBmBDuWSuWD9N7frb5H46AbUytJ?=
 =?us-ascii?Q?ablwP5YR3rSBm7pc4QanMlDf6J1MlOFxyxZqsu+LZBJtoAVzt2NWdw2mzhYr?=
 =?us-ascii?Q?/tbIJDkbdbFecobAgSCd/RmJPDXQVcbty+x/glGijPQn7NW0imYt++Y4hQ/T?=
 =?us-ascii?Q?vu9D/ioWJOuhXQmuOHEss6/BjPT1/XobN/tkW2YFgVjGcU/DKTj2qbGRAAOF?=
 =?us-ascii?Q?wxUGYtbnsxhppjOUlEK6DNo72+vOTGiS6nRVH9Gl1vXDLV6aNus3/WaTCreG?=
 =?us-ascii?Q?llqajKXVyUedHEE0xTqnXTM2m7NyomgGzUP9vBxRYSuCkypZV9fsRT6kzJbN?=
 =?us-ascii?Q?R+p4POqaa7OSqLp3FeKK823GfsYdhNUEanDhj9Q7cWbEhYMhHkFUJxPEe1iD?=
 =?us-ascii?Q?wGr8w0lzM6Wq5goYKB6U6/y/yGAeUa6u3cP8Sr3JDCL8VBk9qfoE0B6IuT5D?=
 =?us-ascii?Q?IXV6xwU4a8tJY+Rhie45NJhD7wz1bmYpiZl87SbSu/N0qvsQmons866dD3QK?=
 =?us-ascii?Q?rUSf08Ufs4qlJsYLpkGEKWMJY484I/CrWYrFK5gZFEewfFKa5n/LzVPTWBkP?=
 =?us-ascii?Q?lZr0rD8nSlIskWmisRI4cX0dr33pzTa7QwYJDtKDCWpWTYV147ypF4JWoCSO?=
 =?us-ascii?Q?UVBzSpt7UPVNFcscKhv1zML6V/H6toOY9K1eoMq9FUu02Mo03pj5HRowaEdv?=
 =?us-ascii?Q?4Fa4/a96VgEiLQHYAq5TtOHRXnd+468F6N6wh1JTan3yX1rZsoMHAtD9tyzW?=
 =?us-ascii?Q?FU6YBdgfghN7OpXVuxlD3x13mr+cSO1sfXhmn/H/GoD9AINTx2TUuV/Ms3te?=
 =?us-ascii?Q?/lszmGJvNUVf2VUGWsAmXx9uAAG0RKc7q4Na+5EucVDmbkfHmkEhyaC0FouP?=
 =?us-ascii?Q?JzW+dqW6HOmCpfq5M5Q5LKxrbc9y5RvrkJ6wztWQSqLyPCchdW/g5+yY2YYK?=
 =?us-ascii?Q?xzkJp/qaY54J91++VjUIJw7uXD3pMDCCZ6uIdcO77WIpTfiGK/gIRqYEKH1R?=
 =?us-ascii?Q?cEfvC1KyKno4u3buCuXKDeoiaVaMFRVkBZmeTrGTcsDgHzvFm0KWHswLxhFO?=
 =?us-ascii?Q?ZboSbr4XRyVDvdW6tbcTYOIgvW4YOBdHyWH+7qG8Qp2slLRZVRTRVE8Ez0an?=
 =?us-ascii?Q?tFrna7m/Hj1Qgo6/vG8zsoTp/qJP3yy6yvzcjL7HAOmekR3QLXj0so9UpPfN?=
 =?us-ascii?Q?iambxfz8BTjcNZDSfAP0UKI13SXsXJS/PcyastzRE742TvYJGAl5XwK//gVC?=
 =?us-ascii?Q?nm2EtlJc1bFautsajTvksMaDYaMDpuev40wy9utShz7mTalViEVcZFhuA2x8?=
 =?us-ascii?Q?OdqTnG+y4qaZCqVMR5ftLXzqOt0Un4xt8JXMqSJI+E+vrjCk7Kv0PA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pk6A1N5qCnDJJ0dBHTg1nO0Gg1NVI7JOX3V28h/XhUPNh0pDYRk8h0jMNCG/?=
 =?us-ascii?Q?jQkYNKItsaHWf7F86HZE5/4xAEan70PhEwXQa+8TXs1cX5dLZ7THzODmRD4W?=
 =?us-ascii?Q?Ece9lDMi5jVdvtTptOeVJ3eeyaPsSSyVIs/Y4wUoZJmw0r5gJkylDZiUWUo0?=
 =?us-ascii?Q?UbS84esysmskImy8iCUvRT2H5aV3OOZLSqmcSzKhwl9aOukeber8Nn3rZehe?=
 =?us-ascii?Q?AW2FUm2ix7r6VPcPaAzX4kOVt6i8HwHhUw+MZrOIEBc4OoxNFwu2VNZUULip?=
 =?us-ascii?Q?5av14/jD8XXn56MroVgRcakaIBlYGUmraRg0AOCYfezIjawo5rTnq93FHWKs?=
 =?us-ascii?Q?TlTxMb7rTYLpqHKQeO5iwmFpbYrXUG5liOqiHQmiZJS7P8B3AAy5ANfWWhCS?=
 =?us-ascii?Q?e/+OELoy2NJzxCVBCBEp4E7XTtw5RtmA7KoKdcF+pxudMxyVwI05O9XhrQ/F?=
 =?us-ascii?Q?Nygz/zOhjJaLr8h2A1EpAtjV40Id/+lc2ESZdX4gBFzE+hGNA61Of1VpIlwV?=
 =?us-ascii?Q?x118OhniBAvesvTtsq/TD7i0ZwcZoU2YRLwbzmoqCm/izn+MCeRClIhlenLg?=
 =?us-ascii?Q?tPQVkBzrY8FrKnhQdDXRRSDNNuvmfAadCmYnx01fpJxRBLLzrAKCgfn2eJID?=
 =?us-ascii?Q?8eCnji9ml83Faqn+NiEbRupAnRY17RIBnTKrConFvsNps+2vrDwObhge8yWN?=
 =?us-ascii?Q?lZf1KCxmJVML1IsAw8pIKG66VJ6WLvTrSbyfWMo1kwRIFqNZHqU4hPBucYts?=
 =?us-ascii?Q?3PJvofh/DesKJOJFKO5rLsImUuX3GViMIuuXhov9Zk4weuhQR3niSbV7hHk8?=
 =?us-ascii?Q?/dP31N7kuLSAaYO6udaEVV0E0eq7t+cAc8mMlT6c5tVaT8KQbqCr1qLGjlFJ?=
 =?us-ascii?Q?ARan1D/nPbASwisgGBPY3CVjfxBFXFGrYGLs7yKPsk2XKTwGg9cGw//jgZCp?=
 =?us-ascii?Q?YHLY/3lzwYCWWzWguXFwFO+96o6HB6Ep0q9EKr+s+5IdO+fjl41aMZVGJiIb?=
 =?us-ascii?Q?ArOM73VAOJ4MB0hCccC9yYdthLrDMX5Tz4tdxfRL2TuZ77jJJta32ERmDruD?=
 =?us-ascii?Q?auW0nfvH+0dVdCfm5bl/gxLxnJXpCwc98IpoPFlAGh41FCzMHdNF0LoibJxh?=
 =?us-ascii?Q?62hfFRj673RxiaQEdKkC55UsKkTSUkZDglbgS8Wk03e9X4vuSeuOOOxGHbK6?=
 =?us-ascii?Q?JihNEtOf1v2c61HQtUJ1/LfUdHvG2oMM33+A1uzmDsOHlVTqVnemj42Pu12L?=
 =?us-ascii?Q?avRKkNJ38cNnH/954wFW52YuVNuk0tm2pbMqpcFJ3PiTjXoQlMTeW4JPJLrL?=
 =?us-ascii?Q?h+5B4pAsISK62NI1iSAIB//7+RwzpuHIt+95pQyIZmb2SpGeJUklRExR3h/O?=
 =?us-ascii?Q?6BEKqhxYHoRRhh3VYob+17k4M0n9LHwQrTqNRmxvG+Z2bgMIJTG3qA8F0eLh?=
 =?us-ascii?Q?qilbkSoKHJKoNHUmCvQXEEse+cZafdduYcpDWdLuf2QbwXuMGohyjmuYij0h?=
 =?us-ascii?Q?08cpXGMs4sLEepx7irgkTfqfOcWh8SQmccZWQZPfmjAhdCyQlvolK0ZTN+rd?=
 =?us-ascii?Q?sjFkAvEftZ24FMxooE8qoR8ykFbVo/xlQEQ/keqD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc4d70c-5c95-4cbd-507f-08ddfc1cd3d8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 10:18:10.3684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tGig/NjSn82JAUZ4ikFjOJnck7Ct9G2HQ/2sdkFmvla+qgHy7wFnA8w9Z1p1MqSXGI56yoAJydwAEkQRAyk/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6092

Hi Herbert,

On Tue, Sep 09, 2025 at 05:50:56PM +0800, Herbert Xu wrote:
> On Mon, Sep 08, 2025 at 08:23:27AM -0700, Paul E. McKenney wrote:
> >
> > I am guessing that you want to send this up via the rhashtable path.
> 
> Yes I could push that along.
> 
> >  * This is similar to rcu_dereference_check(), but allows protection
> >  * by all forms of vanilla RCU readers, including preemption disabled,
> >  * bh-disabled, and interrupt-disabled regions of code.  Note that "vanilla
> >  * RCU" excludes SRCU and the various Tasks RCU flavors.  Please note
> >  * that this macro should not be backported to any Linux-kernel version
> >  * preceding v5.0 due to changes in synchronize_rcu() semantics prior
> >  * to that version.
> > 
> > The "should not" vs. "can not" accounts for the possibility of people
> > using synchronize_rcu_mult(), but someone wanting to do that best know
> > what they are doing.  ;-)
> 
> Thanks! I've incorported that into the patch:
> 
> ---8<---
> Add rcu_dereference_all and rcu_dereference_all_check so that
> library code such as rhashtable can be used with any RCU variant.
> 
> As it stands rcu_dereference is used within rashtable, which
> creates false-positive warnings if the user calls it from another
> RCU context, such as preempt_disable().
> 
> Use the rcu_dereference_all and rcu_dereference_all_check calls
> in rhashtable to suppress these warnings.
> 
> Also replace the rcu_dereference_raw calls in the list iterators
> with rcu_dereference_all to uncover buggy calls.
> 
> Reported-by: Menglong Dong <dongml2@chinatelecom.cn>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

We hit the same issue in sched_ext and with this applied lockep seems
happy. FWIW:

Tested-by: Andrea Righi <arighi@nvidia.com>

Thanks,
-Andrea

> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 120536f4c6eb..448eb1f0cb48 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -713,6 +713,24 @@ do {									      \
>  				(c) || rcu_read_lock_sched_held(), \
>  				__rcu)
>  
> +/**
> + * rcu_dereference_all_check() - rcu_dereference_all with debug checking
> + * @p: The pointer to read, prior to dereferencing
> + * @c: The conditions under which the dereference will take place
> + *
> + * This is similar to rcu_dereference_check(), but allows protection
> + * by all forms of vanilla RCU readers, including preemption disabled,
> + * bh-disabled, and interrupt-disabled regions of code.  Note that "vanilla
> + * RCU" excludes SRCU and the various Tasks RCU flavors.  Please note
> + * that this macro should not be backported to any Linux-kernel version
> + * preceding v5.0 due to changes in synchronize_rcu() semantics prior
> + * to that version.
> + */
> +#define rcu_dereference_all_check(p, c) \
> +	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
> +				(c) || rcu_read_lock_any_held(), \
> +				__rcu)
> +
>  /*
>   * The tracing infrastructure traces RCU (we want that), but unfortunately
>   * some of the RCU checks causes tracing to lock up the system.
> @@ -767,6 +785,14 @@ do {									      \
>   */
>  #define rcu_dereference_sched(p) rcu_dereference_sched_check(p, 0)
>  
> +/**
> + * rcu_dereference_all() - fetch RCU-all-protected pointer for dereferencing
> + * @p: The pointer to read, prior to dereferencing
> + *
> + * Makes rcu_dereference_check() do the dirty work.
> + */
> +#define rcu_dereference_all(p) rcu_dereference_all_check(p, 0)
> +
>  /**
>   * rcu_pointer_handoff() - Hand off a pointer from RCU to other mechanism
>   * @p: The pointer to hand off
> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> index e740157f3cd7..05a221ce79a6 100644
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h
> @@ -272,13 +272,13 @@ struct rhash_lock_head __rcu **rht_bucket_nested_insert(
>  	rcu_dereference_protected(p, lockdep_rht_mutex_is_held(ht))
>  
>  #define rht_dereference_rcu(p, ht) \
> -	rcu_dereference_check(p, lockdep_rht_mutex_is_held(ht))
> +	rcu_dereference_all_check(p, lockdep_rht_mutex_is_held(ht))
>  
>  #define rht_dereference_bucket(p, tbl, hash) \
>  	rcu_dereference_protected(p, lockdep_rht_bucket_is_held(tbl, hash))
>  
>  #define rht_dereference_bucket_rcu(p, tbl, hash) \
> -	rcu_dereference_check(p, lockdep_rht_bucket_is_held(tbl, hash))
> +	rcu_dereference_all_check(p, lockdep_rht_bucket_is_held(tbl, hash))
>  
>  #define rht_entry(tpos, pos, member) \
>  	({ tpos = container_of(pos, typeof(*tpos), member); 1; })
> @@ -373,7 +373,7 @@ static inline struct rhash_head *__rht_ptr(
>  static inline struct rhash_head *rht_ptr_rcu(
>  	struct rhash_lock_head __rcu *const *bkt)
>  {
> -	return __rht_ptr(rcu_dereference(*bkt), bkt);
> +	return __rht_ptr(rcu_dereference_all(*bkt), bkt);
>  }
>  
>  static inline struct rhash_head *rht_ptr(
> @@ -497,7 +497,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>  	for (({barrier(); }),						\
>  	     pos = head;						\
>  	     !rht_is_a_nulls(pos);					\
> -	     pos = rcu_dereference_raw(pos->next))
> +	     pos = rcu_dereference_all(pos->next))
>  
>  /**
>   * rht_for_each_rcu - iterate over rcu hash chain
> @@ -513,7 +513,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>  	for (({barrier(); }),					\
>  	     pos = rht_ptr_rcu(rht_bucket(tbl, hash));		\
>  	     !rht_is_a_nulls(pos);				\
> -	     pos = rcu_dereference_raw(pos->next))
> +	     pos = rcu_dereference_all(pos->next))
>  
>  /**
>   * rht_for_each_entry_rcu_from - iterated over rcu hash chain from given head
> @@ -560,7 +560,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>   * list returned by rhltable_lookup.
>   */
>  #define rhl_for_each_rcu(pos, list)					\
> -	for (pos = list; pos; pos = rcu_dereference_raw(pos->next))
> +	for (pos = list; pos; pos = rcu_dereference_all(pos->next))
>  
>  /**
>   * rhl_for_each_entry_rcu - iterate over rcu hash table list of given type
> @@ -574,7 +574,7 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
>   */
>  #define rhl_for_each_entry_rcu(tpos, pos, list, member)			\
>  	for (pos = list; pos && rht_entry(tpos, pos, member);		\
> -	     pos = rcu_dereference_raw(pos->next))
> +	     pos = rcu_dereference_all(pos->next))
>  
>  static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
>  				     const void *obj)
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

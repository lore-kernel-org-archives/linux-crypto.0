Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E1433CB
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jul 2024 23:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721085718; cv=fail; b=mD7VszMA/r9ufeS4dOroJ9RXj0W0H50lNDje5h8vhUcf6oJJ777mRH99nca5+1+7jt81dP7gWT0dLMhb6W3jB/HwRSKH9hpVOzPGW/WPgXwuc/1Mkr2golpXdeu1pYD7xfRsru6M+hFviSwNVnVheHtuwF1h6NZ1UGtK6zr2QdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721085718; c=relaxed/simple;
	bh=WeUBtERRrzjEkoT9LtWx112GpogHiplbpwdYFqDT6fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VDzwqrliR6lBQn8R04GU4Mg9stn0vsb+soyZcqnGY9NsjZMnWEgGy4xzsG5bU3fYYcauaZPOsK0MVOTJlYUDSdspEwBcK2SsbIm6MUSCeFtJBa2Q1ln+EmO4qWSY/WWsUV+bY012n8wehOI9ywgJ8MrhNp88bdS9Obm3NAfKJWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o77DpKaT; arc=fail smtp.client-ip=40.107.100.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o77DpKaT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZhMtnXk05rXKga6+uPKbTh2e1QmbyZl9LaNzG4HkOYjSYKOcGDoGCR0RM3mXlRtF1UEorc0xnWDYtG8n91sGu0pz8jWlX3SajWb0YRi9JCY3LB27+qCFYQg7kQAUzPgxJRHHp4OnyB0V9p3pDXljgFMamfZ6fYq2r4Cu0i6KU3jh8Y7ns4mvekFph/cVJpbzPB+yV8P2TPlnlx193et1gt/VydhPZ9rgrLlkI9dAAnUrHIMk0Oqqehzs9CE91cQvVIcNQ0m2zTMCISQ2JP+ROAVwUcTrLzmfsfqDzknpYw3fpGkS1vJeZJ9rskA23e031rX2+a3qSs4nEQpW/WDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k3N5W8ElMTOJDOJzRFP3g2ETjjU9mpbf473kG6Pmmo8=;
 b=Qg6UZuEWMkPNjOiGISAP7/6YGFG1e3Y+DZxKOqk3ZBMQ/1enx0mGTOb/PkEz5l7kE5oOCPszm+FJ6eih43aM6/6FAZzfDWjlH878y5BqgRCQMD6NA/NYQ1mvhsNIhd0niQ2lNaBLFqdBucmiXfs2ZLgHu54j3Lzs/djalxYsujRuV6QVvI4COdPLUCghYjuK22k9NfA+l6yoQT8Lhe2TXsCbeisu9/6L18ja/Oo2ML3YIgxXS71+z7Al93F+6u7wDyHSBc/aPA05GcNc4DPs0soddO1HlVRCXWxGD62pI4V0aE1NaNWbzcGD5LUgyHSGZC1hvnxoRENxpbVY4fVsYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k3N5W8ElMTOJDOJzRFP3g2ETjjU9mpbf473kG6Pmmo8=;
 b=o77DpKaTvtLZIxtW85fx32megEw/wkKRtWHfmOER+zw939LCc6shBVtwQZtZmHl7qSNu35K5Lxg6+Sle2qSWLG3g8fVcMtQKoenl6cyGlQkTQgKXVAeBM2vMVYX1+plLqEIGcGimuUC2nj1TNfYegbEXuXbqTQSOSV/STeO96M6lcyorNy2qtOkbfx07zvhrTqfuCv7gzTjA8lhbM/NamGSf819pLpLdixLPC9qpUuxoyWFBidcnGeHRuz1wzllfikhVFB9r6Hj1LNnCQuzjoPnn2jmTxJIqi1R67E+trNlHWwV5v8AU6HX7scoorejcEsX+HrMuRu4/jPTEZaMJ9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 23:21:52 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 23:21:51 +0000
Date: Mon, 15 Jul 2024 20:21:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Kees Cook <kees@kernel.org>, Lukas Wunner <lukas@wunner.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linuxarm@huawei.com,
	David Box <david.e.box@intel.com>, "Li, Ming" <ming4.li@intel.com>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dhaval Giani <dhaval.giani@amd.com>,
	Gobikrishna Dhanuskodi <gdhanuskodi@nvidia.com>,
	Peter Gonda <pgonda@google.com>, Jerome Glisse <jglisse@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexander Graf <graf@amazon.com>, Samuel Ortiz <sameo@rivosinc.com>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 08/18] PCI/CMA: Authenticate devices on enumeration
Message-ID: <20240715232149.GY1482543@nvidia.com>
References: <Zo_zivacyWmBuQcM@wunner.de>
 <66901b646bd44_1a7742941d@dwillia2-xfh.jf.intel.com.notmuch>
 <ZpOPgcXU6eNqEB7M@wunner.de>
 <202407151005.15C1D4C5E8@keescook>
 <20240715181252.GU1482543@nvidia.com>
 <66958850db394_8f74d2942b@dwillia2-xfh.jf.intel.com.notmuch>
 <20240715220206.GV1482543@nvidia.com>
 <6695a7b4a1c14_1bc83294c1@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6695a7b4a1c14_1bc83294c1@dwillia2-xfh.jf.intel.com.notmuch>
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b21f666-0782-4671-9f08-08dca524e832
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s1eDdkhRIap9ylalLZxKHDF8RWmqIQSEG4U73iQNDgY5sZxFHLWqpEJ+Fuwb?=
 =?us-ascii?Q?2NsJsZ2ufy+RgxnsUzwjqpeKxYJgFmWYiiEinYLiLGyQGl3HJGtE+efTWmmp?=
 =?us-ascii?Q?ISCqAGJ1j9Dctz4kAH0sU617z4othur3Zrm3p+daUkS9qyS4tTQU1s5JcJmf?=
 =?us-ascii?Q?H2sq9iztTSckRFn7OEkPYAro0lCv9wjKOpCLlmApWrZfXMY5/KwBAHpTplHQ?=
 =?us-ascii?Q?poL2RAIeB5MbT3mukAxHpLOp2GeBk0MgxxygfD+v4FT0JqvJWLzh5qc4yVnf?=
 =?us-ascii?Q?vlfp8Kfgl2PJePa4hSreAEbzv6Mz8SrS/WOP6jwuU2d54DU1ryAA3d8ikutp?=
 =?us-ascii?Q?j8ye5reeNTjv9RR2oWaGHyAv+69XBAOAxkC3/BTAILKS+y8tS2+VmaOpIv7V?=
 =?us-ascii?Q?tVoBFtU0C7Y2RtXJx8WqhYfbtdlOQChYV3y9Pl8gD8fhC4jkvp0vFvi6Pf/J?=
 =?us-ascii?Q?tiYyQDtd6F0PYIF71tQbmQ4N1T0yuMDsC38J9FtruQ5fM9Pd3Lrrs/xvJov8?=
 =?us-ascii?Q?dc5h3bMzGvyvfax/UslfHuqxlbjRcp09rq7Ie13g1jGTHRmpTAu4u50zmsH2?=
 =?us-ascii?Q?dYb18JDGuNqOchmjC9tglWKPGCjPIgu6KoFilKpPUpwDxkH7h9NJqwri4vHh?=
 =?us-ascii?Q?iqwYvcpqwWFVs716dTppkZ3g1rGd95YRgYcOpNEbhvPX8xvGoZh6UelYGntZ?=
 =?us-ascii?Q?U3a4YaCqFN6CuXa/rVZcgdtboRcmgTQO9oLDnjG3jenH+7qTLqZBJiTlBrrj?=
 =?us-ascii?Q?QXkOfoSpUBSdFoE4dGDhMe35LRimkeY3+15j7zLHr+BcrazngyNNsWZImAiJ?=
 =?us-ascii?Q?JuS9LDhgTDI68Dg+xdD2aiSzHGdfIswBaUBPYLLE+8suzcmPsyGD8JwemxoC?=
 =?us-ascii?Q?F+jOye8+ViOg/fwXdoZLDMMBRTU5C+fw9kUk2s7FqrddctQ1gGhqUsPBcFDQ?=
 =?us-ascii?Q?BbDv2U8i3Yuygxr827/liExIG04ktwT7iJCLZcYsQrajmTfOr1i+BhauoNI8?=
 =?us-ascii?Q?oygarA7nRPnxspIUdVMw+86sYLLvi4KSJgWNthtn6llM5Jt35GezTnNn/d8j?=
 =?us-ascii?Q?/kxSVLIQYZfAfqR6BRckrmjlbsRe5g+4Yaa314+YFZlU+6Yh5ohb1ws9NvMR?=
 =?us-ascii?Q?uRzXfY1WO9QOb5UmgTppws9g3ygaHlKvxaiV6Ba6/SPS288Hrme4bvDQ6gul?=
 =?us-ascii?Q?t9Au6ABdNQ+yC74NkwJr3xdjW0k1m76sj8ibbRUGBu2KAXcDDaeJNciaOA5x?=
 =?us-ascii?Q?QsDW/C2zv1GJWvkTK0i6w37weUulo+jv368fI9n7WYAu9ZpOaFwo3yLlIzdz?=
 =?us-ascii?Q?hktpVMn789WWjf7gtugKzIfWTURbPA60HEijAkL/xesQIQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W2U3zpTncDjd6j2c5By7+9oxyLRoKM4l+DVFVdDAkeD7DZ7i9ngngBhmqP17?=
 =?us-ascii?Q?kArwQ/lRCfPt0KBvQLy3FkyN1ywVc27P6qarnzE9Zl+x1q/t28jBmmo5pyRR?=
 =?us-ascii?Q?iyQ6W4z4sOCiAopPAFjD8Nwkrj0tLw1bfYvlbh0XNVRjEzwWsTLXU+s+7PWe?=
 =?us-ascii?Q?x7FAgXhr/wHyga94J7BWGOOmrFb4fESVZWYkfN6jSdcGAsHEVH3RD6YXt0NK?=
 =?us-ascii?Q?JU6NWUwZJqmf71qCDXa02F+w0ZQd8GVIOjK0x6ekZjXPXgNkLaQP4KXMyxcU?=
 =?us-ascii?Q?kPu73wwM6dEUhs8zE3hQhKzG5bavPrdHBRv+lmuN27Yo1/X5kzmDvvDKHi5g?=
 =?us-ascii?Q?bOfyOrfn63ADPWjzgiAVItfR84sqepksrWRC7USV++56qCnJpDNqQwHLLNJe?=
 =?us-ascii?Q?pXcWbuH3dIO2QCcuDV34qAEcXsUgnJkUgiYW+j/JuT4n16v3KQ1fvosWowCP?=
 =?us-ascii?Q?rv5ttll2D4/GTjhJVTQrHjA1LaHXtUNbQwb5SM3EuHk+Otom1Uvnk2+l9Ors?=
 =?us-ascii?Q?Q2S0m55g9Sh87+FmFu4x4ewPrXDjlDbURa72psgsW51xKjMhESpjOXSCCacZ?=
 =?us-ascii?Q?2X+Gn3Uf8L8/1h3LQA+EX75+Mrf1bzGBSbfwJqp7rJ/uZ7BuIrAP5ZOEIOuS?=
 =?us-ascii?Q?Jrwop902dE+IQbbM+3OICl7/WYvrqJp/7HXeK2QA4wU1jTC1d5XZcmbeqKYA?=
 =?us-ascii?Q?yta0AygzjfMm0Ez8YnafcBgPg743Ic+btTnTIxuocEV1salaBvYoSnk5BabQ?=
 =?us-ascii?Q?P/09CUx++b7gQPXfH7Ljbmr/wIGB4Ye4YwHi0lhIpNFgnodMGiVDrLSQVBic?=
 =?us-ascii?Q?SUAueO4UxDW55RVUGYCNGv3Z3NhheWWtExmg8+bgmKDm7mbWzowjYmXOB0DY?=
 =?us-ascii?Q?vcWCSKLRfVExSa51cSIVTaCDmHmxp8mc+gnN29SylEX1KCteQ1d7tOGMyK76?=
 =?us-ascii?Q?SBNWHFvEQ+JeZgOHfzNYwytv2db5We1AA8q2YE/uhZ+3FqGullDQ1NQLoZvf?=
 =?us-ascii?Q?O8uuscR0xjRM1Jnw7KfcrxN0kdlPImgmnStqnQPnD61wwH7u6rHMkzgE57fA?=
 =?us-ascii?Q?B4cayM/08ZaaGhYCFpOh1w+GOLSxwkH52IGm/yfMvUW/3aH7PpLPZHix+ekD?=
 =?us-ascii?Q?7NNAHHpMbNxdA5lut4nmCOGf+usQhk4QT66zveU/E2JjUBvVeeg1lyB7/uE6?=
 =?us-ascii?Q?qUu3x/WD/NQCAY9ULWLSlRAOfGUBPa1exUvidnjSCQ6IcbIXyP2+9HLlH4zT?=
 =?us-ascii?Q?skf3/bvqOdPSwsI6rAPSrLVQPLSR7OrOC9+b68t6t4DPf+QjNkEIpFT/KBX/?=
 =?us-ascii?Q?HrE0l95j5+MYig5cEBelwRkpN5p9fc5utM1Icl1QqJ398RVSSWMBPwTJB3xa?=
 =?us-ascii?Q?Uzo2ZVPkMjzULS651/uWgDYCU2m9nIrYfLZZjy5W+kXm7wgGmC/W3n4KSrGM?=
 =?us-ascii?Q?NYgUAECVriimYgQXe1cKko4WmQLRaY0G77HPfTvmFU37fEhhtl3D/adVjR8H?=
 =?us-ascii?Q?V/OcK5m7yDI2vDGT+hj997bhYs5/12gjtdv2lN/Xy2MWdsxQKyBPZx86do5/?=
 =?us-ascii?Q?6YoDboqMmJhmWPNWCZqNoNsVCtPGID9uGRM/gWKD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b21f666-0782-4671-9f08-08dca524e832
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 23:21:51.9145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DADZJ31q5J48LRj77kRE99iAGSB+CiF2QpPSxxcXHkEfeDuaXVspf2Z662APba91
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420

On Mon, Jul 15, 2024 at 03:50:28PM -0700, Dan Williams wrote:
> > > The motivation for the security policy is "there is trusted memory to
> > > protect". Absent trusted memory, the status quo for the device-driver
> > > model applies.
> > 
> > From what I can see on some platforms/configurations if the device is
> > trusted capable then it MUST only issue trusted DMA as that is the
> > only IO translation that will work.
> 
> Given that PCI defines that devices can fall out of "trusted capable"
> mode that implies there needs to be an error recovery path.

Sure, but this not the issue, if you stop being trusted you have to
immediately stop doing all DMA and the VM has to restore things back
to trusted before starting the DMAs again. Basically I'd expect you
have to FLR the device and start from scratch as an error recovery.

> For at least the platforms I am looking at (SEV, TDX, COVE) a
> "convert device to private operation" step is a possibility after
> the TVM is already running. 

That's fine, too

The issue is the DMA. When you have a trusted vIOMMU present in the VM
things get complex.

At least one platform splits the IOMMU in half and PCIE TLP bit T=0
and T=1 target totally different translation.

So from a Linux VM perspective we have a PCI device with an IOMMU,
except that IOMMU flips into IDENTITY if T=0 is used.

From a driver model and DMA API this is totally nutzo :)

Being able to flip from trusted/untrusted and keep IOMMU/DMA/etc
unaffected requires that the vIOMMU can always walk the same IO page
tables stored in trusted VM memory, regardless if the device sends a
T=0/1 TLP.

IOW the secure trusted vIOMMU must be able to support non-trusted
devices as well.

So.. How many platforms actually did that? And how many said that only
T=1 goes the secure VIOMMU and T=0 goes to the hypervisor?

This is all much simpler if you don't have a trusted vIOMMU :)

> > And I only know in detail how the iommu works for one platform, not
> > the others, so I don't know how prevalent these concerns are..
> 
> I think it is an important concern. Even if there is a dynamic "convert
> device to private" capability, there is a question about what happens to
> ongoing page conversions. Simultaneous untrusted / trusted memory access
> may end up being something devices want, but not all host platforms can
> offer.

Maybe, but that answer will probably be unsatisfying to people who are
building HW that assumes this works. :)

Jason

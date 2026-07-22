Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011029.outbound.protection.outlook.com [52.101.57.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7835AC3C;
	Wed, 22 Jul 2026 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784748687; cv=fail; b=O6WSQTa+w63zeUU4JQ/oITPOHaRFxtJF04lYvWdkob0T69pCWh57UM56znZrjqHD2CxP4AXW5AUeSPRZ0ECllX5mUOEy2YKOTB9M4df9rapZSSGczouni51g1JXTRHSvqEYltwk7KacViZN+zNYhq4+9B1xt0kK2+XV+itwwpXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784748687; c=relaxed/simple;
	bh=7GsT4mkKXHIRxMmiPrRLSVAzuC2kWTKzK0QrxDGP87g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GOA7GU2vMR3AE08O4WfMpb+FkmYnPKXQXQ/A9gtpeVCumDrPSAVO/EMiGvaLC/fiW1ZOcs824OuPqzVHPcXdnR8QliFxRGf2DUJi9RRuiLTkAc4bbdDb30Q9MbGogjXdhsRAkVSu80FFWJEbqJkIHDWW3Tu0FgSKT5YARr6hXjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M0Ik0ADI; arc=fail smtp.client-ip=52.101.57.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M0Ik0ADI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rr1nkOxCiJ14kE4Q0ETysXrhRc8cMyjGOO8BIePd2/PNNYywtfPdH8nGxGQ7LQmDtjkIoC9Y+64h+pZDpSVepyKzcxDvSEv9Omwq7cHrDJnZyO8DFeCnSESyWZ3D21Piz8v/hckLlXhVS2uHptOUIVEXyUghAUwZ+V75UYx05oqUuIlGE20xj+oJ+JWOcC2CfFi/BSAwXkKfACRjnCqb5NEvMMEGV78mUkekq9c79qbeEDTRlxODk1dTkAJCn/XZYJD+pXblfWCKfzvdgIu3uMjCKTrAbgAJIKzxx6wSI0MJFM3dE9Iz5+k6b3Nzq3r08/uh1KdIyYXWPaHdQaLz2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0+VZdEOqANgO7pyLaK7INuAmo5wjtv8EwKI8iqwh7w=;
 b=pgiwJB5Olis2wRs0zk/9wopcye7kaZuESEY74ahMv0LzoKSYmcgY3imtKuAHVbe9FWwaFI5z44eVIWaqhuDAT8b3Mx/AMrej6aEELa2C+NsPPaT0FfM9nBqKCmL2elK3HVoIFsWeimBaYAozblOeYedMjRMtJzvON177BanyY7KxZxXuI3Jq7js7QC7v97DdtV/9iEHOscQ1AC9azMNwEQI0GVpKSwjRT9TR189CZhly+Eae86uwHAjUWQi3WyC2ebtqteEAxqtPvki8/GieOFjaCvM2fCAfbogOSCLB40ECNIqe+qiB8uGtqpgAAZX5+guDUU3Opo3nQg0W5EMFCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0+VZdEOqANgO7pyLaK7INuAmo5wjtv8EwKI8iqwh7w=;
 b=M0Ik0ADI2TBQNKShOl2wtXkatVWpB7gBlpJcaPHWUAMTM4kX8HdApIbj4fIl0kyXwmNpCG/qp8gWpmarg3kDwS4eXdjbVc2ZnxjO6tgECgclz3znWS4VMCR9LVhj8DD30FlHCMRr0Q+OfHmnB1UfDiFkezVrmy5QzgbA+31gL3Xp6gzRyKWyXnMoxKIU+g+kgP6MxxSU15B02BtQr3lCj2dwRLiPTsnJ3/OEOpMM/mwoXNM7+v/hRQFphqfGM6Zx6AGXnkIXvQqe0aFeG46GPdl2SUtrkYc4bZTdJwt9+uNSIwm5/uus31D9FVdJhoBTyajMSVYQ9rIAkGeovuzARA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by MN0PR12MB5906.namprd12.prod.outlook.com (2603:10b6:208:37a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 19:31:08 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 19:31:08 +0000
Date: Wed, 22 Jul 2026 15:31:07 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Russell King <linux@armlinux.org.uk>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Allen <john.allen@amd.com>,
	Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Yury Norov <yury.norov@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Cc: sunyi <279644543@qq.com>
Subject: Re: [PATCH 0/5] bitmap: align bitmap_find_next_zero_area_off()
 output with the rest of the API
Message-ID: <amEaewg9HgUKL0ml@yury>
References: <20260709020312.133977-1-ynorov@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709020312.133977-1-ynorov@nvidia.com>
X-ClientProxiedBy: MN0P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::24) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|MN0PR12MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: a6c16df1-86be-4cca-513a-08dee827c788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|6133799003|11063799006|10067099003|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	ZEF502ZqI6ZpATaGMZ9KYiQmgxpBRgNQmjE7JaU7aWcKS1qNZcKxAqHPeh8VBNvmOTaDt7TojFMj3c9vpW37grhtKhno9y7oyG6xRERnYjRYTIZnKFbd3RzSaNtQfu9d8gSccnzAHsiBMxmpyZpertpTolRkIHl9jtKQ3Yqd/0TMw8cik/reRtvtihxt6Cm1vUWrFq1j3UgAxg+6h37ReoJMBauGHi8GAYHyhzMyAks8U7DemoUGTeCFYglR8QsrFkKefnBXDPm64y1Qy66inZDj3wVdlV7V6LEv1osIPVbs/GtstOS3Je/MLw5/M6DBtX/Qi4IEHWAg2Aux8aWd3XGAr0mDtBeV87JZc31XyikPM23A1CoTC7MAxz5YP0OwYXZB5GzbbrbIzHqawyxDwg4tDBi0bziCp9+S5p8TCoX+owAEsHeP8mSYgu62uPY0D1YkP2phO4TKljMcl9JOVMbcVp5WOVSsSFmP8aSHPPCBEXv29ENDUZSbTc6bKZiQX8LfzZKQO0oVctL4uLBHPEOGQygmqYx85KLf2QTskoj6IACKJ8Q2csbCx9mZIPIjTWzqPhAlkHHe8nN+Ze6j///UbnyHM0lTgrl6PQ7kih/VOK83ipDURG1dlMRa02KnrN1kGdWYFomyTiGQFOCjZX2Qgja4U65fTgQ4YEukAsLHWzZK2cjsn4ceRRYvm9mtDqk5K+EfrK6nAdf/N4498w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(6133799003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?otIvzF09iBbzcHD7+B+EO7qXo9+x7YxB9aJD/zjDjY/6MVjpKJnPFSw+xKrn?=
 =?us-ascii?Q?zLNJusjbgbP9Uqz8ERrGI6xLwHMybOYz72j+gE+rlBik6XDeCQhdBUpdQAlO?=
 =?us-ascii?Q?U58jqkBjSBlDqJ6bLVvn7Bj95SnpXo2EtG8/X2CycQjFdacICLD1+0FA+vbB?=
 =?us-ascii?Q?7lt5yefBmeGJRGYe1lUEImU8RdzenTuzpyGZOhWI4VWyOAr1JYzofpCD43dO?=
 =?us-ascii?Q?2YggB1rFV/xLNWEiluCWL3CRSSNJvC1kXe/97bRr7HgsYm5ypNi6zrsQ8YSa?=
 =?us-ascii?Q?ymw1uM6krZq99Folhu0DPrsFmUhpAoEDEst/Hu80hSCHe28u0JsfE/ltu1P2?=
 =?us-ascii?Q?GJjlWEsCKwXuiwSL7kvyx3r1zLB9ExD+XyTDIYfvuK1mmT1aAYCDHtzFTSx0?=
 =?us-ascii?Q?4Tzw9pZ/TYPgDV3pFoqaRVscn2myKGnzWEMJ2GQ2+aGJmGsC/C3vA153X7Yf?=
 =?us-ascii?Q?d+8Lvw4X2h3zd/1hwYIMCOoY8tPcOpt5xEJP/SjMJsc7vqG8BmrSxzrtxV9E?=
 =?us-ascii?Q?boW0Hh1dbbmOzy2qRL6petVXUyUM/tAOlQJ9c8NP37QNUzeMHfZsZfkbmgs6?=
 =?us-ascii?Q?o1reFao2tyIFSWNKrurHMJdxbeV0H6ihngjcNRkIKAcYYT5EHvq/4Am3b5Jm?=
 =?us-ascii?Q?1lJkXGSKEkimGI4CdIpBgGC5xPudhoS1sjr3kVWccpyEuOJe7sq8hGAXh+U8?=
 =?us-ascii?Q?a4xllUlySNkz+J4qk8JXCbnSPP+d+xf5OFOW4UNJc6Es6lWmTiy8Iv7HtuU2?=
 =?us-ascii?Q?u9SrW9VHXWYUP7NskgeccpuJLACIfwYbSlQn9Gzadg7hHXw5PDlkCO2oenMa?=
 =?us-ascii?Q?lxSy0AsILOiPSbRm4xWdei6yjpeJiOJYi93HaI4Jmuvwoc0bdyz7WqBGkFUN?=
 =?us-ascii?Q?JvcSYLuNvlWgcrMLs4xMCXdwtTCceX9ggMyNKuH4T//AMTM8OYIF1IYCSEOr?=
 =?us-ascii?Q?l2jU20pcBi2QvPq+s1kvyP1zXM9ELD0oZA1ZHaRFVED7eV7Ah242L43RBHvf?=
 =?us-ascii?Q?uNhcrPC3f3MU/AFQN7Qu+hOFIO0htllykcCtkkTQGIwDfpKg8K4BXqbfsSYH?=
 =?us-ascii?Q?FW0mWvWmHdGTQPA3dRpvoYkT2YN5VeKM0WzTgcF3ud8cqMsQkCykTRanPxUD?=
 =?us-ascii?Q?75pdsqk5pJQ/YNS1tnunwYSmk9eMlOkRvcK65wzDuqggkqQZ84CBExog8fb7?=
 =?us-ascii?Q?PKrEqxKDVZnY1Ba1anDKGVEz4/6xGpbviqCF8FPP1HrDG75rLn/QbtKnFEYb?=
 =?us-ascii?Q?C47poVIGVTSQ4SzaqyrL/QbMhsxleQe/14jXMyIlOAuApiFsNg5CP2gYq1Ed?=
 =?us-ascii?Q?DNY/7SZxJgTNioCyVF+WAbFLl1s90sAFbAJiK8zi3uRUI9mQH+0TESIp7Eak?=
 =?us-ascii?Q?RPLH83duuwcgvrZuihP/4GWvJWg5A03+G8dMoT9JL5cx7pgz1hpzQTbyfWxe?=
 =?us-ascii?Q?QHv3MnB5b4w6or/t7zlEK3Bn2e1iwHHBEt753WFlCanZUwJeTM1eiYoa7x7Q?=
 =?us-ascii?Q?gTQ1hGJ1jUIR30EaYDJ5SlZ0iMnGnxBU/zSnZdy1RogfFrAiCY48mkuuJW9G?=
 =?us-ascii?Q?u0i/7MG46TtXkIowvALY/AqDSIp+QCcSMcD/Gzca3h7+8A/bIKMPNmgENLdu?=
 =?us-ascii?Q?sX4o3cpU3Q/DutlWcWK88qGtMEKbOr6dJytCx7P01agWQVkKMqlkCVA82L2/?=
 =?us-ascii?Q?q10gaLSDX644FLmMe9iMKSETLsu2YyO+WgdzpwwL9bCHc4rhlu6RpSqZjsYW?=
 =?us-ascii?Q?bLJCbtFxQA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c16df1-86be-4cca-513a-08dee827c788
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 19:31:08.4673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+n7J6gtw2Otrv0Py+0hI8y/Gr2lWAE8eJ+TlTDdOgDm3flQnYITuKW1RDzdn2KsjsMLP5aDP63jxTvDFnD+9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5906

OK, adding in bitmap-for-next. Thanks everyone for review!

Thanks,
Yury

On Wed, Jul 08, 2026 at 10:03:06PM -0400, Yury Norov wrote:
> Bitmap search functions return a value greater than or equal to nbits when
> no suitable bits are found. bitmap_find_next_zero_area_off() is an
> exception: it returns a value greater than nbits.
> 
> Align the function with the rest of the API and adjust the affected callers
> accordingly.
> 
> Patches 1-4 are sent only to their respective maintainers and mailing
> lists. Patch 5 and the cover letter are sent to all recipients.
> 
> On top of -next. I plan to carry the series with bitmap-for-next.
> 
> Yury Norov (5):
>   ARM: dma-mapping: Treat bitmap size as allocation failure
>   powerpc/msi: Treat bitmap size as allocation failure
>   crypto: ccp: Treat bitmap size as allocation failure
>   media: s5p-mfc: Treat bitmap size as allocation failure
>   bitmap: Return size when no zero area is found
> 
>  arch/arm/mm/dma-mapping.c                            |  4 ++--
>  arch/powerpc/sysdev/msi_bitmap.c                     |  2 +-
>  drivers/crypto/ccp/ccp-dev-v3.c                      |  2 +-
>  drivers/crypto/ccp/ccp-dev-v5.c                      |  6 +++---
>  drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr.c |  2 +-
>  include/linux/bitmap.h                               |  3 +++
>  lib/bitmap.c                                         | 10 ++++------
>  7 files changed, 15 insertions(+), 14 deletions(-)
> 
> -- 
> 2.53.0

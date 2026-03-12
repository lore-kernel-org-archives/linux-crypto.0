Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013034.outbound.protection.outlook.com [40.107.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8500A38F653;
	Thu, 12 Mar 2026 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773333291; cv=fail; b=SpkT276/ErAnquTrmEXozuTqB/GR78vVTPRh+XjvigLj2DLmw+ym3KsZ3P1sHiLVDiwhJq59sHpqeNWgTp+i9sMW0ZuBL6FwqUkJCQjKIovc3pbSwewZuKhpMGt1UrVWUjqdcqCvgMLAkSZcN7ptGfWdAGHVRopPMwTM7m+pvZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773333291; c=relaxed/simple;
	bh=g9Rcf0ZhSnIUoPCyr3OqvlwAH/GM3N7qefIOM690WxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d0KwD8U9TsfraBsW1xlS9R/0lZ+9d8ZtWCh/tNrlqgW42EMKxzYeEn0InIO7X3YM0bdNluEPblZ6l1A6SVGGhZXB+tn0f9iTeZEzuIBT9G0sBf+s8SA3rI+rNqdDGLlBr5J5MKIh3e6VR0eEZ/O/G76+4iF5RjGRRarCYh72djA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GNrAWHkH; arc=fail smtp.client-ip=40.107.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GNrAWHkH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HukXgtQUzuYCLe4kZdYFyOoIxiPuvOE6/eqz9MEnWT2pxPhixz+WeoYiYs9wZVdNl+pnMzn3rbPQpDQA8DGdXdT83xX/Ax90z7N1U6av5xH/SEAPzZWa+j6/4T+R+Z9BhqYP3xqvfWmuvIxlQjQ6kEp+9s/BZOLG89eTfQ/yzIdJm4rb1Nu15FTDpDC1nf6B5qhwejo/zIAeqL9yjjKnulmrL9It8AVkQy7gstBbsU2dj1cOHY90UrYEVbwXpReKbGSyME3Jhp+ltR64O6z2WyI133UbfNZ7Oz+NXkyYTRNsiJeVW/5Wlh9NzJnkYvEtS9/bc3YILoQWIN4uhbskkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzV+rAjNbEDmnLP2w3mPjxztTJMoZK6n4uwPgRyG62k=;
 b=VhyGbdOwWsuFd40+EzDJKggMJC1AiM/gJdHh4bOQvkfHINWdByAwjirlfcHu6gQfUQ7cK6I3eTpLW3ALfOrKlF1/BSG2KEVKR84rB3Cd8Lel0W/mjJiW+bicsOw1rDlLE4/klzE0iLrRhTBEiV03yDQuAb3WOAHj3Re+4p0wufai2HPlKmX6NSVBoOzXcq2H0CggIk/VIEmZKugf6Unc+PaECSRfWBZyh7pfwOwpRKY1EeVC92dVUIvgIK1NyGxu/3H1IqkPoliNOPP2XCeHYAqS70QjgE8KOFqGgopRoxVSuTfFWVQ06Jfh6CwpYwM+ivxbUNaA7NxBEyeQqjwMgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzV+rAjNbEDmnLP2w3mPjxztTJMoZK6n4uwPgRyG62k=;
 b=GNrAWHkHoys0moX2P8vOPKgUzrm+cmMo1tiMejqDK/SVg8bSJ1RNmYbAG2vQo942i40LCA3GLJIAgLER5QmQRefpzAwq9y03cRVlAJI+wMWH7rvqOkuYY6DHSNphBIiQiU9VNjImCDEN1mOWqJt4VTiNXVmhJxZDHdJvNjJlXrb8uUn9GuA4t0At2gPu0fnaXH+sR8uXoR2uwZQGrCj7a7Cyc0d3tUPnpqN2lrg53nNQv4Ca/gjx/QWt5BjA4oNKEkYLeCgPFpgavIyOKjwKFXPb+lLmqYrScLCXJFd59fsmzlQiZHaYWyUIWsi1YZaQOauov2DxlLAIOdmf7zD7AQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by SJ2PR12MB9192.namprd12.prod.outlook.com (2603:10b6:a03:55d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.6; Thu, 12 Mar
 2026 16:34:42 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9723.000; Thu, 12 Mar 2026
 16:34:42 +0000
Date: Thu, 12 Mar 2026 12:34:39 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] lib: crypto: fix comments for count_leading_zeros()
Message-ID: <abLrHz5BRojkcoxM@yury>
References: <20260312161133.249374-1-ynorov@nvidia.com>
 <abLnLIRf6z8nh_Pu@ashevche-desk.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abLnLIRf6z8nh_Pu@ashevche-desk.local>
X-ClientProxiedBy: BN9PR03CA0944.namprd03.prod.outlook.com
 (2603:10b6:408:108::19) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|SJ2PR12MB9192:EE_
X-MS-Office365-Filtering-Correlation-Id: ed1638d4-a86f-4f24-415b-08de8055430e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Q93vgGs7WUUCVQ7thVANSUzAb9FGZiYwRrhOS/roioMF0VyXOOrjXo2sw2G0GcTUfRlZckB2zYpnbfdg7On17FpZnUjIpXko9/Y7r5cPim78OjBgA3lxE8pACC0GgO4+kgmnHVmDXn2XUalVnlbRzBl+T8Q56y7CKQEtvTVaLrr9OHCLFNbzSek15+0OSM3I/G0ZFbbc1nuyIE1Fw+ACDlIrLQnGE4l8SbnU9jvdEm83c25tMkz5wib5yMhVHirHojsWOTIIRMRfuatMOL3qIFjochBvtizUg/wqARAvz77yV1Uk62FjdLDtgBygtaKUqd/cfk68CE6soZAN2pshCg3ckcfV5zogkgIK4x8iUoYSQxNR5ftdlozN70NAS5SVT++azCBVMvocXkzRBkJQkdlV7aSvAyD0S8FWufyxPQrHX7kNOkoNXeOUh0EcXWl/1jacCFa8u1ZQ3xBxEjJtyoWu1bYA3AXA6mylMVah4U9G8oG2ietjtrkhQ5lgM3xv6KFFmZzJwoF+GvZ6Vrjk8kAKAUgKhzM7FzxAcud+Z2L17gZlDEkOuUG0E56puA6Meq/xZyRmWvknZUDVld5Ky7806zbFSUKvPzgZ3XcAO1jkI8Sw/kKxvRZy81aGvn9SfGyC7CYF2qJ/yv/Pjwni7SDN1Co2Jj2bpPppbzfyoFQI8XxTBwXBNGcf+LZwVoUThp5h/oSw+pPTXDD7dK+Sa8kTZLCn8n9QoxuujMkEzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RsEcML14inQbRtc/rF5B9toBDog8nFue2yOmnjS6n7tcL4kGC2fk8AzKEvld?=
 =?us-ascii?Q?h7dRWy6KjSSOLRTsxVp3gsFirBi1Dzo59Efg/5MMwd8F9EEab5zxafaJk8F6?=
 =?us-ascii?Q?q7gdzGINfX1rN/WAdkPXP12IssxVhZjljBA1J21agPol+8U9q/l9j2J8jTYU?=
 =?us-ascii?Q?LzVXMlwGh/7UuQYs5XGsBl2EMKQ5AXWismSLN17V3GgWR2V/CoSLSVSZ2lS7?=
 =?us-ascii?Q?S6DKIKtJiaZ7R+RadAJ+wgIZb3XFfHyfwBv4CCOIVCZNJfNb9g1gRfkg+O3u?=
 =?us-ascii?Q?JpypxTQ1eRrSitqcN2YxQgf1aY/OvDJMz4tKJmcg/2oIXyKt0TWABOyUi55Y?=
 =?us-ascii?Q?8/uGMmO+eLUisdfyDmsndruN97GM1YAOEdPfwBSo2T03o+nsFE3T62xfs1Ps?=
 =?us-ascii?Q?7/6q8tZyGNrqOdNw4QMY23DcVMCts6mTMHxYnZciYNL36CNgazrRdkBRDqSz?=
 =?us-ascii?Q?YR60aWCuRuasLQNvelIzEY8F3roG0p5MeHs6qG5fbNKOtDsU5++eF7cALNd2?=
 =?us-ascii?Q?Ey8rxGfnYtptdVIeNfvV8RsPuL7TFZ+M0CFPXacrhi/JQ7xHr+Tj+QEqeWmh?=
 =?us-ascii?Q?z/V1zht3G8wCbOGYdtfGzTIkI+QaXABHYSvoPNoDMMMFVKVWKG25pk8Dpb5e?=
 =?us-ascii?Q?6bo9RnVlCH2pI7LHnfFzsC6Us5b2ZMEe6AgFo8XhB/8NBwDr7C1y238Yrbmr?=
 =?us-ascii?Q?PxFOqSy5KQfaXbgBKidG2cwR+zMfDoj67Vcazt4Cse6HxfTvnANvAruNuBI1?=
 =?us-ascii?Q?t5jGeeAwWejx3oMaSyp/ihF5hWDlZSSMlBSlr9msW5He3G0n1Rag4vLUtjkb?=
 =?us-ascii?Q?iqswDbN3k9f31zoLMtptN17alGQS1IlpJzYq0SplBMVBECyj0KxAbQX5tnqw?=
 =?us-ascii?Q?BIr0uIR76jz1mfI0AWgOr2QQqe8keoafsimJSvdLmoK4DV7R8z8e8WoWlsYn?=
 =?us-ascii?Q?bCoenQIDcXMhU3XW3Ky/vjsJizvmiGWJTrYKVteoVuWUbhytF9VXovDwWYQh?=
 =?us-ascii?Q?rRPUFBI1Mz0/i8l38Ek3jPjg/h2sPTMvFeCf6GIx4ReuXEkR9/4DRQq4X2Rn?=
 =?us-ascii?Q?hS4sLpkiYqH2x0ZbF0ZMo/87vb8SgeHHoBE7ygZF6X8VePQUvBp+unKzf8I0?=
 =?us-ascii?Q?ohMnkljHsYtpzBZt60hiQK5IwYhS7WagbObuhJpuDGAlagrTKrQmcbtSFlnL?=
 =?us-ascii?Q?a3bkNRJ2vCE8AD+ua2VurstZvp3GOAnWWK/3ewcdpz3oKIXAnpU1mth0ebQN?=
 =?us-ascii?Q?JKW4bKrGQgPVo8RQHNSCUt35SS02a38MHKykYC3XbsLfaT95i9Yj2ujqYMga?=
 =?us-ascii?Q?rYyuwZCj9YUyYd6oRbEj5cH05B/g+j2kCknH+U49ygTAVVmrBU5wtzBcrXqC?=
 =?us-ascii?Q?YsHLy6iykIJc1mrvQR18tilhtZMV4yr7uO+61RWFoz/YaBob5g4yurCQZwPZ?=
 =?us-ascii?Q?GOVsU1+cAYa80KO7XDOuHUcb9gFCGg+FMUFDTTUWU5RTkLrmV4pswxie7GP/?=
 =?us-ascii?Q?FVGxXKmNQA6Yxxhw/gZ/MCHKuz1RDcKfpyJ35t7E4wOQzY+zDazwWf7KmuAb?=
 =?us-ascii?Q?TG7kuhHh8EdiazDXQ8WYmY1QgoNyzXf9vSBKEgiOp7tVA/KSlrvaTceNfDAR?=
 =?us-ascii?Q?ULD26hqDmD6Du/T4yK53z2skBmotFQzRj5uIuSBNF/X4rIckENWQ1w+XEIpq?=
 =?us-ascii?Q?bUxLpOVMcLMpJCRnRD79z6IMOgWJjMAnKSDoUEHYFiX6Tvsih4r0xgHmi0O0?=
 =?us-ascii?Q?3zO4hGvbeLnawCOV3B+i17YTH4279EsFg3QrGF3KuS4o9zubnblt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1638d4-a86f-4f24-415b-08de8055430e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 16:34:42.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eEa1lHFzLlm443m7cMXtlLPFMMYAeUCeKpaqiq6bXF/M4Z3DSxdH3vslFM5/VrQq4K14i23Mc+7IWiKeR1oliA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9192

On Thu, Mar 12, 2026 at 06:17:48PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 12, 2026 at 12:11:32PM -0400, Yury Norov wrote:
> > count_leading_zeros() is based on fls(), which is defined for x == 0,
> > contrary to ffs() family. The comment in crypto/mpi erroneously states
> > that the function may return undef in such case.
> > 
> > Fix the comment together with the outdated function signature, and now
> > that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
> > it too.
> 
> FWIW,
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks, it worth!

Applied for testing in -next.

Thanks,
Yury

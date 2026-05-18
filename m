Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5143D1FECAB;
	Mon, 18 May 2026 03:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779076616; cv=fail; b=cKUOCFnlrDLbwi6j5+DuhCQzBh0/5xxUQXjrC4Zm+Qn/UYmckHIxRqaD8hINhw0mcy843wXRACQFUlDdvCpBPFrngELdkjPyzfy6KPILFJjTwH30iirQoFl82fUrx4NyC37kR4c1YuAHnorLFtTQRkTVRR/L3btzWFvYdSpj/Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779076616; c=relaxed/simple;
	bh=pYg2cLi8BBtCId2bBw65JRLtgA7lxj2F4dbM3eI1hQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n0QkyumNC20/Sd1wzb/TvCmiB1SVRYEn05880Kn3oKSuk2LECJfVHT2UgwLDUUWPb297JGI2t4UwOctBrTtv8cos9Us49HttQjJrOSlixBrNjOAPlRI7J9a43+mNV6uOdMwLFlo9ma0lfP9P/YkF/+W4zO3OipnfKL5JFYisBgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3H/5uEN; arc=fail smtp.client-ip=40.107.208.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3H/5uEN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtSJIxGILGcjC+yEe9xQ4d4VRHjl2OqYMYLIovRucgXEp3wZSbX4m02+n+TrVRIWyM5Z/9LtCN6GBfCbckScFRveUIwse2FPGObcN0QpmQpKKPSjmJMNWSEpHA8YTAFbJrgttLD2PYDqWo3jXtRe1Cq9SPY3VhMKZlrT/fReDAnsr644LPcr0jSVUntE9VnRSPN8jQ1kJuGMKLxkhHAMca7H59CqMjH6V/36zPZgc5XSpDZndr5uSp4Q0+h+a7YAE6Uma73B2fIRUY0b3RgCuk1fyexAf9nVe3UvPW/dmjyX3Iap/aOm1AA6oIE8K2W4L3SqOBmihq9slXWDPCd8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6NXCb+oJWo6nKQgeeJwawKEkW/7dLceuHvvzqv5gW0=;
 b=DWktiYXiUgtFs7jrVuDPb3vpa+SRRYHiG3GTnNIioAjFHfs5fAC1kmehzUi66DQiok/jIc03Iy9iycNfaVAu8yTXH8yfN/Zk2aCduBkreOCGiOjicY7l8J3UOPg7mKknnZFqiJGVZLZwxAcshYgLIvq0IdXQ4vXjnhHMBAjuY5asejnwdArXQqyFcVsoWUEY3e9XbXYr52GVLbR7v5KDt0XBvhM87NKxdevBViT+R2vVpQ2ORkpkaIg31WspXQikLB8lqFBpkwMUwOOlZThyr/xERU3kvyjmCkqVqs7SQ/obq1Zp0z6pbriBSp81bx2NflESORIbVeu5RuZ9Ws0N+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6NXCb+oJWo6nKQgeeJwawKEkW/7dLceuHvvzqv5gW0=;
 b=l3H/5uENfI03yzMk0azS+fZXpGBfAUesIkwBdjp7zlVwbKK9XVM657Sxy6Nw2q+GZ/8YhDYWFqVpZIz6QN7FRqGM2AhyfCeywjYbF/W8JNv7l/quoUHLxzaf0q609s2mdxKRqODPP9PFQ9QsJOxWcDW57lj+MkhujrDjym13YCQkBEGtJd9n1ZzyVnr0O3r5Y9VPPm7I3Cyr+7hVDpNW43DQbw6KADBH0dlMSrYqiHCTgDGFPQwdFoekMcvLLh5xDdG664cLOLKaDigeyzTelxN8rK52YJ5qSuhDJ/hUOmqtAYfhzinKJtbwZmngTEpOFtZwL0+3eo88l9ZeF7w0Fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by DS0PR12MB7972.namprd12.prod.outlook.com (2603:10b6:8:14f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 03:56:48 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%4]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 03:56:48 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
To: Aaron Kling <webgeek1234@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jonathan Hunter <jonathanh@nvidia.com>, Akhil R <akhilrajeev@nvidia.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, dri-devel@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] gpu: host1x: Allow entries in BO caches to be freed
Date: Mon, 18 May 2026 11:12:46 +0900
Message-ID: <vTpFv1KrTcGkVeSTU1oWRQ@nvidia.com>
In-Reply-To:
 <CALHNRZ8-UKV1aVf6z_8uKOQ5eP1aP_7SEVJAtQ0fvCuAybb37Q@mail.gmail.com>
References:
 <20260515-host1x-bocache-leak-v1-0-a0375f68aeab@nvidia.com>
 <20260515-host1x-bocache-leak-v1-1-a0375f68aeab@nvidia.com>
 <CALHNRZ8-UKV1aVf6z_8uKOQ5eP1aP_7SEVJAtQ0fvCuAybb37Q@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYCP286CA0371.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:79::7) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|DS0PR12MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f7423bc-3b9c-4976-18b6-08deb4917c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	HUizJsc0hpiIvhiYG97scfEZG12wEzyYRVL9bQRX0V+vpYKAvR2Sl9OaK+Uz74z0g7KTY90ZIh14ozt4Z2DV3162Al/h1xSXHpfxJryVEWvKFcvWPanrYkLfteLTpLKhxkKoakS0m0URjWWgGuNkIBgcGZNshsLDbJ33l+JEGctMT9rXRC+tyC5ljW75jJWJnC/7/dwpeE7gYjEOKmJyDPlXu5eJSQ8EHzKmAh/RvoGKX1+PGqgaOyWNgB+7G/FpsZvp0wPf7TC+VCb+4D+CIDLX+7Xv5VTmV0w5UveYNaWA+Guvvgz3aCcqIxsI5zqfDaYGCtAQJCxGnPSK8TkRe15t943aj72jmN/YmhRdt24zkZinOfgLLwsFyDpF+RlLye8dk2hdHgGD/xt1NXFMNqLV01SilQ7L/uQ5DJx/Jzp68xa253WO2LPY2XYMgnxRX8Z0LdQih3ehW8UeAqVFOi9UYCYuoSU60y7lczyOS9umcJz5vMTDcroSuiPaORSDfLnxgkKGHr4ILrmy+VXwktdw5rSsvYA9RZg8t6v4sxhM7UEW0FVU3VGtLnpRqKpEB8O3ZDLSR1wYtKXdu0t+Tz6gLE6qW++j/sNnt4ejLEwk2ScHkhOpfNOXu3Yx3dWW8l7UQyoQyCCnI0u80NHzZ6wHHvXh23B46lqRlGGbQWSFGpb5RYlPf1qxIHn4S5tV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ck12ZkZVZDJBcWQrUjNCaDVlS3l2Y3VmTW5kcC9Nd1UrcWJLQ1hjR3c4N1o0?=
 =?utf-8?B?UENtNjE3MUtPQmdWd0x4QWZjM2t4a0NOUXRGZlpOd0Z3ZzAxSldJYkZWVVNB?=
 =?utf-8?B?QW5xZjZtR2RDU2tYeTZ4MkNYOEtLQnlSOUYyZnlSeE9qeVBHQUR3Y3R6WUZZ?=
 =?utf-8?B?NzJzUHY1THlybW1yMThtUmhUSHhyR3luL3RnbmZhbG04TStFR2ZHaVNmN0g1?=
 =?utf-8?B?Y3VWdWNiMG8yS1BZSVZJL0hKaWg4aXlsSFRiT1JHY0pRcXh0TEV4TmliT3d2?=
 =?utf-8?B?eHhEa3VxK3pNYmFQRVZiTzJ4TEhqTTA3WFdQZ0FBSkZQZ1NXNysyako3bU16?=
 =?utf-8?B?amJIdlZYb2JGOVMxY0hTOUhoWTJmNWtIUFEwRjhuK0pPWUpwVWhmRExLeklF?=
 =?utf-8?B?TjRyVW1VZHJQTG16R0JGWUh0T2JrZlQ1VnU0SDlNQUFIQUxnd2REZ1dhNVRH?=
 =?utf-8?B?NkNMTUpHVUFPQ1IvaUFXKzBLc2k1T1lOdkowMStVelJFZGE5TjcvdUVtZlc1?=
 =?utf-8?B?RU9JRTltZUVSMmdSMTVUUTJkQ0tkdEp6VkJJeUNjMUtyVUoxODFKUTFTSGpv?=
 =?utf-8?B?TUZmVmNnblJVQXI3VTQ1RHBGVHYzb2dTVG54Ulk5NzcrL3hCVHJKSzJOTm8y?=
 =?utf-8?B?R2VhNDdMQkgxWlc4U05Ea21YTXQyN1VLZzBpak9uajVkcFk4R1FHdithaUtZ?=
 =?utf-8?B?YTB4NWRBL1VzSFZoSythRFVMVHIrZmtBeURvWk53RW01SE1mazVla3pheUF6?=
 =?utf-8?B?SDlaeDZoUm5palBBakpQeXBqWmpET1JVTktOUnRYQnlvZnFiaEd3RUUvSXpu?=
 =?utf-8?B?WTM0djN0eklJMEFHc1IyN3lvVEo4RVlQMUYwcVhUbGRhVjAyWVdEOUJrdHU5?=
 =?utf-8?B?YzBXVGIycmRkc1orS0x0RHdOaG1kT3RkLzlwK1YyOFpyaG9KdE5IVHBKN3Nu?=
 =?utf-8?B?QjRZVm5qQWEyT2hIcFFkcUxtU2J3Sk1kbzQzRnQyTHpnNVQ3ZHg0Z2ZQcFNE?=
 =?utf-8?B?TGNRYmQybXNaMmVMamtJejVKUVd5RHpkMlVLeE50WXpoMmQ5MHdnVnRwNmpw?=
 =?utf-8?B?Z1VwN3lkN0FKci9KMFB2T1BxTkZaNWdVOVJZamd4VnFNU3AwZlBTNnFhRGN5?=
 =?utf-8?B?YkxjZExBOGlhNTNkZ2VJWE1YR1g5OFJaazRwNzF6eGo1VGVSNHRiaWJucFJL?=
 =?utf-8?B?S3FBLzFVRnpmNUhUalR5SHN0M1VFaE5GSHZhS25CdFVuWFA2My9vbU16akx0?=
 =?utf-8?B?ZTFtWWhJY2w2NzJRWGRyVXc4cUtqbzBDRWZXZXJSSm5WTlc3T2QvbXpzV0dT?=
 =?utf-8?B?UTl0RW14V25CODFab2s3UnNGTFlLeHRXTGg1dnJEZC9ZZUJybW1BRHVHRmFr?=
 =?utf-8?B?dTR6SU8rNWVQc2VnekQxekNmTFhkUGdzNEhTLzhzcTFqcXpKYkpuTHZub1NP?=
 =?utf-8?B?a1pNbjVvWlArS2RiMlpudEFNc0xJUDFHSWdDWFY5QmxXWlY3QklCV3p4aXA3?=
 =?utf-8?B?K01lVS9PNko5aTVUM0IwSG1zRDdXK1pwSS9uM2xwS0dOM3ZXVis5eFNGNHQy?=
 =?utf-8?B?bitReEk5TzlqRWpiR01ObTFpYUkvVjlZWXhrbFZZcytoUnpRZlNLSCtKRmZO?=
 =?utf-8?B?NlprYUpPTVQrZnlIckxaZXpVUWVnQ3pIMDdRUVRnYnhFNVNiNGRySStRbHhE?=
 =?utf-8?B?cGJmcVRjYzFtc2pZNFpPZ2JCekQzRkw4eEt6WGZJREtVQ01sQzJrdG56clBR?=
 =?utf-8?B?cjJjdFlqSFRLbmhWT09xcHd1cHc2QzdOWEJ1U25KV2xTWXQ0TWVFd1hvSkFG?=
 =?utf-8?B?MXBna0F5a1BXR2xhU0JFekVpM2hQSVp2MUppZXZ0OE1taStmb2dOMFRPSk5Q?=
 =?utf-8?B?YU9id0ZHYi80VXovMGlWTE9JYXJPaGk0OVptQ25RR01GbVhMTFN0RjRnZmNa?=
 =?utf-8?B?UC9NWHZkTGlHbitKRHVQT2tqdUFFMWtFQjJkQ3B6T3QyWVJtbmZSTW95OXBO?=
 =?utf-8?B?TDg1NGVZN25NUXRsVjIzbmxVQWpiK2VKSGtBMmhLaTVXUXB0U1k1a3ZMY1Rj?=
 =?utf-8?B?bzJvT25mZlBCTDZxWUVzV0FOS1orUk9nQnFNV2NPRE1VVWtJL1QyQnF0Nllz?=
 =?utf-8?B?S3pWcFdkQnI4aTNFeVE3d0ZFVnRkWkIyQ1IweVRxVjkwU0hJTGFIMm9rbUR6?=
 =?utf-8?B?VzgwM1ZlYlRGTXdZMmlRVDJ1a2hLTEdHTlZYTTl2eXUxalIzMWUxK3FOd3Nn?=
 =?utf-8?B?M1FCZHp5UjlLdU12bXRnWVpkcXJ1L1UyZ1U5QzdwUlBWT25uMVlvYkIzTXVm?=
 =?utf-8?B?NU9ZSHY2RjM1dlB0cnhCZlhUWExhVjZMUjMwYU5GeTlXSmNlbjhGQXpHMjlz?=
 =?utf-8?Q?ohnxTLiKxL3CbKJkJT8UdMP0fDWL7+2X910EGMSo+/8mM?=
X-MS-Exchange-AntiSpam-MessageData-1: vLWhcLqfokDCYg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7423bc-3b9c-4976-18b6-08deb4917c6f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 03:56:48.5748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J94WEafJF6yHL53vui2eZW1uDeVZNe8PSwC3RXGRhMFh9sh9CTD/jTek3hxFPgo1qqUGfWjiP/NfJzuQUiUtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7972

On Monday, May 18, 2026 5:02=E2=80=AFAM Aaron Kling wrote:
> On Thu, May 14, 2026 at 9:35=E2=80=AFPM Mikko Perttunen <mperttunen@nvidi=
a.com> wrote:
> >
> > When a buffer object is pinned via host1x_bo_pin() with a cache, the
> > resulting mapping is kept in the cache so it can be reused on subsequen=
t
> > pins. Each mapping held a reference to the underlying host1x_bo (taken
> > in tegra_bo_pin / gather_bo_pin), so as long as a mapping was cached,
> > the bo itself could not be freed.
> >
> > However, the only way to remove the cached mapping was through the free
> > path of the buffer object. This meant that if a bo got cached, it could
> > never get freed again.
> >
> > Resolve the circularity by holding a weak reference to the bo from the
> > cache side. This is done by having the .pin callbacks not bump the bo's
> > refcount -- instead the common Host1x bo code does so, except for the
> > cache reference.
> >
> > Also move the remove-cache-mapping-on-free code into a common function
> > inside Host1x code. This is only called from the TegraDRM GEM buffers
> > since those are the only ones that can be cached at the moment.
> >
> > Reported-by: Aaron Kling <webgeek1234@gmail.com>
> > Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
> > Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> > ---
> >  drivers/gpu/drm/tegra/gem.c    | 13 ++-------
> >  drivers/gpu/drm/tegra/submit.c |  3 +--
> >  drivers/gpu/host1x/bus.c       | 60 ++++++++++++++++++++++++++++++++++=
+++++++-
> >  include/linux/host1x.h         |  7 +++++
> >  4 files changed, 69 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
> > index d2bae88ad545..2377e2b76397 100644
> > --- a/drivers/gpu/drm/tegra/gem.c
> > +++ b/drivers/gpu/drm/tegra/gem.c
> > @@ -69,7 +69,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct =
device *dev, struct host1x_
> >                 return ERR_PTR(-ENOMEM);
> >
> >         kref_init(&map->ref);
> > -       map->bo =3D host1x_bo_get(bo);
> > +       map->bo =3D bo;
> >         map->direction =3D direction;
> >         map->dev =3D dev;
> >
> > @@ -170,7 +170,6 @@ static void tegra_bo_unpin(struct host1x_bo_mapping=
 *map)
> >                 kfree(map->sgt);
> >         }
> >
> > -       host1x_bo_put(map->bo);
> >         kfree(map);
> >  }
> >
> > @@ -509,17 +508,9 @@ static struct tegra_bo *tegra_bo_import(struct drm=
_device *drm,
> >  void tegra_bo_free_object(struct drm_gem_object *gem)
> >  {
> >         struct tegra_drm *tegra =3D gem->dev->dev_private;
> > -       struct host1x_bo_mapping *mapping, *tmp;
> >         struct tegra_bo *bo =3D to_tegra_bo(gem);
> >
> > -       /* remove all mappings of this buffer object from any caches */
> > -       list_for_each_entry_safe(mapping, tmp, &bo->base.mappings, list=
) {
> > -               if (mapping->cache)
> > -                       host1x_bo_unpin(mapping);
> > -               else
> > -                       dev_err(gem->dev->dev, "mapping %p stale for de=
vice %s\n", mapping,
> > -                               dev_name(mapping->dev));
> > -       }
> > +       host1x_bo_clear_cached_mappings(&bo->base);
> >
> >         if (tegra->domain) {
> >                 tegra_bo_iommu_unmap(tegra, bo);
> > diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/sub=
mit.c
> > index 3009b8b9e619..e5841857c937 100644
> > --- a/drivers/gpu/drm/tegra/submit.c
> > +++ b/drivers/gpu/drm/tegra/submit.c
> > @@ -76,7 +76,7 @@ gather_bo_pin(struct device *dev, struct host1x_bo *b=
o, enum dma_data_direction
> >                 return ERR_PTR(-ENOMEM);
> >
> >         kref_init(&map->ref);
> > -       map->bo =3D host1x_bo_get(bo);
> > +       map->bo =3D bo;
> >         map->direction =3D direction;
> >         map->dev =3D dev;
> >
> > @@ -117,7 +117,6 @@ static void gather_bo_unpin(struct host1x_bo_mappin=
g *map)
> >         dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
> >         sg_free_table(map->sgt);
> >         kfree(map->sgt);
> > -       host1x_bo_put(map->bo);
> >
> >         kfree(map);
> >  }
> > diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
> > index f814eb4941c0..772e05a7b45b 100644
> > --- a/drivers/gpu/host1x/bus.c
> > +++ b/drivers/gpu/host1x/bus.c
> > @@ -887,6 +887,20 @@ int host1x_client_resume(struct host1x_client *cli=
ent)
> >  }
> >  EXPORT_SYMBOL(host1x_client_resume);
> >
> > +/**
> > + * host1x_bo_pin() - Create a DMA mapping for the buffer object
> > + * @dev: Device onto which DMA map to
> > + * @bo: Buffer object to map
> > + * @dir: DMA direction
> > + * @cache: Cache in which to store mapping, or NULL
> > + *
> > + * Creates a DMA mapping pointing to @bo for @dev. The refcount of @bo=
 is incremented
> > + * until host1x_bo_unpin is called.
> > + *
> > + * If @cache is specified, the mapping is also stored in the cache and=
 not released
> > + * until @bo is freed (refcount drops to zero). This improves performa=
nce when a buffer
> > + * is pinned and unpinned frequently as in the case of display use.
> > + */
> >  struct host1x_bo_mapping *host1x_bo_pin(struct device *dev, struct hos=
t1x_bo *bo,
> >                                         enum dma_data_direction dir,
> >                                         struct host1x_bo_cache *cache)
> > @@ -899,6 +913,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct devi=
ce *dev, struct host1x_bo *bo
> >                 list_for_each_entry(mapping, &cache->mappings, entry) {
> >                         if (mapping->bo =3D=3D bo && mapping->direction=
 =3D=3D dir) {
> >                                 kref_get(&mapping->ref);
> > +                               host1x_bo_get(bo);
> >                                 goto unlock;
> >                         }
> >                 }
> > @@ -908,6 +923,8 @@ struct host1x_bo_mapping *host1x_bo_pin(struct devi=
ce *dev, struct host1x_bo *bo
> >         if (IS_ERR(mapping))
> >                 goto unlock;
> >
> > +       host1x_bo_get(bo);
> > +
> >         spin_lock(&mapping->bo->lock);
> >         list_add_tail(&mapping->list, &bo->mappings);
> >         spin_unlock(&mapping->bo->lock);
> > @@ -918,7 +935,12 @@ struct host1x_bo_mapping *host1x_bo_pin(struct dev=
ice *dev, struct host1x_bo *bo
> >
> >                 list_add_tail(&mapping->entry, &cache->mappings);
> >
> > -               /* bump reference count to track the copy in the cache =
*/
> > +               /*
> > +                * Bump the mapping reference count to track the mappin=
g in the cache,
> > +                * but do not bump the BO's refcount. This allows the B=
O to still get freed,
> > +                * triggering the release of the cache mapping through
> > +                * host1x_bo_clear_cached_mappings.
> > +                */
> >                 kref_get(&mapping->ref);
> >         }
> >
> > @@ -948,9 +970,17 @@ static void __host1x_bo_unpin(struct kref *ref)
> >         mapping->bo->ops->unpin(mapping);
> >  }
> >
> > +/**
> > + * host1x_bo_unpin() - Release an established DMA mapping of a buffer =
object
> > + * @mapping: Mapping to release
> > + *
> > + * Unmaps the given @mapping, unless it is cached. Decreases the refco=
unt on
> > + * the underlying buffer object.
> > + */
> >  void host1x_bo_unpin(struct host1x_bo_mapping *mapping)
> >  {
> >         struct host1x_bo_cache *cache =3D mapping->cache;
> > +       struct host1x_bo *bo =3D mapping->bo;
> >
> >         if (cache)
> >                 mutex_lock(&cache->lock);
> > @@ -959,5 +989,33 @@ void host1x_bo_unpin(struct host1x_bo_mapping *map=
ping)
> >
> >         if (cache)
> >                 mutex_unlock(&cache->lock);
> > +
> > +       host1x_bo_put(bo);
> >  }
> >  EXPORT_SYMBOL(host1x_bo_unpin);
> > +
> > +/**
> > + * host1x_bo_clear_cached_mappings() - Remove all cached mappings poin=
ting at a bo
> > + * @bo: Buffer object to release mappings of
> > + *
> > + * Drops references to any mappings pointing to @bo left in any caches=
. This must
> > + * be called by any host1x_bo implementers that may be pinned with cac=
hing enabled
> > + * before freeing the bo.
> > + */
> > +void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
> > +{
> > +       struct host1x_bo_mapping *mapping, *tmp;
> > +       struct host1x_bo_cache *cache;
> > +
> > +       list_for_each_entry_safe(mapping, tmp, &bo->mappings, list) {
> > +               cache =3D mapping->cache;
> > +               if (WARN_ON(!cache))
> > +                       continue;
> > +
> > +               mutex_lock(&mapping->cache->lock);
> > +               WARN_ON(kref_read(&mapping->ref) !=3D 1);
> > +               __host1x_bo_unpin(&mapping->ref);
> > +               mutex_unlock(&mapping->cache->lock);
> > +       }
> > +}
> > +EXPORT_SYMBOL(host1x_bo_clear_cached_mappings);
> > diff --git a/include/linux/host1x.h b/include/linux/host1x.h
> > index 5e7a63143a4a..d8f052a85b75 100644
> > --- a/include/linux/host1x.h
> > +++ b/include/linux/host1x.h
> > @@ -143,6 +143,12 @@ static inline struct host1x_bo_mapping *to_host1x_=
bo_mapping(struct kref *ref)
> >         return container_of(ref, struct host1x_bo_mapping, ref);
> >  }
> >
> > +/**
> > + * struct host1x_bo_ops - operations implemented by a host1x_bo provid=
er
> > + *
> > + * @pin: create a DMA mapping. Implementation must not touch the bo's =
refcount.
> > + * @unpin: destroy a DMA mapping. Implementation must not touch the bo=
's refcount.
> > + */
> >  struct host1x_bo_ops {
> >         struct host1x_bo *(*get)(struct host1x_bo *bo);
> >         void (*put)(struct host1x_bo *bo);
> > @@ -181,6 +187,7 @@ struct host1x_bo_mapping *host1x_bo_pin(struct devi=
ce *dev, struct host1x_bo *bo
> >                                         enum dma_data_direction dir,
> >                                         struct host1x_bo_cache *cache);
> >  void host1x_bo_unpin(struct host1x_bo_mapping *map);
> > +void host1x_bo_clear_cached_mappings(struct host1x_bo *bo);
> >
> >  static inline void *host1x_bo_mmap(struct host1x_bo *bo)
> >  {
> >
> > --
> > 2.53.0
> >
>=20
> I have verified this on a Jetson AGX Xavier devkit, a Jetson Xavier NX
> devkit, a Jetson TX2 devkit, and a Jetson TX2 NX in a p3509 carrier.
> No longer seeing allocation failures nor am I seeing any obvious
> regressions. I am currently unable to boot any t210 device to Android
> userspace to verify those for various preexisting reasons, and Android
> recovery does not reallocate buffers to stress this issue.
>=20
> Tested-by: Aaron Kling <webgeek1234@gmail.com>
>=20
> Aaron

Thank you!



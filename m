Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9917B24A19
	for <linux-crypto@vger.kernel.org>; Mon,  5 Feb 2024 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707143391; cv=fail; b=hq4Tt79slF4IVDk++KDNp4a86RfOTwQZn2yx4Jz5ZXXY4hYnxbyc9GL9TrWHA0AJN/07H0FZMbfe738t/wnhlLviWSSV2NVwPvaeJymma6+bnbgvbWoOz6UQ5VnKujDFdLIkdMtbDn2wd+2x55HzjvZmNqKEBLCEeOL3lNLR/p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707143391; c=relaxed/simple;
	bh=HlsKz+W/ErpyaZLZJkdLcyKjDJ/gHODY7DVWjta2Dmg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f9fkDuM8FZ4glXuYSLBK0h8fKRAL8Tzkx0DVS6DGN5Lmte7zlD1f/vEgGT+yAUOdsUn2p7LpVHTl3yAf6UnKxAtoXqPetPCy88ieJFzsSTtKoz+pI1SS4EhobqJ0Y6CAgbkJ9jNH7NKZu26+XvMBMpw9OCSqJRxIbeDiZoHX68Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BJqC4hGe; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BJqC4hGe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707143389; x=1738679389;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HlsKz+W/ErpyaZLZJkdLcyKjDJ/gHODY7DVWjta2Dmg=;
  b=BJqC4hGelN41gSa6WjeqO6TcikMhrIB2fqOG31SS29urLYTS52QESrGs
   gxIvw2dliqtEdsGuh1mlM6nQVUN1W01DKad7fzJQbrdIXMIH1/TPkbnbc
   3zAVibjp8ILc5pGwRY5rQ8fl79igs1CcyOIJN6l6SCSGudhI80TTn+X82
   a7+PU97LoVyft8k4+g78NbMXNsxXYL6n+ZedxLjO6sB9u6SvlRG/vapR1
   gz7UvQ57bAr9BWjqiFRZvFrdLM6ko2ly311E50MtwQDD26qHTdCVYRnv8
   p/5CMA5H+lJk7SJgum3Iqihh69dH/SHMljWDmHl/ThOKWAdqCkeYydW4J
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="11885308"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="11885308"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 06:29:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="933166567"
X-IronPort-AV: E=Sophos;i="6.05,245,1701158400"; 
   d="scan'208";a="933166567"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 06:29:46 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 06:29:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 06:29:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 06:29:40 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 06:29:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L0sSKNATSkv3TYpwm4pJdfl4xF9XX+TE+JjZ5QuqHVkZFikHrFQVzKsVNaGJZR6u6jak6MM5X6InzqTvGWwBui/AEJWDysf8fUmoKAh6Ce4N8SUMl7CR6wL35KQIOAQGFdTy3cOs1ZCR+PJKjXMGzZwuYtdO2tHnr7ss7ahlgxQHN0pHvwjCnH/23pKSjhUPFYYgZfE0Y7E3GtNZj1JQpuqCn/du1uNCawPfKP9UCmzZpJ1hP0Y7Ssv59JOoHQ+6ybMSwguGMrTMMIYfz4hGY7JwI2EkhhRKrlxbqDgKJctCe2CdcEACRS3XwS5/CDHuqhBR+IdTpEGFs4JrpfVqNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZOnBpqpJrrgHqJUudrYF+dpH0kcY6doJcnyomkS0gs=;
 b=Ork1frFY9NWvfpa6GzHnsKy7+9jzk80xLFUfV4r/dQdUbGY+3th0zA/2ZwpreFiAefMQ5xnWVB4lwU1QF27XfNFC2T/iHqEPvrzj21QZALxypfDebFKdoDQP1MWcf2+ne1yqH1xfDnTrdirqpO4W0TZhvninviMLYfYF83nfF3YDtEy1w2qp6W+tE4PnrSok5n515NBUJnL1/ed8NnekdmkKCi7PnrmVXKunP92s12N/Eqnogixjo04/ZIT2LERYbzXUA+nD4rJVBNvDhwPegO85ggNfFU4/kzS3HoxRvHsuMC/jvQV41iReB/YPQlxHaSpYMPnJeJRIL/mRgKkzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB5486.namprd11.prod.outlook.com (2603:10b6:5:39e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 14:29:32 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::1819:577e:aefc:d65d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::1819:577e:aefc:d65d%4]) with mapi id 15.20.7249.032; Mon, 5 Feb 2024
 14:29:32 +0000
Date: Mon, 5 Feb 2024 14:29:26 +0000
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>
Subject: Re: Failed self-test on ffdhe6144(qat-dh)
Message-ID: <ZcDwxipP+CR8LBE8@gcabiddu-mobl.ger.corp.intel.com>
References: <ZcC/C/kpcKaoVPp4@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZcC/C/kpcKaoVPp4@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR06CA0062.eurprd06.prod.outlook.com
 (2603:10a6:10:120::36) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB5486:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d863cc6-4a98-40f5-62a2-08dc2656dee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MP82AIPz+HqxEPVkmUpX8DretY1sBWCHt6lP3AyC8JlM3uIoFqAPYkXxqAOqIxGZxsqQA+9NfunKZCI0SAVIuTPkPg01cB7NRHrb3dVOee4RIkTAk38n2znfOPW/6GKh9F0hM5WZ1+WI6Vx7vXSx9yjVLwS527rRev6kE0hCNJBDx5cC32qtYfHM7CUcdu8lzcjFs4SW+iKDWvXKljGt1ABa1g8Ay9fjAzEtzDKiMmkVd46A3JiPgUH59PS6+pEuuVU1cGM034hCmb9ksWFzHVyF7SDAW7db1CZY50d1aevxEfj+sy2in0Ney2O/iMbSI1A3ea4NPQFu7+XyF8YghHl7qHevqY4ptbJjBalzb7VF6/bTXnG2jryGQBwvTLp5CyGerURpsYWjhFtqfUayC6ueK0Yy46wSFT2b7wF6DdeDeKNONJlK8eKikzx6ce241RgfLEBhiOl+Y1eIwPVpuJkXQko5kfAdfIaA3D+z9oVKQbTt8i+Z595O+4KfpCHoP09Yu5eUK5qG+I1NNswaiaUnm33G/8voa8rG4Usg+kLLpAESV4MXn6YmD9lTNRNIrL+LfCb7yYobsvrY/ZYvCwaRFMOJJ4JjUsZIGhGQqI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(376002)(346002)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(41300700001)(82960400001)(2906002)(4744005)(83380400001)(6506007)(36916002)(6666004)(26005)(38100700002)(6512007)(6486002)(478600001)(966005)(86362001)(66556008)(66476007)(66946007)(316002)(6916009)(4326008)(8676002)(8936002)(5660300002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/9jS7j7Q0A06cY3zEm/q03QXBDcLlh2aV8ZNEN0PMmB4KRVKPhKlFe23zbBU?=
 =?us-ascii?Q?q/HYUIvFL0UvDpleHxfrN0Ee90m4T4O7oXnS2kS2ntEvqPCyEBZl8umX87P8?=
 =?us-ascii?Q?OYG4Zfw2FVP8gyBtC3RgatmZDiNflqlI05btnxMYyWKfkFzvI0BdEeo6Csg3?=
 =?us-ascii?Q?2b0s+rweeRqvcFt46gGEFnUZYMffXRDkjZCRH7cFqLNigrntDjU6kb9TTKEK?=
 =?us-ascii?Q?moI99Ygh+vgs6ZacY2/je5qOEqqafUdauNwatWXJFu4zwjdCThFFTXeWfpwG?=
 =?us-ascii?Q?D2sdGn9bstnPKMl50rIyqGCPeImyOFxgxFx/N1bUdoMP37VOnWmTE8UQUgNR?=
 =?us-ascii?Q?ptvA46bmts0AJlYZOZoqX1Yvq6FDsmHyTiDBGxeeDJNAf+1rqaH/QXnNQKZU?=
 =?us-ascii?Q?lCzeI9tav/zW5tZvijrjMJdg33cIUfy2yJ9V+WdIFXFtqBtLRI5q8PSnPdQT?=
 =?us-ascii?Q?X3fErJ0ipbvf08VpCaVWG5qsItezB+en3tXzFTsXV/LfFy6bip6vZYcAnqs/?=
 =?us-ascii?Q?MlaPbk7LsR0pwgDfLCgdSIO+7eSxTTZGCmLZcZRy+7c55gH1KUcw8W9axjTq?=
 =?us-ascii?Q?IQ7Ew1GrQx/B3PetW7nwAu5poQpusQFp6hxI0dUcgj8x/CxJGayVLEZs/9Ua?=
 =?us-ascii?Q?3QnYRSC2XHC9HAFvd89nWr3hNuiLP6WL43Lss35W82Wnml5xd4ZP+QKgSG02?=
 =?us-ascii?Q?X+//XLIwZGLkwMTETVLy+bnGfodVJ2oHnNsxBQAame/eRfLsqrD5AQsFs1O9?=
 =?us-ascii?Q?o33bmIpP6Uzwbsl3GNW2lgY/BryjakPKouSg4AFQUlt1Fg60SkPDGhKE8Tlh?=
 =?us-ascii?Q?sI/ZoZpro4u83oXTmbNGij/L8vvOz/n6OT3nSOztgBUsLbCynFyJNuAVQbub?=
 =?us-ascii?Q?3z6OIsfgIKTNH8iffUhg6nGNRrumme0eb7jsCgY5NffAkrLj4jwM9HXB9S4a?=
 =?us-ascii?Q?Jus3yf5dO+EMJortjlWLMQz5w1+tCZjY9RN1L327CfbAJ4z5qU+XAJVXlpS0?=
 =?us-ascii?Q?UUTj+iVaXeIkzyx7HQ5zIb+iPyQfW78+X33zYjZeLntuDeCI+wq4yEOfZW9y?=
 =?us-ascii?Q?dQQw2F+VvrdJiJ+sPsf+ziKj5h+UpMkljLJQPxKwurQSUWZ2hWuhpvidmoJh?=
 =?us-ascii?Q?yncMsrEjkMHZgQWoFVB2s+vvMh1GE4O7usmqcAr/MxFi7eyD5DvT7CRFpmBy?=
 =?us-ascii?Q?jxWiyCuiKxG2uK5gvKluQ1AMT7czgS/qWR8npIZMVs1/uatpM64nmH0CYMEH?=
 =?us-ascii?Q?pwdqPyQ1lDs5YeZccRrFqJnSlySwOzGxANXpNQcoLYSfpM9aszZRg30kur3s?=
 =?us-ascii?Q?XV1eYgnVG2abtGHjAz8OqOaN3wfO8BenN0Yo1Qffgc0fj2S9ouPU3KEQW8qM?=
 =?us-ascii?Q?NEs6xwh9GB27eemELvLD8ADkSJohWZ0y9cC9Qax6EjGwc0tjSDThtd9VBCdN?=
 =?us-ascii?Q?j7sjAuBCki6Am4fpeO1vkZv5h2zRBVn7ccqGrWf9mL4vIw7PeML1jDlZc2qT?=
 =?us-ascii?Q?f9ZrjCh+OOd4/2WRe/dy99eph+s3QtIgQCS8rz5TiPmZBXFcoMpPtmIc1o2+?=
 =?us-ascii?Q?Ix/NgbtD5cGlVTMRcGMoNgllI/1GrdKzvJXwhKDBWct4irWhRlq27ORMBHfA?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d863cc6-4a98-40f5-62a2-08dc2656dee1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 14:29:32.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdxkY1hcD/3Na/3YA+hbhjyf31vgYYXyi5/LCxBRC6KIKf559wrr+DsvDGiUhbTqUjopKNuEQyp4zzG+vWknbbV9eIYXzXQ/zdlKAJ/KEjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5486
X-OriginatorOrg: intel.com

On Mon, Feb 05, 2024 at 06:57:15PM +0800, Herbert Xu wrote:
> Hi:
> 
> I received a report that ffdhe6144(dh-qat) fails its self-test:
> 
> alg: ffdhe6144(dh): test failed on vector 1, err=-22
> alg: self-tests for ffdhe6144(qat-dh) (ffdhe6144(dh)) failed (rc=-22)
> 
> Could you please take a look at this and see if it's
> reproducible for you?
Thanks for the bug report.
I'm looking at it. It appears that even if I have
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y, ffdhe is not getting registered.
I'm trying to understand what's going wrong.

BTW, do you have more details, like platform and kernel version?

Thanks,

-- 
Giovanni

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

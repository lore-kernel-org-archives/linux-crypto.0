Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7E6C4167D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 09:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiKYJta (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiKYJsL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 04:48:11 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939DF2D1E9
        for <linux-crypto@vger.kernel.org>; Fri, 25 Nov 2022 01:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669369592; x=1700905592;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lpppSF7e/832TgqMQOIYfZzdpWa5mxCjeUiMg7V3IT0=;
  b=GOryBdzPT5ckiXdS/6s1BJAq/L573+XnUbo6GelnIYlXf/7LjTb/HqLY
   ZCIgTBqVoNbJX38S+lCduTwPUvs6gA2D+QWwklaTUNHUJOUqDct2vRLZy
   DvBsn1ssHAMdVKKImfeBo+RytnBmRz3dGEbKngprTdVjfXPDaw6djs0S9
   JYQRKrCGwaZeV5cyJkjYMQIocT03nlxznNqzDuM2/RdiSvACoz43w8EGM
   JqiNKqcCNicOrYQ5LpLOwTNZlRAE9pKj0wlRaRv7oYbPVA2ANv2s5ayLV
   UD597iJmY7gKeq3f2f8PwvavZnZEt4197hqh7aUq6v//NCtrniewbt+Dm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294833988"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294833988"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 01:46:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="642653229"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="642653229"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 25 Nov 2022 01:46:17 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 25 Nov 2022 01:46:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 01:46:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 25 Nov 2022 01:46:16 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 25 Nov 2022 01:46:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swls9yNG4TuUBo8QDu/xn4J397hjUY0MBWmI6Z34pqUZpDc/sj7lAFUMNa7EFl1IJNh12/94WeW0XZ/EFVAFtG3rVx0IkAI1D27R8FpAgv8ngiE/77AdiL9n/+nWti4skeqdnRNusaj74fvdNJH847ZbPutHyT/9KzHRD7NiSFHxIG6dAWkuilpzm3b6txNJKQo4MzpXuzxgtf1YzmkUoFct90Ge4pwKvvXcn2TjjhNKuw2phUg2RRF18eAXBM00AKKCyTPeNpBFdy6pXfAP1qBvkvsQZK5Nvv3RJoEDCsEQpyXWiPK48fFZP494txvCAtJtzbWlCGYC/mzrLNDCjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73ZGBIBHbX7BC23AIPljulJrI2Ks8e1zy+pcMNmf6oc=;
 b=HtyOSM5WOekT5E0tf6l4ZUa0yJCdD3EYerT0DVT3lk93LNm2j08uo3p/5BDmaao9w7iZ5mmM5ZgqLwnr1A28aP3m2aNHsltQkY55Rf3bM1EZgYPAwjNnu10yhTJCbBWYPKHJwXBmaNUNgEzUp5MIlbRKSbFPsJkU8FW+KT56K++9B/4KGDo/ZvTkZ4lLomK4ywW9S/P07KsjxfA3VPLKbb0CCC8NerB9Un4KbphWfxqT8dxuh+h86Z+a+kY1TuWehwB3AkHondcR/uRKCbYfW6f/IskaIQkfZ4bNh1ZzKi4QU0wz/j2YPcTNgoKSOds34RlTkUz530lFohsm87iSCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ0PR11MB4992.namprd11.prod.outlook.com (2603:10b6:a03:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 09:46:14 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::7b39:df5f:fe4e:f158%8]) with mapi id 15.20.5857.019; Fri, 25 Nov 2022
 09:46:14 +0000
Date:   Fri, 25 Nov 2022 09:46:04 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v2 11/11] crypto: qat - add resubmit logic for
 decompression
Message-ID: <Y4CO3O21Kx/Ywi6S@gcabiddu-mobl1.ger.corp.intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
 <20221123121032.71991-12-giovanni.cabiddu@intel.com>
 <Y4BKgx2axzqsjWch@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y4BKgx2axzqsjWch@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR0P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::8) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ0PR11MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: f7e4f2f8-193c-4407-464c-08dacec9e44c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jFUBHaLx8dUlY9B6ByodbVKbrON4RyP2Ncji4UdJMIbHeL8wTPNDcapoFh4bMciuxREj1pISnNe1eGUhFNpfAgsrnnZjpu89Y02p8ZWbXiLR6g+hLuPjLKLyYeHZQUfFvK5LiNfqSNcCCh8cjXabOOdMqlVAIL5TnG/s+IQnnrXASfnItO7qRw5bJ/5tCDcYcGSd0fzVE4BA+lajrZ1U3lYyNpC+ob7y9p1t4Zjvzg+XzY0urn4ffVzOL2odvP6q/VTia5eGT9kezsPX76aCRMO02UwUNjEqT9buqILlm7xp5o/uFKOmGr4ShCKbsM4A+mJQE1omf1/07q5DvPPP2RrqNB/IOaRwaBw5s1BCdDmRtX+ePeir4A2pycWUoPxv3JSWkRrNPFWoSdg219NERnd2NT9vekwFbwulUx//LeN5izIPm2mO4SQhfHwnrcrdcdUB2/fy0ed/mNDb9vdCQevPhU3EFt0tvZw8faZIaqVqKKA/i4QOyKfmPvzxRoQTP9wlPMePZU4LE/EErc2gaa1bpAYyfxA88LmaTdBbd34apa9YGu0yskM0SKmtPyLZy3Klx+Wracod0p9SdQzfAcrgj+50DaUQZqsdnAgcr8/bjVPfdzUnBEc9HyT+RkQ3tXi78znXlXYDnWB6XXzACVct29n1eccfNtcd7zIWFkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(6512007)(66946007)(82960400001)(478600001)(8676002)(38100700002)(26005)(966005)(6506007)(6486002)(44832011)(316002)(6666004)(41300700001)(6916009)(66476007)(86362001)(5660300002)(4326008)(66556008)(36916002)(8936002)(2906002)(186003)(66574015)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f3IsDHi0ROuTw7R++S9J3BWQ6zgdoKML/MDwV7VcomZRlbNwBJa6dqEARryn?=
 =?us-ascii?Q?roBC0vFTrrgWCeU5UqdOYsNh2g2WA/OOPc50Vtvjd4o/aiIZTsvURSRp7ufV?=
 =?us-ascii?Q?2Wz1zoNqACSvxJnCyVlG4aBmKWiSVHOGM5dUv6k1yn8AfSGSG0ShiBvsVkZc?=
 =?us-ascii?Q?PYIl+kFUe7jQWnvcJ31cR6Gb/Xs23kFOF2IFtrguJiA86zKb+p2+0mZ1UB1L?=
 =?us-ascii?Q?qsKr1YnTUEc/otaORxmfVdU8JauGCAs7n6JEH3PdA5KwqGYzEplzOJuvwD6W?=
 =?us-ascii?Q?4JxijpR1N0KKZZSxRZalQ1QZFevaKjsOjEPooQq23t4R/+Y7XwHsgepoeWdE?=
 =?us-ascii?Q?5VYiJZUtEsfJy7qZ0YucJd9BKE/oyuudj0gXZUs/QBqpmz9RSUob8/GEqjOQ?=
 =?us-ascii?Q?yQSYjIONH+6MuIYjj+hIYED9FJsU8dK/gkyOG2Be7QQ8UvNJ4oJYaLrvcB5Z?=
 =?us-ascii?Q?fcVUBGRO4uy0NY+45iArTmKND0N/6Vky58KEOFrzvKUNapwe1Uk9usUn4c8u?=
 =?us-ascii?Q?+I+jxq/1K3RJj/CTe4aVtCGkG79pWFJVDFafc8gmZVcSYecYUb6O3ZOJxGgN?=
 =?us-ascii?Q?uaZ/5y5rSqAXdVkaoqk+R4q2PVh9y3EILY/J1C06nlejt6BXSSwPyQZ4zoTy?=
 =?us-ascii?Q?zl/UJi3WA4wtJksxhoZ+tgyWYXD6y0RQCbYOchqb/LPDHhHHkgbIRgiyaW88?=
 =?us-ascii?Q?kGyC5o4zQX2PufQi3ISr89rDmhxLbr9HkcyIANtSYpv1TvHIzhjR2RZGfzAU?=
 =?us-ascii?Q?kbauKz8QBDEtZjaX93xjqcBH58Jm1B6D3Ob8B1Rd4YrIKwiVISeYdnJUTv2h?=
 =?us-ascii?Q?pScVlfqJrEd5HBxJk/scAbk/Ux2MqxQ6YOlKis2l/QAsbbKJEOson9G5MN+x?=
 =?us-ascii?Q?KmQlBO2Ix6vitAdBXDtdgc+aQSyP0HuBuknO4FXZBZEJMb8H2XbpF5DzngN5?=
 =?us-ascii?Q?B3OhREnS5DhrMd8LB7ceQ8NRcS4L+7bawGe3I1nilrjQrHEwZnLCwkO4QLa+?=
 =?us-ascii?Q?rJ+f1kN4KclyzgPGsVsYovwohr2fV/IwYsUhk/y21zeZfucZGEOl+ZEILFu3?=
 =?us-ascii?Q?jT1P5KMH85YvO9f1V6p3qhZPq9M2Cqlohhoh9gxtr2sHLdlAJesDc1AGKNn3?=
 =?us-ascii?Q?OQahR9NhvGqhAcsFUe5zv8aFLQ93Xu/uOyv5Qml2VDqvNF4nd02tVKA1eHNi?=
 =?us-ascii?Q?JBeHIxRsewRt4HvFdYybT1ZjhfPoSNihlx89/etBqLxDAsoffl3L0ijLSWLt?=
 =?us-ascii?Q?GM6M0rYnx6DEXeaHPPRrzmvumn9PXLNetNZB2yRSQ8ieKoEDShHK3eVHD5xe?=
 =?us-ascii?Q?ZuRsiH3fVo7OQbFgyjkkWdwV1DWv1IDoPEjcNDx4Kt6yuALS0k8moRmpBf4J?=
 =?us-ascii?Q?scqQdO+wso9OYEtkVofdzQvGovUn0+CtUfW8J4CdaMdfDE51zzGIt6RDo2U7?=
 =?us-ascii?Q?EUUMTkE5LbwcgQY9SmF2K+5TbtPFWqbDxdFWgPaoS7Zpmnh1J59o8cLRz7Wo?=
 =?us-ascii?Q?dsY8Col7Thwblyh+4PfFdWlpNkh3zWNSK3KDJXFXYYrtalBkLuu/5F2/0OBK?=
 =?us-ascii?Q?Q4i8UH7CY3D1pGlq5jvgzH9x28oaX9xO6lR4EFmwAZm2FabJK3a9LlOUpZIl?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7e4f2f8-193c-4407-464c-08dacec9e44c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 09:46:14.1392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wDwgC0nPNkG8z5Fs7rH+DoNsY9UoLI1Fg4gHu5eGZDZx1LBSWIUmOp93tMovlPpA4qCKk0jAA4VcVHMoX0tzi8z2VzElj6FXsHQxeHX+AmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4992
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 12:54:27PM +0800, Herbert Xu wrote:
> On Wed, Nov 23, 2022 at 12:10:32PM +0000, Giovanni Cabiddu wrote:
> >
> > +#define MAX_NULL_DST_RETRIES 5
> 
> Why do we need this limit?
I wanted a cap on the number of retries. What if the input is a zip
bomb [1]?

The alternative would be to retry up to the point the allocation of the
destination scatterlist fails.
What do you suggest?

> Doesn't that mean that anything that
> compresses by a factor of more than 2^5 or 2^6 will fail?
Anything that decompresses by more than (src size * 2 rounded up to 4K) * 2^6
will fail.

> Perhaps it would also be wise to enforce a minimum for dlen in
> case of a NULL dst, perhaps PAGE_SIZE just in case slen is very
> small and it would take many doublings to get to the right size.
This is done already. See this snippet from qat_comp_alg_compress_decompress():

	/* Handle acomp requests that require the allocation of a destination
	 * buffer. The size of the destination buffer is double the source
	 * buffer (rounded up to the size of a page) to fit the
	 * decompressed output or an expansion on the data for compression.
	 */
	if (!areq->dst) {
		qat_req->dst.is_null = true;

		dlen = round_up(2 * slen, PAGE_SIZE);
		areq->dst = sgl_alloc(dlen, f, NULL);

[1] https://en.wikipedia.org/wiki/Zip_bomb

Regards,

-- 
Giovanni

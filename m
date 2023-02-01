Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B25C38142
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 16:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjBAQ6a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjBAQ6Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 11:58:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1DF7BE4B
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 08:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675270698; x=1706806698;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oZY40k5BZgNL68fYlFE4075OHLmsRMii4pvCS8NNy+I=;
  b=MJjmf7hywMDYze+4hQCNk0ZmNPPRQ41k1IIp8xQdI+CRrXNDtSqy99b1
   Ltc/28sgkN9hvzsfNgleI7nU1jWeCzbxhKKLnb9mif+/+ubfNcKbbvG3d
   DNwzam8RslZtSmBSkDHniLz0plejeD8skZzldSxZZGIH5YSQZ0E3Z7cMW
   T2HrOcCZow+pJzps8BjXF4phycl+Xb7pMduevbAwzroHxEbbJGrVxeeAV
   WzT4cHLEkxX6/vIff5QXpY1/ld93oZXhWIsKSAR2jGd+KCiOi6Qa2NGzP
   hann+wOCByRBDfRkhPA3Yc7dCXFf9pDfakkAzrNkIcbMiGn8YauOExN9U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="390590693"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="390590693"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 08:57:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="993757873"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="993757873"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 01 Feb 2023 08:57:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 08:57:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 08:57:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 08:57:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vq8YErP+8zwuaWz6sb0pxwe4wa5BozLdQEBAl4wLysIPw+sySdiStXoCtvw9g3KzwAk6SMODOpc6ZgMyymcGvseWjuDI6Pr0mVqY4Rl2RpeTzdcOGKxFR6dpdgBWPzJ2qn1xG2fQWRasEbnxD4H0+c+uhxo1WqEynSlCsdVuqCuT/tAmwryD/p03TjYDMnSLtWErE0QuVLY+j7bd4g9m2wfBYznO5ELQ0Wk5oDPCgsPTULmtkuZI4dYxokk7AkWotB0w5TSdxKJ7Ozef1+FY9YeJC7jy3gBC+1//E0JxsYvEmZ6MOezfTEvtNNmTkC/jWqhtmJ+o8RU4I9sfru74Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcbuykJL90COP0A6LtkauwkRuxeWOyIswqEhZERt1M0=;
 b=Zbtw/zjHww3NFouquvHvVPxEpCt5VxIOL6qU+wcWWMb49PSPMvv+9RIFtwm2VVqYKg4MBjU/KJ0mAN70LmNFAr2YLJVNwOk54FsdD3rXUlKSWNJ/eM77IcDBWobT/KUeNwkB8V+Zi7p2YkGY/5Yb2ggGWNSv3obXb7PScKTq2p5nCWFrEJl7wg56+zp7AK0NyrVLInzVe0ZXznnaWjIG/fUs+oYuflbpHLtsaRb5Qj1jFdGJq0aTdfwftn5sB6/eJMZ5/HSWr0Rb0hmAixHQgHyHjl13g4RLuSjI7dohz31OWEwNf9IfpWuVo3aLlmA55N4J+mK+Kugv0pOFzQFuqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MW5PR11MB5786.namprd11.prod.outlook.com (2603:10b6:303:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Wed, 1 Feb
 2023 16:57:25 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525%6]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 16:57:25 +0000
Date:   Wed, 1 Feb 2023 16:57:12 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "Lars Persson" <lars.persson@axis.com>,
        <linux-arm-kernel@axis.com>,
        "Raveendra Padasalagi" <raveendra.padasalagi@broadcom.com>,
        George Cherian <gcherian@marvell.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>, <qat-linux@intel.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 28/32] crypto: qat - Use request_complete helpers
Message-ID: <Y9qZ6J5Nj0koOnV4@gcabiddu-mobl1.ger.corp.intel.com>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlbG-005vte-GJ@formenos.hmeau.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1pMlbG-005vte-GJ@formenos.hmeau.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::11) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MW5PR11MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: 246ba383-2f34-42d4-a734-08db0475648c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7pyGCTBqNSClSLkyO9fR2cKH1mXLIEGvxxp+sUQ4c714uHMfozTkGPTI8o7VmTrDtPlYc+wdIuNxIyP8T3bbE+EplBF8liIh+ru8EJK0c3W7XpqcpHWI0masTviXwg7KjqbVLd2g8QFkTx5eZ+6djiNcqvAaIjHJ9NrL9GrVT1RZDKIJX3MkpYREYYFi2S0PeaqcV9WXm2i0uVEZ6lkwlOeAx6PM+Jxg3gaZD2s8GaPN2FBx66lYh59k5EDPGxeD6qAwBwn6wtiRVj+ok//ail7pBbcVNSfn7Rn2D8X1m2++JcHXUZ5U7/W806WXT0zIT1xeqn9rOBuQyFW16vXDDnkUvYqNlI2b1pVrcL3f+M026GLcP7x5bTa5Z1AFAIeYfmQHwr/cQB7302BLH/0NlgvBXHsPNR+4BONLFgGLa2c+t5hpHN5inqKpdCOMwPbRcwrEwbLv9CZiGD+pYn56W+08xJOc309dDTPgTz8TlADfee89UJbbD9GbGu+bJo3mYZPfGQWQsUAfvP5eResABx9mWS8CnVPOv3Lo6jH0TFcFu+DK8333u8xBIq4T+gEfsuBp2N9TbYBzuJB362A4BJ8fwbTdUUJ1Z1bA5Qva93EA/hzyzCnD5pfhtbE0JKPiJAZay/vGphNjqW1d76IfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199018)(2906002)(83380400001)(86362001)(44832011)(5660300002)(7416002)(558084003)(41300700001)(38100700002)(82960400001)(316002)(36916002)(186003)(6512007)(26005)(8936002)(6486002)(478600001)(66946007)(6506007)(66556008)(6916009)(4326008)(8676002)(66476007)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jc2XTuxfYQ0q4P2Jpv/fvgLh3BDda4+usR0MJhdVL1mCnkfGlnwU6nOUIRbh?=
 =?us-ascii?Q?DzpOFT3imQTO8mZ9JLUGJHSutlAyD5EX7jVKc0N9VjcOUywYr8c7F9jSWo44?=
 =?us-ascii?Q?zURfl2i7l6cwosGC3Gd9E/9NKdwZzwvNmeuD+DEEqhKwyAfgwaMI9MyUtvsS?=
 =?us-ascii?Q?HUPTUQwpMAvD6Q6pEz51x2/LFKi85E67OvPEKzUbAXEgV3XXR7155yTcDtXt?=
 =?us-ascii?Q?BTavg9Ho1va8dFLebTj9S0INbPjlEmBa1YDhgWNiCOthQTERTO4TntwkEAFw?=
 =?us-ascii?Q?B+WC+kaKgg3q5poYDNvlkTTA0CmC3Vd+t+DpkxFRIFuiZUMJ631UB4Q6YT3x?=
 =?us-ascii?Q?WUNPJEvAsj7f+1Z2zqL8tcLTNt51ENR5wDBfqGGqU20txwdkiL754sXq4WeG?=
 =?us-ascii?Q?oLh0skYTpscqIii9AAFRHUi0NURUOIDrsS3C9/A3GQlNpr3KbFDxh921vmon?=
 =?us-ascii?Q?vWZK3P+Hj+ptbZmQ3+RIhdl698sNj1xa8qZkiXLvd7yorhcsDbxqLa4PVq3h?=
 =?us-ascii?Q?OOYr47J7ympjs0TXx6wcUiw4DpwclXpertZSDDYtwfSUPzMcaiFRukAwFS5f?=
 =?us-ascii?Q?zTvztaKuBReIS+m1aMdWPWCW514q3i3GWOmNUe41vHG/9y6lh1v3pIjBA7dW?=
 =?us-ascii?Q?RFvBVqJyO1K131FevnrezJxagMEpWRCuXwr6Wf8YM/H7l3Om875MaGZ0u/SF?=
 =?us-ascii?Q?6qI9O/IBH+KGzPsXf6V17ZZHHXxrDrBd2epCdoUUwFAdAcHX9pJVskJQCz2C?=
 =?us-ascii?Q?GJnVf3/NUtBOgBwOY9qsmXDwC0EFE6zF/OHGHtDJmC5efHSbboP7KKi2pjc/?=
 =?us-ascii?Q?LHdfXc/UhKMvEwuwotNqFgsCZ+wjl5hD/kAd6txWl1Lluqtylj3muGDK48Qy?=
 =?us-ascii?Q?G6vWhj5efUTAZnh6v6xPuHgw963KU3m7HxTsddTiZjVjwDURvMJ97Yq1gxQM?=
 =?us-ascii?Q?ON0rxkPh4qgpVHramiwHb661d335Afc5PUPLQz+mMYtKzFwe1QuWqtGWseYm?=
 =?us-ascii?Q?zNMOoUAvIHBfM3ctWhNV06P3/SBJMRwYwmXhq8Yi+Yrhec7R2bC3v02V8Hwu?=
 =?us-ascii?Q?NwDgeljI0fVpxHAPPzsLSfYUlZ/IsxRJqxC0enezRhs5ELJuzk8p0ZhrxM5L?=
 =?us-ascii?Q?vtaUkyPsIjvh8OYFL/cLoDG/xfBJyexxTHgw1Yh91aPqYjwjYGUECtez3p4Z?=
 =?us-ascii?Q?POpN0+H6lSpzw5sqaAOtoiAU2GGhXoszRMW0DA8ofQYgpsPn6Gkiz326rolX?=
 =?us-ascii?Q?F4tceEm1YWpj4ZwIW4piZJZyLxc3x6t4TkBwB5UfUsufOrORoY5ApQCGPj5D?=
 =?us-ascii?Q?vHc/7X4TeqFrF0GD4ZLSS48Sc1wnD5JbYNe1eEOj3kX5hwvCu20RNmiuGYxA?=
 =?us-ascii?Q?l2wUQY8ERGVxMGBYJ/m7H/fhSFaMpVUa4SAB93LqkHfrny3tKVZMyjbw2759?=
 =?us-ascii?Q?2iHN11P/sNJbS4sHgkaw25vG6iEdOM4BKjXEjFZqVDFmakEcqVBtLGKvfevf?=
 =?us-ascii?Q?vrlahnWxgHmPemg6olZbdiz0za0VlMiPD3F5d4Hh138TV7/Httx7j27uw4S6?=
 =?us-ascii?Q?szqaMS1ZheQFcYMrgk+k+187ER/ZZcKBygA33csm1OWMr7+sQwr+FQ5XoZJb?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 246ba383-2f34-42d4-a734-08db0475648c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:57:25.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oiy7li5L4d9z4LvnPv6pctAhc3Z+JFk5uNwRacKe7nwDQVTifWRfhaoPQzBAdVpEuoj5rp/KAWiyrPqqx0ij+3Kv+Cg0I7uEh3MaQlYRDCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5786
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 31, 2023 at 04:02:42PM +0800, Herbert Xu wrote:
> Use the request_complete helpers instead of calling the completion
> function directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>


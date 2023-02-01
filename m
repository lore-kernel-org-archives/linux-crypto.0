Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE29C05027
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Feb 2023 16:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBAQqJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Feb 2023 11:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBAQqJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2023 11:46:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA0724C94
        for <linux-crypto@vger.kernel.org>; Wed,  1 Feb 2023 08:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675269965; x=1706805965;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nDjhcbr1FM3kqIKqGT7G+0BRMHio4YEpo+R4IWA2ono=;
  b=WfYmmMs/v15xvR9/lyyB4Agyr3gf7p1PhPVJbyq4BU860LCYpvFhjrvJ
   fr2fxQluYOjMaVx4puivclyjOSM/4bnkmUQcE2YnyIPPRrESGizhuVQIA
   pupIZaXVpBT2GmRpRRdWJ/DupBtcWMHpxP89IkWRW8ZTLgXTTBl43jBUd
   X8Q5mbPiDeEvQ32JaV/cC/fiw12QV+YFTSok94YLLocKeCc2F+2dNwOJe
   q6LxbplCAytSwNWLbyAYJkvC1nna0d2gaefrlcCbLI0xwRIxiyYn2UKrz
   S0uhgBM2Tx5fEsFNmI4wIN1X9WJqDLklM21FkKAmn+S/IsHY7W2WllQy/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="316194747"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="316194747"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 08:46:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="664930337"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="664930337"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2023 08:46:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 08:46:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 08:46:03 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 08:46:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 08:46:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrDJnFKUk5aAfcm1aj77Ym+CYFgL7AsEFYzOZIVsSp4HbhYHRaHJq6sK3wpBTykdD+TxcWk/VbMvV/n++vXhYCY3VyDZqYzDs75/32nLFx/R7e83J9s7/jpnL8PAEadKabERtjF+s2ryQTixQVXwtNaCKqIxpAHDxTjwJbf+31gIu91aSiPXX/siMRjmVbU1mYEbI8ZZOBoOnH9SGiirlCgG7XQzF8FkzKohjcSd37iJLf+3n++Em2cX88wM6/jZR4NisxE8bAZmzDZ15vDmPsu5H5rR7T36Gn8X/j8pQtBOAOyOZ6erL+a9RW0VpbEkei+REmIjlvfWp9LqPViFoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=26JcnbHZt9JGCEONs/L4c8KyUAHF/u8sYvjOXf7IVcM=;
 b=HyZJGRhkHdBJxdMB7MW5+LRBUHknOTuVptiJDeNNmjzen3RJbFC21JeUPzJI0khD3oQyOui4hsIjnMKtGNb+gBwwrys+cJZP157RFprKCR10u9zTh3e+ac4Ud+mKyqxoDPzuPLMMVlJ5SFhQdOeTyQxWAzTPxjnqsB19g4k67ZyH2ODQgnrejibzMLIIH/GRTxkBkISRjAY30DNE5UXZgaZR961Y+2nqaXg1coreEGg/nZOMjhAAVYieHqPSDCsIQdNBas7cQ6QabuUNe1FVgy8crrGMLiUB+ycl1Abb8C5qi8dL+9ykWdWQzox26GK/b053G8EQx07EpE+hvs5lqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA1PR11MB6613.namprd11.prod.outlook.com (2603:10b6:806:254::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 16:46:00 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525%6]) with mapi id 15.20.6064.024; Wed, 1 Feb 2023
 16:46:00 +0000
Date:   Wed, 1 Feb 2023 16:45:52 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        <linux-arm-kernel@axis.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
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
Subject: Re: [PATCH 3/32] crypto: acompress - Use crypto_request_complete
Message-ID: <Y9qXQIoyJvrLiU28@gcabiddu-mobl1.ger.corp.intel.com>
References: <Y9jKmRsdHsIwfFLo@gondor.apana.org.au>
 <E1pMlaP-005veJ-L6@formenos.hmeau.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <E1pMlaP-005veJ-L6@formenos.hmeau.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0192.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::17) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA1PR11MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d31cef9-057b-4c0c-23fd-08db0473cca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1OeztJi/YlHjAlZFceh+1/VhgeZb6hr9vZ8UEtk0BiGJrqVTzoJ8h+jT9N8fJhYNcTA5p0ta8mlvc6mQ4oz/I9AzrVVTyH+2S56J1OkQidubBWGNZZG6hb7cnzzgaTScQEnQi41GtxIFrw1xktqh/ROhrMRPw9gvhF+llu/tH28uZFqKz+rMwkh58mWfIc19GCiKpARak/qmGDMyMeRA4OhflkBXDmM1zFlZC/3NKykfuJbiILWpG0lc/mkkXKE24ZJsjfxe5sbSBqHlSlfSnLhSys3fyp9LFaffo6efX0w4Rm8Od7154u5jLlM68DEUlTdfjHXRfbEX7sieGw9GJPORxMU3afK3X1AyKmjjJwJYeYhEmvytDIhpTN63NzF7zNU6Xl0hNGHp0J1iMfs7Ct+d6aaHmY1qzREqxMS35YRJo8fSZV0iHqbcOtCDFfam6dWI0egv85CJ56fr7/rwWzFpklY7YJJi8qCkMM2Ob+8aiTbbZOpFn+FrGxzzCD9HbMsPT6jmK3aeSFB3wx69LKzB244PJhYCJXuh7bevp2alAptF5eQN8/GDLhKe9UqtePMG7jt5hoAFRaKHcphdcFnF/TVq3TVwkSipl6FlMDNXFp3xzBcXX/Bp/JpU9VqGPWzR4xhQFpmG9xnHh+Duw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199018)(41300700001)(44832011)(8936002)(7416002)(86362001)(66556008)(558084003)(5660300002)(83380400001)(38100700002)(66476007)(4326008)(6916009)(6486002)(36916002)(66946007)(8676002)(316002)(54906003)(478600001)(82960400001)(6512007)(186003)(6666004)(26005)(6506007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cSiJANdxr1JrPcJo/SKby2TJT5WVPpzNg+T5mPQE3jXB+SP+3oBfcndJl2oK?=
 =?us-ascii?Q?OPOPLXi229PpANIXhEJXuwJHZNHdQoSG1Skx4z6jFbU02C2/wtzTiVFhzxQg?=
 =?us-ascii?Q?pNSaVfkkl3BhlUwGOoNdCZQpzstuokEG04mUE2V2+IA6o12HfElK8ZwQGp9x?=
 =?us-ascii?Q?qridy+eM//f5afVW2VdM+jJHMxfv7mDd+h3LusreokXpNqA2TsNnK8ccyPcT?=
 =?us-ascii?Q?AGw0gW1H9+efnUbT24QPC0dLQ7B5rZ4NdZIAhQKmHjlvcajmlaulrNBbcC1Y?=
 =?us-ascii?Q?+JAQJgBF5RgVb6cs/osjrned/f96BrtzNBnPhquF3a3/wAuE7zvdY0mx+os5?=
 =?us-ascii?Q?GTiuj/5UkTJ/baOfTCCiyst2tVobQiXyLhvS1WafcLfDuo5if3AIT9ZcBzLo?=
 =?us-ascii?Q?5G+LHK4CvyhZOGmU3Gk6URXJPAJog22PWoCVWaFt4CiEMLtezD8oDnmrWqFH?=
 =?us-ascii?Q?2oTSRi2nQHxRZJEJ8zsvIoEKVebUQUMHNXnjbaPF5hfLRq0yr9PprHpPV/vb?=
 =?us-ascii?Q?xauncyYNe9ssFCc84yO4KxKukZ+AJSnApRf46NZupPICtMmsn30mAlSm9BIk?=
 =?us-ascii?Q?LAzlbx6ElsuIOiu1Qi/TeKlU24DBLraY7ISfZXtppADlDjd5InFQc9ylEKRd?=
 =?us-ascii?Q?RprE85p/uMj84Ui+1Zp08XMQhOuZ7lfajjnkRMQ8MeZFAVEGTIT+fyQhLn10?=
 =?us-ascii?Q?3lXhktmR2byYQKN6OUmWSWbwOJDZkkITIMUOA0lRZcOy9RRnp8eT7FSJE4/A?=
 =?us-ascii?Q?oyd80vJILTwtQbGgwDfXLaq9SqHCq5aXP0BJIvDHVcdw58Xr+JdZEc6WP6yM?=
 =?us-ascii?Q?VgmIm+RA4xn8rVNB+cbq+/sHjxkxd1UAuJkPqE1tLm6miboTQ9SiWADcyyo3?=
 =?us-ascii?Q?lOOpnFL1wbVNIQxprn9WbkjXbFOC9WpOgxgZE9XF6poVRM8nMekUpu7JS57o?=
 =?us-ascii?Q?TmOns3x/zFNZ78NT501eUtzOpt/mifEzEpsf/XjuM1eJSu45ZEOoYRpU7IUp?=
 =?us-ascii?Q?3R83EGIgMsxdo5cksuFmA4WwE808HcrocUEHlXoOAoLS6xLqy49rMwt8dfPu?=
 =?us-ascii?Q?N4TFyznWIQrHAXXonKGkSBByFzo5mspf0Vq8pVpYtaNqxjAaowwAqPOhWjto?=
 =?us-ascii?Q?034HVrRP00u/Oh1+OoUaJcb/bh4/3Uh1+stM6kenz0pkcMk+w/+UQtzHtp1V?=
 =?us-ascii?Q?LHv7T5Y01UlCe6i1uvn/HHG9KIt4u5ZrBt8ZtbL6zbN2YdCTh4WaczzAZTYO?=
 =?us-ascii?Q?Kp3yIly5lajb3XWWpydNsNMNuVims5QsuRDvkz+BQ0nxmV3OZccAjTsKz3U7?=
 =?us-ascii?Q?9gGlWfNDs6diMLSz1DVRBrdUvKDOON0WW5Gol2/QSkzOuCZTKI/KvTiOsbJY?=
 =?us-ascii?Q?vGlBlpMIPQREkndHVA1aZzSfum0kmXtwqd0Gn1yMqcKkrcrvndm8ZYfT3iVV?=
 =?us-ascii?Q?S+3M3DzgYPqU7zar036l6Cuqr6qB20O3r1GKQYyePynGqWsSS6vUghe4cFGW?=
 =?us-ascii?Q?XUWsQST8d/xe/0rypM82llZYqiD6haA+eh89rPRPLCYeLiLwn2hOBsJ3Rre0?=
 =?us-ascii?Q?x4ZO4uXK2WOsRmoeSOfUWCoxNJv3gRsF6D3I/NeloKIyLhcdp52HJFJJOcjJ?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d31cef9-057b-4c0c-23fd-08db0473cca9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:46:00.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BsOxguyYEFyArblinjPeQSKcHvljPzlJhNn/NPpBq0v9LxyVwyvLp4U5QKUfs+HX73+9FcacXQxFWlRkQJ+buNCPnyf9RvK7gAQV3zN86k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6613
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 31, 2023 at 04:01:49PM +0800, Herbert Xu wrote:
> Use the crypto_request_complete helper instead of calling the
> completion function directly.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>


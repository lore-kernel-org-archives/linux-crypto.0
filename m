Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90672C636D6
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 17:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBWRZd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 12:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBWRZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 12:25:32 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A5C18A8A
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2023 09:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677173131; x=1708709131;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ufodHtTcfUNobuHjY+/eatMlOmTZO/2vG9TlZi72cj8=;
  b=XRngI0Mex+CdI0eYW1nv9Pjp6buSAVGNmdbxb/2G2L2buFxxa+IEdoTs
   bA3SYC7GDX3fOttRgjwsx257SV75POIBjO8/AC31lKDuyjwBggN912Kf7
   kRZ6YpH0tA8U+7UOcD10lY5u6nUQDbqD4F4cUjJ0mi5I/TNielK5po7eP
   /upOl034vmmS33rq9A6p4U/LUPi9wwa6fxjrWbd5SNtQF9XAa5zP2RfTh
   M/HFIF1kCdQNws89nqXIdCFpsZXGAF5xkfeieBaPcmtJfmx5TFPJ/DLsK
   4TOrr6Ym/3LZWD7hq1lySo0PPR+LmaWa8W/MlT1pXfCMctSr2Jp6IOGH5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="397996033"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="397996033"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 09:25:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="781994577"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="781994577"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 23 Feb 2023 09:25:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 09:25:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 09:25:20 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 09:25:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/kt0DUBAgQ47PA5AmZHEvvFHo2exsJeT4nBgm8eEs8ruyDZ1LTk6c+/uYvpLlxHO2nJuhePjXWFTTOkJ9KYlzXrmLlrP3aEcKFkSmhEfGQsw8iUBhx9PjB3g+Bkl+Y28u4UoceLPqzYVQfS8esUalRtd+fAxNeeXl0YKP0BojUmxomJNVeK8urhbDLtPkymCKOE1osrxB2HRwjcT8Y/HWO3f0UWS+bqxv+yRyQxsoanrm/jDzjNw7Q8lV8rhs6+X5Rdu//WTgK/whxLWrAkNxuYSBWaUK4fQgPtGyxCtUY9sI82K7zfNubBAoTrCwajoXr5ApjV50urlFSeb9sZlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W521smpjByioaBVEscZ6azK6Av7YVY/z8+Wjt9Udi4U=;
 b=C6jGbzOwUmUphMMgSZG5+cYy5/vP9lOhUu7hR76Kpbow26lYjjYf197+GIzAMMDNPQCuCGuInPwrharEdl82wiYb+IFceMcXn+U0irUMbgE0M8KdgOaEsjjw7HUXRL/RCOhKH2u7T/gAbhWIOADlJeuUyySDSr9xphDGEeIhYdQSLFnULBRVXM+HyZ8BPnOU95xs6ugqEtsS9//rOGMoJbpATRnVNLBkCdCV7KlrLqeVFd/ghXN8vL+TX8Yevm2aRwA8sV1hHftNYtsDchmENYsVWpc3uycgp8VUA1bau00r+BdF/O4CzirGoO/hvTBkm3HHQ7DQEpUl8FpvzET2VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by MN2PR11MB4677.namprd11.prod.outlook.com (2603:10b6:208:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 17:25:18 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::af76:f08d:dc47:8f8d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::af76:f08d:dc47:8f8d%3]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 17:25:17 +0000
Date:   Thu, 23 Feb 2023 17:25:12 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - Include algapi.h for low-level Crypto API
Message-ID: <Y/eheB9yHWbfAHEt@gcabiddu-mobl1.ger.corp.intel.com>
References: <Y+yZHiWPKyyR6fLw@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y+yZHiWPKyyR6fLw@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0128.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::7) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|MN2PR11MB4677:EE_
X-MS-Office365-Filtering-Correlation-Id: 06bfaa18-05d8-4704-f328-08db15c2eea5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u1zOFH+MHqCv11dTClXDAkrdKgSfLobf0uFiVdOvGmSES2I1PAlHn2nZlqg75m+pff3HmyezlzTEq7zv4CFywUd49QFy3HRPV38LwG2Dy6yDZm+8btTvfWDRJnknkkCoclhh709sQKWQ7F5BVOfFsVjXtzDPwKShQytzEDFrs4c/KPeJBBNWUMNUx8uchCWO3qNd4N+kaqN4Km9L+1dMSDHenWcMJ+49POKLuPQOrLg/4U0U3kI+ZXtCAbXmBQaVv+CRT1kd3WDLZZjjZq4mnxyqNIzRgLAk6Jul/WbLJytI/3hLbWk30jnr9F+P+el/j/9tRrZ4uTeAdhjqEDQx30i4akIlLH8FQUx96KKqzVcG96cftYZlrLxBWvbCciUbeYqHiGPCx9Z94jcC638UV7jQmv1k2ARUFbfkGQr+h/tX4J55WXJTZ4rA1mtJ/Tc5FvL+p2Of+NpMjcPaUlwOJHQOAx+PHQ6+0sYjYbxrdUvocbUIme7pWWoJP1qoLkRiHnTdm18w613iFsWzEF5nNxfDxXZOlAD6L0Z+PJ2gp87QDeGhZcfZCQ2+psPpCad43hth/FTzCsi+GyIgdLA1E88LPDev0CIZNBHKrZfJyWPtC/GyKsUhOYnojhNJh6rlrFk3Y8IgIuYS+ikkolbK2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(41300700001)(5660300002)(44832011)(478600001)(186003)(26005)(8936002)(86362001)(38100700002)(8676002)(4744005)(6916009)(4326008)(66946007)(6506007)(6512007)(36916002)(82960400001)(6486002)(316002)(66556008)(66476007)(2906002)(6666004)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nh8ULwWod8BqaXb0dPV9a4Y7c793izI8aMCUWKWKPSQdStKZy7j2UgfqO6W8?=
 =?us-ascii?Q?EB1iPPvXK27BH693cqzbaFwaeDM9/Wf7lAObWFGHGElLZRFiW1v1ui5xDX9W?=
 =?us-ascii?Q?QmB642rh5fp1LsnfOlTq+FG9oT1u6WR1QYj6eVnUd5HxHgO1S7twA4jSbtLD?=
 =?us-ascii?Q?wMd5eiBW/hUALdKFUIEtrJS5OJb15lmTY7hmG2WX8uu0AV1csatXHi720sGU?=
 =?us-ascii?Q?RsA5H/qy0ptI88u2Z9/eZEx43OdUKSvyV9a6S0Og/Wcof5IQMlBydY65w2RA?=
 =?us-ascii?Q?kmaqeNYlHp9Rg/ZluEFURUnMji3/0Xwn46wsaTc1WQWWnuZQ49XyFyOuBUgq?=
 =?us-ascii?Q?djf84R6pTJAdySHPrsnYid/bMIXeefhVQaQPRBCLmWK4J/rnoTI23JFPJz6g?=
 =?us-ascii?Q?esI/pLMPJmNorr9Bt8eWMjYf4KWBjgpeArO90qXe5j9bVTUQYO360C4np75F?=
 =?us-ascii?Q?V0GNKaTFhz7ikO1fWT6ORLLoO3MiIg5Dfk1U/rd6o1wX07uWTB9v/G5amyR8?=
 =?us-ascii?Q?jZLC//UflFADzMcxjmYmcpa/NnoFTw7cMnze6wZbocdYgaLTkt1sDZN+vHEa?=
 =?us-ascii?Q?POzdM0vVlBc7uNpZosU31PeOCEv/5rAVo8xYafgY+LM7rsCTP2C7Hkig4Rma?=
 =?us-ascii?Q?pWRi1J7OjEu0pWiEkcf7N2a4oy4h3mR7FAYVgWcQCnEHJdoxeaaHRXjAIVra?=
 =?us-ascii?Q?CpQs2Iie5Yl1MQkoSCZaQXCqchGkttCQScvG6AzpRB0iz0MByZdpG6kWSc0Y?=
 =?us-ascii?Q?SN9G2mlS4mQWpE/2ACahLyvZdU+90ack0D1S2Y9orPCYTHk/UNTvbg/q656s?=
 =?us-ascii?Q?ux7O4lfsx4IWhUdmMBaGTJ0OKG9TsoUCwi4Z8YPfnACqs5Y5ylvfETr854Y2?=
 =?us-ascii?Q?R/N+C22ChA9dFQNUqcS7nzmzPX0cqUDh8dGvZ4/wTuQXvPPHd/a2o4ti0O5l?=
 =?us-ascii?Q?uckwcU3eHSVeaI9vYLArGyFyqCepsnhROyXRrvPz3fKnT8WY9s5eCQYmkwCw?=
 =?us-ascii?Q?nzEvC9gGkzMrP2JhLLQVeTq3ZuvHuq8C3mBq/+YbKzjdJ19CR5xVcvUcS8MF?=
 =?us-ascii?Q?yfx1+xy3q3TqVFTVtipEo16exlDXOuTCsp5OjyAbBwMT3LVDU3Nuo5LS1viV?=
 =?us-ascii?Q?rr6LDaVvLTPnFPJtARsgv4DfIXxqs1dLWT6K1YeZch2/zm4gx+x4XidbagxB?=
 =?us-ascii?Q?A+FDHtsm9uzRpNqWYzskmNp1Otg/RsGpy2nOCe7uLs3JaNEWJ8k7D5YQQ9vX?=
 =?us-ascii?Q?bQxIZWvrRx/Pi7KQba/wNMHn0Mkg8CA/FDTRXwq7+QkaqVIK7+ghKzUkbCLP?=
 =?us-ascii?Q?QW4gufoLxNlrRmf+SHll45UECNYmbae6EvuhxGGn1cgRr/3aBtdCzQaQ5m5u?=
 =?us-ascii?Q?VrzENMTpDGr78C52sjsJ5GaXRBHJNnEmN0OKJx6Z0kek7dQuvx0wiY7x6ZK5?=
 =?us-ascii?Q?bhXGi1jTG+20pFo3eaeoFE126jQcV3c4voyVGq7pubvmUhMQs+YYvi2k/FIC?=
 =?us-ascii?Q?LRgRro+xHpdX2xLxFsHyH0IrHhfEuDS9SYBXU4w/KtnP8sshmIfuayYpfXij?=
 =?us-ascii?Q?ycQIkRKpbhTCFbFkDqyatguAD2LraS/pNh8Xs94JDbBTwRBkYU8osyDzRXHa?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06bfaa18-05d8-4704-f328-08db15c2eea5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 17:25:17.6779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cp0sBhehdDQOiXFe3ZQWqCUwZT7adtvg3lMBBiz990B6y0+nUjjgWWCfSdOziAAMsePaP0zIvTVhpI/mkbE8/UJGFD6/pZjzheCJ89Pjkgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4677
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 15, 2023 at 04:34:38PM +0800, Herbert Xu wrote:
> Include crypto/algapi.h instead of linux/crypto.h in adf_ctl_drv.c
> as this is using the low-level Crypto API.  It just happens to work
> currently because MODULE_ALIAS_CRYPTO was mistakenly added to
> linux/crypto.h.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>


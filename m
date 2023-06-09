Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19050C7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 12:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238387AbjFIMFH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbjFIMEu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 08:04:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB511BC6
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 05:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686312289; x=1717848289;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uEP5qNLR8Up6iLtV9L77euT/k6X6VqoOwIgJYkk++Yo=;
  b=O5G6bSAParZW/X1iS9inELwx12zjKf19Rl0E9rs9mvgaWfP/pX/F8WD5
   vRLDWtvUOD1FlHu+QE5B+b8dAngvr1iIG1zfQqqFz4Ps3ZoVXaY3Y9pyN
   2T7nDk+a5pv5ins0Vmp7Mg4lcjDyOZh+eQJ0pYF55m0tCaIYfejamliWy
   FU1z1FHURL93ISPXXRNXL67VM3pi79R7WMWJ2JGTPy7fZtdG4l/rZZEDN
   TmNmdvpq7CJ+jO2OM8VfiWe4zWxt+eYqrnQLk/Dp2Z8nuIU7/e7VkCHk6
   bdPI5b4d8tTVwvre62mRhSLL4KqOtOF8Au9p5TtLS6AMeryW7dMHeFNmv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="342259325"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="342259325"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:04:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="834628775"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="834628775"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 09 Jun 2023 05:04:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:04:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 05:04:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 05:04:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=De5hbmWg9prQd7u49fyJsfchzjmbU8YYmFUIYSUYzkrl7XB4EiSFiBSUwvB30sdDqz4GMNyXjKsSBkMYJ8dgDPBTq6/bBOrC9bwAgSvibnHQr8WNNh+W3RaUYmvk6dQQpZNnG3821SUjogaqW1INtQTbiVbY1Al7QQRSxM3FbUC5QCy+Nqfg6GHSp+jcOEbA659IkUAC63hPiYKxqvnOKEUA57h9f2yez0naEqVfMqTHvVTSrW8rG/mzAypzocPzDA2vYT2hmgCCAjySIe78n0qPpEZoEFplcoBfYNTATJ6uOZ+EDYGkMQeKAoZ8NUbvgQatL5u7/kc5z79/yoyXNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBBdIk6wj0TDxLRAEIwdEYfm7UEU83Z3OCJiodMuQsI=;
 b=hsisH8d+Y3Omx9q2FikzPZxMX0yebpNCoRKDaQnjpC0ktz68ce7ijs+ZkEFjYATaf+vM6BQv4JYjXtK+l9uBbWc8I7e/+oTm0TjbnQlPZjQqnwHZHYUUNebJtD4Lz3n8op8UHCKNvMhgspYEe8CdvGB8UlXbGfA2ryTQR1Npb1zhGNi6g2i2BrRu3jUzATByonjr3R5RxQAcOWzBECuW8iidCtjaoTFkQ5PHdiGF9ckHXDLblVQexcgLh3bSWwNK1IG0tQKhu/0Z571Gft4BuIAnM1iANhTp7ansPN5NhRYthpEyiNOeZ1mDgu594YVbLd/jVb8nWzc5y63ic4Om6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 12:04:41 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::21cb:3fb:a485:5481]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::21cb:3fb:a485:5481%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:04:40 +0000
Date:   Fri, 9 Jun 2023 14:04:24 +0200
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add internal timer for qat 4xxx
Message-ID: <ZIMVSDWXOcS6/Whg@dmuszyns-mobl.ger.corp.intel.com>
References: <20230601091340.12626-1-damian.muszynski@intel.com>
 <ZILrxDmxkHyIZ1Sw@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZILrxDmxkHyIZ1Sw@gondor.apana.org.au>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173,
 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
X-ClientProxiedBy: LO4P123CA0580.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::16) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3734:EE_|PH7PR11MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 4083f462-482f-4a57-28f1-08db68e1b413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/dGXLtFPNqPoMZro6KD5Bux1n9jNn6AHZNr9SeGbs73i1QKAXKr98blg9AZlvaZI6Ga6o/a4YRZ8dgyG0Rhcayt/b4Z931npx31qDjswRKh0atjkQwR0YJm2/oK5tw8tuBOBXsaGepRIFu16OddUOxfaJP1M7PAtAJMVVJ0NJgU/mIeFOElxlSgY7KUVm/B2OHkh74Qqu3jehjHUvdrFiwoa+DMBqPzyjoTC6iByB33WmoYLKU4nw4j4klBPLIPxxwKF+MuyBm9K9wbdeIb/67lYs6bsVlT00SFeui1Pd0D58lnnMcFIFAj+BOOfffkZrVixEXhjfedsi195Pkce0uc/CrXML3RQxC9tOgdLF3kWNhiukUuPSE3NidH9gXRnh6pGaoCQyUwTdY4MTjLLVjlmnpeztyoGkRbFrig/x5RGsWho6g9O7OJft1FuoLPRBUXBa71zb94R20tzpJFFikexqayLYULtL+tfCTnK2wwKioEmFU9jgS3eNuBLSXrm9yW4IKbYTjr1L3th2LYJAftO1yZLgU6Yem/GjzT2gA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199021)(41300700001)(86362001)(83380400001)(966005)(6486002)(44832011)(478600001)(316002)(8676002)(8936002)(66476007)(4326008)(66946007)(66556008)(6916009)(5660300002)(38100700002)(36916002)(82960400001)(6666004)(2906002)(6512007)(107886003)(26005)(186003)(6506007)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?004T3FHc1f/+Xl5OacuSipdxa54owwtlR8vUSWSzSE0c+qA5ediEhP3u5ypW?=
 =?us-ascii?Q?0pKZ8OWU/Ev44i0ea60mt8uFkQ8Mo5sVIomfy5DHLXMoJv3ei+Dz36XzOb20?=
 =?us-ascii?Q?xcHgt26Xwf2MM6EIuNxsiDZOTw53vZYPlVN9aILgNbAn0FKd4kHSQIvcd+Y9?=
 =?us-ascii?Q?SBjniFMihWltqJ/HldT5XGQ9wSj8DzR+qn5h5I3c/EabtIt+3PIdy6UvQwhS?=
 =?us-ascii?Q?XQ/x3Lzs5imF1Fs3RkbcEQ/wwICDVIv2XmfyM5FTO7Xfa/ANSCDCqm3blIt0?=
 =?us-ascii?Q?LHtr5VBQtVpvdIx5hqiSMJ4KPS3gd3NvTf3fFZ/QNkkYo1nZhIaayFXcGMjs?=
 =?us-ascii?Q?xzdsfisJTwKuN66NNKfA7jwp//ThMVkhr3ArVsy07q9ZRLpM/qAj8bS25Q48?=
 =?us-ascii?Q?p2MmL8IHKPrhBpLO4RqBT+mFVOTNEtSwY7a7Rw6RfjJ7wJY+4/IKGb3rwiGy?=
 =?us-ascii?Q?B1WygUtJHZ0dqXtLtwMoz1BLIx59hmm0AbjbAzuVq789yZILhoD0hgi5JBF0?=
 =?us-ascii?Q?joVYhsXj/fm89h6aFKcIXt0aBthzpDv/GJDSKftibvwgR6hoMtcCmia7ehpC?=
 =?us-ascii?Q?ewCrTJH8uLUn8GdFCLJAwmCHPb9gaBa5P9z/gdZVdYGwyfj01iKMNjjGNaGq?=
 =?us-ascii?Q?AOQvBJIF50M7pIfX2iso/QLbI7P9HbQQCxuzsXNIHF/n2dULBe4L36A0nBNh?=
 =?us-ascii?Q?X+DlhjJBRRcaBKOXtLZw1LVPPgJ7PW6nnxpwJnIKJViCh7Rn/ehJFA4MJRIq?=
 =?us-ascii?Q?rN2RwiPp31Of+njKOV07GibAV9aasL6hre6QjuzWiI2QSrbxp8DPa7yDrIYs?=
 =?us-ascii?Q?XqkQ7i890IKXepLpwXQfcNa3voQg3pVP5hu73bPEl5udWsbohlf2g0BA6qT+?=
 =?us-ascii?Q?PCCiuiB0BMu9MHriiBmcW6xFEew9FBS47jWGM9OumEaASohNf1HRZpDKlRJf?=
 =?us-ascii?Q?o+6mkrN7jB4MZGd+N0g/nvzLeGU6zYTy0lZa2URrN1gsAiy4tjdSZ58L6d6g?=
 =?us-ascii?Q?52d7L7H8JNUmCVxNB0tQui3/cyp6Qr+v+6eCg+ArRBXMMUhSA25S6nGTV7q1?=
 =?us-ascii?Q?DinmuvNQ1rxQcj1NSA7tlSqNpLuafCuTkPJlhnjAw8XFZXzp7RQnqBkNn76f?=
 =?us-ascii?Q?6GD8+nSBrCquoAhPe9ksXzZbzzJhnunNE3ga/CHidHm0BnR0DYDFQf19xcBs?=
 =?us-ascii?Q?FeD7oMXn+B+Wwe2PPTBfcjMaNO4l3JfMrJTGX+Aj+WHtsphc6fPoNZyW2CzD?=
 =?us-ascii?Q?oCYEkGd7TqbZNtN/MUBMFTdLqB+ixkmXct4fvC53z9VUOtyyG6VC1g6/u35w?=
 =?us-ascii?Q?Wg8Cbrzmlq2lqMrPFSzEHAHJSBIs4jBbD3eAlrT1eWyYKVPQjIKp64wqhgjb?=
 =?us-ascii?Q?ez78aAaYmOcwbvbOlvdYhEVSxG9MG1FK5cltQTQ3vTRaVkeBImQX+mb4CotB?=
 =?us-ascii?Q?ypjGKSDrcJFrbUTGy0Vx4xlHypYvuD5DMl2XIe+a4aEsZwMvssBP/ZXFzz+I?=
 =?us-ascii?Q?d0iI5PXe4k44unGg7GGhdntHKOvCQ2Y1EkPN+OIbbEYL8tWyapyMK/uotQ+B?=
 =?us-ascii?Q?ErkKX2pw+pvaNRan1ujy+Sz66vFGMy0acJIFJ1y253Sk2im5ie2bHn3GPrMM?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4083f462-482f-4a57-28f1-08db68e1b413
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:04:40.3685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KpWSRcJSyNRyYvrPq2krGS3+URBr6k3KyR90Bks0A7eVEfZuq/Y/Dm1/CW8sVXFwciwrXq02Rh9iZfOi9or1HBTpVz5RgKyt8cw+ZZL4P4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 2023-06-09 at 17:07:16 +0800, Herbert Xu wrote:
> On Thu, Jun 01, 2023 at 11:13:40AM +0200, Damian Muszynski wrote:
> >
> > +static void timer_handler(struct timer_list *tl)
> > +{
> > +	struct adf_timer *timer_ctx = from_timer(timer_ctx, tl, timer);
> > +	unsigned long timeout_val = adf_get_next_timeout();
> > +
> > +	/* Schedule a work queue to send admin request */
> > +	adf_misc_wq_queue_work(&timer_ctx->timer_bh);
> > +
> > +	timer_ctx->cnt++;
> > +	mod_timer(tl, timeout_val);
> > +}
> 
> So the timer simply schedules a work.  Could you use a delayed
> work instead?

We considered the usage of delayed work when implementing this, but it will 
break functionality. Apart from scheduling the work queue, timer_handler() is 
incrementing a counter which keeps track of how many times the timer was scheduled.
This counter is then sent to the firmware in the WQ. For our usecase, the 
counter needs to be incremented at accurate intervals.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41535ECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 14:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbiHZOVb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiHZOVa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 10:21:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAD14D4CF
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 07:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661523689; x=1693059689;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kuaYGmX2Li0LjZwqcs9uM1ZADbleRGt1soMRnBOwJZ4=;
  b=j26Ox9H2CR0Qk2FCDKleZy8wQdMx+fbg4yyWjpdUlQPRvM5Fui8IJIWl
   j+sjv6X+38IKFXpFKnvefr0Fgon1OIxB9Edq0j2dF37U1OmFYa8uuW9ao
   frT4JUzuF8h4AxQgsZ9ujz0ANQMNXewuaAJITZXV4H0uTfyZXwo+dZyBj
   m6TOibbUmNd3xWU1bCPzAc9CqRVhhJ1FF2NP7rxgyhZovRjjNKCgWDejj
   lCbzG2AfhrGX9LmOOJjLnHHTFLjl6UOv3Vvr2ZmhhFKcCy/k5F5Kur/R9
   3xsx7JyHSOX5hzGC7eIxZ0eIfXdpvZWk6ApdAwhZdpI2UDUoQU2xqw+Kh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="295293786"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="295293786"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 07:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="640072419"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 26 Aug 2022 07:21:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 07:21:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 07:21:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 26 Aug 2022 07:21:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 26 Aug 2022 07:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ET3YXwJ/utNDQ+tnDIgMrQwPa/2xLoto0h2oBBS9OeL0/zGVD9R8t6BhBJr89RnBMvffSMnpKWW902zWuFjPZKYHkSOqrJL/vyRojpI5ZBySPmvLvO73CWn8I/GY5+2PFygJzwC/8HfdcaprUpQySmeDp7XLjzWoxObwVG3mjir2ETBa4Jx8QlimGqNFrwGF2CjDoq4l3r0I8G5pxlazh6acSHiIugzYq/dfmfDgcCGj/Ly18Ap+mhIb86xvIiMa+w33ezAJHjEo8cRacHqBiaMPwSYs5+Zquj1dJnLDktRzVWwkB64eknYCCVyMFtrOP7ofISebPhpUFKYSyDErgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBxeYXVvgCjnQ+S2+cUWeFM9QPvCeMrH0pR4lt+ziYk=;
 b=OxOv+nYff7ko8SGbDXUpG2i/lkis/pNycs3TZ0Y2WKhq9seNfFri+4J7QuTw73JrHq8HWwp2Nf0kgPlsQ1mFl5oN5hYVnN/ZZzpdaHRGab53x3a0qrU8qk2gHxiWaIZmd95bydS7LL+2HehRANXC90CzHpDOMjisteIAljAgsIKRuRQw9i0u1IMvlQ69ZPeFqQo8eufrDNHjRhNZuTPJSCAJoo4ME2VdqBE5XJge8arlmJW0C5tayuuiujjjFzUqNtdDOkPwnpDMepChwrT/7K/1sBw2oKUheaNPVX8UW8REq7XPz6aU7k9zZLrO3g8PmPH0p8GHQ8RgOFKri+rEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM6PR11MB3516.namprd11.prod.outlook.com (2603:10b6:5:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 14:21:26 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::9d94:4bbb:2730:639d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::9d94:4bbb:2730:639d%5]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 14:21:26 +0000
Date:   Fri, 26 Aug 2022 15:21:15 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        "Adam Guerin" <adam.guerin@intel.com>
Subject: Re: [PATCH 8/9] crypto: qat - expose deflate through acomp api for
 QAT GEN2
Message-ID: <YwjW2x/uT9ST8+8i@gcabiddu-mobl1.ger.corp.intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
 <20220818180120.63452-9-giovanni.cabiddu@intel.com>
 <YwigYBNM7O/J6gO1@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YwigYBNM7O/J6gO1@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8P191CA0019.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:130::29) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 104ce78e-5c9a-4a4e-b462-08da876e42c1
X-MS-TrafficTypeDiagnostic: DM6PR11MB3516:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W462VDdIXu+6n8R0Nzs/6Pv3zMrnQXMF37fVC5GPzbJQax/5xzA/sx+5L62fs9LcA/guMU+UV+cQZQRoDYfN/L7lLOjWz5UQFtF/oZ0t3+2B97U3Bh5Snp+frBVwQBLJd5D6QxvQsrMhEdjBg/THP9Fm3P1pZZjCRcR4eHozoxbtX/6wGG6TDNu+27Ah74NIaVuhPCNj7S0h1XFki4bp0lnexjDM0+2gmKegiO3oWElfepWccJRcI+IvvI0Z2LXq9foAzT28XWs8weGPvIowDhvB8l2yQSS7fjyJUEcawXERnKwGO+AdiP9zTVqZDG5g1b0oY+PD59E8heVx/p96eQ81NQ8Cc9ANIowOB/pMwQtogLcXGJWTFiVt32qfz5Jc07DzNEo+u7KGm0OKDc2VQ5aXk2vFIvgc6AfdXYIbLMiz8GZBIuSXutRPIi6PGso7eeRu8pDuf+RbTVRZt1hEnS8LSH8tJX4ZdVOYq7iR9rUXamFojuFxJsjB66hrXGewkVa45R1EzuaKU6b6XOb8B7pUJca1s2eRlK8ulutHzQTcmQn2I0npEqkRsUvFGZI2xE91lvL/rVtX/b0yK0oZ5sHLhv/1pKAYCFJ/VIyR+jnmLw2afBfVUYMTsfJfi+Kr5pmPWKLLjHJ5G5+UBzJUhePcbxy9aVgY6hZCudyEe+mUQscD75wERckAymKIvuQ8e9nX8KsFahYTqUZVkoysBMMIbbVMdbC16dMN+P4/ND3eBpmLa7hUYk50DEBGWA2+2ec9XJpGSah4Laq2pAU5yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(366004)(396003)(346002)(6506007)(83380400001)(478600001)(36916002)(26005)(6512007)(186003)(82960400001)(86362001)(2906002)(54906003)(38100700002)(6916009)(5660300002)(41300700001)(316002)(8936002)(107886003)(966005)(66556008)(66476007)(6486002)(8676002)(66946007)(4326008)(44832011)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?liWp+1RHbvsBWdgDBcJLU/AH6LOt3XFaroR8MAqCCibYFw5/rhULCZGZcolv?=
 =?us-ascii?Q?Kxmt6FWm8EeVYhUAXpyOO1n7eK+/yu0YZlsSdcN6bBUGjOnhg7JgCRRHEG5N?=
 =?us-ascii?Q?P3CQLeh99erMCUDQNNA0WQkBaASdDJmCKKu6CqVA8i23NP0Gn+S3YdzTu6YF?=
 =?us-ascii?Q?vjkkx1qIjKGvEBuKyTGNQri3dMSgwTI84Ik5e592BWciDFcbX8X56ODi0fXC?=
 =?us-ascii?Q?TNsEuTeO0MRzfiV5Rfu42ML8qjkUkVcOrNvBPQPNhhal8bzLQ5h7ZO9l/fDz?=
 =?us-ascii?Q?ThdG7H9GR6lJsuyjheURavmgFpx3sqjKw2opjCHjuonFUF0UXIRKLE2NwYDu?=
 =?us-ascii?Q?VfnF4ll7EMVmtEv84EVJ5/hUEKtqgjKLnod0o/2tidbNWEHq9SXvU6XYc03T?=
 =?us-ascii?Q?a66YXeuwXuYix+AS0ctU3ZbKyhL+7pD7KgwBUgeQU9wniOKtTxGJGCnJFnBH?=
 =?us-ascii?Q?zHaadOz64qHw1ChU4DUW/5SFiSmIG6Yz954GhjrpoGDC35duep45I0qcgu5e?=
 =?us-ascii?Q?KumpI4imn05Pz/q4VJinOtDD1j1jImIZx/9kb1vM60wPlJ9wJ+Mo0acoqQCN?=
 =?us-ascii?Q?aME4Y53VasSYeSAd9aa/uQi44gABod/8nFmtNJJQj1GFnLjNrbMg1EwiGKGN?=
 =?us-ascii?Q?bN96sk4FuwIfmLoXbV9qnxYE6nwXbCb71OJT0YGxBr3fe9c7yyuAAy9aLBrq?=
 =?us-ascii?Q?ldRtorOo7dnijkS+ZsB2vluujra/T22jwKs4ydh6nYqueE2WjnsR+agT6hyE?=
 =?us-ascii?Q?XzFifjAags0CPDcLE8uUF9B9skaeD1gWSHkTGboj4RhTCKsqgZ/jujbzoAKX?=
 =?us-ascii?Q?gd2WYrTboNaI9cLsYSlQK8gGpsYQN2Z4deFfwgFP/hoXO8SmdpYhS3RJgGc/?=
 =?us-ascii?Q?0caAg5EIvXJ2g8OyK347hUmMxRyLz+45uEsf3Yi+Zc2zsnascZE/sw/r2PM9?=
 =?us-ascii?Q?rPYC/damUUacs9uyFdJitlfxYE6uqequEANhm9MpDes+YB4yAUj+mI7HpeKn?=
 =?us-ascii?Q?ml8OHIZ3yjmorp0lLd/9kNqtHp+STfBfbZ4sNxHXaEJ2FXdzW0Lg00zjBVEi?=
 =?us-ascii?Q?8/aoWZDPJj8Kdqup3Xqg34eHVfo58RVEshSai5KXcT/JqhwTrZ3i47itlP19?=
 =?us-ascii?Q?GdbGlcO5fGakwRah4XEIGj8C0OpR3q2Py5JwUJRVj48gUqo47YGgmL+7yQ4m?=
 =?us-ascii?Q?8UBqRm79HHFRCUiVURDh/xIRT9ym/TNXZ/ZEcsmt8xL2jJTghFcLBMZqd/jg?=
 =?us-ascii?Q?EPVWVFWaBfU2lKJRfc2b5dmOSDwTF6FtXmDyuJC40ZEc38oQALEzqQxsUHNX?=
 =?us-ascii?Q?SZHb7b+JteptnFjczm9MT+6iNAUNAJiU6X4akYwKrIGWisf+lqjtY1rcNboX?=
 =?us-ascii?Q?TYM0R28bhVuUIDrouPSlSIMDyjxgi9bysJ1rjEEMnV2lj4nKM8sqNDu3tfpc?=
 =?us-ascii?Q?+PnVFVNm/QVsI0nl0kc/zPZkXsQuxKGObr8FGWfqV5v4zOismyxumhhw13Yf?=
 =?us-ascii?Q?+Jrct4zXdprUdfumUHAz/JPVDUyzpUuXxiAcZ9FBuiVXxGQa5lxI1w2oQico?=
 =?us-ascii?Q?vDKGXI4WpsuvnTrLgr1ayLEyzPrlYsUU0JnWhndwYLl7zLVQwoh1G/qeO+P0?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 104ce78e-5c9a-4a4e-b462-08da876e42c1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 14:21:26.4833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evX9VSNjYJz/eWQYFXH+RmYHLxHDi6mAjHtKK6lcOhfItLDAqNYgTjDHAhLUaa1C6CeIoasagSc0Xwy47E8v5sr2Qtd3fJSHGLPLPijXGkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3516
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 26, 2022 at 06:28:48PM +0800, Herbert Xu wrote:
> On Thu, Aug 18, 2022 at 07:01:19PM +0100, Giovanni Cabiddu wrote:
> >
> > +	/* Handle acomp requests that require the allocation of a destination
> > +	 * buffer. The size of the destination buffer is double the source
> > +	 * buffer to fit the decompressed output or an expansion on the
> > +	 * data for compression.
> > +	 */
> > +	if (!areq->dst) {
> > +		dlen = 2 * slen;
> > +		areq->dst = sgl_alloc(dlen, f, NULL);
> > +		if (!areq->dst)
> > +			return -ENOMEM;
> > +	}
> 
> So what happens if the decompressed result is more than twice as
> long as the source?
The QAT HW will report that the destination buffer is not sufficiently
large to store the decompressed result and the job will fail with an
error and with dlen=0.

From the use case described in this thread [1], an option would be to
allocate always 64KB, i.e. IPCOMP_SCRATCH_SIZE [2].
Alternatively, allocate twice the source rounded up to 64KB:

#define MIN_DST_BUFFER_SZ 65536
    if (!areq->dst) {
        dlen = 2 * slen;
	dlen = dlen < MIN_DST_BUFFER_SZ ? MIN_DST_BUFFER_SZ : dlen;
	...
    }

What do you think?

It would be nice if the user of the api could provide a hint for the
size of the destination buffer in acomp_req.dlen.

Regards,

-- 
Giovanni

[1] https://lore.kernel.org/all/20160923150518.GA20384@gondor.apana.org.au/
[2] https://elixir.bootlin.com/linux/latest/source/include/net/ipcomp.h#L7

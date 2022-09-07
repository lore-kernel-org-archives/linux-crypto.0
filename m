Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C283CC38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 10:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiIGKHW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 06:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiIGKHV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 06:07:21 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B88086700
        for <linux-crypto@vger.kernel.org>; Wed,  7 Sep 2022 03:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662545240; x=1694081240;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xBCkoyESMw4Q2V8wxdUJfQFkNKicasvomXs3pa0o4L4=;
  b=K80mMDdeh0utbsnkD4CWA7GUxnMsrZHYVCaexFeEkrR2jyN+ORrgYcZu
   T70gb94A0xiT3Li87Rk8GBBQfJ4vqjMeUmonf6X8jMtfwbIRwDv2CTuyz
   Y6RUtXN7cGqeiqnCTd1KWmCuok7gmedxwwolE5vrA/W5vP2miLElm8hzQ
   IT5fS2BD9AYnJV/0kSxBjOfw8BbGtTUQ1Xan6EzhywDucZCq2ZE7Xd1KM
   ZwholpGwgIPWqU3E4aQLrnZJ3dsK+2eC04yYV+m8RovFW6AT2Z6UYBRzD
   qzz5EWdAFpGMRSR0DFjK3pTJroyox+IjlZIFOJv/mZqXHWyjN+p++jdOd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="323017683"
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="323017683"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 03:07:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="942827873"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 07 Sep 2022 03:07:20 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 03:07:19 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Sep 2022 03:07:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 7 Sep 2022 03:07:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 7 Sep 2022 03:07:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao/sy6G4DfWY47B5wZc6j3btCgGwSKT/FBDRnxf5I7AuO70b7FAVp9QYEQrBSqH5FRtHZr9wVPa3AX7C5iqQFUGb2s59x2lkrStmTD/WkFM2N4Y9p1nypS/5x4XMuaCCXNM27efBP3dPXaM8J6iZZJxGqL7bGn7pqjAMtj00n9oqeJfPIyDZ3zdGum6hmZh6Uo4Qp3jgrDPpcOzX6eDyBFBLqc+IFO4D6GxXb1OatoTZ+0VdGkUG1TQ3Wp9c/dRRkqubo8IrXMlJhs1/lxut40c/MFnOWonOCsytUHF8Oos8xDRka6YIM8gO1obrmLbQgcStAkwb5B15MagGH1ZtYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kftFtg2wEFdStcuYZy+MVcPbRpMzvl3gQHp2daQ68iE=;
 b=XzmqhubrR+vmkbzfKEMV9bOq7wuJ/ql+bgzbeLXUiBhiGqnybcF7CPgAN0VpNT0xcyPFUeC02083vSfZjDN0U1qZ4UCD6ef3y27ZuaF2ZASmxYCqTYyxPzRPkr2k8VQXh9/uM/Zd9y7jnSL5SBnj40LKtRGst0+XehISxTHMrmAIE0sHfYHourzdDy8WLYtRux73XzNiviHP7NUO3qBFXC+ZmiSuieZ6HcXr4jIwymkrKrNqiRAtGhX06h1uI6VOhPmEVfraht0TVmBYuCFBeEqE9WM81hfQ919ICuatVAxuVTdcSZqGKhPtNXrbvmiZlvrQbDBu0hg7RH/XK2aL4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by BY5PR11MB3944.namprd11.prod.outlook.com (2603:10b6:a03:18e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 7 Sep
 2022 10:07:17 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::9d94:4bbb:2730:639d]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::9d94:4bbb:2730:639d%5]) with mapi id 15.20.5566.015; Wed, 7 Sep 2022
 10:07:17 +0000
Date:   Wed, 7 Sep 2022 11:07:07 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [BUG] crypto: qat - Mismatch in DMA mapping length in
 qat_rsa_enc/qat_rsa_cb
Message-ID: <YxhtSz6Y/tbi5pw6@gcabiddu-mobl1.ger.corp.intel.com>
References: <YxhLgkOBQob6qdRy@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YxhLgkOBQob6qdRy@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: PR3P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::35) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc7ed3d-0145-4b65-b351-08da90b8be95
X-MS-TrafficTypeDiagnostic: BY5PR11MB3944:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39qaOsupAhBCIEDqFigzjf0ZNmFq0KgAWVvgCntMmVZiBUKSvxabOOrlbRwJATbjI8M/llwwcqvlTRxMfdUGpr9F9Q/lUX2Z54UNp9YRQm6vFYAqrs+5/c3QK29pFTyPXKFM5qKsL7LPBm/Be4vKozUhP0uG+Y3st5zUF5OSz+pd4Sv0T+C8ZdtWcP0Q0nGN4+goOjP6z+HRTChr07wGHvumCkLFQminfXv8CF+HerNw1aVwqhimHqFBE5Zp08vUp0g4kB89UjUfxJZvm9/jor3VUHoGcEe6AIEW4aaLy/xL8hGCdMlKdXSOyisLf0tKvoGLihbpe/wTsJkSvxdThbE5f5vydnbG+0Wxq0s3jflg3IhX+HDacxyOuLgD+kI4cOEEwMdjIF2FbTe+qVHiKg3ToySd2dC+Ob3NcWBBN79B/VIptuci+4jsZQRedS/R+rK5ulxwMVIuPEjvCGjrfBOwP81XNQQtcraQEQlX59DqXkod8LGAXSfHnkwg6DKwLEZNbdQ72RYLkDm2FOLZYZQWjeTp5ry8YXZje51GTv+f2hrkJFwPTOhWwxpw407WXtA560uk095IDZqqSeiHA/Nwk58GJK3ENXoSZkXXTZWYNxuf6kA7io16Jydt69DRqAu2W8VZjofEIEB0Fn5hPwBvIUUCDHKXCwh+L4cGom58XRKxuPMwQwFkWw4UmmOV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(376002)(366004)(39860400002)(6486002)(478600001)(316002)(38100700002)(82960400001)(6916009)(86362001)(6506007)(6666004)(6512007)(36916002)(26005)(41300700001)(44832011)(2906002)(8676002)(66946007)(66476007)(4326008)(66556008)(5660300002)(8936002)(4744005)(83380400001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?34YGlu4n5MGf2EWIVkCPNkShyUmpIf1P3eXIzSgsfHG1lXBUVdZdzYAgR6Fn?=
 =?us-ascii?Q?r3ev+R+5ijNP9GOFDbwQeFUqcq89nic14YmQyB0MWqokTRfXF7txON9VP8pJ?=
 =?us-ascii?Q?TkVskuPUHHSGJQgDRbd9974wE+2qUit0PEg+AJaCNEofDwx4APF6xcMEj+UI?=
 =?us-ascii?Q?ZHdiARLfz95nv1YjPozbUTeODmTKjZxVmclFnL2uhWRONlsL0cOOJ8e9hyCc?=
 =?us-ascii?Q?EpRE8sinHT380RZYtsmPkY5ll+iAVUD96nrxDDC+wNSARZGe9v3oj8uSjgtZ?=
 =?us-ascii?Q?jbpZCl1tdk3Zp+2vxlgPPv/t6bbgX5IVY/jiwwRA5flTCUCTycZh7PcUp5ac?=
 =?us-ascii?Q?bKm8A6Nm5VzgcP7rWv2tusp7KDn/Yw/bAJqo+yZEcoK9Q/wAShkRV8j7oZq5?=
 =?us-ascii?Q?iVX+m84HxU3qmL0FtwcQ95qo4ok0IJyjU5GBJrRN9eckwn1OZ5xpsn5PP47K?=
 =?us-ascii?Q?gR11tXs9xPTewuTAObuIpQVXDDUW3AkrPtc1NZ5T1cpmZVXEYixs8S+aoXO1?=
 =?us-ascii?Q?Y38YAsgh8/f8LzbOP6/Pj8pRWQ2uUGD2NBpJucE/ZDuz0pEhMvFZVV6HbVfS?=
 =?us-ascii?Q?EfG4PCFVR5lf9OAgIhZ6sUSVsSVbGASqPnbRMH62JOtlBs87PaeMCqvfCVA4?=
 =?us-ascii?Q?loTSev3jQ9KxCq4fGjpmm5QTc/PaEGD8pt04JgXp4QDykpGxseIho79JHfP3?=
 =?us-ascii?Q?RxJQ+1IQFKyHeySi0lMUVHE8RTcweDIAD0WY9mEfdKrIy2Q25qebBvhvuovG?=
 =?us-ascii?Q?pOFJOJPAT+ZAxRok5BINoTTj9mwcGeNrPw0QvhAbaOaXCyOE9Zoaljwid5CT?=
 =?us-ascii?Q?oCkEvMedqAsNx1o/z23KO8S37ELHtzD46172Vc8BXkRPVLMLOwYxou/S6Fn4?=
 =?us-ascii?Q?I8kD3DjzrFaUeEKiO45J0ZiDyDDo3QYqipmn/ACO1UDUSykl29OM5AIGpzA5?=
 =?us-ascii?Q?d1R/XVttXOy0CQJLVhx21OafvvLBZRXCQ13iVjJD+avjo14QdNEhl31Wufvj?=
 =?us-ascii?Q?H9VndmTjl8jkpspdnRvg6eG0gY1jVLlWEoMD/nk2oHFQfsiQUVzd8TKCOjbR?=
 =?us-ascii?Q?n2vfXX3+iQ9DeLitjtQoddz/By2POJndcLmUpD77653+zI9zGHD2KIlKs4Fx?=
 =?us-ascii?Q?GaNN9FI6uXkOxYS9WY5FGA/R7T39A/MJg1HCNet7c92bwGDHMbjPGM0vFM0S?=
 =?us-ascii?Q?4Fe9tRHM1tDsm4BqP6qpyOVvsh2ivf7NQUpZgV/+2oFyYS5irj5aZ5OkoDTe?=
 =?us-ascii?Q?W8MIa8qigvF+bLGzdJuJiBUNX19TOpto6fc2Y1lhEJKSf0EuK1jXM5ZgMmXp?=
 =?us-ascii?Q?NRre5144dN2NvwRh+VOczqrcqAz5DV32+E3oB6Db1AJyOCZO/nDMVUiCA6EU?=
 =?us-ascii?Q?PH2+mh6et/mG3q7wMzdp3UGj6ytoRW6IIpahjkqJ8Aukqr/1MU8efpKrb3w2?=
 =?us-ascii?Q?QBSNwCz/NJRJydq8+lH58Uz5hflDDgV9GQyMRRBoYip+T81uCVvdXZs7x1xC?=
 =?us-ascii?Q?Cz5hTlif5HqEe/e8Bv1gu4Nm1En5ZRuB/KJTMPwHy+AI9AfmYer5H1AG5nMp?=
 =?us-ascii?Q?JVFYGR4qxC7ifuQStklgNJqOqnzhQQST0Ix6Ilz7POtoj0Ed1Y6kTwjCdlZm?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc7ed3d-0145-4b65-b351-08da90b8be95
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 10:07:17.3147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvm5sEOcgGu/z+yxLYDBrdQFFv4IxBCyeTCElsPw/lC5ZXiTA4jiqhyVm20dq7UPzkMsIQlF/DPGXVi3RDI9gPcNlTkH0Igwuw7aBjTDubk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3944
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 07, 2022 at 03:42:58PM +0800, Herbert Xu wrote:
> Hi:
> 
> The function qat_rsa_enc maps req->phy_in with a length of 8 bytes,
> but the function qat_rsa_cb unmaps it with a length of 64 bytes.
> 
> This causes the DMA API to generate warnings in debug mode.
Thanks Herbert.
I was aware of that. We have a set in review internally that fixes all
warnings reported when CONFIG_DMA_API_DEBUG=y is selected.

For this particular issue, e48767c17718 ("crypto: qat - reduce size of
mapped region") needs to be reverted. This revert is included in the set
that I'm going to send.

Regards,

-- 
Giovanni

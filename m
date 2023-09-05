Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597D7CA1000
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 16:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245169AbjIEQUb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354535AbjIEMYN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 08:24:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986D31A8;
        Tue,  5 Sep 2023 05:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693916649; x=1725452649;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vAPHZtY3qFfkOCO2RE7wpW+JADNDTop239ttxtKjWAc=;
  b=YhKhuw1dlbGjM0U+dODsDCvTgsB2xrzl6PB9lG1pi6TdFWaTR/6Ia8GE
   I8pHv4LHAP9hFnDFrVkkeFjF25y3701xgzPSZypYioaHMGRlvBxqwr4em
   rpMAoonLtaNUz5hBGz2ypMwBWQ8lDadtjQeJitdtpxyb9eWquaSkr7e8y
   RhEyRYGj80SfX6feOAYXVBY6vNe0FD1DrDmeps2I+b/0MNoymnXGWI7xF
   104SPeXLLFRpZEX5XU3rU9mhWFXkr+e3md0cOGaPKtfR2UQ496jgcNGtq
   9cTLX/0bpVTvlfYj3dcT5xxN3uKhZ7Vs6etEBLyFNToYJ50PAoO1benx6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="463149449"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="463149449"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 05:24:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="987809736"
X-IronPort-AV: E=Sophos;i="6.02,229,1688454000"; 
   d="scan'208";a="987809736"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2023 05:24:09 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 5 Sep 2023 05:24:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 5 Sep 2023 05:24:08 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 5 Sep 2023 05:24:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwTFeyMeEzVdGX9Nmh3sYJiJoYPFzgKmlgIcdp+HBHLSgnpLMi/6NSdRjUwwGCuYL2USy9xLbqSEqRfBYNbz1nYdEhhz79wuFqA8gb3tiLA30UnMBoah89iIG/cyH2fUTvklHAnSJLAwmCHUOAj4O1aiSKDMz7MRib+L4ulxJOQ7HQpvDB32aqjqBIYbI38Tw4ZgYVG1AKtSt/Ob1ZL5dNorfNfmQMuPEeJx2Bd2/a6g/TxmN1bMnBohE22jjOLHctO0zffoKHcL00WUp8S63tKhDL+Eyp3kavfWzHO12zn2XI/oGHGSrFInrEX9xr/svHqiRC+MHQDKfXV0MmIplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iw7222Lb2pTibpLHXq4qoXH+l4bIXhwUUtZWJ1ns7TE=;
 b=PAfODt6B6UhrQz8OTpEeD64p8M6ObHdDkUJfvW3tNiDLSQ+k3wVblRzvW0So7RaYZsDp6U2jYIfHXL/TM2O9GVyvEupB4dLeAiSyr/a+WAwTPgwT/KDbiJjAnnw1F7WVvlXPEvqS7RgwEh0gP69T7kBDbHCsns1FcclnzpOehfCT2QObr7ayN2kuPLwtb9HgZZ6PmwZVS0aN/VNnxePgGhXi+NBZ1AV5buaYIEG4g/T1cEfdO+WWmMQjY9eoTldqS7+44J7RyBCIJC0Kv5md1LTSC1Yy7vt+nowolltngJnYSoA53PmblvEDGsduRQNbyMRp2t9xnzM5mZmD7X37ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CO1PR11MB4898.namprd11.prod.outlook.com (2603:10b6:303:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 12:24:01 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%6]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 12:24:01 +0000
Date:   Tue, 5 Sep 2023 13:23:55 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     qat-linux <qat-linux@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Bug in rsa-pkcs1pad in 6.1 and 5.15
Message-ID: <ZPcd243+28VCFJHz@gcabiddu-mobl1.ger.corp.intel.com>
References: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZPcFyp4jdE3uSeqW@gcabiddu-mobl1.ger.corp.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB8PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:10:be::49) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CO1PR11MB4898:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ad0ab08-8f99-489d-833f-08dbae0afca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Esb5jrRbelKWjf8gji8dmGMDFVjm62n4XZ+EVxLPfWHcSYQNL3xscDZVeb4VWkjRkOEMD6RPvg1zD1vgDwImjEar/1NZofkaCzFUBQmO7EhCXZmfAe80aS+WBY6RS17byDJVMbg3g1NSiMJf74/fFMa/MhV3erHGW8EFrqDBRTpMuFVsPCnH1b9/i25Ob/jQLs62NcN6sHYijQBFe+Qg8yKIAoC4u9fTceYhTadm0azLiwas5OF1y9qEDgY1Ydm/loM/gmteSRdDrH5NE4aCv7Xe25xAmlbbW1QVresiLJ3u/HB1YO/YQhrFhEv2XcZtVvFXWUfDh/qE4G6PvTt/7A9zve5P8TAGwWuUePHRtC6k9wB/Vbwr5OvSeSwydRXOd4CdByVQSwUyVaN27qxq7MEXDo0sVDBlYm6pOy+wYx4zK/+13uF4yYYGru2aFW8aZOIzpftZ05zpgFCeUnZJ6Hv4M/OvwffhTLm72fo2NrS2zQrd32gbSqv+Hb98yBwqeUfOTjr9/2MNiVsrVgO85csvaaUIdsxn5RLEaZjc/yQV1G7qnerUiwpU3LmaT+8e7fWSmCcIB5CPQwzogoE3zjiV/wdsaUqE15KaCRm9ppQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(376002)(366004)(39860400002)(1800799009)(186009)(451199024)(26005)(5660300002)(8676002)(4326008)(8936002)(2906002)(4744005)(83380400001)(86362001)(82960400001)(38100700002)(44832011)(6506007)(6486002)(36916002)(6666004)(110136005)(66946007)(66556008)(54906003)(66476007)(478600001)(6512007)(41300700001)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jzvLkEBbL4fP5l0CEnNa5o3QsnQlpNvDzKDquqW5EBRgAZGnh/DasKVOyO0g?=
 =?us-ascii?Q?w4bvDcR3HmcNSXeEYo1QcZhhumwRzOsP5zO2QKJtgHV6TWZObMhlUypfdwpr?=
 =?us-ascii?Q?oZEIqM/GCdNvNoGtubkV5OKq5Ye/EUHIurLsLOzsifXk3DjxkcZUD3JUDuDr?=
 =?us-ascii?Q?PsnTVlT0G6XjtiK7XZiHHCoE7wN4p6Vh3VboEQtQDJe4F3HCbcfp6xfumVdS?=
 =?us-ascii?Q?tzk82yTWAAaDvVc3wqVzBcT+sA06wfJFiTI5zfZXQAbv7Kskc8HmpaJ7jHin?=
 =?us-ascii?Q?FnGWp7bHe4WVE3XwqdLLy0O1/FvyK+b0a/C202AjB991qig+R63KbVs+cz+n?=
 =?us-ascii?Q?clI5PvgUE6Rb29nYslkohhyVos2H6dxNDS+hguognKgG08g8Eu+ofpXpDYCZ?=
 =?us-ascii?Q?t+LBzVoMM7sZexlJcxJUJfnyhaAi0JLiWRD1zybH6nA1XrmB+v6VYSWJA16R?=
 =?us-ascii?Q?AUXo5BNAvHlhnYmkpPPPvwBGDDw5Zyh2FemhOQVq+/cZQ07gpnZH6JNQXbpl?=
 =?us-ascii?Q?J0/8WlSEwfmKfnsbYsw7+3llX1jYz60Vg/vX5neQO9J4k9zy4E1XixF61jVN?=
 =?us-ascii?Q?AK7KLG/7HS0FiUWt6nB78oEaDd671HNGmplBSTtpBsHiZgO3jlV6E7yXfjUv?=
 =?us-ascii?Q?+DlvxjKVLCHVS6jz/i1pSdPxY220l0n5tzCdUNwMm3hKcna9kftl6ZW8XYwj?=
 =?us-ascii?Q?8/AKUTPBPAgE9217RdLXIFN2wtQDxU7f9STNacYX9s4uDWODk9RcTza0/Pn4?=
 =?us-ascii?Q?1jwJTiaHh8lRZBngJV/3XLL+ASoMKGL5QvslOXr4+U4XWKtHgyUm/ZWKvuxC?=
 =?us-ascii?Q?DKXa+I1VKuSbug5HwPPivkPOw2KcqONtXQGQZ7XFQ22xtjgJUjmwHqY2tT5B?=
 =?us-ascii?Q?s35G8ZpD0/7mcQv0rrZmcAL50A9d7kLL8oaLxAY68oXbx5ak9ZtyE1kMaDM7?=
 =?us-ascii?Q?+7kf797U5PYRXPje7U+TAe35EPRjsW1TNXVmyiVQjS3Ubj/mDb8IM/Z4CxN2?=
 =?us-ascii?Q?vOypywinmkzMDxAtQyeDl0NBxch/G8WqYlEYYy7FMLH9SCr7ZVw3DC+Z1EAA?=
 =?us-ascii?Q?7bAr3OcAApqEzse2/rbjYg4yxQNLQ2pMHxOvCaTI6dyYHH0jAi61fLlYSVn8?=
 =?us-ascii?Q?CqckP/+/eAgOKw8iC5aS+EoUQhUBWmoOhxkyKK2tpreY/yNBUxWnnPa2KJIZ?=
 =?us-ascii?Q?ScV1+nlwK/x84OAcc+GqYFta56uEhRv+obGY1Xh8n3TsNP53JoSUhAcdBdJX?=
 =?us-ascii?Q?KsATc4HjZQjTXHRwN1n8KURQrrR/fCrsSC7hK5/NF/qYi9uibtZKSvAKMCIa?=
 =?us-ascii?Q?WR1wcwVduNkrAGqJH4+VjSFaPYBLTQuAkkc4efALIobkvAWRC1FwyCHNlbeq?=
 =?us-ascii?Q?FqivhpRkCEgVZrGMUpNSZiYhtRi0Vr4Fa6on1K/zl81RWFeyTyII/hvqm5Tq?=
 =?us-ascii?Q?DNkIne4UjcmSUZTuMB0XMTdsny7ZIYYM26vr2vI+V4SiDeUR9XYahY2kH5Tc?=
 =?us-ascii?Q?gDoZj9NufXuAUKB6gbzEuEvszsWrp7ipE00p1Ad4UIFy4tNj+eb/cC+IVwKU?=
 =?us-ascii?Q?hrgBV/bAVdeoRrmL/Jm6uN8k49eiIsdC2AmQ8zHo3XMqpBmuu3SXEW6lQsDt?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad0ab08-8f99-489d-833f-08dbae0afca4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 12:24:01.5806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjgM4nHtDast3tlF7Ph9xatQB5Ny9A71RU/yWaQaW0S3WFFZfVTdPN4z2kvZBsqbu4YP+uRPxov11dQ4d2hJ2cBZOlaczOnsVnV29KCts+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4898
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 05, 2023 at 11:41:24AM +0100, Cabiddu, Giovanni wrote:
> This issue occurs only when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not
> set.
Apologies, there was a mistake in my previous email.
The issue occurs only when CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y, i.e.
the crypto selt-test is disabled.

Regards,

-- 
Giovanni

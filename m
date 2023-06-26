Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C1EEB64D7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jun 2023 11:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjFZLbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjFZLbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2023 07:31:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F7410D
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jun 2023 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687779092; x=1719315092;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7UgugnRkj4T5jOHWnPIs3U0a+1ZKX2C/CiqpBeuzjCc=;
  b=WCTHRqMUvQu81yV3v2rJ6cpjfibkJMVTZdICyicOTBVVikA4zABxP0Wk
   MI4ztAJBnPvDX32Es321NeG2IIZuVYciYN0zLxt6BSHftcGdBRCPEAXQf
   FEctQ8iH6Us0lyMubjRsRuTI0zGd6bMx5oKutGqERXBVNx8Dasl2GNcui
   OSGacjJHo01pjKNIF0Y90G8uTGhhc4Z7bZ7DjgYJmGeK5gqVweGlKHHQi
   m00Fk889RKNhE+WK2nGYGyiH2rJ5PkgsRYuGOKr6kPDvCSHxJgErRXfBc
   UOGhHAxgFlLtb7qyTSbkavlf3tZRkBM+VC/9ZlslLawf8xnyJjM+0VX67
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="364693712"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="364693712"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 04:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="781398430"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="781398430"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jun 2023 04:31:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 04:31:30 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 04:31:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 04:31:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 04:31:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPECctw47rjTF5XchF0sNpd7Sa8CPhl91uaXZyk2nFkCRU6BYA0FC/LIhnn+YQXSEV03d7njk9B2+aD9BCUmtoGLrEaN+OFs0nBCggV/E6P5HlBiGKfwO/Mmy+1pWYjutG5eK5wMJbvrvIBsiZL83uH7g+afLENnLxJa1AHHW5Cky4WnbeksVMMXR6ZsrFJYOMbJPpd6g1dki0hx4R22lS92TECIWZHFAZ53k1CqqmwlnUj8Ux1GtyKHS/hze0Bg8Qfb5n98aetSVCao7U8GWA9NRRwk/ghylunWI7whSok/NJYMvyRqPC/8uG8HJKihRRBjDz4u6JmwDg7U9tZYYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2QV1KgaPtV2bDgP1rsulT4DxR+oTU/EAc5rIGpRyXk=;
 b=aba0OQ84th6cdejvFGcPdGDaLGOOGV+XnEoEeIWf/aCPFJdcgL3UD7Jk/9Y+7lclw5dg8mDoUhXOlIb8OSSDe/zSYRpKBw6XGoOdpYX7te2yzzbMS5SbAuFtd5DVrQADTnZIG59fIMJnqL7xpp7Pr+CF8oaTUb6E62pV6cm5ugyf9JCUvsfNnxiE4CVpwaSUXXSaJdedc0VyWUvfM3/I9vH+IQt3o2hyhlQWkw1FaFKq3hE6XHIkXsfgbSb1dcEmpU4AWj6M9KUU4scQgaaM6b1e0lzdwhl4DnLQmSNphNNKkIfc6oi90/BfHEKXX69sbxZ6KwbN8kdFhfcjEeEk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB5375.namprd11.prod.outlook.com (2603:10b6:5:396::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 11:31:27 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 11:31:27 +0000
Date:   Mon, 26 Jun 2023 12:31:22 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>
CC:     Damian Muszynski <damian.muszynski@intel.com>,
        <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH v3 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZJl3Cv1aI2tBRU+F@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
 <ZJSSmE9nDZXKwPd0@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJSSmE9nDZXKwPd0@smile.fi.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB3PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:8::20)
 To CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: bc6f8533-041f-4adf-189a-08db7638e133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUQ+HJzNQ1GFQJLBFqokhRkTKIKIKnwWl5zm/Jy4pj4C4QXf2KcBq6Oolae49GGtGO2Oynl97lVHo7hwaUMTpTjZ09BAG7E0iusH90arxBDu8LDR1iZa1CLPuW/WLFYOlRy6uhIF6530voZ/DPCs7f/OiQo1z2hInmHjN+vfC5fmOjFMsyF09zwarl0JWhh0xtEf2w1kY5aiEMF/FJQK+IxGcttfLP5Z4CeG/X2RXgXapr183l5E8BPGz8Hv+CIKhaEwT5UFGyOpl057nEMsu7XlsIX5FFCtZc8zWYTLX8pYIOAiqJVYYi+HKe8d3h7xf0+IhCxeWG9UvLl3YNw64kzPsKfRg3Ks0mkX/+Dx7I5eonDfrtM7GxFmAob/b/G//4Oc3L8zX8JOMzWX3HiXTcSFRjl3QclyBEiSYVqD/e0MPj8dgGTrWt6dXP+SyooSllwV+afQrnswPROFqJFfYouuuZdKCl9rrbAFZB2REolFrSU9Z8HvhJohGWND7IFeD8Mu5A49uhgURfjXuWsBxgtzK3tYmXTbCEk7WUFCd32ZK+U23qMI2OvFTC0bVv3b1xpepJDYmAk0O374+FJoVKAwW21OGqISI3aOo2zEmEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199021)(82960400001)(38100700002)(83380400001)(86362001)(478600001)(6486002)(36916002)(6666004)(41300700001)(66476007)(66556008)(66946007)(316002)(8676002)(8936002)(26005)(4326008)(6506007)(6512007)(186003)(2906002)(44832011)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U/9oADcKMdTgmdFmwfOSDdXSfMiOTGeWTYw/A7FBy3lG05E2EsDBIxRzJ5uf?=
 =?us-ascii?Q?IsRWnL4gT0dVx6gr67B5QxSXdNLkaTmBLxeA9Xp9W0bmuQ9FUXgPCzP8QksS?=
 =?us-ascii?Q?Te7E0zQKJQQxf/+oTrvoTluSKcC3QZCP5peeEGjtsG/x8t+0rSSOyU1U+ek3?=
 =?us-ascii?Q?ixgnuvuuzUbvBk/uUFNg97boZqY8tz0+0UVUbvUQb8NXbQ33B7T3zoNmsih6?=
 =?us-ascii?Q?1M1Ho/9UDbNrcdU6b3hDxcOcILyAev+iGZiF+7Xfo252PFkGa6OTVxfvZhw4?=
 =?us-ascii?Q?4V2Zxzgl9lteigt8IXAoSssEKAcuVJziUeNLVHDNZsi130eFmyuOrgCR8IKH?=
 =?us-ascii?Q?LoQ8eSlAGdpvTgD630nYyXG3ts1S4pQFxH3rbzUPGtczsK5EEaTraeXXUrOJ?=
 =?us-ascii?Q?Fb2OIwxCiqPlR2nJ7Wqd/z0uthvFm2F5+e54WOmrYFvQG70JmdFy5Pr8JX+z?=
 =?us-ascii?Q?WQvRdjUNH/7ZV5/z43cBR6tHSR5xFYI7PuLXYqweBFaSW8sw0YLnVhXCB1HS?=
 =?us-ascii?Q?0R/9W3nyaxio3jaYDcBcUsDjex66JXpjDqIts9ESv0OQsOVTlh5eudjgrDyg?=
 =?us-ascii?Q?go8MFPvqww8leXgf01QkQu3BUPcPqMGbugcyM+G4lQyXaIuxfqF8GysZv6GA?=
 =?us-ascii?Q?epCjPmiQkeEF0n1X/A7SE10/IXaUq9W8ERmea7M248qVjSZbZJ+7qzd56mt9?=
 =?us-ascii?Q?yz7shiyiMxVLBTOobGcONYoBjOetZZ9Vm5markbR450N9tdOTDAlOXBiKBTi?=
 =?us-ascii?Q?+yprkuFZnB1+sRkGaAJlE5zGwONJpdY/MjdEysSFyOFZI8o14jeIl22S73aS?=
 =?us-ascii?Q?kGfxg0vsDWSqzOdrEJyznVO2DExwlHb7URTl20f2f7Kwe/2g1FNFmwVp08Y+?=
 =?us-ascii?Q?B8MSo2lLpPbRBO102TVliYT7ESSKK/ujVb68SsVjy7+9jZlAyRF4UIISQpdn?=
 =?us-ascii?Q?mrcGDcaNw8QLe2mGQdtXQ7k8rRYECanjvWw4lhlfevDSN8/3KV26DA7DKP3S?=
 =?us-ascii?Q?2b8AOFiJ56vxyyMlzDEuqzKQeOE0jUojafB53BF0vggCoMjqM0fvPbn41ab3?=
 =?us-ascii?Q?HCoSEYr6SbJfX3Krc+O3xnVr7wyVCr3nX0VNNliyiq11QB0xd7Xkdr19BMVo?=
 =?us-ascii?Q?CFASNIu5WW/khUzHz3yFJVvbNFMCDf8I/rB4ZVLE3nx5t/uzDpx5Xgdie267?=
 =?us-ascii?Q?7SCR4h5C09BwqmTraxwTA8sJgWarzCESd+MMvaSn6pt0PH68XoOCB9euVd91?=
 =?us-ascii?Q?gWMoejMwz1BIx/zuY3krRkzxI2xlbwU+/o8Qs3OWlksMaklEMPXL3jgzsCBS?=
 =?us-ascii?Q?XWC4Zv994Qq6IOdYslqqCTXMbOmIvnjs9x3U5+f7kcMKiwXu6O/fsrG6XeDs?=
 =?us-ascii?Q?7zaJ9wDrStQ5HsHJjkGV7g36FrXV26ZZMv5iBlayYBZsrFRbIthOhjTOrw4d?=
 =?us-ascii?Q?lY8hcqAMJRCh8tViVweCs3HM28+pOb1DY88F5sMeOCZyi7ds4RNXUf1DxkVP?=
 =?us-ascii?Q?C2w+9D/APm+fprnIirtvxgSBeZ6qw0eVhGeMdDuaBezyeMYc3ubvrqfY19IE?=
 =?us-ascii?Q?druwcEy9UsSsapF7Z2MLrMyWunhYVSmFHfL8UcCKGb7aavlGVo6q1190tFjk?=
 =?us-ascii?Q?6w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6f8533-041f-4adf-189a-08db7638e133
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 11:31:27.2957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lu6Ge/t0N5V4ssFeoFoK0aiLxmuTtoAnWhMpaG5BweWmYZLzK5aTqTA+efVh4kk8Y7cxSb611ErffLCAAHval53AB21Mu/gvm5zpWeaslTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5375
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 22, 2023 at 09:27:36PM +0300, Andy Shevchenko wrote:
> On Thu, Jun 22, 2023 at 08:04:01PM +0200, Damian Muszynski wrote:
> > This set introduces support for the QAT heartbeat feature. It allows
> > detection whenever device firmware or acceleration unit will hang.
> > We're adding this feature to allow our clients having a tool with
> > they could verify if all of the Quick Assist hardware resources are
> > healthy and operational.
> > 
> > QAT device firmware periodically writes counters to a specified physical
> > memory location. A pair of counters per thread is incremented at
> > the start and end of the main processing loop within the firmware.
> > Checking for Heartbeat consists of checking the validity of the pair
> > of counter values for each thread. Stagnant counters indicate
> > a firmware hang.
> > 
> > The first patch adds timestamp synchronization to the firmware.
> > The second patch removes historical and never used HB definitions.
> > Patch no. 3 is implementing the hardware clock frequency measuring
> > interface.
> > The fourth introduces the main heartbeat implementation with the debugfs
> > interface.
> > The last patch implements an algorithm that allows the code to detect
> > which version of heartbeat API is used at the currently loaded firmware.
> 
> I made a few last minute nit-picks, feel free to ignore them if it's okay
> with the maintainers.
Thanks.

Herbert, If you decide to include this in the PR for 6.5 we will send a
patch on top to clarify the comment.
Otherwise, we will resend the set including also a version update
(6.5->6.6) in the Documentation.

Regards,

-- 
Giovanni

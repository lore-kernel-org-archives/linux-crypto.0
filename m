Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 420EAEB64DA
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 14:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjFSOqs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jun 2023 10:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjFSOqr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2023 10:46:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E18173E
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 07:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687185984; x=1718721984;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7/Gv5mTxmIWMRFVvX3IZZp3Kd4lO2PODLkNM5OtID3g=;
  b=GdPHUTnwtLr82p8PZQqSporfHGm7s+MGrxi+D6p+R5oSJuDt2WXH6xZS
   a2KfC+afXjfe26cs+SjP4ywHhWANMvnleGRKflJpFDBj0lGyyeksEZ7Xb
   E43Z7LUZwidqmOOiVaPozGUskilDwpF4Eia8kT5E6a6yxCXpsRt+AjJWj
   WSOIkJ/1wii+zEorHgMUSzIWmtgwBKjdAL75Cn7iKfChirvABxN1vAZKG
   Tdz0M63kqrJDdjz+Z2zfYTvROEjXUw+lwzElJeVk/cah85FPfn83/UdNY
   0GnqbHunQk9LeCIUyQhAnsyDY6wnHBNfBHIDBj1JO7vXLPq3+c62xdJrm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="357137474"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="357137474"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:46:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="1043921228"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="1043921228"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2023 07:46:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 07:46:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 07:46:22 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 07:46:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 07:46:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRoiYY5HjHvBTd0bJXovuLoiiZ6q1jG2GbhA1/1KGYebZ31dhWC3ZSkIQbYfAzbhFmQWxF8bLupi2mXnqVfCpkL9N1WodLiikC71OfFHJd/QE2rKe+XwkVjsoNKkc8s6VT+I+uY3CcC0Ge1tqqhlUPIDHFLdtjk88RhZhwN6IK8U+vif5WjQe1K2DNJTAFNeVpe20q7qEe2xfeyUOcjlwKm92csCNb4whe91KduwpJ8z+1B4k0Li8YH0AWEeo6nxy2B75PeGej96VnIHdyxuIDcbr0Y6Q7x9Vpd/BXJqsCgnV0XkUWSCh7Y1IPDb5k2bJJspvqVX6BU530yzx4yo3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uY6AAxmh00UCvYgD/j+i2zWrtdVnmYAj2XP1Td0Quug=;
 b=YmhYrj0PZkI9X9qFjDtUQkKmb3KJCZm9NDL5mdkgm6WTL3s+B09hn/oZox5HZvKa3kdgMpvYG5FR/p705GYoris97EgDcwCTFWoUxGYIC7MU+RecxmvCUBgtbPnil150UOnISL/q4/9h6kje1oca7RVd8udnoGYbvxUQul8SRBD4ONuJVjK8kqCQr9toYfIsilmTfF1OHzR1ZWxWv8tAruzG5WsxTyHkZhILN67wvoC91B4oH/NOwg7lFw26s1LPC260ZeWyMh5KxWV5e9cjZBpHDSvcsPgNWOoOQHCQy7mqzSAebe173MkLjt1xQlI/IpObPFZ7KYVyUfZdLRDcxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA1PR11MB6345.namprd11.prod.outlook.com (2603:10b6:208:38b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 14:46:20 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6477.028; Mon, 19 Jun 2023
 14:46:20 +0000
Date:   Mon, 19 Jun 2023 15:46:12 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Damian Muszynski <damian.muszynski@intel.com>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 0/4] crypto: qat - add heartbeat feature
Message-ID: <ZJBqNHXy1PmKpiNz@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230615090437.436796-1-damian.muszynski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230615090437.436796-1-damian.muszynski@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0411.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::20) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA1PR11MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 7175bb63-d5ef-4f38-7193-08db70d3f15d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ueFUVN9KzkEbIjx/GA7Fu8CkhJluXrHz5pTu7B1inZ6Goc/ZqcPo0yFUgW9q5C+7F+I/lDQWuLxC/Y0KHnkfZRlnjlw7/FRlQIJpX/goGUt9Qof1hTZpvPi+cP1T/5Vc8ChsM1V1ZRmWuzSjIXQgHHUwva9gcJM9llSue2RPz3A83uX2gReKI1AqgVW5+16ooqaZl429bhdrMS7mGODXwmdRVWr6KWIpxkCKcaFims94pWNDurkuP3TGldlS5bM0F68bhzd6hqxDav/qaZoDI5SOoZYCAuN1nQLSk5hMrqYE/rEnuLdxVUARoR2FQy1l53jcrTz7LmFiDJJrpubvZVFAWlCDe82RMKxC8E2rsKh4TphFXOroGm3SSHMhaZtw2rOpKP0HqOxNqs0MS2+L4Du8Dp9nKBuLNqE2Id83s8N7XPC1XycDj0GZTai0+A/jsqRRa8SYDflxxzODSFSbRmDMxM/0l/kg+UbzWkM+J0NCyE1EQbjUUgDnVYbxFTZYFQRzH0hDsY7krRToi1JhQpM++/igXuHaXgMIq0j3Xgh0x7ywIEZ5pObln1ext8y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199021)(2906002)(478600001)(44832011)(5660300002)(41300700001)(4326008)(6636002)(66946007)(66556008)(66476007)(316002)(186003)(6666004)(6486002)(8936002)(8676002)(6862004)(6506007)(6512007)(26005)(83380400001)(38100700002)(82960400001)(36916002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qTuQh8MhAXi93UOyX1L3JIbKmvfv4VpB9k5C7SYSiZ2fcQX6yPkeaP2etWVG?=
 =?us-ascii?Q?pSKKEcr2HVe5FD3oqKc087eSHTBUGSbGRWDY1NfVTWnjQbGBEX1n2HKQJzvi?=
 =?us-ascii?Q?+cElFHiBJydmM1pqxw4KbdGw4zhyBvi0K7xSst+05bjY7TP5W0sUMgmw0O/l?=
 =?us-ascii?Q?4ftIfcFgs1RXjWXHFMWU0jlptJq0K8guak19VcGnaNXmDbNTnFZgLMURRLtG?=
 =?us-ascii?Q?cXleYYseHnQxoNkjXLVAnjH0K4+/wDgu80AKnCRxB5MbLQfYeI4Gc6GHHlrt?=
 =?us-ascii?Q?nkt1mn0tMyrhVbMxcMWsxWlX93aPWE4/QlG/LovU1HBhf/i1wVb+ZuJd9gyZ?=
 =?us-ascii?Q?c0B2TreQ6jE4+g6mnG3XzNNpIsxKSm7Dt/T8rY6tu4oumSQHgcCLcZ0h+Jg3?=
 =?us-ascii?Q?9PTL2tx34Xs/7U+lbQZhqYppveKjxg6mhkKesdV6P4MGNZEss8WiEDs67f3t?=
 =?us-ascii?Q?xXm8TmsTm0vskkv6WNKRqjB500kvvktTMTxlxO53yFGEbN09tHt5CwKb/VH7?=
 =?us-ascii?Q?c2uInvMv8tjFwC6AhJJe8jJiD9vAZVhw0y1FXuJqgsRfuVe/+I3FxwMGStWx?=
 =?us-ascii?Q?aL/4StlvShwVt8zhESDTcSmdiRfalEQovrXgQwCdYxFJiBo5jC4BqKP1kOmz?=
 =?us-ascii?Q?5T0XHQ5qGg3FBY+OJrVDvd56c8M8Rj2WVr1EkKGRHx/+Umej3HsdGYuWSJNS?=
 =?us-ascii?Q?sJsRJfY08ui99pgZya5TxWj7gvwnxdmKIuKyhSHPGKz+hU/SwBeBA1hIXjt7?=
 =?us-ascii?Q?Q6qcwvJUWpJXEkQFRk2MDk8ofmqOm6hb69525Zn5UmaHVvCmr7ivOmYK/9zB?=
 =?us-ascii?Q?1XMeUWp6kfRRrHmt8z3dvVugkSpTIuoNd1aLisaiF/AMz7TeEFYlng/xoNvg?=
 =?us-ascii?Q?Ib+YNaMB3YnBkD0A9iaRTHKan3blZfLH9BE5jX0oARnfnYAEbQrVjGJ2WrzO?=
 =?us-ascii?Q?j78lLYe8nmjkTsD051URl3JLdZOVEseLwPn58oKMFU0DMzsIH8WHxTnmcIq3?=
 =?us-ascii?Q?WM3HIKeTWB/Cy0bXJ2bTy6uiq9o6vzhFyXhuAGMtsG7ui5kACyylsMxe/by+?=
 =?us-ascii?Q?w35Yzdepm207BDwPrG6/atEAnvxpSIthmTUvExrpMOv9t1E3jW6rgdlwxtmB?=
 =?us-ascii?Q?xljyLuwFPaOgzK055HLN7ei2IFq/jUnXJGnHxOT8I8miI8rE7J3kaFYJVgFT?=
 =?us-ascii?Q?sxNSsyjtH7rCpUDaHJ74tAeqTFZlQoWQkXedjk47qcYInvoOspYDlBfz20Di?=
 =?us-ascii?Q?5cq3Vch7sP4xy/M0f+iAcBDrqkn1z/Af7r2w2uGiB12IoLxoRZqyGutFIXys?=
 =?us-ascii?Q?hn4WTpFKvLsmj4PczpNhGdopFvjYpRtz6SygN0hxw0NS412pp0U5aDvw0U4q?=
 =?us-ascii?Q?U6KmNK2v5vXfU8pmI6b+may6wseKvtNPMY8pPznTdq+6Ad9l9QdFDIfcxg3J?=
 =?us-ascii?Q?f0PxN22cHn1a45OD0BZB3dgvcRGZi3dMvLyJsIesuGFefRVMFdPDzpU1cebk?=
 =?us-ascii?Q?Yla49jVK+Hgdq2JKwRrSy9qW7yeZA/vcerDBV5EzP/RQ2sKuEcVELDR1WWrC?=
 =?us-ascii?Q?XK0temOMM7b1uV0hza8tjOTuTy8DXgtzBDkIP14P4ATivNEtfN5RuxbZ6vVo?=
 =?us-ascii?Q?dQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7175bb63-d5ef-4f38-7193-08db70d3f15d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:46:19.5829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N415NwA2L/W1In1pOMLLKvZfymKv4sCTGWqliIP7Vni+3P1eFLYYsJSAokvg5YJY+Y8O6JMpAR7kxTS5dXfVCWkHq+LJ4/eADXoypMsVCOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6345
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Jun 15, 2023 at 11:04:33AM +0200, Damian Muszynski wrote:
> This set introduces support for the QAT heartbeat feature. It allows
> detection whenever device firmware or acceleration unit will hang.
> We're adding this feature to allow our clients having a tool with
> they could verify if all of the Quick Assist hardware resources are
> healthy and operational.
> 
> QAT device firmware periodically writes counters to a specified physical
> memory location. A pair of counters per thread is incremented at
> the start and end of the main processing loop within the firmware.
> Checking for Heartbeat consists of checking the validity of the pair
> of counter values for each thread. Stagnant counters indicate
> a firmware hang.
> 
> The first patch removes historical and never used HB definitions.
> Patch no. 2 is implementing the hardware clock frequency measuring
> interface.
> The third introduces the main heartbeat implementation with the debugfs
> interface.
> The last patch implements an algorithm that allows the code to detect
> which version of heartbeat API is used at the currently loaded firmware.
> 
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
This set introduces a build failure with clang.
Ignore it. We are going to send a new version.

>> ld.lld: error: undefined symbol: __aeabi_ldivmod
>>> referenced by adf_clock.c:29
>>> (drivers/crypto/intel/qat/qat_common/adf_clock.c:29)
>>>               drivers/crypto/intel/qat/qat_common/adf_clock.o:(adf_clock_get_current_time)
>>>               in archive vmlinux.a
>>> referenced by adf_clock.c:24
>> (drivers/crypto/intel/qat/qat_common/adf_clock.c:24)

Regards,

-- 
Giovanni

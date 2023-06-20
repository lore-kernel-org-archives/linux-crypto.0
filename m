Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A843EB64D7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 12:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjFTMRH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 08:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjFTMRG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 08:17:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF48C6
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 05:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687263425; x=1718799425;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rX7euRRxLFDmKeaFOB5gDLqbdV320UDRj7YAYSy6AU4=;
  b=VRKRJFN3zDx9fFAK8aVd/xG8VY6O5926uZQgAJn3u28BEdsCJEz6ce8J
   gTqlg35GJRMu9bN03zPETQdd2kK3DSmRDRzKV7xxa8uBj6ahrZ/uP2enS
   LGiVytAWRk74K//5zfslczxiWvVFO/VUSUNiKy3Y6NCBBHLOjXf/LYMMX
   8wo6lT1s5ejSbRw+jyIKteviePThLZsjOcwie1HPp1sHhzzvkm8cQH28/
   yzO90gVu/FtGli0p/CTX/wenoMEuNiYi0HNWERFqJH0gduBpIPyHBcTlJ
   i93zEauwBkZISbrRK7NSuf7OeSSKPZDDLtVKrIzB08cgjQp0oCswy3/oY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="389080440"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="389080440"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 05:17:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="803933962"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="803933962"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2023 05:17:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 05:17:00 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 05:16:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 05:16:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 05:16:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihU/E7vLB12VmujNVAiU8pEsJg3cd5EJxVEsL2rbd9vdn/Hi+Q9DR72lnMDA9SkIKxgyECSCwmmX6fUoAulc7Oan7WDz3ygRQoQGumyZKBGd0bCcE8WG33pXPa9RFepV3oX4yJasLe/8X8lC+h4MVFMelXnmpN570PnDO/zAb72DtuAm5Va8Tzso6ZMbvkSS/vY+vM8kgdwHbA/lDNiQSAo+DXxT1+pDkVhfnKs3NfHCjEAcFpuVM3A7JvPx+CadZFDO+RQd4Qsilht6sxVpJaeDl/DWtpShUydiG0i0GdbyM6QFAFs5G+bx2L1+JAQUO9a5YfrOeIOyAMV+jk2cNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mls+yad6IdTXmS343KnKtiGvc9ImpFZY4VFwk0J1Y3Y=;
 b=ZOSzvuCcPEZ2prM9M2+lRlWDiCMNIRIVhaV+hcujfDlwLqOKNABnZHwy8bokrjkwyB8fiYpvx7xeaY/spjjG3crLgTf6GNW/e0S+rQm7DMOy637xfcf2PkKFA1vu3XpIs9Z6Zu98B6C39Cm2hzCBuFeIKQ9I7KmqRnmkQ0Glgd6fpSGVZ9H7tepgAciSo3Z4EXn1NNvM35ZbG/luNbqSdJ9fYkex7m2r0WeieCwcCmVhF6p6rf/wrn9zBdYXpAfZlPe5RpgvhnJJswaXh4N96SPS1TXkoBR/a/tXD+HYPW0tlav+z3r+DZncMwu5FrH6iwVi41V4YDgDv8/9zH7ltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM8PR11MB5703.namprd11.prod.outlook.com (2603:10b6:8:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 12:16:57 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6477.028; Tue, 20 Jun 2023
 12:16:57 +0000
Date:   Tue, 20 Jun 2023 13:16:44 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>
Subject: Re: [PATCH] crypto: qat - remove idle_filter setting
Message-ID: <ZJGYrOHDA3rH82Z0@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230613102923.109818-1-lucas.segarra.fernandez@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230613102923.109818-1-lucas.segarra.fernandez@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO2P265CA0211.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::31) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM8PR11MB5703:EE_
X-MS-Office365-Filtering-Correlation-Id: f6954583-e416-46e0-0a91-08db71883e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMTmUHGp/xKxB+M/VHy70d9N90UIk+WysEM3f7nSfYjYGTJ8owNb+8JsCy2rFSNr5VpHXbA1oiaXILIG1bEX/hzrxgeNq+UIhTcOmGVyoivf/cs19sa8rPUi7uJAjPWNOVZTHzRsk4aAqU90dATijTbkU3cAQaQxvgE3gdVhEK/WvQ5Z3YUSX4N/3CCnyz3+FfaessIpwBVoBwku1lXrNUKeMsC3pwGSGurN9xoOVKdCRV0P1y6wZF5HEjQJaHsn24WXU/gsr+49GV+m/hJ7p85/v3sNmd2PlP5LPAnIKd295kCPRGebeANe1WHYpGC8gXstB/QQeO5jAWj0ojKkyZ6Vgx+h9EWzqalqoAbuVS9B1/VSTgHEc6J4Fjg/MfO8My7btaktDS7lNZGdFolAcrhWj0hxLxzvAa2q5bOZmFUYlgDVYoqDovx0rp7YxX1PXlKE/JVjvn7JXHsw7HKrZbO+E63q2foGh2p/ec5I9DZJDyZgpkOCeMWy2NzUs86RdbJ5UoNAiAXOS9w03UUO9AzqyLXxjR6vxSyGsaykB67/T63G03rWhmRdZCiT5dQy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199021)(107886003)(6486002)(478600001)(36916002)(6666004)(83380400001)(6506007)(6512007)(26005)(186003)(2906002)(4744005)(5660300002)(44832011)(38100700002)(66946007)(82960400001)(4326008)(316002)(8936002)(8676002)(41300700001)(86362001)(66476007)(6916009)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GbovEKSUzCseb551250PHt/6KqWRnCjAFaaBZypz6+UnWoIdcdmLTFQxf/y2?=
 =?us-ascii?Q?WlMde6uktIWQZeUCEcnrfOvz/GxJejGEuHHcmE4zkFBaeRULESQH/xlC95FU?=
 =?us-ascii?Q?XXwMPkqiEterhVHejp0xcowqvNQ07Q1Q+5wxT7RBVkKZX/6m5Pd7cgyZibZO?=
 =?us-ascii?Q?+ABGRuU80fPQjpxoN1L8IT3Pw5zv8MPfgkbZ9FrhC3HJXXRwE2IEYDrFDwrI?=
 =?us-ascii?Q?u5Un646lVkD+ElkJMT5FhU0eruZFxY8Q3oeQRANcaKws81YVE8f8CgV8EtyA?=
 =?us-ascii?Q?JtMB4adSYos7P6xSE9mFRaufSrdF55KsU4rsw0AC4wLLmU+UC32gt4xooWzV?=
 =?us-ascii?Q?wU5wSnsaVaui+vPXfAvxUme2pKQOnQYJNLS3VM2VCb9lCp0RCOmD+fbux1mO?=
 =?us-ascii?Q?+n87vxQJwG2101BhEngllmy7pbz5CAZ8XKPn3u+PW8vX6O9by9fA+51G8znx?=
 =?us-ascii?Q?qNl59hoFVwfB+x+0bisUkpFztY7+fbr5dJGoP05lmLanxcB82eeD8iMxPjVY?=
 =?us-ascii?Q?23Vy6+Ljof+Gdin8bbg5jjISN9EqMkPmhCD4qR2RMsFlHrAovAARZMwfX0xX?=
 =?us-ascii?Q?A3dIKhCtp+/bGIlWYaihS44KVb6P92vYg1HO/CJAfOxMs5fh19KYMM7LNbkh?=
 =?us-ascii?Q?yoG9pMUfCIGTkFQXbcWjsxqxed2zGX/YlGdSW6FI3w4DZ1diPixMacI8D4Kb?=
 =?us-ascii?Q?Qz7NU6vm+Dmgvi8tGAEXNWBv3VV/FNOcsTTkZ9/wjm9iZNOLRwivr6s9C/eq?=
 =?us-ascii?Q?uT83kS/dkdaGqyFUxOy2dhApw1l4RX+E1Lq3yZbjBsKHqp0ykR3blnIe+SeV?=
 =?us-ascii?Q?LtpbfnZRCBo+iPfVSNA5cJ1IsbLoYgB9CXxX57rnwdZUiPB+pvNGHL2sAidA?=
 =?us-ascii?Q?4PnjBheDxtPXmmY6VsYhgKo4CCpcmw+XNviQasNSXdD93S05AJIKKSfBPRJ6?=
 =?us-ascii?Q?wc14LHu67V2/qdlF8KfQrvOMx0gFNHzL6w5OTG29Tb/Ny/xciWAIfJ7Rb4CD?=
 =?us-ascii?Q?zntydXivArkSU1p5v2f9cu+RH8DEAhS8DDJspcMPUMPfZn3k0JIwlz0fzWm1?=
 =?us-ascii?Q?qJo72SrPmFu5M1aztUo/ovPRxhQe7YzAqZFXfKhhHGxr2ePpcSf/uYLO0Uwl?=
 =?us-ascii?Q?ASTjOz8OiJ9+nlF9Y72JAKi6qUIgkiG4pkpr7U5s2WwNlk9b6Awd/lqcKq38?=
 =?us-ascii?Q?6f8PbPlR1wD6v8b+u/+C4qcLR2V9DqUlq/CGPtz4wnryQOwnih3WZ9NK9mcp?=
 =?us-ascii?Q?M00oVRDjjTqujUQykWEzYLOy6vnMsxoiQdzTr7+jjhgwj3+3uun0uq6WJ30E?=
 =?us-ascii?Q?bRaJp+b4rnttoXK/035xEvL4tLOTnovhMma9YMoTCEeK5PT1g5W4gbIR68+I?=
 =?us-ascii?Q?oILxRkDinxZuRWLjb63sK86snhdl3QBMoqGvsGES8FUIM7gZazQFPLr7WoSV?=
 =?us-ascii?Q?8qHmdNwfCXVjhRwFxsl9thb8sedpdAZIB5pT2LMHOu5nmupZ3vmweK2Aq9z7?=
 =?us-ascii?Q?AEGuZC+qya7uIjb8SWDQpbjHzZ7Zx8NKsBUfx0292bKsQu0/LkgVB4xhnur+?=
 =?us-ascii?Q?E3BzfqN+WI+Jxcwx+hkuL0fedVOoMTDYyKdFSool4awDorLA+qOxrU9kratT?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6954583-e416-46e0-0a91-08db71883e0f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 12:16:57.4862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHeUueSFxoaGiLVv9kk1v5Er+vTlYHgUd3uUbi+7nzD/tXS0FVc5oTjDEtHrwq/W5xVeK0+36PIG+gChPU3EzJz1H47I08TyOmmBlbpXMoU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5703
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 13, 2023 at 12:29:23PM +0200, Lucas Segarra Fernandez wrote:
> The field `idle_filter` in the CPM_PM_FW_INIT CSR determines
> after how much time the device will be transition to a low power
> state if it is detected to be idle.
> 
> This value is managed by FW regardless of what SW sets.
> 
> Make the `idle_filter` field in the FW interface as reserved.
> 
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Herbert, ignore this as well.
We are going to send an updated version.

Thanks,

-- 
Giovanni

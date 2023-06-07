Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD91FC77B7A
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Jun 2023 07:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbjFGH7I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jun 2023 03:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbjFGH7H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2023 03:59:07 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5F5E79
        for <linux-crypto@vger.kernel.org>; Wed,  7 Jun 2023 00:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686124746; x=1717660746;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W1fDWjK6TDvtDbbj1Hbe3XDhG0Sm7sqtKYqULRonnOQ=;
  b=AiXY09QI0eKkqdKdh8ITpPOon4QrDXczAOso0ZDf+kbb3FBv0HaK8mKt
   XTZZ9bprcn97IpS55aCrL2X9Cb8bucHZ5tUYC/JH8sqagc8kyyFp6rIpN
   /I8ldVBeVG+KAof+Crv1PeFvyXOzuCAwBlhXE4hyfH33IhKexXQ0xlHW4
   dTCl6lE8eT290yyURB7z0B3LaPa+yaLT/MdVsIlQSAR1phGsruXTJLPDA
   iIhHsehtq7qgAvLnZbN2Wf90Ta6Krbmv+tJkPu01vqYW3gbf3VqKNG3Gb
   nTq0gz0sikrzhCfjXhzlv6hl/mflu583dExt/r3DRHZgcPjoEqQcNheGm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="355773804"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="355773804"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 00:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="853724890"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="853724890"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jun 2023 00:59:04 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 00:59:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 00:59:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 00:59:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yf8WuquM+Co6atr5JDWx0TN8uS7ZBZ5fqs20Fk+6W08yitvHoxLg33hL7cRQ+i4MoDgDjrR8V0eVEA7PpfTGiix0BV/kGmGFCYunKv29BX3LkxHQga3SqEuoiz8/FJRL01tVXiHHsGO9kGW+sHA6OXHEtF/sG7zMKtKodUYXjD0Ol7t04L6HxLmPv24gUaxz8bQ+rsApIh3dCpX4CRNUVFF385yocEP0PTCTldD1EQatDWg/JVD8plt0HFLKhJnXcGlGrvQn4cotw+3oQ/R+1/4T0AtJ4O8k8aahb8bSYi/wKI2Q7zPp43f9Ji7eNysQL8rQoNlwV1iRoMrH2hAamA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wcc73c/U0HV+CFWLKjYDdH4mEBIxZemK1R+eXd9M/BA=;
 b=ILa2t4VfTd1AnmgIpMJfqGTk9Xs/CfJTUUbRT3RaGx1pBT/f7Bkcb9NVqgXMvN01eUMsgOKgmFUJicCgqN22gT4/5b69DemtvUa+WFW4c/RQRD2ho9iKy4L0KGDWI0ovpdPHV57smB1gIJy1oxtzeGEIUFxsVlGJpMWScKXFLv+ojsY4siT63YZqVvkFUbvqhZvdK+O7t7QUzPzXZ8ler2PCU5Qr5UavElSrUtvKUEULNe3/sfrMRaLrqlIDBFlo05EoTSdGyeHMTCL/KZdx23d4B5P9z6vf65rjOILlLbVutXtfyPluCVLM7TxJPOpXV1pe3oQzjEqfQA8UGmsk+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by IA1PR11MB6073.namprd11.prod.outlook.com (2603:10b6:208:3d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 7 Jun
 2023 07:59:01 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 07:59:01 +0000
Date:   Wed, 7 Jun 2023 08:58:55 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>, Adam Guerin <adam.guerin@intel.com>
Subject: Re: [PATCH] crypto: qat - add fw_counters debugfs file
Message-ID: <ZIA4vyVMyIEbu5k6@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230601105907.132675-1-lucas.segarra.fernandez@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230601105907.132675-1-lucas.segarra.fernandez@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0296.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|IA1PR11MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d407587-b3a2-4399-5c02-08db672d0e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J42DGCXcvMO+R4KDvp/E9GNFGBBHioil0mPHjqbt7uJQi3aFleayTrGA/rbm5jzIdvfnhIU0i9EKtMrriGQemOqruVDcB4UBdBXd4xqFi/gbEub2zGwQhSRCAnRbztcwjYtlTWbOm6mpA4yVvAjesfhXSL2aWConWdLU7MwcmhpVbGqWB2tsgbCf/eo6AEiGoUf9cfhFzXHwAnrlyoMDBcWuiz8BpULJ8MXovyb8GqmIZtQUNJ5W0Y2jptP+NoCFXb01hy6ywF9QUEygPiSPSqi4npn3D9Z+0BEeRfHWmmqeWw3Th9Sa2maTwKpS0ejb5ipI721xRKPyAYLova2D1YEUSaJ0tQgl0QbOnXIakGFJzOEcVEtA9HxKSL3M2bGMIqlhZmrfkPfZGvgCmz+yYWcxEmb4CrADEEw8GM6ibmL9YI6VQF/hSnp+NG/CVAD70PZRl86/4xfVpRiNgSMF1e6gxVil9G6JtNJgZm6DfPLQ2Ep4BELoBTxYW/U4m2TjPs4vWLwoULxVFRQQJ7S7Z1/yfbm/EmkrIRcPfnh2BFxT0FjMTUWyaKw6hoXrwEk8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199021)(66476007)(4744005)(66556008)(2906002)(66946007)(8676002)(5660300002)(44832011)(4326008)(316002)(6636002)(6862004)(41300700001)(8936002)(6666004)(82960400001)(36916002)(6486002)(478600001)(107886003)(83380400001)(26005)(186003)(6506007)(6512007)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P6gokiZ+C+CU3axHkOfsXid8TXUbjiLU5KUbTcPRo6QTL72YT2kg9vxpdZZ/?=
 =?us-ascii?Q?FTZPpvvmeqekzHTzw/GvpiALYGwS6WJHHZPBqHNOp2VmAA2/LqNLRx/GEAzu?=
 =?us-ascii?Q?jdTQzs9Z597scEPJhfEx99w7ueLTp/BAJQmlit1dXhybOSkK10Criw0YKYyN?=
 =?us-ascii?Q?r7wrltO+BqvPUvFYXlOpwi9LgDMc5z32CSVSOidwpnlENZ18YQWWhLcWg4/R?=
 =?us-ascii?Q?FshPPmk0TUA4WgED2+8v9yovCZT8tktup/tfJxOntsser9ythOooKVFKOagN?=
 =?us-ascii?Q?u50GN2QmQyVweAqZZUUzkOSU96ED5ySsk2liRDXXy9kAkdt3giorMbZ1MDal?=
 =?us-ascii?Q?BsXLoPPvoxW4qtHtMoUNidQeSLJ1apKqPfHvkWGOgVLD/EuwKEwrC4HfCdWD?=
 =?us-ascii?Q?Ic79DEdBGKRrKvicqh1wmLw24tAm3Mvl8XYzfKKClwecRxW9QuM/DiEYw/rg?=
 =?us-ascii?Q?27BurSakXgG47hoNqRQW44Cde6PJ2rPpWAWuXajBaedai6JwyQHOZ4qPaKpW?=
 =?us-ascii?Q?gYdw0pXBTbc/oaukbhbgbQ7fApRUHkyUN7b482/X3O4txTnFN485fdYfN0pk?=
 =?us-ascii?Q?A0O2wQGp4DqUH04N8XP5WqqvCqF+LkCmoUe4mVnOHHkh4tVgsG07+hM8Ssri?=
 =?us-ascii?Q?nOnSf2vbvB5izeUFE5TFnPuqB7GiiZK1tYxT0GV5qFmufkS+CvRrZaiPf3SL?=
 =?us-ascii?Q?esQOXnonSz3ODeVEmm5Tyb0zvYudXlBeJ8ZdeU7B2pGVBmfh4L6retZFT0iX?=
 =?us-ascii?Q?gXna4+GLwFJmCB6E81vgM1iiACa6eVBY/XhLiGTXQ7snjA6XNM5M54r9fbln?=
 =?us-ascii?Q?ii17/VfUsE9m9NEdwFNfLMtRxKf21YNEHt9t30hkrZxQFD/VlrugID/pg9d2?=
 =?us-ascii?Q?g74HWfZhF4yrnOfGyWW+OevU+DFGnu5cea/9g6Zd/5hgwNXT3DgYGuosn6Rs?=
 =?us-ascii?Q?geUtCDszWNPqU/WILhu9elMtLAOPcvgIgiIZVEweNtbkC/zpM8yd/5YEvPcd?=
 =?us-ascii?Q?OeemUSZeWpUS5RQHDJt4qSD8ykHLMYwaP0gEbGhlPh8btewn23H8V+HG5dfM?=
 =?us-ascii?Q?FBZ8gabqDrrgNw1q2ZRDqTbiqH+0Zn5hFLSYRXS4AukTjGCGyfGL+lFEEN5C?=
 =?us-ascii?Q?WKsc6Oc1DTsgdyj/UyFMWDgWKhCie0xH9sS9Fa3SdCejFXRT35nHa2JB1NOJ?=
 =?us-ascii?Q?s/61jHTUPV8a0w06WptuHk+9wFnPIsjBqe4ccKYq0W+gNxmylxfznPA6qlvg?=
 =?us-ascii?Q?+O6uE4gJFsF+iZdMBgp66rOcVZa8uPA649DFB2JO9LignqgLHCA22zgHFfEt?=
 =?us-ascii?Q?aJGTO812uAHH9ueMvcQPoU1J/bX1UdybRLA0SEo914/1QS4nU65sXz7BJhz6?=
 =?us-ascii?Q?zOVvEm53D9UIp1Aucy147ntwdRSfXpuX70FVBA3extDEdoxKMuuXVcuIBqkf?=
 =?us-ascii?Q?Wdwu29P4upx8ZKWP3/Q78fWZ4psXAFsgxCRlGPompiIxrBms8S6IsUJKmXpO?=
 =?us-ascii?Q?BHb8cjCyLo9gmzWolR0r/4uPZSItLrCxSuyyMybeloCC2U3vH2W2lNnuRqIu?=
 =?us-ascii?Q?91k5CD/AX5hT4y22HILuSvWRxD850FmeH6OM8AP2f38baOFUReH+SI/slUL6?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d407587-b3a2-4399-5c02-08db672d0e56
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 07:59:01.5927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFDDVUMFxFfL8O8bo+cEN22Gi2zdflm3aX8g7eKt4Spawy59OBUUtdPOk1ked28G1nAUIH3dwCJnsLZoDSAM93ruBgXpYXxaksaoVRb2Zcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6073
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Thu, Jun 01, 2023 at 12:59:07PM +0200, Lucas Segarra Fernandez wrote:
> Expose FW counters statistics by providing the "fw_counters" file
> under debugfs. Currently the statistics include the number of
> requests sent to the FW and the number of responses received
> from the FW for each Acceleration Engine, for all the QAT product
> line.
> 
> This patch is based on earlier work done by Marco Chiappero.
> 
> Co-developed-by: Adam Guerin <adam.guerin@intel.com>
> Signed-off-by: Adam Guerin <adam.guerin@intel.com>
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
Ignore this patch. There will be a V2 soon.

Regards,

-- 
Giovanni

Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72E7C83F2E
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 16:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbjHaQsD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjHaQsD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 12:48:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FB8124
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693500479; x=1725036479;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zQaYqguNnv9m2a6WN+sY8rYmMZnlakU0nPKMNVG6IwU=;
  b=PrKIBsYoz08Wirksj8YhfqRACncX8dHBktQ8e2XYpt2ofGgvrP26X13V
   mZHrRGbzvIa8n8vsXWvbpWlBGHIpWXhjb/MNk3Cnz50Wxs996MNP3oemJ
   MpSYPIXDJgDj+rlL3zOdGFczmlZwDRZcg11whYo05J0kAmo0dSJHo3/IF
   kX77VdUKSyshHO8vga1Jr1yzZkmRZDgi6XuCbPryBSkgU1Wkjd5DFJiXu
   IXsaPKsSOyITVIgp6UM6OBZPB20KpHIdpsnmAv6qeQ65pEyIZt89Fxkmj
   IRBjdbeb8yrFTi5on13SHC6Ksl0A5r/1+PfJhRSdE4LMX62qOQ1pYN2pb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="442393395"
X-IronPort-AV: E=Sophos;i="6.02,217,1688454000"; 
   d="scan'208";a="442393395"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 09:47:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="913359057"
X-IronPort-AV: E=Sophos;i="6.02,217,1688454000"; 
   d="scan'208";a="913359057"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Aug 2023 09:47:58 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 09:47:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 31 Aug 2023 09:47:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 31 Aug 2023 09:47:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 31 Aug 2023 09:47:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIgFv78cI4u11RMkszhdMXbj9lEV45IsW1bYEIKQcm7VeECS3B8D3sdMhzvcYSR3yaZE3Dyif+RN0Bj+IrdnxI6hRcBRQWcsGoCR2Z1FguP/JVRsxce5E0FjiIidSV3/G9FHo1IleK9hB9SFDIJugdb3kfqjFqTM9U3WPRU9gipKJJI3ble6/Co2+Q37Lp9+zuYPcasiqHQoMR+7Kttolbsno2NPjDuHIECho0IRpxK8RBoFdQFF3AX5IbzjTbtY+nLUGs5YnN6+LMQMvjlre/yNznkJW4vbYsPnrPWRcCoc+YM+ksHVI+o3YgPZWQyE+stYfcYe1HoODdjhEFqOyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTWphan5ZrPljvZkeL7+/anuI9y5ctTz/IFIV89Lo/0=;
 b=dofq87DFQ77ig65W1Za5ktAHekquHhsp20PkaA5LVJ/aNzCTUZ3v7d0fj8Piu3OXPX/SQIKwdqT+19ttN3if0OCq+WU8N1Jrqb/6XckI5NWb4so/K77snh2rnyK5ymJLUMawSnLMUdPwxWdAtBjUCiLHlujzfTV9vFNNqiN9UqFXbGU3CpGNZMr278nD+XqknzO42yY3nMMbwayXWh2XMxAVADoYYlgYCGKJn3jPtLi4tIRHt2pW2cvy6e76/IVW+hYGRD1aJo/Z2XJsCLpFAwMZfjaQuyl4d1+7t/qecLg8tGsluwK//GNJ64bcQwtjD9AIfjeAcsvaVjQJ79TM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by DM4PR11MB6237.namprd11.prod.outlook.com (2603:10b6:8:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.18; Thu, 31 Aug
 2023 16:47:56 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::f8a8:855c:2d19:9ac1%6]) with mapi id 15.20.6699.035; Thu, 31 Aug 2023
 16:47:56 +0000
Date:   Thu, 31 Aug 2023 17:47:49 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Jinjie Ruan <ruanjinjie@huawei.com>, <qat-linux@intel.com>,
        <linux-crypto@vger.kernel.org>, <damian.muszynski@intel.com>,
        <shashank.gupta@intel.com>, <tom.zanussi@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -next] crypto: qat - Use list_for_each_entry() helper
Message-ID: <ZPDENa0eem5zVNHH@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230830075451.293379-1-ruanjinjie@huawei.com>
 <ZPCY1EEFz0opLpvo@smile.fi.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZPCY1EEFz0opLpvo@smile.fi.intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DB7PR03CA0076.eurprd03.prod.outlook.com
 (2603:10a6:10:72::17) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|DM4PR11MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: b46ee266-e87d-43b2-d2e6-08dbaa42068b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTXlESKf2pevHxCpRKHKtFo+2Ha6d2JET7CmFgjSdCg1uMhcXplQ+llyYz/3CvIZ0pfNTK/3CuZwM8nnWN3uA2Kx48qiWviwDqFHrQPMVG8uIfS3hmu6K+eWwmMUCyIF3YsBapsD0S7cc6U6HHrOoik9sLvGi7wQXrcTfeZICMLzMAQFdZANDgvZlTk1w6xu+0X4hnU40jUVKet8a6l3mKns+xgbzkLYu/ilCovMg121nXlENXJpiWFBrmvCfJMQlWbSXSomkrb0DLtInjzsWjiZkIG/0CQPuTPzemYIEkkdzgXM3/Ke4ij64Pzq96xwKRsZi6RHn1hygtfunO5WmQTAuPz8AR55J0xmzs1bFoqQoOYKOq2Zt4EzGaBZAq/ouJgjSpsbtZlvx1r7+GF0KSe8+8miVOEyaWcUDrLuGDYGug/Y0i5Fds0khk4f9mgxLGf7ymSnKBSN05YViMtGGCiAcBNyqoCEG8L1c44utMmOchSdOH4oCcxUStydvpTEnzF48Wd8OfjmPYO74N+xt6CQSHK0PX+Ui5wTC+Qrwviqi9IQ+zMq8AbIqEBnYDD7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199024)(186009)(1800799009)(4744005)(2906002)(54906003)(66556008)(66476007)(8676002)(6916009)(66946007)(316002)(41300700001)(44832011)(4326008)(8936002)(5660300002)(6506007)(36916002)(6486002)(38100700002)(6512007)(86362001)(82960400001)(478600001)(26005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RbMb/r/zZM4jsdMtwMs6k4wp9uhVpfrzKc32rqEV7cFO0O2MY/kPOTvZ5fGy?=
 =?us-ascii?Q?KRbsZS/QY9B9UedlJfE25PU2t0Fr6juRbgho0ZQi22qDP85DqmZdf5D/lwno?=
 =?us-ascii?Q?0YeEpRPdZihTybAIKDgckc2USudf1TT4/Uq8ck3/KFAGTwSSPl8EV0oaJeGa?=
 =?us-ascii?Q?JWzLI0KRMeiHFVYUBk1VF5Whct2v76IR5Lgy0fAdpHjyQTyqZbsIMb0DDiQW?=
 =?us-ascii?Q?9CF69A4rt0K6qs8wo4ZUuNcBfTW2lAK/vXn1PssSNEQxwXeq9Qu6Yj5cqcAA?=
 =?us-ascii?Q?Ev2zS/ABs/X1yOz3+9C6gd4zYEzv7qYRxC3VMIjxG98PC8T4ifVRmOpfgkld?=
 =?us-ascii?Q?cERdATLRBzhUOv3bZ9WlYmkC+p2Zh6EZIoWpEtdKYwlbp5/7JapOq4I3/74E?=
 =?us-ascii?Q?erKArUta5D7YQkVU3xjmPYUFldfOq26crnmZSquagnO4/vLTY3CIp5oD/2Zk?=
 =?us-ascii?Q?P9kUsSHK8jNIgUxCuVVPpMCLSlxJelrrDPctcC0sZLsGSonitsDvEd7IjUS0?=
 =?us-ascii?Q?+Rl6ZNl522CB4cWI2JpOBVhCRRNK0EaW2evSI0PDjSm7LFGlO2vw0sr617Gb?=
 =?us-ascii?Q?Bb/4nd+swkS/pu5z5p61All4Pg/dtayYtJRXL7mTlK993boIu6zDK/Wga8DH?=
 =?us-ascii?Q?s2p+VwQMYFFh6XXsKQLRW4aLGR1Dk5RmFI+7dkimF1KpF/ZO9WUvZuQQWtaW?=
 =?us-ascii?Q?RJQ/DcYkAXf+sfWV75ApHVqwHqlcBZVzw7a6h5VjFHVR++iiU/j4/FG53ktS?=
 =?us-ascii?Q?tr3kbF9hR+fXwGg8Rx2rB+LPHBRZHPemqfuf/T81y8d7RjeEfMfEhEmMNvL9?=
 =?us-ascii?Q?6swDh556bDBFnop/ZvQ1nreLZdcWvlt480eqTXTpsVAwtkt8alnuNkHg+cGR?=
 =?us-ascii?Q?fwIP9a9y2i9Q46hrDgJNNH1zc7yTx3wZfVdGyiEFxIt42ifF1Ulkac+DVx6Y?=
 =?us-ascii?Q?yXRstfC2EH+TbqSfq23eddnZ28kBt/JJdaplu3r5pRJUvcV3ka3aJK0N7rDP?=
 =?us-ascii?Q?G/90J3Cw9u9quWNfuEj1D8UHLG1eggNpPYS0/lcc5fZi8W2rMc5VHjIEFibi?=
 =?us-ascii?Q?QQ2HWjzt0r81HISh3Cnc2Rgzu09OZbobsa5dNSd3nunv9a0DJFnu7JBbPD6g?=
 =?us-ascii?Q?LYfQf3D+kinu/Ci4b5xYS6pe6IM7GagmBbir+qHtelYNdB/6UgZJOTrIT6ZY?=
 =?us-ascii?Q?nQaOtnzu2SgHL7BRRmiwiwNmXvqFV+QxIaHFbIPCF8Deg+9hMxYYMix+npu3?=
 =?us-ascii?Q?vwsYc3NPMgCtemgtGl1XOIUPOtNl+wa8cyAE8XLweu4x2Zewl6yXXlwvhkrD?=
 =?us-ascii?Q?FzJ50lDZ+ECFC6NAAFSyQH0Joja7MD7c+BI4+reSbkN5Te9Uq5Gre1i1xnom?=
 =?us-ascii?Q?wOsZHZLp0r+c7MyVZVVQc6R/R9BaUAbhdaoo/kJuCVMtzHDOWHB3yWYcR75B?=
 =?us-ascii?Q?zj+7qoyj04HNMlWgejE38vDbUmtYlmdTXNd30tcL3siqbz5dO8rTn21wP3yV?=
 =?us-ascii?Q?+3SfXOuYBE9UX8ce8zAQN+W5mHKh13jBK0SRb49MuCzl7E5MEZCIVJbRG/Oi?=
 =?us-ascii?Q?DjtaaWNsUsyMHddThsvp4qyT5dVLKXe+bMYezx5fgQj4ul5+Ja320cOQhAWt?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b46ee266-e87d-43b2-d2e6-08dbaa42068b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 16:47:56.0652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBkpV2WfJLtEBkqZkaDyOsIA7l77OHbACZfxob9/Tx8PYIgoXUeN13yDGMKf/XuqmU1FrV2lsK83s8rk63fW1TmtnPHATPB1qqkldZGlBGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6237
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 31, 2023 at 04:42:44PM +0300, Andy Shevchenko wrote:
> On Wed, Aug 30, 2023 at 03:54:51PM +0800, Jinjie Ruan wrote:
> > Convert list_for_each() to list_for_each_entry() so that the list_itr
> > list_head pointer and list_entry() call are no longer needed, which
> > can reduce a few lines of code. No functional changed.
> 
> Seems correct to me, assumed that this has been tested,
Seems correct also to me. I also tried it and it works.

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

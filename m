Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27F8EB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jun 2023 14:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjFSOye (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jun 2023 10:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjFSOyb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2023 10:54:31 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0689CE78
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2023 07:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687186467; x=1718722467;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KEXprsmzpH2X0ZjcibHwkmFuRQM4H0ZN7mKEVXKbQ3Y=;
  b=dAXpK+sJRbx19YsTeWE2c2J2rYZfiIvPMWcT2fw3EHMVmQFoFIhIWlmM
   4rOuJ+Pnd6zBq/NLCBvKAagmSpIJvhY8L4obIYgXFwUfdbem9zoK1sKx9
   33UYxe4jhtwHJcS08Bih7EoPx7mgopk4/Yl1b/PFEtlQYuHEfbl8o7t5H
   VRvJpzb8NIONq81uXGL0OZwuyh6bipv+zbRObEEpu27Bq2lJEg6Miunbc
   GeWzdO5TflamB7q8/59h2wGqElKVIKdJyW0ndFxwWHqCo7x6+xN1O5DrO
   +Y319qlTshkDZUOGkOErbRHGe5q0bZ7kPQ+AXyCGZsOhEBhNaDg8wBWMG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="423311935"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="423311935"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 07:54:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="837895770"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="837895770"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 19 Jun 2023 07:54:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 07:54:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 07:54:26 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 07:54:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyfzFx24B5qOTHYYdSj7p7FYntwAeImmjCY96uYlsUvvPnx5YF9CZn0QmtX5Ad8oszqV3lOFCqexfNJl0/r56RK9rkvOdaVbuqk2d7azkgna0YCDGgGpwqzQLA1EScJKG5n6xSofBjseIO0L9usiX5Kk7c1HHcGEbk6W2RIZgqImfiaT1YjoqKXWnu8QUmIlbKScV5aAIm3ayS0X4QKJDkMgl58eW1lOiW+Xd02S2IzfafPaPZQTrEPlfU2dJzqnVzrmPvm8b/1cAJ6K+NVxJ1D7vdigT7lHMcq1p+2U2RN+W65opjIV0ijC6Ta+kGaxHIHsC67UKT6syPKjkjZusw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vq95jv413ta10LWnQ4ZuGZguUIna5I0EdhwneQ2eFBg=;
 b=QYekMho0K3iuQ0/Rj+CYrtCrLjbfYFAYcrgkAwY0VTwYQIEQlwz3Zf1VgiB61aT24yd3nFkAIWrpFxayBuKW9HyHvOFIFo0GjsoJLZeIQghwBR2XBt5D9c1lxhyCLOVqACeN5zEee4TB2ERuDX5229nUeNkur4y8XUtXv10fcWI6ZXJeG62d6OGpt9N4YkZltm8roWHM02Op3viYy/VowNzMZ8LvMdJVO9Xz3UISX8MUmpaACu1igiecAAQYYDOhVNbvM4IGDaz2nk6UBm0ISsclYHh+LauVigi36zWemStXCaE4+HdNgBrC28pGsLr4Ta9MUswLhu5X5rXyOA7tcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB7249.namprd11.prod.outlook.com (2603:10b6:610:146::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 14:54:24 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::955a:2397:1402:c329%3]) with mapi id 15.20.6477.028; Mon, 19 Jun 2023
 14:54:23 +0000
Date:   Mon, 19 Jun 2023 15:54:17 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>, Adam Guerin <adam.guerin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: qat - add fw_counters debugfs file
Message-ID: <ZJBsGZrHEVmTwsFX@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230612132631.96630-1-lucas.segarra.fernandez@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230612132631.96630-1-lucas.segarra.fernandez@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0484.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::21) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: f672c869-949d-4d3d-2754-08db70d511d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rMIUCz8R/LYRONgqAg1xBVZmC5S9ZW3D+7fDqbrFbD2sPh/pTVqFHAE7XpgnGsd2CrZmvPAVlzaOr26VRkxIpheH+e0EdY/GkiG0+fSaoKkBmHa3aUG/T7OTNUylUNL/ucH/zorwKQVaCe6YjsY7FA6KZ+bQrUZWYoSIbsWT57SOzdUpyeGMUkViDyNTw+YA1Qn0H7W4KatUXxqDl3O6RbojohMaW1eKcvARvo4zIpRGA6EWw4Ji69zxuMY6wItS7yoHRrr17x+XYK3PEAogIktHlYALMNXDIbjNne0s9wuwnLgIwbvlESc/h6mgXvcqMv0g+blWhCN6ckxCUzvfa+UAR+cpCYcCr0MHTe8t6cAHFnif8whws8sY8lSj4LBeizPmf+0IhJqDFZTd7tq1LPfQRvS0CBRSBv/GaOCP6NMbufJbpSVC6FfmiQHRaZdzI5b4PpnNn5d/OVo2B7BV74/AZy3srcjJ6P9cpcX6y1WPhchn6RBsYgt5pP2dgVaXcHnf8l+tEbkpH0xHZToVd5gBGSZFGxboMxOcEbaUmbqG5yV0p8TuxIIVBF7Wa24
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(186003)(6506007)(6512007)(26005)(6486002)(36916002)(6666004)(83380400001)(478600001)(54906003)(82960400001)(4326008)(66556008)(66946007)(66476007)(316002)(38100700002)(6916009)(41300700001)(44832011)(8676002)(8936002)(5660300002)(4744005)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gxm9Yfz8lhjzYn8Ud1T9YtGVuomHiBV7bf2lm0PH9iYU45mfXdAvIsnG+7ph?=
 =?us-ascii?Q?MrOHrEhRti+IjkxcRZEEOmSALzcGR34yN8FDcar4spPlmy9F6hcnZ2/0tDaW?=
 =?us-ascii?Q?pg4Zliv/8Z27njtdlBohsYXDlVVxo3hBq1n8nrplN9tesRZ9sD/N1Kc54b90?=
 =?us-ascii?Q?HlIE53EuMPdrjQx/EGJ6gEzdY4s/wW9Ztj5l+MTmnkretrBlaJk1TZptDaBy?=
 =?us-ascii?Q?bccadscso4NQYplX0oMN/fX/3D76yTpCUWhB6bYpt3a00zF7K0Gdp1nmwNqU?=
 =?us-ascii?Q?A3zDFl52mwmD8JITZtfdPlW94nhjLIbNsl+t0QlaQaW/RMnUKYNayulIoY5p?=
 =?us-ascii?Q?TYUeZ7KvL1WQ12YsXMSr3rsD5haD7LwRHe/dxY0nLzh9W62USgs936tqYP3f?=
 =?us-ascii?Q?6LnY29jHTgkd39bvij2tRQ++LCjVWYT+EunQimmBznzSTBr017iXgwYx+cO5?=
 =?us-ascii?Q?v4veHfHR/R4NJvVEAXEJRpUKa5YA5qOz6lWH/lziA6qsjS2f/mf1zKjbInHZ?=
 =?us-ascii?Q?Z05YCJmy33nx84n3rmySQU5VQu8jWgjwSqAI1rX3aQ4kWPndOLQ8y4v0y3QC?=
 =?us-ascii?Q?7Jt5uecF79dj6gdizzbbkVpNWQ9nvsOPUP249hbIU3kai7QEPdHl3Y/wUQM5?=
 =?us-ascii?Q?oMonJvP8Z6N8OrLgTOSuUgc3/O+8j2vLGmXeuts4gk9h+KSHihcmPQWZwHFf?=
 =?us-ascii?Q?lI/GO/la71YGrrKIkRyvkV0J1W1H/Yq4kA1dW9IiO2DsVcpn/HxKbQNJpI8D?=
 =?us-ascii?Q?X0Z1HYDEa5ufsGRyq/C9xKkktP3wYWidKlLiKukTO2ikswBS8bqzgineGmWw?=
 =?us-ascii?Q?zMyyuAtt4jK6A0xh2PkG5fGPsECXWNlquvz7hJW2Sw+9VOM8q26pCnITu8BR?=
 =?us-ascii?Q?+Ry8gsGmxW+12ZDtUsoy4sY94PAMVYRQGasNlb7jX30Pb6yqBbKRgfZCzzSd?=
 =?us-ascii?Q?7LoWxhp5hI495pfbXyjl8JXV5TsozL/A/J3b6ICpLFU/BV0MkcAkEnXwt0pe?=
 =?us-ascii?Q?ZWuofxBcH3jy8xuUBHgEnIKXVu5HyeigQ1NsU/zd8Q3YtYDc61TZBEJamGyM?=
 =?us-ascii?Q?uad7KiPNmH5JqKAo+M4euSFEC0QxkFG7PRbzM6FxedtNJU4BmEDMK8awreUa?=
 =?us-ascii?Q?yxgDrbQMaIpbHJ4W5hj1aOCU6DEdCFkKn+qLWKu2N8IjvFOoX5/fHUoGr6XW?=
 =?us-ascii?Q?5Ikv94WUZ03qEMjuRoHs4EMK8btgXy5ouGoGeJkb4g1Vrrq4A/lRsoRhjeWE?=
 =?us-ascii?Q?I0A0RzvwEdrPq8eSPJ8XQg/l8zagzKV9djo5Ur5PN+ZTE+e/ljvf8M071KsM?=
 =?us-ascii?Q?zu1t+OUfdMPmpt6hJjl400KqBXC+m1dwvdvSSDDC4fkDlimILir+ZHGQBViy?=
 =?us-ascii?Q?I108GkerWg9KBKTJlPNv9wcFJU5R9Diw63QQqOJpQAiUgWyRfNM4lX2npTUq?=
 =?us-ascii?Q?t2sK1p8oNf58G8TiXhRxqe+eWAkOktHctWy5xCZXtu+J8Y2Q030pHsAOaUOx?=
 =?us-ascii?Q?Q+xGP3YV5ZsRQbw03wj4DRuFMDIYoXhz3M5GbWabfiCbc9WQmX1qGbBlQ3aA?=
 =?us-ascii?Q?fdE5HkjGU73z6Nf6ZJSYtOMNpJracK0JZWl4hdPGUWlZJ5kKOCkC3QsmySXr?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f672c869-949d-4d3d-2754-08db70d511d4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:54:23.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnzEwCM/OuSObPte8VIm1VaRycPSSzABLyoeCn17K0KpwbkrxGyomwNcBHg9xEPymImMJAt2ap1kRMY5QkQWSOsqMoWc8ziLNh1otpWh22U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7249
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Mon, Jun 12, 2023 at 03:26:31PM +0200, Lucas Segarra Fernandez wrote:
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
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
This patch is rebased on top `crypto: qat - add internal timer for qat
4xxx` which was not applied.
I'm going to re-send it rebased on top of the last commit in your tree.

Regards,

-- 
Giovanni

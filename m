Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F60CC32771
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Sep 2022 09:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiIUJjG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Sep 2022 05:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiIUJjC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Sep 2022 05:39:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D14F923EA
        for <linux-crypto@vger.kernel.org>; Wed, 21 Sep 2022 02:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663753141; x=1695289141;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qjBVWw7iKVjQMxxSVUgL/utdP1VTNub9UxjpDyJGY1g=;
  b=lsF27juUghZbtGj0q1UuDwNgkOnb0qmQ9tjwQmB1i+JdD8aiuZlMGNiB
   ttQ/1BtIqi9hbSWFYXBCQxMDbAIgLOyH6kTQyO5ZxCCv2AjoL6xQ2h1Mi
   X8hBrAJ+09G5iITb05vhO2CYJu/U0hjmod+5brgug7yxDh+Ht1AyYOrwc
   tRR32yOVQFKGVmvdy5yUykPNINI3pdCo0OjBgTbjJ2QvFd0PIQADffpYc
   mA01If4jVNeaa7DJcMVI+76GnWOJd4biw0y6x+sTtGfBC8orHEGMY+R3a
   AEJWXhdiK4o516EDpZXk/OiPzG8LS4sA8hLie3MAJYDt5UirMYgKBoWB1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="298673314"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="298673314"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 02:38:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="649981354"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 21 Sep 2022 02:38:59 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 02:38:59 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 02:38:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 02:38:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 02:38:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT5nv1C5Iko7RAeEWosCACg6DCUO1qmb6/vVhqjMYC+0XSiLSTrtWX+w6yCk1wZMjZiKcI2+xdsbXNmmG0MLrzwaAsZ0EsMIOkpsLtCax7zomlTY6ohj1rt87Z8pbDF1CuG5l+FpSWI1+v2k7PFcyyE4enC+jBuNP8QAlPXxX2LKtynjIg3HDZvjFa3RK8ASikDLNsRqt/Xco6VnNWpjM9YmtaEgc3+PCStAAmwPG0KNGvhGb+9I1nxdsVqWeHzZ1Vc2Q8bTGHUM8LZQ+daK5sguxiFO6u9Y/RVCgORqUn5VenP0j/+wIGfeNq3eFVq0rU/SoQujvuPT/en8czf6Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHGUtYpOYwjLdelkQKZF2PWzJZ0MWvqDjGsdngOysSA=;
 b=QN3Y7wwJau3tN9ej0UgnvVTMeDvFLdSIUpy1kS2qA3NJOeDUB8VerP7J+qAZX2wi7yYWcNaXp43VVTn9w43GUlYMFk9r9crRJMy04aDI5DdPVgWiPo73ez9kg9Y+cYRLj+ll3KO92nP7d03zQR3ntONbICghsXoQyJpoaKYm3vGg9furDGcs4V/5xYcMukt/ef2gq4DGs3l1E18HpA+uji5fJgXxSY8t92WNeuvBHu1rFJ1W71HS4idN3i4TQEZb2jce5lDE9LvkCuT5YujYdsNyTygGaKDjii5UFTTlaOs8/VG7xm9PrjzkYGf2DyoOV96POzOhunXdPBm6EDYVdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SA1PR11MB6920.namprd11.prod.outlook.com (2603:10b6:806:2bb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Wed, 21 Sep
 2022 09:38:57 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::c431:f74d:4292:f2e0]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::c431:f74d:4292:f2e0%5]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 09:38:56 +0000
Date:   Wed, 21 Sep 2022 10:38:50 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     <herbert@gondor.apana.org.au>, Adam Guerin <adam.guerin@intel.com>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        Ciunas Bennett <ciunas.bennett@intel.com>
Subject: Re: [PATCH v2] crypto: qat - add limit to linked list parsing
Message-ID: <Yyrbqno1KF8T+oCg@gcabiddu-mobl1.ger.corp.intel.com>
References: <20220921090923.213968-1-adam.guerin@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220921090923.213968-1-adam.guerin@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::13) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SA1PR11MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c314200-bb29-48f7-048e-08da9bb51ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QUvSEfQ+VmQtH6viitAEMgVONzOX/AQUUKT9uCe3q7xzSBljAgEugw0C2DKmj9C/3tqRZt65LMbasy+bm+dclZlHs4DqAT91f+NkAk7o7ZpiYTTDLGN5smGcdJkzQ2yhSyyQdUUKmNByIAXRZLGGVaauGCSLa0MwjmjE0cp2AeXnrvsymYQ97a61BPB0bx37hVJ0/Tp7mY+PfyuGNW6mlQ58HJnzfOYgyuGRrbwqAKOThJgsOQ6uP7Mk8T9pIIVRMq5t6O00YmbVIILsYE+FW8UZslI0s5iRX1TjgFAwyxFYT6VLFoyBLCBNJ+4+QzA7EFL42kNG847ERP5yE3WW0xLmL2jhTkYq+3TMJHrDvTn13W+E8amSEu5hEMjIsWJs927fv6m5qCU2jQiVgkQajWXTVmvOE1qHB1ZSq7PsK5vSpO87TnCW+J3VWJm+EyN4KLEom29lJdFqaVMc3VsgPn8kNZW+kfAjOtyRxYYrrDsVhKBLv+Fjn0kEYb4WNTz1LgmbCpCqMgr0VxAyh4sox5uvfgbMua3BfkyUaBw9NqJAXQcBiJRg1cik72/NeJaI2OQ8A2CgKWQ5hHU6R7TpdwYuDn2nx7eePi/untTjJiSFZc0WUcBNq5c+grVIx/bpHO0F/SSLdmPG9oHP8HfUJH3c1k8iO+biVnlFv1s7iBcKEG8bSrqOzGCbjx1WuPawF3lOPqAI+S/tqALxc3Rg7VQ9nr+b3BfIRpn45ZsJN0lSb2FH10x76KES1YMMbju
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(6862004)(6506007)(107886003)(86362001)(6666004)(26005)(8936002)(36916002)(41300700001)(66476007)(66556008)(6486002)(478600001)(6636002)(66946007)(186003)(316002)(2906002)(6512007)(8676002)(4326008)(82960400001)(83380400001)(38100700002)(5660300002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C4G8Fn6fURoN8uY+LbzzsJA0KbadX7LLqvechlPuTy7Af56RXvgN8KODdTl1?=
 =?us-ascii?Q?5Pg1owtw0u7QxQS6/ja286JpmNLIPOXi5NmSbrDJ0ZvWo+ukKxvfLzd68YjV?=
 =?us-ascii?Q?YfdS5/5aywbQNCJIpPLz6uCWiag9iVGH0jesRBxRJqkTdF+tR/QSOPoS/l5J?=
 =?us-ascii?Q?xaX9gXYymUDSrt597DsbYvifDKCyvfpAEbz4EnEwENzh+LegAWnW5rqJBSta?=
 =?us-ascii?Q?uq5Gkx0Yn7DPczWdhPkJCTw9Ied8aJ88p9SxFIqdi+bv3iW/qgOF0yTLYjh0?=
 =?us-ascii?Q?5zkviAGsM120/nsknV3HmFVmREiHhm3eLNmbp9E3gYunS2G78kjhrRlwFddc?=
 =?us-ascii?Q?2K5MdM1SqHUiVuo6Bz4zncxCAe1EBRWyp8xxZhR0x/okUT6ks1YLPwS6I7Om?=
 =?us-ascii?Q?3/QRWsMEvirO/U7QDv5/gI7j60p8hCBH8zm1kpd4gYA1Ke1D7JI7Ur2iypQB?=
 =?us-ascii?Q?W0G7y3YQbQgyyAstJtrY1SJW9jWudHt2BIX7RjUf7KhHxkBc9vnMG6fcqJN6?=
 =?us-ascii?Q?x5sJdX8572sb75iLF+d/Jagwi4pLT8/G9hJmhH22l3OP7vX1Bs8ZJn4xMvxT?=
 =?us-ascii?Q?PzxrBV/5eH8zZPivnNh7Uc4M28yq4BgQ0cSe1WTUfqe0T3ErLV5JixfTr03J?=
 =?us-ascii?Q?51BMlLJLOL2btJAoSJl6iMGqi7aTb1Lo6oHELw6iS89cpKysrWsTxVvCvUFb?=
 =?us-ascii?Q?DZmioaf/KVVjas195kwPDzhTw8qt5JBAaQuIhYLKJC7j3uWDz6vhVDYp67Ad?=
 =?us-ascii?Q?1jBq3Mo4Ey4/qroDDGjl7R9CiLXYx6WEZ28W7Q+dba9TohPiq/46Bzd+OpkB?=
 =?us-ascii?Q?oLm0eYb5+lU4ag6zGNnr9cJWwNFxNb8ISjdhBtejeAA89gzOhVTiq9PbfZkh?=
 =?us-ascii?Q?cy9XYlGpAp4ytsoz6OP/pe0Ga1JJdZI3pYQh4hV9uMUcY3c3Ei2T1RsqLiOw?=
 =?us-ascii?Q?roWOY25m4kIotRFsAqlCywFejFon46q778FvT9Jt/SykmYmY0EL6dIvqII/1?=
 =?us-ascii?Q?Wmp6FZ0Y2dpIjYz95N8ht+1TgVjoOwA5t9nfh1HPsR4aDFisboG7c3PCs05R?=
 =?us-ascii?Q?FDzR6R96OaohejFV7Jk/zpnZ0BXQ3icH9WSzwi9L3pDG4nYIjq/KSKM6irTn?=
 =?us-ascii?Q?w2wDJK1oU656nnkCFyx7U8Z2dBXEYq67kbiTbITrg5gH5dyYyB7qw1PmVO0l?=
 =?us-ascii?Q?klM1n/BuYpg/ugdOBz/OUzxcK0P5ymzbZ5YCZklOm6VswGad9wsWtQp/3O78?=
 =?us-ascii?Q?BDj13+6gl647G1oxxWCRzkqJa9bhRytlcM5HpmNgAUZUlhdkwr/AIJf2j2Jz?=
 =?us-ascii?Q?WBniooqJCjQujt5u44FWo38Lwc4WvKgxm8LINcltnKexrCGSTqZqO4/OMUMg?=
 =?us-ascii?Q?Bo5f1AL8mj+ZGAlcwGTVW+/41gAFWB6JgDy/ciq4XzsQdiPDSWVfguNGOvFt?=
 =?us-ascii?Q?av9uAI/ezEWmN8UpR93FyiUSXBksGiw9XxiTp8i5SrKW7RsJdzFKq1IFFprV?=
 =?us-ascii?Q?sozH7FR/fPrZrE2a1ofjVOonRgMM5zsfDE/mafBu4l2I65coc5RKvgN1Th5E?=
 =?us-ascii?Q?bEPmqcZwWCV7JtmrgEgZWqzIXziSnlwwKDMm6I75ACBOIQYZoXE3XdU+yS10?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c314200-bb29-48f7-048e-08da9bb51ab4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 09:38:56.8718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +R/XQoG0LO4rMgs6bN99PasMDgk8yVZyKqCzk1HxtoVsGBj05gRMXVZSNc6CZgWJCpUMdKyFhgRN1Qv5iAAh0GT1i8i6RFPJ6RaQyTZlg04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6920
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

This patch was accidentally sent starting from V2. Adam is going to
resend.

Regards,

-- 
Giovanni

On Wed, Sep 21, 2022 at 10:09:24AM +0100, Adam Guerin wrote:
> adf_copy_key_value_data() copies data from userland to kernel, based on
> a linked link provided by userland. If userland provides a circular
> list (or just a very long one) then it would drive a long loop where
> allocation occurs in every loop. This could lead to low memory conditions.
> Adding a limit to stop endless loop.
> 
> Signed-off-by: Adam Guerin <adam.guerin@intel.com>
> Co-developed-by: Ciunas Bennett <ciunas.bennett@intel.com>
> Signed-off-by: Ciunas Bennett <ciunas.bennett@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
> v2: improved patch based off feedback from ML
> drivers/crypto/qat/qat_common/adf_ctl_drv.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> index 508c18edd692..82b69e1f725b 100644
> --- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> @@ -16,6 +16,9 @@
>  #include "adf_cfg_common.h"
>  #include "adf_cfg_user.h"
>  
> +#define ADF_CFG_MAX_SECTION 512
> +#define ADF_CFG_MAX_KEY_VAL 256
> +
>  #define DEVICE_NAME "qat_adf_ctl"
>  
>  static DEFINE_MUTEX(adf_ctl_lock);
> @@ -137,10 +140,11 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
>  	struct adf_user_cfg_key_val key_val;
>  	struct adf_user_cfg_key_val *params_head;
>  	struct adf_user_cfg_section section, *section_head;
> +	int i, j;
>  
>  	section_head = ctl_data->config_section;
>  
> -	while (section_head) {
> +	for (i = 0; section_head && i < ADF_CFG_MAX_SECTION; i++) {
>  		if (copy_from_user(&section, (void __user *)section_head,
>  				   sizeof(*section_head))) {
>  			dev_err(&GET_DEV(accel_dev),
> @@ -156,7 +160,7 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
>  
>  		params_head = section.params;
>  
> -		while (params_head) {
> +		for (j = 0; params_head && j < ADF_CFG_MAX_KEY_VAL; j++) {
>  			if (copy_from_user(&key_val, (void __user *)params_head,
>  					   sizeof(key_val))) {
>  				dev_err(&GET_DEV(accel_dev),
> 
> base-commit: 8aee6d5494bfb2e535307eb3e80e38cc5cc1c7a6
> -- 
> 2.37.3
> 

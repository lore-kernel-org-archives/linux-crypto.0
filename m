Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B86C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0B064E37
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCRQGw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:06:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhCRQGs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 12:06:48 -0400
IronPort-SDR: scMWyt5MBOuxNU831d0pZeu7S8XxwFEw9MZqrUc2uXIAvmes5whhF6Gl+MZ/JEsYvYWb8YhygW
 uqqvFlV0b2Vw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189806617"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="189806617"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 09:06:37 -0700
IronPort-SDR: uLQTgUwqiXZMjBnMSdm38gP/D5GlyDgT17VBRbK8DuOkh15ZBSt8DaiYew9rpwQabpFnca2cbF
 BVCK8s0vaMbw==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="389294311"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 09:06:33 -0700
Date:   Thu, 18 Mar 2021 16:06:30 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: qat - dont release uninitialized resources
Message-ID: <YFN6hlz/L7erLO0H@silpixa00400314>
References: <20210312162203.2416149-1-ztong0001@gmail.com>
 <20210312162203.2416149-2-ztong0001@gmail.com>
 <YFN3X6q8dzEaUp27@silpixa00400314>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFN3X6q8dzEaUp27@silpixa00400314>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 18, 2021 at 03:53:03PM +0000, Giovanni Cabiddu wrote:
> On Fri, Mar 12, 2021 at 11:22:02AM -0500, Tong Zhang wrote:
> > adf_vf_isr_resource_alloc() is not unwinding correctly when error
> > happens and it trys to release uninitialized resources.
                   ^^^^
Typo: perhaps 'tries'?

Regards,

-- 
Giovanni

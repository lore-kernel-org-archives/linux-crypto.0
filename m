Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A768BC07E99
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 10:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B9061004
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jul 2021 10:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbhGLKbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jul 2021 06:31:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:46148 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233527AbhGLKba (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jul 2021 06:31:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="208137507"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="208137507"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 03:28:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="429596773"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 03:28:21 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m2tAe-00Bz1B-0B; Mon, 12 Jul 2021 13:28:16 +0300
Date:   Mon, 12 Jul 2021 13:28:15 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, tomaszx.kowalik@intel.com,
        marco.chiappero@intel.com, fiona.trahe@intel.com,
        wojciech.ziemba@intel.com, ztong0001@gmail.com,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: qat - Fixes and clean-ups
Message-ID: <YOwZP5pWrgidURqM@smile.fi.intel.com>
References: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jul 11, 2021 at 08:12:57AM +0200, Christophe JAILLET wrote:
> The only link between these 3 patches are that they are all related to
> 'drivers/crypto/qat'.

Entire series looks good after addressing comment against patch 1.
Feel free to add
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Christophe JAILLET (3):
>   crypto: qat - Simplify code and axe the use of a deprecated API
>   crypto: qat - Disable AER if an error occurs in probe functions
>   crypto: qat - Fix a typo in a comment
> 
>  drivers/crypto/qat/qat_4xxx/adf_drv.c       |  8 ++------
>  drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 15 ++++++---------
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  9 ++-------
>  drivers/crypto/qat/qat_c62x/adf_drv.c       | 15 ++++++---------
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  9 ++-------
>  drivers/crypto/qat/qat_common/adf_aer.c     |  2 +-
>  drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 15 ++++++---------
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  9 ++-------
>  8 files changed, 27 insertions(+), 55 deletions(-)
> 
> -- 
> 2.30.2
> 

-- 
With Best Regards,
Andy Shevchenko



Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940ABC83F10
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 13:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbjHaNnU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346419AbjHaNnJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 09:43:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781C210E6
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 06:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693489371; x=1725025371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0ZaryvLmhdMiNgDSnOq7f55JW35/Gpnif0ICL5DYq6o=;
  b=KheCEBzwN5GCcFSWGgDa8wRQr/JRVT1CRkWOjBvKq5K5YiIMRMVktWqX
   5bN/2nN/buGxokDN/hI+h0y+cBUxVzOegeAxxDYd80rDY59iNmMLG7WXP
   Js+ytuLHn9jbR8lruP+iBD0rk1jDl5gUl8OUMQx35HsVHmiW1VPtQXMxK
   iiSuW4YqTqiKpcK/6XjeQQpl+508piNS3wQuLmFgdJov/L60FSn+A7NUE
   tZmOgip4wXAS6YSxnimcDmSku7m/O73zjQ421nR95A94WYodA1PBJQpoY
   hy57ddBg+tx8/4+S40B2LnyThCa5F7Y5NIDEsMeJP4r83ZZ7MgbvkW5yK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="462316278"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="462316278"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:42:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="774575966"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="774575966"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 06:42:48 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qbhwb-005OqC-05;
        Thu, 31 Aug 2023 16:42:45 +0300
Date:   Thu, 31 Aug 2023 16:42:44 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        damian.muszynski@intel.com, shashank.gupta@intel.com,
        tom.zanussi@linux.intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -next] crypto: qat - Use list_for_each_entry() helper
Message-ID: <ZPCY1EEFz0opLpvo@smile.fi.intel.com>
References: <20230830075451.293379-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830075451.293379-1-ruanjinjie@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 30, 2023 at 03:54:51PM +0800, Jinjie Ruan wrote:
> Convert list_for_each() to list_for_each_entry() so that the list_itr
> list_head pointer and list_entry() call are no longer needed, which
> can reduce a few lines of code. No functional changed.

Seems correct to me, assumed that this has been tested,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko



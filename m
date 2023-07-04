Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DDA5EB64DD
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 07:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjGDHQB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 03:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjGDHQA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 03:16:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3513130;
        Tue,  4 Jul 2023 00:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688454959; x=1719990959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KxiOKK8ZtnUQMHJugLP3SqpKmfaT0o8tDXBooxFv9EA=;
  b=GNZZl6/B2XpOIWBxwNGfgXH5SIth4sZuxXvaLEWTwTmLIsoWBNEyW79w
   4fl197afjYeqwq3lTc912jeV0nCMo5IuhJY9ZmJEngf3rBDRZl/xpSO23
   HA6RB+pBmkteA3OVmffzYQzVKBlOjDoiM5mJpslxLFMPjCDttg5T24+e8
   cVua+T/SF94lwsl78970QzXnLitQLC8ZAHpqfhezi6WxcwOpLIYp46inA
   LAuBIgOEwqFwEp8Scv7vA6JgS6UxrAiNwAOG7fGjrvORqlMOE6QI4KI30
   6kuP7v7cnuN329VCyWm2wHDctALyCs0Azma/+v6OzPP+G0sH9xXKIN5E0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="342646738"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="342646738"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 00:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="842899636"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="842899636"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004.jf.intel.com with ESMTP; 04 Jul 2023 00:15:31 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qGaG1-0024BQ-2o;
        Tue, 04 Jul 2023 10:15:29 +0300
Date:   Tue, 4 Jul 2023 10:15:29 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     You Kangren <youkangren@vivo.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Srinivas Kerekare <srinivas.kerekare@intel.com>,
        "open list:QAT DRIVER" <qat-linux@intel.com>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: Re: [PATCH v4] crypto: qat - Replace the if statement with min()
Message-ID: <ZKPHEYxkBeFbIBeR@smile.fi.intel.com>
References: <20230704065643.32220-1-youkangren@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704065643.32220-1-youkangren@vivo.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 04, 2023 at 02:56:39PM +0800, You Kangren wrote:
> mark UWORD_CPYBUF_SIZE with U suffix to make the type the same with

You need to respect English grammar and punctuation.
Here should be

  Mark...

> words_num and replace the if statement with min() in 

(drop trailing space)

> qat_uclo_wr_uimage_raw_page() to make code shorter

...and here the period is missing.

Also, Haven't I given my tag? Why it's not added?

> Signed-off-by: You Kangren <youkangren@vivo.com>
> ---

Where is the changelog from v3? What had been changed so far?

-- 
With Best Regards,
Andy Shevchenko



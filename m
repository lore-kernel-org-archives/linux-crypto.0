Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732BCEB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 18:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjFVS0d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjFVS0d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 14:26:33 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CD82118
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 11:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687458390; x=1718994390;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZB5wnq0txNlYjCXe1+1/+07+tPlVpzckHsJSREmnU9o=;
  b=XGzcLGIMDH0GR6gkkHJMJCrhhTb8Gt8zVVLNGoampA/ed6NSNzwr1N4F
   0rcCCXXxhAOljhSRgtefwndCWvUD7qXZsF4f2Xo6bIC9VRwnU7jg713Zh
   JUkn61MZs0oMxBiCE5cld3YW1meda+W6JSI7Hz8T8TFOC8SqZe2apK8Vs
   yGyfHciJ6v76tftVJ+L2mgV0xk1/I3iPTcCs+nbqox1dm2q3MCBhzXvs8
   hcs2BTd6yP2wQpLw9PiVU/nFJOXVirreuCnp7M9pSF1QRPh192SKOdyMu
   vYd4PUrsmDuk5ugV1Y6s7oWzTeJvZJWc12RsVC+uY6ds/LNJBH/iE8mi0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="350332926"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="350332926"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 11:26:21 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="749435483"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="749435483"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 22 Jun 2023 11:26:20 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qCP0c-005pcz-2W;
        Thu, 22 Jun 2023 21:26:18 +0300
Date:   Thu, 22 Jun 2023 21:26:18 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v3 3/5] crypto: qat - add measure clock frequency
Message-ID: <ZJSSSnFhuDR9CkEc@smile.fi.intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
 <20230622180405.133298-4-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622180405.133298-4-damian.muszynski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 22, 2023 at 08:04:04PM +0200, Damian Muszynski wrote:
> The QAT hardware does not expose a mechanism to report its clock
> frequency. This is required to implement the Heartbeat feature.
> 
> Add a clock measuring algorithm that estimates the frequency by
> comparing the internal timestamp counter incremented by the firmware
> with the time measured by the kernel.
> The frequency value is only used internally and not exposed to
> the user.

...

> +	/*
> +	 * Enclose the division to allow the preprocessor to precalculate it,
> +	 * and avoid promoting macro to 64bits before division.

"...promoting r-value to 64-bit..."

> +	 */
> +	*frequency = temp * (HZ_PER_MHZ / 10);

-- 
With Best Regards,
Andy Shevchenko



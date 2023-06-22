Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BE8EB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 18:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjFVS1l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjFVS1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 14:27:40 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1172116
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 11:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687458459; x=1718994459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R6lbbEn0x9IGUWCYVmGNFEVscuxp2s7u24xZuz3jfsA=;
  b=asGbQ+adJNZNwvpOMdnFaufVeFJjHWhEXXzsVP01TX4EwlKVFnjva5sS
   E2qZcZ9KbEXDomNhlg+b0qRdQ27k0+cEfziRtUmbH8rg92FWbQ89WBkVl
   7BDxvJO2QZHgzR6ri8xqDOzN983rYp6L90DkZ/7emMFaWNswp2sLjoDMc
   pFk5vAti16I3guP9xFwBRM4O4W1ZEsDYwlBW2q6bVsIl4GhbV/ifzzQKw
   xhbgNXsWdQtey2zwvWYon7TOEsZY1GtrC/U4zuhMVcGee1QKdcvblUShR
   q0eVZMn9nWq9MMxUhbYWdsOXu16Gc38/6Bwh2eUIVaL9TQW+0tpzvx/td
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="340914014"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="340914014"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 11:27:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="961681268"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="961681268"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2023 11:27:37 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qCP1s-005pdy-1B;
        Thu, 22 Jun 2023 21:27:36 +0300
Date:   Thu, 22 Jun 2023 21:27:36 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v3 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZJSSmE9nDZXKwPd0@smile.fi.intel.com>
References: <20230622180405.133298-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622180405.133298-1-damian.muszynski@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 22, 2023 at 08:04:01PM +0200, Damian Muszynski wrote:
> This set introduces support for the QAT heartbeat feature. It allows
> detection whenever device firmware or acceleration unit will hang.
> We're adding this feature to allow our clients having a tool with
> they could verify if all of the Quick Assist hardware resources are
> healthy and operational.
> 
> QAT device firmware periodically writes counters to a specified physical
> memory location. A pair of counters per thread is incremented at
> the start and end of the main processing loop within the firmware.
> Checking for Heartbeat consists of checking the validity of the pair
> of counter values for each thread. Stagnant counters indicate
> a firmware hang.
> 
> The first patch adds timestamp synchronization to the firmware.
> The second patch removes historical and never used HB definitions.
> Patch no. 3 is implementing the hardware clock frequency measuring
> interface.
> The fourth introduces the main heartbeat implementation with the debugfs
> interface.
> The last patch implements an algorithm that allows the code to detect
> which version of heartbeat API is used at the currently loaded firmware.

I made a few last minute nit-picks, feel free to ignore them if it's okay
with the maintainers.

-- 
With Best Regards,
Andy Shevchenko



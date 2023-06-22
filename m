Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6099CEB64D8
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Jun 2023 18:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjFVSVq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjFVSVo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2023 14:21:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D9A210A
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jun 2023 11:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687458102; x=1718994102;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NOcfnpZD4bF03XplDTIMFCM+JoJoCkIzrWRYPdMaj4M=;
  b=LoQSLDwTKpKpaZUO3uNL89MfeC6HD7MfkReJXORlhAUPazN4ziUnlryJ
   3SvSee66S+t/XP99BxmYdfuVeFS+G6hlAKEjf68I87FSvyuA24o1J+4Ap
   P2MU0ketnSUxAXH8jMmHxxxMg7cA00ySA/ykEaJQOp5PqaVBFPMD62092
   qFyaQz8SZTowQ4AF8usHC114OqSF6NpK3BbxcfG6BrOoKtLYGGYDaEf8x
   wrIZC/LfPBN+k/6iNZNEw/vG4srh9nfGIQIyHosRp0ASw6ekGNKn4j3Z4
   aIfhPFvN2BHLeGJSDf+44Bcmqpz+/p2NHQn9/OpS4dNmbsR2TuVSfN3tW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="390396344"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="390396344"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 11:21:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="961678990"
X-IronPort-AV: E=Sophos;i="6.01,149,1684825200"; 
   d="scan'208";a="961678990"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2023 11:21:39 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qCOw6-005pXH-13;
        Thu, 22 Jun 2023 21:21:38 +0300
Date:   Thu, 22 Jun 2023 21:21:38 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH v3 0/5] crypto: qat - add heartbeat feature
Message-ID: <ZJSRMgjqp+rqxTCO@smile.fi.intel.com>
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
> 
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>

> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

These tags are not for cover letter.

-- 
With Best Regards,
Andy Shevchenko



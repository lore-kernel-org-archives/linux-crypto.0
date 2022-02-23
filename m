Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F4FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 11:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbiBWLKY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Feb 2022 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiBWLKY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Feb 2022 06:10:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE178EB60;
        Wed, 23 Feb 2022 03:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645614597; x=1677150597;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MiQ9JVyV1Ee4uRCraDgESdGOmKLVIdnK2qWMWiAcqtw=;
  b=bclqWglPS50XTO/6zOXh2OfVmHqRi68+XzJ4xMcx3llVNIXJi7nKyEWu
   jMkCkJiMlMRFV/7GWpcc2UTPo3ymN4Pc/L+iXKmsLhJavvE0PqdVl9WR3
   lN65VVhxeTVCu9avwP2apyz3LB22WMZQM5sIcJFVLinzs6nbe58ZXLt9V
   IJBXhV/Xu7LrIeFWs2CpmS2XCbhOfXY41QeDQq0Kz0BoEi7ggR9xVUktQ
   FL9QlthBXGlEk9o+XSrTGCKxxHdBTM36+IIz2rd2hd2emhc+s8GSp0cwm
   KrFeciHd/K/GOyC/DhkOCoOu5iQQNyQ55y/NRmpvldt/mfC2qu9fqgXv1
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231913473"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="231913473"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 03:09:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="706991530"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 03:09:55 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMpW4-007O4Q-Qv;
        Wed, 23 Feb 2022 13:09:04 +0200
Date:   Wed, 23 Feb 2022 13:09:04 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1 1/1] crypto: cavium/nitrox - don't cast parameter in
 bit operations
Message-ID: <YhYV0DCYw+YPwVgC@smile.fi.intel.com>
References: <20220215160641.51683-1-andriy.shevchenko@linux.intel.com>
 <YhWhhPL+M6QWdqzL@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhWhhPL+M6QWdqzL@gondor.apana.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 23, 2022 at 02:52:52PM +1200, Herbert Xu wrote:
> On Tue, Feb 15, 2022 at 06:06:41PM +0200, Andy Shevchenko wrote:
> >
> > @@ -122,6 +123,7 @@ void nitrox_pf2vf_mbox_handler(struct nitrox_device *ndev)
> >  {
> >  	struct nitrox_vfdev *vfdev;
> >  	struct pf2vf_work *pfwork;
> > +	DEFINE_BITMAP(csr, 64);
> 
> Perhaps you mean DECLARE_BITMAP?

Yes, sorry. I have missed the build by some reason. I'll send a new version.

-- 
With Best Regards,
Andy Shevchenko



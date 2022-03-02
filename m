Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604DBC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 15:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiCBPtH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240523AbiCBPtH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 10:49:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC91F26AF8;
        Wed,  2 Mar 2022 07:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646236102; x=1677772102;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7SxZt8cvpX0qbBlZfjbZpbU5r4hZyRS0CTLl/eM6fCk=;
  b=P1vYV7EuxFF/MOO7iKrDmYoIK81ghNQKBTQR8mTlaW/n/7i9NxuIzAVE
   CthAkabPZsukPIqUsFlOZGEetOx7n+oA5DjnNSl0wUSvWZLvMl7DID/m6
   czR+MbRY7xUbSaVTNAGtWc86FuiZd4HMTrGU0BV55/eFTmwUaUSKxqxNb
   0A2oFtAqoaF0G5Kt60YdQGFE922D7uJD4jCOMQIbGOIZBQE03lkI+Pep4
   l2CZpCZar65bju7kLEwOj0kuEt6oq6sEf1MZ5EueMWiBU54PESurI/J+C
   R7acXP97clzDpctIW9Ler39vnn4xCuifuQVUKrZIvalHCwAm7Wh/OXZRk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="253160768"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="253160768"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:48:22 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="508240936"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:48:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nPRCQ-00AMnZ-3A;
        Wed, 02 Mar 2022 17:47:34 +0200
Date:   Wed, 2 Mar 2022 17:47:33 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/1] crypto: cavium/nitrox - don't cast parameter in
 bit operations
Message-ID: <Yh+Rla5X7/8MBybu@smile.fi.intel.com>
References: <20220223162620.44307-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223162620.44307-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 23, 2022 at 06:26:20PM +0200, Andy Shevchenko wrote:
> While in this particular case it would not be a (critical) issue,
> the pattern itself is bad and error prone in case the location
> of the parameter is changed.
> 
> Don't cast parameter to unsigned long pointer in the bit operations.
> Instead copy to a local variable on stack of a proper type and use.

Is this fix already applied?

-- 
With Best Regards,
Andy Shevchenko



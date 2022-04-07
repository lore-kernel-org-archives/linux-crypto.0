Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BFF6C433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 19:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiDGT2d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 15:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiDGT2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 15:28:18 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393A3284E62
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 12:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649359570; x=1680895570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iTHWNESpGl0orNs305WEqyPLwp9940y5agQkLaD9hLI=;
  b=i+7+B4/dR3UpBqYMBkMeSDsrXQzU4paqaULaLNvfXmkfwHZ+0EpUX3c/
   wPX1chBbUfViTvoRgyFaihrC1MtEME/IpoKksVVjK9HfqLm32qPhmkHSS
   9YYk3+8axXGglgwB5M0INL/qVLQfLUMSsNhYqp8WGV8tJ2HI41LzXZcy3
   gzKhUDs1+963kww2l+loA9uX6ZRyneKTXNJJyQivDZkHdUm+qs14VT/jr
   RyHnn71aSw3UiDBfxoHz0X/jjYH9isx4smnEKXhA6aiAbMPYvr0Kgyqew
   iy3kVE6cGiBNDzPDy4QG25ta72w/sJK+WzuBkqNF15aFtdB/NBq+wtne0
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="259019631"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="259019631"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:26:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="524506508"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.76])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:26:08 -0700
Date:   Thu, 7 Apr 2022 20:26:01 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Chiappero, Marco" <marco.chiappero@intel.com>
Subject: Re: [PATCH v2 0/4] crypto: qat - fix dm-crypt related issues
Message-ID: <Yk86yVHY/WedmAlO@silpixa00400314>
References: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331153652.37020-1-giovanni.cabiddu@intel.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 31, 2022 at 04:36:48PM +0100, Cabiddu, Giovanni wrote:
> This set fixes the issues related with the dm-crypt + QAT driver
> use-case.
We found a regression with patch #3 of this set.
I'm going to send a v3 that fixes it.

Regards,

-- 
Giovanni

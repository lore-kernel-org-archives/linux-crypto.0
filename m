Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941F3EB64D9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jul 2023 09:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjGDJtU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jul 2023 05:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjGDJtT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2023 05:49:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA5D7;
        Tue,  4 Jul 2023 02:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688464158; x=1720000158;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+To5exkrtzkCLi+f4+ve49sb0CwCQ1OAhNXBwPW82dY=;
  b=MX8H4vMfFb8183IHhSFS8WsHTtd5KqrQQAfLPgUyBLbtMjZqCTlItase
   +wxVxKm75UGgbJ/hCBoKLr2Kk6jLhVZ/KEdfriAJ1PBUqb2cjOhrZ6Z9K
   Uui5lXzWJVsjamt8d6K3LLpxFrFItKepBCQNr7UtChYE7OgWaTDXWDQKj
   7RTWcNBVExF5oLYT6/VkLecsPVBWFqkxFqU5DLITq0JWB8pXOeDIGElYU
   DDLCmI1DtT9HlBJsMagMUb+8tqBqzMFnAY6IiMGGf8W3VfcTXt2xqvzVj
   XTCdOR7+MLGlQy/NH/BrG9Doq6J0fCylyuYA3QiBg8zx4RQFcswkyHLVA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="360564671"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="360564671"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 02:49:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="669038388"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="669038388"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003.jf.intel.com with ESMTP; 04 Jul 2023 02:49:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qGcel-0026VT-01;
        Tue, 04 Jul 2023 12:49:11 +0300
Date:   Tue, 4 Jul 2023 12:49:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     You Kangren <youkangren@vivo.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Srinivas Kerekare <srinivas.kerekare@intel.com>,
        "Bruce W. Allan" <bruce.w.allan@intel.com>,
        Pingchaox Yang <pingchaox.yang@intel.com>,
        Bo Cui <bo.cui@intel.com>, Karen Xiang <karen.xiang@intel.com>,
        "open list:QAT DRIVER" <qat-linux@intel.com>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: Re: [PATCH v5] crypto: qat - Replace the if statement with min()
Message-ID: <ZKPrFrfvvK2vgrnN@smile.fi.intel.com>
References: <20230704094208.642-1-youkangren@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704094208.642-1-youkangren@vivo.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 04, 2023 at 05:42:07PM +0800, You Kangren wrote:
> Mark UWORD_CPYBUF_SIZE with U suffix to make its type the same with
> words_num and replace the if statement with min() in
> qat_uclo_wr_uimage_raw_page() to make code shorter.

...

> Fixes: b4b7e67c917f ("crypto: qat - Intel(R) QAT ucode part of fw loader")

> - Add the Fixes

Hmm... Can you elaborate what it fixes?

-- 
With Best Regards,
Andy Shevchenko



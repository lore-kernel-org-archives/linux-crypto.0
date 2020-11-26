Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D90C63697
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 12:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B872087C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Nov 2020 12:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbgKZMET (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Nov 2020 07:04:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:7769 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgKZMET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Nov 2020 07:04:19 -0500
IronPort-SDR: Ay13JN+vTm1NrpwxE71aBO18W8gPPl+V7BtBwxn+rqqjk3PUBhjhotMr8VaneGRdhjJucG5Dd1
 MfXmtS0NVh/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="233881451"
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="233881451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 04:04:18 -0800
IronPort-SDR: Rdr0vgWgv4OAA1iUSSQd7PXQpUoWlTqP4uRbIuN5+eKpIQrJVZMMV8hzIQOpdbf1xDp+Jwonm5
 lY8Az+ZW/xOg==
X-IronPort-AV: E=Sophos;i="5.78,372,1599548400"; 
   d="scan'208";a="333354621"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 04:04:16 -0800
Date:   Thu, 26 Nov 2020 12:04:08 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Trahe, Fiona" <fiona.trahe@intel.com>,
        "Ziemba, Wojciech" <wojciech.ziemba@intel.com>,
        "Chiappero, Marco" <marco.chiappero@intel.com>,
        qat-linux <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Use dma_set_mask_and_coherent to simplify
 code
Message-ID: <20201126120408.GA21666@silpixa00400314>
References: <20201121071359.1320167-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121071359.1320167-1-christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christophe,

On Sat, Nov 21, 2020 at 07:13:59AM +0000, Christophe JAILLET wrote:
> 'pci_set_dma_mask()' + 'pci_set_consistent_dma_mask()' can be replaced by
> an equivalent 'dma_set_mask_and_coherent()' which is much less verbose.
> 
> While at it, also remove some unless extra () in the 32 bits case.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Instead of returning -EFAULT, we could also propagate the error returned
> by dma_set_mask_and_coherent()
I'm going to re-submit implementing the comment above and also including
qat_4xxx.

Regards,

-- 
Giovanni

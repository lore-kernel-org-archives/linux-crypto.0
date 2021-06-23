Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFEAC48BE5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 14:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D3C6108E
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 14:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFWOLA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 10:11:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:16386 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230274AbhFWOLA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 10:11:00 -0400
IronPort-SDR: 4iBSV607JQCUAL8h7od7dwf7Grq1hpNWws7Bd3QtIaFTXqvD8StqOfGfpppcQN8Uf/jM0DoFvh
 bBgw9gUVZkiw==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="271113513"
X-IronPort-AV: E=Sophos;i="5.83,294,1616482800"; 
   d="scan'208";a="271113513"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 07:08:40 -0700
IronPort-SDR: vYprr8R9IUpUo6IDIn7or13zowPRhoIFjSUSFNMl5HEjTyplSdILSjLsKZRD/txvBkuTaVIR0E
 HpjXIQlyGPFg==
X-IronPort-AV: E=Sophos;i="5.83,294,1616482800"; 
   d="scan'208";a="556155669"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 07:08:38 -0700
Date:   Wed, 23 Jun 2021 15:08:31 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Qinglang Miao <miaoqinglang@huawei.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: ratelimit invalid ioctl message and print
 the invalid cmd
Message-ID: <YNNAX92NdKi1BRBT@silpixa00400314>
References: <20210622151608.23741-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622151608.23741-1-colin.king@canonical.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 22, 2021 at 04:16:08PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently incorrect QAT ioctls can spam the kernel log with error messages
> of the form "QAT: Invalid ioctl" if a userspace program uses the wrong
> ioctl command. Quench the messages by ratelimiting them and also print
> the invalid command being used as that is useful to know.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Just a minor comment on the commit message:
crypto: qat: ratelimit invalid ioctl message and print
           ^
Patches to the qat driver have the following headline:
        crypto: qat -
not
        crypto: qat:


Apart from that
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Regards,

-- 
Giovanni

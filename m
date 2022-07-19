Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64876C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 03:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234323AbiGSDrj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGSDrj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jul 2022 23:47:39 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C72018B;
        Mon, 18 Jul 2022 20:47:37 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oDeCp-001xuh-4W; Tue, 19 Jul 2022 13:47:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Jul 2022 11:47:31 +0800
Date:   Tue, 19 Jul 2022 11:47:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        liulongfang@huawei.com, davem@davemloft.net, xuzaibo@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc
 mem during softirq
Message-ID: <YtYpUxGQLs6M7iiz@gondor.apana.org.au>
References: <20220719021042.250882-1-shaozhengchao@huawei.com>
 <YtYT+JeYj7vlz9Xp@gondor.apana.org.au>
 <00e710db-3fcd-1fb7-3d19-b5761e241adc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e710db-3fcd-1fb7-3d19-b5761e241adc@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 19, 2022 at 11:31:02AM +0800, shaozhengchao wrote:
>
> 	Thank you for your reply. I think differentiate the application scenarios
> of GFP flags, which can be more suitable to allocate memory.

You need to have a very strong reason to do this.  I don't think
it's appropriate here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

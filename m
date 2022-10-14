Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29575C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 08:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJNI0M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 04:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJNI0M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 04:26:12 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7741C208B;
        Fri, 14 Oct 2022 01:26:07 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ojG0z-00EdPa-VO; Fri, 14 Oct 2022 19:25:59 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Oct 2022 16:25:57 +0800
Date:   Fri, 14 Oct 2022 16:25:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Shen <shenyang39@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC PATCH 0/6] crypto: benchmark - add the crypto benchmark
Message-ID: <Y0kdFaXQtsJxgrC0@gondor.apana.org.au>
References: <20220919120537.39258-1-shenyang39@huawei.com>
 <Yyl5yKQCAgPBbFd7@gondor.apana.org.au>
 <3dd984c1-d17f-0a6a-c52e-87e161f867fc@huawei.com>
 <YzZ12Y/kEF4DrQV6@gondor.apana.org.au>
 <09d0686b-1955-c63d-c02d-fb0d2db42672@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09d0686b-1955-c63d-c02d-fb0d2db42672@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 14, 2022 at 09:43:40AM +0800, Yang Shen wrote:
>
> Got it. I'll try to support this on the tcrypt.

Before you get too far into this, please note that I have no
preference as to whether you go with tcrypt or your new benchmark
code.

My only requirement is that we pick one mechanism.

But obivously others might have a preference so you should try
to produce RFCs as early as possible.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

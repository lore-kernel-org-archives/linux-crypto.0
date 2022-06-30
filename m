Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFF9C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 06:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiF3G7R (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 02:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbiF3G7O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 02:59:14 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AAD1F2C4;
        Wed, 29 Jun 2022 23:59:13 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6o8q-00Cwd2-GF; Thu, 30 Jun 2022 16:59:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 14:59:08 +0800
Date:   Thu, 30 Jun 2022 14:59:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, mst@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        berrange@redhat.com, pizhenwei@bytedance.com
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
Message-ID: <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623070550.82053-1-helei.sig11@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 23, 2022 at 03:05:46PM +0800, Lei He wrote:
> From: lei he <helei.sig11@bytedance.com>
> 
> This patch supports the ECDSA algorithm for virtio-crypto.

Why is this necessary?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

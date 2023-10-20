Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA400CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbjJTFuf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjJTFue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:50:34 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1312BCA;
        Thu, 19 Oct 2023 22:50:32 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiOV-0097Rl-OJ; Fri, 20 Oct 2023 13:50:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:50:05 +0800
Date:   Fri, 20 Oct 2023 13:50:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     mst@redhat.com, arei.gonglei@huawei.com,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] virtio-crypto: handle config changed by work queue
Message-ID: <ZTIVDQZeHb2BlbH7@gondor.apana.org.au>
References: <20231007064309.844889-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231007064309.844889-1-pizhenwei@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 07, 2023 at 02:43:09PM +0800, zhenwei pi wrote:
> MST pointed out: config change callback is also handled incorrectly
> in this driver, it takes a mutex from interrupt context.
> 
> Handle config changed by work queue instead.
> 
> Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  drivers/crypto/virtio/virtio_crypto_common.h |  3 +++
>  drivers/crypto/virtio/virtio_crypto_core.c   | 14 +++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

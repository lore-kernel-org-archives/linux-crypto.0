Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC69C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 09:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiF3JH1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 05:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiF3JH1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 05:07:27 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C76192A8;
        Thu, 30 Jun 2022 02:07:25 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o6q8u-00CzNX-TN; Thu, 30 Jun 2022 19:07:22 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jun 2022 17:07:21 +0800
Date:   Thu, 30 Jun 2022 17:07:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Lei He <helei.sig11@bytedance.com>
Cc:     davem@davemloft.net, dhowells@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        berrange@redhat.com, pizhenwei@bytedance.com
Subject: Re: [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
Message-ID: <Yr1nybJ9eSNgU24i@gondor.apana.org.au>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
 <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
 <Yr1TuPM8yvJUoV9r@gondor.apana.org.au>
 <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CC761178-556D-44F6-9479-5151C69476C8@bytedance.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 30, 2022 at 04:30:39PM +0800, Lei He wrote:
>
> I have explained above why we need a driver that supports ECDSA, and this patch
> enables virtio-crypto to support ECDSA. I think this is a good time to support ECDSA
> in the kernel crypto framework, and there will be more drivers supporting ECDSA in the 
> future.
> Looking forward to your opinion :-).

Until there are drivers in the kernel it's pointless to implement
this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

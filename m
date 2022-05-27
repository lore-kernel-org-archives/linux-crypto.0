Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A312C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 10:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350294AbiE0KGf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 06:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350818AbiE0KGd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 06:06:33 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AFD5DA02
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:06:30 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nuWrB-000YOU-IB; Fri, 27 May 2022 20:06:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 May 2022 18:06:09 +0800
Date:   Fri, 27 May 2022 18:06:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 02/11] crypto: add crypto_has_kpp()
Message-ID: <YpCikbaFof/+eNhQ@gondor.apana.org.au>
References: <20220518112234.24264-1-hare@suse.de>
 <20220518112234.24264-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518112234.24264-3-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 18, 2022 at 01:22:25PM +0200, Hannes Reinecke wrote:
> Add helper function to determine if a given key-agreement protocol
> primitive is supported.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>  crypto/kpp.c         | 6 ++++++
>  include/crypto/kpp.h | 2 ++
>  2 files changed, 8 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

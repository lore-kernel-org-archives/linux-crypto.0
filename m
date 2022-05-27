Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A67E5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 May 2022 10:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350821AbiE0KGd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 May 2022 06:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350764AbiE0KG2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 May 2022 06:06:28 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE156C34
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2022 03:06:25 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nuWqt-000YNg-KO; Fri, 27 May 2022 20:05:53 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 May 2022 18:05:51 +0800
Date:   Fri, 27 May 2022 18:05:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 01/11] crypto: add crypto_has_shash()
Message-ID: <YpCif8gjs/LRopmF@gondor.apana.org.au>
References: <20220518112234.24264-1-hare@suse.de>
 <20220518112234.24264-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518112234.24264-2-hare@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 18, 2022 at 01:22:24PM +0200, Hannes Reinecke wrote:
> Add helper function to determine if a given synchronous hash is supported.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

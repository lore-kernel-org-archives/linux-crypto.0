Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D66C001DF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jul 2023 01:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjGVBXb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jul 2023 21:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGVBXa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2023 21:23:30 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D7E30C4;
        Fri, 21 Jul 2023 18:23:29 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qN1Kt-002CvY-Tq; Sat, 22 Jul 2023 11:23:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Jul 2023 13:23:01 +1200
Date:   Sat, 22 Jul 2023 13:23:01 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tom Zanussi <tom.zanussi@linux.intel.com>
Cc:     davem@davemloft.net, fenghua.yu@intel.com, vkoul@kernel.org,
        dave.jiang@intel.com, tony.luck@intel.com,
        wajdi.k.feghali@intel.com, james.guilford@intel.com,
        kanchana.p.sridhar@intel.com, vinodh.gopal@intel.com,
        giovanni.cabiddu@intel.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v7 12/14] crypto: iaa - Add support for deflate-iaa
 compression algorithm
Message-ID: <ZLsvdS6NbaetDFe1@gondor.apana.org.au>
References: <20230710190654.299639-1-tom.zanussi@linux.intel.com>
 <20230710190654.299639-13-tom.zanussi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710190654.299639-13-tom.zanussi@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 10, 2023 at 02:06:52PM -0500, Tom Zanussi wrote:
>
> Because the IAA hardware has a 4k history-window limitation, only
> buffers <= 4k, or that have been compressed using a <= 4k history
> window, are technically compliant with the deflate spec, which allows
> for a window of up to 32k.  Because of this limitation, the IAA fixed
> mode deflate algorithm is given its own algorithm name, 'deflate-iaa'.

So compressed results produced by this can always be decompressed
by the generic algorithm, right?

If it's only when you decompress that you may encounter failures,
then I suggest that we still use the same algorithm name, but fall
back at run-time if the result cannot be decompressed by the
hardware.  Is it possible to fail gracefully and then retry the
decompression in this case?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

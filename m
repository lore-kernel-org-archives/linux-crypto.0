Return-Path: <SRS0=QtXc=XE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4A7C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB6221920
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Sep 2019 07:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbfIIHyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Sep 2019 03:54:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:32924 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388497AbfIIHyW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Sep 2019 03:54:22 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i7EUw-0007dU-R8; Mon, 09 Sep 2019 17:54:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Sep 2019 17:54:05 +1000
Date:   Mon, 9 Sep 2019 17:54:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Eric Biggers <ebiggers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Glauber <jglauber@cavium.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/zip - Add missing single_release()
Message-ID: <20190909075405.GE21364@gondor.apana.org.au>
References: <20190904141809.170277-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904141809.170277-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 04, 2019 at 02:18:09PM +0000, Wei Yongjun wrote:
> When using single_open() for opening, single_release() should be
> used instead of seq_release(), otherwise there is a memory leak.
> 
> Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/cavium/zip/zip_main.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

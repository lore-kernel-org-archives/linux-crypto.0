Return-Path: <SRS0=YBhh=TS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FE3C04AAF
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 22:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E068C2087B
	for <linux-crypto@archiver.kernel.org>; Sat, 18 May 2019 22:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558218050;
	bh=FWB8o9hJXRs9/f3k+SAZiT620GgvbBJxzutwvrug9lA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0qaqTFHcYZcuwjbYI6wKk5EnGuy1LVrVXuGxw+SjJgmOMqOCSzC43tZfmR65T22aG
	 VVF/cRB25qQNzzkasz8ArBk49U8K5yomexMX7JM+PFlbkAtrEofVe9FX78tldQbWYI
	 ACzhyMYqlHW9E2f3kgFUIzPCBG6YzTfdVIwseErQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfERWUt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 May 2019 18:20:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfERWUs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 May 2019 18:20:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4FC120848;
        Sat, 18 May 2019 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558218048;
        bh=FWB8o9hJXRs9/f3k+SAZiT620GgvbBJxzutwvrug9lA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzsYIlJll0Drj/jsErYq00QuhkHcL93qP4q7thB0YHMm4JVARe7FGRxgiKr3EB0lN
         yOR4WfAt+Lzmj5QZ4yUr9m5R5SWzVvgXfV14Um+jUmbnMCJK2e08thpKAVte2k+myj
         +jwcw636lpOOAnQV/SInS5FksSC9mXdMdFz38OlM=
Date:   Sat, 18 May 2019 15:20:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: skcipher - perform len fits into blocksize
 check at the top
Message-ID: <20190518222045.GA3119@sol.localdomain>
References: <20190518213035.21699-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518213035.21699-1-chunkeey@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christian,

On Sat, May 18, 2019 at 11:30:35PM +0200, Christian Lamparter wrote:
> This patch adds early check to test the given data length
> is aligned with the supported ciphers blocksize, or abort
> with -EINVAL in case the supplied chunk size does not fit
> without padding into the blocksize for block ciphers.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> 
> ---
> 
> This will also work instead of the
> "crypto: crypto4xx - blockciphers should only accept complete blocks"
> It will fix all potential driver issues in other drivers as well as
> break the drivers that don't have the correct blocksize set. it will
> also make the extra checks scattered around in the drivers make
> redundand as well as the extra tests that do send incomplete blocks
> to the hardware drivers.
> ---
>  include/crypto/skcipher.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index e555294ed77f..971294602a41 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -494,6 +494,8 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
>  	crypto_stats_get(alg);
>  	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;
> +	else if (!IS_ALIGNED(cryptlen, crypto_skcipher_blocksize(tfm)))
> +		ret = -EINVAL;
>  	else
>  		ret = tfm->encrypt(req);
>  	crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
> @@ -521,6 +523,8 @@ static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
>  	crypto_stats_get(alg);
>  	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;
> +	else if (!IS_ALIGNED(cryptlen, crypto_skcipher_blocksize(tfm)))
> +		ret = -EINVAL;
>  	else
>  		ret = tfm->decrypt(req);
>  	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
> -- 

Unfortunately this doesn't work because there are some skcipher algorithms
("cts" and "adiantum") that set cra_blocksize to their minimum message length
(16) rather than their length alignment requirement (1).  I.e., these algorithms
support all messages with length >= 16 bytes.

So before we can add this check, we need to get this straightened out.

I actually don't think "block size" should be a property of all crypto
algorithms at all, e.g. for skciphers we should instead have "min_msgsize" and
"msgsize_alignment".  The notion of "block size" is not meaningful for
length-preserving encryption algorithms in general, let alone all crypto
algorithms.  But unfortunately "block size" is pretty deeply embedded into the
crypto API, so it doesn't look easy to fix this...  Maybe for skciphers we could
get away with it always meaning the msgsize_alignment, though.

- Eric

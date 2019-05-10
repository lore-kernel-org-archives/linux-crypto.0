Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B76C04AB2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 04:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C87C2182B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 04:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557461000;
	bh=E295heL6SMH3QceBd+cDz96tYvC0Sw1ss1EgCF5CKrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gFBCHg7Xvp0OWHB4VFZjewFQO3ebotwzaWIHdIvXG4/F8alHkzQ/wwZObQrZ8Qyyt
	 VpdnHKncadcV1/2X2b87o9zhgwvTIYKPpfIH9aueW7fj8kNWVAAEYhibmdbYZBc5Le
	 3fVa5ZojbOSP8Gzx3t0YjE6QpgmOmYPdlWJdTiTw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfEJEDT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 00:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfEJEDS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 00:03:18 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DAC1217F9;
        Fri, 10 May 2019 04:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557460998;
        bh=E295heL6SMH3QceBd+cDz96tYvC0Sw1ss1EgCF5CKrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HfIEKw5MgTlxFIp5NCYGoQCXk7tehTbc+fTl3TJK8zyFKKCsjSE43EGYnYVmX1xNS
         0eSpXUSHXJkN5TDugGNQcAJOFFJNg+ZGV/mUk44OZ+QbE5lDdQ5Ix4hRPKO6E276ZU
         DEjkipZZz8AzPyrJF0V4AXswLYcwWHcZ/ng3jD6I=
Date:   Thu, 9 May 2019 21:03:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: potential underfow in crypto/lrw.c setkey() setkey
Message-ID: <20190510040315.GA737@sol.localdomain>
References: <20190509110622.GA15580@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509110622.GA15580@mwanda>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 09, 2019 at 02:06:22PM +0300, Dan Carpenter wrote:
> crypto/lrw.c
>     72  static int setkey(struct crypto_skcipher *parent, const u8 *key,
>     73                    unsigned int keylen)
>     74  {
>     75          struct priv *ctx = crypto_skcipher_ctx(parent);
>     76          struct crypto_skcipher *child = ctx->child;
>     77          int err, bsize = LRW_BLOCK_SIZE;
>     78          const u8 *tweak = key + keylen - bsize;
>                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Smatch thinks that keylen is user controlled from zero to some upper
> bound.  How do we know it's >= LRW_BLOCK_SIZE (16)?

See create() in crypto/lrw.c, which is the function that creates an LRW
instance.  It sets .min_keysize and .max_keysize:

        inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg) +
                                LRW_BLOCK_SIZE;
        inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg) +
                                LRW_BLOCK_SIZE;

Then when sometime calls crypto_skcipher_setkey(), it calls skcipher_setkey() in
crypto/skcipher.c which verifies the key length is in within the bounds the
algorithm declares:

        if (keylen < cipher->min_keysize || keylen > cipher->max_keysize) {
                crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
                return -EINVAL;
        }

> 
> I find the crypto code sort of hard to follow...  There are a bunch of
> setkey pointers and they're sometimes called recursively.  Is there
> some trick or hints?
> 
>     79          be128 tmp = { 0 };
>     80          int i;
>     81  
>     82          crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
>     83          crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
>     84                                           CRYPTO_TFM_REQ_MASK);
>     85          err = crypto_skcipher_setkey(child, key, keylen - bsize);
>     86          crypto_skcipher_set_flags(parent, crypto_skcipher_get_flags(child) &
>     87                                            CRYPTO_TFM_RES_MASK);
>     88          if (err)
>     89                  return err;

LRW is a template for a block cipher mode of operation which is implemented on
top of ECB.  So, LRW's setkey() method calls setkey() on the underlying ECB
transform.  Similarly, ECB then may call setkey() of the underlying block cipher
such as AES, or alternatively it may be implemented directly.

- Eric

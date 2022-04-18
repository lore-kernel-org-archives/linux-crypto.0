Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397E4C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 19:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347544AbiDRTGa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243795AbiDRTG3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 15:06:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7722231225
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 12:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE47B80E5A
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 19:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D08EC385A7;
        Mon, 18 Apr 2022 19:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650308626;
        bh=7weyYpdH1PMpEntkBRnFKu6bXPlkXQpX66FX/bTmMKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KoerriXFohbSDWB/qmzOO1UTY6l8K2cSwlS9jBBlpltmNYJ3KmQp4GGeIhYcrULIf
         5QoDxO82tjGt42hjfjaHE4UOYp2kPZHAkeL1aPSH/A/Db5ZWWQ0Y9QU5lw64tK9eLO
         v0YrBYHVz/w5VGZL16Jghg0bPan539jVFS31g0tyJe9TB8dLxdbpfJLVV7EovXeaox
         oaEp1VYrnC1PiaSg0QC31DxghPvdDb6IzK6iPTn/f652STmXt6+WzF/hQ9Cqyrwc27
         XODoR5QVv4Z+uyuHaHMhmETpsl8K81JcC2vW8lbAuZBLLpy9V4U5Jzq/B+i0mnKlps
         EJpDXUnqo5TzA==
Date:   Mon, 18 Apr 2022 12:03:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 1/8] crypto: xctr - Add XCTR support
Message-ID: <Yl22DZjFe4/Ic9LM@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-2-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:09PM +0000, Nathan Huckleberry wrote:
> +// Limited to 16-byte blocks for simplicity
> +#define XCTR_BLOCKSIZE 16

Make it clear that this is talking about the current implementation, not XCTR
itself.  E.g.:

/* For now this implementation is limited to 16-byte blocks for simplicity. */
#define XCTR_BLOCKSIZE 16

> +static int crypto_xctr_crypt_segment(struct skcipher_walk *walk,
> +				    struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	u8 *src = walk->src.virt.addr;
> +	u8 *dst = walk->dst.virt.addr;

'src' can be const.

- Eric

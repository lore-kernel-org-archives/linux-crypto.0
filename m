Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30FD4C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Mar 2022 04:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiCaEaO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiCaEaH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Mar 2022 00:30:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AA647AF6;
        Wed, 30 Mar 2022 21:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0998AB81B7F;
        Thu, 31 Mar 2022 02:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE3CC3410F;
        Thu, 31 Mar 2022 02:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648695150;
        bh=8Jk5jUus/4t4unRblybctLktYNOTa1roSvaFfciGgN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nEqe6kqiUSIi2rXW5OV/rN4vS6HFQLcjj9RPpWMrqWUnO9hw6RxRCDw5RIcHqgRoo
         MK/LI9QuD8mSeRkozHMjzuZlfzATnFnoOEgAvYXD7OH+Nqmx8i1el445KwyvXTQfZZ
         8uVUMyCy4i3IUmmn8WQDVfK7YoBYV998+FE50kVs8NvZ7pEjkqt4+1cBJHFaPCx7ce
         fdAQ1SmRD6j8STJujPQJ0X2mKvtPugwCJCfbBCD1AYWM6brf4OsOsavvqW1Sxl2pNI
         wUtatK5zjm1IzFg5a35Kibe13GQnmTBboUykhIjAGa2Vu08ENY8hrYJD/FFyRVsQrU
         YOBDRiX3jk93Q==
Date:   Wed, 30 Mar 2022 19:52:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, <borisp@nvidia.com>,
        <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <vakul.garg@nxp.com>,
        <davejwatson@fb.com>, <linux-kernel@vger.kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net] net/tls: fix slab-out-of-bounds bug in
 decrypt_internal
Message-ID: <20220330195228.21616546@kernel.org>
In-Reply-To: <d7f55e84-ae87-ffd1-a488-a7bf6e65f3b1@huawei.com>
References: <20220330085009.1011614-1-william.xuanziyang@huawei.com>
        <20220330093925.2d8ee6ca@kernel.org>
        <20220330132406.633c2da8@kernel.org>
        <d7f55e84-ae87-ffd1-a488-a7bf6e65f3b1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 31 Mar 2022 10:35:41 +0800 Ziyang Xuan (William) wrote:
> I am thinking about is skb_copy_bits() necessary in non-TLS_1_3_VERSION
> and non-TLS_CIPHER_CHACHA20_POLY1305 scenarios?

It's not necessary there, but we should not make that change be part of
the fix, the fix should be minimal. I'll send a separate patch to move
the skb_copy_bits() call later on.

I think for the fix all you should do is replace the
	crypto_aead_ivsize(ctx->aead_recv));
line with
	prot->iv_size + prot->salt_size);

> If the inital iv+salt negotiated configuration for tx/rx offload is right
> and reliable, what is the reason why we have to extract the iv value from
> received skb instead if using the negotiated iv value? Does it can be
> modified or just follow spec that versions below TLS_1_3_VERSION?

TLS 1.3 does not send the nonce as part of the record. Instead 
the record number is always used as nonce in crypto.

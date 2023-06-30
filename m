Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CD7EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 08:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjF3IPl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjF3IPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 04:15:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E491997
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 01:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB2E616E7
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 08:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EBEC433C8;
        Fri, 30 Jun 2023 08:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688112938;
        bh=xFT58AgnoEdvrriMPFKIYVP3VSxYOuXQiVLAb8fkBuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtNuvpkjstdh+XtSqjulDd69wa1F83pXwB0q02RcGditu6uhdmt4jWh8L4DVV0nLN
         MYUE16jyGN4yV/7yaeKEi7RHgb4js2iiR2BdmYTcb1w7PjfC0jbiXjJzR/wB5wpRQ8
         iCaAWw8vbUomvbqr2+c5faJWOgSyq1tkIGGgX3ajb9YRyVBhnyHDcyX77y8YAn3cQc
         8TlmyC17VOOLkw87V75NOClVFsLwCN1OPZnYrmPFK1681aTbbihHE1FFopbEtpiug2
         Rh8+w0Y7o5l655cXA4ve29yTDBJ0itchVj1fZvPOYEBblKwYzsBJCOIAFRsVRYm4oa
         HjzR1iKDhT9SA==
Date:   Fri, 30 Jun 2023 01:15:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Message-ID: <20230630081536.GD36542@sol.localdomain>
References: <0000000000008a7ae505aef61db1@google.com>
 <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <20230628140317.756e61d3@kernel.org>
 <ada9b995-8d67-0375-f153-b434d48bd253@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada9b995-8d67-0375-f153-b434d48bd253@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 29, 2023 at 07:15:21AM +0900, Tetsuo Handa wrote:
> On 2023/06/29 6:03, Jakub Kicinski wrote:
> > On Wed, 28 Jun 2023 22:48:01 +0900 Tetsuo Handa wrote:
> >> syzbot is reporting uninit-value at aes_encrypt(), for block cipher assumes
> >> that bytes to encrypt/decrypt is multiple of block size for that cipher but
> >> tls_alloc_encrypted_msg() is not initializing padding bytes when
> >> required_size is not multiple of block cipher's block size.
> > 
> > Sounds odd, so crypto layer reads beyond what we submitted as 
> > the buffer? I don't think the buffer needs to be aligned, so
> > the missing bits may well fall into a different (unmapped?) page.
> 
> Since passing __GFP_ZERO to skb_page_frag_refill() hides this problem,
> I think that crypto layer is reading up to block size when requested
> size is not multiple of block size.
> 
> > 
> > This needs more careful investigation. Always zeroing the input 
> > is just covering up the real issue.
> 
> Since block cipher needs to read up to block size, someone has to initialize
> padding bytes. I guess that crypto API caller is responsible for allocating
> and initializing padding bytes, otherwise such crypto API caller will fail to
> encrypt/decrypt last partial bytes which are not multiple of cipher's block
> size.
> 
> Which function in this report is responsible for initializing padding bytes?

According to the sample crash report from
https://syzkaller.appspot.com/bug?extid=828dfc12440b4f6f305d, the uninitialized
memory access happens while the TLS layer is doing an AES-CCM encryption
operation.  CCM supports arbitrarily-aligned additional authenticated data and
plaintext/ciphertext.  Also, an encryption with crypto_aead_encrypt() reads
exactly 'assoclen + cryptlen' bytes from the 'src' scatterlist; it's not
supposed to ever go past that, even if the data isn't "block aligned".

The "aead" API (include/crypto/aead.h) is still confusing and hard to use
correctly, though, mainly because of the weird scatterlist layout it expects
with the AAD and plaintext/ciphertext concatenated to each other.  I wouldn't be
surprised if the TLS layer is making some error.  What is the exact sequence of
crypto_aead_* calls that results in this issue?

- Eric

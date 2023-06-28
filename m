Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19ABEB64D7
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jun 2023 21:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbjF1VDY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jun 2023 17:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjF1VDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2023 17:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651781BC5
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 14:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679466146A
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 21:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B592C433C0;
        Wed, 28 Jun 2023 21:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687986198;
        bh=taogyxlxQ+1K0qg3OBjrm+rufktyEbtN8eOpF9xqVs4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LFfWFIv7+YiMyacNyyYzut9KsthSQqThgNliTfbLNy4YZ+9+Ol5Ik3KRG5yVNSOGW
         76Wfao5gzVsy3J4lDOLwd6VHbBSgBiqCmLAgQuKikHqGOqhSxcegMILVA9AFFqGVzg
         NhyUQzAz4YhEN0OA4tzMM5MKDF/60+8OqpuOJBzCb1Sf0nPe0w8008JW1C7Tg+0uRr
         c9DTXcNIHuM8L+QyABiMyPjOZTNniK4x9+Rj6Exs6QAKIXxXLR84zwAG2krgiTOWFZ
         PM54kYMGxDztyH1eB6OeODcSiNUN/JCPvDHnaQIulyl+IXjiKupUlQByQhs+Uwd16j
         QjOAu8FvPd6fg==
Date:   Wed, 28 Jun 2023 14:03:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Message-ID: <20230628140317.756e61d3@kernel.org>
In-Reply-To: <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
References: <0000000000008a7ae505aef61db1@google.com>
        <20200911170150.GA889@sol.localdomain>
        <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 28 Jun 2023 22:48:01 +0900 Tetsuo Handa wrote:
> syzbot is reporting uninit-value at aes_encrypt(), for block cipher assumes
> that bytes to encrypt/decrypt is multiple of block size for that cipher but
> tls_alloc_encrypted_msg() is not initializing padding bytes when
> required_size is not multiple of block cipher's block size.

Sounds odd, so crypto layer reads beyond what we submitted as 
the buffer? I don't think the buffer needs to be aligned, so
the missing bits may well fall into a different (unmapped?) page.

This needs more careful investigation. Always zeroing the input 
is just covering up the real issue.

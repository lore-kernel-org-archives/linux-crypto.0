Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA7CC64E69
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 09:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86669206B2
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 09:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgKQJmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 04:42:22 -0500
Received: from s2.neomailbox.net ([5.148.176.60]:28642 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbgKQJmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 04:42:21 -0500
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Antonio Quartulli <antonio@openvpn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201117021839.4146-1-a@unstable.cc>
 <CAHmME9q8k26a9rn72KTfcJw0kJ0iMdob6BBsAsyYBzvfYjRtQQ@mail.gmail.com>
From:   Antonio Quartulli <a@unstable.cc>
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
Message-ID: <69c23c36-60fe-2676-d07a-67ce1f752dd1@unstable.cc>
Date:   Tue, 17 Nov 2020 10:41:10 +0100
MIME-Version: 1.0
In-Reply-To: <CAHmME9q8k26a9rn72KTfcJw0kJ0iMdob6BBsAsyYBzvfYjRtQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 17/11/2020 09:30, Jason A. Donenfeld wrote:
> Nack.
> 
> This API is meant to take simple integers, so that programmers can use
> atomic64_t with it and have safe nonces. I'm also interested in
> preserving the API's ability to safely encrypt more than 4 gigs of
> data at once. Passing a buffer also encourages people to use
> randomized nonces, which isn't really safe. Finally, there are no
> in-tree users of 96bit nonces for this interface. If you're after a
> cornucopia of compatibility primitives, the ipsec stuff might be more
> to your fitting. Or, add a new simple function/api. But adding
> complexity to users of the existing one and confusing future users of
> it is a non-starter. It's supposed to be deliberately non-awful to
> use.
> 

Thanks for explaining the ratio behind this API.

At first I thought this API wanted to take over the existing one, hence
my attempt of making it more generic and re-use it.
But I understand now this was not the goal.

I will stick to the classic crypto API then.

Best Regards,


p.s. I am curious about any use case you may have in mind for encrypting
more than 4GB in one go, as there are no users doing that right now.

-- 
Antonio Quartulli

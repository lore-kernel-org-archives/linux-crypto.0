Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5EBC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 14:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC74217D4
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 14:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfGYOoF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 10:44:05 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45690 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbfGYOoE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 10:44:04 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so36620041qkj.12;
        Thu, 25 Jul 2019 07:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=funkA3SMKZCSiaNaKD/uWvlPYKWjK7kWFho0OBB3Ohw=;
        b=bqTM/6e4M7Sa10bxlorteOQQ5A/7yDTMousTh3Sy9tTHTert2dQQI9n45/d5ea7G4t
         y4s+t1DkEKTH33qKkm5vI02gdhiGX1SVkNI6STZue3ZaQ4YHrAVLxfxmeNF6XkVDw6AA
         UwbjaA7UWpJ0jCUFvclPzFJmhR19A1QgyDUdIJD9K79ROFqQ/Z7wnwCbOmY/uvd8cb0U
         jKsu10JpyXn1VWW6MhK3FeZzLAWewsJfDx/Pnh/8l1zZhBWABts4lKsNtmDnGPzSpFU0
         nywCQvSO45DNTXIGPunXvaPDMQuAPBt2OBuM5BlF7xhF+h6U2iaFM9c6Fngox2n99IQW
         kFuA==
X-Gm-Message-State: APjAAAUriReq+1jlDSARYImORSZlAv6uKvObnExitdnjh7E/+U7HiKHT
        lKQDu6q6+9RyewcFk5+gxYnE3lGuHZAnHGneDXa22XBG
X-Google-Smtp-Source: APXvYqwLK6uX7FbbnLqPq6Bqf5v0pn5uNhnqfNQ8BRbrxD0d/isKagxy52S93HxU9iP1qyG+bsfu3S54dO/9sB5hleE=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr58280759qkc.394.1564065843402;
 Thu, 25 Jul 2019 07:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
In-Reply-To: <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 25 Jul 2019 16:43:47 +0200
Message-ID: <CAK8P3a23gnvxA3PcvFy5wadNGoCPRH7PUEY_dqJ+bk3uH5=t+g@mail.gmail.com>
Subject: Re: [RFC PATCH] rxrpc: Fix -Wframe-larger-than= warnings from
 on-stack crypto
To:     David Howells <dhowells@redhat.com>
Cc:     linux-afs@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 25, 2019 at 3:31 PM David Howells <dhowells@redhat.com> wrote:
>
> rxkad sometimes triggers a warning about oversized stack frames when
> building with clang for a 32-bit architecture:
>
> net/rxrpc/rxkad.c:243:12: error: stack frame size of 1088 bytes in function 'rxkad_secure_packet' [-Werror,-Wframe-larger-than=]
> net/rxrpc/rxkad.c:501:12: error: stack frame size of 1088 bytes in function 'rxkad_verify_packet' [-Werror,-Wframe-larger-than=]
>
> The problem is the combination of SYNC_SKCIPHER_REQUEST_ON_STACK() in
> rxkad_verify_packet()/rxkad_secure_packet() with the relatively large
> scatterlist in rxkad_verify_packet_1()/rxkad_secure_packet_encrypt().
>
> The warning does not show up when using gcc, which does not inline the
> functions as aggressively, but the problem is still the same.
>
> Allocate the cipher buffers from the slab instead, caching the allocated
> packet crypto request memory used for DATA packet crypto in the rxrpc_call
> struct.
>
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Arnd Bergmann <arnd@arndb.de>

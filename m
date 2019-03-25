Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472FEC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 00:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162A821019
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 00:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfCYAC5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Mar 2019 20:02:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44492 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfCYAC5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Mar 2019 20:02:57 -0400
Received: from localhost (unknown [50.233.106.125])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C83812DE5812;
        Sun, 24 Mar 2019 17:02:57 -0700 (PDT)
Date:   Sun, 24 Mar 2019 20:02:54 -0400 (EDT)
Message-Id: <20190324.200254.1946143057733371048.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH net-next v9 19/19] net: WireGuard secure network tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190322071122.6677-20-Jason@zx2c4.com>
References: <20190322071122.6677-1-Jason@zx2c4.com>
        <20190322071122.6677-20-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 Mar 2019 17:02:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 22 Mar 2019 01:11:22 -0600

> +static __always_inline void swap_endian(u8 *dst, const u8 *src, u8 bits)
> +{

Unless you have an absolutely requirement on inlining (if uninlined,
the compilation would break), you must not use the __always_inline
keyword and you must let the compiler decide what to do.

Said another way: "The code isn't optimal with my compiler on my computer
unless I force inline this" is not a valid reason to use __always_inline

And for this reason we never use __inline in foo.c files, always let the
compiler decide.

This applies to your entire submission.

> +		((u64 *)dst)[0] = be64_to_cpu(((const __be64 *)src)[0]);
> +		((u64 *)dst)[1] = be64_to_cpu(((const __be64 *)src)[1]);

Are 'dst' and 'src' both 64-bit aligned?  If not you'll get traps on some cpus.

> +	__skb_queue_head_init(&packets);
> +	if (!skb_is_gso(skb)) {
> +		skb->next = NULL;

Why?  Direct ->next and ->prev pointer accesses should never be used,
along with anything that assumes what the implentation of skb lists
looks like.

Always use the helpers instead.

> diff --git a/drivers/net/wireguard/hashtables.c b/drivers/net/wireguard/hashtables.c
> new file mode 100644
> index 000000000000..8aedc17b85f9
> --- /dev/null
> +++ b/drivers/net/wireguard/hashtables.c

No way.

Do not invent your own hashtables, we have several generic versions in
tree and in particular rhashtable.

If the generic kernel facilities have a weakness, fix that instead of
rolling an entire new hashtable implementation.

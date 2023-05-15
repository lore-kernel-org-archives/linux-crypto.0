Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86148C7EE22
	for <linux-crypto@archiver.kernel.org>; Mon, 15 May 2023 06:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjEOGUu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 May 2023 02:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjEOGUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 May 2023 02:20:49 -0400
X-Greylist: delayed 531 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 23:20:48 PDT
Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [IPv6:2001:41d0:203:375::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE59E99
        for <linux-crypto@vger.kernel.org>; Sun, 14 May 2023 23:20:48 -0700 (PDT)
Date:   Mon, 15 May 2023 02:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684131116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gQtZtkYSr01iPUQ02O9EobNAKFbxisOovLBX2ZmpB7g=;
        b=O9YpRD3DZPEXA9ewsr2sNqxtN7Vi/X8uluvLidZYd38LkD6FuRqZXWsgWVCxdOzOKNmXpD
        yAsKazwRFfkvObwLb+W6n0yNVX2ydTWdRJoYQPnW74kG3grbMjFO/L+6AV5QsviCIf3jwS
        JjU47Hg728g4OEulJNDfTCYZTiL6eek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     FUJITA Tomonori <tomo@exabit.dev>
Cc:     rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 1/2] rust: add synchronous message digest support
Message-ID: <ZGHNKCY/2C5buW7O@moria.home.lan>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101881db037b4-c8c941a9-c482-4759-9c07-b8bf645d96ed-000000@us-west-2.amazonses.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 15, 2023 at 04:34:27AM +0000, FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> 
> Adds abstractions for crypto shash.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers.c                  |  24 +++++++
>  rust/kernel/crypto.rs           | 108 ++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs              |   2 +

I think in the long run we're going to need Rust bindings located right
next to the .c files they're wrapping. Certainly modules will.

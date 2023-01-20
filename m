Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0B3C27C7C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 14:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjATO0h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 09:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjATO0T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 09:26:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B11269F;
        Fri, 20 Jan 2023 06:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A13761F8A;
        Fri, 20 Jan 2023 14:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3AAC433D2;
        Fri, 20 Jan 2023 14:20:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="InXIFNlL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1674224437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e7/u6Xz+Ghh5AzLpeu/oxPkoROb2gfCM3ENaGLRIflc=;
        b=InXIFNlLjoa24zR7k6w5yeL9RJHEHH3aky3LUyniu9fenU8KBrWBfv1qAqXJfwSWW796JV
        tuWLd+f98xWii6q/UCjbAFWNn/X/oNf9OnaObFDnlz9uxOJbdWAZIIdYoZCYgK3RKe6PqD
        AzWjUeUBdcbs1wy4Pyrl6qURZzIEeks=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fc1d6521 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 20 Jan 2023 14:20:36 +0000 (UTC)
Date:   Fri, 20 Jan 2023 15:20:30 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Babis Chalios <bchalios@amazon.es>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, amit@kernel.org,
        graf@amazon.de, xmarcalx@amazon.co.uk
Subject: Re: [PATCH 0/2] [RFC] virtio-rng entropy leak reporting feature
Message-ID: <Y8qjLolaLbMnDnkw@zx2c4.com>
References: <20230119184349.74072-1-bchalios@amazon.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230119184349.74072-1-bchalios@amazon.es>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Babis,

As I mentioned to you privately this week, I'm about to be out of town,
so I won't be able to look at this until I'm back in a few weeks. I
appreciate your patience.

But as a cursory look, I'm happy that you've written the hardware-side
code for this. That's a great starting point. The plumbing is not so
nice, though. This needs to be integrated more closely with random.c
itself, similar to how vmgenid works.

When I'm back in a few weeks, I'll see if I can either write a
description of what I have in mind, or simply integrate the useful
hardware work here into an expanded patch series.

[Please don't merge anything for now.]

Jason

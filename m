Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A27C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbiA0FTb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiA0FTa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:19:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4A7C06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 21:19:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19411615BD
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C67C340E4;
        Thu, 27 Jan 2022 05:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643260769;
        bh=vWfaLq/qC52SFr+J0SFQONIJabGEv3kLS5rXjzoTqk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pgXGaXr0i/TZHK9Vy0eERjKknMvG6VwAHr/WXP3oNCX3RpNwpaKWFcxUdI8ERFzWs
         9DQtngLi74fJyIGndlQ/SRQCXY0VPfqbo+AS5OoXWsy3mAalCjrfPCVCUZkXOwuvlX
         j3V1AnQc8MpVdNhJ710K3Evx/7oADXihmKXs1Plb0zZF8xMFRPxyYa+BP23u9PGLs8
         F+6Ev4NmSvaBqx6fjf+iCj3TtFmGsw+acfQkJx/UhNKq0tc3Rg2znVeCNEDelkAIAR
         B381fRajRZGb5fnykD94tkRU02uO9whHqJAaMuxF8A8S+FJYvzXxnjzWnL3wxPR8bq
         E3JQfFtnYqrFw==
Date:   Wed, 26 Jan 2022 21:19:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 2/7] crypto: polyval - Add POLYVAL support
Message-ID: <YfIrXzoKsX5TjAGY@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220125014422.80552-3-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 24, 2022 at 07:44:17PM -0600, Nathan Huckleberry wrote:
> Add support for POLYVAL, an ε-universal hash function similar to GHASH.

I think you mean ε-∆U (i.e. ε-∆-universal), as appears elsewhere in this
patchset?

> POLYVAL is used as a component to implement HCTR2 mode.
> 
> POLYVAL is implemented as an shash algorithm.  The implementation is
> modified from ghash-generic.c.
> 
> More information on POLYVAL can be found in the HCTR2 paper:
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

This commit message could use a brief mention of why POLYVAL is used instead of
GHASH, and where POLYVAL is originally from.  It is in the paper, but it's worth
emphasizing.

> diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
> new file mode 100644
> index 000000000000..63e908697ea0
> --- /dev/null
> +++ b/crypto/polyval-generic.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * POLYVAL: hash function for HCTR2.
> + *
> + * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
> + * Copyright (c) 2009 Intel Corp.
> + *   Author: Huang Ying <ying.huang@intel.com>
> + * Copyright 2021 Google LLC
> + */
> +
> +/*
> + * Code based on crypto/ghash-generic.c
> + *
> + * POLYVAL is a keyed hash function similar to GHASH. POLYVAL uses a
> + * different modulus for finite field multiplication which makes hardware
> + * accelerated implementations on little-endian machines faster.
> + *
> + * Like GHASH, POLYVAL is not a cryptographic hash function and should
> + * not be used outside of crypto modes explicitly designed to use POLYVAL.
> + *
> + */

This comment could use some more explanation about the implementation.  The code
is using the implementation trick where the multiplication is actually done
using the GHASH field, but it is not explained.  Also, it should be explained
why this implementation was chosen.  The reason that the GHASH trick is used
instead of doing a POLYVAL native implementation is because in practice, one of
the accelerated implementations will/should be used instead, right?  So this one
didn't matter much -- there just had to be a generic implementation.

There should also be a warning that this implementation isn't constant-time.

- Eric 

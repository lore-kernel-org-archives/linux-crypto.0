From: Matt Mullins <mmullins+lkml@tuxags.com>
Subject: Re: [PATCH 4.9] hw_random: Don't use a stack buffer in
 add_early_randomness()
Date: Sun, 16 Oct 2016 14:19:15 -0700
Message-ID: <20161016211915.GB18235@hydra.tuxags.com>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>,
        linux-crypto@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hydra.tuxags.com ([64.13.172.54]:50874 "EHLO mail.tuxags.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753943AbcJPVhS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Oct 2016 17:37:18 -0400
Content-Disposition: inline
In-Reply-To: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Oct 16, 2016 at 10:17:15AM -0700, Andy Lutomirski wrote:
> hw_random carefully avoids using a stack buffer except in
> add_early_randomness().  This causes a crash in virtio_rng if
> CONFIG_VMAP_STACK=y.

I hadn't noticed the existing kmalloc in the __init, for the explicit purpose
of virt_to_page().

This boots on the VM from which I had grabbed the stack trace yesterday.

Tested-by: Matt Mullins <mmullins@mmlx.us>

Looks like an extra quote snuck in your To: line, so I'm not sure if this was
distributed as widely as you intended.

Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F6DC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12152218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfAYKsT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:48:19 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44464 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:48:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz21-0005iY-Lx; Fri, 25 Jan 2019 18:48:17 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz1y-00026p-Vh; Fri, 25 Jan 2019 18:48:15 +0800
Date:   Fri, 25 Jan 2019 18:48:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Tolnay <dtolnay@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] virtio-rng: Avoid repeated init of completion
Message-ID: <20190125104814.gb44yavguk7jwswo@gondor.apana.org.au>
References: <07d66683-77b7-1f53-c9c5-24e14c2aa954@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07d66683-77b7-1f53-c9c5-24e14c2aa954@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 18, 2019 at 11:01:45AM -0800, David Tolnay wrote:
> From: David Tolnay <dtolnay@gmail.com>
> Date: Mon, 7 Jan 2019 14:36:11 -0800
> Subject: [PATCH v2] virtio-rng: Avoid repeated init of completion
> 
> The virtio-rng driver uses a completion called have_data to wait for a
> virtio read to be fulfilled by the hypervisor. The completion is reset
> before placing a buffer on the virtio queue and completed by the virtio
> callback once data has been written into the buffer.
> 
> Prior to this commit, the driver called init_completion on this
> completion both during probe as well as when registering virtio buffers
> as part of a hwrng read operation. The second of these init_completion
> calls should instead be reinit_completion because the have_data
> completion has already been inited by probe. As described in
> Documentation/scheduler/completion.txt, "Calling init_completion() twice
> on the same completion object is most likely a bug".
> 
> This bug was present in the initial implementation of virtio-rng in
> f7f510ec1957 ("virtio: An entropy device, as suggested by hpa"). Back
> then the have_data completion was a single static completion rather than
> a member of one of potentially multiple virtrng_info structs as
> implemented later by 08e53fbdb85c ("virtio-rng: support multiple
> virtio-rng devices"). The original driver incorrectly used
> init_completion rather than INIT_COMPLETION to reset have_data during
> read.
> 
> Tested by running `head -c48 /dev/random | hexdump` within crosvm, the
> Chrome OS virtual machine monitor, and confirming that the virtio-rng
> driver successfully produces random bytes from the host.
> 
> Signed-off-by: David Tolnay <dtolnay@gmail.com>
> Tested-by: David Tolnay <dtolnay@gmail.com>
> ---
>  drivers/char/hw_random/virtio-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

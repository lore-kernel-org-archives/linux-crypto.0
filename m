Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48450 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfARKnj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:43:39 -0500
Date: Fri, 18 Jan 2019 18:43:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Tolnay <dtolnay@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] virtio-rng: Avoid repeated init of completion
Message-ID: <20190118104336.j3mh5k5mefb3cvgu@gondor.apana.org.au>
References: <CAJN_sMh5v5YKJ1f0BdSjLAoBfkiYddxi7a-75SbRWT-BwGeLsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJN_sMh5v5YKJ1f0BdSjLAoBfkiYddxi7a-75SbRWT-BwGeLsQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 07, 2019 at 03:44:38PM -0800, David Tolnay wrote:
> From: David Tolnay <dtolnay@gmail.com>
> Date: Mon, 7 Jan 2019 14:36:11 -0800
> Subject: [PATCH] virtio-rng: Avoid repeated init of completion
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

Thanks, but your patch doesn't apply because it is white-space damaged.

Please resubmit.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

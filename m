From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: chacha20poly1305 - validate the digest size
Date: Fri, 22 Dec 2017 19:34:16 +1100
Message-ID: <20171222083416.GD29663@gondor.apana.org.au>
References: <94eb2c05a380bd8f2a055ffc6de5@google.com>
 <20171211201517.46407-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        davem@davemloft.net, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46178 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdLVIee (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:34:34 -0500
Content-Disposition: inline
In-Reply-To: <20171211201517.46407-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 12:15:17PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> If the rfc7539 template was instantiated with a hash algorithm with
> digest size larger than 16 bytes (POLY1305_DIGEST_SIZE), then the digest
> overran the 'tag' buffer in 'struct chachapoly_req_ctx', corrupting the
> subsequent memory, including 'cryptlen'.  This caused a crash during
> crypto_skcipher_decrypt().
> 
> Fix it by, when instantiating the template, requiring that the
> underlying hash algorithm has the digest size expected for Poly1305.
> 
> Reproducer:
> 
>     #include <linux/if_alg.h>
>     #include <sys/socket.h>
>     #include <unistd.h>
> 
>     int main()
>     {
>             int algfd, reqfd;
>             struct sockaddr_alg addr = {
>                     .salg_type = "aead",
>                     .salg_name = "rfc7539(chacha20,sha256)",
>             };
>             unsigned char buf[32] = { 0 };
> 
>             algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
>             bind(algfd, (void *)&addr, sizeof(addr));
>             setsockopt(algfd, SOL_ALG, ALG_SET_KEY, buf, sizeof(buf));
>             reqfd = accept(algfd, 0, 0);
>             write(reqfd, buf, 16);
>             read(reqfd, buf, 16);
>     }
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Fixes: 71ebc4d1b27d ("crypto: chacha20poly1305 - Add a ChaCha20-Poly1305 AEAD construction, RFC7539")
> Cc: <stable@vger.kernel.org> # v4.2+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

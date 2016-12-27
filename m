From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -resend with CC] crypto: algif_hash, avoid zero-sized
 array
Date: Tue, 27 Dec 2016 18:06:01 +0800
Message-ID: <20161227100601.GF10629@gondor.apana.org.au>
References: <20161215133101.6129-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52459 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932187AbcL0KGL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 05:06:11 -0500
Content-Disposition: inline
In-Reply-To: <20161215133101.6129-1-jslaby@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 15, 2016 at 02:31:01PM +0100, Jiri Slaby wrote:
> With this reproducer:
>   struct sockaddr_alg alg = {
>           .salg_family = 0x26,
>           .salg_type = "hash",
>           .salg_feat = 0xf,
>           .salg_mask = 0x5,
>           .salg_name = "digest_null",
>   };
>   int sock, sock2;
> 
>   sock = socket(AF_ALG, SOCK_SEQPACKET, 0);
>   bind(sock, (struct sockaddr *)&alg, sizeof(alg));
>   sock2 = accept(sock, NULL, NULL);
>   setsockopt(sock, SOL_ALG, ALG_SET_KEY, "\x9b\xca", 2);
>   accept(sock2, NULL, NULL);

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

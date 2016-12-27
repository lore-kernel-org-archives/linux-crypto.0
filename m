From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - RFC4106 can zero copy when
 !PageHighMem
Date: Tue, 27 Dec 2016 18:05:24 +0800
Message-ID: <20161227100524.GD10629@gondor.apana.org.au>
References: <1481639526-71743-1-git-send-email-ilyal@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
        davejwatson@fb.com, tls-fpga-sw-dev@mellanox.com
To: Ilya Lesokhin <ilyal@mellanox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56883 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753144AbcL0KFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 05:05:39 -0500
Content-Disposition: inline
In-Reply-To: <1481639526-71743-1-git-send-email-ilyal@mellanox.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 04:32:06PM +0200, Ilya Lesokhin wrote:
> In the common case of !PageHighMem we can do zero copy crypto
> even if sg crosses a pages boundary.
> 
> Signed-off-by: Ilya Lesokhin <ilyal@mellanox.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

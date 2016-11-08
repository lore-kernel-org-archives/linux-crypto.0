From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa: rename two rsa key files
Date: Tue, 8 Nov 2016 20:09:00 +0800
Message-ID: <20161108120900.GA5267@gondor.apana.org.au>
References: <1478240017-23117-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, jinyanjiang@gmail.com
To: yanjiang.jin@windriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478240017-23117-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> This is to eliminate the below compile error:
> 
> crypto/rsa_helper.c:19:29: fatal error: rsaprivkey-asn1.h: No such file or directory
> #include "rsaprivkey-asn1.h"
>                             ^
> compilation terminated.
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>

This patch is bogus.  The header files are meant to be generated.
Please find out why they are not being generated in your case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

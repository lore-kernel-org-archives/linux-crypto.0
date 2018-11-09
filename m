Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37394 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbeKITdc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:33:32 -0500
Date: Fri, 9 Nov 2018 17:53:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Colin King <colin.king@canonical.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcrypt: use format specifier in kobject_add
Message-ID: <20181109095332.e6nu33okzpt4wpji@gondor.apana.org.au>
References: <20181027144926.8433-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181027144926.8433-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 27, 2018 at 03:49:26PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Passing string 'name' as the format specifier is potentially hazardous
> because name could (although very unlikely to) have a format specifier
> embedded in it causing issues when parsing the non-existent arguments
> to these.  Follow best practice by using the "%s" format string for
> the string 'name'.
> 
> Cleans up clang warning:
> crypto/pcrypt.c:397:40: warning: format string is not a string literal
> (potentially insecure) [-Wformat-security]
> 
> Fixes: a3fb1e330dd2 ("pcrypt: Added sysfs interface to pcrypt")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  crypto/pcrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: tcrypt: Zero iv before freeing it
Date: Sun, 23 Apr 2017 21:11:04 +0200
Message-ID: <10591442.E9JOlzuEgW@positron.chronox.de>
References: <20170423161204.GA9489@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Codarren Velvindron <codarren@hackers.mu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59170 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163315AbdDWTLH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 15:11:07 -0400
In-Reply-To: <20170423161204.GA9489@hackers.mu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 23. April 2017, 18:12:04 CEST schrieb Codarren Velvindron:

Hi Codarren,

> Signed-off-by: Codarren Velvindron <codarren@hackers.mu>
> ---
>  crypto/tcrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 9a11f3c..48a721c 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -384,7 +384,7 @@ static void test_aead_speed(const char *algo, int enc,
> unsigned int secs, out_noaxbuf:
>  	testmgr_free_buf(xbuf);
>  out_noxbuf:
> -	kfree(iv);
> +	kzfree(iv);

Why would you think this is needed?

       if (iv_len)
              memset(iv, 0xff, iv_len);


Ciao
Stephan

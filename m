From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr: clean up memory for sensitive information
Date: Sun, 23 Apr 2017 21:08:51 +0200
Message-ID: <6071972.fa1OB9bQHi@positron.chronox.de>
References: <20170422234056.GA25272@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Pirabarlen-Cheenaramen <selven@hackers.mu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59164 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163312AbdDWTIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 15:08:55 -0400
In-Reply-To: <20170422234056.GA25272@hackers.mu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 23. April 2017, 01:40:56 CEST schrieb Pirabarlen-Cheenaramen:

Hi Pirabarlen,

> Signed-off-by: Pirabarlen-Cheenaramen <selven@hackers.mu>
> ---
>  crypto/testmgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index cd075c7..0af2e16 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -953,8 +953,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
> out_noaxbuf:
>  	testmgr_free_buf(xbuf);
>  out_noxbuf:
> -	kfree(key);
> -	kfree(iv);
> +	kzfree(key);
> +	kzfree(iv);
>  	return ret;

Hm, I do not think that key or IV are sensitive in this case.

	memcpy(key, template[i].key, template[i].klen);

	if (template[i].iv)
                        memcpy(iv, template[i].iv, iv_len);
                else
                        memset(iv, 0, MAX_IVLEN);


Ciao
Stephan

From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] crypto: asymmetric_keys: set error code on failure
Date: Mon, 12 Dec 2016 16:10:18 +0000
Message-ID: <12739.1481559018@warthog.procyon.org.uk>
References: <1480777024-7410-1-git-send-email-bianpan201602@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
To: Pan Bian <bianpan201602@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480777024-7410-1-git-send-email-bianpan201602@163.com>
Content-ID: <12738.1481559018.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Pan Bian <bianpan201602@163.com> wrote:

>  	outlen = crypto_akcipher_maxsize(tfm);
>  	output = kmalloc(outlen, GFP_KERNEL);
> -	if (!output)
> +	if (!output) {
> +		ret = -ENOMEM;
>  		goto error_free_req;
> +	}

This is preferred:

+	ret = -ENOMEM;
 	outlen = crypto_akcipher_maxsize(tfm);
 	output = kmalloc(outlen, GFP_KERNEL);
 	if (!output)
 		goto error_free_req;

I'll alter your patch.

David

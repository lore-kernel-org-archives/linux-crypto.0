From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] X.509: Fix error code in x509_cert_parse()
Date: Tue, 23 May 2017 17:49:03 +0100
Message-ID: <4045.1495558143@warthog.procyon.org.uk>
References: <20170523142717.GA28346@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170523142717.GA28346@elgon.mountain>
Content-ID: <4044.1495558143.1@warthog.procyon.org.uk>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

>  	cert->pub->key = kmemdup(ctx->key, ctx->key_size, GFP_KERNEL);
> -	if (!cert->pub->key)
> +	if (!cert->pub->key) {
> +		ret = -ENOMEM;
>  		goto error_decode;
> +	}

Put the "ret = -ENOMEM" line before the kmemdup line maybe?

David

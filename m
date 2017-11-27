From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] pkcs7: return correct error code if pkcs7_check_authattrs()
 fails
Date: Mon, 27 Nov 2017 20:54:08 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711272054000.2808@localhost>
References: <20171127071844.26106-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37879 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdK0JyS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 04:54:18 -0500
In-Reply-To: <20171127071844.26106-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 26 Nov 2017, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> If pkcs7_check_authattrs() returns an error code, we should pass that
> error code on, rather than using ENOMEM.
> 
> Fixes: 99db44350672 ("PKCS#7: Appropriately restrict authenticated attributes and content type")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index c1ca1e86f5c4..a6dcaa659aa8 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -148,8 +148,10 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
>  	}
>  
>  	ret = pkcs7_check_authattrs(ctx->msg);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		msg = ERR_PTR(ret);
>  		goto out;
> +	}
>  
>  	msg = ctx->msg;
>  	ctx->msg = NULL;


Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>

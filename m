From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] crypto: rsa - fix buffer overread when stripping leading
 zeroes
Date: Mon, 27 Nov 2017 19:22:09 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711271921511.2808@localhost>
References: <20171127071649.25800-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171127071649.25800-1-ebiggers3@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 26 Nov 2017, Eric Biggers wrote:

> Fixes: 5a7de97309f5 ("crypto: rsa - return raw integers for the ASN.1 parser")
> Cc: <stable@vger.kernel.org> # v4.8+
> Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/rsa_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index 0b66dc824606..cad395d70d78 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -30,7 +30,7 @@ int rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
>  		return -EINVAL;
>  
>  	if (fips_enabled) {
> -		while (!*ptr && n_sz) {
> +		while (n_sz && !*ptr) {
>  			ptr++;
>  			n_sz--;
>  		}



Reviewed-by: James Morris <james.l.morris@oracle.com>

-- 
James Morris
<james.l.morris@oracle.com>

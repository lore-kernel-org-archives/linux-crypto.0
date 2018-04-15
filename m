From: Martin Townsend <mtownsend1973@gmail.com>
Subject: Re: [PATCH v2] crypto: caam: Drop leading zero from input buffer
Date: Sun, 15 Apr 2018 14:52:21 +0100
Message-ID: <CABatt_zL94FcfD6JK+a8LpgT411WpFQ69tto4a12ZJOTz0pX2w@mail.gmail.com>
References: <1523790224-26083-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>, breno.lima@nxp.com,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>, stable@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1523790224-26083-1-git-send-email-festevam@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 15, 2018 at 12:03 PM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
>
> imx6ul and imx7 report the following error:
>
> caam_jr 2142000.jr1: 40000789: DECO: desc idx 7:
> Protocol Size Error - A protocol has seen an error in size. When
> running RSA, pdb size N < (size of F) when no formatting is used; or
> pdb size N < (F + 11) when formatting is used.
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at crypto/asymmetric_keys/public_key.c:148
> public_key_verify_signature+0x27c/0x2b0
>
> This error happens because the signature contains 257 bytes, including
> a leading zero as the first element.
>
> Fix the problem by stripping off the leading zero from input data
> before feeding it to the CAAM accelerator.
>
> Fixes: 8c419778ab57e497b5 ("crypto: caam - add support for RSA algorithm")
> Cc: <stable@vger.kernel.org>
> Reported-by: Martin Townsend <mtownsend1973@gmail.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
> Changes since v1:
> - Use a temp pointer
> - Assign len to req->src_len , so that more than one leading zero
> can be taken into account
>
>  drivers/crypto/caam/caampkc.c | 45 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> index 7a897209..5f3e627 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -166,6 +166,14 @@ static void rsa_priv_f3_done(struct device *dev, u32 *desc, u32 err,
>         akcipher_request_complete(req, err);
>  }
>
> +static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
> +{
> +       while (!**ptr && *nbytes) {
> +               (*ptr)++;
> +               (*nbytes)--;
> +       }
> +}
> +
>  static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
>                                          size_t desclen)
>  {
> @@ -178,7 +186,36 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
>         int sgc;
>         int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
>         int src_nents, dst_nents;
> +       const u8 *temp;
> +       void *buffer;
> +       size_t len;
> +
> +       buffer = kzalloc(req->src_len, GFP_ATOMIC);
> +       if (!buffer)
> +               return ERR_PTR(-ENOMEM);
> +
> +       sg_copy_to_buffer(req->src, sg_nents(req->src),
> +                         buffer, req->src_len);
> +       temp = (u8 *)buffer;
> +       len = req->src_len;
>
> +       /*
> +        * Check if the buffer contains leading zeros and if
> +        * it does, drop the leading zeros
> +        */
> +       if (temp[0] == 0) {
> +               caam_rsa_drop_leading_zeros(&temp, &len);

Sorry to be a pain but looking at the other use cases for
caam_rsa_drop_leading_zeros they check len afterwards which makes more
sense to me as temp being NULL after this operation is very unlikely
:) and I suppose we are trying to catch the case where the data is all
zeroes which wouldn't be a valid signature.

> +               if (!temp) {
> +                       kfree(buffer);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +
> +               req->src_len = len;
> +               sg_copy_from_buffer(req->src, sg_nents(req->src),
> +                                   (void *)temp, req->src_len);
> +       }
> +
> +       kfree(buffer);
>         src_nents = sg_nents_for_len(req->src, req->src_len);
>         dst_nents = sg_nents_for_len(req->dst, req->dst_len);
>
> @@ -683,14 +720,6 @@ static void caam_rsa_free_key(struct caam_rsa_key *key)
>         memset(key, 0, sizeof(*key));
>  }
>
> -static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
> -{
> -       while (!**ptr && *nbytes) {
> -               (*ptr)++;
> -               (*nbytes)--;
> -       }
> -}
> -
>  /**
>   * caam_read_rsa_crt - Used for reading dP, dQ, qInv CRT members.
>   * dP, dQ and qInv could decode to less than corresponding p, q length, as the
> --
> 2.7.4
>

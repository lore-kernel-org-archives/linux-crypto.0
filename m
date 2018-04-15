From: Martin Townsend <mtownsend1973@gmail.com>
Subject: Re: [PATCH] crypto: caam: Drop leading zero from input buffer
Date: Sun, 15 Apr 2018 09:01:52 +0100
Message-ID: <CABatt_zxJeHAHcZLK0JPi2Ly8RPDLEaunCPLAqnuW2i1Oviivg@mail.gmail.com>
References: <1523739000-27093-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: herbert@gondor.apana.org.au,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>, breno.lima@nxp.com,
        "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>,
        linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>, stable@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1523739000-27093-1-git-send-email-festevam@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Fabio

On Sat, Apr 14, 2018 at 9:50 PM, Fabio Estevam <festevam@gmail.com> wrote:
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
> Fix the problem by striping off the leading zero from input data
> before feeding it to the CAAM accelerator.
>
> Fixes: 8c419778ab57e497b5 ("crypto: caam - add support for RSA algorithm")
> Cc: <stable@vger.kernel.org>
> Reported-by: Martin Townsend <mtownsend1973@gmail.com>
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
> ---
>  drivers/crypto/caam/caampkc.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> index 7a897209..d2ad547 100644
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
> @@ -178,7 +186,34 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
>         int sgc;
>         int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
>         int src_nents, dst_nents;
> +       const u8 *buffer;
> +       size_t len;
> +
> +       buffer = kzalloc(req->src_len, GFP_ATOMIC);
> +       if (!buffer)
> +               return ERR_PTR(-ENOMEM);
> +
> +       sg_copy_to_buffer(req->src, sg_nents(req->src),
> +                         (void *)buffer, req->src_len);
> +       len = req->src_len;
>
> +       /*
> +        * Check if the buffer contains leading zero and if
> +        * it does, drop the leading zero
> +        */
> +       if (buffer[0] == 0) {
> +               caam_rsa_drop_leading_zeros(&buffer, &len);
> +               if (!buffer) {

This would free NULL, I would revert back to using a temp pointer
instead of passing &buffer to caam_rsa_drop_leading_zeros.
> +                       kfree(buffer);
> +                       return ERR_PTR(-ENOMEM);
> +               }
> +

I would set req->src_len to len here and then we're covered if there
are more than 1 leading zero.
> +               req->src_len -= 1;
> +               sg_copy_from_buffer(req->src, sg_nents(req->src),
> +                                   (void *)buffer, req->src_len);
> +       }
> +

If we have a leading zero buffer will now point to a different memory
location than the one allocated, using temp as above should fix this.
> +       kfree(buffer);
>         src_nents = sg_nents_for_len(req->src, req->src_len);
>         dst_nents = sg_nents_for_len(req->dst, req->dst_len);
>
> @@ -683,14 +718,6 @@ static void caam_rsa_free_key(struct caam_rsa_key *key)
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

Fixing these things I have tested the patch on my board and have not
seen any issues yet and it has booted to the prompt and I've checked
/sys/kernel/security/ima/ascii_runtime_measurements and can see all
the files that have been measured. :)

Cheers, Martin.

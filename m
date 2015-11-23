From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] crypto: nx: use of_property_read_u32()
Date: Mon, 23 Nov 2015 09:16:21 -0500
Message-ID: <CALZtONCqTg_wP9_TgKm6wevsVF7Mrrw8fYAMcRqsyOcmJ-aS+w@mail.gmail.com>
References: <1448272614-24337-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Saurabh Sengar <saurabh.truth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448272614-24337-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 23, 2015 at 4:56 AM, Saurabh Sengar <saurabh.truth@gmail.com> wrote:
> use of_propert_read_u32() for reading int value,
> it can help reducing number of variables used
>
> Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>

Acked-by: Dan Streetman <ddstreet@ieee.org>

> ---
>  drivers/crypto/nx/nx-842-powernv.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
> index 9ef51fa..87f7a0f 100644
> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -525,7 +525,6 @@ static int nx842_powernv_decompress(const unsigned char *in, unsigned int inlen,
>  static int __init nx842_powernv_probe(struct device_node *dn)
>  {
>         struct nx842_coproc *coproc;
> -       struct property *ct_prop, *ci_prop;
>         unsigned int ct, ci;
>         int chip_id;
>
> @@ -534,18 +533,16 @@ static int __init nx842_powernv_probe(struct device_node *dn)
>                 pr_err("ibm,chip-id missing\n");
>                 return -EINVAL;
>         }
> -       ct_prop = of_find_property(dn, "ibm,842-coprocessor-type", NULL);
> -       if (!ct_prop) {
> +
> +       if (of_property_read_u32(dn, "ibm,842-coprocessor-type", &ct)) {
>                 pr_err("ibm,842-coprocessor-type missing\n");
>                 return -EINVAL;
>         }
> -       ct = be32_to_cpu(*(unsigned int *)ct_prop->value);
> -       ci_prop = of_find_property(dn, "ibm,842-coprocessor-instance", NULL);
> -       if (!ci_prop) {
> +
> +       if (of_property_read_u32(dn, "ibm,842-coprocessor-instance", &ci)) {
>                 pr_err("ibm,842-coprocessor-instance missing\n");
>                 return -EINVAL;
>         }
> -       ci = be32_to_cpu(*(unsigned int *)ci_prop->value);
>
>         coproc = kmalloc(sizeof(*coproc), GFP_KERNEL);
>         if (!coproc)
> --
> 1.9.1
>

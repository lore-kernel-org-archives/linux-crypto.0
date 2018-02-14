From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [PATCH] crypto: nx-842: Delete an error message for a failed
 memory allocation in nx842_pseries_init()
Date: Wed, 14 Feb 2018 11:48:35 -0500
Message-ID: <CALZtONBqJ26mzfN02Zs8OjwuoZFLY0vz5BO9tRwyovXF11=SMw@mail.gmail.com>
References: <8261d041-ccd9-c0f8-4530-a4afb43ee7ab@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Haren Myneni <haren@us.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8261d041-ccd9-c0f8-4530-a4afb43ee7ab@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2018 at 11:17 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 14 Feb 2018 17:05:13 +0100
>
> Omit an extra message for a memory allocation failure in this function.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Dan Streetman <ddstreet@ieee.org>

> ---
>  drivers/crypto/nx/nx-842-pseries.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
> index bf52cd1d7fca..66869976cfa2 100644
> --- a/drivers/crypto/nx/nx-842-pseries.c
> +++ b/drivers/crypto/nx/nx-842-pseries.c
> @@ -1105,10 +1105,9 @@ static int __init nx842_pseries_init(void)
>
>         RCU_INIT_POINTER(devdata, NULL);
>         new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
> -       if (!new_devdata) {
> -               pr_err("Could not allocate memory for device data\n");
> +       if (!new_devdata)
>                 return -ENOMEM;
> -       }
> +
>         RCU_INIT_POINTER(devdata, new_devdata);
>
>         ret = vio_register_driver(&nx842_vio_driver);
> --
> 2.16.1
>

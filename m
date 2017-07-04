From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 1/3] crypto: hwrng use rng source with best quality
Date: Tue, 4 Jul 2017 18:47:20 +0530
Message-ID: <CANc+2y6=0d_1Mpzj2bhDVRwgOne8RPsT2KkmCAKoRCpv0104ug@mail.gmail.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com> <1499076204-18547-2-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34871 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdGDNRW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2017 09:17:22 -0400
Received: by mail-vk0-f65.google.com with SMTP id p193so13088308vkd.2
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jul 2017 06:17:21 -0700 (PDT)
In-Reply-To: <1499076204-18547-2-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3 July 2017 at 15:33, Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
> This patch rewoks the hwrng to always use the
> rng source with best entropy quality.
>
> On registation and unregistration the hwrng now
> tries to choose the best (= highest quality value)
> rng source. The handling of the internal list
> of registered rng sources is now always sorted
> by quality and the top most rng chosen.
>
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> ---
>  drivers/char/hw_random/core.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 503a41d..e9dda16 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -29,6 +29,7 @@
>
>  static struct hwrng *current_rng;
>  static struct task_struct *hwrng_fill;
> +/* list of registered rngs, sorted decending by quality */
>  static LIST_HEAD(rng_list);
>  /* Protects rng_list and current_rng */
>  static DEFINE_MUTEX(rng_mutex);
> @@ -417,6 +418,7 @@ int hwrng_register(struct hwrng *rng)
>  {
>         int err = -EINVAL;
>         struct hwrng *old_rng, *tmp;
> +       struct list_head *rng_list_ptr;
>
>         if (!rng->name || (!rng->data_read && !rng->read))
>                 goto out;
> @@ -432,14 +434,25 @@ int hwrng_register(struct hwrng *rng)
>         init_completion(&rng->cleanup_done);
>         complete(&rng->cleanup_done);
>
> +       /* rng_list is sorted by decreasing quality */
> +       list_for_each(rng_list_ptr, &rng_list) {
> +               tmp = list_entry(rng_list_ptr, struct hwrng, list);
> +               if (tmp->quality < rng->quality)
> +                       break;
> +       }
> +       list_add_tail(&rng->list, rng_list_ptr);
> +
>         old_rng = current_rng;
>         err = 0;
> -       if (!old_rng) {
> +       if (!old_rng || (rng->quality > old_rng->quality)) {
> +               /*
> +                * Set new rng as current as the new rng source
> +                * provides better entropy quality.
> +                */
>                 err = set_current_rng(rng);
>                 if (err)
>                         goto out_unlock;
>         }
> -       list_add_tail(&rng->list, &rng_list);
>
>         if (old_rng && !rng->init) {
>                 /*
> @@ -466,12 +479,12 @@ void hwrng_unregister(struct hwrng *rng)
>         list_del(&rng->list);
>         if (current_rng == rng) {
>                 drop_current_rng();
> +               /* rng_list is sorted by quality, use the best (=first) one */
>                 if (!list_empty(&rng_list)) {
> -                       struct hwrng *tail;
> -
> -                       tail = list_entry(rng_list.prev, struct hwrng, list);
> +                       struct hwrng *new_rng;
>
> -                       set_current_rng(tail);
> +                       new_rng = list_entry(rng_list.next, struct hwrng, list);
> +                       set_current_rng(new_rng);
>                 }
>         }
>
> --
> 2.7.4
>

Looks good to me.
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>.

Regards,
PrasannaKumar

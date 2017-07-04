From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/3] crypto: hwrng remember rng chosen by user
Date: Tue, 4 Jul 2017 18:48:36 +0530
Message-ID: <CANc+2y6PAsrxgJFfZfe_E1tx99nbNNgpH_qim-9Rohfwn1z+QA@mail.gmail.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com> <1499076204-18547-3-git-send-email-freude@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:36174 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdGDNSi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jul 2017 09:18:38 -0400
Received: by mail-ua0-f196.google.com with SMTP id g40so15175155uaa.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Jul 2017 06:18:37 -0700 (PDT)
In-Reply-To: <1499076204-18547-3-git-send-email-freude@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harald,

On 3 July 2017 at 15:33, Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
> When a user chooses a rng source via sysfs
> attribute this rng should be sticky, even
> when other sources with better quality to
> register. This patch introduces a simple way
> to remember the user's choise.
>
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> ---
>  drivers/char/hw_random/core.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index e9dda16..ffd4e36 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -28,6 +28,8 @@
>  #define RNG_MODULE_NAME                "hw_random"
>
>  static struct hwrng *current_rng;
> +/* the current rng has been explicitly chosen by user via sysfs */
> +static int cur_rng_set_by_user;
>  static struct task_struct *hwrng_fill;
>  /* list of registered rngs, sorted decending by quality */
>  static LIST_HEAD(rng_list);
> @@ -304,6 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>         list_for_each_entry(rng, &rng_list, list) {
>                 if (sysfs_streq(rng->name, buf)) {
>                         err = 0;
> +                       cur_rng_set_by_user = 1;
>                         if (rng != current_rng)
>                                 err = set_current_rng(rng);
>                         break;
> @@ -444,10 +447,12 @@ int hwrng_register(struct hwrng *rng)
>
>         old_rng = current_rng;
>         err = 0;
> -       if (!old_rng || (rng->quality > old_rng->quality)) {
> +       if (!old_rng ||
> +           (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
>                 /*
>                  * Set new rng as current as the new rng source
> -                * provides better entropy quality.
> +                * provides better entropy quality and was not
> +                * chosen by userspace.
>                  */
>                 err = set_current_rng(rng);
>                 if (err)
> @@ -479,6 +484,7 @@ void hwrng_unregister(struct hwrng *rng)
>         list_del(&rng->list);
>         if (current_rng == rng) {
>                 drop_current_rng();
> +               cur_rng_set_by_user = 0;
>                 /* rng_list is sorted by quality, use the best (=first) one */
>                 if (!list_empty(&rng_list)) {
>                         struct hwrng *new_rng;
> --
> 2.7.4
>

Looks good to me. Reviewed-by: PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com>.

Regards,
PrasannaKumar

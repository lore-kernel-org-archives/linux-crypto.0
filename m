From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user
 selected rng
Date: Thu, 6 Jul 2017 10:21:50 +0530
Message-ID: <CANc+2y5T-SBi_3KP3zwzVcL__U8r6tzOub7PVkbDQn---Rm9EA@mail.gmail.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
 <1499076204-18547-4-git-send-email-freude@linux.vnet.ibm.com>
 <CANc+2y4SQhDdwbV+FLda9OwQpX=2fUsvDiD1eZE0QqQp1N+_hg@mail.gmail.com> <0954fe1d-e0ff-6b35-6d2d-96901cad6503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35403 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbdGFEvw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 00:51:52 -0400
Received: by mail-ua0-f193.google.com with SMTP id j53so650763uaa.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Jul 2017 21:51:51 -0700 (PDT)
In-Reply-To: <0954fe1d-e0ff-6b35-6d2d-96901cad6503@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harald,

> Here is an updated version with just showing 0 or 1 in the new sysfs
> attribute file:
> ========== cut ==========
> From: Harald Freudenberger <freude@linux.vnet.ibm.com>
> Date: Mon, 3 Jul 2017 10:19:22 +0200
> Subject: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user selected
>  rng
>
> This patch introduces a new sysfs attribute file 'rng_selected'
> which shows if the current rng has been chosen by userspace.
>
> If a rng source is chosen by user via echo some valid string
> to rng_current there should be a way to signal this choice to
> userspace. The new attribute file 'rng_selected' shows '1' for
> user selecte rng and '0' otherwise.
>
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> ---
>  drivers/char/hw_random/core.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index ffd4e36..2b4c7f6 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -28,8 +28,8 @@
>  #define RNG_MODULE_NAME        "hw_random"
>
>  static struct hwrng *current_rng;
> -/* the current rng has been explicitly chosen by user via sysfs */
> -static int cur_rng_set_by_user;
> +/* the rng explicitly selected by user via sysfs */
> +static struct hwrng *selected_rng;
>  static struct task_struct *hwrng_fill;
>  /* list of registered rngs, sorted decending by quality */
>  static LIST_HEAD(rng_list);
> @@ -306,7 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>      list_for_each_entry(rng, &rng_list, list) {
>          if (sysfs_streq(rng->name, buf)) {
>              err = 0;
> -            cur_rng_set_by_user = 1;
> +            selected_rng = rng;
>              if (rng != current_rng)
>                  err = set_current_rng(rng);
>              break;
> @@ -355,16 +355,27 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>      return strlen(buf);
>  }
>
> +static ssize_t hwrng_attr_selected_show(struct device *dev,
> +                    struct device_attribute *attr,
> +                    char *buf)
> +{
> +    return snprintf(buf, PAGE_SIZE, "%d\n", selected_rng ? 1 : 0);
> +}
> +
>  static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
>             hwrng_attr_current_show,
>             hwrng_attr_current_store);
>  static DEVICE_ATTR(rng_available, S_IRUGO,
>             hwrng_attr_available_show,
>             NULL);
> +static DEVICE_ATTR(rng_selected, S_IRUGO,
> +           hwrng_attr_selected_show,
> +           NULL);
>
>  static struct attribute *rng_dev_attrs[] = {
>      &dev_attr_rng_current.attr,
>      &dev_attr_rng_available.attr,
> +    &dev_attr_rng_selected.attr,
>      NULL
>  };
>
> @@ -448,7 +459,7 @@ int hwrng_register(struct hwrng *rng)
>      old_rng = current_rng;
>      err = 0;
>      if (!old_rng ||
> -        (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
> +        (!selected_rng && rng->quality > old_rng->quality)) {
>          /*
>           * Set new rng as current as the new rng source
>           * provides better entropy quality and was not
> @@ -484,7 +495,7 @@ void hwrng_unregister(struct hwrng *rng)
>      list_del(&rng->list);
>      if (current_rng == rng) {
>          drop_current_rng();
> -        cur_rng_set_by_user = 0;
> +        selected_rng = NULL;
>          /* rng_list is sorted by quality, use the best (=first) one */
>          if (!list_empty(&rng_list)) {
>              struct hwrng *new_rng;
> --
> 2.7.4
> ========== cut ==========
>

Nice to see quick turn around time. Why not just use the
cur_rng_set_by_user instead of selected_rng? This way patch 3 won't
change things that patch 2 introduced and patch 3 will become much
smaller. Also I feel folding patch 3 and 2 will make sense as both are
related to user selected rng.

Regards,
PrasannaKumar

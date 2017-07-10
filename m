From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 3/3] crypto: hwrng add sysfs attribute to show user
 selected rng
Date: Mon, 10 Jul 2017 11:49:16 +0530
Message-ID: <CANc+2y7coAVgkzrVRv2WbMxFUuVsnGwXowxu5v-RVw0G8Ac9Kw@mail.gmail.com>
References: <1499076204-18547-1-git-send-email-freude@linux.vnet.ibm.com>
 <1499076204-18547-4-git-send-email-freude@linux.vnet.ibm.com>
 <CANc+2y4SQhDdwbV+FLda9OwQpX=2fUsvDiD1eZE0QqQp1N+_hg@mail.gmail.com>
 <0954fe1d-e0ff-6b35-6d2d-96901cad6503@linux.vnet.ibm.com> <CANc+2y5T-SBi_3KP3zwzVcL__U8r6tzOub7PVkbDQn---Rm9EA@mail.gmail.com>
 <2cfcef13-2315-6bbe-4eda-ee019c870ce8@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>, schwidefsky@de.ibm.com
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33954 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdGJGTS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 02:19:18 -0400
Received: by mail-vk0-f68.google.com with SMTP id 191so5570802vko.1
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 23:19:18 -0700 (PDT)
In-Reply-To: <2cfcef13-2315-6bbe-4eda-ee019c870ce8@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Harald,

> Hello PrasannaKumar
>
> here is now a version which combines patch 2 and patch 3 together
> according to your suggestions:
>
> ========== cut ==========
>
> From: Harald Freudenberger <freude@linux.vnet.ibm.com>
> Date: Fri, 30 Jun 2017 17:06:40 +0200
> Subject: [PATCH 2/2] crypto: hwrng remember rng chosen by user
>
> When a user chooses a rng source via sysfs attribute
> this rng should be sticky, even when other sources
> with better quality to register. This patch introduces
> a simple way to remember the user's choice. This is
> reflected by a new sysfs attribute file 'rng_selected'
> which shows if the current rng has been chosen by
> userspace. The new attribute file shows '1' for user
> selected rng and '0' otherwise.
>
> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> ---
>  drivers/char/hw_random/core.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index e9dda16..9701ac7 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -28,6 +28,8 @@
>  #define RNG_MODULE_NAME        "hw_random"
>
>  static struct hwrng *current_rng;
> +/* the current rng has been explicitly chosen by user via sysfs */
> +static int cur_rng_set_by_user;
>  static struct task_struct *hwrng_fill;
>  /* list of registered rngs, sorted decending by quality */
>  static LIST_HEAD(rng_list);
> @@ -304,6 +306,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>      list_for_each_entry(rng, &rng_list, list) {
>          if (sysfs_streq(rng->name, buf)) {
>              err = 0;
> +            cur_rng_set_by_user = 1;
>              if (rng != current_rng)
>                  err = set_current_rng(rng);
>              break;
> @@ -352,16 +355,27 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
>      return strlen(buf);
>  }
>
> +static ssize_t hwrng_attr_selected_show(struct device *dev,
> +                    struct device_attribute *attr,
> +                    char *buf)
> +{
> +    return snprintf(buf, PAGE_SIZE, "%d\n", cur_rng_set_by_user);
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
> @@ -444,10 +458,12 @@ int hwrng_register(struct hwrng *rng)
>
>      old_rng = current_rng;
>      err = 0;
> -    if (!old_rng || (rng->quality > old_rng->quality)) {
> +    if (!old_rng ||
> +        (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
>          /*
>           * Set new rng as current as the new rng source
> -         * provides better entropy quality.
> +         * provides better entropy quality and was not
> +         * chosen by userspace.
>           */
>          err = set_current_rng(rng);
>          if (err)
> @@ -479,6 +495,7 @@ void hwrng_unregister(struct hwrng *rng)
>      list_del(&rng->list);
>      if (current_rng == rng) {
>          drop_current_rng();
> +        cur_rng_set_by_user = 0;
>          /* rng_list is sorted by quality, use the best (=first) one */
>          if (!list_empty(&rng_list)) {
>              struct hwrng *new_rng;
> --
> 2.7.4
>
> ========== cut ==========
>

Good work, patch looks good to me. Reviewed-by: PrasannaKumar
Muralidharan <prasannatsmkumar@gmail.com>.
I am wondering if you want to make a v2 of the whole series. You can
just put your patch 1 and 2 and send it again with description.
Requiring a v2 depends on how Herbert prefers to take patches in.

Herbert, Do you prefer a v2 of the patch series or you can take this
version of patch 2?

Note: If you are re-posting this patch as v2 please add my reviewed by
tag for both the patches.

Regards,
PrasannaKumar

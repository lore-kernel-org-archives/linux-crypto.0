Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF09DC56202
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 12:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA062224C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 12:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgKMMDq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:03:46 -0500
Received: from ivanoab7.miniserver.com ([37.128.132.42]:41614 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgKMMDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 07:03:46 -0500
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1kdX4U-0003MM-90; Fri, 13 Nov 2020 11:16:50 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1kdX4R-0006Z2-SK; Fri, 13 Nov 2020 11:16:49 +0000
Subject: Re: [PATCH] um: random: register random as hwrng-core device
To:     Christopher Obbard <chris.obbard@collabora.com>,
        Richard Weinberger <richard@nod.at>,
        linux-um@lists.infradead.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
        Alexander Neville <dark@volatile.bz>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        kernel@collabora.com
References: <20201027153022.196800-1-chris.obbard@collabora.com>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <a03f0ce9-04f2-ffff-d9a3-e790667c12ed@cambridgegreys.com>
Date:   Fri, 13 Nov 2020 11:16:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201027153022.196800-1-chris.obbard@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 27/10/2020 15:30, Christopher Obbard wrote:
> The UML random driver creates a dummy device under the guest,
> /dev/hw_random. When this file is read from the guest, the driver
> reads from the host machine's /dev/random, in-turn reading from
> the host kernel's entropy pool. This entropy pool could have been
> filled by a hardware random number generator or just the host
> kernel's internal software entropy generator.
> 
> Currently the driver does not fill the guests kernel entropy pool,
> this requires a userspace tool running inside the guest (like
> rng-tools) to read from the dummy device provided by this driver,
> which then would fill the guest's internal entropy pool.
> 
> This all seems quite pointless when we are already reading from an
> entropy pool, so this patch aims to register the device as a hwrng
> device using the hwrng-core framework. This not only improves and
> cleans up the driver, but also fills the guest's entropy pool
> without having to resort to using extra userspace tools in the guest.
> 
> This is typically a nuisance when booting a guest: the random pool
> takes a long time (~200s) to build up enough entropy since the dummy
> hwrng is not used to fill the guest's pool.
> 
> This port was originally attempted by Alexander Neville "dark" (in CC,
> discussion in Link), but the conversation there stalled since the
> handling of -EAGAIN errors were no removed and longer handled by the
> driver. This patch attempts to use the existing method of error
> handling but utilises the new hwrng core.
> 
> The issue can be noticed when booting a UML guest:
> 
>      [    2.560000] random: fast init done
>      [  214.000000] random: crng init done
> 
> With the patch applied, filling the pool becomes a lot quicker:
> 
>      [    2.560000] random: fast init done
>      [   12.000000] random: crng init done
> 
> Cc: Alexander Neville <dark@volatile.bz>
> Link: https://lore.kernel.org/lkml/20190828204609.02a7ff70@TheDarkness/
> Link: https://lore.kernel.org/lkml/20190829135001.6a5ff940@TheDarkness.local/
> Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> Signed-off-by: Christopher Obbard <chris.obbard@collabora.com>
> ---
>   arch/um/drivers/random.c       | 101 ++++++++-------------------------
>   drivers/char/hw_random/Kconfig |  16 +++---
>   2 files changed, 33 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
> index ce115fce52f0..e4b9b2ce9abf 100644
> --- a/arch/um/drivers/random.c
> +++ b/arch/um/drivers/random.c
> @@ -11,6 +11,7 @@
>   #include <linux/fs.h>
>   #include <linux/interrupt.h>
>   #include <linux/miscdevice.h>
> +#include <linux/hw_random.h>
>   #include <linux/delay.h>
>   #include <linux/uaccess.h>
>   #include <init.h>
> @@ -18,9 +19,8 @@
>   #include <os.h>
>   
>   /*
> - * core module and version information
> + * core module information
>    */
> -#define RNG_VERSION "1.0.0"
>   #define RNG_MODULE_NAME "hw_random"
>   
>   /* Changed at init time, in the non-modular case, and at module load
> @@ -28,88 +28,36 @@
>    * protects against a module being loaded twice at the same time.
>    */
>   static int random_fd = -1;
> -static DECLARE_WAIT_QUEUE_HEAD(host_read_wait);
> +static struct hwrng hwrng = { 0, };
> +static DECLARE_COMPLETION(have_data);
>   
> -static int rng_dev_open (struct inode *inode, struct file *filp)
> +static int rng_dev_read(struct hwrng *rng, void *buf, size_t max, bool block)
>   {
> -	/* enforce read-only access to this chrdev */
> -	if ((filp->f_mode & FMODE_READ) == 0)
> -		return -EINVAL;
> -	if ((filp->f_mode & FMODE_WRITE) != 0)
> -		return -EINVAL;
> +	int ret;
>   
> -	return 0;
> -}
> -
> -static atomic_t host_sleep_count = ATOMIC_INIT(0);
> -
> -static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
> -			     loff_t *offp)
> -{
> -	u32 data;
> -	int n, ret = 0, have_data;
> -
> -	while (size) {
> -		n = os_read_file(random_fd, &data, sizeof(data));
> -		if (n > 0) {
> -			have_data = n;
> -			while (have_data && size) {
> -				if (put_user((u8) data, buf++)) {
> -					ret = ret ? : -EFAULT;
> -					break;
> -				}
> -				size--;
> -				ret++;
> -				have_data--;
> -				data >>= 8;
> -			}
> -		}
> -		else if (n == -EAGAIN) {
> -			DECLARE_WAITQUEUE(wait, current);
> -
> -			if (filp->f_flags & O_NONBLOCK)
> -				return ret ? : -EAGAIN;
> -
> -			atomic_inc(&host_sleep_count);
> +	for (;;) {
> +		ret = os_read_file(random_fd, buf, max);
> +		if (block && ret == -EAGAIN) {
>   			add_sigio_fd(random_fd);
>   
> -			add_wait_queue(&host_read_wait, &wait);
> -			set_current_state(TASK_INTERRUPTIBLE);
> +			ret = wait_for_completion_killable(&have_data);
>   
> -			schedule();
> -			remove_wait_queue(&host_read_wait, &wait);
> +			ignore_sigio_fd(random_fd);
> +			deactivate_fd(random_fd, RANDOM_IRQ);
>   
> -			if (atomic_dec_and_test(&host_sleep_count)) {
> -				ignore_sigio_fd(random_fd);
> -				deactivate_fd(random_fd, RANDOM_IRQ);
> -			}
> +			if (ret < 0)
> +				break;
> +		} else {
> +			break;
>   		}
> -		else
> -			return n;
> -
> -		if (signal_pending (current))
> -			return ret ? : -ERESTARTSYS;
>   	}
> -	return ret;
> -}
>   
> -static const struct file_operations rng_chrdev_ops = {
> -	.owner		= THIS_MODULE,
> -	.open		= rng_dev_open,
> -	.read		= rng_dev_read,
> -	.llseek		= noop_llseek,
> -};
> -
> -/* rng_init shouldn't be called more than once at boot time */
> -static struct miscdevice rng_miscdev = {
> -	HWRNG_MINOR,
> -	RNG_MODULE_NAME,
> -	&rng_chrdev_ops,
> -};
> +	return ret != -EAGAIN ? ret : 0;
> +}
>   
>   static irqreturn_t random_interrupt(int irq, void *data)
>   {
> -	wake_up(&host_read_wait);
> +	complete(&have_data);
>   
>   	return IRQ_HANDLED;
>   }
> @@ -126,18 +74,19 @@ static int __init rng_init (void)
>   		goto out;
>   
>   	random_fd = err;
> -
>   	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
>   			     0, "random", NULL);
>   	if (err)
>   		goto err_out_cleanup_hw;
>   
>   	sigio_broken(random_fd, 1);
> +	hwrng.name = RNG_MODULE_NAME;
> +	hwrng.read = rng_dev_read;
> +	hwrng.quality = 1024;
>   
> -	err = misc_register (&rng_miscdev);
> +	err = hwrng_register(&hwrng);
>   	if (err) {
> -		printk (KERN_ERR RNG_MODULE_NAME ": misc device register "
> -			"failed\n");
> +		pr_err(RNG_MODULE_NAME " registering failed (%d)\n", err);
>   		goto err_out_cleanup_hw;
>   	}
>   out:
> @@ -161,8 +110,8 @@ static void cleanup(void)
>   
>   static void __exit rng_cleanup(void)
>   {
> +	hwrng_unregister(&hwrng);
>   	os_close_file(random_fd);
> -	misc_deregister (&rng_miscdev);
>   }
>   
>   module_init (rng_init);
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index e92c4d9469d8..5952210526aa 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -540,15 +540,15 @@ endif # HW_RANDOM
>   
>   config UML_RANDOM
>   	depends on UML
> -	tristate "Hardware random number generator"
> +	select HW_RANDOM
> +	tristate "UML Random Number Generator support"
>   	help
>   	  This option enables UML's "hardware" random number generator.  It
>   	  attaches itself to the host's /dev/random, supplying as much entropy
>   	  as the host has, rather than the small amount the UML gets from its
> -	  own drivers.  It registers itself as a standard hardware random number
> -	  generator, major 10, minor 183, and the canonical device name is
> -	  /dev/hwrng.
> -	  The way to make use of this is to install the rng-tools package
> -	  (check your distro, or download from
> -	  http://sourceforge.net/projects/gkernel/).  rngd periodically reads
> -	  /dev/hwrng and injects the entropy into /dev/random.
> +	  own drivers. It registers itself as a rng-core driver thus providing
> +	  a device which is usually called /dev/hwrng. This hardware random
> +	  number generator does feed into the kernel's random number generator
> +	  entropy pool.
> +
> +	  If unsure, say Y.
> 

Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/

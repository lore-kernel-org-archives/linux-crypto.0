Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C860C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 08:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240082196E
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 08:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lTOI99WS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfJKIp1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 04:45:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45503 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfJKIp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 04:45:27 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20191011084524euoutp01f8bfd8b506f7840a58e24a1bdfe83c97~Mi0r33MTO2702727027euoutp01E
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 08:45:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20191011084524euoutp01f8bfd8b506f7840a58e24a1bdfe83c97~Mi0r33MTO2702727027euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1570783524;
        bh=0Ef1wHolE+gIegA/6gSP5AZmKE5HLcr9Ed6UFZWRJCk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=lTOI99WSOD5uY/s8xCMebc1PyNhrTazZo1TErvJ/zzYS5rvSvzvbbXNZ3bTBbbrd7
         RKDa41GbXVyohob6hmEFzWAhtgmnDlZf9LZSY3gaYBxRBqqVJFKwggDgJ7rVV8rWqX
         47HurhJLooaDtRLv6kUR4kVn7l083bmbpO2qP9ek=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20191011084523eucas1p2b11d4d1213ee1821c3ae9006a753637a~Mi0rsQkLj2622126221eucas1p2w;
        Fri, 11 Oct 2019 08:45:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 53.6A.04309.32140AD5; Fri, 11
        Oct 2019 09:45:23 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20191011084523eucas1p1fe003b9be75fc2fa864f0ab2bd896677~Mi0rb0CcH1301813018eucas1p1T;
        Fri, 11 Oct 2019 08:45:23 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191011084523eusmtrp1f2cf1a70a686b336cc72087d98230280~Mi0rbJWND1572715727eusmtrp1B;
        Fri, 11 Oct 2019 08:45:23 +0000 (GMT)
X-AuditID: cbfec7f4-f2e849c0000010d5-0e-5da041233ba7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2E.49.04166.32140AD5; Fri, 11
        Oct 2019 09:45:23 +0100 (BST)
Received: from [106.120.51.15] (unknown [106.120.51.15]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191011084523eusmtip1d65edad875888bece7130e05ef1cc2d8~Mi0rEEBQG2213422134eusmtip1A;
        Fri, 11 Oct 2019 08:45:23 +0000 (GMT)
Subject: Re: [PATCH] hw_random: move add_early_randomness() out of rng_mutex
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <5aec0832-e18f-a557-3614-33970bc4ff1f@samsung.com>
Date:   Fri, 11 Oct 2019 10:45:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
        Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190912133022.14870-1-lvivier@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsWy7djPc7rKjgtiDU71WFh0v5KxuH/vJ5PF
        5V1z2CxmnN/HZPGpQcpiwbY+Rgc2j20HVD3e77vK5tH3cgOjx+dNcgEsUVw2Kak5mWWpRfp2
        CVwZl298YSmY7F7x+fI95gbGP5ZdjJwcEgImEjOWTWHsYuTiEBJYwSjxr/cvC4TzhVGisfEe
        E4TzmVFizZPZTDAtNzrXM0MkljNKrFy/Hcp5yyhx8OwJZpAqYQEfiWenz4N1iAi4Srzetx5s
        FDNIx6IjW8ASbAKGEl1vu9hAbF4BO4klXz+CNbMIqErM+TOFHcQWFYiVuPfjODNEjaDEyZlP
        WEBsTgELieZp98BsZgF5ieats5khbHGJW0/mQ506j13i9LowCNtF4vKLNjYIW1ji1fEt7BC2
        jMTpyT1gT0sINDNKPDy3lh3C6WGUuNw0gxGiylri8PGLrF2MHEAbNCXW79KHCDtKfDu5hhEk
        LCHAJ3HjrSDEDXwSk7ZNZ4YI80p0tAlBVKtJzDq+Dm7twQuXmCcwKs1C8tksJN/MQvLNLIS9
        CxhZVjGKp5YW56anFhvlpZbrFSfmFpfmpesl5+duYgQmm9P/jn/ZwbjrT9IhRgEORiUe3hny
        82OFWBPLiitzDzFKcDArifAumjUnVog3JbGyKrUoP76oNCe1+BCjNAeLkjhvNcODaCGB9MSS
        1OzU1ILUIpgsEwenVANj5V6enpfZPg7f9rKtN+8WmbieYfJkRTaJ2a6Pz/+dwLRk8ZfGplT5
        7xs/xDf8XdLN2/w7e/PGNBtj2dU+wf6+sxO+W19d3nK1pXP+8oqKktTVdwqZ3yneYJ+0qf5K
        B89qu9P79Hq7nK+Ip27Mk0+dE/A/VFx1bk5YZMEv6XqrcubXj09zfZivxFKckWioxVxUnAgA
        XIha6DIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xu7rKjgtiDb4cVbPofiVjcf/eTyaL
        y7vmsFnMOL+PyeJTg5TFgm19jA5sHtsOqHq833eVzaPv5QZGj8+b5AJYovRsivJLS1IVMvKL
        S2yVog0tjPQMLS30jEws9QyNzWOtjEyV9O1sUlJzMstSi/TtEvQyLt/4wlIw2b3i8+V7zA2M
        fyy7GDk5JARMJG50rmfuYuTiEBJYyijRebCDFSIhI3FyWgOULSzx51oXG4gtJPCaUaJlVwaI
        LSzgI/Hs9HkmEFtEwFXi9b71TCCDmAWWM0qcffscqsFcYummo8wgNpuAoUTXW4hBvAJ2Eku+
        fgSLswioSsz5M4W9i5GDQ1QgVmLTXjOIEkGJkzOfsIDYnAIWEs3T7oHZzAJmEvM2P2SGsOUl
        mrfOhrLFJW49mc80gVFoFpL2WUhaZiFpmYWkZQEjyypGkdTS4tz03GJDveLE3OLSvHS95Pzc
        TYzAyNp27OfmHYyXNgYfYhTgYFTi4f2gOD9WiDWxrLgy9xCjBAezkgjvollzYoV4UxIrq1KL
        8uOLSnNSiw8xmgL9NpFZSjQ5Hxj1eSXxhqaG5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1ML
        Uotg+pg4OKUaGDv33kkRn6u9TfxavbisAVvCIhcu30SPWZynZ3LUJEy41Le4pF1XK6DnxBpp
        lVWL5/5Yn689d4HO7Q2C1X/OvesR9bI6FZ3zb4XfkSUnrvD3zZ2n/sWm0uz6mVXXeAUbl3DN
        3d+zeJuUt1PiviWybXwqzdu7rGUnr5vxXT0y4oyJ+1tR1Wn+b5RYijMSDbWYi4oTAeUG+nrC
        AgAA
X-CMS-MailID: 20191011084523eucas1p1fe003b9be75fc2fa864f0ab2bd896677
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20191011084523eucas1p1fe003b9be75fc2fa864f0ab2bd896677
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20191011084523eucas1p1fe003b9be75fc2fa864f0ab2bd896677
References: <20190912133022.14870-1-lvivier@redhat.com>
        <CGME20191011084523eucas1p1fe003b9be75fc2fa864f0ab2bd896677@eucas1p1.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Laurent,

On 12.09.2019 15:30, Laurent Vivier wrote:
> add_early_randomness() is called every time a new rng backend is added
> and every time it is set as the current rng provider.
>
> add_early_randomness() is called from functions locking rng_mutex,
> and if it hangs all the hw_random framework hangs: we can't read sysfs,
> add or remove a backend.
>
> This patch move add_early_randomness() out of the rng_mutex zone.
> It only needs the reading_mutex.
>
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>

This patch landed in today's linux-next and causes the following warning 
on ARM 32bit Exynos5420-based Chromebook Peach-Pit board:

tpm_i2c_infineon 9-0020: 1.2 TPM (device-id 0x1A)
------------[ cut here ]------------
WARNING: CPU: 3 PID: 1 at lib/refcount.c:156 hwrng_register+0x13c/0x1b4
refcount_t: increment on 0; use-after-free.
Modules linked in:
CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc1-00061-gdaae28debcb0 
#6714
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[<c01124c8>] (unwind_backtrace) from [<c010dfb8>] (show_stack+0x10/0x14)
[<c010dfb8>] (show_stack) from [<c0ae86d8>] (dump_stack+0xa8/0xd4)
[<c0ae86d8>] (dump_stack) from [<c0127428>] (__warn+0xf4/0x10c)
[<c0127428>] (__warn) from [<c01274b4>] (warn_slowpath_fmt+0x74/0xb8)
[<c01274b4>] (warn_slowpath_fmt) from [<c054729c>] 
(hwrng_register+0x13c/0x1b4)
[<c054729c>] (hwrng_register) from [<c0547e54>] 
(tpm_chip_register+0xc4/0x274)
[<c0547e54>] (tpm_chip_register) from [<c055028c>] 
(tpm_tis_i2c_probe+0x138/0x1a0)
[<c055028c>] (tpm_tis_i2c_probe) from [<c07324b0>] 
(i2c_device_probe+0x230/0x2a4)
[<c07324b0>] (i2c_device_probe) from [<c05c1884>] (really_probe+0x1c4/0x48c)
[<c05c1884>] (really_probe) from [<c05c1d20>] 
(driver_probe_device+0x78/0x1f8)
[<c05c1d20>] (driver_probe_device) from [<c05bf7cc>] 
(bus_for_each_drv+0x74/0xb8)
[<c05bf7cc>] (bus_for_each_drv) from [<c05c1620>] 
(__device_attach+0xd4/0x16c)
[<c05c1620>] (__device_attach) from [<c05c0790>] 
(bus_probe_device+0x88/0x90)
[<c05c0790>] (bus_probe_device) from [<c05bdff8>] (device_add+0x478/0x62c)
[<c05bdff8>] (device_add) from [<c0734928>] 
(i2c_new_client_device+0x158/0x278)
[<c0734928>] (i2c_new_client_device) from [<c0734a50>] 
(i2c_new_device+0x8/0x14)
[<c0734a50>] (i2c_new_device) from [<c0738014>] 
(of_i2c_register_devices+0xf4/0x16c)
[<c0738014>] (of_i2c_register_devices) from [<c0734f34>] 
(i2c_register_adapter+0x180/0x458)
[<c0734f34>] (i2c_register_adapter) from [<c073b6c0>] 
(exynos5_i2c_probe+0x22c/0x28c)
[<c073b6c0>] (exynos5_i2c_probe) from [<c05c410c>] 
(platform_drv_probe+0x6c/0xa4)
[<c05c410c>] (platform_drv_probe) from [<c05c1884>] 
(really_probe+0x1c4/0x48c)
[<c05c1884>] (really_probe) from [<c05c1d20>] 
(driver_probe_device+0x78/0x1f8)
[<c05c1d20>] (driver_probe_device) from [<c05c2104>] 
(device_driver_attach+0x58/0x60)
[<c05c2104>] (device_driver_attach) from [<c05c21e8>] 
(__driver_attach+0xdc/0x174)
[<c05c21e8>] (__driver_attach) from [<c05bf6f8>] 
(bus_for_each_dev+0x68/0xb4)
[<c05bf6f8>] (bus_for_each_dev) from [<c05c0a2c>] 
(bus_add_driver+0x158/0x214)
[<c05c0a2c>] (bus_add_driver) from [<c05c30bc>] (driver_register+0x78/0x110)
[<c05c30bc>] (driver_register) from [<c0103214>] 
(do_one_initcall+0x8c/0x424)
[<c0103214>] (do_one_initcall) from [<c1001080>] 
(kernel_init_freeable+0x158/0x200)
[<c1001080>] (kernel_init_freeable) from [<c0b036a8>] 
(kernel_init+0x8/0x114)
[<c0b036a8>] (kernel_init) from [<c01010b4>] (ret_from_fork+0x14/0x20)
Exception stack(0xe88e1fb0 to 0xe88e1ff8)
1fa0:                                     00000000 00000000 00000000 
00000000
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
00000000
1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
irq event stamp: 296027
hardirqs last  enabled at (296157): [<c0b0bce8>] 
_raw_spin_unlock_irq+0x24/0x5c
hardirqs last disabled at (296180): [<c0b04030>] __schedule+0xd8/0x7b8
softirqs last  enabled at (296176): [<c01026bc>] __do_softirq+0x4fc/0x5fc
softirqs last disabled at (296197): [<c012fff4>] irq_exit+0x16c/0x170
---[ end trace d219e40773096999 ]---

If you need any help testing a fix for this issue, let me know.


> ---
>   drivers/char/hw_random/core.c | 60 +++++++++++++++++++++++++----------
>   1 file changed, 44 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 9044d31ab1a1..745ace6fffd7 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -111,6 +111,14 @@ static void drop_current_rng(void)
>   }
>   
>   /* Returns ERR_PTR(), NULL or refcounted hwrng */
> +static struct hwrng *get_current_rng_nolock(void)
> +{
> +	if (current_rng)
> +		kref_get(&current_rng->ref);
> +
> +	return current_rng;
> +}
> +
>   static struct hwrng *get_current_rng(void)
>   {
>   	struct hwrng *rng;
> @@ -118,9 +126,7 @@ static struct hwrng *get_current_rng(void)
>   	if (mutex_lock_interruptible(&rng_mutex))
>   		return ERR_PTR(-ERESTARTSYS);
>   
> -	rng = current_rng;
> -	if (rng)
> -		kref_get(&rng->ref);
> +	rng = get_current_rng_nolock();
>   
>   	mutex_unlock(&rng_mutex);
>   	return rng;
> @@ -155,8 +161,6 @@ static int hwrng_init(struct hwrng *rng)
>   	reinit_completion(&rng->cleanup_done);
>   
>   skip_init:
> -	add_early_randomness(rng);
> -
>   	current_quality = rng->quality ? : default_quality;
>   	if (current_quality > 1024)
>   		current_quality = 1024;
> @@ -320,12 +324,13 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>   					const char *buf, size_t len)
>   {
>   	int err = -ENODEV;
> -	struct hwrng *rng;
> +	struct hwrng *rng, *old_rng, *new_rng;
>   
>   	err = mutex_lock_interruptible(&rng_mutex);
>   	if (err)
>   		return -ERESTARTSYS;
>   
> +	old_rng = current_rng;
>   	if (sysfs_streq(buf, "")) {
>   		err = enable_best_rng();
>   	} else {
> @@ -337,9 +342,15 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>   			}
>   		}
>   	}
> -
> +	new_rng = get_current_rng_nolock();
>   	mutex_unlock(&rng_mutex);
>   
> +	if (new_rng) {
> +		if (new_rng != old_rng)
> +			add_early_randomness(new_rng);
> +		put_rng(new_rng);
> +	}
> +
>   	return err ? : len;
>   }
>   
> @@ -457,13 +468,17 @@ static void start_khwrngd(void)
>   int hwrng_register(struct hwrng *rng)
>   {
>   	int err = -EINVAL;
> -	struct hwrng *old_rng, *tmp;
> +	struct hwrng *old_rng, *new_rng, *tmp;
>   	struct list_head *rng_list_ptr;
>   
>   	if (!rng->name || (!rng->data_read && !rng->read))
>   		goto out;
>   
>   	mutex_lock(&rng_mutex);
> +
> +	old_rng = current_rng;
> +	new_rng = NULL;
> +
>   	/* Must not register two RNGs with the same name. */
>   	err = -EEXIST;
>   	list_for_each_entry(tmp, &rng_list, list) {
> @@ -482,7 +497,6 @@ int hwrng_register(struct hwrng *rng)
>   	}
>   	list_add_tail(&rng->list, rng_list_ptr);
>   
> -	old_rng = current_rng;
>   	err = 0;
>   	if (!old_rng ||
>   	    (!cur_rng_set_by_user && rng->quality > old_rng->quality)) {
> @@ -496,19 +510,24 @@ int hwrng_register(struct hwrng *rng)
>   			goto out_unlock;
>   	}
>   
> -	if (old_rng && !rng->init) {
> +	new_rng = rng;
> +	kref_get(&new_rng->ref);
> +out_unlock:
> +	mutex_unlock(&rng_mutex);
> +
> +	if (new_rng) {
> +		if (new_rng != old_rng || !rng->init) {
>   		/*
>   		 * Use a new device's input to add some randomness to
>   		 * the system.  If this rng device isn't going to be
>   		 * used right away, its init function hasn't been
> -		 * called yet; so only use the randomness from devices
> -		 * that don't need an init callback.
> +		 * called yet by set_current_rng(); so only use the
> +		 * randomness from devices that don't need an init callback
>   		 */
> -		add_early_randomness(rng);
> +			add_early_randomness(new_rng);
> +		}
> +		put_rng(new_rng);
>   	}
> -
> -out_unlock:
> -	mutex_unlock(&rng_mutex);
>   out:
>   	return err;
>   }
> @@ -516,10 +535,12 @@ EXPORT_SYMBOL_GPL(hwrng_register);
>   
>   void hwrng_unregister(struct hwrng *rng)
>   {
> +	struct hwrng *old_rng, *new_rng;
>   	int err;
>   
>   	mutex_lock(&rng_mutex);
>   
> +	old_rng = current_rng;
>   	list_del(&rng->list);
>   	if (current_rng == rng) {
>   		err = enable_best_rng();
> @@ -529,6 +550,7 @@ void hwrng_unregister(struct hwrng *rng)
>   		}
>   	}
>   
> +	new_rng = get_current_rng_nolock();
>   	if (list_empty(&rng_list)) {
>   		mutex_unlock(&rng_mutex);
>   		if (hwrng_fill)
> @@ -536,6 +558,12 @@ void hwrng_unregister(struct hwrng *rng)
>   	} else
>   		mutex_unlock(&rng_mutex);
>   
> +	if (new_rng) {
> +		if (old_rng != new_rng)
> +			add_early_randomness(new_rng);
> +		put_rng(new_rng);
> +	}
> +
>   	wait_for_completion(&rng->cleanup_done);
>   }
>   EXPORT_SYMBOL_GPL(hwrng_unregister);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


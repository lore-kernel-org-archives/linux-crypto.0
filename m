Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEF3C25B50
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 12:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjATMdl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 07:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjATMdk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 07:33:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA02C656
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 04:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674217965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OsnA5kxHRbbvBoJCybult9E8G7jO5iy0mNgQ7K6U6PI=;
        b=KQqog7oMPumonVK7EsCfIU5g9McphyoKNtfHnwQyROFVUxQgKi+Kb/NcTlpi7gMWF95KLG
        7n8cjMO0021zHsUomU1Lr04AELuwItxQDTOdhlqFwmOFor7h4qvTE8biu2BhSY7ao6rlnT
        dRz2Upxmh3amOXjFExIdBN73G1XxScQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-ofB-f7qJN1uyYJyhv55p_w-1; Fri, 20 Jan 2023 07:32:43 -0500
X-MC-Unique: ofB-f7qJN1uyYJyhv55p_w-1
Received: by mail-wr1-f71.google.com with SMTP id o15-20020a5d684f000000b002be540246e1so342905wrw.22
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 04:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsnA5kxHRbbvBoJCybult9E8G7jO5iy0mNgQ7K6U6PI=;
        b=C2KWI7otJ9N1jjO8mpGu9bbyvd6ERX7qrgYhJht2BHbMUZHHW+L5uhZ7ygPtzlJW+k
         Df3irLZ3yEANnWTAkQ5ZMJd5PczGZ6eePggMCfXZNpm0ygN4KQ5XoZIuvN2hCVDJge4r
         nZ93TCeo+yI8vx5b/tLt3XU8ol7jcSHSjeWxkrwq3rhKYpf3fgvTUaPFQp1SGyfp1BmG
         QbVZAD8FB62IWQL055SkZaSItBuGUgxOXZ2LNrBiyI+oEKvhIWxKjX39G1X6qZOjVV7B
         rp0es2Jhbo5Tqjzydfvc05eVY9KkASESn8c7We8niy15RyCmPLmZatI3XQnXfeBvDjXs
         WgnA==
X-Gm-Message-State: AFqh2kpFJ3LDc4GnmdvJpGd7vFp7Qzyf8n61hVRr09YQ7TU1IEifEgyL
        JYWJknIfqnSn3/G0ja0I42Jqskq47vAKlReXmoN/vJcgtQsS0gYbzPAXRnpE33fldhQbtYQa4Ak
        zdxlt/q+Jt7OJxX//TVGeOr4e
X-Received: by 2002:a05:6000:689:b0:2bb:b17e:789 with SMTP id bo9-20020a056000068900b002bbb17e0789mr14593255wrb.58.1674217959850;
        Fri, 20 Jan 2023 04:32:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsSnZrosVuccCBK2otmYGPDXTzQAyx1OFQYANyIFSkVQQMgKzy4ZIAFWqdAnDobRxwHneih3w==
X-Received: by 2002:a05:6000:689:b0:2bb:b17e:789 with SMTP id bo9-20020a056000068900b002bbb17e0789mr14593233wrb.58.1674217959534;
        Fri, 20 Jan 2023 04:32:39 -0800 (PST)
Received: from redhat.com ([2.52.19.29])
        by smtp.gmail.com with ESMTPSA id l29-20020adfa39d000000b002bf95500254sm157750wrb.64.2023.01.20.04.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:32:38 -0800 (PST)
Date:   Fri, 20 Jan 2023 07:32:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Babis Chalios <bchalios@amazon.es>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, amit@kernel.org,
        graf@amazon.de, Jason@zx2c4.com, xmarcalx@amazon.co.uk
Subject: Re: [PATCH 1/2] virtio-rng: implement entropy leak feature
Message-ID: <20230120072909-mutt-send-email-mst@kernel.org>
References: <20230119184349.74072-1-bchalios@amazon.es>
 <20230119184349.74072-2-bchalios@amazon.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119184349.74072-2-bchalios@amazon.es>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 19, 2023 at 07:43:47PM +0100, Babis Chalios wrote:
> Implement the virtio-rng feature that allows a guest driver to request
> from the device to perform certain operations in the event of an
> "entropy leak", such as when taking a VM snapshot or restoring a VM from
> a snapshot. The guest can request one of two operations: (i) fill a
> buffer with random bytes, or (ii) perform a memory copy between two
> bytes.
> 
> The feature is similar to Microsoft's Virtual Machine Generation ID and
> it can be used to (1) avoid the race-condition that exists in our
> current VMGENID implementation, between the time vcpus are resumed and
> the ACPI notification is being handled and (2) provide mechanisms for
> notifying user-space about snapshot-related events.
> 
> This commit implements the protocol between guest and device.
> Additionally, it makes sure there is always a request for random bytes
> in the event of entropy leak in-flight. Once such an event is observed,
> the driver feeds these bytes to as entropy using
> `add_device_randomness`.
> 
> Keep in mind that this commit does not solve the race-condition issue,
> it adds fresh entropy whenever the driver handles the used buffer from
> the fill-on-leak request. In order to close the race window, we need to
> expose some API so that other kernel subsystems can request directly
> notifications from the device.
> 
> Signed-off-by: Babis Chalios <bchalios@amazon.es>
> ---
>  drivers/char/hw_random/virtio-rng.c | 200 +++++++++++++++++++++++++++-
>  include/uapi/linux/virtio_rng.h     |   3 +
>  2 files changed, 197 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index a6f3a8a2aca6..389a091a8801 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -4,12 +4,14 @@
>   *  Copyright (C) 2007, 2008 Rusty Russell IBM Corporation
>   */
>  
> +#include "asm-generic/errno.h"

Why are you pulling this in?
If you really need errno the thing to include
is linux/errno.h

checkpatch has a rule to catch such cases:

# warn if <asm/foo.h> is #included and <linux/foo.h> is available and includes
# itself <asm/foo.h> (uses RAW line)    

did you run checkpatch?


>  #include <linux/err.h>
>  #include <linux/hw_random.h>
>  #include <linux/scatterlist.h>
>  #include <linux/spinlock.h>
>  #include <linux/virtio.h>
>  #include <linux/virtio_rng.h>
> +#include <linux/random.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  
> @@ -18,6 +20,12 @@ static DEFINE_IDA(rng_index_ida);
>  struct virtrng_info {
>  	struct hwrng hwrng;
>  	struct virtqueue *vq;
> +	/* Leak queues */
> +	bool has_leakqs;
> +	struct virtqueue *leakq[2];
> +	spinlock_t lock;
> +	int active_leakq;
> +
>  	char name[25];
>  	int index;
>  	bool hwrng_register_done;
> @@ -29,27 +37,159 @@ struct virtrng_info {
>  	/* minimal size returned by rng_buffer_size() */
>  #if SMP_CACHE_BYTES < 32
>  	u8 data[32];
> +	u8 leak_data[32];
>  #else
>  	u8 data[SMP_CACHE_BYTES];
> +	u8 leak_data[SMP_CACHE_BYTES];
>  #endif
>  };
>  
> +/* Swaps the queues and returns the new active leak queue. */
> +static struct virtqueue *swap_leakqs(struct virtrng_info *vi)
> +{
> +	vi->active_leakq = 1 - vi->active_leakq;
> +	return vi->leakq[vi->active_leakq];
> +}
> +
> +static struct virtqueue *get_active_leakq(struct virtrng_info *vi)
> +{
> +	return vi->leakq[vi->active_leakq];
> +}
> +
> +int add_fill_on_leak_request(struct virtrng_info *vi, struct virtqueue *vq, void *data, size_t len)
> +{
> +	struct scatterlist sg;
> +	int ret;
> +
> +	sg_init_one(&sg, data, len);
> +	ret = virtqueue_add_inbuf(vq, &sg, 1, data, GFP_KERNEL);
> +	if (ret)
> +		goto err;
> +
> +err:
> +	return ret;
> +}
> +
> +int virtrng_fill_on_leak(struct virtrng_info *vi, void *data, size_t len)
> +{
> +	struct virtqueue *vq;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!vi->has_leakqs)
> +		return -EOPNOTSUPP;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +
> +	vq = get_active_leakq(vi);
> +	ret = add_fill_on_leak_request(vi, vq, data, len);
> +	if (ret)
> +		virtqueue_kick(vq);
> +
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +
> +	return ret;
> +}
> +
> +int add_copy_on_leak_request(struct virtrng_info *vi, struct virtqueue *vq,
> +		void *to, void *from, size_t len)
> +{
> +	int ret;
> +	struct scatterlist out, in, *sgs[2];
> +
> +	sg_init_one(&out, from, len);
> +	sgs[0] = &out;
> +	sg_init_one(&in, to, len);
> +	sgs[1] = &in;
> +
> +	ret = virtqueue_add_sgs(vq, sgs, 1, 1, to, GFP_KERNEL);
> +	if (ret)
> +		goto err;
> +
> +err:
> +	return ret;
> +}
> +
> +int virtrng_copy_on_leak(struct virtrng_info *vi, void *to, void *from, size_t len)
> +{
> +	struct virtqueue *vq;
> +	unsigned long flags;
> +	int ret;
> +
> +	if (!vi->has_leakqs)
> +		return -EOPNOTSUPP;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +
> +	vq = get_active_leakq(vi);
> +	ret = add_copy_on_leak_request(vi, vq, to, from, len);
> +	if (ret)
> +		virtqueue_kick(vq);
> +
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +
> +	return ret;
> +}
> +
> +static void entropy_leak_detected(struct virtqueue *vq)
> +{
> +	struct virtrng_info *vi = vq->vdev->priv;
> +	struct virtqueue *activeq;
> +	unsigned int len;
> +	unsigned long flags;
> +	void *buffer;
> +	bool kick_activeq = false;
> +
> +	spin_lock_irqsave(&vi->lock, flags);
> +
> +	activeq = get_active_leakq(vi);
> +	/* Drain all the used buffers from the queue */
> +	while ((buffer = virtqueue_get_buf(vq, &len)) != NULL) {
> +		if (vq == activeq) {
> +			pr_debug("%s: entropy leak detected!", vi->name);
> +			activeq = swap_leakqs(vi);
> +		}
> +
> +		if (buffer == vi->leak_data) {
> +			add_device_randomness(vi->leak_data, sizeof(vi->leak_data));
> +
> +			/* Ensure we always have a pending request for random bytes on entropy
> +			 * leak. Do it here, after we have swapped leak queues, so it gets handled
> +			 * with the next entropy leak event.
> +			 */
> +			add_fill_on_leak_request(vi, activeq, vi->leak_data, sizeof(vi->leak_data));
> +			kick_activeq = true;
> +		}
> +	}
> +
> +	if (kick_activeq)
> +		virtqueue_kick(activeq);
> +
> +	spin_unlock_irqrestore(&vi->lock, flags);
> +}
> +
>  static void random_recv_done(struct virtqueue *vq)
>  {
>  	struct virtrng_info *vi = vq->vdev->priv;
> +	unsigned long flags;
>  
> +	spin_lock_irqsave(&vi->lock, flags);
>  	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
>  	if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
> -		return;
> +		goto unlock;
>  
>  	vi->data_idx = 0;
>  
>  	complete(&vi->have_data);
> +
> +unlock:
> +	spin_unlock_irqrestore(&vi->lock, flags);
>  }
>  
>  static void request_entropy(struct virtrng_info *vi)
>  {
>  	struct scatterlist sg;
> +	unsigned long flags;
>  
>  	reinit_completion(&vi->have_data);
>  	vi->data_avail = 0;
> @@ -57,10 +197,12 @@ static void request_entropy(struct virtrng_info *vi)
>  
>  	sg_init_one(&sg, vi->data, sizeof(vi->data));
>  
> +	spin_lock_irqsave(&vi->lock, flags);
>  	/* There should always be room for one buffer. */
>  	virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);
>  
>  	virtqueue_kick(vi->vq);
> +	spin_unlock_irqrestore(&vi->lock, flags);
>  }
>  
>  static unsigned int copy_data(struct virtrng_info *vi, void *buf,
> @@ -126,6 +268,40 @@ static void virtio_cleanup(struct hwrng *rng)
>  	complete(&vi->have_data);
>  }
>  
> +static int init_virtqueues(struct virtrng_info *vi, struct virtio_device *vdev)
> +{
> +	int ret = -ENOMEM, total_vqs = 1;
> +	struct virtqueue *vqs[3];
> +	const char *names[3];
> +	vq_callback_t *callbacks[3];
> +
> +	if (vi->has_leakqs)
> +		total_vqs = 3;
> +
> +	callbacks[0] = random_recv_done;
> +	names[0] = "input";
> +	if (vi->has_leakqs) {
> +		callbacks[1] = entropy_leak_detected;
> +		names[1] = "leakq.1";
> +		callbacks[2] = entropy_leak_detected;
> +		names[2] = "leakq.2";
> +	}
> +
> +	ret = virtio_find_vqs(vdev, total_vqs, vqs, callbacks, names, NULL);
> +	if (ret)
> +		goto err;
> +
> +	vi->vq = vqs[0];
> +
> +	if (vi->has_leakqs) {
> +		vi->leakq[0] = vqs[1];
> +		vi->leakq[1] = vqs[2];
> +	}
> +
> +err:
> +	return ret;
> +}
> +
>  static int probe_common(struct virtio_device *vdev)
>  {
>  	int err, index;
> @@ -152,18 +328,24 @@ static int probe_common(struct virtio_device *vdev)
>  	};
>  	vdev->priv = vi;
>  
> -	/* We expect a single virtqueue. */
> -	vi->vq = virtio_find_single_vq(vdev, random_recv_done, "input");
> -	if (IS_ERR(vi->vq)) {
> -		err = PTR_ERR(vi->vq);
> -		goto err_find;
> +	vi->has_leakqs = virtio_has_feature(vdev, VIRTIO_RNG_F_LEAK);
> +	if (vi->has_leakqs) {
> +		spin_lock_init(&vi->lock);
> +		vi->active_leakq = 0;
>  	}
>  
> +	err = init_virtqueues(vi, vdev);
> +	if (err)
> +		goto err_find;
> +
>  	virtio_device_ready(vdev);
>  
>  	/* we always have a pending entropy request */
>  	request_entropy(vi);
>  
> +	/* we always have a fill_on_leak request pending */
> +	virtrng_fill_on_leak(vi, vi->leak_data, sizeof(vi->leak_data));
> +
>  	return 0;
>  
>  err_find:
> @@ -246,7 +428,13 @@ static const struct virtio_device_id id_table[] = {
>  	{ 0 },
>  };
>  
> +static unsigned int features[] = {
> +	VIRTIO_RNG_F_LEAK,
> +};
> +
>  static struct virtio_driver virtio_rng_driver = {
> +	.feature_table = features,
> +	.feature_table_size = ARRAY_SIZE(features),
>  	.driver.name =	KBUILD_MODNAME,
>  	.driver.owner =	THIS_MODULE,
>  	.id_table =	id_table,
> diff --git a/include/uapi/linux/virtio_rng.h b/include/uapi/linux/virtio_rng.h
> index c4d5de896f0c..d9774951547e 100644
> --- a/include/uapi/linux/virtio_rng.h
> +++ b/include/uapi/linux/virtio_rng.h
> @@ -5,4 +5,7 @@
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
>  
> +/* The feature bitmap for virtio entropy device */
> +#define VIRTIO_RNG_F_LEAK 0
> +
>  #endif /* _LINUX_VIRTIO_RNG_H */
> -- 
> 2.38.1
> 
> Amazon Spain Services sociedad limitada unipersonal, Calle Ramirez de Prado 5, 28045 Madrid. Registro Mercantil de Madrid . Tomo 22458 . Folio 102 . Hoja M-401234 . CIF B84570936


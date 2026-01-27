Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6565722AE7A
	for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769520758; cv=none; b=rn4GCVbnPR8mG6JSCMkmLwl9fzfrNBtwJ+aoH/N86omojd25l4eEU2viTGSNFQ4FbTgV487rr0l9I+O21mvDsTOQApFDWKmTKdv9/dS2KfFqbD2pbksb2q12Cm+2n47rFzwXrjFqSvpBNe9t43IYYnOIRdCoAgi0ZWssoGDdtb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769520758; c=relaxed/simple;
	bh=1pPzm73jU4WnRRZr3Qtem69llsafO+XdLvLKYKRKi3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUPtxzZorzT5iYofXZ/VdGlfiQIhnFKFrvAXxt4Cawl51jlvWHtmWFT1MgF83QZKgD0HsJLuYicWAbVdSZBvE0D5hgT5jUQnDI5XM+2eCr3f5/WtNO1nUUZWrdDHXFharVFs8Ob6Fj/TWcIJvpf14yHWP+n6naWM+8uAicj3XmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUxW5i/q; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUxW5i/q"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a743050256so37473985ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 05:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769520757; x=1770125557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJljzrF8g/4OX2Qdnlxu9vDiYnMdBso4JJtLFlTyJgI=;
        b=MUxW5i/qfZdWilmV4qQlUjux+Agta8zfDXwIpIQFFypGTonUlBqJza3juozEV61iMq
         uyxChAuY/+kphkSlMXGLOuAoBP1JXvQhgYjWU+MY2Hv0MB8hRZRVwWxuR0ha/Kzpvpaq
         PuREes3VlzaQoFR9ZvUYo51mPC6RMCuXCbxZaQtjjyakhmMAe9hFM9QtXZY8saNoBPgS
         7JgdrePc3NFwvFJ9pZind4u8FVmzZVIzEkkffCfOxhirfLIWarLwREHUvH2+Loub5Ays
         1WMItqYdqqy0VK3HIfzKD9lW01QJ1azawCMM6z/Pl8IJs0GrasyPFBZKp/XIeGpuxLZF
         0unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769520757; x=1770125557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJljzrF8g/4OX2Qdnlxu9vDiYnMdBso4JJtLFlTyJgI=;
        b=eBrKSAHfIu8kp2i+lGpvQgpTezBWsTMS3O6prOnJX0rP6WbzXSisk311t/BEUOupUz
         2Ij4zK7SDDF3sPZLHzt/mQ2sJ6f9OTyVSdHxgYyx1GfQRb6RuHgPeH7sWImxFUZX1HN+
         LFoZUhIe+jC8XF4fcCDE+wJZgwjzG8v3v4injgat7rH3unPiCra0VY+EatDKzcnf6afu
         6+FcsM/fZkZ0zulJFbFjx+RmcF3ggR05Uq5nsbWWg4j+XC2ssieSB2POhRsevwWUahEK
         r0+OHVDLOdNn8zWhKdmGOgK11KN+TSaCnn8x5LKS0fy2WmuIWmmrfq5yM6vCQOvE+Dey
         o8iw==
X-Forwarded-Encrypted: i=1; AJvYcCUDZVA04ktKp9uJIGFVI6M3vZ9oZrK31gkxRSFFA2P9NeZ2z82SxkgsCbU93+Mo4n5OS/P3nxuty+V8hPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTC3wKo5kPA5mkV+4oUSsxORAjqMzFnJdJTv843Ceuow1e5aZI
	cNor+5kMeJhiTP/wY6VUWQEJ77F/ikz57Uk9VMnt9Md32u+Xyic96OTy
X-Gm-Gg: AZuq6aJCo51QRg5+TRaIYSfmmTbqWmD52GNEQEQryc5o7IM9QenNBiHV5+mFfAfsHlV
	M6Xe4XkgylkfCoNnws/2BpdLz8LlEL25UyGDy5cCKBtXl5prInaUD27DXuwIi7OpkbrREpXKp3S
	3jwauVX2XwukfIH0ofURRoY1v3+bwRxvh1phRMYVBsxaShQbhI6FPz8tmrhaNwy9/YKdSPnmawh
	cY72vz/+QZDnzLlPWNJSPcxXehe57FYQ4qu/2ipck92GUs3ZGWDJECCbYG3k6Ji3LytYrRga5Fk
	sQ7WkfiALe+Ak2rfUAJGT2VAaA8Io8iW5ihybeSi5dx+YidWD3LYineqP5TdFwCQWkXKOiruyl3
	nwId671cgHqgWXA3JoKVIvFSbIADKZXnRJPwtAwI7GbIn/bwR14AVkVlOSfXd0WMmiz5sbSvd6M
	WI27T673uD0zt/f12yn5XmUpXXMF1iwV/Z21KFcIdC9cADjRjGmnUKUxY1mV6KGdbhdAnvwtZUX
	ayr7sF2JA==
X-Received: by 2002:a17:903:22d2:b0:2a7:5751:5b27 with SMTP id d9443c01a7336-2a870e192ecmr19477235ad.39.1769520756637;
        Tue, 27 Jan 2026 05:32:36 -0800 (PST)
Received: from kator.shina-lab.internal ([133.11.33.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a878425405sm13710935ad.56.2026.01.27.05.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 05:32:36 -0800 (PST)
From: Lianjie Wang <karin0.zst@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: core - use RCU for current_rng to fix race condition
Date: Tue, 27 Jan 2026 22:32:30 +0900
Message-ID: <aXirTffsg1GWk2Yw@kator>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aXbwM1wiPKqmC94v@gondor.apana.org.au>
References: 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jan 26, 2026 at 12:40:19PM +0800, Herbert Xu wrote:
> >  static struct hwrng *get_current_rng(void)
> >  {
> >  	struct hwrng *rng;
> > 
> > -	if (mutex_lock_interruptible(&rng_mutex))
> > -		return ERR_PTR(-ERESTARTSYS);
> > +	rcu_read_lock();
> > +	rng = rcu_dereference(current_rng);
> > +	if (rng && !kref_get_unless_zero(&rng->ref))
> > +		rng = NULL;
> 
> rng->ref should never be zero here as the final kref_put is delayed
> by RCU.  So this should be a plain kref_get.

Thanks for the review! I will change this to kref_get() in v3.

> >  static void put_rng(struct hwrng *rng)
> >  {
> > -	/*
> > -	 * Hold rng_mutex here so we serialize in case they set_current_rng
> > -	 * on rng again immediately.
> > -	 */
> > -	mutex_lock(&rng_mutex);
> > -	if (rng)
> > -		kref_put(&rng->ref, cleanup_rng);
> > -	mutex_unlock(&rng_mutex);
> > +	kref_put(&rng->ref, cleanup_rng);
> >  }
> 
> I think the mutex needs to be kept here as otherwise there is
> a risk of a slow cleanup_rng racing against a subsequent hwrng_init
> on the same RNG.

It is true that cleanup_rng() can race with hwrng_init(). However,
currently put_rng() is also called in hwrng_fillfn(), where we want to
avoid holding rng_mutex to prevent deadlock in hwrng_unregister().

To solve this race, should we introduce a separate lock (e.g.,
init_mutex) to serialize only hwrng_init() and cleanup_rng()?

Alternatively, I think we could stop the thread also in
set_current_rng() before switching current_rng, so that each lifetime of
hwrng_fillfn() thread strictly holds a single RNG instance, avoiding the
need to call get_current_rng() or put_rng() inside hwrng_fillfn().

> > @@ -371,11 +385,10 @@ static ssize_t rng_current_show(struct device *dev,
> >  	struct hwrng *rng;
> > 
> >  	rng = get_current_rng();
> > -	if (IS_ERR(rng))
> > -		return PTR_ERR(rng);
> > 
> >  	ret = sysfs_emit(buf, "%s\n", rng ? rng->name : "none");
> > -	put_rng(rng);
> > +	if (rng)
> > +		put_rng(rng);
> 
> I don't think this NULL check is necessary as put_rng can handle
> rng == NULL.

I removed the NULL check in put_rng() and moved it to rng_current_show()
in v2, since all the other callers of put_rng() already check for NULL
before calling put_rng(). I can restore the NULL check in put_rng() in
v3 if preferred.

> > @@ -489,8 +502,17 @@ static int hwrng_fillfn(void *unused)
> >  		struct hwrng *rng;
> > 
> >  		rng = get_current_rng();
> > -		if (IS_ERR(rng) || !rng)
> > +		if (!rng) {
> > +			/* This is only possible within drop_current_rng(),
> > +			 * so just wait until we are stopped.
> > +			 */
> > +			while (!kthread_should_stop()) {
> > +				set_current_state(TASK_INTERRUPTIBLE);
> > +				schedule();
> > +			}
> >  			break;
> > +		}
> > +
> 
> Is the schedule necessary? Shouldn't the break just work as it
> did before?

With the break alone, the task_struct might get freed before
kthread_stop() is called, which can still cause use-after-free
sometimes:

refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x103/0x130
...
WARNING: kernel/fork.c:778 at __put_task_struct+0x2ea/0x510
...
Call Trace:
 <TASK>
 kthread_stop+0x347/0x3b0
 hwrng_unregister+0x2d4/0x360
 remove_common+0x1d3/0x230
 virtio_dev_remove+0xb6/0x200
 ...
 </TASK>

As in the description of kthread_create_on_node() from kernel/kthread.c,
it seems we cannot return directly if we plan to call kthread_stop():

 *  ... @threadfn() can either return directly if it is a
 * standalone thread for which no one will call kthread_stop(), or
 * return when 'kthread_should_stop()' is true (which means
 * kthread_stop() has been called). ...

And in kthread_stop():

 * If threadfn() may call kthread_exit() itself, the caller must ensure
 * task_struct can't go away.

So I intended to wait until kthread_should_stop() is set. Otherwise, we
might need to call get_task_struct() and put_task_struct() manually to
hold the task_struct and ensure kthread_stop() works.

Alternatively, we could stop the thread *before* clearing current_rng in
drop_current_rng(), so that get_current_rng() will never return NULL
inside hwrng_fillfn(). What do you think?

Best regards,
-- 
Lianjie Wang

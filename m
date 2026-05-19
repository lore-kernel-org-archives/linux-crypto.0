Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5693C4577
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223712; cv=pass; b=OXFUYoMNU+eRbNQWZK0rir2y3Z8dd0VSGkmw3LBAB5uQYFn56HZNDGmPpXiqPLUMnrHqVP9nHcb5gHl8N1RVjY5c9HBBL63yIcDqadkcV5S0jLGe30hpb3kJRhidnv6zDUb6Wv8pGgOAexzP5jDKAecR1/71KyPFftMH5+amH6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223712; c=relaxed/simple;
	bh=ZC0Yv+mzFoZd7F87Y3lFyANxFkNR7vFPv8Ss/GY9w70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+hl755vy35XKIOvWpVZ6NIKl3797k7EYwnXvlaUCwiz90cpy48W4znmpvmlXP+yYKFoAf9Z4WZZOcvHCYt/p9nmUwp9ajVBhAb22HuBJXI3NQpjL/fC2cCLAkNqVyI+Zsg7YwhsfFpNxIL1YVQHTSJfVRA6UMUwKhIuR2dvH5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjXWTcr0; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjXWTcr0"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-65d8c6e78f0so237022d50.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779223708; cv=none;
        d=google.com; s=arc-20240605;
        b=KVXanRXA05y+nQtwFGZdRvSX6DHE1zWvDonoT7Pn0Xwypu4CCPRQJEb0E0SVpR1nc1
         We+dUZOxepBaBD0pYkI+xByKCtRyIk7eMMRTy3mtRj94cQdELdQpdeJrTd6Zh8pWstUO
         DfVu5ANlRyxTvMaFUyq7SVPuWppA56gQd0Zb/qLIDILO1RiBsBVPnhZ8i6QNoyWrhyoz
         aEqL35kWsiu5QothmjxJasUbdKDSa7rNyUlv6A3lqdytr4aJDzT8+AELXM0BQU9seYxP
         Zigcy47tG5R45oPnq/rH+if5zH/oXFAv/dgrkqFs/cCC5khMSpnhfh7kW7x5xgzY5yr3
         hQMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6DirUaProdGmmZxWP10QTDxw/St3Z8Ta0SL+hLPOUxc=;
        fh=d+4tgtFdyi4Z/nndsnRYVE0JVPkp6WECQcO63ytPAlE=;
        b=b5GEdB6W+bTtJOI6wBuiCZrQ9dOsHuSoQEFwY8fryD+Rwmj7bM/fVjKpsxUPlCwIgK
         yv2oK5vAfwVMLFdhRd79zqEMT8LtzRHk7k3w7JecT5cFtVWSKCAucpGzcq/SW1I707gn
         qbj6BEj1CPJ6MfdCY5AebBvwtmAVpcDHVQ5cc0WHbQwzBxuRq9c50uW4YP4+ccqbAGYe
         CNxDMQR4VHYRQpMQU99ov6k966EH05zyD1P+hE+5phelIXEold7yvKQx80n1+KcHecQb
         6gB829QP8C073lUnxRkeKG3lM1johyMT9Gs4gDbOJYuI33ZtOFBNdv0OKeD+3dHNW/2V
         r/sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223708; x=1779828508; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6DirUaProdGmmZxWP10QTDxw/St3Z8Ta0SL+hLPOUxc=;
        b=SjXWTcr0IqszwA8AvW4AgxyalWEz7e+ZNDLzeQgx8KiLyUjLbRSDRqvYNAZ0P4Vse4
         WD6ORNjBxg1w6HyJx3LaUVuJl/wHG99WoC72/VRXHVPkmbIS8eOT2a/Cht3B5F9v66uz
         pMWhlhbgJvx9vaqhlYeKoQ4gj6ha/gH2C+bMbOjBBctACZDd9CpZlM0SZHpUPHJ1MOSz
         vvG+/dqqkd1dqjwtI+pkj/B82v3jd8OQlTYYqLIzAGxYAL094m4tHy5LvN8uSG1Hz2A8
         KQDjA59hc8WxNKva+7L+KJs85FwWoiG8iLvI69/moxmBDUU+tvnDOiaf2Wz6BD97fSHQ
         23Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223708; x=1779828508;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6DirUaProdGmmZxWP10QTDxw/St3Z8Ta0SL+hLPOUxc=;
        b=sCAdhUkOjF50opOnRqkVmBy7Oh6KILz3JTYj3fFgCVJwELQatBa4ipv+RhztsVyy0v
         32GDqwn3OPbK6UhsSLUlAoY6exqFMt1Xy5xNDyDDUTB4zDMbqtjx3G90dpcLTDarBauF
         NnZy27/Ld0QABDmyY+Wfd/JDPwjn0s8cbaMAAj3YpU1uKBP03K8AOoOOilYbBluE/t7M
         9athUnQVFCYaumrJ21qGs6iC61JwmGlgCjcK2LPZ80+EE8ThPavhN3iecEVhsL/FLYZ6
         hqHbkJvwZRPnwW7Rfvj5KklARhwJm3fI3qwUQr2BaFFVpWdpvzqkFSGXOOLP+Pt9KclS
         PlDw==
X-Forwarded-Encrypted: i=1; AFNElJ/AxBbAU+36vVudsUswOtyAkc5FzBkel3KfSr0doJav2vTWsB17Ry1GIs2DRLINKjGJ2ff9MVtHU6w5Y6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9YEcDSNVYpcV/LovYDCbMz7WxEBm4tOsk/CKLFof9AtYqw3+C
	qGI5XzM774v8Go9Zdt14pxs2lu4LuUPyGwCxICrCfFZFCs9I9IsLiKZK7GS61wCdd3y1yE8O+70
	lwFJKqFFB0dJfKQZ1b0SZn74PrsOl6jU=
X-Gm-Gg: Acq92OFCmz2sncxCAlSARo+mMxxBbf6UMA9PAKM/zr2A/2ZuY0FPD0I0p/bvep751PH
	aVDwf61+/L6HEaWRZuE/O0IBl4eB+tPEfyGJ/WtQrRW8vcmkqlhkBWTicLFkKaV00cwNPLEIv8f
	IQde+bEMmuNHYp1LKnsHBJdSRJFMm9Lw5CLRmgQ+U+vGuILr3cye4T995VifUWKAP7whkb2hycS
	hwX1L7Yn1kSsvNY/UkQ52pd8t2pxru3Bd79mK7qLFUfuaAWEt1rJSuYbRyZfwlXbadxegtafwhi
	sYD55Mos81zk3QE=
X-Received: by 2002:a05:690e:1206:b0:653:9e2:1059 with SMTP id
 956f58d0204a3-65e223a1712mr13831799d50.0.1779223707773; Tue, 19 May 2026
 13:48:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512224349.64621-1-l.rubusch@gmail.com> <agYnpsiG8bNeVw57@linux.dev>
In-Reply-To: <agYnpsiG8bNeVw57@linux.dev>
From: Lothar Rubusch <l.rubusch@gmail.com>
Date: Tue, 19 May 2026 22:47:51 +0200
X-Gm-Features: AVHnY4KL7hK9v69b2jAE6nqIga-EyoAH1fUmSKUmwNEyNhkKgyfTVvx-PntyOZY
Message-ID: <CAFXKEHa0zgT24JqU3MzQPFdfodxjPREQyJ_-gk5iXcj6W1fqzQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] crypto: atmel - refactor common i2c support and add
 SHA256 ahash support
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Thorsten,

(...)
>
> Sashiko [1] also reviewed the series and found potential regressions
> that might be helpful to consider.
>
> Thanks,
> Thorsten
>
> [1] https://sashiko.dev/#/patchset/20260512224349.64621-1-l.rubusch%40gmail.com

FYI

As you asked to consider the Sashiko output, I will paste here the sashiko
review feedback and inlined my answers down below. I may continue with this
still some more iterations against AI/sashiko bot, no problem. How eventually
can I signal you (guys), when I need someone more "human" / maintainer?
What exciting times, we're living in... - let me know, if I use this tool wrong.

[PATCH 01/12] crypto: atmel-ecc - rename driver_data before moving it
into atmel-i2c
> commit 0ed25c0f5044cd5112cafff9ff8ab8248d0e2676
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
> This commit renames the local driver_data instance to atmel_i2c_mgmt
> to prepare for moving shared I2C client management infrastructure into
> the atmel-i2c core driver. No functional changes are intended.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index 9660f6426a849..c9f798ebf44fe 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> [ ... ]
> > @@ -323,16 +323,16 @@ static int atmel_ecc_probe(struct i2c_client *client)
> >
> >      i2c_priv = i2c_get_clientdata(client);
> >
> > -    spin_lock(&driver_data.i2c_list_lock);
> > +    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> >      list_add_tail(&i2c_priv->i2c_client_list_node,
> > -              &driver_data.i2c_client_list);
> > -    spin_unlock(&driver_data.i2c_list_lock);
> > +              &atmel_i2c_mgmt.i2c_client_list);
> > +    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> >
> >      ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
> This isn't a bug introduced by this patch, but does adding i2c_priv to the

It is IMHO not very helpful to flag a(ll) particular patch(es) for regressions
in the existing code aside, but ok. Perhaps I can fix something.

> global list before crypto_register_kpp() create a use-after-free risk?
> If algorithm registration fails, the error path removes the client from the
> list and returns an error, leading the driver core to free the i2c_priv
> memory.
> However, during the brief window it was on the list, a concurrent
> atmel_ecc_i2c_client_alloc() could discover the client and assign it to an
> active crypto request.
> When the probe fails and memory is freed, would the concurrent crypto
> request operate on freed memory?
> Also, does calling crypto_register_kpp() with a single static global
> algorithm structure cause memory corruption if multiple devices are probed?
> The crypto core modifies the algorithm structure before taking locks, which
> would corrupt the state of the active algorithm registered by the first
> device.
> The second probe would also fail, breaking the multiple-device load-balancing
> design. Unregistering a single device also unconditionally unregisters the
> shared algorithm.

As soon as being registered, the struct `atmel_ecdh_nist_p256` will require to
access the `atmel_i2c_mgmt.i2c_client_list`. Being it for the selftests, or a
consumer. Thus I cannot simply change the order. I added a ready/state flag to
address the use-after-free risk.

> >      if (ret) {
> > -        spin_lock(&driver_data.i2c_list_lock);
> > +        spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> >          list_del(&i2c_priv->i2c_client_list_node);
> > -        spin_unlock(&driver_data.i2c_list_lock);
> > +        spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> [ ... ]
> > @@ -363,9 +363,9 @@ static void atmel_ecc_remove(struct i2c_client *client)
> >
> >      crypto_unregister_kpp(&atmel_ecdh_nist_p256);
> >
> > -    spin_lock(&driver_data.i2c_list_lock);
> > +    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> >      list_del(&i2c_priv->i2c_client_list_node);
> > -    spin_unlock(&driver_data.i2c_list_lock);
> > +    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> >  }
> This isn't a bug introduced by this patch, but does the lockless check of

Sure, let's continue drive-by-reviewing...

> tfm_count earlier in atmel_ecc_remove() introduce a race condition?
> A concurrent atmel_ecc_i2c_client_alloc() could acquire the list lock and
> increment tfm_count immediately after the check, causing the device to be
> freed while a new session is starting.
> Additionally, if tfm_count is detected as greater than zero, the driver
> initially returns early. This leaves the freed i2c_priv on the global list
> which leads to list corruption and use-after-free on subsequent allocations.
> Returning from remove does not prevent the driver core from freeing the
> devres-managed memory. Should this synchronously block until tfm_count
> reaches zero to safely unbind?
> The dangling list pointer issue is fixed later in the series by commit
> "crypto: atmel-ecc - simplify remove path and relax busy handling", but the
> underlying active-user use-after-free remains unfixed.

I added a global lock with refcnting to address this.

[PATCH 02/12] crypto: atmel - rename atmel_ecc_driver_data to
atmel_i2c_client_mgmt
> Result:
> No issues found.

[PATCH 03/12] crypto: atmel - move i2c client management instance into
core driver
> commit 81ed08d3b64ea6591f1cadc2ccdca81d40c20205
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel - move i2c client management instance into core driver
> This commit moves the atmel_i2c client management instance from the ecc
> driver into the atmel-i2c core driver. This prepares for consolidating
> shared i2c client tracking infrastructure in the core.
> [ ... ]
> > diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> > index 0e275dbdc8c55..db24f65ae90e8 100644
> > --- a/drivers/crypto/atmel-i2c.c
> > +++ b/drivers/crypto/atmel-i2c.c
> > @@ -21,6 +21,12 @@
> >  #include <linux/workqueue.h>
> >  #include "atmel-i2c.h"
> >
> > +struct atmel_i2c_client_mgmt atmel_i2c_mgmt = {
> > +    .i2c_list_lock = __SPIN_LOCK_UNLOCKED(atmel_i2c_mgmt.i2c_list_lock),
> > +    .i2c_client_list = LIST_HEAD_INIT(atmel_i2c_mgmt.i2c_client_list),
> > +};
> > +EXPORT_SYMBOL_GPL(atmel_i2c_mgmt);
> While this regression wasn't introduced by this patch, does exposing this

Sure..

> globally shared list allow for a time-of-check to time-of-use race in
> atmel_ecc_remove() that can result in a use-after-free?
> In atmel_ecc_remove(), the check if (atomic_read(&i2c_priv->tfm_count)) is
> performed without holding the i2c_list_lock.
> If the count is 0, the function proceeds to call crypto_unregister_kpp().
> During this algorithm unregistration window, the client remains accessible on
> the globally shared atmel_i2c_mgmt.i2c_client_list.
> If a concurrent thread calls crypto_alloc_kpp(), it triggers the .init callback
> atmel_ecdh_init_tfm(), which calls atmel_ecc_i2c_client_alloc().
> The allocator acquires the list lock, discovers the dying client still on the
> list, increments tfm_count, and returns it.
> Then, atmel_ecc_remove() acquires the list lock, removes the client from the
> list, and returns.
> Returning from the remove function causes the devres framework to automatically
> free i2c_priv, leaving the concurrent thread with a tfm bound to freed memory.
> Can this sequence lead to memory corruption?

The two additional patches will cover the remove function.

[PATCH 04/12] crypto: atmel-ecc - simplify probe error handling
> commit 3bca954bd7e39050b3fe5381aad35c915da883f3
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-ecc - simplify probe error handling
> This commit refactors the error path in atmel_ecc_probe to use a goto
> statement instead of duplicating the list removal code. It also claims to
> add comments clarifying client list insertion and algorithm registration.
> > crypto: atmel-ecc - simplify probe error handling
> >
> > Replace early return in atmel_ecc_probe() with explicit error handling
> > using a goto-based cleanup path.
> >
> > Add comments to clarify client list insertion and algorithm registration
> > steps.
> This isn't a bug, but the commit message states it replaces an early
> return and adds comments, yet the diff doesn't show any comments being
> added or an early return being removed. Should the commit message be
> updated to reflect the actual changes?
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index 76fb1d0cf0753..696ab1d51fc67 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> > @@ -328,17 +328,20 @@ static int atmel_ecc_probe(struct i2c_client *client)
> >
> >      ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
> Is it safe to register the static global atmel_ecdh_nist_p256 algorithm
> structure here directly from the probe function? If multiple devices are
> probed, a second call to crypto_register_kpp with the same static struct
> could cause crypto_check_alg to reset the active algorithm's reference
> count, and __crypto_register_alg to re-initialize the cra_users list,
> potentially causing a regression that corrupts the state for active
> crypto users.
> >      if (ret) {
> > -        spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> > -        list_del(&i2c_priv->i2c_client_list_node);
> > -        spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> > -
> >          dev_err(&client->dev, "%s alg registration failed\n",
> >              atmel_ecdh_nist_p256.base.cra_driver_name);
> > +        goto err_list_del;
> By moving the list removal to a goto block after the dev_err call, does this
> code introduce a regression by widening the window for a race condition?
> Since the client is added to the global atmel_i2c_mgmt.i2c_client_list earlier
> in the probe, if registration fails, a concurrent task might find and use the
> failed client. Executing a potentially slow console log before removing the
> client from the list seems to worsen the window for a use-after-free when
> devres cleans up i2c_priv.
> [ ... ]

Patch replaced and merged

[PATCH 05/12] crypto: atmel - factor out i2c client unregistration helper
> commit 67148be9a0cfbd189723055fbc1cdfa19bd244ad
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel - factor out i2c client unregistration helper
> This commit moves the i2c client removal logic into a dedicated helper
> function in the atmel-i2c core. It also converts the ECC driver remove
> path to use this new helper.
> >     Convert ECC driver remove path to use the new helper and
> >     ensure queue flushing is performed after removing the device
> >     from the shared client list.
> Is this description accurate? Looking at the implementation below, the queue
> flushing is performed before removing the device from the list.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index 696ab1d51fc67..e5dd77008b97f 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> [ ... ]
> > @@ -364,9 +364,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
> >
> >      crypto_unregister_kpp(&atmel_ecdh_nist_p256);
> >
> > -    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> > -    list_del(&i2c_priv->i2c_client_list_node);
> > -    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> > +    atmel_i2c_flush_queue();
> > +    atmel_i2c_unregister_client(i2c_priv);
> >  }
> While crypto_unregister_kpp() prevents new lookups, concurrent threads that
> already resolved the algorithm can still execute atmel_ecdh_init_tfm().
> Because atmel_i2c_flush_queue() is called first, it will sleep waiting for
> the workqueue to drain while the client is still present in the global
> atmel_i2c_mgmt.i2c_client_list.
> Could a concurrent atmel_ecdh_init_tfm() call atmel_i2c_client_alloc(),
> find the still-linked client, increment its tfm_count, and assign it to
> ctx->client?
> Once the flush completes, atmel_i2c_unregister_client() removes the client,
> the driver returns, and the device core frees the i2c_priv memory.
> Would this result in a use-after-free on subsequent crypto operations since
> ctx->client now points to freed memory?

Replaced by a more comprehensive dealing with the teardown, patch replaced.

[PATCH 06/12] crypto: atmel-sha204a - add i2c hw client list and
improve probe error handling
> commit 14fd691f797c32576c19b57c937cd6cf75be5ef8
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-sha204a - add i2c hw client list and improve probe error handling
> This patch adds registration of the sha204a i2c client into the shared
> atmel_i2c client management list during probe. This allows the driver to
> participate in the common hardware selection infrastructure.
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > index 6e6ac4770416e..cdfdcf2e43a7d 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -173,6 +173,13 @@ static int atmel_sha204a_probe(struct i2c_client *client)
> >
> >      i2c_priv = i2c_get_clientdata(client);
> >
> > +    /* add to client list */
> > +    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> > +    list_add_tail(&i2c_priv->i2c_client_list_node,
> > +              &atmel_i2c_mgmt.i2c_client_list);
> > +    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> Is it possible for another thread to discover this client before the rest of
> the probe completes?
> If another thread like atmel_i2c_client_alloc() grabs a reference to this
> client from the shared list, and then a subsequent initialization step fails,
> the error path will fail the probe. The devres cleanup will free i2c_priv,
> but the concurrent user will be left with a dangling pointer.
> Also, since the shared atmel_i2c_mgmt.i2c_client_list is used by the
> atmel-ecc driver for hardware selection, could adding the sha204a device
> here cause the atmel-ecc driver to incorrectly dispatch ecdh/ecdsa
> operations to this device?
> Since the selection logic picks the client with the lowest active workload,
> it might select this device and the hardware would reject unsupported
> commands. This was addressed later in the series by commit "crypto: atmel -
> add capability-based i2c client selection".
> Additionally, if the atmel-sha204a module is loaded first, could loading the
> atmel-ecc module later completely wipe out this shared list?
> If the atmel-ecc initialization blindly uses INIT_LIST_HEAD() on this list,
> it would orphan the sha204a clients. This was fixed later in the series by
> commit "crypto: atmel-ecc - switch to module_i2c_driver".
> > +
> > +    /* register rng */
> >      memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
> >
> >      i2c_priv->hwrng.name = dev_name(&client->dev);
> > @@ -183,15 +190,24 @@ static int atmel_sha204a_probe(struct i2c_client *client)
> >          i2c_priv->hwrng.quality = *quality;
> >
> >      ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
> > -    if (ret)
> > +    if (ret) {
> >          dev_warn(&client->dev, "failed to register rng (%d)\n", ret);
> > +        goto err_list_del;
> > +    }
> >
> >      ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
> >      if (ret) {
> >          dev_err(&client->dev, "failed to register sysfs entry\n");
> > -        return ret;
> > +        goto err_list_del;
> >      }
> Is it possible for userspace to queue an asynchronous non-blocking read
> between devm_hwrng_register() and this sysfs_create_group() call?
> If an async rng read is queued to atmel_wq and work_data is allocated, and
> then sysfs_create_group() fails, devres will unwind allocations and free
> i2c_priv.
> Without calling atmel_i2c_flush_queue() in the error path, the pending work
> would execute after i2c_priv is freed. This would also leak the dynamically
> allocated work_data.
> >
> > +    return ret;
> > +
> > +err_list_del:
> > +    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> > +    list_del(&i2c_priv->i2c_client_list_node);
> > +    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> > +
> >      return ret;
> >  }
> Does the atmel_sha204a_remove() function need an update to remove the i2c
> client from the global list?
> Since the client is added during probe, it appears it would be left dangling
> in the list when the device is unbound and devres frees i2c_priv,
> potentially causing a crash if the list is traversed later.
> This was fixed later in the series by commit "crypto: atmel-sha204a -
> switch to module_i2c_driver".

Chronologically this is the wrong order. I moved this patch down to the end.
The issue should be fully covered. In this way, Atmel SHA204a devices are
added to the i2c list, when they can configure not being available for ECDH
operations. This is a preparation for future capabilities
(as in the initial roughly splitted series).

[PATCH 07/12] crypto: atmel-sha204a - switch to module_i2c_driver
> commit e46024ee80d35e3759c2e5365d027bec6fb2ea51
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-sha204a - switch to module_i2c_driver
> Replace custom module init/exit functions with module_i2c_driver() for
> driver registration. Update remove path to unregister the client from the
> shared I2C management list before flushing pending work and cleaning up
> sysfs and hwrng resources.
> > Update remove path to unregister the client from the shared I2C management
> > list before flushing pending work and cleaning up sysfs and hwrng
> > resources.
> >
> > No functional change intended.
> This isn't a bug, but this patch appears to fix a list corruption regression.
> Before this patch, unloading the module would leave a freed i2c_priv structure
> linked into the shared atmel_i2c_mgmt.i2c_client_list. Does adding the
> atmel_i2c_unregister_client() call fix this dangling pointer issue, making
> the "No functional change intended" claim inaccurate?
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > index cdfdcf2e43a7d..613ed5e7b3f61 100644
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -216,6 +216,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
> >      struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> >
> >      devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);
> > +
> > +    atmel_i2c_unregister_client(i2c_priv);
> The commit message states the intent to unregister the client from the shared
> list before cleaning up hwrng resources. Since devm_hwrng_unregister()
> blocks until active synchronous readers complete, does placing
> atmel_i2c_unregister_client() after it leave the client exposed in the shared
> list while the device is actively being torn down?
> Could another subsystem discover and bind to this partially removed client
> during the blocking window, resulting in memory corruption once the unbind
> completes?
> Should atmel_i2c_unregister_client() be moved to the beginning of the remove
> function to match the design described in the commit message?
> >      atmel_i2c_flush_queue();
> >
> >      sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
> Additionally, I noticed a potential use-after-free regression in the probe
> error path.
> In atmel_sha204a_probe(), if sysfs_create_group() fails, the function
> returns an error:
> drivers/crypto/atmel-sha204a.c:atmel_sha204a_probe() {
> [ ... ]
>     ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
>     if (ret) {
>         dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
>         goto err_list_del;
>     }
>     ret = sysfs_create_group(&client->dev.kobj, &atmel_sha204a_groups);
>     if (ret) {
>         dev_err(&client->dev, "failed to register sysfs entry\n");
>         goto err_list_del;
>     }
>     return ret;
> err_list_del:
>     spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
>     list_del(&i2c_priv->i2c_client_list_node);
>     spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
>     return ret;
> }
> At this point, the RNG has already been registered and exposed to user-space
> via devm_hwrng_register(). A concurrent user-space read could have initiated
> an asynchronous read, which queues a work item onto atmel_wq.
> When probe() returns an error, devres will immediately unregister the RNG and
> free the i2c_priv structure. Since the pending work on atmel_wq is never
> flushed or canceled, will it dereference the freed i2c_priv when it
> eventually executes?
> Should atmel_i2c_flush_queue() be explicitly called in the probe error path,
> just as it is in remove()?
> I also noticed a potential kernel heap memory leak to user-space in the
> asynchronous read path.
> In atmel_sha204a_rng_done(), if an asynchronous I2C transaction fails,
> the buffer is unconditionally cached:
> drivers/crypto/atmel-sha204a.c:atmel_sha204a_rng_done() {
> [ ... ]
>     if (status)
>         dev_warn_ratelimited(&i2c_priv->client->dev,
>                      "i2c transaction failed (%d)\n",
>                      status);
>     rng->priv = (unsigned long)work_data;
> [ ... ]
> }
> If status != 0, the work_data->cmd.data buffer is left uninitialized or
> partially written.
> On the next call to atmel_sha204a_rng_read_nonblocking(), the code blindly
> copies up to 32 bytes of this buffer:
> drivers/crypto/atmel-sha204a.c:atmel_sha204a_rng_read_nonblocking() {
> [ ... ]
>     if (rng->priv) {
>         work_data = (struct atmel_i2c_work_data *)rng->priv;
>         max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
>         memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
>         rng->priv = 0;
>     } else {
>         work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
> [ ... ]
> }
> Because work_data is allocated without zeroing memory, does this copy
> uninitialized kernel heap memory into the hwrng output data buffer?
> Could this allow an attacker to leak kernel heap memory to user-space via
> /dev/hwrng by inducing I2C read failures?

Chronologically this is the wrong order. I moved this patch down to the end.
Add different error labels in probe to address failing sysfs_create_group().
Fix kernel heap information leak in a separate patch.

[PATCH 08/12] crypto: atmel-ecc - switch to module_i2c_driver
> commit 1156053e97f2cc049a62750ad595b29dc8a4e921
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> Date:   Sun May 17 18:06:35 2026 +0000
>     crypto: atmel-ecc - switch to module_i2c_driver
>
>     Replace custom module init/exit functions with module_i2c_driver() for
>     simplified driver registration.
>
>     Initialization of the shared I2C client management structure is handled by
>     the core driver and no longer performed in the ECC module init path.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index e5dd77008b97f..dcfc09d244973 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> > @@ -392,21 +392,7 @@ static struct i2c_driver atmel_ecc_driver = {
> >      .id_table    = atmel_ecc_id,
> >  };
> >
> > -static int __init atmel_ecc_init(void)
> > -{
> > -    spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
> > -    INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
> > -    return i2c_add_driver(&atmel_ecc_driver);
> > -}
> > -
> > -static void __exit atmel_ecc_exit(void)
> > -{
> > -    atmel_i2c_flush_queue();
> > -    i2c_del_driver(&atmel_ecc_driver);
> > -}
> > -
> > -module_init(atmel_ecc_init);
> > -module_exit(atmel_ecc_exit);
> > +module_i2c_driver(atmel_ecc_driver);
> While this change simplifies driver registration, does this driver have a
> pre-existing regression involving a use-after-free in its remove path?

again, "pre-existing regression". I already addressed this topic above.

> Looking at the driver's remove path, it can return early if the client is
> busy:
> drivers/crypto/atmel-ecc.c:atmel_ecc_remove() {
>     struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>     if (atomic_read(&i2c_priv->tfm_count)) {
>         dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
>         return;
>     }
>     ...
> }
> When atmel_ecc_remove() returns, the driver core unconditionally frees all
> devres-managed memory, including i2c_priv, which is allocated via
> devm_kmalloc() during probe.
> If there are open crypto transforms holding pointers to this freed memory,
> will subsequently closing a busy transform cause atmel_ecdh_exit_tfm() to
> access the freed i2c_priv->tfm_count and trigger a use-after-free of
> i2c_priv?
> Furthermore, does the early return leave the atmel_ecdh_nist_p256 algorithm
> permanently registered with dangling pointers to module text?
> Additionally, could a time-of-check to time-of-use race occur here?
> If atmel_ecc_remove() sees tfm_count == 0, a concurrent transform allocation
> might acquire the client just before it is removed from the global list,
> leading to the same devres use-after-free.
> Note that later commits like "crypto: atmel-ecc - simplify remove path and
> relax busy handling" remove the early return, but the fundamental
> use-after-free persists because devres still frees i2c_priv while active
> transforms hold references to it.
> Is there also a pre-existing regression in the probe error path that can lead
> to a use-after-free?
> The client is added to the global atmel_i2c_mgmt.i2c_client_list before
> crypto_register_kpp() is called:
> drivers/crypto/atmel-ecc.c:atmel_ecc_probe() {
>     ...
>     spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
>     list_add_tail(&i2c_priv->i2c_client_list_node,
>               &atmel_i2c_mgmt.i2c_client_list);
>     spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
>     ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
>     if (ret) {
>     ...
>         goto err_list_del;
>     }
>     ...
> }
> If registration fails (for example, because another device already registered
> the algorithm), the error path removes the client from the list and returns
> an error. This causes the driver core to free the devm-allocated i2c_priv.
> While the client was briefly in the global list, could a concurrent transform
> allocation acquire it via atmel_ecc_i2c_client_alloc()?
> This would leave the concurrent transform holding a dangling pointer to the
> freed i2c_priv memory, resulting in a use-after-free when cryptographic
> operations are submitted.
> >
> >  MODULE_AUTHOR("Tudor Ambarus");
> >  MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");

All of the issues are supposed to be already addressed here. Let's have a look
into next Sahiko iteration. Patch updated.

[PATCH 09/12] crypto: atmel-ecc - simplify remove path and relax busy handling
> commit e814c428ad784badd861d6adbe0e2dbf99beae12
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-ecc - simplify remove path and relax busy handling
> This commit simplifies the removal path of the atmel-ecc driver by removing
> the early exit logic when active transform users are detected. Instead, it
> issues a warning and continues with the full teardown of the crypto
> registration and device cleanup.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index dcfc09d244973..ce7a2e750ba88 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> > @@ -346,21 +346,14 @@ static int atmel_ecc_probe(struct i2c_client *client)
> >
> >  static void atmel_ecc_remove(struct i2c_client *client)
> >  {
> > -    struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> > +    struct atmel_i2c_client_priv *i2c_priv;
> >
> > -    /* Return EBUSY if i2c client already allocated. */
> > -    if (atomic_read(&i2c_priv->tfm_count)) {
> [ ... ]
> > -        dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
> > +    i2c_priv = i2c_get_clientdata(client);
> > +    if (WARN_ON(!i2c_priv))
> >          return;
> > -    }
> > +
> > +    if (atomic_read(&i2c_priv->tfm_count))
> > +        dev_warn(&client->dev, "Device is busy, remove it anyhow\n");
> Could this still lead to a use-after-free on i2c_priv?
> The i2c_priv structure is allocated using devres during probe. When
> atmel_ecc_remove() completes, the Linux device model automatically triggers
> devres cleanup, which unconditionally frees i2c_priv.
> If active crypto transforms (indicated by tfm_count > 0) retain pointers to
> the device context, won't they dereference the freed i2c_priv when enqueuing
> new crypto operations or when they are eventually closed?
> >      crypto_unregister_kpp(&atmel_ecdh_nist_p256);
> Does unregistering the statically allocated crypto algorithm while busy
> trigger a warning and corrupt its reference count?
> Because the atmel_ecdh_nist_p256 structure is statically allocated, it has
> no cra_destroy callback. Calling crypto_unregister_alg() while active
> transforms exist (cra_refcnt > 1) deterministically hits the safety check
> WARN_ON(!alg->cra_destroy && refcount_read(&alg->cra_refcnt) != 1) in
> crypto/algapi.c.
> Additionally, if the device is subsequently re-probed, crypto_register_kpp()
> will overwrite the structure's cra_refcnt to 1. When the original, orphaned
> transforms finally close and call crypto_alg_put(), they will decrement the
> newly reset refcount to 0. Future allocations of the algorithm would then
> trigger refcount_inc() on a zeroed refcount, permanently corrupting the
> algorithm's state.
> >
> > -    atmel_i2c_flush_queue();

Patch dropped.

[PATCH 10/12] crypto: atmel-sha204a - guard remove path against
missing client data
> commit 940da01227a9a17cd454a0d965228cb8cdc7880a
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel-sha204a - guard remove path against missing client data
> This commit attempts to prevent dereferencing invalid client state during
> driver removal by adding a NULL check for the I2C client private data.
> It also mentions retrieving the data only after sysfs cleanup.
> > Retrieve the I2C client private data in atmel_sha204a_remove() only
> > after sysfs cleanup and add a NULL check before continuing device
> > teardown.
> Is this description accurate? The patch places the i2c_get_clientdata()
> call at the top of the function and leaves sysfs_remove_group() at the
> bottom, which does not appear to reorder these operations.
> > diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> > --- a/drivers/crypto/atmel-sha204a.c
> > +++ b/drivers/crypto/atmel-sha204a.c
> > @@ -213,7 +213,11 @@ static int atmel_sha204a_probe(struct i2c_client *client)
> >
> >  static void atmel_sha204a_remove(struct i2c_client *client)
> >  {
> > -    struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> > +    struct atmel_i2c_client_priv *i2c_priv;
> > +
> > +    i2c_priv = i2c_get_clientdata(client);
> > +    if (WARN_ON(!i2c_priv))
> > +        return;
> Since the driver core guarantees atmel_sha204a_remove() is only called if
> atmel_sha204a_probe() completed successfully, can i2c_priv ever actually be
> NULL here?
> If this early return were to trigger, would it skip the rest of the teardown
> sequence?
> Bypassing mandatory cleanup like sysfs_remove_group() and
> atmel_i2c_flush_queue() would leave dangling sysfs files and uncancelled
> work queues.
> Could the crash this patch attempts to mitigate actually be caused by a
> pre-existing issue in the probe() error path?
> If sysfs_create_group() fails after devm_hwrng_register() succeeds in
> atmel_sha204a_probe(), the function returns an error and devres cleans up
> i2c_priv.
> However, if a concurrent non-blocking read queued asynchronous work to
> atmel_wq, this work is not flushed because atmel_i2c_flush_queue() is
> omitted from the probe error path.
> When atmel_i2c_work_handler() executes later, would it dereference the
> already freed i2c_priv structure?

Patch dropped.

[PATCH 11/12] crypto: atmel - move i2c client selection to core driver
> commit ec87e048a52b48d6d9799216ee15e9f3c0e86cbc
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel - move i2c client selection to core driver
> Moves the I2C client selection logic from the ECC-specific driver into the
> shared Atmel I2C core. This allows the load-balancing logic to be reused
> across other Atmel crypto drivers.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index ce7a2e750ba88..f877f236552f7 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> [ ... ]
> > -static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
> > -{
> [ ... ]
> > -    return client;
> > -}
> > -
> >  static void atmel_ecc_i2c_client_free(struct i2c_client *client)
> >  {
> >      struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> > @@ -249,7 +214,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
> This isn't a bug, but the patch exports atmel_i2c_client_alloc() to share
> allocation logic while leaving the corresponding free function static here.
> Since the goal is for other Atmel crypto drivers to use the new shared
> allocation API, won't they be forced to manually access i2c_priv->tfm_count
> to decrement the counter? Should we also move and export a shared free
> function to create a symmetric API lifecycle?
> > diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> > index 861af52d7a88b..4beab68997c4f 100644
> > --- a/drivers/crypto/atmel-i2c.c
> > +++ b/drivers/crypto/atmel-i2c.c
> [ ... ]
> > +struct i2c_client *atmel_i2c_client_alloc(void)
> > +{
> > +    struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
> > +    struct i2c_client *client = ERR_PTR(-ENODEV);
> > +    int min_tfm_cnt = INT_MAX;
> > +    int tfm_cnt;
> > +
> > +    spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> > +
> > +    if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
> > +        spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> > +        return ERR_PTR(-ENODEV);
> > +    }
> > +
> > +    list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
> > +                i2c_client_list_node) {
> > +        tfm_cnt = atomic_read(&i2c_priv->tfm_count);
> > +        if (tfm_cnt < min_tfm_cnt) {
> > +            min_tfm_cnt = tfm_cnt;
> > +            min_i2c_priv = i2c_priv;
> > +        }
> > +        if (!min_tfm_cnt)
> > +            break;
> > +    }
> > +
> > +    if (min_i2c_priv) {
> > +        atomic_inc(&min_i2c_priv->tfm_count);
> > +        client = min_i2c_priv->client;
> > +    }
> > +
> > +    spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
> > +
> > +    return client;
> > +}
> Could this result in a use-after-free if the device is unbound?
> If the underlying I2C device is asynchronously unbound while a crypto
> transformation is active, the driver's remove callback executes. The remove
> callback unregisters the algorithm to prevent new transformations, but it
> does not block waiting for active ones to be freed.
> When remove returns, the I2C subsystem frees the i2c_client structure, and
> devres automatically frees the allocated i2c_priv structure. The active
> transformation would retain the dangling ctx->client pointer. Any subsequent
> crypto operation would enqueue a work item that dereferences the freed client
> and accesses freed memory.
> Should we take a reference on the device via get_device(&client->dev) before
> returning it here to ensure it stays alive?

No. atmel_ecc_remove() was reworked, this issue should be addressed now.

> > +EXPORT_SYMBOL(atmel_i2c_client_alloc);
> This isn't a bug, but this function internally acquires locks and iterates
> over atmel_i2c_mgmt, which is exported via EXPORT_SYMBOL_GPL.
> Does exporting this as a non-GPL symbol allow non-GPL modules to bypass the
> GPL restriction of the underlying shared data structure? Should this be
> exported using EXPORT_SYMBOL_GPL to maintain consistency?

Renamed patch title. I changed to EXPORT_SYMBOL_GPL. The alloc and free
functions are now migrated.

[PATCH 12/12] crypto: atmel - add capability-based I2C client selection
> commit 67dd11917ea1c6943f1088bb31e4aa5da0cb31f4
> Author: Lothar Rubusch <l.rubusch@gmail.com>
> crypto: atmel - add capability-based I2C client selection
> This commit introduces capability-based filtering for the I2C client
> allocator. Devices now advertise supported features during probe, and the
> allocator selects clients that match the requested capabilities. This
> prepares the driver for using the hardware beyond a single algorithm type.
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> [ ... ]
> > @@ -286,6 +286,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
> >
> >      i2c_priv = i2c_get_clientdata(client);
> >
> > +    i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
> > +
> >      spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
> >      list_add_tail(&i2c_priv->i2c_client_list_node,
> >                &atmel_i2c_mgmt.i2c_client_list);
> This problem wasn't introduced by this patch, but there appears to be a race

Sure

> condition if a device probe fails.
> In atmel_ecc_probe(), the i2c_priv object is added to the global list before
> all initialization steps are complete:
> atmel_ecc_probe()
>     list_add_tail(&i2c_priv->i2c_client_list_node, ...)
>     ...
>     ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
>     if (ret) {
>         goto err_list_del;
> If multiple Atmel ECC devices are present, the second device will fail to
> register the same static algorithm and return an error.
> During this window, could a concurrent call to atmel_i2c_client_alloc()
> select this incompletely probed device for a new crypto transformation?
> If so, when the probe function hits the error path, removes the device from
> the list, and devres frees i2c_priv, the crypto transformation would be left
> with a dangling pointer, potentially causing a use-after-free on subsequent
> operations. This same pattern also appears to be present in
> atmel_sha204a_probe().
> > diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> > --- a/drivers/crypto/atmel-i2c.c
> > +++ b/drivers/crypto/atmel-i2c.c
> [ ... ]
> > @@ -73,6 +73,9 @@ struct i2c_client *atmel_i2c_client_alloc(void)
> >
> >      list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
> >                  i2c_client_list_node) {
> > +        if (!(i2c_priv->caps & BIT(cap)))
> > +            continue;
> > +
> >          tfm_cnt = atomic_read(&i2c_priv->tfm_count);
> >          if (tfm_cnt < min_tfm_cnt) {
> This problem wasn't introduced by this patch, but it seems active

Already mentioned...

> cryptographic transformations might not properly secure the lifetime of the
> underlying I2C device.
> The atmel_i2c_client_alloc() function increments a local tfm_count to track
> active references, but does not pin the device structure itself or delay its
> destruction.
> If a device is hot-unplugged or manually unbound via sysfs, the driver's
> remove callback executes. Since i2c_priv is tied to the device's lifecycle
> via devres, it will be automatically freed upon returning from the remove
> function. The unbind process does not block waiting for tfm_count to drop to
> zero.
> Does this mean any concurrently active crypto TFM previously allocated via
> atmel_i2c_client_alloc() will maintain a dangling pointer to these freed
> structures?
> When the TFM is later destroyed or performs an operation, it might
> dereference the freed client and execute atomic_dec() on freed memory.

The time-of-check to time-of-use situation should be addressed, as also the
multiple hardware devices competing for the algo structure.

Best,
L

Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F364C42EEA2
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768916397; cv=pass; b=ipAWcqg5GEiO2Vva2VjNRPwbCBKljXTpkHt8HdHcEsfk73R0jb9t+YWRf2Nvx2SbPSWEyb/mAIcHWRz0/nPHTeqBUMDJQI/bodrrTNobKXKLzaZ8AONoVsOFavS24aA7nQFtzKYdH4NFG+wH96rdgoCcw+qG1cCV/MHxgBf3KDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768916397; c=relaxed/simple;
	bh=ycO8W0dmgZoBI6/VgypRscOK3o0+TlOtO2uK6pwHKA0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z6Y8hFfvbuWnc2dVapn5IBJ87j8TO8AOSR7Bk7kzXskKMtOuhLfhatv4MUT+DGCfgYdadeBkBIG0LtPDcmYlwwHSmnBj7N0YWGFPjtrp/tyPjt8GyB9uos+ku4PQPY92I1IFeD5xr+ISkl1XGPFugcPh7gwmLX4aHpF8nHUw6ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fzRlSWqL; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fzRlSWqL"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50145d27b4cso56365951cf.2
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 05:39:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768916395; cv=none;
        d=google.com; s=arc-20240605;
        b=Izf5laZjSocgabYpMdJ9S9ENp8fx8lrldA+V5CiYB/8uSBXl27kNNGPopz5uEKygKc
         W5M2FQFcBJjBYWjK4UCd5cxJ0TRGsv+pGirk+cE26DCv3rYNVaV8oZn+9uPLk2NntcPz
         XVHXz+MYrRS26bp4xov45+ukMqd5wGEsxkKPmebNKjleF7YAFmHaYXw2m6yiuH7iVabK
         Hp+q7/nMAwz1aKNU1k0LOV+Vck8uqzzCahjF2e+J2WbngFiKhvw6hTrBpI/YzDm/es5r
         Q4+R43JmaJzhab6NUYD5Yo+7DLLR5EkIof2TwKgEVNFz7WFj39KeFTz9bc/g3Gi9GgW8
         8dYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        fh=9IVjdW2A1S9iJWtM3G+FQauo70TaArlle6chQPIS1iA=;
        b=NC9mHrfOOTuZJbGX/CugxHtou6J0ebuEPcVqN0iKtWwxHdy2qEbhQxWgDF7hvayyMf
         HLoDpIGNuRVXkySyNhyCLK+9WdeOq4gYUcju0SDdqYKPSEaDQMHKSAWXC5rQOeRDuUjw
         f9MhLMMw0/YJpiXSejIW+g2Rdn86aNfTZYLOvvz9kIuLAjOz1J+YcX5ggPgNNL/F7aSF
         BWcGs5WQmjILONvDk59m6b6TE/36YLGJ4Badxzox5ewSB397ySfQR3LDRWRFLeyOlT8k
         G7KjSzqQ0AL5v0iyc3SVjTdCqHks4sOyJysvAluHkH9kIOVOVgXxtqvI8tXmMj+0tMr8
         mxcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768916395; x=1769521195; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        b=fzRlSWqLyFcvzMs0WQyB5zi7XjdrVv1oC24sqyp7Hdx1ngdWUgF4qiBBjxhyuMsEzN
         oQiSvxdWOKi7uOZH0EX2kgiJoyfAZigvRlhYKVN3LWQRu1DpBirH/q11nxr6w+KcM2wh
         DeNH4bSCa5mhUIWqw7+h7PZZZWqETo6p+8ZTjDhozTnWZJlnjbtB0iF5u0IHdGzgPe1E
         HZiCFH1dxD2JBxC7o79AwxbCrEYy2+q7ZL2FOWSL9vvYY2Vu2omDYB03S8s4wkxh49sc
         oo2Xy8ztSWXlriLVI2IPky87Do5BG7P8j9MiSkMLaUntvT5gF0OEDWq6Kka34POjTy3Z
         dg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768916395; x=1769521195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0q6rVfmOcQQ7ikYVJ6BpQMxddONQmNjn6LAGePsigA8=;
        b=JUczM9eJfte4dDB7f6g5/tlreHD1CreAuO60bqAr+zFMR695CrNKsfz+s4gHAaoejM
         X33e/ITx+PcVFYZ9JT+cve1qS+PrzMXDTRTHgu6N8mm0U/J4OZHLCA1cv0u73uHb59S/
         C8TnDbnhKgWr6+F/Lje1l6bzIBq9p8+nlpbU2bT5C6EpVpR3bMFtwDgq6OEGfWL0hWMI
         D+tbqybsMvV4WgwY7n4qqB/eQiZK2aPpTeedb/slMr4BeDSKUG29Nq867ZYwFKInqtR0
         kz9SjRKqAtm3A2T1DOrTHV/cFF2gjYX4i6Y1386qI4Yl3glu80YXCioq9YZDowtR9zf7
         iI5w==
X-Forwarded-Encrypted: i=1; AJvYcCVB+zkc29GgtC7wXiJbAsUTJHljxit6TNpsBgIpw2zCrVWHtHvJoWwL+Cijcv6NmDGSSi6BOXunlRJO2VM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNCMddpiv87hsJ4kvvP0x4G8nH9d2RjvOJSY0q6S32gN4UCDtE
	AnI1WNBQfFk5/vzzDTaEJ2VZ3hQVgyz7DaHf4LGe3CohAU/Z11jw1xzwLCryMT6u5FeiE3eHGrJ
	dvlrSFgNElcVsHpSyGPxax5+mrJPQe+P5au265NHj
X-Gm-Gg: AY/fxX7D5+bQS5WVCFfnT6VP0ud4ni2HtuGyOkQSlrFtbu0SU86CuP3PbY1Po77woU9
	TJQADys+GFOFSdsuG8wusOE4AnPLM1PLkpeGWUSxvRH0JefR4D40N2AJBsiQxYA94eyU++6sGGW
	zNGAzi/B8VMR3g9chK/UToqIGe00ync1/4H+j2YnsaQDXbGWYvWFsYfIXD+wbZxmPuN3FuKmOf9
	qkKKQrtwspxq6Nwv5ij4AsdcB9xGLuQRkXNnP8clAgcajw+POu58HWkvIQvyUHCzjegu79SiZ+m
	Zd31HxZ1IShz8OR1mqXi75A6
X-Received: by 2002:a05:622a:1884:b0:4f1:df6f:6399 with SMTP id
 d75a77b69052e-502a15e468cmr183024831cf.14.1768916394245; Tue, 20 Jan 2026
 05:39:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 14:39:17 +0100
X-Gm-Features: AZwV_Qhyxy4QYBC9vsg-1pl1r-iBwYh-56DZQ4fI_mrGZ4r5y44flCCfgaeUkgg
Message-ID: <CAG_fn=VWpu6eDgumX7KV1LuRu+qYJjQzKqqYyapwyzPFWrAYXw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] kfuzztest: implement core module and input processing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:

> + * Copyright 2025 Google LLC
> + */
> +#include <linux/kfuzztest.h>

General comment: please include what you use.
Make sure there are headers for e.g. add_taint(), pr_warn(), kzalloc().


> +        * Taint the kernel on the first fuzzing invocation. The debugfs
> +        * interface provides a high-risk entry point for userspace to
> +        * call kernel functions with untrusted input.
> +        */
> +       if (!test_taint(TAINT_TEST))
> +               add_taint(TAINT_TEST, LOCKDEP_STILL_OK);
> +
> +       if (len > KFUZZTEST_MAX_INPUT_SIZE) {
> +               pr_warn("kfuzztest: user input of size %zu is too large",=
 len);

Let's change it to pr_warn_ratelimited() to avoid log spamming.
Or maybe -EINVAL is enough for the userspace even without a log message?

> +               return -EINVAL;
> +       }
> +
> +       buffer =3D kzalloc(len, GFP_KERNEL);
> +       if (!buffer)
> +               return -ENOMEM;
> +
> +       ret =3D simple_write_to_buffer(buffer, len, off, buf, len);
> +       if (ret !=3D len) {
> +               kfree(buffer);
> +               return -EFAULT;

I suggest returning `ret` here if it is < 0, and -EFAULT otherwise.


> +#include <linux/atomic.h>
> +#include <linux/debugfs.h>
> +#include <linux/err.h>
> +#include <linux/fs.h>
> +#include <linux/kasan.h>
> +#include <linux/kfuzztest.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>

Missing <linux/slab.h> for the allocation functions.

> +       /* Create the main "kfuzztest" directory in /sys/kernel/debug. */
> +       state.kfuzztest_dir =3D debugfs_create_dir("kfuzztest", NULL);
> +       if (!state.kfuzztest_dir) {
> +               pr_warn("kfuzztest: could not create 'kfuzztest' debugfs =
directory");
> +               return -ENOMEM;

Note: leaking state.target_fops here.


> +       for (targ =3D __kfuzztest_simple_targets_start; targ < __kfuzztes=
t_simple_targets_end; targ++, i++) {
> +               state.target_fops[i].target_simple =3D (struct file_opera=
tions){
> +                       .owner =3D THIS_MODULE,
> +                       .write =3D targ->write_input_cb,
> +               };
> +               err =3D initialize_target_dir(&state, targ, &state.target=
_fops[i]);
> +               /*
> +                * Bail out if a single target fails to initialize. This =
avoids
> +                * partial setup, and a failure here likely indicates an =
issue
> +                * with debugfs.
> +                */

An initialization failure could result from something as simple as a
name collision.
Do we want to bail out in such cases?

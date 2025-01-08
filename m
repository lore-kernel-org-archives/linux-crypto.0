Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A6C198E80
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jan 2025 04:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736309854; cv=none; b=C2jIY76baehx0NnVwGXqeO6quTBckhQecf2XsVA6Vx6umMULygT3UUthlHc8JIY2f0YlQ6nOB4HWdeyn/rQrrW22ta4MxYJzVPUO3J9YuZQMUWSklfxQFEh9MTuzZxN6vjTcqxGt2sOI60n65/Mt9VDVvSUxoCCt1t8Hp54Wys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736309854; c=relaxed/simple;
	bh=QSVu2eVPppDsm5BFvyowLRyUsDZyN49SsqxHbqtsTPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=En2I75uf4o1t9iWWfPl62z6Qy03bEEyj1+GYGwkAy7BV+Tjoe+dXAbKI9i9CfNbugczEd2+tub4oIUdb5sKtJ/UEiSXGu99WMYtCmBhlPL7sTH8owZ96uHuh8n+ssWGI/0hqOuvbons8tyKZi1AjKVFb5XqJsjH3BFhyB3MMUQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w6PN2o2X; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w6PN2o2X"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4679eacf25cso89697261cf.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jan 2025 20:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736309852; x=1736914652; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Yc9mZAfT6V6ArAXeLUQVlPLk9ybss1V+MmISZuZ1RI=;
        b=w6PN2o2XiMu1V6iTT3EcbIDMxiDwZVqvUS0aOjFY20q3abWw1pPi+Vy1Y7/Jr6FPh0
         zJxkjEz5kZ5xJvxnLI7MDIbvoYbHMblS+vpAQxpCe2eKRN0P1+rBZ8RIr0ezVEPj1PQO
         aoMzXisT5PSfcywFLvs0tz4XBeFdcrCAd871gUQ1J+NZcYeQepxbqg0rSM4gqX4fVgAV
         D25cpRNy6E+eKC8a8Z5qh3pwxBb73Bpc7hiR5rzyF5teoDBlyRoQvAZXC0DAbPqrIf+F
         WIDKPiIgKDXxdz7rjYwxFQLk1pi8A8sbxdQpJLeLxa/CIEPkuACIfHr0uwxyl9Kqz73H
         DqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736309852; x=1736914652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Yc9mZAfT6V6ArAXeLUQVlPLk9ybss1V+MmISZuZ1RI=;
        b=w/4MRcXGMDx4cM2urGE33dMbQYTnS336wkwhVzA/mop0cCDdfciGbs1+kZz5TbqBfL
         1o7utGRAadxmAiMXXEtUf77/WRcRokyPq0I4H8d2fdMvdQ+/ltUj30Md6Mde1Rai3c4Q
         sNsWjJ9VHoVLHNMpgowPJ7nbtxmBhnJvELo4Fj21TqU1dlwvBBV2BNlTm63kCuO67bK8
         vjcvANYZSRWemY0UQtN3uQ9kxnXl03bltl+aAfPkhhGhHk3eZQT5F8SQZ5yrHQOi5eNH
         UXY77OzITDgf9l5/wrBGzktAcfl6JIcVhduizsPQXJUI8U7T65//hbwdYN6c36+Y9+/k
         6Mcw==
X-Forwarded-Encrypted: i=1; AJvYcCV1MsZcRMr0A8DMnEHwjxBaNExD8O5qd4iR4Fez8FUrrcLesITrlJg0nHgLrANKbF/KnXg+HOxjBiiOOOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQC5FR+Sv2G/STc08keOSMV7LMQ5s/oMd+l75NfN0nbBx65an
	lpi1Hjtavz98ZlKt3HHsNVsBjtVi6uh+hB4PCYQHjFqtQ/MdcF7oGI1wOuz+/KcWqGAid5+7asY
	QqJaDabliyL7rF36v8S3un24YdoF2D8OzGhTl
X-Gm-Gg: ASbGncvfQtNKmTSCXFgoiVkJnqZdfsdtlpdUp1EOuOKuYuuCc7UkUJZ/DADTHnqNfZc
	hqb/WvWYqMA+hUZg2N1V2YpvUh4XRCV/0mrI=
X-Google-Smtp-Source: AGHT+IHubh8JdlZy8enWlyA4v+Thqive2415xKAhHBXZciV2IK35dqZnjO15cZfeq2i95UJI4vfbjffy/yWdqgjY4ro=
X-Received: by 2002:a05:622a:294:b0:467:87f6:383 with SMTP id
 d75a77b69052e-46c710f9ff0mr27571611cf.52.1736309851846; Tue, 07 Jan 2025
 20:17:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
 <20241221063119.29140-11-kanchana.p.sridhar@intel.com> <CAJD7tkatD8Qw582C4gOsHRNgN3G7Qx=CxzV=FExhvroCaCAW6Q@mail.gmail.com>
 <SJ0PR11MB5678F6B135763812DE92AD48C9122@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678F6B135763812DE92AD48C9122@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 7 Jan 2025 20:16:55 -0800
X-Gm-Features: AbW1kvajCmHZRI_eSFFMKODBssd2ouTiX22XclorxGeJUv0xa9N1AP9Ex1X-T1M
Message-ID: <CAJD7tkYZiz4SaPsqVai1HQzwOV3Y8yoVt9V8m7+dSKi_VfSseg@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"

[..]
> >
> > > +       }
> > > +
> > > +       acomp_ctx->buffers = kmalloc_node(nr_reqs * sizeof(u8 *),
> > GFP_KERNEL, cpu_to_node(cpu));
> >
> > Can we use kcalloc_node() here?
>
> I was wondering if the performance penalty of the kcalloc_node() is acceptable
> because the cpu onlining happens infrequently? If so, it appears zero-initializing
> the allocated memory will help in the cleanup code suggestion in your subsequent
> comment.

I don't think zeroing in this path would be a problem.

>
> >
> > > +       if (!acomp_ctx->buffers)
> > > +               goto buf_fail;
> > > +
> > > +       for (i = 0; i < nr_reqs; ++i) {
> > > +               acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2,
> > GFP_KERNEL, cpu_to_node(cpu));
> > > +               if (!acomp_ctx->buffers[i]) {
> > > +                       for (j = 0; j < i; ++j)
> > > +                               kfree(acomp_ctx->buffers[j]);
> > > +                       kfree(acomp_ctx->buffers);
> > > +                       ret = -ENOMEM;
> > > +                       goto buf_fail;
> > > +               }
> > > +       }
> > > +
> > > +       acomp_ctx->reqs = kmalloc_node(nr_reqs * sizeof(struct acomp_req
> > *), GFP_KERNEL, cpu_to_node(cpu));
> >
> > Ditto.
>
> Sure.
>
> >
> > > +       if (!acomp_ctx->reqs)
> > >                 goto req_fail;
> > > +
> > > +       for (i = 0; i < nr_reqs; ++i) {
> > > +               acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
> > > +               if (!acomp_ctx->reqs[i]) {
> > > +                       pr_err("could not alloc crypto acomp_request reqs[%d]
> > %s\n",
> > > +                              i, pool->tfm_name);
> > > +                       for (j = 0; j < i; ++j)
> > > +                               acomp_request_free(acomp_ctx->reqs[j]);
> > > +                       kfree(acomp_ctx->reqs);
> > > +                       ret = -ENOMEM;
> > > +                       goto req_fail;
> > > +               }
> > >         }
> > > -       acomp_ctx->req = req;
> > >
> > > +       /*
> > > +        * The crypto_wait is used only in fully synchronous, i.e., with scomp
> > > +        * or non-poll mode of acomp, hence there is only one "wait" per
> > > +        * acomp_ctx, with callback set to reqs[0], under the assumption that
> > > +        * there is at least 1 request per acomp_ctx.
> > > +        */
> > >         crypto_init_wait(&acomp_ctx->wait);
> > >         /*
> > >          * if the backend of acomp is async zip, crypto_req_done() will wakeup
> > >          * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > >          * won't be called, crypto_wait_req() will return without blocking.
> > >          */
> > > -       acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > > +       acomp_request_set_callback(acomp_ctx->reqs[0],
> > CRYPTO_TFM_REQ_MAY_BACKLOG,
> > >                                    crypto_req_done, &acomp_ctx->wait);
> > >
> > > +       acomp_ctx->nr_reqs = nr_reqs;
> > >         return 0;
> > >
> > >  req_fail:
> > > +       for (i = 0; i < nr_reqs; ++i)
> > > +               kfree(acomp_ctx->buffers[i]);
> > > +       kfree(acomp_ctx->buffers);
> >
> > The cleanup code is all over the place. Sometimes it's done in the
> > loops allocating the memory and sometimes here. It's a bit hard to
> > follow. Please have all the cleanups here. You can just initialize the
> > arrays to 0s, and then if the array is not-NULL you can free any
> > non-NULL elements (kfree() will handle NULLs gracefully).
>
> Sure, if performance of kzalloc_node() is an acceptable trade-off for the
> cleanup code simplification.
>
> >
> > There may be even potential for code reuse with zswap_cpu_comp_dead().
>
> I assume the reuse will be through copy-and-paste the same lines of code as
> against a common procedure being called by zswap_cpu_comp_prepare()
> and zswap_cpu_comp_dead()?

Well, I meant we can possibly introduce the helper that will be used
by both zswap_cpu_comp_prepare() and zswap_cpu_comp_dead() (for
example see __mem_cgroup_free() called from both the freeing path and
the allocation path to do cleanup).

I didn't look too closely into it though, maybe it's best to keep them
separate, depending on how the code ends up looking like.

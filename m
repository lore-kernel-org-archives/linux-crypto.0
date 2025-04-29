Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8891C4609
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745923577; cv=none; b=EE+T+0mhqfwDo4oSuegSJfr+HD5aaILxFxgZq7GlTljBkHrfkDSPjlHoAIVj5sXDcQBunAQ0xiLl0fq122jkTw1MfaEtcxh2MNr+kr1rnnlKTBUMZ/SG/pQ0qFPyQsEQUCjxPBn+ou0w5kKWzEsxn1jQwFEz0J026vFizUmDup0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745923577; c=relaxed/simple;
	bh=Fs1aFS6opvByAbBh37Sle+MMGbZEdG/PsjGn4YMxeV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=La1UIPqvy2yY/vx4O+21nqsqp8vkx54IVFasvqPns35NnzbCc5eL5WvtDBrLHnyoLsgGERFeMiLPSR1rvC8k9Si7C5vhkiViqiUIz05g2kXXmFc7EPrxZFH5ScZPA+DY8uznmW5sjG3gm1dSlzhGieuVBd62ED9sH5AwKqlN2uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=MwevwRsG; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="MwevwRsG"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e6df4507690so4553014276.0
        for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 03:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1745923574; x=1746528374; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hF8vKN9sh8z0ZO8tOpt/PfKR+YRXIdIXAv4/thippV0=;
        b=MwevwRsGpthsFaaPfW+axNsh8M5IMzMwvlN0XKgsmlXfB8cavAnO08a5HtPtagqxNK
         2ZqpB7+NN/1fR5wRhAp4aNN1bWz7N2KdOYpebwoi9f5prVN96KjT8JSJ5KV94qwOj5DF
         FTGbjN/ueXG5RzfMVtBWu1toxnXiXoU4cjkSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745923574; x=1746528374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hF8vKN9sh8z0ZO8tOpt/PfKR+YRXIdIXAv4/thippV0=;
        b=TKcvOqGv2Q8ULzTpgTkRRpjrUr0acevMXcqUBH5Afd8cH814HqfKdC4HPGFnKEuHSp
         77lZ3bsWAMA/ebHrUpQxSNFajG7QWcxwZ7oS9gMGwLFlnJ4s7Be0K8NRDOEI0IdW4iAw
         BUjUIzBo91swx98WbvLKkl/4afrBlQqTZQGgH/fxqpgiMYnIWL/9YVq+1UJz5SPZDrkZ
         keutjt1Y7F4EwX1OSRhJbWHO2hwShOJfjp4R+zQwiDUAVFw093uOW/n0wvyY8MCDcybx
         nd6cNTf65YLWPu3QV47DoyBH1KoUEcpPRrqLDLzJ9xd0R1GAMmSUUSTZZBAYmcTUwABy
         Dodg==
X-Gm-Message-State: AOJu0Ywz4bQP/JLcEf6R1t+qaS2C8f8V9YZ1pE2wPZRAKP1OTF1Lq72C
	T6d/5pq+tWwyZhBDhVw5HkeMNGDSWYfTeippFNbte7nS8AYf43he8DZXKXJxqknXDCEL91D/pC4
	W5txmZ5hJ0G15VNUxCsLvOybU1WrWiXQj/SXuJbkbscCm7Qd8
X-Gm-Gg: ASbGnctAXoYf+MaanOz7rSg80L9201J/9P/nKxOlPe19jpjSOmS69a2SZcEtheVcAtE
	kE+cdBaAO5szojBBUIGnN8XJvBonJp5kdBcosmNVb2sr0NalolqMbNpcc2J0DF6IrU8c42bVTyi
	iFYLHsVBdzKVmKJ9lKrmCuf/NQDLTnL+fmrQpJktEihA7uK1caSYiJikk=
X-Google-Smtp-Source: AGHT+IGa5Soai89tjfK+oZA5gyBDX32F8Eol887fw+QprtCC0h1OiddDE+yPmdB8AvU79PCN3CxoqjI09aOhKcTBLtA=
X-Received: by 2002:a05:6902:488f:b0:e73:cd3:5250 with SMTP id
 3f1490d57ef6-e73511bd4bemr3420566276.23.1745923573760; Tue, 29 Apr 2025
 03:46:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423101518.1360552-5-pavitrakumarm@vayavyalabs.com> <aA30mVmjAahKb1P-@gondor.apana.org.au>
In-Reply-To: <aA30mVmjAahKb1P-@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 29 Apr 2025 16:16:02 +0530
X-Gm-Features: ATxdqUGZ2Ep4oayvRUmOZ6OsH0awXvVmqSlv8_hTfisW-DbZ9yQhAWg1_Fka_E4
Message-ID: <CALxtO0=gwbQH9Hk69spwN_Z4hZN833o4KNSgNKGm85w6XEgf5A@mail.gmail.com>
Subject: Re: [PATCH v1 4/6] Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	adityak@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
  My comments are embedded below.

Warm regards,
PK

On Sun, Apr 27, 2025 at 2:41=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> Pavitrakumar M <pavitrakumarm@vayavyalabs.com> wrote:
> >
> > +static void spacc_digest_cb(void *spacc, void *tfm)
> > +{
> > +       int dig_sz;
> > +       int err =3D -1;
> > +       struct ahash_cb_data *cb =3D tfm;
> > +       struct spacc_device *device =3D (struct spacc_device *)spacc;
> > +
> > +       dig_sz =3D crypto_ahash_digestsize(crypto_ahash_reqtfm(cb->req)=
);
> > +
> > +       if (cb->ctx->single_shot)
> > +               memcpy(cb->req->result, cb->ctx->digest_buf, dig_sz);
> > +       else
> > +               memcpy(cb->tctx->digest_ctx_buf, cb->ctx->digest_buf, d=
ig_sz);
> > +
> > +       err =3D cb->spacc->job[cb->new_handle].job_err;
> > +
> > +       dma_pool_free(spacc_hash_pool, cb->ctx->digest_buf,
> > +                     cb->ctx->digest_dma);
> > +       spacc_free_mems(cb->ctx, cb->tctx, cb->req);
> > +       spacc_close(cb->spacc, cb->new_handle);
> > +
> > +       if (cb->req->base.complete)
> > +               ahash_request_complete(cb->req, err);
>
> This can only execute in softirq context, or you must disable BH.

PK: Sure, I will fix that by disabling and enable the BH using
local_disable_bh() and local_enable_bh()

>
> > +       if (atomic_read(&device->wait_counter) > 0) {
> > +               struct spacc_completion *cur_pos, *next_pos;
> > +
> > +               /* wake up waitQ to obtain a context */
> > +               atomic_dec(&device->wait_counter);
> > +               if (atomic_read(&device->wait_counter) > 0) {
> > +                       mutex_lock(&device->spacc_waitq_mutex);
> > +                       list_for_each_entry_safe(cur_pos, next_pos,
> > +                                                &device->spacc_wait_li=
st,
> > +                                                list) {
> > +                               if (cur_pos && cur_pos->wait_done =3D=
=3D 1) {
> > +                                       cur_pos->wait_done =3D 0;
> > +                                       complete(&cur_pos->spacc_wait_c=
omplete);
> > +                                       list_del(&cur_pos->list);
> > +                                       break;
> > +                               }
> > +                       }
> > +                       mutex_unlock(&device->spacc_waitq_mutex);
>
> While mutex_lock obviously cannot be taken with softirqs disabled.
> So what context is this function called in?

PK: Agreed. This function is called as part of my workqueue, so
softirqs are not disabled. And the mutex_lock here is to traverse the
wait queue and flag completion of a job so that the hardware context
can be used by other waiting jobs. SPAcc has 16 hardware contexts
only.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

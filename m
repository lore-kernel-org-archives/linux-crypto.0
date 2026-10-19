Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7103F4F4CFA
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414869; cv=pass; b=pIyHJ59QUof5kmiQ+UW8gV2vgT7yKBlXs+llJsJIxPw63y7Rk3KWjLu6KP5qdyW5/xY3WqOqEA9iYqF1obDq4CwEmezqoDL8ST68Y7oRv6jpchw8OkNvPshBQ+kdEeVPEdnvR861Y6H1FDCfBur/HXU+vH9uajgQ4KVp3TTIdvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414869; c=relaxed/simple;
	bh=de4WRoZFaD3lgjauScr5sV8aw74tWRpk4ewrSfnzero=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agKeKT6zfUjkecKOuRGJ0GNoUETE/F9jkwedjdXCowDx2HTcI97NuASBMGL0s9p0XDeaOm9HIrELZk5HEHxovOxzsrIYOw11erg80JcMVeI3QQaJkE1oSiMKiQN2pwlC1Y4cNf6WnGIK2+jHF4KHCgAljnZYsWj+JW9WqTmK7lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cizj4eee; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cizj4eee"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4301e334ceso69535766b.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 06:01:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792414866; cv=none;
        d=google.com; s=arc-20260327;
        b=ch8LlVydJZyVMw/+5y5b5QEEjnEvKf2u6MYbnDpxCQ1tyR/aKu+gMlhm4v3c3xUwVU
         kUgcXSH2Ew0UzAEW6Y2IF3/asPkfXAgZGaBgBGyjKxShreeTrOnPyMdgdGNkF2sPGuPI
         kOA294LrG2fthxUZ4vixaFNR5rtBSCs3yTF/F2ZNTav3m6o6bkISDEoCuCYowKxyPVIn
         fwOlPiZhXHmeNe8m+hqriEx0ZoQoZYKwi5bkqJpi/Y0af6ARyoKH/eQ8DxMiAjQQkDBV
         Uj58aJgVOJlH8r9tn+flm+lsFCU+nu5HZjMQrp9+Jq5j3BM4gw67821CG13OjnWs9a9y
         AhAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=phogftG3FaF6nlP3xa0hV5oXVTce+rqKpGshxnP7eVk=;
        fh=MwrF04NTqA0aDZEW6xYiKEIkWQxitKZi3OjE821aNJ8=;
        b=KEqFpXOFyNC0gWQ3+gZii/Qleju2A+al5/9ZMnvnfdZYru3SdUosLbvck3t5/F5CA3
         lSC4ilgz9adG08lMm8u2FdHMLP2qmyQAds3PAhz73lCwK42U/UTuRXkWejQAdPJI9xFe
         YjGzoANNkrJwZ7hi8VB4HHuCPIxJ1EfcTyWa29abKtaXPQCwMwUj0X+jxOLMtLBg8LXH
         lEML9t1xrhbh9pi/5kVUTNZNFpLoS2wA4VC4giNOgOZzT84WC4cNF2UEPJJunn3+whK1
         nGXsCfwBX/t2xs3jrd3oBIJYQSsju1Mxk2jQg1ckHP4OnnQVm84Z5f4X+nzAAiK8GK/g
         vrRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792414866; x=1793019666; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=phogftG3FaF6nlP3xa0hV5oXVTce+rqKpGshxnP7eVk=;
        b=Cizj4eee5qf8fVnAE2JTD4fMX547a2d243E/Z2KkinBFCP9NmsdK/WcOLqKKpwyr1E
         7jg8BCVRUfdYo6FpmabSy5GaaKRwwfF+zQ59GSOuuJz+oPWzGsA9ZU8gmeVdkfK43uoU
         z7XtVyaBlbE/bdfUBpE0SsEdDnrfxekglKsYYpOVSOQh6cW/WYHY5f2MEMhJdaKXsJEh
         FJhS1UaX14WsQSl5vYE5DFsKWEOM4z8ZSesorgkzxYlxXFZdCuBLiX++VCZyTQCaymmv
         MXBVS0yUKKHUjdIN5DBzbGxQ0hPe1Vz4PToPjO+nMY0V1au58VXfY7SITU7j9CbFiyeq
         1HQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792414866; x=1793019666;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=phogftG3FaF6nlP3xa0hV5oXVTce+rqKpGshxnP7eVk=;
        b=PVa+RzIndc2EYs89SCMEncd7Jbw9cPRRd9BNKjvJ03ltZL6Z1XQ/sCSGCaTa4wsrdI
         4LZKzqeHZ4UBGtzjPb6iR6FtiyjFMTOQ3j7LghFGxwF2uWJmJjJIMJuWXSngwxsbXuFA
         uDSP+FNAFnHY4mISOjocqjaQRH337TrDpJxjPsrDbYzvIk50zCVYAnVbPsF/UQAi2ljT
         cwqcEtFqbvHtL8iJpwwbnIdp7/wfTJ+xjYokv8cai8v0gJUsPdqMkYCfOiMEjcQBovnh
         OboD3NQnqez9t2pwRCU6/7xbQTeR8cDoJhq2zcu28KwppyNtdnx+4tDaYa0ljYroMlA3
         heeg==
X-Forwarded-Encrypted: i=1; AKwUvBzUnMFsBCy8hyuunxoZF7yKoYngLs1bBTr54C1SVbIG7jW1I2vZeGDO/MHLPN5SzhhNw10wGhmQg9xF+zg=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7YvCXf5fGJxfI9/gagYH82AfwpDB7NvPwOdOhKyOz36+6hKfQ
	Ib3m9f5gV3EogNBS8/8pXQTR7UJDp+uSGDUTZRcdveRG0+jRpZmKB2FPyYxL1JOQ7hUmxHRxltU
	T/G1zAlF3UySWMc4UvkcYvbPIeIqHlEazPg7R
X-Gm-Gg: AYBFou0keZBzhNGBkl+35olR418lk5PD64lmNk1g8SJhhRsstNBIKL6hA5bL9O4SZLM
	B77fZ1QXcOMrCU95GnrbQI00PSJOuNewYfZayYzzyaYsm4w5Cma2uBKE9kDY+r25hk04IXzPjU4
	DM4NV9UtWqFIDikhnV2V5KEuURlg84tK5zprtgMO8hUmkfdMurvlBMpg1LjWMA9sH6XTTIm1ily
	sQtBwwjv1KR5sgRPEsUe+VUz9Jr3pjk2e2FTCZdXCk0H8XBL0aI2sn82oNgvSylu236kEzfI85N
	mV5OslGiTKzdr3zwb36DtoIjxP7Yt8ZuES/ZmbIBfZWhq2VbqGu2PP26BTZZq3RcnAat4zApuor
	VVyn4bZmrobzwWU4iwrN9DDtnN3KdOFxrmlv21FxouYENZePXaTkHyJCO4ehAJqzhiAcwaMxN3B
	U=
X-Received: by 2002:a17:907:9702:b0:c3f:7e8:235d with SMTP id
 a640c23a62f3a-c419b13cb81mr585828066b.5.1792414865469; Mon, 19 Oct 2026
 06:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016103640.4989-2-blum@kernel.org> <CANc+2y7ruqmfO+D_nfdc9rnBE0uSSnZR9UJY2Dvc5Nez9U-61Q@mail.gmail.com>
 <atUuAsxE42s8NGEY@kernel.org>
In-Reply-To: <atUuAsxE42s8NGEY@kernel.org>
From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date: Mon, 19 Oct 2026 18:30:00 +0530
X-Gm-Features: AclHuK9F_lIB1oQ9kkXqLikaEL15-RIDnT85r6_EBtYmdugz9hD8gsTn-BpuPrU
Message-ID: <CANc+2y6Wf8HCf6mUdZb3dALZitMUR=JdhThQWMyp_R=AdMKH9Q@mail.gmail.com>
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed restore
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rusty Russell <rusty@rustcorp.com.au>, 
	Amos Kong <akong@redhat.com>, virtualization@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Oct 2026 at 02:07, Thorsten Blum <blum@kernel.org> wrote:
>
> Hi PrasannaKumar,
>
> On Sun, Oct 18, 2026 at 10:30:08PM +0530, PrasannaKumar Muralidharan wrote:
> > Hi Thorsten,
> >
> > On Fri, 16 Oct 2026 at 16:16, Thorsten Blum <blum@kernel.org> wrote:
> > >
> > > remove_common() frees the driver data during freeze, but does not clear
> > > vdev->priv, which points to freed memory. If probe_common() then fails
> > > during restore, a later remove or freeze can dereference the dangling
> > > pointer.
> > >
> > > Clear vdev->priv on the probe_common() error cleanup path and before
> > > freeing the driver data in remove_common(). Also reset the device and
> > > return early from remove_common() if vdev->priv is already NULL for a
> > > safe teardown after a failed restore.
> > >
> > > Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Thorsten Blum <blum@kernel.org>
> > > ---
> > >  drivers/char/hw_random/virtio-rng.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> > > index 5e83ffa105e4..a9ff520975a7 100644
> > > --- a/drivers/char/hw_random/virtio-rng.c
> > > +++ b/drivers/char/hw_random/virtio-rng.c
> > > @@ -190,6 +190,7 @@ static int probe_common(struct virtio_device *vdev)
> > >  err_find:
> > >         ida_free(&rng_index_ida, index);
> > >  err_ida:
> > > +       vdev->priv = NULL;
> > >         kfree(vi);
> > >         return err;
> > >  }
> > > @@ -198,6 +199,11 @@ static void remove_common(struct virtio_device *vdev)
> > >  {
> > >         struct virtrng_info *vi = vdev->priv;
> > >
> > > +       if (!vi) {
> > > +               virtio_reset_device(vdev);
> > > +               return;
> > > +       }
> > > +
> >
> > The virtio_reset_device() is always called before setting vdev->priv
> > to NULL. So the virtio device is already quiesced, no need to do early
> > return. Isn't it?
>
> The check is still needed.
>
> For example, during hibernation or suspend, .freeze (virtrng_freeze() ->
> remove_common()) frees vi and sets vdev->priv to NULL.
>
> On resume, .restore (virtrng_restore()) calls probe_common(), which
> could fail and leave vdev->priv NULL. A later .freeze or .remove calls
> remove_common() again, which would dereference NULL without the check.

Yes, it makes sense.

> Best regards,
> Thorsten

Change looks good to me.

Feel free to add:
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>.

Thanks,
PrasannaKumar

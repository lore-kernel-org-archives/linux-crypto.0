Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB82D3A380C
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792342822; cv=pass; b=t8L5Jdyf6kO76YwM31VIc0Nh9HPPb59+1JocbtN/DBt46XDyInX9o3ZRsI3A6cdzpl51xBGXM8Zj9FxCe3uPHCNEuIpBm6o8mV97M1wb9I7nQyX6FmjgQ6xVfwPE3XUcdcVc6vNn4iNZ9e9kdtS6kSUPkzu6yyeX8lyOTEEgxLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792342822; c=relaxed/simple;
	bh=g/JGIrVbzY2CScB/KpNY8unmxw00ClvPmppC33lSWpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ivzLy/llhxl3NDP34NmJdV+swd7fwn2pU8eEx9otsS3DxUMoFW1w/uAfYZdvsuH84Aoe9oFkEAc5FyqFyjCtjdbkBFJhV58qoQpsYZs+O6ZjgmfxJNqnGeZFFTywrHCXB0YX3/DSkSI8lFIf6WrWq8sAeXnNEvdkL6Y0UoES1nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCTMdb5l; arc=pass smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCTMdb5l"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40e9aff12fso25612266b.3
        for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 10:00:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792342819; cv=none;
        d=google.com; s=arc-20260327;
        b=LhnpzWuPeDtR0vpo3caNntYDOE0coj6UBdBxt1b+JKdrOU99uoHtzQnnR228HVOf0k
         TuaYyvEh4XI066c1mV12/ta2/iTCRrs/wayTHekD1bgDk39cG6fu8x2uszoMdBGfEcZg
         uS1UzL0ChWZkDI+yBQiyI4YSBE4bUD+SpxPyZX4nW/IO1qiS/nIpuZpeq8VbTKdnIzpP
         69zg8MUtEa2ChhJk0eykmim9GGGYOMBFS6x1VPMDGdRzfTkClsoioEHYClMHi179Ogvc
         CpxzTdBDcgOfGYVLGrU4x1LPQbeTN0YQ0Q3gcr8KzNUiH7wUM4jr3GPBizYTMobdsRHE
         GmOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2/1Y5ghSBlEp/00kqDwKjo69e3DTVuqhYG4tCNcmd4Y=;
        fh=D0FeAca+YbWYfrpTYGHGvmVpWsgxwXOrzWSlLxF55+M=;
        b=P4RPkt+WeNMolxQL4nwNuNpGUvTiv3nYA+4iSxXQYb2zCZi+WaDx1PQRmZ33IHnYdJ
         ciVd5xkB4MtokURWm8X+6XkmoFZCD7wzRUi8wP3hrduS+rJ3hWKqFen2KCMDlQoFrTSa
         sL/HcpqQ1vOAtW6Eu1R1BRyV072IKSgC4clWMlvAxPalOWMiGMFUp9phdWSe0/okhIPA
         dcs/5fqln0QduokO116y0keTLjTO/aCBDdn+6dNY4/6y3SDycgZUWKlfjTuLP4LGXAhJ
         UBxxeVO15f86N3MM1V54YgwEwYy/O71yY+6z1P6T0pE6U7Iuqy05/CJjviT3uw2yCtyN
         7pjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792342819; x=1792947619; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2/1Y5ghSBlEp/00kqDwKjo69e3DTVuqhYG4tCNcmd4Y=;
        b=KCTMdb5lYY31W4EOnOXwBsqyCMrEvyLBtiNkKOpkpsQLanu/ZwR76T1NzwKdK8tTgo
         EO4wGYPp3hg8ZrFdrQBHgO70Bh94fpzjjb73efQgSsivx4RLdEolg9qgB76dwlIT0j97
         PbH4APf+FHUo0L8T9usCSgySHxInol+3XBs1cqnIY9XMlBGVsMHLofIi4FMLV34khbtP
         jz2H05dt/Ys9q4Pgkib56GjeieD+rdBZ58NPj0Vy2D8shFt3eMZ84gyaHMLv7WTcV7n6
         JRjY5BPW9XxitBGOkf6JGjBat3l4rcT7sMUapypW5eiPHo7RAgdnMbdqoWKWZw6VgEA0
         CCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792342819; x=1792947619;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2/1Y5ghSBlEp/00kqDwKjo69e3DTVuqhYG4tCNcmd4Y=;
        b=iMJLR7Kbmc9Gzo2Gwj6iptDGXX2rFWe/ntqVD7iMWgNqv3sc7rE2wtwLMyimd0SFGA
         bxs9yqd2EhhnTkag1sqsNGOb0oB/CF0zLP9+GJ6D8IUjCI3YOYIMMAhZYAilH+3MVT6u
         Xx5uYDHqPcIhx/MyGsji0gS+iUEhR4APKp9f67B4We/g/VaSOxNxKb8/nOWKahFiAB4p
         UHkrHAtcuLKOPW/B4mugpV/x7RRSkcmuyrsU67bcvnL4NCA4O2FiSyez0gbTpQ5v1nD+
         2RBe/CQyrwVRcoM0b9e+SmgJi+8XI3K2NA3Rac63WyO0u4yhiPqqVWxUR1WUBnsnRibw
         f9ig==
X-Forwarded-Encrypted: i=1; AKwUvBy0xG3x4mN2pGp9FAfYG9ZQFbNIC90+VjrMvkT+kI4lS+TFYAcDt56jsd9htsiiN7KDDbASm/UUo+OidM0=@vger.kernel.org
X-Gm-Message-State: AFq9FYLlhg1hZUrUNb4yUGY4fPtzUto4tv0x0nS03SyH9vL8zWrf98rl
	kiZLQGgrNB99vS7oj8w0WV/7NDeZYvkrAQTxyMwq1AixywGW23ugNvjBYCa7c8CF/Jo+O+xMgDb
	nwuJgPZmFqy5qPeP8P8rV9GoArnp3oKg=
X-Gm-Gg: AYBFou3jB1tLye3U3D6O6VKDzosAln/wm0KdnZaCPYLDqU8Akwo7el3HGZoFm1IFDmB
	/W0g7IMHQXxCKDrDIM4B5hzAAOk32bjqHxX1CYBytGu6nxeqLn6l/Y69ZmqG7vYnbl/V4XQ6FaO
	cIEUHAnCgBfj99qF7bpD/R+3CLMww8Ywy79pQCBipYlf9O4AAhrcKhmz3CIFZMeAzZmWrw7/zDs
	XA9OObY5KKFvvakqeNwV+IV6mkkMseBPr09w3X0QntnIL+8KZ8tIiJLJ7yXsSpIsFg7wxXQT4xX
	Yb8cru7/v3oOD0xjO8ox5B5T5O3k7rmfEaeWIdF9VOompgAwWG+UDlFaS9vRsylJXXdQ4zswmwc
	cUniXpBUrjNaRNJVn2da95ku/azZPHtpYPw==
X-Received: by 2002:a17:906:f597:b0:c41:55b4:d88b with SMTP id
 a640c23a62f3a-c41a00f1a94mr354678866b.43.1792342818130; Sun, 18 Oct 2026
 10:00:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016103640.4989-2-blum@kernel.org>
In-Reply-To: <20261016103640.4989-2-blum@kernel.org>
From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Date: Sun, 18 Oct 2026 22:30:08 +0530
X-Gm-Features: AclHuK-nQ7ZtqX-oks4iRGuLf-PLYl2NcnCVNUFe0eh8h6uUfoXPMhFqyj8drsU
Message-ID: <CANc+2y7ruqmfO+D_nfdc9rnBE0uSSnZR9UJY2Dvc5Nez9U-61Q@mail.gmail.com>
Subject: Re: [PATCH] hwrng: virtio - prevent use-after-free after a failed restore
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>, Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rusty Russell <rusty@rustcorp.com.au>, 
	Amos Kong <akong@redhat.com>, virtualization@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Thorsten,

On Fri, 16 Oct 2026 at 16:16, Thorsten Blum <blum@kernel.org> wrote:
>
> remove_common() frees the driver data during freeze, but does not clear
> vdev->priv, which points to freed memory. If probe_common() then fails
> during restore, a later remove or freeze can dereference the dangling
> pointer.
>
> Clear vdev->priv on the probe_common() error cleanup path and before
> freeing the driver data in remove_common(). Also reset the device and
> return early from remove_common() if vdev->priv is already NULL for a
> safe teardown after a failed restore.
>
> Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/virtio-rng.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 5e83ffa105e4..a9ff520975a7 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -190,6 +190,7 @@ static int probe_common(struct virtio_device *vdev)
>  err_find:
>         ida_free(&rng_index_ida, index);
>  err_ida:
> +       vdev->priv = NULL;
>         kfree(vi);
>         return err;
>  }
> @@ -198,6 +199,11 @@ static void remove_common(struct virtio_device *vdev)
>  {
>         struct virtrng_info *vi = vdev->priv;
>
> +       if (!vi) {
> +               virtio_reset_device(vdev);
> +               return;
> +       }
> +

The virtio_reset_device() is always called before setting vdev->priv
to NULL. So the virtio device is already quiesced, no need to do early
return. Isn't it?

>         vi->hwrng_removed = true;
>         vi->data_avail = 0;
>         vi->data_idx = 0;
> @@ -207,6 +213,7 @@ static void remove_common(struct virtio_device *vdev)
>         virtio_reset_device(vdev);
>         vdev->config->del_vqs(vdev);
>         ida_free(&rng_index_ida, vi->index);
> +       vdev->priv = NULL;
>         kfree(vi);
>  }
>
>

The rest of the hunks are fine.

Thanks,
PrasannaKumar

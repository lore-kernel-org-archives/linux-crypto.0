Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4CB15ECCD
	for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716814703; cv=none; b=krYHZWQZtUL8qKCdZOsuuOsgd4stKU5cUpkAjFwiNoKUwdEAki4EujLGpSRsyTAWyeJGIkAbwCYGrb/rshIJLnXeKuqCvcXe9yFrcGZtmtXE9enXhpheF7LhYQnxH+C/LAAo4ku3NKZ+hHEPmM9r2OvQ7C81BCPigzqTfeLMQ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716814703; c=relaxed/simple;
	bh=bmcvhdZmrh6MM9mLmNF5LoiL7grdt8YdrHMavfQCy6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxaVwN33OIioJ1lGX1ocL0HDYeN1CgQ4fsl8HtR7sUvzzsD3w3kLn6wQVMUW9V8MDbfLoaSrzB3CygmB6veYtxUBQ+0YqwtqE5Lg+skCfbVDguTsc2+cyTzgImlu3Pq90BzXUb3steq+kgRROlZzEoDEgAxBY6w5eXD0LfoR3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com; spf=none smtp.mailfrom=benyossef.com; dkim=pass (2048-bit key) header.d=benyossef-com.20230601.gappssmtp.com header.i=@benyossef-com.20230601.gappssmtp.com header.b=Y8p3eWYK; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=benyossef.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20230601.gappssmtp.com header.i=@benyossef-com.20230601.gappssmtp.com header.b="Y8p3eWYK"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6f69422c090so5891427b3a.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 05:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20230601.gappssmtp.com; s=20230601; t=1716814700; x=1717419500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvZlf59fa//TZ0XsXvjA+byhSo5nv4PsjI3fiaMAaLI=;
        b=Y8p3eWYKEJmljk5COSiuAZvkvorZeAUf2+Ny7bS3Z0ok+UjGxmGqonx9PJ5CQjoHhw
         GEd1ssy31/p4rh272GyRHfdZa0pwosPZF7l3drvKi6RzGtPI9A/CNbuakXPk3f38X2oP
         xsPAMov2TNGKUb2af+eEKQYPNrGtGFeQfHNleci5VcGiVrxdNJGaGSLMHz02VBI1uT8k
         hvRfS5g+GwonDUiJjvzkU0PwF4+DwsQEa/7hdJPR+4jiPNGFhJbhtBGsUNQgWbKbhWhK
         2PZqkF9ADuDxmBt9LMFSeQNYUqkLkDVR6AcLxMnrFWC1A/T/ql52uFaj1+8WfJ9tQIIy
         wdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716814700; x=1717419500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvZlf59fa//TZ0XsXvjA+byhSo5nv4PsjI3fiaMAaLI=;
        b=Tj57wIkCBBA7lpjeTJdRPHo2ZryIh/4IvH8c5c+s+AfZuCtYfiWnMhFVZEDgP8tdQG
         +J1uZVdVLV5DozmZfusWB7SLw/86nlWJ5tCd+df4jfja5YEdmf5rxNSlE5GCWDjftVbZ
         1rrVospIbJR80wuphgBqsL+ocT3gEzguWrNg16OoTH4acuqzUsQlvuCtWGRFxsx8z+GC
         ryvu8iOQuQRT9OUvn4KvuFeBYMVKbArNHWg2VW1vOesx5rnZVuJGJAkoWj7RMpTrjbLF
         GIawVDh2eqfAY6vd6wSkHG+pnW0yoBme/loIjzgogyEVYfyMYkWKZRaZNq/3kg1jfiVo
         mFaQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4P/KeRTz+N17RBosIxiSq7xyiCwI9dTInTRuG3EnePZX4HloQqiLfzAgKaU4otAVZB6IYvlet4mFEi70pru518KW0SngmbwO6wYjf
X-Gm-Message-State: AOJu0YxAwvlaW3Tj/aNqbm6g1PAhkL+LYb0HDfjGso2sb6Mmvt4tvxiD
	wRqry/cT3Qxkgsn0yeCF8/CNcB2ZSE1h+jlN/rold+O3bt56XtrTeWAc5CQkQhXrF7kOUgO6ARx
	5X3P7n8O2bYGQEuED2SI+qm6YJoONnwJDtUpVLA==
X-Google-Smtp-Source: AGHT+IHHyXhyOmyn8cD3PRL1zxRgm+vpW39GdI4a6ARMcYXrO5Tarx7P0yZjgP8sagG7trFpkjvT6O1DxX7Ia+kJMYM=
X-Received: by 2002:a05:6a21:7895:b0:1b1:ebf3:7a4e with SMTP id
 adf61e73a8af0-1b212d0f9f4mr11200573637.25.1716814700097; Mon, 27 May 2024
 05:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240511145200.226295-1-linux@treblig.org>
In-Reply-To: <20240511145200.226295-1-linux@treblig.org>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Mon, 27 May 2024 15:58:09 +0300
Message-ID: <CAOtvUMfYbNZ2G7-qkO8PFX5shdZmYvAQa6Uy4XbdvxsmKnDttQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree: Remove unused struct 'tdes_keys'
To: linux@treblig.org
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

On Sat, May 11, 2024 at 5:52=E2=80=AFPM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> 'tdes_keys' appears unused.
> Remove it.
>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thank you for the patch and your patience.

> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_c=
ipher.c
> index cd66a580e8b64..3fb667a17bbb1 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -261,12 +261,6 @@ static void cc_cipher_exit(struct crypto_tfm *tfm)
>         kfree_sensitive(ctx_p->user.key);
>  }
>
> -struct tdes_keys {
> -       u8      key1[DES_KEY_SIZE];
> -       u8      key2[DES_KEY_SIZE];
> -       u8      key3[DES_KEY_SIZE];
> -};
> -
>  static enum cc_hw_crypto_key cc_slot_to_hw_key(u8 slot_num)
>  {
>         switch (slot_num) {
> --
> 2.45.0
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!

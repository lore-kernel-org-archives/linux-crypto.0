Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116D520264A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 17:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729273535; cv=none; b=AO1wyOGOyT7zCQZxMLbfht4WofOppoI8QYUFD7SGAzrLmBkXP3B5Of+BTFNQlzEuVYbBwTtTkRWyHL4dalF4eitYU+uiqnTdVMrmlziWgrENix7Imclzsu4sEkjyPKE7U1mxbeeJ0aImP0fuZ4Y76i5+xfQgIcPSUJYVL6l0zB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729273535; c=relaxed/simple;
	bh=zVgV68zqNAMBgHC5ih+l7Dr7bZTc2ehLIDArvss9PQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h+Q7cPGtD7r+57Dt/Ms1ZCzRpYMn0rgDlOGYU43/g01pmIiMytq5+ZEF5RAryK+xza8kvODT9AMd2KeKH+DVCLt7nc+44qysFEtMYhBcvWrPcDCvRt6CxCfHmjXk0YMVUw++RcUc1mq0pTDFoGiRpls0dCJ2z2zVWLG3zBpzUhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=everestkc.com.np; spf=pass smtp.mailfrom=everestkc.com.np; dkim=pass (2048-bit key) header.d=everestkc-com-np.20230601.gappssmtp.com header.i=@everestkc-com-np.20230601.gappssmtp.com header.b=ylO1u3gr; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=everestkc.com.np
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=everestkc.com.np
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=everestkc-com-np.20230601.gappssmtp.com header.i=@everestkc-com-np.20230601.gappssmtp.com header.b="ylO1u3gr"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9362c26d8so5766805a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 10:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everestkc-com-np.20230601.gappssmtp.com; s=20230601; t=1729273530; x=1729878330; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UycLbInY8XVHUJwgb8SlAwx2dkW5WqLLmbDPCUL9SDo=;
        b=ylO1u3grZs58v9a9Aqfq0j23XiHtyoPUHoSE1w0ZzB97+LwNmagFhLlQfKOQDdQZ0e
         mARfo1QlUpIH+ycJJGmoJi/t39xv/UWaEFgnK9DOFvWneDptwiDJEWBz4b27/YxFzL4T
         SCZWqN4tK4nN85uyHB18aWFfB3ATcNmbK3lLAr1DqXf8J85IqIDIG8yhH2/mM50Db+Ui
         ZfT0TN49TfMiyfhCq9F+nzNYyri9G9lkW/Z3TU4unM2lmM2Rw839gwUNdFiW4dlWgnda
         y3Uxjg/81wa2NdYWjT6/9qI7+G9mmD5pEP0ubcf287WOWlcwujUc8ZhCM2FW5v0Yh6/+
         F3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729273530; x=1729878330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UycLbInY8XVHUJwgb8SlAwx2dkW5WqLLmbDPCUL9SDo=;
        b=UEPv31NZl1GKSxexMfdKC20UkLzxPZc2aEKGBzKy+foTIjLN/DXHsPdDLWC/29EpLf
         IwOg7rwf5BWaXKNMCoCkAUv0oYLenIPs+os1DphIBXt9GcZCQ2EcCG1cqvMrUCzoI/Xi
         sQKqK4jT3zZXrgSCz9E/SlXSFiB+XFjXJbBTb1ZhwP1fRY7P4VFqBSOP7s9NLFymC8t2
         UaQ0McYPhLbWai4KOmsO1vG8ogetrE0DNGgXphVm99qDLSEmaast5IBX1+hpX6NXnPFi
         3smFTzP5XMOd9cOqVdPpl+Q8sv2XavqFI8xydeaAUfWH9uIlhRNUIJuySoBlUtmCCVXd
         yi1w==
X-Forwarded-Encrypted: i=1; AJvYcCXqWXEOpONTbIuB0+4BsDjzPVCkJGFKWIpyBwVxz95W5zJr0JVBvea1dJTiE4IbKqxwQS5QcNh+rPrH87g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPh2jPg8EZCT2vBsJtUHEJGfFJYyMCOcJl4tRBiJu6MsYpbeaE
	eXj+qNE3XEz9ar9yEaFvGRMaJ+HoL9EB/cYUf9055Gy2FaH3wakeGAZJRvCv78BiljwVeyTXBA2
	MPPoK5irBljjyymL9vNX0IYdsfb1hdfKIoG/6Rw==
X-Google-Smtp-Source: AGHT+IGgOLmBCaLEk5MbTwop088cWLaCaOhDIQBysmyf4jbJoRHxnK3RSV90rMVLknbfLkVQBZIn+mpkyNWMXfcFom8=
X-Received: by 2002:a05:6402:370a:b0:5c9:1cdf:bbae with SMTP id
 4fb4d7f45d1cf-5ca0b0d01demr3123694a12.11.1729273530034; Fri, 18 Oct 2024
 10:45:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241018170347.647896-1-colin.i.king@gmail.com>
In-Reply-To: <20241018170347.647896-1-colin.i.king@gmail.com>
From: "Everest K.C." <everestkc@everestkc.com.np>
Date: Fri, 18 Oct 2024 11:45:18 -0600
Message-ID: <CAEO-vhE3RLGnp3667V30-rk5zFef=VL9ACruO47wskS9R_JtfA@mail.gmail.com>
Subject: Re: [PATCH][next] crypto: cavium: Fix inverted logic on timeout end check
To: Colin Ian King <colin.i.king@gmail.com>
Cc: George Cherian <gcherian@marvell.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, David Daney <david.daney@cavium.com>, 
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2024 at 11:04=E2=80=AFAM Colin Ian King <colin.i.king@gmail=
.com> wrote:
>
> Currently the timeout check will immediately break out of the
> while loop because timeout-- is always true on the first
> iteration because timeout was initialized to 100. The check
> is inverted, it should exit when timeout is zero. Fix this
> by adding the missing ! operator.
>
> Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engi=
ne")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/crypto/cavium/cpt/cptpf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavi=
um/cpt/cptpf_main.c
> index 6872ac344001..48f878460f41 100644
> --- a/drivers/crypto/cavium/cpt/cptpf_main.c
> +++ b/drivers/crypto/cavium/cpt/cptpf_main.c
> @@ -44,7 +44,7 @@ static void cpt_disable_cores(struct cpt_device *cpt, u=
64 coremask,
>                 dev_err(dev, "Cores still busy %llx", coremask);
>                 grp =3D cpt_read_csr64(cpt->reg_base,
>                                      CPTX_PF_EXEC_BUSY(0));
> -               if (timeout--)
> +               if (!timeout--)
>                         break;
>
>                 udelay(CSR_DELAY);
> --
> 2.39.5
>
>
This bug was recently fixed by my patch:
https://lore.kernel.org/all/20241018162311.4770-1-everestkc@everestkc.com.n=
p/

Thanks,
Everest K.C.

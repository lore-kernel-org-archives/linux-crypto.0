Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BC979CD;
	Fri, 29 Aug 2025 00:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756426625; cv=none; b=QAYrFMbOyfgC+JLnKp0R6p+E96ybC8dhHUkmNtL7mz7NutfcgYtTugi/NnnEcOXZdLL/Ti5VhpHsDnD5S4DfL/bxkz7Zgouwxbn0uYSn8vyVQ4fC+dYD+D378NlwCxVoAzOlpLoLKUrRR4j6C5c+dBViahT9IfvzUDfWBOPE/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756426625; c=relaxed/simple;
	bh=Dix/X/pXNlEG3e3/O4VfYbF8CXaRGSDW+QAdAmVL7L0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1NqxUjTQHSuVGRqZi14td75JTgawTT1Kz/6dEkrtELrAqoKjJJZgnAupCd/tDcQYZhSB8UJbMVltSCez3OCksINEQ2AEcy3SzSXcw4hxOFhnvlKcjZ5Er9H5knBk6t3+cAetjrGj/2Zp3qgmP5YvgdcWrfdt+XAow0qZotO1X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kxe7LfZM; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kxe7LfZM"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7f04816589bso151093985a.3;
        Thu, 28 Aug 2025 17:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756426622; x=1757031422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wb1jMUXGb6/ItBoZsFy9z50zNJdJkY6b2JpW/rUsSoo=;
        b=Kxe7LfZM7hoTSwUAWAxT8yqdePT5lQr3Xra40b4L8WgQUljF+NsPN2bEC1jkyLxiCT
         PMR+Ifq9c0nAKJnZpeSoFx13fMKvgOK5DDYlHTRhKWPXa9bPECOf3YTwbi7kPdYvzrrQ
         AP8XkVth4puZeP5uZ/wU3WUM3j2kIxy3QG531hFfA3nSZ7NjBhq+e11n29JHgM7+rRWw
         HoBOLffM3brqUpsKQNkL5K4476YvzyFZQwaXfzXKbknHIGAMQWC6f3ncmmryx756n2t/
         bHtd+YqL0ryvYi6Nq8uMhFSRmqToKx3NBmmWjxVM3EGtO7s5hfHi1LAr7slbY82qY3U3
         IB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756426622; x=1757031422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wb1jMUXGb6/ItBoZsFy9z50zNJdJkY6b2JpW/rUsSoo=;
        b=l/dYvJyHGY9leavxzi20mdcuxFm1Km8mqmLG2i7TDVXThyN5Upw+Zp6q7uereKkFkq
         mfksFIP1AWReeFRBc1e25fVNLTbdsLdPT8/0pgPSaYehaUG2XLAP0HqeJT/A73gqMKy9
         wvuu9j+IJUwd1lVvPSJexQ/ik9xg3EWcusK+5xmfBY1I5o9krteBAnNhz+shvpZwl7fE
         2POlEOVbu/AZmjROhM0V1QlGnsQ0XbsLmcqGtVfDboQcXtZY2LXtN4cFF85nN22G8/4+
         pFXvPXNTSWc5fIdboOUONopJs26WF7Zb76I+GaDICkSWLoXZifS47OA8IhqaYAaKAAJo
         lVAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcVdftRSkmUinDKBQMP1UaunVFW6yMDHZ3jLdCcioZ8QMFADXqCTBOksnTNKAGI1XsTAH27VhtZEO20Io=@vger.kernel.org
X-Gm-Message-State: AOJu0YweyKkEGu6LdG5s8CMY7e+nGSvNEkW25acuisK+y2B/Rsj0GrpK
	k2SabtQBJ5OABELHFjOPDSD7S/t3b9+ZYPFmzbAlZQYyuHPJ7C9mBvxqzOUlDtO83l9nhwiyPuU
	vb4Ld6EiF1TT7uwqC+spa1z1M5znVEIfidocy
X-Gm-Gg: ASbGncvjfOTdE/lF6BHq9lqd8hCN6bxqJhyBj4Y69MUI8anxc3N+6t1MYqQAiSoJgb0
	pv9fvGB/oGKQbhcOBunGoKPWTOSaGqxuGYgmRSVbZAEceKRa8ZTzh2UaYmvYw6CMB65ltPC0ce5
	JE+youpcXnOYJw3bwNY3UdCnW6/6nhL3nhCeL+2hLgEsTrMkPqmJ5FD870R2LmWzk72k9ITDjdd
	bseBIk=
X-Google-Smtp-Source: AGHT+IGQKl+/zd12XCaC1+Qms5ixirA4oJqGGhDKEW/cxCJbRtH8rakdEL2CHuZDPUKYY+4Tla1xYBAgtFyzgH1jJxo=
X-Received: by 2002:a05:620a:4410:b0:7f1:7f01:9a3e with SMTP id
 af79cd13be357-7f17f019ca5mr1925740985a.72.1756426622000; Thu, 28 Aug 2025
 17:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-20-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 12:16:51 +1200
X-Gm-Features: Ac12FXwfAjOO-4JtlTJ0PGYlVUAWZtUILQp063i-tfGCeSFeBU9jVKtn_v69wSg
Message-ID: <CAGsJ_4xuMEDzX0z-oEyPQyb+jhnytfrfyASKxwR+5XRzxayJPQ@mail.gmail.com>
Subject: Re: [PATCH v11 19/24] crypto: iaa - IAA acomp_algs register the
 get_batch_size() interface.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 4:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> The Fixed ("deflate-iaa") and Dynamic ("deflate-iaa-dynamic") IAA
> acomp_algs register an implementation for get_batch_size(). zswap can
> query crypto_acomp_batch_size() to get the maximum number of requests
> that can be batch [de]compressed. zswap can use the minimum of this, and
> any zswap-specific upper limits for batch-size to allocate batching
> resources.
>
> This enables zswap to compress/decompress pages in parallel in the IAA
> hardware accelerator to improve swapout/swapin performance and memory
> savings.
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/=
intel/iaa/iaa_crypto_main.c
> index 480e12c1d77a5..b7c6fc334dae7 100644
> --- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
> +++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
> @@ -2785,6 +2785,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate =3D=
 {
>         .init                   =3D iaa_comp_init_fixed,
>         .compress               =3D iaa_comp_acompress_main,
>         .decompress             =3D iaa_comp_adecompress_main,
> +       .get_batch_size         =3D iaa_comp_get_max_batch_size,
>         .base                   =3D {
>                 .cra_name               =3D "deflate",
>                 .cra_driver_name        =3D "deflate-iaa",
> @@ -2810,6 +2811,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate =
=3D {
>         .init                   =3D iaa_comp_init_dynamic,
>         .compress               =3D iaa_comp_acompress_main,
>         .decompress             =3D iaa_comp_adecompress_main,
> +       .get_batch_size         =3D iaa_comp_get_max_batch_size,

I feel the patches are being split too finely and are not fully
self-contained. You added iaa_comp_get_max_batch_size in the previous
patch, but the callback appears in this one. Why not combine them
together? Anyway, since you are moving to a static field, this patch
will be removed automatically. Could you reconsider organizing v12
to make it easier for everyone to follow? :-)

Thanks
Barry

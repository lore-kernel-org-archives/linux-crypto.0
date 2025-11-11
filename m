Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49A32827A
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762868199; cv=none; b=n+GI1m9isN6WSAqF1bqt5a27+bY70lYSgMk/Zvit43ucFPSA88gMRo89VtWhVizqIuLPKjQY8JExiPavTNyADmQ0VIXLq91kYiPq5AJ5+/OBlXW2QYAzvq7SXvsFPv1OQCxNTTQJluXdDlCIA42yM56IVSnCxRTdKwm5y61+IX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762868199; c=relaxed/simple;
	bh=w8ua2yh5XTlREuHCT+bXanJEtJbqd9BIe+yddso/xi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cThe1tJR1Gn5nt/EWGYhJ6B/8bhUM2tTIjpPqk7sTV4vx7GWVg7SeLLWFMfny1c08tSbyTc4I3/IjgYnXd9oVWDaZnab3MERPGAj13V2hSdknFucgt8gAqN8b4R4srWfUjG3teHcVqnRsdxBRqWV//M7FJHK8sjoAX/wU70LtN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaXhYcYX; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaXhYcYX"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b725ead5800so550718366b.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 05:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762868196; x=1763472996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1W2CPGMBHn+khJhcZ1AUaCt20ytZZAlALbm1UElRgAM=;
        b=MaXhYcYXPxo8RtvAWMtjpBdEnr/kYmNUQBAulsx6xRVyjau2iYsEmzmQp0SQ3NUnOD
         iON8Y7qAy2FAMsAYIn85bG7Jw+WK2rV09Oa0FHTc9I4fLLSrABsCafOsZE5L6weEBBpZ
         UbSFmN2hngPVMLFI+ePacbFMz7cFMhj5p34d8k4iCisi6LrFLC154iADbGerVGCEVHYR
         cblK+x1U9TYsc28IcY+FcjVI7uUCruBA/L9Lqd6pO0mFHRRJEEKw4G8DYdPgPGePRy/P
         qg3bP5m44bM0PwVhNRHbyzLgh99C4GjJaepOIBp9RgyBaza8eil9dD7dhLUv+agNNFjm
         Xtng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762868196; x=1763472996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1W2CPGMBHn+khJhcZ1AUaCt20ytZZAlALbm1UElRgAM=;
        b=jnyJEWlCkS2zD3+X6soipoZeyoVk+TrBUADwsQ2WtRcJcpPIEW77muIJIH6bsyVK+B
         zwKZ8oF5JzhgOxm/3fkDJAUsyjmHUrmnQRwCSfk7s2MRQ0IdWLPwc4n4pQuYx5+ghQBt
         SEnw3m+n6LNJAezK6q8esZSYEPnrQz7kVQ7dxFpF2l2ceA2LhdPanxyCrJ9C9KbrqcMA
         N18xqP3M1KOKldeS4eWLzb/rbq/D/8AKjMy5HrChO7GMvZXIfQjbG6Yc+sAfhdDkpxvJ
         d/05J0gUPpC5ocY8EfV2eXbyZYMwOCvwH3DZ3g6mFfbTXVem3mwRNq9sTLkERCjOatNE
         tb9A==
X-Forwarded-Encrypted: i=1; AJvYcCWWvanmZzxIwHbSeA+FCpuBhWTgNry9c17SSZlgkr12FxaO7dPO9Q1YtufKnQF7dt3uiBippXL2IG2Y95Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRRM7/kHeXMB+mVpwd4sMc38uOKwOYnJQPRVEeIEBjj80WWxhP
	lXsWBZIhcMps589uu7Tjj07mJmVF9L1lUx9t9pK/xs5XqQHfL8zeTLzmE8hZQh9Gx1S2kkgPvFF
	WbzeaOClU5ahQDyoYIMt+p1A4GJHe0wQ=
X-Gm-Gg: ASbGnctM4w9eYQp10FF5aDjtOQEAvKuqmXl7nzzct4KVW+cEQDrqKlcUn22fnnKIGqz
	NqS5ixMUxTzslS09xGDqaRrTFFquexq1bn4fypZLrJl21fg+1VQiZlGC+5/yHKD/P20Yi4sZVZY
	I17jnCB0NP1y+BVC4XSRLIl3XyZdu8RxzGSOU5A3kl4F6SQONfzaO+/2WSNurPdafqfKpcsvbiY
	cpYaQDrLlB48sKDNvvNlgh3BQwKTluRGH9ilkY+h3EnhDgqIy9EWo1XmurwsVFwq6DMn4+n1mgz
	mXPD7NmlG+znf0LhC2d/8l0gNLrSkw==
X-Google-Smtp-Source: AGHT+IGTYw9TjsV5qi6Mg0i0hZfiUxO5b6ghqnuSfx2JSXKmv5crvo/4li/liipwWqyOa+9lovMAHnBJbB87ToLQmR8=
X-Received: by 2002:a17:907:60cf:b0:b6d:51f1:beee with SMTP id
 a640c23a62f3a-b72e001b360mr1067708566b.0.1762868195405; Tue, 11 Nov 2025
 05:36:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251105-aheev-uninitialized-free-attr-crypto-v1-1-83da1e10e8c4@gmail.com>
 <CALrw=nH8z0p=nyM_S0BN0JfdUB8fQHvkH6AULD3qj6sPQ1qJig@mail.gmail.com>
In-Reply-To: <CALrw=nH8z0p=nyM_S0BN0JfdUB8fQHvkH6AULD3qj6sPQ1qJig@mail.gmail.com>
From: ally heev <allyheev@gmail.com>
Date: Tue, 11 Nov 2025 19:06:24 +0530
X-Gm-Features: AWmQ_bn6DFpia9qoGca_FfmizgWOja0n7Y2cbf7Nbfr1UW8s9B6XmJTBA25bbQM
Message-ID: <CAMB6jUFFvVRr2rfuvu0FySvR7b3LAe78H1HHBkcnMDyeyNT_Mw@mail.gmail.com>
Subject: Re: [PATCH] crypto: asymmetric_keys: fix uninitialized pointers with
 free attr
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 6:42=E2=80=AFPM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
[...]
> Should this be just initialized to NULL instead of moving the declaration=
?
>
> > -       struct x509_parse_context *ctx __free(kfree) =3D NULL;
>
> This pointer seems initialized. Is there still a problem?
>
> >         struct asymmetric_key_id *kid;
> >         long ret;
> >
> > -       cert =3D kzalloc(sizeof(struct x509_certificate), GFP_KERNEL);
> > +       struct x509_certificate *cert __free(x509_free_certificate) =3D=
 kzalloc(
> > +               sizeof(struct x509_certificate), GFP_KERNEL);
> > +
> >         if (!cert)
> >                 return ERR_PTR(-ENOMEM);
> >         cert->pub =3D kzalloc(sizeof(struct public_key), GFP_KERNEL);
> > @@ -74,7 +74,10 @@ struct x509_certificate *x509_cert_parse(const void =
*data, size_t datalen)
> >         cert->sig =3D kzalloc(sizeof(struct public_key_signature), GFP_=
KERNEL);
> >         if (!cert->sig)
> >                 return ERR_PTR(-ENOMEM);
> > -       ctx =3D kzalloc(sizeof(struct x509_parse_context), GFP_KERNEL);
> > +
> > +       struct x509_parse_context *ctx __free(kfree) =3D kzalloc(
> > +               sizeof(struct x509_parse_context), GFP_KERNEL);
> > +
> >         if (!ctx)
> >                 return ERR_PTR(-ENOMEM);
> >
> > diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetr=
ic_keys/x509_public_key.c
> > index 8409d7d36cb4f3582e15f9ee4d25f302b3b29358..818c9ab5d63940ff62c2166=
6fd549d3a1ff07e67 100644
> > --- a/crypto/asymmetric_keys/x509_public_key.c
> > +++ b/crypto/asymmetric_keys/x509_public_key.c
> > @@ -148,13 +148,13 @@ int x509_check_for_self_signed(struct x509_certif=
icate *cert)
> >   */
> >  static int x509_key_preparse(struct key_preparsed_payload *prep)
> >  {
> > -       struct x509_certificate *cert __free(x509_free_certificate);
>
> And here: should we just initialize this to NULL?
>
> > -       struct asymmetric_key_ids *kids __free(kfree) =3D NULL;
> > -       char *p, *desc __free(kfree) =3D NULL;
>
> Same here: these two pointers are initialized.
>
> > +       char *p;
> >         const char *q;
> >         size_t srlen, sulen;
> >
> > -       cert =3D x509_cert_parse(prep->data, prep->datalen);
> > +       struct x509_certificate *cert __free(x509_free_certificate) =3D
> > +               x509_cert_parse(prep->data, prep->datalen);
> > +
> >         if (IS_ERR(cert))
> >                 return PTR_ERR(cert);
> >
> > @@ -187,7 +187,7 @@ static int x509_key_preparse(struct key_preparsed_p=
ayload *prep)
> >                 q =3D cert->raw_serial;
> >         }
> >
> > -       desc =3D kmalloc(sulen + 2 + srlen * 2 + 1, GFP_KERNEL);
> > +       char *desc __free(kfree) =3D kmalloc(sulen + 2 + srlen * 2 + 1,=
 GFP_KERNEL);
> >         if (!desc)
> >                 return -ENOMEM;
> >         p =3D memcpy(desc, cert->subject, sulen);
> > @@ -197,7 +197,9 @@ static int x509_key_preparse(struct key_preparsed_p=
ayload *prep)
> >         p =3D bin2hex(p, q, srlen);
> >         *p =3D 0;
> >
> > -       kids =3D kmalloc(sizeof(struct asymmetric_key_ids), GFP_KERNEL)=
;
> > +       struct asymmetric_key_ids *kids __free(kfree) =3D kmalloc(
> > +               sizeof(struct asymmetric_key_ids), GFP_KERNEL);
> > +
> >         if (!kids)
> >                 return -ENOMEM;
> >         kids->id[0] =3D cert->id;
> >
> > ---
> > base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
> > change-id: 20251105-aheev-uninitialized-free-attr-crypto-bc94ec1b2253
> >
> > Best regards,
> > --
> > Ally Heev <allyheev@gmail.com>
> >
>
> Ignat

initializing to NULL at the declaration itself seems to be the right
solution here, as it conforms to the `variable declarations at the
top` rule too. I will send a new version with the changes

Regards,
Ally

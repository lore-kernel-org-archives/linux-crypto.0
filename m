Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A06F9C1
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 02:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728268382; cv=none; b=oEvespimO4wbMzdiJUbniiUoQYPcqKEw2JLoXkIUU2ob2BEnPv/8vkc5iZN1rAbRDa60qw7tfdcK1Rk3WOZSFGrvEOt6sKu/PRMX5v7u/+VClqdQTSK+G3/Ag8GnTr3gKU8nb+7nfpjbYkuo3Az6jxWjaHQoM2+ZE2VCiuj6uQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728268382; c=relaxed/simple;
	bh=UmYzWjwwdRldGzMtasrj0iUPzywF33QHaFRM8bXmb/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cc3Tzkidt8zN1IxKuufzktbHldZT0DtZX3osblG2Q2XI2tBTrOUKVmwg5eZB+NGiSildwNlL+ysvncN5CX6xXp2chSks+2azBmlJZfL0yw1+tZp+aldcsX9VzkKiRSzMeZUydvVs9c16eDKyH+kRLmxu1dBP01koVP500uFyPMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kev009.com; spf=pass smtp.mailfrom=kev009.com; dkim=fail (0-bit key) header.d=kev009.com header.i=@kev009.com header.b=tuIpb769 reason="key not found in DNS"; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kev009.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kev009.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=kev009.com header.i=@kev009.com header.b="tuIpb769"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4581e7f31eeso36158141cf.0
        for <linux-crypto@vger.kernel.org>; Sun, 06 Oct 2024 19:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kev009.com; s=google; t=1728268379; x=1728873179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eIagNj3XBeiwbes7ESay7OedVVX9YeO+j3SWRSuWDgU=;
        b=tuIpb769p5oD0BWU9SUrJE4RyPonSCiDvwzOKjzffMGJDU82HUKHq4lzCS/ioKYOrm
         QDXVeJV6LQjGIWPMtPKHYfrf4AEIiyZpWU3He1FOCy/6WqsM0rud7fQP4UtlJDBTZCq1
         ZjzQRzllrHWRp3q6Q9zICqXpK/uhznT/YuZoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728268379; x=1728873179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eIagNj3XBeiwbes7ESay7OedVVX9YeO+j3SWRSuWDgU=;
        b=jsGgAMFTzEDIF0zHupIr/6PEpUeoa9n7zYhMsBWcmrYQ1bKtYnvdmnWIq+uOmriJTP
         7qz2YCu/pvKitmBssGmX1LxoMLWol96wXG3mbwAQfdmOtH3N9TZWR7kcorgTVyNlcbtl
         EuqJFXeDWAegP81eo6oEFmJRpIAKQInjCmcVic0/HdHWSgeKyT77Z2fFbuDKdr/HksyN
         /XHTX+kb0IwN/aEc2Mlvci2/lFtii7tqYGqL41pcTQyhMNzSRD2kh6kG3MUXRM9yvmru
         z9FX5FvCJeaMogi4Sd9QUIQpzXWyw/XjOeS5obheyflNP4tLPDtCjWg8dOBlprRPlNL0
         DWlg==
X-Gm-Message-State: AOJu0YxPQgfhmmTpEZ6KBdCvwFLU4AmtBEctzzk+3cXBoVkt0N5gIZ1g
	8+D23YppHWKSTgy6a++uX/g3fwBoKW3RG/YeCS+Ii+HnyQ8jpo0d0+THX/B7XAJG8jh39WlFiNf
	5sPVc7shnqRQloPEvUC/Wu6EDk5dyDybJT3gu
X-Google-Smtp-Source: AGHT+IGW6ESRO/rs7JsIqpNrzr5mR+Qf6lp+llFyFWrhgLaCLuuBhqRYKgzRWQDEQknxfpZf58As69biVB1biwW3opY=
X-Received: by 2002:ac8:5792:0:b0:45b:1d3:d9a8 with SMTP id
 d75a77b69052e-45d9ba85fdcmr172235491cf.27.1728268379057; Sun, 06 Oct 2024
 19:32:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801210155.89097-1-kevin.bowling@kev009.com>
In-Reply-To: <20240801210155.89097-1-kevin.bowling@kev009.com>
From: Kevin Bowling <kevin.bowling@kev009.com>
Date: Sun, 6 Oct 2024 19:32:47 -0700
Message-ID: <CAK7dMtDiL16JAXvTuTv3fOL5JNkMOCyjr6tVx44uDMKQxVnwqA@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Print digitalSignature and CA link errors
To: dhowells@redhat.com, keyrings@vger.kernel.org, jarkko@kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Hopefully this is pretty self explanatory, it just increases the
diagnostic capabilities of using the keyring erroneously.  How do I
get someone to look at it?

Regards,
Kevin


On Thu, Aug 1, 2024 at 2:02=E2=80=AFPM Kevin Bowling <kevin.bowling@kev009.=
com> wrote:
>
> ENOKEY is overloaded for several different failure types in these link
> functions.  In addition, by the time we are consuming the return several
> other methods can return ENOKEY.  Add some error prints to help diagnose
> fundamental certificate issues.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Kevin Bowling <kevin.bowling@kev009.com>
> ---
>  crypto/asymmetric_keys/restrict.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/r=
estrict.c
> index afcd4d101ac5..472561e451b3 100644
> --- a/crypto/asymmetric_keys/restrict.c
> +++ b/crypto/asymmetric_keys/restrict.c
> @@ -140,14 +140,20 @@ int restrict_link_by_ca(struct key *dest_keyring,
>         pkey =3D payload->data[asym_crypto];
>         if (!pkey)
>                 return -ENOPKG;
> -       if (!test_bit(KEY_EFLAG_CA, &pkey->key_eflags))
> +       if (!test_bit(KEY_EFLAG_CA, &pkey->key_eflags)) {
> +               pr_err("Missing CA usage bit\n");
>                 return -ENOKEY;
> -       if (!test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags))
> +       }
> +       if (!test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags)) {
> +               pr_err("Missing keyCertSign usage bit\n");
>                 return -ENOKEY;
> +       }
>         if (!IS_ENABLED(CONFIG_INTEGRITY_CA_MACHINE_KEYRING_MAX))
>                 return 0;
> -       if (test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags))
> +       if (test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags)) {
> +               pr_err("Unexpected digitalSignature usage bit\n");
>                 return -ENOKEY;
> +       }
>
>         return 0;
>  }
> @@ -183,14 +189,20 @@ int restrict_link_by_digsig(struct key *dest_keyrin=
g,
>         if (!pkey)
>                 return -ENOPKG;
>
> -       if (!test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags))
> +       if (!test_bit(KEY_EFLAG_DIGITALSIG, &pkey->key_eflags)) {
> +               pr_err("Missing digitalSignature usage bit\n");
>                 return -ENOKEY;
> +       }
>
> -       if (test_bit(KEY_EFLAG_CA, &pkey->key_eflags))
> +       if (test_bit(KEY_EFLAG_CA, &pkey->key_eflags)) {
> +               pr_err("Unexpected CA usage bit\n");
>                 return -ENOKEY;
> +       }
>
> -       if (test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags))
> +       if (test_bit(KEY_EFLAG_KEYCERTSIGN, &pkey->key_eflags)) {
> +               pr_err("Unexpected keyCertSign usage bit\n");
>                 return -ENOKEY;
> +       }
>
>         return restrict_link_by_signature(dest_keyring, type, payload,
>                                           trust_keyring);
> --
> 2.46.0
>

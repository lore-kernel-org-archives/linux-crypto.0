Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721631DFD91
	for <linux-crypto@vger.kernel.org>; Tue, 17 Dec 2024 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734475922; cv=none; b=CExUH+lTW3xfcTO/iI+DLzK3ePcPOUM/wzVWodVv1ZRcUeiG576W3N4xIzW2L0e4uYWoh9FLTjCUMbVfefFNTz3+USHRWo1munl3LiEMF7IW5EUSUd5iC+kLOuzu0rIoJi1XRkjXm1gR+DCxNeKrCcSxY8NKPE+N5XtZM3HciE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734475922; c=relaxed/simple;
	bh=+eyhKNJumZs6/FTEwOn6NrjFWtzki3e9oRxmhRQgX1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2p9/L/rklcG3QxjSPJxhehVqaUXYQBHvLLSi/s6c+PbMUwaxa9GUUVZ+0qE2shPzNycb5lchEwtUe8usPezJjtEsTMiz8wiK8HW/Q6R7RCYLhK37qHfSjQw1/z2zPqcnYvT6JaYrWtGFV8R/WV9T0n0FSlk3uvGSx5kcPXt8u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xL2+mjJi; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xL2+mjJi"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9f1d76dab1so1175367866b.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Dec 2024 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734475919; x=1735080719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVYL3s9CILTnwogTJZ1OTIZuv0ARpRPo5KpbFGa6KD8=;
        b=xL2+mjJi2YQwtSt4Yapr/JgbFLX9aECv5HMoMBmOG3xvVfDIIG2n1gK9XrKlBpxpwH
         90qjWwizqyRFAJt7176MCmN+5YBUGI9TshVBz5kTtoE4n+SlB2UMYosMkaGt4FWl4Nvi
         eh3eZ5nJxmuiIHN5QUW/zxuZNq+YmuWuZ8OSYMZbZIez3nFgs0cL2hbBHcyBs2MV9XEf
         HL/+vJmEYft9P0hCn2BiLUOgWTgQygby9ZeOuB9W4/Xtmx6a9aFMTWOVXYN9caaPcdy0
         JaXuEZsKQbHPykEDA3JPV/snigAlHVRryUzMOaOWqzd4OOeAOIGB9ZobUFgKJDHLrkLG
         iW4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734475919; x=1735080719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVYL3s9CILTnwogTJZ1OTIZuv0ARpRPo5KpbFGa6KD8=;
        b=ox97NJwghsiB+iT7t3gsDiRB7AUp+biQZXEJGoc74vcRiO4fn33s865e2S1TqaHIGe
         t7A9Mi4fzofWdjpq6GHVvda5w6Boe1MB6W9J9NIfM+TZfldHYxM43NGSLZQBJFSEjYeU
         3nJlH85CUKj3ZOL4YpAt48jl3WKAG82AdHKghlSVHLZE5RYGVZWbXRE7YWi7iktL9MVu
         pQSRLQ4i+OLND4oK2xsEzaxjud/nzmxajtxX6HjcKURAT0ohCjsaLee1cUSH/YsfL+kq
         QK1b3xdiq5eY2XHMEUEtVmVWVUIRiYQ8zUFLOn6vyCmtSQiAtnuwr7mgU0HWtNnusRA1
         uaHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDiH80JnCtJTadfBSEtOZibTwx2gpTkjl4TOwl28vYGftrvxdYRek2eJIhYUCv+YqqjQT32HCwAmvp0xQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT6NhK5i5TLMzRhLrS+A6scX6MUyAFC5cWdiCHxo4iepTix2dA
	8dMocOkqGu1I/QLoq91RaUbe1g/Fz0mbNfrD2kJDsOmbnyEqpC0YkhmsCilDLodwtGIb+PBe1G3
	8LJdulYg9zNZI3vupNPqz1w9HmeGc+e4tCVBe
X-Gm-Gg: ASbGncvR6hW1l6n6mabxgk1DoRqHU2Y+lj5+6tbVpRRZO+OkvsqDW9eBo6gMYhgR9qG
	OVINu7CIOKnIrZn7HO3AAncDM5HuY76bHJSZWkQ==
X-Google-Smtp-Source: AGHT+IH1GTjImrAaApRrEGDhHMKaiEFNxqjHCuhUD4o38YaFXBS8IA8KoPJRL636fi9mhowUw350/nmafoSV7nTEPLA=
X-Received: by 2002:a17:907:72cb:b0:aa6:8a1b:8b74 with SMTP id
 a640c23a62f3a-aabf4920960mr39223766b.53.1734475918650; Tue, 17 Dec 2024
 14:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
In-Reply-To: <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 17 Dec 2024 14:51:47 -0800
X-Gm-Features: AbW1kvaHDgTDS8JrAFaBs3expr5K210DWpQNsbnGYLLnTtGnZ9fPc2iUNyA1dYg
Message-ID: <CAAH4kHai4mqmY6CB3Ybk6JxD7M=OX44k0S=2n_h_F4mVSVco6w@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2024 at 3:58=E2=80=AFPM Ashish Kalra <Ashish.Kalra@amd.com>=
 wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down
> SNP in PSP driver when KVM module is unloaded.
>
> Currently the SNP panic notifier is being registered
> irrespective of SNP being enabled/initialized and with this
> change the SNP panic notifier is registered only if SNP
> support is enabled and initialized.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9632a9a5c92e..7c15dec55f58 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +                                unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier =3D {
> +       .notifier_call =3D snp_shutdown_on_panic,
> +};
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>         struct sev_device *sev =3D psp_master->sev_data;
> @@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
>         dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major=
,
>                  sev->api_minor, sev->build);
>
> +       atomic_notifier_chain_register(&panic_notifier_list,
> +                                      &snp_panic_notifier);
> +
>         sev_es_tmr_size =3D SNP_TMR_SIZE;
>
>         return 0;
> @@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bo=
ol panic)
>         sev->snp_initialized =3D false;
>         dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>
> +       atomic_notifier_chain_unregister(&panic_notifier_list,
> +                                        &snp_panic_notifier);
> +
>         /* Reset TMR size back to default */
>         sev_es_tmr_size =3D SEV_TMR_SIZE;
>
> @@ -2490,10 +2503,6 @@ static int snp_shutdown_on_panic(struct notifier_b=
lock *nb,
>         return NOTIFY_DONE;
>  }
>
> -static struct notifier_block snp_panic_notifier =3D {
> -       .notifier_call =3D snp_shutdown_on_panic,
> -};
> -
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>                                 void *data, int *error)
>  {
> @@ -2542,8 +2551,6 @@ void sev_pci_init(void)
>         dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initial=
ized ?
>                 "-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>
> -       atomic_notifier_chain_register(&panic_notifier_list,
> -                                      &snp_panic_notifier);
>         return;
>
>  err:
> @@ -2561,6 +2568,4 @@ void sev_pci_exit(void)
>
>         sev_firmware_shutdown(sev);
>
> -       atomic_notifier_chain_unregister(&panic_notifier_list,
> -                                        &snp_panic_notifier);
>  }
> --
> 2.34.1
>

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

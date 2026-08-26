Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8675E3976A0
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787773873; cv=none; b=RpCRY12cGGpRfwoK/wwWOlkfR/DhEVBGWozCDcoJPiCvkq3k3MBaPG8bdCtchR4Vxb7kpFZowVeOzJQ8IR5nJUd89J47b/ytF7fxvk0EJKE0PU1z8jIjKD3QnVzikDMztUPV3Y83C6cmvPWbs4WuhG7q6QdrCctr0IdOfwuuNmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787773873; c=relaxed/simple;
	bh=M+TpnqIzx9YzVakWndAoYkuS3Ivh0lBQkdoao0Agnh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tU07VpFJFGfmll7Nf2g3ha9G4/zSruYHh029UV/xi8VYdizIBJu9kO95gZe0jPo2l4NWeT4OdfJB0a/vnZ5VcxCr6SrvjvDxW9ERWidkB5oLR9v3a9eHIX6lKB1rYBKFIRHEsodRbMnl4Bv9bZOcRVnDygX2vFLkbUsXoupyFXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c25344a8c6cso63479466b.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:51:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787773865; x=1788378665;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ffOGWLkNU0B5wefleM0f4kOcS8WHnfV6s3VJ7x4ll4=;
        b=s2BkSVkY4NWlROIA8MAk5lQqX/B7vbeeduZMFHm8uRpkJrDt5M9+j+stw0ELU6O0uE
         mC+s7VjocD8JrvQhIjzujkx57eGUzoP2emz0T4n2A4gn6WYt25kRqDKzo6cUVcsOY6Gb
         eVU45X9jiYSXe91NQ5IOiNJZsGvLthYgxCijtrB583TDPb9xMl6iOq3FP6dUCYIF6l/h
         eLoAsHb8u/cByOWaNsNY3ktM+yZOPVQ/5HFUDigZb/sKv7EDMITGcHFV2hcwh5xdXgcZ
         UQw0HRUoVId8wcqWOq2Ra9nFPw8HMpWnf88LELktw2SIfjaOBtgp1LQgPJ5b5T4AKaHD
         v39A==
X-Forwarded-Encrypted: i=1; AHgh+RquaN9U1O5hRgERSkZRA9TTE88ld0qKkkOh0/w6UxwXWIgjCUIj+eSlkxJz4dVP6Lk9gkzkQjlfEeCG9qA=@vger.kernel.org
X-Gm-Message-State: AFuF++ni/Eneq1cQHnBP9dihQlSbEKVnHGivThBios/4I1fyiTSni5Aq
	yJjEq4ApeU2nIxrvGQYmG488JOiENyF0/N9mGcPEpzzvf/rDevaCAU5bDJB2IuN60qQ=
X-Gm-Gg: AR+sD12/hJVdzT9t30EQODFrPUczOMybSVNGu5ESYqcVG01TvogaH5ueHZP8wl+jwjv
	YnD16XSXGoL+E4U1HO5fIMf0V7QD4DkVSIH7KSwRBKsvVBz8MhhO++97JMYgQznhf82xBQ59Oxk
	Dede+UExA53G/pc9Soyp8JOLRS5N8lP2UT6Hd+lXNky3zRHVs94auts6yrtRbxbsvVD7CUWTAS+
	m/HrPyQ6XFxj6eFE6vgrej6iBwSRcdn0LnmkujBMrA/fremNDDfDy7cQ7lQ3lkyLVjDzKpls995
	PY9CJurW4OY7I21ADud9VkIOlcG0frPsjK2lMBzeNR1egQgicudMVvn/n7uDU8Q/SX/BeadzxUG
	KYc4tpglnAf3TPG1JxrRLJCxZIRXL9gukasjCtRt3CwxPK287R2hO2NnlR84scqGFsPIo4uPujF
	1MhIa5xBA8CtBON+rHUr1/K0iWOy6KHmosaB6+MWdeGBuvdcXm0X/DprxtrQeCYSYG7wikx1KHq
	V1FDujkw9XIdyV0Fjw=
X-Received: by 2002:a17:907:7203:b0:c20:fda7:1856 with SMTP id a640c23a62f3a-c250bb76be9mr1058824166b.8.1787773864469;
        Wed, 26 Aug 2026 12:51:04 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a5deae9a75sm4678003a12.28.2026.08.26.12.51.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 12:51:03 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1677c91969so155919566b.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 12:51:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoJrnWVaPxR10OQ43kioXbBdNjzPMpDKBzVIp6KhEBNQKsI0BAE6RS73OI1keWce5GwmB5axRIpEkS3NsY=@vger.kernel.org
X-Received: by 2002:a17:906:9fce:b0:c1f:1520:4de5 with SMTP id
 a640c23a62f3a-c250bb50762mr1103314466b.1.1787773863104; Wed, 26 Aug 2026
 12:51:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOs+rJW1QymCXkr8-mU4kwMFvznnC98CXVvZMRjqpXwjJutdtA@mail.gmail.com>
 <20260815114533.2171445-1-fabrice.derepas@canonical.com>
In-Reply-To: <20260815114533.2171445-1-fabrice.derepas@canonical.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Wed, 26 Aug 2026 20:50:49 +0100
X-Gmail-Original-Message-ID: <CAOs+rJVggeq-Y4hysPRtpV0pQRBU8cZTm-iyQ4EpHM6-6eapkA@mail.gmail.com>
X-Gm-Features: AcwNN1W5DIcNWEcvlctI_OYJ194qPghIiHh-JbFunx3timWYfG5krkQObSF_4k4
Message-ID: <CAOs+rJVggeq-Y4hysPRtpV0pQRBU8cZTm-iyQ4EpHM6-6eapkA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: asymmetric_keys - bound PE section ranges in pefile_parse_binary
To: Fabrice Derepas <fabrice.derepas@canonical.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for delay on this,

On Sat, Aug 15, 2026 at 12:45=E2=80=AFPM Fabrice Derepas
<fabrice.derepas@canonical.com> wrote:
>
> On Fri, Aug 14, 2026 at 11:29 PM Ignat Korchagin <ignat@linux.win> wrote:
> > > Tested under KASAN (CONFIG_KASAN_GENERIC, x86-64) with a KUnit case t=
hat
> > > calls verify_pefile_signature() on real images: a signed-then-tampere=
d
> >
> > Same as your other patch - any reason not to include this KUnit case?
>
> The reason I am not including my tests is that I use real signed EFI
> binaries (a valid one and a tampered one), ~88 KB each via xxd -i, which =
is
> a lot of binary to carry in-tree. For upstream I'll write a self-containe=
d
> case that constructs a minimal PE in the test itself and asserts that
> pefile_parse_binary() rejects an out-of-range section, so there are no
> embedded blobs. I'll send it as a second patch in a v3 series, so the fix
> is not gated on the test.
>
> > > +       for (loop =3D 0; loop < ctx->n_sections; loop++)
> >
> > Looking at the code again: seems ctx->n_sections is user-controlled.
> > What happens if it is 0?
>
> For this loop, nothing: n_sections is unsigned, so "loop < 0" is false on
> the first test and the body never runs -- no chkaddr() call and no
> ctx->secs[] dereference. So the patch itself adds no hazard for
> n_sections =3D=3D 0.
>
> But you have pointed at a real pre-existing problem one step further on.
> n_sections =3D=3D 0 is not rejected anywhere -- pefile_parse_binary() onl=
y
> bounds it from above, against header_size -- and pefile_digest_pe_content=
s()
> then does:
>
>         canon =3D kcalloc(ctx->n_sections, sizeof(unsigned), GFP_KERNEL);
>         if (!canon)
>                 return -ENOMEM;
>         ...
>         canon[0] =3D 0;
>
> kcalloc(0, ...) returns ZERO_SIZE_PTR, which is non-NULL, so the !canon
> check passes and the unconditional "canon[0] =3D 0" writes through
> ZERO_SIZE_PTR. Because the digest runs only after verify_pkcs7_signature(=
)
> succeeds, this has the same reachability as the read this patch fixes: a
> validly signed image with n_sections tampered to 0 (the PKCS#7 is
> unaffected) reaches it via kexec_file_load().
>
> I confirmed it under KASAN. With a trusted key embedded, a signed image
> whose NumberOfSections I set to 0 (leaving the certificate table untouche=
d,
> so verify_pkcs7_signature() still returns 0) faults in the digest step,
> while the untampered image verifies:
>
>   control (trusted, 7 sections): verify_pefile_signature() =3D 0
>   BUG: kernel NULL pointer dereference, address: 0000000000000010
>   #PF: supervisor write access in kernel mode
>   Oops: 0002 [#1] SMP KASAN NOPTI
>   RIP: 0010:verify_pefile_signature+0x5c3   (pefile_digest_pe_contents in=
lined)
>
> Address 0x10 is ZERO_SIZE_PTR and error_code 0x2 is a write -- the
> canon[0] =3D 0 store -- so it is a write fault, reachable the same way as=
 the
> out-of-bounds read this patch already addresses.
>
> Since we are now centralising section-table sanity in pefile_parse_binary=
(),
> the natural fix is to reject n_sections =3D=3D 0 there as well, e.g. by f=
olding
> it into the existing bound:
>
>         if (ctx->n_sections =3D=3D 0 ||
>             ctx->n_sections > (ctx->header_size - cursor) / sizeof(*sec))
>                 return -ELIBBAD;
>
> A PE with zero sections is malformed (a signed kernel/EFI image always ha=
s
> at least one), so rejecting it at parse is safe and closes the
> ZERO_SIZE_PTR write too. I will include that in v3 and cover it in the KU=
nit
> case.
>
> Do you prefer it folded into this patch, or kept as a separate fix for th=
e

Let's fold into this patch, since it is one place now.

> canon[0] write? Either way I will respin as v3 with the KUnit case once y=
ou
> let me know.

Thank you.

>
> Thanks for the careful review, Ignat.
>
> Fabrice
>

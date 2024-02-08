Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33207EF19
	for <linux-crypto@vger.kernel.org>; Thu,  8 Feb 2024 17:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413087; cv=none; b=qNAxg/eP4titpjCmbDGBRCixRXwqSiT2FsCDx8oyZZhXHpx63DuawMPHQavNfeZkdF58nWLsJ4Si5T3+0Xn78US88zHfhYyTY358DSdNfcyB5Rq+CaB8hteaxCOZPIkMhtAxp2iToNBbvw3HqIWyzqDBGA2/lXIvWAOQpz3kLNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413087; c=relaxed/simple;
	bh=nV/LNjb5CU7yzvc5i8UEcZU4JJuy0e6i3RxrzHZwSno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvktGMvmzwXSb8W00wCV9XRZagg3mfenxo/aUXNZhDTry0MU7dTJnrt5GOK7gOsRbCwwDgqUGiwL12gV8dbo5eX0rNSyHGu43idvDrNtGWEhiUVEMbrvLHuvDWwP9krtX8nnY7pObByhvlG84mhwKcQrIQASzM+PyVjaXYF99eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UL+USnRG; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UL+USnRG"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40fd15fe6a8so85085e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Feb 2024 09:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707413084; x=1708017884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yarRK1lAFRq9eCULl/Eq1FKildQp7BdcoEWnr9X+znI=;
        b=UL+USnRGDZPPykPK0MECeDFEBF1RnmRmiq9VvBB6oKYaCuFaFmQqkjdTt77YuWFaoq
         GsLl8boi7fD/UO2RrfxHLd0PN56xjqQKDizEhw5FmEenFRPP014vSlrVlo2D4w+aAHvR
         nlekPOCJaCTrQhVRXaEuEo1rUeaRfvtPIZOSkMnCWApcMJICxRw+FTcpMc8cKpQneapF
         aIc8wXkhRhUiIp6cRYCRO9sm6vqZrrf6eh44Ot7DOyyJ8zsVQUtrsouBu5R0RxDjjA0X
         m6kv0vjyGT38C7tC4ZAnuvGQPmr2ng6RHBfQxqlidUMmE96bsg0f9RiSPoFRn4y4qsUc
         rmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707413084; x=1708017884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yarRK1lAFRq9eCULl/Eq1FKildQp7BdcoEWnr9X+znI=;
        b=YO+EadHG3hCt4e2Z/+A2e9NNb6oIwRlwtrSL8G3EF/nQ+OVO823rya30WZKe9dz2NT
         AZXBwgVIMgxxjT4BXI+cHIOMMFjq6lu51kvy9kKpgfZY1bv3NFeZA/11+Ho8ky1eI+T/
         nKONkKHH2503pLRi+QsX8JdBOzF6Cbk1B709RO5vbkMZuD1D2qBFYXLNYoCL2BCUsjEa
         lOMsrpIjCAovb2/yI+7mCAZGx0geIRrnlcwHEtPOEy3Hb4cjHcx7NKSb0nLrQUAlbzLh
         5knP9o7ltuiw/MdEYGnCLFfQV1lKFQehcKSXeHkk6M0JF60oYOGo0X///OA7xFXjfx8N
         AuQA==
X-Gm-Message-State: AOJu0Yy1Q8ihtKNSv3oPtKDLohsrLGdrlwxLhF1rZcKpZFy2r8gscKBT
	DsGiVyJYY5AHvGK+HTl6zX2IYuIXfpq8wCm1rKD0eb+A8ys1J72Q6wdhJbj1wCq0YPc9LwwO2hp
	QZoTNCX1t0fq2Z59ob4W1NA0O9F21JNAvVzqX
X-Google-Smtp-Source: AGHT+IFAe4SP6oZGY/A/Of5dn+VQ3xb1HTWjy0AeI++s2i99iL2iMKe0ViiNXfC/FrPD9boggoK90r1zd5YEHCDBzBA=
X-Received: by 2002:a05:600c:a385:b0:40f:dd8f:152c with SMTP id
 hn5-20020a05600ca38500b0040fdd8f152cmr445743wmb.4.1707413083683; Thu, 08 Feb
 2024 09:24:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207215439.95871-1-mario.limonciello@amd.com>
In-Reply-To: <20240207215439.95871-1-mario.limonciello@amd.com>
From: Tim Van Patten <timvp@google.com>
Date: Thu, 8 Feb 2024 10:24:32 -0700
Message-ID: <CANkg5eyntgB7a7Fj2UKkTncAhM=gbcQXJds7ZB2VKO3kGAsz-A@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: ccp: Avoid discarding errors in psp_send_platform_access_msg()
To: Mario Limonciello <mario.limonciello@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, 
	"open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..." <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 2:55=E2=80=AFPM Mario Limonciello
<mario.limonciello@amd.com> wrote:
>
> When the PSP_CMDRESP_STS field has an error set, the details of the
> error are in `req->header->status`, and the caller will want to look
> at them. But if there is no error set then caller may want to check
> `req->header->status` separately.
>
> Stop discarding these errors.
>
> Reported-by: Tim Van Patten <timvp@google.com>
> Fixes: 7ccc4f4e2e50 ("crypto: ccp - Add support for an interface for plat=
form features")
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/crypto/ccp/platform-access.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccp/platform-access.c b/drivers/crypto/ccp/pl=
atform-access.c
> index 94367bc49e35..792ae8d5b11a 100644
> --- a/drivers/crypto/ccp/platform-access.c
> +++ b/drivers/crypto/ccp/platform-access.c
> @@ -120,7 +120,8 @@ int psp_send_platform_access_msg(enum psp_platform_ac=
cess_msg msg,
>
>         /* Store the status in request header for caller to investigate *=
/
>         cmd_reg =3D ioread32(cmd);
> -       req->header.status =3D FIELD_GET(PSP_CMDRESP_STS, cmd_reg);
> +       if (FIELD_GET(PSP_CMDRESP_STS, cmd_reg))
> +               req->header.status =3D FIELD_GET(PSP_CMDRESP_STS, cmd_reg=
);
>         if (req->header.status) {
>                 ret =3D -EIO;
>                 goto unlock;
> --
> 2.34.1
>

Tested-by: Tim Van Patten <timvp@google.com>

Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F283D47AF
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 20:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777406887; cv=pass; b=J+S3v3727tKYB/1CMoeVqDJXJqnUQ6biRFFDLDyTivPLSOsNLtss34GuU9mZUYsfUN2aYTXY7L4jZ1K7BrSraZI4Ruki2if+T9qhgEuS1BXbU3Odu6BJijIzX1BQbYOCpShDBunQJAdCEQU/qg7Xj/7oMW384JXFmbDVHn0/fR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777406887; c=relaxed/simple;
	bh=fQMknEkO6zX7leeH6wjWjS3N+IQG1h23K4I8H/ei6ec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MzEev/e5JyPeRb27lOC76jgF86egtFsVdd8Ykkw2m/BwpniM42Bu9yBkpF0uR+dh5CtKPJ+NcRtTaiV6k+l0a5tALXT7uRIb0SPjNQ80hk35MHkoxFTd0JA86V96pdKOA/6GGkmFPHhE/UO3nct35Y/FKWuyPW25KwOdxNTV/S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7fcWvpu; arc=pass smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7fcWvpu"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12c565dd3a7so4088735c88.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 13:08:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777406885; cv=none;
        d=google.com; s=arc-20240605;
        b=YR3C96OWUQeV8PCPcQ6B1MJXKP26NhHddmyUqovGtll/ZKaNZm4wZAFNlsE4+PvxO7
         ycaRPHNNukOv7LIdcSJB5VX8w6g+/NMwT44Dgkdx6lBKSsfFKW6xHfiJ6448UW0mx2KY
         ZfvnD+Dr4MuHQUAZRTdthqyR+XQCqeQZi9sktHqJfBXrHV1Em2tKF+g04TnD3QI+wDGO
         UOoTvIHjlTPgpWheQuHu2mhU9bBNoCgtvVnZ0kVQDdaEXERGXYs17aagAg3viusyYXRb
         3n1PpGpnI+kFah+TgAilIRG28CxB1VUp1attIXRuR5tFY0yvha5V7m/G8V5ap92eDnm7
         e3cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fQMknEkO6zX7leeH6wjWjS3N+IQG1h23K4I8H/ei6ec=;
        fh=etSiHrgHphXuFr+pjswuyspsJ2j4ug4fwWiDTkBfNIw=;
        b=URtbKXQI7AgaqFoQlCgTHAcWTuKLAFTDBeiAqAZfoqWP7lepp/K0b7Jw3kNUfQXmyC
         9cdl+sBorW+SuTpVwuih5cfLJGD8Dkm0Seo2hEtTReAl5Nuwdgo/PGQrePcBePfC69Hj
         +8ic+3MvDpqd4ddCIGeRmx40rApvtjFTg3xQulzk37F3XXWornNAjhqItRbdv26uGvCn
         XYa34gmVlpjqQKPlbbPs9crRIxyYybW0xR/fXD2NwiuLcNE84nwv6EKHYaD2Ke3KiSKf
         I23rJPJX4Gqd3B5EVQWkkByMKKtGJN69IoouyNPsdZE8rAFJfxKdeH/NoM8DHlpRAavc
         FWig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777406885; x=1778011685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQMknEkO6zX7leeH6wjWjS3N+IQG1h23K4I8H/ei6ec=;
        b=d7fcWvpuPLovxNu4qHMfzFDgwDmd+aRY5na/LhNqUghLEv6J+6pl2D0Sn0R0wWBM3H
         4iL5hOOd23LTAJmAXObUODb8xunrM1UQqg993+Lh1eowlxDp8QFbfNlN647txo46PeII
         ipuu7fJEVZ6Kj9IeOiMgtKDjPp8pzo2RE/Z3ydoJATld4yoygERlPZ4y63ZtYHygxm3x
         GnHffu3xcoIb/K4FrzSbaztupnFUVb+du0eBar/hnvEoYctcFkUUTA9dPiDdjgMSD3Sy
         hLgcllW+Yq7LriUt1hLBZtP8MFUu1vdYI+epA7WamsdcQrR8W45usXZVHJ3gEP6H6mpZ
         262w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777406885; x=1778011685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fQMknEkO6zX7leeH6wjWjS3N+IQG1h23K4I8H/ei6ec=;
        b=iG/dhIFx2LghSLrwvEAF2NhsAnJoLoRG7p0jPv53d16uYiQbaZWm0delEN2cYsHKUQ
         fQoknsH7M2GRdxQPKgURBQG123jPmKgDCWZNSLJk5y+yb+Dk4oKvnr7qvuQAIZPym+pP
         kQK7kZ7g7n80izmyTnPDXiGEdyY6w0I6apMYcm37Lj53FtzORE8RTLgO6BHdNUiMuSXO
         k51GgeG8PFB0JjuIAHDwuknB8ZdWA+f2Zl2dgOV2SMi76NxYELI5STKGIhnk1NoT3iKA
         vwgwEmtPIXr3mldKz/Er9vn/3DmW/MdwJbuptGKokUcDElLQzVcrNLTLB9uH0gN8To82
         urgQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2yq7KwA3coUTPTlG+RiFVvEOZfxWFX/lipTrmIMmAUilV685qEaf2OWRz89w3c91TwuZZQDalk3SZZZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEyyU0JyVbHskYG6Tb+ll2VZocsOOw12CIi2lx7OHgJ1K9aUFV
	JVhRgG7OXN+cKEVu1l+sHTWGasaInavA560Sz89HAJDFNr9HzscO31Vb2QSf02U/vZiBFrygS4a
	DbNm73WTd4uzpMx1ynvh5fPo1BI/fvf3NowoQxNRr
X-Gm-Gg: AeBDiet4KgG/DuIRMjMkv8ibbAhjBOdrNYpumtDnjavoYtWYRVN7O2C5Z/KJsq3KkRA
	sK4QIrlMtH7bG0wDGJvEFPLz9vmeDiHiUQIzCXCH+AOlpZhqtSCcZRXwi9a+Fpi4JpPgocLMPZp
	Rk/5778Q6jz6irCX4xLEgiuqmfOvDiFtSmZMsW8T+VIQm5wwGpMavmkVe5C1FoTiWXAYi9Wlbwk
	w831lyitANzgjuUYWETZ1uZsc3ZYDDEXkSD9XSy5KeLg77SyG8F2j3SNa/VRu7PRUW+CgKWS9Bc
	93EO81BH6flpGhmf360SRdFmga/02KzTOoTAEMhw0f+GF+JdXbFe007Q6XGS5vgDrss5al/CfyN
	QRCIEhHfZAnd6XU8w2QN42fbsReYDdJAJOno2W/3N0RT4vgfbw8u9ggfYiV0qGBPdi2lxGw==
X-Received: by 2002:a05:7022:1b0d:b0:12a:68cc:3f08 with SMTP id
 a92af1059eb24-12de29f9d58mr408983c88.8.1777406884571; Tue, 28 Apr 2026
 13:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427104129.309982-7-thorsten.blum@linux.dev>
In-Reply-To: <20260427104129.309982-7-thorsten.blum@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 28 Apr 2026 13:07:53 -0700
X-Gm-Features: AVHnY4J73j8pL-LfVuqAh555PFEgauGF6YTRh1yCPW0Fh77Uly1m0wFVgjicirU
Message-ID: <CAAVpQUDMrtAtJnuCvp34-OTLa4w1jdGoezP+o+OOBNpYw5V5WQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] sock: add sock_kzalloc helper
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 3:44=E2=80=AFAM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Add sock_kzalloc() helper - the sock equivalent to kzalloc().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>

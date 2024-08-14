Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED121B9B50
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655182; cv=none; b=N8qJeyBWMT35dn9UatcLYTtyh9VtB2LGQQkRpL0fxYi0gYSTuVwBRcKMcyDXKwQp0AGGmOPeuH40XYLnAwfqbvwrRCdYGDikmjrku3UA5DCnuFs2dSqkm1Xi440Jfhi5wg/4T4/jI6QwP30t08epeMSRLRfmoH73aQgkN8Ek4dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655182; c=relaxed/simple;
	bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2RCdoPmEsBqM1WAGU5W73BI9BPF/stR7m+uQLkdRWW45rrwmq8MSjqS1SBtwhqlskPOjCGk9PUZnUpSbIiBKAA02P50YsPQ9tgM6HNsBtQwDgMUAu6x/WbNgMfJchS7thHWDq6lMlOO7giF6us8LELAI/ATCvyBVZU2+yIGVCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vw2rjbpG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vw2rjbpG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723655179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
	b=Vw2rjbpGVaLj9GhbF4znSARFqXop9eAHC47rftBRMoUKdsfme7/hdfdY0cbzZPpbIyQADS
	VzODf30GAZQQIY7wdAMTcQbLM7tA3mYiQuvGgTdv0A/UH9gSrBgclVU8IZ/fCNS5QPU5ym
	SiUJPqNjUDtrI6dpBRLIf7NutqUCmEE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-1YMYLouvPlOgM28HQs2rPw-1; Wed, 14 Aug 2024 13:06:18 -0400
X-MC-Unique: 1YMYLouvPlOgM28HQs2rPw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-36bbcecebb4so98837f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 10:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655177; x=1724259977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sARIX4ukqMN0+YO7QoHBlDh3NtqVN+qyWfzelkzISJQ=;
        b=SYvf/A34afsYZVjCk6DiN5zZj/RC834hZNjFHEP1hDrqEHsZKWDe09zTx5Y3wRWJAR
         vG/t+Pu10zPuGsr262O02nKNEqEl/pL9rh/Z4WCyAi8cYsLYLWRo4cgNERoUZ1R+bFdM
         9AkWSwKDG+Z4anoLuxtxdpeejjJ6pjA2vpZ6d+KLy6xYflfD9uO/iVlTpbj0EO9Lvajd
         CNIW5AThFaempUozPBuX939TTfKvJBaWamdHao7yZL8T1FPYrSj067yUaDxUNq4kQsuL
         3+jVgIBw4PlhLNa5aE1k+/XRLer56XtG2RYhpR8NRX92HIiwpjMGXmJ1MlHX/pFi4lHa
         kA2w==
X-Forwarded-Encrypted: i=1; AJvYcCVCfj4ZCFAvxlOd42fQk1YsnkdfG+84qDTUvAsIifc1BqhqPdM0jDjGvfaXq12oRLZ/6D9DSJmXUwDc2PJuGGflB7cMIDZpVau/o2GO
X-Gm-Message-State: AOJu0YwsDvpwRsFAc358nHDbVT8gpKidcR9nW7+1esbIHYzQr+siglEd
	XanwI6DpTvYyCB5Ofk1MooTmbz948+vFprNuHMA/9Yrt57hMgy2lPeub6lR3FtjbYVhDfVPQ4x5
	wzhxNguSCapQooWWAPztYkBnM945Gabxc7+0PihkEvieN+9kcW1AoWNm5vphcilZVJTvKUtsAAJ
	/QVh+XSeSjfdxVlo/0Oc+ZOcnM5iFKePIJ59JC
X-Received: by 2002:a05:6000:a91:b0:368:e634:1520 with SMTP id ffacd0b85a97d-371778158afmr3221000f8f.59.1723655177101;
        Wed, 14 Aug 2024 10:06:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJ92s0bv9O9QBrTJDwjKcvnvPi4/xG23d+AxWMhC7q7M8ceY+CEkp/DVKnrkLJkmwapEuW3h74NVPYEizA4eA=
X-Received: by 2002:a05:6000:a91:b0:368:e634:1520 with SMTP id
 ffacd0b85a97d-371778158afmr3220976f8f.59.1723655176647; Wed, 14 Aug 2024
 10:06:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814083113.21622-1-amit@kernel.org>
In-Reply-To: <20240814083113.21622-1-amit@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 14 Aug 2024 19:06:04 +0200
Message-ID: <CABgObfZHVO23h8MmWy=nzaToTMqcG3WgUVXHXf5N-Ca+c0y5wQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: uapi: fix typo in SEV_RET_INVALID_CONFIG
To: Amit Shah <amit@kernel.org>
Cc: seanjc@google.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, amit.shah@amd.com, 
	bp@alien8.de, ashish.kalra@amd.com, thomas.lendacky@amd.com, maz@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 10:31=E2=80=AFAM Amit Shah <amit@kernel.org> wrote:
>
> From: Amit Shah <amit.shah@amd.com>
>
> "INVALID" is misspelt in "SEV_RET_INAVLID_CONFIG". Since this is part of
> the UAPI, keep the current definition and add a new one with the fix.
>
> Fix-suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Amit Shah <amit.shah@amd.com>

Queued, thanks.

Paolo


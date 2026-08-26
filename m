Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5FC44607C
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787756292; cv=none; b=RU4YaiIHeBh0r+8IYKyoS9igft+Zh53/kMqS0s85B/sTDN/gm+lku1EgdS0NFrFvBewwgJ+P50uW2cvR8rpq4aL2BdlQslEhHBiTO4+GU+/bAgvzFWudztYn9ZlPof6oRiNHnJPbxVqlYPoo9BhW5qkAA/bTcKgE9ZcdagIb0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787756292; c=relaxed/simple;
	bh=YvujksyLFDhmPQJuueDPzzMP/JE9fimvOtcAO4bvLZU=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k9aw6bkqbcNbVV2gFKXzb5LnLhqyQez4UG4teoZeL/UHkipYKuEJVQzEoZgSXFU4rrQcduQml4xdWc3KNCtOSsHppoi74exqdPFvVsX5YNUdnUfr2i2fOd6r9tCYiM5kvVvKj0Ms3HtVGt86x7X9A4w148N5XjNoYNxwuQVdNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUqdbNvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUqdbNvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB6C1F00A3F
	for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787756290;
	bh=YvujksyLFDhmPQJuueDPzzMP/JE9fimvOtcAO4bvLZU=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=RUqdbNvZSuWZezsEwc2FRMAC80gbuiOrO0thk1oS3UG015LUJ/UnqR591EohEUPyU
	 xOAhXABHctlRziAcUC0LE9RYCyZxxt7s6wRpzNlNcKKxX98Q9OxdtPI3CVCyHjOHps
	 L8rXPCgFQhLIqdnKn6QTgAwvP2OuzjURwQGyLzH0mbkqt3/zbMh107qENU77OlavjS
	 b82KQ+WNr49Yt84SSFXjyGTBidYmInjjkOwwZTUTaFDn0X+FDz9gvanBFjgcmYEllM
	 OcHg+rw2f4+IOzT5aVeE7SOyFByCLQuxEOrJOduhYt1PkBlZRroLjYANjmgLjqzpUb
	 0smNflUQs9wZw==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b4ab4b4179so766624e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 07:58:09 -0700 (PDT)
X-Gm-Message-State: AFuF++mcixdPJk+BadRj33fdovlVa7Tz9t7xxPyQQPD+sXlBWFNGZmGF
	RTIhLIN9l5W6EO016uZcjUuN4fqFnao2z36YYFFZdnEdEyfpRbTOhj7etHyNG1/OcT870w+k/ng
	xMskRcwguV9ORUvw0qKtlGr0k/FFcgrJJNP+/quSEFA==
X-Received: by 2002:a05:6512:318c:b0:5b0:197b:9827 with SMTP id
 2adb3069b0e04-5b4a9003109mr2324523e87.3.1787756288681; Wed, 26 Aug 2026
 07:58:08 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 09:58:06 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 26 Aug 2026 09:58:06 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260815150946.12142-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260815150946.12142-3-thorsten.blum@linux.dev>
Date: Wed, 26 Aug 2026 09:58:06 -0500
X-Gmail-Original-Message-ID: <CAMRc=Mdbk0tH=-hG=MXwFpY9ARzuAuMmvi7fhTKEPzmpuw5_AQ@mail.gmail.com>
X-Gm-Features: AcwNN1Wnew0yhSJaB7OhGm28Gy9RvMow8DWUWA6z3mUd8NRlAST-l5JlU_tfAYU
Message-ID: <CAMRc=Mdbk0tH=-hG=MXwFpY9ARzuAuMmvi7fhTKEPzmpuw5_AQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - simplify control flow in register functions
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

On Sat, 15 Aug 2026 17:09:47 +0200, Thorsten Blum
<thorsten.blum@linux.dev> said:
> Remove the goto statements and handle errors directly to simplify the
> control flow in qce_aead_register(), qce_ahash_register(), and
> qce_skcipher_register().
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

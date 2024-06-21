Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6E2C6BB;
	Fri, 21 Jun 2024 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718981146; cv=none; b=aD2WNX5eUjhVCpj+TmrdkpGgJv4rje9j+Cspy6M9aQi5uNv4Qidt155Qr9ktGxip5Y87IfdNkrK3NDWHZLYQuzJH5Xx8Qc85XkMhb/RJSkfjQgOJgYYh4uFlxyJlJ3Cw3hQym2FFNMzgmgVANazaYUg9z4rmyD/ooUKcGJoMcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718981146; c=relaxed/simple;
	bh=NxVj40cdOchzrQqEkP4dhiyynqL5T82rHBpo+PoV684=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mm+f9oPgJT5uXO6Gghq6SyJpbFJE3xMN6DvCXnCVJMXKMo0wgpxtMihivTzZ0BNsTzBE2vIqPUbnBBRUDnLE8YJooQS8VBzgHW+tMAG4GHWno6V5JVHJkOvn07mlc1b66lGOzEQM3rs+woNLbdkragtpwzRE7U0h/svzfAgOmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52cdb9526e2so259327e87.0;
        Fri, 21 Jun 2024 07:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718981142; x=1719585942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NxVj40cdOchzrQqEkP4dhiyynqL5T82rHBpo+PoV684=;
        b=GN/l3qgKMsEbj1EWybBJMUFDFJ1FZbbtfG+oY3SwvMzOoB4c8/L3ptrn4IDwxMkyoH
         mLRL7UOJ4aoPzN7cnQY7XzFfMn0RyH5jgcdwK154Ws6LoNnVHDcHx3KRor0Ekx+FH2gr
         ILSPVfrCjufqSn/iQvXtzBcCeR81kZKYAdjtPt1mPgHkm2vDd3HuNgRdlfpvuFIPLyvS
         UG0ZFqvFtE3oWpxXuMPuPydAT7wAdZlUMlGY6PGfCOhJJPTQHKvkgQHtbQiBDHC8Incb
         Y3LbvZInAz+R/uCs9JTQwecXkP1p3ebFXvuF4laaLyq6y4pGYlgIdbMuh473AKJW5FVU
         QkkA==
X-Forwarded-Encrypted: i=1; AJvYcCUdb5OGJnJn6+Gh0WrbmSvnbHl3advokAAEDIZszP/x+LA3OtuK/F0UlMBkra40JYNfYgkOVzcudiOeCM4GHLpjChN8v3bKFp7S9uh7MahKdhQlK6wryXaMN3N8S9sdSq6gZAyF/1SoLg==
X-Gm-Message-State: AOJu0YzQtDomW4JO/0hd4bS15l6xtQuqa1Brx699MKXVR1WfmFqoVxCO
	PJ14z9S53ZuRjuzALeMA7rNK7Q2ySU4ywut9nvMp3/DhRq7QN+HFz3erDwcK
X-Google-Smtp-Source: AGHT+IF7Qwm8F5y5qIxkgDIHfWWxyQyxSTsIzpZsHW/pEqkqqA9vXa+JkC7HiI1KqQxPGV2slpcvKg==
X-Received: by 2002:a05:6512:3e0a:b0:52c:9fb1:6ae with SMTP id 2adb3069b0e04-52cdcde47famr4354e87.1.1718981142510;
        Fri, 21 Jun 2024 07:45:42 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cd6432b2asm218981e87.232.2024.06.21.07.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 07:45:42 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ec4a35baa7so12522291fa.1;
        Fri, 21 Jun 2024 07:45:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXO4FT6RCw371vxFRM1AUaq8RN1zQEBpk5DF8Wb4uvDxRO8yMRNs4ATCrU+fE1z6hir0Hy67deYXzIIq8kLgVaW8pnBIYjcYPOIeMzAxtrki4yu/BYQsw2vBa/Ateu1hmssgymcASBuVw==
X-Received: by 2002:a2e:9b53:0:b0:2ec:35a3:20bd with SMTP id
 38308e7fff4ca-2ec53afdc03mr148101fa.22.1718981142291; Fri, 21 Jun 2024
 07:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240616220719.26641-1-andre.przywara@arm.com> <20240616220719.26641-4-andre.przywara@arm.com>
In-Reply-To: <20240616220719.26641-4-andre.przywara@arm.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 21 Jun 2024 22:45:29 +0800
X-Gmail-Original-Message-ID: <CAGb2v656egzMQ+YqwZm=Z5QyHzEKGoSOivZxYhzBbq4GGp8mEA@mail.gmail.com>
Message-ID: <CAGb2v656egzMQ+YqwZm=Z5QyHzEKGoSOivZxYhzBbq4GGp8mEA@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: sun8i-ce - add Allwinner H616 support
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 6:09=E2=80=AFAM Andre Przywara <andre.przywara@arm.=
com> wrote:
>
> The crypto engine in the Allwinner H616 is very similar to the H6, but
> needs the base address for the task descriptor and the addresses within
> it to be expressed in words, not in bytes.
>
> Add a new variant struct entry for the H616, and set the new flag to
> mark the use of 34 bit addresses. Also the internal 32K oscillator is
> required for TRNG operation, so specify all four clocks.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>

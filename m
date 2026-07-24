Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6443F99FE
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 22:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784931289; cv=none; b=YVyUv1tjLWVbEZdhXsuUoxdH3wRi7uK3vR/Ft9B+RVMkSlemYXB1mVmWCqdBGPOLbAUySedmrA7B2j8TPfns83yoTz4LT9U3Jv9XK4t3xvbgsuCMavPJbhIoxlK864bAP3BpFT19k2EPt6pRmcZpEw6dzb8Pg7riOiJAfHVHIRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784931289; c=relaxed/simple;
	bh=TOPaKmNckDvcgQmmExHska8Z+3r6aiIwmxBNHoTxxaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=urDtFi4IbSsYMbg4FHETpxkbd+oldxdPw7f9CftPrhRaonZt0MsWZCB0I5GlEj/uvqZwvmCVn6pMxMMUOmkaWtsDrm7gpkbUnDCBnDs3nguQ5w8OLujV6RbDCf9vcZylkulR4pOTlj+dOJBpPR7ey6U0Jf3FmMCkFg3kWoNk58A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtHfqT3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtHfqT3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5735E1F00A3E
	for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784931288;
	bh=TOPaKmNckDvcgQmmExHska8Z+3r6aiIwmxBNHoTxxaM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LtHfqT3sxiWYryab8npI1acPJKFsfGsVSzgUgoFGYGeiZDK5rIqhQYMh49wBjXSU+
	 J28V3wNf3pHBVk0Wdvj2m9AYfeFf3IvHZj0qctHZMbgRO5AAmuDCo870Dvy1dlMdkv
	 Z+NTiXip/JjIYyd1bNpkk3GW60keNeZcUPiNRr1znqzCZCQfdo/I4axuNfcDbtDa3v
	 3eIl2OVHITS7qU6YKrkfNcJ1+ulkWfuQUcVETYEFn9YkebqvZkZLwCbHd4zEFXUN0w
	 hxKxFVUdPWJMEd0HvtqNg5h+BeV/LXdEwjrWHu03oKI7mBaB15+8Jq5LY5AatJ+t0k
	 eatiAyAMIVAkw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b021916bd3so1002918e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2026 15:14:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqVMUa+9NB63y6L6Nm6y7ss38aLQCDi8uWpOxiWq3vQ7HfjKxrEv8g0ELJgF6VcZ47dITsNl4CR9Pa1HlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwthjwFpXuPsITycIa0jyM+Qw12hYgVdh7SRFYZ+HX3SoDP8/5N
	AVwIOqAo24lmReJxw/UejcPe8UUZl1zUVNQgDuHk5im0hlf0m+yn5ygr9hzADaznCZDBPOPLmfR
	akZw19jeTItPSpsOM9zFH+oI6CMVnM8E=
X-Received: by 2002:a05:6512:3504:b0:5b2:8de5:ce9d with SMTP id
 2adb3069b0e04-5b2b2f74b53mr1739071e87.50.1784931287156; Fri, 24 Jul 2026
 15:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717080045.191538-1-panchuang@vivo.com> <20260717080045.191538-8-panchuang@vivo.com>
In-Reply-To: <20260717080045.191538-8-panchuang@vivo.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 25 Jul 2026 00:14:32 +0200
X-Gmail-Original-Message-ID: <CAD++jLmVWUVAnb+UzUPCypHid_r68C0JFaSVdTSw1jftnpJ2Pw@mail.gmail.com>
X-Gm-Features: AUfX_mwHY8wlQTjuQQHMEE-3RVHYLAEpXSek3Hma4TN9-jsazFca-kzi2Q8HfIs
Message-ID: <CAD++jLmVWUVAnb+UzUPCypHid_r68C0JFaSVdTSw1jftnpJ2Pw@mail.gmail.com>
Subject: Re: [PATCH 07/12] crypto: sl3516 - Remove redundant dev_err()
To: Pan Chuang <panchuang@vivo.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>, Corentin Labbe <clabbe@baylibre.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"moderated list:ARM/CORTINA SYSTEMS GEMINI ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, 
	"open list:GEMINI CRYPTO DRIVER" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 10:02=E2=80=AFAM Pan Chuang <panchuang@vivo.com> wr=
ote:

> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() calls.
>
> Signed-off-by: Pan Chuang <panchuang@vivo.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

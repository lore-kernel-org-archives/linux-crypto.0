Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795673683;
	b=xej1F+HI/swR9OXQ7kVHY8dq0BUUAkJ4Zi099tn031eSb27mi3sM1c90fyyIYQInvgui
	 Wk4ioCavVWIzYYcUBb42HbWDCb+0oKgz9xuEcDb/+YwQipPn0qAZI6046y6iSAlQ0jaNE
	 jQk+SvFDdRAusdBshK97rGMZGNI4dkPfoV/WLNjnHL3iQa5zu7lfwTZQhkbOuvLS22GrG
	 NB8f+VXJMJ31mkmFyQBe7qMf6Zl/RMIwndzMHwwZvZqs0lwcNXcgWsA4S7UhxcYTelwdB
	 2vEA8uTwMR5F8xzOVR2fyV/l+PiW7zKTXwmC6qtETuM1ixFupwaQhPY8mZxhUzzT8uw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=mUxr52qRZC0dlONq/XcMJQeDMgSpZAsaaLlrj7GG4BU=;
	b=HwDBJ9wrb0IhJyR5xA35PXqSuSC8hptLlKh4rh1P0RjKHbTe2hB/iN9jjpsX2la5QHP8
	 F564BxBXZNsSp43K+S2Ap8nLgdkm3ofz83av+K8u4LAvOqsfgZ3ncyb9EPuTyro1PNhgz
	 F+0m4a7w6E12cUmaYsQlNMJ62qSamAlARmYYoLahHBBJwXUf7dYwKaVABwi/7Jo31BIYp
	 J/9wUq7PVOCDbLUsLEe81YxDRjt+DYDL8T1dCKkvc+IBhyjo3c25lBZgzPvqm8GKo925T
	 MlPsRYiZfbcDWPGwY3BzVAiKg8wGb+OehngkZeyvoBC+yC2ARqZG9fYJGvsEW+y+pmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="KZG/mCR/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8804606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 06:14:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8804606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KZG/mCR/
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5430f70c827so78357961cf.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 22:14:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795673682; cv=none;
        d=google.com; s=arc-20260327;
        b=B8dOc+Kr/mdWDmK/6TZVA/aGfEwuqxaUtpOTmXIZlJ6fAyw7cQEUjoRPAU5Jt9InSm
         m2NrvcynekRkzxzCKsVg5gubqoBiBrpRbFynTe2dK7ofGz400oNk8qOyEP2b/tP4aRwq
         TR5wJvG/au7vSLuOmW8XOkERmTpUk0bPwBgdPzNxI4BNLo9fKqHytCfQy6PM4tQHRnYk
         Bx7X8Vbvyx99RQuDSLEae0AGHLKB6moe4BIkXqr9vmVIGqaXylgD2WcBzUYpqX6XAEi2
         tkc7HpdU1Xb/v0KxrGUOFZEaAK8qKjsNVMaX7yWrl3FQeo+zdPM1L3TVz4L/CvwtSswW
         qKtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mUxr52qRZC0dlONq/XcMJQeDMgSpZAsaaLlrj7GG4BU=;
        fh=mYukIsWbcql1crXa3qAu+y4z81B13a12BT+UnGNeqws=;
        b=jRekNLPKRcH7b+eCrSqjYBAeTvNXuD3B5Q8/N0oFrCzHM0HdGYsqcnpc3pEv9nQxWs
         AFJwDZy3qejnGeJz68gElzSkuVf/MwaZ77IAVhJe98IiWHtcR2huIKYosSTd3Z6La34v
         +B0mCvtenpljTWVpkBFQmwGQlemUSTrqkO+tV2fnwEugCGhblZh1RoB3OFx2nUSDpr8+
         8fZT1IsDYwpdCBBuC7CefqioEggeMDFPR7gLZNEIN0do/twGnKYsqApT7Cf5wcbtcxuL
         VtJtsobxIsft3mGbuL83jKfOlNKBlQaYEIAgBMpOnkuW8EiJiWmCon6IAPJImkUje6UJ
         NLww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795673682; x=1796278482; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mUxr52qRZC0dlONq/XcMJQeDMgSpZAsaaLlrj7GG4BU=;
        b=KZG/mCR/6TjmN7B6AxcnQxGiT+DQNKv6+vrcj4AVehfzDV5wiHupOBRTOsJpKAM9cY
         811W/c+zxQK8iSVzpZyYCK6ibP2YJvSM78G+1hv7pe7k7sOrlLTT1GoNuGgzKcASUByl
         V6SoHMOTINXkxpftj8STkPqfsPQKyyGvH1Hf0mFxZ3i8+h3hp7LaB/n8aOPd0Jz+adi3
         HsNKzRyfevs/64ZJHdRTJUw1G6+ZerezBLf7oyaXNIRH6+Eo/lG1qdZXUdVOScCt8kNf
         LxYH0YfS6cv8+lVvPT5GY8sK+yBTBnkUTCa5oq2kqkGsq+hyl8EqlylfdkD5IeVInFw/
         iwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795673682; x=1796278482;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mUxr52qRZC0dlONq/XcMJQeDMgSpZAsaaLlrj7GG4BU=;
        b=Ur9PXS5ia7njLjH+iyeVHuGef7YBqcsjIkcugMdzT7n4Kb3OvWVqdvotPYLvDQO45w
         YNKEU2xyvWy3+SFiDQ0VRjYj+DkKMjSzES6zGI0xBru1lg+091JUe1RlWUn9G9X79IVa
         ge4ZdS0AFpzcfVb+0zcl+FZcEV3ADtsfXJDAp9D/Nxc2IskJyWSToT7ChyeMWHr1UVBs
         z4GdSxXNr4nbh7uwJt8fRYoCUCuibXHpfm6U4kAlKs/zyvp+3y0v3809i7UNW3wbktmh
         Ceihe+zg6ZU4wZG5E1ig57+Ckq2GuuTBX1HloscHwB+8TCOPbKbHrDjBoOgtIF2bBzEV
         G5eA==
X-Gm-Message-State: APuU4Z/tkN4On3b6t+zUUBGfSBsQPw6uIi4HZAneyGwA2Y/YM4+k09Rw
	/Q7Fuft365oo9JblKJzpGJ4t+qiwsQubRn5LMxnOEVWUIEAisCRd2MnZd1DeneRCikOzVHQPyjN
	zGn7P6NXgHiE5I1fYPOa8ZOeQzllwmcRe6Jof3Ms=
X-Gm-Gg: AZFdTZdgVqHw7jNJCNTKG3no+aqgapsgqJa3/r47VhkfjR5oRxX1WC/JbokOqvocko1
	09YxAwpQXCuKsWAy2uNezCl2lL6Byr0rg/osA+hQtr/g5YnvbE3z63TD3gYjjpbDBTUET/qWv7y
	vWC35EUnlxP04Rn/Ghfh2hnuJB1xK8WLT1lOK0OSKYBi073pHmSAqteKF4x0l5+FmSePi9KAZHd
	QcxbfsHUFEqgBDaAz/hk9TUoRCE5CHPWvqJNdjhqw3o+1QqxJLX0Gc+gKh9e5TRsrASx6CFX/V/
	R+uEzQp9xPD1AZf1G4PalyvrAZ7OZqjeoY/TT5c4LNy4qqs7zB7BCGSkIUhTmYr3+76E1hPflPU
	urOWsYXcKI7q4bkBJ7f5ubg3RaF8eFXZmo1uyyQ==
X-Received: by 2002:a05:622a:5a1b:b0:535:384d:68ac with SMTP id
 d75a77b69052e-55d769e9f2bmr361688051cf.13.1795673681848; Wed, 25 Nov 2026
 22:14:41 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126055600.23172-1-artem122novak@gmail.com> <20261126060548.24746-1-artem122novak@gmail.com>
In-Reply-To: <20261126060548.24746-1-artem122novak@gmail.com>
From: Artem Novak <artem122novak@gmail.com>
Date: Thu, 26 Nov 2026 00:14:30 -0600
X-Gm-Features: Aa3M54orCCMbRnFNTpSX_xCfn6m-xkAlUWoqql4WGvtI_DqQ-BUz3LNBOOon_yc
Message-ID: <CAPufuhZZ=VS0FsrxkK=Ba1kJot3Fp5TS5dxKUWs2o8TAotRdXw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: tcrypt: avoid 32-bit overflow in throughput calculation
To: herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the confusion in v1.

I accidentally included the two Fixes: tags below.
On Wed, Nov 25, 2026 at 11:56=E2=80=AFPM Artem Novak <artem122novak@gmail.c=
om> wrote:
>> Fixes: fdaeb224e2bf ("crypto: tcrypt - Use pr_cont to print test results=
")
>> Fixes: 3e3dc25fe7d5 ("crypto: Resolve shadow warnings")
(they belong to other work),
which refer to unrelated changes rather than the commit that introduced the=
 bug;
I've corrected this in v2.

Best regards,
Artem

On Thu, Nov 26, 2026 at 12:05=E2=80=AFAM Artem Novak <artem122novak@gmail.c=
om> wrote:
>
> Cast bcount to u64 before multiplying by blen to prevent 32-bit
> overflow when calculating throughput on 32-bit architectures.
>
> Fixes: beb63da739f7 ("crypto: tcrypt - Add speed tests for async hashing"=
)
>
> Signed-off-by: Artem Novak <artem122novak@gmail.com>
> ---
>  crypto/tcrypt.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index e6834bdde9b9..1e6132045c24 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -28,6 +28,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/jiffies.h>
>  #include <linux/kernel.h>
> +#include <linux/math64.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/scatterlist.h>
> @@ -734,6 +735,7 @@ static int test_ahash_jiffies_digest(struct tcrypt_ah=
ash_request *treq,
>  {
>         struct ahash_request *req =3D treq->req;
>         unsigned long start, end;
> +       u64 bytes;
>         int bcount;
>         int ret;
>
> @@ -744,8 +746,9 @@ static int test_ahash_jiffies_digest(struct tcrypt_ah=
ash_request *treq,
>                         return ret;
>         }
>
> -       pr_cont("%6u opers/sec, %9lu bytes/sec\n",
> -               bcount / secs, ((long)bcount * blen) / secs);
> +       bytes =3D div_u64((u64)bcount * blen, secs);
> +       pr_cont("%6u opers/sec, %9llu bytes/sec\n",
> +               bcount / secs, (unsigned long long)bytes);
>
>         return 0;
>  }
> @@ -755,6 +758,7 @@ static int test_ahash_jiffies(struct tcrypt_ahash_req=
uest *treq, int blen,
>  {
>         struct ahash_request *req =3D treq->req;
>         unsigned long start, end;
> +       u64 bytes;
>         int bcount, pcount;
>         int ret;
>
> @@ -777,8 +781,9 @@ static int test_ahash_jiffies(struct tcrypt_ahash_req=
uest *treq, int blen,
>                         return ret;
>         }
>
> -       pr_cont("%6u opers/sec, %9lu bytes/sec\n",
> -               bcount / secs, ((long)bcount * blen) / secs);
> +       bytes =3D div_u64((u64)bcount * blen, secs);
> +       pr_cont("%6u opers/sec, %9llu bytes/sec\n",
> +               bcount / secs, (unsigned long long)bytes);
>
>         return 0;
>  }
> --
> 2.56.1
>

Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB51377E82
	for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762879928; cv=none; b=tsYb9gLQKVYxe2rx6gfjoAy88lGKj9DpBELaRU9gfAs57L1JbkDzlzEstLhVdPDTPQznexWfrlJCMd1Lf5yjx7sFfdBpEA78bI7s/KYb+E1QzZXJdDfAdyB6WKNFYrNk7m0zoJxL5lIja/akqNupEQa5o+7uoL5w7cX61QeJXxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762879928; c=relaxed/simple;
	bh=HEIC2usiTHdfW1IJriTA3jOrfNUiVWrInSNqYkPBaGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ev/PLY38Ml8tj3LjsmtyxDfPGSgT/MBIBDie+TkbMsX83WEFJ30dUbEn0FNhG1W4zXhgJp/itKB0EJW3ZUJ74KVX6fHlI7QYrfRxLddqEkV1jIaQqxe49I3jkH+pm5rm7CQZ/IZ2ZdFNbssO8SLEZUwNE0ZSOOsfFgc+gm8NT28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=V6vmHzIZ; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="V6vmHzIZ"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b25ed53fcbso443729185a.0
        for <linux-crypto@vger.kernel.org>; Tue, 11 Nov 2025 08:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1762879924; x=1763484724; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uaNFkqsjr5HqJ0U2z2rhHc1IR4euaoELq+Vuadxi0mU=;
        b=V6vmHzIZ/0h7EG7IVdRdOaO4C+VQXmZpWkT533XH8PJbezQnyvbfR0oj+PHCbZgjYv
         MM3U9dyu0ZjiX15PmEwMJf5+JndnDy1GL3RKUR+8XIVMP0ibr6hj4nseci/qvvFxaDqK
         5VV0vdbPgLEaC498zwwEJUN22k87lH65Kc5805zrDSRMBwzZTSv1kftFRKcbq+3zF5hE
         0qP5TfYV390B0zbi8X94lENmZElkbGgjI40s+Hq/TsUn0ZX3m9XUhVspaKc2+d4V2Huc
         LE83yy8wrkxFyiyKxdOQrFSWnOuCzB/Ixk2uJRPM+pOOXEfemtiLVPwdy24UalKnQWJ5
         +4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762879924; x=1763484724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uaNFkqsjr5HqJ0U2z2rhHc1IR4euaoELq+Vuadxi0mU=;
        b=kKT3fMaxI/YuCCHN+RL8tCRnBr5MeN+8kIesF3X6NxoFcyfSD6g5c5bmunrM0LMdxA
         HNQcG5wzgj28InhdMQ5favV0sURh4QyyPmbIm2YuKwTKfSZKxE0rV75aWoKU/RVEHbdX
         lcXvXXHKZd7iJs2kHEyZy1O6+f93ZknrUubleF6VLwVFf7frJ4IkTvmiLdluIjZDK0TM
         3hFfSFUr82GMfxCWAXMumrTGehWuvVaMtHMbd2TO9xoMOSuG/5RQgkasJYcY6kfj252E
         mW2JEANgrzcngqMk4q4fnxUQkkITy74OOk/k+JWeHtF0aVn5yDkYXOX2G7AHdQVuHY9N
         mztw==
X-Forwarded-Encrypted: i=1; AJvYcCU3hbHghI8ay1Go6280wYQBGw8EHFTFmhU+rx3y3PViepnE7tGHPExLdgheUfmMaJ3WJW/q0sEJTVuVb9M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz54DVZiJoRrTyTooZJVQZAndLvFh9pOEiS4ZrOcZIziIbDWuNd
	UsxqPn2OyJnFENnPf5Zj8N1DX1o2rVfdcC1pOIrRUiO2LzreuNgL6Ycjhl/BGAeyK7TcAnpdXcU
	3kTe/PNx6zwKHcYp3XCuwKYJbhTpnXmIz9C8clGrhHA==
X-Gm-Gg: ASbGncvtP/LpqTygheDclFU/ndQFUJU2nsFzsqb8wRp+g4koxksE/rojBJVcUGax70S
	uGuXI9UWlYIWYt0rNC7DxmYIeZP7jz+Zm56+7R0VAFWwVOgrkNy+DpaZy1d0cGlKfEkgVmQQVh1
	00hl0EVYw268JunX76EAVW9shp1i4+cGb2cMi+i26OsM2n+HzMvcbVFGHx30f19rPMpg8nzrqNf
	A7bxJyyYqI2nrcYGSh4Hsob4zorymocgIq85LE7Fvt8/8lOqUkbWqxvXuKnOKz09wFMm3TctiAg
	xewSGZM04sTxwZM/+GRVxsFZ
X-Google-Smtp-Source: AGHT+IEUkPPpBFSnV49PowujRgyHB8h3Cch3prLC6j+Nq7FI3gGEKIgq2OVf2cRR3rles90pF9EIZfNOPT3YwIjwQ28=
X-Received: by 2002:a05:620a:31a4:b0:866:a24e:2eb5 with SMTP id
 af79cd13be357-8b257ef5b64mr1620026685a.34.1762879923750; Tue, 11 Nov 2025
 08:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aRHClatB48XT_hap@kspp>
In-Reply-To: <aRHClatB48XT_hap@kspp>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 11 Nov 2025 16:51:48 +0000
X-Gm-Features: AWmQ_bnpjuyUMlKXkIQGvaXCW-KCOwGvfQY3esE3go312vitsho8JRzN-sru6wg
Message-ID: <CALrw=nF_riH-aHJ6gpKBw59s0szrWhqT+QmdpYVH6d38Kc_rZA@mail.gmail.com>
Subject: Re: [PATCH][next] KEYS: Avoid -Wflex-array-member-not-at-end warning
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 10:46=E2=80=AFAM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
>
> Use the new TRAILING_OVERLAP() helper to fix the following warning:
>
> crypto/asymmetric_keys/restrict.c:20:34: warning: structure containing a =
flexible array member is not at the end of another structure [-Wflex-array-=
member-not-at-end]
>
> This helper creates a union between a flexible-array member (FAM) and a
> set of MEMBERS that would otherwise follow it.
>
> This overlays the trailing MEMBER unsigned char data[10]; onto the FAM
> struct asymmetric_key_id::data[], while keeping the FAM and the start
> of MEMBER aligned.
>
> The static_assert() ensures this alignment remains, and it's
> intentionally placed inmediately after the corresponding structures --no
> blank line in between.
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

> ---
>  crypto/asymmetric_keys/restrict.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/r=
estrict.c
> index afcd4d101ac5..86292965f493 100644
> --- a/crypto/asymmetric_keys/restrict.c
> +++ b/crypto/asymmetric_keys/restrict.c
> @@ -17,9 +17,12 @@ static struct asymmetric_key_id *ca_keyid;
>
>  #ifndef MODULE
>  static struct {
> -       struct asymmetric_key_id id;
> -       unsigned char data[10];
> +       /* Must be last as it ends in a flexible-array member. */
> +       TRAILING_OVERLAP(struct asymmetric_key_id, id, data,
> +               unsigned char data[10];
> +       );
>  } cakey;
> +static_assert(offsetof(typeof(cakey), id.data) =3D=3D offsetof(typeof(ca=
key), data));

The whole thing looks a bit convoluted to me just to declare a
fixed-sized static buffer and call sizeof() in one place in the code.
But I couldn't come up with a better refactor not introducing
potential alignment side-effects. So LGTM.

>  static int __init ca_keys_setup(char *str)
>  {
> --
> 2.43.0
>

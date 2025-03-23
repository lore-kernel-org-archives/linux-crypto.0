Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3EB1E5B6B;
	Sun, 23 Mar 2025 10:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742725263; cv=none; b=pz5YB9NiZKdAS4EYLG7pfB4q07KMV6/AnJpwCdkuQi0a49BHSeIkBucsbcb1r50wvI7xlAlmbxSlh/RLHJytcSJuDYPeOZkhyRWOP+EW27cnxPRawQ4NGpzVVDkVw6UOEUsqkKvgLyroARU9euzHy0WHPIys1I+ZLfg18yZFXo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742725263; c=relaxed/simple;
	bh=mhlcwCiOJk1OYGNmsrJQoGnSWAYfCzhWAm+lenx4tR8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FN1dmIlL1B2bBAQJr1Gq5YyX8ppWCx3j2aWXFvWCXw3vPXDr+yL/sd6T7DNOYxZKO0HGVBZ9RynVPaTGKT+IVjTwP8vjYL0QMjWa/t+bw3ROOnJcfaeMpiOPQn4cgF7HfSMYxTsXlS0qQ48xRep/CHaWQnZR7nvta2IzkwlXGrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQzNBeDn; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQzNBeDn"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3913b539aabso1834116f8f.2;
        Sun, 23 Mar 2025 03:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742725259; x=1743330059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeJQl4E3xKZmL5KbVn4fJK5YhYvsJTclIdlv1fujUX8=;
        b=mQzNBeDnrFJIdquMYUIk8vPgBm88DQtxwt4AAqKC+ZTD/95QXnBXovEm10vb6YJnTh
         823FGulYLsKfrk6bCWR7wnFR44Wo3UrC1MxWVjb5o0KVb96jB8lEXwD5GUJjNFYJyTbe
         wtNXaz0Sz81c0mwQBaINCLOmuza4CDOqwH3CwZPmoAHlXOI0uxnEzhJQ6Kc6CW1ZmLrw
         PELZWeXRDNv16f8/8MIYWkk5CuOZNmV4jaQh9n4sVM4g8jEa3d3WZblLhSmETIjq+1MF
         JqeLA8DufFf4485VAGiNfXin3vYZkuEAaZGUVnKFnYylHp0+Vx/MO1E2V11j9MvpU8Rz
         /7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742725259; x=1743330059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeJQl4E3xKZmL5KbVn4fJK5YhYvsJTclIdlv1fujUX8=;
        b=cHar1Zri0Q+/T9XPtgxsPVRAncWkfGMA81rO6hqz/E8as6DOX0txQ6KwIdlvGgOKWE
         vLPFLOJapDoLA8CfGLPLQ4YJ7CKzXAEGNyUy9ZI5FUPXS2PlkInM+4qsAVMExId09Akm
         hDQGRJiT+62QbivhQKUYmeviTPYZdO/RJXjkdinP6oqSc6x84rzObwQ5Go3xhSjwwUTf
         g/YO2uwllmEI6cIULQ+7AXy4hEahlJkeO6FkH0/H/uzAQukEtNeKse5mEz15a/3gVFCR
         UxYoLzH4CfMaUAGXSMalcxlRnmLURLaHEd95PUEjJGei7Q4GBnAv0+Tl14Au/cx1RW65
         UsXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKhDYJO51+EUgAyAGlQbWxcmFwhmgKCyE+UetYAVtUyaTjmB7SXG3pZoRpCPQ8yPx76b3GWi4ad2lbAIs=@vger.kernel.org, AJvYcCXs7IJW33UvblHuxl4nw3gTmM4Uj0ZdQKdOmmw4l0KkEEL1Rb5qVF3o0JqO6jn6V36LFfAZsJAQTGISmqmQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxoeEatG5/GZRsmnb7yiS5MpG7k4hyOfMXnnZs2BClQI0MNIpCk
	kzjBBaUQHtiFF6BNuKHX11rL1U4Pg/S0aFK/65UuCrD+XIMrB4d3
X-Gm-Gg: ASbGncvonm2o3suUMBH0UiIGw5pN3YKgz4RJsmiB0TOlQAzFNmEmMkELSTQblcMYyEn
	MdZaB2kgLdS+0HBJEboD1wb0O756v9xE5LA53Xoho2ugfd5iLcMsG9sp/vCP1FYpf1TDkgFfLbP
	7S8ssKNR/5Adw26SN5jBfdLf7/+ivh4ikAr1YLDLkcEtXxulXH2/VXqb0Zz0Ul553dfvL3xx1h3
	NuOfaxJ2UBYctMwLf8aZJdCJY8V+eTbypnHP+rPuosYZsPP2Ay7HSQxKE4Z23TNU7TFIkhzWoTT
	20cr9rrkpsxAS5m3LeobgghEVvv32KnIMvRC3jhLTGiZImzKrE4jhPZ34pVsnnWmDY/mPE2EfGy
	iMLLB5TgkDPYbjLoF+Q==
X-Google-Smtp-Source: AGHT+IFtspyb7aGU8PqUeHK5tVMGTazHsDMgEYaDtmM86O0LQ5fMac9P3KCTGj2Vs5NlkiCnMpgWhA==
X-Received: by 2002:a5d:6d81:0:b0:391:29c0:83f5 with SMTP id ffacd0b85a97d-3997f94da3bmr8008850f8f.44.1742725259346;
        Sun, 23 Mar 2025 03:20:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a3c90sm7575305f8f.36.2025.03.23.03.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Mar 2025 03:20:58 -0700 (PDT)
Date: Sun, 23 Mar 2025 10:20:57 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: essiv - Replace memcpy() + NUL-termination with
 strscpy()
Message-ID: <20250323102057.79c810f1@pumpkin>
In-Reply-To: <20250316211504.39327-2-thorsten.blum@linux.dev>
References: <20250316211504.39327-2-thorsten.blum@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 16 Mar 2025 22:15:04 +0100
Thorsten Blum <thorsten.blum@linux.dev> wrote:

> Use strscpy() to copy the NUL-terminated string 'p' to the destination
> buffer instead of using memcpy() followed by a manual NUL-termination.
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/essiv.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> index 1c00c3324058..ec0ec8992c2d 100644
> --- a/crypto/essiv.c
> +++ b/crypto/essiv.c
> @@ -405,8 +405,7 @@ static bool parse_cipher_name(char *essiv_cipher_name, const char *cra_name)
>  	if (len >= CRYPTO_MAX_ALG_NAME)
>  		return false;
>  
> -	memcpy(essiv_cipher_name, p, len);
> -	essiv_cipher_name[len] = '\0';
> +	strscpy(essiv_cipher_name, p, len + 1);

That is just 'so wrong'.
The 'len' argument to strscpy() is supposed to be the length of the
buffer (in order to avoid overflow) not the number of characters.

In this case the bound check is before the copy (and the buffer assumed
to be the right size!)
So memcpy() + terminate is exactly correct.

The warning gcc emits for strncpy() when the length depends on the source
string is equally applicable to strscpy().

	David

>  	return true;
>  }
>  


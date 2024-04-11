Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4C13C81F
	for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 05:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712813518; cv=none; b=CI0AIUVBm1H8qkm415VSZu8KkQGYSQ2hHrMTKQM+eG2jxtDXC9wH0KQ3xQiOO1v+mxBMZE6kArykifpAv+orJ/I1HzbZ1icsqhIPoO2Mh2FpW5P7XdkFzUC2G2+d+C5ci1F6cc9B611ZRT0TRgRPDdk0Mi9eZu7XYhlLc8fXh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712813518; c=relaxed/simple;
	bh=ojN/xMV7IVN8fvk1jKfWfjx5M57TuBQu/wFwTgnk/gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=novqTOmu+z6apjMs73PO09l3jGfb7NfoZk8fCNwokVHhWk7eVQQU2m1tQBrlQcPfi+XSnhzHcdxdmk9uqn1iykbSkGwYVK9P/5r+zshvsRVbj1n/P7+v3LRxQLaJkeIF5s5jDl+BYWnDTzwNLHFY0deBXtdOhBOW02Xvz3H5Xis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=OpThaoQ+; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="OpThaoQ+"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6151e2d037dso83595647b3.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Apr 2024 22:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1712813516; x=1713418316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmMtC5iK3O6S0iXgVptYO+6Sv57v1TF90CK03ieC43A=;
        b=OpThaoQ+UsmN5piq4+roQqheGvRTa9Ywa5gIRroHQClPnVtphcsKTkz/O2eMvo1ZEi
         aKmbGaj3z4KPKh+pwwObgZnKu2V5IX/OXpqDERk8chULCeP2iN9wjv6ZTa40yBJeN88V
         X3hSghnmsyaeSriZdMbB8A7Mst1jJTqkcdc4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712813516; x=1713418316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmMtC5iK3O6S0iXgVptYO+6Sv57v1TF90CK03ieC43A=;
        b=QKC8M7QSM8WIY6jeF+AcEmzy9RsYYXWt31tSuNAUdr2+Z7bFgM/0JxA/OrsuhRUF6w
         /8txD01nI3r4V6W+GIeau+cNfi7QF2x6jYiz0tdXodq94T1JktfoXnKrEnAmFH58t9cC
         fXWEpRUt1nWSjqTbq/Rj15SmKIVzVLSCIkShIixE3zRmcGOPETXraLTfmiOSkU6EGjly
         6TYMX7Yo0ZNLINp3kk0L9WKVUZ58ey5TX1cx9OFC5uDULrMSYv741AVWoznEI+n2gEmc
         w36yarb0HnBqGyYWs1Lud7c5ADW0gfCQmR1Fxs5lyLD9oA1Zh2PBDtrRogtyR5Vsgqgr
         Qt5w==
X-Gm-Message-State: AOJu0Yx+sXMdwG74evdQb4os2LNzHK2+MAOXbCBq+chKwl6Jwl7tT5SM
	s9/r9Um058LuIfv11WDDUX2RoZQhPfXWFHh05wT9ovaR5ecKeW+3pQJz1PypD91i77IENCgvN43
	sjBvVmQE2EHC3+u8kK28lZnBU4FD7YIC5PIs2Kw==
X-Google-Smtp-Source: AGHT+IEWxdXqjFcH+ITEgh6vAW6CyMIRPzYOCQvrZywMgOcwUFdN/oCEssRvtv40rHgdgvb+KpoEs3UHJmYcpW7hxjM=
X-Received: by 2002:a0d:ca8f:0:b0:615:3858:bcc5 with SMTP id
 m137-20020a0dca8f000000b006153858bcc5mr5576531ywd.10.1712813516017; Wed, 10
 Apr 2024 22:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com> <Zg+jhukIGEyFdjae@gondor.apana.org.au>
In-Reply-To: <Zg+jhukIGEyFdjae@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 11 Apr 2024 11:01:45 +0530
Message-ID: <CALxtO0=EU0LvpZvmzQjNfSq70EhAeLZi5Co0KdEA-6oQ46K8bA@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] Add spacc crypto driver support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure Herbert,
  I have removed all those that dont have software implementation and
pushing v2 patch.

wwr,
PK

On Fri, Apr 5, 2024 at 12:38=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Mar 28, 2024 at 11:56:48PM +0530, Pavitrakumar M wrote:
> > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> > hash, aead algorithms and various modes.The driver currently supports
> > below,
> >
> > aead:
> > - ccm(sm4)
> > - ccm(aes)
> > - gcm(sm4)
> > - gcm(aes)
> > - rfc8998(gcm(sm4))
> > - rfc7539(chacha20,poly1305)
> >
> > cipher:
> > - cbc(sm4)
> > - ecb(sm4)
> > - ofb(sm4)
> > - cfb(sm4)
> > - ctr(sm4)
> > - cbc(aes)
> > - ecb(aes)
> > - ctr(aes)
> > - xts(aes)
> > - cts(cbc(aes))
> > - cbc(des)
> > - ecb(des)
> > - cbc(des3_ede)
> > - ecb(des3_ede)
> > - chacha20
> > - xts(sm4)
> > - cts(cbc(sm4))
> > - ecb(kasumi)
> > - f8(kasumi)
> > - snow3g_uea2
> > - cs1(cbc(aes))
> > - cs2(cbc(aes))
> > - cs1(cbc(sm4))
> > - cs2(cbc(sm4))
> > - f8(sm4)
> >
> > hash:
> > - michael_mic
> > - sm3
> > - hmac(sm3)
> > - sha3-512
> > - sha3-384
> > - sha3-256
> > - sha3-224
> > - hmac(sha512)
> > - hmac(sha384)
> > - hmac(sha256)
> > - hmac(sha224)
> > - sha512
> > - sha384
> > - sha256
> > - sha224
> > - sha1
> > - hmac(sha1)
> > - md5
> > - hmac(md5)
> > - cmac(sm4)
> > - xcbc(aes)
> > - cmac(aes)
> > - xcbc(sm4)
> > - sha512-224
> > - hmac(sha512-224)
> > - sha512-256
> > - hmac(sha512-256)
> > - mac(kasumi_f9)
> > - mac(snow3g)
> > - mac(zuc)
> > - sslmac(sha1)
> > - shake128
> > - shake256
> > - cshake128
> > - cshake256
> > - kcmac128
> > - kcmac256
> > - kcmacxof128
> > - kcmacxof256
> > - sslmac(md5)
>
> We don't add hardware implementations without software counterparts.
> So please prune your list of algorithms according to this rule.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

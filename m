Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED1E3E928D
	for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 16:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774455833; cv=none; b=UABUE0G4Ac5ItWJzM7Xfg9cmaudE8E2o7toE9xIyQJyATJ9JGGVH07eL/CoRlNhI1Ygfv54wIJSyz+QhCjFB/elfIoUO87zbHqpLki3ht2qMXcRVb9KK+8wpmL9Fkt2jEnry4N4XA458aMKm9ix7Fyy0cNZctOHEnMrkUIVIOXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774455833; c=relaxed/simple;
	bh=nO86jVfdQ63Cy3MQ5IB90yb3gxkkrH+dYp7vjBgXzjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U/5+OP0F8tKDihTxEY6LTbuEa2/zt2YmaMmKVWAfbe+PzdRmT9CeFAQVNqqNVNsgglgFHuM8O9tSe1720i3OoH8bF/xTm93w2VfUBSMWQ06MOi54UdcX6v0W4XMi+iaHsA7trBMWFWKacvJMQUMcWlcZSA9Ny2ds+FdFCcFAVVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dErEMNCQ; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dErEMNCQ"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b980785a0bfso389079966b.3
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774455829; x=1775060629; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xqRumgqylqhdvOolgAnZpUvCcbCRYsHI+2vuXt4pFJ0=;
        b=dErEMNCQ480Bb/YNjqWnZfDSV6befDLBk4n1ho9rlQbBuluDQ0Yue7+3RnpFnd9KIF
         lC0VZRrf0QRu2l9SLiAJzuAyYx5lmYv+XLBj71Tqo1DQ/5UFjvF7B7QTx3gIQiCCfTNl
         nrqrfsdUDXVEFHSMCebHj9EbkjmHVDMlXBTdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774455829; x=1775060629;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqRumgqylqhdvOolgAnZpUvCcbCRYsHI+2vuXt4pFJ0=;
        b=myFAh34L06k82uRP6HyZAC1wqeFnrJNAAIwY+iOBT6xaabdwwXnT5jsU3ZAjGGnIsI
         LnXJaHzCmCQ3zBwG1z4Yv5Z58udGutIcU7B2/OUjIwpJgD2hViBur2UOUeAzHAchAeie
         nHlu758IHsntHg2vH/a4gvuH7CO53wPPo9r2SPOosZ9Oxn4VAVYW5AG+zyBE78sRNkMf
         qcuwQDaj6+SW2tvAIcOakNdqRNGVTF9I6PW4GeVKH9aJiNHd38zlr4Om4mUX7YmkWfs5
         9JZY8v1LZ2DKgadW8uE3SoGQz2XQhFVMt3/cs4n0C6MOr34pCpa2makfhYireGy5d237
         JsKA==
X-Gm-Message-State: AOJu0YwGr8eBw3nq1WRYZ0Vae/vZspJjXDMo25+m+IBxm9992dsWb5GN
	nl9crgLOutQoe2w6E9snTk5MH4pIkU3GzRr9ob3Q8PUhYfMHvLoP6AjgCSg7bCSiE2t5JMAf7Vl
	u5+CkrLg=
X-Gm-Gg: ATEYQzw5SL3xUbRVHw/RWo29itMgZYgfWLd2O8giR3rPGG0xuNuhFiKSRbEOVYEPvN7
	gTEIfd7hZceqOJafjDPpZAK8RjUuZuvlXDkIohyQBwzJ0JEatLYDq6Kwkvs8yNwqzEtMHjRRG0a
	bSMCkdwIcNEahXqs2eCk40b7qWUVvi0BSj0AQi3ymc1SZsMyU1oa7JvVU8W+xWWDh41lX+e97q1
	dWuOtnVhFSRcpAFYyhq2mHR2oK4/S3mCPsGe8y5bthAfGgE5mM859tI7K7zuX3zRxQB+iib9zAR
	5H1ah95TrTZLCOGyu4Qvj6Jffc1CPIHlUkBfedmYVjxr1XJi3Yneb4Dp9P91B0h6tnH+NkQXNUA
	q+xQoMsznOnKsXvA6Uo/URlq/eXG4gm4Bh53LS7rqtoBuJVe06hqTfFIWx69KcKM4s7O21o/zq2
	9yo/D5XtPQV5RIB2spcp2mkk3iL31QsoXTfxL4iMxw6wGybmHmsaf4UaG6Nry4QVKLzQ6+4Gw=
X-Received: by 2002:a17:906:f5a2:b0:b97:c719:14d4 with SMTP id a640c23a62f3a-b9a542527f8mr277233466b.29.1774455829516;
        Wed, 25 Mar 2026 09:23:49 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b202192desm6900366b.2.2026.03.25.09.23.48
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 09:23:49 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-661d20c9787so3964154a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 09:23:48 -0700 (PDT)
X-Received: by 2002:a05:6402:52c7:b0:66a:5c2:51cc with SMTP id
 4fb4d7f45d1cf-66a82618054mr2725783a12.4.1774455828155; Wed, 25 Mar 2026
 09:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
In-Reply-To: <acOpDrnN3cVfiASk@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 25 Mar 2026 09:23:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiEzzo=LQ4TasUqFDkSYYAXa3VT6PvLx+AS8asOEA6hng@mail.gmail.com>
X-Gm-Features: AQROBzCvobMTeSr66Doog6JxPYO6sueQRqpfgG5bNFV_fR0cItaL4yWoGy3wQ-4
Message-ID: <CAHk-=wiEzzo=LQ4TasUqFDkSYYAXa3VT6PvLx+AS8asOEA6hng@mail.gmail.com>
Subject: Re: [PATCH] crypto: authencesn - Copy high sequence number from src
 after out-of-place decryption
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Taeyang Lee <0wn@theori.io>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net, 
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Mar 2026 at 02:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
>         /* Move high-order bits of sequence number back. */
> -       scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
> -       scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
> -       scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
> +       if (req->src == dst) {
> +               scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
> +               scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
> +               scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
> +       } else
> +               memcpy_sglist(dst, req->src, 8);

Side note: can we please just get rid of the horrid
scatterwalk_map_and_copy() when making changes to code?

That function is disgusting. It's really hard to see which direction it copies.

At least with memcpy_to/from_sglist() the function name and the order
of the arguments gives a better hint of what the code is trying to do.

This code is all very hard to read even _without_ the code being
intentionally obfuscated with that horrid interface.

                  Linus

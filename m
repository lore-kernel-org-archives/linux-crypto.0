Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE4283FD8
	for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758018094; cv=none; b=qaBtOYvagzMKOiXndeWt63VGHL39tC94kXttvOuCyri3nvCfLIQx2gpASe7qNWxGrtZ+idC4ou9jSN/VajIgKEZJQsqDIPT56m9c2cgabsrK1DcioellVkuorjC2m97fSLeyzGre3+4fqdeqQ4b8q5XriesEALo0esrLfbuuXYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758018094; c=relaxed/simple;
	bh=+pHfAIinNV2odKqBFFjt35fFvhndrYbaBa5T8z2tI5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ChPUKYJynnzICi7M4SpxDBhpKD+/JkCiLLSi2z6xC/h5krNmN7XpJjZ4oHe2toz5CaeG32umJ0Pyh47lIbhIIq0w14hKbZVzd1p7aNEBeb7q7/eyTiD/A7alBYkjHYwlhP+nhmMsjQeqR/zRd1FWKCHmqc4QU9ZyNoATfAj8L/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=NeIIJPvd; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="NeIIJPvd"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55f7b6e4145so5700041e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2025 03:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1758018090; x=1758622890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Re0vwBhFoYzxGBDIw019v96czr5mGdxB5qY8UUQnmFA=;
        b=NeIIJPvdRwBDzTNRbp5+M8urTZCthFRR/Lwqd/XQ9kRzI7bM2bEyq4NEhcaY+7vuZY
         nCqersycL14wCUpndQ1T0HSoJMJhWa/rMK8g438jAbQjCrNuPgx/omU+iaP4o90Hqks1
         tGUQORUyF6gRngUkxFnmufECBSAyO9K1i6DydvBKr7ru6vo4n9C0gMzxZrSjQk8lb+KD
         yjMEzS1Qy51R8Bc9ouYornlDaoaH7/SufVgDYg13gPAWKpOfAvV6hL93s6f4a37KEV1F
         8xZqfUTxvH/+7BLeVfb0EBnpl1UQtLZJ9wQ43CCA6Qf7p33924obgvDV5hSzYI+rri4Y
         rLNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758018090; x=1758622890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Re0vwBhFoYzxGBDIw019v96czr5mGdxB5qY8UUQnmFA=;
        b=qyjRMwez/+aQuvrc/K9mzEaZ5BOoFt8Sj9+0GXFonnx3uhu9VWjfWJ7R1/g1XkLw+z
         uAHcOpCe7eU2U7fPHqMPSHXIZDfdA2+KgeC7cBVmGWoIkgqiuVqugsGR7t/vd8y4E5Pi
         OA/W7W2O4Mo1HBotV47wCPSnUM641dzUVAGfpq3sQdBLNb3fHFRmO8tRY/L4wpR+vrAj
         9gfIF4E+ehIjblBHIF1XfwmVgJqPrZTLKMav3CnduyvirMJ4+PUMpk8WaqGvNXSMerVY
         I9qC0vcVNN9dY9yEuTwdqkFtBzgYHV3bj5e/ALdTnPuhgwuaffe759wmsrH+AO5owgIv
         QyyQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY/BWNA1ZRC3AKiVB7mvlKpBm0H3w41hMtae+0vNSxH2NbEtjTbIlusYsEd27H7+yJ1u2pIOXGEmHHY7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLWD/weQvVD1M0lqUOBT3IauEO92UldD26hftgiZPH+Kp6x6kp
	pmy9UOI1uBGaBr7783KdipLT9KOJz28SWbdpKTLpJSg5Blgs/d7JuaTXIzvCUDKlQPYgKJs5BPa
	8YTHH+sm3hSHtGF9ok2wVaF9xIRlnE//OUkdPc1RGUQ==
X-Gm-Gg: ASbGnctzPt12RziNmR7xJpzEzx5k3A9CsSpv2Qbfg38oLulICvP+klukDcxR+JEyYBi
	oA6h2+DYAdWtrYHEApWUYo4C7BMyRnq812F6GizvSXhH4AEj7B2H5+hWAX0d/wf31DD1hhsKehP
	fWyapgY2kWgG2PVhGwx5+hGSxwUxyEw2BxIfMltdv2i3NWpCyjrFVM8CdRPhThfnznT85WCz8+L
	gwtCqe0Ud/u8fFxA0L54Bs=
X-Google-Smtp-Source: AGHT+IHx4EFlvcoVm7IMS1KvyL2kcDkAM0OviNxHR5HnisZyh1I5tiFqYMpL8ereFr3MwguOvUPsE04E9UaKNDFFdWE=
X-Received: by 2002:a05:6512:4381:b0:571:ed63:2efa with SMTP id
 2adb3069b0e04-571ed63315emr3282580e87.19.1758018090344; Tue, 16 Sep 2025
 03:21:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915084039.2848952-1-giometti@enneenne.com>
 <20250915145059.GC1993@quark> <87f17424-b50e-45a0-aefa-b1c7a996c36c@enneenne.com>
 <aMjjPV21x2M_Joi1@gondor.apana.org.au> <fc1459db-2ce7-4e99-9f5b-e8ebd599f5bc@enneenne.com>
In-Reply-To: <fc1459db-2ce7-4e99-9f5b-e8ebd599f5bc@enneenne.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 16 Sep 2025 11:21:19 +0100
X-Gm-Features: AS18NWAFt1NkpGOxkt8CegfptpF0EMO4UxObNAn5Ipr_oFC3pDr1b8wfuP2uwPo
Message-ID: <CALrw=nEadhZVifwy-SrFdEcrjrBxufVpTr0BSnnCJOODioE1WA@mail.gmail.com>
Subject: Re: [V1 0/4] User API for KPP
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@kernel.org>, 
	linux-crypto@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 9:22=E2=80=AFAM Rodolfo Giometti <giometti@enneenne=
.com> wrote:
>
> On 16/09/25 06:10, Herbert Xu wrote:
> > On Mon, Sep 15, 2025 at 05:47:56PM +0200, Rodolfo Giometti wrote:
> >>
> >> The main purpose of using this implementation is to be able to use the
> >> kernel's trusted keys as private keys. Trusted keys are protected by a=
 TPM
> >> or other hardware device, and being able to generate private keys that=
 can
> >> only be (de)encapsulated within them is (IMHO) a very useful and secur=
e
> >> mechanism for storing a private key.
> >
> > If the issue is key management then you should be working with
> > David Howell on creating an interface that sits on top of the
> > keyring subsystem.
> >
> > The Crypto API doesn't care about keys.
>
> No, the problem concerns the use of the Linux keyring (specifically, trus=
ted
> keys and other hardware-managed keys) with cryptographic algorithms.
>
>  From a security standpoint, AF_ALG and keyctl's trusted keys are a perfe=
ct
> match to manage secure encryption and decryption, so why not do the same =
with
> KPP operations (or other cryptographic operations)?

I generally find the AF_ALG API ugly to use, but I can see the use
case for symmetric algorithms, where one needs to encrypt/decrypt a
large stream in chunks. For asymmetric operations, like signing and
KPP it doesn't make much sense to go through the socket API. In fact
we already have an established interface through keyctl(2).

Now, in my opinion, the fundamental problem here is that we want to
use trusted keys as asymmetric keys, where currently they are just
binary blobs from a kernel perspective (so suitable only for symmetric
use). So instead of the AF_ALG extension we need a way to "cast" a
trusted key to an asymmetric key and once it is "cast" (or type
changed somehow) - we can use the established keyring interfaces both
for signatures and KPP. For example, what if we somehow extend the
add_key(2)/request_key(2) syscalls to be able to initialise an
asymmetric key from a trusted key payload instead of providing the
payload directly via a buffer (similar to how
ALG_SET_KEY_BY_KEY_SERIAL does it for symmetric keys for socket crypto
API)?

Ignat

> I know there might be issues with allowing user space to use this interfa=
ce, but:
>
> 1) I think this mechanism can get its best when implemented in hardware, =
and
>
> 2) (hey!) we're developers who know what they're doing! :)
>
> This patch series is just a sample of the improvements I'd like to make o=
n this
> front. Please tell me if you don't intend to add these mechanisms to the =
kernel
> at all, or if I have any chances, so I can decide whether to proceed or s=
top here.
>
> Ciao,
>
> Rodolfo
>
> --
> GNU/Linux Solutions                  e-mail: giometti@enneenne.com
> Linux Device Driver                          giometti@linux.it
> Embedded Systems                     phone:  +39 349 2432127
> UNIX programming

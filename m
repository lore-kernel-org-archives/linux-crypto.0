Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF12E148850
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 00:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777334428; cv=pass; b=KYq9NVsaiJ6feaq6JcG6qjoJ9048jLkH4InDm3oPxg1sk9kkMr1nfjXf7AE6QVGtdK2MKMYT/AUOWHN4SNLzPtgkVgdw9VSVCYSo6PTcx9aVw91z/HOm9aJUKBWVCqCvCwJnVrQpnOK3wMsDBn//Lk1NY4TJakPzbwwPBmri6DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777334428; c=relaxed/simple;
	bh=kY8ajUarq8aP3iReXTwYvnLU3kEyZk0lXPgo6J91jK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B1mw+kHk8lQrB506E3n0upON0r18OnO7ENAOQONLPu6lenQY9Rj1mMizC32yc9ga7OL84XA67kN+z9yrGQqhhOy+yPWZihTI3pVRDdBhAN2uE33S5rjLBTt4RdX+CXY1SPzt31QGFViVf2Ljlg6Rw+iPc59svXD5SPxc6XcBcH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VkVLTmnF; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkVLTmnF"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2d8fa0fadfeso5918402eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 17:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777334426; cv=none;
        d=google.com; s=arc-20240605;
        b=K1yo/IbNDCbUFNV3pV4pE2Efpk1KpHtklFJ9uo4U7YdCcLT0AJ3czK+hkOL/1u/Dpl
         kJrh98Vc9gOlBsE+ubLgo30Akk6soZSuVw0UMZTyz998GRhuqzviMGzu1uP/r6oJvIQU
         v4QBDC/tyweFx/xEp4r5x4vAn6caZhHh93DwA8HnqhkQPG9Az2H01pyG0yw//jF8B0gq
         IlKpQSqrGnbcb7jyIs7iDX8kooafFCwD6AhA1jAws5hiZ1qndzkKomBbbVkzE0yQsfxo
         QFSAryv8oDZwA/X3MuOCc1TPH8eHQptxWWAlGFklvJ3sFaEoRxFMsI8iOTJywfcWs6JN
         6ltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KoA5YJGTIVDehubXJpZZlLbfoOKtW7Qf8V5dW+bI5v4=;
        fh=Cwak02MppaK43FYSgYw16B7tknmE03mxB1wmQnH0vus=;
        b=Nb1lSuauvO8kG5BPVoOgIWURV9ekHWfTTDTrK057KGlvYf/3raPyomSDcRQrCU87Df
         3uYMbmQ0C5dfYUO4Hs7MsYaX9DI4HQJ/PI8QIpWTTiN+jK5lim3YmyKrlz/NB5LEk0r9
         KDwn/M5M/p0ltvatj3duDFWsGASRauqy/IYHaqaEairer7NnMVoqeySMNorfnAhkDJZc
         yai5e0oAYo85Q2V9gf2NqMrJQPhahpOlG9CEEFXEMPUBrxjX3Dj9IHo/PFR6Mq4Y9zzh
         ZuMsCtWe6Zn2+wT4MbaueZlfKSOdG5bEacE3mMpTC7I/jAvU9rSKN0Kyhe3C75Na/QyW
         rfbA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777334426; x=1777939226; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KoA5YJGTIVDehubXJpZZlLbfoOKtW7Qf8V5dW+bI5v4=;
        b=VkVLTmnFCSXDkZqlKZr9dOof2hAtSdLkg8ZToV3fvjz0uhizTlj2SgSkcTmRbLGD7x
         xAdzYguU7s8MrXOnG7H6wAiERNUpV3FM7StWuI1h4OwedpLi2c34li55wUmXQbiF+uWg
         d1EiHHrdyDHI2ezjJn+RntpMrqQKSFNe7yLTOpe3GKuvr0af3AdldNMktlGtVIk2EMQ6
         3zuGCqpEvezHGXzUPd8lQydK87idLP09ykZuDdIgyPtbydNbWboCGDduIlgYOWhr0Ocu
         vS4fc9/GlamUqpjiGrjqTA+vaX1bsICTEdHsP2t0X5ff/ZMjismzzZfJ2csokAJ7dKrR
         PXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777334426; x=1777939226;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KoA5YJGTIVDehubXJpZZlLbfoOKtW7Qf8V5dW+bI5v4=;
        b=bD3tbIbsDh5s218m5YifOxmVmRXNopKp5XLQ6K3br8dMVtQ7fJ7qElXXKNtpdPbVQ9
         kYvLHsnz4DKg3avvP8tH6qLu7zDXEPn0Kh0bRpqiXcZJlmicGeNFXn/Ybg5VL3Gf9NMj
         q6kTFiyn2R9xZT0a+e3XrbVPprC3RFs0Aa1oe8DenEHLqBJ/lsJ8eMnnT1QpKbRd+Dqb
         pJh9KsLxKm45MSZNCR093R6rgoHEaNezIuvK47Ec0gBuSkC6zfJrJjVAhohjuNIYmGeW
         JitB9TyfN8t+CLJt/QErHwD/Pwf2WhlB7QWYimV3HU0EZjhJYr05OJWRLQ6u1Ko++za0
         IipA==
X-Forwarded-Encrypted: i=1; AFNElJ8tE3Q8d/DrUoX72CtvislFncBWsMAzJSoSoIz9IVJGr6XgB6GsBc2unhQPqiHQH7lNy4ibULFrYFRhbaw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg1EvwXuhfxIc8w8Pywu5bw2cpb/e+rDsAhsA7bDYoAvHmg/fq
	yZPHlNsqzgNgKeSNPhzQN5HJENV3KWjdMogEq7dCG7y29HvlkjZcmv3TTVicltwNf9g+wvCP++a
	wDHYdSKMkSp3yYceF6sY9/R88jwTf23A=
X-Gm-Gg: AeBDietld+sKaAfuJo6zJhpRScX4p1/vvJI/LmxZBU9vEkuHekn0anJWiZXn9S6gooZ
	b3cpPA6Ns7WJZH0aT29yA5Lhah9X8juaGstevV0aBMMlZjbZObRRvYjFAETs0dPnlxhgzi5b8ie
	MXP/6hE0aKNJvmsa6kcKyz2dVJZBRJ8Sm+pKg3e4wyou4oXzplqSpOGsxGWhaT1xQSjfxrEaC4p
	14SiaIicRRhczC+lUbf2ymFTQxpY1FdfAvn2l7e/YhqRe3G/++7rzsEc16LBN+4L9nX3hqMEQIz
	4S9DMH3c8LU5gBabmMISkm6hbDWr28QYjlIV2JSwTDReWhWjqmhnr0wxogtf44/9W2swDWU/Cj3
	Fq6YuY0PBB5Kw9qMrUtL1mEnJmO0jS/k=
X-Received: by 2002:a05:7301:3fa6:b0:2d9:db50:c6ce with SMTP id
 5a478bee46e88-2ed0e2e56a6mr29805eec.3.1777334421260; Mon, 27 Apr 2026
 17:00:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427172727.9310-1-ebiggers@kernel.org> <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
 <20260427155538.2e1b8488@kernel.org>
In-Reply-To: <20260427155538.2e1b8488@kernel.org>
From: Dmitry Safonov <0x7f454c46@gmail.com>
Date: Tue, 28 Apr 2026 01:00:10 +0100
X-Gm-Features: AVHnY4IU52sIs7A9BJsD-ykwxp7flhe6McSxaUZIV17UJdFUfYdDqRdscJZ2HIk
Message-ID: <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 23:55, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 27 Apr 2026 20:09:05 +0100 Dmitry Safonov wrote:
> > I do like these numbers quite much! Yet, as I mentioned in version 1,
> > removing a fallback for other algorithms' support does not sound good
> > to me. There are two reasons:
> > - Ronald P. Bonica (the original RFC5925 author), together with Tony
> > Li do have an active RFC draft to support the additional algorithms
> > [1], potentially in addition to TCP Extended Options [2]
> > - There is at least one open-source BGP implementation (BIRD) that
> > allows using the algorithms that you are removing [3]. Without a
> > deprecation period and communication with at least known open source
> > users, it implies intentionally breaking them, which I can't agree
> > with.
> >
> > I don't feel like Naking as we don't have any customers using anything
> > other than the 3 algorithms above (and BGP implementation is
> > [unfortunately] closed-source, so that would not feel appropriate even
> > if we had such customers), yet I do feel like it's worth and
> > appropriate to express my thoughts/concerns.
>
> What do you want to happen? You are the maintainer of this code,
> you don't get so say "i don't want to nack it but also no" :)

Yeah, that's not what I meant. I see value in Eric's contribution, and
I like getting rid of tcp-sigpool. So, anything but "nack" is not "no"
:-)

> Like Eric says if there are no real users code can be deleted.
> Adding deprecation warnings upstream is quite slow, IDK if injecting
> deprecation warnings to stable has been discussed..

FWIW, I've written to bird's mailing list inviting them to this
thread; in case if they need other algorithms to be supported,
hopefully that should avoid any breakages on their side.
I'm aware that ciena and fortinet use tcp-ao too, but I'm less
concerned, as they aren't open source.

Thanks,
             Dmitry

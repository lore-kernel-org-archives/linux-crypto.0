Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE583E929C
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777568530; cv=pass; b=mzxW0ES+t9DbGnT6GWkqvZDwMpukdn3gAGeUe9M4+OO1FsIZCswnsHKCQHHKRyxoo+KNdd5SuK6tpBNG2koTxNOf+YsCif4I4Gklb+bsMuZ3hH4prxT2lTf0NQJ1McepyEQXqcnWJQScoq4c+dZeOJLUhrf3UYAUxMSziAInNIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777568530; c=relaxed/simple;
	bh=kdkWT7Lj4mppb7ePDWP0ZDTnqJdUNyj1JX4iVP8CiOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DZBrAPtnPrNeuvr6ypjIY0ExwftPmw1sRgl4e9egRkN0xf3YZO+KZO8aNk4dHcNcZFKcHEaT2mHtJhfZXg0m6yIe04OGj9dDE/jQKap1KjvnTX44u2xD2davELX5ek4aQruDhEotw6Zcsej2ZWq4o6cE58fT00KrEcm4LRpLhg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfQJd0sC; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfQJd0sC"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2ba895adfeaso1493653eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 10:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777568528; cv=none;
        d=google.com; s=arc-20240605;
        b=OVW/+ABF79DuQXgm+s57YrRPxBbQ1kec88ZPweb+aAdxSUZsPzwk5Q/PyY+siMJntQ
         L9WZiH31vf9KQKG18bcH64JjcBnhmniYC+oeHLniX7zJ8misjobcL5by6vSUsnAJAAMM
         /V7sQIsouBEwoLgDOOVL4DPTvxyVGwpZxijxJ2Fq+wGK93pqGEma5bmleGgB4casGvR8
         BZUVqXWwO8drD3q/OBdS2okWGsIIQdlsHXSiP0KKDWKtnr1ok2Lb/m9l0xqbuRgX3AU7
         jf7XlNIs8SwtcjGk5wX4Ty53B4IBGsWpMSBPK/T+5WiRY2rAHDRWuKEPxfPiZAMCl0Zo
         rVrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ysekql4Ul305BpiEGUXKj6pgyfyPE1wDivp5cN89gbM=;
        fh=hAYHOt6+uvUywcXTL6cNkdpqJGKt+p3/gCDmxVpTM18=;
        b=fFzjSQsp7yrHHMEvxFDfEt1eIvGVfTEITp9QwBBM+lpP4oxW3XffLRLq1R7xNmGMZz
         xfVS+olWVkv76Tn8fksVzrftYdbwQUcEhfaEA06WuHL4LJwWJPTDTaEL0LmRN85HMgZD
         27igSySwicLDKks8eZoc0Unl5g2ggkWuUknAswoRy0G/hdcWTI3TmHgpByWFaDMaTZW8
         lyUqvosJ5ugdKBJF2MZQh04DOb7StUQiue8bNrbpyHObFzCbWz1gQmdZfSdhvXIradpl
         RMDZtAQ1p5YIQgRgChd7gya0c07TkFLJ890FC5TFgaaOS0WrgYGzFI0wXNPZh+1aBY6p
         azdw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777568528; x=1778173328; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ysekql4Ul305BpiEGUXKj6pgyfyPE1wDivp5cN89gbM=;
        b=LfQJd0sCylnHBzkUGVjDl9tfbrEIw3KxBl75qZQkzHpaXc6C2gFwozk1l8JmfwrnVN
         JN83oXeJL2Cu8nTx2BzFhrWBHuf6j01HJUQx29gtw7tMfetdoO94K1Jcm+rjK/r375bM
         xoo4oIYtyOeWiPnPRJq5VVPWgWtUBpHP/5KRS3Bbnpyc1hVHOAngsHvldMPJuXNMy999
         m6tveefExDjX6kbYn+LVsm5pqD2zBiNj+D6e+RWjnDaMlK0WkTLr7QtYJJ9hQFlAKpRG
         yfDJM6R6wSnJFHfpU9Pv7XUTa3nlN2pe7GR3GjKHcHeQU/x4cJg61e4CCJX2oBwtUyJ8
         0dBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777568528; x=1778173328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ysekql4Ul305BpiEGUXKj6pgyfyPE1wDivp5cN89gbM=;
        b=ldL1qyXRcPJUF3/xaAsjGqXqxfAXMHbdmWJT+TxYPKt3GaOO631PzPXP2+7F0GtJi7
         Zu2q0PKVCHlMDtdu10zzTBPqUhyfYEK7qIYaKTyawl1tPagLWXpk9dlXIH1aYuZJHEWD
         K3PzDJiMshqjpDqUXD142hbm1STlVKiCEN02LJ6qUltxPtIfRZzxNpCiVwCcrCqSmuIA
         9vXOkEyLInt6d4mky3KH1ylIbeROoXSNlxVe9tP4YE9em/+e8VX8h1kL3+qfkTeeX44V
         avp3nTnco6+Wyngjun4AMU9GqH6Fb5ic/E0XgxBZL+StxNLFmMogP+Z15GVDwC/DRSRr
         Kwaw==
X-Forwarded-Encrypted: i=1; AFNElJ+aH+6bG45c35mmiCpuh5aFAUl1UmbHlSg5Pqtj1rvfGHeHhJYwiq/XBgokgj/lrrKfuB8CgGG7aUF5i6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUS4Lp5r0wQd5FujwNgnkTgEEWZwlgr5Mz0alVISvMIpjOxm01
	njp+gbIXbvmC9+Jy1xAj0t6z00P4GSrqm2h/LXjWPa17j9ARtRvm2jCY77+PyKD8W1psAs1G97G
	CuNuh7MdPkPYvsZhqVNhlP0TWEm34ayI=
X-Gm-Gg: AeBDiesk1K5zFggBx587HJCkNdCb6LAQn+TmwjGB17YWwuxdqvup+RWS5HDM3BuPg4P
	0B9r1TBXNcInXks9YKq6NRQgToMpyRDDLCy6i//eUbekLWCYtOx9H3itOGpcjQuQJYgcZG9g7Ez
	tP29Nv/2zu5AxMMIISQ0K+kXK3LwWZSXo2XFN5chYrbGtwkVTngk1m9E/Nz1/EDaZGgjtOAR0zU
	TW4lsg8GGOnIjTvyYOTHyipehw+8Bthk0caEOgg7zahw0ZR2lw8hUYQJLSzXk4aj1ex+qfNOkMF
	RhXkNp09xAT9lL1bT4EJfOxnyLPX+F3T1JrF9cf89sMsmTuC52PyNGCjiLw/V1NuRaErL+GOecM
	ltLRezUTkhcJ1orcPGZNnfq/6zeBJmn71R0Brf3d5Yqk=
X-Received: by 2002:a05:7300:5411:b0:2d1:e92c:f7ff with SMTP id
 5a478bee46e88-2ed3c5c9e16mr1826579eec.1.1777568527441; Thu, 30 Apr 2026
 10:02:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427172727.9310-1-ebiggers@kernel.org> <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
 <20260427155538.2e1b8488@kernel.org> <CAJwJo6Zh_1V009JSBGwAmR7GWj=2HdG6f=uBxK8krE4B1YrGkA@mail.gmail.com>
 <a642b858-eea0-4b7a-aeb2-aa67c6cf0f64@redhat.com>
In-Reply-To: <a642b858-eea0-4b7a-aeb2-aa67c6cf0f64@redhat.com>
From: Dmitry Safonov <0x7f454c46@gmail.com>
Date: Thu, 30 Apr 2026 18:01:55 +0100
X-Gm-Features: AVHnY4J_afp8At_pOKi9BxqdfNCGc1QYGVwpMxIdJAzdWNmsjbxANmQ8MvQWChE
Message-ID: <CAJwJo6YDJ1h7Ry15BDArx9dQbWMt3xFY28Ecy2rb7HsKi-f-yQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Eric Biggers <ebiggers@kernel.org>, netdev@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Simon Horman <horms@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Apr 2026 at 08:38, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On 4/28/26 2:00 AM, Dmitry Safonov wrote:
[..]
> > Yeah, that's not what I meant. I see value in Eric's contribution, and
> > I like getting rid of tcp-sigpool. So, anything but "nack" is not "no"
> > :-)
>
> I read the above as: "If there isn't any additional feedback soon,
> please apply".

Thanks, Paolo, that's exactly what I meant.

I think we addressed both concerns I had with the new RFC and BIRD
daemon, and Eric did a good job optimising the crypto layer here, so
we are better with his patches than with my sentimental attachment to
extendability that so far is not really required by BGP. And if we
need to extend the list of algorithms, we will be able to do it on top
later.

Thanks again,
             Dmitry

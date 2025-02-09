Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AB27DA82
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739107024; cv=none; b=NUdRawHpqlY0ErmkcncQssLb55UgUolPFwiwW21oOSqWXkT6urYQXfUkXRNlIFWOzt2tcDRO87w7rI/ZqwBoZwPSFK5p7P4Y8icNugclmauE7zMgEsdlRYPGz0UOu6LDIQYtQV5csPCOF3Uk2MBAds7Yc5YWaHWm4OCvSCOSyak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739107024; c=relaxed/simple;
	bh=6xisQHSVs6AKJZzRJl2B7Tep1ymrWUdAcKtZnIjobhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qvv//ri7Wa/lHR/MX4FiW7ko4JcrfxoBS6VSQp7ohTqt5SqEcmxQEPE7Wn6952B5ORFwsPBRwX86WinMNU89Yapg2pKo7EoW1LUzLENHuJ50N9gCzAqcJSbRyn96sI620n3WBq/inFPeRTOpQOJk6cNFRciLmt+HtsD81UY9Dto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=ShL7TjsH; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="ShL7TjsH"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2fa1d9fb990so5025866a91.2
        for <linux-crypto@vger.kernel.org>; Sun, 09 Feb 2025 05:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1739107022; x=1739711822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/0q6Uy3c6A9AJQewjPZhHBDpxyDYOtnZ7qmoIYHB+Y=;
        b=ShL7TjsH9xpdfhty3I0wsUuxFVNPyp4oeWkuzcl4KPVviiJCcfQ7ViQFMqUsL15Odt
         b7ygx0BXH7GOb8frerqaSSIz4UvVTKzs1V9w1Fd18tapiu/bXwKnhTAqN36PVOkqdvzv
         l7cahAKTPTNpOprL70/QEi/3lotbiL7nwwkvQRLbiZJLacRBtOMdXgqgnYHYXJsiJIfs
         7gSQF1bGihMCFO3BXJ+yrj6Nut+Yn9co+xcSkWLW9r1X5ROjG1itYBwz4UGg+OySCxQf
         sxDioRF9fcEoVNWy6jLNLVh9eW5v1jOTuEIqmPEEViUX7OeRGVsOBVG34nKXm/9/lqL6
         snbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739107022; x=1739711822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/0q6Uy3c6A9AJQewjPZhHBDpxyDYOtnZ7qmoIYHB+Y=;
        b=i6S5wgmpvNAYruHjOZgnBNRCHPVF3AheHgs+HLg39Mlnn4BBalVP9doeZmTqiKAs48
         wAyygIPVwmq33XqB9ejiuHFtuJaJqY7bQTnX1dBL07GMGfvGeLjWfq8/6QPHYqZqcBkN
         9DhdGVRw/NB6WWeZp6t20+21OGzZsYldQbrnJZQy8gcfs9B4JqM1iGyBOCYPtwQmA35Y
         HwoC0bNQ2dDTq02zSiRzNbEfEz+ZzpTnlGgciEgDgPS1WPUWP4mr0822d/SbmyZd3uCC
         k8W4rXR6IKhLkblUgaw7U0yHlaQ+NIY95aUTyanpNVv4Ezh2CgeR4whsGkJb1o87+0mq
         fZiw==
X-Forwarded-Encrypted: i=1; AJvYcCWmn83Oj3jfUO4kQoiW15QHbKWXlmTF3J7mxEmhX4v+cn8l6v3qg0J85a1ZAvD27mlD8zcrMDCDUh9K0ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI3hkY6iXbBZH4PUemJfTe9YhQke4D/EwPehwhErnz5VxjdLJr
	A1qPpCFf2qADEfYPnUMuX/fYEbEdE9FasAGCTdrQ/K6E3fuFX84o1vGbMlKEeaB42G5Yxol7XAK
	VOxvkGV4ZJwDTqMrfIt6jrMYg3PhJumwppcqkCQ==
X-Gm-Gg: ASbGncsoRxkzcOJdhTTXZVxVGRuRplwIcG8Z9D+fPbmFo/bAS1fX6QNOCdXroyDwD8X
	V77Z1XytNsaNgwemGV2xb+M10lvQMfq0nI9rdrruSzByO508oijZo+IcnZdwm7m5bcxGBTq+OXN
	TH3ECNkuzuqmosCIbE4l3ezBlLTPTX6g==
X-Google-Smtp-Source: AGHT+IFrys//LwPqEe4ZgEwDr3uizqqJxUMuZeWS4T5vuTlUtXlxEOCX1+ppGlLTBiAIjYGJwhERgjno7Pm5OXUJOAk=
X-Received: by 2002:a17:90b:38c3:b0:2ee:ab29:1482 with SMTP id
 98e67ed59e1d1-2fa24271b9dmr17676607a91.16.1739107021616; Sun, 09 Feb 2025
 05:17:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1738521533.git.lukas@wunner.de> <3d74d6134f4f87a90ebe0a37cb06c6ec144ceef7.1738521533.git.lukas@wunner.de>
 <Z6h8L0D-CBhZUiVR@gondor.apana.org.au> <Z6iRssS26IOjWbfx@wunner.de>
In-Reply-To: <Z6iRssS26IOjWbfx@wunner.de>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Sun, 9 Feb 2025 13:16:50 +0000
X-Gm-Features: AWEUYZl93UXoS8Qs2EeTErAJ5BO1UGgAv0crmqrJhP9OY4-4APU0Swls6MmXuxs
Message-ID: <CALrw=nEyTeP=6QcdEvaeMLZEq_pYB9WO=vFt2K2FuJ1TEmP1Lg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] crypto: ecdsa - Fix enc/dec size reported by KEYCTL_PKEY_QUERY
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Stefan Berger <stefanb@linux.ibm.com>, Vitaly Chikunov <vt@altlinux.org>, 
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org, 
	keyrings@vger.kernel.org, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 9, 2025 at 11:29=E2=80=AFAM Lukas Wunner <lukas@wunner.de> wrot=
e:
>
> On Sun, Feb 09, 2025 at 05:58:07PM +0800, Herbert Xu wrote:
> > On Sun, Feb 02, 2025 at 08:00:53PM +0100, Lukas Wunner wrote:
> > > KEYCTL_PKEY_QUERY system calls for ecdsa keys return the key size as
> > > max_enc_size and max_dec_size, even though such keys cannot be used f=
or
> > > encryption/decryption.  They're exclusively for signature generation =
or
> > > verification.
> > >
> > > Only rsa keys with pkcs1 encoding can also be used for encryption or
> > > decryption.
> > >
> > > Return 0 instead for ecdsa keys (as well as ecrdsa keys).
> >
> > I think we should discuss who is using these user-space APIs
> > before doing any more work on them.  The in-kernel asymmetric
> > crypto code is not safe against side-channel attacks.  As there
> > are no in-kernel users of private-key functionality, we should
> > consider getting rid of private key support completely.
> >
> > As it stands the only user is this user-space API.

Please don't! Keyrings + asymmetric crypto is a great building block
for secure architectures. If anything we want more of this, not less.
We can get rid of various ssh-agents and anything that tries to keep
cryptographic material in a separate address space. It is the most
straightforward way to avoid heartbleed-like vulnerabilities [1].
Before this we had to design whole solutions just to separate private
keys from network facing code [2].

Now, in-kernel RSA implementation is indeed a downside, but again -
one could swap internal implementations and provide their own. We have
an internal BoringSSL-based in-kernel crypto driver (which I hope to
open source one day) which avoids this problem. I remember there was
also some work to expose TPMs through the keyrings API, which would
solve this problem as well [3]. In general this API allows adopting
various platform crypto chips very easily and should be encouraged. I
made a presentation explaining why this API is much better for TPMs,
for example, rather than directly using /dev/tpm from userspace [4].

On the topic of better RSA implementation: last year we've been
working with folks from a company called Cryspen with the hope to
produce better and even formally-verified RSA and ECDSA
implementations for the Linux kernel (based on their HACL open source
library). We got pretty good results [5] for RSA: tl;dr signing is
faster than the current in-kernel code, but verification is slower
(not a problem as we can use verification from the in-kernel
implementation as we don't care about side channels there).
Unfortunately the work was deprioritised this year, but if there is
enough interest from the kernel community (and hopefully support to
make the code more "kernel-integration friendly) I can try to make a
case to re-prioritise this again.

> Personally I am not using this user-space API, so I don't really
> have a dog in this fight.  I just noticed the incorrect output
> for KEYCTL_PKEY_QUERY and thought it might be better if it's fixed.
>
> One user of this API is the Embedded Linux Library, which in turn
> is used by Intel Wireless Daemon:
>
> https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/key.c
> https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/eap-tls.=
c
>
> Basically IWD seems to be invoking the kernel's Key Retention Service for
> EAP authentication.  It's still maintained and known to have active users=
,
> so removing the user-space keyctl ABI would definitely cause breakage.
>
> I've just checked for other reverse dependencies of the "libell0" package
> on Debian, it lists "bluez" and "mptcpd" but looking at their source code
> reveals they're not using the l_key_*() functions, so they would not be
> affected by removal.
>
> There's a keyring package for go, so I suppose there may be go applicatio=
ns
> out there using it:
>
> https://pkg.go.dev/pault.ag/go/keyring
>
> Then there's the keyutils library...
>
> https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git
>
> ...and listing the reverse dependencies for "libkeyutils1" on Debian
> reveals a slew of packages which are using it:
>
>   gdm3 samba-libs sssd-common python3-keyutils nfs-common ndctl
>   mokutil kstart libkrb5-3 kafs-client ima-evm-utils ceph-common
>   libecryptfs1 ecryptfs-utils cifs-utils
>
> And "python3-keyutils" in turn has this reverse dependency:
>
>   udiskie
>
> Finally, folks at cloudflare praised the kernel's Key Retention Service
> and encouraged everyone to use it... :)
>
> https://blog.cloudflare.com/the-linux-kernel-key-retention-service-and-wh=
y-you-should-use-it-in-your-next-application/
>
> In short, it doesn't seem trivial to drop this user-space API.
>
> Thanks,
>
> Lukas

Thanks,
Ignat

[1]: https://heartbleed.com/
[2]: https://blog.cloudflare.com/keyless-ssl-the-nitty-gritty-technical-det=
ails/
[3]: https://lore.kernel.org/lkml/97dd7485-51bf-4e47-83ab-957710fc2182@linu=
x.ibm.com/T/
[4]: https://youtu.be/g8b4K5FQUj8?si=3DyY8mkoRuyE_SKBjh
[5]: https://md.cryspen.com/cf_hacs_kernel

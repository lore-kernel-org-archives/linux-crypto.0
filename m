Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CF3242A9
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 23:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778023054; cv=pass; b=Nx1zoTugMXlOk6Yz/tWAP2bX8pzYGKPyE2IRI7Z6tlE5ENIPB6wlGhBxwXGoJe7fKwnFJfjcwctyfmptpFKLBKPtvuP5vRWOKiMinYyAV9wDTdhy/PNDsPILRPsl7PEdeqIZG+KmuWoKpW9S8k+2uSr/1k7ent1/Yh3JD9qZ7dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778023054; c=relaxed/simple;
	bh=ef/MzUyf7VedQkBFAXuEDwBAG1wJTQuMidX6Kyu4lhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=URWayI6vcZ3yBKX94YqquOqgpfooS1qhlcZTIIXlpYYE8yd4mb+WrVnaNOOmfsUK3JgaHa4tRCDpapnSMzPQtjhuzxnMPHs+2mzv5XeCw1poXJTibQkN40ysCtJzQrJySKC3JaUIkIo7gu90izzjd/olbndpZaq5WefSvDHiZrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=kX/vZv1+; arc=pass smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="kX/vZv1+"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3939d2bd739so25919751fa.0
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 16:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778023050; cv=none;
        d=google.com; s=arc-20240605;
        b=R9BQ4CubyKi1nEXydekYThL1IzcfxBhEzzYn609tsaDRlYeanfksuUybiHNW062EJp
         YZK43Qj4TXUILXqXDKsPofXYJErglICRXeuf2yH+02JiSLwWs6tpQUjdj4elJyaxpqJO
         93jPHqqWSUmpOKBn9S1gHWfK3Tz1IvJpTKHcbE2aXQwjl4dUFF0tDCPxd0FnWN/nPIYf
         gN/yipiPY9DHFK45jY7UkGLIYPi4d8rZCYbZaO4namkV65LaBYmU6O6wbLoHAvjvHjp8
         R236eVHzCebXZ1cQFgOyrkmNJDO+Pbk/JZg+QbSuoHeZWEQpyKQgZOa/nzpsffJREeb9
         Wz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sbkL0dSedhIlHAkm5zLSxKnvc/+dmcs/ZtFP69v5vVk=;
        fh=VFpfdNIxJokOAhXiTYTwKZPlsW4uHQoVAARMVzlNDCw=;
        b=A/X0S6L50uVhm3BGaKbtzTf0+4CJn/gRRXwl8wylaOpFa7680TK4AYAOhTDIggViRr
         Kg3xA5II0LIhA5wyHHB+/MQAy1NNWq65VqXqHTe9w3nriDjszWNl35IEXP2sbittnaFR
         1fuvY0eDpqQEOeReKRQb1G6KjCP2cMHhu7MqyIjWV/kXSlbJeINMMINy4MqvjQwzQhhS
         nQEXUBZW9/6GHcutUgl0C2OV3EyvdXyKbQ+AqXbvVU7lHhIyToaxypa8db2hn8aASBAB
         nQA5dNSBGjR6CPTedZOWPKIzjpWskSw47laJ8Uvvb+/ujm35NdhJxVz5FRZruddPo6P/
         EM/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1778023050; x=1778627850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbkL0dSedhIlHAkm5zLSxKnvc/+dmcs/ZtFP69v5vVk=;
        b=kX/vZv1++mRW0Jk8YjSESDBdJ1f9fMdyxRQh6ebv3Vlc46SZ7IUM5Pvzof3tVKwoNd
         9Q4jXULncEcCUkuU0B8Efc4N4fdsJqYPSPJASOAA+thu84XKOFJxoFT2vUflvZemvpkX
         NGXpD6i/I1lXVKP8dSXxFIupw3CJyezzKs9HGcAzRNfUgW6ys/SVJ5y0E7I3UKJsBn6N
         Y4vECBGoxARmflGfwLdNZfrLAqUs7ZQ3Kmv0RYX1ke9ld9GSNgkyijceU8ZO0lzH7Zcj
         dPwTOjqJEnKWGire/4GpTg7fMtxYsc+aEZU1zOmPKtXP2IdNkLjpDHP8HKk/VmYsHqrQ
         v2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778023050; x=1778627850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sbkL0dSedhIlHAkm5zLSxKnvc/+dmcs/ZtFP69v5vVk=;
        b=pw5MmW+gaVuupv4Vib50zHwy9ZgfIJZ0s6WGOA2Nghhd+Gr9V39jG+VXXWXFvytXD5
         fWk5/BvFptuw2RqTdU7ggsAQRFbuf5yKFssZCEV6S7TZP4Uid0q5QObk8LTV9CA5oaaR
         Ii1UKSCluF+yNx4xLdxCYosnKTPPbNdp9MWWI21DfouBbDktveDr35E111k8nNdvok0n
         k3UNaREHryp9JtA8gGWlJc+ujR6CR8DU7gp9b4ppNn4EsjhAV4azinNMdPU2qun/Efpj
         c5VdqSsM2KZZkW7g1tJkWpJFKpFF7NEMJnIeY+o3Rx5zPulPOgFW2/3pFWhdC3xnnKvc
         stYA==
X-Gm-Message-State: AOJu0YyMPVhD9qdrOgZAcI6CwTErNPVygTjgcWe5yBSjD+cP/TaJbW2i
	WEDCkD0bSiLoOZZjbAqYCpZ48ebPknn6wKPe+HPbXXf1Pz3J1LJT739rpmnAV/TO5N1+za1+2Ti
	dFt4C0rBw013u5+tg1hnNusfo4olcwEQFs46/fW4A
X-Gm-Gg: AeBDieso7fgErTemUOFV07ynboTc3OcwHLyHeYyspMadfBIMeBknAai1XaX/Yfr8bnb
	gBK8d9yC+xm7Tv2LMqrth24Ulx67uV0Kz4yBMNweCXu8eFSf41eP/QBmaPTPyfW9FgjvL4VONUV
	2UPHb1w328xziCQVf1ACes1PK2XEyF61+pSEkn+Ix4lHjzD6F2jcpxIKe1lO839yC08OiK9QtAR
	h88RcjF8QCTmFIkX/X4ymZq8Eo6kCJikV9fKXtRHtMZKommkQ/iISfLSZxScc2bIeuB40Vx3fv9
	14o9coMb+WyzjcoFzHoCuUGwSelSgV/aUlRbIRiyZdOddTrG7A==
X-Received: by 2002:a05:6512:3e1e:b0:5a8:6383:eb1d with SMTP id
 2adb3069b0e04-5a887a9a1f8mr255421e87.0.1778023050325; Tue, 05 May 2026
 16:17:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430011544.31823-1-ebiggers@kernel.org>
In-Reply-To: <20260430011544.31823-1-ebiggers@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 5 May 2026 16:17:18 -0700
X-Gm-Features: AVHnY4LKSVkLgCr9Vwa8gK1KVDGqtIFkDawKs1AD3wzCIeuai4aVYTh3ZhWd8CA
Message-ID: <CALCETrVqG+1yErRJjkxvJrf=A+Vu84HTR4Bx1Pcd8G1C0PJcMA@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-doc@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On Apr 29, 2026, at 6:19=E2=80=AFPM, Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> =EF=BB=BFAF_ALG is almost completely unnecessary, and it exposes a massiv=
e attack
> surface that hasn't been standing up to modern vulnerability discovery
> tools.  The latest one even has its own website, providing a small
> Python script that reliably roots most Linux distros: https://copy.fail/

How about adding a configuration option, defaulted on, that requires
capable(CAP_SYS_ADMIN) to create the socket (and maybe also to bind /
connect it).  And a sysctl to allow the administrator to override this
in the unlikely event that it=E2=80=99s needed.

IIRC cryptsetup used to and maybe even still does require these
sockets sometimes and this would let it keep working.  And there's all
the FIPS stuff downthread.


>
> This isn't sustainable, especially as LLMs have accelerated the rate the
> vulnerabilities are coming in.  The effort that is being put into this
> thing is vastly disproportional to the few programs that actually use
> it, and those programs would be better served by userspace code anyway.
>
> These issues have been noted in many mailing list discussions already.
> But until now they haven't been reflected in the documentation or
> kconfig menu itself, and the vulnerabilities are still coming in.
>
> Let's go ahead and document the deprecation.
>
> This isn't intended to change anything overnight.  After all, most Linux
> distros won't be able to disable the kconfig options quite yet, mainly
> because of iwd.  But this should create a bit more impetus for these
> userspace programs to be fixed, and the documentation update should also
> help prevent more users from appearing.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting crypto/master
>
> Documentation/crypto/userspace-if.rst | 82 ++++++++++++++++++++-------
> crypto/Kconfig                        | 69 ++++++++++++++++------
> 2 files changed, 113 insertions(+), 38 deletions(-)
>
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto=
/userspace-if.rst
> index 021759198fe7..c39f5c79a5b7 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -2,30 +2,72 @@ User Space Interface
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Introduction
> ------------
>
> -The concepts of the kernel crypto API visible to kernel space is fully
> -applicable to the user space interface as well. Therefore, the kernel
> -crypto API high level discussion for the in-kernel use cases applies
> -here as well.
> -
> -The major difference, however, is that user space can only act as a
> -consumer and never as a provider of a transformation or cipher
> -algorithm.
> -
> -The following covers the user space interface exported by the kernel
> -crypto API. A working example of this description is libkcapi that can
> -be obtained from [1]. That library can be used by user space
> -applications that require cryptographic services from the kernel.
> -
> -Some details of the in-kernel kernel crypto API aspects do not apply to
> -user space, however. This includes the difference between synchronous
> -and asynchronous invocations. The user space API call is fully
> -synchronous.
> -
> -[1] https://www.chronox.de/libkcapi/index.html
> +AF_ALG provides unprivileged userspace programs access to arbitrary hash=
,
> +symmetric cipher, AEAD, and RNG algorithms that are implemented in kerne=
l-mode
> +code.
> +
> +AF_ALG is insecure and is deprecated. Originally added to the kernel in =
2010,
> +most kernel developers now consider it to be a mistake.
> +
> +AF_ALG continues to be supported only for backwards compatibility. On sy=
stems
> +where no programs using AF_ALG remain, the support for it should be disa=
bled by
> +disabling ``CONFIG_CRYPTO_USER_API_*``.
> +
> +Deprecation
> +-----------
> +
> +AF_ALG was originally intended to provide userspace programs access to c=
rypto
> +accelerators that they wouldn't otherwise have access to.
> +
> +However, that capability turned out to not be useful on very many system=
s. More
> +significantly, the actual implementation exposes a vastly greater amount=
 of
> +functionality than that. It actually provides access to all software alg=
orithms.
> +
> +This includes arbitrary compositions of different algorithms created via=
 a
> +complex template system, as well as algorithms that only make sense as i=
nternal
> +implementation details of other algorithms. It also includes full zero-c=
opy
> +support, which is difficult for the kernel to implement securely.
> +
> +Ultimately, these algorithms are just math computations. They use the sa=
me
> +instructions that userspace programs already have access to, just access=
ed in a
> +much more convoluted and less efficient way.
> +
> +Indeed, userspace code is nearly always what is being used anyway. These=
 same
> +algorithms are widely implemented in userspace crypto libraries.
> +
> +Meanwhile, AF_ALG hasn't been withstanding modern vulnerability discover=
y tools
> +such as syzbot and large language models. It receives a steady stream of=
 CVEs.
> +Some of the examples include:
> +
> +- CVE-2026-31677
> +- CVE-2026-31431 (https://copy.fail)
> +- CVE-2025-38079
> +- CVE-2025-37808
> +- CVE-2024-26824
> +- CVE-2022-48781
> +- CVE-2019-8912
> +- CVE-2018-14619
> +- CVE-2017-18075
> +- CVE-2017-17806
> +- CVE-2017-17805
> +- CVE-2016-10147
> +- CVE-2015-8970
> +- CVE-2015-3331
> +- CVE-2014-9644
> +- CVE-2013-7421
> +- CVE-2011-4081
> +
> +It is recommended that, whenever possible, userspace programs be migrate=
d to
> +userspace crypto code (which again, is what is normally used anyway) and
> +``CONFIG_CRYPTO_USER_API_*`` be disabled.  On systems that use SELinux, =
SELinux
> +can also be used to restrict the use of AF_ALG to trusted programs.
> +
> +The remainder of this documentation provides the historical documentatio=
n for
> +the deprecated AF_ALG interface.
>
> User Space API General Remarks
> ------------------------------
>
> The kernel crypto API is accessible from user space. Currently, the
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 103d1f58cb7c..6cd1c478d4be 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1278,48 +1278,72 @@ config CRYPTO_DF80090A
>    tristate
>    select CRYPTO_AES
>    select CRYPTO_CTR
>
> endmenu
> -menu "Userspace interface"
> +menu "Userspace interface (deprecated)"
>
> config CRYPTO_USER_API
>    tristate
>
> config CRYPTO_USER_API_HASH
> -    tristate "Hash algorithms"
> +    tristate "Hash algorithms (deprecated)"
>    depends on NET
>    select CRYPTO_HASH
>    select CRYPTO_USER_API
>    help
> -      Enable the userspace interface for hash algorithms.
> +      Enable the AF_ALG userspace interface for hash algorithms.  This
> +      provides unprivileged userspace programs access to arbitrary hash
> +      algorithms implemented in the kernel's privileged execution contex=
t.
>
> -      See Documentation/crypto/userspace-if.rst and
> -      https://www.chronox.de/libkcapi/html/index.html
> +      This interface is deprecated and is supported only for backwards
> +      compatibility.  It regularly has vulnerabilities, and the capabili=
ties
> +      it provides are redundant with userspace crypto libraries.
> +
> +      Enable this only if needed for support for a program that hasn't y=
et
> +      been converted to userspace crypto, for example iwd.
> +
> +      See also Documentation/crypto/userspace-if.rst
>
> config CRYPTO_USER_API_SKCIPHER
> -    tristate "Symmetric key cipher algorithms"
> +    tristate "Symmetric key cipher algorithms (deprecated)"
>    depends on NET
>    select CRYPTO_SKCIPHER
>    select CRYPTO_USER_API
>    help
> -      Enable the userspace interface for symmetric key cipher algorithms=
.
> +      Enable the AF_ALG userspace interface for symmetric key algorithms=
.
> +      This provides unprivileged userspace programs access to arbitrary
> +      symmetric key algorithms implemented in the kernel's privileged
> +      execution context.
> +
> +      This interface is deprecated and is supported only for backwards
> +      compatibility.  It regularly has vulnerabilities, and the capabili=
ties
> +      it provides are redundant with userspace crypto libraries.
> +
> +      Enable this only if needed for support for a program that hasn't y=
et
> +      been converted to userspace crypto, for example iwd, or cryptsetup
> +      with certain algorithms.
>
> -      See Documentation/crypto/userspace-if.rst and
> -      https://www.chronox.de/libkcapi/html/index.html
> +      See also Documentation/crypto/userspace-if.rst
>
> config CRYPTO_USER_API_RNG
> -    tristate "RNG (random number generator) algorithms"
> +    tristate "Random number generation algorithms (deprecated)"
>    depends on NET
>    select CRYPTO_RNG
>    select CRYPTO_USER_API
>    help
> -      Enable the userspace interface for RNG (random number generator)
> -      algorithms.
> +      Enable the AF_ALG userspace interface for random number generation
> +      (RNG) algorithms.  This provides unprivileged userspace programs
> +      access to arbitrary RNG algorithms implemented in the kernel's
> +      privileged execution context.
>
> -      See Documentation/crypto/userspace-if.rst and
> -      https://www.chronox.de/libkcapi/html/index.html
> +      This interface is deprecated and is supported only for backwards
> +      compatibility.  It regularly has vulnerabilities, and the capabili=
ties
> +      it provides are redundant with userspace crypto libraries as well =
as
> +      the normal kernel RNG (e.g., /dev/urandom and getrandom(2)).
> +
> +      See also Documentation/crypto/userspace-if.rst
>
> config CRYPTO_USER_API_RNG_CAVP
>    bool "Enable CAVP testing of DRBG"
>    depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
>    help
> @@ -1330,20 +1354,29 @@ config CRYPTO_USER_API_RNG_CAVP
>
>      This should only be enabled for CAVP testing. You should say
>      no unless you know what this is.
>
> config CRYPTO_USER_API_AEAD
> -    tristate "AEAD cipher algorithms"
> +    tristate "AEAD cipher algorithms (deprecated)"
>    depends on NET
>    select CRYPTO_AEAD
>    select CRYPTO_SKCIPHER
>    select CRYPTO_USER_API
>    help
> -      Enable the userspace interface for AEAD cipher algorithms.
> +      Enable the AF_ALG userspace interface for authenticated encryption
> +      with associated data (AEAD) algorithms.  This provides unprivilege=
d
> +      userspace programs access to arbitrary AEAD algorithms implemented=
 in
> +      the kernel's privileged execution context.
> +
> +      This interface is deprecated and is supported only for backwards
> +      compatibility.  It regularly has vulnerabilities, and the capabili=
ties
> +      it provides are redundant with userspace crypto libraries.
> +
> +      Enable this only if needed for support for a program that hasn't y=
et
> +      been converted to userspace crypto, for example iwd.
>
> -      See Documentation/crypto/userspace-if.rst and
> -      https://www.chronox.de/libkcapi/html/index.html
> +      See also Documentation/crypto/userspace-if.rst
>
> config CRYPTO_USER_API_ENABLE_OBSOLETE
>    bool "Obsolete cryptographic algorithms"
>    depends on CRYPTO_USER_API
>    default y
>
> base-commit: 57b8e2d666a31fa201432d58f5fe3469a0dd83ba
> --
> 2.54.0
>
>

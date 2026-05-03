Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DE537C0E6
	for <linux-crypto@vger.kernel.org>; Sun,  3 May 2026 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777836023; cv=pass; b=F0hu7aZE3zmDT2ucof01Prqqdjigyk2OO50mhSQqMsKyndm0aj3xhGVXlxMgBelLiVbzrIKH0mN7VxEjS9qDdEE9W4J5FkBmSfDmgIeHeVlVvaDZkBpbqoQ+gsahV0przV5IzR7qGBlsrdSLiN5KsZ+YlMryCvJcn236bB3Awts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777836023; c=relaxed/simple;
	bh=okVFKaV0zmI7sdp9gO4+58JWLMiJV8xrb2etBRbGE9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=JGWM8LG+NgO9e0K+xJcKu1LJ9NeGz9UaqxfCjqGYLM/elDYEBQjlA6orJFrIqCpbQ4pDfuWC/zvsRB4Fel70j9153XJKYJHT0lAHpL7b+1RWtCSibgR+m2UXKELTqyGgOgvFelvcPsRxAePPceHvDiiiZYNZi7SejSYYHFYYbh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJ8ZPdir; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJ8ZPdir"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b4eb1fd5d0so31364336d6.0
        for <linux-crypto@vger.kernel.org>; Sun, 03 May 2026 12:20:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777836021; cv=none;
        d=google.com; s=arc-20240605;
        b=VJGrcn32GzjRyTbaJtazK322vornOBcyYyvEPxfae7ykIXJG8j9kIIUFGKNO/jumQC
         ymrEA3b9mh44wLqdQNIihKl3tf9VLF/QtEs6XSB86cV+bCIW9YYj74UBokiFrC7nYgAg
         W8UoAxbzMJDTNoR7NJ3iD3sSsO1R33RaSbAzMQoxWUVwu4MMyg4gMzXQ2cIx8N6YwiX1
         V4uPVc9IdiSFCzav4WgEmbNMtcs7SahkdeViPQEGNHf9evSVyF81tie0FRdfvlvE8ixv
         QI5Ya+Wrvm/R8iVzKTQ7tBqTTR1WKaw/RjICTp9teHMjacTq5PJ2BcimpQ+NCj3aZiNx
         JG+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A1KQkyXrRHz6CgheYFx2NyMsxprpVaixYfv59/L++Nc=;
        fh=/TwhKqZoV7wPrd2A6XO3t2HQHrUvuIilDSy+ow/PPR0=;
        b=hhBMjByCWGOF2Vy5PP7A2fCw7eRneArzpunhpLqj4pB7U2eBstwZuLX1OZx0vz2MC6
         qBJF4iFtqzdUP+Wgwe0DP/mG4tKATnpc+7WFPJ2hgc0cU/PjdJXfzxPR5lEAtMLwJNMQ
         Aelsx3NzNAVj88gbQG9JWe5v7dUiSa0Hds76UEwPqJA1hfc44EnwE5M0J05isc/IzYEk
         mau0Eo+slN90rlv5u6sIy75wAdk1Gt0Q8H7za2+SSGzwejqZw0Kcg+muyrJg0ab8UY0x
         o2rTNeZFAyS5+6aEXSaMSl+OTjO//rhqRI5ilI32OrBRq2ErEpoiVoW4l/yuVu48Cn64
         zGJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777836021; x=1778440821; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1KQkyXrRHz6CgheYFx2NyMsxprpVaixYfv59/L++Nc=;
        b=QJ8ZPdiripJKgamiGpg+TWkbq3OzyR5ElfCSP1hukr/FzejmxRNjq6Y5lgd/UdruxH
         ZnGF3Zt+9Ec4KmjseTtYgv2T7rszGkh1F8/9YoY3l96AI/JyzYbYaI2XTPp366sNj20E
         S8T3jB9gr2tE8N2q/zwOHoHbPC4324XDIApE+58/k6W5wkgj/CBXc5XpK6KCIC9voQDa
         qsItlvVnUA0a+GpXTeERdojg+cw6SjRNZZFa6WGSTiFKf8zs8wT5ZSEKv7IqEfXZyOl2
         TIneUMKDCFkubbJKyRd4Gkrg4I2DYFsMVkQUmy1d3GJHdJ1h4W95lcDi7/a6ZflfmQiV
         VJmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777836021; x=1778440821;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1KQkyXrRHz6CgheYFx2NyMsxprpVaixYfv59/L++Nc=;
        b=op9IaN6lFCOS4j2awfhWRNlNQoFRAmMAGQNDq3w8ajTAEKn2ZUJyJ2BHoydGapvbhE
         0BVHgB/076LKx/djEAWswQUV4BH2EJ1SOdNpzwp5g7WYiELIJaps55RDrOIjb/HftBlp
         +LQqy3yXjjkL8bWsUmCxj860qNrL8y/ZoUl9d1iFB48VxPZReXjgt5M53ZEzqu7KYKQp
         Y9RpF+FGPI8+bYtHEXrIK8BTdwLHk1Shbidvge6tzkHIjRahQVMtXI1exxbqhtz6zxnw
         CMGjIpEjBDU2U1S/aS5OXeGiUSnIE3pn+l73oDMbCKDFTbGU4oncCz7rCXBEUvYyt2B0
         RS9Q==
X-Forwarded-Encrypted: i=1; AFNElJ9A/L5bKvuA6xjtYLL/YIskK4i5KqpK4+PmCD7TnbgN+9HXM0jmpePVs99BI3RMaOEVHAMl0aWXojbYE4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkeaI8u8aIVBLgtWumo4Jsxe56ch+2qrPJ/sYNVxFdCM9vGdmg
	BaE4HgvZHpxZwlYTJDK/Igp4h6TEl3Rfxvl6lzyytGypD1BFZyyvu2b0jUzVeI7wZDrwTcUAxZB
	b9ML8S72pvRbxzNDCR3Tun/JIRazYPn4p1Gn1B9E=
X-Gm-Gg: AeBDietzo0IPAVnCvlFLWaMxVz7hg1GGMlo5UE/jGhCVLrNaA41OvmdkZCNiV3JUeui
	vCBuocOqLQD+3/0qULdzHif0kA3OrC903PEjl8lRpfAO52LQFdhA6aSEDZqUQIGKWUXw5uTMPoF
	Y5DB5kh4AWbyhL+UfjJ+aDSKkgHHKFw6kBJKGF/zPjlhHd7FkpTB/rRBGFDqZMPB3eWtr551862
	IyW36YDE7f0k8cZPpQokM1LvN6vz7OQ7VMxXCMfblfqHJNZcZZ30T0Hkkq9Bh1YJ0297gbsPHcu
	ZqxjoMkGnepXgfm1L9OT1iu684oRFA==
X-Received: by 2002:a05:6214:4c92:b0:8b1:f297:a54b with SMTP id
 6a1803df08f44-8b665f017a8mr117612506d6.18.1777836020540; Sun, 03 May 2026
 12:20:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430071917.GB54208@sol> <177abb5d-8ba9-4bb9-8b23-9fbc868ed3cd@gmail.com>
 <20260501180028.GA2260@sol> <19837ef5-e5b6-45f4-8336-3ce07423dfb1@gmail.com>
 <20260501201841.GA2540@quark> <c13dd3c5-ddc1-431e-bc7d-2de39c551f8e@gmail.com>
 <20260502033556.GA3872267@google.com> <20260502035402.GB3872267@google.com>
 <378c2ca2-417a-4969-bda5-b7d3f3e8b6fd@gmail.com> <CAM=PXV4q2i13W8Z_AZGDfdxbqWANJ=U4Sw3FTcv5mH_QUrrSfA@mail.gmail.com>
 <afcqxCv58YrhbtVr@definition.pseudorandom.co.uk>
In-Reply-To: <afcqxCv58YrhbtVr@definition.pseudorandom.co.uk>
From: Greg Dahlman <dahlman@gmail.com>
Date: Sun, 3 May 2026 13:20:09 -0600
X-Gm-Features: AVHnY4KniK2zDuuOkubdkvD1guInfuZPNAHeRGEHO4bXqYJEjoltMPjC75uDL1o
Message-ID: <CAM=PXV5Nu8VdpFY7mYmA86ddwYR7tR0nyLL_nZEnUdrz83Y=Rg@mail.gmail.com>
Subject: Re: [oss-security] CVE-2026-31431: CopyFail: linux local privilege scalation
To: oss-security@lists.openwall.com, linux-crypto@vger.kernel.org, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Note: re-adding the other lists so that people have an opportunity to
correct my errors.

"CAP_FOO in the init namespace" doesn't matter if "CAP_FOO" is the
gate in the default namespace, namespaces a facade-pattern and not an
isolation, unix abstract sockets, af_inet, vsock, af_alg etc... do not
currently use credentials at all IIRC.


LD_PRELOAD, as a way to (transparently) replace this functionality
without user intervention , involves putting in an interposer to
directly intercept all socket() calls at a system scale in this case,
when it is typically a thread scope concept.

I think socket() hasn't been interposable for at least a decade (in
glibc) you will weaken overall security by reintroducing the PLT or...
Note many people want to avoid adding in a `/etc/ld.so.preload`
because fighting dynamic linker hijacking is not easy due to Unix-like
systems having zero security boundary between the parent and child
process.

The bigger problem is that the embedded users are not where most of
the friction is going to come from, while the motivations are similar,
FIPS 140-3 validation, and downstream vendors which used distros
validations, incorporated into regilitory, compliance, and governance
is a large unidentified user base.

Searching for "Kernel Crypto API" in the Module name on this site will
show some of the upstream validations.

   https://csrc.nist.gov/projects/cryptographic-module-validation-program/v=
alidated-modules/search


In the case of non path backed sockets, userns provides zero
protections and only adds to the attack surface, the only credential
use for non-path backed sockets currently is the restriction of ports
below 1024 on af_inet,

Remember namespace support is not implicit, and all af_family calls
outside of those specific families that have namespace support all
stay in the default namespace.

If you dig through the $distro openssl security documents from the
NIST link above from the vendors you will see why people liked the
contract that af_alg offered, because they were depending on the
kernel teams stable api and reputation. and they could simplify their
compliance because it is easier to ensure no openssl installs exist at
all on a system than to try and maintain compliance, governance, and
regulatory obligations.

While there are some use cases like firmware images on some embedded
systems, where having the DMA pipe into a cryptoengine avoided Von
Neumann bottleneck issues and CPU usage etc.. No matter how flawed it
is to use af_alg, it provided a simple zero dependency interface that
their tools already supported (socket) and reduced their lifecycle
costs.  The reduced performance of the hw crypto engines for smaller
data sizes was acceptable as a trade-off, not as the primary driver in
many cases.

I should be 100% clear, namespaces _are not_ a security feature, but
they can be leveraged to lower privileges and improve a security
posture.  But when you have interfaces like sockets (non unix like)
the main advantage of network namespaces is they allow you to
constrain something that due to historical reasons has almost zero
controls (except tcp ports < 1024).

But the default is for any new, legacy or other subsystem to only live
in the default namespace.  The friction is when ~4 out of the 40+
af_families is namespace but the rest are not.

There is a very real problem with people overestimating the isolation
capabilities of namespaces in general, but paying attention to the
official documentation may help here:

https://www.kernel.org/doc/html/latest/admin-guide/namespaces/compatibility=
-list.html

     The same is true for the IPC namespaces being shared - two users
from different user namespaces should not access the same IPC objects
even having equal UIDs.
     But currently this is not so.

The "should not access" is a very different contract than most people expec=
t.

The FIPS/ISO compliance issue mostly invalidates what I hoped was an
easy fix and putting a kernel call interposer via ld_preload will
still add  friction that is likely to block the aspirations of
removing af_alg from the kernel.  I think that there is a path to do
so, and I think it would be best in the long run.  But the friction
here is not just from code changes, which are far easier to accomplish
than the regulatory issues.

The compliance based user base is one that is often far more challenging.

I do still think that both userland and kernel would benefit from some
mechanism that would make it easier for security teams, admins, and
users to run with lower privileges.  IMHO thinking about enabling that
control will also be critical to the kernel team's ability to remain
effective.  Different use cases will always conflict, and
non-namespace users would also benefit from ways to restrict access to
af_families.

IMHO if the team thinks af_alg is unfixable, it is maybe one of the
rare cases where breaking changes are necessary.  It may be more
productive to help compliance based users migrate than provide a
brittle shim that still invalidates all their authorizations anyway.

I am not an expert on FIPS/ISO compliance, but I do know that
providing guidance that helps users migrate would go a long way.  You
could say, have a userland process that provides a socket-like
interface with guidance on how to wrap or create a their_socket() to
migrate.

I still think that for non af_inet/unix (file backed)socket af
families, there needs to be a credentials mechanism.  People are
building systems on top of vsock and other non unix/if based systems
that are just as vulnerable. Like af_alg, vsock is known to have
serious issues and was designed for a trusted environment.  Without an
effective way to limit exposure from either userland or the kernel
there is enough that is simply just unexplored that it will be
expensive.

On Sun, May 3, 2026 at 5:00=E2=80=AFAM Simon McVittie <smcv@debian.org> wro=
te:
>
> On Sat, 02 May 2026 at 14:21:57 -0600, Greg Dahlman wrote:
> >LD_PRELOAD and capabilities
>
> These seem orthogonal, rather than being part of the same idea.
>
> LD_PRELOAD is discretionary (cooperative) so it would only be useful if
> used in a design something like this:
>
> - at the kernel level, AF_ALG just doesn't work (fails with a
>    permission-related error), at least for unprivileged processes
> - but in user-space, an opt-in LD_PRELOAD module intercepts the socket(),
>    etc. calls for AF_ALG, and emulates the behaviour of current kernels
>    by calling into a user-space crypto library
>
> It can't be a security boundary, but it can be a mitigation for the
> regressions that a new security boundary (or complete feature removal)
> would otherwise cause, similar to the way LD_PRELOADs like aoss and
> padsp mitigated the regressions for older binaries when distro kernels
> disabled OSS audio.
>
> Meanwhile capabilities are a way to let trusted, privileged processes
> have access to things that unprivileged processes do not, for example
> making AF_ALG available to a few system services that need it but not
> available to all of user-space.
>
> >You should expect any UID (even nobody) to be able to gain the
> >privileges in their bounding set
>
> The kernel can distinguish between "CAP_FOO in the init namespace" and
> "CAP_FOO in any other userns" if it wants to, and some kernel features
> are already gated by having a capability in the init namespace
> specifically. For example CAP_SYS_ADMIN in the init namespace allows
> mounting block-device-backed filesystems like ext4, but CAP_SYS_ADMIN in
> a different userns only allows a few "safe" mount operations
> (bind-mounts, overlayfs, FUSE).
>
>      smcv

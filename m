Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB79D3AF650
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782250112; cv=pass; b=ldDHUTuaexYgLaQ67iNE2Q14X64Ltx3JesIQs+ZX+7EOmfNDxjCfJrDurZJ7P+TlmWSz1jBfTECPU7BPSB7xnIPBaqo1CLFjjVlEszJws6agzy1BuX/ajAUcEF83fvoY3sFW4JgSmfeMnFwGiQQ+edrybVQoFHmsb3dQIEiiVYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782250112; c=relaxed/simple;
	bh=40qNJroCUiZX8a9sPjSuvaqj0dipAzu5PU1tI7TqCf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bKLap9ivfxnpfFCU3bW11HyYwMYJobzkA4BOlD/L9xTaiD6rSiNJt/d3BEYn7b7F0eXK1TftvkzzVbYeL+g9nVTotYDR+1Dim93Z52e8OGrqt485e+sY4zMjEtd8ORFjvnqO3dZjlYmo5zF8WVoXXyXLkIpVEgcfJ/FAEcAaHgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=szLeeyUL; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szLeeyUL"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69690062350so355185a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 14:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782250109; cv=none;
        d=google.com; s=arc-20240605;
        b=axPr30LQMeg7CcaA+g1ABWEAJ3e/DffzBXrlE/rH93th4rBcjgbevcV8YHUsLl0dXu
         DWg505ZOtzqpKKEZNlg+F6rZgT0M3/gPmNolkH/W3detJtI61H7V72/+gyWUCCkP8ns/
         WJJVcskhy8d/8K2uLtxAToASnj6vk4zvwYYW7wfso2/xDzn4WZTP3eg12KONYyqDvukk
         BrV2JqiZKF4XJXSWObtUHUGys5fJUQ5pYCAKki3MB3plV5OhE5HR8xEznn4XYhX8edxi
         yUxq/+Y6X3Ts9O7zqdiinKDOxcDX4hciMvlKidZ6RIWzR9W2jndEDFudNPyuMXA86Xod
         4TQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/m+wn+vRSDDNCL4eUzr6UF8pY3U224roSYoMHtZkmVA=;
        fh=oQPyVsOfiflImFtc3HupBs+Qdh4bh24JxOAgZ5D/+F0=;
        b=icyGHJrB170j2VAYgglBEa6kOpKZxL+YSXJp4I5RMgXZG1zLaNIjO9n4t3lsaSdJvq
         Lj1yi1KGQGxsBJ877PYT3v9a2/fszjErwcBKtmoUvwguirijyM3nwcfZOUIXkEqZLzoH
         LApWnzK7HHXFz9qqSH8ZCxJTwTfrqzZ/2faJzSpnglHeGjKF0Ho75PpXl0lXf17Z1EuA
         VnzaGPyZRS0B96bfPOfznQxc1Khm6trmoxKDz9rXJ0lPEL4Z3GnsTmqct5rzPZX1roT6
         ESdba08b+BR+X9h0GodTYA13cszlzZKQ7Z0dgmfLvHMQCflBS9jFF1KRcZjhIrrsLFPB
         Peng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782250109; x=1782854909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/m+wn+vRSDDNCL4eUzr6UF8pY3U224roSYoMHtZkmVA=;
        b=szLeeyULfCs/uXm7e5zuS2DOfmEZ9/w6RUVxteuOMeOjwPYAyIBcaKvHIhhHsiXNR5
         O02z2e6mkmYjSUob3sbLCvx9wLR4FN0CcBFtKEjaQ4JAdQBLA+AdGMbo/Jfkfpbmx50t
         bjnw7nyLN/LgDtk+g93KkKlic3KgrZC4VNYYsBKUdWYfs08ZKlkHQlABveP9QfIUG4Ch
         y7Acmzax0Wy+NtI/zmd9Tj6QQThKdbokoyJBiZktxuY7UGOouDDVaQIbGjSPjr/TaVPO
         sOH62dc1p23kAPmCVl4/NloEVIXiugpUWtiHzK/lhMsak0f+0gmrXUMiv8SpY6EshLi6
         nQHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782250109; x=1782854909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/m+wn+vRSDDNCL4eUzr6UF8pY3U224roSYoMHtZkmVA=;
        b=Mu3oTUz3z5bgOBAZ5o7B6YLB50R/gcRP02IWPWUesDGyEeEWXME9anj8qfbZ0FJUkR
         lTDgcuMGnPTs31NceFUz75pzcoCNzTs3uZ70kEgknR4O80se6GTFhW8dWfZ86Q+St3GA
         9i6p1stptKdf/uP1+5qP+cvAApGLfTt2uSmQ8kk3NO+FcypgcYmcTmaidmtaQAax+cRc
         DYAwXNLb/oXvNuiqrNQRzErdjclB+vDs237dh+D+7mhMzias2tkbDfwEZ44hGYH2F0ZE
         WRSzBLoQ3a388sHgZS2Q8P4nVeZtvQz7wLuwWX6Ar77t5k4K3ar3TKDXaLUqfwOgk26G
         FSrg==
X-Gm-Message-State: AOJu0Yzl1V2dl0DvFCCcfcNT2Yfd8SNGNKlLh9w6c8/vGLAv79b8cwg+
	b3nYAl2Raawthgd+hw9M1W773jnlQXBt3EP1uDW0p9/l6UQ4WEEVqzmdAMzmGnD8j4hj2LJjtad
	VKF5w5EGqs4lFwuG2vq/4ZxmnLeIirLg=
X-Gm-Gg: AfdE7cnCwKjxuDTyWZveQIKGQzp2QSwe2m7amVNVrEEL4/11dJ/5Po11HrYQW+L6qLS
	JQEd5A4WOivbP0dXXERbHyo+xmA2K+mQYdq1csP4A1pgTUDzwnZIgZ8Iv6Hp4ijg1hdWkwRXQ1x
	IpOj/pyKumVV6t2Belk4ye56xIuu5X7vBhY6B8Zo9ghsdxJY07WsXMpaF01NoYH0jBS2BMYiLiE
	3uWYXFVBnLbXLIYUbqN8aqylkglPW6oCClOtp7GoYdXTcY2nKekszoVIkyIJjaWWTANurUGYtwt
	MGL7tYi5KFYXm6RVo8YoP/nVQKuPJJrJ1EXcElVSXJ0+xATVKBpHHr6cr+ZtSENsp5sWXZWUWsA
	QIvjdZTQ39tPMgRjSeoHmGSIBOs2dUCPzV/nWt71ZsV6GFw==
X-Received: by 2002:a17:906:6a18:b0:bfe:ed06:5a16 with SMTP id
 a640c23a62f3a-c119f612f75mr14452866b.52.1782250108908; Tue, 23 Jun 2026
 14:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622234803.6982-1-ebiggers@kernel.org>
In-Reply-To: <20260622234803.6982-1-ebiggers@kernel.org>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 23 Jun 2026 14:28:17 -0700
X-Gm-Features: AVVi8CeOMkgVhsXfzF2PkDsCyod2GPYob2BRHRyvwYKt-_ptClsj1zXqM0ZiVBM
Message-ID: <CAKxU2N_EGTWkvtPOxQXBroxGVXDf1atPoFVyRRu0wHOtEXVWaA@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>, 
	Demi Marie Obenour <demiobenour@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 4:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> AF_ALG is a frequent source of vulnerabilities and a maintenance
> nightmare.  It exposes far more functionality to userspace than ever
> should have been exposed, especially to unprivileged processes.  Recent
> exploits have targeted kernel internal implementation details like
> "authencesn" that have zero use case for userspace access.
>
> Fortunately, AF_ALG is rarely used in practice, as userspace crypto
> libraries exist.  And when it is used, only some functionality is known
> to be used, and many users are known to hold capabilities already.
> iwd for example requires CAP_NET_ADMIN and has a known algorithm list
> (https://lore.kernel.org/linux-crypto/bcbbef00-5881-421b-8892-7be6c04b832=
d@gmail.com/).
>
> Thus, let's restrict the set of allowed algorithms by default, depending
> on the capabilities held.
>
> Add a sysctl /proc/sys/crypto/af_alg_restrict with meaning:
>
>     0: unrestricted
>     1: limited functionality
>     2: completely disabled
>
> Set the default value to 1, which enables an algorithm allowlist for
> unprivileged processes and a slightly longer allowlist for privileged
> processes.
>
> Note that the list may be tweaked in the future.  However, the common
> use cases such as iwd and bluez are taken into account already.  I've
> tested that iwd still works with the default value of 1.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/admin-guide/sysctl/crypto.rst | 36 +++++++++++
>  Documentation/crypto/userspace-if.rst       | 13 +++-
>  crypto/af_alg.c                             | 72 +++++++++++++++++++--
>  crypto/algif_aead.c                         | 11 ++++
>  crypto/algif_hash.c                         | 24 +++++++
>  crypto/algif_rng.c                          |  9 +++
>  crypto/algif_skcipher.c                     | 20 ++++++
>  include/crypto/if_alg.h                     |  8 +++
>  8 files changed, 184 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/crypto.rst b/Documentation/=
admin-guide/sysctl/crypto.rst
> index b707bd314a64..9a1bd53287f4 100644
> --- a/Documentation/admin-guide/sysctl/crypto.rst
> +++ b/Documentation/admin-guide/sysctl/crypto.rst
> @@ -5,10 +5,46 @@
>  These files show up in ``/proc/sys/crypto/``, depending on the
>  kernel configuration:
>
>  .. contents:: :local:
>
> +.. _af_alg_restrict:
> +
> +af_alg_restrict
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Controls the level of restriction of AF_ALG.
> +
> +AF_ALG is a deprecated and rarely-used userspace interface that is a
> +frequent source of vulnerabilities. It also unnecessarily exposes a
> +large number of kernel implementation details. For more information
> +about AF_ALG, see :ref:`Documentation/crypto/userspace-if.rst
> +<crypto_userspace_interface>`.
> +
> +Starting in Linux v7.3, AF_ALG supports only a limited set of
> +algorithms by default. This sysctl allows the system administrator to
> +remove this restriction when needed for compatibility reasons, or to
> +go further and disable AF_ALG entirely. The default value is 1.
> +
> +=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +0    AF_ALG is unrestricted.
> +
> +1    AF_ALG is supported with a limited list of algorithms. The list
> +     is designed for compatibility with known users such as iwd and
> +     bluez that haven't yet been fixed to use userspace crypto code.
> +
> +     Specifically, there is an allowlist for unprivileged processes
> +     and a somewhat longer allowlist for processes that hold
> +     CAP_SYS_ADMIN or CAP_NET_ADMIN in the initial user namespace.
> +
> +     Attempts to bind() an AF_ALG socket with a disallowed algorithm
> +     fail with ENOENT.
> +
> +2    AF_ALG is completely disabled. Attempts to create an AF_ALG
> +     socket fail with EAFNOSUPPORT.
> +=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  fips_enabled
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  Read-only flag that indicates whether FIPS mode is enabled.
>
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto=
/userspace-if.rst
> index ab93300c8e04..d6194346e366 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -1,5 +1,7 @@
> +.. _crypto_userspace_interface:
> +
>  User Space Interface
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  Introduction
>  ------------
> @@ -10,13 +12,18 @@ code.
>
>  AF_ALG is insecure and is deprecated. Originally added to the kernel in =
2010,
>  most kernel developers now consider it to be a mistake. Support for hard=
ware
>  accelerators, which was the original purpose of AF_ALG, has been removed=
.
>
> -AF_ALG continues to be supported only for backwards compatibility. On sy=
stems
> -where no programs using AF_ALG remain, the support for it should be disa=
bled by
> -disabling ``CONFIG_CRYPTO_USER_API_*``.
> +AF_ALG continues to be supported only for backwards compatibility.
> +
> +Starting in Linux v7.3, the set of algorithms supported by AF_ALG is lim=
ited by
> +default. See :ref:`/proc/sys/crypto/af_alg_restrict <af_alg_restrict>`.
> +
> +On systems where no programs using AF_ALG remain, the support for it sho=
uld be
> +disabled entirely by setting ``/proc/sys/crypto/af_alg_restrict`` to 2 o=
r by
> +disabling ``CONFIG_CRYPTO_USER_API_*`` in the kernel configuration.
>
>  Deprecation
>  -----------
>
>  AF_ALG was originally intended to provide userspace programs access to c=
rypto
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index cce000e8590e..34b801568fba 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -6,10 +6,11 @@
>   *
>   * Copyright (c) 2010 Herbert Xu <herbert@gondor.apana.org.au>
>   */
>
>  #include <linux/atomic.h>
> +#include <linux/capability.h>
>  #include <crypto/if_alg.h>
>  #include <linux/crypto.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/key.h>
> @@ -20,14 +21,32 @@
>  #include <linux/rwsem.h>
>  #include <linux/sched.h>
>  #include <linux/sched/signal.h>
>  #include <linux/security.h>
>  #include <linux/string.h>
> +#include <linux/sysctl.h>
> +#include <linux/user_namespace.h>
>  #include <keys/user-type.h>
>  #include <keys/trusted-type.h>
>  #include <keys/encrypted-type.h>
>
> +static int af_alg_restrict =3D 1;
> +
> +static const struct ctl_table af_alg_table[] =3D {
> +       {
> +               .procname       =3D "af_alg_restrict",
> +               .data           =3D &af_alg_restrict,
> +               .maxlen         =3D sizeof(int),
> +               .mode           =3D 0644,
> +               .proc_handler   =3D proc_dointvec_minmax,
> +               .extra1         =3D SYSCTL_ZERO,
> +               .extra2         =3D SYSCTL_TWO,
> +       },
> +};
> +
> +static struct ctl_table_header *af_alg_header;
> +
>  struct alg_type_list {
>         const struct af_alg_type *type;
>         struct list_head list;
>  };
>
> @@ -108,10 +127,43 @@ int af_alg_unregister_type(const struct af_alg_type=
 *type)
>
>         return err;
>  }
>  EXPORT_SYMBOL_GPL(af_alg_unregister_type);
>
> +static bool af_alg_capable(void)
> +{
> +       return ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN) ||
> +              capable(CAP_SYS_ADMIN);
> +}
> +
> +int af_alg_check_restriction(const char *name,
> +                            const struct af_alg_allowlist_entry allowlis=
t[])
> +{
> +       int level =3D READ_ONCE(af_alg_restrict);
> +
> +       if (level =3D=3D 0)
> +               return 0;
> +       if (level =3D=3D 1) {
> +               for (const struct af_alg_allowlist_entry *ent =3D allowli=
st;
> +                    ent->name; ent++) {
> +                       if (strcmp(name, ent->name) =3D=3D 0 &&
> +                           (!ent->privileged || af_alg_capable()))
> +                               return 0;
> +               }
> +       }
> +       /*
> +        * Use -ENOENT (the error code for "algorithm not found") instead=
 of
> +        * -EACCES or -EPERM, for the highest chance of correctly trigger=
ing
> +        * fallback code paths in userspace programs.
> +        *
> +        * Don't log a warning, since it would be noisy.  iwd tries to bi=
nd a
> +        * bunch of algorithms that it never uses.
> +        */
> +       return -ENOENT;
> +}
> +EXPORT_SYMBOL_GPL(af_alg_check_restriction);
> +
>  static void alg_do_release(const struct af_alg_type *type, void *private=
)
>  {
>         if (!type)
>                 return;
>
> @@ -504,10 +556,13 @@ static int alg_create(struct net *net, struct socke=
t *sock, int protocol,
>                       int kern)
>  {
>         struct sock *sk;
>         int err;
>
> +       if (READ_ONCE(af_alg_restrict) =3D=3D 2)
> +               return -EAFNOSUPPORT;
> +
>         if (sock->type !=3D SOCK_SEQPACKET)
>                 return -ESOCKTNOSUPPORT;
>         if (protocol !=3D 0)
>                 return -EPROTONOSUPPORT;
>
> @@ -1220,31 +1275,36 @@ int af_alg_get_rsgl(struct sock *sk, struct msghd=
r *msg, int flags,
>  }
>  EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
>
>  static int __init af_alg_init(void)
>  {
> -       int err =3D proto_register(&alg_proto, 0);
> +       int err;
> +
> +       af_alg_header =3D register_sysctl("crypto", af_alg_table);
>
> +       err =3D proto_register(&alg_proto, 0);
>         if (err)
> -               goto out;
> +               goto out_unregister_sysctl;
>
>         err =3D sock_register(&alg_family);
> -       if (err !=3D 0)
> +       if (err)
>                 goto out_unregister_proto;
>
> -out:
> -       return err;
> +       return 0;
>
>  out_unregister_proto:
>         proto_unregister(&alg_proto);
> -       goto out;
> +out_unregister_sysctl:
> +       unregister_sysctl_table(af_alg_header);
> +       return err;
>  }
>
>  static void __exit af_alg_exit(void)
>  {
>         sock_unregister(PF_ALG);
>         proto_unregister(&alg_proto);
> +       unregister_sysctl_table(af_alg_header);
>  }
>
>  module_init(af_alg_init);
>  module_exit(af_alg_exit);
>  MODULE_DESCRIPTION("Crypto userspace interface");
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 787aac8aeb24..b9217f9086aa 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -32,10 +32,15 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
>
> +static const struct af_alg_allowlist_entry aead_allowlist[] =3D {
> +       { "ccm(aes)", true }, /* bluez */
> +       {},
> +};
> +
>  static inline bool aead_sufficient_data(struct sock *sk)
>  {
>         struct alg_sock *ask =3D alg_sk(sk);
>         struct sock *psk =3D ask->parent;
>         struct alg_sock *pask =3D alg_sk(psk);
> @@ -342,10 +347,16 @@ static struct proto_ops algif_aead_ops_nokey =3D {
>         .poll           =3D       af_alg_poll,
>  };
>
>  static void *aead_bind(const char *name)
>  {
> +       int err;
> +
> +       err =3D af_alg_check_restriction(name, aead_allowlist);
> +       if (err)
> +               return ERR_PTR(err);
> +
>         return crypto_alloc_aead(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void aead_release(void *private)
>  {
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 5452ad6c1506..a8d958d51ece 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -14,10 +14,28 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
>
> +static const struct af_alg_allowlist_entry hash_allowlist[] =3D {
> +       { "cmac(aes)", true }, /* iwd, bluez */
> +       { "hmac(md5)", true }, /* iwd */
> +       { "hmac(sha1)", true }, /* iwd */
> +       { "hmac(sha224)", true }, /* iwd */
> +       { "hmac(sha256)", true }, /* iwd */
> +       { "hmac(sha384)", true }, /* iwd */
> +       { "hmac(sha512)", true }, /* iwd, sha512hmac */
> +       { "md4", true }, /* iwd */
> +       { "md5", true }, /* iwd */
> +       { "sha1", false }, /* iwd, iproute2 < 7.0 */
> +       { "sha224", true }, /* iwd */
> +       { "sha256", true }, /* iwd */
> +       { "sha384", true }, /* iwd */
> +       { "sha512", true }, /* iwd */
> +       {},
In OpenWrt, https://gitlab.com/linux-afs/kafs-client and strongswan
seem to be the other users of the user API. I haven't looked into what
they need.
> +};
> +
>  struct hash_ctx {
>         struct af_alg_sgl sgl;
>
>         u8 *result;
>
> @@ -380,10 +398,16 @@ static struct proto_ops algif_hash_ops_nokey =3D {
>         .accept         =3D       hash_accept_nokey,
>  };
>
>  static void *hash_bind(const char *name)
>  {
> +       int err;
> +
> +       err =3D af_alg_check_restriction(name, hash_allowlist);
> +       if (err)
> +               return ERR_PTR(err);
> +
>         return crypto_alloc_ahash(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void hash_release(void *private)
>  {
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 4dfe7899f8fa..bd522915d56d 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -48,10 +48,14 @@
>
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
>  MODULE_DESCRIPTION("User-space interface for random number generators");
>
> +static const struct af_alg_allowlist_entry rng_allowlist[] =3D {
> +       {},
> +};
> +
>  struct rng_ctx {
>  #define MAXSIZE 128
>         unsigned int len;
>         struct crypto_rng *drng;
>         u8 *addtl;
> @@ -199,10 +203,15 @@ static struct proto_ops __maybe_unused algif_rng_te=
st_ops =3D {
>
>  static void *rng_bind(const char *name)
>  {
>         struct rng_parent_ctx *pctx;
>         struct crypto_rng *rng;
> +       int err;
> +
> +       err =3D af_alg_check_restriction(name, rng_allowlist);
> +       if (err)
> +               return ERR_PTR(err);
>
>         pctx =3D kzalloc_obj(*pctx);
>         if (!pctx)
>                 return ERR_PTR(-ENOMEM);
>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index df20bdfe1f1f..2b8069667974 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -32,10 +32,24 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <net/sock.h>
>
> +static const struct af_alg_allowlist_entry skcipher_allowlist[] =3D {
> +       { "adiantum(xchacha12,aes)", false }, /* cryptsetup */
> +       { "adiantum(xchacha20,aes)", false }, /* cryptsetup */
> +       { "cbc(aes)", true }, /* iwd */
> +       { "cbc(des)", true }, /* iwd */
> +       { "cbc(des3_ede)", true }, /* iwd */
> +       { "ctr(aes)", true }, /* iwd */
> +       { "ecb(aes)", true }, /* iwd, bluez */
> +       { "ecb(des)", true }, /* iwd */
> +       { "hctr2(aes)", false }, /* cryptsetup */
> +       { "xts(aes)", false }, /* cryptsetup benchmark */
> +       {},
> +};
> +
>  static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
>                             size_t size)
>  {
>         struct sock *sk =3D sock->sk;
>         struct alg_sock *ask =3D alg_sk(sk);
> @@ -307,10 +321,16 @@ static struct proto_ops algif_skcipher_ops_nokey =
=3D {
>         .poll           =3D       af_alg_poll,
>  };
>
>  static void *skcipher_bind(const char *name)
>  {
> +       int err;
> +
> +       err =3D af_alg_check_restriction(name, skcipher_allowlist);
> +       if (err)
> +               return ERR_PTR(err);
> +
>         return crypto_alloc_skcipher(name, 0, AF_ALG_CRYPTOAPI_MASK);
>  }
>
>  static void skcipher_release(void *private)
>  {
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 7643ba954125..4e9ed8e73403 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -159,13 +159,21 @@ struct af_alg_ctx {
>         unsigned int len;
>
>         unsigned int inflight;
>  };
>
> +struct af_alg_allowlist_entry {
> +       const char *name;
> +       bool privileged;
> +};
> +
>  int af_alg_register_type(const struct af_alg_type *type);
>  int af_alg_unregister_type(const struct af_alg_type *type);
>
> +int af_alg_check_restriction(const char *name,
> +                            const struct af_alg_allowlist_entry allowlis=
t[]);
> +
>  int af_alg_release(struct socket *sock);
>  void af_alg_release_parent(struct sock *sk);
>  int af_alg_accept(struct sock *sk, struct socket *newsock,
>                   struct proto_accept_arg *arg);
>
>
> base-commit: 1dc18801be29bc54709aa355b8acd80e183b03cd
> --
> 2.54.0
>
>

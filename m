Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355CCEEB3
	for <linux-crypto@vger.kernel.org>; Fri,  2 Jan 2026 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767359833; cv=none; b=n0HIP6+5IuQg0ObwXJFuxGe6dvYPzF1r8mDlsA56yhdDUulS5WclQdgQP+08h1KCvi3+afqoR2BLecrc4PE4+QTpfL+efjApXJPZ2Pnt4DsJLKJenhB6NSMTdAq+oCkg+rEz66TMS8j4af6Bln2NxOLlyspXTbhD6NeIaLrr59I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767359833; c=relaxed/simple;
	bh=wmxzFvO5o/bCD+0RFEBmfpnSQLPM2fVyMljVJ6kbb+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qSNDSE0aev8gZ7otb291C8GyhtbjSJSGRQ42fmFDV0HJzTCEfvBuEbyB/ols1rB6uJQ2dZbw4gL9UCz0iDzBWpeloHKwfspWeaRrBA5Z3XaR26IQflbgnovgHAbNlUK28F18YGEBJEErGyu57g/Im/rb5b8SYadWFnhU4wUqqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=BbgeQ/0L; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="BbgeQ/0L"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-597d712c0a7so12484173e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jan 2026 05:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1767359828; x=1767964628; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cBng+SrQQjxsUQwPTtTuk3tEWndQFoR22jyq6GH9Mww=;
        b=BbgeQ/0LR7kuLr/vv3NbEy6aXEX5ZGGT1ic3uLOUUNhnOGgb6QzFTAZ4Ha63auxt5k
         c/7NJboMQnVD6XKHMF4fpIK52UUmN95gCYEqcV30AurjJ3iJpjpKspqTfLUaaQikAOiL
         HU1X7MY3vRC87Ih4rNu1DZJkOju2sUrpXGUNh/eP79v+V4t5D53KPqmm4q9xAVRwobI5
         XTTx88oyKF0E1c+kn5tTszc6zDccXNHXXT4tZKRuUrPsz8v0jJOq/Ic5JCe0TKVtOGJP
         I078zPQ9Gpy3OXeoLqAr8YRMPpAtQA+wfa9rBxhMbrQjVOCXPg432wHx1R/pBO+oCYwP
         k1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767359828; x=1767964628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cBng+SrQQjxsUQwPTtTuk3tEWndQFoR22jyq6GH9Mww=;
        b=bocFkZeXAd40mOdB6bYNN83TPjtCNnXuMfIitunXZC5tLWmJHzzMw+o49wY4uoCkXu
         terVEbPDEGHaplOUaxKc2sCug7gRYvVe1KzcOt11m+RSoBC/ZwKA668B0O1bphDV+zIm
         gLVdrrAvdkRZMERzniwr9sNnBvuyK0wWQ/rDTKdJ2d/m6b0fdUFXXVt+JJ1y1z2Bcqd0
         UMReI39WLjHxYvJa1pRuUBwk6jDxN4PT0COJHxdC5UpAp7xf8dZw4DfOypH424x+uuEQ
         wF85ShnlMziJ5bm9UQIGEb21NLp6yHPyPSUhL3/bvqoJD+r/LoKFENi1XZh6gYpc9IuH
         OxgA==
X-Forwarded-Encrypted: i=1; AJvYcCU/q4mCxgLDP8vcWMlnHhAfHrvxZgRjXbL46/QwqHXNR2r95sV6x8a9TB19jQiffiy6Pojybv+QA4ECBOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmLVRqrl7ojowatDXSILkYmZ8XWc1KmXsDNbpmeEccSsTWotbp
	8i14m0E0tnzOtO6Qw/Wg4kvtS0WGmbucsCXF68AXXEGS+Ni5Cx603eFBiSxphVbtcVN5dDnEbju
	xxKae2cRk4nSUq8lPCx7RWhvCetqoYS/5nQSm2NzXEg==
X-Gm-Gg: AY/fxX5haoGXbqr1tzNAxYB7AmPTNwXv1oRRFg6ce+CLuM9w8CSN4eTSOdhTD/tRGbl
	Smn2/XrEm6sCkfBwbsavv65zlJ39xBdnST75Rd2st1fD1nE8a6yl1GoDxC82LEjiWu5mx++5zrd
	/Hf+kZd66AkylSn21aKI7QEjJTzTYtDKJ2CFJIGWKuW5A6LkAVkgcEwEAwtdQ7mrcl7QM6O/3QL
	evC29IetM6XZWu1qe73QTURSiWIhou6xPDxfr30Z0Kq1XZigwlKgLHYRzGgttLWqcI4bQW/Y2+W
	EzkFEZlv59UjJw==
X-Google-Smtp-Source: AGHT+IEcQLZ49YcSsJK/41TIDlb2cogJhPW0ToE+QTkbmtfLEYi/OmJW8NJTTnilrkmiQky2WXpwfnm2VTeLLHvVdEU=
X-Received: by 2002:a05:6512:2388:b0:59a:115f:5b8e with SMTP id
 2adb3069b0e04-59a17dd70b4mr14768341e87.45.1767359828085; Fri, 02 Jan 2026
 05:17:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aUC6u-9r7w1uZH3G@gondor.apana.org.au> <20250919195132.1088515-1-xiangrongl@nvidia.com>
 <20250919195132.1088515-3-xiangrongl@nvidia.com> <fab52b36-496b-41c3-9adc-cb4e26e91e53@kernel.org>
 <BYAPR12MB3015BB37C50E4B9647C268ADA9ADA@BYAPR12MB3015.namprd12.prod.outlook.com>
 <953779.1765892118@warthog.procyon.org.uk> <BYAPR12MB3015CB5B2579B8E87E38637BA9BDA@BYAPR12MB3015.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB3015CB5B2579B8E87E38637BA9BDA@BYAPR12MB3015.namprd12.prod.outlook.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Fri, 2 Jan 2026 13:16:57 +0000
X-Gm-Features: AQt7F2rT1PaWb2tOZa6IgRBdYDAxkPpmUIWhC49qO1XNpVoY3Koi08l20ZpkjqA
Message-ID: <CALrw=nE0W5Nk_8OezessQaOUG9eL-OBNtinu2exzuzifJ3TeMQ@mail.gmail.com>
Subject: Re: Nvidia PKA driver upstream needs permission from linux-crypto team
To: Ron Li <xiangrongl@nvidia.com>
Cc: David Howells <dhowells@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>, 
	David Thompson <davthompson@nvidia.com>, Khalil Blaiech <kblaiech@nvidia.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>, Vadim Pasternak <vadimp@nvidia.com>, 
	"ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>, Hans de Goede <hansg@kernel.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 31, 2025 at 8:17=E2=80=AFPM Ron Li <xiangrongl@nvidia.com> wrot=
e:
>
> Hi David,
> The submitted Nvidia PKA driver does not perform any asymmetric operation=
s. Instead, it simply allows the user space to access the Nvidia BlueField =
specific PKA hardware through file operations.
>
> Would you evaluate this use case?

Additionally from your explanation in [1] "The user=E2=80=91space AF_ALG
interface does not expose asymmetric algorithms
(Documentation/crypto/userspace-if.rst), so it wouldn=E2=80=99t reach those
consumers" and to iterate on David's point - can it be made to work
with existing asymmetric key subsystem [2]?

Also for "Additionally, routing through Crypto API adds extra
copies/context hops that regress our handshake latency and batched
throughput targets compared to the direct, zero=E2=80=91copy queue UAPI" -
this is understandable, but again seems the interface somehow
reimplements io_uring

Perhaps there is a way to have two layers of interfaces? A lower layer
implementing io_uring interface for userspace to talk to the HW in a
zero copy manner and a higher-level interface (ideally building on top
of the lower interface) exposing asymmetric crypto primitives via
asymmetric key subsystem (will be useful for non-TLS use cases).

In a nutshell asymmetric keys were designed to more easily expose
crypto accelerators so not doing so feels like a big miss.

> Thanks
> Ron
> ________________________________
> From: David Howells <dhowells@redhat.com>
> Sent: Tuesday, December 16, 2025 8:35 AM
> To: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: dhowells@redhat.com <dhowells@redhat.com>; Ron Li <xiangrongl@nvidia.=
com>; Lukas Wunner <lukas@wunner.de>; Ignat Korchagin <ignat@cloudflare.com=
>; David S. Miller <davem@davemloft.net>; David Thompson <davthompson@nvidi=
a.com>; Khalil Blaiech <kblaiech@nvidia.com>; John Hubbard <jhubbard@nvidia=
.com>; Jason Gunthorpe <jgg@nvidia.com>; alok.a.tiwari@oracle.com <alok.a.t=
iwari@oracle.com>; Vadim Pasternak <vadimp@nvidia.com>; ilpo.jarvinen@linux=
.intel.com <ilpo.jarvinen@linux.intel.com>; Hans de Goede <hansg@kernel.org=
>; linux-crypto@vger.kernel.org <linux-crypto@vger.kernel.org>
> Subject: Re: Nvidia PKA driver upstream needs permission from linux-crypt=
o team
>
> External email: Use caution opening links or attachments
>
>
> Note that there is a keyrings-based UAPI for doing public key cryptograph=
y, if
> it's of use:
>
>         keyctl_pkey_query()
>         keyctl_pkey_encrypt()
>         keyctl_pkey_decrypt()
>         keyctl_pkey_sign()
>         keyctl_pkey_verify()
>
> using the keyctl() syscall through libkeyutils.
>
> To use it, you need a kernel key (ie. created by add_key() or request_key=
())
> to represent the key material and potentially the mechanism by which it c=
an be
> accessed (if the material is, say, stored in a TPM and can only be made u=
se of
> by talking the device).
>
> Keys can be loaded by X.509 or PKCS#8, but other ways could be added.
>
> I've also contemplated making this accessible via io_uring.
>
> David
>

Ignat

[1]: https://lore.kernel.org/all/BYAPR12MB30157EDAC502D14D7E0E5546A9CCA@BYA=
PR12MB3015.namprd12.prod.outlook.com/
[2]: https://docs.kernel.org/crypto/asymmetric-keys.html

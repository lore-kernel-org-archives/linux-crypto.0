Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BA030F958
	for <linux-crypto@vger.kernel.org>; Fri,  1 May 2026 05:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777613852; cv=none; b=PnrfTAmJmumbo5p/1FWAF6Uk0icXbJzsQUMlUbbNuOjgfwEy6MJXchIK/p6pbh0PqE1yuOguSxhYzYPS6DI0024yXbQY7O1B3MjxVCovMzg9yNdnFy6D+Hzj85/SpiRhxretlOH+ELIYJdtBKRfZoS2FxGsD2Fk1ThssRHeD8VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777613852; c=relaxed/simple;
	bh=WKPABIsseylb3RUsTw0xvE9Pmu+sljz/nKUYmu18KhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gO5sZlBMw+M6xpes8sacJd8BEqKknHt9ZWD7GWrsoxp8Anj4alyFuDVuA5tS8oewOhbt3xSYq7O5y3h0DrX9X4/o3MGQLNEb7KXMYYRoqMfGJn5BxlI7QWKdxewcasoxYP4srZgrJfgjo1cHiMCc+piF67ZQsU6F0iDpmhXG5WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67b32c695efso3328323a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 22:37:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777613849; x=1778218649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dXMXzeJoapUPYGltuEcVDIPcO3Wjov50Tx6Z9qKY0P4=;
        b=HKfOS4Jh8bjgcHi/xDNRDIlP+TWdks64z0bslAdfhfyXKjQc/CqY/PNZ57mMF6jjMI
         pemJgNXafZ/+V/o0cpvMjZHfj5P5otWmr8M6z3j0mchPai1jjY2emLbeQ4UNV9IlBDNB
         tqyrDb20Q7IWsuV1lwCFNq9ocUhXSoXgFWxkdNo930ymOi8k4/BEySkbahlZcJSnSLPN
         BNlAYSLkdwYRJzTWrVO0n+571RlKNelA7C+D7Nz4OqcErRRW8pbqFLpzW/dIt5kwE0Hr
         O50Ct+UG2jOApHF+ZO232Ws/EJ8iyP18pbxieOBQY7UsyS0qQu5enYzoyEqbVQKgFMnR
         nLKg==
X-Forwarded-Encrypted: i=1; AFNElJ/3f3k49eRk69/FQpZW50Y4rxGWENNH9ktaCn3akFxO/KrvBDFfaKIOaYK3XCVnX7awAvN8At+zw7gPehI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzMw610FUwd956UBGttIG7nllpfs0iGW8/o6UBdfjexlkdqiNi
	seQySYFmU24icWvrUiQv8qjhC2DAxXXjATFF1vdYpiWpwc/YmrACZU8AOa2lJBLdLHo=
X-Gm-Gg: AeBDietH1wqJTkFdKgCNIIIA+edS8cKQrUaaT0nm8eT9HJv7jIV6Iz8QgWsoTHEWDBI
	kzcuKbRHsouSsh2gcfupXqcc6zI3qsJMlmP9aK1F6XtrFFpMBw3weu16zROBJLlB7Xz1rJ4Uw4Y
	d/J0jMMzQ8PE2/jN8KwdD6IvH+V94qraQcs1gDKSgZuGAVlCrW67JtV33DFTf3MTMovxtzfyKKc
	wV8cxj/FsgRYe/PvBbSrCKE77hw3A5xZ/gpVq+p5tWcYWa8kJy+06hVWtQ9m16H/8AQg1fSV7Qh
	zkTc6Z6RixaJ72UzfRCJzi1bSjyZgci3eHdSziPc2sEkk7/DUP9YcOuT+/ZcrcfYUD48Sflrg5F
	OlSfnjysNWfCT6QUcpPkgj5+fcvTAfTyt8Lm3GefsnaILvRBIS04Xpcrvuwl+tYwvjl9vVBYjk2
	4be+p3j0SzZbPviqcdMQ/i5Xdb9hK27UzHljwgMOSUNAWsZ/OP00CM1by5uAw32j3+
X-Received: by 2002:a17:907:a088:b0:bba:6a98:c860 with SMTP id a640c23a62f3a-bbb98476c02mr319465766b.25.1777613849255;
        Thu, 30 Apr 2026 22:37:29 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bbe6a64dabbsm73334766b.25.2026.04.30.22.37.28
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 22:37:28 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67b6a6bd7b8so1507863a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 22:37:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8c/AZG0Ua3etx6ihIPzJDZTtXg0i1Doq8ZPwMRLPemecTK7Fu8yxchYbMl1oqS9EK0hUPix94cMlAaP18=@vger.kernel.org
X-Received: by 2002:a05:6402:440a:b0:67b:7e67:7f5f with SMTP id
 4fb4d7f45d1cf-67b7e6780f9mr1738106a12.9.1777613848314; Thu, 30 Apr 2026
 22:37:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429181629.110802-2-bestswngs@gmail.com>
In-Reply-To: <20260429181629.110802-2-bestswngs@gmail.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 1 May 2026 06:37:16 +0100
X-Gmail-Original-Message-ID: <CAOs+rJUiup_B1ve7UztJH4crzE+98ZObRc3jLRsqkhLekpDmxA@mail.gmail.com>
X-Gm-Features: AVHnY4KFOllNfFhVUkq7YkiLdAqrH2_2sLf6kLFO07pHIa-YECyWylPj48Aai_M
Message-ID: <CAOs+rJUiup_B1ve7UztJH4crzE+98ZObRc3jLRsqkhLekpDmxA@mail.gmail.com>
Subject: Re: [PATCH] asymmetric_keys: check asymmetric_key_ids() for NULL
 before dereference
To: Weiming Shi <bestswngs@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Andrew Zaborowski <andrew.zaborowski@intel.com>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Xiang Mei <xmei5@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks for the report.

On Wed, Apr 29, 2026 at 7:17=E2=80=AFPM Weiming Shi <bestswngs@gmail.com> w=
rote:
>
> asymmetric_key_ids() returns key->payload.data[asym_key_ids], which can
> be NULL for keys parsed by the PKCS#8 parser (pkcs8_parser.c explicitly
> stores NULL in prep->payload.data[asym_key_ids]).
>
> key_or_keyring_common() in restrict.c and find_asymmetric_key() in
> asymmetric_type.c both dereference this return value without checking
> for NULL. An unprivileged user can trigger a NULL pointer dereference
> in key_or_keyring_common() by creating a PKCS#8 key, restricting a
> keyring with key_or_keyring:<pkcs8_serial>, and adding an X.509 cert
> to the restricted keyring. CONFIG_PKCS8_PRIVATE_KEY_PARSER=3Dy is

Could you add a simple bash script for this to the commit message?

> required.
>
>  Oops: general protection fault, probably for non-canonical address 0xdff=
ffc0000000000
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 c=
rypto/asymmetric_keys/restrict.c:279)
>  Call Trace:
>   <TASK>
>   __key_create_or_update (security/keys/key.c:884)
>   key_create_or_update (security/keys/key.c:1021)
>   __do_sys_add_key (security/keys/keyctl.c:134)
>   do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
>   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
>   </TASK>
>  Kernel panic - not syncing: Fatal exception
>
> Add a NULL check in find_asymmetric_key(), mirroring the existing
> pattern in asymmetric_match_key_ids() and asymmetric_key_describe().
> In key_or_keyring_common(), skip the trusted key matching when it
> has no key IDs and fall through to the check_dest path.
>
> Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  crypto/asymmetric_keys/asymmetric_type.c | 2 ++
>  crypto/asymmetric_keys/restrict.c        | 9 ++++++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric=
_keys/asymmetric_type.c
> --- a/crypto/asymmetric_keys/asymmetric_type.c
> +++ b/crypto/asymmetric_keys/asymmetric_type.c
> @@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyring,
>         if (id_0 && id_1) {
>                 const struct asymmetric_key_ids *kids =3D asymmetric_key_=
ids(key);
>
> +               if (!kids)
> +                       goto reject;
>                 if (!kids->id[1]) {
>                         pr_debug("First ID matches, but second is missing=
\n");
>                         goto reject;
> diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/r=
estrict.c
> --- a/crypto/asymmetric_keys/restrict.c
> +++ b/crypto/asymmetric_keys/restrict.c
> @@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *dest_k=
eyring,
>                         if (IS_ERR(key))
>                                 key =3D NULL;
>                 } else if (trusted->type =3D=3D &key_type_asymmetric) {
> +                       const struct asymmetric_key_ids *kids;
>                         const struct asymmetric_key_id **signer_ids;
>
> -                       signer_ids =3D (const struct asymmetric_key_id **=
)
> -                               asymmetric_key_ids(trusted)->id;
> +                       kids =3D asymmetric_key_ids(trusted);
> +                       if (!kids)
> +                               goto skip_trusted;
> +
> +                       signer_ids =3D (const struct asymmetric_key_id **=
)kids->id;
>
>                         /*
>                          * The auth_ids come from the candidate key (the
> @@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest_key=
ring,
>                 }
>         }
>
> +skip_trusted:
>         if (check_dest && !key) {
>                 /* See if the destination has a key that signed this one.=
 */
>                 key =3D find_asymmetric_key(dest_keyring, sig->auth_ids[0=
],
> --
> 2.39.0
>

Ignat

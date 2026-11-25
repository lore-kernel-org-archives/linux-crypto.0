Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630971;
	b=SwQsT+LiAtAPv6s2XYhX2ch3Qqq5/q3fG2ab+n0OJuxXhkG81jaGH6b0npNagrY0TyR+
	 2O47DT4dtUx1I3DoMssXjLK4CT4aDSEhjundjC4fiR0wWeELcPkxwGeIm8TpCKJVupfTX
	 WbsaUv86xJ16vxU4z6NkBMCk4ZkoNjDU5JstF+bFhxrI5nzqArFMfWT4GfEr3yMmekwsH
	 zzY94nnQpxQxEY1x4i/WwAU0qhLrvgt9UET+f5H8PL698JA06HYXfjCcDmYbAFYCmWypF
	 6dTwEm5s4wd4KoQGsVY5rZIpGhMA4vUpuDt+5nvSAGeDZvz2bH+yp1J+5ThLKDG0c4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630971;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wn7BSSA8/p+YXYHhitmjH8m+fQEFTnO81AlhTtuLU5Y=;
	b=BF2/CaQtXxtfv+m1rwtjST6ehcJuV+WkLyKFGunz8SuQjDwdc/1lIN+Wb07WN0JBnrfP
	 FpxagvUG4JaTi/T7rdKq4iSi70f0lwa8Fpic4VSART0XaAFQmHp3HKsIOT0WQ9/w/y9tA
	 WHD26bh6+CoL8WmqaALoJTBl9RKjmNnTX95COap71eLAI/1UukKEc59mVqgOexGm1b1fl
	 Drx5qYE6t30gWfNXpi6EBVaEArdG4/uxxfQNtHGohGq9qkb1zn07pFNobRhNEAjm70sle
	 BKFoa+o5UXm5MDJigSRUksplE4Q4eqX6QJlu92OdbSu5tT3VfgEQcQ6a5MjVL8YzrHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kNi/gIg9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBF5606A323;
	Wed, 25 Nov 2026 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kNi/gIg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DB31F000C0;
	Wed, 25 Nov 2026 18:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795630971;
	bh=wn7BSSA8/p+YXYHhitmjH8m+fQEFTnO81AlhTtuLU5Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kNi/gIg9IdtW8Te0fr8ZxQI/q/CRQ5IoPixdgYLm9zyL9CRDd58oRoO19uHG2iVrZ
	 Ic55oO80pUPZLa2VgxQjCpSBDe6dSwu3L0YN6z9tIxxwlQm1S9XjCfV03xXnq46oZa
	 jtiebGDzj3WLaNs2QkZ2UCJGXnfSWSpmHX2d0B4IiPyTt5qfGX7ab+GKZ2czJvhV4y
	 XwFtgGqyZ2b/vuHcsZE/qABbuz+S/1UU+g/gnjHdX9H3inGj5XA9EMsilYbdzJQIyv
	 PTMvqWUM4pExss83vnU6S+KWl/tVcuXiKklU0WgJ0JS90viHzVQmcsK7xXkUsswQKQ
	 cG9DuhJBrfsyw==
Message-ID: <sashiko-outbox-233977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/9] KEYS: Factor out opt-in KEYCTL_PKEY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, keyrings@vger.kernel.org
Cc: dm-devel@lists.linux.dev, linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org, "Ahmad
 Fatoum" <a.fatoum@pengutronix.de>, "Alasdair Kergon" <agk@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "David
 Gstir" <david@sigma-star.at>, "David Howells" <dhowells@redhat.com>, "David
 Laight" <david.laight.linux@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Woodhouse" <dwmw2@infradead.org>, "Eric Biggers" <ebiggers@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Ignat Korchagin" <ignat@linux.win>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "James Morris" <jmorris@namei.org>, "James
 Prestwood" <prestwoj@gmail.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Jonathan
 Corbet" <corbet@lwn.net>, "Lukas Wunner" <lukas@wunner.de>, "Mike Snitzer" <snitzer@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul
 Moore" <paul@paul-moore.com>, "Peter Huewe" <peterhuewe@gmx.de>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Sumit Garg" <sumit.garg@kernel.org>
In-Reply-To: <20261125180616.1854753-2-jarkko@kernel.org>
References: <20261125180616.1854753-1-jarkko@kernel.org>
 <20261125180616.1854753-2-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 18:22:49 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] keys: TURRIS_SIGNING_KEY Kconfig options still depend on
  ASYMMETRIC_KEY_TYPE
--

commit f2c536390b5f9f7464b1b59aadb07824b873665b
Author: Jarkko Sakkinen <jarkko@kernel.org>

KEYS: Factor out opt-in KEYCTL_PKEY

This commit separates CONFIG_KEYCTL_PKEY from CONFIG_ASYMMETRIC_KEY_TYPE
as an off-by-default option controlling compilation of keyctl_pkey.o.

> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index 3f64d60d0f8a6..75cc4043ca642 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -22,6 +22,15 @@ menuconfig KEYS
> =20
>  if KEYS
> =20
> +config KEYCTL_PKEY
> +	bool "Public-key operations on retained keys"
> +	help
> +	  This option provides support for querying, encrypting, decrypting,
> +	  signing, and verifying signatures via keyctl using public or
> +	  asymmetric keys retained in the kernel.
> +
> +	  If you are unsure as to whether this is required, answer N.
> +
>  config KEYS_REQUEST_CACHE
>  	bool "Enable temporary caching of the last request_key() result"
>  	help
> diff --git a/security/keys/Makefile b/security/keys/Makefile
> index 5f40807f05b3d..aafd28f7ee2fe 100644
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -22,7 +22,7 @@ obj-$(CONFIG_PROC_FS) +=3D proc.o
>  obj-$(CONFIG_SYSCTL) +=3D sysctl.o
>  obj-$(CONFIG_PERSISTENT_KEYRINGS) +=3D persistent.o
>  obj-$(CONFIG_KEY_DH_OPERATIONS) +=3D dh.o
> -obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) +=3D keyctl_pkey.o
> +obj-$(CONFIG_KEYCTL_PKEY) +=3D keyctl_pkey.o

[Severity: Medium]
Should TURRIS_SIGNING_KEY, TURRIS_OMNIA_MCU_KEYCTL and
TURRIS_MOX_RWTM_KEYCTL be updated to depend on KEYCTL_PKEY instead of
ASYMMETRIC_KEY_TYPE?

turris_signing_key_type implements .asym_query and .asym_eds_op for
keyctl_pkey.c without using crypto/asymmetric_keys:

drivers/platform/cznic/Kconfig:
config TURRIS_OMNIA_MCU_KEYCTL
	bool "Turris Omnia MCU ECDSA message signing"
	default y
	depends on KEYS
	depends on ASYMMETRIC_KEY_TYPE
...
config TURRIS_SIGNING_KEY
	tristate
	depends on KEYS
	depends on ASYMMETRIC_KEY_TYPE

With CONFIG_ASYMMETRIC_KEY_TYPE=3Dy and CONFIG_KEYCTL_PKEY=3Dn (the new
default), those drivers still default to y and register hardware signing
keys whose KEYCTL_PKEY_QUERY and KEYCTL_PKEY_SIGN calls now fail with
-EOPNOTSUPP.  Conversely, CONFIG_KEYCTL_PKEY=3Dy with
CONFIG_ASYMMETRIC_KEY_TYPE=3Dn cannot enable them at all.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125180616.1854=
753-1-jarkko@kernel.org?part=3D1

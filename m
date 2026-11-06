Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990137;
	b=5tURls5oYxxP9dWzUwyjQjjempCzoX7VSymzvB+X8p/dE0vmM3o4v/SSJW4/gY7FUzSy
	 pkuPLtqVYntAwcPXWDyqG6noAd6J0y+R84FAeWcEetFZTDfRyFd169XTxh7Vj9NN9F4OO
	 fpf4cvAtnS/M471DL6V+Gq3bTSFE0RMHuFGBHBFgIq8zsUX1Z/dY9tXC6i9GypiQ4KXCe
	 eoYws5ZzxnDo/3zX471A9mX/YKKXZY4Fd/AZgZ2I0ANICZWdc3eHYsIq9FChsnTJhTvBy
	 ur2e5kO3A2+EW2wjBwayPJcNflzylImPKpc2lNYaC3IXxRpxNS4NE+b0+NwUKNO3jAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990137;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UliTkuKSwijkprFnPvplR6mcOQUjgocutB6yCvWNZyo=;
	b=nh6Yyi6F/fCVDC2Zrfgn2tC9ftBYlAYY6t/H1L8CZGxFvpIclMGWBmXH06xlE5d7K+Gv
	 +4y7cBXgRJf1U9hX4NhZlkBS0po8rgtllIaMjh/tKWa8tT5/hsmRecqbvnltJX90Wj8wP
	 gSKZfGiqoZTTnT6E35LBTsQNjwiZJpo4UWZX78xd2MolUJU612arsD/WItS2fzzNzlnEz
	 Dst4xCyxaSFWQQcHOt1ndGL6wv/pcDOzCF8OSw/ZVkPpjbThQC1bSSvNbzvY21xplB+W9
	 RnO+vU1zCJ3wcECPesB1XO7wiMpJZsYu0t0l72AD4drID8yD18xOJEygeHXNrDkyowg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux.win;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDF5606A326
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 18:35:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FDF5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so1145917a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:35:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990136; x=1794594936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UliTkuKSwijkprFnPvplR6mcOQUjgocutB6yCvWNZyo=;
        b=qclRvl2aM1pkYklEFnVWTDM1SdBzqaUxGPX02abZplWesGTQpAUKmr0fQIUwpTFLNa
         nVkU3Mn3OctrP+L1t2lR89FHdssuk2CLJ3TZ0yCyNprlm3nKWcdFbX6qNsaMuJC4tUp3
         ClVTfd0pgYea2/b8LaXPG8EGRZBNpQW9+nwHh/DTmuItcOIwCZMIYc3UmM4pvYYspSeE
         02VSzuVZDUVSGJeKCRptn4CcWfppO2wldbBQf2WTUvFWwqBhLe+5sunRQWYjA6n2EVfP
         FsYjz6veBc+LZc3N3OgGLel7aOfrD375MRj+9bsPyizj018PDqRjIWinFyR/AP6OYOOI
         lkaA==
X-Forwarded-Encrypted: i=1; AL+hErHCAu4bh56qWw+/9/yi/ZtiR1CJ4VI0rhe9Nnt8dg0IpR5DjbHnZk4hg5I5MZmx52VheRBa2KIPNE552ag=@vger.kernel.org
X-Gm-Message-State: APuU4Z+ZKDgvjcW3rosqVl4+FUxjiCZ2x9QB/m9zt2XAFikvwQZdauJ0
	5Ow5gfTJt5fxzu9oWMwirXFwKFoYkTs1igOBLSLlMF6G6bBQqSNviSxApFACjCPSDLo=
X-Gm-Gg: AYBFou22JFMXi78NLOly6gqEx9wdcA9u+1XVrYePNgPLW0u3uXCKVWdsrHw9rYZ+H2h
	ukFniFM5vVwCHpH3QmQvpGdL16dSw/X2ujh8gcVaT8tSQaJRhD1jvUd3Awo3xy4N1RErsnZFFKS
	FVEDAQhvZvaxiMzpYrm8DwhODgZrroX3X0Pd/AbC2LQXDJDieFugS5PXk2EuE8zaI2pbZ7VF9gG
	NNxUWALxbo2WlviIv4C51Kn8hqfiqsWxa0VBd7VhMG0gmvaTkJUbLbS6Nrac5FSzgZwP5WQ2l18
	xXv8DIe1c5Nn5Ef5wmpRHwZ3Ce8nWnTt3zfSoc4guFO4EyVcEcXUan71+kRj8ymYhd5StBIz4Ht
	WCqKXaYcnU1x8xKekzhjS9Az6XV73NYHmMyjELOjQzh80q38+GjwhQMclYYFviASrBXxBRjIeUx
	X+DKA76vwUd3tgj+7iNZNvWsWYIlc8/nTvXusKxj5JH1AlmSx0GUnvlL4SKUyI0kIp7VGmi6S5g
	GD7CSDwWwQdga3tCD56IIYqXCZgD0H4cPWY5DdPz5RGQMy0dJybyiOVng8tDMKyjfyyxqyF4wCN
	Svm96cT13/vpA5FQ3Cv43CgbFX49rwOjiv7v+JJflhT8V6ruSair53Tdp9M=
X-Received: by 2002:a05:6402:51d4:b0:6b1:ced2:dfcd with SMTP id 4fb4d7f45d1cf-6b5977de686mr2464686a12.23.1793990135942;
        Fri, 06 Nov 2026 10:35:35 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b65d6b3a1csm957559a12.2.2026.11.06.10.35.35
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 10:35:35 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so144638366b.2
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2026 10:35:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw0UKCdDcQ2i+qIWsOc9nGQkG/r4KVCdLoES6/lnfW71cUxOnwKgXLybMlOmiJlT+3kDor5lIproREO/SA=@vger.kernel.org
X-Received: by 2002:a17:907:ea89:b0:c4c:bff4:200c with SMTP id
 a640c23a62f3a-c4d3531f031mr283547466b.32.1793989808075; Fri, 06 Nov 2026
 10:30:08 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029232437.2581640-1-jarkko@kernel.org> <20261029232437.2581640-2-jarkko@kernel.org>
In-Reply-To: <20261029232437.2581640-2-jarkko@kernel.org>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 6 Nov 2026 18:29:56 +0000
X-Gmail-Original-Message-ID: <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>
X-Gm-Features: AclHuK8TGNjpH-aL7rdb3WJ8RwrdjoKcrJ52VddwbSIE-hld3YHoMNkMBO-NFbA
Message-ID: <CAOs+rJVNyJwqp4CR-d_T4GVjNMjgbaDL78_mZCVGGvN1xpd33w@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] KEYS: Introduce keyring_is_empty()
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, 
	Eric Biggers <ebiggers@kernel.org>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, 
	"open list:ASYMMETRIC KEYS" <linux-crypto@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, 
	"open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO..." <fsverity@lists.linux.dev>, 
	"open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)" <bpf@vger.kernel.org>, 
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 11:25=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org=
> wrote:
>
> Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
> fs-verity how keyring internally manages the keys.
>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Ignat Korchagin <ignat@linux.win>

> ---
>  drivers/md/dm-verity-verify-sig.c                      |  2 +-
>  fs/verity/signature.c                                  |  2 +-
>  include/linux/key.h                                    |  1 +
>  kernel/bpf/keys.c                                      |  2 +-
>  security/keys/keyring.c                                | 10 ++++++++++
>  .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
>  6 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-ver=
ify-sig.c
> index aadcf5e4a47c..cad21e9144ed 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -153,7 +153,7 @@ int verity_verify_root_hash(const void *root_hash, si=
ze_t root_hash_len,
>         if (ret !=3D -ENOKEY && ret !=3D -EKEYREJECTED)
>                 return ret;
>
> -       if (dm_verity_keyring->keys.nr_leaves_on_tree &&
> +       if (!keyring_is_empty(dm_verity_keyring) &&
>             dm_verity_keyring->restrict_link)
>                 ret =3D verify_pkcs7_signature(root_hash, root_hash_len,
>                                              sig_data, sig_len,
> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 0302a4e506ec..890d33b9d812 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -67,7 +67,7 @@ int fsverity_verify_signature(const struct fsverity_inf=
o *vi,
>                 return 0;
>         }
>
> -       if (fsverity_keyring->keys.nr_leaves_on_tree =3D=3D 0) {
> +       if (keyring_is_empty(fsverity_keyring)) {
>                 /*
>                  * The ".fs-verity" keyring is empty, due to builtin sign=
atures
>                  * being supported by the kernel but not actually being u=
sed.
> diff --git a/include/linux/key.h b/include/linux/key.h
> index c4486e938a06..20ca43f5eab1 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h
> @@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
>                                 struct key *restriction_key);
>
>  extern int keyring_clear(struct key *keyring);
> +bool keyring_is_empty(const struct key *keyring);
>
>  extern key_ref_t keyring_search(key_ref_t keyring,
>                                 struct key_type *type,
> diff --git a/kernel/bpf/keys.c b/kernel/bpf/keys.c
> index bffc356839ac..24e0416abc99 100644
> --- a/kernel/bpf/keys.c
> +++ b/kernel/bpf/keys.c
> @@ -29,7 +29,7 @@ struct bpf_key *bpf_lookup_keyring(void)
>
>         if (!bpf_keyring)
>                 return NULL;
> -       if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
> +       if (keyring_is_empty(bpf_keyring) ||
>             !READ_ONCE(bpf_keyring->restrict_link))
>                 return NULL;
>
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index 5281da9d5bf7..ac48d6204915 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
>         assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
>  }
>
> +/**
> + * keyring_is_empty - Check whether a keyring is empty
> + * @keyring: The keyring to check.
> + */
> +bool keyring_is_empty(const struct key *keyring)
> +{
> +       return READ_ONCE(keyring->keys.nr_leaves_on_tree) =3D=3D 0;
> +}
> +EXPORT_SYMBOL(keyring_is_empty);
> +
>  /*
>   * Describe a keyring for /proc.
>   */
> diff --git a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh =
b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> index 1f9601ef22f8..792449d356cf 100755
> --- a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> +++ b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
> @@ -746,7 +746,7 @@ test_keyring_inactive_when_empty() {
>      log_info "TEST: Verify dm-verity keyring is inactive when sealed emp=
ty"
>
>      # When keyring_unsealed=3D0, the keyring is sealed immediately while=
 empty
> -    # This means it should NOT be used for verification (nr_leaves_on_tr=
ee=3D0)
> +    # An empty keyring should NOT be used for verification.
>
>      log_info "Keyring state (should be empty and sealed):"
>      list_keyring_keys
> --
> 2.47.3
>
>

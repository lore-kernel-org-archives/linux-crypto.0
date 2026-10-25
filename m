Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792890307;
	b=DATn0wNvNbtQVAYkH/RHrnUsK46MW/bcwVP9TYoLhu+9YqT9LBQFHjhn07YgYpa44DgX
	 kX2JT7zoZyg8RqwbgkimHsKQUdKlEimIWaN5b17zfWBQNvHBLtaNjzUvX8EAcVBrVtpqY
	 cu6xNMhAcq2NejTU/iouow32C9+sadg57Ylsy7EMgD+YQa9DEWQPEjbjbA4pHcyzRief9
	 jXBpRd5UKays0oNXg3ot5YRT2ODmrEJ4zKxGeMW5TkIoucxrxBybTqdyK8DZkkiZNX9Uf
	 qtaJ2JH+0VZPSiec9lbogYdB463P1/Q9DyFu9xepGdeOoot/aulQJIAVWZJ8oQ0ajcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792890307;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aTC397QvzS7RPDEFjW14JHlImiPoaTHVxqtkssvt3Ws=;
	b=l2KbeyU/dkpk3c04P2jpcw7UYI9k3r/WcvXaOJLbaQlQUNfj7wKQRKAJswKU4OK6Qh37
	 y45cMA33Iv8Vnvio7pFl3QJ09nlsgDQTgtD56N9tXv0G8h7T35FRs5r9vWUfAhSQauTKD
	 /SxdmfbBkAtO9CEGYQV7Tg0ro+v9txapk5tLXzKHJCqP6fcTPv+6+jtQIORilvuplzCy8
	 YRTncPy/RPadAjhQIXkwFGr1vwMVqSrhTk77vzT5XfwbQK33OtfHTd1I72eQ8Z+yT3zZo
	 lpPMuHTRdoGzl8Rq6FOEk6X9GAG3aYvwZPD5VGdd+5c2EJfB3ynuS+jKvdRtIgPQLJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RmUVRrvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900A5606A31A;
	Sun, 25 Oct 2026 01:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RmUVRrvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF61F01825;
	Sun, 25 Oct 2026 01:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792890307;
	bh=aTC397QvzS7RPDEFjW14JHlImiPoaTHVxqtkssvt3Ws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RmUVRrvqp54OoSmXU0GF+1ktahkrCXMGspCi/2dS5YT7BZqFSZsvunglZUPdtt9d4
	 WlTWSaq/aHyJ7am7qvwHN60gDAkN0oO56pjlQywmtWWDAsC+Ot5bCPWGfMocCtmuG2
	 dt9TQsB+NnP6YYZoHxIs9yC9dlOa1nNPloh+SB346pafrvQyhz9WO8NGQvCRIPbzh8
	 j+I6QTKQar/HTRysgotJdiLjbTHcCA+nP68pJ518T0+eVekquRlR4nUTttWpTdAwOK
	 TSKzF3ay9qI9BDF8BRkwHRi4M+CRHE0ZvA4cGFN8IGdwMt9749pFzpHzsodVfEAf0Q
	 JiqMdwPk+zwAQ==
Message-ID: <sashiko-outbox-183965@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "David Howells" <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, "Linus Torvalds" <torvalds@linux-foundation.org>, "Eric
 Biggers" <ebiggers@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Thomas
 Graf" <tgraf@suug.ch>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, =?utf-8?b?b3BlbiBsaXN0OlJIQVNIVEFCTEU=?= <linux-crypto@vger.kernel.org>,
 =?utf-8?b?b3BlbiBsaXN0OlNFQ1VSSVRZIFNVQlNZU1RFTQ==?= <linux-security-module@vger.kernel.org>
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
 <20261025001105.1824178-6-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 01:05:06 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] keys: build failure in bpf_lookup_keyring() after removing struct k=
ey.keys
--

commit 65b3c94e1ad80dd7e23ce523a687b926fdca188c
Author: Jarkko Sakkinen <jarkko@kernel.org>

KEYS: Replace assoc_array with rhashtable

This commit replaces the associative array implementation in the keyring
subsystem with rhashtable and an RCU-protected list using keyring_index and
keyring_link structures.

> diff --git a/include/linux/key.h b/include/linux/key.h
> index 20ca43f5eab1f..597131e150186 100644
> --- a/include/linux/key.h
> +++ b/include/linux/key.h

[ ... ]

> @@ -271,7 +260,7 @@ struct key {
>  		struct {
>  			/* Keyring bits */
>  			struct list_head name_link;
> -			struct assoc_array keys;
> +			struct keyring_index __rcu *index;
>  		};
>  	};

[Severity: Low]
Does removing the keys member from struct key break the build in
kernel/bpf/keys.c when both keys and bpf syscall support are enabled?

While commit 99fefa08474b ("KEYS: Introduce keyring_is_empty()") converted
dm-verity and fs-verity to use keyring_is_empty(), bpf_lookup_keyring() in
kernel/bpf/keys.c still accesses bpf_keyring->keys.nr_leaves_on_tree:

kernel/bpf/keys.c:bpf_lookup_keyring() {
	struct bpf_key *bkey;

	if (!bpf_keyring)
		return NULL;
	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
	    !READ_ONCE(bpf_keyring->restrict_link))
		return NULL;
	...
}

Should bpf_lookup_keyring() be updated to call keyring_is_empty(bpf_keyring)
instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025001105.1824=
178-1-jarkko@kernel.org?part=3D5

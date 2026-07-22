Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AD9481AAE
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 11:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784719816; cv=pass; b=Q9FW1NIRm6iwhILD0r6G/Yre3G26hhrNXwWXFMbrGWVUdE86V2YFmMFVDmHEAPzRqDqDH3o4QhC2tILI66lzTYO0cJNrYkhTN2TwwS2In6CPyJFgnKazYyrBQuJSy/pv2u0xNN9STUUb3vhH0MNfdIX7to9AdCtNR0z8nqmTZ7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784719816; c=relaxed/simple;
	bh=E+njPgvKf12mFz9T91Y9Xx9bUOKnyTcHbcFeNY1Wl3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MJ+5Q6NkZQ7Tp/ZtZnkItlfsAupt6oSkg9d4e7kbyolvhw3EhtCkg/qZ7xmdcRTTFao5XQ9WBE4YsmjgTlPhcDZRYuacPw+y9pCiIqIhUzc21l6m0iNj1IQVFSu+HcGTHLBezWHGqaBbg/LfHYP4LIamNS83oufIE3USeXcTdyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTY9fOqE; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTY9fOqE"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso4545075a34.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 04:30:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784719811; cv=none;
        d=google.com; s=arc-20260327;
        b=mlkAGBh6tUXihlGszIryJgnyt7mJqQsGx2KyCxtOfN0yUq37DyR/liwf/hHyagh9XZ
         n75k3Jaz8qkkANh6cZV+pdlysDdaczQ8MjeXWLu/5+1J14kthhPj+55RtrYNz2aUe3BQ
         qh3XQOP2CmTXzvknJRJK8kyHqLVTuZmdMw7vuMhXSqL2+ZQlDa4khVDy5OxZP63ZARUI
         74C8N1wZFZHHi1cE7H+dly3XpDTs33FVgMwrDm6NWTMH9jkNt3cCe3vZ9gTB8mcP75Uy
         dt2/7oOA6Rn+dQwL3+yRF+A7GgWK+OVUdnfHsGX711f7TCSvwZUZyo8XjBQv8Qr5RdMg
         SrwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jDBle99E/HW8ioCSHAc0fkWAWZq+NTNUR1CKDVDo7Ik=;
        fh=ZDXB8364RSBcwx3SzDfs4Hxs6RnWgaT9/4CM3lcadY0=;
        b=Z+HpJQD9fhcpFdgZpZYAV3LwvMyxJR02nc0y5HL6jESk6lNvXWaHSGlBI6B/XYtYsP
         bTQasS5kHuUDP7y2hPhgOMaQxjRrhoH1NZ0n5r/R00UjWfUV/lnDMrNVBKxPTOffSP/3
         lxjVhPVdeVcFrRO9/na1gwEcGM/s43AVENtDXNKaAxf2FxZyDd05ZkqVyHMTzULoJsB4
         +Ada5+//gkuYSqMXK9Mo7id/Q/f4YQ8EE2AfSxyO7tsb8fLZ33SI4h4BqIhki9LhufLA
         SRV6UiTs+4AHkAjrkFRPGgAkT/j4aPe1lb/g3VIR+Kc4zcpv88TqN89PhFJUiT23MERA
         0O0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784719811; x=1785324611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jDBle99E/HW8ioCSHAc0fkWAWZq+NTNUR1CKDVDo7Ik=;
        b=VTY9fOqESmey/TAdPLg87XPJX4R2IgYyguIXnoPBMTNA5uOi1YlVWAZxakoYpYD2nd
         3vUaYUmluN0BMmmx7MRECKJAtWeYvzW/XhuXT+XJcd6+TdbnwxVX1llkWjI4iEchdoN5
         kVaF0LG1Xf0e5SYErkNM8wmjWphDwROUz3uU6IvAzZbOEYIC/DgQGT/U9jBN+qVVdsPw
         D9mLLJLz+Nf5kOQgm1M86WKZIPZpuFp5eNHoHu+D0/kZiNw4Cxw5vtf9ufgFEFTF6Lz8
         2bdovL8m0gSQxXVA6ZkE5yKqx0fpeYWdOz0K3aZoJbG/J0a+PcLTQJMlD3SgEj8Hhhik
         C66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784719811; x=1785324611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jDBle99E/HW8ioCSHAc0fkWAWZq+NTNUR1CKDVDo7Ik=;
        b=e3+KTtB4E4aIU34/2cKWXp7sJ+P+9Npcq7FOrHANiu/L2jLnYDJWgqUVaNmbvM25ED
         YsNtXZ4f+RxivvkDBhqP/JNtEmZ1Q6S1XUbzdjpeabEIpsigjtx+46eIHylvurqXavi5
         gxOFZZ6+rboDyHqEmLDs3SRx4kpykIrW/g8i0kkobwfvLa6KVt+z2Ztcep+K6sZITD1e
         Mi+0q22r3En+Vg50EmkoWKrTQozJRvmwY1baPinNwEcyuTqkfJr4cHCuD5Ks4D5Ab3Gu
         NATG8g6GleswPFK0tPd946HnSpH8ALAjjJshRZ2l52wj4Rth3lQT5Q0K96OR/d3afRLQ
         4UzA==
X-Forwarded-Encrypted: i=1; AHgh+Rpigi2BndKFhLHwU+8MOEv/Xv2f11J67shfSFa4mvZBoY8Ui8cRxtY6N9SmI3s1I0GX8FAZRWnIUlqxN+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEZdWuZhxETk2hWnubw1BjcwSn7OQyLxcoCQwrYgOyQ8zlBpw6
	rI2BBwHcFBxRj0lwNfEwvhnvVBqKH9z7UDIfpIjZf9xE0XPaKz1oHs6T3vA2YtlV4BteVdy4bJl
	4tnizLGnzfzNZBkMEubz4aeTxkZneRdo=
X-Gm-Gg: AR+sD13AqpoYMnslasWSt0MnP76YpyT2JU2sEwsPs62j+2AkI4D7b1ih5p13FplZJxj
	Fto3mphn5nVRgTldKypGtL89bV4iVuWKRj/x8db2HLAFyzi3NeKne4mjQgjUO/S1jHacyMX6069
	7BkwNB6vnmLK1L/chZyqz+I48u2J3vKpF91+eCqHtyWbxNKw78+rY0WIrNu7ft3BrRjysmNOoeE
	RowDho6WcKeVtb9vvOXyVQ8vaVpYziXHRTK/sEH691KTPuECR67ehEdOamswh6p
X-Received: by 2002:a05:6830:4901:b0:7e6:deb1:485b with SMTP id
 46e09a7af769-7eda15447c6mr12694944a34.16.1784719810792; Wed, 22 Jul 2026
 04:30:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722102748.6292-1-fw@strlen.de>
In-Reply-To: <20260722102748.6292-1-fw@strlen.de>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Wed, 22 Jul 2026 16:29:58 +0500
X-Gm-Features: AUfX_mwqiKljb7IdXZ3qLLDAI-dbk1Fkmp_opzXsxrHUURKgEVN4rnTaTwEiHPY
Message-ID: <CABXGCsMpDtmuGPUg9_P9fnc6nsC-W1wb=Y_P9N=-1tZ=J7oBnQ@mail.gmail.com>
Subject: Re: [PATCH] rhashtable: fix false-positive lockdep splat on rhltable destruction
To: Florian Westphal <fw@strlen.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 3:27=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Blamed commit removed ht->mutex usage during destruction but forgot to
> switch rhashtable_free_one() to rcu_dereference_raw(), this triggers a
> lockdep splat when an rhltable gets zapped.
>
> Fixes: 09ae540e1d5c ("rhashtable: drop ht->mutex in rhashtable_free_and_d=
estroy()")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  lib/rhashtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 40cfb38ac919..68de5019abbf 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -1260,7 +1260,7 @@ static void rhashtable_free_one(struct rhashtable *=
ht, struct rhash_head *obj,
>         list =3D container_of(obj, struct rhlist_head, rhead);
>         do {
>                 obj =3D &list->rhead;
> -               list =3D rht_dereference(list->next, ht);
> +               list =3D rcu_dereference_raw(list->next);
>                 free_fn(rht_obj(ht, obj), arg);
>         } while (list);
>  }
> --
> 2.54.0
>

Correct, and thanks for catching it. rhashtable_free_one() returns
early for !ht->rhlist, so the simple_xattrs users that motivated
09ae540e1d5c never reach the rht_dereference() -- I missed it when
auditing the teardown path.

I re-checked the remaining dereferences reachable from
rhashtable_free_and_destroy(); this was the last one still requiring
ht->mutex.

Reviewed-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

--=20
Best Regards,
Mike Gavrilov.

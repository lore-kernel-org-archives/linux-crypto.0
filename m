Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793252955;
	b=B8/La1K0sUbuY290foGquvd+aPmzIHUcCSU6o2c6cHTYSGMgWU79UgYZUc791lc1P5IU
	 jUmhEyjhNXQ9S1XSGd3co2Q20KxVB/7DYwce+g4SwDzKMh2Eem244NB0w1Wx0NIzpvBBa
	 bOg54ToaD03CLnPlzw/Hii7EJDxnoTPrzb6d7+hn7tP3JvYx5VSVUDhJysdcDdgKfZvQC
	 IRDOmhJuUNeGsTkCmbRAnn88HGtlq+zoOVdR9bSKyE/nPAxODzSCQcBHDd5E8kknjU5vX
	 ysnk90M5zBvLGvdzQj/YCBjtMQiUMwzgK5AWjpxDlve59xXuWN8xoxrq1EeI64YhlzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252955;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
	b=J7BT/ccoLPRfGvO9nn4JEetX9oKplHObhcG5GPT6YW4Xq35XLrxq7dFE6K4sBEAJ3dHM
	 bZlIsec+F2WNsa/pwSm61wH990wH/UnzDFrBM1Gyf9YlveLXK45QCAin5qrj5azZ7kow5
	 Uiz51IcYDFLrW/8iq7PaRHVjxlmJNgCyXnnnhtp9Ahv9KNKh0eSrQkdBpaOMGSv3d5/qQ
	 p3dbxwQW+/EBhAvTZhkXGX//potJ0PvhPUQ7yFRdLsyrZclMSGjTJ0SRGkAwnR7N8kKLH
	 HVrwDU/itMRb1HL6kpFQdUI+YeeDAJy0YTEX7BMt7KGwBAsoyElEqycrrtvi3F/6miQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vW390GVU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22451606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22451606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vW390GVU
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bfa7c09c9eso1429529e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 22:49:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793252953; cv=none;
        d=google.com; s=arc-20260327;
        b=rDB5ffJ9MwiBqmhUW+7fkWxzyAakAy48v3oY73Pgou3yqfBPY7XTJr5KSObqrq3Euv
         /Y469niGZBbxLErpR29v6m704a3JOzP0pbtw2hz4NfaIHm6KmoLrOqaXQbHfZG0j+4rn
         Cz6jgkY5kQlKYYZCuLACMAQ0Yf3K0/c5jT9UVHsu5y/+YuWK3o9nfBxBIkKIg7OvoA3w
         8fLzFZA96M7Df7bv4w5Z+cF5eM/fuBf5Dk9bwG1B5VKgllw1p261ywMkn6t4TDsz+THc
         Ccgv+OL6WE1+f/8sNLA+jxOaw8RzDwPfCthnxyfXUn6alYjnbAXohXrsPhuRSov3NFhN
         hqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        fh=FK7PlYIP3gk+XBzIBGekMRfuqePAt/hqz/NiAUDL8uM=;
        b=mQE526+9iV4/8LOVRymMn70+f3xwulmhwnxbADsH5hXZWvUraYfRZe5tSOzfGD6jHr
         wlInC4pNcioXMNpwh03Aloldso4CRKVBJ6vIUwn/zgUsh9J3nDCMZ9zyRJmUbbiMIEUH
         erkaNeCTNwmOLlLsEs0KHPQdf9Ytym59iGo0Bi5tRVkhpkwMuqbdOtfAj2u3N9Lny9Rl
         VVl2oLnDiZN4I75Q3HI/7Yoyk9rDZW1S9q/VTl3TplMpPIY3jg0+Vk1Eo2l0bLMQOYAs
         AgFjXSzvn3UzTMAaYDYi/yxhxjdpg3sPXF1Rlp3qBMLb0turN+PHMUX6xG1rUHZZic3r
         bRlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793252953; x=1793857753; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        b=vW390GVUfO++wwC1mU1b0X+IOmz12pvvXxgyVIl/Zl6EuLMaJl8fBmUm34C9VnpSe5
         Sjb9Zex6kHNnsyZC1guapYs34bCoprr1dfZigeB1KaHMLpfrrxUvGXKmuSbpWU5UtTsD
         OQw4f2rQv53XMPqkjtj5pmz4GEUO3B0U58SrHpTJzeJmw0VcF8E9G00oL4BI34u15kmm
         la783RI0gVgXTixMdNhEBNs1ys/8z4AvnAUoO1ZJzALtOEIA+neQRxFdI3wsAURWVR/L
         oxAIWN+3rGtZn77eEGILq4ZzCTRRePnchPUjKfebpmmUMmrv4a7KUj3sJlZkkiGDhZZw
         tEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793252953; x=1793857753;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qO35EV0mnWV9G43hoQX9fpVz/YShAelE6s2Ci5t7qJQ=;
        b=Sd5RHAq/BLVWH/Awc7R1exjNB5DFVtCEjYk9lhxcrjHrJyJf0bSS9j5xIekdXAZzPl
         vZgYvHHDWs4dT7nqgn5EK/eUYKD5k5vSsk2HCeMYk+1y83n/XDi0+kdpmXWDhvyzDtj/
         QZOAnBjstpZaVgthA4ayX8EAUkuvSetBQ6yH2DsRbkvvoyrcRQCYwqhMogeMgNq9DM8y
         GcrPjy28z1xCQOCcTkdkn71iQl22lqUFEnFcZn6ckDJZHGI6P4rHXBNiiw4Qrt79PsVW
         tkNuU+0d99Rl3QtxIepELRZ2uzSt0OoOPbUFkYtQFPv2HRCYpeEGCjwvowquIJRV60fu
         9/xA==
X-Forwarded-Encrypted: i=1; AKwUvBycXd1NzcTaCvktsAgffONCmOOV+p0visKyW7miyEAb8a9jc11YgrW8S8MFxTzWUKIIy7Q9qa7OkPJ6TGg=@vger.kernel.org
X-Gm-Message-State: AFq9FYLoBrBh1/MtFbLl140InCObFqOpC6AA9uUD+96Ut4Z3WB52NBd4
	l9cLxjaf8esWn6wOcmUvys4g8sTLwRUpcQ6afpbW9frId8v8gGrNdMsTjHyB5JDr+9g/NzcTQJq
	P4I+ABinI/BS3U/DHqL7UdJZuQI6QzpM=
X-Gm-Gg: AYBFou2IpVpEaozvjKDCgtYKZ3jlaJrVrplgjqiTWgS+YCqtMaEYT3IOrWAlPXHqrZ0
	nEaSqXk0FQ63xf6XUBMlF37C9x/u911+0atwt+lJEaLKlEedJA3RAbYMuDkNFLUkc4HPvAl6Rw3
	vXbgc7p2MPSC+OUZ63BCl7FhTSwLtPSAETCEieQrrSMgE9biYDHnhYOvCeEsQEiXX+52jvXuw94
	7weGn3q2bWm/dUjoAhtyzvf/q1GdXShUeKxwRlbzYtLBlElM5sM9hP7YlFUCXKiIhodl3sPrQ3M
	gZejttwxo2rbAFY0/SxapfzmRkDNfMNWkAlL/4uqeTF6yMdnc4JHvoClopkghJ7bxNUvelussC6
	ptRmp6eF2Z6ItD7XGol8UluWaTia3v0Beulnu
X-Received: by 2002:a05:6512:3e22:b0:5bf:ce85:4d55 with SMTP id
 2adb3069b0e04-5bfce854e61mr1159757e87.33.1793252953140; Wed, 28 Oct 2026
 22:49:13 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188656@kernel.org>
In-Reply-To: <sashiko-outbox-188656@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Wed, 28 Oct 2026 22:49:00 -0700
X-Gm-Features: AclHuK86TsSiLkFwQ-i4UWDD9J3s6NPe_Yms66pEsTQGm5NwMn9Bd4NlQj7Tw6c
Message-ID: <CACpmpocJNk=WEE0_MiRUoWNJGS9wy7inKQ2pM6kNrdxaxgt0qA@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] crypto: acomp: broken type check and async gate in crypto_acom=
p_batch_size()
> --
>
> commit a38b95e87019ff2c11b51ebf159a082ec340456f
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size member to struct acomp_alg and introduces
> crypto_acomp_batch_size() so callers such as zswap can query the maximum
> number of requests an acomp algorithm can process in a batch.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c55b0e8eff3d8..8e285cb7477e9 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +             (crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG=
_TYPE_ACOMPRESS)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
>
> [Severity: Medium]
> Does the cra_flags check in crypto_acomp_batch_size() distinguish
> struct acomp_alg from struct scomp_alg as intended?
>
> In include/linux/crypto.h, algorithm types are 4-bit values under
> CRYPTO_ALG_TYPE_MASK rather than single-bit flags:
>
>     #define CRYPTO_ALG_TYPE_MASK                0x0000000f
>     ...
>     #define CRYPTO_ALG_TYPE_ACOMPRESS   0x0000000a
>     #define CRYPTO_ALG_TYPE_SCOMPRESS   0x0000000b
>
> Because (0x0b & 0x0a) =3D=3D 0x0a, testing cra_flags & CRYPTO_ALG_TYPE_AC=
OMPRESS
> without masking by CRYPTO_ALG_TYPE_MASK evaluates to true for both
> CRYPTO_ALG_TYPE_ACOMPRESS and CRYPTO_ALG_TYPE_SCOMPRESS.
>
> A struct crypto_acomp *tfm allocated via crypto_alloc_acomp() can wrap ei=
ther
> a struct acomp_alg or a struct scomp_alg. If an scomp_alg has CRYPTO_ALG_=
ASYNC
> set in cra_flags (or if the acomp_is_async(tfm) check is removed), callin=
g
> crypto_acomp_alg(tfm) performs container_of() to struct acomp_alg on a
> struct scomp_alg and reads alg->batch_size from unrelated memory inside
> struct scomp_alg::streams.
>
> Elsewhere in crypto/acompress.c, such as in crypto_acomp_init_tfm():
>
>     if (tfm->__crt_alg->cra_type !=3D &crypto_acomp_type)
>         return crypto_init_scomp_ops_async(tfm);
>
> the code checks cra_type =3D=3D &crypto_acomp_type (or masks cra_flags wi=
th
> CRYPTO_ALG_TYPE_MASK before comparing against CRYPTO_ALG_TYPE_ACOMPRESS) =
to
> verify that the tfm is backed by a struct acomp_alg.

Thanks for suggesting this. I will mask cra_flags with
CRYPTO_ALG_TYPE_MASK before the comparison.

>
> Also, should crypto_acomp_batch_size() gate on acomp_is_async(tfm)? A
> synchronous struct acomp_alg registered via crypto_register_acomp() does =
not
> set CRYPTO_ALG_ASYNC, which causes crypto_acomp_batch_size() to always re=
turn 1
> even when batch_size > 1, whereas segmented request handling in
> crypto_acomp_compress() and acomp_do_req_chain() checks
> crypto_acomp_req_seg(tfm) (CRYPTO_ALG_REQ_SEG) instead.

This is a good question. When the patch was initially planned, the
intended algorithm for batch_size > 1 was async, that too for zswap to
know how much memory to allocate for batching resources. Plus, we did
not want to impose strong semantics between batch_size and
segmentation for synchronous algorithms. The only known usage model
for batch_size > 1 was for async, hence the gate to prevent unintended
side effects until we know more about how to evolve this.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D4

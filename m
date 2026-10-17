Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF335674A
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 05:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213349; cv=pass; b=Rd6aQSn5HDpGrah9soixzT2kkVCrcBCQ+GmDN75CovMN/AixGkv5xpTkwe90X4h4eVm3x5VavLXHMF6ZwKv3pjrSCJpXp8iMgQWvolh3ku8XwyGf9DFLeui6Wi8J1IfmaGTDbWDNbvyTms6rZNlkVapwk+6vUgxWT2I1bKyQFxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213349; c=relaxed/simple;
	bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u3mBySqByru8WORy2DyVKq4MXelTj48blprtHCZmkJiZkBu3PTNb/XNYL6evDMXcr2kF50QuBr3ctSi8gHs/l39kXxoU3UKhF8m/JuvNZMZ/cdl71QnnSjqfh2oLY5NJSlTqz4FfaanS2vQ7FXtdetUVuNxMbGFhCF4RneWepjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjSvgtjL; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjSvgtjL"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ba35c0df4fso586066e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 22:02:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792213346; cv=none;
        d=google.com; s=arc-20260327;
        b=Ig15ATLh77BamukftEIHECh+JBnboenpLyugGBLuTlfCQBFjC4f9271/Od8O3OIfIm
         z1zBnIqHNFBgF0WHcanwj7QcchcWa7gpvTLPvyAGwK6VLnFyDhqbh+B9/i9F9xsU56W2
         cYLBGQXHZ30SD2RGbMalrPwdQas7YogWtSELS6GckUOyPUnBJIj6WzEZjh1Nt5CroWIc
         L6y3ehA8hxc9/eRSbMDDS3RHFO9I50DGFpwAa3xcQ8QqNx2tXGM9WBanCt4M9kY3/090
         ruRXHNXAleU+5tTYGFo+Xy3QdLijAytB5EGJIjmyJzt/Oipq+01mJVKdeuFw9o5V/JI+
         J08Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        fh=mfQxfXrQDbaBw7ScRlF8RFlWAr8/rBBBxx9Ych8yQ3s=;
        b=cwSV48m6c8bbLB/gaBBEvAD0FFXF2fG9pyCtOLk7KwoaaoRgG7uPZWWFOJCw46Wt2x
         q4GMzQ7jmdgCSrNECrrHVtbkUFaGoZA1gcgSOEbec2u3y+AYDbYbFEqF7zWXqb0HBRV5
         kXHTNmD5H+zNUEt3R9JWQYmaGgd8WFTLHn6rtVvgMchtZ3Dv2MEes/vdb1NDOiSj9vyd
         eQd0GL2nooNqgdU/JEM6nQGuouZ3lSJIuDGnHiWclEFZ8oslzkweNPsBOdJ6YcnssidO
         fiv5bLFEaDros5QknBx5kMIbbsRvlcJIr6NTkTB0dJ8JHq1KoDLeGzVww8L4Mzhk/zxb
         i2yQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213346; x=1792818146; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        b=KjSvgtjLMx0CCk7ab5oGQSnBpSJewW7IMuy5thAfPce3K129hQosuFKvuzZTzfy7BH
         d6pJQUI2veGQNA9KG6Cs0ROV35LGJf95okA9KThBXnuEl78g+mRgiB8utWcef2Nn4R1M
         kiyZ9cXU9GPcld5jre20eBkL7Hr7ErTsWVncghjGgZ8u2OdwmvwlQ7egKLU/q4fxdIuj
         Xydu0sA6E5M2/cK8m8m+UODHd0Vz+VRWLjWrkPcoaLrDxDM5672EYK9KkTSzIksSmy8v
         Y5ENIrS7K10VUvWvzea4MirvGRlNbneiIQ029sbfCcAtq+pZpAHXzmNFSlxJNFN3PuwY
         S2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213346; x=1792818146;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qA4ufMq4NgXLgUYdkQ43Xh3EEM7qAnRV0fG7/RHdhqY=;
        b=HvbRNxvHlXnGzKF9ICXl4KOKTLMizV4MD0l+P7Na4CduGH88iP8JlOCSuGLTNw1b3r
         TFxpyYaCavOvvcqTibMRisNrCidbqG2+Xk2vv/Nki5fWklJWRVHVu4NndIYCl0npfYP1
         3NfijffaMGZsGLHOcxtjKPNjggmCnfqDleWA/5h+32r58VSWzYSdk48bhS2MWlkD0gHZ
         ThO0U9bZcWcqmrVr+iTJ5r9OKpLrOGsXdWN7AxsFaI4Y8Nn3XANghO/tbD6pYhZqRrhO
         iq4L7X1Wg25olvnbTMVoO122Nun69XwRz7HT3kv9c/vJYYbExDM/Fw2L01urY5m6uPfN
         if6Q==
X-Forwarded-Encrypted: i=1; AKwUvBytds/fJhN5mMdE1zMdK5BGVNyICiMkL0f6PrMbSsxsxh9ITIJjLoR9xBdr9fM3jq6Pv596yoWG9ZzLgnA=@vger.kernel.org
X-Gm-Message-State: AFq9FYLuyLnFt05yJQqo2pznq5boucmWDpnq3LZ3NKHKNFWIKUslMuaW
	Zt52raqa+SPk7NHztVa9/h44ZToRa73I9fVU19GFSF56c7c0b8DpnMxnMdNx5qyHnKH5915E8TS
	rwhsUSHUgZNlA/SOgVIQtZz5SFMlrxOA=
X-Gm-Gg: AYBFou3c42mvDUq+ldjUEu1RFtW6P+cXwmKTroLX09x07/Kdni/u4VRyII4XYcT7SSX
	7CHdZKgwwrlddNJkOcXAvxoON3VDu1x3tzaKO9Rm6IwdwNrTGaAHWXuILV7eYVUDceTqtE1QzGk
	yen3Xvj+k9BZD3b25FSukrfxfEOWZv5hpvIVlv3oTyb4enQe9ja3ekw3aM0n+bNwcbQsjn2/Tdo
	H3ByNVkf/kv65KJ2S9H6jIgO+v6KSK7/RVbA/hNNONJeE5NY76DGrD3s79ufO5WyErmyMV1r5CC
	DAYpNsianb+Gaa/OIWMh+ePSUYgdJpDYnj2ugPwaE88JEmdYVACZKuk=
X-Received: by 2002:a05:6512:3b24:b0:5be:3f7e:7409 with SMTP id
 2adb3069b0e04-5be50a71003mr464282e87.43.1792213345431; Fri, 16 Oct 2026
 22:02:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au> <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
In-Reply-To: <atL1ok1YkHbA4AaI@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 22:02:13 -0700
X-Gm-Features: AclHuK83Cy-eJhLJZxzQLRm52k6Crd7V4JEX6EsZtttKAdEO7DhI1ttSz_5rhrM
Message-ID: <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 9:12=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Fri, Oct 16, 2026 at 08:03:07PM -0700, Kanchana P. Sridhar wrote:
> >
> > The Average throughput of 10 iterations usemem is 19,058 KB/s. IOW, I
> > don't get the same performance boost as making the localized change in
> > crypto_acomp_compress(), likely because of added computes per compress
> > call (one function call, two conditionals).
>
> What are we comparing against?

Sorry, I should have clarified! The comparison is against having the
conditional and short-circuit in crypto_acomp_compress() [1]. I was
referring to this as the "localized change in crypto_acomp_compress".

10 iterations usemem Average throughput with Conditional &
short-circuit placement in:

crypto_acomp_compress(): 20,946 KB/s
acomp_do_req_chain(): 19,058 KB/s

>
> The thing is that the conditional will have to be there at some
> point as otherwise this becomes pointless.
>
> What if you just do the conditional and short-circuit in
> crypto_acomp_compress?

Yes, this is the first option I tried (20,946 KB/s).

[1]:

int crypto_acomp_compress(struct acomp_req *req)
{
struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);

if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
return -EAGAIN;

if (likely(req->unit_size && acomp_request_issg(req))) {
if (likely(!crypto_acomp_req_seg(tfm))) {
int err =3D tfm->compress(req);

req->dst->length =3D unlikely(err) ? err : req->dlen;
return err;
}

return tfm->compress(req);
}

if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
return tfm->compress(req);

return acomp_do_req_chain(req, true);
}

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

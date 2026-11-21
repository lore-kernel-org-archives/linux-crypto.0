Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795296147;
	b=KWcMdvBMvEI+Q5w9IHLvFb4qCmzeZgpQ9Jgdvi3ap4pbcpH849JWaNeu6dwXygOc7i5u
	 5irRjo2iQgJT9NdMLGUIH6p8V7oNhmLc7ISuvFP23cHkK3q6PiFw5btpgZHq+tgmtX4lU
	 1Sz1m4lcvkHxxSYt7+FmIisMLmbB+lNdgFN8BTc4PZlL4d7AgwFIFno4j9oIDbd33g6gD
	 aF0grTbRn5LWooYVRm42jzuDU3fVRtJaAb7CEfYkfg4EDRwg171+0inPI2Z6oDQoJsnU1
	 qHUSloT6Lq1l8ENtY+5NBUhQg9XXn0Ic3mF3/s+3fSJQsNPIH0wn0YN7g3JmHOvQnzQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
	b=hbIhUgVMF0cqgsbbj68xnntWCy9NySX7S/x3q2XdtfFuRyu/Stz+bggZ6RwTJ36FL2Vm
	 rNvSqmBdDML7/9QAFhd0nWqLWpN9ul4xuOcjRcJZAuTiO+W/MmVFKc2YUHrALb5DHb2/Y
	 R5FyMLnn0t2aCULxv5aai/OeatwNU7ETokHdfdL+nK6/NLAR4a5mZDHqa3nBjzXEiXUpx
	 pNLjyAhOLjn4H1VrSCGe85BZLRpgJdGRogH8/qlMYIrt6tnFJwuepfhIYox6PzrLGLifH
	 vTs+tAkdCUPNmlz96eyfZHVjLv9doPGf4KyLefInVnV2dzn5R+zI1/4vcUWzelkngBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c2j2Fvr2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0D2606A320
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 21:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C0D2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c2j2Fvr2
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so1778657e87.1
        for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 13:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296145; cv=none;
        d=google.com; s=arc-20260327;
        b=kdSNFnnVsmBWInGb56g24BXSxVMSkRRv3Ppj0kT5XBFw6/e2fH1+IQSyj9kZsrmjQ+
         qFqLTGla+plGEGnjeVo+mjSy6s/XZbggq0fnMajn/kXB2DbKPJXcRAZDl3ABFR9tzBuf
         Sp+wCIz98Wu4di7FhGIX8TzaqaSY3yLBeKOkX+5v3ru/BWyqQFoEY+FjdcVlgL6QuRAo
         Jj76FogiJGRlMabKYu1/6++NNMLA+uNsu/mIu8MhEkYLl9IJR4R54RzyH4ZPGGMf4Emv
         y+yTvEZ98Y9KhfLekUFLpgUQ7gsOAqsRkyTQUwfhaD+RpCgFgGFf6ou7Nn9bR9yimHqz
         FECQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        fh=790PYzh+sD43vRSO2s4Ur20VsG0U6OQZDNWZbmSoBQo=;
        b=QTekba03JeP209lIjtaKtR4xul41MSIQ2ucyJxs0DM7/cfUcl2Bigrt35Or2TekyaR
         66gO9DQABv9beVqHRyCDcRHeOXwmnvT7dE5l6qou8OXjIg0o/9Ro8GveQfjZoDvc1H6H
         DuGLFW02hMjDSavBLkvAyrFGEUhSLZHGpgSF/gP4i5GMnz8M0shS4ec3YBGec75o8F6k
         tCpLqqRmMjS2oYAq2SREdUTqvesD8kwNra7z4twmeauJeKv8PWDKGa86b+A1fXDx1zAb
         coUJhhDW3pUAFpCJy614k5eSfQYENZ9co7cJWlEu7NKIu0vwjw7wlitkgGE7jUWM2ege
         5sBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296145; x=1795900945; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        b=c2j2Fvr2K8ve5i+Iv0L6BeihDG1SjPamORSooRNaevFOkY0zxyJ/Ex0pUN1XTAOtwr
         wG+XIzSG39NrYpMr4jgbJkjLQAk3zp3P8xgdWhghw6JT/X8C/HR0sybWciw4lwm+fAEo
         BDSydNfmZiV+3ntU7q6VfRTEq+6xFk35dQ7XFz0NzTWVyRLSeoVwjqfj02uNSF3PO+RB
         R1+lkaHhbVL784WXfTwKV+tymsstL90B5g33VDEuXZb1Er4QNKbocXnex+al4L+CjGha
         5fUBHQ+rq/u+hM98Agwj9Yde/zTVzre3OaxNFvX19Vxn5AjgMKNdN5mGSjIixjLwuxm+
         hqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296145; x=1795900945;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhcHhD/8aRKBI15ASV7ocqmrU70ZzMpPTnqr+rqSRik=;
        b=XzvGKZsA07SYfqnZDSCQ7ya8/rSFRPeBcPyQbsBgeezKlZ3D7hxJqpcCNShyIlxnT1
         D3zWX0rN63kyOKXhF0bhWH+veRUnEhhIh0hwY2FMv7ncCaYZaljI8Df+U9XiCUbOy2Uz
         MTbKHTxZlGwy+d47iXWVTOvyZrMxf477l0uUil5qKcp1p7U8MwGgT8NLVMuf/aIW7fye
         GhgMtPpoLUJutbdc1XLpz2pOdC4yhU2Vfd1jORhvi5CANLSEP8VXOgoKt4C8pfhD1+4b
         zw8m5ZvAIAZSis6810jbx+WCpw2/xf6y027Dakmsk2Mmgp1HpwsdaPmYG3Yb6OFLkvLL
         SgGg==
X-Forwarded-Encrypted: i=1; AL+hErHHYVcIe7/EOZ6ZxJ55YR2H4vrIZ6/lwYH+xVRkt54Qr8c7mum4DV8sGlzAm6L+J3DeksnQQRPRBnYXy0s=@vger.kernel.org
X-Gm-Message-State: APuU4Z8R0VY1Hgdu/5S5nnDOm1MUg3UwWw7AKLAFp8tLD6qheCLGnQQ3
	yMmVsOYklVu3Ltr8D+qwMJkUyK+qd6o+4PsuCX0uR6tg2qdrwgbCCcrxsaww6ccSKKOeBQuj0Ua
	sM8uN3vs+3wYmf3bdnHgBT4/ni09NylLXLSLo
X-Gm-Gg: AZFdTZfm0d886oZ3opFsekl8kSOotiqeAMNXDitwBCdFtDudjR3QsITDXKRRjE38ncS
	9a3SSKOasWn9aYCL+1abE6MQnPtemULmelAzi2A4jdSkajL+WteEC0vADQzPSY0TKxV3jy+2Vuu
	Xn4Y8NT/PxQ0hEUKHgYEc0auotMtmU0aHMOzqYspG8J+5t0pLh2HvQMv6DvWLMgW6+IEeKb8fsc
	WWZQgI+vB4TtzCYdB77QkzHqGA9CYE/bnV5FzoL0KN8sRrwImQF/YAJIl5rLbI7TPAsdJDHK01T
	nAsxg6EQjHLOxop/oF73IBsrmE6Ka43Te2YFbJRswMtaT6p1yYui5DFp229P6dtjAUMvlKwxdYJ
	QD7pZhITDzHXdT6KOJYCUDJgJFUciswadHN+0
X-Received: by 2002:a05:6512:3a86:b0:5be:590e:ea76 with SMTP id
 2adb3069b0e04-5c1bc680e86mr2302113e87.6.1795296145205; Sat, 21 Nov 2026
 13:22:25 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-5-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226634@kernel.org>
In-Reply-To: <sashiko-outbox-226634@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:12 -0800
X-Gm-Features: Aa3M54rocg5lImMNhqmcaG3bXPnzsrtWItRkXY1bhretNH8NzvJavMtXKNpuBjY
Message-ID: <CACpmpoc-OJoQ4hcKpF6muY+tf7NcP9ok+fGXQLog3dc1q__njA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] crypto: acomp - Add API to get a compression
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

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] crypto: acomp: crypto_acomp_batch_size() checks async instead
>   of req_seg
> --
>
> commit 4f8164105102abaa98a8641d32dd35c9cb223ee0
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add API to get a compression algorithm's batch-size.
>
> This commit adds a batch_size field to struct acomp_alg and introduces
> crypto_acomp_batch_size() so callers can query the maximum batch size sup=
ported
> by an acomp algorithm.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index ac4dc52668b89..df9e42f519c35 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
> >  }
> >  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> >
> > +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> > +{
> > +     if (acomp_is_async(tfm) &&
> > +         (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_ac=
omp_type)) {
> > +             struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> > +
> > +             if (alg && alg->batch_size > 1)
> > +                     return alg->batch_size;
> > +     }
> > +
> > +     return 1;
> > +}
> > +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
>
> [Severity: Medium]
> Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) instead =
of
> acomp_is_async(tfm)?
>
> crypto_acomp_compress() only dispatches segmented requests (where
> req->unit_size is set) to tfm->compress(req) when crypto_acomp_req_seg(tf=
m) is
> true, and otherwise sends them to acomp_do_req_chain(), which rejects
> multi-segment requests (req->slen > req->unit_size) with -ENOSYS:

v3 response:
As described in response to Sashiko's v2 comments, this is kept simple
for now and for the only known use-case which is acomp_is_async(tfm).

v2 response:
This is a good question. When the patch was initially planned, the
intended algorithm for batch_size > 1 was async, that too for zswap to
know how much memory to allocate for batching resources. Plus, we did
not want to impose strong semantics between batch_size and
segmentation for synchronous algorithms. The only known usage model
for batch_size > 1 was for async, hence the gate to prevent unintended
side effects until we know more about how to evolve this.

>
> crypto/acompress.c:crypto_acomp_compress() {
>     ...
>         if (req->unit_size && acomp_request_issg(req)) {
>                 if (!crypto_acomp_req_seg(tfm))
>                         return acomp_do_req_chain(req, true);
>
>                 return tfm->compress(req);
>         }
>     ...
> }
>
> If an asynchronous acomp_alg sets batch_size > 1 without CRYPTO_ALG_REQ_S=
EG,
> crypto_acomp_batch_size() returns alg->batch_size and callers such as zsw=
ap
> will submit multi-unit requests that fail with -ENOSYS.  Conversely, beca=
use
> base.cra_type =3D=3D &crypto_acomp_type already distinguishes struct acom=
p_alg from
> struct scomp_alg, requiring acomp_is_async(tfm) forces
> crypto_acomp_batch_size() to return 1 for a synchronous acomp_alg even wh=
en it
> sets CRYPTO_ALG_REQ_SEG and batch_size > 1.

In addition to the clarifications reiterated above, this is an
additional v2 7/8 response:

Excellent questions. For compressors for which compr_batch_size > 1,
i.e., zc->nr_batch_pages > 1, that batching algorithm's driver is
expected to test for req->slen > req->unit_size and use
req->slen/req->unit_size to ascertain the # of SG lists to process (in
the case of compression). Please refer to a reference implementation
in [1] and [2].

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-19-kanchana.p.sridhar@intel.com/

The crypto_acomp algorithms don't use
zc->comp_ctx->sg_table->sgl->length as inputs, these values are always
over-written as the output of compression (patch 3 in this series).




>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D4

Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208B6330B30
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786746591; cv=none; b=WsYXADi9gq/LMBLnqEpaftcYvQ4by7okLc/JNB/B5pMrK0e5G44G2uci7MfebIZIXXaqFKHa05XwW+nsP2IgKnaCZK83xTg8sTY7Rg7SAenubT2YE/uZPNpM8j2P5hn99Du58WUz+Sq/tadQdEdkUFMgw37xw2XOZfJs1ID2ucU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786746591; c=relaxed/simple;
	bh=007RVhNG3bzisB8QTh6oufkYCx+dZM4te2B2RVnhDkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eslo/N8IaJXk8z/rdwYif2BNpnjiuP5EzzMFStOUCvmJP8+jjNQyrPHlT10nC3DzkRnKqt/jNbhV+ZXdKbblqlBDiMYMM+zVB3WaNl+Xad5OSwOCf4NFwHNe8ExgbuowzJcIPvb0ZZ+JegHLMsC3N5gTKfthiLZbMcmSORyX+aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15e592da74so213317666b.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 15:29:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786746588; x=1787351388;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=waG0BdNRrEs0bEN8xb/gjEyGJq6U6CRZNm5O6yGz0BQ=;
        b=maYTYKNwfYO48+/L/ObHyjJXXxJLP6odoE8IKa7ieWyC0Cb1PihwfRjF3wG5iAQ1bU
         d1T7kCn4B4x8Rbsbn7UC/jLv9FBtL9ADS9ESvXY7aOwOgrXotL01D+yqWRn7YMJEM/Qb
         7rNcL1BnFsjqnw9fGR/fRKOf7TFNhZQUOVzGIrOzR2oueh429nlVqkvkgqsEMYHLEhbc
         88zCOny1013uw1xhQEau6HV7tmrEzzA+WBH7sls3IKOFHHT5qF9M2Rb6sFEXzFAzw3WG
         kcBZNNgOoSO3lpIN19S/qqC+HGx4sjoBCsxDgv3onX2wF6/vjqt11T+wGPrlF9pzkDqn
         8FjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp0oSAd5uwLz3hyJIjquq8g2ZVtTCG8VHECqC4qKxVK7/DHqbkmVqdEiEBWX9X5vclaiQujOSvCxRr8ycQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDv5YmA/9cM9fLIfJsRJTI02Q2Uihtk3sK4eSDZPL6hSpRAXow
	+FnwXCwN7hnO5g4YZS6D9KszX4z04P+viy2GNmPa2e8aGPtd8jWLy3attmpiVVyVGX4=
X-Gm-Gg: AR+sD11whNH8OcF4qCkChplU5fOb2qyW3i9Dn2vGvrqudbCJ6bl8vVbIOyC2mxA/C1d
	hKNIWnOZQEmntPeO75/yXvMlTkRcgZmTlW6Jhm60BkRu1OUOT+DfA0RYW20MKthXQl6glYk5yPS
	mVIot4bz2V09ukmmGMkv41awlp/srqYxo0S/wbbSVq0zKMz2mZ4qi07k4aKeuRJmsD54Kt4ljhA
	kTx7vsnwH+ewZ7kazHY6lyAIb9BBDj+wJhllzcaFVON4AD+dJNvqpbeKDLS+wkPEeic/CcsNxIs
	ITOTGn4kYoIGBxGTGGwLXrWG85ubOfjXPPl5ysgccv04mxNL+s1OhSdZ2pk7exT3SoMo7BKDopQ
	dD+A7CPyIphNvq4WUs/T8HgXxx+HAfZEKm73d6KaAQlvtfIvivL0xdH04F+MLeijFgWNUqA4V8k
	S7fD3+Dt5gQqFBc3e1L9a+zmoyEIV1V/6bI5kAAzBhOzBvW7LDp093vMbEVeQgePfxCT59oeYMo
	mpArx5zwIphKf2xMvc=
X-Received: by 2002:a17:907:3e96:b0:c20:af9d:4533 with SMTP id a640c23a62f3a-c212a2a3054mr392514466b.19.1786746588368;
        Fri, 14 Aug 2026 15:29:48 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c212378a3a8sm141706566b.38.2026.08.14.15.29.45
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 15:29:46 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c197e7e4e94so275408066b.2
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 15:29:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+APc7aNDDzgP4tdEzFlaycoOdVc1HOQEsEHA/NR7lx9wzuL7VSsmSXHFh1i6cpPxy1iSG7jTabWLT1ng=@vger.kernel.org
X-Received: by 2002:a17:907:d1b:b0:c20:3402:bd35 with SMTP id
 a640c23a62f3a-c212a15b29bmr481986966b.12.1786746585644; Fri, 14 Aug 2026
 15:29:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOs+rJXZ++7_o4L6LuT567FjdYsa=6NEki3qcFSRX+ehJxpoVg@mail.gmail.com>
 <20260814220631.1101496-1-fabrice.derepas@canonical.com>
In-Reply-To: <20260814220631.1101496-1-fabrice.derepas@canonical.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 14 Aug 2026 23:29:33 +0100
X-Gmail-Original-Message-ID: <CAOs+rJW1QymCXkr8-mU4kwMFvznnC98CXVvZMRjqpXwjJutdtA@mail.gmail.com>
X-Gm-Features: AcwNN1Xw9h6GNj0ibMyw5rWypoAatSz6xjvorf8gf94rjiZOoVeFiOOzG0DX_sA
Message-ID: <CAOs+rJW1QymCXkr8-mU4kwMFvznnC98CXVvZMRjqpXwjJutdtA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: asymmetric_keys - bound PE section ranges in pefile_parse_binary
To: Fabrice Derepas <fabrice.derepas@canonical.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 11:06=E2=80=AFPM Fabrice Derepas
<fabrice.derepas@canonical.com> wrote:
>
> pefile_digest_pe_contents() hashes each PE section with
>
>         crypto_shash_update(desc, pebuf + ctx->secs[i].data_addr,
>                             ctx->secs[i].raw_data_size);
>
> where both data_addr and raw_data_size come straight from the untrusted P=
E
> section table. pefile_parse_binary() bounds the section table's location
> but not the sections' data ranges, and nothing else on the path checks
> them. A section with data_addr and/or raw_data_size pointing outside the
> image therefore reads past the pelen-byte buffer (CWE-125); a large
> raw_data_size makes it read far past the end and fault.
>
> Commit f7dd32c5179d ("crypto: asymmetric_keys - fix OOB read in
> pefile_digest_pe_contents") recently fixed a sibling underflow in this sa=
me
> function (the hashed_bytes + certs_size trailer computation); the
> per-section read was left unchecked.
>
> The digest loop runs only after verify_pkcs7_signature() succeeds, so it
> requires a validly signed image -- but not an attacker signing key. The
> PKCS#7 signature covers the SpcIndirectDataContent (a self-contained dige=
st
> in the certificate table), not the live section bytes, so tampering
> data_addr in a publicly available signed image leaves the signature valid
> at that step while the out-of-bounds read fires when the digest is
> recomputed. It is thus reachable by a local CAP_SYS_BOOT user via
> kexec_file_load() with a tampered signed image; the access is an
> out-of-bounds read only, but a large raw_data_size faults, which is a
> denial of service when panic_on_oops is set.
>
> Validate each section's data range against the image when the section
> table is parsed, reusing the existing chkaddr() bounds macro. A malformed
> range is rejected with -ELIBBAD at parse time -- before signature
> verification and before any hashing -- so a bad image is never digested.
>
> Fixes: af316fc442ef ("pefile: Digest the PE binary and compare to the PKC=
S#7 data")
> Assisted-by: copilot-cli:claude-opus-4-6 frama-c
> Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
> ---
> v2:
>   - move the check into pefile_parse_binary() and reuse chkaddr(), per
>     Ignat Korchagin's review [1], so a malformed image is rejected at par=
se
>     time -- before signature verification and before hashing. v1 put the
>     check in the pefile_digest_pe_contents() section loop.
>   - because chkaddr() runs on every section, v2 also validates zero-size
>     (raw_data_size =3D=3D 0) sections, which v1 and the shipping digest l=
oop
>     skip. This only rejects a zero-size section whose data_addr points pa=
st
>     the image -- malformed input that real PEs never produce (.bss uses
>     PointerToRawData =3D 0, which passes) -- and matches the "don't start=
 on
>     malformed data" intent.
>
> [1] https://lore.kernel.org/all/CAOs+rJXZ++7_o4L6LuT567FjdYsa=3D6NEki3qcF=
SRX+ehJxpoVg@mail.gmail.com/
>
> Tested under KASAN (CONFIG_KASAN_GENERIC, x86-64) with a KUnit case that
> calls verify_pefile_signature() on real images: a signed-then-tampered

Same as your other patch - any reason not to include this KUnit case?

> image (a section's data_addr set to pelen) is now rejected with -ELIBBAD =
in
> pefile_parse_binary(), before verify_pkcs7_signature() and with no KASAN
> splat, while an untampered signed image passes parse and reaches the
> signature check (-ENOKEY, as the test key is not trusted in this build).
> v1's KASAN repro -- a crafted context taken straight into the digest loop=
 --
> showed the slab-out-of-bounds this prevents.
>
>  crypto/asymmetric_keys/verify_pefile.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_k=
eys/verify_pefile.c
> index cec99db14..c447597f7 100644
> --- a/crypto/asymmetric_keys/verify_pefile.c
> +++ b/crypto/asymmetric_keys/verify_pefile.c
> @@ -30,6 +30,7 @@ static int pefile_parse_binary(const void *pebuf, unsig=
ned int pelen,
>         const struct data_dirent *dde;
>         const struct section_header *sec;
>         size_t cursor, datalen =3D pelen;
> +       unsigned int loop;
>
>         kenter("");
>
> @@ -112,6 +113,14 @@ static int pefile_parse_binary(const void *pebuf, un=
signed int pelen,
>                 return -ELIBBAD;
>         ctx->secs =3D pebuf + cursor;
>
> +       /* pefile_digest_pe_contents() hashes each section's raw data usi=
ng
> +        * these fields directly; reject a section whose data range falls
> +        * outside the image so hashing never reads past the buffer.
> +        */
> +       for (loop =3D 0; loop < ctx->n_sections; loop++)

Looking at the code again: seems ctx->n_sections is user-controlled.
What happens if it is 0?

> +               chkaddr(0, ctx->secs[loop].data_addr,
> +                       ctx->secs[loop].raw_data_size);
> +
>         return 0;
>  }
>
>
> base-commit: d58772d8520c7ef247c4b95c9bd76d3a25da9ff5
> --
> 2.53.0
>
>

Ignat

Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AA2343890
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715645; cv=none; b=rTXjG4+H/LfZpPQ3uXMOZeyi5ch+hCDlRM/c1njlO2ct94Rnpn20ctLL1LWKmb5dpmp7JXPVXNXBxMOMDE8vvfCxBLvUQqU0dR6kJ0YlyskSK/XWKt8M9MalBUE8ElQOda2JhKsRnNMBnkncnQC1rrupVq4eDdlcmWme1Fv3/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715645; c=relaxed/simple;
	bh=HW4yLSvoZYZvQWXm5wsfQ6gd3IabSYpAM3gCA+OgMSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9sfmUpjcu+bH76G42j1qqKoJq8KXFkJKXbT+qpmAl0TiMIWUolWB948zigWxPh84Vl0J/ElO4CWfYag63mytXXBdzKptkpMkYsB5t1lWttWuP6vzqsf4GSQ25bErWk9bFsufEgGR+9z0fWZkcMTEjKOe5Ry/8DkVJ+xmYd+VzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.win
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a10b20634fso1783305a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 06:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786715640; x=1787320440;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=32UXxjqR1VKYvNK68Dz7f7JjofaG/JzH3ImA8OxnCM0=;
        b=sSrVjfdCL6m82YoLcj140EfkaXvtXHDzz+4Qp9zGUWuYd55AKSJaIK1Br0psv2qEtA
         0EzOEVglL1bQBc/hT9mbiliVY7/2viI0hTLwjshGafkiooUtw+houbES+I0HM6ZwZ15g
         S1cZTfLNCXQ3v4ETkwwyzgVd1v9pHeh4HizUQFRaV/6w4cPun/w/ce5zdS5rYHaFym5w
         LrsIomd6MRhISvwLSISEaj6JxDoSHT2nLgCRIk9f4Lm27dxyXAVqpEkxtwNQe94ZIZdd
         9aply1j6II24AbXVetuSLzZyx7EYT9i0mQTRuOz9ySuvTpSlJ7yVZC+KFKwIi1JKogux
         pN6Q==
X-Forwarded-Encrypted: i=1; AHgh+RolOMSZu/JSOfu4FiyKsQSfiPQ4aky329P8TcYnxEBRAdKlnEIMJGu3BEGMZ/BlIXX40WS+us+i3gOBsd4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNNOaX2lSUdkaCB9M6feYIRzmrj1VmHReFvS0NFuoZmcXrmmU/
	GdaCkHITuhLG6jU4r67s7tb05+fNBdgBEEDDEEfFUnBPh9LBfH+xQjqI1xfVbT1rmkM=
X-Gm-Gg: AR+sD10N7wkmjcwT0KMVPz3zwTBtNopxOdlHYATJ/nQLFPQ9LcBZ/TS2DU91NpguVS7
	c/Z+Z6T68LnsIx8KjGAq/gGdK/sx2VhR5HOgGDP9T4tfubXF2VDmYz48G9moOExKmRoLSrie5Vt
	isLg67xITKGQndU7YQjp+03TuVGvCrfyx2ZJ84oAowHVQEteFfU7yHLasRZKnuSkKGTRNJjCkCr
	QTuD/MsPxRjAMAKYKLxSMzJqfc2IJECMOdynO9LYCwDjJMfs5q1yDvX3APyLkjoMgqXyv7H7IOX
	kF5y4i5v821xr379JTDl/Asidnl3mAgz/YI/Zs/DNqpl9xej+Tsnz3lnVI1mHDnpquVNaNe77ER
	oY7HxyDmNo8y3bzbFZvaqZ9XMf4ZJl63BvuS0hJVYUSB3CTC20DcPdzir5YE0xdGTmsupawDG3Y
	0J+doENchoF2lX4+kn31bpPMc8iaITA3Mtbebkzvp+3EA49BALzCkD5Bq/JNVFsycQ41yay2uzE
	yKp0xtoNEs7KjW+XTngoxCVdQXMeg==
X-Received: by 2002:a17:907:a01:b0:c12:713b:e199 with SMTP id a640c23a62f3a-c212a208e57mr260909466b.25.1786715640428;
        Fri, 14 Aug 2026 06:54:00 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2123839c22sm100301166b.55.2026.08.14.06.53.59
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:53:59 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso131207666b.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 06:53:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrA6HtgtgbK3N1rr+lFkjFSn5GyCzqZDzTLWkCg31owXrP1+Q4Kh8IErmqv3J1L8AdpekuI/Yy5Zf4TLeo=@vger.kernel.org
X-Received: by 2002:a17:906:730f:b0:c12:aaec:342a with SMTP id
 a640c23a62f3a-c212a113efdmr280357366b.16.1786715639417; Fri, 14 Aug 2026
 06:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260813182546.138705-1-fabrice.derepas@canonical.com>
In-Reply-To: <20260813182546.138705-1-fabrice.derepas@canonical.com>
From: Ignat Korchagin <ignat@linux.win>
Date: Fri, 14 Aug 2026 14:53:48 +0100
X-Gmail-Original-Message-ID: <CAOs+rJXZ++7_o4L6LuT567FjdYsa=6NEki3qcFSRX+ehJxpoVg@mail.gmail.com>
X-Gm-Features: AUfX_mwuLx2aJR43wVpuS27IhjyS7MfpE6qQTDN1bU1nAQBlqaS068ZzBhfmWrg
Message-ID: <CAOs+rJXZ++7_o4L6LuT567FjdYsa=6NEki3qcFSRX+ehJxpoVg@mail.gmail.com>
Subject: Re: [PATCH] crypto: asymmetric_keys - bound section data range in pefile_digest_pe_contents
To: Fabrice Derepas <fabrice.derepas@canonical.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 7:26=E2=80=AFPM Fabrice Derepas
<fabrice.derepas@canonical.com> wrote:
>
> pefile_digest_pe_contents() hashes each PE section with
>
>         crypto_shash_update(desc, pebuf + ctx->secs[i].data_addr,
>                             ctx->secs[i].raw_data_size);
>
> where both data_addr and raw_data_size come straight from the untrusted P=
E
> section table. pefile_parse_binary() bounds only the section table's
> location, never the sections' data ranges, and nothing else on the path
> checks them. A section with data_addr and/or raw_data_size pointing outsi=
de
> the image therefore reads past the pelen-byte buffer (CWE-125); a large
> raw_data_size makes it read far past the end and fault.
>
> Commit f7dd32c5179d ("crypto: asymmetric_keys - fix OOB read in
> pefile_digest_pe_contents") recently fixed a sibling underflow in this sa=
me
> function (the hashed_bytes + certs_size trailer computation); the
> per-section read below was left unchecked.
>
> This loop runs only after verify_pkcs7_signature() succeeds, so it requir=
es
> a validly signed image -- but not an attacker signing key. The PKCS#7
> signature covers the SpcIndirectDataContent (a self-contained digest in t=
he
> certificate table), not the live section bytes, so tampering data_addr in=
 a
> publicly available signed image leaves the signature valid at that step
> while the out-of-bounds read fires when this function recomputes the
> digest. It is thus reachable by a local CAP_SYS_BOOT user via
> kexec_file_load() with a tampered signed image; the access is an
> out-of-bounds read only, but a large raw_data_size faults, which is a
> denial of service when panic_on_oops is set.
>
> Reject a section whose data range does not lie within the image before
> hashing it.
>
> Fixes: af316fc442ef ("pefile: Digest the PE binary and compare to the PKC=
S#7 data")
> Assisted-by: copilot-cli:claude-opus-4-6 frama-c
> Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
> ---
> Note: f7dd32c5179d, which fixed the sibling underflow in this function, w=
as
> assigned CVE-2026-64544; this closes the per-section read it did not cove=
r.
>
> Reproduced under KASAN (CONFIG_KASAN_GENERIC, x86-64). Two things were sh=
own:
>
>   1. The defect + fix: a KUnit case calls pefile_digest_pe_contents() wit=
h a
>      crafted context whose section has data_addr =3D pelen. Unpatched:
>      slab-out-of-bounds read; patched: -ELIBBAD before the hash.
>
>   2. The reachability, end-to-end against a real trusted keyring: a real =
EFI
>      binary was signed with a test key embedded via CONFIG_SYSTEM_TRUSTED=
_KEYS,
>      then its section data_addr was tampered (leaving the PKCS#7 byte-ide=
ntical).
>      Results from verify_pefile_signature(): the untampered image verifie=
s (0),
>      one signed by an untrusted key is rejected at verify_pkcs7_signature=
()
>      (-ENOKEY), and the tampered-but-trusted image passes that step and t=
akes
>      the OOB read in pefile_digest_pe_contents(). So no signing key is re=
quired.
>
> The KUnit case (item 1) is easy to package and I can submit it separately=
; the
> end-to-end setup (item 2) needs an embedded trusted key and signed images=
, so
> it is harder to ship standalone. Neither is included here.
>
>  crypto/asymmetric_keys/verify_pefile.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_k=
eys/verify_pefile.c
> index cec99db..4e84fcf 100644
> --- a/crypto/asymmetric_keys/verify_pefile.c
> +++ b/crypto/asymmetric_keys/verify_pefile.c
> @@ -292,6 +292,11 @@ static int pefile_digest_pe_contents(const void *peb=
uf, unsigned int pelen,
>                 i =3D canon[loop];
>                 if (ctx->secs[i].raw_data_size =3D=3D 0)
>                         continue;
> +               if (ctx->secs[i].data_addr > pelen ||
> +                   ctx->secs[i].raw_data_size > pelen - ctx->secs[i].dat=
a_addr) {

Can we do this validation earlier? Perhaps in pefile_parse_binary()?
The idea is that if the data is malformed we should probably not start
hashing at all. You could also reuse chaddr() macro for the check.

> +                       kfree(canon);
> +                       return -ELIBBAD;
> +               }
>                 ret =3D crypto_shash_update(desc,
>                                           pebuf + ctx->secs[i].data_addr,
>                                           ctx->secs[i].raw_data_size);
> base-commit: 3d6d817622b0a9721e3cc404df3469171582be13
> --
> 2.53.0
>
>

Ignat

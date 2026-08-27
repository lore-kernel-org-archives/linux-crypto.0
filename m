Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AD847FAF5
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842058; cv=pass; b=CeYg6Ry3p6slXJntPFkSKp4dkZM8M4UhYbkB4pkYiksix1Ei49xq+UKosnrJ9HB+g36HHDnXoU5kq1ujqW1XiiK2D/0xBKDC/glCZFOM5fAJAKjAdKl3hE1qxs8Sd5miG+3B/NOxOAbslzXGFtSu/+ApEBAJb2hMeepVSNcLsJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842058; c=relaxed/simple;
	bh=UyNAutr3ZBqr3zw4vZvqNGkd6aojgPH2Nb7YhuynXlM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2a6aXnYnMBNTpjnxVd7O6+z84P6VTRgb7KBVZzFV/pLv2xfCmywoPUBfHA82ULSpJh2fcKPq/Tim+IEkWqRLf8NQyVY+fxTemU+SqoxjktF/PO33QwOxd4stIMoeRLk+t081xjpHix2xFtKQ5spLzrQHq9IuRBkSfXR7/v6k1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTituS9x; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTituS9x"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b4a2ef5ff1so219067e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:47:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787842034; cv=none;
        d=google.com; s=arc-20260327;
        b=qjfpww3qL6hnmnb66tmnDZHIPe01ih0TRyDGs/B17mYkdetfovzGMQuLyuoBjIztoJ
         RLwQD29IYAF5dOSeYCcUEsnquhcGIJuqAC5KIViEUFtI0cEvYYp0ilgHteYT7OO+EOB+
         /HIFRnIKYg2Ki99Z1DrAD+QJnHbwdyoL6nm/lXrBdTd0W2ZfVrEFNzqsbTiZ3J7Hrv9O
         9PSj0w+MChDcFqhQPfdGBHtm851C3GkMthGX6HIb416w7hsGV20mu2a693GYLfBLLOkS
         AjtyV6nFEoJNs76pXQpCT0J09zfvUlUMdnSAbLRmFUjQKtvuAJDKzvnkMtMoaLAcpMvU
         A+kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cIv/H/IplOBpLOuUIXvmqmWRs9LjOZuBeIKzBslr/ec=;
        fh=88Ag+rIShH4M6d3Ib9x17cKgzuAHMBckYLjn1w+Gvt0=;
        b=W+Vkm01y82N3FO/3DTBbIa2rSlQzBCzr8nzkz8fxVItvqbP9d5Lwt+omwtLIqsf1oX
         gsc0YE/LrwXRa81VqGs+Q1AffTNaZGgPOZBWrwXGBgGzyV7o/ddUhr1OTSzMAAc9mDnt
         MVcU+qwppLvK2kBtKInwznqaw42YHQn5DqDIWsdH1gnAOGKyc67gPQmolc3wtyTl1LPI
         0KjXSFD4ss3AClKf/KzMVBaqJ0njUeysQ8gbEBPC8ZB+PaQ4Mt7SkboEv3cepUOfAIoc
         h3p1FBpVjl1NLGr7Al0Y1mIDkg29TOhJK9X89DJ40cdx43qd6jU8oLt//+zwCZCk1Bf3
         F3Mw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787842034; x=1788446834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cIv/H/IplOBpLOuUIXvmqmWRs9LjOZuBeIKzBslr/ec=;
        b=bTituS9xr/yXNciyLAZtTMQdu8C3H21kfPJlFuuk9AYtE8aCx44MselVEtMIS/Zy1w
         T/r9fVIX5RZfNNwW0vNONCitDBdGo9iK1dLJsOEFZx9Al25xsxixVpzWce8xfefUClQ6
         Psh3z9OfUWoOKGg5X+070xyJ+ji3qdux7f6ai1S+HSlowa1yz/2DTToYuGoxMVij1K4b
         Lx8zkZEjYiSUB+fpIcndNJnGc6bn9j2t8SqfsQVusCB5KjgG+r+Z+1ZvGp6DK4vK0nLC
         i/xLUjYPTmrHSYCwarZI9TyfWWg1ZMo9iLMBXTE/dSsbsfh5oW5geT2Y+Vg7XWJOIcUp
         L08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842034; x=1788446834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cIv/H/IplOBpLOuUIXvmqmWRs9LjOZuBeIKzBslr/ec=;
        b=AAevcKzZ3ewLjTGY/vHbq1MdSsjDEy3ygp2+4A3IJbzKC6Ne7MSABfw3QMD/7nCyku
         TvFijg7QQaMpHvNY6xFjtUZ800C+Pg+USl02+CNUlqqS95xar7DEZ6R7VDK/VWV87dtX
         /PzczxIFVLEDZ/2Pq1eDbX7SMvVKMKlAeYrpB+QtcoyFI6aJcG4B9ZbZXFLUTaGXFDQ0
         VrgFYE7SHyuMUHhwnSSZgtBUiyCwNA6WC3xZHaMiOPDKGvQJLFD+75b5KvVJm7qe1WBV
         f4w9BXP8iVsTSoEBNZ3A5egWwAOlUsEJu9YbkbjvMke8V9TlkhuwlVC0yr6afwJTCP6k
         U2Mg==
X-Forwarded-Encrypted: i=1; AHgh+RrrnQp8lFhXFTB2NlGhSAITE+jjKlUVOUJibYtQo7vP7myG9ceX0AF0lDmlSZSmHrr51IB70dfEd/RMwaE=@vger.kernel.org
X-Gm-Message-State: AFuF++mRgFTzTNYvYcNdB89Jg7ZCuIjcAKiPMWQ9UanQWCRFyYaiXjfq
	XL5Fyj8Z02sj4/Zzs40V6CS9f99Bf3Mo0s6cfdGtnyEJn+Xk/Ij5c8cbv71KbrhyCQjuCvFdetY
	JOZFP5BEmDJ4wixbSUqJDn2Fw5ZG4NnM=
X-Gm-Gg: AR+sD122N4PNaVk4Ca75fJfY5D9AK3kIYH2oJYqxyWzs2bGYAKdH8Uhh0Lf4dJwpYMb
	jNNQSERpdhRDSaEVA/w1BiLcCgpz12dL8uEg0yoFXamiCi/mX17Fd4ChUZFcRHOP5mvFI5N7xMf
	dE+rkV1A5LlOtvLwf1/lqdf0r/OomVsy4IbLGdR/8CQA/99Q+p2dx/n/egIp3gVV4i86DgI6bzn
	ne0b5qvg/9B9RejbifurKUfpkNLsZhNB3LIf7JbEG45+TF7lbOoHo3oAyddHIZLR0RfiQGGIFEW
	KjSjl1Ff4rQICHePTp2Dp2QOolLcXfJpivHUiT+kkEwKsuPhVWg6kWfReJGLO3wj36RD5hiAm6z
	3YvDhA1lVcXB2MwpoGUwczYsX33Psv8ew2GCoHFPQ1JGIc3AnFw1ORnAP1wD7NzLnrCCdwWI=
X-Received: by 2002:a05:6512:2524:b0:5b2:8f21:9208 with SMTP id
 2adb3069b0e04-5b4af8125bcmr1537133e87.2.1787842033712; Thu, 27 Aug 2026
 07:47:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826163004.3365-1-mike@fireburn.co.uk> <20260826163004.3365-3-mike@fireburn.co.uk>
 <20260827030352.GB2327@sol>
In-Reply-To: <20260827030352.GB2327@sol>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 27 Aug 2026 16:46:55 +0200
X-Gm-Features: AcwNN1UsDJQr_7lyG3pHWuoyy3p3_nTOF3nxmpNZaHmXNVMz_ZzoncBZkrBRMoQ
Message-ID: <CANiq72k3COcjo1s1MXdh=K7qRcOMMSq7-3_JCMtNKN3J0zQmjg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] rust: crypto: add synchronous RSA akcipher support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mike Lothian <mike@fireburn.co.uk>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Asahi Lina <lina+kernel@asahilina.net>, Burak Emir <bqe@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Yury Norov <ynorov@nvidia.com>, 
	David Gow <david@davidgow.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 5:05=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> As I've been commenting on other of these bindings patches, it also
> doesn't really make sense to have the kconfig symbol be in lib/ but then
> have the actual code be in rust/.  They should be in the same place.

Did you see my reply at

  https://lore.kernel.org/rust-for-linux/CANiq72=3DuUR4Vo9W55Kq6tQjc+6Q4_+w=
iWhCo-VLdkvg6PJeoAw@mail.gmail.com/

?

But if you feel strongly about it, I guess it can be temporarily
placed elsewhere, i.e. Kconfig symbols are not tied to the path anyway
so they should be easy to move later on.

> > +__rust_helper void rust_helper_memzero_explicit(void *s, size_t count)
> > +{
> > +     memzero_explicit(s, count);
> > +}
>
> Isn't there a standard Rust solution for this?

If you mean a function in the standard library to zero memory without
being optimized out: no, there isn't.

For context: I added `memset_explicit` to the ISO C standard and
informally asked upstream Rust about adding an equivalent function
many years ago, but at least back then they didn't want to add it (or
at least in a way similar to how it is specified in C, which doesn't
really give guarantees, letting compiler writers do their best
effort).

I guess I can ask again since now we would finally have an actual user
in Linux... :)

I hope that helps!

Cheers,
Miguel

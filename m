Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C04348477
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774547043; cv=pass; b=MCRuTbunTnHSss1HxJ6u+sZLs6/h0ZRiz0ldnr99z+eCVhTkjLWvnGWqbVRhkmO7Hq5Ku/apZMOuQ/udm/aoUhP0a+DfgzR1OLqFeNYxmQEugsThTqvOOgsduLhZQMkf8Pz0K22yLIO01Gr27diyADIZ7Idr93SQgVBkQsDVK3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774547043; c=relaxed/simple;
	bh=zrsCLS+SQTlQb03AFpk57v8MGREVn2wqLR1L25NKBU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pb77MWp5I3H3q9GqyfYYtrj8C8EtRo8tXjBqMPFqnYnaCS6kGNtzHxduUK7rJ89+Ty27Bs8mvxdRfhIKCh19l5wuzV5nNfTGJJwwdEVJkjF/TYdphYWaZOg8HdMWNJP6OpSJU0dwxJ2eOpUt/1dm8wpNM0Op3yNq4NYF/R1zOCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io; spf=pass smtp.mailfrom=theori.io; dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b=QKhp1j5V; arc=pass smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=theori.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=theori.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=theori.io header.i=@theori.io header.b="QKhp1j5V"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so10487625e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 10:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774547040; cv=none;
        d=google.com; s=arc-20240605;
        b=ihmGV5KtcLFrut/QBX7OwAp1DJkHTdL+r8xufkenz3YYMrTBY+PiaZb3C65JQ5iarj
         cCSL5BMJSxZEVkoT2b8jLSIHdrKyoj0LhZtYgF/Mc7Q33kF/t7AAP1rlve1hOSTTD0pS
         862fY9yoJyQ40qpC9O7BURhGW6Hiylr9c/ZnHO+DXurABhav5uhx1L1mFjN3FdBvaWbv
         AdnzGLCQ67XGoPHhp1U5iO8j7acnxlp/k1RYa6Pftbr4Wv9be7V2rUEZaesc0uDfyjoA
         ShsMwsISDZzoPNSmBOUMSjFnFHqVgcZ89VfVfJUdqWw+n8XLINCL6H3WkZuSroIYRXZW
         KQEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p6SzyHTLkCR+6NEWAKrMuYJMhCmjxCFZr6WpRPZiz1w=;
        fh=5NrMv9mtW1OmH1vGgLGo4st5nuutcYrzFScqlg6A3Co=;
        b=IoxVw5bhjVXMkWdJ3Ri8mO6XraDr4Wqdyv/+HIByoKzsNdaAXUTCn80rLjbYqXACtE
         InzpLU+QstoWuP0EqbRhTJAjhy9oTd1Jo+poHuP6RZzCpHtSUxVuGjDxaNpeOkv0kmiz
         gIl77N1qnUz3gCgAyxNjJwylPQy2Mnux/g0C74npYsgyo8zHNAEUZaWEgtJrB9rLQC/E
         SKizQn69r+HbsmZcHH9GwslplFeSR2FNcQdDlwYEOEhJnyWRlqoUZ5W7QZPj2UsVCV4Q
         P7Us2MjoQ4uVbN/jiMgzIdvbUmEzZ/jav9cjSmNWh3uKlrmF/EAow24pZ8XOhSDqhgLX
         yl+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1774547040; x=1775151840; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p6SzyHTLkCR+6NEWAKrMuYJMhCmjxCFZr6WpRPZiz1w=;
        b=QKhp1j5VBhhFxTY4WRx2jptchkku6Htdy5NLzi2IP34+3GumLO7QgVjCeDL7D64M46
         qNk8sYI00e0EAilkVHmNWOpNPd2+1Od3XIB/tvIsYx6E0WybiZWit6g0KSqNVZF5quIX
         FQ7v7H6+lMg4iKsli8H7eWGFfAAhGSi0BCArc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774547040; x=1775151840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p6SzyHTLkCR+6NEWAKrMuYJMhCmjxCFZr6WpRPZiz1w=;
        b=naQ52+FRP7dr5j6uL7bfOZiEqG0dJSW44B0euK02Pp4BKa5YmzlJwhB0vWgOci8o/F
         hLic661se15zEoz+GE5zyeHfMdZiip4XjeI636BM+LlnxpW8DzsSrAljLOniKUZgwPtu
         +LxUuxRoLnEDN4/enIHlEeg/tfi86ys8YyRFw8GkVtaEyPl+NtBdhFLmDFxfnlt057Bz
         FFWaFO/jvItC8Dp4g6ofT3hv5S9dgSelFg8AkznMKS+B2bhJjyghbwFmu4kM9+sbvmpu
         VXucI4cmvIRCEOS2Syln68r9IxX165mTh/ELxMSJ/xPQW3s5n2fbunhO+Xm1a8efmBW7
         jy+Q==
X-Gm-Message-State: AOJu0YzkShK19bGAb1OVm8I7/V8M9QAjw43i+ti2Kv4RwG8dqqlQbBY7
	iT6GjGml/V3jklqHtXTYEFWqWp9RqGw5DZ6ZLiTdpYI3ZyxgRKEMj0YNr9xEPzfHk2npLD0z9jS
	pFDlJ+HSVxfzyE0I74/51tfq6UbRtJVix6RUfjU4Yyw==
X-Gm-Gg: ATEYQzzpj+i+/LK5CVYWQ55XUBrErArFw7wSbr6/aWdf09wL/juZDcYYS1FLAfYglgm
	+86Wlh0KiwxDrKIbxTBpLEn+toClpbiQrH0mhMqitbMXM4/HdyHJBvwDthM108TbHR3rNDXVHEx
	5IKdLXOBsSe2Ocj+kWxHEVl163Zawtx7//ogQRQOrdxStjYGERJ99zo0DEB0zp9oNbHp7/EU0fW
	vCuMhLIgjGAyz+ljUzlbcamV5awIyN/o+Dj0SZFLRE2OblEMdorxjToEbF4Cfrmu/g96+teHiw2
	/2TqsljChW9ETGI=
X-Received: by 2002:a05:600c:3b16:b0:485:ae14:8192 with SMTP id
 5b1f17b1804b1-48715fc3291mr126488425e9.7.1774547039754; Thu, 26 Mar 2026
 10:43:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <acOpDrnN3cVfiASk@gondor.apana.org.au> <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
 <acTSfLPWDGTaGIf7@gondor.apana.org.au>
In-Reply-To: <acTSfLPWDGTaGIf7@gondor.apana.org.au>
From: Taeyang Lee <0wn@theori.io>
Date: Fri, 27 Mar 2026 02:43:23 +0900
X-Gm-Features: AQROBzB3aXz1ENPeUwhNKE7Hy5OZwIRzauxI6g0L-SZC5Rw6wRPbllRTcgIiZRA
Message-ID: <CAH-2XvLaZR+Ee+q35wXexKEh3AE7R0w1AGC__kV9To_6sLMdhQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: algif_aead - Revert to operating out-of-place
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net, 
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>, Jungwon Lim <setuid0@theori.io>, 
	Tim Becker <tjbecker@theori.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 26, 2026 at 3:30=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Mar 26, 2026 at 02:59:24AM +0900, Taeyang Lee wrote:
> >
> > I don't think checking only `src !=3D dst` is sufficient for the issue =
I
> > reported.
> >
> > In the AF_ALG AEAD decrypt path, the child AEAD request is intentionall=
y
> > set up to look in-place: `req->src =3D=3D req->dst` on the RX SGL head,=
 and
> > the TX-backed authentication-tag pages are then chained behind that RX
> > SGL. So from authencesn's point of view this still takes the `src =3D=
=3D dst`
> > path, while `dst[assoclen + cryptlen]` can still resolve to TX-backed
> > pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.
>
> Right, that's a separate bug.  algif_aead should not attach a
> read-only mapping to the dst SG list, which will be written to.

Agreed.

By removing the RX/TX tag-page chaining and turning the child request into
a genuine out-of-place AEAD request, this looks like it closes the AF_ALG
page-cache exposure path.

With that in place, I think the security impact I reported should be
addressed, even though the authencesn-side use of req->dst as temporary
scratch storage during ESN rearrangement would still remain as separate
cleanup for now.

Thanks.

--=20
___

Taeyang Lee, Security Researcher
Theori, Inc. / Xint Code
Website. www.theori.io / xint.io
Email. 0wn@theori.io

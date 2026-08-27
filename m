Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA933DB328
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787871653; cv=pass; b=ovQdu5Snd6HSXM//XSLdfD6LG+0JCukNArB0B1j1ZW/5A+kfclvvI5jTdxdgQ/4ySwTQD1TebE6GauWlYm/eSDa9GnWbIBkqAiXtMsedrybmimz2IpC3HJgHP13SE5W/c32ygULwknTrx+NizeMKJ5GG4cYhZD0aFhhny4d0m60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787871653; c=relaxed/simple;
	bh=PtOQ1ctrt5ChIryejtRZPvf9ci4aQrCJNC6i+HqoyYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ikcAOvtS452fUi1Iyl9r0vT0K7Bp8w4nYULTCMcLut7lOYbwaSyXGIW1LPTGcGSb6hYE3FmAWVApRz9BBrQg2a9MCoVmD49/2JITqpkYY8YYdfZBRjKuoBkp0i5tznu3G6hS7epPcyp54WL859o1MfRzcnTNa7OdAUZVYdq+tOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p9+covru; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p9+covru"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d03fcd26a6so252735ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 16:00:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787871650; cv=none;
        d=google.com; s=arc-20260327;
        b=d7EdE5DcFzzN0n7TYm3AHWNkiWhqPgGKxOf1O87PhfuQbj5avlaSpPAigKH31a++vD
         J+fa17pQF9VujNPVti+mKHm0qx7ss9okAhZ84OiYuDhKlO8fD6HJXMcIjyHV/SJUBO3A
         TnnMRUwNc6D8ByP8uJ6pnjozsPWhVFg4kl0POUpj8R7BRpw24JA91Qtyv3Jl6u8nRdJt
         adMk4/KBE4yUH4sWqSK9omoRIerxWnFfvAniKjm4aF5cBOyn+h59hGU368dSfiDL1XV+
         EjvqQBQK5CtHIHr8Q9KodrxYwUYlf7X4POHti9Xff6bpR2KIQNRtUqkl60gGW8vK7Esp
         9DrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PtOQ1ctrt5ChIryejtRZPvf9ci4aQrCJNC6i+HqoyYo=;
        fh=8DMqfkpZ9NLkZudISPD9LJhyTtmne9HBjyRpbUCMV8M=;
        b=KU1qiBhVACW58ESmAM9MLloszrQSQB9heFs3ikOizFasXIBG8gzmSjLHuaWQEPm/yE
         1r9kMigVY3P1tZ1qxKICYGCnfL/j11x+l84ioMCYg7MjhU9JHnn8ozLa4Xa2CIJAU3ky
         yWiJObZjyh3nF5n9Ufz7C4F0SR2kKoXpUXNiY7da5ciyWH420XJJNOAUdT9G52y14tjP
         KkOLjoQO/+r3T2u90Budeh6Ige9UmPVXcOLLkky9NY2EiU8KHxmqfpOUH12dHa+/Yn5x
         q5gu3nvl4QAHgscLwvILEKhqaK3R7dU7ILKjEHsaUz/GMLM4l0OBzShB2X+hQB2x+rN1
         f92A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787871650; x=1788476450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PtOQ1ctrt5ChIryejtRZPvf9ci4aQrCJNC6i+HqoyYo=;
        b=p9+covru2Hp5BxxPX+gS4B4kj8l3iQMWtHIkbuwbH++g0b4ZFXpIwAUUa06uTwE4Qe
         Ie/QHJVFJmxZNI+YrdT6rxNByYEAqaFDnzMtvmtLvIumADy9Uja0h1eCjX6/8APpCb/F
         v+pb/A/Kh//celSSa/C8KiuFfGDDWvoCJYzbMIiabWsZHjuO49l0uydKOyuJ8JDeFqSE
         SISdkJV/TWoRYIUVtm0Mz7LSC/TTuZETu/PceOtahPw5m+rQCDuO/8qrF925bpxEYOvs
         W3ZqyBT82TUFs5+Cnv55Nt2v3gtqfBcf5hG63gG8kAr0nfVYDDA2euCgXHBfQJSCWibK
         WjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787871650; x=1788476450;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PtOQ1ctrt5ChIryejtRZPvf9ci4aQrCJNC6i+HqoyYo=;
        b=hs2qGWaB8aCJSjx4uWSE+eygIH2XwABjG9eP0LpashbHuAZjOuFamVoxUQFyVXBa/8
         gmGmWlCO2oeKyI7fGpjs2tBtlgg+qWxbmQeEOQgbKEBEFOKw8/Ade0Vx3MtxJxnmCXlF
         3XK/Jg7st0TaaNFX9n4APt2iMhuFQ0S4l8XchmR7CptLFvJGVmNwImf8HQsOGE64Xn2Q
         texMoG2sJXVxPzcQUmYxVXzaWSxNMaADx2y5nC6Vt25YkHTksZyvphakzdg/gXSjleLp
         R5VvsfMiSFPi0TEOEEjDotORIjSf79YQz/voFwY7rDx9UlaG5BTdnyw0Lvs4O97aQDA6
         KkZQ==
X-Forwarded-Encrypted: i=1; AHgh+RorNXzNlYbo7Eje51ylAC30HBhNjpjd8ensvPOMEBNuy8Ios0aGhmDaQqMe9NGucFzEzIAPv4okTxIxhr0=@vger.kernel.org
X-Gm-Message-State: AFuF++maQztMnJBiBXldj9Ho5ksAsz+5bkKLuN8I5yJRxlAgLfyoyiG4
	8cZSCW11WC7WTgfBW4ZjkYk5YxrASHlmFekHFl66zH7pedKMYGgSVY++tOXZcif20F0PeBI6XNH
	Eoz0XfQHJR+xqX6nJcIpgguV/c7rUptY=
X-Gm-Gg: AR+sD10AaPCcOWFVpUtd3yZzYjE7T3on83DE2yyyeiXpr9KwZWH44WVFHxpHEIU+8TO
	spnox+B7edeYmz2x+y+vvCjUhHkqxXWFM+rCPK1WGvpghzJRcDhKLzgjxgd885ac+/1NAmPaSyv
	PXar2X4nt3igQaR3E5nWJX8vaDrLGwArjcv3M4HN0nb6caVUpP2OuzoDQ/wj1mqTzUYt75hI2Oa
	InUU6CCYgc/LBtY765zcNtc8TFfDIZac3haZGuaayvXvRWib7Jo2fruKW/p6aXjYowEDqQnju7f
	+0uvMXjdU+Vr2WcthhYX0QYyfRJeIZ/vA+pr29WAqX2+U0bpn24IhV7A+tw4gOP0TUVy5wpEU2z
	BFajtffEpS4Oo2GTicKkmwBXY6q2fTFtZCKLL61fSEXKFSzJ9Ggbu87xOwOoW
X-Received: by 2002:a17:902:d2c7:b0:2c9:ed4a:c3a4 with SMTP id
 d9443c01a7336-2d74ce38075mr21203935ad.0.1787871649744; Thu, 27 Aug 2026
 16:00:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826163004.3365-1-mike@fireburn.co.uk> <20260826163004.3365-3-mike@fireburn.co.uk>
 <20260827030352.GB2327@sol> <CANiq72k3COcjo1s1MXdh=K7qRcOMMSq7-3_JCMtNKN3J0zQmjg@mail.gmail.com>
 <20260827182907.GA2137493@google.com>
In-Reply-To: <20260827182907.GA2137493@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 28 Aug 2026 01:00:35 +0200
X-Gm-Features: AcwNN1XMEcBfhQK81kPdbiieX1lImw4sydc4Mu3cJx6g3SD17OlDU5gWr95b-jw
Message-ID: <CANiq72n5swSHaTsDi3TYdneyCiePHF-gEAHuFk3ZWj4v0meR+w@mail.gmail.com>
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

On Thu, Aug 27, 2026 at 8:29=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Yes, it doesn't explain why they need to be inconsistent though.

It is simply because it is the end state that we want, i.e. both
Kconfig and source code to be in the usual folder (so less things to
move later), plus one normally wants the Kconfig options to show in
the right place in the menus.

> And if the code is "conceptually part of the subsystem", why is the
> MAINTAINERS entry for "CRYPTO LIBRARY" not being updated to include it?

I don't know, but it should be, indeed. That is what we have been
asking subsystems to do since the beginning (modulo exceptional
cases). Some take direct ownership, some request to have a maintainer
dedicated to that in the entry, some add a new sub-subsystem, etc.

I hope that clarifies.

Cheers,
Miguel

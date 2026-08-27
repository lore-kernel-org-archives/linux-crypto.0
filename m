Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7E846C4C6
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842772; cv=pass; b=IJghU5fCOQrGwUj79X8jLfwf8AKuxhEb8DZ4d82vQFGK0wSS2o6qxdH7uvXQvbfNQmj3Nz9JL10G5j0uzQw15+tZ6HbsUoYoNz+GP6DTCyPBnbL6ew+0v4TtYKdlvaLiBKbr7d/ozkP0YFXJAOFFZRzkmrCPymXjBrhd0z+30kQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842772; c=relaxed/simple;
	bh=41WewWIErbX3yd9Z3vKfnXfsdNWRVLs4FM/DXBSS53c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h41YAcgn9YOcIPZTLnvJR79oGiYaAXlv9CgavCzSRTCJEkeA1t8oTwfU622wCNPsjNnjph8+rD1TR59ERvAaAW2CQKXW0xzkXWC/VlqCWvEKIwvh7WmeZYxWQjCiCC1En0JKckhzdZDqIGE4bsy3VDAbKDogso9taCfXkGON4FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMdgmt1W; arc=pass smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMdgmt1W"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d590f4c291so4350195ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787842770; cv=none;
        d=google.com; s=arc-20260327;
        b=T7bHlwAkNTsXaGruhQF1OdMjCz11+j1wu1ZYRNeO49CSWyqGvA7voJhb6BeAfo8RM9
         j13TVP1w8P7TPQhR8Omf4xKqKvgJLEOKznDR8Ty9WUkz58xDl2eXcs4rxhE5wOqhdCmQ
         H3omWr6v9RW31WL4homrotbzQIuyVZDp1uIpIa0hEQl1S18vr/TzH8sS0+eyExXlg15S
         mbbIzMGADwc7Jgoxe+GxjC/Eck74CEPGM01ig58A8CZnepPJb+aNMQ8KNHgXigCqr5Ew
         Ip9oss/MkhqjS76Wcf7HjAcfH/rYd8B0iVc3SsFBbIB/6Gtlyt0oqYzZvQ+s7qr4c/sr
         uCxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3caV8jGIKYECCoF6AjoMVnw7A/xTQryGhAY1zu/DQLg=;
        fh=/EP/5fvlJ3dt3mUbPJRvKw013YHgJ1oxZV6zFgto1Kw=;
        b=fjDFY8z67W6Sv5RZziwziiTZ92lDM141lHjRror9ElQ43jQwYWGsQuZbsZoGhbMAi2
         dsxycQEI3hqjh6SFl+cvAQQULrOCM/VdEEUE8gR9MrYdwngRVHev8RTOSX67n7bJk54v
         xbkDVHscF58zMVfd4qLMuEWxvAMYj/L8X2RlTRV+UnQet235SX7c3I8+44BpKjI+p/cg
         HcQJHhkSI7ymEQ+pP1Hz0VAEf12YfQFDXsIxn4YdrRTnRDr/tUy/HFp7vC1zgzg9CSjp
         kvi/k1W3wpni1hxpjrfxz7hKUBXtSzbON6bCTluQWj8KzBOhv6LxFNrzamGV9m9X7Vid
         MBmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787842770; x=1788447570; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3caV8jGIKYECCoF6AjoMVnw7A/xTQryGhAY1zu/DQLg=;
        b=QMdgmt1Wt/TKna15326h1CQJqqJV9kNggWJ+6lruH2vsyUr3pyLDAXl1c406Xb4TSp
         e0Xfvl1P2YgarMjFpi4zKv3MZYJHxJ2eZPxjpwHYjwrhbv7I035qamC3uI+a9coeOCqF
         voyjznUmKCH+ijuX8JbDR0EeKIC88y4aNojx/eUQ5VKhsGtddpASqNP6vsHrJ8z47LTs
         P7TNEw3YkA9YbveCPvwh1/8nD2NGrPqwuU/UEWmpOaqeqjE9Z6w6XKRVV3Sxn7xwcl1h
         9pSYjBDsPPuR2QnXPMxiO3jziFPicio449EOuxntLVg+U4O1Oj92UNVKgtSx50uSxOMS
         qchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842770; x=1788447570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3caV8jGIKYECCoF6AjoMVnw7A/xTQryGhAY1zu/DQLg=;
        b=nl0t2Q5pYGWdXMOrKl5O3rMTLdBEioxR79Btu1u2PxH+lEVhdD4f4IFFWorHSl+diX
         6yQpZ/Fg1eXf5jVv5oyo09xbR1k7Y/D5FB+wLiOBEePUtVnbzuOSJgb0FLxJmmFW7ca3
         dgFmpeOccmckDxWY3otEu5HOtawzXZ9LOSog5WPeo1/BPs5ArgrH2LH/BJa2XoQVMw2+
         F3O7Q+PRUGP6/+BmWHVJ3tyzj3+P7ml364bzPbzLYDcZagPpdL9kloRa1QcdWT5BBbEE
         +gBhOeYznCzx+uAswMCdqs59aaqFKPHEXcNXYpiwZKl1UzjYeBwLCB65Jcn2KkhQDN8A
         rlNA==
X-Gm-Message-State: AFuF++kj00ySxqrCkfC+OBsZ9KIxPaG2mIs87kEkIXSNUuMajZ4OKpyY
	wjSr2WwdV7NSAC1ZVumUk+kmpl7LI893We3qXTesN+AdmlMj8mQ2JjBChxb81d+0c4RRvuHnfcq
	IOV3nBGDO7WjqXi82c3iUB7gnPq0opwo=
X-Gm-Gg: AR+sD106FmYuzIe/t+yiglHQ2PXPbT8OdKDksHkFev3DgiErrVFBEY2YDi6uLF4z5B2
	cBkGfV7nSLglJiP6OD2WBh9ihWKJaQC1JdtB51IOW6IxQgRbgkTPuLRHnwjP8dy0RjtlY6WxpCE
	HbrqTWNL8Dw3eiylxxOeJRRpwHYC8QkoYFAoA7gB21+g6Nv3OkFa04XgeYYnd0dN8A7gz78P39+
	WaFm6XsMOF3HFn34fYzgVS9sPnAPipKXguid+iL10lkeBOX0wZV4lH3UWP/uOBkLtweCKobySrH
	ZKo9aFyxSAn1iiCfmuoqRIWjuSX02By7OzzU+IV8SXPBs5x+++2Gj0GOAzwYp3S5i5G9XfoodRO
	2pQ5rXrggWnI8ajpJgdApj8uI1PWjT3X/IWQSRGnErX7ZR+wD9aZvTziUri4m
X-Received: by 2002:a17:903:3504:b0:2cf:9e90:8be with SMTP id
 d9443c01a7336-2d71e4f74abmr88346095ad.4.1787842769819; Thu, 27 Aug 2026
 07:59:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826163004.3365-1-mike@fireburn.co.uk> <20260826163004.3365-3-mike@fireburn.co.uk>
In-Reply-To: <20260826163004.3365-3-mike@fireburn.co.uk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 27 Aug 2026 16:59:15 +0200
X-Gm-Features: AcwNN1W0d-V13zh5elWYWY1xq_Ye1PYxNifjQKCjt0be_UdVKV0D_eRNv-EoeZc
Message-ID: <CANiq72nTu0JMOQ2ovkCnrHVr3sFE648f0e1My9nesqmKz1Gpig@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] rust: crypto: add synchronous RSA akcipher support
To: Mike Lothian <mike@fireburn.co.uk>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
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

On Wed, Aug 26, 2026 at 6:30=E2=80=AFPM Mike Lothian <mike@fireburn.co.uk> =
wrote:
>
> +__rust_helper void rust_helper_aes_enckey_zero(struct aes_enckey *key)
> +{
> +       memzero_explicit(key, sizeof(*key));
> +}

Hmm... why does this one need to be a Rust helper? i.e. why doesn't it
call the other helper from Rust?

(Same for the other calls I notice here in the context of the patch to
`memzero_explicit`.)

i.e. helpers are meant to be as minimal as possible -- just forwarders
to the same functions unless there is a good reason not to.

And then you can have a safe function abstracting the call and use
that from the different places you may need in Rust (e.g. from
`Secret` and `Aes128`).

Thanks!

Cheers,
Miguel

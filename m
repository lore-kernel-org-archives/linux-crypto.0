Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723291;
	b=1kPBye5GDjMIsIGjglX987fnghYKdFLZo+PdltART7vLK5O40G16seGf9YX2p+hKWqjK
	 l4V2IXvv0QivHuQIZF378JMvybZHV6rVZ0wZIWF6aG6tPlybCZ+6HmVQoJAj7OED4nN81
	 GrPNn7hTcBWOrLKlKZ/0DcuOTqpNy6u3/rs4mhXhHhd7oBBqI6vjF/0qhfpqC7Vd2TLLN
	 uAmU4W0mFvOCPyMoWayfEaGX3obO6kt4d8dRH3Sb2RojlNPEue2fLnGJBXYBkPhCzIE8l
	 VxhHKds2WyZqwfS0o/IFhhZV4rGTB/L7thKe7qcdczLQzC781BAmV9lzB8HyeENvtEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723291;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kFjGSTadJ6qoktnpYz+dD2REm71grJ6UoHE4PWQ/UmU=;
	b=LV7OR/25MfmJ87zyXqhtV56dnPDiY+QhbmIjumdvYeiPE34+LCMjUILBt6YKDi/meX3/
	 6Bk468WKQwutrLVHcNf87rk6jxI144/5dfex08R1j6bOhh6nS6rk1RqTUqBV5dnBX+vho
	 cVkhfRxreZoibGqEmWHSvC1rsGDvnOxLDOj4MlNQBml8+GFYbvWdPx/GMNkpZcEps1ymf
	 ycHCiHXKGN1VnA9v9PZMDQsywRfG6C9hRo7koJibCueUhXG2rY4gFoNv3C94vv3BVGXqe
	 H+uFBGaM3l0PMjsuGmOXGFJOrBNMMjbZEspE9mcUsHZJxqL9r0YoWBuKcME9PGPE9qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJryDVI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCA606A324;
	Tue,  3 Nov 2026 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJryDVI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DCF1F000C1;
	Tue,  3 Nov 2026 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723291;
	bh=kFjGSTadJ6qoktnpYz+dD2REm71grJ6UoHE4PWQ/UmU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJryDVI+RTtFOJZpdf9qlki724l0mIzud1wID2ZFGSsOEVpWf5DvwDvXB5pGnjk8q
	 VI6JajuHnseOqOMbMvimsiWyk2rKegsjVJrWPyiFCNzdRRaSgc/NRDIH2sysBDoaAO
	 g4KW0M1J3XspwXIfjvvMFRWOPn1vg6QmKP1QxlIW7G7LffkrWreXJgrX8SdUCciIdJ
	 Gh26Fu6Su9GncWtnVdXbdUlgYsAswFNJd5K2CKU+95M1HgogAS5O5aBXv0nkE5ltLg
	 9F6wORaUaksyxbVKHwuf2BjfKBYmkofjmoHjAHUPqHMiUJknjLBoRA2v73jg3qI9vr
	 AKP6mDRb7do/w==
Message-ID: <sashiko-outbox-195724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/9] rust: kernel: Add greybus abstractions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ayush Singh" <ayush@beagleboard.org>, "Jason Kridner" <jkridner@beagleboard.org>, robertcnelson@gmail.com, "Johan
 Hovold" <johan@kernel.org>, "Alex Elder" <elder@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>, =?utf-8?b?Qmo=?=
 =?utf-8?b?w7ZybiBSb3kgQmFyb24=?= <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>, "Alexandre
 Courbot" <acourbot@nvidia.com>, =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Eric
 Biggers" <ebiggers@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Ayush
 Singh" <ayush@beagleboard.com>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Markus
 Probst" <markus.probst@posteo.de>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261103-gb-uart-transport-v5-6-f8e326d6561f@beagleboard.org>
References: <20261103-gb-uart-transport-v5-0-f8e326d6561f@beagleboard.org>
 <20261103-gb-uart-transport-v5-6-f8e326d6561f@beagleboard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 16:28:09 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] rust: greybus: blanket Send and Sync impls on hd::Device<Ctx>
--

commit d45a0cafbb6b7cfe1ad47516461c24f42e8c8a34
Author: Ayush Singh <ayush@beagleboard.org>

rust: kernel: Add greybus abstractions

This commit adds Rust abstractions for the Greybus core, including host
device registration, driver callbacks, and wire protocol definitions.

> diff --git a/rust/kernel/greybus/hd.rs b/rust/kernel/greybus/hd.rs
> new file mode 100644
> index 0000000000000..9e1a5fc645cd7
> --- /dev/null
> +++ b/rust/kernel/greybus/hd.rs
[ ... ]
> +/// A Greybus host device.
> +///
> +/// # Invariants
> +///
> +/// The wrapped value is a valid `struct gb_host_device` created by `gb_=
hd_create()`, and every
> +/// [`ARef<Device>`](crate::sync::aref::ARef) owns an increment on its r=
eference count.
> +#[repr(transparent)]
> +pub struct Device<Ctx =3D device::Normal>(Opaque<bindings::gb_host_devic=
e>, PhantomData<Ctx>);
> +
> +// SAFETY: `gb_host_device` is reference counted through its embedded `s=
truct device`, which may be
> +// used from any thread.
> +unsafe impl<Ctx> Send for Device<Ctx> {}
> +
> +// SAFETY: `gb_host_device` has its own internal locking, so it is safe =
to share references to it
> +// across threads.
> +unsafe impl<Ctx> Sync for Device<Ctx> {}

[Severity: Low]
As reported by Sashiko on v4 [1], in rust/kernel/greybus/hd.rs, Device<Ctx>
provides blanket Send and Sync implementations for all Ctx and omits the
Ctx: device::DeviceContext bound on the struct definition.

Because Device<Ctx> also implements AsRef<device::Device<Ctx>>, marking
Device<device::CoreInternal> as Sync would allow sharing a
&Device<device::CoreInternal> reference across threads and obtaining
concurrent &device::Device<device::CoreInternal> references, even though
device::Device<device::CoreInternal> is intentionally !Sync because
set_drvdata() and drvdata_obtain() mutate dev->driver_data without
synchronization.

Other bus device wrappers in the kernel crate (such as device::Device,
serdev::Device, platform::Device, pci::Device, auxiliary::Device, and
usb::Device) bound Ctx: device::DeviceContext on the struct definition and
only implement Send and Sync for Device (Device<device::Normal>) and Sync
for Device<device::Bound>, keeping Core and CoreInternal contexts !Send and
!Sync.

Should Device<Ctx> in rust/kernel/greybus/hd.rs constrain
Ctx: device::DeviceContext and restrict its Send and Sync implementations to
match the other device wrappers?

[1] https://lore.kernel.org/r/20261021-gb-uart-transport-v4-3-c308ce821d45@=
beagleboard.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-gb-uart-tr=
ansport-v5-0-f8e326d6561f@beagleboard.org?part=3D6

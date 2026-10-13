Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A4D4E50BB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 12:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895994; cv=pass; b=WgoZ2GB+x1o2P8UhDnk2Mpg3txZgMAPFNyL3hBIlChfeaBDh1kFhACwoIp6v5Tijr2fOqDT9k0UrDTzK8Pm+wPpD2fkRD81e/kNxsbXdVbJsTeZYVaqZCyBDjpkCHgjRyA/VRrM/59iZsvwGF/H3QHZdvB7oUHqbXSwq1mdd0nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895994; c=relaxed/simple;
	bh=UuiRmBadCxfqcfSzZSqby4/2UPwr5QA6sDq3PGs+kpY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aI0skkb1dCcOFtd/+Z+TdAOMJj0jjzjXmRiLY43PxE5ucRaBr6L6nYiddagVDpXYG1/zfP1U+GxDOuvPCv0IpJ6WZuYlxmVE2pXXzEKvzM/PaOUh4gZydbFBUUj2do2LFekQ+1A+cdv017No13sghsw52VYw4v6sxcR0I8Y+jKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s2Y7Inva; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s2Y7Inva"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33c10faf6easo290444eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 05:53:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791895993; cv=none;
        d=google.com; s=arc-20260327;
        b=RInBEKTo/s2c9RYNOfi58cthH8GJ9pt7waTGM5d4rBl4ZUW6z0YsNWIWx9hvmXa98C
         9jLk7zz0+dLp/+RPYjZfBkNG83t398yHEMct9+DOHkljg2kjVSMQyDp4Ldc4eMp7gu1I
         kErNFMU6VaRlf2qF2dSv0WZVnTyEoqdpYHZg3+B7WPTpMIT3w3rJ8xb0ATZ5oqFNGPJY
         DRTKFxiwxMwGxBOxVKWsJYyOZgkDSs8H5mwtU1KE4SKZLXRkKJgEtO5hHoiZ68ZY2i9w
         XzgyOQe+TMXzCZLFzuvxRk+NqM3RXDag4Rff1sbCx5eahJGFvow2Ir2C7J9ZIQQa/Hw4
         r7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hFhU2bYt0krteVUmUhOtq11sG/zJcX159F1mHbOkYZE=;
        fh=Zh3awUGiq9AkZeepU1I8PGxCWeeWZzUGT//ZZ9O+1aU=;
        b=eiG6O5yw4xMh0eUTO8AKyb2p7G6SO5dBxbn1e1IqEJ03a2gvBX8/BLJLV0FOraeB+f
         eZU75IDvdahxci7ed2gQbE/kE7QEzt10LmzPxR50r1bWiZYB+woIMZjKIG3cGwwAS+aX
         +QyBsuWnVxSGfOL94ZmGCPvfUfIvxJslscTYTsrxSzkkKpjaaauZHIOT3QtkBDAiq0O3
         F1hqQZMQjQ7T7Irds9IHccFHiRe116AaNPXdqxw6B/2yS3LwdJ/7WnPgeRuYEGlouhCB
         dYlezPOLCyoR0ut9uN3MoR+ZnaMtC1GW1Y20XqGOzcmpKb4WFRLpIxiaNO2+zCSuQedg
         C0ww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895993; x=1792500793; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hFhU2bYt0krteVUmUhOtq11sG/zJcX159F1mHbOkYZE=;
        b=s2Y7Inva6fQGfLVIQZMLYFwDJSoX+mPdVI4FfdG0eb2ia54fUNsny+X2nyB6Qxzei8
         3iHPlJWq40/CURiwkEuyC7GRC+zhUqnhryntMeaJc19s7L/EFfRQNMFuOH/DfTPMYt1o
         QUwUd5VwKJQn6iekspQOHJ+kOeee8XwJ2DzDx4SlKNxz7kcxOlYO8Uim16bvHbBrjCNH
         gGqNhGGHUWUqE6SywQvCkjeL8IEjLvuKBsJ7BBF4Zo/wf4Ytuest/3vqaOMSlpheupTA
         Fu6QTdXlYl2TV+Lh5bwrZ7MhAYP6Sv/KPPdiljo8RHm4YWoE2D2WDPmPeKIVaXjPU/xV
         r+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895993; x=1792500793;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hFhU2bYt0krteVUmUhOtq11sG/zJcX159F1mHbOkYZE=;
        b=DtoCG5hAz3EJZwb9kRqUqef2R5UWNci3uLxcEPRVFOp78svxQB72TFB0YD0f/FIYW/
         mycpZFM0ZXh/gZvz92pA5SPd9Mx1WCPT9Ojw4x445Vj9f2inMM22F79gSYNBN2nDSzx0
         MME+7VD6pb20slYAkcWKqRFYrBExhis9X4APlCXUgRh/1snq9aeM7SJo0pvhK9GfFX4M
         fcjxR1rxehssRJvrUVl45aOyd4a0doNAXWzdYUknTKZPe5SuhNUKZxEKN6xV8g+AUMNs
         EhKNZ+csJqogS8G9/tiHf43lMXeo5GqOzfJJQmVLRRrnvKqk2OkM2EpdXXS4MuTarihu
         dAOg==
X-Forwarded-Encrypted: i=1; AKwUvBz/KXZqoD1CcRVATS+7AfFrEdI2q30c82J3puwSNpNvRqj1zvZqbSX4LyknrU8AW29Qyii9IWLUa9A294w=@vger.kernel.org
X-Gm-Message-State: AFq9FYJiZ+u6txVLw7hT2lTzbg+scgOCeDoVIZP4exabXrAFiSEW3XzV
	YbkGx+v+lgq7MkJuMv1JUXABB+0vguldGnxRD3jsC3fTZHozt7w6nC0PDAK1jHBgHI4/aRRKxbN
	lM7iFqUD5R31GSgaQYbP8N4FaG884NNU=
X-Gm-Gg: AYBFou1omAxKrQdt1thuVVp6e3stz2DvUXO/tAh+cZM98dqqFedZQT96l6SDmxtPu5T
	oDohZV1pC8od9li7tG3IRox9dh5quiisBlboIHua0XvKdMhnE2AHUWv2/4fjJHOWOyKFtkaho4i
	45GLoMJQTZGKzu7trWn/PdL0jQLybxK10YulvxsIKAG1oinJDaYxlR0v7OKpOu7g3YaQcf3OG0F
	SBo983zVADRfwllsTaytcvhZ6fdrwbLvakd5mIVwRBaNJP+dgblGW+41XMQE99TLGddgNC2tv3/
	cftFLFVewvj5TYnbGL7HTGJBqNqaZOpnyVe/LLVGREHJMlBeN3G1mgy1fHvMdAfDVFbnGTA9wpG
	TyVv4y54yCb7C/oGOtweZ1MK/sU6LIKfpE43/GLKXkthKqVTKUDXOjfkoycoujX9n1TX8FSgt+1
	E8+tKBWWmyN1Qkfs9vMt+FM+ODZfWuOHyHZQDAfqSCyQuTFsVX1xg=
X-Received: by 2002:a05:7301:4d0b:b0:33e:6714:3945 with SMTP id
 5a478bee46e88-3537e0129e3mr26810675eec.2.1791895992551; Tue, 13 Oct 2026
 05:53:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
In-Reply-To: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 13 Oct 2026 14:53:00 +0200
X-Gm-Features: AclHuK-P5U2ev9hpzeyozzfAgREhL2ZTBvoLRgkZb9RpskE9yERenkCCWIyQj54
Message-ID: <CANiq72mA6pTmPJUk8g7y3Z=wetFMXdzHLiPEPChpY4OTg3OHiw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Add Greybus Sotfsvc and UART Node drivers
To: Ayush Singh <ayush@beagleboard.org>
Cc: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
	Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Markus Probst <markus.probst@posteo.de>, greybus-dev@lists.linaro.org, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 2:01=E2=80=AFPM Ayush Singh <ayush@beagleboard.org>=
 wrote:
>
> - I am not sure if Rust abstractions should have a seperate entry in
>   MAINTAINERS with me as the maintainer, or if they should just be added
>   to the respective subsystem entries.

This is up to the subsystem maintainers where the respective
abstractions may belong to. Some subsystems prefer to get a
co-maintainers for the entire subsystem (e.g. because they want help
with maintenance; see "M:" entries with "(RUST)"), others prefer to
have a sub-entry (sub-subsystem) where you would maintain the Rust
side (see e.g. entries' titles with "[RUST]"), others prefer to own
the Rust code, etc.

Then another question is how the patches should flow: some maintainers
may prefer to get a PR from you, others may prefer to take the patches
directly after you review them, etc.

I have some notes at:

  https://rust-for-linux.com/rust-kernel-policy#how-is-rust-introduced-in-a=
-subsystem

I hope that helps!

Cheers,
Miguel

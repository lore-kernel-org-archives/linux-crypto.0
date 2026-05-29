Received: from mail.nessuent.net (mail.nessuent.net [188.245.177.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ADA34E746;
	Fri, 29 May 2026 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.177.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780087123; cv=none; b=SLMgMOgZycxSzkbX+tgmj6+mkkOR9tfC/ebojxiV98V8vjJ9Cw8hfDpc/N0k5489OnuoOVSCftOZYEUQTnrQ9FQelR9SdBJ1iAkolobCWdVXxKnLeaDYP82suTlGvxh+/aSybM828VXAPWhrm7OBUPn4S4/yMwAdZtFjd5R10ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780087123; c=relaxed/simple;
	bh=P9zkL2wSf0NtTzrr9NaBIzkk4AEbyJTf4/kuZeX/+v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=XomXEGwyEeaQSxbqNtdGJVaEdKDYvVaQFoAVEHrkai3SzPCvh9RH4eAKLXZWino4ycFGpaliGovYXyx8O9rtYcVfcBXVHw3q5aFi/xtcWIxvRLK7xd7riXVu2KJUrLjxKWPCkGNkaHZOsTEvFTOQ3RU1uEe2w8Kiiz7K/f3fQus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is; spf=pass smtp.mailfrom=pitsidianak.is; dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b=MYy+WWMm; arc=none smtp.client-ip=188.245.177.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b="MYy+WWMm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pitsidianak.is;
	s=mailSelector; t=1780087118;
	bh=P9zkL2wSf0NtTzrr9NaBIzkk4AEbyJTf4/kuZeX/+v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
	b=MYy+WWMmos4Xv7Lk1MsYLiG7FKILIzHV/+V0wYpvIGMIVXPcxNsRwijQmS/gLui3A
	 HprK6ZzORNuYtsEm4+yJZa3QhFy43icWV8bua4vjg+R1de0MrvAWGd5QG5LG9SJ9vz
	 PCzq6yv4l0I76Cade/7HMkE3We8bkoCrcTSWCToTjDWVQYmffn7CJofYNbOLG+xw/h
	 zcXHwEBdZ6+vIi78rk7ft6Z3yzyb9khsXmfdlKEMZNVplFxF2gqW92qM5O8lnbQaG/
	 Fqqo9jaKgVPnO3UWakH2jNmBAZhvN6tUF+UnS+4o+pAQmRvn774QqrcL6ZwAak8w2G
	 BEjZUgsQuT2ZJ0/HCExxDMcwls8NPt52et8gOQhopJ0X52uN5cuXdNDdWIb38qMcrJ
	 hVx3OLKw/mbxQv1HzqWhGGtwNz2MKEsfl2RVHQPcmHacXOLcM5XCF1u0YGgEJ1ok83
	 RPtTdWD2x4qSu7RCQqAvrYk7CgyIc44t4/YPRGuGQl+1klSeWjKH0rl1nil9otEkJ3
	 GUpivlYo6Vx8sLBAmLXO0F68SxoDkTGK5/g7QU3DrTsVlGlccFr7HhtrM8D3wzkyRp
	 rUXQHxpSDwxAqRQIVNKtc/soJ9SJO25kEKbEU/1gwngOPRaezVn8yuV0tXz0KRF210
	 qlMa5njP+7Hx7B5Qy5UxmQ3k=
Date: Fri, 29 May 2026 23:35:21 +0300
From: Manos Pitsidianakis <manos@pitsidianak.is>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, Bj=?UTF-8?B?w7Y=?=rn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, manos.pitsidianakis@linaro.org
Subject: Re: [PATCH 0/2] Add hw_random Rust bindings
User-Agent: meli/0.8.13
References: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is> <CANiq72mU=yQ_L_D6emvTj4c5E_ankLFvpXzkE7yTfcYfLB5T=g@mail.gmail.com>
In-Reply-To: <CANiq72mU=yQ_L_D6emvTj4c5E_ankLFvpXzkE7yTfcYfLB5T=g@mail.gmail.com>
Message-ID: <tftg0b.hvzv4shfwv46@pitsidianak.is>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8; format=flowed

Hi Miguel,

On Fri, 29 May 2026 23:02, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>On Fri, May 29, 2026 at 5:50 PM Manos Pitsidianakis
><manos@pitsidianak.is> wrote:
>>
>> A virtio-rng Rust driver that uses them will be submitted as a separate
>> series since it also depends on the virtio abstractions series.
>
>Please include that at least as a reference to a branch or similar,
>since in most cases the user is needed to evaluate abstractions etc.


Good point, thanks.

My WIP branch is here 
https://github.com/epilys/linux/tree/b4/rust-virtio-rng (HEAD is the 
driver that uses the abstraction in this series)

It uses atomics instead of a spinlock since we can't sleep during virtio 
driver probe. I didn't want to overcomplicate it by deferring all the 
sleeping work to a workqueue, but maybe it's a necessity until we get 
spinlocks that can disable IRQs.


>
>Thanks!
>
>Cheers,
>Miguel

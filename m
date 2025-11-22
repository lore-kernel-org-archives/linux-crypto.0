Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1188B1E47CC
	for <linux-crypto@vger.kernel.org>; Sat, 22 Nov 2025 23:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763853802; cv=none; b=Ufa2TEW98YOmcooCPEBHqkQVe3Y+yByb7MEegKNu3QabCGmqaPhfQ7ktxLCKcHzJ/N7SO6Pcjy8L4CEgEruv/00H+JQ7IdPFPUVtEgE8OuDRTO9xYYAu8EpjZbbxjBZTbpEQVz8SE/dDLGcVCcswKreVw/fY//jB+ky4LOmM5Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763853802; c=relaxed/simple;
	bh=jBD2qYdWoljKo1K1W18LnGHk8HgQ28Ueoeeibldsohg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OEleJlXzZ8LjiuG+FcZEUC8F79TYpZeaou5L6GwPjslHe2roWVpjtKMkmjid+Bqp+pL0AuR2698+KRJHy7AhO5XLGKR9/tc+aWsRLoMoj15DmCZfo77oDH9uVHLS0w1yKW7rzPyc+MEiMZEYlll904pP4wufoziXdOkG7Tki2Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RGeJWhRq; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RGeJWhRq"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763853788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MSZINowlPY+Tkr86sehvG9r5JvyfZl+PL5R2MKWVqCk=;
	b=RGeJWhRqE/wQ/dBVipy9eS0cVmGJ8XpRinQnqGEJhjqlwl8QBz/dPQw5B3jMxCsGyXGWVo
	bC/x+Dsp0auKFecuWRaD1MG2s40xkgK7jVYpuFHfnBMhGpD9PW3sIJiqsTS/b7I9/iIzxM
	Ok+FRpcvw64brW9JEhciv2R478aMSO4=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC <
 12.2 on i386
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20251122200402.GD5803@quark>
Date: Sun, 23 Nov 2025 00:23:02 +0100
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <90EF627D-97C7-4CE2-B5CD-80000567F361@linux.dev>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
 <20251122200402.GD5803@quark>
To: Eric Biggers <ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 22. Nov 2025, at 21:04, Eric Biggers wrote:
> On Sat, Nov 22, 2025 at 11:55:31AM +0100, Thorsten Blum wrote:
>> The GCC bug only occurred on i386 and has been resolved since GCC =
12.2.
>> Limit the frame size workaround to GCC < 12.2 on i386.
>>=20
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
>=20
> How about we do it without the nested ifeq?
>=20
> ifeq ($(CONFIG_X86_32)$(CONFIG_CC_IS_GCC)_$(call gcc-min-version, =
120200),yy_)
> CFLAGS_blake2b.o :=3D -Wframe-larger-than=3D4096 #  =
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D105930
> endif

I considered it and went with the nested ifeq, but I'm fine with both.

> Also, according to the bugreport this was a regression in gcc 12.  =
With
> it having been fixed in 12.2, i.e. within the same gcc release series,
> is this workaround still worth carrying at all?

Not sure - gcc 8.1.0 is still the min version supported by the kernel.

Thorsten


Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BCE1DDDD
	for <linux-crypto@vger.kernel.org>; Sun, 23 Nov 2025 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763917218; cv=none; b=Kpwf3KvmBbSv9e9HoJLSUGcJCdmw1+VRaem+11fBJC0JTNfJWoCtJbqybtbsHSwv2qow6n1xi8K+2sN6dVs91H2k3qKvMmre9mv7w/TP3RhrovC+ivGDj++Gs9LjDpCJTLeQrdxSB41m67t5Q8qERD1hcdEHsPcobBjfmzJSIys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763917218; c=relaxed/simple;
	bh=xu4/NAp9CrEChv5OAz35w3rWrluVIpgR0B7PvZZ95V0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lbh/gaFjtv1LM8ikGR6D5vcPQdE5RztOSq8QzgAUVpKZ+XNt7siaTZZ+KCKwslXY5STUt9MHbVy7XrkLpGZJboePM23FUA/Ux2yUyWMRoqiUbYFmknqOQWvREyGWoap9CFMcYDEU2KUHA2QuAVj8kKYI3S1MjJ6CejxRyQFiwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eY8Gn8Ti; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eY8Gn8Ti"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763917204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mW0ngaEizqT72Yb8EDT9IsK8XyQModcoE3gvhR+5+8o=;
	b=eY8Gn8TipO5M9klrPTcI9vtFYCB+qrF7XW65XWAZ7L0zV6oxYazx7G+3c9LFMzCyitGqCr
	FNECiwywCSm6+HXsZfvG6n6qU8lrcO5uUsgDEgcWS7yjR0pt9AXiCNyGSsVt6ac/RlXjgp
	+/qVHdIFPGl0CfDHzdGVOZe7OdXfR3I=
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
In-Reply-To: <20251123092840.44c92841@pumpkin>
Date: Sun, 23 Nov 2025 18:00:01 +0100
Cc: Eric Biggers <ebiggers@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0EA9C088-D1B1-4E6E-B42F-EFE9C69D1005@linux.dev>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
 <20251123092840.44c92841@pumpkin>
To: david laight <david.laight@runbox.com>
X-Migadu-Flow: FLOW_OUT

On 23. Nov 2025, at 10:28, david laight wrote:
> On Sat, 22 Nov 2025 11:55:31 +0100
> Thorsten Blum <thorsten.blum@linux.dev> wrote:
>=20
>> The GCC bug only occurred on i386 and has been resolved since GCC =
12.2.
>> Limit the frame size workaround to GCC < 12.2 on i386.
>>=20
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> lib/crypto/Makefile | 4 ++++
>> 1 file changed, 4 insertions(+)
>>=20
>> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
>> index b5346cebbb55..5ee36a231484 100644
>> --- a/lib/crypto/Makefile
>> +++ b/lib/crypto/Makefile
>> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL) +=3D gf128mul.o
>>=20
>> obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) +=3D libblake2b.o
>> libblake2b-y :=3D blake2b.o
>> +ifeq ($(CONFIG_X86_32),y)
>> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
>> CFLAGS_blake2b.o :=3D -Wframe-larger-than=3D4096 #  =
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D105930
>> +endif # CONFIG_CC_IS_GCC
>> +endif # CONFIG_X86_32
>=20
> Isn't that just going to cause a run-time stack overflow?

My change doesn't cause a runtime stack overflow, it's just a compiler
warning. There's more information in commit 1d3551ced64e ("crypto:
blake2b: effectively disable frame size warning").

Given the kernel test robot results with GCC 15.1.0 on m68k, we should
probably make this conditional on GCC (any version). Clang produces much
smaller stack frames and should be fine with the default warning
threshold.

I'll send a v2.

Thanks,
Thorsten


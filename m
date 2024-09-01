Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D4844393;
	Sun,  1 Sep 2024 18:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725214015; cv=none; b=Pul/pV2SuubqxsPRbjPmOwyHNa6oFaVaRCfV9Z7ALEBS3nomuyzDUjtjtuP1xP6O0jgsZyZ5fHtsg6aF8yGUKwDg4ECEp7iEXcJpXp56ujaXbbzNY0SWHfsDiBNzgCw/SVFaJ/SoWZT/s/8wduJ+I9h2yhsAyQrFg31MjxA0IUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725214015; c=relaxed/simple;
	bh=BPLrJN3UMpNuXgRmPmDcj2geSPj996SWXjtw9iHJaKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JwTmjyFSMI4VtJKkXXGYLESXyVOlHRAoJRsoP69bPQBGzCpN5FdT7dI5h673rKgo7OZkIPNC/5WPo4CbPvr4IYvwATgMiN1mX9i9YVZ2jApqnYJ1fCd4DxH/0DHjPTmWuupCPR7Yo2iggA6vMjBFLaDxi3cQ5VulASWkruOLflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4WxfwX1D6zz9sSN;
	Sun,  1 Sep 2024 20:06:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hNS5A6He75iU; Sun,  1 Sep 2024 20:06:52 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4WxfwX0N6Nz9sSK;
	Sun,  1 Sep 2024 20:06:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id EE2908B767;
	Sun,  1 Sep 2024 20:06:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id tZRK63f112yO; Sun,  1 Sep 2024 20:06:51 +0200 (CEST)
Received: from [192.168.234.154] (unknown [192.168.234.154])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7A6918B763;
	Sun,  1 Sep 2024 20:06:51 +0200 (CEST)
Message-ID: <88982e01-9d69-4ac6-a423-ecfe700abc1b@csgroup.eu>
Date: Sun, 1 Sep 2024 20:06:51 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for
 all architectures
To: Xi Ruoyao <xry111@xry111.site>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
 Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20240901061315.15693-2-xry111@xry111.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 01/09/2024 à 08:13, Xi Ruoyao a écrit :
> Without a prototype, we'll have to add a prototype for each architecture
> implementing vDSO getrandom.  As most architectures will likely have the
> vDSO getrandom implemented in a near future, and we'd like to keep the
> declarations compatible everywhere (to ease the Glibc work), we should
> really just have one copy of the prototype.

It is a good idea but it have to handle all architectures, not only half 
of them. If you look into vdso_config.h in selftests, you can see that 
there are two names:

__kernel_getrandom is used on arm64, powerpc, s390,

__vdso_getrandom is used on arm, mips, sparc, x86, riscv, loongarch

Christophe



> 
> Suggested-by: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>   arch/x86/entry/vdso/vgetrandom.c | 2 --
>   include/vdso/getrandom.h         | 5 +++++
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
> index 52d3c7faae2e..430862b8977c 100644
> --- a/arch/x86/entry/vdso/vgetrandom.c
> +++ b/arch/x86/entry/vdso/vgetrandom.c
> @@ -6,8 +6,6 @@
>   
>   #include "../../../../lib/vdso/getrandom.c"
>   
> -ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> -
>   ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
>   {
>   	return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
> diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
> index 4cf02e678f5e..08b47b002bf7 100644
> --- a/include/vdso/getrandom.h
> +++ b/include/vdso/getrandom.h
> @@ -56,4 +56,9 @@ struct vgetrandom_state {
>    */
>   extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);
>   
> +/**
> + * __vdso_getrandom: Prototype of vDSO getrandom.
> + */
> +extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> +
>   #endif /* _VDSO_GETRANDOM_H */

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5BB223C55;
	Thu, 12 Dec 2024 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734027880; cv=none; b=d5xhF/dlhv1KqBMhzduXuby5Bi0svbEyMaLjumIZdTaqeC8z3rDpCHJk5je2mpIciaqKZMx2rI0jWOeQ28ktEJvDXT62bUKae6Q3a/zU0+RYS107H2P78zHGgnaUZiQ1oQQEsAk1zA0Do4w7ZBo0yvXTyH4yRGlk48LbMfdOmQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734027880; c=relaxed/simple;
	bh=ABmVqV7Sr6ju3vzD1TlCStS/iRAA5BYzZFgN0WSIZdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLn6ji2IZOkj1V48sGm2n2lZ547tpunzX6gTyGyp6efQVJ4sKoqRKVYj/fOr2ZDC+Z6lILjf0rwcyaBraC/4xMZ4KA841zMRtNL0Qqkul1hxf8ahXptKK5M7mEa18r7iHiwacgKLNJW/P25y64P1ZLb3oiUYeBfmBh35JJso47I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTIFBcup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTIFBcup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C633AC4CED3;
	Thu, 12 Dec 2024 18:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734027879;
	bh=ABmVqV7Sr6ju3vzD1TlCStS/iRAA5BYzZFgN0WSIZdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mTIFBcup6VhyOT8Fwf9cjPQuLaGRzKzQBtEOcJycY7sFCtRkIYozgQ2+c8VtygwK3
	 eU4zObSiyquQo8QlHU8V+ZF+JS0MezqeNiY0mWoBXeA0ulreMBX7kyvloc38T8s3Io
	 y8e5T6UXcinVj/S+IkD8O9x8PEQ8E0qErbVqHKVGrx3t3P5NHWskZ2gxVB+AhR6c3K
	 P9s8WwHfUjRb514O5ew5G/YDLnFqrZ3ebVaYKXkFjY9XXJtA+eSoFnIs6WkBOKwpnQ
	 P52P2Je13Ukhno7VG0chD4uWscZtg7QNNEojQCex05+GCW2L/q3bgxP3rKMo1wsNyN
	 IARUxIsXC5Onw==
Date: Thu, 12 Dec 2024 10:24:36 -0800
From: Kees Cook <kees@kernel.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, yury.norov@gmail.com,
	gustavoars@kernel.org, nathan@kernel.org,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <202412120953.87F2827497@keescook>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241208161315.730138-1-nilay@linux.ibm.com>

On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
> While building the powerpc code using gcc 13.x, I came across following
> errors generated for kernel/padata.c file:
> 
>   CC      kernel/padata.o
> In file included from ./include/linux/string.h:390,
>                  from ./arch/powerpc/include/asm/paca.h:16,
>                  from ./arch/powerpc/include/asm/current.h:13,
>                  from ./include/linux/thread_info.h:23,
>                  from ./include/asm-generic/preempt.h:5,
>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>                  from ./include/linux/preempt.h:79,
>                  from ./include/linux/spinlock.h:56,
>                  from ./include/linux/swait.h:7,
>                  from ./include/linux/completion.h:12,
>                  from kernel/padata.c:14:
> In function ‘bitmap_copy’,
>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>   114 | #define __underlying_memcpy     __builtin_memcpy
>       |                                 ^
> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>       |         ^~~~~~~~~~~~~
> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>       |                          ^~~~~~~~~~~~~~~~~~~~
> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>   259 |                 memcpy(dst, src, len);
>       |                 ^~~~~~
> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>   713 |                                  cpumask_var_t pcpumask,
>       |                                  ~~~~~~~~~~~~~~^~~~~~~~

We've seen this also on x86 with 320 CPUs[1] (which perhaps was already
known since I see Thomas Weißschuh in CC already.

Building with -fdiagnostics-details we see:

In function 'bitmap_copy',
    inlined from 'cpumask_copy' at ../include/linux/cpumask.h:839:2,
    inlined from '__padata_set_cpumasks' at ../kernel/padata.c:723:2:
../include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' reading between 41 and 536870904 bytes from a region of size 40 [-Werror=stringop-overread]
  114 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
../include/linux/fortify-string.h:633:9: note: in expansion of macro '__underlying_memcpy'
  633 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
../include/linux/fortify-string.h:678:26: note: in expansion of macro '__fortify_memcpy_chk'
  678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
../include/linux/bitmap.h:259:17: note: in expansion of macro 'memcpy'
  259 |                 memcpy(dst, src, len);
      |                 ^~~~~~
  '__padata_set_cpumasks': events 1-2
../include/linux/fortify-string.h:613:36:
  612 |         if (p_size_field != SIZE_MAX &&
      |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  613 |             p_size != p_size_field && p_size_field < size)
      |             ~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~
      |                                    |
      |                                    (1) when the condition is evaluated to false
      |                                    (2) when the condition is evaluated to true
  '__padata_set_cpumasks': event 3
  114 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
      |                                 |
      |                                 (3) out of array bounds here

What's happening is that GCC is seeing that the run-time checks of
FORTIFY_SOURCE is checking for this condition (i.e. there is a path
through the code where the bounds could be too large and it still calls
memcpy) -- which is the point of this runtime check -- but that GCC has
found a compile-time path where this can be true.

Built without CONFIG_WERROR, we can examine the padata.o file for the
FORTIFY_SOURCE warning string to find the field:

$ strings gcc-diag/kernel/padata.o | grep ^field
field "dst" at include/linux/bitmap.h:259

which confirms it is this, which has already been seen in the thread:

static __always_inline
void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned
int nbits)
{
        unsigned int len = bitmap_size(nbits);

        if (small_const_nbits(nbits))
                *dst = *src;
        else
                memcpy(dst, src, len);
}

and I think what Nathan already discussed[2] is all true (i.e. that
nr_cpu_ids is unknown -- but bounded to a smaller range than [0..UINT_MAX]
due to the calculation in bitmap_size()). Nathan's fix silences the
warning. We could narrow the scope to only run-time-specified nr_cpus:


diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9278a50d514f..8f1a694109e9 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -836,6 +836,8 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
 static __always_inline
 void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
 {
+	if (!__builtin_constant_p(large_cpumask_bits))
+		BUG_ON(large_cpumask_bits > NR_CPUS);
 	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
 }
 

Or we could avoid the BUG_ON check and simply silence the warning
explicitly:


diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9278a50d514f..0725b26f21b8 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -836,6 +836,8 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
 static __always_inline
 void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
 {
+	if (!__builtin_constant_p(large_cpumask_bits))
+		OPTIMIZER_HIDE_VAR(large_cpumask_bits);
 	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
 }
 
Or we could unconditionally put the OPTIMIZER_HIDE_VAR() inside
bitmap_copy() itself:


diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 262b6596eca5..5503ccabe05a 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -251,12 +251,14 @@ static __always_inline void bitmap_fill(unsigned long *dst, unsigned int nbits)
 static __always_inline
 void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
 {
-	unsigned int len = bitmap_size(nbits);
-
-	if (small_const_nbits(nbits))
+	if (small_const_nbits(nbits)) {
 		*dst = *src;
-	else
+	} else {
+		unsigned int len = bitmap_size(nbits);
+
+		OPTIMIZER_HIDE_VAR(len);
 		memcpy(dst, src, len);
+	}
 }
 
 /*

I prefer any of these to doing the build-system disabling of the
warning.

-Kees

[1] https://lore.kernel.org/all/202411021337.85E9BB06@keescook/
[2] https://lore.kernel.org/all/20241209193558.GA1597021@ax162/

-- 
Kees Cook

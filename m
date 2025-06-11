Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047AD22B8AB
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749668012; cv=none; b=Sm+V5F3WCa7eOc9TqWOIE40r5BDJaUfyvGj2rCCiebO1qXZ8bbOTN/M5p9adij/kzEK6j1f7spUkxht9xGXArOeCQ+vyfpbsKH8YDoBHniwD8ocUQcR9Uqu2get7r5f+caqQdRGPW2POBzCCe1vKZq9lWvg5KfoDU3o8m8SKbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749668012; c=relaxed/simple;
	bh=6PhEVxny/pNtFQ59Y3RQZ7Fspzsg+hSD3GfWX/lMYGE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=MdQ0jLbReWC/CPO3ezxfH/5DEiRtpCELsGewt7pIFR4WnSE+XZJ/7wyY9lp6trN7WFi2denDJrCu5eSNVrpEsIwBgDLFEVDIrtAeVQUzL5DMCNLKOLAX5EE1aWmvPKVyh9Z7U0n7WBRGyQ2XHyRdpwgTa+AcP7a0xDTHQEYJBeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=XA7w2nDL; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="XA7w2nDL"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1749668005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z9Ngc8BFLZcajbvkbgoSnpknnsO3kDOod4k2hOKAQ5I=;
	b=XA7w2nDLbTvEx2DxApU0fK4nBiU8wSbr+hOWKcheZi+I5vL2p1tRMzmQ4zETvZarA30gX9
	A7nxAFeKZUHAegbKYh65W3CkhfCs5WkzYBbseRoWNJOXFtl0UENPifpx4MIzxju4WptBDV
	EjC3t+hQfz4+Rbi7ml/qrb3IlLwssRRcNfOiDXiWoZgDELyVZ8+dtYuDfsFeaJLs4MfPi9
	o+AqRrq36nZpBznuXub2sp4sMGTSe6EtAljk7xZi5U2RzZUuMS4FkpgB528/Gxlk/Rc/QO
	Cg8T/L1ZkcfKUHKQL0EhF8b/XB4lfoKqhsho4z1wdp94O/VwLBTPuhtuFokDnQ==
Content-Type: multipart/signed;
 boundary=a2b9797885f3d11a998329b426c25f7c213f5b963f86d455ce2a3ec162a6;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 11 Jun 2025 20:53:17 +0200
Message-Id: <DAJXJHLY2ITB.3IBN23DX0RO4Z@cknow.org>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Franzki" <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
To: "Eric Biggers" <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
References: <20250611175525.42516-1-ebiggers@kernel.org>
In-Reply-To: <20250611175525.42516-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

--a2b9797885f3d11a998329b426c25f7c213f5b963f86d455ce2a3ec162a6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

I was about to respond to your reply, but I guess this may be a better
fit for it. The TL;DR: version is this:

If you think distros shouldn't enable it, as you initially clearly
described and it seems to me you still think so, the right thing for
distros to do, is to disable those test. Which in turn means the fast
tests should not be reinstated (?).

On Wed Jun 11, 2025 at 7:55 PM CEST, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Commit 698de822780f ("crypto: testmgr - make it easier to enable the
> full set of tests") removed support for building kernels that run only
> the "fast" set of crypto self-tests by default.  This assumed that
> nearly everyone actually wanted the full set of tests, *if* they had
> already chosen to enable the tests at all.
>
> Unfortunately, it turns out that both Debian and Fedora have the crypto
> self-tests enabled in their production kernels, and they seem to want to

I explicitly referenced https://bugs.debian.org/599441 as that was the
only justification I found for enabling it.
In it, on 2010-10-07 "Mario 'BitKoenig' Holbe" said:

  I personally think (re)enabling these tests would be a way safer
  default for a distribution kernel which runs on lots of different
  hardware setups

Before I looked up that bug, I had not heard of that person, so I don't
know if they're a crypto expert or just a random person on the internet.
It also doesn't say *why* they thought it would be a good idea to enable
those tests.
I have no idea what Fedora's reasoning was for enabling it. Maybe their
reasons were sound; I think Debian's are rather thin (that I could
find). And from ~ 15 years ago.

> keep them enabled.  The full set of tests isn't great for that, since

I think the 'new' description is(/was) great. A subject matter expert
says/said "don't enable this on production kernels". I wish all Kconfig
help texts were this clear :-)
So based on the previous description, it seems wise that Debian (and
Fedora) would update their kernel config and disable those test.

In *my* update to 6.16-rc1, I only 'converted' to new names.
A change to my kernel config (ie disable the tests) would be in a
separate commit (with an appropriate commit msg).
I hadn't done that yet as I was curious what the results would be.

So "they seem to want to keep them enabled" seems a premature
conclusion; at least wrt Debian and AFAICT.
It's also possible that if/when people see the kernel warning, they'd
file a new Debian bug to have it disabled.

(I've made some contributions in the past, but) I am not part of
Debian's kernel team, so I don't know what they will decide.
=20
I'll gladly leave it up to you if you still think reinstating the fast
tests is worth it, but I felt a bit more context was warranted.

Cheers,
  Diederik

> they take significantly longer to run and slow down the boot.
>
> One issue is that the crypto self-tests are being (mis)used to meet FIPS
> 140-3 pre-operational testing requirements.  But actually the more
> fundamental issue is that the crypto/ subsystem has many buggy and
> untested drivers for off-CPU hardware accelerators on rare platforms.
> As a result, apparently in some cases the tests are actually being
> relied on *in production kernels* to stop buggy drivers from being used.
> I think this is kind of crazy (untested drivers should just not be
> enabled at all), but that seems to be how things work currently.
>
> Thus, reintroduce a kconfig option that controls the level of testing.
> Instead of the original CRYPTO_MANAGER_EXTRA_TESTS which was confusing
> and disabled by default, go with CRYPTO_SELFTESTS_FULL which is enabled
> by default (but dependent on CRYPTO_SELFTESTS, of course).
>
> Given the "production kernel" use cases, also remove the dependency on
> DEBUG_KERNEL from CRYPTO_SELFTESTS.  It was introduced by
> commit 40b9969796bf ("crypto: testmgr - replace
> CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS") and wasn't present
> on the original option.
>
> I also haven't reinstated all the #ifdefs in crypto/testmgr.c.  Instead,
> just rely on the compiler to optimize out unused code.
>
> Fixes: 40b9969796bf ("crypto: testmgr - replace CRYPTO_MANAGER_DISABLE_TE=
STS with CRYPTO_SELFTESTS")
> Fixes: 698de822780f ("crypto: testmgr - make it easier to enable the full=
 set of tests")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>
> This patch is targeting the crypto tree for 6.16.
>
>  crypto/Kconfig                 | 18 ++++++++++++++----
>  crypto/testmgr.c               | 15 ++++++++++++---
>  include/crypto/internal/simd.h |  6 ++++--
>  lib/crypto/Makefile            |  2 +-
>  4 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e9fee7818e270..8612ebf655647 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -174,20 +174,30 @@ config CRYPTO_USER
>  	  Userspace configuration for cryptographic instantiations such as
>  	  cbc(aes).
> =20
>  config CRYPTO_SELFTESTS
>  	bool "Enable cryptographic self-tests"
> -	depends on DEBUG_KERNEL
>  	help
>  	  Enable the cryptographic self-tests.
> =20
>  	  The cryptographic self-tests run at boot time, or at algorithm
>  	  registration time if algorithms are dynamically loaded later.
> =20
> -	  This is primarily intended for developer use.  It should not be
> -	  enabled in production kernels, unless you are trying to use these
> -	  tests to fulfill a FIPS testing requirement.
> +config CRYPTO_SELFTESTS_FULL
> +	bool "Enable the full set of cryptographic self-tests"
> +	depends on CRYPTO_SELFTESTS
> +	default y
> +	help
> +	  Enable the full set of cryptographic self-tests for each algorithm.
> +
> +	  For development and pre-release testing, leave this as 'y'.
> +
> +	  If you're keeping the crypto self-tests enabled in a production
> +	  kernel, you likely want to set this to 'n' to speed up the boot.  Thi=
s
> +	  will cause the "slow" tests to be skipped.  This may suffice for a
> +	  quick sanity check of drivers and for FIPS 140-3 pre-operational self=
-
> +	  testing, but some issues can be found only by the full set of tests.
> =20
>  config CRYPTO_NULL
>  	tristate "Null algorithms"
>  	select CRYPTO_ALGAPI
>  	select CRYPTO_SKCIPHER
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 72005074a5c26..32f753d6c4302 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -43,17 +43,22 @@ MODULE_IMPORT_NS("CRYPTO_INTERNAL");
> =20
>  static bool notests;
>  module_param(notests, bool, 0644);
>  MODULE_PARM_DESC(notests, "disable all crypto self-tests");
> =20
> +#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
>  static bool noslowtests;
>  module_param(noslowtests, bool, 0644);
>  MODULE_PARM_DESC(noslowtests, "disable slow crypto self-tests");
> =20
>  static unsigned int fuzz_iterations =3D 100;
>  module_param(fuzz_iterations, uint, 0644);
>  MODULE_PARM_DESC(fuzz_iterations, "number of fuzz test iterations");
> +#else
> +#define noslowtests 1
> +#define fuzz_iterations 0
> +#endif
> =20
>  #ifndef CONFIG_CRYPTO_SELFTESTS
> =20
>  /* a perfect nop */
>  int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
> @@ -317,13 +322,13 @@ struct testvec_config {
> =20
>  #define TESTVEC_CONFIG_NAMELEN	192
> =20
>  /*
>   * The following are the lists of testvec_configs to test for each algor=
ithm
> - * type when the fast crypto self-tests are enabled.  They aim to provid=
e good
> - * test coverage, while keeping the test time much shorter than the full=
 tests
> - * so that the fast tests can be used to fulfill FIPS 140 testing requir=
ements.
> + * type when the "fast" crypto self-tests are enabled.  They aim to prov=
ide good
> + * test coverage, while keeping the test time much shorter than the "ful=
l" tests
> + * so that the "fast" tests can be enabled in a wider range of circumsta=
nces.
>   */
> =20
>  /* Configs for skciphers and aeads */
>  static const struct testvec_config default_cipher_testvec_configs[] =3D =
{
>  	{
> @@ -1181,18 +1186,22 @@ static void generate_random_testvec_config(struct=
 rnd_state *rng,
>  	WARN_ON_ONCE(!valid_testvec_config(cfg));
>  }
> =20
>  static void crypto_disable_simd_for_test(void)
>  {
> +#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
>  	migrate_disable();
>  	__this_cpu_write(crypto_simd_disabled_for_test, true);
> +#endif
>  }
> =20
>  static void crypto_reenable_simd_for_test(void)
>  {
> +#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
>  	__this_cpu_write(crypto_simd_disabled_for_test, false);
>  	migrate_enable();
> +#endif
>  }
> =20
>  /*
>   * Given an algorithm name, build the name of the generic implementation=
 of that
>   * algorithm, assuming the usual naming convention.  Specifically, this =
appends
> diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/sim=
d.h
> index 7e7f1ac3b7fda..9e338e7aafbd9 100644
> --- a/include/crypto/internal/simd.h
> +++ b/include/crypto/internal/simd.h
> @@ -42,13 +42,15 @@ void simd_unregister_aeads(struct aead_alg *algs, int=
 count,
>   * crypto_simd_usable() - is it allowed at this time to use SIMD instruc=
tions or
>   *			  access the SIMD register file?
>   *
>   * This delegates to may_use_simd(), except that this also returns false=
 if SIMD
>   * in crypto code has been temporarily disabled on this CPU by the crypt=
o
> - * self-tests, in order to test the no-SIMD fallback code.
> + * self-tests, in order to test the no-SIMD fallback code.  This overrid=
e is
> + * currently limited to configurations where the "full" self-tests are e=
nabled,
> + * because it might be a bit too invasive to be part of the "fast" self-=
tests.
>   */
> -#ifdef CONFIG_CRYPTO_SELFTESTS
> +#ifdef CONFIG_CRYPTO_SELFTESTS_FULL
>  DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
>  #define crypto_simd_usable() \
>  	(may_use_simd() && !this_cpu_read(crypto_simd_disabled_for_test))
>  #else
>  #define crypto_simd_usable() may_use_simd()
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 3e79283b617d9..f9e44aac6619b 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -60,9 +60,9 @@ libsha256-y					:=3D sha256.o
>  obj-$(CONFIG_CRYPTO_LIB_SHA256_GENERIC)		+=3D libsha256-generic.o
>  libsha256-generic-y				:=3D sha256-generic.o
> =20
>  obj-$(CONFIG_MPILIB) +=3D mpi/
> =20
> -obj-$(CONFIG_CRYPTO_SELFTESTS)			+=3D simd.o
> +obj-$(CONFIG_CRYPTO_SELFTESTS_FULL)		+=3D simd.o
> =20
>  obj-$(CONFIG_CRYPTO_LIB_SM3)			+=3D libsm3.o
>  libsm3-y					:=3D sm3.o
>
> base-commit: aef17cb3d3c43854002956f24c24ec8e1a0e3546


--a2b9797885f3d11a998329b426c25f7c213f5b963f86d455ce2a3ec162a6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCaEnQnwAKCRDXblvOeH7b
bj9mAP98h7N1N7UhiG7N/oWUjkZAFnUeL4ZDV1EjWptXXp12zQEA5CpLBrl9zQ70
f2LcDH+l+KfOk78W1yjoGGMqCBPM/A8=
=XUmy
-----END PGP SIGNATURE-----

--a2b9797885f3d11a998329b426c25f7c213f5b963f86d455ce2a3ec162a6--

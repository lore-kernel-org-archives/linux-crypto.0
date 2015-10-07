From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] crypto x86/camellia_aesni_avx: Fix CPU feature checks
Date: Wed, 7 Oct 2015 09:25:58 +0200
Message-ID: <20151007072558.GF7837@gmail.com>
References: <1444131093.2956.122.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	=?iso-8859-1?Q?St=E9phane?= Glondu <glondu@debian.org>,
	stable <stable@vger.kernel.org>, x86@kernel.org,
	Dave Hansen <dave@sr71.net>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33016 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbJGH0C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Oct 2015 03:26:02 -0400
Content-Disposition: inline
In-Reply-To: <1444131093.2956.122.camel@decadent.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


* Ben Hutchings <ben@decadent.org.uk> wrote:

> We need to explicitly check the AVX and AES CPU features, as we can't
> infer them from the related XSAVE feature flags.  For example, the
> Core i3 2310M passes the XSAVE feature test but does not implement
> AES-NI.
>=20
> Reported-and-tested-by: St=E9phane Glondu <glondu@debian.org>
> References: https://bugs.debian.org/800934
> Fixes: ce4f5f9b65ae ("x86/fpu, crypto x86/camellia_aesni_avx: Simplif=
y...")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable <stable@vger.kernel.org> # 4.2
> ---
>  arch/x86/crypto/camellia_aesni_avx_glue.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/cry=
pto/camellia_aesni_avx_glue.c
> index 80a0e43..bacaa13 100644
> --- a/arch/x86/crypto/camellia_aesni_avx_glue.c
> +++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
> @@ -554,6 +554,11 @@ static int __init camellia_aesni_init(void)
>  {
>  	const char *feature_name;
> =20
> +	if (!cpu_has_avx || !cpu_has_aes || !cpu_has_osxsave) {
> +		pr_info("AVX or AES-NI instructions are not detected.\n");
> +		return -ENODEV;
> +	}
> +
>  	if (!cpu_has_xfeatures(XSTATE_SSE | XSTATE_YMM, &feature_name)) {
>  		pr_info("CPU feature '%s' is not supported.\n", feature_name);
>  		return -ENODEV;

Good catch!

Do we still need the cpu_has_xfeatures() check after the cpuid based ch=
eck?

Thanks,

	Ingo

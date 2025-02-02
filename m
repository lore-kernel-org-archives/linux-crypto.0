Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CA11F9EAA;
	Sun,  2 Feb 2025 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738506563; cv=none; b=dwSsj/WFaqoGYTNkX2XjupNr7Tx46JLqlxjoIWESA/5nXy2YwFulUMUEGz7whIUlIHZgF9hf4Ewuye139e+9ik4UVWETxduK0HD7gyvyJePbK+2XBN3z1WFeRgNcjXFwv1G6x/+NtA9X6atnCcZyxoz0qF/4zyozGGgqQ4QIUVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738506563; c=relaxed/simple;
	bh=wcP4QoOPfXwxQI9jtMm804m9A95CiiZXwoUcmIfrRbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aAvHYUVz6jMHKtXdWt8vXI6NNg1jp53Okmmii0pbKgVK+BQ6gAXIMNSfVc6EeR9eyZiWr72M3mDUsYjWgATxQpGmQ93mf+l17fGXr/L0vaNbSTpA9vl8m7pC7EYtnn/wT6e4bQ7MQ33C0nSKZhxx55R/iuC+6L9eCkLwcbYRP/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7buWDMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7buWDMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1390C4AF09;
	Sun,  2 Feb 2025 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738506563;
	bh=wcP4QoOPfXwxQI9jtMm804m9A95CiiZXwoUcmIfrRbE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J7buWDMyF1NY03PIWqh0Bn5gkRyuP743cs1pRVNNKntbr+bco5u3RzH1tuXKLRBb9
	 rsHGpOgYJ+2SP6D+lza7TZBmbs924fcivA7uPWrx5RPArd3gGFPCxSHl1QN5VWzHvS
	 F8hyvlwxTw96dyfNaedCPf8A7hlblvSoFnUuTf6ZbHbHfo02AAYMnLCGkeGRufOCCu
	 7CxT/Trmt0K6ov7vw4FmXsiI6GfF8Di7cvECQUpKogDz6F+MynbBObiIswAsXOdDb2
	 loUwCGYJtn1T91zy/lJLyy6tJ9mN7mB96P+JxE6Dt4HATlOq+rTcYJ/IlDTAGu3rfN
	 +QI3yvAnZzNsA==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53e3c47434eso3726459e87.3;
        Sun, 02 Feb 2025 06:29:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUa725kQUgkmsibKLZGoTOqGO4gk13bw4zTPzhZlqW+FW8bpKJJ/12QwUHDBmAhDoLZy+KlDo9L8hOHDkU7@vger.kernel.org, AJvYcCVkyhyuEb8Wuwjj6E3fcGJYraLLH4ScFnyPjSNJ+cw4JvNZzemqaMfz5Hhyo0ikPSANDaYdkwNrAReh7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyT+w9LoG0Wj04ZlYAUP8NtCaP3vMV1eimwSrRPBuqlM5KIr7W+
	Lp1i+O5ac4Gd1rr9ifXcihHoRgiuZtSbjl/Yqo8DmzxIUSTJQhkyr3f7D3xlHI7ApsHRMgpwmO8
	jqtfPyd0ykqrPjGJzH63L0TLepIw=
X-Google-Smtp-Source: AGHT+IG6/EIeIDxZP25bIChWRjdKRZxsJ99L1EpFBIF5AhhKjXtuGuJXPDB1YxIkDSb6pZAJiK4oV1ltsuan6ljgY7k=
X-Received: by 2002:a05:651c:210b:b0:300:12d1:37e8 with SMTP id
 38308e7fff4ca-30796839e6amr67288101fa.12.1738506561295; Sun, 02 Feb 2025
 06:29:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130035130.180676-1-ebiggers@kernel.org> <20250130035130.180676-5-ebiggers@kernel.org>
In-Reply-To: <20250130035130.180676-5-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 2 Feb 2025 15:29:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEH89x0fqhs2jmK2RFkg9jPPNS-rnWm5qmBLK58wgJNrQ@mail.gmail.com>
X-Gm-Features: AWEUYZlbCFdGtwcnPfAFbHGsb5FR4jekMyqC0sQEXU7vSvGvi33FRmlVPcL-nEI
Message-ID: <CAMj1kXEH89x0fqhs2jmK2RFkg9jPPNS-rnWm5qmBLK58wgJNrQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] lib/crc_kunit.c: add test and benchmark for CRC64-NVME
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 04:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Wire up crc64_nvme() to the new CRC unit test and benchmark.
>
> This replaces and improves on the test coverage that was lost by
> removing this CRC variant from the crypto API.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  lib/crc_kunit.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crc_kunit.c b/lib/crc_kunit.c
> index 6a61d4b5fd45..1e82fcf9489e 100644
> --- a/lib/crc_kunit.c
> +++ b/lib/crc_kunit.c
> @@ -30,11 +30,12 @@ static size_t test_buflen;
>   *     polynomial coefficients in each byte), false if it's a "big endian" CRC
>   *     (natural mapping between bits and polynomial coefficients in each byte)
>   * @poly: The generator polynomial with the highest-order term omitted.
>   *       Bit-reversed if @le is true.
>   * @func: The function to compute a CRC.  The type signature uses u64 so that it
> - *       can fit any CRC up to CRC-64.
> + *       can fit any CRC up to CRC-64.  The function is expected to *not*
> + *       invert the CRC at the beginning and end.
>   * @combine_func: Optional function to combine two CRCs.
>   */
>  struct crc_variant {
>         int bits;
>         bool le;
> @@ -405,10 +406,35 @@ static void crc64_be_test(struct kunit *test)
>  static void crc64_be_benchmark(struct kunit *test)
>  {
>         crc_benchmark(test, crc64_be_wrapper);
>  }
>
> +/* crc64_nvme */
> +
> +static u64 crc64_nvme_wrapper(u64 crc, const u8 *p, size_t len)
> +{
> +       /* The inversions that crc64_nvme() does have to be undone here. */
> +       return ~crc64_nvme(~crc, p, len);
> +}
> +
> +static const struct crc_variant crc_variant_crc64_nvme = {
> +       .bits = 64,
> +       .le = true,
> +       .poly = 0x9a6c9329ac4bc9b5,
> +       .func = crc64_nvme_wrapper,
> +};
> +
> +static void crc64_nvme_test(struct kunit *test)
> +{
> +       crc_test(test, &crc_variant_crc64_nvme);
> +}
> +
> +static void crc64_nvme_benchmark(struct kunit *test)
> +{
> +       crc_benchmark(test, crc64_nvme_wrapper);
> +}
> +
>  static struct kunit_case crc_test_cases[] = {
>         KUNIT_CASE(crc16_test),
>         KUNIT_CASE(crc16_benchmark),
>         KUNIT_CASE(crc_t10dif_test),
>         KUNIT_CASE(crc_t10dif_benchmark),
> @@ -418,10 +444,12 @@ static struct kunit_case crc_test_cases[] = {
>         KUNIT_CASE(crc32_be_benchmark),
>         KUNIT_CASE(crc32c_test),
>         KUNIT_CASE(crc32c_benchmark),
>         KUNIT_CASE(crc64_be_test),
>         KUNIT_CASE(crc64_be_benchmark),
> +       KUNIT_CASE(crc64_nvme_test),
> +       KUNIT_CASE(crc64_nvme_benchmark),
>         {},
>  };
>
>  static struct kunit_suite crc_test_suite = {
>         .name = "crc",
> --
> 2.48.1
>

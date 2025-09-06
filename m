Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B2019049B;
	Sat,  6 Sep 2025 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757201451; cv=none; b=bejrdVwRZJ1DpAQQL1WcwJAVBQ0YG6q01+G8vGEi16lNbV1JkLm/jamhb0Y4fRCw+7XQtREkgoWCGJY1XQRRtqyxam0R44knyip/nyipeovToCeENq1w/ksB2DhP+PKa3mRYMkUnpbR+OKHeQqwfHbRNx195pnJxAVjC1wkQxd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757201451; c=relaxed/simple;
	bh=q1iTThsw7oKpa0zcQPp1lbL8O39eXWUFrfG8Gq7JLkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p16SHmtLHHHOF5NKJbDC341MD+gLliLsZFCXh3HgpC9q88pXsxwYV2cOO8ssfcOCbvyCxlYf2JIXWmgqYy4rrYeNXd4cOPjVjfIpR6X88779ZNfbQe33pKfqH9dnlDuDanJmEs/BG+MvFsFTZOxqy2g8JTGh+l+HF8IBinH1SkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxUu0HkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxUu0HkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413B8C4CEE7;
	Sat,  6 Sep 2025 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757201450;
	bh=q1iTThsw7oKpa0zcQPp1lbL8O39eXWUFrfG8Gq7JLkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LxUu0HkE0H8avOiTvooj1Fk/dhVtoRl4Q5BJPmUo6coiGIpXS6RA++E+vyWuiIjI4
	 L55/6QXlwlNPzafdqyJ7tTIlwAZHQU9PqiixX04vyP+5hWCqout9j2LZcphH4BEd86
	 TTdRhs/xeUGOQwpo0GLSjDHlAVShMWNfYe3jVuYYCmc/CRAFmNrM3XcyxISCAO2Pih
	 sFMnCpATcCPr87LzBvkVjd/LUfa5YnRCPpFck68LgJ0JppDpzCBzAsTe5yGmovA8rY
	 pYFEJyDkwNb30v/YpGdYH68O+7CHyW/L+o7wqjjevHsIhEbzCLyZ5fQ3T+PFCIQKwN
	 bJMqX/vv6aTVQ==
Date: Sat, 6 Sep 2025 16:30:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 07/12] lib/crypto: tests: Migrate Curve25519 self-test
 to KUnit
Message-ID: <20250906233048.GA109599@quark>
References: <20250906213523.84915-1-ebiggers@kernel.org>
 <20250906213523.84915-8-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906213523.84915-8-ebiggers@kernel.org>

On Sat, Sep 06, 2025 at 02:35:18PM -0700, Eric Biggers wrote:
> +static struct kunit_case curve25519_test_cases[] = {
> +	KUNIT_CASE(test_curve25519),
> +	KUNIT_CASE(test_curve25519_basepoint),
> +	{},
> +};
> +
> +static struct kunit_suite curve25519_test_suite = {
> +	.name = "curve25519",
> +	.test_cases = curve25519_test_cases,
> +};
> +kunit_test_suite(curve25519_test_suite);

Correction: there should be a module description and license here.

MODULE_DESCRIPTION("KUnit tests and benchmark for Curve25519");
MODULE_LICENSE("GPL");

- Eric

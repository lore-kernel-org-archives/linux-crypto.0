Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880B02F360A;
	Mon, 19 Jan 2026 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768848715; cv=none; b=nhKJiWm7aO2UvvI0gnZD4MyKJZHst8F/g1PPCfaLyrn6kxTqkSTwdlxe/xKEwzcJN9SOW26Dpkv5Y3YGw+vjrVhR5elKyyYgPM9fyb0SkaSp3G5mQxZXNwycccuiiAWrOuM2oIWBZeeg4rfpQ4x+VQQk7iX6aPwWGEP/DNEqZPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768848715; c=relaxed/simple;
	bh=wqmOviZHoDPFYIkUy/Qp7rX/uuzWiF0OrDNpkcE86g0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6lJVOoFKwqk50bfEn+3mhjQXRFFEmMS79P6UYlYGBEKzMEE5Y3Sov9VZTEj2AIGTnpvSlh6xACQG8Zjabmgj+bYuEc4yypMr4pp1QpMfHvXF4n8vmIUnnA9OtWkVqK85KBmYjMgYV+ePK6WmQBPhlbWylSVjqeamTA+EbTwNUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlbqdBs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlbqdBs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DD9C116C6;
	Mon, 19 Jan 2026 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768848715;
	bh=wqmOviZHoDPFYIkUy/Qp7rX/uuzWiF0OrDNpkcE86g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FlbqdBs66PcaR3Ak30ECd4lbhol7fcT0i+Vkr+5fQv3iJjGrFhHUEyJcsEhh4lQMs
	 29YWbc333dcD15I8oEejGcazkLt9+2iqHEYTv4KxAbnM3vXnxm1GycHT/+qxNjAc/U
	 QB5VlaU4bzXFUD0tTiKtDVFfqs/fuAWFlL5XncJYDZFlzlHb+cViSWnqmwpxECKj/u
	 oi521ft+4uVhzmmf/D0qnmouj+K699ElHYB6MtyS59ScYVJKm/Jsiad0oi+I/7YVHG
	 ho14kAYPUOolTukl+y2O2IPRGVfMq1qNx4NupCBCf7z389a/HPWaSKvGeZunYeKS2S
	 PHwHVgyVoqmww==
Date: Mon, 19 Jan 2026 10:51:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: NIST FIPS test vector failures
Message-ID: <20260119185125.GA11957@sol>
References: <1010414.1768841311@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1010414.1768841311@warthog.procyon.org.uk>

On Mon, Jan 19, 2026 at 04:48:31PM +0000, David Howells wrote:
> Hi Eric,
> 
> I'm trying out autogenerating X.509 and PKCS#7 tests from the NIST FIPS test
> vectors here:
> 
> https://github.com/usnistgov/ACVP-Server/tree/master/gen-val/json-files/ML-DSA-sigVer-FIPS204
> 
> Unfortunately, all of them seem to fail, but I'm not sure why.  As far as I
> can tell, test case (tcId) 174, for example, should pass, but does not.
> Attached is a patch that adds that test case to the kunit test for ML-DSA for
> you to try, skipping the X509/PKCS7 stuff and going direct to verification.
> Could you have a look see if I've done anything obviously incorrect?

Have you checked which algorithm test case 174 is meant to test?  It's
in the following test group:

    {
      "tgId": 12,
      "testType": "AFT",
      "parameterSet": "ML-DSA-87",
      "signatureInterface": "internal",
      "externalMu": false,
      "tests": [

Given the "signatureInterface": "internal", it seems it's meant to test
ML-DSA.Verify_internal().  Currently, the kernel ML-DSA code only
supports the "external" interface, i.e. ML-DSA.Verify().  So that test
case isn't applicable to it.

- Eric

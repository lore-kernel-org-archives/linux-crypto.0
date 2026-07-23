Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D984E2ECD1D;
	Thu, 23 Jul 2026 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840026; cv=none; b=i1Nuv+1LgBX3lix49tglULAT4Zr7U0BJxNiLedGrQOB8rbpDB9CMr2M7Ai4G02YpTbxmd21idJbnEWIFqB7Ouu2cNTcpsDPYJWCl5MktMXHxVEk231ROcbyFWAJqvoaXkM6GRhuKt3EE0IvUdD5aYHzxqGRCBLvm9XPQiqqCGUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840026; c=relaxed/simple;
	bh=+7HidkZniv/c4eRYZ/YvnsLRolGGPCemTEPiJIeI7N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8uJLdffuymmFQWGIiqelZpm1+8pu+S7AJGll2znKAIp6iL299Wv58NvqlF6fcr+Rk5PR5zi+YRhSoSOyAxF7+vmmTQxS0DU2GO8FV0o8/uiQKAjgCIdPje3OiXMGbeWJ41g83rtyz5EGQSjFGD9omBVHztg+FsIyeQQOiA0Gus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmdMPyeq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmdMPyeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402D61F000E9;
	Thu, 23 Jul 2026 20:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840024;
	bh=6lWaf+qj0ikUvwRNdH9LXd3Q7sZtHDIwywPpGVeSH4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MmdMPyeqldX2ph1LrWJQceJbPI3jDhH9tsm/RqP+SQXRYEzHwJo6a63KUphg2pvv7
	 8AqWLa7PKbXdv8CAiJRmO7IkTuknZOnGQcMm6LmOE8TC2fE2ht5kGgwm/d+Wx1Bg4u
	 SF1A/3jOFOa7fH65V0Qb65jJ3/UELB3zzbZuVu1J3bKtvmIXFhdOxbiU5TjGQEQUOt
	 xEl/KQk5jPYevYf8kOw2s+1ktJFjFAm8TUe/lTtH/iKjdsDaAzLAuD3xMkMoGv1NFm
	 uDTcv4qTn9x6TN9aZhkPpZppZKNQpKT1F4o68hT5KWKk2rwDRO2Bo07o+HMArrvjC9
	 i5baZMYXDBgkA==
Date: Thu, 23 Jul 2026 13:53:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 0/8] crypto: qce - Fix crypto self-test failures
Message-ID: <20260723205342.GC110634@quark>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
 <20260723202704.GB110634@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723202704.GB110634@quark>

On Thu, Jul 23, 2026 at 01:27:04PM -0700, Eric Biggers wrote:
> On Fri, Jul 17, 2026 at 05:53:29PM +0200, Bartosz Golaszewski wrote:
> > This extends the initial submission from Kuldeep.
> > 
> > The QCE hardware crypto engine has several limitations that cause it to
> > produce incorrect results or stall on certain inputs. This series fixes
> > several bugs and adds workaround allowing the deiver to pass crypto
> > self-tests.
> > 
> > The failures addressed are:

I also noticed that qce_aead_done() compares MACs using memcmp() instead
of crypto_memneq().  That makes it vulnerable to timing side-channel
attacks (https://en.wikipedia.org/wiki/Timing_attack).

This is yet another thing that is inconsistent with claims that this
driver improves security.

Of course, the software implementation does not have this problem.

- Eric

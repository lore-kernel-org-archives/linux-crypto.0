Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF6D14A60F;
	Sun, 19 Apr 2026 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776612879; cv=none; b=ONlHipkiSERSpkuD5GOIkULOkL/CvbhLooHpiJ3h+xUtZ74V5Cvhl/s+2/wfzQdamkouv3C6DY2F665yfqgbsMxQo2xGhXGqBx93y4cbrEXQN88aqIjJfFd/Bi2FX2BLUIE6EKfziIWKWjPZsLkMIUHzfHRmYPgV/Ne1EuceFcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776612879; c=relaxed/simple;
	bh=H46xEImp2/v84M5n4lt1wVNxWaCced9vVT7gZZPrWtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muWsbgN7wr2IZ39B8RsUzm5u990HPc9e5iI98kS0D1ML7BGtVIhnB/kgM83N+g1LsWpc8kQjCzLP4Se9oGYSTfwKNHDVq/dvdeZi0g33CGz/uq1TjvkpNu9HAfpHKjzPQqiltzTPhzHG1d0k3wTyaRjQMmLGjszYOSoTeK0jNEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ce+yRL7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ce+yRL7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416D7C2BCAF;
	Sun, 19 Apr 2026 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776612879;
	bh=H46xEImp2/v84M5n4lt1wVNxWaCced9vVT7gZZPrWtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ce+yRL7+4d8WTyQfo3E73NQMAx1AL5s7RpefacGStpHgZQns5rfwSuCD7qJAOxTe4
	 wsD+BhhIhmVSDb2a2GSwLcPBU6PIXJKMsqqKSFrdMLef0hO0iGyywmbqdup7t6gxJQ
	 xhjp96aSKJUWtJMD8IGiN39PwWjZl7gv+Y7O5A8GNIRhprmz/hKmSY7PpCmKupCeqp
	 wMW6ekXdukex4hvNfo2mPh/Pewy1+gTGcRtnyNJDy+/Rr/2zi2Dm42yQx8d3bMO0nW
	 l+EyKXr6f3qjhyczRYhy3n6uJPNwo2mE6Iu8Jm2z0fHROn44n3HrXMhBkEZeMRQR3G
	 OUf0i4czA9Pew==
Date: Sun, 19 Apr 2026 05:34:38 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, NeilBrown <neil@brown.name>
Subject: Re: [PATCH v2 sched_ext/for-7.1-fixes] sched_ext: Mark
 scx_sched_hash insecure_elasticity
Message-ID: <aeT2Dgam3gVqKiVx@slm.duckdns.org>
References: <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
 <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
 <aeLV6aDhM0-S4oQ1@slm.duckdns.org>
 <aeLWH_HgSHF4buiJ@gondor.apana.org.au>
 <aeLgjAeJuidWNy3N@gondor.apana.org.au>
 <aeLhQRFPEY24ySIq@gondor.apana.org.au>
 <aeT11WIF6kzvifm7@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeT11WIF6kzvifm7@slm.duckdns.org>

Applying the rhashtable patch and sched_ext fix to sched_ext/for-7.1-fixes.
Herbert, if this wasn't what you meant and want the rhashtable patch routed
differently, please let me know.

Thanks.

-- 
tejun

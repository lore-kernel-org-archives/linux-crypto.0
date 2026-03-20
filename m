Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8DC3E2766;
	Fri, 20 Mar 2026 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031161; cv=none; b=coOZDWCsbwrigO99KYhn2Fc4MkGFPzJ93lx6IJiHH+pLTZy4oZU7SSuoWAbGeXkAzN20oipvh+nxPKqoz0kCNd/SGOEwbtNuMfNWRgX/v0qtF7VeKhL9wMN3uHL7J3r5yPVimSG4Hg4d0dgjkl4ICTvSeYzkLrhkZAtEuTgeVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031161; c=relaxed/simple;
	bh=jlrQP6CtospijAjR1wos41IMDs4DAGnm2KjWl19/ukk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eu36voWUSaStUkUsfF4QH9CKyeZYNzzYnC8m668NjIJSi3CUuWCQX8m0qMkxkPGTBGljuFUqkCuO+6u9xyHJTCMC2JN+9XOmFBrHaT0BMjoi+tjB7Sw1R6+2pOVpHAnYYxNkzNzD5YGMR3DOPMQJg2u45o/Koowzy88Py0Tt/hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7m/Av3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7m/Av3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8CEC4AF65;
	Fri, 20 Mar 2026 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774031160;
	bh=jlrQP6CtospijAjR1wos41IMDs4DAGnm2KjWl19/ukk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c7m/Av3S1jBwh4aIpwIEm9YlGIP56CKhDCFlVKaRpszyu5bhjBVFk1nMZYJwhzJez
	 WYIoQT23O5DoFyFbY0THi/N9uUJoG3bs2m2Pw/jJDp4iH1FwGneZV9KKsrnJIasPAA
	 WYTJYbR/iiXAq/bDhKGeNjNg4l3ZFf3eHRU7pCk7Dmq2tcMJ4V3YBW1Ey+qmkdexAf
	 YojwZsvqmQ8jtZOmDZ4vBtUdHpmZjxdWnp375kNIbVjbEeBB/O6rrY8W32M0/keBxL
	 eCayRRMpxenf78oyEXEwT+HxMKDj+q7xHEiBXDbjBjpbMVrQhG92Q9tXyJKutnlMSc
	 YpylKX0mgne4g==
Date: Fri, 20 Mar 2026 11:26:00 -0700
From: Kees Cook <kees@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Maxime =?iso-8859-1?Q?M=E9r=E9?= <maxime.mere@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: stm32 - use list_first_entry_or_null to
 simplify cryp_find_dev
Message-ID: <202603201125.964AD89B@keescook>
References: <20260320084914.7180-3-thorsten.blum@linux.dev>
 <20260320084914.7180-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320084914.7180-4-thorsten.blum@linux.dev>

On Fri, Mar 20, 2026 at 09:49:14AM +0100, Thorsten Blum wrote:
> Use list_first_entry_or_null() to simplify stm32_cryp_find_dev() and
> remove the now-unused local variable 'struct stm32_cryp *tmp'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

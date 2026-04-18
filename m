Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5BD245019;
	Sat, 18 Apr 2026 00:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776473578; cv=none; b=XF0Cp/ZbpHcXFv7oVFPTRFZrmnmlBSRShqBK+PgRCYpAiAtjiVrPfWqFgmw46FBAgz8qhll8b0rJV/5UR0WubxEIB1Y0D6pRUOKhRo3H/Lcile4NP7qeP8Fbmc0UcpCxwVBkSdBMYZsFWDZN7lYlL9qh63kf4xv334reym1ShcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776473578; c=relaxed/simple;
	bh=wEZGzTvzDuzWiupPNTggOh/AkQ7MfNyD+rjGVUi+30w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t79+YQ2cEgwaZhQDFTX97Z2IkS5biG9QgwhA9oNvYSq6kuz5rN91p5pjQt4HKZ5KVR8i8uJThv/uaRmRdRm+VZRLPwISJzZD9KO+HDnzNxw4T1JCJhUjPh2/sJKEaA5ktR76JA7cpFHj51EEPyqqxHKCFIG24WTVG2QdftHoIOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSWr7XQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSWr7XQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5298FC19425;
	Sat, 18 Apr 2026 00:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776473578;
	bh=wEZGzTvzDuzWiupPNTggOh/AkQ7MfNyD+rjGVUi+30w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QSWr7XQ1Pki5oAnawEIqLQhHgGhSY5H6mbNPQInj67bQGeY2Sln4wXeYom2LhBmDf
	 Cp1Xdchg+OLFqH+ehIS8IWjWHPMbSuzpfBvUCUc/8Wv4tK1yQMw3nNG0k36qAk23k2
	 62nN4VTkZYoJZfVvVkE0aOUp1Zlv46iCJsM+XBCojGQh+lXMueqYm6R3895uvCTyZE
	 4hkWY1TpQuzSDJ9t3sXJmOKOGO+dImdz1yGY8WEl7ijaSyaBilQPosV0kUTP/bBN4a
	 /416AeWK56rQgPESfgE/MjDlKSWmQYYl+HGCtWK54NA63uBU9wJhSWyHG6pdxJLvvj
	 h5x4k2gD7rcsQ==
Date: Fri, 17 Apr 2026 14:52:57 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeLV6aDhM0-S4oQ1@slm.duckdns.org>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
 <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
 <aeLT8eB_xfzLxqbI@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeLT8eB_xfzLxqbI@gondor.apana.org.au>

Hello,

On Sat, Apr 18, 2026 at 08:44:33AM +0800, Herbert Xu wrote:
> On Fri, Apr 17, 2026 at 06:25:22AM -1000, Tejun Heo wrote:
> >
> > That'd be great but looking at the commit, I'm not sure it reliably avoids
> > allocation in the synchronous path.
> 
> If insecure_elasticity is set it should skip the slow path
> altogether and just do the insertion unconditionally.  So
> there will be no kmallocs at all.

I see. Thanks, that should work. How should we go about reverting the
removal?

Thanks.

-- 
tejun

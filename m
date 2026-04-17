Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042562253EB;
	Fri, 17 Apr 2026 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776443124; cv=none; b=taepZbrpTUep9Q7f2cU1sVHCtoou03FcYaCoRyRSwGH5kQbsBP5fcsqfZeI375AfY+xXcZ6/Cu/TXRhiP6iyT+JeP2dgmqrba6df8m7wEZDJdEZzH1Eb6nruPM8djr1tJZzkz77cc/IdTf5C8K7luCTajsG/BeRJOAFftuPsYp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776443124; c=relaxed/simple;
	bh=E2r7+QJxXsHvtNOiZs+GhSrcgo3S7clUPj5gQzOlWEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=moL+hqzAuEcZsMK+ls+PIT9i8owViF/nJPVXj38bW+An/TEFyOgg7Pj4m51uYIS2Ch0bfAXH78uOI2Ch0fvce0XUf6vSo3nl1pk66E3RC6pPYJSYsqiEMvaJ2H/UkRXc8tvFxLKXAg/drGQmot4vmptyGL8oU/ajsxrhHtrSVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMHlKXNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMHlKXNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85641C19425;
	Fri, 17 Apr 2026 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776443123;
	bh=E2r7+QJxXsHvtNOiZs+GhSrcgo3S7clUPj5gQzOlWEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fMHlKXNuFWPuhqiqKWS2hY7vvt8mXLyRY+li/CuVElazlwL/JELRdgWT0oc0sYvZ+
	 bNzS93W2ATr66NQTZniFfPfoejF8h3tR9QcqNLnf7o7Df38suxPEbtCMTrIM4uwHnh
	 HbakjFGBt4KQhbaFOs/FaZrKcWAKrt0ISD3bDlgoMkfIzmYt3uN9SabXo9M9Tkirdy
	 qrbnuSG/IOptOGCaYOGQzfxfgQTgIwPW6da5rsIFmX+3y0+oTsXBcTPeFAif3oENEB
	 tQh9V65SLnQPxr5ulfeGBEN6H71vlPz7rjhFYB1nzQbIXgwpE+RTpI2wfR8VGEZDNz
	 /xEdcyAcyOOqw==
Date: Fri, 17 Apr 2026 06:25:22 -1000
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
Message-ID: <aeJe8oIyYUi-NtCQ@slm.duckdns.org>
References: <20260417002449.2290577-1-tj@kernel.org>
 <aeGCMkdg5Fgv8UMS@gondor.apana.org.au>
 <aeGElQ-TcCclEHwo@slm.duckdns.org>
 <aeGIsGi9fBqu9EZT@gondor.apana.org.au>
 <aeHjjGEhlikSsxCX@slm.duckdns.org>
 <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHmeAz-Z-Rx2MqX@gondor.apana.org.au>

Hello,

On Fri, Apr 17, 2026 at 03:51:20PM +0800, Herbert Xu wrote:
> rhashtable originated in networking where it tries very hard to
> stop the hash table from ever degenerating into a linked list.

I see.

> If your use-case is not as adversarial as that, and you're happy
> for the hash table to degenerate into a linked-list in the worst
> case, then yes it's aboslutely fine to not grow the table (or
> try to grow it and fail with kmalloc_nolock).

My use case is a bit different. I want a resizable hashtable which can be
used under raw spinlock and doesn't fail unnecessarily. My only adversary is
memory pressure and operation failures can be harmful. ie. If the system is
under severe memory pressure, hashtable becoming temporarily slower is not a
big problem as long as it restores reasonable operation once the system
recovers. However, if the insertion operation fails under e.g. sudden
network rx burst that drains atomic reserve, that can lead to fatal failure
- e.g. forks failing out of blue on a busy but mostly okay system. I think
this pretty much requires all hashtable growths to be asynchronous.

> It's just that we haven't had any users like this until now and
> the feature that you want got removed because of that.
> 
> I'm more than happy to bring it back (commit 5f8ddeab10ce).

That'd be great but looking at the commit, I'm not sure it reliably avoids
allocation in the synchronous path.

Thanks.

-- 
tejun

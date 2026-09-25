Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CFA479872;
	Fri, 25 Sep 2026 09:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790327452; cv=none; b=f56w2n4WMySNUu1bS6i9DRYIlrkOcv6ID7EqtcfpLX+MTm+qiEP1ptcfV50lRPJxpbK1G2NIdMgEzByULURJeBIJsFcDGdpdB6oRfJr4VIBNMFlgrfPK1gexj+SgtU1LGdw1zu7MH+vWZA3iHtiaywwkqUFPA/cNwxhKS0dS/AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790327452; c=relaxed/simple;
	bh=ig5R/VvsS+9uNk4dBeTzMAiX1G+zzlE1Aub1dMxONKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiH6rgkdQRBlHDJ+Nu9Gt019JkLN4M3kqEzDYZ6hHtt+IiqC5IrILqnMA19nv8pkjYGRBkGVxGM+f1rwHQM44w8UX/eNZIX6Ulj9pUtvacrzygOwcepglX4bojOveRdGYRRAbgkpMGHbb2EIZwph+mTiM5x0OXOA2HuISqf0Eq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EE6flcc4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EE6flcc4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k3Xm1TdRHFUCZcaelTuIJRJooadtI6KrhUHTrvHal0M=; b=EE6flcc4ugeS+GxWJ6hOTp2M2F
	L4r0KqMGNNIrnJsTkWPB0TtOoBBJqhOBSXbwUmNoE1if8dysCzjkmZgRf45ZBDZk9i4mmmnqeDAmd
	xEawveXvAlpSyLW+MqvbOaVHcdDIYVClx4Lgt6KvYLQGEyqLNSypaBpr8PZK7jXmb+iJsrOiOwcQw
	D/zbnBao+gK9W2xKgE7MgXpCUG67TRRB05s0asT9b6486VISPDuKNDnvpb/e45Xv8nDAX694uK+XJ
	ziNgW6p51tsksaxVrdXzcLiWa3PvumpVn959yQYRE5ceqsCSNdDUpBwQluv/C7wb81f1G1ilGZOLJ
	uTMIPZXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA1x9-0000000Cyom-3fan;
	Fri, 25 Sep 2026 09:10:47 +0000
Date: Fri, 25 Sep 2026 02:10:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leonid Ravich <lravich@amazon.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	ebiggers@kernel.org, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request
 splitting
Message-ID: <arY6lzQtvVzUGngU@infradead.org>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 24, 2026 at 07:58:40AM +0000, Leonid Ravich wrote:
> * No throughput *win* is claimed for software AES.  The win is for
>   accelerators that amortise setup across units; the software split
>   exists so the interface works on every existing skcipher today and
>   goes quiet as algorithms gain CRYPTO_ALG_REQ_SEG.

So what is the use case?  So far all crypto driver we've seen have
shown to be slower than cpu.  Which one are you using that isn't?
And if you have a genuinely useful one, should we have a proper
interface to it that doesn't pay the scatterlist overhead to start
with?


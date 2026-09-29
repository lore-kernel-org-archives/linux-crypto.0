Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77794FD7B2;
	Tue, 29 Sep 2026 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686663; cv=none; b=S2ByqfmBnkFntpny+H4yT8c888ABPa5aVZBjVWlTKCmEjlm+zDubM+yfbgFUk5/+0KfMn1LVlJnoZyPURnJnLKPrjwiwPzWoVE+FgXVbKVGH8b2/NKwzeSmVeedFR65PbDGqxV9VcqKme5yCeBmmXQWEHsWOjIiUAAKu3h4YhpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686663; c=relaxed/simple;
	bh=DdUk/mKEhR4P/9zF0l2ao29YdFResSCaQJr3CssYO8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGRwRcAq9/s2NeVNsuYl/oxCC89eJmsluz/ilBTQBqtTsar+zUdWvvvqlpOjiTOyXzP2Y0nFowD6US3UN6l3+J54wrH47QOt9LszQALaF6FQFFy9815JQM441NjbhJl+Fia/MF2vosQ4l3WevWljAsU5/h0T1PzBiEIDId9UHjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b=dmCWwUeq; arc=none smtp.client-ip=212.27.42.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=free.fr header.i=@free.fr header.b="dmCWwUeq"
Received: from L15923.iliad.fr (unknown [213.36.7.12])
	(Authenticated sender: vjardin@free.fr)
	by smtp6-g21.free.fr (Postfix) with ESMTPSA id DB0907803A2;
	Tue, 29 Sep 2026 14:57:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
	s=smtp-20201208; t=1790686651;
	bh=DdUk/mKEhR4P/9zF0l2ao29YdFResSCaQJr3CssYO8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dmCWwUequnNJgkM2nMUiHXC4CpHw+o18PICKCKrdTd0adHtavOs/nRvnqd5ui4+aC
	 tQdtGZGHlrVhUUZrBanO+NiGjRnApNPWYFKiTliUpm4wxQ7CQHK0dXt56J21YIUk0a
	 xqMjdw5spF4VrSxYbQBYaA4rQ39r2tLNwq5OT265JavglHg0oJVetUIf/TmfagyUfc
	 NPiQp4p4lGe0Kakv+1/Z+2++j2zEtfDao57sRLCwnNlthFM8C193FAD3Qgb47AtgVS
	 +a3ri480YObFoA2nG+dzzjGXUw0G0QKPPWByNA4Ucram9KktUg674qZet0BgrDiEx7
	 3QYmnXz6g529g==
Date: Tue, 29 Sep 2026 14:57:16 +0200
From: Vincent Jardin <vjardin@free.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia =?iso-8859-1?Q?Geanta?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: caam/qi2 - algorithm priority be a parameter
Message-ID: <aru1rDmeHJfgsyHk@L15923.iliad.fr>
References: <20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr>
 <20260928-for-upstream-caam-qi2-priority-v1-1-e4a8e5f01dbc@free.fr>
 <aruvJECCDNdguMdw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aruvJECCDNdguMdw@gondor.apana.org.au>

Hi,

> You can easily change the priority from user-space through the
> crypto_user interface.

Yes, that's definitively the way to go. I'll move toward this
option.

> 
> So why not lower the default priority and let the user adjust
> it if necessary?

agree, users should drive it, it'll be more flexible.

Thanks,
  Vincent

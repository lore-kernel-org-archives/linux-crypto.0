Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793394129;
	b=XKjRKxPi/E1BfzDvNOXLMrJjtQivvwA7jkOZE5p9Eo+FGxcQ29dZbul+YQNongwHkU9n
	 BYZZ4XyRvnawnbiOT7ekZJXA0sNFjWPVjwdph5sdeK0K04YkudkZpUeUf4Bz6oatM1WLz
	 HV6ZPtISAUJh0gmw7s43JmnKXtF5R+I7tk/yR67gkhTH2dcQNbAXcHamZ0R8Uq1XmD8ZG
	 bMIbrFgUuLL/VkbBcJTFVpIB8QNKCiANQTQcYsaYzsWilFNi0+uXPlGj2zA29EaWSi5vn
	 307+8ic2kIMpje8ZnODAGk75V5lOqV1ZyKVsc32kQ/UWzmW6re5SioW4BughY1nTRkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394129;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jJ9xWy1qumc499gtGlq2DdLr+ntxF89oEkYQOmg/9m0=;
	b=qZefbNe2TcX23WXoHNwYGiBrMBnb/rPl9Rn91E1pYow3maNcjS5FuyjZZffKQixkiHKQ
	 8tUsZIgqxNtO4yJSGYhUfY0r9om3nQY2ETEN4/AIexvAv3C1NjcZcyPkTHzSKHcSycGbt
	 +HQM/E4o68cwLPw71zVnBHuejEvGJNFUVeLRzshjHwJRvXXOF6tAq7Xkz7JzlkxrULFjL
	 sUh0fCq8pTR5kW4xd942CFSgr2j/564muQTHrrz55btzyki+K3WpWxSlxkj+/l3KlAb8H
	 aGEjErGEmvCfqUSD81788SQUXKpEspn4f6R70Xvp4oioB2ypLUFoubqAitS1BfM3v5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTOP7pIa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADEF606B6EA;
	Fri, 30 Oct 2026 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTOP7pIa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F351F00A17;
	Fri, 30 Oct 2026 21:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793394129;
	bh=jJ9xWy1qumc499gtGlq2DdLr+ntxF89oEkYQOmg/9m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fTOP7pIaASAPFaQF5RcHw5JyS/ppW4VUjc0GO9IHwf4/AUkt2XytG2lXQuyi/Eo3K
	 d2dhFa0jMleUxiLpY/z+sQJO+s6FKpy+/pa/XAYcB25RgA1R/7FlJP0nAdLNNKaKWX
	 NK0WmbQ9pRhiTag78tZRBzBJe4xhyKzos9+ZQ79ZW8aMGa4KGZnbpjAFxigoqFKDs1
	 Vgq67BxqTRfub+jArdjBvNsROqvpaF6Or3KqClmO11pRiwz2sJoQU/9KqV6NH9I0DH
	 KiPqxqfp9SAp8eIqgOLEj2MU4Ti/x3I15GLH3wR8qhzsQKeHG+uwv+raiv3OJLCC3g
	 iXIJMJL9w1nTw==
Date: Fri, 30 Oct 2026 14:02:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.1 1069/1887] crypto: jitter - replace LFSR with SHA3-256
Message-ID: <20261030210207.GA1877@quark>
References: <20261029210038.GB49373@quark>
 <2026-10-30-1-daily-reply-0001-jitter-sha3-6-1@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-30-1-daily-reply-0001-jitter-sha3-6-1@kernel.org>

On Fri, Oct 30, 2026 at 04:54:04PM -0400, Sasha Levin wrote:
> > But also this commit had known bugs that were fixed in follow-up commits
> > such as 735b72568c73, 908dffaf88a2, 9aa7e045f4af7, maybe others.
> 
> Queued the first one for 6.1. 908dffaf88a2 ("crypto: jitter - add oversampling
> of noise source") is already in 6.1. 9aa7e045f4af ("crypto: jitter - Mark
> intermediary memory as clean") only adds a KMSAN annotation and is not in 6.12
> or 6.6 either, so I left it out.

Okay, there are more too and this should just be reverted, but whatever.
It's clear stable is just doing its own thing here for some reason.

- Eric

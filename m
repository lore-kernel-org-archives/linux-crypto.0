Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ADD291C10;
	Wed, 18 Mar 2026 19:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773863846; cv=none; b=lLf5b1ekFHBdme5lrudxlmXZGI1joPPy+BVdsi1m6mpG57cnP+xSkbbK8zg8omZKPf263qYMTNnBpvyxL9vHVDSO6MJZU3ozgnHEJ2vW8ZNZl43UBgUg1zk19JCXtKC3XR45m2GuqPn1JoMQi+5ANPC1t3EazhlONnW4oo4cLfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773863846; c=relaxed/simple;
	bh=LidL4J9zLPkbYvfBgGkS/sMRcTCfLgpiUPfrnQgIiu8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JwfS5kv0YUqGe+0/TPC6q06VvEyuvC4mpRBAH8VtQopPl5zddPQUjbB5AWoMiAFeHGIwPHhUBjqZgwZIDlliCL0uVw/CH2hD8LU1kuq1LcqI6NT8giL+nW7AT5QKuCcaiE7BoOMkAz3Jv3EIB7K96qEIAwecgTHeQfZw4WIV4Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=qdue4iyL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=3GxasUMD; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="qdue4iyL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="3GxasUMD"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 3E72B1D0012B;
	Wed, 18 Mar 2026 15:57:23 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Wed, 18 Mar 2026 15:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773863843;
	 x=1773950243; bh=Hv2JDo/h3dfYJP5SOe3RfmBdCEK5P70Y0N/U3cfXu7c=; b=
	qdue4iyLJH2itNTeoiC6rvqyp+8/f2K2h2OJdsjfCJn3RY2fMbJWXtctt3p48VfQ
	tROnvLx4ymcHxRDwRF1bb7Sm20SdW3YeYJqJyOym92kmEInghmodAXkM/jye3Fu4
	p6x/UOJ35i2G8mW0FLNK2UR8BBLBJcANSCFBTDnm89kNV/TqxWbCAU4rFuxTSH99
	jjb9SDGHNDtTXqjZNNh7yGQnzlzu2ZlZ1ezZ50nXXLnfhsWXJx+PyuFHty1NP927
	2ZASb9OCeUaATVtOArrDM/ZHwwhprAp6HrNWyqBKGc/AN6+lFZUvZJ0GeImvpLuE
	Af6IDX1jHD33HtjtwvqafA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773863843; x=
	1773950243; bh=Hv2JDo/h3dfYJP5SOe3RfmBdCEK5P70Y0N/U3cfXu7c=; b=3
	GxasUMD3Qu1Cm48Y3fXL6bV47hKG5DAifxsAbyrtr8bASFRhrfD57sXwp9TocQYU
	KiA4oE8brWQhXqbIpyVLeLJXdbkD+7Fji66y/WcAXBI0o6jJAGXxWavvTWXdttSC
	2umfu8K2kZgDAjpnimUrEbA7OEr+AUB4bIP0Atdvnt9A49RG1/cgBdUBDAoSSd/D
	UVzq+dYBvqaP5hc5TG9XwG9n30UlDvUEEkUYja3MsqwSDJ288h+TCDWwxXMZMvD2
	m7N6kiMJJejburQdLomcnRf3e34Gmpt81g17HM/XFfSDxkZDZUYNiZH6GJ8DkJSU
	wlN8NZqf9JQR5YvaUO9wg==
X-ME-Sender: <xms:ogO7abov_C-TYtcFn5jsq57w-jRBTB0Wh0xPYwGkG1Y1qMF6-I8NNA>
    <xme:ogO7aQdCSCiS24vPYS9DhLNz0hbmcoaA8j3gPIebvOhJXCEJWNdnqRUFnc-fJAQ3_
    hYxuVR5qkUCfK8WLKebzsiCQtwy64x-0i5K5EtBuGzcAogn5Hot-Ro>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdehtdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudehpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegtohhlihhnrdhirdhkihhnghesghhmrghilhdrtghomhdprhgtph
    htthhopeguihhonhhnrghglhgriigvsehgohhoghhlvgdrtghomhdprhgtphhtthhopegt
    vggurhhitgdrgihinhhgsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrnhdrjhdrfi
    hilhhlihgrmhhssehinhhtvghlrdgtohhmpdhrtghpthhtoheprghruggssehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmhhhirhgrmhgr
    theskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepiihhohhuhihuhhgrnhhgsehkhihlih
    hnohhsrdgtnh
X-ME-Proxy: <xmx:ogO7aevMUU2i_g-gDC57m0pzheDluLCZgW6j-dECYEoaBK-_n-taGw>
    <xmx:ogO7aT7VPVBOivpokpAPz5D1SBE0kYY7qYlbnF4jzGzlJws7V055Rw>
    <xmx:ogO7aZjv9HFUWqnFGEW9huNyxXbzYbuneZK48kXEc9Kym_LjE6dJTA>
    <xmx:ogO7aVljPpv9GxIMBC_YYAvVy5IOC8L553sajU3o4pq4tHJj3NFNjg>
    <xmx:owO7aYBIsb0Kp6qpNAfdL0mMWW0qBlhJJ0K8LLd8myWY3j9Vj9T77TqW>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3D6C4700065; Wed, 18 Mar 2026 15:57:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ArlFyPd34Br3
Date: Wed, 18 Mar 2026 20:57:01 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: "Arnd Bergmann" <arnd@kernel.org>,
 "Dan Williams" <dan.j.williams@intel.com>,
 "Dionna Amalie Glaze" <dionnaglaze@google.com>,
 "Cedric Xing" <cedric.xing@intel.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Zi Li" <zi.li@linux.dev>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Lance Yang" <lance.yang@linux.dev>, "Zhou Yuhang" <zhouyuhang@kylinos.cn>,
 "Colin Ian King" <colin.i.king@gmail.com>,
 "Ard Biesheuvel" <ardb@kernel.org>, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org
Message-Id: <dc124ea8-05b8-42d2-93ad-d265e0ecf585@app.fastmail.com>
In-Reply-To: <20260318164233.19800-1-ebiggers@kernel.org>
References: <20260318164233.19800-1-ebiggers@kernel.org>
Subject: Re: [PATCH] sample/tsm-mr: Use SHA-2 library APIs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Mar 18, 2026, at 17:42, Eric Biggers wrote:
> Given that tsm_mr_sample has a particular set of algorithms that it
> wants, just use the library APIs for those algorithms rather than
> crypto_shash.  This is more straightforward and a bit more efficient.
>
> This fixes an issue where this module failed to build due to the kconfig
> options CRYPTO and CRYPTO_HASH not being selected.  Also, even if it
> built, crypto_alloc_shash() could fail at runtime due to the needed
> algorithms not being available.
>
> The library functions simply use direct linking.  So if it builds, which
> it will due to the kconfig options being enabled, they are available.
>
> Fixes: f6953f1f9ec4 ("tsm-mr: Add tsm-mr sample code")
> Fixes: 44a3873df811 ("coco/guest: Remove unneeded selection of CRYPTO")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> I'd like to take this via libcrypto-next, as that is where
> "coco/guest: Remove unneeded selection of CRYPTO" is.

Thanks for fixing this! It is indeed nicer than the fix
I sent earlier today.

Acked-by: Arnd Bergmann <arnd@arndb.de>

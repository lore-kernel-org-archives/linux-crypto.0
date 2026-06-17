Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56BD4968EF
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781710617; cv=none; b=i7WFvXlStaet9GpNpqpziHrU3NckcuY5pOUn0tW4ZK/o7h+vnQM7X/FmzpWRlROXgbfNo2+SIAUeeb66E81Bp0/C1cp1zHSyPoOFEuE0LgDKZYnG3XHDXPAKPZ8BycdfY9MOn2IWwy5RJCbhBWk6eoZxxoqgnu3r2rmWRyjVFPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781710617; c=relaxed/simple;
	bh=b5LWD5QfXea/9hfcz6gkmZKMaic4IoHwihcD6wMuhlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVpBZ3N9Pz1/MXE2nAJaNFhuoIGoj1AcmTECXdr7tmPmxd4bD/xLDTo/CoWj7LzyJXKvx1GungdQRQEDSy3KJtSmpfRD/ofhhk1CNSQJGjNUzYAmJHmkB25o2LkMZg7bYzryIpSpLSgxbhZd0/EfwG7iZc74PlE4pvXWZr4Zr0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C3HW69YQ; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C3HW69YQ"
Date: Wed, 17 Jun 2026 17:36:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781710593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ukG8Obl+dv0tRFim3AGkcZvu1/Geyk29Tlk/Y83JGNM=;
	b=C3HW69YQrzlhHC497L18r4iKPYaqCWl8ly/F7jdHs6xlL/nN9KZGGuE2O5zXdjlE/N3clc
	ZYKbepLLI3eoQSCARb/OTmGoRzMa9YigmkBRRRUPmTGiOhNdUW9s6UDd2l8G7aIqavVEKx
	w9xv2ZlMCVwcCYi7vwsVCPBt6x3b++8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND 1/6] sock: add sock_kzalloc helper
Message-ID: <ajK-_byCXAGGMGdO@linux.dev>
References: <20260527082509.1133816-8-thorsten.blum@linux.dev>
 <ai7JfHTFgFt6YN_K@linux.dev>
 <20260615091555.4af017aa@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615091555.4af017aa@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 15, 2026 at 09:15:55AM -0700, Jakub Kicinski wrote:
> On Sun, 14 Jun 2026 17:32:12 +0200 Thorsten Blum wrote:
> > Gentle ping? Patch 1/6 still needs an ack from netdev maintainers.
> 
> Perhaps other maintainers shared my feeling that this is a waste of
> time.

Could you elaborate on why sock_kzfree_s() is okay, but sock_kzalloc()
is not? Both are small, socket-specific zeroing helpers.

sock_kzalloc() has the same number of call sites as sock_kzfree_s(), and
it could also be used in net/ipv6/exthdrs.c in ipv6_renew_options().

Thanks,
Thorsten

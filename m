Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4880E1A2398;
	Tue, 10 Dec 2024 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733832413; cv=none; b=b3j3OXBZTnTtQBfK6gY5Y6cfFGz+qjRBjw5XO73qR6Zq5RRbaL/E0CaX+6nuy1fnQtJG9lNjnfaic0Pmr9Cee/zLskO0PjJBMX5QyJEaFle/8tivNwelHUY/aqqPQPrxzToD+tkVIbUTBLjGsHWdFGcnQwh/EUMq7LuoX1cusAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733832413; c=relaxed/simple;
	bh=ild0bFZNR6bQk2pXxpDn2lqlMl1RKFsLC+TVBoQgfgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7TzA1ElVbx+cegqU4voylCoTt13WezRDQ3D+as+WBddqhfC1ilDswMbreLEqm1BwEpG3m+0coMHUokdIp8EOqyeJZS3lCXogZw1zTVu1lrokGef7PsBVk2YkuU4CJgjNCZmN4ghxJf5VJeATW3qjatT9bSNg3sAJXXA50QGoHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BTJl6VGr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BTJl6VGr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=w3MisstJK8dyOq6lFAVcaeAn47QK03qMK9BpK32cW6o=; b=BTJl6VGrBZ5FH4AkBifV+eY4L4
	PhTq1aEhRchWot1oHwSW8R6ZKNYh56Ke8eWzbl57BrPlGAM/ZRI+lxGT/Ccw4LqU5Pu72RRw2WIVX
	D2eDjUwmpl4UJ0rDABK5ZANVOdrIZngLGAtMsQvP77klMdhVw88CN8p97JHa+/4W6s3b/QiZdJynE
	bp44UqWOzZ6boVFcIoOf6XfzoNzN7qaPMyM3SOMikvvZ46gf3h0hxJAu1WkR+zrOMF7uu9NTpdpU/
	mW8HaxXactXXONKhBP2mGsA58RGqZWYgKMJbz2dw9OomLphlX1IcGmtfYbH3CruaWRUxb9CdPsMEF
	cRUhyo3Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKynf-000T9J-2U;
	Tue, 10 Dec 2024 20:06:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 20:06:32 +0800
Date: Tue, 10 Dec 2024 20:06:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z1guyCJy-Cpo7U11@gondor.apana.org.au>
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
 <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
 <67582c1b.050a0220.83ef5.c8df@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67582c1b.050a0220.83ef5.c8df@mx.google.com>

On Tue, Dec 10, 2024 at 12:55:02PM +0100, Christian Marangi wrote:
>
> The main problem here is that .update only enqueue packet to be
> processed and we don't wait for it to finish as that would result in
> really bad performance.

You can return from update prior to finishing the hash.  However,
you must return -EINPROGRESS in that case.

Once the hash has completed then you must export the hash state
from the hardware into the request object, and then invoke the
callback to inform the user that the update has finished.

At that point, the user may call export.

The user cannot call export prior to the update completing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

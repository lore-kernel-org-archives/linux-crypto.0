Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936FA19BA6;
	Mon, 23 Dec 2024 02:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734922436; cv=none; b=DbMaCqyiAIo/GcswPkuenlRlmPW0C8wBmYZpdhB5gbO9gm0cZX3mcwRJgJFif9z3POSnvdmHV1S39UjrwfjtNXAVALg7OSRyfE+VPzW5K217CsPFw2l/bmHsd7Jo82Ss0UVoU5v3Qs2M/DjBrb9Y8p1vpQmW8m5iIgdK2pEPSpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734922436; c=relaxed/simple;
	bh=kUUBGikdtXr9koloWcESuZHNZ+tKO485yigGPSw//PQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIaeMFgHhm0Zm9qOrLT69XfMIyZMoMEP9FC6WKu9r+TotRxZEoUVr9RPTzd45KzYj4I3rjH546llAX6s96Nz3lR/sxtLv3IBixU5VWxNGgHBHovBbVCoE+se3w9Vgfmzg2ptF9spAktIR4uO3SHaCTfmVnqXqmBcY2AXBDSWeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HhQpa9nv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HhQpa9nv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k1RVVPOPWnrP3P+6X0EVuLTSytw/SUUS/gMS9H6c53g=; b=HhQpa9nvzBxLkNxfTJWJWiew5C
	S3e5TQyChzFYZTkYS9lfmBgjHX5aqVLklF4I+d43FB0HHw3TOFRS4LYQGtwNdrV8xFNPYoOiQi3im
	X10kg7bS1n57yvEiGjkJ5/ouYwL76RXBdlUlxM7Gx/6V9meCAqm1BkNm1ZFQ2+cRbd9NEbYcPvVOP
	DCgj49YKxvkfu3PqRMs6AIuXiMv1M+BDrPfNyKUMSv0u9OSHL6UejGiEz9wntq8fSF5OIfl1wqhec
	mbX2yIfPsP4htpTVWN4IM9l2DqV8PtfZKB4i/m85OJ0BZbnEueQNs38by9XNo+CqxK3wE8JgBktrk
	z5Hvw9RQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tPYMi-002a3e-1r;
	Mon, 23 Dec 2024 10:53:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Dec 2024 10:53:37 +0800
Date: Mon, 23 Dec 2024 10:53:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] crypto: lib/gf128mul - Remove some bbe deadcode
Message-ID: <Z2jQsb6d2PCKyRZ1@gondor.apana.org.au>
References: <20241211220218.129099-1-linux@treblig.org>
 <Z2eTGr3l-Zu_Tgi3@gondor.apana.org.au>
 <Z2f-CXgNGkstB4ds@gallifrey>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z2f-CXgNGkstB4ds@gallifrey>

On Sun, Dec 22, 2024 at 11:54:49AM +0000, Dr. David Alan Gilbert wrote:
>
> Thanks!  I'd appreciate if you could also look back at one
> from September:
>   async_xor: Remove unused 'async_xor_val'
>   Message ID: 20240929132148.44792-1-linux@treblig.org

The MAINTAINERS entry for that file is:

ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
R:      Dan Williams <dan.j.williams@intel.com>
S:      Odd fixes
W:      http://sourceforge.net/projects/xscaleiop
F:      Documentation/crypto/async-tx-api.rst
F:      crypto/async_tx/
F:      include/linux/async_tx.h

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

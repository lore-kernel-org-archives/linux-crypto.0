Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2488632C;
	Mon,  3 Mar 2025 02:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740969360; cv=none; b=mHvgnRewxcuNqv3WHwQ0LxQXhx7D1K54MJjD8562nj5D76591xv6M2g6rmtKP7BCzIFIbZ8Bv7W7fB9c4GA5z9UQEzQYTPSb+Gs0/Wa1xxp+4IVdfdV5bZQ75IaSnvU9H6/N18s8sIxBLgCSawwSlUf9KBxEYAL+Fltx04CtbTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740969360; c=relaxed/simple;
	bh=IPC1arS/Xge42WT1G3n6F+Qd/Z8nXYfSMVkXHphRXYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7U0k34p0dWpVuaeWRo+0A++4IexIKOzm7wBZTnLGfkWTZs5fn2bh/sI8OUsYDGSpLcZpukwKl+UiSXk2hixkapSHVZKfzADHRTkKL0fThD72/+hXV0ZpWGV509dIUrFhjoMXHbVdBZaOgl7x/YhV1pI0z8AEIN9cbACm9aJR3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=RUJecLlC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="RUJecLlC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vq1wwetaUowMy1aDAep7qN9rrxxmtZ00oG+zzQtkiDs=; b=RUJecLlC+xkB9G6iwY6MXxmZmA
	UUgks8U7oB4LTqbG8dBKc44LnbZSE0yKCEtTIW8NETaob0mW0wBUFk3B6J9RBcFSQCvUmoKA2/fmQ
	GcddP3rS4nTHmD3qfZRS2KTAKjC8Nscfk22s5wQ8W61B3snoTmOpe6t9J1PQogO8cPemPOo8BM2Kr
	5kV8Mcqz9BGg3L8UT8all1SQrk1OzWEowYHur+vDSj1qQKPOaWZCVEHjxE7yVPx+dsaCAioL0qF/h
	WqGvuP+cotIOLxWf3s9Leoc2C2vsSEPKlbmfMmrvufSE9baynTureg5OYusPkdeoCqAcLtOQHu6z0
	3jsQr3Ow==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toveq-003AMN-27;
	Mon, 03 Mar 2025 10:35:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Mar 2025 10:35:52 +0800
Date: Mon, 3 Mar 2025 10:35:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 03/19] crypto: scatterwalk - add new functions for
 iterating through data
Message-ID: <Z8UViL6bHgnvAUlX@gondor.apana.org.au>
References: <20250219182341.43961-4-ebiggers@kernel.org>
 <Z8P6qOt4DQ3_FkMo@gondor.apana.org.au>
 <20250302202135.GA2079@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302202135.GA2079@quark.localdomain>

On Sun, Mar 02, 2025 at 12:21:35PM -0800, Eric Biggers wrote:
>
> Patch 19 of this series already did that.

Thanks.  I should've finished looking through the whole series
before sending that email.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

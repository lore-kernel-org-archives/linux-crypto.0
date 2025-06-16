Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD63242AB0;
	Mon, 16 Jun 2025 04:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750047493; cv=none; b=a6nrkq6YpMFASWOzKz1rEWow4KaXffBm6ttkUv1HSSkp49QrAS7y7H4H2LimtyOPEZRBXBrjyyAK4Yq2JffXPDidASGm91bCOJkQCfX82+0SjZUQEuQtDvtTNck+RGaqhRGtt8m3Akza1i/LiOSYL4OWQDdknbfJBqUlKB4AeNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750047493; c=relaxed/simple;
	bh=L8PHFjU2To72jL+gJgPH32JmV62Supo0DiBrKC0bw14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZIDaxi4CjyJUs1T7nwnW13yXXibI49fTqdd6ST35v9ADki3eooQDJne9EIt2vQd24Dm9p/urQ0VT0vz4zwSEfE99u8AQigHQ+0pTrCLqS05bg9fd87qPKWF/wrNcaPeIkipjzOqKPmo2KtPPyKl4xd4PVf2YWQC/ywiqmfcQsrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=H0DGMkSI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="H0DGMkSI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EaTQroFOfynVg7Ha2PjvslSMuN0yDCnIB2BzBUq863Q=; b=H0DGMkSIti9t77zAoM+KFxh5HB
	GYqZSTPFMo6bn0/x/ybm1A1UEqDJUxQWrPDcXO1bpoNAazgoOqZAIYW80U8NTDyAlrSMyrPO+5KbE
	J4PSqPh0U9GwxUWG1SJ8sq+GOtl3gSHD3/Q6vAhs4hvjgE6lyJVmp5HMrr9s1tR4ofC9WZCR10iYr
	uaDyjhBic5hNK/+P0dU4XCFMifFEG1EhJgEaQShVwDNlAGmIEeJ7lS8CmJbhsgVbLc+N513DzN50V
	5w1dxHn0va5m+13jPuqJdsgQGMUTO2gKKUO0gXUIAVv9KMEuJXXQaUw/0JlWzB7MRdYU5N0PHVyfP
	U65iOuWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uR138-000JHd-29;
	Mon, 16 Jun 2025 12:18:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 12:18:02 +0800
Date: Mon, 16 Jun 2025 12:18:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: ebiggers@kernel.org, linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613103309.22440-1-giovanni.cabiddu@intel.com>

On Fri, Jun 13, 2025 at 11:32:27AM +0100, Giovanni Cabiddu wrote:
> Most kernel applications utilizing the crypto API operate synchronously
> and on small buffer sizes, therefore do not benefit from QAT acceleration.

So what performance numbers should we be getting with QAT if the
buffer sizes were large enough?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

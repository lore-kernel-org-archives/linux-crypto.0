Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF9B170A37;
	Fri, 22 Nov 2024 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732261481; cv=none; b=jry/p5uhHNWKn33ql6uCTl/GaaiaiImsEKM8UmNGadC6L/nNLqQWb59d6nQx2i7jAW3z557MguuNY5r7vYhdu1txHK8Evb15nvdAzoX9zCSWAo9Gk5OHBLlyuUG1/yvLe2K703NT+rZh6T9JEj2zoh7nOt7gkaRfDd4pby6BZ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732261481; c=relaxed/simple;
	bh=bizZchoBVNlH4WG6wwctE/hTudXZ/DpCgsH5vJjZPEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/JFnbb2w+dN/Xyd1tqByoU6gBBuGYmYhfJnbzVal5L2X7LoapNf+iV2aF1unaoY7XhbsUBZFnF+Ura19hUs1Kaa89wtPe9IbB3SjnJslUqE1ONviCCYnV4NqeQQDA3BxT8vpG1cogyGVza4ABng8xRppcP80ojHBSG7m3fX1/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=k8ynNSmi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="k8ynNSmi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6cgypngBYJ1FG4I1IIZQyMyKuh429tzjhlzyyaG3A6g=; b=k8ynNSmiQczZIRNQMRXw6yvaiH
	dB3paNYPGnosEfJrtPuPOVia3UVIWbDXJ/RuCd3smILmi13bpPDG0CQIhd4P9hbH6sG1msZugbWi2
	zs7F7dAri2H6X4aufikbWsEtEg8zDqQqasvarZgQPfGHNfq1k13NaN+5drTiX7Qilgf6RKQNompj4
	RGhDCaev2BWbgeg0hLwo2bUsD1wXjFGReDE4Chl4PHcfXG5SIfBs2zqGjZaMqL6qDoMEuURD1Fhkc
	rxyj7TRXeyypGZ9W9Yj1hQ/OI4rpBEV9gP0oGxvtmW+7xs9v385oYdOa1jSHxqgCmAdSRU3beke2X
	wLoy8gjA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tEOL5-000udB-1b;
	Fri, 22 Nov 2024 15:44:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Nov 2024 15:44:27 +0800
Date: Fri, 22 Nov 2024 15:44:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>

On Fri, Nov 22, 2024 at 07:42:54AM +0100, Ard Biesheuvel wrote:
>
> Does this help?

This is a bug in the API/driver.  Users should not be expected to know
what kind of a virtual pointer is acceptable.

In this particular case, rsassa-pkcs1.c should be fixed to use the
crypto_akcipher_sync_encrypt interface.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

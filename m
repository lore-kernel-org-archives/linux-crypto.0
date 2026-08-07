Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A4737268C;
	Fri,  7 Aug 2026 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786107647; cv=none; b=Qcn7SRU8IzOxZtmz2CrXeMdLf1XWFisEi+5p5RdZhPSdADiZ8OSNiVkGTG5hu8R9TAQZpH8XzyjGsLxacSVZwjSE6ahiNpLArLsBdDVeVae6J26QsjwnckaI1DXY4EBtHQz1cq3ys2sNRejsg8Q08Yf9i6j7L+vUSZ6XJFZxcd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786107647; c=relaxed/simple;
	bh=g600cQqnGXX1oTHXPKKvU4bsoh24LhFpbFXPe+3q+bo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XDwMZ2sB3Aem4aZzzJhLzh/rCZdyjWHUxQdHmsLUdcVxQbu2rv5tCtamZNdQLcLAQ5DGdkhIvsLQybQXQu7BGeEYVinjZUHQWCQab/K7xGQfqjt7cu2HWVCg/N0xmbdlaBreYr0VGQSl86tcgaQx9QGiaKwMVCHQsKyH1evHypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=juz6ngmb; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="juz6ngmb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=g600cQqnGXX1oTHXPKKvU4bsoh24LhFpbFXPe+3q+bo=;
	t=1786107636; x=1787317236; b=juz6ngmbiXE8lSPa3mDNYX75dCLF71A/5+9PH+f3z5XGKCD
	Dg5A9GK4/oRt6yz+SE6H/DmGtfoKCOp+UcqAdCsH0hzdRxyeE0y1DCbROE1VI+aaBCBGPWeFSYVO2
	gl4fCmdoJSEI9dJVMU9dIuHRc4TzwAz/McjotN0VOxgzMwl3NZXzIkkLC9ujtcpjX0DR4ogWAa1mj
	3tQhLthsNqjyNd3rniYdi3mV6tCLF5ZqDjnT/jsq+Tf13KRseysm6xOBpeS5sOjwymwghNuvU/PCp
	pDqnpq9B5pqAYLLRVQJPm/OxIZb6K3xHP2ZrZJcza5FdZ++A7dEbenmFwLntqSIg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wsKBK-00000002p8G-3Pkp;
	Fri, 07 Aug 2026 15:00:15 +0200
Message-ID: <767b4dc3e5452e27e4d4ece63b84a88ecea3b88e.camel@sipsolutions.net>
Subject: Re: [PATCH v2 6/6] mac80211: fils_aead: Use __cleanup() for
 aes_cmac_key instead of memzero_explicit()
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huth <thuth@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"	
 <davem@davemloft.net>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>, Namjae
 Jeon	 <linkinjeon@kernel.org>, linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2026 15:00:13 +0200
In-Reply-To: <20260807125845.1477067-7-thuth@redhat.com>
References: <20260807125845.1477067-1-thuth@redhat.com>
	 <20260807125845.1477067-7-thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Fri, 2026-08-07 at 14:58 +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
>=20
> By using __cleanup(aes_cmac_zeroize_key) for clearing the key data,
> we can save one line of code here.

I'm assuming this won't be going via my tree, since it's part of a
bigger series.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E02D1E5B7E;
	Tue,  1 Apr 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507244; cv=none; b=p0JN192nWLA9lEYu+3oOvSOJdp+IssqNyrI3DRfHvWecjb4fjxwToMigtfy0C0cB2JlFSLP2v+gD/N0uWh2lX/9OC7P/T/a+i8H74/2WQBGsChWFi7MKBboP+fEpYjepsE47K26j4wgPYponb9QBA7YMOkGdywLMNMeNOHWc3ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507244; c=relaxed/simple;
	bh=Da1+bF/BSq4mWTcmY++wwkgUTq18EEuB4ADZWh3lFZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoaEXeBYWxBOx7+OSA5az84PU8WfW/KVCZDSG6JVbVCG+T1VFJInGsyQxxUUDzHZUvTI99EKEs1An76uSrEb0gUNt9Lu8PWmGIQAfqQVtNoZFt4zKKdpSr2muT0QibZRD2pE9OuqOhvZGofLEhS/bKHpZtj/7EZ7OW9CBgi/FRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=M/W7C9ys; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="M/W7C9ys"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RdxSA8as+JgtfsTvVEJNndvDyr/LwUMDt+9OFDkr84U=; b=M/W7C9ys/a5HAFMQ9DCsXXR2fO
	xSiApmaTnEilUbLLuEZRhFCmbiYS3RQrCBSlOl+ArCyMSr0OzGpBxhFPV/Wef326dG2bMsqJmuA8K
	gXtjReYpVYQPJJ4nWV/MNIGfWUqJiXHgxf9iz8cLPRfwH8C3knpzaMkJgckiEBJrbY2nkmKwhCdI5
	Sa315E4H5XgckYlbtK0XYFn4enWbmxel6Kmj1a/T/vmKfqyMEcwFLSW/oo71Q2RfSWyAt7Z5SqSs6
	k6qxKvSNCH9uzt0usjPLEwBHq1mKvNECUjYGOuUshZ0abAOR/cMyyPliF6ThJbZNejh0IqxXE/R5u
	jSLqtEUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzZsL-00Bonz-2h;
	Tue, 01 Apr 2025 19:33:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 19:33:49 +0800
Date: Tue, 1 Apr 2025 19:33:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
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
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z-vPHYjLd2BiOZDc@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
 <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-vFkUmd6vgciU6V@gondor.apana.org.au>
 <CA+_ehUy0qHfQseVv4D4BbZa+wHKTCvY9dVNfUtcDF3x7XHss0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+_ehUy0qHfQseVv4D4BbZa+wHKTCvY9dVNfUtcDF3x7XHss0Q@mail.gmail.com>

On Tue, Apr 01, 2025 at 01:13:21PM +0200, Christian Marangi (Ansuel) wrote:
>
> If you are ok I can send a patch to drop this (and maybe leave the
> comment just to document this strange finding)
> 
> What do you think?

Thanks for checking.  There is no need to send a patch for this
since I can just remove it when changing the export/import format.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

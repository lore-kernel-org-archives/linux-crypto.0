Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF42343C1;
	Tue, 14 Jan 2025 03:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736825819; cv=none; b=Vpw3CisF+3b86Jjy24yeTQ+rvi3fRoa4srLGL30xgCQnJhp/6KQGdSJxRCiaTL2Dhr/3VySUpvfHM+DFtxhIhxu+MflOcgcMayTPu905Lkxp+Z94UXjVY0HPnrafIOB6hyAaclp5aDVaCfRSChbmLDLiXwtPpCm+EXBM3qHDJVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736825819; c=relaxed/simple;
	bh=XI58++6TtQ82xswAkhpDySdUrIiXLyvDpIPHGUoYIpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXs7SCHUCw7U7la3KS269OJASXPVkNDTnPf4uW5yTJSDIucRKDnzXJWSdVrrFoTsX7N7mvCr/VP9XLhc09b9IcDgVyTvvmQyYIG/E6Z7k6mgE+nnNzUs6mP+MojzhF6euAqQctkt2uFthA00lJbf5l+vqSgHifcwBVFgp3VKzJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZKQDh28N; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZKQDh28N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=70J6vzkPIXlCxUfJYdiD36nXRWaj4H0pYUMl2HSnMo0=; b=ZKQDh28NdkjbA8YTvkbWfA/s2N
	YmuY1lg/8BNTOJementF8NzLJROljHdYN1ptGcFS/kMGXZ6AzIKEStAJ5SHwj0aYMxxHAMTUT1ZpH
	xMAQWyeUxOcEMCNqBSd2csFFphcan8r/Jgb7fVIe3RTe0/wQHymi8ZPxFHcrLXV3WG5xIRIXM4z6/
	Dgp9SriTVeS3oBJpWVSO9t23mvIhsDmUHf8me4sEk7fchVumSOGM57GOjwVs29udRJSMh64VrKUCq
	6elmx6/GGydXsolOto0DQEPpI7vU/z84gIn0JRwjE92mAn8+A/JAqamgXPFTEW1VyqgxAP+3YQQxg
	u37Mt5wQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tXXWN-008xTJ-0C;
	Tue, 14 Jan 2025 11:36:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Jan 2025 11:36:35 +0800
Date: Tue, 14 Jan 2025 11:36:35 +0800
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
Subject: Re: [PATCH v10 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z4XbwyrBXXcQvqiO@gondor.apana.org.au>
References: <20250105143106.20989-1-ansuelsmth@gmail.com>
 <20250105143106.20989-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250105143106.20989-4-ansuelsmth@gmail.com>

On Sun, Jan 05, 2025 at 03:30:48PM +0100, Christian Marangi wrote:
> Add support for the Inside Secure SafeXcel EIP-93 Crypto Engine used on
> Mediatek MT7621 SoC and new Airoha SoC.
> 
> EIP-93 IP supports AES/DES/3DES ciphers in ECB/CBC and CTR modes as well as
> authenc(HMAC(x), cipher(y)) using HMAC MD5, SHA1, SHA224 and SHA256.
> 
> EIP-93 provide regs to signal support for specific chipers and the
> driver dynamically register only the supported one by the chip.
> 
> Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

I get a compile-time warning with this patch (C=1 W=1):

  CHECK   ../drivers/crypto/inside-secure/eip93/eip93-common.c
  ../drivers/crypto/inside-secure/eip93/eip93-common.c:101:5: warning: context imbalance in 'eip93_put_descriptor' - wrong count at exit
  ../drivers/crypto/inside-secure/eip93/eip93-common.c:126:6: warning: context imbalance in 'eip93_get_descriptor' - wrong count at exit

Could you please take a look?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3AB679E5;
	Thu,  8 Feb 2024 04:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707367239; cv=none; b=sUVfrpg3TqzkR0YAgzhiE7/JEP9J91t9YPqbAG3m7+WotbsVDVigJ/dwj10lfoNITh9LYOfZI5UVYN+7Rm92xJmO7ozODsj/HXvTIGRuf6So0ynrnuRaYgIIzPc47mjcIJw38vqtxPZrog4TQAq1AKCQ5IOLQvvbUiqDup0A+6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707367239; c=relaxed/simple;
	bh=YMEls4pXTTT7G5AlTzGpypQOGkFyooymapPD7mkKRXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhvi8OxUi3Bz3vF8fOoFc9x6kXVP+OmbekeRv373PcFyGbXHTCdUFvn376PBrbLYJpF/kXd69RqRNAYb+xKhhGYOHnxwcFuHWviOYpc/StvGvGH+YMIHC+6Wuj5m9DZV4QCbm9HKeqsa2PV53ilDCC5bfut77aFHDgFLl/+LzDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rXwD3-00BHZi-QO; Thu, 08 Feb 2024 12:40:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Feb 2024 12:40:39 +0800
Date: Thu, 8 Feb 2024 12:40:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: A question about modifying the buffer under authenticated
 encryption
Message-ID: <ZcRbR+NaLLKsvscx@gondor.apana.org.au>
References: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>
 <20240207004723.GA35324@sol.localdomain>
 <1a4713fc-62c7-4a8f-e28a-14fc5d04977@redhat.com>
 <20240208043610.GB85799@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208043610.GB85799@sol.localdomain>

On Wed, Feb 07, 2024 at 08:36:10PM -0800, Eric Biggers wrote:
>
> The crypto_aead API allows the source and destination to overlap, yes.

I would prefer to call it in-place rather than overlapping, because
the following is certainly not supported:

	encrypt(src: A, dst: A + 16, len: 160)

Just in case someone gets any funny ideas about the API :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

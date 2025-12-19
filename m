Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D6D2ECD37;
	Fri, 19 Dec 2025 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127898; cv=none; b=LPqDOxjknPiv5AbMDq+Z7D03+Au1i/NU9yZBaXZHn/WEd6i73n/83Ps+T2wWn01qd1F8Vm9QHrq62KASgu+57aeJiZASj+BbBX8+9h0uSWuBecgltdLFcGTe9AqlNv1yl1xGhl8gI+BrZ/DRHExb9fjuWBj7mkbso2khwOLAydM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127898; c=relaxed/simple;
	bh=ZMkOuAKrIhsnui/sp/CCmN3fK9WyqBnD998X7scz7+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyos/dm1aKkCApg5Y1Oljm887c3rfRzhrGQevHfPB5eHZxm/ipkGecyOJuyNFDTMxidcZbSqmA06nY3WbnGHA5l9vW7d4gC69ckjY4rgf7rSqcwqDxZSeZm4qtLyx7I/RJqdC6HaXqhuQmthzhbECZNsDIfhIrHh7Vl1Ucovexw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=i8c8YdBD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="i8c8YdBD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=pjv6FiaQsSPNSLI42Z3cFBIdoX3uD5JlazS6nd0/Ra8=; 
	b=i8c8YdBDBB9rjXghAmHewdF0/WQEkgWxeeV1j9ki9QcZv3JD7ueTY5UeayyfnJAKDIVmkc7ol84
	/tyRmKs0TUjqnRgNTPtJoDe5fAAaM8ZeOb8FX2ZHoikf7k7v49HYJRQZ2KyxggsJMMKQCze4DwxA9
	mJL4r5vzKo3ZNnJ5ZeAXVlYA6dblAuBFjhJLaDyfjcFF0HfVPlarLpbpd4yBe2gmbmTVLkc26dqSd
	On+4xpUJnjR36rCM+OAO449V1ur63rtOVzY2CIAEPw1CfeO3sAh1yM4YWGK4DlRq581KqAz3NPr2R
	jj5DkMFFxKwerwB9slAGix63VPLGdYOmeZrw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUXd-00BEfW-1c;
	Fri, 19 Dec 2025 15:04:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:04:45 +0800
Date: Fri, 19 Dec 2025 15:04:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Remove unreachable pr_debug from
 iaa_crypto_cleanup_module
Message-ID: <aUT5DTzEP1__EnFu@gondor.apana.org.au>
References: <20251128135413.2291-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128135413.2291-1-thorsten.blum@linux.dev>

On Fri, Nov 28, 2025 at 02:54:12PM +0100, Thorsten Blum wrote:
> iaa_unregister_compression_device() always returns 0, making the debug
> log message unreachable. Remove the log statement and convert
> iaa_unregister_compression_device() to a void function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

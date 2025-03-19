Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E5B15A85A
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 08:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742372830; cv=none; b=RLTaEFjEAGOdkvHSSI9JVugGAhrh1pusJO6V4Wh5JxCh5xePbNG66WQB9UkMaaMjA8MUJ58k0MN64w6xy9l4m+D5qgjiFOsQFUjhS6Vpm7HI6HBya3fYqy63EHImgnstsSTaXCJyp1xPV0WYNDWV0+1usyNC50DOHupziuEvIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742372830; c=relaxed/simple;
	bh=RZG1LLqlVI3bop1LumH8sMbqpW6i8EWzhcmStIc0moY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/6LCV0EKj1cIpDLdq5FgJG0CTCQRd6h/UxXvHhzMeCyL5qnPbWPtbrlyZNg4KQH2bhq1PrV52wH787/xpMifR2vr+D3He5cRQ0L7lXoLaHpxZMEXGEsxbXtHdu4kqgsy7+7CsmHFfFAnZABQz37Z/i69yNAbAB38guIdrZDc24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BWrxobiK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BWrxobiK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gy01e5YqNpm302QttcL7gnPskMBvcydroZpkw2TEEYc=; b=BWrxobiKezvXnXimA0yCBFoczq
	+58LBTd8HB9UzljYDD1vTUFtJ6zPqT8ufRv7JDR9sgOf5vzAClLWt5QponMdmY1KGL5RYhlH+w09C
	cJvEoqO9km0dFYH9VRMNfwmhunRbb2d0jj5+VEQGWVQpTrPhAVzKe3ntedYmFBNLknu/xeWENLvGR
	YmIqYQRXGsAnQYSZSV5rmPxQEUIElnO8DzEYnjE0w1GogMBdxoggnBLEhwNFu3z5WdVbzVQb5A5i1
	RBvhxS6Jkd2J7T0BEL8wAHWBloX22Z5IIW9F3WHAFBoB7ATm3rKw/UBAKcQ2gRXl0hvfUIMKM1Hbt
	tyJG3tkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tuolO-008KoI-2Y;
	Wed, 19 Mar 2025 16:26:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 16:26:58 +0800
Date: Wed, 19 Mar 2025 16:26:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jan Glauber <jglauber@cavium.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Cavium and lzs
Message-ID: <Z9p_0k7AsqZql-Ye@gondor.apana.org.au>
References: <Z9pfpHP783E3W6pz@gondor.apana.org.au>
 <CAMj1kXFxbUm1NUd2ogVAqOydPhcbU9GwnOhYnbuM9Tg8GNazwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFxbUm1NUd2ogVAqOydPhcbU9GwnOhYnbuM9Tg8GNazwg@mail.gmail.com>

On Wed, Mar 19, 2025 at 09:18:42AM +0100, Ard Biesheuvel wrote:
>
> Not sure whether there are any other SoCs that incorporate the same
> IP, but the ThunderX SoC that it was added for is hopelessly obsolete.
> 
> So depending on that, we might either drop just LZS support, or the
> whole driver.

Removing the driver works for me.  This is the last thing stopping us
from removing the scratch dst buffer in scomp.

Which is ironic because cavium allocates its own scratch buffers so
the scomp one is only used because the driver isn't acomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

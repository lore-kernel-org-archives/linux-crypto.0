Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8292114
	for <linux-crypto@vger.kernel.org>; Tue,  1 Apr 2025 04:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743481915; cv=none; b=LsDbWBTs7tXPxW1UpKA3+gyzl0dghyOaXZXtHgTjE6hkXrhJSX3v1SmljAeUSdt3rwtst6pSzinfF9T+X+5I1xk4L1f6xpMxpu+5RrTS4qD4uu9bMjx+fJ9ftPs1NsTAw6GpEsFOn6HHDd6CXh3HVCSK9V+MP543CrJSh3D2vDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743481915; c=relaxed/simple;
	bh=TcqRjMaaqSn3oYvGVFoEr2VgWGVo3miTZVbeXLd+pB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fps4W/+puSqH2KiJtOtOKvyVlBomrV/ur27xkuXZVJzMEWEf4w5WdyOXbTzFaSR4v9tJBRrfTsaTcOkTN630JIMJLq3dYnXmvTp+LZg8zeMoAehPzNyK26Pl+HNuVeNBQj3AiBH8tiFUF4Dc8gBUWIjDK/4lk5l5H+aZSpv/5WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QgCeFB9q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QgCeFB9q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FO1a0KoaP1tuu/XDLemZd54qUAb/Um76I8bcmMGHhbg=; b=QgCeFB9qsqL3lggUR5LBZSBvn4
	oHgH4Iep67vm1r12tLRcOl347G0CtLllJxe+liY9JEKkQu3We6noecL9Zl/Vqz8wMdr4PzWgyWNIH
	lvXAlMqBPbTvLcaK32Djgi68IXY7RC6VFoiETCyETMDNryD59EP9v44zd3YX4IEHtTlGPhyE+8bl+
	eHcG7klQV2F8fCfGGnAH+28T9fXQEeEn614kBxOi/QL4fJcpo5Bcj+sNpEIoVl/t4YQcPQ/9P2Lnv
	BiHQthVj1q1D+Kb2uKsGh3TGUdSfcO/e44hxnuPB7lxtgSTLUtWdRTnvA3TOwykIpZJg4InUstzER
	OryCFg9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzTHw-00BkEI-26;
	Tue, 01 Apr 2025 12:31:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 12:31:48 +0800
Date: Tue, 1 Apr 2025 12:31:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: Gaurav Jain <gaurav.jain@nxp.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>
Subject: Re: [EXT] caam hashing
Message-ID: <Z-tsNNmTih4Yt7dR@gondor.apana.org.au>
References: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
 <DB9PR04MB840907ADF03612B64D1CF910E7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-ESpJxIG8jTGHZM@gondor.apana.org.au>
 <DB9PR04MB8409D73449B57FABE1B3031CE7A42@DB9PR04MB8409.eurprd04.prod.outlook.com>
 <Z-EmH9n5u05iJ47p@gondor.apana.org.au>
 <e3dc3351-c819-4d65-b5ea-0e90916ea7c8@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3dc3351-c819-4d65-b5ea-0e90916ea7c8@nxp.com>

On Mon, Mar 31, 2025 at 03:45:51PM +0000, Horia Geanta wrote:
>
> Yes, running message length is big endian, possibly unaligned.

Great.  I'll take this into account.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

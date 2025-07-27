Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF81E51FE
	for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2025 12:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620247; cv=none; b=EpayUaPklOkAlflKejoeP/avGXBCvqNXGcBrx26FbPEWY+lgvXPNY2RmeabtjllI5SHMY9THY5ab1o8QsVxGL/n/7oPNMUG6GcJfzms7OE5oBn3swh+hHVwTMJhp0GAiJbUUmHUf8xtRuXbwOS7/GhZWgkSA9hlqbrp7mg9mstM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620247; c=relaxed/simple;
	bh=A66a91zpsPnyYhEr/TgU2Ui6AGCCz2/8TbZlUY/J3NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sofOZ9vXc2/xHpJLJbI084JDbAn2qTZ79FVj//TGgPE8D9XYrT1CwhT/Np6SMKfjWB1eBgTm1JP7dAu0Rw7AkxBw0Nq0qyoyGuFxZCgvfu3GSfc5cLhDYqs3jnRniMtU6Ch3VIpSHJZcc5QqIYFWnNJlx19mBHVl3ZQUuIHRyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fyOoMRpj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fyOoMRpj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+3GCA7o9fQ9p9JIg4wFA5RuRGzbothpB81Cq5g/wUvM=; b=fyOoMRpjDSd4Se63dtXF1kOuc9
	UldCgbfNaRktyzHGWkB59xKeiCdSAcEZM7D/FtO7SH5PrauGsihfqtg2ezp0kS8edP2Rw1Cz/OuJV
	LKMDu8Vkkm9VpL5CEoz43b+Kba5FzrVVMrK5pmnUn7XWpggatdYOQo3c6rPVwHRCAVvnjCKsFdDJN
	czD00oxw77MzMsxasMMOoIEGBm02WdM4geCxwwOZvsTvgupB/NGopbBfc/gZmqjwObDtW7asD0apv
	THKN0wZbiqneXrS/gxzRkNt2r5M9yhYvrT2x2o5Uw3cnYRZEpzA9v8SoYM/PRh7zs9+NpF7SFii/B
	am63HWug==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0U0-00A4sI-1e;
	Sun, 27 Jul 2025 20:44:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:44:00 +0800
Date: Sun, 27 Jul 2025 20:44:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - fix and improve ring related debugfs
 functions
Message-ID: <aIYfEPz2qJxiYoRB@gondor.apana.org.au>
References: <20250714071135.6037-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714071135.6037-1-giovanni.cabiddu@intel.com>

On Mon, Jul 14, 2025 at 08:10:28AM +0100, Giovanni Cabiddu wrote:
> This small patchset addresses a bug in the seq_file implementation for
> ring-related debugfs functions in the QAT driver and introduces a simple
> refactor.
> 
> Giovanni Cabiddu (2):
>   crypto: qat - fix seq_file position update in adf_ring_next()
>   crypto: qat - refactor ring-related debug functions
> 
>  .../qat/qat_common/adf_transport_debug.c      | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> 
> base-commit: 60a2ff0c7e1bc0615558a4f4c65f031bcd00200d
> -- 
> 2.50.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

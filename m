Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A772D266B6C;
	Sat,  6 Sep 2025 08:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145746; cv=none; b=S1rDwC5Nl0Q1IqJhFodX9AFh5kD/CmSy4dvd7/xIpnXBfqFtW0IicRj3Swdv66rMKI2X7ZEfBpmajh4vQcyGWs/BYzBt2UhzXGkNhS+PIxfZ4+oiG++oRI55IF+YriLV6fi1NAsx0GCAuRwl6N2H+t4sJmkCtUDEjF1BppWE65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145746; c=relaxed/simple;
	bh=7ejlEKmJaHMo4EEkk38bNhQMp1MLd0wJje6ql+RDI9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M51AV42eC8NGKVLGCxvjMfzd2EKI//cO05CBpOz4JRb7K8GrM/TeoPZ4NFaOC8moZqPi88XH70u7aJY8KGZr0k6at9Ca1f9Rqff7nHb6JBHnHoBpeHDMh1zgrd3knAvb0Wl1LA2vafMJUE725VLzMPqZwPQHUK1XXAFMeZN+COU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iJpPVuRw; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iJpPVuRw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LheWJZB6RGpHI2S5TPFLdD2888AupwevejHdiKAccQU=; b=iJpPVuRwJVsTfhWtTgAvS3Bldp
	RSSsURK/J6Cas48FcwQW3F/fUmEQrBF/m0xeWURaDNxWJ/ZdjT9Tw4LF6u210MF3emHRCNgHfTpiK
	cdtYNLsVCwdxtae02A1xYQ1RvEVx3ecjVeMWGggpkzb+dVH6oTHKNfqH5SOVrypX4+vbhzT1q2r73
	PN4U1Mqc3XUeC6DJL+lTUMQHUmpRPhveTUwBOG5LfHnH57TPLNmedCP2v2W1XUjbQ1TWu2QNYHDaX
	9lSS6Ch9znvtmqceUHZng4E3Gc9gzCJ6DUHwg0GmlkDYwTSwuSGBKiQDdslNQ2IbNuzMaarKyeEjc
	eIoHhblA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uuncl-003BPM-0t;
	Sat, 06 Sep 2025 16:02:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 16:02:11 +0800
Date: Sat, 6 Sep 2025 16:02:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: zhang.enpei@zte.com.cn
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, christophe.jaillet@wanadoo.fr
Subject: Re: [PATCH v3] crypto: caam - switch to use devm_kmemdup_array()
Message-ID: <aLvqg0DZQkkUZuHa@gondor.apana.org.au>
References: <20250827155236014-BSh7mfwJD5Yz3cdi955c@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827155236014-BSh7mfwJD5Yz3cdi955c@zte.com.cn>

On Wed, Aug 27, 2025 at 03:52:36PM +0800, zhang.enpei@zte.com.cn wrote:
> From: Zhang Enpei <zhang.enpei@zte.com.cn>
> 
> Use devm_kmemdup_array() to avoid multiplication or possible overflows.
> 
> Signed-off-by: Zhang Enpei <zhang.enpei@zte.com.cn>
> ---
>  drivers/crypto/caam/ctrl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

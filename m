Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EB21B218E
	for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2024 11:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671831; cv=none; b=fEnsq9EFjUt72YYffxZ7niGbCxSEInH1IPaSTZxhGoHgLC/dT/hQqVN9fwx1A/WY+/G0QmyEog4h9w4PGodtTtV/KJLp/adsO4MbwLBABGMfvwef7Btq6FU3t5wA65JLQrS9UJ7l4errPxSIrAdT7jvqWp6Up8fJm7srDRbdMq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671831; c=relaxed/simple;
	bh=17featO63AHhTDwn0XA/uIk0WRqUZjoMFmPgS5CSL1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfnilUAKkJ7ZdSloJEHIa+h/f3NFvdPgUcSbg2mXWjhvEi1DZF2fBHlaqj1hSDDWV3LAfGPygh5nQHt2UWbfWL5s37lrH5yZEFhNlqiP3BtLBNhvKOKMZkmzHYNsK0r1Mo02dXVrO1+pnx3K+IqQd+u/2XyhD8MdJj2x2/Bb/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=THJxAlBp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="THJxAlBp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a7WCWLXfvWYcj09kSe489kB4x3RERQaIoEoKPSLBE4U=; b=THJxAlBpWD2XazVhnvAwnPHZur
	n/unumB9oElc2eoxl8wTbGjXpl68S1Eems8idESOHR4jXS9tq1BHbGBLEQEPJQXxfvOUvq2Ic3sZf
	QzadEck9XPQtZW9d20OAKL1gJ8HZA9XKUz0BbtyGOkLsGF6RWwn/kW0KZzJ1rdXGpc8ciON6Ug3L0
	2mwr9G/o7ausTV6h0ZEBVkKd1hr6swcP6zJjtukIgX8aJM8g5DDBAW+jU+Wvd+q5HtglZM5O/nfs+
	iotE08DACw0inrjdZDTkbdM1+eapAmpSyVUhS3MxW5nLXbhRQyCXMBPkSReSIdDHMqaV3DHy/mjsS
	j6qRyjRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBuwa-00H1wx-2w;
	Fri, 15 Nov 2024 19:56:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Nov 2024 19:56:56 +0800
Date: Fri, 15 Nov 2024 19:56:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, tudor-dan.ambarus@nxp.com, radu.alexe@nxp.com,
	linux-crypto@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH] crypto: caam - add error check to
 caam_rsa_set_priv_key_form
Message-ID: <Zzc3CIbvow2RTxqD@gondor.apana.org.au>
References: <20241104121511.1634822-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104121511.1634822-1-chenridong@huaweicloud.com>

On Mon, Nov 04, 2024 at 12:15:11PM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The caam_rsa_set_priv_key_form did not check for memory allocation errors.
> Add the checks to the caam_rsa_set_priv_key_form functions.
> 
> Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  drivers/crypto/caam/caampkc.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

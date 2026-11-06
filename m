Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963097;
	b=uXcM2l6M45uT752SuOvm+NHDJgqwFLLbSXQRSxxpF1m3sZNfNnXW/XlVlJaSEGyU9KVj
	 lSyOKrK4ngh+3PWoBHT5Eg/SALINGcAQ/m3SJT4G6V9rdhnF06VpP2D7CwQpmSN0mxl4E
	 flzH5mX+BtNahIlYyJ3m92qcTwxeI4iq9IxdJXz7oKlXGXIGKADQOvTguaHrvjcdaVofZ
	 FqWiyzp41T1MbcCNXCOsJ82gd4zX8PYMiRcU+w9QHgiD9sxQNdEs1RDEomrrTys7gA7wP
	 EAUThfjRgqw5bDHs3vQZ721j4sXQVj2xLeCWua+mLnMBhl7XSaoqMmQZA53BP/ncD2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963097;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=840l1+NRCJffqP8jGWZU81yXph/OTtF9PmFfJpjGlIQ=;
	b=ZKrOIhQMODz3Sy8WOkPEImYNWlKk/vgz625iiDD9dokXz8olX1T0P4geIYsp5teqEN3l
	 QCGoQKlrQpsMdYxGNC4PMMPrQB4NMGa5r3QNQ72WSZgIYIyRsPXuLPQ8IdVuWdqhOT7PB
	 Sjj9vsTydEJ7DJdGlXRuPrWiYjVf3563t3Zfa0ODl1BZmjgklrlErg6MOtNSF3RuMjA+2
	 HHo9zmpcuxN+E1ag5ez24N6wp2wMTsM7+IByVgrkeyVFsGZchjV8pSv1VZFOJ54XSwIXP
	 +X01q9Y8OkQZ8m6rzNZiOwVC21rx4ymX2Gymz3qqpbOpDonoMMCG1/1tZCzpcFgdQEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=nY37wDZi;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59531606A326;
	Fri,  6 Nov 2026 11:04:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59531606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=nY37wDZi
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=840l1+NRCJffqP8jGWZU81yXph/OTtF9PmFfJpjGlIQ=; 
	b=nY37wDZi0jBnlX/oA7zBeeEBGxGYFwFX8l8my1sOEs8KnCoSCytMq3UOEVoCFeJm3HVY5cox0UK
	uGl26azA0WwKCBCeaOmffBfKdoAVfNaaqAR5ZpB4cIxbhfRbJSYtcQlplYv6qkglrNhNPPnESsfL/
	SSYTpkxArvZX1DKpqYj91k7l02cK/Zgj5PtfV9To3IuP/4jpt2i16r+UfYGchmRUc0Ukz8GZoVXyf
	9NKQty7SaeEY5+vpCpe6fbvhF8F8Z3XhB9P4RFTwEkPBKnQolwG8gKp/DGAUzKMdm/6uIZwQyqOmv
	VX1kNAxk2IUtwuOsgAh5vU0rQVhP7vwPayeA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPHkP-0000000BqNb-1p4G;
	Fri, 06 Nov 2026 19:04:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:04:41 +0800
Date: Fri, 6 Nov 2026 19:04:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Thara Gopinath <thara.gopinath@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: qce - fix CCM AAD buffer leak and the AEAD
 error paths
Message-ID: <au20Sf0r0Ck6Mc53@gondor.apana.org.au>
References: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>

On Fri, Oct 16, 2026 at 10:09:42AM +0800, ZhaoJinming wrote:
> This series fixes a memory leak in the QCE AEAD driver together with two
> bugs in the error handling around it.

Please check the Sashiko review:

https://sashiko.dev/#/patchset/20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0%40uniontech.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

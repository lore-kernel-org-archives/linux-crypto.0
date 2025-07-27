Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3488A19D09C;
	Sun, 27 Jul 2025 12:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620421; cv=none; b=PaemerVg+M2RWJYEGcSEqxCBGRFt+nCcDoQrzM96JEf/ZvAKEEsDoyIaVxvZUzL+wfzOMpnChNmqWlt/XHjZEg7MwxG+ytdU3AUchBhfMaJTscE6K36HxtAC5j1eXkxJhFfry2HRZte7VmKhQNssl5jqacPujAHqf7Bgoblt6gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620421; c=relaxed/simple;
	bh=jqDBm1cu98OTZ8pfukLBz4tWi7w8LcL0+yKMB6zd9EQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQY/9UC0op+GtclW/jK4qr/J+p7lPftlwMwO9holYYDRwNDxNimuyqV8FaNcgnC3ijoPiVeTxfh/2IY5HQJpdYCElI6FSlS9HPqmoU0crVS/Dm4mhg5VkgsX7unsoKv2d5MGoaTVJLoGpojjWp2fUPd2eYZlbI+4uBAJwNB9XYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=tCUrrjPa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="tCUrrjPa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=a/GI/a8jqI0nVrfGIWGF5si/MO8HzB/HchmBa3oJyNA=; b=tCUrrjPa8c1xc14e1GigHtIays
	vDN4nnWB0yWwauKGg5BtBBXyA+/UHlNorAqaQinnYpiXberJ0eqPyd3CnAh0cTPSeluvz0DlDRG3x
	iba5+ZlufxIHIfA58dB6Z6ZrJL9MR7a6qLoqjQgqC5OohIb6MC3n9xP1lKV7shbfiw8pQDz96WF34
	uVl8hXzsmZXgdd07sdl+XdCfoYrh/3Vo9HdDCisiiUR3wYMhas7o6WPzVFdSq5ZOPHI4tPaIMtKAD
	cDTl3oySXS4HrcTdXPIwp+eOuQk/0AqmRa5cJK5lg0nxibhGs0dRduy4NDFlrqDwxv/yYi32SPtL2
	kpj2k7EQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0Wi-00A4vK-02;
	Sun, 27 Jul 2025 20:46:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:46:48 +0800
Date: Sun, 27 Jul 2025 20:46:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay - Use min() to simplify
 ocs_create_linked_list_from_sg()
Message-ID: <aIYfuACQ9qpNddGq@gondor.apana.org.au>
References: <20250720182605.427375-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250720182605.427375-2-thorsten.blum@linux.dev>

On Sun, Jul 20, 2025 at 08:26:05PM +0200, Thorsten Blum wrote:
> Use min() to simplify ocs_create_linked_list_from_sg() and improve its
> readability.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/keembay/ocs-aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

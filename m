Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168461;
	b=Bu3nmLAXOVJGGZlQgt3Qhk3qZFJ3tnA3cLkD4vmFjEYzsEkDzrNi7/UfoJ73MIELhoj/
	 09vs+5N+lPj6ibEzLJNZkk/ZjyOU89ND7Q79JnfnYIq9G+1ZefNsiMkQTiRJFk6IolQnG
	 FSQmd5Ywt2x+ai6Oia6yhsAvQPjIRMEgPk+Lo+A8R5qbM/Rxw3zWMk+kQCodrGR2G6aOF
	 knzFtbYsRKe3T+VD4JKXeFbgPr20Dk6Wf49Ji0lnqWKD6H892wR+yQMuIs858nqwUxAS9
	 DBCr+KRMfs0IxWZSB5GcqLwqcdIm1q5FzUh7RHJIb192b4juTbcY0JRePlHj2TRgM1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168461;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=5H4SaiSHQZbbitE0VP8DxeDHKADjdTBjB65w822tiJo=;
	b=sXeEWgUdH093BahQJUGYn4Tlet0ErzgUtvJeeW73ghltMEGCBtP5TsrKrfC9XGjuBTqj
	 V6RCIe7k2QVq45a4q2LhZ9ApjjW4sLgwClfWu9oHnyUNcbCjxoD0H5FDIxRh1GF6Mh4Hu
	 d+PWY7AZqVQmgCW/wZ7z3xmjD1Hlhl3zsRhGwzOmi9ETCRZmbTwJDhrTk0YWE6cqXkfev
	 2yF9tTPi/U7DCEi24kCvpjatGgyVZ3RhbK5j/oy4fxk5XlfNFYh8lL1rT0V2vi/sJnaFe
	 qnQGO4nEku3ZsJvonpW0MVAJ1FeU0d3qMhc8sr03aG4aex4vmxqd9Hh6mTa0BgacELg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=EcAwf6j0;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A363F60A262A;
	Fri, 20 Nov 2026 09:54:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A363F60A262A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=EcAwf6j0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5H4SaiSHQZbbitE0VP8DxeDHKADjdTBjB65w822tiJo=; 
	b=EcAwf6j0CntvZ07zEBA0EK7mGtRM6Ty9kNZvBf6cSfeCnUQIxwN3OjQZDd7K6GdsFR2OzUkBpsV
	c7TDp/i9LBg2XdYy1M6gNr3XFwEoyPSvrmRyLrfHOzRxWmDr342iLO9fZuqzeXHpsfU+A7EaF7Z/9
	YCt7WXWWR1eYd/GtGSpSHeME+zRUKqvXx12OjgFVjKGvNT0AAEIi2XlnD3uSg2pO53snN/fLlIaJq
	moAsgef5vq2jLcET6rJBrKnshrbeueOTP7zzuVY4SINFGmkc1TTjpLMQDUkt0VbWKbp9pRFZbps9i
	w46W2VEge/e+dJ3yg715glnlttUEofgA4hZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULJc-0000000HYhH-3TYH;
	Fri, 20 Nov 2026 17:53:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:53:56 +0800
Date: Fri, 20 Nov 2026 17:53:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavel Popov <pavel.e.popov@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	"David S . Miller" <davem@davemloft.net>, x86@kernel.org,
	linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] crypto: ccp - Drop unused <asm/cpu_device_id.h>
 include
Message-ID: <awAYtBlS9Fg8iBDz@gondor.apana.org.au>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-8-pavel.e.popov@intel.com>
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
In-Reply-To: <20261111234821.4814-8-pavel.e.popov@intel.com>

On Wed, Nov 11, 2026 at 04:48:20PM -0700, Pavel Popov wrote:
> Nothing in ccp-dev.c uses <asm/cpu_device_id.h>; the CPU match table
> it was included for is long gone. Drop the include and the #ifdef
> CONFIG_X86 around it.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c | 3 ---
>  1 file changed, 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

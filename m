Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395390;
	b=jqW8h83Iau2bUtQ1LqHt1XBzdrNHyldl/65MfykftGD4Gp0E+tW+8e8Qt4mxhVmGP2Le
	 MKOwR3KCbYVUWI9jAvTLGo/ddlzwzcdoDqla9Rqn5n3Lh1S7fLDp+w7jmzrhKFOsrMHBC
	 DMBRELvcmKf3FEHGVYlditSuKoXrHy5+ner8xCylDfVPug/QLcaMZgYVuDYTmttkb0QJs
	 vhlSVvE1m1ZcvdV2AIjm937KveZgioJVw/hIM/M8N2o+HtAO1/QO7OtFO8FaSAptInDFy
	 k55276Z/Xo7xLfXTPVDjfrniPW5YeJdOZA75sI+NAkb/hYX1KIMbeWmZwE7XUUi+E1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395390;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=xUWrGeiVJp6mO35QrtyhQ7Y2pj8LDKhG3Xi2m+MjYn8=;
	b=ramV4WaXgbCAfGEiWAlx3lmPRirxiHYmoprRuVZKfeybukuHU4ug7Z5wBXpJup6x/tJp
	 UoVqRDpidMIiGyAyWqHLjFMpHCEH7lMGkzkXBj8ZI4ykB+g1zhb9B1N4Q7sOIxgspXymx
	 7H1jmjXvSLjXo8ZJGajl6hJWMlJIcz1qulj3rZfNNy2EiH0RIrccMI7287xgv0nO1M0KO
	 mOarlhpuWtnMj9RAALaYwz54ffIDSXuu/R91xB/qYoAHGQGsBPnUzfZ/trvRyrF8P7W+t
	 ke9xwS0YefMG8iBWPDS/mvvopYJEnCJzDg9N4E5rPEraIx30+4942joeJ8VdKOLe+zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=jsJCrizg;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5CD606A8AC
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 11:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED5CD606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=jsJCrizg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xUWrGeiVJp6mO35QrtyhQ7Y2pj8LDKhG3Xi2m+MjYn8=; 
	b=jsJCrizgnEBchLFKuJ0vXfXoVHVv6eO5xjLYlhWzYWD6oI5/9h0ClhILG03/3nNJAUs53Rv8KHi
	Lhl/fUajy9qttwPjKO1nxBx4iJ47tEiCFskMWPAb5c1DpYlgpMg3sI03WRUxlaonbtk+XNzP22gGk
	Y06+APNDSzRWWjujWsqFmeZldFvXr7kl05T8T3K5n+cSkd/vIDGOHZJVZO0/wPlSb6HRHOMK0BmHg
	vpbqAQH6dNWAWk2PDrG2iDwXRGBK8w4t9/IUsxo3juR37vS2q24MpWAtG50WS13io+h3ob7V6MBJj
	x/Yp+wH4UYbiI721KwXl+8Mvp5ahS/PI+U6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6D3-0000000DmPG-3qZE;
	Wed, 11 Nov 2026 19:09:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:09:45 +0800
Date: Wed, 11 Nov 2026 19:09:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: George Abraham P <george.abraham.p@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - fix rate limiting and telemetry for
 QAT GEN6 wireless
Message-ID: <avRM-dK1hd2M4cEv@gondor.apana.org.au>
References: <20261019110356.3781949-1-george.abraham.p@intel.com>
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
In-Reply-To: <20261019110356.3781949-1-george.abraham.p@intel.com>

On Mon, Oct 19, 2026 at 04:33:53PM +0530, George Abraham P wrote:
> This set contains fixes for the QAT GEN6 driver (qat_6xxx), mostly
> affecting devices running in wireless mode, where only the symmetric
> service is available and the firmware uses WCP (wireless cipher) slices
> and the adf_wcy_fw_config object layout.
> 
> Patch 1 relaxes the rate limiting initialization so that throughput
> limits are validated only for enabled services. Without it, devices that
> support only a subset of services fail to initialize rate limiting.
> 
> Patch 2 fixes the rate limiting parameters for wireless mode: it uses
> the firmware-reported WCP slice count as the symmetric slice count,
> sets only the symmetric maximum throughput (with a wireless-specific
> value) and computes the symmetric accel engine count from
> adf_wcy_fw_config, where the wireless object is loaded on two accel
> engine groups. It depends on patch 1.
> 
> Patch 3 fixes the number of command queue counters reported by
> telemetry on QAT GEN6. The per-slice multipliers are replaced with the
> total number of command queues for each slice type, reported only when
> the slice type is present, and the queue count constants are corrected.
> It is independent of patches 1 and 2.
> 
> George Abraham P (3):
>   crypto: qat - validate rate limiting only for enabled services
>   crypto: qat - fix rate limiting for QAT GEN6 wireless
>   crypto: qat - fix telemetry command queue counts
> 
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 38 +++++++++++++++----
>  .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |  1 +
>  .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 24 ++++++------
>  drivers/crypto/intel/qat/qat_common/adf_rl.c  | 15 +++++---
>  drivers/crypto/intel/qat/qat_common/adf_rl.h  |  1 +
>  .../intel/qat/qat_common/adf_rl_admin.c       |  1 +
>  .../intel/qat/qat_common/adf_telemetry.c      | 14 +++----
>  .../intel/qat/qat_common/adf_telemetry.h      |  2 +-
>  8 files changed, 63 insertions(+), 33 deletions(-)
> 
> 
> base-commit: 19a2e99ff8eb57bd3d5cb5d52f9eb77bf3b1540a
> -- 
> 2.40.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

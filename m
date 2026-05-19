Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84D93AFD1C
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779203332; cv=none; b=l5/BRdL3UxttqU/UgXJhtUUg2WLh2MvplIsUEquSpZezdHuLbT568FPB3s03Oq7azpy/mw+dzllpT/dzWKVGQPjMALKSmbUE/7SQViqCjmCCwN8NcW4/sH2XdoY+s9yRBdkuhZgs5S9CJXlYheIaXACdcZ2OL26W9pjKns6g+tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779203332; c=relaxed/simple;
	bh=QLKSoKjES7TRoInF71uSgaA0hDmAMuFqyVn9YgFid6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMznqJZlSu0QnhTEq38BLsUYIRJPoyXRg/QQDXNs55GRP2R4IZ53Cnz2lOOI3sK1ReJvIDJ2ljyU5N9ejqZaraLwVJBO7GBrEplMqeRJG18/wnSRmEfDAacYtpCa+3oQKFLP4PNmEVItpNVbb3RevIXXVUAzPkxF0zsBnoUhtns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IzpdKzfn; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IzpdKzfn"
Date: Tue, 19 May 2026 17:08:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779203328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqAODZTseDy2b3wTVMd4RwN7DRzwrz661jj/FBjPqhw=;
	b=IzpdKzfnSvUjR2XRcC+CIJrKvzmIuzE4S6YOpTBRE/1Qia6QepD4RLaKPIvLQFm3EXrbM7
	uXHnG5b2yxr1SPEDSj1XNF+P7vnfWeg6zzM1QunqZYfjoUbT5emBhWpTARwUH7upZT+lKP
	uLlEfUCcPGi0B9nTgcZrXW5i7V6LuBc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] crypto: Use named initializers for struct
 i2c_device_id
Message-ID: <agx8-_ZCrC4-enwR@linux.dev>
References: <20260519141033.1586036-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519141033.1586036-2-u.kleine-koenig@baylibre.com>
X-Migadu-Flow: FLOW_OUT

Hi Uwe,

On Tue, May 19, 2026 at 04:10:33PM +0200, Uwe Kleine-König (The Capable Hub) wrote:
> While being less compact, using named initializers allows to more easily
> see which members of the structs are assigned which value without having
> to lookup the declaration of the struct. And it's also more robust
> against changes to the struct definition.
> 
> This patch doesn't modify the compiled arrays, only their representation
> in source form benefits. The former was confirmed with x86 and arm64
> builds.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

This part has changed recently, and your patch no longer applies. Please
see linux-next or Herbert's tree for the latest version.

atmel_sha204a_id[] now uses .driver_data, and atmel_ecc_id[] has been
extended by another entry.

Thanks,
Thorsten

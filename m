Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795503930;
	b=1snz0Cdb69TEQV8umYypgrnicaJKpytmz0T+bPKFznNKmDGNwhvWs8bcXJgXC5ZsPlyB
	 e3YFaX/vupuGTmrE3gcJZ0gKU8wENTXqKy+U+gsY9KeAjjGwEymlpfHaSxpLxcCmwLOY2
	 KAUWaQu94vHWyO8mz9mtG4csI0L8bnWdViCZrBPsQsLp1++YBGILgeUbYh+1jJQWsyI/z
	 yPizu+ipHdoMGG9MLHm6pa2L0bKIeTVjrTu0bJUfHGX7+VFcHAGjJvcAAkYyOhZOCddEa
	 nNTFOgRXxnuJmXMzwG/ZoDYx5jpz6L1THJFE96hyACpZxW+DM3+elDTZNTmTVF0c+cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795503930;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=uWITfgyRJ+DT3n8YFgueon79iakRaQERwgzzXSP2YYo=;
	b=qI3MHKMX5ySEYDLhX/YCiHoFq0n2OBA22icOi5n+JuVIgpN9MORES4xwcRdoZ7NpjOGP
	 crgw7DseKDf540pvWF9FMey0uTKrP1bk4eCIYUQBS966hP6wPlc5Db3Q1OaSXLIVREG/q
	 jRl6LfcFoXn4eeMFHjsxjmvo+BCVgDHBnXS0O+HOSRKjaj+hNuemOjCymaZ8D0nFE4Mio
	 aSuvAvfVvoTsfryMCtwcCnfdfPb6mdQk9ojgg8LrDpEKM+SKqsWg9Y/Jq4tyr78F0cevi
	 lJnvim/uzj1zKymZVIivuPcVY/NCHhamqNadP/ZlDTMmQ8BsZRvtgmkqed6BsugolOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=kqgoHF2Y;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DCC606A322
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 07:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48DCC606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=kqgoHF2Y
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49d05d51553so29649395e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 23:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1795503929; x=1796108729; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uWITfgyRJ+DT3n8YFgueon79iakRaQERwgzzXSP2YYo=;
        b=kqgoHF2YDALc+f9/RieVMk3nV8G4RNjhav/vx18ZWMiMNQndDTGFtpK7lcTEzu4Lkn
         9D2G5/ZTGnNt+knnZeBE3unSxyw+zi93B1ut2dNz73+v2ADuPbdSWQHuzgkO04DLXmjL
         odO/YveQjmNTTn0H+03xgCdf1ZxUHYInFSTZxJpWBDm3bXL2gxi5n9PTKva+gOc/DtR7
         yntni/qD8wXpjNrB5LrlQnzvYJ4UQla64AG0p/S/lLP9GdKCnl4O7O81qKWlobG7lzKs
         4w6H9D1N6dKGYzVyikfctxOhKpa53SVjdwgzU+e6ys3k2v2tqOTyW+ukNX2O25ez5MGH
         HMUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795503929; x=1796108729;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uWITfgyRJ+DT3n8YFgueon79iakRaQERwgzzXSP2YYo=;
        b=loG25lAjswEXrPvoP3YEizWVtfm5H1H5skIbQ/wvYR4a773GfLL/aT4yMYTGbxHnQE
         6f68uI7ieQjfEHp0hIFEQhtwrTd7bHb+IJC67b/kQjXrtYB4u5UE1cBEyzqhcwiIKvgp
         dBtVYKi/s9mguORXewpyWSU0C0P8qszeYKlZxRIRXlb9jX8wk6ojIaBVHy1Wt16cs9ne
         NLG9FxHitT6AEFFNUEbT+RXT8cbEmcgyEANrv24/MgbBhKjF7fPivsoKXHHzlgF8iyOe
         aORguSgPUvjss7GJiwmKsLJqV9IYZDoHF8S29xL3EQI1IeMqv46m+Z3Rm6h5/s9a9aZE
         gb/A==
X-Forwarded-Encrypted: i=1; AL+hErEF+IQBAu4H3Si2Yorvhjf4Duo75ydc7Jg+1zdXnAGQAyXJ26J7SnB/a4kMgtHVOSRsTNNT9axbDm8kRlc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8K5MSOpUSLsEpcIPOLFz5ckZFLMVBVwnXV2gz2y0Z7vlenzIcE
	MiArkKjVanvw2QAluhD4wuL6NePjNUYMAOvtBC/AeGSSLcg5pCkH04pno9r9jpqfX3U=
X-Gm-Gg: AZFdTZelyeYe2/wHbO7ik8gPZtgTZPM4eNT/CGBvAkYrxsYW+Ywz1t97xaALQddsQ9Z
	5eBeV/fyd9gxXyZHUW+6c5t8ewZY+ySHOkrh8gJUEy2pB46dNIQicwykoV8XRZpxRMBxp7t+s/c
	KJabHcPxACMwFhx3j/XB7UPb1fEwkz+EwSojLino8CLCn759rqu5bZIwEMvllqPA8VPgdhmXUlC
	Nv5LttW5LJ6PW1upOsEs48GKHxk9iYTWiHtAxBnt+M5RGT9GqE7FcRY32pnhCkKdU4nwxYxuwBr
	RoiQ3+agx/B3VSuzkBg4Wf84hfvEbqc2AGM6CHwuOd3pMT96/37U/CaIJX0fvgXzVS+cy2751bB
	9mHeTYsYhNHfIHpMciuk3WH4Nm1SbGL6v99PNQ8RTeXbju7jCd5C0ZbLhWdoy4D1KImxzYsG9rY
	vC5mYaG13WArb5uypwIRcK6Lnlh80qhmIiTXD2IRe106GiqfNEAGa1ScjBmCWEcnGpHhhBGF3um
	q4WZgUldGf//QZ0gybKmvUedQnnzlgtuR7tHFsf5uSMzJzDLe4qE1SSESlLme9y9K/5zV/ugD6E
	sG7VXDZRNXlLhiNQrHjS4tY/OGQk6ABXq+Q=
X-Received: by 2002:a05:600c:3b9e:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4bb88820687mr324067185e9.29.1795503928774;
        Mon, 23 Nov 2026 23:05:28 -0800 (PST)
Received: from localhost ([2a02:8071:6e30:8500:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4bb8526cbd0sm541592115e9.0.2026.11.23.23.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:05:28 -0800 (PST)
Date: Tue, 24 Nov 2026 08:05:26 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: filipp.dunsky@gmail.com
Cc: Olivia Mackall <olivia@selenic.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hwrng: Add Cortina Systems CS7542 TRNG driver
Message-ID: <awU2-KjkZB7WvqfX@monoceros>
References: <20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com>
 <20261123-b4-cs7542-trng-v1-2-92d9ffcee531@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mtdygncuvh4wucsf"
Content-Disposition: inline
In-Reply-To: <20261123-b4-cs7542-trng-v1-2-92d9ffcee531@gmail.com>


--mtdygncuvh4wucsf
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 2/3] hwrng: Add Cortina Systems CS7542 TRNG driver
MIME-Version: 1.0

Hello,

On Mon, Nov 23, 2026 at 09:41:35PM +0300, Fil Dunsky via B4 Relay wrote:
> +#include <linux/bits.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/mod_devicetable.h>

Don't add <linux/mod_devicetable.h>. of_device_id is already provided by
<linux/platform_device.h> with less overhead and build dependencies.

> +#include <linux/of.h>
> +#include <linux/regmap.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>

Best regards
Uwe

--mtdygncuvh4wucsf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmsFNzMACgkQj4D7WH0S
/k4RvAgAkmX1z3ggD4bQYR5QDbQBtW/xgm40V3vJbHo8sFlOzs9OnglLP+iPjhHu
WKQBnpxjsqZITO8X1LvclAujKd6LAR/OEzTxOML37xIoq2uBbct6r4uBVug8dmzk
0TZf3jIxobXh6AuI2klxHcrpbIkEKAJgKFnJNJnRnS2pjQnmue649DpG/SF2PgAm
tIIPrcfWA1AyLg82sa98l6cfBXT/Cj1+457Y+hc7mN9Vs6T+gLTj9cRd+VHY6cW5
FqY3RUG/SNcyRVT4K6C6iR6RS2S41VNXYMCkhMXLIxu7ERVkC/tz2juaeFdUr1Zp
bBg0EPgOCTpcZl2EyaSSblW1G3fqCw==
=IJHG
-----END PGP SIGNATURE-----

--mtdygncuvh4wucsf--

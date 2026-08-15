Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55BA231842;
	Sat, 15 Aug 2026 01:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786756160; cv=none; b=i+SIPuh9lCxYYyx8UmcpK0d9kYxj1d+nT4/1zmg3hNeybJHXTi6UBMbYjRXGcAUPWBs7QsCKuHNj8u28CvFpwsgKpEcroDDO6+vnkKz14D2JmjI0gz09+s2WHfNsw6mfFX2+bpWdBOkl6KEWCzt1r2alcf0faZf9GcrWyWGzHaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786756160; c=relaxed/simple;
	bh=mwud3WUXcpbIaZKpXp8DDk5obEMxS4m0fM1E+oeeUKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5eOQx+JoiGgV5+IQpqWFmHG99Iu4Nten8cmlswEiHQaYKrzpBoBc9YzuT3n/rNf3PbOmsJWKhVQ5a+WFyDtcmvClVDgn0MCyUIW74snhV9MVmAfOox9RLzCpan/c3SfWIqw651Ve90qP3DX5wuitSAPnyxdEG4JiEbmZV3rlpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aVoDirdZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aVoDirdZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=I7DFdDgltr4L3oxSCnQXABMpfl9lUr/pAe7DsWx8OAQ=; 
	b=aVoDirdZEM7JoXXoKN5ssZL3WlH5xPM2UXzvAVYKKEnOfKoTSjXkvRPou3cT7sk7gTvydrWGKW2
	IppzHyFP5V10siIEvvfBHhYWBpp9JvhZjqb/wvtWllzx6W/HBjOd92Q3t0fvzOUPhFA5Tk6MSTYia
	9Pb/6S9/ft8rwQWMfIbeHFD8YH+Wz5lXhjMYkPDzirx3jcvfBYC955KIYsqkdTF31P6BLfo8WnF3R
	Izssd8XzPc8g3gkmQ57W1GZvlPCt5uAmWy/BjfUgKD3oiDwt8RVSyaGRs6mvNdsVuO3mHc3hH7Law
	TuL4UIDU+zeA/et0iwznwRSg3vD5SNU7p86Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv2tZ-000000054mY-3Kcb;
	Sat, 15 Aug 2026 09:09:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:09:09 +1000
Date: Sat, 15 Aug 2026 11:09:09 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>,
	Sebin Francis <sebin.francis@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>
Subject: Re: [PATCH v5 0/3] Add support for hashing algorithms in TI DTHE V2
Message-ID: <an-8NYJ1vo03NpRX@gondor.apana.org.au>
References: <20260807110501.975130-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807110501.975130-1-t-pratham@ti.com>

On Fri, Aug 07, 2026 at 04:34:56PM +0530, T Pratham wrote:
> 
> T Pratham (3):
>   crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
>   crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver

As even sha1 is being phased out, there is no point int adding
another new implementation of md5 into the kernel.

Please drop the md5 code.

>   crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver

Sashiko has found some issues with this patch-set, please take
a look:

https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

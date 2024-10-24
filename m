Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377F1FAEE1;
	Thu, 24 Oct 2024 17:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729791007; cv=none; b=AjloPS4tQdAdCNlt2oSdp6lV9kjmyYRv9O26h4v76WyAk0qyVAwXD3hdson8RIsQOMQGN+JuztG6VBhWzz3dnvBs4GaxOWomgx5Hn1dfMXOKWYCX8E80jIqYOHKHrZv+BdyBZKnBbA/HPNGVFKJsmXmBOljKqfjUqwEjPives4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729791007; c=relaxed/simple;
	bh=re5Dw77Pt8aFDjWAU443Yh31qKbvdzp9KAc/vTtgA4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0zBVU3rKvqxdKt5KDw/I/jQEGGOiitr2J/+6vFQ5exXa7WPcq7L/Lel3Z/mp/CktOJmh/MfLE+TpQBrkdhi81oqI+maWiojhuX23pDpOzeomNZl6NcSHmtBCbFollTdJOwsfZr2FkMWLbCe8OM31cTna6qYP0e1nV0o77Jj/uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoVHbN5s; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoVHbN5s"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43155afca99so15640165e9.1;
        Thu, 24 Oct 2024 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729791004; x=1730395804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bjj1g6K84uBKnLvFb4c9FZjmngram/wrNlXEx3jnXwM=;
        b=LoVHbN5s1hpZzJAKEYCrNLbtCLOc/tupXp7OzPuSUTgxZSupytqpq4D8FFrtPs9p8x
         DEkHKNf8UPR56vP/mj0/sJpjQBQ+leXLyhrGmS/ABKcKYN0s24TGwyP80eNzxGG04pKZ
         1csDAXw4JfQ38QYN06Hiwv+wts79RJN1I1wfqndnzxnvt8DDTqCmP0GxdpNOlkc82sU8
         I8HYfz7l+Z7zDjMOKlu4O84NQtLKrFPpmb9Z5AqHrxfWhuD8LAq0GTGluA9sJv7Yfox4
         adimrvSd9yPiAJ4ieFzSDEzb3RAtZvKgml7rHawEHAhMyLbb7jU0wy834Qt29DLnzKHX
         re7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729791004; x=1730395804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bjj1g6K84uBKnLvFb4c9FZjmngram/wrNlXEx3jnXwM=;
        b=DnvfeV71ZSyomXK31qEVFu+cacmGcS1vRGMy16yqV2SfcvsGp5vd8bBZ9tl9P+5Gc6
         4W0Bh9R2TQtS/IPy689/hgH74WTLxZzArsjRpzIfkugglB4CpY8p3OT+iR54xX7Ufc52
         UB45O07hWIX5B9qM7dPTcaTMSNAudXRaICYezQhBUCAVkgFP36lfnwWglQPwDcYtuPjL
         /g3IMr6Q3DhciyCFUgSnJC0RCqmnMRo3hmg73cZsyybHadr6MSe79ywMCDlxzClz0Kpr
         PcFhqLSsNujiGoehUOTIMwGsegVsIF50Un3nwKNS1LTDIoG7ukEENUSE/9BGUQNR9f21
         QZFg==
X-Forwarded-Encrypted: i=1; AJvYcCUAqe0mu9361tXkQiGPbjm4FuLdAqPcXmYn+dCbFhmZzn5Fub0ylYxySLhCG0intrqyv/hNtwtaPp0syiU=@vger.kernel.org, AJvYcCWttzOrhwYiBhOFJjJOlcYIINO9v7o59Z1TrixRiuIDjJxXinb3374gzT83g8DLV+FsrNWgUNuWUPOLQyE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi4j2+V/Nl9AAWk/Pya4YWReCdQqx+rdyv4jc9nws9mEwhOKRq
	HBzBHWmdvqj2blrlUVuIyvvcrjahaKYVQtuQhcj9qXT33xv0ooFdf1RmVzrt
X-Google-Smtp-Source: AGHT+IF2ug9I6HryTJtoD9X1dRMFq2tIouyS1WdfJtQT9gk+fkkIb9oe+FiI/ko/3ypoAMx1GFgukg==
X-Received: by 2002:a05:6000:d0b:b0:37c:ccba:8c93 with SMTP id ffacd0b85a97d-3803abe4498mr1839585f8f.11.1729791003839;
        Thu, 24 Oct 2024 10:30:03 -0700 (PDT)
Received: from orome (p200300e41f26ec00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f26:ec00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b93dfesm11720625f8f.66.2024.10.24.10.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:30:03 -0700 (PDT)
Date: Thu, 24 Oct 2024 19:30:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, Akhil R <akhilrajeev@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: tegra - remove unneeded crypto_engine_stop()
 call
Message-ID: <ts5mfn5mu2e36pxob7oh5dvzttvevuqsrmuuba7x72g5qdnajc@ineylxagvxno>
References: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="i6yvtutue3vrnrgd"
Content-Disposition: inline
In-Reply-To: <20241020192532.4008-1-ovidiu.panait.oss@gmail.com>


--i6yvtutue3vrnrgd
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] crypto: tegra - remove unneeded crypto_engine_stop()
 call
MIME-Version: 1.0

On Sun, Oct 20, 2024 at 10:25:31PM +0300, Ovidiu Panait wrote:
> The explicit crypto_engine_stop() call is not needed, as it is already
> called internally by crypto_engine_exit().
>=20
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: linux-tegra@vger.kernel.org
>=20
>  drivers/crypto/tegra/tegra-se-main.c | 2 --
>  1 file changed, 2 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--i6yvtutue3vrnrgd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmcahBkACgkQ3SOs138+
s6FB8BAApFabzCSec7g2CfORyGKsvyUHHmBNyfqDpM/HXprZkh0oDUdbUC0PII1h
wJY14fuBIYTH1fpjh/ykvkXtq1JMHZAd5Lu+V6jNgD+yjqafdmCxfXCFQmLsdgTF
Vmu3gx+OaNyB8nUY5O1W5/ytzaItEUI0l1G0ZFl71w4GAaH+3L+wq1keJ+gxBnba
ZNcEkTVYpn8RgRVlScRvRSyuNm3zm3FB8PpGTgXW5T0KCdfhy11aYKvd5Av53UNb
k/avIhg9VPxFXes37+hQZiGCb7UGgY+PtQFs298iYVeyIXq2RDpBWBDlaRHRBhm8
KrbQLZoYHrqBZ4/TClssHYGoGKWrsVgXey2h41GDLHxBxn5hI5sTgCYQx8GKZJT3
bRma3vWFis26M507iAJarte15BwQ+1xZ1bvz9liRVQOIQN2sYmtOVCR1PyAAiTaa
UKdVF9CPRQ5oja5cYqvudGTVUnGF722cxwpdg+sfmQapF2eweZbg9KiEyNducrQX
xpNLsh34PV03DuGsMCkTbtqQdvxIW2W1znXrNzOQI/HlSNEBaLUC6Rkeeg+/IQP9
2UjDNcrIGG2miu5c1wJdwJyKU92CW26P6E79ZxNjZFjYbLo4LDQDzLDrcc1UDXLf
oVTKLFmIc8KbZ43DN+KbLbJyxbTIFVv7huY5neeMhMQaixWKaqY=
=0DIc
-----END PGP SIGNATURE-----

--i6yvtutue3vrnrgd--

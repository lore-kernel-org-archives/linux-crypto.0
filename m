Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D468221540;
	Thu,  8 May 2025 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708829; cv=none; b=NIV+r7ZPp0OOZRDBLF2ucSQPPD622RdWbdcalaDiKdtm/rdVwn3LZ4LsfTjj0fmLIM0XphZNdvqgTLiuIqxmf7EBpB2r0J3r4kpAVJkWa4kN71Q/cT/YQ5/Gbc9CdCk0bzs+oM38QCVga9AGmtmBl3DufTb38WmYxabkXMNj0Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708829; c=relaxed/simple;
	bh=rKvDdcEyFMuVbDxsaVe56Ux5vURLprceReNvMRSRIM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfvNVVNH3lMknlwHFDOyYYhGlVhMOT1Km/RO2GncuVrMKs5ziXKNoJ8PJnGhRm7J8DSaVk0ulD5b4vrXi3E3RJ2bvR+0Akkde78OxRxpW9JnesMj9Qf5pjRkQ/VeLF8KNeKVjTrVcewOsPhnyad+DAQ7jSZ+9Jddmo1AfHOBEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G//ayWXC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G//ayWXC"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfe63c592so9090475e9.2;
        Thu, 08 May 2025 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746708826; x=1747313626; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1l3iS/TKmQrqa4v6zV9bm1xcGBuMMVrt22SRtsapFPU=;
        b=G//ayWXCcTyO1cxNMJVGnQ2Z9DrYOUbuyYdOIz9IYrBKVJEW3uJ+b8z2jXgjFczSdI
         9o7UIqa2VNHDZ5x6hqCAZlou9lVB4lFoY6B9f9r+lllL3gNQG8Tt/ZtCE8pI3bLy+n6T
         LmMO/gvUUYvWj4/8vwCNd9naGq1TQlcG3z/iQbBLke4vMM2HKRc9bDXkqCO0l3Xbtl7n
         kEfNqxBHngJ8aRu7yAjD7WhVDgBQSZdUPhvBxm1x5OdBSiME9Im3kMydRpfV8AwLr873
         3hjmL5YxY62M4ZF5qa+jyq5vJTXDIQ96CnZHpOlRVf6YapnZ3izTbNT8YDilLwazVJMh
         1JtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708826; x=1747313626;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1l3iS/TKmQrqa4v6zV9bm1xcGBuMMVrt22SRtsapFPU=;
        b=TqRPrnSnCYzMdkbYwBdbTuApCrf8stHMR5Rww0M20txQP3yEqBhTYOn9UgDyucGVER
         2v6jNcwR1sWGK0/VfjHnhMcSSWRsSVic38CL8x9g3iOJ84QzZKRVfGIuXM7ECWdcN1MC
         amEvdEXMYti8MeRp0TfzHPP8yq0tIe8LRyOYmdC/peRqh6qxyjR70rtIgCOwiYTAQusw
         wE724pAKK2IVudJc7EZ2doY0KfvK1sg95lXr3foxUNwJFmyRyapAv6KlpMXA+DgfLYay
         8CanX6+4O3HBWLA4o+fJwjwRnW0WULE2pEBJZ1vnyjHMZVQvQp74nmP53yHt4u70OvO5
         z62g==
X-Forwarded-Encrypted: i=1; AJvYcCU8iXatKXnGaOJfTGbNMkKEd7g2TZhA8HxnqCwx+ZLhOPTfLozueQIOA0cOJjwd/4u+oT2eUPO0xwM1DT8U@vger.kernel.org, AJvYcCWKWNH+ltqwZoEfjMd+txg6lRQgR3DzKa3Ev1xlLSeWLOLjLxaGUf53qZR8zAuLh/xZ5qhEreBBP6d0vqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyXPcxnWaMLPhkQHL7B2pSS6GPFT4Jp7oEHov/l7/c4FOEhVO4
	fhuI68WqGjlqgUnBB1kbx0irowWG1Ly55Xf5XOzX6f8sNF5m0piQL+GiSg==
X-Gm-Gg: ASbGnctPRMRTizeoclNqD7+1k6Hxi4X1JfK91bU+w527qNrdxd5oW8ly4rkkpKLNQ0U
	qT37n6ftZjLP6YgjjEOMfRgta+bsue9W7VypFgW26nTbi5i0GtUh5xxU2N02g1hMNbGA3SgWO39
	+TK+E5c36mv60v5gb/ktNTgnx8JbatfkENw/Jp+rHTMV/zB0kxWlHdsHrqNU88IJmUYyOg+0UC3
	u0yvRx0KrXxZEI8qTjsgbhrZjezTS0kvIj4hPq3tHy+Yp8PzfTM9kNhXkUHItgO8JkxNYl7U0ie
	sBTf+NHx2jVmIF+A6vo2eMOB3LQTbnBOOxXvWJvfm3sRUHLR5xnM
X-Google-Smtp-Source: AGHT+IG5cba62jUROOvRO+O5AK/nVNwnJkll+1lZntviPX9TwJtwpBBNe1ExNq1zIB+0bFYPdgQflA==
X-Received: by 2002:a05:600c:1394:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-442d034bcffmr37384505e9.30.1746708826061;
        Thu, 08 May 2025 05:53:46 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a099b0ffb1sm20154250f8f.73.2025.05.08.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 May 2025 05:53:45 -0700 (PDT)
Date: Thu, 8 May 2025 14:53:43 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [v3 PATCH] crypto: marvell/cesa - Do not chain submitted requests
Message-ID: <aBypVwhHHzmqqN5K@Red>
References: <ZwePSPG8aWm6mwKK@gondor.apana.org.au>
 <15fadc356b73a1e8e24183f284b5c0a44a53e679.camel@gmail.com>
 <Zw31JIEyh28vK9q7@gondor.apana.org.au>
 <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aBw_iC_4okpiKglQ@gondor.apana.org.au>

Le Thu, May 08, 2025 at 01:22:16PM +0800, Herbert Xu a écrit :
> v3 simplifies it a little bit:
>  
> ---8<---
> This driver tries to chain requests together before submitting them
> to hardware in order to reduce completion interrupts.
> 
> However, it even extends chains that have already been submitted
> to hardware.  This is dangerous because there is no way of knowing
> whether the hardware has already read the DMA memory in question
> or not.
> 
> Fix this by splitting the chain list into two.  One for submitted
> requests and one for requests that have not yet been submitted.
> Only extend the latter.
> 

The board do not panic anymore, but have still selftest errors:
See the full boot log at kernel.montjoie.ovh/477935.log

Regards

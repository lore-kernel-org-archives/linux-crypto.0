Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B41DF6B
	for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2024 03:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714446294; cv=none; b=Sj3Clk/Zm/CKJmU+OZnq2mvDGH19SdBCt22sAoJ5Ohl9LvYmLSFYX0q7REhoov880qklnaT8a9o4OWNtSBXWq8cVNhS2M8d4AjQ+UrmKH9iLyPeWWPhWIA0PHC9wzhmEBFTfIwrcYwI7QkYrNmlRdXd0GmIPZACqubNVNN2MZak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714446294; c=relaxed/simple;
	bh=S3dcFG9nl2arKz/OB2xphR0OKK1uAoMU8ChtHy95lPU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=addD7Oh3M/FriyAxgFyjqt38CYpVfZJ7UrD32W+Np0N0dXJEjhmScIG/5iXHXAcI1QNKLuWTuuL2K/Z+/eLmnTa8//cbM0jdNMR05UlFck2bV2v72t10Plg5UuoJJCEI3Ouc7yZsUk1Mm9UEvAeFh5oKfDBj2hlHTrXpQoEBAuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mkGoDDhD; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mkGoDDhD"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c74fd6fb92so3551625b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Apr 2024 20:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714446292; x=1715051092; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8GmvV6P1saiYDGx6aEXWiDKEEjYyVwYItU/oo2t7qo8=;
        b=mkGoDDhDbcMXpOtD/awIvRX4i+T7K/WTxQ0BZp0TQ+JNGgYl+1gbIM/hrM4st3dhQ8
         SkFJRwxtRDWd2A4VTjLpBk8p7fGivV0yd9DbKMyHgDeD3zQ1JwDx4wA4a88thHVT1u+O
         AQ1G33mQsFMpbMyzADAjCqmtZSscC4wNcEw94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714446292; x=1715051092;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8GmvV6P1saiYDGx6aEXWiDKEEjYyVwYItU/oo2t7qo8=;
        b=xNmsjSKFKR6gON2fUBhB7DDYln8xKY/ftH+B6fVud8wvYi+2uFfuqb0+OieAI0uLxt
         PfgBaCl8gs4RfR9RwHytSPr7KpY0E8B+1ZJIdkW22l97hbZw41i/27CIPVRF5Myhl6Lq
         Ix5RCtefRnL5GROA74itR+fnHP9YPiuPR1MHRI24w11wP2+LJKYECzpd+80VNLKAW0kV
         VRu6is3Obiuey6MnsLbDiuAXSc7F0nKb0awwULkNnSaRl61/5OipqrRIC9pkImWhbxsW
         wWMFgi2FMiHIlG1JM5bA9vXfvMGGjFDUvNniycCRdzZcspEBqrn1k7Nfv2hP1DojN99P
         0RzQ==
X-Gm-Message-State: AOJu0YzNIIFKyZGF5EdXdXMDz0h04qHI/sekq42DoDpw2Jx0b7b8mtUy
	POTP4z/R1SRQ4l0iit2bs8LKawPGEoDDSVly83fj58kyZHYEYLrEuZkBqiYffg==
X-Google-Smtp-Source: AGHT+IHoOv2bed294ADi560bgBmZKT/Ayee8+LWb6/uFb3ODkPyPBkr3pKvDObUtk22A6sGzJHMfUA==
X-Received: by 2002:a05:6808:4c8:b0:3c7:3af6:1cb5 with SMTP id a8-20020a05680804c800b003c73af61cb5mr13307260oie.46.1714446292049;
        Mon, 29 Apr 2024 20:04:52 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:e55f:86cd:c9e1:6daf])
        by smtp.gmail.com with ESMTPSA id g7-20020a632007000000b005e83b64021fsm19850926pgg.25.2024.04.29.20.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 20:04:51 -0700 (PDT)
Date: Tue, 30 Apr 2024 12:04:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] crypto: passing configuration parameters to comp algos
Message-ID: <20240430030447.GE14947@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

	We'd like to be able to pass algorithm-specific parameters to
comp backends. As of this moment, crypto usees hard-coded default
values and does not permit any run-time algorithm configuration,
which in some cases simply disables the most interesting functionality.
E.g. zstd can be configured to use a pre-trained (in the user-space)
compression dictionary, which significantly changes algorithms
characteristics. Another, obvious and trivial example, is algorithms
compression level.

The problem is that we need to pass params to cra_init() function,
because for some algorithms that's the only place where configuration
can take place (e.g. zstd). Changing cra_init() to accept additional
`struct crypto_comp_params` looks to be a little intrusive so before
I write any patches I'd like to hear your thoughts.

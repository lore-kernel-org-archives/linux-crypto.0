Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F59EEC3;
	Tue,  8 Jul 2025 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751983504; cv=none; b=qYZ8eFAOi9aqfT8SGtGckULZ90OSFoEUP3VAgmGEDZCQgfTFYYQae3vb2KnZwknUl6WKNsx1kdAWUn+OY+ztBBLCpiNJvRrh7qDEfdx7GmYFDiJPXRxaZXozmgCllYwlJ2V8P8vCFU85GcRUIszomBwQfFOv14HiS+nIZYe/T2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751983504; c=relaxed/simple;
	bh=NBLxj2iyNEYe0RkPUYz8ceMh1dxW6+f8giBxYHZCfFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9xsDgAy+tREL3r1z5H1lp84H2NRSbm6B4y8Ssf1+O8ib2jjLbk2aACNzsZ/m3QjDnUvLeqTDz9uojMFbxkzIwYrbeGUFk0595NVyriAKRZFB6yrEVIRPYY/M/ilV9/czNWsz1BUsMHpOr8bpbn6CX2gV6l70o+r0VgVJ4y962M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2My+ida; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2My+ida"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-451d7b50815so36468805e9.2;
        Tue, 08 Jul 2025 07:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751983501; x=1752588301; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HtyOMEbmKhYccPR85zPZqi+3OXt4HRCWKlkTUzeAlK8=;
        b=f2My+idaTjM/CDFsPql3HawrRcALjXKfz0PGFNduhdqqjhkRGSSxbnhP4wVZWS2uDN
         Rb7m2ab+oyXi2JHgWOp/Q3GGjZnAT1Cz0MDWEK3SrS5iTg8BOI4ZPuCacPinhTEjaWFF
         SdYdlUzbmcWasVAIzrY4EzP0vvI/rBJ5+XzQonD59wjNlITpSUcupZ59JvPnrex46h/c
         riR5MG1i4EmdciK4pPisMEvrKODJ/nAYkmQejdcRslIJNVdnwX5RalZ1oC1JMnW9b7kn
         rtPBmYFdbwRVMPt2KfO+DEU9QV0xSLuv4KV4imEoU/ntsU6Dv2PBClptanA0GvK44/Be
         8onA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751983501; x=1752588301;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtyOMEbmKhYccPR85zPZqi+3OXt4HRCWKlkTUzeAlK8=;
        b=xVKw13Ntn55hJwRIDX1outkXosxoD3DS1UBXG0yFA3ZlRvIpKTYupQODaJyKn9YUwL
         R3I88ilrJLQ+ii0e/CxVCB5w7E1dJLAcFFgHmanyr5xQWkzbAEDH8v77wv+TrE25T38E
         6KO48e1OaTUAs/KkZL00d3M0C6cd53m4Khb+62ovZdmQtd/4qVSXV7/Lg/5vBaEvY8DZ
         TeMlgOKS2F1lniRtqVe+nntWkH8w3Thf3T9Zx79iZ2EKjhr6Ppt8rmW++02Zc1QCNJdk
         tZZ+VEkfk8GIumvQeNXsoSDC6Dz1zA7tN+F6zsPB2ym29IEOBr48iMXM8c+BzxBCKrd6
         hYBw==
X-Forwarded-Encrypted: i=1; AJvYcCUAnqGQ3feV3l6OnENI1+ZHN3gKfJT1K6AgUbZubH30qDmS4qi+u4RSWbCW/lhamVCwYi/J/dA1FrVP0HU=@vger.kernel.org, AJvYcCXiPQKCeia0Gt6vhJOrGiETlevErbTvNQFeYIL98BYRE4YbIdtw3G/E1BYz8gxCgdbRrstEZgT2Af1sYbtO@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/N0flYamPdU7MlkwGaf4ZaOaqN26DKAqwYGmJzSdED/NOoKir
	nWeX4tch2V6yUZsA5HwOCmNpDBGxaeSWLWSRsxbZp2/2JpNCPppmivek
X-Gm-Gg: ASbGncvQinADnjpYLnNlHRflCyZzysjTSBHAseFwmEDsxtSbqTASTRsv7C4ta/o3H+8
	hDKWG0WORsgjd8PC1Kb191EvguUWOF1krPFAUIBnLcpgFvSLhat9TjmL+5EV3DTkwFAhy9xZxgY
	c8euLpTHSLaiJmo5Dh/N3BIhlEADnU7V2v4SXazgnNupPgzvh269MkdTHkLHf8ai1Sx98Mq6VTg
	lY21WW8Qm3OSgZUBXDfD2fU9z0W1wz7QGE0ZbPfVjX0SFJZV1BovdUYhabBTgsEEeDw3rpbAaM7
	SFA4OTRuP0yTlakFGhV3ubWRQPMl/5bckwSfjTKFS50ebslgZHHkmkdOvKg5Jg==
X-Google-Smtp-Source: AGHT+IH2IcGnzTu4f5ARGuOr251NCQFPNC43aWQKhhYdtFHA2gXGRsOu9touosxAKfObj0pUusrlfQ==
X-Received: by 2002:a05:600c:8219:b0:441:b3eb:570a with SMTP id 5b1f17b1804b1-454b3107ef7mr149559065e9.2.1751983500451;
        Tue, 08 Jul 2025 07:05:00 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-454cd38f03fsm23612485e9.5.2025.07.08.07.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 07:04:59 -0700 (PDT)
Date: Tue, 8 Jul 2025 16:04:57 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, wens@csie.org,
	jernej.skrabec@gmail.com, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] crypto: sun8i-ce - remove boilerplate in
 sun8i_ce_hash_digest()
Message-ID: <aG0liS6ZSr9HF_EB@Red>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
 <20250626095813.83963-3-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250626095813.83963-3-ovidiu.panait.oss@gmail.com>

Le Thu, Jun 26, 2025 at 12:58:05PM +0300, Ovidiu Panait a écrit :
> Retrieve the dev pointer from tfm context to eliminate some boilerplate
> code in sun8i_ce_hash_digest().
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 

Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Reviewed-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
Regards

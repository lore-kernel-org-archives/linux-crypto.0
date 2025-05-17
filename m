Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A31E1C36;
	Sat, 17 May 2025 11:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747481091; cv=none; b=NrRcDg0cieGrxgeUyN0mxmerVsJrJfErFHa8hsZTY77MEe0Tjwzso9I2aPVa/YduX3J6+Pi9Jj3Ho+Y92jdklWxEfaK91gxRtBGtlv9EfZm1K2nbti0dhb9xLI+Ppifctmu+/s0nqB1zdc5jQU243m4oE/y2Os9JLguGrQ6AooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747481091; c=relaxed/simple;
	bh=ITQ8WoBgcuYy2CoCnaWW8b2dqVeJ6CVqmMWg/wOdEMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8SaA5voMs2epiWPyXBTrIkb0yCMU/meR+D3w+8iKe0p1LSEB4jYqnso/M3yQRUU/hnDSADjZWSve5GoB+yLDYTYIA3f/AJWmx36WyyRzd/IRmY1hewfhGB9xbSivlYy5q1ugIgOAq8kwy418XO6YVP5Q+ZDZjUCPxYM7/N1XrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PmxBAVxg; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PmxBAVxg"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a365a68057so510378f8f.0;
        Sat, 17 May 2025 04:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747481088; x=1748085888; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MSwDpQT84zdgO6wXxHFEBW2XxJars8UnwfBLwxECHy4=;
        b=PmxBAVxgXTpI7KtnvuVV0NbaxhymuZ+xLoSwhq8fOejcmwvamfAapA65uMBTLYb8aw
         D9VXBWjI7W8oOa8a6t6TPhNsReHJT9s1PQflc36m6gKrz3gx8OYYiHhcUD4i+TO8uGVK
         1WiDIjBhMh9kpgvbMaEWYoPjVVt71t4EqTkh84lwBpD6FsJrwgF5yFKdaBLlWGSTmFO7
         J9f+cgiZflmMdQHW+wI6OTMA1RczGc+YzdUlz863ZNQknJ8b5a85oCAXj/SX3Gado7PE
         N56J2zkVkGYVMYc+N4R9A2ezElBHQPm5JlHq+k+b8x/Im1+91h72OPklL/NXLIkQw0pT
         wyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747481088; x=1748085888;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSwDpQT84zdgO6wXxHFEBW2XxJars8UnwfBLwxECHy4=;
        b=JJwoU/eHskXKub6qNe1Qs7ybV43YHdcRBpv6M9UwzEUAm4gBsbhGuZNVJvv88sJGIL
         K/ITJJBGrYGvUfLAdhl6L21YfQTAuPEC+CfOlthrtKUVTd7mXLJE2djh6RUa5LElhwk9
         8T0IxD7f9dpQlfqeBF9npI3UAACJNOXk3NRRkQpjb4l4CvnZd/GNvEyt/H2aFu1mUhuZ
         S7y5SFASPozoVgmi2frcsTUvGqN7Mi2ixnafoDr++4WqAXNjQkHCZCpNQLbv1b+Oq37y
         ARnrAju7E4uygfv4y0vA/g4VVkTbSshmB2ClOVgeqYmpduFx+ozRQod2j1YzEXwHWt/T
         XsqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKBza0mlh9ITfCol7OenUZKNTyNbU+uEgzk8Ry9kIBAPJukcXsFJ7/rf8o9EbqhuauF5I2Gs/gYX9yZD4=@vger.kernel.org, AJvYcCUWyflonRRHUuEfeq8ROFRc1zhA7OU9nehbSrbEERrZq4Ve0AAbMUrELxGAhXMskPdVxLqKzjIo8JlydSee@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ArjgLtOWVdz/P1+Ja/i9yP5ZraiW/MCHfCVOKhvpLExs98z1
	jIY91uDWirGB9yaAWNFTZMdljOdZ+4IaPed/u8QYRBsR3x1a6Fz9DeY7
X-Gm-Gg: ASbGnctbJjbLy1/bs98srHirxxWWxy9iIWXIv82CnbI6RFbT1ho2J1m/HynB9PepFb6
	lu538yf3pP5STJQGnI/hMAsLTg69oCgblyaE7rCvIXJgutdMJmgxN+lKh84edrOhaDq/fgr8XwK
	1J0bHF7iGOmDAwQZliM17g4hcriA4D2il03NAgc70yBPO0O9WGIheb702azB45b/YYpFKt8hL7B
	CdLoHbsefpirSrGakh/K/wYX5Glx+jggvkHtf9P8xl4bdeyFjG+FTtAWJzF4UwDFSIF+RtQ63kR
	xFN2MXEuWnP0+9fVk+H1lAxLWMrllsY7kIqHawkc/i6dXRXWNCQVwsZAoJaAdt2l7N4AMzHzOLB
	WucdAv/AcexQYxkRIG/UIxG26KMQ=
X-Google-Smtp-Source: AGHT+IELLGTB3mvKaXwEU3iKQvyyKkC/EtqZga1x5Ws2/utzAKD+OKcH1q2bdpPcVf7VWr+9eHW4uA==
X-Received: by 2002:a5d:6e4d:0:b0:3a3:5f36:33ee with SMTP id ffacd0b85a97d-3a35f3634demr3881503f8f.32.1747481088193;
        Sat, 17 May 2025 04:24:48 -0700 (PDT)
Received: from Red (lfbn-nic-1-341-50.w90-116.abo.wanadoo.fr. [90.116.174.50])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-442f39ef8f7sm136118285e9.39.2025.05.17.04.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:24:47 -0700 (PDT)
Date: Sat, 17 May 2025 13:24:44 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aChx_ODF_hYKL8XO@Red>
References: <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCczV6MF6xk5rRA3@gondor.apana.org.au>

Le Fri, May 16, 2025 at 08:45:11PM +0800, Herbert Xu a écrit :
> On Fri, May 16, 2025 at 02:41:02PM +0200, Corentin Labbe wrote:
> >
> > Yes I have still errors:
> 
> Great! Please apply my debugging patch and see if it shines any
> light on the problem.
> 

Hello

Your patch didnt apply cleanly on cryptodev/master in tdma.c
I have fixed at hand and the result is:
http://kernel.montjoie.ovh/478852.log

Regards

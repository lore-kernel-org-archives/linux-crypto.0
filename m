Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8983FCB3D
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 09:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725078; cv=none; b=UhZrQpHr6M6bbUwzBTSRXX0jKwqwEPj8sTXesRqp9OfoZGnpWauTvcImFqMnCuZkL2fZ2EAFo2Va4sRcszJCmrAWkw1wo5Th0Mlbp3/RnJW52apmpn+DWBK4NV5JXEZYnBmraf5eA0KPU+CILqUtnXUHs3LNdinkjX6dANaSb7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725078; c=relaxed/simple;
	bh=K5w+oPWyuH0dY8GvE65gmUksEt/FYv6HqO1wp+2NpMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1Xgj9NEQw9cwFAs4m133zfnt9rR/TXOhQ1KcqX+iE/T8eSUacS8kEdp8fueSwV7B4isDo3nkS12raius6U785X8uT/VGCaypzXYF0jv42gX+w2Llu/dxf2ZwpeHIw/GD5Y/egRes6UAvX32KCx19jPWbLta6gDDfU+vgKQvzbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FAt0CX2N; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FAt0CX2N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UFxBGEloCLnsSvKmVSGuuzLYC+3Zhai/HXwvd4qBW/4=; 
	b=FAt0CX2Nw7MXW7tGZAtjHlsYEQe5iCGRLP7WJ4EyYSVji11Vxuc05VnVO0OElzXr4fcf2a4okM4
	JQP/IQovYhldFDOz3nVDY3D3Zs3nA7lPQSrOBMbOEeh01QmybR8MBhqLYnlO4JpUI9lT1Rm72T2Io
	Sf/lsG8m/j31zU1yxx9m5ZyK75cnRPAveljNsGlKzv7dSVWx2fqoTKTGvvP3KOzzgc+2XMc+dvQNw
	9KiF5/WU6do+gIWJyiixj2orMgZRc3VeIXfOxEMRk6LDqa6N7bJqKlK4Ne5yvpgV3vhHqSfnTyOH5
	jPzl/MaokmF9YFMQtUbdpfM/RQScvAv9MIng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VFQ-0000000FLxd-0kWi;
	Fri, 18 Sep 2026 17:51:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:51:12 +1000
Date: Fri, 18 Sep 2026 19:51:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?utf-8?B?2K3Zhtin2YYg2KfZhNmF2LfZitix2Yo=?= <ha2020anan@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: jitterentropy - add fast hardware jitter mixer
 extension
Message-ID: <aq0JkKUIkWApYWb_@gondor.apana.org.au>
References: <CANai08PJ9bKRn3JkgUP7SFHn+qXLoE_JDerRv-UtMkELZXu-wg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANai08PJ9bKRn3JkgUP7SFHn+qXLoE_JDerRv-UtMkELZXu-wg@mail.gmail.com>

On Sun, Sep 13, 2026 at 06:16:34PM +0300, حنان المطيري wrote:
> This patch introduces a fast custom hardware jitter mixer extension for the
> jitterentropy subsystem. It utilizes high-precision cycle counters combined
> with memory pointer attributes to disturb the branch prediction unit
> and hardware
> prefetcher dynamically. This creates pure architectural micro-entropy
> by exploiting
> execution timing variations (CPU jitter) without relying on
> floating-point operations,
> ensuring compatibility within the kernel space.
> 
> Tested on x86 architectures using standard high-precision macros.
> 
> Signed-off-by: Tamim N. Almutairi <tamimdevlopment@hotmail.com>

This patch doesn't apply:

https://sashiko.dev/#/patchset/CANai08PJ9bKRn3JkgUP7SFHn%2BqXLoE_JDerRv-UtMkELZXu-wg%40mail.gmail.com

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

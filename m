Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360433FE36
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777210394; cv=none; b=UG6zxJmzOaHvchocJzNpExhUOaL15ZkmLA/KOhmxXYGJLLu950xgwvYd88LA5S+5evloBJR08LbVAT/oORen8vAvndLjePSXxnl5+5PnRv5T6ddCgPlkGlLtJhQtNwFMsYgGigLPNMVxxLb4+dUeYlQi8ItLta40+pemEzUvLC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777210394; c=relaxed/simple;
	bh=G884qd97PNIxFyanL5+UkLxO8fmPu7J/+fwd9gPZOR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsu+zjbT8Rb6FkIcnsi6uPoy4CefSnifnf53GjPJDYV2kAo71rYbGcPRhOS0OYjmg/nfl9bld6lzAeiII227GVQmWGmIr+d4a7fJGrPvNtXIMEdIYPnGK9V6ljgAASFos7Jf1kRYh54VdBdjD56ImPtHh0Qm5fMjhuxiYnrf87c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WsE19gSk; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WsE19gSk"
Date: Sun, 26 Apr 2026 15:33:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777210390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G884qd97PNIxFyanL5+UkLxO8fmPu7J/+fwd9gPZOR8=;
	b=WsE19gSk0wj+TVv11MRCqO70eJqdJIYZTDkuTcxHRdA1Z/2eX9AE+eMmp+QRigvfhinfBC
	8wa4yJzFa4j8lkMkswAbKZhLYamRAujoAcaph+IooMc6H+EZAyzBYTyQXg8e+4ZJ3VCVpM
	o/0DCI0D9/H4wP0HsplB+6MoArqXyt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] crypto: atmel-sha204a - fix memory leak at
 non-blocking RNG work_data
Message-ID: <ae4UD-JGUarmSMiK@linux.dev>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-2-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422210936.20095-2-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 22, 2026 at 09:09:34PM +0000, Lothar Rubusch wrote:
> The driver allocated memory for work_data in the non-blocking read
> path but never free'd it again.

Yes, 'work_data' is allocated once on the first nonblocking RNG request
and reused for subsequent requests, but the memory is eventually freed
on device removal in atmel_sha204a_remove().

The memory might be retained unnecessarily after use when the device is
idle (probably negligible), but it's not a memory leak.

Best,
Thorsten

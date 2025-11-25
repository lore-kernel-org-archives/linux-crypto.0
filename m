Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F4D2741AC;
	Tue, 25 Nov 2025 04:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764044466; cv=none; b=VOvmHeca9cZXjYl9CxYkZpo9St/yjxmdXi30nipN7ES2ZUl53b4d5/aYh4FY2cjsoNd+T2RhdSauUFLMgQ+8RW351db1cz4+1O9WQS/92WxCEhYE4JwWaoPYGAhD/I5nA2Gb9P+fkyomawhM1/USnendapS6B66gQc5/W9ANtT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764044466; c=relaxed/simple;
	bh=ce/lSRwIWXceeZyfPenIbqn34OQ0MJZm01CBiLmkpV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MbHlIog0J2XkG8EkXRzbigPDVIztwFUIJgmrWvfAiEmoc98oX5C/avg1HxxHPxGPql8wNhajXLw0XFYsqyRpDWa66Waji1mb8oVBG0JnQeumYl22bMOwEOSb9ynnISD7ou3re+fxc86aOOWTBSO+ML7cI09QsHKiywPOuEqCFLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Xluk0Iyk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Xluk0Iyk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GH3ppYV3iSuFNXRuBiLohj/P1RNXkLh0EExzM20knz4=; 
	b=Xluk0IykmrjC/SMSyPOdyVd3xuMyLjqHHqoKQFs2GQ++kN0nocXHdmpe/d7MCZXviUsf33mYo8d
	oy3cVcktlW2CDwCcEY+8lgUzYXhRezK5iK+1WrZZq5rRBPjAI6KN2nPp55FTtLdzjmfL5f9Ap0Zyq
	Na91h6GalgsF7CxegqDk4ii0ESHdfvC8bGJP7CIm0DUV0BNK7kIArvAulId0qDcu09eHMoUStfPoK
	CcbV0iSPyP3hZSKrcpVN/MsTTycW/hJ/LkuQsxXP8W59XnWs8xGx/mi5IjrnROvkyg1wFFbi5cV3v
	FiJ4eVJlQHFe3IrhTXjmQ+J1dptEnAIVf4UA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vNkXu-005ka1-0W;
	Tue, 25 Nov 2025 12:20:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Nov 2025 12:20:54 +0800
Date: Tue, 25 Nov 2025 12:20:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Subject: Re: [PATCH v8 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aSUuplXyzpFBQGuL@gondor.apana.org.au>
References: <20251031044803.400524-1-pavitrakumarm@vayavyalabs.com>
 <20251031044803.400524-3-pavitrakumarm@vayavyalabs.com>
 <aQw-ugxNqclAqDkg@gondor.apana.org.au>
 <CALxtO0=LxXg6Cw+PKnPQLhurkPRxvTOn63pyK9gFFH=y+F=hBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0=LxXg6Cw+PKnPQLhurkPRxvTOn63pyK9gFFH=y+F=hBQ@mail.gmail.com>

On Fri, Nov 21, 2025 at 01:30:57PM +0530, Pavitrakumar Managutte wrote:
>
> Whether there were any additional changes in the ahash API or fallback
> handling between 6.17-rc1 and 6.18-rc1 that drivers should adapt to.

What failures did you see with 6.18?

Please try the latest cryptodev tree which fixed two problems with
ahash import and export.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6702580D5;
	Mon, 10 Feb 2025 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739205168; cv=none; b=Dm0n/9/yEqgcLRXZnwGB/mW0VS6u8TnlXtL+fz86bTZtJSX24CRknfiGtvgipOmwy5aMo5AhyaoGUKJ4JjWt1x7M/3NNO8/CcxlaZAs4q4nNYNvHPnCk0/qmG5PW3vlBPv9S6qF7csqGWtrdhOvIEuBQA2OM1lY1V+Ocozp5dpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739205168; c=relaxed/simple;
	bh=R1G23Mx8i1twwIigIePIEmfwkGFvwlDiNAkiyuJkmLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeiQe4V9E/NjoeB/XEAg2ZbxeJ6Wz6LYs5LJMmJkRY8nB4ASou8RBfI1Szk6TsbcIGER1tuaKflzUGhLKHT1WRLK0RRdj3S1YEu/n4qxCSv05GAw311zIdDRj2fF6P0KHCcqaDi9v16XofPv8Jlgghs43DC7X05Z+dKABeh9oBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/EqEeNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/EqEeNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A2EC4CED1;
	Mon, 10 Feb 2025 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739205168;
	bh=R1G23Mx8i1twwIigIePIEmfwkGFvwlDiNAkiyuJkmLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q/EqEeNNlYDBNgUtrreA4N7eFtEViO4s5JyujVS6Vsa/HhVWyb0p5snoSolIej2IQ
	 cWny55B+81HFGLghyGl78fQkb7beTqr6jpT7O4Y2AykaKamjp4Qw2HYaWQwSGtvVul
	 LdilVhlcUzTzBI6TL/Utf2as/F3VyTRk472nyn1jLlH6RvfUDmN75yFgn4UGUQP4aj
	 lHD2Q2Bh98I5i2wdS+jU71cj5mpTrlPsDtUohl0tdBP+obQHeXCJ1TCrcdfuWivHkl
	 d+F0oyPJ7BmBfeeLRsoX9Syp5pvDg0wOKHVaTou40eBdho1z2allcGsbxPIqcpWxKe
	 WEEAz1zMnfPBA==
Date: Mon, 10 Feb 2025 08:32:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250210163246.GD1264@sol.localdomain>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
 <Z6mxZ8lfO6zzD7x0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6mxZ8lfO6zzD7x0@gondor.apana.org.au>

On Mon, Feb 10, 2025 at 03:57:27PM +0800, Herbert Xu wrote:
> On Sun, Feb 09, 2025 at 08:34:30AM -0800, Eric Biggers wrote:
> >
> > Or just make it synchronous which would be way easier, and the calling code uses
> > it synchronously anyway.
> 
> Note that synchronous in general does not make the problem go away.
> The important thing here is to give congestion feedback in the form
> of EBUSY which tells the user to stop generating more data until a
> callback is made.
> 
> While synchronous can be a form of congestion control by requiring
> an extra thread for each waiting request, it doesn't really give
> that feedback to the upper level.
> 

Which is of course entirely theoretical, given that the proposed user waits
synchronously for each request to complete anyway.  And hardly anyone wants to
do otherwise since it is way too much of a pain.

- Eric

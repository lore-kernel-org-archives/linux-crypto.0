Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C6229633;
	Tue, 14 Jan 2025 13:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736860921; cv=none; b=AO7vnkvLdUJdLKVkkgI8kOMtgMq159Qp+5dP1sw4CfsotZ9hRk5w9u0NEwNeq9+kCXHWZEsd/yhAewiv6g9gDsqIF2X6ndqM8QyGxHKk3rincsKB5f2ehZl++4QCu9PLCyB7Il1gJnViKyF6VPtmjXj/YgRppxtQtfZxPbwktOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736860921; c=relaxed/simple;
	bh=WOkTVTQT5owBP+CzzzAUG56uC7kWRvzRMRnG/da44So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXQnCjmRgRpkIBtHdOakRAyHs8Wd5veGgbolXNW6+j1UZfzvscb61/lgSKK+R4RAttGoIpXJyWgbxrBbFOuWhlRkX9o73KXl2FLnLi0NTKLDNuC3XgWByi8r0l8z3xdbEdbI/bAcc6sA4NwGBTT63Nw8nZig9hSCK7LaNU7FtnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDvrHGlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDvrHGlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A50C4CEDD;
	Tue, 14 Jan 2025 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736860921;
	bh=WOkTVTQT5owBP+CzzzAUG56uC7kWRvzRMRnG/da44So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDvrHGlu5pr0o7jjTmjGKkZ53ZQQ8ymLgUbKNfY1zG1AlyYlJCCir0WiNSyA4TU3m
	 Afl8CFxnLQZyTQx7HXiflY+9FHPkt9AN7GqladQXivWNTuetSZMQBBUC1wyEgSLUJ4
	 jqjFkhNMIzXUv0rEt8GulaFHv8JsDD2NXUFMFYuk=
Date: Tue, 14 Jan 2025 14:21:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Arnd Bergmann <arnd@arndb.de>, Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Lee Jones <lee@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"derek.kiernan@amd.com" <derek.kiernan@amd.com>,
	"dragan.cvetic@amd.com" <dragan.cvetic@amd.com>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: Re: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson
 6000SE SDF
Message-ID: <2025011407-muppet-hurricane-196f@gregkh>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
 <20250114095527.23722-4-zhaoqunqin@loongson.cn>
 <ee65851c-4149-4927-a2e7-356cdce2ba25@app.fastmail.com>
 <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97000576d4ba6d94cea70363e321665476697052.camel@xry111.site>

On Tue, Jan 14, 2025 at 06:43:24PM +0800, Xi Ruoyao wrote:
> On Tue, 2025-01-14 at 11:17 +0100, Arnd Bergmann wrote:
> > On Tue, Jan 14, 2025, at 10:55, Qunqin Zhao wrote:
> > > Loongson Secure Device Function device supports the functions specified
> > > in "GB/T 36322-2018". This driver is only responsible for sending user
> > > data to SDF devices or returning SDF device data to users.
> > 
> > I haven't been able to find a public version of the standard
> 
> A public copy is available at
> https://openstd.samr.gov.cn/bzgk/gb/newGbInfo?hcno=69E793FE1769D120C82F78447802E14F,
> pressing the blue "online preview" button, enter a captcha and you can
> see it.  But the copy is in Chinese, and there's an explicit notice
> saying translating this copy is forbidden, so I cannot translate it for
> you either.
> 
> > but
> > from the table of contents it sounds like this is a standard for
> > cryptographic functions that would otherwise be implemented by a
> > driver in drivers/crypto/ so it can use the normal abstractions
> > for both userspace and in-kernel users.
> > 
> > Is there some reason this doesn't work?
> 
> I'm not an lawyer but I guess contributing code for that may have some
> "cryptography code export rule compliance" issue.

Issue with what?  And why?  It's enabling the functionality of the
hardware either way, so the same rules should apply no matter where the
driver ends up in or what apis it is written against, right?

thanks,

greg k-h

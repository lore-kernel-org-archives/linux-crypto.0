Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76AE26ACC;
	Thu, 11 Jun 2026 10:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781175310; cv=none; b=NE6LRNbH8TacMbCpvvR3wLhKfw3RSccCFejEMtTkzkw//4q0cWzInmfoiT/9uet+x7QtNgDhkTOi/J6qs7dvmznsoi8I7yQsZVB+mA06pszdZCKofCTJLJ7vqmDheXSRUgaC+Bapf85hGsiTAo6afGLje13SZn+lDfzeDVkFmXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781175310; c=relaxed/simple;
	bh=zXtiU7+VjghzRFlEOGRCqtmeDcqfqKZG1ZLUXrU/HVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpTHHgrrzzhJraBDxWoPZySlbuGQuVGmYRUL+muSV+IcAbVNIBjJyVjdSlepf/n9H2vOrFDNKZ7KtSB/Ms48SqsWGMpyfVrLBvza1a4puHODNVUJCrT5o/bxQe0ZpMfKDpWLMdoH0KFtAnr1aF6DTgJtjfLL/HmpkCl5C2iqdU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cM2dQJFH; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cM2dQJFH"
Date: Thu, 11 Jun 2026 12:55:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781175306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7pVz5J49AxA7AOOClK6NcKBTj5l/4nUBhjoMqDmJbOc=;
	b=cM2dQJFHmnegyMvYl7NA6PRZ6vrBnxxJTP26I0GwbHjIRkMd1vuCmDQZH8hTyOSWgjYMUj
	hTp0iPirf4mk24tS5I9Ycsk9P0zuTlQxpRh4VO+QlWxVobViJDBtofRtRuwSTnlhJCOL5g
	bx5qEIsqrr5fqT3WM5pTFJO/NZnzPGk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - remove stale comments in
 atmel_ecc_remove
Message-ID: <aiqUBXIybgHXA6uj@linux.dev>
References: <20260602165247.977197-3-thorsten.blum@linux.dev>
 <aipH0NgL4Gbe7Oz1@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aipH0NgL4Gbe7Oz1@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 11, 2026 at 01:29:52PM +0800, Herbert Xu wrote:
> On Tue, Jun 02, 2026 at 06:52:49PM +0200, Thorsten Blum wrote:
> > atmel_ecc_remove() no longer returns -EBUSY since commit 7df7563b16aa
> > ("crypto: atmel-ecc - Remove duplicated error reporting in .remove()")
> > and is a void function since commit ed5c2f5fd10d ("i2c: Make remove
> > callback return void").
> > 
> > Remove and update the outdated comments.
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  drivers/crypto/atmel-ecc.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> > index 9c380351d2f9..e6068dc0a0c1 100644
> > --- a/drivers/crypto/atmel-ecc.c
> > +++ b/drivers/crypto/atmel-ecc.c
> > @@ -347,13 +347,11 @@ static void atmel_ecc_remove(struct i2c_client *client)
> >  {
> >  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
> >  
> > -	/* Return EBUSY if i2c client already allocated. */
> >  	if (atomic_read(&i2c_priv->tfm_count)) {
> >  		/*
> >  		 * After we return here, the memory backing the device is freed.
> > -		 * That happens no matter what the return value of this function
> > -		 * is because in the Linux device model there is no error
> > -		 * handling for unbinding a driver.
> > +		 * That happens because in the Linux device model there is no
> > +		 * error handling for unbinding a driver.
> >  		 * If there is still some action pending, it probably involves
> >  		 * accessing the freed memory.
> >  		 */
> 
> Please fix this properly rather than fiddling with the comments.
> 
> Drivers should always fail gracefully if the hardware disappears.

Yes, I'm working on a fix, but it's not ready yet.

Thanks,
Thorsten

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F66376
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715345532; cv=none; b=jNgQUAIHkBSdYLMcoIazNCdHjtmJso/RFiJAjHDlVBCKtKMs3ga7oQ9wjvRpENCjZoeZXLREixi57YogdJnBfykFjcEq+74rKVr9RjttZlNV3+/z93FYuRbBzn2o13iY01xY0eA1qxfVd2RVLEGEjVG9sOLj3gaRRaNhQEBqDOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715345532; c=relaxed/simple;
	bh=F4R3C19AZoLiQoZKLlM88oNqKAIwm0tvC1yAksYsh2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lM+tdahPDmPTciebJSVJAHv7Xp+oY1MRGkhokZXxE4+vupFmomlKvnA+mfm8l4ZmFwr2TbiWMkRmzYyfBH4uWDzllxTSx3NjS9/ASZgqtK2uSIk7fj9I3y878yF3j3tGE1Yz4O5gVQWcrcq0VwKK9oVee4QGUBxxgsLn7/OleWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3QxkSPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3QxkSPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952ADC113CC;
	Fri, 10 May 2024 12:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715345532;
	bh=F4R3C19AZoLiQoZKLlM88oNqKAIwm0tvC1yAksYsh2o=;
	h=Date:From:To:List-Id:Cc:Subject:References:In-Reply-To:From;
	b=V3QxkSPoxBn2qgJJNrFqi/U7Ad5bYZhYMS+hBAldKeIy5SQx4nwhxy71tZ4+iOQQr
	 ZZ2t+oNUxO4Ah+sM0/5dMsTL8awo37dLbbFNDoOY+bapZqeXMQoRcjR4PgrSimEA/P
	 YFqiSf+pm4iwBd4Sqb20cvZoqpM7Bk4dY7BOQT6Y=
Date: Fri, 10 May 2024 13:52:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH v10 7/9] platform: cznic: turris-omnia-mcu: Add support
 for digital message signing via debugfs
Message-ID: <2024051042-unbuckled-barometer-1099@gregkh>
References: <20240510101819.13551-1-kabel@kernel.org>
 <20240510101819.13551-8-kabel@kernel.org>
 <2024051007-rendering-borrowing-ffc5@gregkh>
 <20240510133158.2f40ee55@dellmb>
 <2024051013-purse-harsh-d927@gregkh>
 <20240510135020.06aff350@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510135020.06aff350@dellmb>

On Fri, May 10, 2024 at 01:50:20PM +0200, Marek Behún wrote:
> On Fri, 10 May 2024 12:37:04 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, May 10, 2024 at 01:31:58PM +0200, Marek Behún wrote:
> > > On Fri, 10 May 2024 11:52:56 +0100
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >   
> > > > On Fri, May 10, 2024 at 12:18:17PM +0200, Marek Behún wrote:  
> > > > > Add support for digital message signing with private key stored in the
> > > > > MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
> > > > > when manufactured. The private key is not readable from the MCU, but
> > > > > MCU allows for signing messages with it and retrieving the public key.
> > > > > 
> > > > > As described in a similar commit 50524d787de3 ("firmware:
> > > > > turris-mox-rwtm: support ECDSA signatures via debugfs"):
> > > > >   The optimal solution would be to register an akcipher provider via
> > > > >   kernel's crypto API, but crypto API does not yet support accessing
> > > > >   akcipher API from userspace (and probably won't for some time, see
> > > > >   https://www.spinics.net/lists/linux-crypto/msg38388.html).
> > > > > 
> > > > > Therefore we add support for accessing this signature generation
> > > > > mechanism via debugfs for now, so that userspace can access it.    
> > > > 
> > > > Having a "real" user/kernel api in debugfs feels wrong here, why would
> > > > you not do this properly?  On most, if not all, systems, debugfs is
> > > > locked down so you do not have access to it, as it is only there for
> > > > debugging.  So how is a user supposed to use this feature if they can't
> > > > get access to it?
> > > > 
> > > > And debugfs files can be changed at any time, so how can you ensure that
> > > > your new api will always be there?
> > > > 
> > > > In other words, please solve this properly, do not just add a hack into
> > > > debugfs that no one can use as that is not a good idea.  
> > > 
> > > Hi Greg,
> > > 
> > > this is the same thing we discussed 5 years ago, I wanted to implement
> > > it via crypto's akcipher, but was refused due to
> > >   https://www.spinics.net/lists/linux-crypto/msg38388.html
> > > 
> > > I've then exposed this via debugfs in the turris-mox-rwtm driver 4
> > > years ago, and we have supported this in our utility scripts, with the
> > > plan that to reimplement it in the kernel via the correct ABI once
> > > akcipher (or other ABI) is available to userspace, but AFAIK after 5
> > > years this is still not the case :-(
> > > 
> > > If not debugfs and not akcipher, another option is to expose this via
> > > sysfs, but that also doesn't seem right, and if I recall correctly you
> > > also disapproved of this 5 years ago.  
> > 
> > Yeah, sysfs is not ok for this either.
> > 
> > > The last option would be to create another device, something like
> > > /dev/turris-crypto for this. I wanted to avoid that and wait for
> > > akcipher to be exposed do crypto since another /dev device must be
> > > supported forever, while debugfs implementation can be removed once
> > > this is supported via standardized ABI.
> > > 
> > > Do you have any suggestions?  
> > 
> > Not really, I can't see the link above (no internet connection right
> > now) but this should just be fixed properly at the crypto subsystem
> > instead of these horrible debugfs hacks.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The mail is from Herbert Xu and it says the following:
> 
>   The akcipher kernel API is still in a state of flux.  See the
>   recent work on ecrdsa for example which affected the RSA API.
>   
>   Until that settles down I will not allow akcipher to be exported
>   through af_alg as that would commit us to that API forever.

5 years is a long time for "in a state of flux", perhaps work on getting
that fixed up now that things are settled down?

thanks,

greg k-h

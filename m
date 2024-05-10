Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C3B170842
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 11:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715341027; cv=none; b=VQFelT8UEJ+z5z3EgQqgtQ66bhC0pWEvmTjIAPT189s+yctLiAMl1/COJc8ZDho0JQ77eN/KMF9ij5/aIEWeBLnRFxYcXOrKqkrtLMdtL48mc0RdHNVKDxJ6f53Su7V7ovqan6lisg8T34kSPwUFwFJMAgetH1jWkup+Kk9UMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715341027; c=relaxed/simple;
	bh=OEARAHgfF7UBd5km5jO5Rc2BPSqqwbKmaW+QFnCKJH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKWGe7Ho5SEEnWNizLQRNBZ/9ZmY37Kq/d9hqADbt+qDgBkUBzWl+gvhAetxJFqCe6QG8t5UHQhgCSRISNFRh1r32OmtRfWh5wHacmiktA6vc8u3UMtroZALbmYl+MLarHf7nePKvHcr/nsjkhS/Qymrr5biLvK388Ti1qfS+0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6ekbjxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6ekbjxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF487C113CC;
	Fri, 10 May 2024 11:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715341027;
	bh=OEARAHgfF7UBd5km5jO5Rc2BPSqqwbKmaW+QFnCKJH4=;
	h=Date:From:To:List-Id:Cc:Subject:References:In-Reply-To:From;
	b=c6ekbjxfNkyya4S+uCY4EOjNYyPm/E7dAhnCGDbMsauYNEg4de3bZ2PZnyb3g/+VZ
	 /b8DommstLAS4z1QySnwFr6jDcxZ+D77Vb4WZu+BGH4GR3eS6gg/kdygUs6dMqyfIm
	 ct6igCU+U4cxwDsPKZv2tQjqd2QBsMYVr62VoU0w=
Date: Fri, 10 May 2024 12:37:04 +0100
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
Message-ID: <2024051013-purse-harsh-d927@gregkh>
References: <20240510101819.13551-1-kabel@kernel.org>
 <20240510101819.13551-8-kabel@kernel.org>
 <2024051007-rendering-borrowing-ffc5@gregkh>
 <20240510133158.2f40ee55@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510133158.2f40ee55@dellmb>

On Fri, May 10, 2024 at 01:31:58PM +0200, Marek Behún wrote:
> On Fri, 10 May 2024 11:52:56 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, May 10, 2024 at 12:18:17PM +0200, Marek Behún wrote:
> > > Add support for digital message signing with private key stored in the
> > > MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
> > > when manufactured. The private key is not readable from the MCU, but
> > > MCU allows for signing messages with it and retrieving the public key.
> > > 
> > > As described in a similar commit 50524d787de3 ("firmware:
> > > turris-mox-rwtm: support ECDSA signatures via debugfs"):
> > >   The optimal solution would be to register an akcipher provider via
> > >   kernel's crypto API, but crypto API does not yet support accessing
> > >   akcipher API from userspace (and probably won't for some time, see
> > >   https://www.spinics.net/lists/linux-crypto/msg38388.html).
> > > 
> > > Therefore we add support for accessing this signature generation
> > > mechanism via debugfs for now, so that userspace can access it.  
> > 
> > Having a "real" user/kernel api in debugfs feels wrong here, why would
> > you not do this properly?  On most, if not all, systems, debugfs is
> > locked down so you do not have access to it, as it is only there for
> > debugging.  So how is a user supposed to use this feature if they can't
> > get access to it?
> > 
> > And debugfs files can be changed at any time, so how can you ensure that
> > your new api will always be there?
> > 
> > In other words, please solve this properly, do not just add a hack into
> > debugfs that no one can use as that is not a good idea.
> 
> Hi Greg,
> 
> this is the same thing we discussed 5 years ago, I wanted to implement
> it via crypto's akcipher, but was refused due to
>   https://www.spinics.net/lists/linux-crypto/msg38388.html
> 
> I've then exposed this via debugfs in the turris-mox-rwtm driver 4
> years ago, and we have supported this in our utility scripts, with the
> plan that to reimplement it in the kernel via the correct ABI once
> akcipher (or other ABI) is available to userspace, but AFAIK after 5
> years this is still not the case :-(
> 
> If not debugfs and not akcipher, another option is to expose this via
> sysfs, but that also doesn't seem right, and if I recall correctly you
> also disapproved of this 5 years ago.

Yeah, sysfs is not ok for this either.

> The last option would be to create another device, something like
> /dev/turris-crypto for this. I wanted to avoid that and wait for
> akcipher to be exposed do crypto since another /dev device must be
> supported forever, while debugfs implementation can be removed once
> this is supported via standardized ABI.
> 
> Do you have any suggestions?

Not really, I can't see the link above (no internet connection right
now) but this should just be fixed properly at the crypto subsystem
instead of these horrible debugfs hacks.

thanks,

greg k-h

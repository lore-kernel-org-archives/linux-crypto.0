Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F058F1D435F
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 04:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771820050; cv=none; b=BZRxVGwjSUIN0QC7/5GIOhU460J8n9r53qysYN3m9KuaSLCa5HMT6pMT12FoPV7na5hQ+DdH1nQh7T+SaYxPBIhU5VqQhpfqTecvpL2/QO4o4sN1zafNZedh/UDsCKNoQpwwsPuSxiupfXAWe5LpzGo74uFC1PQK5EjHt+PNS3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771820050; c=relaxed/simple;
	bh=MXky6nBicUc1x+qGVyqO1jo/VXdtgJE4F5hbgNOXzPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TEflNM5uNgdLCPhTFgGZ7wugGePXuMF6im2z/zs+gaEJk2Q3/g2rBXq7SjJyPrz1a0lujv48D8E3xIQL2i7+4e1ZpemOL/iVoV74UAuoVaTDyFx2keYYbx+B0Ya1hiG+wHWMR0E/W32xD0Oz8GLSxX2nUypOr/IsmdypDIHQvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDZ1xMyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDZ1xMyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBB1C116C6;
	Mon, 23 Feb 2026 04:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771820049;
	bh=MXky6nBicUc1x+qGVyqO1jo/VXdtgJE4F5hbgNOXzPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JDZ1xMyCs4gDiZ4GUX8L5Wbuz5M9EF6xxlSoAMGA9eYJb+4duQU6web8QttJCEIaR
	 LiNG3COfBzmvo5XyR9cIZxPUAxkID3JHCQRE+SiazCvk7QKHQpRkbeq3pMCs03xTzS
	 6xzXUOrIKi4HCix19Tp6Jj2Hzy24T0pU2XeBO6Yg=
Date: Mon, 23 Feb 2026 05:14:05 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Manas Ghandat <ghandatmanas@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	herbert@gondor.apana.org.au, rakshitawasthi17@gmail.com,
	security@kernel.org, linux-crypto@vger.kernel.org
Subject: Re: Null deref in scatterwalk_pagedone
Message-ID: <2026022305-handoff-maverick-13c5@gregkh>
References: <e3044be2-1f05-4cfb-99e4-39dc09e4aeb4@gmail.com>
 <63fdfca0-5165-4307-ae8e-c25cbed7f8cb@gmail.com>
 <20260222202123.GA37806@quark>
 <1205234f-6ddd-4369-834c-6415f8fe0265@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205234f-6ddd-4369-834c-6415f8fe0265@gmail.com>

On Mon, Feb 23, 2026 at 09:32:17AM +0530, Manas Ghandat wrote:
> 
> 
> On 2/23/26 01:51, Eric Biggers wrote:
> > What kernel feature are you using that does GCM encryption?  E.g.,
> > IPsec, TLS, SMB, ...  Is the code in-tree?
> 
> I was fuzzing the TLS subsystem when I found the crash. And yes the code is in-tree.

As this seems to be fixed in 6.19, and you don't have a reproducer,
there's not much we can do here, sorry.

If you do end up with a reproducer, can you submit a backported patch to
stable@vger so that we can queue up the fix for the older kernels?

> > Any reason linux-crypto isn't Cc'ed on this thread?
> 
> Aah, my bad. Added it to CC.

Note, they didn't get any of the previous context :(

thanks,

greg k-h

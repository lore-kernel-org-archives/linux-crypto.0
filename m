Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1323957D
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 22:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974259; cv=none; b=M8yG+dkkjjy1UuYrcfPVROkqt2+iXoYAoxRtv2qERB5DkxrS4Z+ysxcajqX7u/fDrSDbIp9pEWU+mmjZicLKovFzJPcujbbCRqJ9W91b1e+uSNb7LMhDWM7PDiVLeUTO+OETZZJZoTchn9dJChkfEWqP/sVeu7i1vhFLQ9A49qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974259; c=relaxed/simple;
	bh=x6l8q2x20aN5Rv9DcBorVvGAIvZJ1+l1PBWqdFA6HVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8w74xAPnW374kovyA/Hjvo0RCLpg5wZV+a1OmOyVdqbhzhBejDuaw/lZUpbj75xD7CkoewV9So6ZoB+E7umi1UwNi+NPTX2XVK0Q7voIy47Is7kdSFrX4Lti+3mWoydL2ClVaFh8OGOFMiEElxvkG+TpAOGs0Rpmhiwziomhvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YLe0r3WU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YLe0r3WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65858C4CEF1;
	Mon, 15 Sep 2025 22:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757974259;
	bh=x6l8q2x20aN5Rv9DcBorVvGAIvZJ1+l1PBWqdFA6HVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YLe0r3WUOvon6we12LDikj3L3gU1zdBGWjKwWILVggd7UQi7rFxg34u1NiyAqDaCd
	 cEsF4btdbmTjlg8kw8RMJEIE14l+SbN9856JHSklqy3N8MQppl24z/Qo3VAXZrrR/z
	 5qlRCfJeO73PbmsQO4+Mq9LH1GcBf3wetg7o3HTOUb1+/0h8M/KwcKIfh6y/9jcWue
	 jvCIlGfrwf6tLnfQ6326K3yu0K9DMbWP4QQR+74jIGxW9OVQBlvNeZT+JFh/tyKkHP
	 loFO/wItYt3KwtEgdmOsme6fmCEVU+0t+dsMOEGXeSyFXYlMMd9qsCUsHXYxmQnP7m
	 rAnB1RPrBi/iw==
Date: Mon, 15 Sep 2025 17:10:55 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
Subject: Re: Adding SHAKE hash algorithms to SHA-3
Message-ID: <20250915221055.GB286751@quark>
References: <aMf_0xkJtcPQlYiI@gondor.apana.org.au>
 <2552917.1757925000@warthog.procyon.org.uk>
 <2767452.1757969294@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2767452.1757969294@warthog.procyon.org.uk>

On Mon, Sep 15, 2025 at 09:48:14PM +0100, David Howells wrote:
> > If so you should be using lib/crypto.
> 
> Okay.  That will automatically use CPU-optimised versions if available?

If it's done properly, yes.  It's already been done for various other
algorithms, such as SHA-1 and SHA-2.  No one has done SHA-3 yet, but we
should.

> Btw, are the algorithms under crypto/ going to be switched to use the
> implementations under lib/crypto/?

Many already have, and most of the remaining ones should be as well.

- Eric

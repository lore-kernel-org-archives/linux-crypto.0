Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436664;
	b=ey5XX75JmDN+bTbFpJEfgkGZbS1gv0UoXFxZaJC6ONhGho3EsZVAodA4lxLY9ZAA9eOl
	 9t9gxKBESFQWR6fXiF/L6dfGXSFrC03JFZr9HI2rcf6tvrzAY7q4VGDYygT5eWj36KLCm
	 JKkmQCRL/BuN982lh0Qx/tUI3nK36x3fo9XZaoQp9Ps1Ty8aJ3xP5oUv/007gQZEKZ7w6
	 bJQR2/veK64u+ty2mtBQjdnRI8komhr1lWRfrU51iFQkjrxa+7IdnySnZ22meUE/seB4O
	 PHDxurDR1tfj0JXJrB4o7PwZKt49hmOdXLV6ftYkNisFdq5/S+zFJMSAMQt6nlhaM1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=61zqpYLK2zN4FoimILaEQmQFkmsGj8y9iKj/xRNxzh0=;
	b=M+fLyGDBKmHGnMWrs7P+geZoUk+pX7WrnSD2f11q3PZjhfU5tIIcnvDVp1vW4dgpN9NW
	 WgHSiqL/nJ36ZU5SpaC0zQ2pWPVoDVigti1fIE3ng/w59J+BaAjmJMQhMcvydDcCSGoQL
	 +hxoJznqvQWb8VQrZjG2Ecq5vNyxLATBo5SJp8NNocKikGC8Q3drg8A0bdBh4sY7yJB9N
	 WV+4BP/zsiR7IutgfClfDZl8S8rslC0y1Jmay5qD8s4w2dJTgwf0SovGM1oSb4j+XEmLD
	 7ZyI1a+LzPA0pyPp2oJKRhpPiGKoUF/ReP+xp0s2UHdaHI/5zR3ptPi1lwrbWXpVgqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeMb2nj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D485606A338;
	Wed, 11 Nov 2026 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeMb2nj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FDC1F00A05;
	Wed, 11 Nov 2026 22:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794436663;
	bh=61zqpYLK2zN4FoimILaEQmQFkmsGj8y9iKj/xRNxzh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aeMb2nj6hW0xg3VGqMq/j27bFe8owBE1WUS3Engog9IOUBm2zLOmtUIJzATOUSEB3
	 M6+IPKUNkGPEKlLtD4VUZU7cjb9SoAPo5HEQc5CZtl+ZtgE78C3pI9/wWpnCnG30ox
	 pX9U3eKsmqo6YvPvj/taHrWOeZO1kuNi+suHI9IA8uujACzCpqG5i49UZua80drYCN
	 lsVSsdocLxbXe/gPBL+c24Q06pf+PPQ9SvRVRh8C0Wc2otONg7NYNXtpl/Hev8WLNY
	 Cv23Uq/9SHlFKneO9BxoJxsoHgDAJB3s2HB0E07UFVB7IetA8NEdV8GxLat0CnO693
	 OvE84wlvHWxjg==
Date: Wed, 11 Nov 2026 14:37:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Mimi Zohar <zohar@linux.ibm.com>,
	Roberto Sassu <roberto.sassu@huawei.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, Peter Huewe <peterhuewe@gmx.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Check return value of crypto_kpp_set_secret()
Message-ID: <20261111223741.GC41158@quark>
References: <20261025211119.138277-1-ebiggers@kernel.org>
 <at5-ve5Ap7Oyp1Fo@kernel.org>
 <20261025224723.GA148998@quark>
 <at6MlY1kpfa01tr4@kernel.org>
 <at6QqYWELUtDqUUT@kernel.org>
 <20261025234009.GC148998@quark>
 <at6fpcT5EJIZD8DD@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at6fpcT5EJIZD8DD@kernel.org>

On Mon, Oct 26, 2026 at 02:32:37AM +0200, Jarkko Sakkinen wrote:
> Adding Mimi and Roberto.
> 
> On Sun, Oct 25, 2026 at 04:40:09PM -0700, Eric Biggers wrote:
> > On Mon, Oct 26, 2026 at 01:28:41AM +0200, Jarkko Sakkinen wrote:
> > > I'm not sure if it already is but if it isn't, probably also at
> > > linux-integrity turning on Sashiko would make sense.
> > 
> > Sashiko currently has monitoring enabled for linux-integrity, but not
> > email replies
> > (https://github.com/sashiko-dev/sashiko/blob/main/projects/linux/mailing_lists.toml#L45).
> > 
> > (Note: this particular patch was Cc'ed to linux-crypto, which does have
> > Sashiko email replies enabled.  So Sashiko would have replied if it had
> > found an issue anyway.)
> > 
> > I definitely would support enabling email replies on linux-integrity
> > (for issues found only), like a lot of other lists already do:
> > 
> >    ["linux-integrity@vger.kernel.org"]
> >    reply_to = ["author", "list", "recipients"]         
> > 
> > If the maintainers of security/integrity/ would ack that, I can open a
> > pull request to the Sashiko GitHub repo that changes it.  Or someone
> > else can go ahead and do it if they want.
> > 

Mimi and Roberto, any thoughts on whether you want Sashiko replies
enabled on linux-integrity?

- Eric

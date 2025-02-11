Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595291F55ED;
	Tue, 11 Feb 2025 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739287913; cv=none; b=qemyc3426AIlAK2WkcicT3jN38Hy89NZqeC5Qx2su8S9Ye/3lZtE4Pri6lg7wqnU9ksA4hU9gEtWXATPPDSYA++FGkqh/G8e6HqSdbjQ432TPr03UxGdI5yDTpK/FWpawpl2Kk2BqBRnNQcx5EDzy9pmWv7QtHxDxEEqFKnDiFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739287913; c=relaxed/simple;
	bh=BuvtqjV55gZ0tKhPQub/uLEqKJ0jsP/YnyzafgATcPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahKoQaTUJ4vAvb2I9iqK3yMmgA54CqmcC2ED3EMQfsQV/fq7Lnu7/8xrjPcKSmVt97LNakfNLsCFluOVRzv/XiErDG+eOZPC4Hc6WhQQp602alXnc4oRPoZog1t5i08Yp7DckGZoKGYQa0u4rtn7/vin/+oJJmsI3Dp4OeF4/bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAihRzm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAihRzm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ED7C4CEDD;
	Tue, 11 Feb 2025 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739287912;
	bh=BuvtqjV55gZ0tKhPQub/uLEqKJ0jsP/YnyzafgATcPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oAihRzm8tvtP4l3Icb9yKW/TQcrsCLazIAneqqp06Mvm/NXXCi5vJvafFte5ECOfK
	 iU8psq2u7+NX3LeDJ951NnsAqXOTE7BM44yWqjk1igX6h8KMFBX6TPWXQNIBfOxIrc
	 mUIt3WWjBrKLy7dThYw00GfFF5i8eA0/RqL4XOONAm+l2jA6zkmDvnP5q6sHYVjq2N
	 q0tbVGImCYlI5hkG0f2YKu74s6DmRD8nhhkSdkUcWYd92iTQQfTTybvFA+M/+4sLn2
	 u3cLcOg2oxycTHw69SWKxr9/OanlNorarORNsqv2JleD401/YPHh4KAV3RpCndf8xe
	 Cc/cjgoFdFXdg==
Date: Tue, 11 Feb 2025 07:31:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, dengler@linux.ibm.com,
	herbert@gondor.apana.org.au, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250211153151.GA1227@sol.localdomain>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>

[+dm-devel]

On Tue, Feb 11, 2025 at 01:09:12PM +0100, Harald Freudenberger wrote:
> On 2025-01-15 17:22, Harald Freudenberger wrote:
> > Add support for protected key hmac ("phmac") for s390 arch.
> > 
> > With the latest machine generation there is now support for
> > protected key (that is a key wrapped by a master key stored
> > in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> > for the s390 specific CPACF instruction kmac.
> > 
> > This patch adds support via 4 new ahashes registered as
> > phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> > 
> > Co-developed-by: Holger Dengler <dengler@linux.ibm.com>
> > Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> > Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> > ---
> 
> ...
> 
> > +
> > +	  Select this option if you want to use the phmac digests
> > +	  for example to use dm-integrity with secure/protected keys.
> > +
> >  config S390_PRNG
> >  	tristate "Pseudo random number generator device driver"
> >  	depends on S390
> 
> Hello Eric
> 
> with your commit
>   7fa481734016 crypto: ahash - make hash walk functions private to ahash.c
> you move the crypto_hash_walk_* functions to private context into ahash.c.
> So for example my new phmac does not compile any more.
> What is the replacement for these functions then? Should I really do
> the scatter walk by my own now or is there a set of new functions to come?

This is just another ridiculous problem caused by trying to shoehorn CPU-based
crypto into ahash which is an interface designed for off-CPU offload.
I've already given the solution here:
https://lore.kernel.org/dm-devel/20250116080324.GA3910@sol.localdomain/

- Eric

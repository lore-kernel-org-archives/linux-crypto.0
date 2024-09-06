Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7914A4D1
	for <linux-crypto@vger.kernel.org>; Fri,  6 Sep 2024 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725606390; cv=none; b=XEEC1R9Ai8AhkUkbwt4UGicLuOXtH7+tT0L2kR5OSYaZtUGb8osjpYfAyRHVIsJPKlLCv9LOK5Ura8Is993CoMbcfHkGCXol8QndcWgMKpaZJQK/WvJBZit4YbejFts+ap1aBZSjV4TB2nMu4mAWll7HluvHbfiv+6vkzMrimSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725606390; c=relaxed/simple;
	bh=8S2nKwtt4VfiQli2S+kyvHwZITj2ou8eGMjHTICbWqk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=R7kZHe5RTLhqo5aoZejbTLmLWt0BU8dToldKRR/7PkRz5DiODwjYJTCSoqq/PWun4VnExOtG5vNAKt3eK0AlS9bPKinwum1G0a0lw3N4zRHWdhT8TwJUOxKr9ziJdzlO88Wrucj6FF3oVsnbIFXzJl8AnTN4xpHkwz3rLYXuG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rDSCLVN5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rDSCLVN5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fKcH8WibWIITWPKZkcn0VkdI4E6ulHEI6QdTaICZatY=; b=rDSCLVN51jdj4RmLvBf3d6mvQq
	ZMYuqnvf9E2Quz7IZ//AIjBKp9rJfUsHsnNMi+R9J4RTDxWCfkr30fWIVtUC0DHJyk661L/cTX96S
	zgKsH6Q4ITsEsm2dAGAdnfC5liY69F1v3Dfioe/X5no5Ss9j6HPNQv0QKf/6Lr3ixq2vxf1KJ4j6B
	HHc4QZtDFQrM1cbdPbF2ExdYOg0aTrccOS5xQEaUMNuaStYhwZKniobqYX0yecVl/uqsBLhlKps0G
	erCEHETphnewvXnGJ11Cs2pz0ff2ks+amITK9QkXtybv6gqNQQv219dkXrhi9jBIOE6DxVI6myVSO
	j8LCE3yA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1smSt7-000WUE-1k;
	Fri, 06 Sep 2024 15:06:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Sep 2024 15:06:23 +0800
Date: Fri, 6 Sep 2024 15:06:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aesni - update docs for aesni-intel module
Message-ID: <Ztqp76uSimFCHfM7@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827185001.71699-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Update the kconfig help and module description to reflect that VAES
> instructions are now used in some cases.  Also fix XTR => XCTR.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/Kconfig            | 8 ++++++--
> arch/x86/crypto/aesni-intel_glue.c | 2 +-
> 2 files changed, 7 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

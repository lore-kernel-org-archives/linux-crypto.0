Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7027E271834;
	Wed, 12 Feb 2025 05:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739339304; cv=none; b=fgvSXwhblodBvkViud+YD+XBGC6guuWidV+6uCzWSwjT9OEr/h6qKhFW1vkxzXHkrXgBIuVwuynb39b0L/7PFGnPO4hPX9H5hZtjGTUZgkLJ0N9H96IDqnyjooP62NRlao1Z/7Bpltkfbr52+p9L0QSZv4ow3NLDV2R+4I7PDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739339304; c=relaxed/simple;
	bh=ScOg7aiAPTeXbBcpVo1c4sXN5pW27p2xE46n2njDNLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nceUxqlknjyHRfEuuYollBFKRT/zGevhlly7jlRdp0sy6ELawYNghM4EqERYP5xXmU7vC/+Fir+VAheiRYVIQc0A7jVrNDzdc+M1/mc3xPYEkveTCIUCnBxLI03Blr4PQ6VgQzxG+cet28n1wQujbx3wLITpSBDXv3OuTNA9ySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GGrDtlIq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GGrDtlIq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ycHONxMQPF80DIruc10D2MrsS8Rh/RkcLxDH6/yynuo=; b=GGrDtlIqnDlQK2yOFShmfnPcnm
	/2VVBNLE5LVEd4SqWhWtwNSOv5YjV6nw2+UAlhgUhWfNReFAGuEYPPCvOscQuTItV2k4Tw4SCwMWs
	zmGlY5WTtV6RhPbCSIkUmmK62Iro6KZGhuzA4PmnhvkG15ohuPuwCUgiddQW/KSxHDaZSi6jz23+W
	WkS8WoaE0mBAOqaUjmQekfJanfT60KYICI5i08EFTGo8dHundZun0fruo0ts88j9BMc7nxBokEyFC
	xMn1tLAJRLxChqx+xeIPyiAxoLkEqxSb9q7vLaH/xgwgDgusHxbvTvKdlnilhMBx3ktFrpGfJN4O+
	kQg5fwAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ti5Od-00HEQB-1D;
	Wed, 12 Feb 2025 13:48:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Feb 2025 13:48:12 +0800
Date: Wed, 12 Feb 2025 13:48:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <lkp@intel.com>, Danny Tsen <dtsen@linux.ibm.com>,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: lib/Kconfig - Fix lib built-in failure when arch
 is modular
Message-ID: <Z6w2HNjkFo4jvP3s@gondor.apana.org.au>
References: <202501230223.ikroNDr1-lkp@intel.com>
 <Z6woN4vgdaywOZxm@gondor.apana.org.au>
 <20250212050936.GB2010357@google.com>
 <Z6wxp7UE9MAht4pc@gondor.apana.org.au>
 <20250212054428.GC2010357@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212054428.GC2010357@google.com>

On Wed, Feb 12, 2025 at 05:44:28AM +0000, Eric Biggers wrote:
>
> The way that the arch options are selected is very much related to this issue,
> but even disregarding that the first paragraph of my response is a review
> comment directly on this patch about the naming it uses.

The CRC situation is not the same unfortunately.  For better or
worse, the crypto API glue code is currently entangled with the
lib/crypto arch code.  Meaning that a single Kconfig option ends
up selecting both.

So I don't see how the MAY_HAVE options can map onto the ones that
you've used for CRC.

Sure you can clean this up and perhaps make the lib/crypto arch
code always built-in.  But that is not something I wish to spend
time on.

In any case, none of these new options are publicly exposed so
you can rename them down the line with very little effort.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

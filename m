Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DA40DFCC;
	Wed,  8 Apr 2026 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655850; cv=none; b=uCzk99kHTe52Px/Wv2ax9SCz71jI72UrReK4Y10hT69aMexriZyk8yFIoHxpWl1jsO2ACQ3TCBpoBoFUUjQFdRwmZw4DPV3pYLKYTUuMqnJGPLNoVD6dkgqELOIRix/xFKMC3loGyCLBO/800bwO7LZiS3j/8hXvDQPs+QqByYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655850; c=relaxed/simple;
	bh=H1zDvRJ+eiDVgGyPs7eDpoOc3Zmxth5aoyqg49reSsU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C9LeRNNZxegOPY4sDgZ15MaYquc0luNES3/5n5+ALPkPhN0ssHnvmihgVX8x53DHaG+1I9+2lDUEj5mLfW3FoeGIvrOrQqiwJkZ63drfaopU7ZiH7K8PzK6OkREwzpVrsZR8FLS5ZV28/nm81wy0sVEPoRZKYxdTgHM8c0oJQzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=gWmfGEl+; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="gWmfGEl+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=6xMhuaeGAXPBrlBVV7ljiN2WwXgxanWaSJ56liBEV/I=; t=1775655848;
	x=1776260648; b=gWmfGEl+c0mCdG0FGgkxM9BpHP+7C6t3QfCAbqoF+kfIP9sqC5t2jsQJ2kbHG
	qGcffkPAcaUqmW6MKeJGeQQ0Zb/f/X6v5FSL1/7H8W8B9Tcn8+L89xlCacvQOaJYkv+Cbq8F29iKE
	Q7x/CnIEBNl9Ln+VNjFexbYntpPzYrVtYhbcIaGBwAbOEV/Ca8u7w6q4D5VmDKjeskCLgpCCedhjz
	+N+DcwtL48bap4k7BcvJGfH3rwP6f1eIz5PuMhHVxBMGexE8lGOr1bSH83KeYMaBhC1O2u+VDDgNl
	4EUc4Y0lIdfgdG6mkJaWkarLbiJHMd0zpiT9pNP0f367i6Mynw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wATCI-00000000qa6-3Dzx; Wed, 08 Apr 2026 15:43:58 +0200
Received: from p5dc559e1.dip0.t-ipconnect.de ([93.197.89.225] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wATCI-00000003rfa-29TE; Wed, 08 Apr 2026 15:43:58 +0200
Message-ID: <6cdf44cd6851a9a147dfcf5982bcd18ebc78ea34.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: freude@linux.ibm.com
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, 	sparclinux@vger.kernel.org, x86@kernel.org,
 Holger Dengler <dengler@linux.ibm.com>
Date: Wed, 08 Apr 2026 15:43:57 +0200
In-Reply-To: <ccb1363db0aa040838396090155b3e66@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
	 <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
	 <ccb1363db0aa040838396090155b3e66@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

Hi Harald,

On Wed, 2026-04-08 at 15:35 +0200, Harald Freudenberger wrote:
> I am about to implement some of the cpacf instructions for qemu.
> Eric and others complained about being unable to test the s390 in-kernel=
=20
> crypto
> implementations and thus I am about to improve this. As soon as my patch=
=20
> series
> is in a good shape I'll forward it to you. As of now my main focus is on=
=20
> AES (ECB,
> CTR, CBC, XTS) with and without protected key support.
> Please let us not do this work twice - so get in contact with me and=20
> Holger
> about possible s390 specific crypto implementations for qemu.

Thanks a lot for working on this. I would be interested to see the first
patches as these might help us to work on the implementation for SPARC.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

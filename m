Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81261322A00;
	Thu, 26 Mar 2026 20:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774556466; cv=none; b=uUO8pLGoVFiTUkkHIm8jXr0RWNGuvQxJ39jdioXRECSovbMeZvjgfRGDHWwbjInX9udhN/utXdWsgFMhUzhmTV6KYjZ6Wptcpr+SJ6FQyp87z7m5pLJTwmD9az55GwefC9Yu9SQtDiiJEAlC3+lXqxPnjP6qQ/86eJLuqG9hhbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774556466; c=relaxed/simple;
	bh=IU72WFFPhnyUv/dlSXXLELNERChFsek/ZmOvUuINy8U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M/x47ILqcGydheMdslEs/W4vwtpDQ5V8QzhE6usdtvLmY90dwl/GyhN6xfnoHaJDbfDC4UK3rqEgOlUE6/Ep9aLhAEHe9FZskBH6D0zKeO3XRgo3x9h8iFyF9ZpB9LxbnBEGkojSeE3KT0dgXwmG6TRAcytOtxV09ALfXMfpuMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=fwNi9Deu; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="fwNi9Deu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=B9tbqH/9iMZAK5Qqn8bB/L1c2I2QPoQoR8e2ULL9pz4=; t=1774556463;
	x=1775161263; b=fwNi9DeuDZG255LblIOw2RI+gH/vyo43ec9jkmEV58tX9tE3hAVq5aNmYvwNr
	e1vr1xP6Q2+Af3vNykW2gg/CrBwkdiDtp+golcFOsqFFfF4fYJUT5F51aTE7CKZWkJmpxKAxUqr5W
	aX8W6wcEyey9DFYQxEjcmCKdejQCkX5PRbwC0SOIC0gFDMveyso1wCtBB7W5DV76QvnCFT0z4mT9K
	Aee+Xim9vpYUpw1aaVvq2Bhih9NGCv49Xaujlp73Ttxn5sa+SKEH+Th5rsAn/CxYE6cU/vbt9eFR+
	diiwNZLX6AwfsiGLvo4fd3yX6eiNNX9XHVU07Xwp/Oa9BMDGMw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1w5rCG-00000000VOE-36c3; Thu, 26 Mar 2026 21:20:52 +0100
Received: from p5dc55f29.dip0.t-ipconnect.de ([93.197.95.41] helo=suse-laptop.fritz.box)
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1w5rCG-00000000hiR-2DKC; Thu, 26 Mar 2026 21:20:52 +0100
Message-ID: <0982d4341f58e2f1181bc472dc9c9d8542148e3c.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 0/3] crypto: Remove arch-optimized des and des3_ede code
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Harald Freudenberger
	 <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>
Date: Thu, 26 Mar 2026 21:20:51 +0100
In-Reply-To: <20260326201246.57544-1-ebiggers@kernel.org>
References: <20260326201246.57544-1-ebiggers@kernel.org>
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

On Thu, 2026-03-26 at 13:12 -0700, Eric Biggers wrote:
> DES and 3DES are cryptographically obsolete and insecure by modern
> standards.  Continuing to maintain highly specific, complex assembly and
> glue code for them, especially when the code isn't testable in QEMU
> (s390 and sparc), is unnecessary and risky.

We're working on getting crypto instructions added to QEMU though.

Adrian


--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

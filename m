Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3399D3E51E7;
	Tue, 17 Mar 2026 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756902; cv=none; b=l10btid04qlf/JuadzZV3+TK/m/pzBNcQbaUuNK+8fmlG+IPGcfQ12fB98A98VJnb/nrUk2t2VGVkOZrWAAfUDAECrfjUJZhU8Gwv7RuxCppvULAB0Ne1y9VtK/NCKTqF+/sFQWZEH6uACQMtNnNYALp0c+m3CpguSbSILTRgRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756902; c=relaxed/simple;
	bh=r1wJf9IeXXp2nO3l/rI+uioKCx+6QP3LaI4aVZPbYVw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=da1PI0GR4uzrBpIlX0D6a/U0X22AhAAJg5qQv0kLht2BazMeFdpmuhUSozNRZjfk5qJWlhcn0h90q3VDlm0n0diXWh8pybkrxG5vdczuYRFZYl4z+0w/dZR1v+ch0hwL7LurK60CeveJuLTlZGjNNDb3XTZmX0+CPwah4KHySJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=hkfb+gEP; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="hkfb+gEP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=JeNWP9eIK4AC3wTPnnPdm97ys2ptc7WHoXS4ajsGCmc=; t=1773756899;
	x=1774361699; b=hkfb+gEPgt4kYdql+Xes5EcxlmVtAhcPpXnPqEb4XHbgItPUrsBam0x5ExNkp
	DmizxMYrGjk5YZLBYjL4UBKiqyIb4wl9YXJGbh9dzhrJQLXcnOWW0dvxBBSflgwH6YisLt7inOVfd
	opuEtes/F6pAP/zGzdgNjRIZGjizLjKD1T5WuD/syHd8OKOfyTaTvziDGFBiubPFGnHaNFjwD2jZZ
	Sms2HRi8hLhPKGhOKKUWG4QnZ+ubp7xErnqpRCHCxKCTG1bpbgtNSsk9SXXw8jh1xqg47NZ7dXgc+
	Z7ZuNKKcy429nmA3/1fKAJaxcOoGIL4oUHCaaBbTivqayD2NNQ==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1w2VC7-00000000AMK-0tHx; Tue, 17 Mar 2026 15:14:51 +0100
Received: from p5dc55f29.dip0.t-ipconnect.de ([93.197.95.41] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1w2VC6-00000000ukG-4BRp; Tue, 17 Mar 2026 15:14:51 +0100
Message-ID: <079d287944ffe94903286ea73fc1df167206321a.camel@physik.fu-berlin.de>
Subject: Re: Does the SPARC optimized crypto and CRC code actually work?
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Theodore Tso <tytso@mit.edu>
Cc: Eric Biggers <ebiggers@kernel.org>, Nathaniel Roach	
 <nroach44@nroach44.id.au>, Andreas Larsson <andreas@gaisler.com>, "David S.
 Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
 linux-crypto@vger.kernel.org
Date: Tue, 17 Mar 2026 15:14:50 +0100
In-Reply-To: <20260317140646.GC53921@macsyma-wired.lan>
References: <20260316204211.GA2661@quark>
	 <ca9ba2ec-849c-4f86-8ac9-274ac4b5f885@nroach44.id.au>
	 <20260317034539.GA2705965@google.com>
	 <76ed4ac4c86341c5c9168aeee8cd53566e018001.camel@physik.fu-berlin.de>
	 <20260317140646.GC53921@macsyma-wired.lan>
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

Hi Ted,

On Tue, 2026-03-17 at 10:06 -0400, Theodore Tso wrote:
> How hard would it be to add support for the Sparc crypto accleration
> opcodes to QEMU?  Is that something that could be, say, an GSOC or
> Outreachy project?

Good idea. I'll ask someone who has been mentoring QEMU enhancements in the=
 past.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

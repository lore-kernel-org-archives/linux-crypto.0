Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20315F330;
	Fri, 29 Nov 2024 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732867258; cv=none; b=k9fSVN/coiMlmmdJREQd7ycGLSPVr2sKm2nAOAN1iVKcNchbKON6qyAhnFTDO9bblz89Lj4oTVlYua28NUfE5a+3iMeFEPcOXflXoeE+9oUW3fHTPIXgcf8fdSieej7TQIE26GMWaQjZS62FmRE5l0879fBjEHaMEaupZBfUBlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732867258; c=relaxed/simple;
	bh=c27EDe/Ch3F83JtNc0h/e8gRo94TJxOj9812ouwJRHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXe8iCe++aP2wfQa2G7uga85PEFdbO4mCNHctvw5PTQngKFQaWtWBf8sU4UmaFG6qd4h5bofLidkllpVWG1/CPN8Qqjfb4clZvy4MziI00JjaFmdasB3SZCP5ab8hd8Lf7sD5u9SdvBxctczbOFQ6Tgg/xEqizGcHD7Hmoc1M0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 491C02800BB9A;
	Fri, 29 Nov 2024 09:00:48 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 29B0F31EAD5; Fri, 29 Nov 2024 09:00:48 +0100 (CET)
Date: Fri, 29 Nov 2024 09:00:48 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Zorro Lang <zlang@redhat.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next/fixes] arm64/mm: Fix false-positive
 !virt_addr_valid() for kernel image
Message-ID: <Z0l0sMgZPWpMlBXn@wunner.de>
References: <90667b2b7f773308318261f96ebefd1a67133c4c.1732464395.git.lukas@wunner.de>
 <CAMj1kXFvJGHr_iv6bFQfb89XqPFrNWH7-rV7SFy4QBSWXYC4RA@mail.gmail.com>
 <CAMj1kXER7AbNyUDjtij6Ni0jVRMg11xvyhkCMKAxaKbx=dsgcQ@mail.gmail.com>
 <Z0RJaU4wjU5WeQb4@wunner.de>
 <Z0RWcgrQASMIleRn@J2N7QTR9R3>
 <Z0SOZhtJohCNxX6_@wunner.de>
 <Z0SVYSew0gIgSdAe@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0SVYSew0gIgSdAe@J2N7QTR9R3>

On Mon, Nov 25, 2024 at 03:18:57PM +0000, Mark Rutland wrote:
> No; I meant that the test could use lm_alias() on the test vectors
> before passing those to sg_set_buf(), when the test code knows by
> construction that those vectors happen to be part of the kernel image.
> That'll work on all architectures.

Herbert doesn't want callers of the sign/verify API to do the mapping:

https://lore.kernel.org/linux-crypto/Z0A2W1FTTPt9PeI5@gondor.apana.org.au/


> That said, looking at the code it appears that testmgr.c can be built as
> a module, so the test vectors could be module/vmalloc addresses rather
> than virt/linear or image addresses. Given that, I don't think the
> changes suggested here are sufficient, as module addresses should still
> be rejected.

Ah, I hadn't considered the modular case.  Good point!

Thanks for the explanation and for taking a look!

Lukas

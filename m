Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000536DA00;
	Thu, 10 Sep 2026 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054857; cv=none; b=lV13L181xmVLsNDF/7EHIkfH9bG5WWt/bWJox9QJxXEn15un8LdrSOjgayZ0uU5v0IAHwMvJpNIGTz0RFWVUPfauiI41DT0lVQUOhgTY7BBGzMpeDcHyFlgLXyFXY8VDttbbsJDnwa0qJc3DGdtafaslSKSbMWa9/CRlGwU5sQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054857; c=relaxed/simple;
	bh=zLZhcdz43NUrZIZASgPkE6Q4DKtvuzt/ZbbWtBdOLRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duQUfnOPGK9SRy3F8jNHuJGfwsOgHP5/5Fmz2Hzle9sTYQE7F8eYs/cMIbsWHk86FZlsECiGzOowLIx2Q8PAUzQv2ip80VTdhHd0MrTSNINu2YzD4uZpq/WZdaXB4ZgTPsB9Rur749GRjvRBhVmGCr7Oh4vkMFC3uuGFn6UB+MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fzrEWeGZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fzrEWeGZ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CAF5640E0320;
	Thu, 10 Sep 2026 15:40:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4Vby3mrPxHxu; Thu, 10 Sep 2026 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789054841; bh=gp2teKxKliqTw5kfDWAHhiXM2zQQkqngJBZCjBMNz/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fzrEWeGZ+mjqz31Tp3NNB3bvCfEl1HRu6UlhRBSzXPz1FSFRQOtFvS7CJjv1dpUnK
	 71ZnStWglj/s9fwU3ukQCmgk8x1K4c9IUV1QsiGuwWXHbP83U66iYDXxqVMp9fzQWt
	 v2TjH7qf6OEu1AL3a2rWYdBTBBENG+l2OpWp+Di3D85TxmoKttn80lslrbSYxE3Wtp
	 DXh/D/vmK9D+X4zbsFzqilv/cSPBefH+/2DDGIX7XxWtJRLDjLbF/JEsEAFR0RWhuv
	 dQ8AZaj6hC9GVXqEuoJA0UXo+r5SGslhdTsmchDZeD3C5x7KUn8TOkBElIslSLBknR
	 1Df6I8CjFm2ivlp7R6Ouvb8FrtPcePIn4BZWr/9egCWM5SWHQYF50kyIAK3u+SLmSG
	 KYZHdkNEU5cBI0BIIJZzoAgkfCQsKw1qGRul+TSdPWTWgLYu2Tr1g5fPDR8zZ0ZIsW
	 ZBBlS6R8cPt3wooD9ttXpPwR7yq7klJ1NhMpL1TLJBWJdkw4oV6kJYbOp8XgPeLGn3
	 EmTF92p4d0Swg7Pq4+cRglMPFZnlnnS0VTkDEaCJTwurxrS2G6Kd0NHBjL7LsX8MZl
	 zQtt/JccGm0y9k+571whocVfxbf7uLqvBkBNJ9i/VwEv2BNrBcvZhBghB8uJsuTG9d
	 kDR1wj5Kvf3W538EhVYzNi6g=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 391DE40E01DD;
	Thu, 10 Sep 2026 15:40:30 +0000 (UTC)
Date: Thu, 10 Sep 2026 08:40:26 -0700
From: Borislav Petkov <bp@alien8.de>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 00/13] libcrypto: Provide more __cleanup functions for
 zeroizing data
Message-ID: <20260910154026.GBaqLPam9ofZoyiDCR@fat_crate.local>
References: <20260910124138.417439-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260910124138.417439-1-thuth@redhat.com>

On Thu, Sep 10, 2026 at 02:41:19PM +0200, Thomas Huth wrote:
> v3:
> - Don't put function names into ``quotes`` in the last patch, so the
>   cross-references will be generated right now.
> - Added a missing #include <linux/string.h> in the sm3 patch

From: Documentation/process/submitting-patches.rst

Don't get discouraged - or impatient
------------------------------------

After you have submitted your change, be patient and wait.  Reviewers are
busy people and may not get to your patch right away.

Once upon a time, patches used to disappear into the void without comment,
but the development process works more smoothly than that now.  You should
receive comments within a week or so; if that does not happen, make sure
that you have sent your patches to the right place.  Wait for a minimum of
						     ^^^^^^^^^^^^^^^^^^^^^

one week before resubmitting or pinging reviewers - possibly longer during
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

busy times like merge windows.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

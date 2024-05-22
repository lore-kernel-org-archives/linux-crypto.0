Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693917483;
	Wed, 22 May 2024 03:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348805; cv=none; b=XhoEh1mSLmFmMdd6p2bB0t+Bap1hDe6apDbb0Lr059sQcFvXOw466LlCBHW1BJXE3Us+q1kp4cRCYrBZNVHWyURG7DPt/QC73hxnPQgKmGlNNhuT6FxIe3N1vVq9FAqvz6OCwG2ncv1jrMofE5yhj2l4u4sVzu+Syc3xmJ0SYyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348805; c=relaxed/simple;
	bh=qDJ3Rq11DxABpJzaKs8tcvplDGGzzrro/h06hy+ZUcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Svn4yr4mqWwt1fXPm67yh5Lm+gS7Q41+PD6jW5/BEH2+gNYGJ1GkkUGsWxAezu/6sgz8MT0EA60WEi39izYf1YRpSKd2GSbag2vQbVTv9M4UWTq0bKnFH799fOUuvXRvr0rZnQTsNlaex92R4wrrc0jCnA2orQaGBPgB7JjwCDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s9ciD-000mdM-0o;
	Wed, 22 May 2024 11:32:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 May 2024 11:32:22 +0800
Date: Wed, 22 May 2024 11:32:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 01/49] crypto: x86/aes-xts - Switch to new Intel CPU
 model defines
Message-ID: <Zk1nRlPLeqeNn6X5@gondor.apana.org.au>
References: <20240520224620.9480-1-tony.luck@intel.com>
 <20240520224620.9480-2-tony.luck@intel.com>
 <20240521172202.GFZkzYOh0pET7B1SFW@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521172202.GFZkzYOh0pET7B1SFW@fat_crate.local>

On Tue, May 21, 2024 at 07:22:02PM +0200, Borislav Petkov wrote:
> + Herbert as an FYI that I'll pick up this one and the next for 6.10 as
> it is a fix for a regression that got discovered.

Thanks.

> On Mon, May 20, 2024 at 03:45:32PM -0700, Tony Luck wrote:
> > New CPU #defines encode vendor and family as well as model.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

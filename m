Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BE9185B5E;
	Mon,  2 Sep 2024 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725318476; cv=none; b=MVgSRdTvX4NfSg264MxaVnKYKya1jdQeb04bBoeZZlQEzK+rkWe9GReSdAbRFqbn+zAoYTy5f9KVIpalo84CxCVi1C0CJ6w4EjkXlfFeHlTJgdHTH58h2WhrliqaAiqLqQTRn4LT5TfKAeJpV4oIB/ZNF7TgD0urufbD1atbspQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725318476; c=relaxed/simple;
	bh=MkGrQEN+r2oK6c1bibPW2ZYEWVgkIeAPUMcLKtqT+MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSMw6XZPbUGThhy6cfgIgVEs5/jmhAaewI6Kl5fo09lSivNvWAINZuFKVmAIAL480wIyhKOd+iVT8VKBx9K2mkVbqpCF47MHOFVy1ydzJ4yz0POc8/csIDelwplSlb9Lh/9XDhIy8YMkM6ef0dAYzF2biOnr2TbI6cYsDLwwR6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o3gReQAg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o3gReQAg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P7VTnzFqJqA6t2/V8liDLaUZHtWEMYfizrv2jlrTN4A=; b=o3gReQAgQ+v3ItksVUrIaIMz1s
	p/9veE310MquUShUNkNMDoZAyIiFahXYIWMDhyfXFl24O0wlu6KGAWPdp+7zI34IsYy1fj4yby38L
	QgUwMRNw7hWWWk6CVsTLq51vwS53zVKZ5cNfbO7zOXBWdR1FnNZFm6yXHtMcd8jeeSwV+488JEtCG
	+pwyhg4hu1uLKAaDGbkEoGOR7E4l+zHZWlg40jxBom3K1prowRvz+Vf6Yh+6vU6B03JsKXEkNO0Qm
	imjduErLG0pf0mjGsjriE8ThIJ+cgED30h38ZfVss16JepuKsEI8qv83Lf24OlvqtpoaP4q1KDZnJ
	CW1BbfvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slG94-009Cnt-2s;
	Tue, 03 Sep 2024 07:07:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Sep 2024 07:07:38 +0800
Date: Tue, 3 Sep 2024 07:07:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <ZtZFOgh3WylktM1E@gondor.apana.org.au>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902170554.GA77251@sol.localdomain>

On Mon, Sep 02, 2024 at 10:05:54AM -0700, Eric Biggers wrote:
>
> With both this patch "crypto: api - Fix generic algorithm self-test races" and
> your other patch "crypto: algboss - Pass instance creation error up" applied,
> I'm still getting errors occasionally, e.g.:
> 
>     [    5.155587] alg: skcipher: failed to allocate transform for cbc(sm4-generic): -2
>     [    5.155954] alg: self-tests for cbc(sm4) using cbc(sm4-generic) failed (rc=-2)
>     [    5.372511] alg: aead: failed to allocate transform for gcm_base(ctr(aes-generic),ghash-generic): -2
>     [    5.372861] alg: self-tests for gcm(aes) using gcm_base(ctr(aes-generic),ghash-generic) failed (rc=-2)
> 
> I can't follow your explanation of what is going on here and what the fix is.
> Would it make any sense to just revert the commits that introduced this problem?

As I said earlier, these errors are expected.  What's happening
is this:

__ecb-sm4-aesni-avx gets registered (but not tested)

cbc(sm4-generic) gets registered (but not tested)

__ecb-sm4-aesni-avx finishes testing
	with lskcipher this is equivalent to crypto_cipher sm4
	so it triggers the destruction of all instances of sm4

cbc(sm4-generic) gets marked as dead

cbc(sm4-generic) fails self-test because it's already dead (ENOENT)

It's harmless because whatever that is asking for cbc(sm4-generic)
(in this case it's the extra-test mechanism) will simply retry the
allocation which will then succeed.

I will send a patch to disable the warning when allocating X returns
ENOENT while we're testing X itself.  This can always happen if X
gets killed for the reason mentioned above and it's perfectly harmless.

It's just that the race window was tiny previously because testing
occurred immediately after registration.  But now we've magnified
that window many times with asynchronous testing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

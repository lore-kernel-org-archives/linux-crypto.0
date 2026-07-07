Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16173416132;
	Tue,  7 Jul 2026 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430489; cv=none; b=q6FMXHPbJHFE6Cp4ixfwhAUbMm5/rJVaDX1Js3Ke4ElrMd9HiVg2bUZHpqQd8sFGbyYNoeiNnVK4KCT9C7YKwKfCpt5pHk8EXSav9tHiLI+ZzD/w0VmRVpbqZHYyLB3LmvVu0BK9r3cY8p18w3a3mu0nPr7QTViUlMU55Hk/rdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430489; c=relaxed/simple;
	bh=aTI150TJIrCiFSkMzkGJnHBZn+tFIQP7mzFfIPu4Tkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0VPr0kMl/M9b40n/bcnRIkr0tJpAzTrXy9PrrameTgYJ3q4zwLWxCW27dBha0qGUoDV7VX5XYYmk+Jh+qrDDYI9SNASXgaDSc0PWBX1MMOgPsABTIk7DgAKlOJ9YNM+aTvQcT/IzJHMIMap4OBwLVmjrUs4FVt9tpEx3+l/5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=T7mYdosi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="T7mYdosi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=My+KPg/qXh2P4MUPP32y367LOETlt/nlmXRd1cw9Rcs=; 
	b=T7mYdosiQhUuJZLvgw/3p2c6ZEQ0BrELzjDCGitCFs2FUo7cchdr1PaaCFpe4EFhB6sOUvKz8qd
	eF45+AkKPwhP2lyiBWAtNbS9fNoMEACEk4tVP2SYkc1vsm941UvKFFx61rqkI1q/4a7i8DGesBmA2
	EDyQnysDCIfKNg+Doj/yp9sI1gcKg+2jjxOcKM2joDTndMEOvrrx5dFlCjMROMRfasFHtelZGkJ7F
	Pm5/0cSLY8SfbhPOsOhfa5EIcl3BdL8K2dHXlT1Z9y7mqkaOQLqt+Zp8o4s85bqwjBs//Rc9gwgfJ
	0ht27yljz4+pkR4bkAL4pfYSZjHBcKwT3zkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wh5jH-0000000BPKS-1vDg;
	Tue, 07 Jul 2026 21:20:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Jul 2026 21:20:51 +0800
Date: Tue, 7 Jul 2026 21:20:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Christopherson <seanjc@google.com>
Cc: Atish Patra <atish.patra@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Peter Gonda <pgonda@google.com>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Youngjae Lee <youngjaelee@meta.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	John Allen <john.allen@amd.com>, clm@meta.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Atish Patra <atishp@meta.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Fix possible deadlock in SEV init
 failure path
Message-ID: <akz9M0mBGwHW08aZ@gondor.apana.org.au>
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
 <20260602-sev_snp_fixes-v3-3-24bfd3ae047c@meta.com>
 <akdUUggmSSS1a0IW@gondor.apana.org.au>
 <akvvTFUAI9tjOXRh@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akvvTFUAI9tjOXRh@google.com>

On Mon, Jul 06, 2026 at 11:09:16AM -0700, Sean Christopherson wrote:
>
> Want to take patches 3 and 4 through your tree?  I'll grab 1 and 2; there's no
> dependency between the KVM changes and the crypto changes.

Alright, I'll add them to my tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

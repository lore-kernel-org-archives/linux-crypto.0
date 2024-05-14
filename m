Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD7D18E11;
	Tue, 14 May 2024 06:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715666565; cv=none; b=TBeA2hDq9y0cpnwgxsWlN3ASobYuU7/Vr3gCNpw2PteI+LcF4MKGetYmJvHWJjm5UGhlK7EGuYNYmGRV0ppnF0gCXbgb46ivcNwpaV6wMtZv4YcC34GOq8+WQWG0hzhw6Y6XmZLcVwGbpdjfmm7vh9B70KJyqzqJTXs15orRxzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715666565; c=relaxed/simple;
	bh=C+fA/HPt9R8hW4MRIgOb6Fk7HyLMsbWU6zbumrUaDqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gnOEMWdgoMUrFgejtd7LjVUTrlOw3zRzH6HXMrkBvwDjVvfhZhOuHCvz1/Z3abkhBqE8l0BbZGcqcCly5GFBe6M6RrmnIdF/KT5XIEf/Ias8EDFesnEk6cp3zmnOFkasBd8LuB73tPQXa+aezeSO0UQjpnB+rG/NBYInPO+Ku6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s6lF9-00Ese0-27;
	Tue, 14 May 2024 14:02:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 May 2024 14:02:32 +0800
Date: Tue, 14 May 2024 14:02:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.10
Message-ID: <ZkL-ePdM2bpMIZl7@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <CAHk-=wjmwmWv3sDCNq8c4VHWZUtZH72tDqR=TcgfpxTegL=aZw@mail.gmail.com>
 <ZkLz31t6ZJmbsj3o@gondor.apana.org.au>
 <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi1T6wq1USBfU=NjdpSaTiKzV4H2gnUQfKa_mcXqOSk_w@mail.gmail.com>

On Mon, May 13, 2024 at 10:41:58PM -0700, Linus Torvalds wrote:
>
> I suspect that because I removed the whole 'assume()' hackery, neither
> of the above issues will now happen, and the code nwo works.

Alright I'll let it stay and see if any new issues crop up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

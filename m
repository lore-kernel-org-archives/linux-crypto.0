Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6646428151E;
	Mon, 19 May 2025 14:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.236.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747664437; cv=none; b=LTVg9jOt5CF4Nnl+9LjonkBL6RsLWzuIFjOrbt7NrH2Hconpyt4HkYge9ivE7FWXvKBIXkyd+E3HoiFTdpyJUyHr074Sgze8qFuaLXoDPTn5YYV79xJavJcAYUO3rK+NPGktDTwwJ39N0oujnuv3H3o3hgP1EyV/W3pO2QbvA0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747664437; c=relaxed/simple;
	bh=QaTcfMhaqALXzJmEgyxGZWJ+zYjWOFxFsUrYOmwRYdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QRDNWesYfbWnbwg+GD/Vaq73txQzJXDqsTCzPtQCG2uFUi2da04B49aaKpptpAOpmZeCl5UelGNLxIYHigpnn+eB22b+pMoeVl7qzEktZ7C3pv/mQ0SX7h3LsEPOFhJjj/oYHvxkh4wgIFAsc/MPQvrDrvUR8z9+B6iDM1in62Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.236.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
	by localhost (Postfix) with ESMTP id 4b1K2Z0j89z9sgR;
	Mon, 19 May 2025 15:55:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
	by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T1tLa2scvF_G; Mon, 19 May 2025 15:55:34 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase1.c-s.fr (Postfix) with ESMTP id 4b1K2F3Z3xz9sl0;
	Mon, 19 May 2025 15:55:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 74BA68B767;
	Mon, 19 May 2025 15:55:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id ERUmtIadJGXE; Mon, 19 May 2025 15:55:17 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id AA9E88B763;
	Mon, 19 May 2025 15:55:16 +0200 (CEST)
Message-ID: <02c22854-eebf-4ad1-b89e-8c2b65ab8236@csgroup.eu>
Date: Mon, 19 May 2025 15:55:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 naveen@kernel.org, dtsen@linux.ibm.com, segher@kernel.crashing.org,
 stable@vger.kernel.org
References: <20250514051847.193996-1-ebiggers@kernel.org>
 <aCRlU0J7QoSJs5sy@gondor.apana.org.au> <20250514162933.GB1236@sol>
 <aCVNG2lm9x9dzu6x@gondor.apana.org.au>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <aCVNG2lm9x9dzu6x@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 15/05/2025 à 04:10, Herbert Xu a écrit :
> On Wed, May 14, 2025 at 09:29:33AM -0700, Eric Biggers wrote:
>>
>> I didn't notice that.  Probably, though I don't have time to review this subtle
>> Poly1305 code.  Especially with all the weird unions in the code.  Would be
>> great if the PowerPC folks would take a look.
> 
> Of course more reviews would be great and I think they're all on
> the cc list.
> 
> I did test this by manually forcing the conversion, which is how
> I discovered that powerpc wasn't even using donna64.
> 

As far as I can see related patches found in linux-next tree were not 
sent to linuxppc-dev@lists.ozlabs.org.

Could you resend them, and split out the introduction of 
CONFIG_ARCH_SUPPORTS_INT128 from other parts of patch "crypto: 
powerpc/poly1305 - Add SIMD fallback" and add the lib/tishift.S in the 
patch which adds CONFIG_ARCH_SUPPORTS_INT128 ?

Thanks
Christophe

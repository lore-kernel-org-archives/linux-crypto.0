Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E297FA94F;
	Tue, 20 May 2025 05:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.236.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747720235; cv=none; b=aHFhjeqFFexi84TPuFkJcAezcaqN/I1X6h8tiUl3bZm9EEGPRwHgdGI4/JhBHgMuh2ykUeDjuuqeMdzoysGWKFdGmuCWCGV6L8Uy4CGXkJZtsJNXirJuw0nuq4fKgJW9V4xTExcxMY/iFr/y6U15enIEDAlktbSjgJI8L22FMQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747720235; c=relaxed/simple;
	bh=HpJnIaQxNCrVPEddwkzry03hhfHcD09CbAvopBDF+rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D1YMEGzmH+TLjsTAH9zeOu7hwuy+SgqpDiMZmQnN346PYJyICeFgKW5H8ctZjjA9wFXWWcwkgpksJQPW+yy4DwNlBRLH5+Ukl+mpt5os0+nCRLmWqCbOvsiRkWNQy0+Xix9itjJaDG0+EfnJ4S9WJsG3QP9OHR9kRT1dgL3dJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.236.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
	by localhost (Postfix) with ESMTP id 4b1jVC1shBz9sWb;
	Tue, 20 May 2025 07:17:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
	by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DBxSY6Tt1GUC; Tue, 20 May 2025 07:17:23 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase1.c-s.fr (Postfix) with ESMTP id 4b1jVC0pHqz9sVS;
	Tue, 20 May 2025 07:17:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 0A9598B765;
	Tue, 20 May 2025 07:17:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 6gA5yYbrJAGp; Tue, 20 May 2025 07:17:22 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 71E518B763;
	Tue, 20 May 2025 07:17:22 +0200 (CEST)
Message-ID: <633eb665-d1d4-4433-b81f-8ff831cf795c@csgroup.eu>
Date: Tue, 20 May 2025 07:17:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, naveen@kernel.org, dtsen@linux.ibm.com,
 segher@kernel.crashing.org, stable@vger.kernel.org
References: <20250514051847.193996-1-ebiggers@kernel.org>
 <aCRlU0J7QoSJs5sy@gondor.apana.org.au> <20250514162933.GB1236@sol>
 <aCVNG2lm9x9dzu6x@gondor.apana.org.au>
 <02c22854-eebf-4ad1-b89e-8c2b65ab8236@csgroup.eu>
 <aCvp1rzh2vV9L4g_@gondor.apana.org.au>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <aCvp1rzh2vV9L4g_@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 20/05/2025 à 04:32, Herbert Xu a écrit :
> On Mon, May 19, 2025 at 03:55:16PM +0200, Christophe Leroy wrote:
>>
>> As far as I can see related patches found in linux-next tree were not sent
>> to linuxppc-dev@lists.ozlabs.org.
> 
> I just checked and it was definitely sent to linuxppc-dev:

Oops sorry, my mistake.

I see them in patchwork, they still have status 'New'.

> 
> Cc: oe-kbuild-all@lists.linux.dev, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Danny Tsen <dtsen@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>
> 
>> Could you resend them, and split out the introduction of
>> CONFIG_ARCH_SUPPORTS_INT128 from other parts of patch "crypto:
>> powerpc/poly1305 - Add SIMD fallback" and add the lib/tishift.S in the patch
>> which adds CONFIG_ARCH_SUPPORTS_INT128 ?
> 
> I'll just revert them and mark powerpc/poly1305 as broken.  You
> guys can sort it out later.

Fine, lets do that and make sure all necessary bits are there when 
enabling CONFIG_ARCH_SUPPORTS_INT128

Thanks
Christophe

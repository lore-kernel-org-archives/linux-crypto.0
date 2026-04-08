Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0E4224B04;
	Wed,  8 Apr 2026 09:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775640889; cv=none; b=aaGLJzr91Y9N6AtAGwHCD1fZDIdWiiW87ge6+qAkM9a4805vx7/aPlFSHiJ1opC7K2aV2eAhTHFH0xvBQhWbq12MaBPbYe6YxBAaKE0eagh+FxcvpRp5f+r10JPdyZUP9b0yQ3W5vEGzghgmMwgqUBpiiVRxbIn5lLG2fIFevO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775640889; c=relaxed/simple;
	bh=R/b1bc5OVvwE31LlF+wFK+5d+Ru91KTenrJH4/xCRr4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgaWfyFmY+wmBiYr8Rc8e8nhg2TO7Cl1MILyMTmRjovHRtpL760NuGuIUV4Z1Yt1gePOBrtM0SBysUKcMkOlA1ulUdFRxendN6mNdFJkFu1ghyds5Xteib+JBmJKSvlFHlw6jq1SNqgKmdyQbWqyohEsBOQ+WkIzl0PmInHt9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=ymtEqxe6; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="ymtEqxe6"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id F2BF020728;
	Wed,  8 Apr 2026 11:34:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AbnceWvLlMfr; Wed,  8 Apr 2026 11:34:46 +0200 (CEST)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id 21BA2201D5;
	Wed,  8 Apr 2026 11:34:46 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com 21BA2201D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1775640886;
	bh=zS79HN+MwePvO/pYvOblADFlSrM4jAhkaN0vzpnyOS8=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=ymtEqxe69DCmzevK5Ljizo2/qDSyJgxcb9M4EGhl2jM5po49jngpcItxeADk2mAd1
	 GPdwysYdHLIeXsgjl8OVk8Rlf7zrZlmHwapuUKWRoEeoe2mJeTe0k7u8YnFG+PlpEn
	 PrbZslM/YrlOghjS1u3Om/dtKhFA03FUG4pM8vnb7IO7foyQkZH1hC8AWH+hLdqYW+
	 nkkKGCuoa2dVWzUMn7+TohzR+xZxFpMwRYHxn22bq7SK6Zv2yBeQAIYwWKS/7Noo+j
	 Q5OTu6x0TUsGOgoei9FG2DlP5UM9RwLpsqg3RPcBO/JkpPShGtV/suoh+qE4ku+mcx
	 5Ojrkn30wNGEg==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 8 Apr
 2026 11:34:45 +0200
Received: (nullmailer pid 95933 invoked by uid 1000);
	Wed, 08 Apr 2026 09:34:44 -0000
Date: Wed, 8 Apr 2026 11:34:44 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: Drop support for HMAC-RIPEMD-160
Message-ID: <adYhND1MsLgR1ZLg@secunet.com>
References: <20260405011513.64909-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260405011513.64909-1-ebiggers@kernel.org>
X-ClientProxiedBy: EXCH-01.secunet.de (10.32.0.171) To EXCH-01.secunet.de
 (10.32.0.171)

On Sat, Apr 04, 2026 at 06:15:13PM -0700, Eric Biggers wrote:
> Drop support for HMAC-RIPEMD-160 from IPsec to reduce the UAPI surface
> and simplify future maintenance.  It's almost certainly unused.
> 
> RIPEMD-160 received some attention in the early 2000s when SHA-* weren't
> quite as well established.  But it never received much adoption outside
> of certain niches such as Bitcoin.
> 
> It's actually unclear that Linux + IPsec + HMAC-RIPEMD-160 has *ever*
> been used, even historically.  When support for it was added in 2003, it
> was done so in a "cleanup" commit without any justification [1].  It
> didn't actually work until someone happened to fix it 5 years later [2].
> That person didn't use or test it either [3].  Finally, also note that
> "hmac(rmd160)" is by far the slowest of the algorithms in aalg_list[].
> 
> Of course, today IPsec is usually used with an AEAD, such as AES-GCM.
> But even for IPsec users still using a dedicated auth algorithm, they
> almost certainly aren't using, and shouldn't use, HMAC-RIPEMD-160.
> 
> Thus, let's just drop support for it.  Note: no kconfig update is
> needed, since CRYPTO_RMD160 wasn't actually being selected anyway.
> 
> References:
>   [1] linux-history commit d462985fc1941a47
>       ("[IPSEC]: Clean up key manager algorithm handling.")
>   [2] linux commit a13366c632132bb9
>       ("xfrm: xfrm_algo: correct usage of RIPEMD-160")
>   [3] https://lore.kernel.org/all/1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Applied, thanks a lot Eric!

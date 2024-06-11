Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EFF12E61;
	Tue, 11 Jun 2024 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718137141; cv=none; b=Dc3Ipx4aAB8RtTRoq+agM0Rq3pjM8PQfmAt3y9x7Hbl0yDRm5Y9rCtzWopCksAHfA+sAvC3M6u7WANsuCAw5g7ZB9HR7Q3ciZGbXupZfv2Ed+S2MN1vIWBy9zNRwInISnY7Njx+xsSP6BdW4BQO5/bQOJ6zBI3lJVlfOfMBq/cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718137141; c=relaxed/simple;
	bh=gtTMkJYRvzc11WF2seK68wjURAdaNya0C5PddHKpdUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4pjcRsxja/dpEZIlpe8F9dCEVRpXHB7ATRTXFge6iKFemz+HKQF3xTD6WLj1DQQnBT42pe8gujseZNYM+Bw8ZquS1BUemu77NNnxoBITlOMIpjeWEh/1jSitG5nQUkI/a+lr4pB4SCBd+CzTpdYfywiurcFTVCg0X2y5GqMyEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tg4w6+Jd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tg4w6+Jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4D4C2BD10;
	Tue, 11 Jun 2024 20:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718137140;
	bh=gtTMkJYRvzc11WF2seK68wjURAdaNya0C5PddHKpdUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tg4w6+JdHhFxJdi4TnsqqM/VB92iMDH+/U5LYjnE2oucxYyHNoYL6hd/t2ucaGpqi
	 MoMgRkjwlMDaMU/QbFTds8e7j2TTxvqa7GWcWpN0QZuhI4R7S15A4YpMi+GXeIkju8
	 ONuWoutk4kJTocbsp41zeLdPmpRfeldqNLgZ6RNufQ6kcR6Jo2FCvN2+7f0gd2ZktV
	 a+mLDeyfRdQtGhbuQI1i7YJoVZ38wME27wLvflfJjcFKA3eMCh/QrUUjWcRoymhZ4a
	 tPfpBeKRwt8nI9jOk4zvQl9T9nTOUaAl+M4rkU88SYx6HpP/b0s79oC+teD4onsnwP
	 xzSfHlcvR7rIw==
Date: Tue, 11 Jun 2024 13:18:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240611201858.GA128642@sol.localdomain>
References: <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
 <20240610164258.GA3269@sol.localdomain>
 <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>

On Tue, Jun 11, 2024 at 11:21:43PM +0800, Herbert Xu wrote:
> 
> BTW, I found an old Intel paper that claims through their multi-
> buffer strategy they were able to make AES-CBC-XCBC beat AES-GCM.
> I wonder if we could still replicate this today:
> 
> https://github.com/intel/intel-ipsec-mb/wiki/doc/fast-multi-buffer-ipsec-implementations-ia-processors-paper.pdf

No, not even close.  Even assuming that the lack of parallelizability in AES-CBC
and AES-XCBC can be entirely compensated for via multibuffer crypto (which
really it can't -- consider single packets, for example), doing AES twice is
much more expensive than doing AES and GHASH.  GHASH is a universal hash
function, and computing a universal hash function is inherently cheaper than
computing a cryptographic hash function.  But also modern Intel CPUs have very
fast carryless multiplication, and it uses a different execution port from what
AES uses.  So the overhead of AES + GHASH over AES alone is very small.  By
doing AES twice, you'd be entirely bottlenecked by the ports that can execute
the AES instructions, while the other ports go nearly unused.  So it would
probably be approaching twice as slow as AES-GCM.

Westmere (2010) through Ivy Bridge (2012) are the only Intel CPUs where
multibuffer AES-CBC-XCBC could plausibly be faster than AES-GCM (given a
sufficiently large number of messages at once), due to the very slow pclmulqdq
instruction on those CPUs.  This is long since fixed, as pclmulqdq became much
faster in Haswell (2013), and faster still in Broadwell.  This is exactly what
that Intel paper shows; they show AES-GCM becoming fastest in "Gen 4", i.e.
Haswell.  The paper is from 2012, so of course they don't show anything after
that.  But AES-GCM has only pulled ahead even more since then.

In theory something like AES-CBC + SHA-256 could be slightly more competitive
than AES-CBC + AES-XCBC.  But it would still be worse than simply doing AES-GCM
-- which again, doesn't need multibuffer, and my recent patches have already
fully optimized for recent x86_64 CPUs.

- Eric

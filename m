Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307641;
	b=JP20t+lfYAAEeu1O/DYznySKMYFklXWnwOVo62/jqX2Zn6kd4fI6O2cZAnOKlc7cC3zG
	 /+/cWi1CLOvpL4QdvNDDNWN24h+f/uQZdoO/IrZmRu6ChMjvQldHulQmzpvOBdRlO1clu
	 NLUsjtYkVPuUc1GB/JfSLUoXFcNDKMvXqSXg5Tz4ap5nQUkX5l7Au4QumFVdtgnopz2zy
	 cDPO2PC9i80N76Os+24/XFfRg8ZCi+VqDDOQbjl+o4xMyD4Gs45ZvEYa4y2ecWNYxGqKT
	 DCbrYVivdNX+TIZ0jM0ENJqidjUoPhnIMTgFxATV/EGt4FoDPDICNAN5RoaHCbDJW+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307641;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=qIWE6Q4QhfMAoFSaQSmSICX/bModQ3jDHts65+ZYthU=;
	b=lFnWI1S5rc1JyX7DNdStMFtZIoDcN9YkCIScKevm8YdpTWVkGjZFyz+726RilOBXgmRB
	 EbVbrnbfTp0vX6CO7QHvDZ08IcGQHcMFoOzj2VK8X/K8DUvtYJCGdGN2AWm8LFNqDDQ9W
	 /jvn9RniOa2njYI4AQSgHCSK/WFrvaWkT63fjgvfmsFbd5EIAK8EgHPa5Smwwhz62Jrdm
	 Pb56T/2sWsly58eozapYjn6/05NbXefy86tm7bgtQNDRskJ6Ch4veULCSkaKmh2gql8Q0
	 +RjniPaRXJjS8s4gBmbDiK7aWk+p2nlqqO4bTeQ8oPZG5f0AKjAIJy7xqyfmWP8ORAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJ16e0wJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5E6606A31C;
	Thu, 29 Oct 2026 21:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJ16e0wJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C7B1F01816;
	Thu, 29 Oct 2026 21:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307640;
	bh=qIWE6Q4QhfMAoFSaQSmSICX/bModQ3jDHts65+ZYthU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FJ16e0wJmz698MK6cm6TBBbIK5DQDFd7eU7PxKXstYo50fmoSpTD/aE12/50jsmC1
	 LvAJi9K6O0VLKKwuWd4QBnf1W6JxQcb5yyxM9SFbb3GhHwLhK1QizDXLz0PiB4HvX9
	 Z4pobueWpo7WLxl+iHrppgqgcYCV2i1IdKMWiLTMCoDLvuv3pWGGPtHFStmiiHJMMp
	 6d0gQ8ODxN8Zh+WEsg9cOVklhYdLjYz3QZTpSWQAiUISiaX0F9ygdsP5w3Gn+VYSvc
	 BF1Iks+sAsVsYLWc46JL2NyJqlYr9+e21rSmjCdPn7MfTqFYJLj2PVEi476Pfw2PwH
	 8Yl1XEX/QT5fg==
Date: Thu, 29 Oct 2026 14:00:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.1 1069/1887] crypto: jitter - replace LFSR with SHA3-256
Message-ID: <20261029210038.GB49373@quark>
References: <20261028170459.200466217@linuxfoundation.org>
 <20261028170523.734746721@linuxfoundation.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261028170523.734746721@linuxfoundation.org>

[+Cc linux-crypto@vger.kernel.org]

On Wed, Oct 28, 2026 at 05:52:45PM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stephan Müller <smueller@chronox.de>
> 
> [ Upstream commit bb897c55042e9330bcf88b4b13cbdd6f9fabdd5e ]
> 
> Using the kernel crypto API, the SHA3-256 algorithm is used as
> conditioning element to replace the LFSR in the Jitter RNG. All other
> parts of the Jitter RNG are unchanged.

For some reason this is going by on stable@ without linux-crypto@ being
Cc'ed, which is itself grounds for a nack.

But also this commit had known bugs that were fixed in follow-up commits
such as 735b72568c73, 908dffaf88a2, 9aa7e045f4af7, maybe others.

Now, these changes were all to the known-problematic and little-used
"FIPS RNG" instead of the regular one.  So, ideally, it shouldn't matter
much.  The thing is, before v7.1, certain things actually *did* pull
from the "FIPS RNG" even when the kernel wasn't booted with fips=1.

So pulling in known-broken commits to it is a little concerning.

- Eric

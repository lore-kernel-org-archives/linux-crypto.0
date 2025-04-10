Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F2A1EB1A1;
	Thu, 10 Apr 2025 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744327883; cv=none; b=sxze7uQ5mriffe6g+3iTKtpl/m1gwSGugGzvrBoWJ/4VRDg/HGSGKfeBg/d+xOcNoI2NVhPfksmUhFfoQwQZNQDFufXUhwvfNW6xnzUUXx5NMzcaIlfg3AdL4zKF9HwVzbxB351NlrtB80lTRwAw+wdz13EvxFqcic9jV/jocgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744327883; c=relaxed/simple;
	bh=0Vad+E3w7U+JnMUzlV2hA2BHgUo7/l3ew51N/EPhyc0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BL0QLwpNqLKeCLk3yDQu6xGB2C6o2/trdlmR/+UEfo8Yh4CrWRGp4g1nnVePWCZ94zuYzd1lU9AcUCY8lCfgLwoZLIlrEhdnHjaP6xLLTNNugxuvqMJbRtrIVTQeVYKbHRZIxXV/s6/YAmQRwFK9ukz0tt8CYamAFxHCdWSUOJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3YDSXNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3YDSXNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFFCC4CEDD;
	Thu, 10 Apr 2025 23:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744327882;
	bh=0Vad+E3w7U+JnMUzlV2hA2BHgUo7/l3ew51N/EPhyc0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h3YDSXNjdYnrn2Jp9zAIzIESVGSpxRDPMQNcNfsvkmoPZ8TgwQ/OuAjs+bvtGNrOj
	 fSeOhwm4flzim0UQRMX755MnuQLUXjK8b6KVBoRhCelg2CWtTLRjteAY/noy6d3UoP
	 SBFXvk59bnSL2PMyg8mpGO5ShsOsP/rGtqBZhPbs4vp1C9uJs9bS2NgcolxXzjw/1B
	 o9FlYQZsoHB2jyqBaV68zYU8W0VdGqVdEfSuLU64wl621AV4YTfgPbsqnajUSGWB3d
	 MypUPhcd9bGO6wSZphj8iBZ9vGnxjQDd36RdRzdtdWIPnl+JQ2SwtunwkaxFcKKT05
	 uqc+hRXj2Wcng==
Date: Thu, 10 Apr 2025 16:31:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Christian
 Brauner <brauner@kernel.org>, Chuck Lever <chuck.lever@oracle.com>,
 linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, Herbert Xu
 <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next v2 06/13] rxrpc: rxgk: Provide infrastructure
 and key derivation
Message-ID: <20250410163121.04d56770@kernel.org>
In-Reply-To: <2099212.1744268049@warthog.procyon.org.uk>
References: <20250409190335.3858426f@kernel.org>
	<20250407161130.1349147-1-dhowells@redhat.com>
	<20250407161130.1349147-7-dhowells@redhat.com>
	<2099212.1744268049@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Apr 2025 07:54:09 +0100 David Howells wrote:
> Good catch, thanks.  That path should never trigger, but it should really do
> "ret = -EINVAL; goto out;".
> 
> Do you want me to respin the patches or follow up with a fix patch?

Sorry for the delay. I was hoping you could respin and maybe fix/give
up on the annotation in patch 3? Right now patch 3 gets flagged as 
a build warning which terminates the CI processing before we get to
make htmldocs. And it would be nice to get that run given patch 1.

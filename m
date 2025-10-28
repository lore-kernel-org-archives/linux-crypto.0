Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07E320010A;
	Tue, 28 Oct 2025 11:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761649708; cv=none; b=UPHB1M1QAXQmFhZfRbj1lFes077yZXevs19mUErRG3Wp2IJdGOp40QNtAoJb05gtI3gXHYPMFYtCE9cRz/18wmdY9aX950TUAixCiV8mDounehXajjr9AZM8FogvCoe1DO/X58eN1fkuRkm/qc9XjNCKvOZmNRKed1SupOfHHss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761649708; c=relaxed/simple;
	bh=i9J39zRR2eSSGPRLPdRg/y9QnDj/mpqjN//j0CsvBZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYgDugwd9ToS4qAp7ukzlxPOT6l+HJMV/W6WxImvCEp1P1RBioZaUn+b9y/jpC52g/wH0wiAMxamJWOC1d7wUwiBxYBfNREUBz+pbqxamNhTslG6ISzBRyLM8igQksNn8x2UBsTbxq1TNeq75DThYTBFObqHhqhbgHbUaf1m1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKl6eLS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKl6eLS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AC4C4CEE7;
	Tue, 28 Oct 2025 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761649708;
	bh=i9J39zRR2eSSGPRLPdRg/y9QnDj/mpqjN//j0CsvBZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PKl6eLS9n2tXk5yx922cD6aHdzZH0CCJuKHe7NpZ1W+HnudzsXpp/ktr2sEqL6HLP
	 Wqi1FQg7p94phkO94LB5AuGzpo762yUNkr7Bwpgp2jqr4pLqrpb5kGKxazFIPnGjA6
	 KbrVdiROkcDpK+6S717C6QLHrZvpjIVCBFz+x/pgmZjtuMAyfCg/bdswVcgNfZ7htx
	 gxyTNAGBaGCd92ntjKRl3VpHBy41ohcYDx0DmvmNAevwhD836mTfQWuVLoNOEJtJf7
	 ElgZewuy0hU3yRp/qoHuCmoAOxT1B3qwvxqyjWECCoHonuH6Gd39MLO2G3gTpX3qKD
	 5iBMaWaIRQ4oQ==
Date: Tue, 28 Oct 2025 11:08:24 +0000
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, herbert@gondor.apana.org.au,
	bbhushan2@marvell.com, sgoutham@marvell.com,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 01/15] crypto: octeontx2: Share engine group
 info with AF driver
Message-ID: <aQCkKB-0ocnvM8II@horms.kernel.org>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-2-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026150916.352061-2-tanmay@marvell.com>

On Sun, Oct 26, 2025 at 08:38:56PM +0530, Tanmay Jagdale wrote:
> From: Bharat Bhushan <bbhushan2@marvell.com>
> 
> CPT crypto hardware have multiple engines of different type
> and these engines of a give type are attached to one of the
> engine group. Software will submit ecnap/decap work to these
> engine group. Engine group details are available with CPT
> crypto driver. This is shared with AF driver using mailbox
> message to enable use cases like inline-ipsec etc.
> 
> Also, no need to try to delete engine groups if engine group
> initialization fails. Engine groups will never be created
> before engine group initialization.
> 
> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

Hi Bharat and Tanmay,

I realise that this patch-set already runs to 15 patches.
But the 'Also' part does feel like it belongs in a separate patch.


...

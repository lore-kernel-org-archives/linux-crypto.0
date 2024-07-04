Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550DC101DB;
	Thu,  4 Jul 2024 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720116030; cv=none; b=fzrdDj+3B9m+8zt1oio+ISMlT4exXbTP1Xw/Ce+TU+12fevPjjigQIoSDu2nOTym78f8c8/mCoYi3gwjGfooz/TW9857QrbmPyOAGnP00YFiDdH38tS+rw8HOW6la54X/6X4ooqCedjJTa4vNA8zExk1IHz/cbX77e0c8l5hr2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720116030; c=relaxed/simple;
	bh=7CM7LCzL/FexzNhEv5GX0DgAZg5LMKsi2jK7Gi5eIC4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nntdxPfyOhjIqiUU33BdRw3v2XrM/FThjIjnsTrrBLjMKZFWqaubByVFZIibietS4AdmH2kXXTdV2hcM6STCpzxoVDbAjEiEBE6BcwFRtv5w17oMH3o1kVXKgYJq3yZ2Jk6udieU2cbjRvsIrNZNVO87UmYhmbHDjHG5CJnZ/Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFxuJQSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFxuJQSG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC16FC32781;
	Thu,  4 Jul 2024 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720116029;
	bh=7CM7LCzL/FexzNhEv5GX0DgAZg5LMKsi2jK7Gi5eIC4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rFxuJQSGu4WBvXc43cqzFG6wic7ngA2MyGRm46FspP+as0YNbNTFK9QRPfmlDC7L/
	 2WgckPwYVVEmed3iBZhmDByLvNHHQS04UL+Ow/w8t8PZjbI/hScxAXXnOJbJ2rcIaT
	 v6Fph2lLmTVLdOz4BBmVpepm8g8WJkegZpLm0spNBsB5JKJzteN878iKvUvhMkJA60
	 a1FQy+0g6voH52HSx+h73CD+QZpfjcKsOb8FylIGHS7fhS93YFqdox75BVqPtdq9SU
	 KwsIIZjrVUjlpPYkPDrpBRSxU0uo7TpKkfIdY+o6fDVtvuocpgAGGKtPAOc3RIb304
	 20/+ve1yHTgPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7EF5C43331;
	Thu,  4 Jul 2024 18:00:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] crypto: caam: Unembed net_dev
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172011602974.29043.12028718630944239259.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jul 2024 18:00:29 +0000
References: <20240702185557.3699991-1-leitao@debian.org>
In-Reply-To: <20240702185557.3699991-1-leitao@debian.org>
To: Breno Leitao <leitao@debian.org>
Cc: kuba@kernel.org, horia.geanta@nxp.com, pankaj.gupta@nxp.com,
 gaurav.jain@nxp.com, linux-crypto@vger.kernel.org, horms@kernel.org,
 netdev@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  2 Jul 2024 11:55:50 -0700 you wrote:
> This will un-embed the net_device struct from inside other struct, so we
> can add flexible array into net_device.
> 
> This also enable COMPILE test for FSL_CAAM, as any config option that
> depends on ARCH_LAYERSCAPE.
> 
> Changelog:
> v3:
> 	* Fix free_netdev() deference per-cpu (Simon)
> 	* Hide imx8m_machine_match under CONFIG_OF (Jakub)
> v2:
>         * added a cover letter (Jakub)
>         * dropped the patch that makes FSL_DPAA dependent of
>           COMPILE_TEST, since it exposes other problems.
> v1:
>         * https://lore.kernel.org/all/20240624162128.1665620-1-leitao@debian.org/
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] crypto: caam: Avoid unused imx8m_machine_match variable
    https://git.kernel.org/netdev/net-next/c/9b5c33b1a3b7
  - [net-next,v3,2/4] crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
    https://git.kernel.org/netdev/net-next/c/beba3771d9e0
  - [net-next,v3,3/4] crypto: caam: Unembed net_dev structure from qi
    https://git.kernel.org/netdev/net-next/c/82c81e740def
  - [net-next,v3,4/4] crypto: caam: Unembed net_dev structure in dpaa2
    https://git.kernel.org/netdev/net-next/c/0e1a4d427f58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



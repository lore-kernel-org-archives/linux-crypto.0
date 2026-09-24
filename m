Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCC21632E7;
	Thu, 24 Sep 2026 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280082; cv=none; b=U7Gv2w9zWXs9Zk+yJ9Dq7TwYjN5T/pI8fbdvTaxZc/JQGaarO3p2rCEOHqSM87sxloMeHFwXKTF7BasRg6AqOew1U4q3zBv9dGBDDbAfgcOkwjQxgHepZSvublQYxFyxPo+9nI9OVWPnom+lKz0GAieURPdzuBRorNCLOl7lwsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280082; c=relaxed/simple;
	bh=xmcuLD3NTU4WHCa4CzhrFe5pgMsJjGWnOTkMnh156uU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RlfoBKC+enrjIA70qPmGEP9LzT7qfbLXJMkOEXjOO4Zi51sUxCuf0stxZIPE00X/ZiwyEUT+Eq2X1b+aDpTO3fFTjKwc0PrGQH0QVdTefKh/oXlRuWuXXUa25ynWPIGUeX+vos5C/5/VAly/bLZ5E/EFM4xPQxSPdD8TZxzQn5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFgCv4n9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFgCv4n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AC21F00893;
	Thu, 24 Sep 2026 20:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790280077;
	bh=4gAD+z28Mjehi+HRzS6v0ju/TBEp/Xh6+EpIaUJhZeA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=KFgCv4n9aMG8PMNRMmZRhzp29O/jGEVUhY6KE99FhKaW2rFne74ixBsfcJKMWC66o
	 Q8VdR0sCUc4KNZmuBMwF9tNa4Z43ZGHKmIRMVp05mPwnVV3jnpNioj3+E92v8EqUR/
	 lodd33fobpzMSuB2vH3kKU/ZoOV6g2elGhTveQQlmb8n24f0EDQvG0eTM49a/6dG9U
	 OW7mZnr9KxPreIBr51Sk1RW+LpM4iHchlY6RtBmIH+WnBi4fxM1clnnZ3PuIZqqamM
	 5zT+wmVuxp3IfUeQ3H17J1fFgBFbZpsnyIPPP0gWkcETtBPhrmESceXM4W89HPzNsa
	 f/+bvh0EP4d1w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09E73A566E4;
	Thu, 24 Sep 2026 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5] bpf: crypto: Use AES-CBC and AES-ECB
 libraries
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179028000639.2177981.16327703943696079557.git-patchwork-notify@kernel.org>
Date: Thu, 24 Sep 2026 20:00:06 +0000
References: <20260924184254.142720-1-ebiggers@kernel.org>
In-Reply-To: <20260924184254.142720-1-ebiggers@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: bpf@vger.kernel.org, vadim.fedorenko@linux.dev, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev,
 jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev,
 john.fastabend@gmail.com, kmehltretter@gmail.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 24 Sep 2026 11:42:54 -0700 you wrote:
> BPF crypto was implemented using the lskcipher API, which doesn't seem
> to be going anywhere.  lskcipher supports only ARC4 and block ciphers in
> CBC and ECB mode, and only with unoptimized implementations.
> 
> Library APIs also have been found to be a much better approach, for a
> variety of reasons, including reduced overhead, greater flexibility, and
> having to be explicit about the crypto algorithms that are supported.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5] bpf: crypto: Use AES-CBC and AES-ECB libraries
    https://git.kernel.org/bpf/bpf-next/c/d5c101840af8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



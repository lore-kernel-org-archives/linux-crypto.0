Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657323C73E5;
	Fri,  5 Jun 2026 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780672228; cv=none; b=DmPJ5zGSYETpPX5mY0d/gyXBZWAKXfy5VijiPiLrN2LiiOjapx8GfLz/Zyl/pBV5kQUj022vSEeA54iqm++UJaDTW/bRlZwwEcAW46QLv00WLZEzJD9agWg2tj9n1cB7ssEmeelrzX6Av9Gd0xODMFMTUjIQ51hZ2sVPlp2NmeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780672228; c=relaxed/simple;
	bh=+44rknf9POmsbTO3YJaOJjrIrp1KTt5t6L0xUpx1d48=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=J7YbThWFsKRHBheQQWivOWaBgmREoCjglqjBF5dwYrQ8+RMcp/CiCPC2idLjUhVagjwfA6/YP8EF9gTG+CrPzSbnqtJykwqkzXgFIVu0aXC+afmzOuGrAIQtEoykl+q9Amfko0hEh71gaZYPEDv3foKlM9Xk0fIa9kgI3fdMsRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrPorASL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrPorASL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0413A1F00893;
	Fri,  5 Jun 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672227;
	bh=bNiYy2YfaQcMsJTyZlifLww+uLEb+yP4a6jCsMOj3Sg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jrPorASLeRpkOPGO7F6vrxY3NuV5wyaZAPTEVhTDu5EEptrx4tn6qYXP5/r1Xsk18
	 FmPLL2je9581h59q6RZNYph0vPTUODEmY5QXamdacqcMVRXB4/Kru42DAwBVjwN7t/
	 vZNtb9tMeAsnQ9ejx4EkDa51LHvpCl8zluey4wMxFfm6wtj1HRoLWD05ldv8w4LqhP
	 MsFMwIk5oOl+H/RpU24RXVrq2TFQvUYA8alRjMXo11ExxTiOJhXjgMHuteNrjL8KEC
	 M378Nd9x3VqDYrIGlM9mL8u+KqxCR1nm7Kfs+Y6qKq0n49abtFH6xnPbwQ7jcmECiu
	 NuuaGkxD1ONiA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93D333930BA1;
	Fri,  5 Jun 2026 15:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rhashtable: Use irq work for shrinking
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178067222714.3794367.10286050193642059000.git-patchwork-notify@kernel.org>
Date: Fri, 05 Jun 2026 15:10:27 +0000
References: <aiDgUPXZUi-jnTdo@gondor.apana.org.au>
In-Reply-To: <aiDgUPXZUi-jnTdo@gondor.apana.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mykyta.yatsenko5@gmail.com, bot+bpf-ci@kernel.org, bpf@vger.kernel.org,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, kafai@meta.com,
 kernel-team@meta.com, eddyz87@gmail.com, memxor@gmail.com, yatsenko@meta.com,
 martin.lau@kernel.org, yonghong.song@linux.dev, clm@meta.com,
 ihor.solodrai@linux.dev, tj@kernel.org, linux-crypto@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 4 Jun 2026 10:17:52 +0800 you wrote:
> On Wed, Jun 03, 2026 at 02:08:25PM +0100, Mykyta Yatsenko wrote:
> >
> > For v7 I'm dropping automatic_shrinking, because it adds a risk of
> > calling schedule_work() on element deletion path (__rhashtable_remove_fast_one())
> > when hashtable size drops below 30% of the capacity.
> 
> Now that expansion uses irq work I think shrinking should switch
> to that as well.
> 
> [...]

Here is the summary with links:
  - rhashtable: Use irq work for shrinking
    https://git.kernel.org/bpf/bpf-next/c/46730ee6e884

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



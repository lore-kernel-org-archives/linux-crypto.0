Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA0219F49B;
	Thu, 15 Aug 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730934; cv=none; b=HX6BvvoJO5WEP/y7JGGx15FYW7iYCFwZQlyN4wU7m6Mli+PBpFXg1LphyRDvbpW+3m+wGlGtzZPz6ioxk1PuTXf+wIyTTdaK0UvRZs2hc18lTHpgz2zj1osYxC65IC7iTwCWGQROpZICXIpjjwZFFCCG6oRObXTbrzRcw9CEVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730934; c=relaxed/simple;
	bh=6J7/nbBGANAtqTMijx3LW7jLQZcKylk+IT8kHzyQfuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1L9WyRpGdr54ogM54gIknDaGhlun7raurDX+CQyPweNE3bZqICiNqNqdbHlhwPl1SJuETHHl/9XoT25/vFwqHGOD8aVSJ1wJPtmiTfGPdrRvRQSHRme45zSgctSwmfgCQZJEY4oygqy+cqgqcM6wqWJtTr3VUDTZTm6DVp85mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=hr3j+aCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hr3j+aCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0405AC32786;
	Thu, 15 Aug 2024 14:08:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hr3j+aCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1723730931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q7Qe90W7d8OXonZG2Y/sUz0TFsN4GjLdPacQQ4g1UkY=;
	b=hr3j+aCltqdA/f5x6s5ggxLKx93bVRr1k3y5zQz/bOo7rT7DHQr9lNE/MMgZxnwaTCNs8k
	gYsFAqQqG8BsfKcsCCN1nwYi++lGoeFC+FMkyu6wfDr+oIzFQxCWtNiSYewgKNRsocc+l3
	PEF9LGDcr41/xsunDzsU9FPnF+UBr3E=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aa72d43a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 15 Aug 2024 14:08:51 +0000 (UTC)
Date: Thu, 15 Aug 2024 14:08:46 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
Message-ID: <Zr4L7qj1SxVnkMC0@zx2c4.com>
References: <20240815133357.35829-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240815133357.35829-1-xry111@xry111.site>

On Thu, Aug 15, 2024 at 09:33:55PM +0800, Xi Ruoyao wrote:
> v1->v2: Remove Cc: lists in the cover letter and just type them in git
> send-email command.  I assumed the Cc: lists in the cover letter would be
> "propagated" to the patches by git send-email but I was wrong, so v1 was
> never properly delivered to the lists.

The `--cc-cover` flag is what you want, or set sendemail.ccCover in your
git config file.

https://git-scm.com/docs/git-send-email/en#Documentation/git-send-email.txt---no-cc-cover

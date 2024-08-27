Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E954919ADBE;
	Tue, 27 Aug 2024 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724766891; cv=none; b=Duvw4F5CVxFa2VHBZN+1NIC+sdp4K+8LhSUq7x/+SKLKwKrhPCa3xQcf0Tf/Po5xPwy3l5EdNfiwSS/6KJcF7gJPjweU5o0LUGM06iwgtzpb8/CAVjeAYrdeGGfXozCb4W8tlXPTHt108TR9zvIg0QYmLy5AnbAkEFqIb8UzfAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724766891; c=relaxed/simple;
	bh=DWRlIH00O/5rtxW583DKV4bMto5Yzd8c0t//b3Xzsfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEQ1tYt2Jj831kS9Y248mz819G893Y1rgTxjnGX7GesKMx6DM3UlTEO7lIveqsQLpYvNzhMVg+Y5QyqbNETD8kdKh+muUYNI4mILMFbsZZRcC0fXtwFG8DKSHaaEy7+RfxGKmLMIgQL+RRZV1k7eqk5bSojjzv31jpaSNIzRZcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=V4e51nzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="V4e51nzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3399C61040;
	Tue, 27 Aug 2024 13:54:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="V4e51nzt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724766888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ruJqG1luFWdVSSRr3qCFOVtA3TtRdOO478zw2WgTrk=;
	b=V4e51nzt61NBzSEXuaf/87U7cZwLadOtIeXXNCIqWx6B0Zfl0zkilyo5afwdaEc3gOixGi
	CONsdpwRQj1tMztOuOZBHHle3FyHDgs7k4iukv9sxUuSXsVcBeORc6vQWi4YDHNW2evpaz
	SstnY3JYoDGJn7RaVG1ekJ1zfgOs690=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6de812c0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 13:54:48 +0000 (UTC)
Date: Tue, 27 Aug 2024 15:54:42 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/4] selftests/vDSO: Add --cflags for pkg-config
 command querying libsodium
Message-ID: <Zs3aoj7X6Ardjey4@zx2c4.com>
References: <20240827132018.88854-1-xry111@xry111.site>
 <20240827132018.88854-3-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827132018.88854-3-xry111@xry111.site>

On Tue, Aug 27, 2024 at 09:20:15PM +0800, Xi Ruoyao wrote:
> When libsodium is installed into its own prefix, the --cflags output is
> needed for the compiler to find libsodium headers.
> 
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>

Thanks. I applied this one to random.git. gitolite.kernel.org is down
for maintenance at the moment, but it's in the mirror on my personal
server: https://git.zx2c4.com/linux-rng/

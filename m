Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3819ADB0;
	Tue, 27 Aug 2024 09:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724751940; cv=none; b=RX13CTw/wK2pyx1qijh1BmQm1RA/Ig6+jgo2fBsRNwNQMhw5MxIs2uwLeMbnt0Prv22DrD9oH5h6FuDXjYRiC3v/sxdXFihRNtfAtfxkUo11qKkIx5gA8cB5PttWkMlNVrnZmLDSNfr4sQfwsFoFi02b1Y4pM7OdKBhuElCXp68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724751940; c=relaxed/simple;
	bh=eVclaBJ2YxjTVTaOSTbmAnw0uz4jKUu4DqgThpqOVSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6wpw9DOIz37+RpSG6rqPop3m77nFE1Y+JA8c5nhbwsjs4Tgu3dQYCObOn8rxZ1gBROZ4vKeHyb11inMoX/s185EdGqDdk18Y2Jdvp4rqgpsl5I3KpVDxNlaZh/MkxaN87vhJ4Ny92smZuNGFq5cs/gUBnPoBlvBSETCrSK/zJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=caeQWXgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="caeQWXgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC586C8B7A0;
	Tue, 27 Aug 2024 09:45:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="caeQWXgN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1724751937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVclaBJ2YxjTVTaOSTbmAnw0uz4jKUu4DqgThpqOVSs=;
	b=caeQWXgNoSnvlrNwSSAl9nDQtEgPn3bBXDq8o5gn1N4Vsm04CP8AWk2HGYIQzMNDv5qcdq
	EdthTkWpCfF5SjJTVU1SohO2gJE28IVfBv7rJjCEhqtEDSixWUFLmpZdv62Lok4ZcAlLnX
	+/MRHP4ZxCjpJoFfIlmnoInaSx6WorU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aa222d56 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 27 Aug 2024 09:45:36 +0000 (UTC)
Date: Tue, 27 Aug 2024 11:45:31 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re:
Message-ID: <Zs2gO0NQwOuK8Bmu@zx2c4.com>
References: <20240816110717.10249-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240816110717.10249-1-xry111@xry111.site>

Hey,

Per https://lore.kernel.org/all/Zs2c_9Z6sFMNJs1O@zx2c4.com/ , you may
want to rebase on random.git and send a v4 series. Hopefully now it's
just a single patch.

Jason

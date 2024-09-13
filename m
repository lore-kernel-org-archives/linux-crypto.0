Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2052239FCF;
	Fri, 13 Sep 2024 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726240414; cv=none; b=pa7BchfswlEpQK/Idh4IJKflNr7Euq0H057vRH2DEQ94lmakrMgVr1FODAHvavqDq4QS0oppvusSlaBkKlOoHlC7Ij/qpGU1x7I73J0fSbKZVt9tCZxQW0DFwZnQQ/DuL+sXWBhZ5Pq4byIRvS0wRY6i1eUs+WPa5RQ7HxszIRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726240414; c=relaxed/simple;
	bh=xCSBTryq6bwQH6c76v53KWQS5iDgMkcugOpLLrQm/ZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hdp2ZedFrQypzPgCTBvvXKxx88fGbOVcsJmNpPEcb7XPPcpGv/PEkcjUcrLvz/w02glrVEUGrBOIDxo1rWJXGfTXPuuVCCAiZLE77sHAZ/Dx2Ph1GMIza35uX+cxXZgJQV3Ir4qpAgZsV3KV1WtNk6Ro+qx9o90/Ww3x/6HYFSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=HwZiHfYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HwZiHfYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74517C4CEC0;
	Fri, 13 Sep 2024 15:13:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HwZiHfYd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726240410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RF+0+HwIqqe8mBdx6xhoiSWm3aYBzJOERThEiOJHBdM=;
	b=HwZiHfYd1Qsj+4g0Pk4hNmdxqKGGgC8Mt4g8W2oHCFr9OCl5nrcp3nn/T60ezvuLkOPqXk
	Q6L4efv3XSudrNj4+s3d/UPiy66YEo+TsQzMaL/JL9+epxNlL4+8Pq6eMKdN/X61qvJnOp
	Eezapw9vOitT48kPtvEftNOk7ft/fMo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 632065ec (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 15:13:30 +0000 (UTC)
Date: Fri, 13 Sep 2024 17:13:28 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <ZuRWmJTWqmD92D8d@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913130544.2398678-8-hca@linux.ibm.com>

On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.

I'm trying to cross compile this but I'm getting:

  CC       vdso_test_chacha
/home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
/home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'

Any idea what's up?

Jason

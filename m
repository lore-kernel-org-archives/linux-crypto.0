Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16E63C;
	Thu, 15 Aug 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732089; cv=none; b=SQJusKXqEfTH9LxUSzQ9MnhLSYzINc5tMZ70FpR7nVe7Jdp+ZlHGJA6xIzjWfSapXKiLvPFcpjotytcvOeFvFXg6aRNdCm6Cf+LNqVtDp/J/YbQgkkHq/rMnmaq3sr2ExcUHJddAZ2HVVqxv3cAlHwNWzCDz3pY9/e4K0OOMNkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732089; c=relaxed/simple;
	bh=N6//kfETdSZHz4Qqf3/fw4CjEQ8UZmS/LxmRoAM9854=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/IL7r0jDfgKzBdJIAaVtHXKiBvC1980pe6FgZkuSUQ0e9t5btoIIuK3LdcoQqgBsMZ9lrrV6jP7DcxeYvlmBql9pWbVwq/BHIlghnQ7kMHfManonJkjuxFb82zYt2jP+9SJk2RR2fAwMorvwEXS6MgUfHODJEPlxRzNRdLUEYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Bx5SykW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Bx5SykW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88481C32786;
	Thu, 15 Aug 2024 14:28:08 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Bx5SykW8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1723732087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zATbbc6yYiiuh3DPYBd/ighFv+fg7c5nLRUMsvk+jZM=;
	b=Bx5SykW8goRkBfTPEO4Z/OP0rgHRTzUd9ili5LbJxu4Sh1znODsEGH/PlH2vlbiDbaK1wA
	+dvadok62QU10cjXsUwcG9O/jBCFmIcEeDhKJf0/WSo+OY//h4Sj0PDOEFF1dPd9qmAY6q
	OP16e8Oc31KG6dQvpBThCmTcshzChdU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5de9001a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 15 Aug 2024 14:28:06 +0000 (UTC)
Date: Thu, 15 Aug 2024 14:28:01 +0000
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 0/2] LoongArch: Implement getrandom() in vDSO
Message-ID: <Zr4QccFIu4BQOwEI@zx2c4.com>
References: <20240815133357.35829-1-xry111@xry111.site>
 <Zr4K77uPi3CMfE-S@zx2c4.com>
 <eae5ab91ee6a6eb96c397b4ff6470b72e9bf3086.camel@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eae5ab91ee6a6eb96c397b4ff6470b72e9bf3086.camel@xry111.site>

On Thu, Aug 15, 2024 at 10:22:31PM +0800, Xi Ruoyao wrote:
> > so I'll be able to take a look at this for real starting the 26th, as
> > right now I'm just on my cellphone using lore+mutt.
> > 
> > One thing I wanted to ask, though, is - doesn't LoongArch have 32 8-byte
> > registers? Shouldn't that be enough to implement ChaCha without spilling
> > and without using LSX?
> 
> I'll work on it but I need to ask a question (it may be stupid because I
> know a little about security) before starting to code:
> 
> Is "stack-less" meaning simply "don't spill any sensitive data onto the
> stack," or more strictly "stack shouldn't be used at all"?
> 
> For example, is it OK to save all the callee-saved registers in the
> function prologue onto the stack, and restore them in the epilogue?

Just means don't spill sensitive info, which means the key, the output,
the entire ChaCha state, and all intermediate states. But saving
callee-saved registers in the prologue like usual is fine.

Jason

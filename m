Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5807122D781;
	Fri, 16 Jan 2026 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578220; cv=none; b=hC5u9C97iJogLT9onLchwIMA0ugtsGiXrvXiEQSDndL+411+E/ORxw8ibZaCBynE1fSQgX8gGLpMQ+VEpYIPIlCOO9/3CJmW6Qal2Xv+q7yrYh+ew6MmcmMwg//fE60ZBsJ2J0RGt3msE9ejJsiYieqPRGGMP4LEZl4S4X9indw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578220; c=relaxed/simple;
	bh=/Qu6YYe/IkLdLRCC2+zRX38VFiJNRVMn6Z/Q15FijsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XMuqNszxJ/opsyigPrvY4UJ4WRti9M4UyC4a4kncMae/wOORwudXLHEpQyfLf9RaL8B1alYKxfUXor6ruCrgcmMA9D9kV7FXG44/LZ2idrW02vG+U19wyOqcN/q7dDVhsbrpj0z0AMvOdOomR8VfTz1VKtK3kyyAGGHfDIcTBbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnaIU6ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnaIU6ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5F6C116C6;
	Fri, 16 Jan 2026 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768578219;
	bh=/Qu6YYe/IkLdLRCC2+zRX38VFiJNRVMn6Z/Q15FijsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SnaIU6ul73Iy8njRMl2hUuJ78mv2+XiV4/LiZfPdNyAk+APlFVndcAz5fCWVgfvGc
	 AVvIGm7Tj2ZygF1lLSKjoWTNhoWMwBW1z3enpdT9AAahCNqbV9mM1WDVG3OCdmNRLz
	 ObKlJllK7td6Q/hgwlkfGE8aY1YusYef2ePu1eXs=
Date: Fri, 16 Jan 2026 16:43:37 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: zhangfei.gao@linaro.org, wangzhou1@hisilicon.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	fanghao11@huawei.com, shenyang39@huawei.com, liulongfang@huawei.com,
	qianweili@huawei.com, linwenkai6@hisilicon.com
Subject: Re: [PATCH v6 0/4] uacce: driver fixes for memory leaks and state
 management
Message-ID: <2026011627-wreckage-comply-e78a@gregkh>
References: <20251202061256.4158641-1-huangchenghai2@huawei.com>
 <828e0dcd-ae17-448b-ba33-97603031fc60@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <828e0dcd-ae17-448b-ba33-97603031fc60@huawei.com>

On Tue, Jan 06, 2026 at 10:38:46AM +0800, huangchenghai wrote:
> Kindly ping for this fix.
> 

Sorry for the delay, looks good, now queued up!

greg k-h

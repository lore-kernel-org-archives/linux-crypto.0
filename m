Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C97D8AD;
	Tue, 12 Dec 2023 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHqUPE4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C50C433C7;
	Tue, 12 Dec 2023 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702404239;
	bh=KFxrU+XIaTmYgFM6JiVW7oqbgm2QQdzND412ropUAdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uHqUPE4wITcHBxzyxIW15KMdIuzxEKfuOxb4wI8+KHsd6y5SVqI7wXylwzrSHrA3b
	 fvzG5tZOLYECQsRbMAoZWUlVlfUbx2SYamv8fRbveXRDEbSThpfzx2Q5ESQ4/01xvS
	 w8SPjPRJN1+vFnYIztVgW3Z0OeHcDiKwjQL4ZxlKsklTrXbr3+egjucasKWhy3f64L
	 J/54So2u8iXTPQrAFHWCKcDNal1ln3JCinI2HOZ8nd/6IsLFs7dSu4vM/GBfbRP0Jy
	 Y06QJCkXO1sTuduxSw8Rb7tYKAQcupUSowI7naQ/1SxhS8/MXiepP+LwPcOqlydOv8
	 iYQo4S4OxTpAA==
Date: Tue, 12 Dec 2023 10:03:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Srujana Challa <schalla@marvell.com>
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
 <pabeni@redhat.com>, <edumazet@google.com>, <corbet@lwn.net>,
 <sgoutham@marvell.com>, <bbhushan2@marvell.com>, <jerinj@marvell.com>,
 <sbhatta@marvell.com>, <hkelam@marvell.com>, <lcherian@marvell.com>,
 <gakula@marvell.com>, <ndabilpuram@marvell.com>
Subject: Re: [PATCH net-next v2 00/10] Add Marvell CPT CN10KB/CN10KA B0
 support
Message-ID: <20231212100357.452dff35@kernel.org>
In-Reply-To: <20231212051730.386088-1-schalla@marvell.com>
References: <20231212051730.386088-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 12 Dec 2023 10:47:20 +0530 Srujana Challa wrote:
> [PATCH net-next v2 00/10] Add Marvell CPT CN10KB/CN10KA B0 support

I'm not sure why we're expected to take this via netdev.
Looks like crypto stuff.

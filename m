Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C9F379EFF;
	Thu, 10 Sep 2026 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050705; cv=none; b=kEXMfGVOA7ySzbWRIsrcwb/T14zFzOD64gbX75dCKzMXjFuutzNGAKPoL9h3isVA7JSCUfngC0XjEBRn1YVmGZuvU/yKbVHn+uad426lb5uT4qFX/zoPLwH+eeayDK99BLAqLVbmhP0blN7+/Eagr062gNDwxgtxZEeBNAZIyYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050705; c=relaxed/simple;
	bh=81unJ+xQyS1OZb5YmgrJ3wNJT2SEsGfgy/M5SCM83tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qapP86diSyswiSj1Rt5skSeLppj5wW9MwrlA72PvkJNcYLIbTsXHrKSyA7+NCaFoe89yOUODDmV2B51+saWOOPSpd4As4WrdmULy0xFnAOFaOyXe7QYctHMyuA8kZICpbkz5qN5NG00TgqrruyXqN8rMWK+WvXWEE/9RC6Xt0T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbHucjfl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbHucjfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7591F000FF;
	Thu, 10 Sep 2026 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050703;
	bh=IHpQOlYMRC0zl6HC0wXJzTXHYh3YXpTlJwbTQW1CZSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AbHucjfl82yRXnxQtW1Hovmw/+O4DJ0t/9Bo8dOZvngq/2Q5XoVD7WBB+GEOh7DA4
	 U55kTpyd2DiJ1R6E/kxkBNN1P72RJiWBxJmCI7U0ksxMdEt5i25KvE6A44zYgxo4Rm
	 PB6RHFKcyeOQWKYqaQzbCUsLVx5GVWBUkPlk1cd1BRcNitLKApD0iIVqQcgoykzkto
	 Zc8ltAJkIY9PTJuUUKeWeJ8I/HZWkT+0yG+dJL8oY4Mr27lLTJOCnTz42Ms7vCF87K
	 FzrJLbSQFf9zuIybQkJrdXMHAXgoZjR8+DGj+D59wcmItS5dmmlxSvvVUhvFzMcI9Q
	 WZhqgDv3GDJGA==
Date: Thu, 10 Sep 2026 09:31:40 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org
Subject: Re: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
Message-ID: <20260910143140.GA5719@quark>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
 <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>

On Thu, Sep 10, 2026 at 03:00:50PM +0200, Bartosz Golaszewski wrote:
> All self-tests now pass.

Have the other bugs that were reported been fixed?  For example:
https://lore.kernel.org/linux-crypto/20260723202704.GB110634@quark/
https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
https://lore.kernel.org/linux-crypto/20260723205342.GC110634@quark/

>  	help
>  	  This driver supports Qualcomm crypto engine accelerator

As this patch would make the kconfig option visible again and would
result in everyone running "make oldconfig" being asked about it, it
needs to be fixed to accurately document why anyone would want to enable
this option.  As you've stated, it's actually just for "testing".  The
false claim that it's an "accelerator" also needs to go.

- Eric

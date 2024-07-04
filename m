Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAEF28689;
	Thu,  4 Jul 2024 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720113536; cv=none; b=KnmiW1B4GsRVqt4PJ6AIS4QO/Lf42wFBYLJ6ENvcBw6eqRXOqRF2mXcHu2q/68ExWn9H9l6NU3ITp/XiRS1WOOtqMyRgzzn4c9Wiwm+ZxYu0YVy/qiaeLdVlh4Mxgc+/HV1jmn8W4lmv+oJ8I85JnMyP7ZAsRQpQ1M23TTbNeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720113536; c=relaxed/simple;
	bh=jy3MlrkXfIxa1ryQ6DT3vwurPB+Lgox4T1h/YphFWa4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PN30lEpl7AOT3Ce2qVoG/iYUQjS/DS6ANTUsVPO/J1HAq3geGQ5plNbmN6CgG9tgDSuVw7Jr7lnXRN+N9ZhLxXe+pnhDsLjsWAuBWmXyqmAbQDoqS/iSCRtVYiuK3wx8TalSa7iKzLIJOmzp5qVto4dSQ8zwae7zTW9wnj4bJ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vOMOXjWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vOMOXjWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D378C3277B;
	Thu,  4 Jul 2024 17:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720113536;
	bh=jy3MlrkXfIxa1ryQ6DT3vwurPB+Lgox4T1h/YphFWa4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vOMOXjWy8e4W5zkYb1+r7xaTH5Xvh1ns0N4jxrz7x7HwHTnbjPh+DegODox1x0AJE
	 +Jr2C/ZF2NMZD6KP1VWObgdJWlFN/QU0stT/unPU28f/xdAmEPPCiMdtt4VktwtmH8
	 KpIMDyncqNIj7FgikTlgNl0uCAijIjjhhpgepGDw+PxTNuIQ4i9h/d4nP223yWhhET
	 N6kaajeWKiABuCy5b6eWIXbBtu6M/znUFEMhG4VUDb8BGPb41uuIodUxzj6P+0SP90
	 kahF3UXv473Ru365jNrjLH0lLsEcxrSqUwp7DB9J6R+KsMj2eLkdBFk6giJKVoFTAa
	 qxC5G2yiAwV2g==
Date: Thu, 4 Jul 2024 10:18:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, horms@kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] crypto: caam: Unembed net_dev structure
 from qi
Message-ID: <20240704101854.1aceef76@kernel.org>
In-Reply-To: <ZobKod5Fhf1kvLp1@gmail.com>
References: <20240702185557.3699991-1-leitao@debian.org>
	<20240702185557.3699991-4-leitao@debian.org>
	<20240703194533.5a00ea5d@kernel.org>
	<ZobKod5Fhf1kvLp1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jul 2024 09:15:29 -0700 Breno Leitao wrote:
> So, if alloc_netdev_dummy() fails, then the cpu current cpu will not be
> set in `clean_mask`, thus, free_caam_qi_pcpu_netdev() will not free it
> later.

Ah, sorry, I missed the clean mask, my eyes must have pattern matched
the loop as for_each_cpu().

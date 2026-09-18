Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E73284690;
	Fri, 18 Sep 2026 09:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789722311; cv=none; b=SOVFbU0pwIuKIPFoXYbm0F6/ZeJ/5KidKzVXMGc22BUmv5oLRPPTB+v3ilDu/lhjlk0VfKFW/hA/z3e8/mcOwf57ISD35BrGADlAR08VMoSNLrfAMsqFzePJk4njgpu07FVrWzEyJPNHVONROPT79LnRmt8I+6OabffBfFW+nyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789722311; c=relaxed/simple;
	bh=u28tuNb84Mmoot7Z7G7SRMZ5ktMchIZvbMs9ubiYvcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7dP+k03rUZZf/p+X7mrPekp9IaSQTUmnG4oJXVJ3FTMkZZw/FEoxKbiBHqRfIvg5tCMmRSA6ceASLe6N9cBPWxft83rDs4UT8/MFif9tO0pOQbMlSROPz6rvyaScyMOxAw4d5uDrCzJlwCkMB4IdpvmpfeM3cPugBF48i3QhEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=awWVxhdj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="awWVxhdj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1IlrN+s20+y2y+w9UGZ4pNprdasnckf6fAZuQ63Lnnc=; 
	b=awWVxhdjy+thszO3Pa9Z7cLtO5N6N2JprSrIbhQ73OwekP/zAEpXSn4qNeEfRPpMZ4NsTSJzUmX
	9tCdEsgqFHTN4posS95XySkZlyVroGBb3k5zytfmzndBqUGlPL+LvY4tLtMQoH82Wn4quzvk8x/AG
	2uRjE49FEOBl4eu/UCinlJeNxUoktgFBWOMj4xdpKD5SukBQbMy/6xlZQFW0+2+3/VxCGiXMsfnJW
	YtTOB/sZAN/gXZ+fxVmsjBUp6NQgNopYtASyKBfS2du4bnP6YdLUBYWzTQFQtyqOx2aEHVP0C4/sy
	PtGl4OoBGIiR4eXUSTwVxE9KjUmClKJ4k3Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UWj-0000000FKtG-2ZZJ;
	Fri, 18 Sep 2026 17:05:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:05:01 +1000
Date: Fri, 18 Sep 2026 19:05:01 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: mcgrof@kernel.org, russ.weight@linux.dev, dakr@kernel.org,
	ashish.kalra@amd.com, thomas.lendacky@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
	aik@amd.com, tycho@kernel.org, nikunj@amd.com, michael.roth@amd.com,
	shansinha@google.com
Subject: Re: [PATCH 0/7] Implement SNP live firmware update support
Message-ID: <aqz-vc9IPCkYHYfc@gondor.apana.org.au>
References: <cover.1789059391.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1789059391.git.prsampat@amd.com>

On Thu, Sep 10, 2026 at 05:01:55PM +0000, Pratik R. Sampat wrote:
> Introducing support for live update on AMD SEV-SNP platforms via
> DOWNLOAD_FIRMWARE_EX.
> 
> This patchset is an extension of the RFC patchset from Tycho
> Andersen[1].
> 
> This series also fronts firmware_loader patches from Dan Williams[2]
> which majorly cleans up refcount issues so that registering the upload
> interface no longer pins the module. Without which having live firmware
> update will cause failure to reload the ccp module as well as break
> kexec.
> 
> Patches based on cryptodev-2.6

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/cover.1789059391.git.prsampat%40amd.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

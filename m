Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D12EAE3;
	Fri, 18 Jul 2025 10:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836375; cv=none; b=Xz2ivfncc4ap5bLDC6bKnY0WSYCC2ivSbY6fPwrno6N5vOFf/Fx8iNJTeZ4SBJx+TfH8cuPPVnKH1S29ZRYyQNGJblYbzl6ls8JnGAcVcApeQXCsgBlRSdeMsuWt376Zyej45Dgf/BS3j43FebHpjsHp+XFwJV5hscDZBmTI9Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836375; c=relaxed/simple;
	bh=6ktc/3FSkqoCokBOcKM439kKpoMqoxB/l7mvYMJLEuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riaOHrT8sE71dp63RAKlpVzPzL/ZXFOvY9LNBHV8okG6b6hIwhH4+OtIpdSOaRBqQQsn8V94fQxOiyGactFXsVpuBexFwULg6tyaJC5rM4nRRzEsPYnebofiiJkXa3zfDte2xgGoiwQYNytP+I0HkSq7RshpSuve4hjt3oyAJeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HEAgY0Rl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HEAgY0Rl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rHrqihAXBWbkD+hNJe9QmyuvcRfGQMrrS8l0OHyFvmc=; b=HEAgY0Rlaa4bpR/jWfqfLLuZn3
	M2+ATfYOBUC9Ml8x5+NSI5LHinIZtAv/YyP3GyUr/pOSmosNGnR1JThvkVtFGQfjiKKLURBEW+JIm
	L0MKAZAtatL8cHfZSG43b+5SniVMEkXM36/5qvmdxvQKi3DtPHb5FzvW7sdITUeHv2qf4xZQ6Qyy/
	70TQrd1VfRUzKR87JxKnzAhJYnp/nW1hqytsA9KTVfp3J2BlNrca/+M0JCDyHpGvaD/JfyizW+Vp8
	qIyf9XJ07SECEpAO+WPd2aO7SnUNFBboMMnAODtKUX2GRwAleVuu7M9CPtBqyibSMeX+E8Sv3v646
	FEmmY7Uw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciYX-007yZy-0x;
	Fri, 18 Jul 2025 18:59:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:59:05 +1000
Date: Fri, 18 Jul 2025 20:59:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
	"David S. Miller" <davem@davemloft.net>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Eric Biggers <ebiggers@google.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/80] crypto: Remove redundant
 pm_runtime_mark_last_busy() calls
Message-ID: <aHoo-dQpHxX-Lqbf@gondor.apana.org.au>
References: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
 <20250704075402.3217279-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704075402.3217279-1-sakari.ailus@linux.intel.com>

On Fri, Jul 04, 2025 at 10:54:02AM +0300, Sakari Ailus wrote:
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> The cover letter of the set can be found here
> <URL:https://lore.kernel.org/linux-pm/20250704075225.3212486-1-sakari.ailus@linux.intel.com>.
> 
> In brief, this patch depends on PM runtime patches adding marking the last
> busy timestamp in autosuspend related functions. The patches are here, on
> rc2:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
>                 pm-runtime-6.17-rc1
> 
>  drivers/crypto/ccree/cc_pm.c      | 1 -
>  drivers/crypto/hisilicon/qm.c     | 1 -
>  drivers/crypto/omap-aes-gcm.c     | 1 -
>  drivers/crypto/omap-aes.c         | 1 -
>  drivers/crypto/omap-des.c         | 1 -
>  drivers/crypto/omap-sham.c        | 1 -
>  drivers/crypto/stm32/stm32-cryp.c | 1 -
>  drivers/crypto/stm32/stm32-hash.c | 1 -
>  8 files changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

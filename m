Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D304F2F5B;
	Sun, 10 Nov 2024 03:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731210888; cv=none; b=lEWP3v6IQEC8VOvsfXwavLDi7h0atlGz4lTBAHQsoI8f0MlTMsCEIZv5OsMIkX/BRo+ypsXBnMfhLEt5QvXtN+3n3/pLa6ngnl0YCTtckc6DHG8ITbTQZc/ZTHybOq5cwsI85IWmeideuahVn+ZZAlfOA1sPhupk4SE+2rskF9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731210888; c=relaxed/simple;
	bh=U7RSp/hm4quWsG1vq5erxhW0wiR/eP6IV7sTxPdkXns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsN+jFkKx6q79LO+YDPxxP75BSMAl9ILdd8MwNIAQ/jDCBvbifVIIOCq1HqkAlQ76ss+0wJZI/M0pma0vFRLK9olSfomChJGBxYBHgrpL8xodVhyVgLLaWccrKZck3Ii7UG0a/EaWF+drQOSreSE1stLGMT3w4CvKXbZHwTpCB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EnWlkgYr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EnWlkgYr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=n5wC9AfnAdAi+t6gW7YQWtL/DNCHNh9E/uxxFqePCTk=; b=EnWlkgYrQ/DYRVOrB9DyNJP92x
	OT3dsfC7VcFVUrI68wt+6HhPWIhkcqfB4drA4Xepa7hOSBUWav1E1BJ7X4QRutOZOLb27NcM9nihm
	MVDhYNrAFYXSH21dDE1Zl8z0bUF5Bl5BiQb0Nm6mGLqUGzTuPtyA5729x7pZJm+0qwj7AOZGGmMgZ
	JqKRCbDrteOv8tjRXqpM6Mq8juVz7XWr4t5ubR0yADZsVhgWQohqsoB1awP+I/2nTnv7cfSKrryFa
	65GI0rfOc+IzsrSSHZItuV8Q9GomECkjZJmXhEQYzNbNHy88kqdvghNl7IWL8apERwuJ6TIqVQgKl
	mt9cNdkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9z1y-00FkE3-2F;
	Sun, 10 Nov 2024 11:54:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:54:30 +0800
Date: Sun, 10 Nov 2024 11:54:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wang Hai <wanghai38@huawei.com>
Cc: giovanni.cabiddu@intel.com, davem@davemloft.net, ahsan.atta@intel.com,
	mun.chun.yep@intel.com, markas.rapoportas@intel.com,
	damian.muszynski@intel.com, furong.zhou@intel.com,
	adam.guerin@intel.com, zhangxiaoxu5@huawei.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - Fix missing destroy_workqueue in
 adf_init_aer()
Message-ID: <ZzAudk_EVc0fa9_E@gondor.apana.org.au>
References: <20241029150523.52435-1-wanghai38@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029150523.52435-1-wanghai38@huawei.com>

On Tue, Oct 29, 2024 at 11:05:23PM +0800, Wang Hai wrote:
> The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
> for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
> fix this issue.
> 
> Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: add 'device_reset_wq = NULL'
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

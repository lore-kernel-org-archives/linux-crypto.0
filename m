Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FC11C8FB5;
	Wed,  9 Apr 2025 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744170072; cv=none; b=e7lQjnzK9cONN5hB2X0dtUpO39Tr+r9dJM3CI0xrsxBjXsQGeFlHSLh0DJlIAbHq6Twta+VMV3mgeCCUR/I9oq60wr47a6LsXXJ8IUeyemEF9omEAA2ZJp8NoBO1vzirMGpvuWhQJeA3n3FTkngnV47a1XnUcqnSeyozpHaIBPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744170072; c=relaxed/simple;
	bh=8GRNmupPyo69Uqcd2hKvAZBLAkhcD42GjfJJe1HVIU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NlWQfmBQb03gkj0mT0X1HY2Rtb4fIRzLTTY5+xBaAx2GszB9Vr2dlsdAx+7tB2HIY/2Tos17jOclXeg+63D4nUowsVEYfn74cFDqYQCanMU8Srjc8BG5tQ29QOcxo5RAn4unWVvf8ylSovyZ6WC97mfx1fYcz9vHwiDPBGeVZHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bQOfrYaH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bQOfrYaH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T/H6Sk21vQXGzJuFjA5o2HA0xkd8qQUuh9KY1MVmLDo=; b=bQOfrYaHNanQEkfat5Mr3yobss
	Ush9P4xezBgp3VctfArgnn7RtGyCFmAtBi4XvUkgG2rwvQAYV7B7zgW/cV5vc7IDxCxUblFQE3tr+
	bs1n6+/WxZvi9MNqyjA5L6k18kd2AAw2MDQIMpZRTIT5xOSCIF9ylDERn1ALs6+Ciy4PKWH1lLpUT
	B7gZ5H0hn5VzVUe1lUs5atT7Mm/i2uQqoF8QLgV3HK00PepVsA88g+uMEUZHJ1WFXgPtKXeWRXtna
	EWBMD6SKxGX4FCyth4M6CFf+TVrFIgQkPwqzLS1xelp93S44ms/niEmiV/vT8vQdepnL6UwDvWd9Q
	bL5ZbWVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u2Ldc-00E69P-2F;
	Wed, 09 Apr 2025 10:58:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Apr 2025 10:58:04 +0800
Date: Wed, 9 Apr 2025 10:58:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: Re: [PATCH] crypto: caam/qi - Fix drv_ctx refcount bug
Message-ID: <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>

On Tue, Apr 08, 2025 at 11:44:27AM -0400, Sean Anderson wrote:
>
> However, note that the following error is still present:
> 
> [    3.294978] alg: sig: sign test failed: invalid output

That just looks like a bug in the driver.  I'll leave it in the
caam maintainers' capable hands :)
 
> as well as another error on reboot (present before but I forgot to post it):
> 
> [   98.514208] ------------[ cut here ]------------
> [   98.518823] WARNING: CPU: 3 PID: 1 at crypto/algapi.c:464 crypto_unregister_alg (crypto/algapi.c:464 (discriminator 1)) 
> [   98.527100] Modules linked in:
> [   98.530153] CPU: 3 UID: 0 PID: 1 Comm: systemd-shutdow Tainted: G        W          6.14.0-seco+ #163 NONE
> [   98.539899] Tainted: [W]=WARN
> [   98.542859] Hardware name: LS1046A RDB Board (DT)
> [   98.547559] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   98.554520] pc : crypto_unregister_alg (crypto/algapi.c:464 (discriminator 1)) 
> [   98.559224] lr : crypto_unregister_alg (include/linux/atomic/atomic-arch-fallback.h:457 include/linux/atomic/atomic-instrumented.h:33 include/linux/refcount.h:136 crypto/algapi.c:464) 

Yes that's a long-standing design fault in the crypto_unregister
mechanism for drivers.

The unregister mechanism was designed for software crypto, so it
relied on module refcounts to prevent unregistering something
that's still in use.  For hardware that follows the device model
where things get unplugged at random, this obviously doesn't work.

What I'll do is make the crypto_unregister call wait for the users
to go away.  That matches how the network device unregistration works
and hopefully should solve this problem.  But keep your eyes for
dead locks that used to plague netdev unregistration :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

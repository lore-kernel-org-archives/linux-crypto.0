Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476944085D
	for <linux-crypto@vger.kernel.org>; Sat,  5 Oct 2024 05:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106339; cv=none; b=RK/artbH/bTHQ5Kr0McWwo7eNMhVoWgLGXkLWgMnWiJjAna89RTjQBXgpAa4EO5/ge8S4I6mNlbUKuPGqwsMbYvwZMI59F9I31ch9Fd/ul+5MGrm250xciQpB8FppPD6PqaW30dO42DtDv9yG7U23UtDvfFHsPEOAqdniHV8Quk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106339; c=relaxed/simple;
	bh=lJems2rndXxhZRa/h8RbEd7hiQPEu5dtgt6wjX5Chn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1vXPxXldTrm4iv6f/1BoBaXw9np37CGyjK+D6JSHTG+K2KqvLFU9M8BE2NXZ6KisY1jNirnMQi+EZZpDoL7KZo2tLHgHhwrv1bMOuUXdM78eOlGu4Ek/BWMFvfrRfHqsyLCiii6+IBCGjjY1weXWP7fgJOYiXZge63PaZaceiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AsxO2+vW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AsxO2+vW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cS823GGkUlwKr1tWh/BPj/2dBxVq0Ew2zcjy+LSSSiw=; b=AsxO2+vWst/riX6Oa2ARFaNxs1
	JsF5xpNmCUrNCgnEijFvKjDdz2KKyL/rj7e9njC+Z4YIuSyrRoVUD6SG4J1HBFiKovMIePwY1aBmn
	y/WBEfBdJlLUZrpQztUlOVV7Drj4tK2n47FAmaoCXWLjBjh05C8sTb/7tOkNiYsy8lnugUsimIm2a
	f/H/eqMM7XmKS8E8bHW9EA3swwwwzOZ3crSuEsRYGCVR60ZzRxmDJFujWFVPBP5bDN+zq3RUf4MxM
	dih3V+BK4W1EGwwWzR83wiZFu/pkH+G9Vh8fQ1M3TrxX/QPwccQdBVO9arFHDzOAl4mXPu87frRCO
	WXVDiv6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxEt-0071X5-2v;
	Sat, 05 Oct 2024 13:32:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:32:13 +0800
Date: Sat, 5 Oct 2024 13:32:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	Li Zetao <lizetao1@huawei.com>, davem@davemloft.net
Subject: Re: [PATCH] crypto: qat - remove check after debugfs_create_dir()
Message-ID: <ZwDPXY8RX8DVMx0k@gondor.apana.org.au>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
 <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
 <2024091452-freight-irritant-f160@gregkh>
 <ZuV2L2WQXSEgcsy6@gondor.apana.org.au>
 <2024091453-champion-driveway-f9fe@gregkh>
 <Zuf9m8HgYbXp3yIJ@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zuf9m8HgYbXp3yIJ@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Sep 16, 2024 at 10:42:51AM +0100, Cabiddu, Giovanni wrote:
> The debugfs functions are guaranteed to return a valid error code
> instead of NULL upon failure. Consequently, the driver can directly
> propagate any error returned without additional checks.
> 
> Remove the unnecessary `if` statement after debugfs_create_dir(). If
> this function fails, the error code is stored in accel_dev->debugfs_dir
> and utilized in subsequent debugfs calls.
> 
> Additionally, since accel_dev->debugfs_dir is assured to be non-NULL,
> remove the superfluous NULL pointer checks within the adf_dbgfs_add()
> and adf_dbgfs_rm().
> 
> Fixes: 9260db6640a6 ("crypto: qat - move dbgfs init to separate file")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

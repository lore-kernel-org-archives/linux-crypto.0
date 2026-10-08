Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961792FE056;
	Thu,  8 Oct 2026 05:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791436077; cv=none; b=Bgyu2HO3c48NoEuxOi3HaGfsRcigSlU0zhEIAPCAM1yWTgLb96GUYCA5qXoxNgpZabB1reCHGVweMUYTtsnNXZiaTlJTcJwxCveP+b2qhlCUmL/P1DFEb2fXeyXvPtGHc7e4ym7RIF0xIbWh3kUvtFwfnDepn2emN8m45WSAazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791436077; c=relaxed/simple;
	bh=iY+vaCJTlRE+gFdJrLqBpIrdGs4JLRCjfTcxUn91T64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXREje7mAc+lg89jdv3A8zXRuCHMzzgXh+w+it3L6Lo6j7sgY/fOLNuaHC3CBeiADHWbTu09j1Mvcx+zRhASHvxPNnIEC46G/I6PkzoU8/8zGo0+waMqwW/O4+titRBkQMeGCcHHhs2ka1oLdB91/sBIh/BZwJT3SwErlZHoYyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VJXddwPf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VJXddwPf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=z8jVOr3a3RnLmvpjacgTz0lUn70LvW19S2xPohDWSWk=; 
	b=VJXddwPf/9zD6kGHPeC1KwMyGlnX5kpFO5pZrteHAvp1wk2wL7PmSBrqw708a2NIT7Xg9woyzCp
	QUTjHvL8GS9PTYcqJFb4pJ1jbgy+SWYnt5hBOd8F0KNPF3e29ubq9Xtpzf8IcmpeXef7v2H6yJZcn
	oviANcOzJvc6gitQZdgZKaQR1NE4uukUqFE6cuByrNK0mGqtNF/IG78E4hT7TQU6Wtk2jb1ppI5OI
	UoYqMD6r/1tQoRxs76GObwxFbuFa04amX1agSybZeVi2plOUagvnlK9D8Y7HuT7BHdvANLBcrGd6N
	blhAmwTIkZioZGNsh6wssl+36xgwscrO758A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEgLz-00000001l0F-3nH2;
	Thu, 08 Oct 2026 13:07:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 16:07:39 +1100
Date: Thu, 8 Oct 2026 16:07:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/15] crypto: ti - Fix use-after-free of dev_data on
 DTHEv2 driver removal
Message-ID: <asclG7JDJ4SYHZiy@gondor.apana.org.au>
References: <20260930112533.1593952-1-t-pratham@ti.com>
 <20260930112533.1593952-5-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930112533.1593952-5-t-pratham@ti.com>

On Wed, Sep 30, 2026 at 04:55:22PM +0530, T Pratham wrote:
>
> +struct dthe_data *dthe_get_drvdata(struct device *dev)
> +{
> +	struct dthe_data *dev_data;
> +
> +	spin_lock_bh(&dthe_dev_list.lock);
> +	dev_data = dev_get_drvdata(dev);
> +	if (dev_data && !atomic_fetch_inc(&dev_data->req_refcnt))
> +		reinit_completion(&dev_data->drain_compl);

This is correct but rather baroque.

How about simplifying it by making the drvdata also hold a ref
count.  That way the refcount will only hit zero during the removal
process.  So you don't have to keep reinitialising the completion
object over and over again.

Also refcnt should use kref_t which is easier to use than atomic_t.

+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		kref_get(&dev_data->req_refcnt);
 	spin_unlock_bh(&dthe_dev_list.lock);

 	return dev_data;
 }

+void dthe_release_drvdata(struct kref *kref)
+{
+	struct dthe_data dev_data = container_of(kref, struct dthe_data, req_refcnt);
+
+	complete(&dev_data->drain_compl);
+}
+
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	kref_put(&dev_data->req_refcnt, dthe_release_drvdata);
+		complete(&dev_data->drain_compl);
+}
+

> @@ -152,6 +176,10 @@ static int dthe_probe(struct platform_device *pdev)
>  	if (IS_ERR(dev_data->regs))
>  		return PTR_ERR(dev_data->regs);
>  
> +	atomic_set(&dev_data->req_refcnt, 0);

Use kref_init so that drvdata holds a refcount too.

> +	init_completion(&dev_data->drain_compl);
> +	complete(&dev_data->drain_compl);

You can then drop the complete call as the last kref_put will
automatically complete the object.

> @@ -202,10 +230,13 @@ static void dthe_remove(struct platform_device *pdev)
>  
>  	spin_lock_bh(&dthe_dev_list.lock);
>  	list_del(&dev_data->list);
> +	platform_set_drvdata(pdev, NULL);
>  	spin_unlock_bh(&dthe_dev_list.lock);
>  
>  	dthe_unregister_algs();

Just add this here:

+	dthe_put_drvdata(dev_data);

> +	wait_for_completion(&dev_data->drain_compl);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

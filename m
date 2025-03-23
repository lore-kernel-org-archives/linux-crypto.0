Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648B82E3398
	for <linux-crypto@vger.kernel.org>; Sun, 23 Mar 2025 13:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742735822; cv=none; b=Fn0Yp+eHUrcgMdPc+fUu9pTBgk4VmMvlB6ujEF++kBSF1wpBt3lFYIhaG75N00up0xbwrWGR0rUCh37+Tvni1eU11EPov+RsNVVS+JtbnFI7ZKKjiRtJ+H5Vto+dGHG4fFaRhmMryVrprXdKRpXIj5MgKPUVeFV8HNraR9GcFhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742735822; c=relaxed/simple;
	bh=XmJdSHLAlRD8S/Qvny50/RlWawKeXlFWyCiC8CFv2Kg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=edhpH5ALy6cJ8n/oBMdJysU2oADkflJyY1ecHLX2MVzEtjwyRrSZtg9wL0a24fpnZc/RqkR6YYKA95cVBnxHpjE1INA2vfDNYKSFFpeR44IUHh7rkPIvUXz6jVyWYOveGj1wpp0WSOoKko8u33BCUuaDHuPVh6MWFtOa+D3nfpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UJjCJ9Dc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UJjCJ9Dc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lnZ1A2j31SDunXR9cBUY9FnTVOFspMMIxl+mwaYbyqM=; b=UJjCJ9DcWCaTC1/yoK1N1mlDT8
	65xngihNoicTSXcyp5BjzIQT3P3+OravuO9/lH+paLDA26lHVmvfN0VLadbIm0Ba7iJs10pOh6O6L
	Lb61CLxG3deokSlIV3Jxc85c1WJ9kfOBykTKSjhR99TmOvm1jMh0eagpzPcT2HV4eg7bN/o+cR8l1
	rOrUagPQ5VIsNzUbIN1KC228jWfevl6uVLjB9lisaRFiNHJ9gaMAUepkeCe4QpkGRYRtu/vF/SBkZ
	fk68EmrrXsrN68u39WPwAUarWKQRq3yjPF4tZUMws3QPSTa7cuQlwXqj/4LsHn3jyJUe0PhlKYBvH
	2pLw49wg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twLCB-009TMO-1C;
	Sun, 23 Mar 2025 21:16:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 23 Mar 2025 21:16:55 +0800
Date: Sun, 23 Mar 2025 21:16:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: caam hashing
Message-ID: <Z-AJx1oPRE2_X1GE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi:

I'm working on making the export format of hash algorithms compatible
so that you can switch between implementations seamlessly.

I've got a question about caam.  caam_ctx is supposed to contain the
hash state plus the running message length.  What endian is the
running message length in? Is it CPU-endian, big/little, or caam
endian?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

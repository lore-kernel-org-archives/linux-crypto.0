Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC51E9B0D;
	Wed,  2 Apr 2025 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603385; cv=none; b=U3EE8f7FWDWyirX08lmMdoCHrfUXe6VbWUcEUNcB5hUAkPY4Ew8i9oaKOUs50MOulIztx025FfRCSC8srSoQ0rdy9LKS9hNU5IfyEVlfRXZ2GxM3HmsUl2PzMTMa3nMHM6sjnJvSCCD65S15Dl0sapgyGPvbIoaEnlVDjBXLvNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603385; c=relaxed/simple;
	bh=w7oSw39XwiEryX1+UGNcDrLPrmD/z73jLcVEISlafyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4OtmlAA9dZceEFN8mVqGJ8x2peBrkaQD4mTNNylbUEHHMAjM1v/kRZd4BIijGcdfAmqNW0GZS2fzGBH0ZOCKJp5PI0rUtbrfXbSIWc1zf9eC+LLSL0ZV6wlyGek0PPxVI7TjJbUFc9368Hf4fzZChs6I45/kor3cD1ByRZOm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QbIXgIwz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QbIXgIwz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gUPaAmmxVLsnrDYsaEbRgMqcxSa2fPKw/+pgPpN61B8=; b=QbIXgIwzIVZU69jPK/GeVKI/Qm
	MiQRFwqkf8YIkAZ+MCSdxbwPicUG6J3emg/IyGVqipFcDVG1uJsjkLaSp3sFJxb4CCDk0GrMb52PQ
	MfId5axYTL1/8Jaf7leVJkTmW8maNxYFmMV2m+Y98qKe4sKD9BgD4vNP5Sd3MU0mFxO1/GjngZE6n
	dsXM1Kz8HZKApf0clsdclPyMvCBqCJ5D8618m2w8EKyh15TKHxB9cPbkdi/vSmswxB8Mx+hTWUBPw
	2NzAdTu05z9/+foYRDg4QR+n4Yy4Gwahb+ALNhPtMJux+SAkV8I3y3Ds6lVL/PvoErZZqD4aAvnby
	dfbz0Isg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzyt7-00C92A-1F;
	Wed, 02 Apr 2025 22:16:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 22:16:17 +0800
Date: Wed, 2 Apr 2025 22:16:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z-1GsWEkecDrExCn@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <Z-1BnSGNab34W6eU@gondor.apana.org.au>
 <c86a5251-a165-41be-9238-53fb133206a4@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c86a5251-a165-41be-9238-53fb133206a4@ti.com>

On Wed, Apr 02, 2025 at 07:42:08PM +0530, T Pratham wrote:
>
> Thanks! I'm assuming then count[1] will store the digest count in sha512
> here.

count[1] contains the upper 64 bits of the 128-bit sha512 counter.

> Is this the same for SHA256? Since there the count is not an array, so
> is it then count = (digestcnt << 32) & buflen? 

The sha256 counter is only 64 bits long, so only count[0] gets
written out.  There is no need to do any shifting for either sha256
or sha512, it should just be:

	count = digestcnt + buflen;

Where digestcnt is a multiple of blocksize and buflen is less than
blocksize.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

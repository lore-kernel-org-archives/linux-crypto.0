Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2291BBBC6;
	Mon, 10 Feb 2025 07:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739174259; cv=none; b=pJGknZPnSfu8si0B/TeGSWV2SmvbM9ViH5r9zn3L3z0gRIw839v7smgip1vsW7dDjQ+w04jQiSFm0+bMs1FudGt1qmO5JLfYDFxXv4lFQ6DuCbBdMcLsf0FtEab/u68IyJ3fWe8DWf66PJcDfgMs1TpzE4ZuuBaDFyxvmPBjsy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739174259; c=relaxed/simple;
	bh=6ETEw5H8ZqzQ0B+FIB+Exlg/agVeevaj2YaJliPyEL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mapEaNsrVT17GcVCRvuw51Nu0ll3ibDcC9E5rLm6o1grNkyILWbzoLnSQvG27zBaDQd8LeGQpZTEKswYpSY9vNYfZz/eaMCtr9rYgdsAQNG4DuI+uicpf4KfqqavuBmjF4mjB3LF9xydv7e0wy0TWnteK2rN9z+YGGUhd7xZSTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HFGN6Xoy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HFGN6Xoy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=j/HMFOGnESrooOt4kbIgEotWXCCpINQo9WsZPNP1PYE=; b=HFGN6XoygPH/6jlzf6c6TjvaBw
	RgEqDZ8q0dU720z+Zdv6fU02KDx8S3nVmnLxFUQU6Qe7KPWXxNus9pMYXh/t+FZG/2G6rrUBO15rC
	rQbuFMSMDxqrhxxKpiT4Cpkx60i6qznNgpToLwqI3r+CEU96i/THzIJGmbr4Tt4bMNiGSbQ2Qtl7M
	9bXzJH72AgjBB96OTdLU3DuWlHDZZSK0vNx637ne6TnWEj1xK+tBm2ERN/Njxr7n5/f/O302yaz/g
	g2m5Gb3GIknQzr/zOqQ+kMDf0e4hjCjHimBn+xuqxCJFijRpLBGccqbU5SfXqp2b9XNo6NuVL7Xj+
	Wq7wH6hg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1thOSc-00Gcs7-2l;
	Mon, 10 Feb 2025 15:57:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Feb 2025 15:57:27 +0800
Date: Mon, 10 Feb 2025 15:57:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z6mxZ8lfO6zzD7x0@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250209163430.GB1230@sol.localdomain>

On Sun, Feb 09, 2025 at 08:34:30AM -0800, Eric Biggers wrote:
>
> Or just make it synchronous which would be way easier, and the calling code uses
> it synchronously anyway.

Note that synchronous in general does not make the problem go away.
The important thing here is to give congestion feedback in the form
of EBUSY which tells the user to stop generating more data until a
callback is made.

While synchronous can be a form of congestion control by requiring
an extra thread for each waiting request, it doesn't really give
that feedback to the upper level.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

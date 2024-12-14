Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45BC15383B;
	Sat, 14 Dec 2024 09:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734168498; cv=none; b=tuuGDMFuQH7qoIFKMlHOzfytpf/u2zx4+RGCvDCAHV5iKnLBB4NHtPNYssas1LD1QQ+mEeq+22KiDSR6ufoyxuoh9vOzXSRHS2c2guBij5rgklbFbxHuSNnHuvUZduGckuCb8FJct8fPtjKLRI5VJtL/o69E0hpeW3OCXrVLK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734168498; c=relaxed/simple;
	bh=QdhHa7iMZbjkQnT7T+8JCTD6tyAI9zlhwdDIMFKInOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JykaDeEsa9yYv2ZqH/w7RsijD2zCtRJVVP8RSzupwBegw2FlaKFBfSoeOdzRvk8oZrLqGyKBcxb7B79kSSNAI9hx7h1L+9+WakEBz/KIp04NCwn5mMM9yKINbHAfHA8Buybv+l5PQv78OUAs/AX3vLcGX4RgAT5Q02Jhgj+ztSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dTSsXmD0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dTSsXmD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QOHkSD4VtoqFlcrsRN8IrmkfP7RII27E0GitD3i+GcY=; b=dTSsXmD0Kxg/XTDhb0+XSZ6oW6
	YzxM+sLpODyosfhKgRE14COBgKPjU7vXtEIKbd8MceImqQNem2FYwvjVFbkMUPLeHuRH4SJEfDZ37
	+q6462KFoy78IsJZqzQMQ8K1BzblwRQAw8UuDBoQFtNyaT1eaPPbXynq7WbsdELkglm8o9Q67xFJf
	8ZVfd+rH9KbKtUBX3XXnKuWUQn1mHJIqthF1G7LxikbiGWZO37QEzcVtnqhZ+h2BKERhILZ+3jFR2
	uq4D8G3netonbx1l071T+j2UkC/bEurQoPe9txSENqn095xWV4TQDa7ffI+izz4EgD9AG7ayDIe2h
	N1jl5TqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMOEc-001TKJ-36;
	Sat, 14 Dec 2024 17:28:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 17:28:11 +0800
Date: Sat, 14 Dec 2024 17:28:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mario Limonciello <mario.limonciello@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..." <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: ccp: Use scoped guard for mutex
Message-ID: <Z11Pq_NDNLN_oe7o@gondor.apana.org.au>
References: <20241203162257.6566-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203162257.6566-1-mario.limonciello@amd.com>

On Tue, Dec 03, 2024 at 10:22:57AM -0600, Mario Limonciello wrote:
> Use a scoped guard to simplify the cleanup handling.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v3:
>  * Fix logic error
> ---
>  drivers/crypto/ccp/dbc.c | 53 +++++++++++++++-------------------------
>  1 file changed, 20 insertions(+), 33 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

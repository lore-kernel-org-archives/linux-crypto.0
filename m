Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC841CB4C
	for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382536; cv=none; b=vBsUtoRJUnDI11LGHDHOOmR5Fn9NXsWWGqFa65qzeHiULIWWXFvMoyeD308hMQMx0Ow+7chXA79KUYoRjjO63GIsB/bCiYAI1IPkEjnnvpX387bpuEjvHMrT4QSqMcxVcQ67nY8Vz1tsfF4uTMXA7/M4dm16bcmk+WSQ4gD+8OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382536; c=relaxed/simple;
	bh=4so1FUGfOC5kcxISQUhj51bQslU5xUlNH0iCft0lUTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzBb4qAaclaEjtWRxfZUlNlN/k+NsXgMNztqnxFwv9x67RWDGy2gYFL6OQUNxLPFBc/x1x00VkZy33xFvCDATG5rgjliuY3FrUGaLe5OPcJiFE2dddqvMU3berZx9Y6VVYMR4E0XIejvsLzDNEAtsYFwiSHSgJcaNl4IR9Ym7VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fvhiEB+w; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fvhiEB+w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uL3acx084L2gZq018Mwi1y4JZ6YcSR+L7jlOpv7MPP4=; 
	b=fvhiEB+w4QSW7yNY74Vku8JOCpBKlYYyuju5MHex63BbaMS11dERZjwRtuGltV9HxL7va08Ijg8
	ENSunoRIcJVnHO+ZAexowCw2bL2U699Fcg/mVizeln4jjeMv3+ePWajBMxPJdOO8sK6OXD+pY6tiw
	c75+hoSmOqO5W3QrXWk8R7QYN3dGb5w5Qe2PE3ITT7TRke53KIqZcSUCmc1bPffYAHrfcTmXSswu1
	uUJrdZRAXUGgjOZtyiUnmTHFGdxnhsLEad8nAOhNgp2uG6Qz/qal50RUDha55zMbCBItQnbq8cd6w
	bYKijupnVPl6TRdBC7f1zSwkCyQ0GTCTKdYg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x648O-0000000Dlzk-3LCP;
	Mon, 14 Sep 2026 18:42:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Sep 2026 20:42:00 +1000
Date: Mon, 14 Sep 2026 20:42:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Westphal <fw@strlen.de>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqfPeIDmYPI8-ZTb@gondor.apana.org.au>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
 <aqfJgFY73ZYtFJmH@strlen.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqfJgFY73ZYtFJmH@strlen.de>

On Mon, Sep 14, 2026 at 12:16:32PM +0200, Florian Westphal wrote:
>
> Thanks, I rebased the ipset rhashtable conversion patches
> on top of this; all tests pass.

Please take this patch via your series as I don't to add features
to the kernel without a user.

> > Once rehashes are completely gone, ht->nelems is reset to zero,
> > and the new table is installed.
> 
> Wrt. to this, you could do:

The problem with this is that during the flush, nelems will be out
of whack with reality which will cause rhashtable to do grow the
hashtable unnecessarily, followed by a sudden shrinking.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

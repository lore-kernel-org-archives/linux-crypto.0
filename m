Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3C5BA4B;
	Fri, 29 Nov 2024 05:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732859713; cv=none; b=ZVBu62oOVDShDTVU7+cBtZpewBleERAuqy4wq4B+xIDxiLT1suo4Wsr889lueFmJdW2DUc+jYcm8bZNYEJaKs6JA0vgACv1BBty2or2RN14KkyvIPs23hqaEG6O8Cc2trCkU0t3I7MTi4wdi1toXxBRD53RXr7gpRktd2pe6QiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732859713; c=relaxed/simple;
	bh=pjOoYkVFMuHnZj9zsk9+LbQrrWk+4NPvNgihxH/VmY8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IYVdjo7dMaFgnTaCRsxfaoQeB85Q8lT4LfQIwAqNSC1iVvCHGnbOb+PNQhOyz4Z9hR/dKZunfozsCsVN4G1gMlY9vzvrmjFOE4IWpNuZ8jg9tYFNxwBY97eouajqqdrtrVyqI0reSRO8f5QYze/YZgL7/Nl2ANAz1KnsYuvp7+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b+1zl+B9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b+1zl+B9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QnEpyNKBTgXpnhTt/rHf2Kgbpvm7yzHKIG4Rn0/uL8Y=; b=b+1zl+B9rp4eNRqqsocaMKBZTD
	ACKm2LHEgT1zW3VVWB0Sf4/BxT7z5mO68+yOTE7XMnT0m0GzaWXZJwaQs4Wh9ianQHLKxLJ3QUXkS
	mrkXJeUKDIB3miwgnYEaa2sUHx6nWj5NfflRO7kgSAjuC4Ln4n0EI4JsuUDMXSclGhgvKWdi6h/R4
	qa14VyOwT+pmfixEs+/IELjFuviRHND+dXVtqTL4cI8G+Q75CmG7pE8NehbImGw++6pZgrPu9UiO8
	dDWhfSJqYx6Acd6aIa56OA0/5TdAf0UAxaTW8h6MKxRR7UnT7eTEb5vbXnhi3k0/XbHmDGCD+ufx3
	/7+Bzgyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGtxu-002Kdj-0p;
	Fri, 29 Nov 2024 13:54:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 13:54:54 +0800
Date: Fri, 29 Nov 2024 13:54:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Thomas Graf <tgraf@suug.ch>
Subject: [PATCH] MAINTAINERS: Move rhashtable over to linux-crypto
Message-ID: <Z0lXLs9Zoo22kH-f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch moves the rhashtable mailing list over to linux-crypto.
This would allow rhashtable patches to go through my tree instead
of the networking tree.

More uses are popping up outside of the network stack and having it
under the networking tree no longer makes sense.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/MAINTAINERS b/MAINTAINERS
index 48240da01d0c..614a3b561212 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19835,7 +19835,7 @@ F:	net/rfkill/
 RHASHTABLE
 M:	Thomas Graf <tgraf@suug.ch>
 M:	Herbert Xu <herbert@gondor.apana.org.au>
-L:	netdev@vger.kernel.org
+L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	include/linux/rhashtable-types.h
 F:	include/linux/rhashtable.h
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

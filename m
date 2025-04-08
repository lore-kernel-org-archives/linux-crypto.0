Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635E4198E91;
	Tue,  8 Apr 2025 04:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744086060; cv=none; b=FJlQv7/u7D7vhLlQ9Ip34QxySG5+zqv+9ddi8IpJ+zWooudFQA3xLAzNwcDwrp2sQBLm1Wsw+yVNQ0wYxf8WA6YSwRFKzRcjCH45L2TDPWYR9l5FdMqOnfy5IpVlf1W4CRsGQ5B/6PayzENEczwWgjwVZgpG1rbEtgNKJwI5xyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744086060; c=relaxed/simple;
	bh=9fYREZVOv16eUdYuo9SYeOGtuRe15RCrcThGhosK4zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pv5V4SYN0+FPYJTFJvSV6WWZtJvez/flh+XsN01g8711GaWdZqjJm4gZHVPqK3vg0vt3eUvYhaQ2K/fRIFy/THGzd9wRPKmcUDb/dA8fecEyBEKf8y7PxtkeBdPte0FeSQYohidG9UpDKun4UDf/pJZ8MOSm398Eve/JYSCYhMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OKTDF4+E; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OKTDF4+E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f/DoFNRuiiVAkwV02tS1l/zFMuQjpgmiB/Gter90zGI=; b=OKTDF4+Efe4g+aPEIyC/KLv4Nw
	Fi+R60MnSn4xlGz8gKguCFkX4SSGRyT/gj/df+JWet8duRcWVA974LmmTGwccMJKZ2gb5DcqEB+/a
	j4r6Y12EcCVBw7BXh2eWJHLyMPN2EaWXbbvhL4R2f3LE0Q7Rf01PO4V924C8rk5CKqVt2/5HO9tb+
	KOeBL48wE+dKScZeGtncQ+X2kKh/kePMqu1+FLsdGyVxKLamqTb2vZ6LwV3OKgjVxdU4dFVJr1bjq
	MSlzH1m1hbS5VTehq5kePO5kVvTA+Gf02DDNk9XTct7Q+iHF7RvLrWbh//63REJdqAlGnwGTEUFuO
	8gmO9SeQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u20Ru-00Dlm8-25;
	Tue, 08 Apr 2025 12:20:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Apr 2025 12:20:34 +0800
Date: Tue, 8 Apr 2025 12:20:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: scomp - Fix null-pointer deref when freeing streams
Message-ID: <Z_SkEnIWk8E0mLJf@gondor.apana.org.au>
References: <3c239727-6c46-45c2-80e7-d6853427f72c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c239727-6c46-45c2-80e7-d6853427f72c@linux.ibm.com>

On Mon, Apr 07, 2025 at 11:49:27PM +0530, Sourabh Jain wrote:
>
> [   90.892796] NIP [c000000000845eb0] scomp_free_streams+0x6c/0xe8
> [   90.892803] LR [c000000000845ee0] scomp_free_streams+0x9c/0xe8

Looks like I never tested 842 which curiously does not have a
self-test.  Please try this patch:

---8<---
As the scomp streams are freed when an algorithm is unregistered,
it is possible that the algorithm has never been used at all (e.g.,
an algorithm that does not have a self-test).  So test whether the
streams exist before freeing them.

Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/scompress.c b/crypto/scompress.c
index d435d4b24469..f67ce38d203d 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -111,6 +111,9 @@ static void scomp_free_streams(struct scomp_alg *alg)
 	struct crypto_acomp_stream __percpu *stream = alg->stream;
 	int i;
 
+	if (!stream)
+		return;
+
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

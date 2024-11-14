Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C7418BBBD;
	Thu, 14 Nov 2024 11:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583512; cv=none; b=b4TX8OwqZuT8SAsCPx2hJC00tu7uErNWwENOo8gTCiA4g1+6fw3JWVqB1XAK6VDDmJEvoExIgk6yPhKj2cmdBiUxaPJnAwsB1IAEiWkO0sKLM4wiwhFCMV7NKoR5il1Ca22X74c9ZFI24g7Q2R2Kny4lJriSTpnAokf+PK6AS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583512; c=relaxed/simple;
	bh=aVIvz69luqtbRV5NCqi8GetZtaRWYDrPI881Uj4JbiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8Sr5jsAzL/qtF3cogv2BZS5K5zvCoeGs0ymK/PK7gLto0exNbRkYhvp4MX1+zgGchjDDPRGjpmzleGmM1XrDDfZP4THuGSMqHM2mcbVH/sEmgnlElx/xJgJ9bGNaXoEEg1103XBJxvN075hCb+2R21KoEVGqLhMOTMmCxv5lzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LX3f3b2o; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LX3f3b2o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=axqXJOEvoFA8XZXHTN+P0B8l5JDKHF60G0U41LQtzq8=; b=LX3f3b2oa2RJw6pWciddcQfhFR
	nFQl5fJSmncz+mJXUzGVfgQhfmXZRRs8ZoCGH65k8n8+iObxRykPrh7Im1kODRPx0vP8ysx1JZjw4
	03BOV3T4tbbRpLDZDl5Gr307GJ1CZXpvf80x/rGCS7iotrixNOeSAaxBsZ5xr/pMXHp0YjhwPLCWV
	NX8bVRQU1Aw/WckJxHlrEGmkaDhO4wQ22UNdj817qWu06W4WAZtvL9aUWGzgRuMiMxMrMjqmn1WiZ
	OlTJnuFgVTXk168xrEAYG7RfH3IPkbaOMh7T96sdhH6f02xqNwVVvWBA2fO02/fh/wPaeAgaFnepC
	yUeSOsiw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tBXy8-00GmQC-0H;
	Thu, 14 Nov 2024 19:25:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Nov 2024 19:25:00 +0800
Date: Thu, 14 Nov 2024 19:25:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+listbb9cdfe92636134be785@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] Monthly crypto report (Nov 2024)
Message-ID: <ZzXeDFlmeJt_npKr@gondor.apana.org.au>
References: <6734be89.050a0220.1324f8.0049.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6734be89.050a0220.1324f8.0049.GAE@google.com>

On Wed, Nov 13, 2024 at 06:58:17AM -0800, syzbot wrote:
>
> Some of the still happening issues:
> 
> Ref Crashes Repro Title
> <1> 228     Yes   BUG: unable to handle kernel paging request in crypto_skcipher_encrypt
>                   https://syzkaller.appspot.com/bug?extid=026f1857b12f5eb3f9e9
> <2> 15      Yes   KMSAN: uninit-value in sw842_compress
>                   https://syzkaller.appspot.com/bug?extid=17cae3c0a5b0acdc327d
> <3> 6       Yes   BUG: unable to handle kernel paging request in crypto_shash_update
>                   https://syzkaller.appspot.com/bug?extid=e46f29a4b409be681ad9

None of these appear to be crypto bugs.

#syz set <1> subsystems: bcachefs
#syz set <2> subsystems: mm
#syz set <3> subsystems: bcachefs

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

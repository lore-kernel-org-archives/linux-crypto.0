Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E169518F2EF;
	Tue, 25 Mar 2025 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742890942; cv=none; b=c+Vjp7Lv7vvM4sMcWcRkESyTkpc8aBp4nB2iVIj+szohhEWAFTBzaOW+Je/wkl1AqKXFUM3UZlXSTpH7SMOcvyKxPX7p54nFqVDRs29z/1o0U3lzL1jnRa5rfkqODhGDGLYo9NHWqfSzIDzmK8BuiT4N0G1r+/4jgAF3clyzVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742890942; c=relaxed/simple;
	bh=yFXlwGoZcSdAjfQA0xFIUC/CE532Cmp3vb8c7vdbHUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAtJqc/8BfSaA7GrOcFRRQ//qFKhsI9NlxwhPCa3cldYIYQz1PkjZt/2+2S1OPTUPeghVakmRwSOsWAs9DCQ7aVvNsKM9boUvmSOG1yTOIKtzR0VQ39JQCvpEhIz/lfk2N44+89zDfo9E6Q0M76bjFgwq7YkLoZMlCpHYC2nH/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CbSxXnQ0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CbSxXnQ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P0iL0oYqboCcXIkdl7AAs26D2cnlpr0fuu28NX+v2W0=; b=CbSxXnQ0onkkb9Rjh5Q2b2vTif
	BGv2/kg3RgcdnAvBG0P6eWQaooiZpVu4sobh6yzmlSzgLBRANyqKgPU7iWKA6jf9mKu6OehHvqSFQ
	Fvd09w5VetwjOwsqW/HmXItyjo7yYtjnIPAGL3iwsuInsF0valEDh/hxk2LAtbhzsNc5DSxn5QH0n
	x2ODdIR14YT+vg+NjoGtEF7JlpMcURSgQxs5V/T51tZg77fGJmgGn/Q6LURBl4KemDDxogw6GNmoB
	nWqOnYRA2A4yHPIbuYw3uDOwqQjYBY0I0Svq2F9QBGwQGolm/tErWycKS9EQTZbv4T2ChixDgBL5S
	KkBK3yGw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twzY8-009wO2-01;
	Tue, 25 Mar 2025 16:22:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 25 Mar 2025 16:22:15 +0800
Date: Tue, 25 Mar 2025 16:22:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: s390 hmac
Message-ID: <Z-JntzkWQqc-Atlc@gondor.apana.org.au>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
 <1aa33386ca1c39438fd17ea651a21903@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aa33386ca1c39438fd17ea651a21903@linux.ibm.com>

On Mon, Mar 24, 2025 at 11:04:56AM +0100, Harald Freudenberger wrote:
>
> that is the ikp bit in the s390_kmac_gr0 struct:

Thank you Harald!

> union s390_kmac_gr0 {
> 	unsigned long reg;
> 	struct {
> 		unsigned long		: 48;
> 		unsigned long ikp	:  1;
> 		unsigned long iimp	:  1;
> 		unsigned long ccup	:  1;

I hope I don't have to worry about ccup and can just leave it
as zero during import, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

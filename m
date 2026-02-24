Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A83A784D;
	Tue, 24 Feb 2026 16:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951283; cv=none; b=HIkTalkODYqPscaEdWR37jKz0fTF9ZcDKoFMbeOAcP54VGipUG/ppPoz79IlrELSdODqHdXlPU1viNMcn3Pw+Ul3NoeFYqv/Kt2tUuKXgJ0CaIvDNbdBIyfZtzvsKH4u/ozuSk8ZYlTu7PzuEWjNgYp3A5UcCBrhTQ3nx7EzM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951283; c=relaxed/simple;
	bh=RFFOngDEtCjUim5HA3lvpiYjiTFPEFoANJrCo5wxPhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGqAJNnJ8xfhTtIv0b0dkVk4Z0DM/I4q8N78o7+3S9DVswRjrIcvbnh3T4pxVfg/w6QqgQNYh/HDVFFCHzHqY/QmzMrMFwSsMKMMxdbTiX0TGzx4m0PDteuj29M/9Mpt8PM56YZ6H4LlzG8lv7xPzQ/BplfRxXHvHjzAtLmqEz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.78.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by bmailout2.hostsharing.net (Postfix) with ESMTPS id 118B0202021A;
	Tue, 24 Feb 2026 17:41:14 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id ED3C33F3BA; Tue, 24 Feb 2026 17:41:13 +0100 (CET)
Date: Tue, 24 Feb 2026 17:41:13 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kepplinger-Novakovic Martin <Martin.Kepplinger-Novakovic@ginzinger.com>
Cc: "horia.geanta@nxp.com" <horia.geanta@nxp.com>,
	"pankaj.gupta@nxp.com" <pankaj.gupta@nxp.com>,
	"gaurav.jain@nxp.com" <gaurav.jain@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"ignat@cloudflare.com" <ignat@cloudflare.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] crypto: caam - RSA encrypt doesn't always complete new
 data in out_buf
Message-ID: <aZ3Uqaec79TUrP2I@wunner.de>
References: <6029acc0f0ddfe25e2537c2866d54fd7f54bc182.camel@ginzinger.com>
 <aZ296wd7fLE6X3-U@wunner.de>
 <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d7ad1106dbb259f7c61bdd1910ac9f08012725.camel@ginzinger.com>

On Tue, Feb 24, 2026 at 04:09:51PM +0000, Kepplinger-Novakovic Martin wrote:
> Am Dienstag, dem 24.02.2026 um 16:04 +0100 schrieb Lukas Wunner:
> > On Tue, Feb 24, 2026 at 02:17:22PM +0000, Kepplinger-Novakovic Martin wrote:
> > > This works until v6.6 and fails after ("crypto: ahash - optimize
> > > performance when wrapping shash")
> > > but too much has happened that I could revert one and I might be wrong
> > > with that commit even.
> > 
> > It would be good if you could bisect to exactly pinpoint the offending
> > commit.
> 
> I know v6.6 worked. v6.7 showed
> [    2.978722] caam_jr 2142000.jr: 40000013: DECO: desc idx 0: Header Error.
> Invalid length or parity, or certain other problems.

Well there are 18404 commits between v6.6 and v6.7, so 14 or 15 steps
should be sufficient to find the culprit with git bisect.

It's quite doubtful that 2f1f34c1bf7b ("crypto: ahash - optimize
performance when wrapping shash") has anything to do with it.
It doesn't touch asymmetric crypto code.  If you absolutely
positively think it's the culprit, "git checkout 2f1f34c1bf7b^"
plus compile would confirm that.

> I can try to narrow this down a bit later.

I really recommend starting with git bisect now, not doing it later.
It's the most efficient use of your time.

Thanks,

Lukas

Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BF42AA3
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 01:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741139492; cv=none; b=Kxkob1QyQX5cDOqUGWJIojogW+UOidNthK8KsQhhdosGbkbaHqdcqpnAWrKD6RrBKiHA6P+aAL3D0szQH68jHZFTsObhLytmg4l+cpfXhW9q3vTGT6Y2XZ0ecBt1VIhntf0xkDO71TpVcKO/HbvSG++bHiuBXOjrrPj3J4XD34k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741139492; c=relaxed/simple;
	bh=0o8SdK6FtFAa1UjQJP0nuWAwjfxlL5/OvawGM9xHZvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbME/H/v/pnaBGeUt3clsUOiW8vERPa6m/uDZjE6PSyVRctcWi950yGkSb+g1ibCiTbikcr7p2HJhkTl79rwd4aBiqoBvR+GUVB3U5fsCjnxadAc7WHRSPrEDB9KcBP56yu+rELJbS8myUpXVVHA9XqrcMR0q5AffmlGPhJ+xqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sCT6dDga; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sCT6dDga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7ku7hJXZZ3M11RTPAybh/aKYvaFPWeU3ZdUrMhOoMXA=; b=sCT6dDgaJG8HgPmSHEU/jvj/+Y
	bioif/YQCWuQggcCoMUgvn8rnqz/1/w2YO6MD33yqzY0wG61mpjx+mhE9g+x/f6O46h6nJxWSudEU
	njPyC2j96TkiUs9GqlQDvYdVLVsaZ6SR67t+sJtYgp5SgxpjjRqF6n3F2Gnp7OuXr+Xnx04iwwxzj
	J5iwIVosFRmpDdKQpvg96np7yULDXRv1CyreRG9EL+y7y/FViGFSN3bTMcQ1WHBkuO3wm+oYgMC/R
	giZOJ82wtbV8fuS0zBaJ8WbOzIa3gl9Gc2658K8BV2tCSeFOq6ep9JUcraE8elz0O7tuygmpBDHx6
	wKO0dDWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpduu-003qhn-2J;
	Wed, 05 Mar 2025 09:51:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Mar 2025 09:51:24 +0800
Date: Wed, 5 Mar 2025 09:51:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [v2 PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <Z8euHNedFIBkVZmL@gondor.apana.org.au>
References: <cover.1741080140.git.herbert@gondor.apana.org.au>
 <a11883ded326c4f4f80dcf0307ad05fd8e31abc7.1741080140.git.herbert@gondor.apana.org.au>
 <SA3PR11MB81203FD3D6638C0E1259E5DAC9C82@SA3PR11MB8120.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA3PR11MB81203FD3D6638C0E1259E5DAC9C82@SA3PR11MB8120.namprd11.prod.outlook.com>

On Tue, Mar 04, 2025 at 09:59:59PM +0000, Sridhar, Kanchana P wrote:
>
> > +static int acomp_reqchain_finish(struct acomp_req_chain *state,
> > +				 int err, u32 mask)
> > +{
> > +	struct acomp_req *req0 = state->req0;
> > +	struct acomp_req *req = state->cur;
> > +	struct acomp_req *n;
> > +
> > +	acomp_reqchain_virt(state, err);
> 
> Unless I am missing something, this seems to be future-proofing, based
> on the initial checks you've implemented in acomp_do_req_chain().
> 
> > +
> > +	if (req != req0)
> > +		list_add_tail(&req->base.list, &req0->base.list);
> > +
> > +	list_for_each_entry_safe(req, n, &state->head, base.list) {
> > +		list_del_init(&req->base.list);
> > +
> > +		req->base.flags &= mask;
> > +		req->base.complete = acomp_reqchain_done;
> > +		req->base.data = state;
> > +		state->cur = req;
> > +
> > +		if (acomp_request_isvirt(req)) {
> > +			unsigned int slen = req->slen;
> > +			unsigned int dlen = req->dlen;
> > +			const u8 *svirt = req->svirt;
> > +			u8 *dvirt = req->dvirt;
> > +
> > +			state->src = svirt;
> > +			state->dst = dvirt;
> > +
> > +			sg_init_one(&state->ssg, svirt, slen);
> > +			sg_init_one(&state->dsg, dvirt, dlen);
> > +
> > +			acomp_request_set_params(req, &state->ssg,
> > &state->dsg,
> > +						 slen, dlen);
> > +		}
> > +
> > +		err = state->op(req);
> > +
> > +		if (err == -EINPROGRESS) {
> > +			if (!list_empty(&state->head))
> > +				err = -EBUSY;
> > +			goto out;
> > +		}
> > +
> > +		if (err == -EBUSY)
> > +			goto out;
> 
> This is a fully synchronous way of processing the request chain, and
> will not work for iaa_crypto's submit-then-poll-for-completions paradigm,
> essential for us to process the compressions in parallel in hardware.
> Without parallelism, we will not derive the full benefits of IAA.

This function is not for chaining drivers at all.  It's for existing
drivers that do *not* support chaining.

If your driver supports chaining, then it should not come through
acomp_reqchain_finish in the first place.  The acomp_reqchain code
translates chained requests to simple unchained ones for the
existing drivers.  If the driver supports chaining natively, then
it will bypass all this go straight to the driver, where you can do
whatever you want with the chained request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9573382DE
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772746615; cv=none; b=QuCFMPZdBIXRR485v/D4Um46TcTjWf4NV0tlWZLa1YHNNzkBWHik5K0xqB6aeLdM10tF/FVa9MAOKLg30/EO07AM4cRetUWiKeEf3fXP6awb8qnJ0zbIoDkOz5/PfAoTWfpMqmp2KkvH2hhNGI2PhfEvwkyFuvriGgpSpKRotH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772746615; c=relaxed/simple;
	bh=J9S5kmHfxme7EZ+ODQZyBFoYIwMxjfXm0J8deC+7O6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mqhpwep3Ezvs8Eqx0YrOI1AbB9KiByxv1RsjPK3UXWap7pFeEirDZZasJk/mmP5Fjn9uBj7Il2Udyt5Vdl1gQHRIB2h4p/Pd2WfHTa/7aS4JHc3HCiMflCXHDx82JRRkfarL1vxGSNgvNO8w0YozNZzsO7D+mrn0yHqAkir9BqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JR3j8IZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JR3j8IZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6C9C116C6;
	Thu,  5 Mar 2026 21:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772746615;
	bh=J9S5kmHfxme7EZ+ODQZyBFoYIwMxjfXm0J8deC+7O6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JR3j8IZViQEukQgoeQdNRvT8FyjvST9xfUPn2EfU2HnDLI9wPLxnF9sbykX7O5uMd
	 oZ0J5Ezgf1NKTRARhxwEzU0bduvDJh5r2W47WQontAFueawg0ZYmkkU3CxPBYpM9gk
	 p6mcHz7r+tOzz9x+woJCNTWtqUB+V1c3vPctWaT+0sMIR8PDIUM1OgkktSJiIWrSGb
	 ku418oZSk2Navm68aywmqhsamrEFjXa59FqGo5wfaVaXqtVBzhcvoXHbHvB3S8Y001
	 iGQkKbnyEcCJobsFtaGAWMRYhp+pBTok3/XR0sdJ/bKq3CictHYQXzs20u8EhV68Zf
	 OUvdyt62CBeOg==
Date: Thu, 5 Mar 2026 13:36:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: Re: [PATCH v3 3/5] crypto: pkcs7: allow pkcs7_digest() to be called
 from pkcs7_trust
Message-ID: <20260305213651.GA64054@quark>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
 <20260225211907.7368-4-James.Bottomley@HansenPartnership.com>
 <20260226203133.GB2273@sol>
 <bf8b8c374d4398a677b87246bb426c4cd157e1d0.camel@HansenPartnership.com>
 <20260305075831.GB155793@sol>
 <51cf814b5dd2a126c4b2379c7b7d02ff9d2e17f2.camel@HansenPartnership.com>
 <20260305185016.GC2796@quark>
 <8fc67a378cc379065fc187e00e728956a86c9894.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fc67a378cc379065fc187e00e728956a86c9894.camel@HansenPartnership.com>

On Thu, Mar 05, 2026 at 03:11:29PM -0500, James Bottomley wrote:
> On Thu, 2026-03-05 at 10:50 -0800, Eric Biggers wrote:
> > On Thu, Mar 05, 2026 at 09:53:56AM -0500, James Bottomley wrote:
> > > On Wed, 2026-03-04 at 23:58 -0800, Eric Biggers wrote:
> > > > On Thu, Feb 26, 2026 at 10:50:10PM -0500, James Bottomley wrote:
> > > > > On Thu, 2026-02-26 at 12:31 -0800, Eric Biggers wrote:
> > > > > > On Wed, Feb 25, 2026 at 04:19:05PM -0500, James Bottomley
> > > > > > wrote:
> > > > > > > +	/*
> > > > > > > +	 * if we're being called immediately after parse,
> > > > > > > the
> > > > > > > +	 * signature won't have a calculated digest yet,
> > > > > > > so
> > > > > > > calculate
> > > > > > > +	 * one.  This function returns immediately if a
> > > > > > > digest
> > > > > > > has
> > > > > > > +	 * already been calculated
> > > > > > > +	 */
> > > > > > > +	pkcs7_digest(pkcs7, sinfo);
> > > > > > 
> > > > > > pkcs7_digest() can fail, returning an error code and leaving
> > > > > > sig-
> > > > > > > m
> > > > > > == NULL && sig->m_size == 0.  Here, the error is just being
> > > > > > ignored.
> > > > > 
> > > > > That's right.  Basically I wasn't sure what to return on error
> > > > > (although -ENOKEY looks about right since it will cause retries
> > > > > on
> > > > > a
> > > > > different sig chain).
> > > > > 
> > > > > > Doesn't that then cause the signature verification to proceed
> > > > > > against an empty message, rather than anything related to the
> > > > > > data provided?
> > > > > 
> > > > > Not if sig->m is NULL, no, because the verifier will try to
> > > > > reget the digest in that case (and error out if it fails).
> > > > 
> > > > Can you point to where that happens?  It still looks like it just
> > > > proceeds with an empty message.
> > > 
> > > It's the obvious one:
> > > 
> > > verify_pkcs7_message_sig->pkcs7_verify->pkcs7_verify_one-
> > > >pkcs7_digest
> > > 
> > > The latter will allocate and calculate the digest if sig->m is
> > > null.
> > > 
> > > Regards,
> > > 
> > > James
> > > 
> > 
> > But looking at hornet_check_program() from
> > https://lore.kernel.org/linux-security-module/20251211021257.1208712-9-bboscaccy@linux.microsoft.com/
> > ,
> > it calls:
> > 
> >     pkcs7_parse_message()
> >     validate_pkcs7_trust()
> >     pkcs7_get_authattr()
> > 
> > The actual signature check happens in validate_pkcs7_trust(), which
> > appears to have the issue where it can proceed with an empty message,
> > as I mentioned.
> 
> The whole design of validate_pkccs7_trust() is to validate the
> signature only so we can trust the attributes.  It doesn't actually
> verify the digest against the data, that's the job of the
> verify_pkcs7_sig.. class of functions.  The original thought behind
> this was that we might not have the original data by the time we came
> to extract the OID.  However, it turns out we do, so the split of the
> trust functions is not really necessary..

But surely you *do* want to verify the data as well, as that is the
contents of the BPF program?  I think the API you want is something like
verify_pkcs7_signature() extended to return your signed attribute as
extra information on success.

Of course, again it would be a lot simpler if you could find a way to
format all the information you want to sign into one message, instead of
relying on the PKCS#7 message-within-a-message thing that is hard to
understand and implement correctly.

- Eric

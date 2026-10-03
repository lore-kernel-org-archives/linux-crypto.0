Received: from mail-qv2-f43.google.com (mail-qv2-f43.google.com [74.125.230.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602538F954
	for <linux-crypto@vger.kernel.org>; Sat,  3 Oct 2026 17:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791049440; cv=none; b=ddw1502KmmMBQxEus/Fw2jcwJ7xaHEZGnTb4Ojfe9uHSVNaRnJ+DgI5x/PbitbMO9hLnTBN3vev5POx+BKyrkPFj7soheE1IVn9JSRkF3GwgpvuyiuZE5Wl0o51g1kQ7bx2J1c5W3BGWU32rXmVmRFz4n6AU7KKsCRX8JgzVdR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791049440; c=relaxed/simple;
	bh=53CDqkC1FfujZBKX8pVeoPxAUMeRk0D2ckPl1D+NIQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOCNaoGzGn7hQOGgnq8LS9Y4MZ/gnEinvgyuc7jdER1WrFfoHKK2Jta/zlPeb7XOgYIFsxyoTl6RX5CzydYMB7jeFhoTQQ+lkC482l/9thCgTEIGztckYE4eT7yZlCOT6hyJBbcIv/cd5PsBCfHqfF+rFDMj0AP+U7aoBXqYaaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=aiLEHLjB; arc=none smtp.client-ip=74.125.230.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="aiLEHLjB"
Received: by mail-qv2-f43.google.com with SMTP id 6a1803df08f44-919552173fbso9855956d6.3
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 10:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1791049437; x=1791654237; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nae9UyLsgxD5DtiApDpEZVQ4AiL9YBE5VfRS+2MznRQ=;
        b=aiLEHLjBJWMuP2UAdf5vBdXdG2Qio15zIyZ9Ja3ACSCA6y4fbCES2QL+8KORgi/xcu
         jrXgHBtEFTjcwBoQqi5969fmcCjNwEJGeDkJvQJhcx0kTrFLa0uMTVPEyrqVMtqOhj0l
         0Ph4d4FkDAR8cuTzOxvjfSCV37UVKL6HrJfeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791049437; x=1791654237;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nae9UyLsgxD5DtiApDpEZVQ4AiL9YBE5VfRS+2MznRQ=;
        b=W0wn8Tb4HautG2+t52ZClbi8bMNtujqDng4Fm5Op/HVg2iK/osu3bSlC82CsHJsNOi
         C0AvD4+yYml7+dKOk475uy71jQK7zNIa0mvuLFv7KaU2YyAooIuf8DeOlnco2hqwYqWo
         vCYBQRXmF3zd9uyRdSO2HwFUeZuXwUk63R5gq/MvFf4sg/dFRRDv2fhw8UIX9bHrwgYd
         4yXxI0YBjn6XaChkWnthHM1TpuoxvTaZ+mDfTYzqkErgcuhqi7YusIAy+UMmwW795O7B
         g8n3FnQbGNq66qFmHUZK4xMD1Y0SOzra4cPubfguVZf7UV6FXbRgQlHP01JQCM5RXRvP
         gVYg==
X-Forwarded-Encrypted: i=1; AKwUvBwvOa1cV7cBB1/O3CMvAMH9AUW1+vEoMbKUaIy6oIXrOsOO6R8AkkZzis9/l3y5ddiJ8fYOWCtNA95MxrY=@vger.kernel.org
X-Gm-Message-State: AFuF++l167/j5HytKYHJu6JGgY2D2VG49Rh2mjT7nsnWnfMZApHy28wz
	XCso2Fz54tQZU8mmQbkGfi1N+c8Ut1EgiLZfyAJGL8vFAlDPsD7ng1po01M1hmOSvw==
X-Gm-Gg: AYBFou3x0945njKpMiMNwelOPxOJZexet6Wt2Uxh8Zy2T7ET0OzGR8q/TB0EqMIaqTe
	lMVsN69hkzowbatkj/MZkF8mH8XwejuPgodLgflT6nQdhvUTmmEqivT/e+pGAYqE3ZMoi+SE/DV
	XyxOOROvSJAr6OmQnIWTLzmn3Vu11Il8e7cSXUPvit165h9M63T2t0X2hVhWvVLbR3xWVMaZBzD
	6TOBuGb6FX3V17gnOIM+i+tUEIFlcRN5ExH6Kn2IPTMhoUT9paxkk1Zj16GWkmriB78yyOZPbIQ
	jZftBmIrXMBpv5j0kUaMhkYhhID0OvdeNNb89b99CRbmy6HFXF0YhhKIO3vuDsX3Wk//Ivu5R8z
	yVcC0+5sZF9AkQjTXcvW17iHViOnjhZf9mGePJ+oZSfvF+SDK0Nk2JP8QAx0VRtKhnyVMHjsVun
	xwIhH89tU5ViLCeo3ZHjCMH9uZJsWE6XjbO+gD/+h8a6okW9GbslI+P4S95L6lbPktSxFVwISH3
	QXv0sSTn8/9zjvBx9Vc6nLoo+wZ
X-Received: by 2002:ad4:5ccd:0:b0:917:af36:df30 with SMTP id 6a1803df08f44-917c0060951mr127017846d6.16.1791049437314;
        Sat, 03 Oct 2026 10:43:57 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.107.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917d565489dsm48071036d6.0.2026.10.03.10.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 10:43:56 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Sat, 3 Oct 2026 11:43:54 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow hmac(sha512) for unpriviledged users
Message-ID: <asE-2qMif7mw-Hac@fedora64.linuxtx.org>
References: <20261003160302.3000325-1-jforbes@fedoraproject.org>
 <20261003161859.GA152469@quark>
 <asE128W4CxHDCFiB@fedora64.linuxtx.org>
 <20261003173744.GA158720@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261003173744.GA158720@quark>

On Sat, Oct 03, 2026 at 07:37:44PM +0200, Eric Biggers wrote:
> On Sat, Oct 03, 2026 at 11:05:31AM -0600, Justin Forbes wrote:
> > On Sat, Oct 03, 2026 at 06:18:59PM +0200, Eric Biggers wrote:
> > > On Sat, Oct 03, 2026 at 10:03:02AM -0600, Justin M. Forbes wrote:
> > > > By default users cannot run sha512hmac with the current set up. This
> > > > is problematic because our kernel builds call this for FIPS compliance.
> > > > Rather than have anyone turn off af_alg_restrict all together, let's
> > > > allow a common use case.
> > > > 
> > > > Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> > > 
> > > The fips hook in dracut was taken into account already, and it runs as
> > > root.  So this patch shouldn't be needed.  Can you clarify why you think
> > > it is needed?
> > > 
> > > - Eric
> > 
> > Specifically for the case of Fedora and all Red Hat kernels, we call
> > sha512hmac to sign the kernel, and a couple of UKI images that are
> > created during the kernel build. Users on Fedora 45 and newer are now
> > unable to build the kernel from spec without turning off af_alg_restrict
> > all together, while any user can build a kernel on Fedora 44 or older.
> 
> I see, it's in redhat/kernel.spec.template in the Fedora kernel source
> tree which is used when packaging the kernel into an RPM package.
> Please make that super clear in your commit message, because it wasn't
> clear you were talking about something different from the use in dracut.
> 
> I guess the actual diff is fine then, since something like this that's
> being used should continue to be allowed.
> 
> Of course, this is yet another gratuitous use of AF_ALG, as I've
> explained previously
> (https://lore.kernel.org/r/20260504173952.GA2291@sol/).  Depending
> AF_ALG to build the kernel (vs. just using OpenSSL for example) is even
> more misguided than using it in the integrity check itself, as at least
> there are FIPS boundary considerations for the integrity check itself,
> but those are irrelevant for the build tools.
> 
> So even though this will keep being allowed for now, please work to get
> this fixed to not need AF_ALG.  Note also that Fedora 45 explicitly
> deprecates AF_ALG (https://lwn.net/Articles/1088489/) on top of the
> already-documented upstream deprecation.
> 
> - Eric

Understood. I am one of the people behind that change. Basically it
means we backported all of this into 7.2 to make sure that Fedora 45
ships with it by default. The hope is that we can get this all worked
out to the point that we can turn off AF_ALG all together by Fedora 46.
But this piece in particular caught me by surprise, and this will give
us time to get it fixed properly.

Thanks,
Justin

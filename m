Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34A616A395
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759779953; cv=none; b=NzYoMHZTB2Tcf6V85uK374WOU6PfObSxN2vuuh4ZLCYNUoi+7LzLgwpY83ZKNUIwZVZMf+QjWRrld3b+XOa4U5mRBFdSDS0axFBCFWVFZtFtoSzWD/SCZ79Vcd7XvVllwjfsmyuws0MKoo1wVjxrK4AYUD3QxtcfOIjE6v+4cLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759779953; c=relaxed/simple;
	bh=x+ftkWY5fwkw39EHN2Kyi0GJJnaTzx3hijkVj7JP2MY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HuyGyyAvA1BRxkbS0Qlff6wkFh3hvHGzFaVcZoEfaQZnLGIhzE3eT6gJfoT6A2AFuyS8eb8ll//K44X4yWhmEvRvrC3WRzGPlNNFYojMLzDdMVvedNaeE7x8/04E7EzVNIKBFTFrhsKfwlHMuEb4IhcOaPfR+lPa7kQti7mp1i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f2dAtET+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f2dAtET+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759779950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bww/a9+3wdLbRI/iBMrrt7lr6xjDvm4RQk8ELkL6obs=;
	b=f2dAtET+41bKdgS56/rKt9e6pQVacBrpFtZgNHV+PpO3rfoufDIbwMFtOwe60IFw2Kphpj
	s1e8iGALXFhVU3zMEcOhxs2v2dajDsROm5WH7ihx1viBdrJetOybhu4M4zb5I9kdppcgYX
	CX5LLgQt6UtaMIRA85F5Dsq4qcxaFyY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-afV53W-EM5Sl1cQlilrh_Q-1; Mon, 06 Oct 2025 15:45:49 -0400
X-MC-Unique: afV53W-EM5Sl1cQlilrh_Q-1
X-Mimecast-MFC-AGG-ID: afV53W-EM5Sl1cQlilrh_Q_1759779949
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-78f3a8ee4d8so100565366d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 12:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759779949; x=1760384749;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bww/a9+3wdLbRI/iBMrrt7lr6xjDvm4RQk8ELkL6obs=;
        b=dl1IlMaiXBIP9qORi3rJ36QbcXMIcpYP3pS0E3z1uT4JURoEfPphD+NyNPT/cY9x7n
         53LzhtOKUU4N3YLVf9H0TLUYTZHtj1yt6z0sQJ2/duYP7IXL5Eqsen4U2/fiIdVpfIgT
         DowX3h2JZqMbthgqp0AjuZW4RhlFHrzk78HuN35V0X6oBX4PGbx3fah1PkRNg3lJHk1/
         sQNppX20yJEcO9k2xbV/7maIm7NyfHelV5ER6QoXc60QPYWb8QdgGOHfUfdVhrdsCCt/
         gBdUzPS3SU058MHSXKWZaDTiQm7PNyollMSNzo9XSeMc49B7zfKQjqPc1D5c5B2Njg0A
         FeYw==
X-Forwarded-Encrypted: i=1; AJvYcCWJniXTvludyOnovWWn7FEUWabymId0A8Y4B9xdWcPwn5VErt2BIVb1dbiyZeOiSD+zUfjVqalZn5gwiCE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9nwl+03H2eQolNGDoF2Y1HRJXV5nv/mgfQoCxfpgVnVarnfa2
	cSCJbiI0q8Q4MDebSajIqxUXf9XtISb1aEoUVx0pMS1Fn4t6t4SZUETJ9MMHbFlWhNU3kQU6ykB
	cQhHKYIR5OqzRSVI52PJ1qHub72v60zR6MwFUzaBExcxHN8liu+AJuw0jtHtgVS32Sw==
X-Gm-Gg: ASbGncvVLzDrqkAcGQAn8F5C26dXIoFJXNBCekk73oVuinQE51LhNsJmDwzbdWIHkuo
	R7Izx97+4U1BlBeDapF/R2OJKMnhb29XP7ieHzbFqD2u36lgw2yhSvj4o7zdBvmRWBQkZQ67YgV
	xZi6EjYpysJT1A7i1DwfD6mbhCYHidijR12p+wpMMMuvVeUaRLYqtty6YB71SFtwN1hnSViE6Pz
	18f9v8s3bNz99LZXpnrNXN+yr+HAtqfUMQTZC6ossC2q1ltj6QWpuxPd8u5wDAyVP9Fws1CJO/H
	oosEyC9qnEORJjwvrMaGplROI/5Dd5WDtrude0rj
X-Received: by 2002:a05:6214:2465:b0:820:a83:eb04 with SMTP id 6a1803df08f44-879dc799aa2mr132540556d6.20.1759779948786;
        Mon, 06 Oct 2025 12:45:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHY1TaTfi2eevE1f8zq7Sc6pe4IW7SS1PPzrteUKIgFuyF3z0hFZTwxqNXjqadsyaHbu1ADIw==
X-Received: by 2002:a05:6214:2465:b0:820:a83:eb04 with SMTP id 6a1803df08f44-879dc799aa2mr132540316d6.20.1759779948323;
        Mon, 06 Oct 2025 12:45:48 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bd783bb7sm125065946d6.41.2025.10.06.12.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 12:45:47 -0700 (PDT)
Message-ID: <0acd44b257938b927515034dd3954e2d36fc65ac.camel@redhat.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
From: Simo Sorce <simo@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, Vegard Nossum
 <vegard.nossum@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jiri Slaby	
 <jirislaby@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Crypto Mailing List
 <linux-crypto@vger.kernel.org>, netdev@vger.kernel.org, Jakub Kicinski
 <kuba@kernel.org>, Theodore Ts'o	 <tytso@mit.edu>, "nstange@suse.de"
 <nstange@suse.de>, "Wang, Jay"	 <wanjay@amazon.com>
Date: Mon, 06 Oct 2025 15:45:46 -0400
In-Reply-To: <20251006192622.GA1546808@google.com>
References: <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
	 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
	 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
	 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>
	 <20251002172310.GC1697@sol>
	 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
	 <CAHk-=wjcXn+uPu8h554YFyZqfkoF=K4+tFFtXHsWNzqftShdbQ@mail.gmail.com>
	 <3b1ff093-2578-4186-969a-3c70530e57b7@oracle.com>
	 <CAHk-=whzJ1Bcx5Yi5JC57pLsJYuApTwpC=WjNi28GLUv7HPCOQ@mail.gmail.com>
	 <e1dc974a-eb36-4090-8d5f-debcb546ccb7@oracle.com>
	 <20251006192622.GA1546808@google.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-06 at 19:26 +0000, Eric Biggers wrote:
> On Mon, Oct 06, 2025 at 09:11:41PM +0200, Vegard Nossum wrote:
> > The fact is that fips=3D1 is not useful if it doesn't actually result
> > something that complies with the standard; the only purpose of fips=3D1=
 is
> > to allow the kernel to be used and certified as a FIPS module.
>=20
> Don't all the distros doing this actually carry out-of-tree patches to
> fix up some things required for certification that upstream has never
> done?  So that puts the upstream fips=3D1 support in an awkward place,
> where it's always been an unfinished (and undocumented) feature.

FWIW downstream patching, at least until recently, has been minimal.
The upstream behavior has been good enough to be representative of the
behavior you would expect from a certified binary.

Note: this may change going forward, but I am confident that as issues
arise people will propose upstream patches to keep it as close as
possible within acceptable parameters for upstream behavior.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc


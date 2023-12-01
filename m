Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvBWTi1J"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224C210DA
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 11:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701458741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tt4VoE87JLOfTrJPPSXo0vgDxgqgJgly7s6qG0iICLg=;
	b=XvBWTi1Jxf5ochRyyXhDkPHl2QsXLbS+d2Y1DJE+FnY5ZvfaPm1Slz+jvFGAeGnnlZzjLI
	/mEA4bibpRqjitCpi6hsrBe0DTIKR1P74+I74454CkNr8awo77Px9QeFYwf3jTEV4GQ0DW
	eQDNrJFdWJ0qOwLTGOICJzOQCgQZRdQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-x_gfbpuzMMacd8tXLRGZVQ-1; Fri, 01 Dec 2023 14:25:39 -0500
X-MC-Unique: x_gfbpuzMMacd8tXLRGZVQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4238a576bfeso36978751cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 01 Dec 2023 11:25:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701458739; x=1702063539;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tt4VoE87JLOfTrJPPSXo0vgDxgqgJgly7s6qG0iICLg=;
        b=ZGLqMsae1bcMG2SDtCMg1UiU3JA48JryJTisV+nlxDVYR7kDFsBeGgN0pcdhXXytT0
         uSQsjRVo9A82Dp5xSLUW7m2UNdsdIZ6hwqMfJxn4+l//uNatxOXtWLql6BJ24Gjw+KAt
         GoSSnlm1UVtkWaEviwxyL6CRV4Kc71gVteMs0/M0M0pMN5PeIDmTU4nsg25npsmkF2Wv
         qg/X7BZMAodT8oisXMrgb/lFw+QFb1ug1YlUptwjKVViyDqzv8M7V9iFh/o9VuwobiFn
         As2ZTpCPe1R+tWfBwOBQb8A5YvXO+NjD1hHyG9ELeRlwFCXkMxm4a1jAywJbLF1G0ZH3
         UfcQ==
X-Gm-Message-State: AOJu0YwV2kTbFrGtOdIJZbUXgqkTKGB6ogZjkDDm/GkzigPA6Kf0w++n
	jQDglDK1tk6UvENhcqHrpNU4i/S4elIEbQZeTDGXLEncr7lNy5q49qqQAZ1ADIzPpoba32JFJnZ
	ilW69APLy4+gQGY84j8OJXJXH
X-Received: by 2002:ac8:5ccb:0:b0:41e:24aa:81a0 with SMTP id s11-20020ac85ccb000000b0041e24aa81a0mr35409643qta.62.1701458738907;
        Fri, 01 Dec 2023 11:25:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0Z0PZy06L+nM/mBwW9vEOgc6MD91PPMLBJrnR+KnmmAlOHfnc8OSUMs0flBnu9l6FNWSCFg==
X-Received: by 2002:ac8:5ccb:0:b0:41e:24aa:81a0 with SMTP id s11-20020ac85ccb000000b0041e24aa81a0mr35409587qta.62.1701458738102;
        Fri, 01 Dec 2023 11:25:38 -0800 (PST)
Received: from m8.users.ipa.redhat.com (2603-7000-9400-fe80-0000-0000-0000-080e.res6.spectrum.com. [2603:7000:9400:fe80::80e])
        by smtp.gmail.com with ESMTPSA id d9-20020ac851c9000000b00421c31faf05sm1740104qtn.1.2023.12.01.11.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 11:25:37 -0800 (PST)
Message-ID: <e1b3ccb744d67e6214cf206ba8480cb3e35694cf.camel@redhat.com>
Subject: Re: jitterentropy vs. simulation
From: Simo Sorce <simo@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>, Anton Ivanov
	 <anton.ivanov@kot-begemot.co.uk>, linux-um@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, Stephan =?ISO-8859-1?Q?M=FCller?=
	 <smueller@chronox.de>
Date: Fri, 01 Dec 2023 14:25:37 -0500
In-Reply-To: <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
References: 
	<e4800de3138d3987d9f3c68310fcd9f3abc7a366.camel@sipsolutions.net>
	 <7db861e3-60e4-0ed4-9b28-25a89069a9db@kot-begemot.co.uk>
	 <8ddb48606cebe4e404d17a627138aa5c5af6dccd.camel@sipsolutions.net>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2023-12-01 at 19:35 +0100, Johannes Berg wrote:
> [I guess we should keep the CCs so other see it]
>=20
> > Looking at the stuck check it will be bogus in simulations.
>=20
> True.
>=20
> > You might as well ifdef that instead.
> >=20
> > If a simulation is running insert the entropy regardless and do not com=
pute the derivatives used in the check.
>=20
> Actually you mostly don't want anything inserted in that case, so it's
> not bad to skip it.
>=20
> I was mostly thinking this might be better than adding a completely
> unrelated ifdef. Also I guess in real systems with a bad implementation
> of random_get_entropy(), the second/third derivates might be
> constant/zero for quite a while, so may be better to abort?
>=20
> In any case, I couldn't figure out any way to not configure this into
> the kernel when any kind of crypto is also in ...

Doesn't this imply the simulation is not complete and you need to add
clock jitter for the simulation to be more useful?

You can use the host rng to add random jitter to the simulation clock.

Simo.

--=20
Simo Sorce,
DE @ RHEL Crypto Team,
Red Hat, Inc





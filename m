Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE4E1DFDE;
	Tue, 28 May 2024 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902947; cv=none; b=dFbU/CsdpgVsDjezpXmc85V8NEjr2El3yEczfuhpCpQWPUb2mkvETSN4oUbvZBoKMtuYlG4PkNkRsi2dkDoTcmJ+NOGIG304SrV23Lo9dg+rmdUwyK31pUjTvC7dQx+/dlFefQ8dUBCTWyeHogBzoGsL8ll2Qf72W+oEU/HUpjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902947; c=relaxed/simple;
	bh=xyyTmTzN9d8hqo9iRE/ESmgFIUN4LB9umMa2nCS2waI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=F2PNTq0e9jfrXsytJRrAF8iN/7bX8xFfCZ8RNvFSeIpUmD3ymm1TaqvZ0B+URJ9kW2jQdYgFjPh2sgIprXRibTtUdiM8yAXZ47s7MxoKhR09QlrWiezPvZ2UI7UHb3xVOU8n1z/dULyAnPyb9M0dv301nrzVG7OvTcWQGMRgEyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3IC5dJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3IC5dJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7143BC3277B;
	Tue, 28 May 2024 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716902946;
	bh=xyyTmTzN9d8hqo9iRE/ESmgFIUN4LB9umMa2nCS2waI=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=H3IC5dJRl7xG89iDpASrt8tZba/beNU9g20FeAZl2g/h0uH/mKw9uPEYDp37YBLQ8
	 uHU9vl7Ou4ioTe0i2hq1xTz2WZ3rRXbyelwyvS9HxMftlXDkpwaM6Zwa3segTW6IU2
	 YQ8m4cBvkljr5eFAVfeEuA0y4CKrdma+12FNxhFSAjldN5HnM3mOhYecpZwHCAZiJ9
	 cN/5JZsLtPVDyT9p5vZaxAX3C/9ryOZUsqyG4ksR57pFiBtyhtK1byVx0eAdSG8VZQ
	 9hXPyYtz0YO9uQO4fWwVXB5xA6KHbq/OUOpnKv4AVm/rIj0UEVBlbYUHxEJZgsTbSX
	 HnmVMh5IiRMNQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 16:29:03 +0300
Message-Id: <D1LBARSTFSFC.1DQSHTGGDL0C6@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Stefan Berger"
 <stefanb@linux.ibm.com>, "Herbert Xu" <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
 <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
 <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>
 <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>
 <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
 <b5ff9003-065f-437f-bf6b-7f1ae0a0364a@linux.ibm.com>
 <D1LB8PVCTP1S.JDCEWNODTGTQ@kernel.org>
In-Reply-To: <D1LB8PVCTP1S.JDCEWNODTGTQ@kernel.org>

On Tue May 28, 2024 at 4:26 PM EEST, Jarkko Sakkinen wrote:
> On Tue May 28, 2024 at 3:37 PM EEST, Stefan Berger wrote:
> >      Signature Value:
> >          30:45:02:21:00:d9:d7:64:ba:5d:03:07:ee:20:a0:12:16:46:
> >          31:e6:8e:66:0c:17:0d:74:07:87:58:5a:13:fc:14:62:98:9a:
> >          99:02:20:59:ff:29:9c:52:b9:0a:35:3c:4b:03:bb:47:0e:c8:
> >          3e:2d:cb:3e:1c:d3:51:88:91:b1:40:e3:03:86:1b:2a:e8
> >
> > 30:45 =3D> sequence containing 69 bytes
> >    02:21: =3D> first coordinate with 0x21 bytes
> >      00:d9 =3D> 0x21 bytes of ASN.1 integer with leading 0 to make the=
=20
> > following 0x20-byte integer a positive number (its most significant bit=
=20
> > is set).
> >    02:20: =3D> int with 0x20 bytes
> >     ...
>
> This actually helped me located the bug in my code: I had 32 bytes for
> the first one, with no leading zero. I.e. total length was off-by-one.
>
> So I'll just extend either or both based on msb?=20

Actually I use a patch that I made for early version:

https://lore.kernel.org/linux-integrity/20240521152659.26438-3-jarkko@kerne=
l.org/

BR, Jarkko

Received: from server-598995.kolorio.com (server-598995.kolorio.com [162.241.152.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938618DB24
	for <linux-crypto@vger.kernel.org>; Sat,  8 Feb 2025 22:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.241.152.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739052651; cv=none; b=fmg36rmiZWumrhT79hJfqRRIGoPJS4wv0noKVxxjR9H+KRoh2GzMQSmphHmEOmRtosjr3pOl53D2WIcf4tqPqLQXqzgKecG5ZcNuwT/P4Cr6hqLf2EOi4WEclBd4qncmFYjZRTK7RV2VPkTJVMjVTP67VC6vPQSd2VtIm5h3fnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739052651; c=relaxed/simple;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sFUyiNRgcwXuICF9dvAh/4MRE4awn9rfCnZ/lq0zIIaZLuX3ocToQ/UbPSOLmWSybpbKmfP+x5fNkBoFk2f7sNVfaTvzImYoGupiYDz6ELOvzbflkwFhnFXTOVwlyINh8lIGxKqIX3+bOt+todAv+m0pfZzAoahmVYvJy28rGOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz; spf=pass smtp.mailfrom=truemaisha.co.tz; dkim=pass (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b=fCRYXtOj; arc=none smtp.client-ip=162.241.152.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truemaisha.co.tz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b="fCRYXtOj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=truemaisha.co.tz; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=; b=fCRYXtOjzZ6x5iRJ1m/jq8Ic4k
	5UrKRwcd9KVceNTpvfJwdt34aPkB54w3afb5uJr16vXbpcGvggufjok+QKGQnXdyNgjlnjuLBk+Pk
	zFHZHcOgy+vNUi+gslrLXSHzJauybWRpg0mYxH39QIFe91g3A/sikekqN0e1mRGfMFKmBgD6fDoQB
	5DLeWXx5aW/hNT82MztL1X6c3T3dfpJKuMbqfwIzJBle47MiKDIQ1tt/HD0yJ2wX3LR3NB54LGcfH
	rGwMkSN0s5g9nV504arQkskpAiOX4Jph+t7HAJ5nnH8SNUcqrpTLOiuhWvPxQ1m/l/8Ri2o1yvku8
	0qSSLq/g==;
Received: from [74.208.124.33] (port=59640 helo=truemaisha.co.tz)
	by server-598995.kolorio.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <chrispinerick@truemaisha.co.tz>)
	id 1tgt2E-000506-1a
	for linux-crypto@vger.kernel.org;
	Sat, 08 Feb 2025 16:10:47 -0600
Reply-To: dsong@aa4financialservice.com
From: David Song <chrispinerick@truemaisha.co.tz>
To: linux-crypto@vger.kernel.org
Subject: Re: The business loan- 
Date: 08 Feb 2025 22:10:48 +0000
Message-ID: <20250208210542.C99E850529416F00@truemaisha.co.tz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server-598995.kolorio.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - truemaisha.co.tz
X-Get-Message-Sender-Via: server-598995.kolorio.com: authenticated_id: chrispinerick@truemaisha.co.tz
X-Authenticated-Sender: server-598995.kolorio.com: chrispinerick@truemaisha.co.tz
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hello,

My name is David Song, at AA4 FS, we are a consultancy and
brokerage Firm specializing in Growth Financial Loan and joint
partnership venture. We specialize in investments in all Private
and public sectors in a broad range of areas within our Financial
Investment Services.

 We are experts in financial and operational management, due
diligence and capital planning in all markets and industries. Our
Investors wish to invest in any viable Project presented by your
Management after reviews on your Business Project Presentation
Plan.

 We look forward to your Swift response. We also offer commission
to consultants and brokers for any partnership referrals.

 Regards,
David Song
Senior Broker

AA4 Financial Services
13 Wonersh Way, Cheam,
Sutton, Surrey, SM2 7LX
Email: dsong@aa4financialservice.com


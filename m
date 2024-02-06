Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886C51CD38
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 21:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707256025; cv=none; b=jKEnQFLD7Ew4J3SBand/6ySObqlVOlWD744Rp+8LJvB9VpjFi8Ry+n+QfCedvQzN63Kf1LtCb0FsK5ceu6iZUI7vvxGsPWR1D9gYa3ymNUBJipMm1cNdiTXhkkcDPFGQGWSUgZN97F9f+3jDP3mbJI70ZadRFMtLBectZ9R/Sk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707256025; c=relaxed/simple;
	bh=7ywXEtr/UZE4POA2+/UNbLOVQXFOQtlQe2TNaTzprEw=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Tq6oKshSyRgrFzMXCLb5SjcmGlTACykWU+T1E7GH3IPnADuOT0mRqXAA0HqxfSfsEmKogapbFlUNgYdSqwPqwDmTAioD2tHfoq9lHywHeL1YRikXJiC1ShdTpc7kedHd0IUUqecnq6PeGWmKEyMqlka0TpW/aD7PZk2T48YgalE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VaBipMUM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VaBipMUM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707256022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=zGjMP1IOUXwVMDC5kAkBaxijYMamXyALIeSRPPpA03c=;
	b=VaBipMUM1qqG4fIzEmnoL2yJKYfcpulTBMvHkKbCgJ3/E0BrDW8z1kHZ8s/qD1hrPsRYu1
	HtE85JmpI5aXlAuaiA2AJz/RrN71L5S5dMiVPHkQbWQ7jzvGa0KFKfNsmJHwdBmnLPtr01
	SHJsTeFCWzt554vG5BnWD4FqjyfCl9s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-VGXLBbFcMYGSkHF3tpgSIg-1; Tue, 06 Feb 2024 16:47:00 -0500
X-MC-Unique: VGXLBbFcMYGSkHF3tpgSIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63C58828CE2;
	Tue,  6 Feb 2024 21:47:00 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DEC740C9444;
	Tue,  6 Feb 2024 21:47:00 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id EEC6930C1B8F; Tue,  6 Feb 2024 21:46:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id EBCA03FFC5;
	Tue,  6 Feb 2024 22:46:59 +0100 (CET)
Date: Tue, 6 Feb 2024 22:46:59 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>
cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: A question about modifying the buffer under authenticated
 encryption
Message-ID: <f22dae2c-9cac-a63-fff-3b0b7305be6@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Hi

I'm trying to fix some problems in dm-crypt that it may report 
authentication failures when the user reads data with O_DIRECT and 
modifies the read buffer while it is being read.

I'd like to ask you:

1. If the authenticated encryption encrypts a message, reading from 
   buffer1 and writing to buffer2 - and buffer1 changes while reading from 
   it - is it possible that it generates invalid authentication tag?

2. If the authenticated encryption decrypts a message, reading from 
   buffer1 and writing to buffer2 - and buffer2 changes while writing to 
   it - is is possible that it reports authentication tag mismatch?

Mikulas


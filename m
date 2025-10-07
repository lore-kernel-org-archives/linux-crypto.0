Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1582E8DEA
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759857093; cv=none; b=OwOjQInkqX5kZr4OMHL08CdO84nan33t406uXkc9rBQJNYeQqWg1U3c8ckKmEZyr4m6WpOixGzzViqOm/0wJva5Bt227iQx+Zq3GidvstUKIqSZCkl67vLft4Yr/auT1x+my0Rpivq6Ia14mtICTp3ugsxoV7WOcAGI1a/WriPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759857093; c=relaxed/simple;
	bh=oZy7AKjaSJccZXYUq4t4wY2Tq/5OJyalVz3k1tlFsLA=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=pD1nua3Odt1n/+pZXuCCxcILimoeqQ9JRVWRc71e7if/aI07dyROEN3AqxOpQLSJLmrbEnZuMxPeOtJfv83BCF7DNXzjMIHqEGSGmRvXllFEi+CkzCyur6D3gexGBX3kdMNLRALF0uNcqU6FUKiUi8RSvTSyZHm6HgtXCH1zuuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6wz06gB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6wz06gB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759857091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=oZy7AKjaSJccZXYUq4t4wY2Tq/5OJyalVz3k1tlFsLA=;
	b=H6wz06gBENQWBA+a7NOWMEAklF1Xwnvb2Yj7IPvU+aysUf0AEhhJHZoIDXyNi//I1JNlO7
	nByhVDtinRQMvebLVmnOjq80iGEa4lzkTz78PxOmxw9HWSnjJJRIh0xJGZw3fYosaTJha3
	ZX9V7Z9ZDOVvNtnMj00GLwfGDJkeYdo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-A1YJbw92P1WVHiljAHv2YA-1; Tue,
 07 Oct 2025 13:11:26 -0400
X-MC-Unique: A1YJbw92P1WVHiljAHv2YA-1
X-Mimecast-MFC-AGG-ID: A1YJbw92P1WVHiljAHv2YA_1759857085
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59B7018004D4;
	Tue,  7 Oct 2025 17:11:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.24])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6AE91955F21;
	Tue,  7 Oct 2025 17:11:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: dhowells@redhat.com, io-uring@vger.kernel.org,
    linux-crypto@vger.kernel.org
Subject: io_uring and crypto
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4016103.1759857082.1@warthog.procyon.org.uk>
Date: Tue, 07 Oct 2025 18:11:22 +0100
Message-ID: <4016104.1759857082@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Jens,

I was wondering if it might be possible to adapt io_uring to make crypto
requests as io_uring primitives rather than just having io_uring call sendmsg
and recvmsg on an AF_ALG socket.

The reason I think this might make sense is that for the certain crypto ops we
need to pass two buffers, one input and one output (encrypt, decrypt, sign) or
two input (verify) and this could directly translate to an async crypto
request.

Or possibly we should have a sendrecv socket call (RPC sort of thing) and have
io_uring drive that.

The tricky bit is that it would require two buffers and io_uring seems geared
around one.

David


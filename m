Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F174287271
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 20:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757969517; cv=none; b=mfZbJm6gkB0jLfTjk/VzrWMkY8Rw5Rc9NBr4Eb5QE7krT6IyoSbjUteQsV6PciIlE5xYyqFRapmMObE6a/c3WvH4yvdVw9Tg3yOtOiAqpDjHHseEIk/1Zj1/HE77My89xlyIOXdG3kNZTUWiMwThsbmnEzcVYM6QFkuPBPRJSa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757969517; c=relaxed/simple;
	bh=Ns3FlwsyewMIY9rdeqW7oGf2/H5rPjfACY1zFr4nWKU=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=NxxtjabW/Pg0wsi0GYduYu0N1SEuQqKy4PopTSnxrBDNg/KFP0IbcjtHlzW8rUwmmR8LnZzei8CB2m/XXyUNUvqDsyh8OMZD8sWLiJ/lTS4rE4egYozS/E7l6Mft4cNqjOCRDFj39SCZ3YE/JoUv/jHn8HKs0tIDhntEjpW0lbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dvXoWLDw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvXoWLDw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757969514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Ns3FlwsyewMIY9rdeqW7oGf2/H5rPjfACY1zFr4nWKU=;
	b=dvXoWLDwnfw8YwqmOp1gecnweLO0wL6CO0GOMyT5TsM9zFI+j9G+bDlTn2beCbASMsysWm
	daCabuTZpvcb0w1A73IqN7ahBpFH8r6pK2ijLbvmoolxsDAnEufnQUevZNRElRnwp/zCxi
	21V+GM8jSOYZ3mFKgWSg63pSRIw6UaI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-h8jeSwtROxyT60JLxEWEOQ-1; Mon,
 15 Sep 2025 16:51:53 -0400
X-MC-Unique: h8jeSwtROxyT60JLxEWEOQ-1
X-Mimecast-MFC-AGG-ID: h8jeSwtROxyT60JLxEWEOQ_1757969512
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF0AD1808880;
	Mon, 15 Sep 2025 20:51:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.155])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18AEB300021A;
	Mon, 15 Sep 2025 20:51:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
Subject: SHAKE256 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2767538.1757969506.1@warthog.procyon.org.uk>
Date: Mon, 15 Sep 2025 21:51:46 +0100
Message-ID: <2767539.1757969506@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Eric,

I don't suppose you happen to have SHAKE128 and SHAKE256 support lurking up
your sleeve for lib/crypto/sha512.c?

David


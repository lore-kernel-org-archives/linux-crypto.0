Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEB933A03D
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763392937; cv=none; b=LvUhZJP/oyNBqM7vHLev51yyiYBkIpnSvfPVyrd/m49AtdsYnc5oBLHJIKLFIeD/okvLBfv2naHV/e//t6X0kqWwyUcOdn49Yz18scc31seDtdPRHtide0TLOfZG6xBoFGCLlloEVHyO7HaBBAmoaYJH7zmBxSj+W9hZczqSLTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763392937; c=relaxed/simple;
	bh=17vtla297a9y+1Z6Y3w4eo3SL8PGOpth1pv2rT/+2Zo=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EeazJWeNWzb5Vp1b/++kwfNk4hKCRDCK9vEWNu85so6iz+aSMH3mJT7MSM0kUPdywH4i3UH9KGAVNAHVNwLOD7AtZlzUbTZ6qNVvAAZS1nQQP607DdhdeJ613dDF90JJ/P78gvFEFrtgbtrPxW4pnlZfhDcKRACfZ09qEk2lw1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L01FA8m/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L01FA8m/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763392935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BZ1ONyCE354z0Ub5HWDjuKQGFL0uiuBnMmxcCrDGL2Y=;
	b=L01FA8m/2CoJ52yjrwXDLv2maXjzbe+T3ACJhsZizH3v23BfCHPI1Vgu0TnJJhpuHPBTAy
	1qDug45kPRynDRnjxLJFQYdVUYDYMvBs2bK9fwrlUucmyN1DDXWfCTwya0YQR/lj4SA959
	lgF0ftoA8Gjn3C91Ic2B8EGQM22Cn6s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-uHj_4_8FPvCeRtmybsGj5g-1; Mon,
 17 Nov 2025 10:22:10 -0500
X-MC-Unique: uHj_4_8FPvCeRtmybsGj5g-1
X-Mimecast-MFC-AGG-ID: uHj_4_8FPvCeRtmybsGj5g_1763392928
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79037195608E;
	Mon, 17 Nov 2025 15:22:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 176B719560A7;
	Mon, 17 Nov 2025 15:22:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251117145606.2155773-1-dhowells@redhat.com>
References: <20251117145606.2155773-1-dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
    Mark Brown <broonie@kernel.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
    Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
    keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
    linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Pick up keys-pqc branch for linux-next?
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2157242.1763392923.1@warthog.procyon.org.uk>
Date: Mon, 17 Nov 2025 15:22:03 +0000
Message-ID: <2157243.1763392923@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Stephen,

Can you pick up my keys-pqc branch for linux-next please?  It can be found at:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/
	keys-pqc

Note that it's based on Eric Bigger's libcrypto/lbcrypto-next branch which I
believe you already have in order to get SHA-3/SHAKE support.

Thanks,
David


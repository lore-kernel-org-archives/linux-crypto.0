Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8F13D0BE7
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 06:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780985953; cv=none; b=cTD3BeMNpejUoMJZJO0oJOP6c8dboDB2J6lZoA2y3s/5pzKYW9lAEuxWUx/8hPQrPjlkJFmrYF6U/b77wAls7o9zWo6w7E71k/ymkZWyx+cNvA6F0tfbUoEWQpZsSRbVGoq0Xt+Ig55F6KFmF4+f8nSXZ2dXBBDjcg+SaFAts7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780985953; c=relaxed/simple;
	bh=m/8588E549Sx7YLNT/Ae9prWJC1TGYAlx64orwC3YfE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=nlZUQifzU/ZeLCB+pE4XEHQAV8j68Fyz67gG2R0rtbLZA+p6/YCjNsS6XB2naMMOveTZed74i2mZHH/qVN84oB5pIfxL/0PGwWkWVu9oS5XdkplFMsSRMd1gbe5ssxCKrT7/IU3F+SLvyYYBntPW8iyYa4myOgxDxcVvld8tL1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpKhqYPs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpKhqYPs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780985951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+LsXj9LcLVuo5P5r2vxoLuNRU5yNtKTpqcp3OxS8uYM=;
	b=EpKhqYPsrW8bqjWBWrpfa/6EcLQrVo80gGkPG3lne8U3zaRqdadOM/d+r6N4e70q7DifGQ
	O+eE97w8DQrLuSTbUkvBd/8uAPMTPWqii4xm7nbTy+bhVOZVvZkMcT/KHeBIWUBDIcDVWr
	IwW6Xi0UNKpHhfqvQ1PHJNrLraEes/g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378-arpG9RpbNhSZ3v-1X6q95Q-1; Tue,
 09 Jun 2026 02:19:06 -0400
X-MC-Unique: arpG9RpbNhSZ3v-1X6q95Q-1
X-Mimecast-MFC-AGG-ID: arpG9RpbNhSZ3v-1X6q95Q_1780985944
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3418E19560B4;
	Tue,  9 Jun 2026 06:19:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F4D51800598;
	Tue,  9 Jun 2026 06:19:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260608173921.GA434331@google.com>
References: <20260608173921.GA434331@google.com> <20260522050740.84561-1-ebiggers@kernel.org> <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com> <20260603050557.GB18149@sol>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, Marc Dionne <marc.c.dionne@gmail.com>,
    netdev@vger.kernel.org, linux-afs@lists.infradead.org,
    linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
    "David S . Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <764076.1780985938.1@warthog.procyon.org.uk>
Date: Tue, 09 Jun 2026 07:18:58 +0100
Message-ID: <764077.1780985938@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Eric Biggers <ebiggers@kernel.org> wrote:

> > If there's no more feedback, could this be applied to net-next?
> 
> Any update on this?

It's fine by me, but I'm not sure what I need to do with it - shouldn't it
already be in the netdev queue, or do I need to post it?

David

